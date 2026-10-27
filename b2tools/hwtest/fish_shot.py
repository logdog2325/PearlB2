"""Rods and time-of-day test (patches/pearl_rods.py, sinnoh_encounters' time hook). Muted (emu.py).
Needs a build with patches/test_wildmon.py and TEST_ITEMS=445,446,447 (a Pokémon and the three rods).

    PY=~/Documents/GitHub/HoennB2/.venv/bin/python
    EMU_HOUR=12 $PY fish_shot.py ROM OUT setup          cold boot -> Twinleaf -> the pond's edge facing the water,
                                                        saves OUT/pond.dst; prints which wild table is loaded
    $PY fish_shot.py ROM OUT run CMD ...                from OUT/pond.dst: commands, then saves OUT/last.dst
    $PY fish_shot.py ROM OUT boot ZONE X Z [CMD ...]     cold boot -> a new game's field in ZONE (a build with
                                                        test_wildmon TEST_START=ZONE,X,Z), saves OUT/boot.dst, then
                                                        the commands

Commands: A B X Y L R START SELECT UP DOWN LEFT RIGHT (press), W<frames>, T<x>,<y> (touch the bottom screen),
SHOT<name> (both screens -> OUT/<name>.png), GO<x>,<z> (walk there, one checked step at a time: x first, then z),
STEP<U|D|L|R> (one step, or a push on a warp tile), ZONE (the zone and tile now), CAL<x>,<z> (the player stands on
that tile: find its position in RAM again, e.g. after a warp), TABLE (which of the zone's 4 tables is in RAM), ROD (the rod variable:
ROD_VAR=<address from the build log>), FISH<name> (wait for a bite, press A, wait for the battle: shots),
ROUTE201 (walk north into Route 201's grass, then TABLE), HEAP (Black 2's sound heap: used / free bytes),
CAST<n>:<name> (press Y up to n times with one rod registered: each cast is logged with what Black 2 rolled, the
Pokémon picked (FieldEncount_GenWildsCore's slots) and whether the rod code ran (ROD_GENWILDS=<address>); at the first
bite, A, then shots of the battle).

The loaded table: GameData +0x158 = EventData (GameData_GetEventData, arm9 0x02017240), its EncData at +0x38
(event_data.h), compared with the zone's 4 tables in the build's a/1/2/7 (byte 7 = flags + fishingEnable ignored).
"""
import json, os, sys
from collections import deque
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(HERE, '..'))
from emu import Emu, fresh_battery  # noqa: E402
import narcio, zoneheaders  # noqa: E402

G_GAMESYS = 0x021410f4
PEARL_TWINLEAF, PEARL_ROUTE_201 = 411, 342
GEN_WILDS_CORE = 0x021a0bf4     # FieldEncount_GenWildsCore(manager, slots, out) (ov036)
BITE = 0x021795e8               # func_ov033_021795e8: the "!" over the player (a bite; HoennB2 rods_fix)
POND = (111, 890)                # Twinleaf's pond: the water is DOWN from here (12 steps from the fly point)
WATER = (0x10, 0x15)


def twinleaf_tiles(zones=(PEARL_TWINLEAF,)):
    m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    tiles = {}
    for cz in range(m['height']):
        for cx in range(m['width']):
            if m['headers'][cz][cx] not in zones: continue
            land = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f"{m['maps'][cz][cx]:03d}.json")))
            for tz in range(32):
                for tx in range(32):
                    tiles[(cx * 32 + tx, cz * 32 + tz)] = (not land['collision'][tz][tx]
                                                           and land['behaviour'][tz][tx] not in WATER)
    return tiles


def route(tiles, start, goal):
    prev, todo = {start: None}, deque([start])
    while todo:
        p = todo.popleft()
        if (goal(p) if callable(goal) else p == goal):
            path = []
            while prev[p] is not None:
                q, mv = prev[p]; path.append(mv); p = q
            return path[::-1]
        for mv, (dx, dz) in Emu.DELTA.items():
            q = (p[0] + dx, p[1] + dz)
            if q not in prev and tiles.get(q):
                prev[q] = (p, mv); todo.append(q)
    return None


