"""Ramanas Park in Pearl's Pal Park (notes/RAMANAS_PARK.md, data/ramanas_park.json, b2tools/ramanas.py).

    build_rom.py ... scripts pearl_text sinnoh_story ramanas_park pearl_starters ...
    python3 b2tools/patches/ramanas_park.py --text     write data/text_overrides/ramanas_park.json (the items' text)

List it after sinnoh_story (Pal Park's entity file must be there to add to; a quick non-clean rerun replaces what it added) and after sinnoh_music (the looks' music),
before the patches that size tables from the zone headers (season_weather, town_map, sinnoh_pokedex) and after the
ITCM users it shares ITCM with (it appends a table). Needs the zone table grown past 615 (sinnoh_world, notes/
ZONE_TABLE.md) and the Strange Space look's room installed (MAP_TURNBACK_CAVE_GIRATINA_ROOM on zone 624).

apply(files):
- the rooms' zones (data "rooms" of the version: 652-660, the Diamond rooms 661-662): each a copy of its look's zone
  header (the Pearl room it borrows: matrix, area, camera, lights, music, weather, battle background) with the rooms'
  shared script file and text file (b2tools/ramanas.py writes them), no wild Pokémon, Pal Park's place name and
  parent (no banner, met location "Pal Park"), no Escape Rope / Fly (the visit's state lives in the gate);
- each room's events (a new a/1/2/6 entry): the look's warps (sinnoh_events.Planner, Pearl's own) all leading back to
  the room's entrance in the park, the pedestal (sign events on the look's pedestal tiles, read facing north), the
  room's Pokémon sprites on the pedestal (map-local hide flags, set by the zone init), the map scripts (zone init;
  frame table: the Catching Show running -> back out; the room's name on arrival);
- Pal Park's entrances: one warp per room after the park's own (bump warp into the door tile, walking north);
- the items: slates (Key Items, Black 2's Light Stone record: price 0, can't be tossed) and the two shards (Items,
  Black 2's Red Shard record, price 0); their pockets, icons and "can't be held" are the decomp's tables
  (src/system/myitem_savedata.c, pml_item.c: PEARLB2_RAMANAS_* in include/pearlb2.h).
TEST ONLY: RAMANAS_TEST_SPRITES=<room id> shows every room's Pokémon sprites at once in that room's floor (a grid in
front of the dais), to look at their sizes without a battle each (never in a release build).
apply_code(code): the BDSP movesets and the no-capture flag per room Pokémon, a table in ITCM at gPearlB2Ramanas
  (src/pearlb2/ramanas_itcm.c); without that symbol in the decomp, the Pokémon keep Black 2's level-up moves.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio, zoneheaders  # noqa: E402
from zones import parse_entities, build_entities  # noqa: E402

TEXT_JSON = os.path.join(ROOT, 'data', 'text_overrides', 'ramanas_park.json')
ITEMS = 24                                  # a/0/2/4 item data
SLATE_TEMPLATE, SHARD_TEMPLATE = 'ITEM_LIGHT_STONE', 'ITEM_RED_SHARD'
PRICE, SORT_INDEX = 0, 0xF                  # a/0/2/4 record: u16 price (x10), u8 sort index (pearl_tms)
EMPTY = struct.pack('<I', 4) + bytes(4) + bytes(4)   # Black 2's empty entity file
NO_ENCOUNTERS = 0x1FFF
ESCAPE_ROPE, FLY_FROM = 1 << 12, 1 << 13    # zone header flags (zonedata.c ZoneHeader: enableEscapeRope, enableFlyFrom)
BUMP, WALK_NORTH = 4, 2                     # warp type 4 (walk into a solid tile), dir 2 (walking north): sinnoh_events
SIGN_NORTH = 0                              # a sign event read facing north (pearl_events SIGN_DIR)
SPRITE_DIR = 1                              # the sprites face south, toward the player


_FLOOR = {}


def _on_floor(files, matrix, w):
    """A warp's height where Black 2 stands the player on its tile, from the built map (ov012 CheckWarpPositionMatch
    fires a warp only within 2 units of its record). Found in the test (2026-10-26): Turnback Cave's Giratina room
    stands the player at 56 on its south door mat (pearl_chunk.floor_mats gave the mat the sloped plane of the tile
    north of it), the warp's record says 40, and the room had no way out. The record is kept when it is within 2."""
    import pearl_chunk
    if not _FLOOR:
        _FLOOR.update(chunks=narcio.load(files, 8), mats=narcio.load(files, 9), tables=pearl_chunk.tables())
    m = _FLOOR['mats'][matrix]
    mw = struct.unpack_from('<H', m, 4)[0]
    tx, tz = w['x'] // 16, w['z'] // 16
    c = struct.unpack_from('<I', m, 8 + 4 * ((tz // 32) * mw + tx // 32))[0]
    y0 = (w['y'] ^ 0x8000) - 0x8000
    if c == 0xFFFFFFFF:
        return w['y']
    slopes, offsets = _FLOOR['tables']
    lx, lz = tx % 32, tz % 32
    ys = []
    for t in pearl_chunk.terrains(_FLOOR['chunks'][c])[1]:   # (a GC chunk's two levels: the one nearest the record)
        a, b = struct.unpack_from('<HH', t, 4 + 8 * (lz * 32 + lx))
        ys.append(pearl_chunk.plane_height(slopes, offsets, a >> 2, b, lx * 16 - 256 + 8, lz * 16 - 256 + 8))
    y = min(ys, key=lambda v: abs(v - y0))
    return w['y'] if abs(y - y0) <= 2 else round(y) & 0xFFFF


def text_lines():
    """data/text_overrides/ramanas_park.json: the slates' and shards' names and Bag descriptions (sinnoh_names packs
    it), descriptions wrapped to the Bag's window as pearl_tms does."""
    import ramanas as rp, pearl_tms
    d = rp.load()
    files = pearl_tms.item_files()
    out = {'_doc': 'Ramanas Park\'s items (b2tools/patches/ramanas_park.py --text writes this file from '
                   'data/ramanas_park.json): the slates (BDSP\'s names; Stratospheric shortened to the Bag\'s 96 px) '
                   'and the Mysterious Shards S/L, with BDSP\'s descriptions (Serebii\'s itemdex), Pal Park for '
                   'Ramanas Park. Every version\'s slates are here: a Diamond version only changes which rooms exist.'}
    for r in d['rooms']:                        # (the unused ids' data files: name, name_with_article as fairy.json)
        out[f'res/items/{files[r["slate"]["item"]]}/data.json'] = {
            'name': r['slate']['name'], 'name_with_article': '{bd01}a {ff00:255}' + r['slate']['name'],
            'name_plural': r['slate']['name'] + 's',
            'description': pearl_tms.wrap(rp.fill(d['slate_description'], room=r['name']))}
    for s in d['shards'].values():
        out[f'res/items/{files[s["item"]]}/data.json'] = {
            'name': s['name'], 'name_with_article': '{bd01}' + s['article'] + ' {ff00:255}' + s['name'],
            'name_plural': s['plural'],
            'description': pearl_tms.wrap(s['description'])}
    return out


def check_text():
    want = json.dumps(text_lines(), ensure_ascii=False, indent=1) + '\n'
    assert os.path.exists(TEXT_JSON) and open(TEXT_JSON, encoding='utf-8').read() == want, \
        'data/text_overrides/ramanas_park.json is not current: python3 b2tools/patches/ramanas_park.py --text'


def _room_tiles(look):
    return [tuple(look['pedestal'])] + [tuple(t) for t in look.get('pedestal_more', [])]


def apply(files):
    import ramanas as rp, pearl_story, pearl_events, sinnoh_events
    check_text()
    d = rp.load()
    ver = rp.version(d)
    rs = rp.rooms(ver)
    pd = pearl_story.PearlData()
    heights = pearl_events.Heights()
    planner = sinnoh_events.Planner()
    headers, hentries = zoneheaders.load(files)
    ents = narcio.load(files, 126)
    park = pd.by_name[d['pal_park']]
    park_b2 = pd.b2_zone[park['id']]
    state = rp.pearl_var(d['show_var'])
    out = []

    # Pal Park's entrances: after the park's own warps (their indices stay)
    hp = headers[park_b2]
    pe, _ = parse_entities(ents[hp['entities']])
    first = len(planner.warps(park['id'])[0])                # Pearl's own (sinnoh_events); a rerun replaces ours
    assert len(pe['warps']) in (first, first + len(rs)), f'Pal Park has {len(pe["warps"])} warps, expected {first}'
    pe['warps'] = pe['warps'][:first]
    for r in rs:
        x, z = r['entrance']['x'], r['entrance']['z']
        y = heights.at(park, x, z + 1)
        assert y is not None and not heights.solid(park, x, z + 1), f'{r["id"]}: no walkable tile in front of ({x}, {z})'
        arrive = d['looks'][r['look']]['arrive_warp']          # the look's door the player comes in by
        pe['warps'].append(dict(dest_zone=r['zone'], dest_warp=arrive, dir=WALK_NORTH, type=BUMP, rail=0, x=x * 16 + 8,
                                y=y & 0xFFFF, z=z * 16 + 8, w=1, h=1, unk=0))
    ents[hp['entities']] = build_entities(pe, ents[hp['entities']])
    out.append(f'Pal Park (zone {park_b2}): warps {first}-{first + len(rs) - 1} to the rooms')

    # the rooms
    while len(headers) <= max(r['zone'] for r in rs):
        raise SystemExit(f'ramanas_park: the zone file has {len(headers)} headers; zones up to '
                         f'{max(r["zone"] for r in rs)} are needed (sinnoh_world grows it: notes/ZONE_TABLE.md)')
    for i, r in enumerate(rs):
        look = d['looks'][r['look']]
        lz = pd.by_name[look['pearl_map']]
        assert lz['id'] in pd.b2_zone, f'{r["id"]}: its look {look["pearl_map"]} is not installed (allocate_sinnoh)'
        lb2 = pd.b2_zone[lz['id']]
        h = dict(headers[lb2])
        h.update(scripts=d['files']['script'], text=d['files']['text'], encounters=NO_ENCOUNTERS, enc_slot=0,
                 init_scripts=hp['init_scripts'], parent=hp['parent'], place=hp['place'],
                 place_display=hp['place_display'], flags=h['flags'] & ~(ESCAPE_ROPE | FLY_FROM))
        base = 1 + rp.ENTRIES_PER_ROOM * i                   # ramanas_park.write_rooms: pedestal, init, name, closed
        warps, _ = planner.warps(lz['id'])
        warps = [dict(w, dest_zone=park_b2, dest_warp=first + i, y=_on_floor(files, h['matrix'], w)) for w in warps]
        signs = []
        for tx, tz in _room_tiles(look):
            y = heights.sign_y(lz, tx, tz, SIGN_NORTH)
            signs.append(dict(script=base, cond=0, dir=SIGN_NORTH, rail=0, x=tx, z=tz, y=y if y is not None else 0))
        sx, sz = look['sprite']
        sy = heights.at(lz, *look['stand'])           # the height the player reads the pedestal from (the dais top):
        # the sprite's own tile is the pedestal, a solid tile whose converted height is the floor under it (found in
        # the first test: Registeel stood inside the dais, unseen)
        npcs = [dict(uid=k + 1, model=m['sprite'], move=0, evtype=0, flag=rp.SPRITE_FLAG + k, script=0,
                     dir=SPRITE_DIR, p0=0, p1=0, p2=0, areaw=0, areah=0, rail=0, x=sx, z=sz, y=(sy or 0) * 0x1000)
                for k, m in enumerate(r['mons'])]
        if os.environ.get('RAMANAS_TEST_SPRITES') == r['id']:   # TEST ONLY: every room's Pokémon at once, shown
            allm = [m for q in rs for m in q['mons']]
            spots = [(x, 17) for x in range(6, 17, 2)] + [(x, 20) for x in range(4, 19, 2)]   # the floor's two rows
            npcs = [dict(uid=k + 1, model=m['sprite'], move=0, evtype=0, flag=0, script=0, dir=SPRITE_DIR, p0=0,
                         p1=0, p2=0, areaw=0, areah=0, rail=0, x=spots[k][0], z=spots[k][1],
                         y=(heights.at(lz, *spots[k]) or 0) * 0x1000)
                    for k, m in enumerate(allm)]
        table = (struct.pack('<HI', 2, base + 1) + struct.pack('<HI', 1, 2) + struct.pack('<H', 0)
                 + struct.pack('<HHH', state, d['show_values']['running'], base + 3)
                 + struct.pack('<HHH', rp.NAME_WORK, 0, base + 2) + struct.pack('<H', 0))
        while len(table) % 4:
            table += b'\0'
        e = dict(signs=signs, npcs=npcs, warps=warps, triggers=[])
        if headers[r['zone']]['scripts'] == d['files']['script'] and headers[r['zone']]['entities'] > 615:
            h['entities'] = headers[r['zone']]['entities']   # a rerun (a quick build): its own entry again
            ents[h['entities']] = build_entities(e, EMPTY, init=table)
        else:
            h['entities'] = len(ents)
            ents.append(build_entities(e, EMPTY, init=table))
        headers[r['zone']] = h
        out.append(f'{r["name"]} zone {r["zone"]} ({r["look"]}: {look["pearl_map"]} zone {lb2})')

    # the doorways' opening (b2tools/ramanas.py door_opening): sinnoh_rooms builds Pal Park's pack with it; done again
    # here on the pack's texture set (idempotent), so a quick non-clean build takes a change of it too
    w = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    area = w['rooms']['areas'][str(park['area'])]
    tarc = 174 if area['exterior'] else 175                    # sinnoh_rooms: the building packs' texture sets
    texsets = narcio.load(files, tarc)
    before = texsets[area['b2_pack']]
    for mid in rp.res_ids():
        texsets[area['b2_pack']] = rp.door_opening(texsets[area['b2_pack']], mid)
    if texsets[area['b2_pack']] != before:
        narcio.save(files, tarc, texsets)
    out.append(f'doorway openings in pack {area["b2_pack"]}{" (painted now)" if texsets[area["b2_pack"]] != before else ""}')

    # the items
    import pearl_tms
    items = narcio.load(files, ITEMS)
    import tm_audit
    vanilla = narcio.load(tm_audit.VANILLA_FILES, ITEMS)
    slate_t = vanilla[rp.const('items', SLATE_TEMPLATE)]
    shard_t = vanilla[rp.const('items', SHARD_TEMPLATE)]
    for k, r in enumerate(d['rooms']):                       # every version's slates (ids fixed in the data)
        rec = bytearray(slate_t)
        struct.pack_into('<H', rec, PRICE, 0)
        rec[SORT_INDEX] = k
        assert items[r['slate']['item']] in (vanilla[r['slate']['item']], bytes(rec)), \
            f'item {r["slate"]["item"]}: changed by another patch'
        items[r['slate']['item']] = bytes(rec)
    for k, s in enumerate(d['shards'].values()):
        rec = bytearray(shard_t)
        struct.pack_into('<H', rec, PRICE, 0)
        assert items[s['item']] in (vanilla[s['item']], bytes(rec)), f'item {s["item"]}: changed by another patch'
        items[s['item']] = bytes(rec)
    narcio.save(files, ITEMS, items)
    out.append(f'items {min(r["slate"]["item"] for r in d["rooms"])}-{max(s["item"] for s in d["shards"].values())}')

    narcio.save(files, 126, ents)
    zoneheaders.save(files, headers, hentries)
    return f'ramanas_park ({ver}): ' + '; '.join(out)


def table_blob():
    """gPearlB2Ramanas: u32 count, then per room Pokémon {u16 zone, species, moves[4], flags (1: no capture), form}
    (src/pearlb2/ramanas_itcm.c PearlB2RamanasMon)."""
    import ramanas as rp
    recs = []
    for r in rp.rooms():
        for m in r['mons']:
            recs.append(struct.pack('<8H', r['zone'], m['species'], *m['moves'], 1 if m['no_capture'] else 0, m['form']))
    return struct.pack('<I', len(recs)) + b''.join(recs), len(recs)


def apply_code(code):
    import itcm, decomp, resident
    slot = decomp.symbol('gPearlB2Ramanas', code)
    if slot is None:
        return 'ramanas_park: no gPearlB2Ramanas in this decomp: Black 2\'s level-up moves, balls catch everything'
    info = {}
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    old = struct.unpack_from('<I', data, at)[0]
    if old:                                          # a quick non-clean build: the table is there, rewrite it in place
        blob, n = table_blob()
        assert struct.unpack('<I', resident.read(code, old, 4))[0] == n, \
            'gPearlB2Ramanas: the installed table has another size'
        resident.write(code, old, blob)
        return f'ramanas_park: {n} Pokémon\'s movesets rewritten in place (gPearlB2Ramanas {slot:#x})'

    def build(base):
        blob, n = table_blob()
        info['n'] = n
        return blob, {}
    base, end, _ = resident.install(code, build)  # its table in the resident section (b2tools/resident.py)
    data = bytearray(open(path, 'rb').read())
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path):
        os.unlink(path)
    open(path + '.tmp', 'wb').write(data)
    os.replace(path + '.tmp', path)
    return f'ramanas_park: {info["n"]} Pokémon\'s movesets (gPearlB2Ramanas {slot:#x}, {end - base} B)'


if __name__ == '__main__':
    if '--text' in sys.argv:
        open(TEXT_JSON, 'w', encoding='utf-8').write(json.dumps(text_lines(), ensure_ascii=False, indent=1) + '\n')
        print('wrote', os.path.relpath(TEXT_JSON, ROOT))
    else:
        print(__doc__)
