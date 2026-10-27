"""battle_crash: Black 2's anti-piracy (DS Protect, overlay 337) in a playthrough: which of its "OK" / "tampered" callbacks
run, and what happens when the tampered ones run (as on a flashcart / nds-bootstrap without an AP fix for this ROM).

Black 2 (pokebw2 decomp) calls a DS Protect check at three places, each time with a pair of callbacks it picks
from at random (table data_ov337_02182444, index data_ov337_02182440): the OK one, or the "tampered" one:
  boot   GameSystem_Init (arm9)      tampered: func_02016678 (+1 VBlank task per badge too), func_020166c0
  warp   EventMapChange (ov035)      tampered: EventMapChange_DSProtTamper1/2 = 4 KB leaked from the event heap each
  battle EventBattleCall (ov012)     tampered: func_ov012_02169154/80 -> after the battle a permanent VBlank task
FORCE=1 makes every check take its tampered callback (at the check's entry the table's OK entry is overwritten
with the tampered one), i.e. what a detecting DS Protect does.
    FF_ROM=ROM [FORCE=1] [WATCH=1] python dsprot.py VER STAGE [N]
stages: warps N (in and out of the lab N times from ng2_lab.dst), then a wild battle and May (from the states)."""
import sys, os; sys.path.insert(0, sys.path[0])
from pt import *
import battle, party as P
ver, stage = sys.argv[1], sys.argv[2]
N = int(sys.argv[3]) if len(sys.argv) > 3 else 6
SD = os.path.join(STATES, ver)
def st(n): return n if os.path.isabs(n) else os.path.join(SD, n)

OK = {0x020166a0: 'boot ok 1', 0x020166d0: 'boot ok 2', 0x0217ed1c: 'warp ok', 0x02169170: 'battle ok 1',
      0x02169198: 'battle ok 2'}
BAD = {0x02016678: 'boot TAMPER 1', 0x020166c0: 'boot TAMPER 2', 0x0217eccc: 'warp TAMPER 1 (4 KB leak)',
       0x0217ecf4: 'warp TAMPER 2 (4 KB leak)', 0x02169154: 'battle TAMPER 1', 0x02169180: 'battle TAMPER 2'}
CHECKS = [0x0218092c, 0x021809d8, 0x02180a84, 0x02180b30]
TRAPS = {0x0203a21c: 'ALLOC_FAIL', 0x0207c774: 'SYS_EXIT', 0x0203cb80: 'ASSERT', 0x0203cb94: 'ASSERT_EX'}
COUNT = {}
EVENTS = []
DEAD = []
import pt as _pt
_run0 = _pt.Emu.run
def _run(self, frames=1):
    _run0(self, frames)
    if DEAD: raise Stop(f'the game stopped (SYS_EXIT) at frame {DEAD[0]}')
_pt.Emu.run = _run

def install(g):
    m = g.e.d.memory
    def mk(name):
        def cb(a, s):
            COUNT[name] = COUNT.get(name, 0) + 1
            if 'TAMPER' in name or COUNT[name] <= 2:
                EVENTS.append((g.e.frames, name))
        return cb
    for a, n in {**OK, **BAD}.items(): m.register_exec(a, mk(n))
    def trap(n):
        def cb(a, s):
            r = m.register_arm9
            EVENTS.append((g.e.frames, f'TRAP {n} r0 {r.r0 & 0xffffffff:#x} r1 {r.r1 & 0xffffffff:#x} lr {r.lr & 0xffffffff:#x}'))
            print('TRAP', n, hex(r.lr & 0xffffffff), 'frame', g.e.frames, flush=True)
            if n == 'SYS_EXIT': DEAD.append(g.e.frames)
        return cb
    for a, n in TRAPS.items(): m.register_exec(a, trap(n))
    if os.environ.get('FORCE'):
        def force(a, s):
            idx = g.u32(0x02182440) & 1
            ok, bad = g.u32(0x02182444 + 4 * idx), g.u32(0x02182444 + 4 * (idx ^ 1))
            m.write_long(0x02182444 + 4 * idx, bad)
            COUNT['forced'] = COUNT.get('forced', 0) + 1
        for a in CHECKS: m.register_exec(a, force, 4)