class T:
    def __init__(self, rom, out):
        self.rom, self.out = rom, out
        os.makedirs(out, exist_ok=True)
        self.e = Emu(rom)
        self.mem = self.e.d.memory.unsigned

    def ok(self, p): return 0x02000000 <= p < 0x02400000

    def gdata(self):
        g = self.mem.read_long(G_GAMESYS)
        return self.mem.read_long(g + 0x1c) if self.ok(g) else 0

    def zone_field(self):
        g = self.mem.read_long(G_GAMESYS)
        if not self.ok(g): return -1, 0
        d = self.mem.read_long(g + 0x1c)
        return (self.mem.read_short(d + 0x114) if self.ok(d) else -1), self.mem.read_long(g + 0x20)

    def table(self):
        d = self.gdata()
        ev = self.mem.read_long(d + 0x158) if self.ok(d) else 0
        if not self.ok(ev): return 'no EventData'
        ram = bytes(self.mem[ev + 0x38 + i] for i in range(0xE8))
        zone = self.zone_field()[0]
        files = os.path.join(os.path.dirname(os.path.abspath(self.rom)), 'files')
        headers, _ = zoneheaders.load(files)
        tid = headers[zone]['encounters']
        if tid == 0x1FFF: return f'zone {zone}: no wild Pokémon'
        data = narcio.load(files, 127)[tid]
        strip = lambda b: b[:7] + b[8:]
        hits = [k for k in range(len(data) // 0xE8) if strip(data[k * 0xE8:(k + 1) * 0xE8]) == strip(ram)]
        return f'zone {zone} file {tid}: RAM = table {hits} of {len(data) // 0xE8}'

    def shot(self, name):
        for _ in range(4): self.e.run(1)
        self.e.shot(os.path.join(self.out, name + '.png')); print('shot', name, flush=True)


def main():
    rom, out, mode, cmds = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4:]
    if mode in ('setup', 'boot'): fresh_battery(rom)
    t = T(rom, out); e = t.e
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))['zones']
    twinleaf = world[str(PEARL_TWINLEAF)]['b2_zone']
    if mode == 'setup':
        e.run(600)
        for i in range(600):
            z, f = t.zone_field()
            if z == twinleaf and f: break
            e.press('START' if i % 12 == 11 else 'A', 4, 20)
        else:
            t.shot('stuck'); sys.exit('Twinleaf not reached')
        e.run(240)
        fx, _, fz = json.load(open(os.path.join(ROOT, 'work', 'world', 'fly.json')))[str(twinleaf)]
        if not e.calibrate(fx, fz): sys.exit('player position not found at the fly point')
        tiles = twinleaf_tiles()
        while e.player_tile() != POND:
            path = route(tiles, e.player_tile(), POND)
            if not path: t.shot('blocked'); sys.exit(f'no path from {e.player_tile()}')
            start = e.player_tile()
            for _ in range(6):
                if e.step(path[0], timeout=40) or e.player_tile() != start: break
            else:
                t.shot('blocked'); sys.exit(f'blocked at {e.player_tile()}')
        e.press('DOWN', 3, 20)                       # face the water (a tap turns without moving)
        print('at the pond', e.player_tile(), flush=True)
        print('TABLE', t.table(), flush=True)
        t.shot('pond')
        e.save_state(os.path.join(out, 'pond.dst'))
        return
    if mode == 'boot':
        zone, bx, bz = int(cmds[0]), int(cmds[1]), int(cmds[2])
        cmds = cmds[3:]
        e.run(600)
        for i in range(600):
            z, f = t.zone_field()
            if z == zone and f: break
            e.press('START' if i % 12 == 11 else 'A', 4, 20)
        else:
            t.shot('stuck'); sys.exit(f'zone {zone} not reached ({t.zone_field()})')
        e.run(240)
        if not e.calibrate(bx, bz): sys.exit('player position not found at the start tile')
        print('booted in zone', zone, 'at', e.player_tile(), flush=True)
        e.save_state(os.path.join(out, 'boot.dst'))
    else:
        e.load_state(os.path.join(out, 'pond.dst' if mode == 'run' else mode))
    for c in cmds:
        if c in ('A', 'B', 'X', 'Y', 'L', 'R', 'START', 'SELECT', 'UP', 'DOWN', 'LEFT', 'RIGHT'): e.press(c, 4, 20)
        elif c[0] == 'W' and c[1:].isdigit(): e.run(int(c[1:]))
        elif c[0] == 'T' and ',' in c: x, y = map(int, c[1:].split(',')); e.touch(x, y, 6, 30)
        elif c.startswith('SHOT'): t.shot(c[4:])
        elif c == 'TABLE': print('TABLE', t.table(), flush=True)
        elif c.startswith('GO'):
            x, z = map(int, c[2:].split(',')); ok = e.goto(x, z); print('GO', (x, z), ok, e.player_tile(), flush=True)
        elif c.startswith('STEP'):
            mv = {'U': 'UP', 'D': 'DOWN', 'L': 'LEFT', 'R': 'RIGHT'}[c[4]]; print('STEP', mv, e.step(mv), flush=True)
        elif c.startswith('CAL'):
            x, z = map(int, c[3:].split(',')); print('CAL', (x, z), e.calibrate(x, z), flush=True)
        elif c == 'ZONE': print('ZONE', t.zone_field()[0], 'tile', e.player_tile(), flush=True)
        elif c.startswith('HOLD'):                     # HOLD<key>:<frames>
            k, _, n = c[4:].partition(':'); e.hold(k, int(n)); e.run(20)
        elif c == 'NEXT':                              # GameData +0x168 = the saved next-zone spot (ZoneSpawnInfo)
            import struct
            sp = t.mem.read_long(t.gdata() + 0x168)
            raw = bytes(t.mem[sp + k] for k in range(32))
            ct, zone, wid, wdir = struct.unpack_from('<Ihhh', raw, 0)
            x, y, z = struct.unpack_from('<3i', raw, 16)
            print(f'NEXT zone {zone} warp {wid} dir {wdir} pos {x / 65536:.1f},{y / 65536:.1f},{z / 65536:.1f}', flush=True)
        elif c.startswith('WORK'):                     # WORK<hex id>: an event work (GameData +0x1AC = EventWork)
            w = int(c[4:], 16); ew = t.mem.read_long(t.gdata() + 0x1AC)
            print(f'WORK {w:#06x} =', t.mem.read_short(ew + 2 * (w - 0x4000)), flush=True)
        elif c == 'MET':                                # party Pokémon: met / egg location (Gen 5 block D +0x18 / +0x16)
            sys.path.insert(0, os.path.join(HERE, 'pt'))
            import struct, party as P
            pp = t.mem.read_long(t.gdata() + 0x194)
            for i in range(t.mem.read_long(pp + 4)):
                raw = bytes(t.mem[pp + 8 + 220 * i + k] for k in range(220))
                pid, flags, chk = struct.unpack('<IHH', raw[:8])
                dec = P._xor(list(struct.unpack('<64H', raw[8:136])), chk)
                order = P.ORDERS[((pid >> 13) & 31) % 24]
                D = dec[16 * order.index('D'):16 * order.index('D') + 16]
                A = dec[16 * order.index('A'):16 * order.index('A') + 16]
                print(f'MET party {i}: species {A[0]} met location {D[12]} egg location {D[11]}', flush=True)
        elif c == 'HEAP':
            import soundheap
            h = soundheap.frame_heap(e); print('HEAP used', h['used'], 'free', h['free'], 'of', h['size'], flush=True)
        elif c == 'ROUTE201':
            fx, _, fz = json.load(open(os.path.join(ROOT, 'work', 'world', 'fly.json')))[str(twinleaf)]
            e.calibrate(*POND) or e.calibrate(fx, fz)
            tiles = twinleaf_tiles((PEARL_TWINLEAF, PEARL_ROUTE_201))
            r201 = {p for p in tiles if p[1] < 864}            # Route 201: matrix 0 cells (3-4, 26), Twinleaf (3, 27)
            goal = lambda p: p in r201 and p[1] < 858
            for k in range(80):
                if goal(e.player_tile()): break
                path = route(tiles, e.player_tile(), goal)
                if not path: break
                start = e.player_tile()
                for _ in range(6):
                    if e.step(path[0], timeout=40) or e.player_tile() != start: break
            e.run(60)
            print('at', e.player_tile(), 'zone', t.zone_field()[0], flush=True)
            print('TABLE', t.table(), flush=True)
        elif c == 'ROD':
            a = int(os.environ['ROD_VAR'], 0); print('ROD', t.mem[a] | t.mem[a + 1] << 8, flush=True)
        elif c.startswith('FISH'):
            name = c[4:] or 'fish'
            bite = []
            e.d.memory.register_exec(BITE, lambda a, s: bite.append(e.frames) or True)
            for f in range(900):                        # A when the "!" shows (HoennB2 rods_fix step.py), then the battle
                e.run(1)
                if bite: e.run(2); e.press('A', 4, 10); break
            print('FISH', 'bite' if bite else 'no bite', 'after', f, 'frames', flush=True)
            for f in range(300):
                e.run(5)
                if not t.zone_field()[1]: break          # the field is gone: a battle
                if f % 10 == 9: e.press('A', 4, 10)      # "Not even a nibble..." / "Landed a Pokémon!"
            print('FISH field gone (battle)' if not t.zone_field()[1] else 'FISH no battle', flush=True)
            print('FISH field gone' if not t.zone_field()[1] else 'FISH no battle', 'after', f, 'frames', flush=True)
            t.shot(name + '_0')
            for k in range(1, 4): e.run(240); t.shot(f'{name}_{k}')
        elif c.startswith(('CAST', 'BAGCAST')):
            row = None
            if c.startswith('BAGCAST'):                   # BAGCAST<key-item row 0-4>:<n>:<name>: Bag -> Key Items -> USE
                row, _, c = c[7:].partition(':'); c = 'CAST' + c
            n, _, name = c[4:].partition(':')
            core, rodcalls, bite = [], [], []
            mem = t.mem
            def on_core(a, s):
                sl = e.d.memory.register_arm9.r1
                core.append([(mem.read_short(sl + 4 * k) & 0x7FF, mem[sl + 4 * k + 2]) for k in range(5)])
                return True
            e.d.memory.register_exec(GEN_WILDS_CORE, on_core)
            e.d.memory.register_exec(BITE, lambda a, s: bite.append(e.frames) or True)
            if os.environ.get('ROD_GENWILDS'):
                e.d.memory.register_exec(int(os.environ['ROD_GENWILDS'], 0), lambda a, s: rodcalls.append(e.frames) or True)
            for k in range(int(n)):
                core.clear(); bite.clear(); rodcalls.clear()
                if row is None: e.press('Y', 4, 10)
                else:
                    e.press('X', 4, 20); e.run(90); e.touch(190, 46, 6, 30); e.run(150)
                    e.touch(180, 24 + 24 * int(row), 6, 30); e.run(60); e.touch(200, 108, 6, 30); e.run(20)
                for f in range(500):
                    e.run(1)
                    if bite: e.run(2); e.press('A', 4, 10); break
                print(f'CAST {k + 1}: rod code {len(rodcalls)}x, Pokémon picked {core[:1]}, bite {bool(bite)}', flush=True)
                if bite:
                    for f in range(300):
                        e.run(5)
                        if not t.zone_field()[1]: break
                    for j in range(4): e.run(200); t.shot(f'{name}_{j}')
                    break
                for _ in range(4): e.press('B', 4, 30)
                e.run(60)
        else: raise SystemExit(f'unknown command {c}')
    e.save_state(os.path.join(out, 'last.dst'))


if __name__ == '__main__':
    main()
