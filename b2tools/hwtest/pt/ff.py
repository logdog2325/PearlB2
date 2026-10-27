"""freeze_fix new game: base_house -> Littleroot -> May -> Route 101 -> lab starter (inputs only).
    FF_ROM=ROM python ff.py VER STAGE"""
import sys, os; sys.path.insert(0, sys.path[0])
from pt import *
import battle, party as P
ver, stage = sys.argv[1], sys.argv[2]
SD = os.path.join(STATES, ver)
def st(n): return os.path.join(SD, n)
SND = []
def sndlog(g):
    """log the sequences GFL_SndBGMPlayCore starts (r0 at entry: Black 2's id, before hoenn_music's redirect)"""
    import json
    sys.path.insert(0, os.path.join(ROOT, 'b2tools'))
    import sdat, m4a_to_sseq as c
    s = sdat.SDAT(open(c.DEFAULT, 'rb').read())
    mp = json.load(open(os.path.join(ROOT, 'data', 'hoenn_music.json')))
    names = {i: s.name('seq', i) for i in range(len(s.info['seq']))}
    for song, slot in mp['slots'].items(): names[s.index('seq', slot)] = song
    def cb(a, n):
        sid = g.e.d.memory.register_arm9.r0 & 0xffff
        SND.append((g.e.frames, names.get(sid, sid))); return True
    g.e.d.memory.register_exec(0x02005d98, cb)
    traps = {0x0203a21c: 'ALLOC_FAIL', 0x0207c774: 'SYS_EXIT', 0x0203cb80: 'ASSERT', 0x0203cb94: 'ASSERT_EX'}
    def trap(nm):
        def f(a, n): SND.append((g.e.frames, 'TRAP ' + nm + ' lr ' + hex(g.e.d.memory.register_arm9.lr))); return True
        return f
    for a, nm in traps.items(): g.e.d.memory.register_exec(a, trap(nm))
import atexit
atexit.register(lambda: print('sounds/traps:', [x[1] for x in SND]) if SND else None)
def save(g, n):
    for _ in range(3): g.e.d.cycle(with_joystick=False)
    g.e.save_state(st(n)); print('saved', n, g.zone(), g.tile(), flush=True)
if stage == 'probe':
    g = G(st('base_house.dst'), name='probe')
    print('gsys', hex(g.gsys()), 'zone', g.zone(), 'tile', g.tile(), 'idle', g.idle(), [hex(x) for x in g.event_chain()])
elif stage == 'house':
    g = G(st('base_house.dst'), name='house')
    g.adv(maxn=400); print('after mom', g.zone(), g.tile(), flush=True); g.S()
    acts = g.actors(); print([(a['uid'], a['x'], a['z'], a['scr']) for a in acts])
    save(g, 'h1.dst')
    g.sheet(os.path.join(PT, 'shots', 'house.png'))
elif stage == 'lr':
    g = G(st('h1.dst'), name='lr')
    ws = rom().entities(g.zone())['warps']; print('warps', [(i, w['dest_zone'], w['tile_x'], w['tile_z']) for i, w in enumerate(ws)])
    up = next(i for i, w in enumerate(ws) if w['dest_zone'] != 389 and rom().hdr[w['dest_zone']]['map_type'] != 0)
    print('up', g.warp(up), g.zone(), g.tile()); g.adv(maxn=300); g.S()
    print('at', g.zone(), g.tile(), [(a['uid'], a['x'], a['z']) for a in g.actors()])
    print('clock', g.go(6, 3)); g.face((0, -1)); g.press('A', 4, 30)
    for i in range(30):
        g.run(30)
        if g.field() != 0 and g.event() == 0: break
        for t in g.texts(): print('  >', t[:100])
        if g.choice_menu(): g.press('A', 4, 30); continue
        g.press('A', 4, 20)
    g.S(); g.adv(maxn=400); g.S()
    print('after clock', g.zone(), g.tile(), flush=True)
    ws = rom().entities(g.zone())['warps']; print('warps', [(i, w['dest_zone'], w['tile_x'], w['tile_z']) for i, w in enumerate(ws)])
    print('down', g.warp(0), g.zone(), g.tile()); g.adv(maxn=600); g.S()
    print('after tv', g.zone(), g.tile(), flush=True)
    save(g, 'h2.dst')
    ws = rom().entities(g.zone())['warps']; out = next(i for i, w in enumerate(ws) if rom().hdr[w['dest_zone']]['map_type'] == 0)
    print('out', g.warp(out), g.zone(), g.tile()); g.adv(maxn=300); g.S()
    save(g, 'base_littleroot.dst')
    g.sheet(os.path.join(PT, 'shots', 'lr.png'))
