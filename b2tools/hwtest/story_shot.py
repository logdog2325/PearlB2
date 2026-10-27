"""Story test driver (notes/STORY.md): cold boot -> Black 2's new-game opening (A presses; START on the name keyboard)
-> wait for a zone's field -> scripted steps with screenshots. Muted (emu.py). A copy of intro_shot.py with steps to
talk, face and read text.

    ~/Documents/GitHub/HoennB2/.venv/bin/python story_shot.py ROM OUT_DIR ZONE "STEPS" [--state SAVE.dst]

STEPS, separated by ";" (a screenshot after each: NN_<step>.png; the zone and tile are printed):
  U3 / D2 / L1 / R4    walk that many tiles (hold the key 16 frames a tile)
  T<x>:<z>             walk to that tile (x first, then z; stops when blocked)
  F<U|D|L|R>           face that way (a 2-frame tap: turns without walking)
  A<n> / B<n>          press A / B n times, 40 frames apart (talk, read, advance text)
  W<frames>            wait
  Z<zone>              wait for that zone (pressing A every 20 frames: text in between), up to 1200 tries
  S<name>              a screenshot named <name>.png
  SAVE<name>           save a state to OUT_DIR/<name>.dst (only for this ROM build)
--state: start from a saved state instead of a new game (ZONE ignored).
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
from emu import Emu, fresh_battery  # noqa: E402

G_GAMESYS = 0x021410f4          # GameSystem pointer (HoennB2 pt.py); +0x1c GameData, +0x20 Field; GameData +0x114 zone
KEYS = {'U': 'UP', 'D': 'DOWN', 'L': 'LEFT', 'R': 'RIGHT'}


def main():
    args = [a for a in sys.argv[1:]]
    state = None
    if '--state' in args:
        i = args.index('--state')
        state = args[i + 1]
        del args[i:i + 2]
    rom, out, want = args[0], args[1], int(args[2])
    steps = args[3].split(';') if len(args) > 3 and args[3] else []
    os.makedirs(out, exist_ok=True)
    if not state:
        fresh_battery(rom)
    e = Emu(rom)
    mem = e.d.memory.unsigned
    ok = lambda p: 0x02000000 <= p < 0x02400000

    def zone_field():
        g = mem.read_long(G_GAMESYS)
        if not ok(g):
            return -1, 0
        d = mem.read_long(g + 0x1c)
        return (mem.read_short(d + 0x114) if ok(d) else -1), mem.read_long(g + 0x20)

    def tile():
        g = mem.read_long(G_GAMESYS)
        d = mem.read_long(g + 0x1c)
        sx = lambda v: (v - (1 << 32) if v >> 31 else v) >> 16
        return sx(mem.read_long(d + 0x118)), sx(mem.read_long(d + 0x120))

    def wait_zone(z, tries=1200, start=False):
        for i in range(tries):
            zz, f = zone_field()
            if zz == z and f:
                return i
            e.press('START' if start and i % 12 == 11 else 'A', 4, 20)
            if i % 60 == 0:
                e.shot(os.path.join(out, f'wait_{z}_{i:04d}.png'))
        e.shot(os.path.join(out, 'stuck.png'))
        sys.exit(f'zone {z} not reached (zone {zone_field()[0]}, tile {tile()})')

    if state:
        e.load_state(state)
        e.run(30)
    else:
        e.run(600)
        n = wait_zone(want, 900, start=True)
        print('zone', want, 'field up after', n, 'presses', flush=True)
        e.run(90)
        e.shot(os.path.join(out, 'start.png'))

    def walk_to(tx, tz):
        for axis in (0, 1):
            stuck = 0
            while tile()[axis] != (tx, tz)[axis] and stuck < 3:
                before = tile()
                key = ('RIGHT' if tx > before[0] else 'LEFT') if axis == 0 else ('DOWN' if tz > before[1] else 'UP')
                e.hold(key, 16)
                e.run(4)
                stuck = stuck + 1 if tile() == before else 0

    for k, step in enumerate(steps):
        name = f'{k:02d}_{step.replace(":", "-")}'
        if step.startswith('SAVE'):
            e.save_state(os.path.join(out, step[4:] + '.dst'))
        elif step[0] == 'T':
            walk_to(*map(int, step[1:].split(':')))
        elif step[0] == 'F':
            e.hold(KEYS[step[1]], 2)
            e.run(12)
        elif step[0] in 'AB':
            for _ in range(int(step[1:] or 1)):
                e.press(step[0], 4, 40)
        elif step[0] == 'W':
            e.run(int(step[1:]))
        elif step[0] == 'Z':
            wait_zone(int(step[1:]))
            e.run(60)
        elif step[0] == 'S':
            name = step[1:]
        else:
            e.hold(KEYS[step[0]], 16 * int(step[1:]))
            e.run(30)
        e.shot(os.path.join(out, f'{name}.png'))
        print('step', step, 'zone', zone_field()[0], 'tile', tile(), flush=True)
    e.close()


if __name__ == '__main__':
    main()
