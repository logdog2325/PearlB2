"""Sinnoh's bridges: Pearl's two levels against the converted chunks' (pearl_chunk "two levels", 'GC' chunks).

    python3 b2tools/bridge_check.py                    every bridge: list, walk check, Route 215 end to end
    python3 b2tools/bridge_check.py --json OUT         the same, the table as JSON too

Pearl's side (pokeplatinum, Gen 4's own rules): a walker at height y stepping onto a tile takes, of the BDHC plates
over the tile's centre (gen4_land.read_bdhc_dp), the one nearest y (bdhc.c CalculateObjectHeight); 20 units or more
up or down is a wall (terrain_collision_manager.c GetVerticalDirection), the tile's collision bit is a wall, and
water on foot is a wall (map_object_move.c MapObject_IsOnWater: a bridge-over-water tile is water unless the walker
is "on the bridge", which a BRIDGE_START 0x70 tile sets and any non-bridge tile clears:
MapObject_DetermineElevatedBridgeStatus).
Black 2's side (pokebw2 ov036 FieldG3DMapper_GetTerrain, ov012 ActorRouteCollCheckCore): of a converted chunk's
terrain layers (1 for 'WB', 2 for 'GC'), the valid one nearest y; 20 units a wall, the wall flag a wall, water
classes on foot a wall. The chunks come from pearl_chunk.convert exactly as sinnoh_world / sinnoh_rooms call it
(Pearl's signs solid too), with MAP_FIXES=none: the model fixes change the drawing, not the terrain.

A "bridge" is a 4-connected group of tiles with a bridge behaviour (0x70-0x7d) or two BDHC levels (walkable) in one
zone's map. For each: its zone(s), tiles, deck height, what is under it, whether Pearl lets you walk (or surf)
under it and on it from outside, and whether the converted map does the same (before: BRIDGE_LEVELS=none, the
converter's one layer). The walk check compares every step on and next to the bridges (each start level, each
direction) and the reachability from the tiles around each bridge; the end-to-end check walks Route 215 from the
west (Route 210's junction, the Chapter 4b blocker) to Veilstone.
"""
import collections, json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
os.environ.setdefault('MAP_FIXES', 'none')
import pearl_chunk  # noqa: E402
from gen4_land import bdhc_dp_heights  # noqa: E402

PEARL = os.path.join(ROOT, 'work', 'pearl')
STEP = 20                                   # both games: a step of 20 units or more is a wall
SAME = 6                                    # Pearl's level vs the converted height: the same level within this
SURFABLE = {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x19, 0x22, 0x2a, 0x50, 0x51, 0x52, 0x53, 0x73, 0x78, 0x7c}
OVER_WATER = {0x73, 0x78, 0x7c}
IS_BRIDGE = set(range(0x71, 0x7e))           # pokeplatinum TileBehavior_IsBridge (0x70 BRIDGE_START is not one)
UNDER = {0x72: 'cave floor', 0x73: 'water', 0x78: 'water', 0x7c: 'water', 0x74: 'sand', 0x79: 'sand', 0x7d: 'sand',
         0x75: 'snow', 0x77: 'tall grass', 0x7b: 'tall grass'}
DIRS = ((0, -1), (0, 1), (-1, 0), (1, 0))
DNAME = {(0, -1): 'N', (0, 1): 'S', (-1, 0): 'W', (1, 0): 'E'}


def _json(*p):
    return json.load(open(os.path.join(*p)))