elif stage in ('birch2', 'lab'):
    import hashlib
    g = G(st('ng1_aftermay.dst' if stage == 'birch2' else os.environ.get('FROM', 'pre_lab.dst')), name=stage)
    battle.install(g)
    TR = {0x0203a21c: 'alloc_fail', 0x0207c774: 'sys_exit', 0x0203cb80: 'GFL_DebugAssertFail', 0x0203cb94: 'GFL_DebugAssertFailEx'}
    hits = []
    def mk(n):
        def cb(a, s):
            r = g.e.d.memory.register_arm9; hits.append((n, hex(r.r0), hex(r.r1), hex(r.lr))); return True
        return cb
    for a, n in TR.items(): g.e.d.memory.register_exec(a, mk(n))
    if stage == 'birch2':
        print('north', g.go(179, 354), g.tile())
        g.go(179, 351); g.adv(); g.S()
        print(g.go(175, 346, adjacent=True), g.tile())
        here = g.tile(); g.face((175 - here[0], 346 - here[1])); g.press('A', 4, 30)
        for i in range(20):
            g.run(30)
            if any('Choose' in x for x in g.texts()): break
            g.press('A', 4, 20)
        g.run(60)
        for _ in range(int(os.environ.get('STARTER', '2'))): g.press('RIGHT', 4, 30)
        g.press('A', 4, 40); g.S(True)
    saved_pre = False; last = None; same = 0; z0 = g.zone()
    for n in range(int(os.environ.get('N', '900'))):
        for t in g.texts(): print(f'  [{n} z{g.zone()}] >', t.replace('\n', ' ')[:140], flush=True)
        if hits: print('TRAP', hits[:4]); break
        if g.in_battle() and g.battle_hook:
            print('battle', n, flush=True); g.battle_hook(g); print('battle over', g.zone(), g.tile(), flush=True); g.S(True)
            if stage == 'birch2' and not saved_pre: save(g, 'pre_lab.dst'); saved_pre = True
            continue
        if g.zone() != z0: print('zone', z0, '->', g.zone(), 'frame', g.e.frames, flush=True); z0 = g.zone()
        if g.field() != 0 and g.event() == 0 and n > 20:
            print('idle at', n, g.zone(), g.tile()); break
        im = g.screen(); h = hashlib.md5(im.tobytes()).hexdigest()
        if h == last: same += 1
        else: same = 0; last = h
        if n % 15 == 0: g.shots.append(im)
        if same >= 25:
            r = g.e.d.memory.register_arm9
            print('FROZEN? screen same for', same, 'iters; pc', hex(r.pc), 'lr', hex(r.lr), 'field', hex(g.field()), 'ev', [hex(x) for x in g.event_chain()], flush=True)
            pcs = set()
            for k in range(200):
                g.e.d.cycle(with_joystick=False); pcs.add(g.e.d.memory.register_arm9.pc)
            print('pcs sample', sorted(hex(p) for p in pcs)[:40])
            save(g, 'frozen.dst'); g.shots.append(im); break
        if g.choice_menu(): print('  choice -> A', flush=True); g.press('A', 4, 30); continue
        g.press('A', 4, 16)
    print('end', g.zone(), g.tile(), [(m['species'], m['level']) for m in P.party(g)]); save(g, 'end_' + stage + '.dst')
    g.sheet(os.path.join(PT, 'shots', stage + '.png'), cols=5)

elif stage == 'may':
    g = G(st('base_littleroot.dst'), name='ng-may')
    print('to May house', g.warp(1), g.zone(), g.tile()); g.adv()
    print('upstairs', g.warp(1), g.zone(), g.tile()); g.adv()
    may = [a for a in g.actors() if a['uid'] == 1][0]
    g.talk(may['x'], may['z']); g.S()
    print('down', g.warp(0), g.zone(), g.tile()); g.adv()
    print('exit', g.warp(0), g.zone(), g.tile()); g.adv()
    save(g, 'ng1_aftermay.dst')
elif stage == 'birch':      # Route 101: Birch's bag, the starter, the battle, the lab: the starter (nickname: yes)
    g = G(st('ng1_aftermay.dst'), name='ng-birch')
    battle.install(g)
    print('north', g.go(179, 354), g.tile())
    g.go(179, 351); g.adv(); g.S()
    print(g.go(175, 346, adjacent=True), g.tile())
    here = g.tile(); g.face((175 - here[0], 346 - here[1])); g.press('A', 4, 30)
    for i in range(20):
        g.run(30)
        if any('Choose' in x for x in g.texts()): break
        g.press('A', 4, 20)
    g.run(60)
    for _ in range(int(os.environ.get('STARTER', '2'))): g.press('RIGHT', 4, 30)
    g.press('A', 4, 40)
    ok = g.adv(answers=['yes'], maxn=int(os.environ.get('N', '700'))); g.S(True)
    print('adv done', ok, 'now', g.zone(), g.tile(), [(m['species'], m['level']) for m in P.party(g)], flush=True)
    if not ok:
        r = g.e.d.memory.register_arm9; print('NOT IDLE: pc', hex(r.pc), 'lr', hex(r.lr), 'last', g.last_msg[:80])
        save(g, 'stuck_birch.dst')
    else: save(g, 'ng2_lab.dst')
    g.sheet(os.path.join(PT, 'shots', f'{ver}_birch.png'), cols=4)

