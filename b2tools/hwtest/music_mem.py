"""New game -> Twinleaf, then Black 2's sound heap (soundheap.py): used / free bytes with the zone's song loaded.
    ~/Documents/GitHub/HoennB2/.venv/bin/python music_mem.py ROM"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from emu import Emu, fresh_battery  # noqa: E402
import soundheap  # noqa: E402

rom = sys.argv[1]
fresh_battery(rom)
e = Emu(rom)
e.run(600)
mem = e.d.memory.unsigned
for i in range(600):
    g = mem.read_long(0x021410f4)
    if 0x02000000 <= g < 0x02400000 and mem.read_long(g + 0x20):
        d = mem.read_long(g + 0x1c)
        if mem.read_short(d + 0x114) == 427: break
    e.press('START' if i % 12 == 11 else 'A', 4, 20)
e.run(600)
h = soundheap.frame_heap(e)
print('sound heap: used', h['used'], 'free', h['free'], 'of', h['size'])
