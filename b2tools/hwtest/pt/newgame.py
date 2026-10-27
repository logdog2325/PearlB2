"""dex_fix: a real new game from mkstate.py's base_littleroot (cold boot, Hoenn opening) to Birch giving the Pokédex,
with the playthrough agent's driver (inputs only). Steps follow the playthrough's s03..s12.
    DEXFIX_ROM=ROM ../../../../../.venv/bin/python newgame.py VER STAGE      (VER s|r: states in states/VER/)"""
import sys, os; sys.path.insert(0, sys.path[0])
from pt import *
import battle, party as P
ver, stage = sys.argv[1], sys.argv[2]
SD = os.path.join(STATES, ver)
def st(n): return os.path.join(SD, n)
def save(g, n):
    for _ in range(3): g.e.d.cycle(with_joystick=False)   # drawn frames: a state saved right after skipped frames crashed on load
    g.e.save_state(st(n)); print('saved', n, g.zone(), g.tile(), flush=True)

if stage == 'may':          # Littleroot -> May's room -> May
    g = G(st('base_littleroot.dst'), name='ng-may')
    print('to May house', g.warp(1), g.zone(), g.tile()); g.adv()
    print('upstairs', g.warp(1), g.zone(), g.tile()); g.adv()
    acts = g.actors(); print([(a['uid'], a['x'], a['z']) for a in acts])
    may = [a for a in acts if a['uid'] == 1][0]
    g.talk(may['x'], may['z']); g.S()
    print('down', g.warp(0), g.zone(), g.tile()); g.adv()
    print('exit', g.warp(0), g.zone(), g.tile()); g.adv()
    save(g, 'ng1_aftermay.dst')
elif stage == 'birch':      # north exit -> Route 101: Birch's bag, the starter, the battle, the lab
    g = G(st('ng1_aftermay.dst'), name='ng-birch')
    battle.install(g)
    print('north', g.go(179, 354), g.tile())
    g.go(179, 351); g.adv(); g.S()
    print('at', g.zone(), g.tile())
    print(g.go(175, 346, adjacent=True), g.tile())
    here = g.tile(); g.face((175 - here[0], 346 - here[1])); g.press('A', 4, 30)
    for i in range(20):                 # Black 2's three-ball picker: RIGHT x2 = the right ball (Mudkip)
        g.run(30)
        if any('Choose' in x for x in g.texts()): break
        g.press('A', 4, 20)
    g.run(60)
    for _ in range(int(os.environ.get('STARTER', '2'))): g.press('RIGHT', 4, 30)
    g.press('A', 4, 40)
    g.adv(answers=['yes'], maxn=1500); g.S(True)
    print('now', g.zone(), g.tile(), [(m['species'], m['level']) for m in P.party(g)])
    save(g, 'ng2_lab.dst')
elif stage == 'dex':        # Route 103: May's battle, back to the lab: Birch gives the Pokédex
    g = G(st('ng2_lab.dst'), name='ng-dex')      # one attempt: the battle's outcome varies (RNG); exit 3 on a loss
    battle.install(g, run_wild=True)
    print('exit lab', g.warp(0), g.zone(), g.tile()); g.adv()
    r = g.go(178, 283); print('to May', r, g.zone(), g.tile())
    g.talk(178, 282); print('after May', g.zone(), g.tile(), [(m['species'], m['level'], m['hp']) for m in P.party(g)])
    if g.zone() != 326: print('lost to May: retry'); os._exit(3)
    save(g, 'ng3_aftermay103.dst')
    print('go home', g.go(175, 369), g.zone(), g.tile())
    print('lab', g.warp(3), g.zone(), g.tile())
    g.adv(maxn=1500); g.S(True)
    print('now', g.zone(), g.tile())
    save(g, 'ng4_dex.dst')
elif stage == 'train':      # Route 101's grass until the starter is Lv 8, heal in Oldale's Center (May's battle is a coin flip at Lv 5)
    g = G(st('ng2_lab.dst'), name='ng-train')
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
elif stage == 'bagshot':
    g = G(st('ng1_aftermay.dst'), name='ng-bag')
    g.go(179, 354); g.go(179, 351); g.adv()
    g.go(175, 346, adjacent=True)
    here = g.tile(); g.face((175 - here[0], 346 - here[1])); g.press('A', 4, 30)
    for i in range(12):
        g.run(30); t = g.texts(); print(i, t)
        if any('Choose' in x for x in t): break
        g.press('A', 4, 20)
    g.run(60); g.S(True); g.press('RIGHT', 4, 30); g.S(True); g.press('RIGHT', 4, 30); g.S(True)
    g.sheet(os.path.join(PT, 'shots', 'bag.png'), cols=4)
elif stage == 'catch':      # Route 101: catch a wild Pokémon with May's Poké Balls (party grows), then its dex entry
    g = G(st('ng4_dex.dst'), name='ng-catch')
    want = {261, 263, 265}
    battle.install(g, wanted=want, catch=True, run_wild=True)
    print('exit lab', g.warp(0), g.zone(), g.tile()); g.adv()
    print('route 101', g.go(176, 346), g.zone(), g.tile())
    n0 = len(P.party(g))
    for i in range(20):
        if g.pace_grass(80): g.adv()
        party = P.party(g); print('battle', i, [(m['species'], m['level'], m['hp']) for m in party], g.zone(), flush=True)
        if len(party) > n0: break
        if g.zone() != 317: print('left the route?'); break
    save(g, 'ng5_caught.dst')
elif stage == 'pg':         # post-game test build (HOENN_TEST_CHPOSTGAME=1 HOENN_TEST_CH13=1): Birch's house sign = Ch13's
    g = G(st('base_littleroot.dst'), name='ng-pg')   # state + PokeDexGiveNational, then a warp
    print('to sign', g.go(180, 361), g.tile())
    g.face((0, -1)); g.press('A', 4, 30)
    g.adv(maxn=600); g.run(300)
    print('now', g.zone(), g.tile(), [(m['species'], m['level']) for m in P.party(g)])
    save(g, 'pg1.dst')
elif stage == 'dexshot':    # the Pokédex scene again from ng3 (after May), with shots around "received the Pokédex"
    g = G(st('ng3_aftermay103.dst'), name='ng-dexshot')
    print('go home', g.go(175, 369), g.zone(), g.tile()); print('lab', g.warp(3), g.zone(), g.tile())
    got = 0
    for i in range(300):
        ts = g.texts()
        for t in ts: print('  >', t[:80])
        if any('received the Pok' in t for t in ts): got = 1
        if got and got < 4:
            g.run(40); g.S(True); got += 1; continue
        if got >= 4: break
        g.press('A', 4, 16)
    g.adv(maxn=800); g.S(True)
    g.sheet(os.path.join(PT, 'shots', f'{ver}_birch_dex.png'), cols=4)
