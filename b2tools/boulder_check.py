"""Sinnoh's Strength boulders: Pearl's pushes on Pearl's data against Black 2's on the converted chunks.

    python3 b2tools/boulder_check.py                 every boulder zone (Pearl graphics id 84: 55 boulders, 13 zones)
    python3 b2tools/boulder_check.py --zone NAME     one zone (Pearl name, e.g. MAP_MOUNT_CORONET_NORTH_1F_ROOM_1)
    python3 b2tools/boulder_check.py --json OUT      the table as JSON too

Three rule sets, each a search over the boulders' positions and where the player can walk:
- pearl: Pearl's own rules on Pearl's map (pokeplatinum, which Pearl shares here). The player pushes when walking
  into a boulder (graphics 0x54) with Strength on (ov5_021DFF1C); the push needs the boulder's next tile free by the
  map-object collision check with the walk-range bit ignored (map_object_move.c sub_02063EBC & ~1): Pearl's map
  collision and a step of 20 units or more (TerrainCollisionManager_WillMapObjectCollide), the one-way tiles
  (sub_02064004: BlocksMovement* of the tile left / entered) and any object on the tile (sub_02063F00). The boulder
  slides one tile; the player walks on the spot.
- b2: Black 2's rules (pokebw2 ov036 field_player_grid_event.c FieldPlayerGrid_CheckStrengthRockPushEvent,
  StrengthRockSpaceCheck; ov012 field_actor_tool.c ActorRouteCollCheckCore) on the converted chunks
  (pearl_chunk.convert as sinnoh_world / sinnoh_rooms call it, Pearl's signs solid), with Pearl's boulder as code
  109's 1 x 1 footprint: every footprint tile one on must be a valid tile without the wall flag and no Strength
  hole, the tile left / entered must not block the way (TileExitBlockCheck_*), the new tile within 20 units, no
  actor's footprint there.
- b2_2x2: the same with Black 2's own 3D boulder (8197: collWidth/Height 2, the tile, x+1 and z-1), as built before.
The player's walk is bridge_check's (Pearl's nearest plate / Black 2's nearest layer, 20 units, walls, signs; Surf
on water, no waterfalls) plus jumps down ledges and the one-way tiles, and is blocked by the boulders' footprints and the zone's other
standing objects (hide flag 0: trainers, people; objects with a hide flag go away in the story and are left out).
Rock Smash rocks and Cut trees are left out too: Strength comes after both HMs. The player starts on every warp of
the zone (and, on the overworld, on every walkable tile at the zone's edge).

Search: boulders near each other (3 tiles) form a group; each group is searched over (its boulders' positions, the
player's walkable region) with the other groups' boulders where they stand, starting from every tile reached so far;
the groups are searched again until nothing new is reached. Per zone it reports, for each rule set, the tiles the
player reaches, the pushes made (boulder, tile, direction) and the tiles each boulder reaches, and what Pearl
reaches that the converted rules do not (b2 must reach everything Pearl reaches: "ok").
"""
import collections, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
os.environ.setdefault('MAP_FIXES', 'none')
import bridge_check as bc  # noqa: E402

PEARL = bc.PEARL
BOULDER_GFX = 84
REMOVABLE = {85, 86}                       # Rock Smash rock, Cut tree
N, S, W, E = (0, -1), (0, 1), (-1, 0), (1, 0)
DIRS = (N, S, W, E)
DNAME = {N: 'N', S: 'S', W: 'W', E: 'E'}
STEP = bc.STEP
OBJ_DY = 16                                # objects block within one level (Pearl |dy| < 2 half-levels, Black 2 < 1)
# Pearl's one-way tiles (pokeplatinum map_tile_behavior.c TileBehavior_BlocksMovement*): leaving a tile that blocks
# way d, or entering one that blocks the opposite way, is refused
PEARL_BLOCKS = {N: {0x32, 0x34, 0x35, 0x49}, S: {0x33, 0x36, 0x37, 0x49}, W: {0x31, 0x35, 0x37, 0x4a},
                E: {0x30, 0x34, 0x36, 0x4a}}
# Black 2's (ov036 map_attr.c TileExitBlockCheck_*, ov012 TILE_EXIT / TILE_ENTER_BLOCK_CHECKS)
B2_BLOCKS = {N: {0x53, 0x55, 0x56}, S: {0x54, 0x57, 0x58}, W: {0x52, 0x56, 0x58}, E: {0x51, 0x55, 0x57}}
OPP = {N: S, S: N, W: E, E: W}
PEARL_JUMP = {0x38: E, 0x39: W, 0x3a: N, 0x3b: S}
B2_JUMP = {0x72: E, 0x73: W, 0x74: N, 0x75: S}     # pearl_chunk.BEHAVIOURS: Pearl's JUMP_* -> these classes
B2_HOLE = 0x1d                             # ov036 MapTile_IsStrengthHole
GROUP_GAP = 3
STATE_CAP = 300000


