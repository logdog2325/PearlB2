"""Rowan's questions, the Fairy type and the music answer in game (notes/FAIRY.md). Muted (emu.py).

    PY=~/Documents/GitHub/HoennB2/.venv/bin/python
    $PY rowan_shot.py ROM OUT FAIRY MUSIC ZONE X Z [CMD ...]
    $PY rowan_shot.py ROM OUT state=FILE.dst - ZONE X Z [CMD ...]     (from a savestate: no intro)

Cold boot (no battery save) -> the intro: A presses (START every 12th, for the name keyboards), except that Rowan's
two menus get the answers asked for: FAIRY yes|no (A = YES, B = NO), MUSIC sinnoh|unova (A = SINNOH, B = UNOVA).
Hooks on the intro's code tell when: IntroCmd_Talk's message (26 = the Fairy question, 27 = the music question),
IntroMsg_OpenMenu / _CloseMenu, and every Intro_SetConfigBit call (bit, value) is printed. Both screens are shot when
each question's menu is open (q_fairy.png, q_music.png). Then the field of ZONE (a build with a test patch's
TEST_START=ZONE,X,Z, e.g. test_fairy), the player's tile calibrated at (X, Z), and the commands:

  A B X Y L R START SELECT UP DOWN LEFT RIGHT (press), W<frames>, T<x>,<y> (touch), SHOT<name> (both screens),
  STEP<U|D|L|R>, BGM (the BGM playing: Black 2's BGM stack, sBGMStack 0x0209da70 / sBGMStackEntries 0x0209da7c),
  GRASS<n> (step left/right up to n times until a battle starts: the field is gone), FIGHT<k> (in a battle: touch
  FIGHT, then move button k = 1-4; HoennB2 battle.py's coordinates), WAITFIELD<n> (A presses until the field is back,
  at most n), SAVE<name> (a savestate in OUT); story_shot.py's steps for walking a story: A<n> (n A presses, 40
  frames apart), TT<x>:<z> (walk there, x first: GameData's tile, no calibration needed), Z<zone> (A presses until
  that zone's field is up), U<n>/D<n>/L<n>/R<n> (hold a direction n tiles); BGMWATCH<frames> (run, printing each BGM
  change). After every command a change of the playing BGM is printed ("BGM -> seq N").
"""
import os, struct, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
from emu import Emu, fresh_battery  # noqa: E402

G_GAMESYS = 0x021410f4
INTRO_TALK, OPEN_MENU, CLOSE_MENU = 0x021a26f0, 0x021a334c, 0x021a34b0     # ov294 (pokebw2 symbols)
SCOMMANDS = 0x021a4bbc                                                     # sCommands; [31] = Intro_SetConfigBit
MSG_FAIRY_Q, MSG_MUSIC_Q = 26, 27
BGM_STACK, BGM_ENTRIES, BGM_ENTRY_SIZE = 0x0209da70, 0x0209da7c, 28
FIGHT_XY, MOVE_XY = (128, 95), [(64, 57), (192, 57), (64, 104), (192, 104)]


def main():
    rom, out, fairy, music, zone, bx, bz = sys.argv[1:8]
    cmds = sys.argv[8:]
    zone, bx, bz = int(zone), int(bx), int(bz)
    os.makedirs(out, exist_ok=True)
    fresh_battery(rom)
    e = Emu(rom)
    mem = e.d.memory.unsigned
    reg = e.d.memory.register_arm9
    ok = lambda p: 0x02000000 <= p < 0x02400000
    st = dict(talk=None, menu=False, setbit=None, shots=set())
    bits = []

    def on_talk(a, s):
        st['talk'] = mem.read_long(reg.r2)
        print('intro talk', st['talk'], flush=True); return True

    def on_open(a, s):
        st['menu'] = True; return True

    def on_close(a, s):
        st['menu'] = False; return True

    def on_setbit(a, s):
        args = reg.r2
        bits.append((mem.read_long(args), mem.read_long(args + 4)))
        print('Intro_SetConfigBit bit', bits[-1][0], '=', bits[-1][1], flush=True); return True

    e.d.memory.register_exec(INTRO_TALK, on_talk)
    e.d.memory.register_exec(OPEN_MENU, on_open)
    e.d.memory.register_exec(CLOSE_MENU, on_close)

    def zone_field():
        g = mem.read_long(G_GAMESYS)
        if not ok(g): return -1, 0
        d = mem.read_long(g + 0x1c)
        return (mem.read_short(d + 0x114) if ok(d) else -1), mem.read_long(g + 0x20)

    def shot(name):
        for _ in range(4): e.run(1)
        e.shot(os.path.join(out, name + '.png')); print('shot', name, flush=True)

    if fairy.startswith('state='):                                  # FAIRY = state=<savestate>: skip the intro
        e.load_state(fairy[6:]); e.run(10)
        if not e.calibrate(bx, bz): print('player position not found at', (bx, bz), flush=True)
        return run_cmds(e, cmds, zone_field, shot, out)
    e.run(600)
    for i in range(2000):
        z, f = zone_field()
        if z == zone and f: break
        if st['setbit'] is None and st['talk'] is not None:          # ov294 is loaded: hook command 31's function
            fn = mem.read_long(SCOMMANDS + 4 * 31)
            if 0x01FF8000 <= fn < 0x02000000:
                st['setbit'] = fn & ~1
                e.d.memory.register_exec(st['setbit'], on_setbit)
                print(f'Intro_SetConfigBit at {fn:#x}', flush=True)
        q = st['talk'] if st['menu'] else None
        if q in (MSG_FAIRY_Q, MSG_MUSIC_Q):
            name = 'q_fairy' if q == MSG_FAIRY_Q else 'q_music'
            if name not in st['shots']:
                e.run(30); shot(name); st['shots'].add(name)
            first = fairy == 'yes' if q == MSG_FAIRY_Q else music == 'sinnoh'
            e.press('A' if first else 'B', 4, 30)
        else:
            e.press('START' if i % 12 == 11 else 'A', 4, 20)
    else:
        shot('stuck'); sys.exit(f'zone {zone} not reached ({zone_field()})')
    print('field up in zone', zone, 'after', i, 'presses; answers', bits, flush=True)
    e.run(240)
    if not e.calibrate(bx, bz): print('player position not found at the start tile', flush=True)
    run_cmds(e, cmds, zone_field, shot, out)


