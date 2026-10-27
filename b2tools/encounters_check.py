"""Read back a build's wild Pokémon and compare every Sinnoh zone with Pearl's own tables (notes/ENCOUNTERS.md).

    python3 encounters_check.py [FILES_DIR]       default: $PEARL_BUILD_DIR/files, else work/rom/files

Checks, from the built files only (a/1/2/7 and the zone headers a/0/1/2), against work/pearl/encounters/*.json and
work/pearl/zones.json, with its own reading of Pearl's data (it does not use patches/sinnoh_encounters.py's code; it
only reads its ROD_LAYOUT setting):
- Black 2's own 135 tables are unchanged (byte-equal to pokebw2's build).
- Each Sinnoh zone (data/sinnoh_world.json "zones", plus the "rooms" whose header is on their own Black 2 matrix)
  names table 135 + its Pearl zone's encounter file, or 0x1FFF when Pearl has none.
- Each table: grass = Pearl's 12 land slots (slots 2-3 = the day species), species, form (Shellos/Gastrodon east sea,
  Unown letters) and level (min = max = Pearl's); dark grass = grass; shaking grass empty; surf = Pearl's surf
  (species, min, max); rippling surf = surf when rippling spots are on; fishing / rippling fishing = the rods of
  ROD_LAYOUT; rate bytes = the documented rules (grass/surf), Good/Super Rod rate - 1 (fishing).
Prints every difference; exit status 1 if there is any.
"""
import importlib.util, json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import narcio, zoneheaders  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
PEARL = os.path.join(ROOT, 'work', 'pearl')
B2_TABLES, NONE = 135, 0x1FFF
# documented in notes/ENCOUNTERS.md: Pearl grass/surf rate -> Black 2 rule
RULE = {10: 11, 15: 11, 20: 3, 25: 4, 30: 4, 35: 4}
GROUPS = [('grass', 12), ('dark_grass', 12), ('shaking_grass', 12), ('surf', 5), ('rippling_surf', 5),
          ('fishing', 5), ('rippling_fishing', 5)]
UNOWN = {2: [5], 3: [17], 4: [8], 5: [13], 6: [4], 7: [3], 8: [26, 27]}


def pearl_species():
    """Pearl's species names -> national number (pokediamond's constants: the same numbers in Black 2)."""
    text = open(os.path.join(ROOT, 'external', 'pokediamond', 'include', 'constants', 'species.h')).read()
    return {m.group(1): int(m.group(2), 0) for m in re.finditer(r'#define\s+(SPECIES_\w+)\s+(0x[0-9a-fA-F]+|\d+)', text)}


def rod_layout():
    spec = importlib.util.spec_from_file_location('se', os.path.join(HERE, 'patches', 'sinnoh_encounters.py'))
    mod = importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
    return mod.ROD_LAYOUT


def parse(table):
    rates = dict(zip([g for g, _ in GROUPS], table[:7]))
    out, p = {}, 8
    for g, n in GROUPS:
        slots = [struct.unpack_from('<HBB', table, p + 4 * i) for i in range(n)]
        out[g] = [(sf & 0x7FF, sf >> 11, lo, hi) for sf, lo, hi in slots]
        p += 4 * n
    return rates, out, table[7]


def expected(enc, sp, layout, period='day', rod_table=False):
    """{group: (rate, [(species, form, min, max)] * n)} from Pearl's file for a time of day, read here
    independently (Pearl's base land table is the morning one; slots 2-3 take 'day' / 'night'). rod_table: table 3
    of the 'pearl3' layout (Old Rod = fishing, Good Rod = rippling fishing)."""
    def form(name, k):
        if name == 'SPECIES_SHELLOS': return 1 if enc['rate_form0'] else 0
        if name == 'SPECIES_GASTRODON': return 1 if enc['rate_form1'] else 0
        if name == 'SPECIES_UNOWN' and enc['unown_table']:
            f = UNOWN.get(enc['unown_table'])
            return 31 if f is None else f[k % len(f)]
        return 0
    def rows(items):
        out, k = [], 0
        for name, lo, hi in items:
            out.append((sp[name], form(name, k), lo, hi))
            k += name == 'SPECIES_UNOWN'
        return out
    empty12, empty5 = [(0, 0, 0, 0)] * 12, [(0, 0, 0, 0)] * 5
    grass = empty12
    if enc['land_rate']:
        names = [s['species'] for s in enc['land_encounters']]
        for i in (2, 3):
            if period != 'morning' and enc[period][i - 2] != 'SPECIES_NONE':
                names[i] = enc[period][i - 2]
        grass = rows([(nm, s['level'], s['level']) for nm, s in zip(names, enc['land_encounters'])])
    water = lambda key: rows([(s['species'], s['level_min'], s['level_max']) for s in enc[key]]) \
        if enc[key.replace('_encounters', '_rate')] else empty5
    surf, good, sup = water('surf_encounters'), water('good_rod_encounters'), water('super_rod_encounters')
    old = water('old_rod_encounters')
    g_rule, s_rule = RULE.get(enc['land_rate'], 0), RULE.get(enc['surf_rate'], 0)
    rip_spots = True
    if layout == 'pearl3' and rod_table:
        fish, fish_rate = old, max(enc['old_rod_rate'] - 1, 0)
        rip, rip_rate, rip_spots = good, max(enc['good_rod_rate'] - 1, 0), False
    elif layout == 'pearl3':
        fish, fish_rate, rip, rip_rate = sup, max(enc['super_rod_rate'] - 1, 0), empty5, 0
    elif layout == 'good+super':
        fish, fish_rate, rip = good, max(enc['good_rod_rate'] - 1, 0), sup
        rip_rate = 1 if enc['super_rod_rate'] else 0
    elif layout == 'good':
        fish, fish_rate, rip, rip_rate = good, max(enc['good_rod_rate'] - 1, 0), empty5, 0
    else:  # 'rods'
        fish, fish_rate, rip, rip_rate = sup, max(enc['super_rod_rate'] - 1, 0), good, 0
    rip_on = bool(rip_spots and rip_rate and enc['surf_rate'])
    return {'grass': (g_rule, grass), 'dark_grass': (g_rule, grass), 'shaking_grass': (0, empty12),
            'surf': (s_rule, surf), 'rippling_surf': (1 if rip_on else 0, surf if rip_on else empty5),
            'fishing': (fish_rate, fish), 'rippling_fishing': (rip_rate, rip)}


