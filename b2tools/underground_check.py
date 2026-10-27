"""Offline checks of the Grand Underground (no ROM, no emulator): notes/UNDERGROUND.md "Checks".

    python3 underground_check.py [--odds HIDEAWAY]

1. The data: zones 634-651 one per Hideaway, grottos 0-17 once each, every item and species known, the item-ball and
   shard flags registered (data/pearl_story_ids.json), the unlock table.
2. The way down: every walkable tile of Pearl's overworld (matrix 0) gives, by Pearl's arrival rule (the C's), a
   walkable tunnel tile, and from it every Hideaway hole can be reached on foot.
3. The holes: on a north wall (wall, floor south of it), one Hideaway per tunnel cell.
4. The Hideaway rooms: the arrival at their exit is floor; every item ball and grotto "narrow path" can be reached on
   foot from it, on floor (balls) / on a wall over floor (the path); no two on one tile.
5. The encounter table: a Python twin of src/pearlb2/underground_itcm.c's pick (stage, water, rare share, weights)
   for each Hideaway and stage: the species and their odds (--odds prints one Hideaway's); its ITCM size.
6. The script file: generated from the data (underground_scripts --check), assembled, every command allowed at its
   level (b2_script_check: the shard init at the zone-init level 2).
"""
import json, os, sys
from collections import deque, Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, 'patches'))
import ug_data  # noqa: E402

PEARL = os.path.join(ROOT, 'work', 'pearl')
WATER_B = {0x10, 0x15, 0x13}
_lands = {}


def land(c):
    if c not in _lands: _lands[c] = json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))
    return _lands[c]


def pearl_kind(m, x, z):
    if not (0 <= x < m['width'] * 32 and 0 <= z < m['height'] * 32): return 'wall'
    c = m['maps'][z // 32][x // 32]
    if c == 0xffff: return 'wall'
    L = land(c)
    if L['collision'][z % 32][x % 32]: return 'wall'
    return 'water' if L['behaviour'][z % 32][x % 32] in WATER_B else 'floor'


def flood(kind, start):
    seen, q = {start}, deque([start])
    while q:
        x, z = q.popleft()
        for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, z + dz)
            if n not in seen and kind(*n) == 'floor':
                seen.add(n); q.append(n)
    return seen


