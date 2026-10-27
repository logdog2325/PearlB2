"""Sinnoh's place names (the banner when entering a place, the town map, the trainer card) and every Sinnoh zone's
place. Runs after sinnoh_world and sinnoh_rooms.

- Names: Pearl's map sections (pokediamond files/msgdata/msg/narc_0382.gmm, English, 112 rows, row = map section)
  -> Black 2's places (system text 109 = TEXT_BANK_PLACE_NAMES, built from res/field/places/*.json "name" in the
  order of generated/places.txt). PLACE_LINES picks the layout:
  - 'high' (default, 2026-10-18, agreed with the HoennB2 session, notes/LINK.md): Pearl's sections 1-111 go on NEW
    lines 154-264 (line = section + 153; added after Black 2's 154 lines as PLACE_SINNOH_NNN), so a Pokémon's met
    location never collides with the Hoenn games' lines. The Hoenn games' names (data/hoenn_places.json, a snapshot
    of HoennB2's) go on their own lines 4-112, so a Pokémon traded from Sapphire/Ruby/Emerald NDS shows its real
    met location here. The other lines keep Black 2's names. To check in game: a met location above 153 (summary,
    Trainer Memo) and the place banner.
  - 'low' (before): line = section + 3 (lines 4-114, over Black 2's Unova names).
- Met locations above 153 (apply_code; found in game 2026-10-18: a Piplup met in Twinleaf, location 154, showed
  "Faraway place"): MetLocation_GetNameIndex (arm9 0x02035fac, pokebw2 src/system/pml_met_data.c) returns line 2
  ("Faraway place") for every location from 154 to 30000. Its `cmp r0, #154; bcc` becomes `lsrs r3, r0, #9; beq`
  (locations 0-511 show their own line), and the place-name file is padded to 512 lines with "Faraway place"
  (Black 2's own text for an unknown place), so a location this game has no name for still reads as in Black 2.
  The Hoenn games need the same edit to show Sinnoh's names (notes/LINK.md).
- Packed with pokebw2's own text tools on a clone of its sources (pokebw2_mod; an unchanged clone packs a/0/0/2
  byte-identical to Black 2's, checked 2026-10-18).
- Other system text: data/text_overrides/*.json ({file: {label: text}} for res/text/system/<file>.txt) go into the
  same clone before packing, so every system-text change is one a/0/0/2 (rods.json: the Y menu's Old Rod / Good Rod,
  patches/pearl_rods.py; pearl_intro.json: the rival's default name Barry).
- Zone headers: place = the Pearl zone's map section + 3 (Pearl's "Mystery Zone", section 0, -> Black 2's 1);
  display style from a Black 2 template zone (town 427, route 437, building 441, any other room 324 Wellspring
  Cave), so the banner shows wherever Pearl shows its sign (not in buildings), when the place name changes.
- The banner itself showed for no Sinnoh place until the decomp's PlaceName_LoadMessage took lines past 153
  (pokebw2 pearlb2 field_place_name.c, 2026-10-26): it cancelled every line from 154 on.
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import zoneheaders  # noqa: E402
import pokebw2_mod  # noqa: E402

GMM = os.path.join(ROOT, 'external', 'pokediamond', 'files', 'msgdata', 'msg', 'narc_0382.gmm')
VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
PLACE_LINES = os.environ.get('PEARL_PLACE_LINES', 'high')
FIRST_LINE = 153 if PLACE_LINES == 'high' else 3   # line = map section + FIRST_LINE
B2_PLACES = 154                                   # Black 2's lines 0-153
PLACE_LINES_MAX = 512                             # the file is padded to this many lines (apply_code's bound)
MET_NAME_INDEX = 0x02035fac + 6                   # MetLocation_GetNameIndex: cmp r0, #0x9a; bcc (return location)
MET_NAME_OLD, MET_NAME_NEW = bytes.fromhex('9a281ad3'), bytes.fromhex('430a1ad0')   # -> lsrs r3, r0, #9; beq
STYLE_TEMPLATE = {'town': 427, 'route': 437, 'other': 437, 'room': 441, 'cave': 324}
# Pearl shows its place sign on arriving anywhere but in a building (pokediamond ov05_021E331C: not
# MapHeader_IsBuilding, map types 4/5), and on walking into another map section. Black 2 shows the banner on a zone
# change when the zone's display type allows it and the place name differs (ov036 field_place_name.c
# PlaceName_OnZoneChange, IsLocNameIdxChanged). So a room that is not a building (Pearl map type 1-3: caves, the
# lakes, Eterna Forest, Mt. Coronet's sides, the Great Marsh, Battle Park, ...) takes the style of Black 2's
# Wellspring Cave (324: shown), a building Floccesy's house's (441: none).
PEARL_BUILDING_TYPES = (4, 5)


def pearl_names():
    xml = open(GMM, encoding='utf-8').read()
    rows = re.findall(r'<row[^>]*>(.*?)</row>', xml, re.S)
    return [re.search(r'<language name="English">(.*?)</language>', r, re.S).group(1) for r in rows]


def _merge(data, new, where):
    """data.update(new), field by field into a dict value given as a dict (and element by element into a list given
    as a list of the same length: {"pokedex": {"entry": ..., "forms": [{"entry": ...}]}} changes only those fields)."""
    for k, v in new.items():
        if isinstance(v, dict) and isinstance(data.get(k), dict):
            assert set(v) <= set(data[k]), f'{where}: {k} has no field {sorted(set(v) - set(data[k]))}'
            _merge(data[k], v, f'{where}.{k}')
        elif isinstance(v, list) and isinstance(data.get(k), list) and v and all(isinstance(x, dict) for x in v):
            assert len(v) == len(data[k]), f'{where}: {k} has {len(data[k])} elements, not {len(v)}'
            for i, (a, b) in enumerate(zip(data[k], v)):
                _merge(a, b, f'{where}.{k}[{i}]')
        else:
            data[k] = v


def text_overrides(tree):
    """data/text_overrides/*.json -> the clone's res/text/system/<file>.txt (by label; every label must exist).
    A label written "+Label" is a NEW line, appended at the file's end (before its \\pad line) in the JSON's order,
    e.g. new moves' names after the 560 lines \\from{moves.name} makes (HoennB2's text.py appends past a file's end
    the same way). A key "res/<path>.json" instead of a file name merges its fields into that data file of the clone:
    the texts pokebw2 makes from its data through \\from{...} (an item's name, plural, description ...)."""
    d, done = os.path.join(ROOT, 'data', 'text_overrides'), 0
    for name in sorted(os.listdir(d)) if os.path.isdir(d) else []:
        if not name.endswith('.json'): continue
        for f, lines in json.load(open(os.path.join(d, name), encoding='utf-8')).items():
            if f.startswith('_'): continue
            if f.startswith('res/'):
                path = os.path.join(tree, f)
                data = json.load(open(path, encoding='utf-8'))
                assert set(lines) <= set(data), f'{name}: {f} has no field {sorted(set(lines) - set(data))}'
                _merge(data, lines, f'{name}: {f}')
                json.dump(data, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=4)
                done += len(lines)
                continue
            path = os.path.join(tree, 'res', 'text', 'system', f + '.txt')
            text = open(path, encoding='utf-8').read().split('\n')
            end = next((i for i in range(len(text) - 1, -1, -1) if text[i].startswith('\\pad{')), len(text) - 1)
            for label, value in lines.items():
                new = label.startswith('+')
                at = [i for i, l in enumerate(text) if l.split('=', 1)[0].strip() == label.lstrip('+')]   # 'X =' too
                assert len(at) == (0 if new else 1), f'{name}: label {label} found {len(at)} times in {f}.txt'
                if new:
                    text.insert(end, f'{label[1:]} = {value}'); end += 1
                else:
                    text[at[0]] = f'{label} = {value}'
                done += 1
            open(path, 'w', encoding='utf-8').write('\n'.join(text))
    return done


def apply(files):
    names = pearl_names()
    tree = pokebw2_mod.make_tree('names')
    plist = os.path.join(tree, 'generated', 'places.txt')
    places = [l.split('=')[0].strip() for l in open(plist) if l.startswith('PLACE_')]
    assert len(places) == B2_PLACES, f'places.txt has {len(places)} places, expected Black 2\'s {B2_PLACES}'
    pdir = os.path.join(tree, 'res', 'field', 'places')

    def put(line, name):
        if line == len(places):                      # a new line after the last one
            places.append(f'PLACE_SINNOH_{line - FIRST_LINE:03d}')
            open(plist, 'a').write(places[-1] + '\n')
            data = {'$schema': 'place.schema.json'}
        else:
            data = json.load(open(os.path.join(pdir, places[line][6:].lower() + '.json'), encoding='utf-8'))
        data['name'] = name
        json.dump(data, open(os.path.join(pdir, places[line][6:].lower() + '.json'), 'w', encoding='utf-8'),
                  ensure_ascii=False, indent=4)
    changed = 0
    if PLACE_LINES == 'high':
        for line, name in json.load(open(os.path.join(ROOT, 'data', 'hoenn_places.json')))['lines'].items():
            put(int(line), name)
    for section in range(1, len(names)):
        put(section + FIRST_LINE, names[section])
        changed += 1
    if PLACE_LINES == 'high':
        faraway = json.load(open(os.path.join(pdir, places[2][6:].lower() + '.json'), encoding='utf-8'))['name']
        while len(places) < PLACE_LINES_MAX:
            line = len(places)
            places.append(f'PLACE_UNUSED_{line:03d}')
            open(plist, 'a').write(places[-1] + '\n')
            json.dump({'$schema': 'place.schema.json', 'name': faraway},
                      open(os.path.join(pdir, places[-1][6:].lower() + '.json'), 'w', encoding='utf-8'),
                      ensure_ascii=False, indent=4)
    overrides = text_overrides(tree)
    text = pokebw2_mod.pack_text(tree, 'system')['a/0/0/2']
    out = os.path.join(files, 'a', '0', '0', '2')
    if os.path.islink(out): os.unlink(out)
    open(out + '.tmp', 'wb').write(text); os.replace(out + '.tmp', out)

    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    vanilla, _ = zoneheaders.load(VANILLA)
    headers, entries = zoneheaders.load(files)
    def room_kind(pid):
        return 'room' if zones[int(pid)]['map_type'] in PEARL_BUILDING_TYPES else 'cave'
    for group, kind_of in ((world['zones'], lambda pid, z: z['kind']),
                           (world['rooms']['zones'], lambda pid, z: room_kind(pid))):
        for pid, z in group.items():
            sec = zones[int(pid)]['mapsec']
            hd = headers[z['b2_zone']]
            hd['place'] = sec + FIRST_LINE if sec else 1
            hd['place_display'] = vanilla[STYLE_TEMPLATE[kind_of(pid, z)]]['place_display']
    zoneheaders.save(files, headers, entries)
    return (f'sinnoh_names: {changed} place names (lines {1 + FIRST_LINE}-{len(names) - 1 + FIRST_LINE}, {PLACE_LINES}), '
            f'{overrides} other system lines; zones placed')


def apply_code(code):
    """Met locations 154-511 show their own place-name line (see the top)."""
    if PLACE_LINES != 'high':
        return 'met locations: Black 2\'s bound (154) kept'
    p = os.path.join(code, 'arm9.bin')
    d = bytearray(open(p, 'rb').read())
    o = MET_NAME_INDEX - 0x02004000
    assert d[o:o + 4] in (MET_NAME_OLD, MET_NAME_NEW), f'MetLocation_GetNameIndex: unexpected {d[o:o + 4].hex()}'
    d[o:o + 4] = MET_NAME_NEW
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)
    return f'met locations 0-{PLACE_LINES_MAX - 1} show their own line (MetLocation_GetNameIndex {MET_NAME_INDEX:#x})'


def line_list():
    """data/sinnoh_places.json: Pearl NDS's Sinnoh lines, for the Hoenn games (notes/LINK.md)."""
    names = pearl_names()
    out = {'_doc': "Pearl NDS's Sinnoh place names on system text 109 (PLACE_LINES 'high': line = Pearl map section + "
                   "153), for the Hoenn games to append after Black 2's 154 lines, so a Pokemon traded from Pearl NDS "
                   "shows its met location (notes/LINK.md). Regenerate: python3 b2tools/patches/sinnoh_names.py "
                   "--line-list",
           'lines': {str(s + FIRST_LINE): names[s] for s in range(1, len(names))}}
    path = os.path.join(ROOT, 'data', 'sinnoh_places.json')
    json.dump(out, open(path, 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
    return f'{len(out["lines"])} lines -> {path}'


if __name__ == '__main__' and sys.argv[1:] == ['--line-list']:
    print(line_list())