def vblank_tasks(g):
    """GFL's VBlank task count is not mapped here; count the get_mt tasks the tampered callbacks add instead"""
    return COUNT.get('boot TAMPER 1', 0) + COUNT.get('battle TAMPER 1', 0) + COUNT.get('battle TAMPER 2', 0)

def heap_free(g, hid=4):
    """(free bytes, largest free block, block count) of a GFL heap: sHeapMgr (0x0214181c) -> its NNS expanded heap's
    free list (NNSiFndHeapHead + 0x24 = free list head; block: u16 sig 'FR', u16 attr, u32 size, prev, next)"""
    mgr = 0x0214181c
    heaps, idx = g.u32(mgr), g.u32(mgr + 4)
    i = g.u8(idx + hid)
    if i == 0xff: return None
    h = g.u32(heaps + 0x10 * i)
    b = g.u32(h + 0x24); tot = big = n = 0
    while g.ok(b) and n < 4000:
        sz = g.u32(b + 4); tot += sz; big = max(big, sz); n += 1; b = g.u32(b + 0xc)
    return tot, big, n

def vblank_tcbs(g):
    """(slots, used) of GFL's VBlank task manager: g_VBlankCallback (0x0209da58) +0x14 -> +0x20 (TCBManager: count, used)"""
    a = g.u32(0x0209da58 + 0x14)
    if not g.ok(a): return None
    m = g.u32(a + 0x20)
    return (g.u32(m), g.u32(m + 4)) if g.ok(m) else None

def report(tag):
    print(f'   VBlank tasks (slots, used): {vblank_tcbs(g)}', flush=True)
    hf = heap_free(g)
    print(f'[{tag}] f{g.e.frames} zone {g.zone()} event heap free {hf[0] if hf else "?"} B (largest {hf[1] if hf else "?"}) calls:',
          {k: v for k, v in sorted(COUNT.items())}, flush=True)
    while EVENTS:
        f, e = EVENTS.pop(0)
        if 'ok' not in e: print('   ', f, e, flush=True)
    EVENTS.clear()

if stage == 'boot':                 # cold boot with the battery (Continue): the boot check
    g = G(None, name=f'{ver}-dsprot-boot'); install(g)
    g.run(1200)
    for i in range(8): g.press('A', 4, 60)
    g.run(400); g.wait_idle(); report('boot/continue')
def main():
    global g
    g = G(st(os.environ.get('FROM', 'ng2_lab.dst')), name=f'{ver}-dsprot-{stage}')
    install(g)
    battle.install(g, run_wild=bool(os.environ.get('RUN')))
    print('start', g.zone(), g.tile(), [(m['species'], m['level'], m['hp']) for m in P.party(g)], 'FORCE' if os.environ.get('FORCE') else '', flush=True)
    if stage in ('warps', 'all'):
        for i in range(N):
            if g.zone() in (396,):
                g.warp(0); g.adv(maxn=200)
            else:
                g.warp(3); g.adv(maxn=200)
            report(f'warp {i + 1} -> zone {g.zone()}')
        if g.zone() == 396: g.warp(0); g.adv(maxn=200); report('out of the lab')
    if stage in ('battle', 'all'):
        print('route 101', g.go(176, 346), g.zone(), g.tile(), flush=True)
        for k in range(int(os.environ.get('BATTLES', '1'))):
            for i in range(6):
                if g.pace_grass(80):
                    g.adv(); break
            report(f'after wild battle {k + 1}')
    if stage in ('all',) and os.environ.get('MAY'):
        r = g.go(178, 283); print('to May', r, g.zone(), g.tile(), flush=True)
        g.talk(178, 282); report('after May')
        print('after May', g.zone(), g.tile(), [(m['species'], m['level'], m['hp']) for m in P.party(g)], flush=True)
    g.S(True)
    g.sheet(os.path.join(PT, 'shots', f'{ver}_dsprot_{stage}{"_force" if os.environ.get("FORCE") else ""}.png'), cols=4)

if stage != 'boot':
    try:
        main()
    except Stop as ex:
        print('STOPPED:', ex, flush=True)
        report('game stopped')
        for _ in range(3): g.e.d.cycle(with_joystick=False)
        g.e.save_state(os.path.join(SD, f'dsprot_dead.dst')); g.S(True)
        g.sheet(os.path.join(PT, 'shots', f'{ver}_dsprot_dead.png'), cols=4)
