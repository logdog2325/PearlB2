"""Seasons: grass left in Pearl's colours (2026-10-20; user: "the color of the grass also changes with the seasons").

For every seasonal area set (the overworld's 13 Pearl areas and the 10 outdoor areas built as rooms: lakes, Eterna
Forest, Mt. Coronet's sides, ...) and every season that recolours (autumn and winter; the north, Pearl area 14, all
four), every texture the area's chunks draw that still shows a Pearl grass colour (recolour.is_grass) unchanged on
some of its texels: a grass patch or rim that does not follow the season next to recoloured grass.

    python3 b2tools/season_grass_check.py            the sets as patches/sinnoh_reskin.py builds them now (offline)
    python3 b2tools/season_grass_check.py FILES      a build's files dir (its a/0/1/4 and zone headers)

Prints one line per area and season with what is left (texture/palette and texels), then the totals; exit 1 if any
is left. The colours are compared texel by texel with Pearl's own set (roms/pearl.nds), so spring and summer (Pearl's
own sets) are not checked outside the north.
"""
import json, os, sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, 'patches'))
import narcio, nsbtx, recolour, maplook  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

NORTH = 14
SEASONS = ('spring', 'summer', 'autumn', 'winter')


def load_matrix(mid):
    return json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f'{mid:03d}.json')))


def areas_and_chunks(rom):
    """{('overworld' | 'room', Pearl area): (Pearl texset, {chunks})} for every seasonal area set: the overworld's
    areas (by the zones of matrix 0's cells) and the outdoor room areas (sinnoh_rooms' rule: Pearl's area data says
    outdoor light, or the area is exterior)."""
    import sinnoh_rooms
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = {int(k): v for k, v in world['zones'].items()}
    m0 = load_matrix(0)
    out = defaultdict(set)
    for z in range(m0['height']):
        for x in range(m0['width']):
            h, c = m0['headers'][z][x], m0['maps'][z][x]
            if h in zones and c != 0xffff: out[('overworld', zones[h]['pearl_area'])].add(c)
    rooms = world['rooms']
    field = sinnoh_rooms.pearl_light_field(rom)
    outdoor = {int(pa) for pa, a in rooms['areas'].items() if field.get(int(pa)) or a['exterior']}
    seen = {}
    for r in rooms['zones'].values():          # a chunk belongs to the first area whose matrix holds it (sinnoh_rooms)
        for row in load_matrix(r['pearl_matrix'])['maps']:
            for c in row:
                if c != 0xffff: seen.setdefault(c, r['pearl_area'])
    for c, pa in seen.items():
        if pa in outdoor: out[('room', pa)].add(c)
    texset = {('overworld', int(k)): v['pearl_texset'] for k, v in world['areas'].items()}
    texset.update({('room', pa): rooms['areas'][str(pa)]['pearl_texset'] for pa in outdoor})
    return {k: (texset[k], out[k]) for k in sorted(out) if k in texset}


def built_sets(files, areas):
    """{area key: [4 BTX0]} from a build: the overworld groups of data/sinnoh_world.json, the rooms' groups from their
    zones' headers (sinnoh_rooms points them at the group's first record)."""
    import zoneheaders
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    sets = narcio.load(files, 14)
    headers, _ = zoneheaders.load(files)
    group = {('overworld', int(k)): v['b2_area_group'] for k, v in world['areas'].items()}
    for r in world['rooms']['zones'].values():
        group.setdefault(('room', r['pearl_area']), headers[r['b2_zone']]['area'])
    return {k: [sets[group[k] + s] for s in range(4)] for k in areas}


def offline_sets(areas):
    """{area key: [4 BTX0]} as patches/sinnoh_reskin.py and patches/sinnoh_rooms.py build them now."""
    import sinnoh_reskin
    fixes = maplook.texture_fixes(maplook.fixes())
    ow, _ = sinnoh_reskin.reskin_sets(fixes)
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    out = {k: [ow[world['areas'][str(k[1])]['b2_area_group'] + s] for s in range(4)]
           for k in areas if k[0] == 'overworld'}
    rooms = [k for k in areas if k[0] == 'room']
    if rooms:
        fake = {pa: 1000 + 4 * i for i, (_, pa) in enumerate(rooms)}       # any group numbers: only the sets count
        rs, _ = sinnoh_reskin.reskin_sets(
            fixes, {str(pa): dict(world['rooms']['areas'][str(pa)], b2_area_group=g) for pa, g in fake.items()},
            sorted(c for k in rooms for c in areas[k][1]))
        out.update({('room', pa): [rs[g + s] for s in range(4)] for pa, g in fake.items()})
    return out


def texel_colours(parsed, tex, pal):
    """[(palette index, BGR555)] of every drawn texel of a texture (colour 0 left out where transparent)."""
    import struct
    params = dict(parsed['texs'])[tex][0]
    fmt = (params >> 26) & 7
    raw, _ = nsbtx._tex_bytes(parsed, params)
    o = dict(parsed['pals'])[pal][0] << 3
    palette = struct.unpack_from(f'<{nsbtx._pal_size(parsed, pal) // 2}H', parsed['pdata'], o)
    if fmt == 3:   idx = [b >> s & 15 for b in raw for s in (0, 4)]
    elif fmt == 2: idx = [b >> s & 3 for b in raw for s in (0, 2, 4, 6)]
    elif fmt == 4: idx = list(raw)
    elif fmt == 1: idx = [b & 31 for b in raw if b >> 5]
    elif fmt == 6: idx = [b & 7 for b in raw if b >> 3]
    else: return []
    first = 1 if (params >> 29) & 1 else 0
    return [(i, palette[i]) for i in idx if first <= i < len(palette)]


def check(files=None):
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    pearl_sets = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))
    areas = areas_and_chunks(rom)
    sets = built_sets(files, areas) if files else offline_sets(areas)
    left_total, per_season = 0, defaultdict(int)
    for key, (texset, chunks) in areas.items():
        P = nsbtx._parse(pearl_sets[texset])
        pairs = set()
        for c in chunks:
            pairs |= nsbtx.material_pairs(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.nsbmd'), 'rb').read())
        pairs = sorted((t, p) for t, p in pairs if t and p and t in dict(P['texs']) and p in dict(P['pals']))
        mine = {t: [(i, c) for i, c in texel_colours(P, t, p)] for t, p in pairs}
        for s in (range(4) if key[1] == NORTH else (2, 3)):
            B = nsbtx._parse(sets[key][s])
            left = []
            for t, p in pairs:
                if t not in dict(B['texs']) or p not in dict(B['pals']): continue
                now = texel_colours(B, t, p)
                n = sum(1 for (i, c), (j, d) in zip(mine[t], now) if recolour.is_grass(c) and c == d)
                if n: left.append(f'{t}/{p} {n}')
            if left:
                print(f'{key[0]} area {key[1]} {SEASONS[s]}: ' + ', '.join(left))
            left_total += len(left); per_season[SEASONS[s]] += len(left)
    print(f'grass textures left in Pearl\'s colours: {left_total} ({dict(per_season)}) over {len(areas)} area sets '
          f'({sum(1 for k in areas if k[0] == "overworld")} overworld, {sum(1 for k in areas if k[0] == "room")} '
          f'outdoor rooms); source: {files or "offline (sinnoh_reskin now)"}')
    return left_total


if __name__ == '__main__':
    sys.exit(1 if check(sys.argv[1] if len(sys.argv) > 1 else None) else 0)
