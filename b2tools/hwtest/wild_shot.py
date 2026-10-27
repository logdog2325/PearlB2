"""Wild-battle test: cold boot -> new game (intro_shot.py's presses) -> Twinleaf -> walk north to Route 201's tall
grass -> walk back and forth in it until a wild battle starts -> screenshots of the battle. Muted (emu.py).
Needs a build with patches/test_wildmon.py (a new game with an empty party hangs in a wild battle).

    ~/Documents/GitHub/HoennB2/.venv/bin/python wild_shot.py ROM OUT_DIR [MAX_GRASS_STEPS=300]

Zones come from data/sinnoh_world.json (Twinleaf = MAP_TWINLEAF, Route 201 = MAP_ROUTE_201), the start tile from
work/world/fly.json (sinnoh_world's fly point), grass and walls from Pearl's own land data (work/pearl/land: the
Black 2 matrix keeps Pearl's cells, so tiles have the same global numbers).
"""
import json, os, sys
from collections import deque
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(HERE, '..'))
from emu import Emu, fresh_battery  # noqa: E402

G_GAMESYS = 0x021410f4          # GameSystem pointer; +0x1c GameData, +0x20 Field; GameData +0x114 zone (intro_shot.py)
PEARL_TWINLEAF, PEARL_ROUTE_201 = 411, 342
TALL_GRASS, WATER = 0x02, (0x10, 0x15)


def pearl_tiles():
    """{(x, z): (walkable, grass, pearl zone)} over Pearl's matrix 0 (global tiles)."""
    m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    tiles = {}
    for cz in range(m['height']):
        for cx in range(m['width']):
            zone, chunk = m['headers'][cz][cx], m['maps'][cz][cx]
            if zone not in (PEARL_TWINLEAF, PEARL_ROUTE_201):
                continue
            land = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{chunk:03d}.json')))
            for tz in range(32):
                for tx in range(32):
                    beh = land['behaviour'][tz][tx]
                    ok = not land['collision'][tz][tx] and beh not in WATER
                    tiles[(cx * 32 + tx, cz * 32 + tz)] = (ok, beh == TALL_GRASS, zone)
    return tiles


def route(tiles, start, goal_fn):
    prev, todo = {start: None}, deque([start])
    while todo:
        p = todo.popleft()
        if goal_fn(p):
            path = []
            while prev[p] is not None:
                q, mv = prev[p]; path.append(mv); p = q
            return path[::-1]
        for mv, (dx, dz) in Emu.DELTA.items():
            q = (p[0] + dx, p[1] + dz)
            if q not in prev and tiles.get(q, (False,))[0]:
                prev[q] = (p, mv); todo.append(q)
    return None


def main():
    rom, out = sys.argv[1], sys.argv[2]
    max_steps = int(sys.argv[3]) if len(sys.argv) > 3 else 300
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))['zones']
    twinleaf, route201 = world[str(PEARL_TWINLEAF)]['b2_zone'], world[str(PEARL_ROUTE_201)]['b2_zone']
    fx, _, fz = json.load(open(os.path.join(ROOT, 'work', 'world', 'fly.json')))[str(twinleaf)]
    tiles = pearl_tiles()
    os.makedirs(out, exist_ok=True)
    fresh_battery(rom)
    e = Emu(rom)
    mem = e.d.memory.unsigned
    ok = lambda p: 0x02000000 <= p < 0x02400000
    def zone_field():
        g = mem.read_long(G_GAMESYS)
        if not ok(g): return -1, 0
        d = mem.read_long(g + 0x1c)
        return (mem.read_short(d + 0x114) if ok(d) else -1), mem.read_long(g + 0x20)
    e.run(600)
    for i in range(600):
        z, f = zone_field()
        if z == twinleaf and f:
            break
        e.press('START' if i % 12 == 11 else 'A', 4, 20)
    else:
        e.shot(os.path.join(out, 'stuck.png'))
        sys.exit(f'zone {twinleaf} not reached (zone {zone_field()})')
    e.run(240)
    print('Twinleaf field up after', i, 'presses; start tile', (fx, fz), flush=True)
    e.shot(os.path.join(out, 'twinleaf.png'))
    if not e.calibrate(fx, fz):
        sys.exit('player position not found at the fly point')
    def step(mv, taps=6):
        """One tile; the first taps after the field comes up (or a turn) may not move the player."""
        start = e.player_tile()
        for _ in range(taps):
            if e.step(mv, timeout=40) or e.player_tile() != start:
                return True
        return False
    goal = lambda p: tiles[p][1] and tiles[p][2] == PEARL_ROUTE_201
    path = route(tiles, (fx, fz), goal)
    assert path, 'no path to Route 201 grass'
    print('path to grass:', len(path), 'steps', flush=True)
    k = 0
    while zone_field()[1] and not goal(e.player_tile()):
        path = route(tiles, e.player_tile(), goal)      # re-plan from where the player really is
        if not path or not step(path[0]):
            e.shot(os.path.join(out, 'blocked.png'))
            sys.exit(f'blocked at {e.player_tile()} (step {k}), zone {zone_field()[0]}')
        k += 1
    print('in grass at', e.player_tile(), 'zone', zone_field()[0], '(Route 201 =', route201, ')', flush=True)
    e.shot(os.path.join(out, 'grass.png'))
    # a battle: the Field goes away (GameSystem +0x20 = 0) or the player cannot move either way any more
    steps, direction, stuck = 0, 'RIGHT', 0
    while zone_field()[1] and steps < max_steps and stuck < 3:
        x, z = e.player_tile()
        nxt = (x + (1 if direction == 'RIGHT' else -1), z)
        if not tiles.get(nxt, (False, False))[1]:
            direction = 'LEFT' if direction == 'RIGHT' else 'RIGHT'
            continue
        moved = step(direction, taps=2)
        steps += 1
        stuck = 0 if moved else stuck + 1
        if not moved:
            direction = 'LEFT' if direction == 'RIGHT' else 'RIGHT'
    print('stopped after', steps, 'grass steps; field', hex(zone_field()[1]), 'stuck', stuck, flush=True)
    if steps >= max_steps:
        e.shot(os.path.join(out, 'no_battle.png'))
        sys.exit(f'no wild battle after {steps} grass steps')
    for k, wait in enumerate((120, 240, 240, 240)):
        e.run(wait)
        e.shot(os.path.join(out, f'battle_{k}.png'))


if __name__ == '__main__':
    main()
