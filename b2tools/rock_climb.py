"""Pearl's Rock Climb walls, world-wide (notes/TMS.md "Defog and Rock Climb as field moves"), offline.

    python3 b2tools/rock_climb.py               every wall: its zone, tiles, way, length, Pearl's heights at its foot
                                                and top, what the converted map has there now
    python3 b2tools/rock_climb.py --json OUT    the same as JSON (one row per wall)
    python3 b2tools/rock_climb.py --write       data/pearl_rock_climb.json: where each climb starts and its moves (the
                                                story's sign events and UseRockClimb read it)

Pearl (pokediamond ov05 MetatileBehavior_IsRockClimbInDirection, pokeplatinum map_tile_behavior.c): a tile with
behaviour 0x4B (ROCK_CLIMB_N_S) is climbed facing up or down, 0x4C (ROCK_CLIMB_E_W) facing left or right; the field
move check (field_move.c FieldMove_CheckFacing...) offers Rock Climb when the tile in front has the behaviour for the
way the player faces, and the climb carries the player across every such tile in a row. A wall here is one
4-connected group of such tiles in one zone's map; its "lanes" are the rows (E/W) or columns (N/S) across it.
Black 2 has neither the behaviour nor the move (TM120 teaches Rock Climb: notes/TMS.md "Built").
"""
import collections, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
os.environ.setdefault('MAP_FIXES', 'none')
import bridge_check  # noqa: E402  (its Grid: Pearl's and the converted tiles of one zone map, by global tile)

CLIMB_NS, CLIMB_EW = 0x4B, 0x4C
CLIMB = {CLIMB_NS: 'N/S', CLIMB_EW: 'E/W'}


def maps():
    """[(Grid, zone name by chunk cell)] of the overworld and every room map (as bridge_check)."""
    world = bridge_check._json(ROOT, 'data', 'sinnoh_world.json')
    zones = bridge_check._json(bridge_check.PEARL, 'zones.json')
    m0 = bridge_check._json(bridge_check.PEARL, 'matrices', '000.json')
    names0 = {(cx, cz): zones[h]['name'] for cz, row in enumerate(m0['headers']) for cx, h in enumerate(row)
              if h < len(zones)}
    out = [bridge_check.Grid(0, True, names0)]
    by_matrix = collections.defaultdict(list)
    for pid, r in world['rooms']['zones'].items():
        by_matrix[r['pearl_matrix']].append(r['name'])
    for mid, nm in sorted(by_matrix.items()):
        m = bridge_check._json(bridge_check.PEARL, 'matrices', f'{mid:03d}.json')
        names = {(cx, cz): '/'.join(sorted(nm)) for cz, row in enumerate(m['maps']) for cx, c in enumerate(row)}
        out.append(bridge_check.Grid(mid, False, names))
    return out


def walls(with_b2=False):
    rows = []
    for g in maps():
        tiles = {}
        for cz, row in enumerate(g.m['maps']):
            for cx, c in enumerate(row):
                if c == 0xffff:
                    continue
                L = g.land(c)
                for tz in range(32):
                    for tx in range(32):
                        b = L['behaviour'][tz][tx]
                        if b in CLIMB:
                            tiles[(cx * 32 + tx, cz * 32 + tz)] = b
        seen = set()
        for t in sorted(tiles, key=lambda p: (p[1], p[0])):
            if t in seen:
                continue
            group, todo = [], [t]
            seen.add(t)
            while todo:                                    # 4-connected, same behaviour
                p = todo.pop()
                group.append(p)
                for dx, dz in bridge_check.DIRS:
                    q = (p[0] + dx, p[1] + dz)
                    if q in tiles and q not in seen and tiles[q] == tiles[t]:
                        seen.add(q); todo.append(q)
            rows.append(_wall(g, tiles[t], sorted(group, key=lambda p: (p[1], p[0])), with_b2))
    return rows


