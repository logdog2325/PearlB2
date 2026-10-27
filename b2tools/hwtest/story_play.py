"""Story play-through driver (notes/STORY.md section 9): plays scenes with checked steps and reads the game's text,
works and flags from RAM (inputs only; RAM is only read). Muted (emu.py). One emulator at a time on the machine.

    PY=~/Documents/GitHub/HoennB2/.venv/bin/python
    SDL_AUDIODRIVER=dummy $PY story_play.py ROM OUT boot ZONE X Z [CMD ...]   cold boot -> Black 2's opening (A/START)
                                                                             -> ZONE's field; saves OUT/boot.dst
    SDL_AUDIODRIVER=dummy $PY story_play.py ROM OUT load STATE [CMD ...]      from a saved state (OUT/STATE.dst or a path)

Boot options: PLAY_GIRL=1 (Dawn), PLAY_NO=text,... (NO to Rowan's questions whose line contains a text), PLAY_QSHOTS=1
(a shot of each question's menu), PLAY_DATE=YYYY-MM-DD (the DS clock's date, e.g. another season),
PLAY_SAV=file.sav (boot from that battery save, e.g. a user's melonDS .sav: Continue instead of a new game; ZONE -1
takes whatever field the save opens in).
Stall watchdog: no new text or tile for PLAY_STALL seconds (default 30) -> it tries to recover (battle: next move /
run; field: B, A, a step each way); only after 5 failed tries -> stalled.png/.dst (resume: load stalled), exit 3.
Commands (each prints what happened):
  A B X Y L R START SELECT UP DOWN LEFT RIGHT   press once
  W<frames>                 wait
  ADV[:a,b,...]             advance whatever runs (text, scenes, battles, the starter screen, naming) until the field is
                            idle; answers for YES/NO menus in order ('y' = A, 'n' = B; default y); prints every new line
  GO<x>,<z>                 walk there one checked step at a time (x first); stops (and says so) if a scene starts
  GOZ<x>,<z>                the same, z first
  TO<x>,<z>                 walk there along Pearl's collision (work/pearl/land: the converted maps keep Pearl's tiles),
                            around people, re-planning when blocked; stops if a scene starts
  STEP<U|D|L|R>[n]          n single steps (a scene starting stops it)
  FACE<U|D|L|R>             turn without walking
  TALK                      A, then ADV
  TALKTO<uid>               walk next to actor uid (see ACTORS), face it, A, ADV (follows a wandering one)
  ZONE                      the zone, the player's tile and facing
  WAITZONE<zone>            wait (pressing nothing) until that zone's field is up
  WEATHER                   the zone's weather now (GameData +0x1c9, GetWeatherAll's answer) and the kept season
  WORK<hex>                 an event work's value; FLAG<n> an event flag
  BAG                       the Bag's items, key items, TMs & HMs and medicine pockets: (item, count)
  PARTY                     party species and levels
  MOVES                     party species and their four move ids
  EXP                       party species, levels and Exp. Points
  CONFIG                    the options u16 (bits 11-15: Fairy, split, music, sprites, seasons)
  WILD<U|D|L|R>             step that way and back (tall grass) until a wild battle starts, then ADV through it
  WILDSTOP<U|D|L|R>         the same, but stop when the battle starts (then A / TOUCH by hand, e.g. to throw a ball)
  ACTORS                    the zone's actors (uid, tile, model, script)
  ROAM                      the roamers (EncountSave, save block 0x37: patches/roamers.py): each slot's species, level,
                            active, HP, status, zone and place (Pearl's 0-28), the player's previous / current place + 1
  ROAMSET<slot>,<zone>,<place>  TEST ONLY, writes RAM: puts that roamer in that zone / place (to meet it at once)
  SHOT<name>                both screens -> OUT/<name>.png
  TOUCH<x>,<y>[,<frames>]   touch the bottom screen there (held 6 frames, or <frames>), then 20 frames
  REC<name>,<U|D|L|R|->,<n>,<k>  hold that direction 8 frames (-: none), then run n frames keeping the top screen every
                            k frames: OUT/<name>_NN.png (256x192) and a sheet OUT/<name>.png (frames inside a warp:
                            a door opening, the fade, the walk out); OUT/<name>.json logs every frame's zone, the
                            player's world position (pos, off) and the camera (cam, target)
  SAVE<name>                state -> OUT/<name>.dst
  FILM<name> ... CUT        while filming, every new line keeps a frame; CUT writes them as one sheet OUT/<name>.png
                            (PLAY_FILM_FRAMES=1: also each frame full size, OUT/<name>_NN.png; PLAY_FILM_EVERY=n:
                            also a frame every n ADV steps of ~20 frames while the field shows, for walks between lines)
Memory layout (pokebw2; the same reads as HoennB2's playtest driver): GameSystem 0x021410f4 (+0x18 the running event,
+0x1c GameData, +0x20 the field); GameData +0x114 zone, +0x1a8 actor system, +0x1ac EventWork (u16 works[431] then
the flag bits), +0x194 party. Text: every StrBuf in RAM (magic 0xb6f8d2ec) that is new since the last look.
"""
import os, struct, sys, time
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))
from emu import Emu, fresh_battery, KEYS  # noqa: E402
from desmume.controls import keymask  # noqa: E402

