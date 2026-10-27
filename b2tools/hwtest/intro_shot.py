"""Cold boot -> through Black 2's new-game opening (A presses; START on the name keyboard) -> screenshots once the
field of a zone is up. Muted (emu.py). For quick looks at a map a new game loads first (Aspertia, zone 427).

    ~/Documents/GitHub/HoennB2/.venv/bin/python intro_shot.py ROM OUT_DIR [ZONE=427] [SHOTS=6] [WALK]

WALK: steps after the shots, separated by ";", e.g. "D4;R6;T105:876;W60": a direction (U/D/L/R) and tiles to hold it,
T<x>:<z> to walk to that tile of the matrix (one tile at a time, checking the position: x first, then z), W<frames> to
wait. A screenshot after each step (walk_NN.png); the zone and the player's tile are printed.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
from emu import Emu, fresh_battery  # noqa: E402

G_GAMESYS = 0x021410f4          # GameSystem pointer (HoennB2 pt.py); +0x1c GameData, +0x20 Field; GameData +0x114 zone


def main():
    rom, out = sys.argv[1], sys.argv[2]
    want = int(sys.argv[3]) if len(sys.argv) > 3 else 427
    shots = int(sys.argv[4]) if len(sys.argv) > 4 else 6
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
        if z == want and f:
            break
        e.press('START' if i % 12 == 11 else 'A', 4, 20)
        if i % 60 == 0:
            e.shot(os.path.join(out, f'intro_{i:03d}.png'))
    else:
        e.shot(os.path.join(out, 'stuck.png'))
        sys.exit(f'zone {want} not reached (zone {zone_field()})')
    print('zone', want, 'field up after', i, 'presses', flush=True)
    for k in range(shots):
        e.run(45)
        e.shot(os.path.join(out, f'field_{k}.png'))
    keys = {'U': 'UP', 'D': 'DOWN', 'L': 'LEFT', 'R': 'RIGHT'}
    def tile():
        g = mem.read_long(G_GAMESYS); d = mem.read_long(g + 0x1c)
        sx = lambda v: (v - (1 << 32) if v >> 31 else v) >> 16
        return sx(mem.read_long(d + 0x118)), sx(mem.read_long(d + 0x120))      # GameData player position (fx32)
    def walk_to(tx, tz):
        for axis in (0, 1):
            stuck = 0
            while tile()[axis] != (tx, tz)[axis] and stuck < 3:
                before = tile()
                key = ('RIGHT' if tx > before[0] else 'LEFT') if axis == 0 else ('DOWN' if tz > before[1] else 'UP')
                e.hold(key, 16); e.run(4)
                stuck = stuck + 1 if tile() == before else 0
    for k, step in enumerate(sys.argv[5].split(';') if len(sys.argv) > 5 else []):
        if step[0] == 'T':
            walk_to(*map(int, step[1:].split(':')))
        elif step[0] == 'W':
            e.run(int(step[1:]))
        else:
            e.hold(keys[step[0]], 16 * int(step[1:])); e.run(30)
        e.shot(os.path.join(out, f'walk_{k:02d}.png'))
        print('step', step, 'zone', zone_field()[0], 'tile', tile(), flush=True)


if __name__ == '__main__':
    main()