class Grid:
    """One zone map (Pearl's matrix): Pearl's tiles and the converted ones, by global tile (x, z)."""

    def __init__(self, mid, overworld, names):
        self.mid, self.overworld, self.names = mid, overworld, names    # names: {(cx, cz): zone name}
        self.m = _json(PEARL, 'matrices', f'{mid:03d}.json')
        self.lands, self.cells, self.before = {}, {}, {}
        self.slopes, self.offsets = pearl_chunk.tables()

    def chunk(self, x, z):
        cx, cz = x // 32, z // 32
        if not (0 <= cx < self.m['width'] and 0 <= cz < self.m['height']) or self.m['maps'][cz][cx] == 0xffff:
            return None
        return self.m['maps'][cz][cx]

    def land(self, c):
        if c not in self.lands: self.lands[c] = _json(PEARL, 'land', f'{c:03d}.json')
        return self.lands[c]

    def pearl(self, x, z):
        """(collision, behaviour, [plate heights]) of Pearl's tile, or None."""
        c = self.chunk(x, z)
        if c is None: return None
        L, b = self.land(c), pearl_chunk.bdhc(c)
        hs = [h for h, _ in bdhc_dp_heights(b, (x % 32) * 16 - 248, (z % 32) * 16 - 248)] if b else []
        return L['collision'][z % 32][x % 32], L['behaviour'][z % 32][x % 32], hs

    def _convert(self, c, levels):
        cx, cz = next((i, j) for j, row in enumerate(self.m['maps']) for i, v in enumerate(row) if v == c)
        if levels: os.environ.pop('BRIDGE_LEVELS', None)
        else: os.environ['BRIDGE_LEVELS'] = 'none'
        for f in (pearl_chunk.two_levels,):
            f.cache_clear()
        import pearl_signs
        data, rep = pearl_chunk.convert(c, self.slopes, self.offsets, pearl_chunk.neighbours(self.m, cx, cz),
                                        pearl_chunk.ENTRANCES if self.overworld else ())
        magic, layers, _ = pearl_chunk.terrains(data)
        layers = [pearl_signs.chunk(c, t, struct.pack('<I', 0), dict(rep, walkable={}))[0] for t in layers]
        os.environ.pop('BRIDGE_LEVELS', None); pearl_chunk.two_levels.cache_clear()
        out = []
        for k in range(1024):
            tx, tz = k % 32, k // 32
            tile = []
            for t in layers:
                a, o, typ = struct.unpack_from('<HHI', t, 4 + 8 * k)
                cls, flags = typ & 0xffff, typ >> 16
                if cls == 0xff or typ == 0xffffffff: continue
                h = pearl_chunk.plane_height(self.slopes, self.offsets, a >> 2, o, tx * 16 - 248, tz * 16 - 248)
                tile.append((h, cls, flags))
            out.append(tile)
        return magic, out

    def b2(self, x, z, levels=True):
        """[(height, class, flags)] of the converted tile's valid layers (layer 0 first), or None."""
        c = self.chunk(x, z)
        if c is None: return None
        store = self.cells if levels else self.before
        if c not in store: store[c] = self._convert(c, levels)
        return store[c][1][(z % 32) * 32 + x % 32]

    def magic(self, c):
        if c not in self.cells: self.cells[c] = self._convert(c, True)
        return self.cells[c][0]

    def sign(self, x, z):
        import pearl_signs
        c = self.chunk(x, z)
        return c is not None and (x % 32, z % 32) in pearl_signs.census()['chunks'].get(c, {})

    def zone(self, x, z):
        return self.names.get((x // 32, z // 32), '?')


def pearl_step(g, state, d):
    """Pearl: (x, z, y, on_bridge) one step in direction d -> new state, or the reason it is refused."""
    x, z, y, on = state
    t = g.pearl(x + d[0], z + d[1])
    if t is None or not t[2]: return 'edge'
    coll, beh, hs = t
    ny = min(hs, key=lambda h: abs(h - y))
    if abs(ny - y) >= STEP: return 'height'
    if coll: return 'wall'
    if g.sign(x + d[0], z + d[1]): return 'wall'           # (a sign object: Black 2's sign tile is solid)
    if g.overworld and beh in pearl_chunk.ENTRANCES: return 'wall'   # (a step-on warp: a bump warp converted)
    if (beh in OVER_WATER and not on) or (beh in SURFABLE and beh not in OVER_WATER): return 'water'
    on2 = True if beh == 0x70 else (on and beh in IS_BRIDGE)
    return (x + d[0], z + d[1], ny, on2)


def b2_step(g, state, d, levels=True):
    """Black 2 on the converted map: (x, z, y) one step -> new state, or the reason it is refused."""
    x, z, y = state[:3]
    t = g.b2(x + d[0], z + d[1], levels)
    if not t: return 'edge'
    best = min(range(len(t)), key=lambda i: (abs(t[i][0] - y), i))
    h, cls, flags = t[best]
    if abs(h - y) >= STEP: return 'height'
    if flags & 1: return 'wall'
    if flags & 2: return 'water'                 # (Black 2's water flag: ov036 CheckSurfBeginTiles)
    return (x + d[0], z + d[1], h)


def pearl_surf(g, state, d):
    """Pearl surfing: water tiles only (a bridge over water is water to a surfer: never "on the bridge")."""
    x, z, y, on = state
    t = g.pearl(x + d[0], z + d[1])
    if t is None or not t[2]: return 'edge'
    coll, beh, hs = t
    ny = min(hs, key=lambda h: abs(h - y))
    if abs(ny - y) >= STEP: return 'height'
    if coll: return 'wall'
    if beh not in SURFABLE: return 'land'
    return (x + d[0], z + d[1], ny, False)


def b2_surf(g, state, d, levels=True):
    """Black 2 surfing on the converted map: tiles with the water flag only."""
    x, z, y = state[:3]
    t = g.b2(x + d[0], z + d[1], levels)
    if not t: return 'edge'
    best = min(range(len(t)), key=lambda i: (abs(t[i][0] - y), i))
    h, cls, flags = t[best]
    if abs(h - y) >= STEP: return 'height'
    if flags & 1: return 'wall'
    if not flags & 2: return 'land'
    return (x + d[0], z + d[1], h)


def pearl_levels(hs):
    out = []
    for h in sorted(hs, reverse=True):
        if not out or out[-1] - h >= pearl_chunk.LEVEL_GAP: out.append(h)
    return out


def bridges(g, tiles):
    """4-connected groups of the bridge tiles `tiles` (global (x, z)) in grid g."""
    left, out = set(tiles), []
    while left:
        s = left.pop(); grp, todo = {s}, [s]
        while todo:
            x, z = todo.pop()
            for dx, dz in DIRS:
                n = (x + dx, z + dz)
                if n in left: left.discard(n); grp.add(n); todo.append(n)
        out.append(sorted(grp))
    return sorted(out)


def reach(step, g, seeds, window, **kw):
    """States reachable on foot from seeds within window (x0, x1, z0, z1): {(x, z): set of heights (rounded)}."""
    x0, x1, z0, z1 = window
    seen = set(seeds); todo = list(seeds)
    while todo:
        s = todo.pop()
        for d in DIRS:
            n = step(g, s, d, **kw)
            if isinstance(n, str) or not (x0 <= n[0] <= x1 and z0 <= n[1] <= z1): continue
            key = n[:2] + (round(n[2]),) + n[3:]
            if key in seen: continue
            seen.add(key); todo.append(n[:2] + (round(n[2]),) + n[3:])
    out = collections.defaultdict(set)
    for s in seen: out[s[:2]].add(s[2])
    return out


def check_bridge(g, grp, report):
    """The walk check of one bridge group: local steps and reachability, Pearl vs converted (and before)."""
    tiles = set(grp)
    xs, zs = [t[0] for t in grp], [t[1] for t in grp]
    window = (min(xs) - 8, max(xs) + 8, min(zs) - 8, max(zs) + 8)
    ring = {(x + dx, z + dz) for x, z in tiles for dx in range(-2, 3) for dz in range(-2, 3)} - tiles
    # reachability from the single-level walkable tiles around the bridge
    seeds_p, seeds_b, seeds_0 = [], [], []
    for x, z in ring:
        p = g.pearl(x, z)
        if p is None or p[0] or len(pearl_levels(p[2])) != 1 or p[1] in SURFABLE or p[1] in IS_BRIDGE | {0x70}:
            continue
        y = p[2][0]
        seeds_p.append((x, z, round(y), False))
        for levels, seeds in ((True, seeds_b), (False, seeds_0)):
            t = g.b2(x, z, levels)
            if t:
                hb = min((h for h, _, _ in t), key=lambda h: abs(h - y))
                if abs(hb - y) <= SAME: seeds.append((x, z, round(hb)))
    rp = reach(pearl_step, g, seeds_p, window)
    rb = reach(b2_step, g, seeds_b, window)
    r0 = reach(b2_step, g, seeds_0, window, levels=False)

    # local steps from every level of every tile on and next to the bridge
    bad = []
    for x, z in sorted(tiles | ring):
        p = g.pearl(x, z)
        if p is None or p[0] or not p[2]: continue
        coll, beh, hs = p
        lv = pearl_levels(hs)
        for i, y in enumerate(lv):
            if beh in SURFABLE and beh not in OVER_WATER: continue
            on = beh == 0x70 or (beh in IS_BRIDGE and i == 0)
            if beh in OVER_WATER and not on: continue                  # (water under a deck: surfing, not walking)
            if not any(abs(h - y) <= SAME for h in rp.get((x, z), ())): continue   # (a level nobody walks onto)
            t = g.b2(x, z)
            if not t: bad.append(((x, z), round(y), 'no converted tile')); continue
            hb = min((h for h, _, _ in t), key=lambda h: abs(h - y))
            if abs(hb - y) > SAME:
                bad.append(((x, z), round(y), f'no converted level near it (has {[round(h) for h, _, _ in t]})'))
                continue
            for d in DIRS:
                a = pearl_step(g, (x, z, y, on), d)
                b = b2_step(g, (x, z, hb), d)
                if isinstance(a, str) and isinstance(b, str): continue
                if isinstance(a, str) != isinstance(b, str) or abs(a[2] - b[2]) > SAME:
                    bad.append(((x, z), round(y), f"{DNAME[d]}: Pearl {a if isinstance(a, str) else round(a[2])}"
                                f" / converted {b if isinstance(b, str) else round(b[2])}"))
    def levels_reached(r, x, z, ys):
        got = r.get((x, z), set())
        return [any(abs(h - y) <= SAME for h in got) for y in ys]
    # surfing from the water around the bridge (under a bridge over water)
    sp, sb, s0 = [], [], []
    for x, z in ring:
        p = g.pearl(x, z)
        if p is None or p[0] or not p[2] or p[1] not in SURFABLE or p[1] in OVER_WATER: continue
        y = min(p[2])
        sp.append((x, z, round(y), False))
        for levels, seeds in ((True, sb), (False, s0)):
            t = g.b2(x, z, levels)
            if t:
                hb = min((h for h, _, _ in t), key=lambda h: abs(h - y))
                if abs(hb - y) <= SAME: seeds.append((x, z, round(hb)))
    surf = {'pearl': reach(pearl_surf, g, sp, window), 'converted': reach(b2_surf, g, sb, window),
            'before': reach(b2_surf, g, s0, window, levels=False)}
    surf_under = {k: any(len(pearl_levels(g.pearl(x, z)[2])) >= 2 and
                         levels_reached(r, x, z, pearl_levels(g.pearl(x, z)[2]))[-1]
                         for x, z in grp if g.pearl(x, z) and g.pearl(x, z)[2]) for k, r in surf.items()}
    deck = {'pearl': False, 'converted': False, 'before': False}
    under = {'pearl': False, 'converted': False, 'before': False}
    diffs = []
    two = 0
    for x, z in grp:
        p = g.pearl(x, z)
        if p is None or p[0] or not p[2]: continue
        lv = pearl_levels(p[2])
        two += len(lv) >= 2
        for name, r in (('pearl', rp), ('converted', rb), ('before', r0)):
            hit = levels_reached(r, x, z, lv)
            if hit[0]: deck[name] = True
            if len(lv) >= 2 and hit[-1]: under[name] = True
        a, b = levels_reached(rp, x, z, lv), levels_reached(rb, x, z, lv)
        if a != b: diffs.append(((x, z), [round(y) for y in lv], f'Pearl reaches {a}, converted {b}'))
    behs = collections.Counter(g.pearl(x, z)[1] for x, z in grp)
    deck_h = sorted({round(pearl_levels(g.pearl(x, z)[2])[0]) for x, z in grp if g.pearl(x, z)[2]})
    lows = sorted({round(pearl_levels(g.pearl(x, z)[2])[-1]) for x, z in grp
                   if len(pearl_levels(g.pearl(x, z)[2])) >= 2})
    what = sorted({UNDER.get(b, 'road / ground') for b in behs if b in IS_BRIDGE | {0x70}} or {'road / ground'})
    chunks = sorted({g.chunk(x, z) for x, z in grp})
    row = dict(zone=sorted({g.zone(x, z) for x, z in grp}), x=(min(xs), max(xs)), z=(min(zs), max(zs)),
               tiles=len(grp), two_level_tiles=two, behaviours={hex(b): n for b, n in sorted(behs.items())},
               deck=deck_h, under_level=lows, under=what if two else [],
               pearl_under=under['pearl'], converted_under=under['converted'], before_under=under['before'],
               pearl_surf_under=surf_under['pearl'], converted_surf_under=surf_under['converted'],
               before_surf_under=surf_under['before'],
               pearl_deck=deck['pearl'], converted_deck=deck['converted'], before_deck=deck['before'],
               chunks=chunks, gc=[c for c in chunks if g.magic(c) == 'GC'],
               step_mismatches=bad, reach_mismatches=diffs)
    report.append(row)
    return row


def grids():
    """[(Grid, bridge tiles)] for the overworld and every room map with a bridge or two-level tile."""
    world = _json(ROOT, 'data', 'sinnoh_world.json')
    zones = _json(PEARL, 'zones.json')
    m0 = _json(PEARL, 'matrices', '000.json')
    names0 = {(cx, cz): zones[h]['name'] for cz, row in enumerate(m0['headers']) for cx, h in enumerate(row)
              if h < len(zones)}
    out = [(Grid(0, True, names0), {int(c) for c in world['chunks']})]
    seen_chunks = set()
    by_matrix = collections.defaultdict(list)
    for pid, r in world['rooms']['zones'].items():
        by_matrix[r['pearl_matrix']].append(r['name'])
    for mid, nm in sorted(by_matrix.items()):
        m = _json(PEARL, 'matrices', f'{mid:03d}.json')
        cs = {c for row in m['maps'] for c in row if c != 0xffff and str(c) in world['rooms']['chunks']}
        cs -= seen_chunks
        if not cs: continue
        seen_chunks |= cs
        names = {(cx, cz): '/'.join(sorted(nm)) for cz, row in enumerate(m['maps']) for cx, c in enumerate(row)}
        out.append((Grid(mid, False, names), cs))
    res = []
    for g, cs in out:
        tiles = set()
        for cz, row in enumerate(g.m['maps']):
            for cx, c in enumerate(row):
                if c not in cs or c in pearl_chunk.gym_chunks(): continue
                L, two = g.land(c), pearl_chunk.two_levels(c)
                for tz in range(32):
                    for tx in range(32):
                        if L['behaviour'][tz][tx] in IS_BRIDGE | {0x70} or (tx, tz) in two:
                            tiles.add((cx * 32 + tx, cz * 32 + tz))
        if tiles: res.append((g, tiles))
    return res


def route215(g):
    """Route 215 from the west (Route 210's junction, the blocker's (590, 591)) to Veilstone: reached on foot?"""
    seeds = (590, 591)
    p = g.pearl(*seeds)
    y = pearl_levels(p[2])[0]
    window = (540, 800, 540, 680)
    rp = reach(pearl_step, g, [(seeds[0], seeds[1], round(y), False)], window)
    out = {}
    for name, levels in (('converted', True), ('before', False)):
        t = g.b2(*seeds, levels)
        hb = min((h for h, _, _ in t), key=lambda h: abs(h - y))
        r = reach(b2_step, g, [(seeds[0], seeds[1], round(hb))], window, levels=levels)
        out[name] = sorted({g.zone(x, z) for x, z in r})
        out[name + '_east'] = max(x for x, z in r)
    out['pearl'] = sorted({g.zone(x, z) for x, z in rp}); out['pearl_east'] = max(x for x, z in rp)
    return out


def main():
    report = []
    gs = grids()
    for g, tiles in gs:
        for grp in bridges(g, tiles):
            check_bridge(g, grp, report)
            print(len(report), report[-1]['zone'], flush=True)
    g0 = next(g for g, _ in gs if g.mid == 0)
    r215 = route215(g0)
    print('Route 215 from (590, 591):', json.dumps(r215))
    n_bad = 0
    for r in report:
        flag = '' if not r['step_mismatches'] and not r['reach_mismatches'] else '  <-- mismatches'
        print(f"{'/'.join(r['zone'])[:60]:60s} x {r['x'][0]}-{r['x'][1]} z {r['z'][0]}-{r['z'][1]} "
              f"{r['tiles']} tiles ({r['two_level_tiles']} two-level) deck {r['deck']} under {r['under']} "
              f"{r['under_level']}: Pearl under {r['pearl_under']} deck {r['pearl_deck']} | converted under "
              f"{r['converted_under']} deck {r['converted_deck']} | before under {r['before_under']} "
              f"deck {r['before_deck']} | surf under: Pearl {r['pearl_surf_under']} converted {r['converted_surf_under']} "
              f"before {r['before_surf_under']} | GC {r['gc']}{flag}")
        for m in r['step_mismatches'][:6] + r['reach_mismatches'][:6]:
            print('      ', m)
        n_bad += bool(flag)
    print(f'{len(report)} bridges, {n_bad} with mismatches')
    if '--json' in sys.argv:
        json.dump({'route215': r215, 'bridges': report}, open(sys.argv[sys.argv.index('--json') + 1], 'w'),
                  indent=1, default=list)


if __name__ == '__main__':
    main()