elif stage == 'train':      # Route 101's grass until the starter is Lv 8 (level-ups), heal in Oldale's Center
    g = G(st('ng2_lab.dst'), name='ng-train'); sndlog(g)
    battle.install(g, run_wild=False)
    print('exit lab', g.warp(0), g.zone(), g.tile()); g.adv()
    print('route 101', g.go(176, 346), g.zone(), g.tile())
    for i in range(25):
        lv = P.party(g)[0]['level']
        if lv >= 8: break
        if g.pace_grass(60): g.adv()
        p = P.party(g)[0]; print('battle', i, p['level'], p['hp'], p['maxhp'], g.zone(), g.tile(), flush=True)
        if g.zone() != 317: print('blacked out?'); os._exit(3)
        if p['hp'] < p['maxhp'] // 3: break
    print('oldale', g.go(178, 316), g.zone(), g.tile()); print('heal', g.heal())
    print('party', [(m['species'], m['level'], m['hp']) for m in P.party(g)])
    save(g, 'ng2b_trained.dst')
elif stage == 'dex':        # Route 103: May's battle, back to the lab: Birch gives the Pokédex
    g = G(st(os.environ.get('FROM', 'ng2b_trained.dst')), name='ng-dex'); sndlog(g)
    battle.install(g, run_wild=True)
    if g.zone() == 396: print('exit lab', g.warp(0), g.zone(), g.tile()); g.adv()
    r = g.go(178, 283); print('to May', r, g.zone(), g.tile())
    g.talk(178, 282); print('after May', g.zone(), g.tile(), [(m['species'], m['level'], m['hp']) for m in P.party(g)])
    if g.zone() != 326: print('lost to May: retry'); os._exit(3)
    save(g, 'ng3_aftermay103.dst')
    print('go home', g.go(175, 369), g.zone(), g.tile())
    print('lab', g.warp(3), g.zone(), g.tile())
    ok = g.adv(maxn=1500); g.S(True)
    print('adv', ok, 'now', g.zone(), g.tile(), 'dex items', P.bag(g, 'key'))
    save(g, 'ng4_dex.dst')
    g.sheet(os.path.join(PT, 'shots', f'{ver}_dex.png'), cols=4)
elif stage == 'catch':      # Route 101: catch a wild Pokémon with May's Poké Balls
    g = G(st('ng4_dex.dst'), name='ng-catch'); sndlog(g)
    battle.install(g, wanted={261, 263, 265}, catch=True, run_wild=True)
    print('exit lab', g.warp(0), g.zone(), g.tile()); g.adv()
    print('route 101', g.go(176, 346), g.zone(), g.tile())
    n0 = len(P.party(g))
    for i in range(20):
        if g.pace_grass(80): g.adv()
        party = P.party(g); print('battle', i, [(m['species'], m['level'], m['hp']) for m in party], g.zone(), flush=True)
        if len(party) > n0: break
        if g.zone() != 317: print('left the route?'); break
    save(g, 'ng5_caught.dst')
elif stage == 'setmon':     # test hook: party slot I gets species SP and/or exp EXP (re-encrypted, checksum fixed)
    import struct as S
    g = G(st(os.environ['FROM']), name='setmon')
    d = g.gdata(); p = g.u32(d + 0x194); i = int(os.environ.get('I', '1'))
    a = p + 8 + 220 * i
    pkm = bytearray(g.rd(a, 220))
    pid, flags, chk = S.unpack('<IHH', pkm[:8])
    dec = P._xor(list(S.unpack('<64H', pkm[8:136])), chk)
    assert sum(dec) & 0xffff == chk
    order = P.ORDERS[((pid >> 13) & 31) % 24]; A = 16 * order.index('A')
    if 'SP' in os.environ: dec[A + 0] = int(os.environ['SP'])
    if 'EXP' in os.environ:
        x = int(os.environ['EXP']); dec[A + 4] = x & 0xffff; dec[A + 5] = x >> 16
    chk = sum(dec) & 0xffff
    pkm[6:8] = S.pack('<H', chk); pkm[8:136] = S.pack('<64H', *P._xor(dec, chk))
    for k in range(0, 220, 4): g.e.d.memory.write_long(a + k, S.unpack_from('<I', pkm, k)[0])
    g.run(10)
    print('party', P.party(g))
    save(g, os.environ['TO'])
