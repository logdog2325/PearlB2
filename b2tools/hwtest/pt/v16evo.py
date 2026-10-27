"""Confirm the v16 evolution hang: evo0.dst (fixed ROM) with ITCM kRedirect's SEQ_BGM_SHINKA entry put back to v16's
mus_evolution, then the same battle; and the starter jingle (POKEGET) likewise."""
import sys, os, json, struct; sys.path.insert(0, sys.path[0])
sys.argv = [sys.argv[0], 'A', 'evo']
from pt import *
sys.path.insert(0, os.path.join(ROOT, 'b2tools'))
import sdat, m4a_to_sseq as c
s = sdat.SDAT(open(c.DEFAULT, 'rb').read())
mp = json.load(open(os.path.join(ROOT, 'data', 'hoenn_music.json')))
sid = {song: s.index('seq', slot) for song, slot in mp['slots'].items()}
SH = s.index('seq', 'SEQ_BGM_SHINKA')
g = G(os.path.join(STATES, 'A', 'evo0.dst'), name='v16evo')
m = g.e.d.memory
itcm = bytes(m.unsigned[0x01FF8000:0x02000000])
pat = struct.pack('<HH', SH, sid['mus_evolution_intro'])
i = itcm.find(pat); print('kRedirect SHINKA entry at', hex(0x01FF8000 + i) if i >= 0 else None)
m.write_short(0x01FF8000 + i + 2, sid['mus_evolution'])
print('now', bytes(m.unsigned[0x01FF8000 + i:0x01FF8000 + i + 4]).hex())
import battle, party as P
battle.install(g, run_wild=False)
try:
    if g.pace_grass(80): g.adv(maxn=300)
except Stop as ex: print('bot gave up', ex)
for k in range(150):
    if g.field() != 0 and g.event() == 0: break
    g.press('A', 4, 26)
r = m.register_arm9
print('after 150 A presses: field', g.field() != 0, 'species', P.party(g)[0]['species'], 'pc', hex(r.pc), 'lr', hex(r.lr))
g.S(True); g.sheet(os.path.join(PT, 'shots', 'v16_evo_hang.png'), cols=1)
