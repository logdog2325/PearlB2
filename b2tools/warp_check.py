"""Warp glitch check (HoennB2 lessons 1-3; user 2026-10-19: "do a careful glitch check").

    python3 b2tools/warp_check.py [FILES_DIR | offline] [--accepted]
        FILES_DIR: a build's files/ (default work/rom_lead/files): the warps the ROM got (zone headers, a/1/2/6);
        offline:   the warps patches/sinnoh_events.py would write now (no ROM needed; same records)

For every installed Sinnoh zone, from the warps and Pearl's collision (work/pearl/land: the converted maps keep Pearl's
tiles; the overworld's entrance mats are made solid by pearl_chunk, as bump warps; a stairs warp sits on the solid
flight beyond Pearl's stairs tile, whose foot stays walkable: sinnoh_events STAIRS_ON_FLIGHT):
- stack   several warps on one tile: Black 2 fires only the first
- walk    a door/stairs/cave warp (type 2-4) on a walkable tile: Black 2 fires these only when walking INTO a solid tile
- mat     an exit mat (type 1) on a solid tile: the player can't stand on it
- plain   a warp on a plain walkable tile beside a wall (no warp behaviour: Pearl never fires it; Black 2 fires a type-1
          warp when the player standing on it bumps into anything)
- arrive  where an arriving player is stepped to (the destination warp's tile, then one tile by its dir: 0/1 north,
          2 south, 3 west, 4 east, HoennB2's measurement; a type-1 mat: the tile itself) is not walkable floor
- dest    a warp to a zone or warp index that doesn't exist (dest warp 0x100 = Black 2's saved "next zone" spot, the
          shared Pokémon Center 2F's way back down: fine)

    python3 b2tools/warp_check.py heights [--all]
- heights (offline, 2026-10-26): every warp's recorded height vs the floor the built map has where the player stands
          when it fires (a mat, panel or step-on warp: its own tile; a door, stairs or bump warp: the tile it is walked
          into from), converting each chunk as sinnoh_world / sinnoh_rooms do (pearl_chunk.convert: a few minutes).
          Black 2 fires a warp only when the player's height (>> 12, whole units) is within 2 of the record's
          (ov012 CheckWarpPositionMatch). Lists each warp off by more than 2 with the height sinnoh_events records now
          (from work/world's heights, the last build's) and with the converter's heights of this run; --all also
          lists the matching ones' count per zone.
Findings in zones (or from warps) no player can reach are listed as accepted (reachability: from Twinleaf and the
player's room, through every warp whose tile can be walked to from an arrival, and every Warp of Pearl's scripts;
overworld doors count as reachable), as are the ACCEPT entries below. One line per finding; a summary by kind at the
end; --accepted also prints the accepted lines with their reasons.
"""
import collections, json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from patches import sinnoh_events  # noqa: E402
pearl_chunk_ENTRANCES = sinnoh_events.pearl_chunk.ENTRANCES

STEP = {0: (0, -1), 1: (0, -1), 2: (0, 1), 3: (-1, 0), 4: (1, 0)}
OFF_MAP = 0x7FF0                                       # sinnoh_events moves warps to rooms not installed off the map
WARP_BEHAVIOURS = sinnoh_events.pearl_chunk.STAIRS | sinnoh_events.pearl_chunk.ENTRANCES | {0x69} | set(range(0x60, 0x70))