def _json(*p):
    return json.load(open(os.path.join(*p)))


class Rules:
    """One rule set on one zone map: tiles, the player's step, the boulder's push."""

    def __init__(self, kind, g):
        self.kind, self.g = kind, g
        self.size = (2, 2) if kind == 'b2_2x2' else (1, 1)
        self._level, self._move, self._slide = {}, {}, {}

    # --- tiles
    def level(self, x, z, y):
        """(height, attrs) of the level the tile offers nearest y, or None. Pearl attrs (coll, beh); Black 2's
        (class, flags)."""
        key = (x, z, y)
        if key not in self._level:
            if self.kind == 'pearl':
                t = self.g.pearl(x, z)
                r = None if t is None or not t[2] else (min(t[2], key=lambda h: abs(h - y)), (t[0], t[1]))
            else:
                t = self.g.b2(x, z)
                if not t: r = None
                else:
                    i = min(range(len(t)), key=lambda i: (abs(t[i][0] - y), i))
                    r = t[i][0], (t[i][1], t[i][2])
            self._level[key] = r
        return self._level[key]

    def blocks(self, attrs, d, leaving):
        """Whether a one-way tile stops a move in way d (leaving it, or entering it)."""
        way = d if leaving else OPP[d]
        if self.kind == 'pearl': return attrs[1] in PEARL_BLOCKS[way]
        return attrs[0] in B2_BLOCKS[way]

    def on_water(self, st):
        lv = self.level(*st)
        if lv is None: return False
        if self.kind == 'pearl': return lv[1][1] in bc.SURFABLE and lv[1][1] not in bc.OVER_WATER
        return bool(lv[1][1] & 2)

    def solid(self, attrs):
        if self.kind == 'pearl': return bool(attrs[0])
        return bool(attrs[1] & 1)

    # --- the player
    def move(self, st, d):
        """The player's step from st = (x, z, y) on the map alone (no actors): the new state or None."""
        key = (st, d)
        if key in self._move: return self._move[key]
        x, z, y = st
        here = self.level(x, z, y)
        nx, nz = x + d[0], z + d[1]
        nxt = self.level(nx, nz, y)
        r = None
        if here is not None and nxt is not None:
            jump = PEARL_JUMP if self.kind == 'pearl' else B2_JUMP
            key2 = nxt[1][1] if self.kind == 'pearl' else nxt[1][0]
            if key2 in jump:                       # a ledge: down it in its way, two tiles on; a wall otherwise
                if jump[key2] == d:
                    lx, lz = nx + d[0], nz + d[1]
                    land = self.level(lx, lz, y)
                    if land is not None and not self.solid(land[1]) and not self.on_water((lx, lz, land[0])):
                        r = (lx, lz, round(land[0]))
            elif not (self.blocks(here[1], d, True) or self.blocks(nxt[1], d, False)):
                if self.kind == 'pearl':
                    if nxt[1][1] != 0x13:                  # (a waterfall: another HM)
                        water = nxt[1][1] in bc.SURFABLE and nxt[1][1] not in bc.OVER_WATER
                        r = (bc.pearl_surf if water else bc.pearl_step)(self.g, (x, z, y, False), d)
                else:
                    r = (bc.b2_surf if nxt[1][1] & 2 else bc.b2_step)(self.g, (x, z, y), d)
                r = None if r is None or isinstance(r, str) else (nx, nz, round(r[2]))
        self._move[key] = r
        return r

    def step(self, st, d, occupied):
        """The player's step from st: the new state or None. occupied(x, z, y) -> blocked by an actor."""
        r = self.move(st, d)
        return None if r is None or occupied(*r) else r

    # --- the boulder
    def footprint(self, x, z):
        w, h = self.size
        return [(x + i, z - j) for j in range(h) for i in range(w)]

    def slide(self, b, d):
        """The boulder b = (x, z, y) pushed one tile in way d on the map alone: the new (x, z, y) or the reason."""
        key = (b, d)
        if key in self._slide: return self._slide[key]
        x, z, y = b
        nx, nz = x + d[0], z + d[1]
        here, nxt = self.level(x, z, y), self.level(nx, nz, y)
        if self.kind == 'pearl':
            if nxt is None: r = 'edge'
            elif abs(nxt[0] - y) >= STEP: r = 'height'
            elif self.solid(nxt[1]): r = 'wall'
            elif self.blocks(here[1], d, True) or self.blocks(nxt[1], d, False): r = 'one-way'
            else: r = (nx, nz, round(nxt[0]))
        else:                                      # StrengthRockSpaceCheck + ActorRouteCollCheckCore, anchor one on
            r = None
            for tx, tz in self.footprint(nx, nz):
                t = self.level(tx, tz, y)
                if t is None: r = 'edge'
                elif t[1][0] == B2_HOLE: r = 'hole'
                elif self.solid(t[1]): r = 'wall'
                if r: break
            if r is None:
                if self.blocks(here[1], d, True) or self.blocks(nxt[1], d, False): r = 'one-way'
                elif abs(nxt[0] - y) >= STEP: r = 'height'
                else: r = (nx, nz, round(nxt[0]))
        self._slide[key] = r
        return r

    def push(self, b, d, occupied):
        """The boulder pushed with the actors: the new (x, z, y) or the reason it doesn't move. occupied(x, z, y)
        -> another actor's footprint is there."""
        r = self.slide(b, d)
        if isinstance(r, str): return r
        if any(occupied(tx, tz, r[2]) for tx, tz in self.footprint(r[0], r[1])): return 'object'
        return r


