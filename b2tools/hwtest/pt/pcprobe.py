import sys, os; sys.path.insert(0, sys.path[0])
from pt import *
g = G(os.path.join(STATES, 's', sys.argv[1]), name='pcprobe')
from collections import Counter
c = Counter(); lrs = Counter()
for k in range(600):
    g.e.d.cycle(with_joystick=False)
    r = g.e.d.memory.register_arm9; c[r.pc] += 1; lrs[r.lr] += 1
print('pc', [(hex(a), n) for a, n in c.most_common(12)])
print('lr', [(hex(a), n) for a, n in lrs.most_common(12)])
print('field', hex(g.field()), 'ev', [hex(x) for x in g.event_chain()])