def arrival(x, z):
    """The C's (Pearl's) tunnel tile for overworld tile (x, z)."""
    cx, cz = max(0, x // 32 - 1), max(0, z // 32 - 6)
    return (cx // 2 + 1) * 32 + (8 if cx % 2 == 0 else 23), (cz // 2 + 3) * 32 + (8 if cz % 2 == 0 else 23)


def check_data(errors):
    d, hs = ug_data.data(), ug_data.hideaways()
    zones = [h['zone'] for h in hs]
    if zones != list(range(d['zones']['first_hideaway'], d['zones']['first_hideaway'] + len(hs))):
        errors.append(f'Hideaway zones not contiguous: {zones}')
    if sorted(h['grotto']['hollow'] for h in hs) != list(range(len(hs))) or len(hs) > 20:
        errors.append('grottos: not 0-17 once each')
    try:
        balls, shards, fossils = ug_data.item_balls(), ug_data.shard_balls(), ug_data.fossil_balls()
    except KeyError as e:
        errors.append(f'an item ball or shard flag is not registered (pearl_ids.py): {e}'); return
    for b in balls + shards:
        if not 0 < b[1] < 640: errors.append(f'item {b[1]}?')
    ids = ug_data.species_ids()
    for h in hs:
        for s in h['grotto']['starters']:
            if s not in ids: errors.append(f'{h["key"]}: grotto starter {s}?')
    kinds, values = ug_data.unlock_table()
    print(f'1. data: {len(hs)} Hideaways (zones {zones[0]}-{zones[-1]}), {len(balls)} item balls, {len(shards)} shard '
          f'balls, {len(fossils)} fossil balls, unlock kinds {kinds} values {values}')


def check_way_down(errors):
    m0 = json.load(open(os.path.join(PEARL, 'matrices', '000.json')))
    m2 = json.load(open(os.path.join(PEARL, 'matrices', '002.json')))
    hs = ug_data.hideaways()
    targets = {}
    for z in range(m0['height'] * 32):
        for x in range(m0['width'] * 32):
            if m0['maps'][z // 32][x // 32] == 0xffff: continue
            if pearl_kind(m0, x, z) != 'floor': continue
            targets.setdefault(arrival(x, z), 0)
            targets[arrival(x, z)] += 1
    bad = [t for t in targets if pearl_kind(m2, *t) != 'floor']
    if bad: errors.append(f'way down: {len(bad)} arrival tiles are not tunnel floor: {bad[:6]}')
    # Pearl's tunnels are several networks that do not meet (the player reaches the one under where they went
    # down): each hole's network must have arrival tiles
    comp, comps = {}, []
    for t in sorted(targets):
        if t in comp or t in bad: continue
        r = flood(lambda x, z: pearl_kind(m2, x, z), t)
        for u in r: comp[u] = len(comps)
        comps.append(r)
    cells = Counter()
    for h in hs:
        x, z = h['hole']
        cells[(x // 32, z // 32)] += 1
        if pearl_kind(m2, x, z) != 'wall' or pearl_kind(m2, x, z + 1) != 'floor':
            errors.append(f'{h["key"]}: hole {h["hole"]} not on a north wall')
        if (x, z + 1) not in comp:
            errors.append(f'{h["key"]}: hole {h["hole"]} is in a network no way down reaches')
    if max(cells.values()) > 1: errors.append(f'holes: two in one tunnel cell: {cells.most_common(2)}')
    per = Counter(comp[(h['hole'][0], h['hole'][1] + 1)] for h in hs if (h['hole'][0], h['hole'][1] + 1) in comp)
    print(f'2-3. way down: {sum(targets.values())} overworld tiles -> {len(targets)} arrival tiles, all tunnel floor, '
          f'in {len(comps)} networks of {[len(c) for c in comps]} tiles; holes per network {dict(per)}')


def check_rooms_offline(errors):
    """Hideaway rooms from Pearl's data / Black 2's vanilla files (as the patch reads them)."""
    import struct, b2files, zoneheaders, zones as zmod, narcio
    van = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
    pz = {z['name']: z for z in json.load(open(os.path.join(PEARL, 'zones.json')))}
    vh, _ = zoneheaders.load(van)
    vents, vmats, vchunks = narcio.load(van, 126), narcio.load(van, 9), narcio.load(van, 8)
    lines = []
    for h in ug_data.hideaways():
        r = h['room']
        if 'pearl' in r:
            z = pz[r['pearl']]
            m = json.load(open(os.path.join(PEARL, 'matrices', f"{z['matrix']:03d}.json")))
            ev = json.load(open(os.path.join(PEARL, 'events', f"{z['events']:03d}.json")))
            kind = lambda x, zz, m=m: pearl_kind(m, x, zz)
            warps = [(w['x'], w['z']) for w in ev['warp_events']]
        else:
            hd = vh[r['unova']]
            d = vmats[hd['matrix']]
            fmt, _, w, hh = struct.unpack_from('<HHHH', d, 0)
            cells = struct.unpack_from(f'<{w * hh}I', d, 8)
            ter = {}
            def kind(x, zz, w=w, hh=hh, cells=cells, ter=ter):
                if not (0 <= x < w * 32 and 0 <= zz < hh * 32): return 'wall'
                c = cells[(zz // 32) * w + x // 32]
                if c == 0xFFFFFFFF: return 'wall'
                if c not in ter: ter[c] = b2files.gf_container(vchunks[c])[1][1]
                fl = struct.unpack_from('<I', ter[c], 4 + 8 * ((zz % 32) * 32 + x % 32) + 4)[0] >> 16
                return 'wall' if fl & 1 else 'water' if fl & 2 else 'floor'
            e, _ = zmod.parse_entities(vents[hd['entities']])
            warps = [(w_['tile_x'], w_['tile_z']) for w_ in e['warps']]
        for k in h['exits']:
            if k >= len(warps): errors.append(f'{h["key"]}: exit {k}: the room has {len(warps)} warps')
        wx, wz = warps[h['exits'][0]]
        start = next(((wx + dx, wz + dz) for dx, dz in ((0, 0), (0, 1), (0, -1), (-1, 0), (1, 0))
                      if kind(wx + dx, wz + dz) == 'floor'), None)
        if start is None:
            errors.append(f'{h["key"]}: no floor at its exit {wx, wz}'); continue
        reach = flood(kind, start)
        spots = ([(x, z) for _, x, z in h['items']] + ([tuple(h['shard'][1:])] if h.get('shard') else [])
                 + ([tuple(h['fossil'])] if h.get('fossil') else []))
        for s in spots:
            if s not in reach: errors.append(f'{h["key"]}: item ball {s} not reachable on foot')
            if s in warps: errors.append(f'{h["key"]}: item ball {s} on a warp')
        if len(set(spots)) != len(spots): errors.append(f'{h["key"]}: two balls on one tile')
        g = (h['grotto']['x'], h['grotto']['z'])
        if kind(*g) != 'wall' or (g[0], g[1] + 1) not in reach:
            errors.append(f'{h["key"]}: grotto path {g} not a wall over reachable floor')
        lines.append(f'{h["key"]} {len(reach)}')
    print(f'4. rooms: reachable floor on foot {", ".join(lines)}')


def odds(h, stage, water, version):
    """{species: probability} of a battle (the C's pick)."""
    p = h['pokemon']
    out = Counter()
    rare = [(r['species'], r[version]) for r in p['rare'] if r[version]]
    pr = p['rare_per_mille'] / 1000 if (rare and not water) else 0
    tot = sum(w for _, w in rare)
    for s, w in rare:
        if pr: out[s] += pr * w / tot
    el = [(e['species'], e['weight']) for e in p['entries'] if e[version] and e[version] <= stage
          and e['where'] & (2 if water else 1)]
    tot = sum(w for _, w in el)
    for s, w in el:
        out[s] += (1 - pr) * w / tot if tot else 0
    return Counter({s: v for s, v in out.items() if v > 0})


def check_table(errors, show=None):
    d = ug_data.data()
    v = d['version']
    import narcio
    per = narcio.load(os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files'), 16)
    rows = []
    for h in ug_data.hideaways():
        for e in h['pokemon']['entries']:
            if e[v] and not (0 < e['species'] < len(per)): errors.append(f'{h["key"]}: species {e["species"]}?')
        n = [len(odds(h, st, False, v)) for st in (1, 6)]
        w = len(odds(h, 6, True, v))
        rows.append(f'{h["pokemon"]["name"]} {n[0]}->{n[1]} land, {w} water')
        if show and show in (h['key'], h['pokemon']['name']):
            for st in range(1, 7):
                o = odds(h, st, False, v)
                names = {i: k for k, i in ug_data.species_ids().items()}
                print(f'   stage {st}: ' + ', '.join(f'{names[s].title()} {100 * p:.1f}%'
                                                 for s, p in sorted(o.items(), key=lambda kv: -kv[1])))
    blob = ug_data.table_blob(0x01FF8000, 0)
    print(f'5. table: {"; ".join(rows)}; {len(blob)} B of ITCM')
    # part 2: the visible Pokémon's counts (ug_data packs them into each record) and the gimmick id the patch writes
    import re, struct
    sys.path.insert(0, os.path.join(HERE, 'patches'))
    import underground as patch
    hfile = open(os.path.join(ROOT, 'external', 'pokebw2', 'include', 'pearlb2.h')).read()
    m = re.search(r'#define PEARLB2_GIMMICK_HIDEAWAY (\d+)', hfile)
    if not m or int(m.group(1)) != patch.GIMMICK_HIDEAWAY:
        errors.append(f'gimmick id: patch {patch.GIMMICK_HIDEAWAY}, decomp {m and m.group(1)}')
    recs = ug_data.encounter_lists()[0]
    counts = sorted({(r['spawns'] & 15, r['spawns'] >> 4 & 15, r['spawns'] >> 8) for r in recs})
    print(f'   visible Pokémon: {"on" if d.get("visible") else "off"} (gimmick {patch.GIMMICK_HIDEAWAY}); land min/max, '
          f'water a visit: {counts}')


def check_scripts(errors):
    import subprocess, scripts, b2_script_check
    r = subprocess.run([sys.executable, os.path.join(HERE, 'underground_scripts.py'), '--check'], capture_output=True,
                       text=True)
    if r.returncode: errors.append(r.stdout + r.stderr); return
    f = ug_data.data()['files']['script']
    b = scripts.assemble(os.path.join(ROOT, 'src', 'field_scripts', f'{f}_underground.s'))
    bad = b2_script_check.check(b, {ug_data.script_ids()['shard_init']: 2})
    errors += bad
    print(f'6. scripts: {len(b)} B assembled, {len(bad)} problems')


def main():
    errors = []
    check_data(errors)
    check_way_down(errors)
    check_rooms_offline(errors)
    check_table(errors, sys.argv[sys.argv.index('--odds') + 1] if '--odds' in sys.argv else None)
    check_scripts(errors)
    if errors:
        print('PROBLEMS:'); [print('  ' + e) for e in errors]
        sys.exit(1)
    print('all checks passed')


if __name__ == '__main__':
    main()