G_GAMESYS = 0x021410f4
STRBUF_MAGIC = 0xb6f8d2ec
BATTLE_CB = 0x02168bac          # the battle event's callback (HoennB2 playtest battle.py)
NAMING_CB = 0x02019560
DIRS = {'U': 'UP', 'D': 'DOWN', 'L': 'LEFT', 'R': 'RIGHT'}
DELTA = {'UP': (0, -1), 'DOWN': (0, 1), 'LEFT': (-1, 0), 'RIGHT': (1, 0)}
FACING = {0: 'up', 1: 'down', 2: 'left', 3: 'right'}


def decode(ws):
    out, i = [], 0
    while i < len(ws):
        c = ws[i]
        if c == 0xffff:
            break
        if c == 0xfffe:
            out.append(' ')
        elif c == 0xf000 and i + 2 < len(ws):
            out.append('{%x}' % ws[i + 1])
            i += 3 + ws[i + 2]
            continue
        elif c < 0xd800 or c >= 0xe000:
            out.append(chr(c))
        i += 1
    return ''.join(out)


class P:
    def __init__(self, rom, out):
        self.out = out
        os.makedirs(out, exist_ok=True)
        self.e = Emu(rom)
        self.m = self.e.d.memory.unsigned
        self.seen = set()
        self.film = None                # FILM<name>: ADV keeps a top-screen frame at each new line -> a sheet

    # ---- memory
    def u16(self, a): return self.m.read_short(a)
    def u32(self, a): return self.m.read_long(a)
    @staticmethod
    def ok(p): return 0x02000000 <= p < 0x02400000
    def gsys(self): return self.u32(G_GAMESYS)
    def gdata(self):
        g = self.gsys(); return self.u32(g + 0x1c) if self.ok(g) else 0
    def zone(self):
        d = self.gdata(); return self.u16(d + 0x114) if self.ok(d) else -1
    def field(self):
        g = self.gsys(); return self.u32(g + 0x20) if self.ok(g) else 0
    def event(self):
        g = self.gsys(); return self.u32(g + 0x18) if self.ok(g) else 0
    def idle(self): return self.field() != 0 and self.event() == 0

    def event_chain(self):
        ev, out = self.event(), []
        while self.ok(ev) and len(out) < 8:
            out.append(self.u32(ev + 4) & ~1)
            ev = self.u32(ev)
        return out

    def actors(self):
        d = self.gdata()
        if not self.ok(d): return []
        mm = self.u32(d + 0x1a8)
        if not self.ok(mm): return []
        heap, cap = self.u32(mm + 0x1c), self.u16(mm + 4)
        if not self.ok(heap) or cap > 128: return []
        out = []
        for k in range(cap):
            a = heap + k * 0x100
            if not self.u32(a) & 1: continue
            raw = bytes(self.m[a + i] for i in range(0x48))
            gx, gy, gz = struct.unpack_from('<3h', raw, 0x3c)
            out.append(dict(uid=self.u16(a + 8), flags=hex(self.u32(a)), model=self.u16(a + 0xc), move=self.u16(a + 0xe),
                            scr=self.u16(a + 0x14), face=self.u16(a + 0x18), x=gx, y=gy, z=gz))
        return out

    def me(self):
        return next((a for a in self.actors() if a['uid'] == 255), None)

    def me_world(self):
        """The player's FieldActor wPos and wPosOffset (fx32 -> units) and NNS_G3dGlb's camPos / camTarget (the last
        NNS_G3dGlbLookAt), for REC's per-frame log (pokebw2 field_actor_internal.h, nnsys g3d.h)."""
        d = self.gdata()
        if not self.ok(d): return None
        mm = self.u32(d + 0x1a8)
        if not self.ok(mm): return None
        heap, cap = self.u32(mm + 0x1c), self.u16(mm + 4)
        if not self.ok(heap) or cap > 128: return None
        fx = lambda a, n: [v / 4096 for v in struct.unpack('<%di' % n, bytes(self.m[a + i] for i in range(4 * n)))]
        for k in range(cap):
            a = heap + k * 0x100
            if self.u32(a) & 1 and self.u16(a + 8) == 255:
                glb = 0x02143a0c
                return dict(pos=fx(a + 0x44, 3), off=fx(a + 0x50, 3), cam=fx(glb + 0x240, 3),
                            target=fx(glb + 0x258, 3))
        return None

    def tile(self):
        p = self.me()
        return (p['x'], p['z']) if p else None

    def work(self, w):
        ew = self.u32(self.gdata() + 0x1ac)
        return self.u16(ew + 2 * (w - 0x4000))

    def flag(self, f):
        ew = self.u32(self.gdata() + 0x1ac)
        return (self.m[ew + 2 * 431 + f // 8] >> (f % 8)) & 1

    def party(self):
        pp = self.u32(self.gdata() + 0x194)
        sys.path.insert(0, os.path.join(HERE, 'pt'))
        import party as PT
        out = []
        for i in range(min(6, self.u32(pp + 4))):
            m = PT.decode(bytes(self.m[pp + 8 + 220 * i:pp + 8 + 220 * i + 220]))
            out.append(m and (m['species'], m['level'], m['hp'], m['nick']))
        return out

    # ---- text
    def texts(self):
        ram = np.frombuffer(bytes(self.m[0x02000000:0x02400000]), dtype='<u4')
        now = []
        for h in np.where(ram == STRBUF_MAGIC)[0]:
            a = 0x02000000 + 4 * int(h) - 4
            size, length = struct.unpack('<HH', bytes(self.m[a + i] for i in range(4)))
            if not (1 < length <= size <= 2048): continue
            ws = struct.unpack('<%dH' % length, bytes(self.m[a + 8:a + 8 + 2 * length]))
            s = decode(ws)
            if s.strip(): now.append(s)
        new = [s for s in dict.fromkeys(now) if s not in self.seen]
        self.seen = set(now)
        # keep only expanded lines (a raw line with {1xx} placeholders and its expanded copy appear together)
        return [s for s in new if not ('{1' in s and len(new) > 1)]

    def say(self, *a):
        print(*a, flush=True)

    # ---- stall watchdog (user 2026-10-20: a test sat in one battle for an hour; "that shouldn't end a test, it should
    # come up with a way to resolve it like clicking another move"). No new text and no new tile for PLAY_STALL
    # seconds (default 30) -> a recovery attempt, then the clock restarts: in a battle back out of any menu (B) and
    # take the next move (FIGHT, then RIGHT / DOWN / LEFT in turn), a wild battle also tries RUN; outside one close
    # windows and menus (B), answer an open question (A), step each way once. Only after 5 attempts that change
    # nothing: a screenshot and a savestate named stalled (resume from it with `load stalled`, not a restart),
    # "STALLED: ..." and exit 3.
    def progress(self):
        self._last_progress = time.time()
        self._recoveries = 0

    def recover(self, where):
        k = getattr(self, '_recoveries', 0)
        self.say(f'   (stalled {os.environ.get("PLAY_STALL", "30")} s in {where}: recovery {k + 1})')
        if BATTLE_CB in self.event_chain():
            for _ in range(3): self.press('B', 4, 20)
            self.press('A', 4, 30)                                 # FIGHT
            self.press(['RIGHT', 'DOWN', 'LEFT', 'RIGHT', 'DOWN'][k % 5], 4, 20)
            self.press('A', 4, 40)                                 # that move
            if k % 2 and 'wild' in where:
                for key in ('B', 'B', 'DOWN', 'RIGHT', 'A'): self.press(key, 4, 20)   # RUN
        else:
            for _ in range(3): self.press('B', 4, 20)
            self.press('A', 4, 30)
            for d in ('DOWN', 'LEFT', 'RIGHT', 'UP'):
                self.e.hold(d, 8); self.e.run(12)
        self._recoveries = k + 1
        self._last_progress = time.time()

    def watchdog(self, where):
        if not hasattr(self, '_last_progress'):
            self.progress()
        if time.time() - self._last_progress <= float(os.environ.get('PLAY_STALL', '30')):
            return
        if getattr(self, '_recoveries', 0) < 5:
            self.recover(where)
            return
        try:
            self.shot('stalled'); self.e.save_state(os.path.join(self.out, 'stalled.dst'))
        except Exception:                      # noqa: BLE001
            pass
        self.say(f'STALLED in {where}: 5 recovery attempts changed nothing (zone {self.zone()}, tile {self.tile()}); '
                 f'see stalled.png, resume with `load stalled`')
        sys.exit(3)

    def show_texts(self):
        ts = self.texts()
        if ts: self.progress()
        self.n_texts = getattr(self, 'n_texts', 0) + len(ts)
        for t in ts:
            self.say('   >', t[:220])
            if 'Will you switch your Pok' in t:   # Black 2's Shift style before a trainer's next Pokémon: answer No
                self.switch_prompt = True
            if 'appeared!' in t and 'wild' in t: self._wild = True
            if 'You are challenged' in t: self._wild = False
            if 'no PP left' in t:                  # the first move is used up: the next one (RIGHT, then DOWN, LEFT)
                self.nopp = getattr(self, 'nopp', 0) + 1
            if "doesn't affect" in t or 'doesn’t affect' in t:   # the move can't hit this foe (Aura Sphere on a
                self.nopp = getattr(self, 'nopp', 0) + 1           # Ghost, 2026-10-25): the next one, as for no PP
        if ts and self.film is not None:
            self.film.append(self.e.d.screenshot().copy())

    def film_sheet(self, name, cols=6):
        from PIL import Image
        ims = self.film or []
        self.film = None
        if not ims: return
        w, h = 128, 192                               # both screens, half size
        rows = (len(ims) + cols - 1) // cols
        sheet = Image.new('RGB', (w * min(cols, len(ims)), h * rows))
        for i, im in enumerate(ims):
            sheet.paste(im.resize((w, h)), (w * (i % cols), h * (i // cols)))
        sheet.save(os.path.join(self.out, name + '.png'))
        if os.environ.get('PLAY_FILM_FRAMES') == '1':     # each frame full size too (256x384): <name>_NN.png
            for i, im in enumerate(ims):
                im.save(os.path.join(self.out, f'{name}_{i:02d}.png'))
        self.say('sheet', name, len(ims), 'frames')

    # ---- inputs
    def press(self, k, frames=4, after=16): self.e.press(k, frames, after)

    def shot(self, name):
        self.e.run(2)
        self.e.shot(os.path.join(self.out, name + '.png'))
        self.say('shot', name)

    def choice_menu(self):
        """Black 2's YES/NO window: a dark box with white text at the top screen's right, above the message box
        (measured 2026-10-18: x 212-252, y 78-110)."""
        im = self.e.d.screenshot().crop((0, 0, 256, 192)).convert('RGB')
        reg = np.asarray(im).astype(int)[80:108, 216:252]
        dark, white = (reg.max(axis=2) < 60).mean(), (reg.min(axis=2) > 200).mean()
        return dark > 0.75 and 0.005 < white < 0.2

    def adv(self, answers=(), maxn=900, quiet=40):
        answers = list(answers)
        still, n, last_ev = 0, 0, None
        every = int(os.environ.get('PLAY_FILM_EVERY', '0'))
        while n < maxn:
            n += 1
            if every and self.film is not None and n % every == 0 and self.field() and self.event():
                self.film.append(self.e.d.screenshot().copy())      # people walking between lines
            if n % 3 == 0:
                self.show_texts()
                self.watchdog('ADV' + ((' (wild battle)' if self.wild_now() else ' (battle)') if BATTLE_CB in self.event_chain() else ''))
            if self.field() == 0:
                still = 0
                chain = self.event_chain()
                if BATTLE_CB in chain:
                    self.e.run(20)
                    if getattr(self, 'nopp_done', 0) < getattr(self, 'nopp', 0):
                        self.nopp_done = self.nopp
                        self.e.run(30)
                        self.press(['RIGHT', 'DOWN', 'LEFT'][min(self.nopp, 3) - 1], 4, 20); self.press('A', 4, 20)
                        continue
                    if getattr(self, 'switch_prompt', False):
                        # "Will you switch?" opens the party screen at once (Shift style): only B (back out =
                        # keep battling) for ~5 s, no A, or A would pick a Pokémon (seen 2026-10-19)
                        self.switch_prompt = False
                        for _ in range(8): self.press('B', 4, 36)
                        continue
                    # a battle that shows nothing new for a while sits on a greyed-out move (no PP: Black 2 shows no
                    # message): move the cursor to the next move (RIGHT, DOWN, LEFT in turn) before A
                    n_now = getattr(self, 'n_texts', 0)
                    if n_now == getattr(self, '_bt_n', -1):
                        self._bt_idle = getattr(self, '_bt_idle', 0) + 1
                    else:
                        self._bt_idle, self._bt_n = 0, n_now
                    if self._bt_idle and self._bt_idle % 12 == 0:
                        k = self._bt_idle // 12
                        self.press(['RIGHT', 'DOWN', 'LEFT'][(k - 1) % 3], 4, 20)
                    self.press('A', 4, 20)          # fight: the first move (A on FIGHT, A on the move), text
                    continue
                self.e.run(20)
                if NAMING_CB in chain:
                    self.say('   (naming screen: B to clear, START, A: the default name)')
                    for _ in range(10): self.press('B', 4, 8)
                    for _ in range(int(os.environ.get('PLAY_NAME_TYPE', '0'))):   # (a screen that needs a name:
                        self.press('A', 4, 8)       # Route 224's tablet) that many letters under the cursor
                    self.press('START', 4, 20); self.press('A', 4, 60)
                    continue
                self.press('A', 4, 16)              # other screens (the starter screen, fades): A
                continue
            if self.event() == 0:
                still += 10
                self.e.run(10)
                if still >= quiet:
                    self.show_texts()
                    return True
                continue
            still = 0
            if self.choice_menu():
                a = answers.pop(0) if answers else 'y'
                self.say(f'   (YES/NO -> {"YES" if a == "y" else "NO"})')
                self.press('A' if a == 'y' else 'B', 4, 30)
                continue
            self.press('A', 4, 16)
        self.say('ADV: still running after', maxn, 'presses')
        return False

    def step(self, mv, timeout=48):
        start = self.tile()
        self.watchdog('walking')
        for _ in range(3):
            self.e.d.input.keypad_add_key(keymask(KEYS[mv]))
            self.e.run(6)
            self.e.d.input.keypad_rm_key(keymask(KEYS[mv]))
            last, still = self.tile(), 0
            for _ in range(timeout):
                self.e.run(1)
                now = self.tile()
                still = still + 1 if now == last else 0
                last = now
                if still >= 12 or self.event(): break
            if self.event() or self.field() == 0:
                return 'event'
            if last != start:
                self.progress()
                return True
        return False

    def walkable(self):
        """{(x, z): walkable} of the current zone's whole matrix, from Pearl's own collision (the converted maps keep
        Pearl's tiles: work/pearl/land), water and the tiles of people blocked."""
        import json
        root = os.path.abspath(os.path.join(HERE, '..', '..'))
        if not hasattr(self, '_world'):
            w = json.load(open(os.path.join(root, 'data', 'sinnoh_world.json')))
            self._pearl = {v['b2_zone']: int(k) for k, v in w['zones'].items()}
            self._pearl.update({v['b2_zone']: int(k) for k, v in w['rooms']['zones'].items()})
            self._world = {z['id']: z for z in json.load(open(os.path.join(root, 'work', 'pearl', 'zones.json')))}
            self._grid = {}
        mid = self._world[self._pearl[self.zone()]]['matrix']
        if mid not in self._grid:
            m = json.load(open(os.path.join(root, 'work', 'pearl', 'matrices', f'{mid:03d}.json')))
            tiles = {}
            for cz in range(m['height']):
                for cx in range(m['width']):
                    c = m['maps'][cz][cx]
                    if c == 0xffff: continue
                    land = json.load(open(os.path.join(root, 'work', 'pearl', 'land', f'{c:03d}.json')))
                    for tz in range(32):
                        for tx in range(32):
                            b = land['behaviour'][tz][tx]
                            tiles[(cx * 32 + tx, cz * 32 + tz)] = (not land['collision'][tz][tx]
                                                                   and b not in (0x10, 0x15)) and (
                                'grass' if b in (2, 3) else True)       # tall grass: avoided when possible
            self._grid[mid] = tiles
        return self._grid[mid]

    def route(self, goal, blocked=(), grass=False):
        from collections import deque
        tiles = self.walkable()
        if grass is False:
            r = self.route(goal, blocked, grass=None)
            if r is not None: return r
        ok = (lambda v: v is True) if grass is None else bool
        people = {(a['x'], a['z']) for a in self.actors() if a['uid'] != 255}
        start = self.tile()
        prev, todo = {start: None}, deque([start])
        while todo:
            p = todo.popleft()
            if p == goal:
                path = []
                while prev[p] is not None:
                    q, mv = prev[p]; path.append(mv); p = q
                return path[::-1]
            for mv, (dx, dz) in DELTA.items():
                q = (p[0] + dx, p[1] + dz)
                if q not in prev and (q == goal or (ok(tiles.get(q)) and q not in people and q not in blocked)):
                    prev[q] = (p, mv); todo.append(q)
        return None

    def travel(self, x, z):
        """Walk to (x, z) along Pearl's collision, re-planning around anything that blocks."""
        self.walkable()
        mat = lambda: self._world[self._pearl[self.zone()]]['matrix']
        m0, blocked = mat(), set()
        for _ in range(12):
            if self.tile() == (x, z): return True
            path = self.route((x, z), blocked)
            if path is None: return False
            for mv in path:
                t = self.tile()
                r = self.step(mv)
                if r == 'event' and self.wild_battle():
                    self.say('   (a wild battle on the way)')
                    if os.environ.get('PLAY_RUN') == '1' and self.flee():
                        break
                    if not self.adv(maxn=400):
                        self.shot('stuck_battle')
                        return 'stuck'
                    break                                   # re-plan from where the player is
                if r == 'event': return 'event'
                if self.zone() not in self._pearl or mat() != m0: return 'zone'   # a warp (another map)
                if not r:
                    blocked.add((t[0] + DELTA[mv][0], t[1] + DELTA[mv][1]))
                    break
        return self.tile() == (x, z)

    def flee(self):
        """PLAY_RUN=1: run from a wild battle (Black 2's command screen: FIGHT on top, BAG / RUN / POKEMON below; DOWN
        from FIGHT goes to BAG, seen 2026-10-19, so RUN is DOWN, RIGHT; B first leaves a menu opened by mistake); A
        advances the text. True once the field is back."""
        for _ in range(200):
            self.watchdog('a wild battle (running away)')
            if BATTLE_CB not in self.event_chain() and self.field():
                self.show_texts()
                return True
            self.e.run(20)
            self.show_texts()
            self.press('B', 4, 10); self.press('DOWN', 4, 10); self.press('RIGHT', 4, 10); self.press('A', 4, 20)
        return False

    def wild_now(self):
        """In a wild battle (the latest lines say 'A wild ... appeared')?"""
        return bool(getattr(self, '_wild', False))

    def wild_battle(self):
        z0 = self.zone()
        for _ in range(60):
            if BATTLE_CB in self.event_chain(): return True
            if self.zone() != z0: return False
            self.e.run(2)
        return False

    def go(self, x, z, zfirst=False):
        z0 = self.zone()
        for _ in range(200):
            t = self.tile()
            if t is None or self.zone() != z0:
                return 'zone'
            if t == (x, z):
                return True
            moves = []
            if t[0] != x: moves.append('RIGHT' if x > t[0] else 'LEFT')
            if t[1] != z: moves.append('DOWN' if z > t[1] else 'UP')
            if zfirst: moves.reverse()
            r = False
            for mv in moves:
                r = self.step(mv)
                if r: break
            if r == 'event':
                return 'event'
            if not r:
                return False
        return False


def run_cmds(p, cmds):
    e = p.e
    last_zone = None
    for c in cmds:
        if p.zone() != last_zone:
            last_zone = p.zone(); p.progress()
        if c in KEYS or c in ('A', 'B', 'X', 'Y', 'L', 'R', 'START', 'SELECT'):
            p.press(c, 4, 20)
        elif c[0] == 'W' and c[1:].isdigit():
            e.run(int(c[1:]))
        elif c.startswith('ADV'):
            ans = c[4:].split(',') if c.startswith('ADV:') else []
            r = p.adv(ans)
            p.say('ADV', 'idle' if r else 'not idle', 'zone', p.zone(), 'tile', p.tile())
        elif c.startswith('TO') and c[2:3].isdigit():
            x, z = map(int, c[2:].split(','))
            r = p.travel(x, z)
            p.say(c, '->', r, 'zone', p.zone(), 'tile', p.tile())
        elif c.startswith('GOZ') or c.startswith('GO'):
            zf = c.startswith('GOZ')
            x, z = map(int, c[3 if zf else 2:].split(','))
            r = p.go(x, z, zf)
            p.say(c, '->', r, 'zone', p.zone(), 'tile', p.tile())
        elif c.startswith('STEP'):
            mv, n = DIRS[c[4]], int(c[5:] or 1)
            for _ in range(n):
                r = p.step(mv)
                if r != True: break
            p.say(c, '->', r, 'tile', p.tile())
        elif c.startswith('FACE'):
            e.hold(DIRS[c[4]], 2); e.run(12)
        elif c == 'TALK':
            p.press('A', 4, 20); r = p.adv(); p.say('TALK', 'idle' if r else 'not idle', 'tile', p.tile())
        elif c.startswith('TALKTO'):
            # walk next to actor <uid> (wherever it wandered), face it, talk; retries if it moves away meanwhile
            uid, r = int(c[6:]), None
            for _ in range(6):
                a = next((a for a in p.actors() if a['uid'] == uid), None)
                if a is None: p.say(c, 'no such actor'); break
                spots = [((a['x'], a['z'] + 1), 'U'), ((a['x'] - 1, a['z']), 'R'), ((a['x'] + 1, a['z']), 'L'),
                         ((a['x'], a['z'] - 1), 'D')]
                me = p.tile()
                spots.sort(key=lambda s: abs(s[0][0] - me[0]) + abs(s[0][1] - me[1]))
                for (sx, sz), face in spots:
                    if p.tile() == (sx, sz) or p.travel(sx, sz) is True: break
                else:
                    continue
                now = next((b for b in p.actors() if b['uid'] == uid), a)
                if (now['x'], now['z']) != (a['x'], a['z']): continue      # it moved: go again
                e.hold(DIRS[face], 2); e.run(12)
                n0 = getattr(p, 'n_texts', 0)
                p.press('A', 4, 20); r = p.adv()
                if getattr(p, 'n_texts', 0) > n0: break        # a conversation happened
                r = None                                        # it walked off before A: go again
            p.say(c, 'idle' if r else 'not reached/not idle', 'tile', p.tile())
        elif c == 'ZONE':
            me = p.me()
            p.say('ZONE', p.zone(), 'tile', p.tile(), 'facing', FACING.get(me['face']) if me else None)
        elif c == 'WEATHER':
            d = p.gdata()
            p.say('WEATHER', p.e.d.memory.unsigned[d + 0x1c9] if p.ok(d) else None, 'season',
                  p.e.d.memory.unsigned[d + 0x1c8] if p.ok(d) else None, 'zone', p.zone())
        elif c.startswith('WAITZONE'):
            want = int(c[8:])
            for i in range(600):
                if p.zone() == want and p.field(): break
                e.run(5)
            e.run(30); p.say('WAITZONE', p.zone(), p.tile())
        elif c.startswith('WORK'):
            w = int(c[4:], 16); p.say(f'WORK {w:#06x} =', p.work(w))
        elif c.startswith('FLAG'):
            f = int(c[4:], 0); p.say(f'FLAG {f} =', p.flag(f))
        elif c == 'BAG':                               # the Bag's pockets (GameData +0x190; pt/party.py offsets)
            b = p.u32(p.gdata() + 0x190)
            for name, (off, n) in (('items', (0, 310)), ('key', (0x4d8, 83)), ('tms', (0x624, 109)),
                                   ('medicine', (0x7d8, 48))):
                got = [(p.u16(b + off + 4 * i), p.u16(b + off + 4 * i + 2)) for i in range(n)]
                p.say('BAG', name, [g for g in got if g[0]])
        elif c == 'PARTY':
            p.say('PARTY', p.party())
        elif c == 'MOVES':                             # each party Pokemon's species and four move ids
            pp = p.u32(p.gdata() + 0x194)
            sys.path.insert(0, os.path.join(HERE, 'pt'))
            import party as PT
            ms = [PT.decode(bytes(p.m[pp + 8 + 220 * i:pp + 8 + 220 * i + 220])) for i in range(min(6, p.u32(pp + 4)))]
            p.say('MOVES', [m and (m['species'], list(m['moves'])) for m in ms])
        elif c == 'EXP':                               # party species, level and Exp. Points
            pp = p.u32(p.gdata() + 0x194)
            sys.path.insert(0, os.path.join(HERE, 'pt'))
            import party as PT
            ms = [PT.decode(bytes(p.m[pp + 8 + 220 * i:pp + 8 + 220 * i + 220])) for i in range(min(6, p.u32(pp + 4)))]
            p.say('EXP', [m and (m['species'], m['level'], m['exp']) for m in ms])
        elif c == 'CONFIG':                            # the options u16 (save block 27; SaveControl -> SaveData ->
            sc = p.u32(0x02140f60)                     # its table's block offsets), checked against block 0x2d =
            sv = p.u32(sc + 0x10)                      # GameData's EventWork
            data, blocks = p.u32(sv + 0x34), p.u32(p.u32(sv + 0x2c) + 0x14)
            cfg = p.u16(data + p.u32(blocks + 27 * 12 + 8))
            ew_ok = data + p.u32(blocks + 0x2d * 12 + 8) == p.u32(p.gdata() + 0x1ac)
            p.say(f'CONFIG {cfg:#06x}: bits 11-15 =', [cfg >> b & 1 for b in range(11, 16)],
                  '(Fairy, split, music, sprites, seasons)', 'block check ok' if ew_ok else 'BLOCK CHECK FAILED',
                  '| kept season (GameData +0x1c8):', p.m[p.gdata() + 0x1c8])
        elif c.startswith('WILD'):                     # WILD<dir>: step that way and back in tall grass until a wild
            stop = c.startswith('WILDSTOP')            # battle starts (at most 120 steps), then ADV through it;
            c = 'WILD' + c[8:] if stop else c          # WILDSTOP<dir>: the same, but stop when it starts (to throw a
            d1 = DIRS[c[4]] if len(c) > 4 else 'RIGHT' # ball with TOUCH: 2026-10-25, the Great Marsh)
            d2 = {'RIGHT': 'LEFT', 'LEFT': 'RIGHT', 'UP': 'DOWN', 'DOWN': 'UP'}[d1]
            got = False
            for k in range(120):
                r = p.step(d1 if k % 2 == 0 else d2)
                if r == 'event':
                    got = p.wild_battle()
                    break
            p.say('WILD', 'a battle' if got else 'no battle', 'tile', p.tile())
            if got and not stop:
                r = p.adv()
                p.say('ADV', 'idle' if r else 'not idle', 'zone', p.zone(), 'tile', p.tile())
        elif c == 'ACTORS':
            for a in p.actors(): p.say('  actor', a)
        elif c == 'ROAM' or c.startswith('ROAMSET'):    # the roamers' save block (as CONFIG finds block 27)
            sc = p.u32(0x02140f60)
            sv = p.u32(sc + 0x10)
            data, blocks = p.u32(sv + 0x34), p.u32(p.u32(sv + 0x2c) + 0x14)
            enc = data + p.u32(blocks + 0x37 * 12 + 8)
            if c.startswith('ROAMSET'):
                slot, zone, place = (int(v, 0) for v in c[7:].split(','))
                p.e.d.memory.write_short(enc + 20 * slot, zone)
                p.e.d.memory.write_byte(enc + 40 + slot, place)
            for slot in range(2):
                r = enc + 20 * slot
                p.say('ROAM', slot, 'species', p.u16(r + 12), 'lv', p.m[r + 16], 'active', p.m[r + 18], 'hp',
                      p.u16(r + 14), 'status', p.m[r + 17], 'zone', p.u16(r), 'place', p.m[enc + 40 + slot],
                      'nature', p.m[r + 2], 'pid', hex(p.u32(r + 8)), 'ivs', hex(p.u32(r + 4)))
            p.say('ROAM player prev/cur place+1', p.m[enc + 50], p.m[enc + 51], 'zone now', p.zone())
        elif c.startswith('TOUCH'):
            v = [int(n) for n in c[5:].split(',')]
            e.touch(v[0], v[1], v[2] if len(v) > 2 else 6, 20)
            p.say(c)
        elif c.startswith('REC'):                      # REC<name>,<dir>,<n>,<k>: frames every k for n frames (fixed
            name, d, n, k = c[3:].split(',')           # length: nothing to wait on, so nothing can stall)
            from PIL import Image
            ims, log = [], []
            if d in DIRS:
                e.d.input.keypad_add_key(keymask(KEYS[DIRS[d]]))
            for i in range(int(n)):
                e.run(1)
                if i == 7 and d in DIRS: e.d.input.keypad_rm_key(keymask(KEYS[DIRS[d]]))
                if i % int(k) == 0: ims.append(e.d.screenshot().crop((0, 0, 256, 192)).copy())
                log.append(dict(frame=i, shot=i // int(k) if i % int(k) == 0 else None, zone=p.zone(),
                                **(p.me_world() or {})))
            import json                                # (OUT/<name>.json: the player's world position and the
            json.dump(log, open(os.path.join(p.out, name + '.json'), 'w'))   # camera every frame)
            if d in DIRS and int(n) < 8: e.d.input.keypad_rm_key(keymask(KEYS[DIRS[d]]))
            for i, im in enumerate(ims): im.save(os.path.join(p.out, f'{name}_{i:02d}.png'))
            cols = 8
            sheet = Image.new('RGB', (128 * min(cols, len(ims)), 96 * ((len(ims) + cols - 1) // cols)))
            for i, im in enumerate(ims): sheet.paste(im.resize((128, 96)), (128 * (i % cols), 96 * (i // cols)))
            sheet.save(os.path.join(p.out, name + '.png'))
            p.show_texts(); p.progress()
            p.say(c, len(ims), 'frames; zone', p.zone(), 'tile', p.tile())
        elif c.startswith('SHOT'):
            p.shot(c[4:])
        elif c.startswith('SAVE'):
            e.save_state(os.path.join(p.out, c[4:] + '.dst')); p.say('saved', c[4:])
        elif c.startswith('FILM'):
            p.film, p.film_name = [], c[4:]
        elif c == 'CUT':
            p.film_sheet(p.film_name)
        elif c == 'TEXT':
            p.show_texts()
        else:
            raise SystemExit(f'unknown command {c}')


def main():
    rom, out, mode = sys.argv[1], sys.argv[2], sys.argv[3]
    args = sys.argv[4:]
    if mode == 'boot':
        fresh_battery(rom)
    p = P(rom, out)
    e = p.e
    sav = os.environ.get('PLAY_SAV')                   # PLAY_SAV=file.sav: that battery instead of an empty one
    if mode == 'boot' and sav:                         # (DeSmuME copies it into its own .dsv and resets)
        if not e.d.backup.import_file(os.path.abspath(sav)):
            sys.exit(f'battery {sav} not imported')
        p.say('   battery', sav)
    if mode == 'boot':
        zone, bx, bz = int(args[0]), int(args[1]), int(args[2])
        args = args[3:]
        date = os.environ.get('PLAY_DATE')             # PLAY_DATE=YYYY-MM-DD: the DS clock's date for this run (a
        if date:                                       # DeSmuME movie's RTC start; restarts the console, save in RAM)
            from desmume.emulator import DeSmuME_Date, StartFrom
            y, mo, d = (int(v) for v in date.split('-'))
            e.d.movie.record(os.path.join(out, 'rtc.dsm'), 'story_play', StartFrom.START_BLANK, '',
                             DeSmuME_Date(y, mo, d, int(os.environ.get('EMU_HOUR', '12')), 0, 0, 0))
            p.say('   DS clock date', date)
        e.run(600)
        girl = os.environ.get('PLAY_GIRL') == '1'      # PLAY_GIRL=1: answer Rowan's boy/girl question with the girl
        tries = ['RIGHT', 'DOWN', 'LEFT', 'UP']           # the menu is Lucas (left) / Dawn (right)
        # Rowan's start-of-game questions: PLAY_NO=text,text answers NO (B) to every question whose line contains one
        # of the texts (e.g. "Fairy,songs of Sinnoh,Exp. Share,seasons"); A answers YES as before. PLAY_QSHOTS=1 shoots
        # each two-answer menu (question1.png ...): the menu's last item ("NO", "UNOVA") loads into the message buffer.
        no_q = [t.strip() for t in os.environ.get('PLAY_NO', '').split(',') if t.strip()]
        qshots = os.environ.get('PLAY_QSHOTS') == '1'
        question, nq = None, 0
        for i in range(700):
            if (p.zone() == zone or zone < 0) and p.field(): break
            ts = p.texts() if (girl or no_q or qshots) else []
            if no_q or qshots:
                for t in ts:
                    if t in ('NO', 'UNOVA') and question:
                        nq += 1
                        p.say(f'   question {nq} menu:', 'NO' if any(q in question for q in no_q) else 'YES',
                              '|', question[:60])
                        if qshots: p.shot(f'question{nq}')
                    elif len(t) > 8:
                        question = t
            key = 'B' if question and any(q in question for q in no_q) else 'A'
            if girl:
                if any('so you’re a boy?' in t for t in ts):
                    p.say('   boy confirmed: NO, try again'); e.run(60); p.press('B', 4, 60); continue
                if any('so you’re a girl?' in t for t in ts):
                    p.say('   girl confirmed'); girl = False
                elif any('Or are you a girl?' in t for t in ts):
                    e.run(120); p.press('A', 4, 90)        # the question printed, then closed: the menu opens
                    p.shot('gender_menu')
                    k = tries.pop(0) if tries else 'DOWN'
                    p.say('   gender menu:', k); p.press(k, 4, 30); p.press('A', 4, 30)
                    continue
            e.press('START' if i % 12 == 11 and key == 'A' else key, 4, 20)
        else:
            p.shot('stuck'); sys.exit(f'zone {zone} not reached ({p.zone()})')
        p.say('field of zone', zone, 'up; tile', p.tile())
        e.save_state(os.path.join(out, 'boot.dst'))
    else:
        st = args[0] if os.path.isabs(args[0]) else os.path.join(out, args[0] + '.dst')
        e.load_state(st)
        e.run(2)
        args = args[1:]
    p.texts()
    run_cmds(p, args)
    e.save_state(os.path.join(out, 'last.dst'))


if __name__ == '__main__':
    main()