def _wall(g, beh, group, with_b2):
    xs, zs = [p[0] for p in group], [p[1] for p in group]
    ns = beh == CLIMB_NS
    lanes = collections.defaultdict(list)                  # N/S: columns (by x); E/W: rows (by z)
    for x, z in group:
        lanes[x if ns else z].append(z if ns else x)
    lane_rows = []
    for k, along in sorted(lanes.items()):
        lo, hi = min(along), max(along)
        before = (k, lo - 1) if ns else (lo - 1, k)        # the foot/top tiles at the two ends of the lane
        after = (k, hi + 1) if ns else (hi + 1, k)
        pb, pa = g.pearl(*before), g.pearl(*after)
        lane_rows.append({'lane': k, 'from': lo, 'to': hi, 'gaps': hi - lo + 1 - len(along),
                          'end_lo': {'tile': before, 'collision': pb and pb[0], 'behaviour': pb and pb[1],
                                     'heights': pb and pb[2]},
                          'end_hi': {'tile': after, 'collision': pa and pa[0], 'behaviour': pa and pa[1],
                                     'heights': pa and pa[2]}})
    cells = {(x // 32, z // 32) for x, z in group}
    zone = sorted({g.names.get(c, '?') for c in cells})
    coll = collections.Counter(g.pearl(x, z)[0] for x, z in group)
    row = {'matrix': g.mid, 'zone': zone, 'way': CLIMB[beh], 'tiles': len(group), 'box': [min(xs), min(zs), max(xs), max(zs)],
           'length': (max(zs) - min(zs) + 1) if ns else (max(xs) - min(xs) + 1), 'lanes': lane_rows,
           'pearl_collision': dict(coll)}
    if with_b2:
        b2 = collections.Counter()
        for x, z in group:
            layers = g.b2(x, z)
            b2['none' if not layers else ('wall' if all(f & 0x8000 or c == 0xff for _, c, f in layers) else 'walkable')] += 1
        row['b2'] = dict(b2)
    return row


# Pearl's climb (pokeplatinum ov5_021DFB54.c FieldTask_StartUseRockClimb, the same in Pearl): the cut-in, then a hop
# onto the first climb tile (JUMP_NEAR_FAST: 1 tile in 8 frames), a fast walk (1 tile in 4 frames) at once, more fast
# walks while the tile ahead is a climb tile, and a hop off: L + 1 tiles for a wall L tiles long, 3 for a 1-tile wall.
JUMP_NEAR_FAST = {0: 0x34, 1: 0x35, 2: 0x36, 3: 0x37}     # by direction: 0 up (north), 1 down, 2 left (west), 3 right
WALK_FAST = {0: 0x10, 1: 0x11, 2: 0x12, 3: 0x13}
STEP = {0: (0, -1), 1: (0, 1), 2: (-1, 0), 3: (1, 0)}
JSON = os.path.join(ROOT, 'data', 'pearl_rock_climb.json')


def ends(rows):
    """{zone: [end]}: where the player can start a climb, as Pearl allows it: standing on the walkable tile at a lane's
    end, facing along the lane; an end whose landing tile is not walkable in Pearl is left out (listed). Each end:
    stand (x, z), dir (the player's facing), bg (the first climb tile: the sign event Black 2 reads there), moves
    [(code, count)] (Pearl's codes, the same in Black 2), land (x, z)."""
    out, left = collections.defaultdict(list), []
    by_matrix = {g.mid: g for g in maps()}
    for r in rows:
        assert len(r['zone']) == 1, f'a wall across zones: {r}'
        g = by_matrix[r['matrix']]
        ns = r['way'] == 'N/S'
        for lane in r['lanes']:
            length = lane['to'] - lane['from'] + 1
            for end, d in (('end_lo', 1 if ns else 3), ('end_hi', 0 if ns else 2)):
                sx, sz = lane[end]['tile']
                dx, dz = STEP[d]
                hops = max(length + 1, 3)
                land = (sx + dx * hops, sz + dz * hops)
                ps, pl = g.pearl(sx, sz), g.pearl(*land)
                row = {'stand': [sx, sz], 'dir': d, 'bg': [sx + dx, sz + dz], 'length': length,
                       'moves': [[JUMP_NEAR_FAST[d], 1], [WALK_FAST[d], max(length - 1, 1)], [JUMP_NEAR_FAST[d], 1]],
                       'land': list(land)}
                if not ps or ps[0] or not ps[2] or not pl or pl[0] or not pl[2]:
                    left.append((r['zone'][0], row, 'the start or the landing is not walkable in Pearl'))
                    continue
                out[r['zone'][0]].append(row)
    return out, left


def write():
    rows = walls()
    data, left = ends(rows)
    doc = ('Pearl\'s Rock Climb walls (b2tools/rock_climb.py --write; notes/TMS.md): per Pearl zone, every place a climb '
           'starts: stand (the tile the player stands on), dir (the facing: 0 up, 1 down, 2 left, 3 right), bg (the '
           'climb tile in front: pearl_events puts a sign event there, read facing dir, running Pearl\'s global script '
           '10003 "the wall is very rocky... use Rock Climb?"), moves (Pearl\'s hop, fast walks, hop: pearl_story '
           'UseRockClimb), land (where the climb ends). Left out (start or landing not walkable in Pearl): ' +
           '; '.join(f'{z} {r["stand"]} dir {r["dir"]}' for z, r, _ in left))
    json.dump(dict({'_doc': doc}, **{z: data[z] for z in sorted(data)}), open(JSON, 'w'), indent=1)
    return f'{sum(len(v) for v in data.values())} climb starts in {len(data)} zones ({len(rows)} walls); left out {len(left)}'


def main():
    if '--write' in sys.argv:
        print(write())
        return
    rows = walls(with_b2='--b2' in sys.argv)
    by_zone = collections.defaultdict(list)
    for r in rows:
        by_zone[' / '.join(r['zone'])].append(r)
    print(f'Rock Climb walls: {len(rows)} in {len(by_zone)} zones, {sum(r["tiles"] for r in rows)} tiles\n')
    print('| Zone | Matrix | Way | Box (x0,z0)-(x1,z1) | Length | Lanes | Pearl collision | Heights low end -> high end |'
          + (' Black 2 now |' if '--b2' in sys.argv else ''))
    print('|---|---|---|---|---|---|---|---|' + ('---|' if '--b2' in sys.argv else ''))
    for z, rs in sorted(by_zone.items()):
        for r in rs:
            l0 = r['lanes'][0]
            h = f'{l0["end_lo"]["heights"]} -> {l0["end_hi"]["heights"]}'
            print(f'| {z} | {r["matrix"]} | {r["way"]} | {tuple(r["box"][:2])}-{tuple(r["box"][2:])} | {r["length"]} | '
                  f'{len(r["lanes"])} | {r["pearl_collision"]} | {h} |' + (f' {r.get("b2")} |' if '--b2' in sys.argv else ''))
    if '--json' in sys.argv:
        out = sys.argv[sys.argv.index('--json') + 1]
        json.dump(rows, open(out, 'w'), indent=1, default=list)
        print('wrote', out)


if __name__ == '__main__':
    main()
