"""Run the translated story scripts offline (no ROM, no emulator): a small interpreter of Black 2's script bytecode for
the commands the story uses (flags, works, comparisons, jumps, calls, messages, menus, the starter screen, battles,
map changes with their reserved scripts, map-script tables), over the assembled files of src/field_scripts, their
text files and Pearl's events. Every other command is stepped over by its argument sizes (pokebw2's command table).

    python3 story_sim.py chapter1 [--boy|--girl] [--lose]     the Chapter 1 walk-through (below), messages printed
    python3 story_sim.py run ZONE SCRIPT                      one script of a Black 2 zone

What it shows: that the scripts decode, run to their end in the order Pearl's story needs, set the vars and flags the
next scene waits for, show the right lines (with the right names in), and that map changes land where the next scene
starts. What it cannot show: anything visual or timed (movement, windows, the battle itself).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, 'patches'))
import b2_script_check  # noqa: E402

DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
_ID = None


def cmd_ids():
    global _ID
    if _ID is None:
        src = open(os.path.join(DECOMP, 'include', 'asm', 'field_script.inc')).read()
        _ID = {}
        for name, body in re.findall(r'\.macro (\w+)[^\n]*\n((?:.*\n)*?)\s*\.endm', src):
            m = re.search(r'FieldCommand (\d+)', body)
            if m:
                _ID[int(m.group(1))] = name
    return _ID


class Halt(Exception):
    pass


class World:
    def __init__(self, gender=0, win=True, starter=0, answers=None, verbose=True):
        import pearl_story, pearl_ids, pearl_events
        import scripts as scripts_patch
        self.pd = pearl_story.PearlData()
        self.ids = pearl_ids.Ids()
        self.pe = pearl_events
        self.asm = scripts_patch.assemble
        self.flags, self.works = set(), {}
        self.gender, self.win, self.starter = gender, win, starter
        self.answers = list(answers or [])
        self.party = []
        self.log = []
        self.verbose = verbose
        self.zone = None
        self.pos = (0, 0)
        self.reserved = None
        self.pending_map = None
        self._files, self._text = {}, {}
        self.rival, self.player = 'BARRY', 'PLAYER'
        self.follower = False
        b2 = {v: k for k, v in self.pd.b2_zone.items()}
        self.pearl_of = b2

    # ---- data
    def zone_file(self, b2zone):
        """(binary, text lines, Pearl zone) of a Black 2 zone with a translated file."""
        pz = self.pd.zones[self.pearl_of[b2zone]]
        num = self.pd.script_file(pz)
        if num not in self._files:
            path = next(p for p in os.listdir(os.path.join(ROOT, 'src', 'field_scripts')) if p.startswith(f'{num:04d}_'))
            self._files[num] = self.asm(os.path.join(ROOT, 'src', 'field_scripts', path))
        tnum = self.pd.text_file(pz)
        if tnum not in self._text:
            path = next(p for p in os.listdir(os.path.join(ROOT, 'src', 'text', 'script')) if p.startswith(f'{tnum:04d}_'))
            self._text[tnum] = [l.split(' = ', 1)[1].rstrip('\n') if ' = ' in l else ''
                                for l in open(os.path.join(ROOT, 'src', 'text', 'script', path), encoding='utf-8')]
        return self._files[num], self._text[tnum], pz

    # ---- the VM
    def get(self, w):
        return self.works.get(w, 0)

    def any_(self, v):
        return self.get(v) if v >= 0x4000 else v

    def say(self, kind, text, words):
        def word(m):
            return words.get(int(m.group(2)), f'[{m.group(1)}:{m.group(2)}]')
        t = re.sub(r'\{(01[0-9a-f]{2}|02[0-9a-f]{2}):(\d+)\}', word, text)
        t = re.sub(r'\{be0[01]\}|\{ff00:\d+\}', '', t).replace('\\n', ' ')
        self.log.append(f'{kind}: {t}')
        if self.verbose:
            print(f'      {kind}: {t[:150]}')

    def run(self, b2zone, sid, label=''):
        data, text, pz = self.zone_file(b2zone)
        ents = b2_script_check.entries(data)
        if not 1 <= sid <= len(ents):
            raise SystemExit(f'zone {b2zone}: no script {sid}')
        if self.verbose:
            print(f'  run {pz["name"]} script {sid} {label}')
        pc, stack, cmp_, words, local = ents[sid - 1], [], 1, {}, {}
        cmds = b2_script_check.commands()
        names = cmd_ids()
        steps = 0
        saved = dict(self.works)
        while True:
            steps += 1
            if steps > 100000:
                raise SystemExit(f'zone {b2zone} script {sid}: no end after 100000 commands')
            op, = struct.unpack_from('<H', data, pc)
            c = cmds[op]
            p, vals = pc + 2, []
            for ty in c['args']:
                n = b2_script_check.SIZES[ty]
                vals.append(int.from_bytes(data[p:p + n], 'little', signed=(ty == 'u32')))
                p += n
            name = names.get(op, c['handler'])
            nxt = p
            if name == 'VMHalt':
                break
            elif name == 'VMReturn':
                if not stack:
                    break
                nxt = stack.pop()
            elif name == 'VMCall':
                stack.append(p); nxt = p + vals[0]
            elif name == 'VMJump':
                nxt = p + vals[0]
            elif name in ('VMJumpIf', 'VMCallIf'):
                cond = vals[0]
                lut = [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (0, 1, 1), (1, 0, 1)]
                if cond != 0xFF and lut[cond][cmp_]:
                    if name == 'VMCallIf':
                        stack.append(p)
                    nxt = p + vals[1]
            elif name == 'WorkCmpConst':
                a, b = self.get(vals[0]), vals[1]
                cmp_ = 0 if a < b else 1 if a == b else 2
            elif name == 'WorkCmpWork':
                a, b = self.get(vals[0]), self.get(vals[1])
                cmp_ = 0 if a < b else 1 if a == b else 2
            elif name == 'FlagSet':
                self.flags.add(self.any_(vals[0]))
            elif name == 'FlagReset':
                self.flags.discard(self.any_(vals[0]))
            elif name == 'FlagGet':
                self.works[vals[1]] = int(self.any_(vals[0]) in self.flags)
            elif name == 'WorkSetConst':
                self.works[vals[0]] = vals[1]
            elif name == 'WorkGet':
                self.works[vals[0]] = self.get(vals[1])
            elif name == 'WorkSet':
                self.works[vals[0]] = self.any_(vals[1])
            elif name == 'WorkAdd':
                self.works[vals[0]] = (self.get(vals[0]) + self.any_(vals[1])) & 0xFFFF
            elif name == 'WorkSub':
                self.works[vals[0]] = (self.get(vals[0]) - self.any_(vals[1])) & 0xFFFF
            elif name == 'RTReserveScript':
                self.reserved = vals[0]
            elif name == 'MapChangeCore':
                self.pending_map = (vals[0], vals[1], vals[3])
            elif name in ('SystemMsg', 'MsgPlaceSign'):
                self.say('sign' if name == 'MsgPlaceSign' else 'msg', text[self.any_(vals[0])], words)
            elif name in ('ActorMsg', 'ParentActorMsg'):
                self.say('talk', text[self.any_(vals[1])], words)
            elif name == 'ActorMsgGendered':
                self.say('talk', text[vals[1] if self.gender == 0 else vals[2]], words)
            elif name == 'YesNoWin':
                self.works[vals[0]] = self.answers.pop(0) if self.answers else 0
            elif name == 'TrainerCardGetSex':
                self.works[vals[0]] = self.gender
            elif name == 'PlayerGetGPos':
                self.works[vals[0]], self.works[vals[1]] = self.pos
            elif name == 'RTGetZoneID':
                self.works[vals[0]] = self.zone
            elif name == 'callPoke3Select':
                self.works[vals[0]] = self.starter
                self.log.append(f'starter screen: ball {self.starter}')
            elif name == 'PokePartyAdd':
                self.party.append(self.any_(vals[1]))
                self.works[vals[0]] = 1
                self.log.append(f'received Pokemon {self.any_(vals[1])} Lv {self.any_(vals[3])}')
                if self.verbose:
                    print(f'      ** received species {self.any_(vals[1])} at Lv {self.any_(vals[3])}')
            elif name == 'PokePartyGetSpecies':
                i = self.any_(vals[1])
                self.works[vals[0]] = self.party[i] if i < len(self.party) else 0
            elif name == 'PokePartyGetCount':
                self.works[vals[0]] = len(self.party)
            elif name == 'CallWildBattle':
                self.log.append(f'wild battle {self.any_(vals[0])} Lv {self.any_(vals[1])}')
                if self.verbose:
                    print(f'      ** wild battle: species {self.any_(vals[0])} Lv {self.any_(vals[1])}'
                          f' ({"won" if self.win else "lost"})')
            elif name in ('WildBattleIsVictory', 'TrainerBattleIsVictory'):
                self.works[vals[0]] = int(self.win)
            elif name == 'GiveRunningShoes':
                self.flags.add(2403)
                self.log.append('Running Shoes')
            elif name == 'PokeDexEnable':
                self.log.append('Pokedex')
            elif name == 'ItemAdd':
                self.log.append(f'item {self.any_(vals[0])} x{self.any_(vals[1])}')
                self.works[vals[2]] = 1
            elif name == 'ItemCheckSpace':
                self.works[vals[2]] = 1
            elif name == 'WordSetPlayerName':
                words[vals[0]] = self.player
            elif name == 'WordSetLoadRivalName':
                words[vals[0]] = self.rival
            elif name in ('WordSetPokeSpecies', 'WordSetItemName', 'WordSetPartyPokeSpecies', 'WordSetItemPocketName'):
                words[vals[0]] = f'<{name[7:]} {self.any_(vals[1])}>'
            elif name == 'Random':
                self.works[vals[0]] = 0
            elif name == 'ActorPairSet':
                self.flags.add(0x966)
                self.follower = True
            elif name == 'ActorPairEnd':
                self.flags.discard(0x966)
                self.follower = False
            elif name == 'RTCallGlobal':
                self.log.append(f'Black 2 global script {vals[0]}')
            nxt_ok = 0 <= nxt < len(data)
            if not nxt_ok:
                raise SystemExit(f'zone {b2zone} script {sid}: ran off the file at {pc:#x}')
            pc = nxt

    # ---- the field
    def map_scripts(self, b2zone):
        """([(Black 2 type, script)], [(work, value, script)]) of a zone, as sinnoh_story installs them."""
        data, text, pz = self.zone_file(b2zone)
        body, levels = self.pe.map_script_table(self.pd, pz, self.ids)
        entries, conds, p = [], [], 0
        while struct.unpack_from('<H', body, p)[0]:
            t, v = struct.unpack_from('<HI', body, p)
            if t == 1:
                q = p + 6 + v
                while struct.unpack_from('<H', body, q)[0]:
                    conds.append(struct.unpack_from('<HHH', body, q))
                    q += 6
            else:
                entries.append((t, v))
            p += 6
        return entries, conds

    def enter(self, b2zone, x=0, z=0):
        """A map change: zone init, field load, the reserved script, then the condition table."""
        self.zone, self.pos = b2zone, (x, z)
        if self.verbose:
            print(f'enter zone {b2zone} ({self.pd.zones[self.pearl_of[b2zone]]["name"]}) at ({x},{z})')
        if self.follower:
            pass
        entries, conds = self.map_scripts(b2zone)
        for t, s in entries:
            if t == 2:
                self.run(b2zone, s, '(zone init)')
        for t, s in entries:
            if t == 3:
                self.run(b2zone, s, '(field load)')
        if self.reserved:
            r, self.reserved = self.reserved, None
            self.run(b2zone, r, '(reserved)')
            self.after()
        self.settle()

    def settle(self):
        """Run the condition table until no condition holds (Black 2 checks it whenever no script runs)."""
        for _ in range(20):
            if self.pending_map:
                return self.after()
            entries, conds = self.map_scripts(self.zone)
            hit = next(((w, v, s) for w, v, s in conds if self.get(w) == v), None)
            if not hit:
                return
            self.run(self.zone, hit[2], f'(condition work {hit[0]:#x} == {hit[1]})')
            self.after()
        raise SystemExit(f'zone {self.zone}: a condition script keeps running (its work never changes)')

    def after(self):
        if self.pending_map:
            z, x, zz = self.pending_map
            self.pending_map = None
            self.enter(z, x, zz)

    def trigger(self, x, z):
        """The player steps on (x, z): the zone's step trigger there, if its work has its value."""
        data, text, pz = self.zone_file(self.zone)
        npcs, signs, trigs, skipped = self.pe.entities(self.pd, pz, self.ids, self.pe.Heights(),
                                                       lambda s: s if s < 2000 else self.pd.proxy_ids().get(s, s))
        self.pos = (x, z)
        for t in trigs:
            if t['x'] <= x < t['x'] + t['w'] and t['z'] <= z < t['z'] + t['h'] and self.get(t['work']) == t['value']:
                self.run(self.zone, t['script'], f'(step trigger at ({x},{z}))')
                self.after()
                self.settle()
                return True
        if self.verbose:
            print(f'  (no trigger fires at ({x},{z}))')
        return False

    def talk(self, uid):
        data, text, pz = self.zone_file(self.zone)
        npcs, signs, trigs, skipped = self.pe.entities(self.pd, pz, self.ids, self.pe.Heights(),
                                                       lambda s: s if s < 2000 else self.pd.proxy_ids().get(s, s))
        n = next(n for n in npcs if n['uid'] == uid)
        if n['flag'] and n['flag'] in self.flags:
            raise SystemExit(f'object {uid} is hidden (flag {n["flag"]} set)')
        self.run(self.zone, n['script'], f'(talk to object {uid})')
        self.after()
        self.settle()

    def read(self, i):
        data, text, pz = self.zone_file(self.zone)
        npcs, signs, trigs, skipped = self.pe.entities(self.pd, pz, self.ids, self.pe.Heights(), lambda s: s)
        self.run(self.zone, signs[i]['script'], f'(read sign {i})')
        self.settle()

    def new_game(self):
        """Black 2's new-game event: zone 427 loaded, zone init, scripts 29 and 30 (then the map change)."""
        self.zone = 427
        entries, conds = self.map_scripts(427)
        for t, s in entries:
            if t == 2:
                self.run(427, s, '(zone init)')
        self.run(427, 29, '(new game)')
        self.run(427, 30, '(new game)')
        self.after()