class Zone:
    """A Pearl zone with boulders: its map (bridge_check.Grid), window, objects, boulders and start tiles."""

    def __init__(self, zone, zones, world):
        self.zone, self.name = zone, zone['name']
        ev = _json(PEARL, 'events', f'{zone["events"]:03d}.json')
        mid = zone['matrix']
        self.overworld = mid == 0
        m = _json(PEARL, 'matrices', f'{mid:03d}.json')
        if self.overworld:
            names = {(cx, cz): zones[h]['name'] for cz, row in enumerate(m['headers']) for cx, h in enumerate(row)
                     if h < len(zones)}
            cells = [c for c, n in names.items() if n == self.name]
        else:
            names = {(cx, cz): self.name for cz, row in enumerate(m['maps']) for cx, c in enumerate(row)}
            cells = [(cx, cz) for cz, row in enumerate(m['maps']) for cx, c in enumerate(row) if c != 0xffff]
        self.g = bc.Grid(mid, self.overworld, names)
        self.cells = set(cells)
        xs = [cx for cx, _ in cells]; zs = [cz for _, cz in cells]
        self.window = (min(xs) * 32, max(xs) * 32 + 31, min(zs) * 32, max(zs) * 32 + 31)
        self.boulders = [o for o in ev['object_events'] if o['graphics_id'] == BOULDER_GFX]
        import pearl_events
        self.objects = [o for o in ev['object_events'] if o['graphics_id'] != BOULDER_GFX
                        and o['graphics_id'] not in REMOVABLE and not pearl_events.is_sign(o)
                        and o['hidden_flag'] == 0 and o['script'] != 0xFFFF]
        self.warps = [(w['x'], w['z']) for w in ev['warp_events']]

    def inside(self, x, z):
        x0, x1, z0, z1 = self.window
        return x0 <= x <= x1 and z0 <= z <= z1 and (x // 32, z // 32) in self.cells


def heights_at(rules, x, z, y_pearl):
    lv = rules.level(x, z, y_pearl)
    return None if lv is None else round(lv[0])


def seeds(zone, rules):
    """Start states (x, z, y) by start: each warp (its tile, or its walkable neighbours, at each of its levels) and,
    on the overworld, 'edge' (every walkable tile at the zone's edge)."""
    starts = {w: {w} | {(w[0] + dx, w[1] + dz) for dx, dz in DIRS} for w in zone.warps}
    if zone.overworld:
        x0, x1, z0, z1 = zone.window
        starts['edge'] = {(x, z) for x in range(x0, x1 + 1) for z in range(z0, z1 + 1)
                          if zone.inside(x, z) and any(not zone.inside(x + dx, z + dz) for dx, dz in DIRS)}
    out = {}
    for name, tiles in starts.items():
        got = set()
        for x, z in tiles:
            if not zone.inside(x, z): continue
            t = zone.g.pearl(x, z)
            if t is None or t[0] or not t[2] or t[1] in bc.SURFABLE: continue
            for y in bc.pearl_levels(t[2]):
                if rules.kind == 'pearl':
                    got.add((x, z, round(y)))
                else:
                    lv = rules.level(x, z, y)
                    if lv and abs(lv[0] - y) <= bc.SAME and not rules.solid(lv[1]) and not lv[1][1] & 2:
                        got.add((x, z, round(lv[0])))
        out[name] = got
    return out


def seeds_tiles(zone):
    """{start: tiles} that count as reaching that start."""
    out = {w: {w} | {(w[0] + dx, w[1] + dz) for dx, dz in DIRS} for w in zone.warps}
    if zone.overworld:
        x0, x1, z0, z1 = zone.window
        out['edge'] = {(x, z) for x in range(x0, x1 + 1) for z in range(z0, z1 + 1)
                       if zone.inside(x, z) and any(not zone.inside(x + dx, z + dz) for dx, dz in DIRS)}
    return out


def groups(boulders):
    """Boulders within GROUP_GAP tiles of each other, transitively: [[index]]."""
    left, out = set(range(len(boulders))), []
    while left:
        i = min(left); left.discard(i); grp, todo = [i], [i]
        while todo:
            a = boulders[todo.pop()]
            for j in sorted(left):
                b = boulders[j]
                if max(abs(a['x'] - b['x']), abs(a['z'] - b['z'])) <= GROUP_GAP:
                    left.discard(j); grp.append(j); todo.append(j)
        out.append(sorted(grp))
    return out


def search(zone, rules, start_states):
    """From start_states: {'reach': tiles, 'pushes': {(boulder id, x, z, way)}, 'moves': {boulder id: tiles}, 'refused': ..., 'capped'}"""
    static = collections.defaultdict(list)
    for o in zone.objects:
        h = heights_at(rules, o['x'], o['z'], o['y'] * 16)
        if h is not None: static[(o['x'], o['z'])].append(h)
    start = []
    for o in zone.boulders:
        h = heights_at(rules, o['x'], o['z'], o['y'] * 16)
        start.append((o['x'], o['z'], h if h is not None else o['y'] * 16))
    grps = groups(zone.boulders)
    reach, pushes, moves, refused = set(), set(), collections.defaultdict(set), collections.Counter()
    for i, b in enumerate(start): moves[zone.boulders[i]['id']].add(b[:2])
    capped, stats = False, []
    frontier = set(start_states)
    for _round in range(8):
        grew = False
        for grp in grps:
            fixed = [start[i] for i in range(len(start)) if i not in grp]

            def occupied_by(pos, skip=None):
                cover = {}
                for k, b in enumerate(pos):
                    if k == skip: continue
                    for t in rules.footprint(b[0], b[1]): cover.setdefault(t, []).append(b[2])
                for b in fixed:
                    for t in rules.footprint(b[0], b[1]): cover.setdefault(t, []).append(b[2])

                def occ(x, z, y):
                    return any(abs(h - y) < OBJ_DY for h in cover.get((x, z), ())) or \
                        any(abs(h - y) < OBJ_DY for h in static.get((x, z), ()))
                return occ

            def region(pos, p):
                occ = occupied_by(pos)
                seen = {p}; todo = [p]
                while todo:
                    s = todo.pop()
                    for d in DIRS:
                        n = rules.step(s, d, occ)
                        if n is None or n in seen or not zone.inside(n[0], n[1]): continue
                        seen.add(n); todo.append(n)
                return seen

            pos0 = tuple(start[i] for i in grp)
            occ0, covered, todo = occupied_by(pos0), set(), collections.deque()
            for s in sorted(frontier):               # one start per region of the tiles reached so far
                if s in covered or occ0(*s): continue
                covered |= region(pos0, s)
                todo.append((pos0, s))
            seen = set()
            n_states = 0
            while todo:
                pos, p = todo.popleft()
                if occupied_by(pos)(*p): continue
                reg = region(pos, p)
                key = (pos, min(reg))
                if key in seen: continue
                seen.add(key)
                n_states += 1
                if n_states > STATE_CAP:
                    capped = True; break
                for s in reg:
                    if s[:2] not in reach: reach.add(s[:2]); grew = True
                    frontier.add(s)
                for s in reg:
                    if rules.on_water(s): continue           # (pushing is on foot)
                    for d in DIRS:
                        fx, fz = s[0] + d[0], s[1] + d[1]
                        for k, b in enumerate(pos):
                            if (fx, fz) not in rules.footprint(b[0], b[1]) or abs(b[2] - s[2]) >= OBJ_DY: continue
                            r = rules.push(b, d, occupied_by(pos, skip=k))
                            bid = zone.boulders[grp[k]]['id']
                            if isinstance(r, str):
                                refused[(bid, b[0], b[1], DNAME[d], r)] += 1
                                continue
                            if not zone.inside(r[0], r[1]): continue
                            pushes.add((bid, b[0], b[1], DNAME[d]))
                            if r[:2] not in moves[bid]: grew = True
                            moves[bid].add(r[:2])
                            todo.append((pos[:k] + (r,) + pos[k + 1:], s))
            stats.append((len(grp), n_states))
        if not grew: break
    print(f'  {zone.name} {rules.kind}: groups (boulders, states) {stats}', file=sys.stderr, flush=True)
    return dict(reach=reach, pushes=pushes, moves={k: sorted(v) for k, v in moves.items()},
                refused={k: v for k, v in refused.items()}, capped=capped)


def check_zone(zone):
    out, links = {}, {}
    for kind in ('pearl', 'b2', 'b2_2x2'):
        rules = Rules(kind, zone.g)
        st = seeds(zone, rules)
        out[kind] = search(zone, rules, set().union(*st.values()))
        # which starts lead where: from each start alone, the warps (and the edge) reached
        links[kind] = {}
        for name, states in st.items():
            r = search(zone, rules, states)['reach'] if states else set()
            links[kind][str(name)] = sorted(str(w) for w, t in seeds_tiles(zone).items() if t & r)
    p, b, o = out['pearl'], out['b2'], out['b2_2x2']
    row = dict(zone=zone.name, boulders=[(x['id'], x['x'], x['z']) for x in zone.boulders],
               reach={k: len(v['reach']) for k, v in out.items()},
               pearl_not_b2=sorted(p['reach'] - b['reach']), b2_not_pearl=sorted(b['reach'] - p['reach']),
               pearl_not_2x2=sorted(p['reach'] - o['reach']),
               pushes_pearl_not_b2=sorted(p['pushes'] - b['pushes']),
               pushes_b2_not_pearl=sorted(b['pushes'] - p['pushes']),
               pushes_pearl_not_2x2=sorted(p['pushes'] - o['pushes']),
               moves={k: dict(pearl=p['moves'][k], b2=b['moves'][k], b2_2x2=o['moves'][k]) for k in p['moves']},
               capped={k: v['capped'] for k, v in out.items()}, links=links)
    row['ok'] = not row['pearl_not_b2'] and not row['pushes_pearl_not_b2'] and not any(row['capped'].values()) \
        and all(set(v) <= set(links['b2'].get(k, ())) for k, v in links['pearl'].items())
    row['refused_b2'] = sorted(k for k in b['refused'] if k[:4] in set(row['pushes_pearl_not_b2']))
    return row


def main():
    zones = _json(PEARL, 'zones.json')
    world = _json(ROOT, 'data', 'sinnoh_world.json')
    only = sys.argv[sys.argv.index('--zone') + 1] if '--zone' in sys.argv else None
    rows = []
    for z in zones:
        ev = _json(PEARL, 'events', f'{z["events"]:03d}.json')
        if not any(o['graphics_id'] == BOULDER_GFX for o in ev['object_events']): continue
        if only and z['name'] != only: continue
        zone = Zone(z, zones, world)
        row = check_zone(zone)
        rows.append(row)
        print(f"{'ok ' if row['ok'] else 'BAD'} {row['zone']}: {len(row['boulders'])} boulders; tiles reached "
              f"Pearl {row['reach']['pearl']}, 1x1 {row['reach']['b2']}, 2x2 {row['reach']['b2_2x2']}; boulders Pearl moves "
              f"{sum(len(v['pearl']) > 1 for v in row['moves'].values())}", flush=True)
        for kind in ('pearl', 'b2', 'b2_2x2'):
            print(f"    {kind:7s} from each start, the starts reached: "
                  + '; '.join(f"{k} -> {len(v)}" + ('' if kind == 'pearl' or v == row['links']['pearl'][k]
                                                    else f" {sorted(set(row['links']['pearl'][k]) - set(v))} lost")
                              for k, v in row['links'][kind].items()))
        for k in ('pearl_not_b2', 'pushes_pearl_not_b2', 'refused_b2', 'pearl_not_2x2', 'pushes_pearl_not_2x2',
                  'pushes_b2_not_pearl', 'b2_not_pearl'):
            if row[k]: print(f'    {k} ({len(row[k])}): {row[k][:12]}')
    n = sum(len(r['boulders']) for r in rows)
    print(f"{len(rows)} zones, {n} boulders: {sum(r['ok'] for r in rows)} zones ok")
    if '--json' in sys.argv:
        json.dump(rows, open(sys.argv[sys.argv.index('--json') + 1], 'w'), indent=1, default=list)


if __name__ == '__main__':
    main()