# (zone name regex, kind, finding regex, reason): checked and left on purpose
ACCEPT = [
    ('VERITY_LAKEFRONT', 'arrive', r'script Warp lands on \(81, 842\)',
     "Lake Verity's scene (Pearl file 342) warps the player back onto the lake entrance: Pearl's mat, which pearl_chunk "
     "makes a solid bump warp on the overworld; Black 2 puts the player on it and the next step leaves (Chapter 1, "
     "played in game 2026-10-18 and 2026-10-20)"),
    ('(VERITY|VALOR|ACUITY)_LAKEFRONT', 'stack', r'',
     "Pearl's story versions of the lake (normal / Galactic): its map script (zone init, pl_SetWarpEventPos) moves the "
     "unused pair onto a wall tile north of the entrance (z 840 / 760 / 235), out of reach; only the active pair stays"),
    ('ROUTE_214', 'stack', r'\(713, 670\)',
     "the Ruin Maniac cave's three stages: Route 214's map script moves two of warps 2-4 to (710, 670) by the Unown "
     "seen (Pearl's own switch; Chapter 5)"),
    ('VALOR_CAVERN', 'stack', r'\(14, 29\)',
     "the way out to Lake Valor or Lake Valor (Galactic): the cavern's map script moves one of the two to (10, 29) "
     "(Pearl's own switch)"),
    ('TURNBACK_CAVE', 'stack', r'\((11, 1|20, 11|11, 20|2, 11)\)',
     "Turnback Cave's maze (b2tools/turnback.py): each door holds Pearl's warp back to the entrance and a copy per "
     "destination; the map script after each arrival parks the warps before the one Pearl's InitTurnbackCave picks"),
]


class Warps:
    """Warps of every installed zone and Black 2's collision of its tiles."""

    def __init__(self, files):
        self.pl = pl = sinnoh_events.Planner()
        self.zones, self.b2_of = pl.zones, pl.b2_of
        self.pid_of = {b2: pid for pid, b2 in pl.b2_of.items()}
        self.warps = {}
        if files == 'offline':
            for pid, b2 in pl.b2_of.items():
                self.warps[b2] = pl.warps(pid)[0]
        else:
            import narcio, zoneheaders
            from zones import parse_entities
            headers, _ = zoneheaders.load(files)
            ents = narcio.load(files, 126)
            for b2, pid in self.pid_of.items():
                try:
                    e, _ = parse_entities(ents[headers[b2]['entities']])
                except Exception as ex:                    # noqa: BLE001
                    print(f'{self.name(b2)}: entities unreadable ({ex})'); continue
                self.warps[b2] = [dict(w, x=w['tile_x'] * 16 + 8, z=w['tile_z'] * 16 + 8) for w in e['warps']]

    def name(self, b2):
        return self.zones[self.pid_of[b2]]['name'][4:]

    def tile(self, b2, x, z):
        """(behaviour, solid in Black 2) of tile (x, z) of zone b2, or None off its map."""
        mid = self.zones[self.pid_of[b2]]['matrix']
        t = self.pl.tile(self.pl.matrix(mid), x, z)
        if t is None: return None
        beh, solid = t[0], t[1]
        if beh in sinnoh_events.BUMP_STAIRS or (mid == 0 and beh in sinnoh_events.pearl_chunk.ENTRANCES):
            solid = 1                                   # made solid by the converter (bump warps)
        return beh, solid

    def walkable(self, b2, x, z):
        t = self.tile(b2, x, z)
        return t is not None and not t[1]

    @staticmethod
    def at(w):
        return (w['x'] - 8) // 16, (w['z'] - 8) // 16

    def arrival(self, b2, i):
        """The tile a player arriving at warp i of zone b2 stands on, or None (off the map / no such warp)."""
        ws = self.warps.get(b2)
        if ws is None or not 0 <= i < len(ws): return None
        d = ws[i]
        if d['x'] >= OFF_MAP: return None
        x, z = self.at(d)
        if d['type'] in (0, 1, 5): return x, z          # arriving on a mat or a warp panel: stays on it (walkable)
        sx, sz = STEP.get(d['dir'], (0, 0))
        return x + sx, z + sz

    def usable(self, b2, i, region):
        """Whether warp i of zone b2 can be set off from a tile of region (a set of walkable tiles)."""
        w = self.warps[b2][i]
        if w['x'] >= OFF_MAP: return False
        x, z = self.at(w)
        if w['type'] in (0, 1, 5): return (x, z) in region   # a mat (0: stepped onto, 1: pushed from), a warp panel
        sx, sz = STEP.get(w['dir'], (0, 0))             # walking into it in its dir: from the tile it steps you to
        return (x + sx, z + sz) in region

    def flood(self, b2, starts):
        seen, todo = set(), [s for s in starts if self.walkable(b2, *s)]
        overworld = self.zones[self.pid_of[b2]]['matrix'] == 0
        while todo:
            p = todo.pop()
            if p in seen: continue
            seen.add(p)
            if overworld and len(seen) > 4000: break     # (the overworld: doors count as reachable anyway)
            for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                q = (p[0] + dx, p[1] + dz)
                if q not in seen and self.walkable(b2, *q): todo.append(q)
        return seen

    def reachable(self):
        """({zone: walkable tiles reached}, {(zone, warp index) usable})."""
        script_arrivals = collections.defaultdict(set)
        for f in os.listdir(os.path.join(ROOT, 'work', 'pearl', 'scripts')):
            for m in re.finditer(r'\bWarp (0x[0-9A-F]+|\d+), \w+, (0x[0-9A-F]+|\d+), (0x[0-9A-F]+|\d+), ',
                                 open(os.path.join(ROOT, 'work', 'pearl', 'scripts', f)).read()):
                b2 = self.b2_of.get(int(m.group(1), 0))
                if b2 is not None: script_arrivals[b2].add((int(m.group(2), 0), int(m.group(3), 0)))
        region = collections.defaultdict(set)
        overworld = {b2 for b2, pid in self.pid_of.items() if self.zones[pid]['matrix'] == 0}
        twinleaf_room = self.b2_of[[i for i, z in enumerate(self.zones) if z['name'] == 'MAP_TWINLEAF_RIVAL_HOUSE_2F'][0]]
        starts = collections.defaultdict(set, {twinleaf_room: {(4, 6)}})
        for b2, ps in script_arrivals.items(): starts[b2] |= ps
        self.script_arrivals = script_arrivals
        usable, changed = set(), True
        while changed:
            changed = False
            for b2 in list(self.warps):
                if b2 in overworld:
                    reg = None
                else:
                    reg = self.flood(b2, starts[b2]) if starts[b2] else set()
                    if reg == region[b2] and region[b2]: pass
                    region[b2] = reg
                for i, w in enumerate(self.warps[b2]):
                    if (b2, i) in usable: continue
                    if w['x'] >= OFF_MAP: continue
                    if reg is None:
                        x, z = self.at(w)
                        ok = any(self.walkable(b2, x + dx, z + dz) for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1))) \
                            or self.walkable(b2, x, z)
                    else:
                        ok = self.usable(b2, i, reg)
                    if not ok: continue
                    usable.add((b2, i)); changed = True
                    dz_, dw = w['dest_zone'], w['dest_warp']
                    a = self.arrival(dz_, dw) if dw != sinnoh_events.DEST_NEXT_ZONE else None
                    if a is not None and a not in starts[dz_]:
                        starts[dz_].add(a)
        return region, usable, overworld