def chapter1(gender=0, win=True, starter=0):
    w = World(gender=gender, win=win, starter=starter, answers=[1, 0])   # nickname? no; Pokedex? yes
    pid = lambda n: w.pd.b2_zone[w.pd.by_name[n]['id']]
    w.new_game()                                             # -> the player's room: the TV
    w.enter(pid('MAP_TWINLEAF_RIVAL_HOUSE_1F'), 10, 3)       # downstairs: Mom
    w.trigger(6, 10)                                         # the door: "don't go into the tall grass"
    w.enter(427, 116, 886)                                   # out into Twinleaf
    w.trigger(105, 876)                                      # Barry's door: Thud!!
    w.enter(pid('MAP_TWINLEAF_PLAYER_HOUSE_1F'), 0, 0)       # Barry's house (pokediamond's name)
    w.talk(0)                                                # Barry's mom
    w.enter(pid('MAP_TWINLEAF_PLAYER_HOUSE_2F'), 0, 0)       # Barry's room: he leaves
    w.enter(427, 108, 868)
    w.trigger(110, 867)                                      # the north exit (open now: no trigger)
    w.enter(pid('MAP_ROUTE_201'), 110, 858)
    w.trigger(110, 857)                                      # Barry joins
    w.enter(pid('MAP_VERITY_LAKEFRONT'), 80, 845)
    w.trigger(80, 844)                                       # to the lake -> Lake Verity, the briefcase, back
    w.enter(pid('MAP_ROUTE_201'), 102, 853)
    w.trigger(101, 853)                                      # Rowan -> home
    w.enter(427, 116, 886)
    w.enter(pid('MAP_ROUTE_201'), 110, 858)
    w.enter(pid('MAP_SANDGEM'), 164, 843)
    w.trigger(164, 843)                                      # Dawn/Lucas -> the lab -> the tour
    w.enter(pid('MAP_SANDGEM'), 168, 843)
    w.enter(427, 116, 886)
    w.enter(pid('MAP_TWINLEAF_RIVAL_HOUSE_1F'), 6, 9)
    w.talk(0)                                                # Mom: the Journal and the Parcel
    return w


def main(argv):
    if argv[:1] == ['chapter1']:
        w = chapter1(gender=1 if '--girl' in argv else 0, win='--lose' not in argv)
        print(f'\nparty {w.party}; Running Shoes {2403 in w.flags}; {len(w.log)} events')
        return 0
    if argv[:1] == ['run']:
        w = World()
        w.zone = int(argv[1])
        w.run(int(argv[1]), int(argv[2]))
        return 0
    print(__doc__)
    return 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
