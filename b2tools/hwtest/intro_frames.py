"""Cold boot -> the new-game intro with a screenshot every other A press, until the first field zone (default 521,
the bedroom) is up; then a few frames of the field. Muted (emu.py).

    ~/Documents/GitHub/HoennB2/.venv/bin/python intro_frames.py ROM OUT_DIR [ZONE=521] [MAX_PRESSES=160]
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
from emu import Emu, fresh_battery  # noqa: E402

rom, out = sys.argv[1], sys.argv[2]
zone = int(sys.argv[3]) if len(sys.argv) > 3 else 521
most = int(sys.argv[4]) if len(sys.argv) > 4 else 160
os.makedirs(out, exist_ok=True)
fresh_battery(rom)
e = Emu(rom)
e.run(600)
mem = e.d.memory.unsigned
for i in range(most):
    e.press('START' if i % 12 == 11 else 'A', 4, 36)
    if i % 2 == 0:
        e.shot(os.path.join(out, f'i{i:03d}.png'))
    g = mem.read_long(0x021410f4)
    if 0x02000000 <= g < 0x02400000 and mem.read_long(g + 0x20):
        d = mem.read_long(g + 0x1c)
        if mem.read_short(d + 0x114) == zone:
            print('field', zone, 'at press', i, flush=True)
            break
for k in range(3):
    e.run(120)
    e.shot(os.path.join(out, f'field_{k}.png'))