def main(argv):
    files = next((a for a in argv if not a.startswith('--')), os.path.join(ROOT, 'work', 'rom_lead', 'files'))
    W = Warps(files)
    region, usable, overworld = W.reachable()
    found, accepted = collections.Counter(), []

    def report(kind, b2, msg, live=True):
        line = f'{W.name(b2)} ({b2}): ({kind}) {msg}'
        why = next((r for zn, k, rx, r in ACCEPT if k == kind and re.fullmatch(zn, W.name(b2)) and re.search(rx, line)), None)
        if why is None and not live:
            why = 'no player reaches it (an unused room or a dead warp of Pearl\'s data)'
        if why:
            accepted.append((line, why)); return
        found[kind] += 1
        print(line)

    for b2, ws in sorted(W.warps.items()):
        on_tile = collections.defaultdict(list)
        zone_live = b2 in overworld or bool(region.get(b2))
        for i, w in enumerate(ws):
            if w['x'] >= OFF_MAP: continue
            x, z = W.at(w)
            if w['dest_warp'] != sinnoh_events.INERT:
                on_tile[(x, z)].append(i)           # (an arrival point never fires: it shadows nothing)
            t = W.tile(b2, x, z)
            if t is None: continue
            live = (b2, i) in usable
            if w['type'] in (2, 3, 4) and not t[1]:
                report('walk', b2, f'warp {i} type {w["type"]} at {(x, z)} on a walkable tile', zone_live)
            if w['type'] in (0, 1) and t[1] and not (w['dest_warp'] == sinnoh_events.INERT and t[0] in pearl_chunk_ENTRANCES):
                # (an overworld entrance mat's arrival point sits on the mat, which the bump warp makes solid:
                # sinnoh_events.entrance_arrivals)
                report('mat', b2, f'warp {i} (exit mat) at {(x, z)} on a solid tile', zone_live)
            if w['dest_warp'] == sinnoh_events.INERT:
                continue                                # an arrival point only (never fires)
            if w['type'] == 1 and not t[1] and t[0] not in WARP_BEHAVIOURS and any(
                    not W.walkable(b2, x + dx, z + dz) for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                report('plain', b2, f'warp {i} at {(x, z)}: a plain tile (behaviour {t[0]:#x}) beside a wall', live)
            dz_, dw = w['dest_zone'], w['dest_warp']
            if dw == sinnoh_events.DEST_NEXT_ZONE:
                continue                                # Black 2's saved spot (the 1F the player came up from)
            if dz_ not in W.warps:
                if dz_ not in W.pid_of: report('dest', b2, f'warp {i} at {(x, z)} -> zone {dz_}: not installed', live)
                continue
            if dw >= len(W.warps[dz_]):
                report('dest', b2, f'warp {i} at {(x, z)} -> zone {dz_} warp {dw}: only {len(W.warps[dz_])} warps there', live)
                continue
            d = W.warps[dz_][dw]
            if d['x'] >= OFF_MAP: continue
            a = W.arrival(dz_, dw)
            ta = W.tile(dz_, *a)
            if ta is not None and ta[1] and d['type'] == 1 and d['dest_warp'] == sinnoh_events.INERT \
                    and ta[0] in pearl_chunk_ENTRANCES:
                pass                                    # onto an entrance mat's arrival point: Pearl's tile
            elif ta is None or ta[1]:
                dx_, dzz = W.at(d)
                report('arrive', b2, f'warp {i} at {(x, z)} -> {W.name(dz_)} warp {dw} ({dx_}, {dzz}) dir {d["dir"]}: '
                       f'arrival {a} is {"off the map" if ta is None else "solid"}', live)
        for (x, z), idx in on_tile.items():
            if len(idx) > 1:
                report('stack', b2, f'{len(idx)} warps on {(x, z)} (warps {idx}): only the first fires', zone_live)
    for b2, ps in sorted(W.script_arrivals.items()):  # a script's Warp lands the player on its tile (pl_Warp)
        for x, z in sorted(ps):
            t = W.tile(b2, x, z)
            if t is None or t[1]:
                report('arrive', b2, f'a script Warp lands on {(x, z)}: {"off the map" if t is None else "solid"}',
                       b2 in overworld or bool(region.get(b2)))
    print('summary:', dict(found), f'(accepted: {len(accepted)}; --accepted lists them)')
    if '--accepted' in argv:
        for line, why in accepted:
            print(f'  accepted: {line}\n      because {why}')
    return 1 if found else 0


STAND = {2: (0, 1), 1: (0, -1), 4: (1, 0), 3: (-1, 0)}   # walk-into warps: the tile they are walked into from, by dir


def check_heights(argv):
    """warp_check.py heights: see the top."""
    import math
    import pearl_chunk
    P = sinnoh_events.Planner()
    world, zones = P.world, P.zones
    slopes, offsets = pearl_chunk.tables()
    first = {}                                         # chunk -> (matrix, cell x, cell z, overworld): as the build
    m0 = P.matrix(0)
    for z in range(m0['height']):
        for x in range(m0['width']):
            c = m0['maps'][z][x]
            if c != 0xffff and str(c) in world['chunks']: first.setdefault(c, (m0, x, z, True))
    for mid in world['rooms']['matrices']:
        m = P.matrix(int(mid))
        for z in range(m['height']):
            for x in range(m['width']):
                c = m['maps'][z][x]
                if c != 0xffff and str(c) in world['rooms']['chunks']: first.setdefault(c, (m, x, z, False))
    built, new_heights, old_heights = {}, {}, {}

    def chunk(c):
        if c not in built:
            m, x, z, ow = first[c]
            data, rep = pearl_chunk.convert(c, slopes, offsets, pearl_chunk.neighbours(m, x, z),
                                            pearl_chunk.ENTRANCES if ow else ())
            magic, layers, _ = pearl_chunk.terrains(data)
            built[c] = [layer[4:] for layer in layers]  # (each layer: u16 32, u16 32, then 8 bytes a tile)
            new_heights[c] = rep['heights']
            old = dict(rep['heights'])                  # what floor_mats recorded before 2026-10-26: the neighbour's
            land = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))
            for tx, tz, was, _ in rep.get('mats', []):
                dx, dz = pearl_chunk.MAT_FROM[land['behaviour'][tz][tx]]
                if was is None: old.pop((tx, tz), None)   # (before: a mat with no height kept none)
                else: old[(tx, tz)] = rep['heights'][(tx + dx, tz + dz)]
            old_heights[c] = old
        return built[c]

    def floors(c, tx, tz):
        """The built floor heights (units) at tile (tx, tz)'s centre of chunk c, one per terrain layer."""
        out = []
        for cells in chunk(c):
            a, b = struct.unpack_from('<HH', cells, 8 * (tz * 32 + tx))
            out.append(pearl_chunk.plane_y(slopes, offsets, a, b, tx * 16 - 256 + 8, tz * 16 - 256 + 8))
        return out

    json_heights = P.heights
    before, after, checked = [], [], 0
    for pid in sorted(P.b2_of, key=lambda p: P.b2_of[p]):
        b2, m = P.b2_of[pid], P.matrix(zones[pid]['matrix'])
        ws, _ = P.warps(pid)
        for i, w in enumerate(ws):
            if w['x'] >= OFF_MAP or w['dest_warp'] == sinnoh_events.INERT:
                continue                               # (never fires)
            tx, tz = w['x'] // 16, w['z'] // 16
            if w['type'] in (2, 3, 4):
                dx, dz = STAND.get(w['dir'], (0, 0)); tx, tz = tx + dx, tz + dz
            cx, cz = tx // 32, tz // 32
            if not (0 <= cx < m['width'] and 0 <= cz < m['height']) or m['maps'][cz][cx] == 0xffff:
                continue
            c = m['maps'][cz][cx]
            if c not in first:
                continue
            ys = floors(c, tx % 32, tz % 32)
            checked += 1
            def rec(heights):
                P.heights = {**json_heights, **heights}
                y = P.warps(pid)[0][i]['y']
                P.heights = json_heights
                return (y ^ 0x8000) - 0x8000
            def ok(y):
                return any(y - 2 <= math.floor(f) <= y + 2 for f in ys)
            yb, ya = rec(old_heights), rec(new_heights)
            line = (f"{zones[pid]['name'][4:]} ({b2}) warp {i} type {w['type']} dir {w['dir']} at "
                    f"{(w['x'] // 16, w['z'] // 16)}, stand {(tx, tz)}: floor {[round(f, 1) for f in ys]}, "
                    f"y before {yb}, after {ya}")
            if not ok(yb): before.append(line)
            if not ok(ya): after.append(line)
    print('== off by more than 2 units BEFORE (the old floor_mats heights, this sinnoh_events):')
    print('\n'.join(before))
    print('== off by more than 2 units AFTER (this converter):')
    print('\n'.join(after))
    print(f'heights: {checked} firing warps checked; off by more than 2: before {len(before)}, after {len(after)}; '
          f'{len(built)} chunks converted')
    return 1 if after else 0


if __name__ == '__main__':
    if sys.argv[1:2] == ['heights']:
        sys.exit(check_heights(sys.argv[2:]))
    sys.exit(main(sys.argv[1:]))