elif stage == 'wallmap':    # Oldale Center's wall map (CallPlaceSelect: town_map's view mode), then back to the field
    g = G(st(os.environ.get('FROM', 'ng2b_trained.dst')), name='wallmap'); sndlog(g)
    if g.zone() == 397: print('enter center', g.enter(398), g.zone(), g.tile()); g.adv()
    x, z = map(int, os.environ.get('AT', '11,9').split(','))
    print('go', g.go(x, z, adjacent=True), g.tile()); here = g.tile(); g.face((x - here[0], z - here[1]))
    g.press('A', 4, 30)
    opened = False
    for i in range(40):
        for t in g.texts(): print('  >', t[:100])
        if g.field() == 0:
            g.run(150); g.S(True); opened = True; break
        g.press('A', 4, 20)
    print('map opened', opened, flush=True)
    if opened:
        g.press('LEFT', 4, 30); g.press('UP', 4, 30); g.run(30); g.S(True)
        g.press('B', 4, 60)
        for i in range(30):
            if g.field() != 0: break
            g.run(20)
        g.wait_idle(); g.S(True)
        print('back on field', g.field() != 0, g.idle(), g.zone(), g.tile())
    g.sheet(os.path.join(PT, 'shots', f'{ver}_wallmap.png'), cols=3)
elif stage == 'evo':        # a wild battle on Route 101 with the lead set up to level and evolve (setmon hook)
    g = G(st(os.environ.get('FROM', 'evo0.dst')), name='evo'); sndlog(g)
    battle.install(g, run_wild=False)
    sp0 = P.party(g)[0]['species']; print('lead', sp0, P.party(g)[0]['level'], P.party(g)[0]['exp'])
    for i in range(8):
        try:
            if g.pace_grass(80): g.adv(maxn=900)
        except Stop as ex:
            print('bot gave up:', ex, '-> pressing A by hand', flush=True)
            for k in range(120):
                if k % 8 == 0: g.S(True)
                if g.field() != 0 and g.event() == 0: break
                g.press('A', 4, 26)
            print('after hand presses', g.field() != 0, g.event() == 0, [x[1] for x in SND][-6:], flush=True)
            g.wait_idle()
        m = P.party(g)[0]; print('battle', i, m['species'], m['level'], m['exp'], g.zone(), g.idle(), flush=True)
        if m['species'] != sp0: break
    g.S(True)
    print('evolved' if P.party(g)[0]['species'] != sp0 else 'NOT evolved', P.party(g)[0]['species'], 'idle', g.idle())
    save(g, 'evo1.dst')
    g.sheet(os.path.join(PT, 'shots', f'{ver}_evo.png'), cols=5)
elif stage == 'save':       # in-game save from a state (fresh battery first), then 'cont' boots and continues
    from emu import fresh_battery
    fresh_battery(ROM)
    g = G(st(os.environ.get('FROM', 'evo1.dst')), name='save'); sndlog(g)
    print('before', g.zone(), g.tile(), [(m['species'], m['level']) for m in P.party(g)])
    g.press('X', 4, 60); g.S(True)
    g.touch(64, 142, 6, 150); g.S(True)
    for i in range(6):
        for t in g.texts(): print('  >', t[:100])
        if g.choice_menu(): print('  choice -> yes'); g.press('A', 4, 40)
        else: g.press('A', 4, 40)
        g.run(120)
    for i in range(8): g.run(150); [print('  >', t[:100]) for t in g.texts()]
    g.S(True); g.press('B', 4, 30); g.press('B', 4, 30); g.wait_idle()
    g.press('X', 4, 60); g.S(True); g.press('B', 4, 60)
    print('menu still opens, idle', g.idle())
    g.run(600)
    g.sheet(os.path.join(PT, 'shots', f'{ver}_save.png'), cols=4)
elif stage == 'cont':
    dsv = os.path.expanduser(f'~/.config/desmume/{os.path.splitext(os.path.basename(ROM))[0]}.dsv')
    print('battery', os.path.exists(dsv), os.path.getsize(dsv) if os.path.exists(dsv) else 0)
    g = G(None, name='cont'); sndlog(g)
    g.run(1200)
    for i in range(6): g.press('A', 4, 60); 
    g.S(True); g.run(400); g.wait_idle(); g.S(True)
    print('continued at', g.zone(), g.tile(), [(m['species'], m['level']) for m in P.party(g)], 'idle', g.idle())
    g.sheet(os.path.join(PT, 'shots', f'{ver}_cont.png'), cols=2)