def main():
    files = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.environ.get('PEARL_BUILD_DIR') or
                                                                os.path.join(ROOT, 'work', 'rom'), 'files')
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    pzones = json.load(open(os.path.join(PEARL, 'zones.json')))
    sp, names = pearl_species(), {}
    for k, v in pearl_species().items(): names.setdefault(v, k[8:].title())
    layout = rod_layout()
    built, vanilla = narcio.load(files, 127), narcio.load(VANILLA, 127)
    headers, _ = zoneheaders.load(files)
    diffs = []
    if built[:B2_TABLES] != vanilla[:B2_TABLES]:
        diffs.append("Black 2's own tables 0-134 changed: " +
                     ', '.join(str(i) for i in range(B2_TABLES) if built[i] != vanilla[i])[:200])
    zones = [(int(k), v) for k, v in world['zones'].items()]
    rooms, skipped = world.get('rooms', {}), 0
    for k, v in rooms.get('zones', {}).items():
        mat = rooms.get('matrices', {}).get(str(v.get('pearl_matrix')), {}).get('b2_matrix')
        if mat is not None and headers[v['b2_zone']]['matrix'] == mat:
            zones.append((int(k), v))
        else:
            skipped += 1
    checked = slots = 0
    for pid, info in sorted(zones, key=lambda z: z[1]['b2_zone']):
        where = f"{info['name']} (zone {info['b2_zone']})"
        n = pzones[pid]['encounters']
        got_id = headers[info['b2_zone']]['encounters']
        want_id = NONE if n is None else B2_TABLES + n
        if got_id != want_id:
            diffs.append(f'{where}: header names table {got_id}, expected {want_id}')
            continue
        if n is None:
            continue
        data = built[got_id]
        if len(data) not in (0xE8, 4 * 0xE8):
            diffs.append(f'{where}: table {got_id} is {len(data)} bytes'); continue
        if len(data) != 4 * 0xE8:
            diffs.append(f'{where}: table {got_id} is {len(data)} bytes, expected 4 time-of-day tables'); continue
        enc = json.load(open(os.path.join(PEARL, 'encounters', f'{n:03d}.json')))
        if enc['land_rate'] and enc['land_rate'] not in RULE or enc['surf_rate'] and enc['surf_rate'] not in RULE:
            diffs.append(f"{where}: Pearl rate {enc['land_rate']}/{enc['surf_rate']} has no documented rule")
        for t, period in enumerate(('morning', 'day', 'night', 'day')):   # sinnoh_encounters.TIME_TABLES
            rates, got, flags = parse(data[t * 0xE8:(t + 1) * 0xE8])
            for g, (rate, rows) in expected(enc, sp, layout, period, t == 3).items():
                if rates[g] != rate:
                    diffs.append(f'{where} ({period}): {g} rate {rates[g]}, expected {rate}')
                for i, (a, b) in enumerate(zip(got[g], rows)):
                    slots += 1
                    if a != b:
                        show = lambda t_: f'{names.get(t_[0], t_[0])}{"/" + str(t_[1]) if t_[1] else ""} {t_[2]}-{t_[3]}'
                        diffs.append(f'{where} ({period}): {g} slot {i}: {show(a)}, Pearl {show(b)}')
        if flags:
            diffs.append(f'{where}: flags {flags}, expected 0')
        checked += 1
    for d in diffs:
        print(d)
    print(f'{checked} Sinnoh zones with wild Pokémon checked ({len(zones)} zones, {skipped} rooms not installed), '
          f'{slots} slots, rods {layout}: {len(diffs)} differences')
    return 1 if diffs else 0


if __name__ == '__main__':
    sys.exit(main())