def run_cmds(e, cmds, zone_field, shot, out):
    mem = e.d.memory.unsigned

    def bgm():
        depth = mem.read_long(BGM_STACK + 4)
        ent = BGM_ENTRIES + BGM_ENTRY_SIZE * depth
        return mem.read_long(ent), mem.read_short(ent + 4), depth

    def tile():
        g = mem.read_long(G_GAMESYS); d = mem.read_long(g + 0x1c)
        sx = lambda v: (v - (1 << 32) if v >> 31 else v) >> 16
        return sx(mem.read_long(d + 0x118)), sx(mem.read_long(d + 0x120))

    def walk_to(tx, tz):                         # story_shot.py's walk
        for axis in (0, 1):
            stuck = 0
            while tile()[axis] != (tx, tz)[axis] and stuck < 3:
                before = tile()
                key = ('RIGHT' if tx > before[0] else 'LEFT') if axis == 0 else ('DOWN' if tz > before[1] else 'UP')
                e.hold(key, 16); e.run(4)
                stuck = stuck + 1 if tile() == before else 0

    last = [bgm()[1]]
    print('BGM seq', last[0], flush=True)

    def watch(label):
        s = bgm()[1]
        if s != last[0]:
            print(f'BGM -> seq {s} ({label}; zone {zone_field()[0]}, tile {tile()})', flush=True); last[0] = s

    for c in cmds:
        run_one(c, e, mem, zone_field, shot, out, bgm, tile, walk_to, watch)
        watch(c)


def run_one(c, e, mem, zone_field, shot, out, bgm, tile, walk_to, watch):
    if True:
        if c in ('A', 'B', 'X', 'Y', 'L', 'R', 'START', 'SELECT', 'UP', 'DOWN', 'LEFT', 'RIGHT'): e.press(c, 4, 20)
        elif c[0] == 'A' and c[1:].isdigit():
            for _ in range(int(c[1:])): e.press('A', 4, 40); watch(c)
        elif c.startswith('TT'): walk_to(*map(int, c[2:].split(':'))); print('TT', c[2:], '->', tile(), flush=True)
        elif c[0] == 'Z' and c[1:].isdigit():
            for k in range(1200):
                z, f = zone_field()
                if z == int(c[1:]) and f: break
                e.press('A', 4, 20); watch(c)
            e.run(60); print('Z', c[1:], 'reached' if zone_field()[0] == int(c[1:]) else 'NOT reached', tile(), flush=True)
        elif c[0] in 'UDLR' and c[1:].isdigit():
            e.hold({'U': 'UP', 'D': 'DOWN', 'L': 'LEFT', 'R': 'RIGHT'}[c[0]], 16 * int(c[1:])); e.run(30)
        elif c.startswith('BGMWATCH'):
            for _ in range(int(c[8:]) // 10): e.run(10); watch(c)
        elif c[0] == 'W' and c[1:].isdigit(): e.run(int(c[1:]))
        elif c[0] == 'T' and ',' in c: x, y = map(int, c[1:].split(',')); e.touch(x, y, 6, 30)
        elif c.startswith('SHOT'): shot(c[4:])
        elif c.startswith('SAVE'): e.save_state(os.path.join(out, c[4:] + '.dst'))
        elif c.startswith('STEP'):
            mv = {'U': 'UP', 'D': 'DOWN', 'L': 'LEFT', 'R': 'RIGHT'}[c[4]]; print('STEP', mv, e.step(mv), flush=True)
        elif c == 'BGM':
            active, seq, depth = bgm(); print(f'BGM seq {seq} (active {active}, stack depth {depth}) zone {zone_field()[0]}', flush=True)
        elif c.startswith('GRASS'):
            for k in range(int(c[5:])):
                e.step('LEFT' if k % 2 else 'RIGHT')
                for _ in range(60):
                    if not zone_field()[1]: break
                    e.run(1)
                if not zone_field()[1]: break
            print('GRASS', 'battle after', k + 1, 'steps' if not zone_field()[1] else 'no battle', flush=True)
        elif c.startswith('FIGHT'):
            e.touch(*FIGHT_XY, 6, 40); e.run(30); e.touch(*MOVE_XY[int(c[5:]) - 1], 6, 40)
        elif c.startswith('WAITFIELD'):
            for k in range(int(c[9:])):
                if zone_field()[1]: break
                e.press('A', 4, 30)
            print('WAITFIELD', 'field back' if zone_field()[1] else 'still in battle', flush=True)
        else: raise SystemExit(f'unknown command {c}')


if __name__ == '__main__':
    main()
