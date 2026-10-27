"""Pearl script file -> Black 2 field-script source (notes/STORY.md).

    python3 pearl_story.py zones NAME|ID ...    translate those Pearl zones into src/field_scripts/NNNN_pearl_<zone>.s and
                                                 their text into src/text/script/NNNN_pearl_<zone>.txt (and assemble)
    python3 pearl_story.py chapter 1            the zones of a chapter (CHAPTERS below)
    python3 pearl_story.py report               translate every Pearl zone's script file offline into
                                                 work/pearl/b2_scripts/ (not installed), assemble each, and write the
                                                 coverage report there (report.txt)
    python3 pearl_story.py show FILE            print the translation of one Pearl script file (stdout)

How (details in notes/STORY.md):
- Pearl's scripts are read from the dump (roms/pearl.nds, fielddata/script/scr_seq_release.narc) with gen4_script's
  disassembler (pokediamond's command table, b2tools/data/gen4_script_cmds.json). Every command is translated by a
  handler below into a macro of src/include/pearl_story.inc (pl_ + the command's name: Platinum's name for the opcode
  below 0x2C4, where Platinum numbers commands as pokediamond does, else pokediamond's) or into Black 2 commands.
  A command with no handler becomes `pl_stub Name` (no code), its Pearl command and arguments in a comment, counted
  per file in the report: nothing is dropped silently.
- Labels: P<file>_<addr> (Pearl byte offsets), scripts P<file>_S<n>. Only code reachable from the scripts is emitted.
  Movement lists keep Pearl's codes (the same in Black 2: b2tools/data/pearl_movement.json), after `.balign 4, 0`.
- Pearl's common scripts (CallCommonScript id >= 2000: pokediamond LoadScriptsAndMessagesByMapId's ranges,
  SCRIPT_RANGES) run as a sub-script sharing the vars in Pearl; here each one a zone uses becomes a subroutine of the
  zone's file (VMCall; ReturnCommonScript and End -> VMReturn), its lines appended to the zone's text file.
  NATIVE_COMMON lists the ones Black 2 does itself.
- Warps: Pearl's script goes on in the new map after Warp; Black 2's MapChangeCore changes the map when the script
  ends, and a reserved script runs on arrival. So the code after each Pearl Warp becomes a script of the destination
  zone's file ("continuation", entries after Pearl's own: warp_continuations), and the Warp itself RTReserveScript +
  MapChangeCore. Every generated file also ends with PearlArrive (fade in, release) for warps with nothing after them.
- Ids: flags, vars and trainers by their names in src/include/pearl.h (b2tools/pearl_ids.py, data/pearl_story_ids.json).
- Text: the zone's Pearl bank line for line (b2tools/gen4_text.py: Pearl's own text from the dump, converted to Black 2's
  codes), then the common scripts' and continuations' lines and the boy/girl copies of lines naming the counterpart.
- Who speaks: lines of a talk script (an NPC's) are said by that NPC (Black 2's balloon, ParentActorMsg); others use
  Black 2's plain window (SystemMsg), Pearl's own look; data/pearl_speakers.json can name the actor of a line
  ({"MAP_X": {"<pearl line>": uid}}).
"""
import collections, json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from gen4rom import Rom, narc_members  # noqa: E402
import gen4_script  # noqa: E402

PEARL = os.path.join(ROOT, 'work', 'pearl')
PLATINUM = os.path.join(ROOT, 'external', 'pokeplatinum')
SRC_SCRIPTS = os.path.join(ROOT, 'src', 'field_scripts')
SRC_TEXT = os.path.join(ROOT, 'src', 'text', 'script')
OFFLINE = os.path.join(PEARL, 'b2_scripts')
SPEAKERS = os.path.join(ROOT, 'data', 'pearl_speakers.json')
# Closed places (2026-10-25, chapters 4a/5a: the Contest counters, Amity Square, the Great Marsh): places Pearl has and
# this game does not build yet. data/pearl_closed_facilities.json, keyed by Pearl map name ("MAP_..."), a list of rows:
#   {"x", "z", "w", "h", "dir", "text"}      a step trigger (work 0: always) on those tiles; walking onto it shows text in
#                                            the plain window, then the player steps once in dir (Pearl's 0 up, 1 down,
#                                            2 left, 3 right): pl_closed_facility line, dir
#   {"talk": true, "obj": id, "text"}        the person with that Pearl object id shows text instead of its script
#   {"talk": true, "bg": index, "text"}      the same for the sign (bg event) with that index in Pearl's bg_events
#   {"talk": true, "obj": id, "musical": true, "text"}   (2026-10-25, the user: "for contests use musicals") that
#                                            person is a Pokémon Musical receptionist (src/include/pearl_musical.inc:
#                                            pl_musical_reception greeting, first): text is the greeting, in Pearl
#                                            spelling (\r a new page); the Musical's own lines (MUSICAL) are added once
#                                            to the zone's text
# text: plain words, "\n" breaks the line (the plain window is 224 px wide). Each row is a script entry after the
# zone's PearlArrive (PearlData.closed_ids), its line appended to the zone's text; pearl_events.entities adds the
# trigger or points the person/sign at the entry.
CLOSED = os.path.join(ROOT, 'data', 'pearl_closed_facilities.json')
MUSICAL = os.path.join(ROOT, 'data', 'pearl_musical.json')                # the Musical's lines (Black 2's)
MUSICAL_INC = os.path.join(ROOT, 'src', 'include', 'pearl_musical.inc')   # their order: its MUSL_* defines
# Pearl's elevators (2026-10-25, chapter 4a). Pearl's GetDynamicWarpFloorNumber (GetFloorsAbove var) gives the floors
# above the map the player came into the elevator from (the dynamic warp the elevator's exit, dest warp 0x100, goes
# back to: pokeplatinum field_map_change.c, SetSpecialLocation / FieldMenu_GetFloorsAbove); SetDynamicWarp
# (SetSpecialLocation) points that exit at the chosen floor. Black 2 keeps the same spot (GameData nextSpawn, set on
# the way in and by FieldSetNextZone) but no script command reads it, so: every floor below sets Pearl's own
# VAR_ELEVATOR_FLOORS_ABOVE (0x40CE) in a zone-init entry, the elevator room copies it into PL_ELEVATOR_FROM when
# the player walks in, GetFloorsAbove reads that, and SetSpecialLocation is FieldSetNextZone + the new floor there.
# Floors above per Pearl map: pokediamond MapNumToFloorNo (ov05 0x021E2608), any other map 1.
ELEVATOR_FLOORS_ABOVE = {11: 3, 12: 2, 13: 1, 14: 0,                 # Jubilife TV 1F-4F
                         103: 1, 104: 0, 112: 1, 113: 0,             # Hearthome south-east / north-east houses
                         137: 4, 138: 3, 139: 2, 140: 1, 141: 0,     # Veilstone Department Store 1F-5F
                         150: 1, 164: 0,                             # Sunyshore, the Vista Lighthouse deck
                         461: 1, 462: 0}                             # Resort Area Ribbon Syndicate 1F/2F
FIRST_SCRIPT_FILE = 1290        # a/0/5/6: Black 2 has 0-1288, 1289 = 1289_twinleaf_newgame.s; Pearl zone files after
FIRST_TEXT_FILE = 676           # a/0/0/3: Black 2 has 0-675; Pearl zone text files after
NEWGAME_ZONE = 'MAP_TWINLEAF'   # Black 2 loads zone 427 first and runs its scripts 29 and 30 (notes/WORLD.md)
NEWGAME_ENTRIES = (29, 30, 31)
PEARL_START = ('MAP_TWINLEAF_RIVAL_HOUSE_2F', 4, 6, 0)    # Pearl's start: the player's room, (4, 6) facing up
# (pokeplatinum location.c sPlayerStartLocation; the tile is walkable here). pokediamond's names of zones 412-415 are
# swapped: 412/413 ("PLAYER_HOUSE") are Barry's house, 414/415 ("RIVAL_HOUSE") the player's (by their scripts and text,
# and Platinum's own header order). data/sinnoh_world.json keeps pokediamond's names.
FIRST_PROXY = 48                # Pearl global scripts that people/signs/triggers run: proxy entries from here, the same
                                # number in every zone file (a follower carries its script id from zone to zone)
FOLLOW = 0x30                   # Pearl's (and Black 2's) "follow the player" movement type
PARTNER_VAR = 0x403F            # Pearl's partner trainer (pokediamond sub_0205F368, read by StartTrainerBattle while
                                # SetHasPartner is on): Cheryl 608 in Eterna Forest (2026-10-25, chapter 3)

CHAPTERS = {
    1: ['MAP_TWINLEAF', 'MAP_TWINLEAF_PLAYER_HOUSE_1F', 'MAP_TWINLEAF_PLAYER_HOUSE_2F', 'MAP_TWINLEAF_RIVAL_HOUSE_1F',
        'MAP_TWINLEAF_RIVAL_HOUSE_2F', 'MAP_TWINLEAF_NORTHEAST_HOUSE', 'MAP_TWINLEAF_SOUTHWEST_HOUSE', 'MAP_ROUTE_201',
        'MAP_VERITY_LAKEFRONT', 'MAP_LAKE_VERITY', 'MAP_SANDGEM', 'MAP_SANDGEM_ROWANS_LAB',
        'MAP_SANDGEM_PROFESSOR_ASSISTANT_HOUSE_1F', 'MAP_SANDGEM_PROFESSOR_ASSISTANT_HOUSE_2F',
        'MAP_SANDGEM_SOUTHWEST_HOUSE', 'MAP_SANDGEM_POKEMART', 'MAP_SANDGEM_POKECENTER_1F'],
    # Chapter 2 (2026-10-18): Route 202 to Roark's Gym. Left out: Jubilife's south-east house 4F (on Pearl's
    # empty script file 368 with nothing to install: data/story_chapters.json "skip"), the Pokémon Center 2F/B1F
    # rooms (the shared 2F: pearl_centers) and the Route 218 gate (a later chapter)
    2: ['MAP_ROUTE_202', 'MAP_JUBLIFE', 'MAP_JUBLIFE_POKEMART', 'MAP_JUBLIFE_POKETCH_COMPANY_1F',
        'MAP_JUBLIFE_POKETCH_COMPANY_2F', 'MAP_JUBLIFE_POKETCH_COMPANY_3F', 'MAP_JUBLIFE_TV_1F', 'MAP_JUBLIFE_TV_2F',
        'MAP_JUBLIFE_TV_3F', 'MAP_JUBLIFE_TV_4F', 'MAP_JUBLIFE_TV_2F_GALLERY', 'MAP_JUBLIFE_TV_3F_GLOBAL_RANKINGS',
        'MAP_JUBLIFE_TV_3F_GROUP_RANKINGS', 'MAP_JUBLIFE_TV_ELEVATOR', 'MAP_JUBLIFE_SOUTHEAST_HOUSE_1F',
        'MAP_JUBLIFE_SOUTHEAST_HOUSE_2F', 'MAP_JUBLIFE_SOUTHEAST_HOUSE_3F', 'MAP_JUBLIFE_CONDOMINIUMS_1F',
        'MAP_JUBLIFE_CONDOMINIUMS_2F', 'MAP_JUBLIFE_CONDOMINIUMS_3F', 'MAP_JUBLIFE_CONDOMINIUMS_4F',
        'MAP_JUBLIFE_GLOBAL_TRADE_STATION', 'MAP_JUBLIFE_TRAINER_SCHOOL', 'MAP_JUBLIFE_SOUTHWEST_HOUSE_1F',
        'MAP_JUBLIFE_SOUTHWEST_HOUSE_2F', 'MAP_JUBLIFE_UNUSED_HOUSE_2', 'MAP_JUBLIFE_UNUSED_HOUSE_3', 'MAP_ROUTE_203',
        'MAP_OREBURGH_GATE_1F', 'MAP_OREBURGH_GATE_B1F', 'MAP_OREBURGH', 'MAP_OREBURGH_POKEMART', 'MAP_OREBURGH_GYM',
        'MAP_OREBURGH_NORTHWEST_HOUSE_1F', 'MAP_OREBURGH_NORTHWEST_HOUSE_2F', 'MAP_OREBURGH_NORTHWEST_HOUSE_3F',
        'MAP_OREBURGH_NORTHWEST_HOUSE_4F', 'MAP_OREBURGH_NORTH_HOUSE_1F', 'MAP_OREBURGH_NORTH_HOUSE_2F',
        'MAP_OREBURGH_NORTH_HOUSE_3F', 'MAP_OREBURGH_NORTH_HOUSE_4F', 'MAP_OREBURGH_MIDDLE_HOUSE',
        'MAP_OREBURGH_MINING_MUSEUM', 'MAP_OREBURGH_WEST_HOUSE', 'MAP_OREBURGH_EAST_HOUSE_1F',
        'MAP_OREBURGH_EAST_HOUSE_2F', 'MAP_OREBURGH_EAST_HOUSE_3F', 'MAP_OREBURGH_SOUTH_HOUSE',
        'MAP_OREBURGH_MINE_B1F', 'MAP_OREBURGH_MINE_B2F'],
    # every Pokémon Center 1F (nurse, PC, people), ahead of the story: healing everywhere (2026-10-18, the lead)
    90: [f'MAP_{t}_POKECENTER_1F' for t in ('JUBLIFE', 'CANALAVE', 'OREBURGH', 'ETERNA', 'HEARTHOME', 'PASTORIA',
                                            'VEILSTONE', 'SUNYSHORE', 'SNOWPOINT', 'POKEMON_LEAGUE', 'FIGHT_AREA',
                                            'FLOAROMA', 'SOLACEON', 'CELESTIC', 'SURVIVAL_AREA', 'RESORT_AREA')],
}

# Chapters 3-9 (and 'skip'): data/story_chapters.json (b2tools/story_chapters.py, notes/STORY_CHAPTERS.md)
_CH = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data', 'story_chapters.json')
if os.path.exists(_CH):
    for _k, _v in json.load(open(_CH)).items():
        if _k != '_doc':
            CHAPTERS.setdefault(int(_k) if _k.isdigit() else _k, _v)


# ---------------------------------------------------------------- Pearl data

class PearlData:
    def __init__(self):
        rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
        self.files = narc_members(rom.read('fielddata/script/scr_seq_release.narc'))
        self.table = gen4_script.load_table()
        self.zones = json.load(open(os.path.join(PEARL, 'zones.json')))
        self.by_name = {z['name']: z for z in self.zones}
        self.world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
        self.b2_zone = {int(k): v['b2_zone'] for k, v in self.world['zones'].items()}
        self.b2_zone.update({int(k): v['b2_zone'] for k, v in self.world['rooms']['zones'].items()})
        self.level_files = {z['level_scripts'] for z in self.zones}
        self._dis, self._ev = {}, {}
        script_files = sorted({z['scripts'] for z in self.zones})
        self.script_file_no = {f: FIRST_SCRIPT_FILE + i for i, f in enumerate(script_files)}
        banks = sorted({z['text_bank'] for z in self.zones})
        self.text_file_no = {b: FIRST_TEXT_FILE + i for i, b in enumerate(banks)}
        self._own_text = None                       # text_file(): own numbers of files on a shared bank
        self._own_zone = None                       # script_file(), text_file(): zones on a shared script file
        self.names = platinum_names()
        self._warps = None

    def disasm(self, f):
        if f not in self._dis:
            self._dis[f] = gen4_script.Disasm(self.files[f], self.table)
        return self._dis[f]

    def events(self, zone):
        n = zone['events']
        if n not in self._ev:
            self._ev[n] = json.load(open(os.path.join(PEARL, 'events', f'{n:03d}.json')))
        return self._ev[n]

    def cmd_name(self, op):
        """Platinum's name for an opcode below 0x2C4 (its numbering = pokediamond's there), else pokediamond's."""
        if op < 0x2C4 and op in self.names:
            return self.names[op][0]
        return self.table[op]['name']

    def bank_of(self, f):
        """The text bank a script file's messages come from (its zone's, or its global range's)."""
        for z in self.zones:
            if z['scripts'] == f:
                return z['text_bank']
        for first, ff, bank in SCRIPT_RANGES:
            if ff == f:
                return bank
        return None

    def shared_file_zones(self):
        """{zone id: rank} of the zones on a script file several zones share: Pearl's empty file 368 (one End;
        MAP_EVERYWHERE's), which 114 zones with no scripts of their own use. Each of them gets its own Black 2 script
        and text file (script_file, text_file): a translated file holds the zone's own entries (the proxies of the
        global scripts its people and signs run, its warp continuations, PearlArrive) and its text the lines of
        those, so one file for all 114 would give every one of them the last zone's (2026-10-25, chapter 4a). Ranked
        by zone id over all such zones, installed or not, so the numbers never move."""
        if self._own_zone is None:
            users = collections.Counter(z['scripts'] for z in self.zones)
            shared = sorted(z['id'] for z in self.zones if users[z['scripts']] > 1)
            self._own_zone = {zid: i for i, zid in enumerate(shared)}
        return self._own_zone

    def script_file(self, zone):
        """a/0/5/6 number of a zone's script file: its Pearl file's (FIRST_SCRIPT_FILE + rank), or for a zone on a
        shared file (shared_file_zones) its own, after the last Pearl file's."""
        own = self.shared_file_zones().get(zone['id'])
        if own is not None:
            return FIRST_SCRIPT_FILE + len(self.script_file_no) + own
        return self.script_file_no[zone['scripts']]

    def zones_of_script_file(self):
        """{a/0/5/6 number: [Pearl zones installed from it]} (sinnoh_story, pearl_trainers)."""
        out = collections.defaultdict(list)
        for z in self.zones:
            out[self.script_file(z)].append(z)
        return out

    def text_file(self, zone):
        """a/0/0/3 number of a zone's text file. Pearl gives zones with no text of their own Jubilife's bank 18 (72
        script files share it; only Jubilife's file shows its lines), and each translated file appends its common
        scripts' lines to its own text file: so a script file on a bank another file also uses gets its own number
        after the last bank's, unless it is the one that shows the bank's lines (2026-10-25, chapter 3: Ravaged
        Path's Rock Smash lines)."""
        if self._own_text is None:
            users = collections.defaultdict(set)
            for z in self.zones:
                users[z['text_bank']].add(z['scripts'])
            extra = []
            for bank, fs in users.items():
                if len(fs) > 1:
                    shows = {f for f in fs if self._shows_lines(f)}
                    extra += sorted(fs - shows) if shows else sorted(fs)[1:]
            top = FIRST_TEXT_FILE + len(self.text_file_no)
            self._own_text = {f: top + i for i, f in enumerate(sorted(extra))}
        own = self.shared_file_zones().get(zone['id'])
        if own is not None:                         # a zone on a shared script file: its own, after those
            return FIRST_TEXT_FILE + len(self.text_file_no) + len(self._own_text) + own
        return self._own_text.get(zone['scripts'], self.text_file_no[zone['text_bank']])

    def _shows_lines(self, f):
        try:
            d = self.disasm(f)
        except Exception:
            return False
        return any(self.cmd_name(op) in ('Message', 'MessageNoSkip', 'MessageInstant')
                   for e, op, args in d.insns.values())

    def zone_entries(self, pearl_map):
        return len(self.disasm(self.zones[pearl_map]['scripts']).entries)

    def warp_continuations(self, pearl_map):
        """[(src file, Warp address, address after it, src bank)] of every Pearl Warp to pearl_map, in a fixed order:
        their scripts in the destination file are its Pearl script count + 1, + 2, ..."""
        if self._warps is None:
            self._warps = collections.defaultdict(list)
            for f, data in enumerate(self.files):
                if not data or f in self.level_files:
                    continue
                try:
                    d = self.disasm(f)
                except Exception:       # (files that are not script code)
                    continue
                for a in sorted(d.insns):
                    end, op, args = d.insns[a]
                    if op == 0xBE and not args[0][0] == 'var':
                        self._warps[args[0][1]].append((f, a, end, self.bank_of(f)))
        return self._warps.get(pearl_map, [])

    def proxy_ids(self):
        """{Pearl global script id: its proxy entry number}, over every zone's people, signs and triggers."""
        if getattr(self, '_proxies', None) is None:
            import pearl_events
            gids = set()
            for z in self.zones:
                gids |= set(pearl_events.proxies(self.events(z), self, z))
            # scripts the project's own events run (not Pearl's people, signs or triggers) come after Pearl's, so
            # adding one never moves the numbers every installed zone file already has (2026-10-26: the Rock Climb
            # walls' ROCKY_WALL; sorted in, it moved Pearl's 10200 and up, and the Marts' clerks ran past their files)
            added = [g for g in pearl_events.ADDED_PROXIES if g in gids]
            base = sorted(gids - set(added))
            self._proxies = {g: FIRST_PROXY + i for i, g in enumerate(base + added)}
        return self._proxies

    def closed(self, zone):
        """The zone's rows of data/pearl_closed_facilities.json (CLOSED)."""
        if getattr(self, '_closed', None) is None:
            self._closed = {k: v for k, v in json.load(open(CLOSED)).items() if k != '_doc'} \
                if os.path.exists(CLOSED) else {}
        return self._closed.get(zone['name'], [])

    def _extra_ids(self, pearl_map, n, skip=0):
        """n script ids after the zone's PearlArrive (and `skip` ids taken before them), past Twinleaf's new-game
        entries and the house's black-out entry, below the proxies."""
        _, k = self.arrival_ids(pearl_map)
        out = []
        while len(out) < skip + n:
            k += 1
            while self.zones[pearl_map]['name'] == NEWGAME_ZONE and k in NEWGAME_ENTRIES or \
                    (self.zones[pearl_map]['name'] == BLACKOUT_HOME_ZONE and k == BLACKOUT_ENTRY):
                k += 1
            assert k < FIRST_PROXY, f'{self.zones[pearl_map]["name"]}: an extra entry {k} reaches the proxies'
            out.append(k)
        return out[skip:]

    def closed_ids(self, pearl_map):
        """Script ids of the zone's closed-place entries (CLOSED), in row order: after its PearlArrive."""
        return self._extra_ids(pearl_map, len(self.closed(self.zones[pearl_map])))

    def elevator_init(self, pearl_map):
        """(script id, lines) of the zone's elevator zone-init entry (ELEVATOR_FLOORS_ABOVE), or None: a floor an
        elevator serves keeps its floors-above in Pearl's VAR_ELEVATOR_FLOORS_ABOVE (0x40CE), an elevator room copies
        it into PL_ELEVATOR_FROM when the player walks in (pl_GetFloorsAbove reads that)."""
        if getattr(self, '_elevators', None) is None:
            self._elevators = {z['id'] for z in self.zones if z['scripts'] in self.files_using('GetFloorsAbove')
                               and self.shared_file_zones().get(z['id']) is None}
        if pearl_map in ELEVATOR_FLOORS_ABOVE:
            lines = [f'    WorkSetConst PVAR_40CE, {ELEVATOR_FLOORS_ABOVE[pearl_map]}  // this floor\'s floors above '
                     f'(an elevator reads it)']
        elif pearl_map in self._elevators:
            lines = ['    WorkSet PL_ELEVATOR_FROM, PVAR_40CE  // the floor the player came from']
        else:
            return None
        k, = self._extra_ids(pearl_map, 1, skip=len(self.closed(self.zones[pearl_map])))
        return k, lines + ['    VMHalt']

    def item_ball_ids(self, pearl_map):
        """{Pearl object id: script id} of the zone's installed item balls (data/pearl_item_balls.json, pearl_events
        item_ball), in object order: entries after its closed places and elevator entry. Each runs Pearl's own
        item-ball script (ITEM_BALL_FILE) as a sub-script (translate: PearlItemBall_<obj>)."""
        import pearl_events
        zone = self.zones[pearl_map]
        balls = [o['id'] for o in self.events(zone)['object_events'] if pearl_events.item_ball(zone, o)]
        if not balls:
            return {}
        skip = len(self.closed(zone)) + (1 if self.elevator_init(pearl_map) else 0)
        return dict(zip(balls, self._extra_ids(pearl_map, len(balls), skip=skip)))

    def ramanas_ids(self, pearl_map):
        """{extra name: script id} of Ramanas Park's entries in Pal Park's gate and park (b2tools/ramanas.py
        zone_extras: the slate clerk, the walk-out after a visit, the park attendant), after the zone's closed places,
        elevator entry and item balls; {} elsewhere."""
        import ramanas
        zone = self.zones[pearl_map]
        names = ramanas.zone_extras(zone['name'])
        if not names:
            return {}
        skip = len(self.closed(zone)) + (1 if self.elevator_init(pearl_map) else 0) + len(self.item_ball_ids(pearl_map))
        return dict(zip(names, self._extra_ids(pearl_map, len(names), skip=skip)))

    def game_clear_ids(self, pearl_map):
        """(before, after) script ids of the Hall of Fame room's two ending entries (GAME_CLEAR_ZONE), or None: Black 2's
        game clear runs a script of its ending zone before the credits and one after them (event_game_clear.c states
        17 and 18); PearlB2's decomp sends both ending map changes here (patches/game_clear.py reads these ids)."""
        if self.zones[pearl_map]['name'] != GAME_CLEAR_ZONE:
            return None
        zone = self.zones[pearl_map]
        skip = len(self.closed(zone)) + (1 if self.elevator_init(pearl_map) else 0) + len(self.item_ball_ids(pearl_map))
        return tuple(self._extra_ids(pearl_map, 2, skip=skip))

    def turnback_doors(self, pearl_map):
        """Script id of a Turnback Cave maze zone's doors map script (b2tools/turnback.py doors_code: Black 2 type 4,
        after each arrival), after the zone's other extra entries; None elsewhere."""
        import turnback
        if pearl_map not in turnback.maze_rooms():
            return None
        zone = self.zones[pearl_map]
        skip = len(self.closed(zone)) + (1 if self.elevator_init(pearl_map) else 0) + \
            len(self.item_ball_ids(pearl_map)) + len(self.ramanas_ids(pearl_map)) + \
            (2 if self.game_clear_ids(pearl_map) else 0)
        k, = self._extra_ids(pearl_map, 1, skip=skip)
        return k

    def files_using(self, cmd):
        """Pearl script files (zone files) that use a command."""
        if not hasattr(self, '_using'):
            self._using = {}
        if cmd not in self._using:
            out = set()
            for f in {z['scripts'] for z in self.zones}:
                try:
                    d = self.disasm(f)
                except Exception:
                    continue
                if any(self.cmd_name(op) == cmd for e, op, args in d.insns.values()):
                    out.add(f)
            self._using[cmd] = out
        return self._using[cmd]

    def arrival_ids(self, pearl_map):
        """{(src file, Warp address): script id} in the destination, and the id of its PearlArrive script."""
        n = self.zone_entries(pearl_map)
        ids, k = {}, n
        for f, a, after, bank in self.warp_continuations(pearl_map):
            k += 1
            while self.zones[pearl_map]['name'] == NEWGAME_ZONE and k in NEWGAME_ENTRIES:
                k += 1
            ids[(f, a)] = k
        k += 1
        while self.zones[pearl_map]['name'] == NEWGAME_ZONE and k in NEWGAME_ENTRIES:
            k += 1
        return ids, k


def platinum_names():
    """{opcode: (name, [param names])} from pokeplatinum's command list and macros (names only)."""
    order = []
    for line in open(os.path.join(PLATINUM, 'include', 'data', 'scripts', 'scrcmd.h')):
        m = re.match(r'ScriptCommand\((SCRCMD_\w+),\s*ScrCmd_(\w+)\)', line)
        if m:
            order.append((m.group(1), m.group(2)))
    params = {}
    src = open(os.path.join(PLATINUM, 'asm', 'macros', 'scrcmd.inc')).read()
    for m in re.finditer(r'\.macro (\w+)([^\n]*)\n\s*\.short (SCRCMD_\w+)', src):
        params.setdefault(m.group(3), (m.group(1), [p.split('=')[0].strip() for p in m.group(2).split(',') if p.strip()]))
    out = {}
    for op, (const, handler) in enumerate(order):
        name, ps = params.get(const, (handler, []))
        if handler.startswith(('Unused', 'Dummy')) or re.match(r'^[0-9A-F]{3}$', handler):
            name = handler
        out[op] = (name, ps)
    return out


# Pearl's script id ranges (pokediamond arm9/asm/unk_02038C78.s LoadScriptsAndMessagesByMapId): (first id, script
# file, text bank); the first entry whose id is <= the script's applies
SCRIPT_RANGES = [(10300, 977, 496), (10200, 373, 332), (10150, 1042, 562), (10100, 1041, 563), (10000, 375, 334),
                 (9950, 376, 335), (9900, 365, 199), (9800, 206, 203), (9700, 387, 378), (9600, 377, 199),
                 (9500, 464, 492), (9400, 391, 381), (9300, 372, 329), (9200, 388, 379), (9100, 0, 9),
                 (9000, 207, 207), (8970, 390, 7), (8950, 463, 486), (8900, 389, 380), (8800, 462, 485),
                 (8000, 374, 333), (7000, 370, 325), (5000, 1040, 199), (3000, 1040, 199), (2800, 378, 350),
                 (2500, 1, 13), (2000, 205, 199)]
PEARL_NEW_GAME_SCRIPT = 9600     # Pearl's new-game flags (file 377 script 1, run by the new-game event)
# After a black-out Black 2 runs a script of the zone you wake up in: script 2 at home (ov012 EventBattleLose_Callback;
# 2001 at a Pokémon Center), which in the translated house is Pearl's own script 2 (Mom's opening scene). Pearl runs
# common script 2020 there (pokediamond blackout.c: 0x7E4 at Mom's spawn, 0x7E5 at a Center). So the home zone's file
# gets that script as entry BLACKOUT_ENTRY, and patches/sinnoh_respawn.py makes Black 2 call it (found in game
# 2026-10-19: after a black-out Mom said "Barry came calling..." again).
BLACKOUT_HOME_ZONE = 'MAP_TWINLEAF_RIVAL_HOUSE_1F'   # the player's house 1F (pokediamond's names are swapped)
BLACKOUT_ENTRY = 40                                 # below the proxies (FIRST_PROXY), above Pearl's and continuations
PEARL_BLACKOUT_HOME_SCRIPT = 2020
# Black 2's game clear (CallGameClear: the Hall of Fame record, the save, the credits, THE END) changes the map twice
# for its Unova epilogue and runs a script there each time (ov012 event_game_clear.c states 15/17 and 16/18). PearlB2's
# decomp sends both to the Hall of Fame room (patches/game_clear.py), whose file gets two entries after its own
# (PearlData.game_clear_ids): before the credits Black 2's ending song starts (Pearl's ending song is not installed;
# Pearl has no field scene there either: the screen stays black), after them nothing (2026-10-26, chapter 8).
GAME_CLEAR_ZONE = 'MAP_POKEMON_LEAGUE_HALL_OF_FAME'


def script_location(sid):
    """(file, text bank, 1-based entry) of a Pearl script id >= 2000."""
    for first, f, bank in SCRIPT_RANGES:
        if sid >= first:
            return f, bank, sid - first + 1
    raise ValueError(sid)


# ---------------------------------------------------------------- Black 2 side tables

MOVEMENT = {int(k, 16): v for k, v in json.load(open(os.path.join(HERE, 'data', 'pearl_movement.json')))['codes'].items()}

# Pearl sounds (pokediamond include/constants/sndseq.h names) -> Black 2 (pokebw2 generated/sound.txt).
# [guess] = chosen by name and use, to audition. Sinnoh's own music comes with the music port (DECISIONS.md).
SOUND = {
    'SEQ_SE_DP_SELECT': 'SEQ_SE_MESSAGE',        # Pearl's click before an NPC speaks = Black 2's talk sound
    'SEQ_SE_DP_DECIDE': 'SEQ_SE_DECIDE1',
    'SEQ_SE_DP_KAIDAN2': 'SEQ_SE_KAIDAN',        # stairs / door
    'SEQ_SE_DP_WALL_HIT2': 'SEQ_SE_WALL_HIT',    # Barry's "Thud!!"
    'SEQ_SE_DP_SAVE': 'SEQ_SE_SAVE',
    'SEQ_SE_DP_PC_LOGIN': 'SEQ_SE_PC_LOGIN', 'SEQ_SE_DP_PC_ON': 'SEQ_SE_PC_ON', 'SEQ_SE_DP_PC_LOGOFF': 'SEQ_SE_PC_LOGOFF',
    'SEQ_SE_DP_DOOR_OPEN': 'SEQ_SE_OPEN1',       # [guess]
    'SEQ_SE_DP_DOOR10': 'SEQ_SE_OPEN1',          # [guess]
    'SEQ_SE_DP_PINPON': 'SEQ_SE_DECIDE2',        # [guess] (a chime)
    'SEQ_SE_DP_UG_020': 'SEQ_SE_DECIDE2',        # [guess] the Hearthome Gym's "Correct! Congratulations!" board (its
                                                 # only use outside the Underground: a chime)
    'SEQ_SE_DP_BUTTON9': 'SEQ_SE_DECIDE1', 'SEQ_SE_DP_BUTTON3': 'SEQ_SE_DECIDE1',   # [guess]
    'SEQ_SE_DP_BOX03': 'SEQ_SE_PC_ON',           # [guess]
    'SEQ_SE_DP_REGI': 'SEQ_SE_SYS_22',           # the cash register (Great Marsh fee): HoennB2's Safari Zone fee sound
    'SEQ_SE_DP_KI_GASYAN': 'SEQ_SE_FLD_94',      # [guess] the Elite Four rooms' doors shutting / opening (Pearl's lift
                                                 # stop clunk too): gimmick 59's own lift-stop sound (chapter 8)
    'SEQ_FANFA4': 'SEQ_ME_ITEM',                 # an item obtained (Platinum's obtain script: FANFA4 items, FANFA3 key)
    'SEQ_FANFA3': 'SEQ_ME_KEYITEM', 'SEQ_FANFA2': 'SEQ_ME_ITEM',
    'SEQ_FANFA1': 'SEQ_ME_POKEGET',              # [guess] a Pokémon received
    'SEQ_GONIN': 'SEQ_ME_KEYITEM',               # [guess]
    'SEQ_ASA': 'SEQ_ME_ASA', 'SEQ_BADGE': 'SEQ_ME_BADGE', 'SEQ_WAZA': 'SEQ_ME_WAZA', 'SEQ_ACCE': 'SEQ_ME_ACCE',
    'SEQ_WASURE': 'SEQ_ME_WASURE', 'SEQ_KINOMI': 'SEQ_ME_KINOMI', 'SEQ_POCKETCH': 'SEQ_ME_KEYITEM',   # [guess]
    'SEQ_TV_END': 'SEQ_ME_QUIZ',                 # [guess] the TV show's closing jingle (the bedroom TV). Every
                                                 # PlayFanfare needs a real jingle: a WaitFanfare after a stub hangs
                                                 # (tested in game 2026-10-18: the opening TV scene never ended)
    'SEQ_THE_RIV': 'SEQ_BGM_E_HUE',              # Barry's theme -> Black 2's rival (Hugh), until Sinnoh's music
    'SEQ_TSURETEKE': 'SEQ_BGM_E_TSURETEKE2',     # "follow me"
    'SEQ_THE_BOY': 'SEQ_BGM_E_BERU', 'SEQ_THE_GIRL': 'SEQ_BGM_E_BERU',   # [guess] Lucas/Dawn -> Bianca's theme
    'SEQ_THE_EVENT01': 'SEQ_BGM_E_DOCTOR',       # [guess] Rowan
    'SEQ_SE_DP_W025': 'SEQ_SE_W026_01',             # [guess] Spear Pillar, the new galaxy (Pearl's Mega Kick; Black 2 has no W025)
    'SEQ_SE_DP_W060C': 'SEQ_SE_W095_01',            # [guess] Spear Pillar, the lake trio's power (Pearl's Psybeam; no W060)
}
_SEQ = None
PEARL_SONGS = ('SEQ_THE_RIV', 'SEQ_THE_BOY', 'SEQ_THE_GIRL', 'SEQ_TSURETEKE', 'SEQ_THE_EVENT01', 'SEQ_THE_EVENT02',
               'SEQ_THE_EVENT03', 'SEQ_SILENCE_DUNGEON', 'SEQ_OPENING2', 'SEQ_FUE', 'SEQ_D_SAFARI', 'SEQ_D_RYAYHY')


def seq_name(v):
    """(Black 2 sound constant or None, Pearl's name) for a Pearl sound id."""
    global _SEQ
    if _SEQ is None:
        _SEQ, base = {}, {'SNDARC_BGM_BASE': 1000, 'SNDARC_SE_BASE': 1500}
        for line in open(os.path.join(ROOT, 'external', 'pokediamond', 'include', 'constants', 'sndseq.h')):
            m = re.match(r'#define (SEQ_\w+)\s+\((?:(SNDARC_\w+) \+ )?(\d+)\)', line)
            if m:
                _SEQ[int(m.group(3)) + (base[m.group(2)] if m.group(2) else 0)] = m.group(1)
    name = _SEQ.get(v)
    return SOUND.get(name), name


# ---------------------------------------------------------------- one output file

class Job:
    """One Black 2 script file (a Pearl zone's), its text, and what the translation needed."""

    def __init__(self, pd, zone, ids):
        import gen4_text
        self.pd, self.zone, self.ids, self.gen4_text = pd, zone, ids, gen4_text
        self.name = zone['name']
        self.events = pd.events(zone)
        self.bank = gen4_text.bank(zone['text_bank'])      # Pearl's lines (Gen 4 markup)
        self.text = [(t, None) for t in self.bank]        # this zone's text file: (Pearl line, variant)
        self.extra = {}                                   # (bank, line, variant) -> line number in this file
        self.stubs = collections.Counter()                # Pearl command -> uses left as stubs
        self.approx = collections.Counter()               # translated approximately
        self.done = collections.Counter()                 # translated
        self.insn_status = {}                             # (Pearl file, address) -> (command, 'done' | 'stub')
        self.notes = []
        self.common = {}                                  # (file, entry) -> subroutine label
        self.common_queue = []
        self.speakers = {}
        if os.path.exists(SPEAKERS):
            self.speakers = {int(k): v for k, v in json.load(open(SPEAKERS)).get(self.name, {}).items()}
        import pearl_events
        self.init_level = pearl_events.map_script_table(pd, zone, ids)[1]   # {script: feature level} of map scripts
        # Pearl global scripts that a map script runs through a proxy entry: (file, entry) -> that feature level, so
        # their subroutine copy translates as map-script code (2026-10-26, chapter 8: the League lobby 2F's field-load
        # script runs global 9000, whose HideObject 255 became an ActorCmdExec: sinnoh_story's level check refused it)
        self.level_commons = {}
        self.pending_pos = {}                             # object -> its SetObjectEventPos for the next AddObject
        # Pearl's own objects by local id; copies of a neighbouring zone's objects (script 0xFFFF) share ids with them
        # and no script addresses them (2026-10-20: Route 201's copy id 5 hid Rowan's RemoveObject 5 flag)
        self.objects = {o['id']: o for o in self.events['object_events'] if o['script'] != pearl_events.COPY_SCRIPT}
        # index in the zone's Black 2 NPC list (pl_SetObjectEventPos): the people pearl_events installs, in Pearl's order
        # (item balls, berry soil and objects without a Black 2 actor are left out, so later indices shift; 2026-10-20)
        self.object_index = {o['id']: i for i, o in enumerate(pearl_events.kept_objects(pd, zone))
                             if o['script'] != pearl_events.COPY_SCRIPT}

    def line_for(self, bank, n, variant=None):
        """Line number in this zone's text file of Pearl bank line n (variant: a ('boy'|'girl', buffers) copy)."""
        if bank == self.zone['text_bank'] and variant is None:
            return n
        key = (bank, n, variant)
        if key not in self.extra:
            src = self.gen4_text.bank(bank)[n]
            self.extra[key] = len(self.text)
            self.text.append((src, variant))
        return self.extra[key]

    def line_text(self, key, text):
        """Line number of a line written here (Pearl markup text; key: what it stands for, kept once)."""
        key = ('text',) + key
        if key not in self.extra:
            self.extra[key] = len(self.text)
            self.text.append((text, None))
        return self.extra[key]

    def values_before_call(self, var, f, entry):
        """Values the zone's own file sets var to (SetVarFromValue) right before calling Pearl common script
        (file f, entry)."""
        d = self.pd.disasm(self.zone['scripts'])
        prev = {e: x for x, (e, op, args) in d.insns.items()}               # end address -> the instruction
        out = set()
        for x, (e, op, args) in d.insns.items():
            if self.pd.cmd_name(op) != 'CallCommonScript' or args[0][1] < 2000 or args[0][1] in NATIVE_COMMON:
                continue
            cf, _, ce = script_location(args[0][1])
            if (cf, ce) != (f, entry):
                continue
            y = x
            for _ in range(8):                      # (the lobby sets 0x8004, then 0x8005, then calls 2047)
                y = prev.get(y)
                if y is None:
                    break
                pe_, pop, pargs = d.insns[y]
                if self.pd.table[pop]['flow'] in ('end', 'jump', 'return'):
                    break
                if self.pd.cmd_name(pop) == 'SetVarFromValue' and pargs[0][1] == var:
                    out.add(pargs[1][1])
                    break
        return out

    def label_common(self, sid, mode='common'):
        """The subroutine label of Pearl global script sid in this file (translated once per mode: 'common' for
        CallCommonScript, 'proxytalk' for a person's talk script run through a proxy entry)."""
        f, bank, entry = script_location(sid)
        key = (f, entry, mode)
        if key not in self.common:
            self.common[key] = f'{"C" if mode == "common" else "T"}{f}_{entry}_S{entry}'
            self.common_queue.append((f, bank, entry, mode))
        return self.common[key]


class FileTr:
    """The translation of a Pearl script file from some starting points.
    mode 'zone': the zone's own file, all its scripts; 'common': one common script as a subroutine;
    'warp': the code after a Warp, as a script of the destination."""

    def __init__(self, job, f, bank, mode='zone', starts=None, prefix=None):
        self.job, self.f, self.bank, self.mode = job, f, bank, mode
        self.d = d = job.pd.disasm(f)
        self.prefix = prefix or f'P{f}'
        if starts is None:
            starts = [(f'{self.prefix}_S{k}', d.entries[k - 1], k) for k in range(1, len(d.entries) + 1)]
        self.starts = starts                                 # [(label, address, entry number or None)]
        self.reach_from = collections.defaultdict(set)      # addr -> entries whose flow reaches it
        self.cp_bufs = collections.defaultdict(set)         # addr -> word buffers that may hold the counterpart name
        self.sign_type = 3
        self.last_battle = 'trainer'
        self.after_starter = False
        self.force_levels = None                 # a zone-init copy of a subroutine (call_label): always level 2
        self.init_copies = {}                    # subroutine address -> its zone-init copy's label
        # objects this file makes follow the player (SetMovementType X, 0x30): Black 2 renames a follower 0xFE
        self.follow_uids = {args[0][1] for a, (e, op, args) in d.insns.items()
                            if job.pd.cmd_name(op) == 'SetMovementType' and args[1][1] == FOLLOW and args[0][1] < 0xF0}
        self.flow()

    @property
    def zone_file(self):
        return self.mode == 'zone'

    def succ(self, a):
        end, op, args = self.d.insns[a]
        fl = self.job.pd.table[op]['flow']
        out = [t for ty, t in args if ty == 'rel']
        if fl not in ('end', 'jump', 'return') and op != 0xBE:      # (nothing after a Warp runs here: continuation)
            out.append(end)
        return out

    def flow(self):
        d = self.d
        for label, start, k in self.starts:
            todo, seen = [(start, frozenset())], {}
            while todo:
                a, cp = todo.pop()
                if a not in d.insns:
                    continue
                prev = seen.get(a)
                if prev is not None and cp <= prev:
                    continue
                cp = cp | (prev or frozenset())
                seen[a] = cp
                self.reach_from[a].add(k)
                self.cp_bufs[a] |= cp
                end, op, args = d.insns[a]
                name = self.job.pd.cmd_name(op)
                ncp = cp
                if name in BUFFER_CMDS:
                    idx = args[0][1]
                    ncp = (cp | {idx}) if name == 'BufferCounterpartName' else (cp - {idx})
                for t in self.succ(a):
                    todo.append((t, ncp))

    MSG_OPS = {'Message', 'MessageNoSkip', 'MessageInstant', 'MessageVar', 'MessageFromBank', 'MessageFromBankInstant',
               'MessageUnown'}
    CLOSE_OPS = {'CloseMessage', 'CloseMessageWithoutErasing', 'DrawSignpostInstantMessage',
                 'DrawSignpostScrollingMessage'}

    def prints(self, d, start, limit=400):
        """Whether the code reachable from start (a subroutine, up to its returns) shows a line."""
        seen, todo = set(), [start]
        while todo and len(seen) < limit:
            a = todo.pop()
            if a in seen or a not in d.insns:
                continue
            seen.add(a)
            end, op, args = d.insns[a]
            name = self.job.pd.cmd_name(op)
            if name in self.MSG_OPS:
                return True
            if name == 'CallCommonScript' and args[0][1] >= 2000 and args[0][1] not in NATIVE_COMMON:
                f, bank, entry = script_location(args[0][1])
                if self.prints(self.job.pd.disasm(f), self.job.pd.disasm(f).entries[entry - 1], limit - len(seen)):
                    return True
            fl = self.job.pd.table[op]['flow']
            todo += [t for ty, t in args if ty == 'rel']
            if fl not in ('end', 'jump', 'return') and op != 0xBE:
                todo.append(end)
        return len(seen) >= limit

    def speakers_in(self):
        """{address: which message window may be open there}: None (none), (kind, uid), or UNKNOWN; a forward
        dataflow over the code (Pearl has one box; Black 2 has a balloon per person and a plain window, and two at
        once hung the game: Mom's Journal scene, 2026-10-18)."""
        d, state = self.d, {}
        todo = []
        for label, a, k in self.starts:
            st = None if self.mode == 'zone' else UNKNOWN       # (a sub-script's caller may have one open)
            todo.append((a, st))
        while todo:
            a, st = todo.pop()
            if a not in d.insns:
                continue
            if a in state:
                if state[a] == st or state[a] == UNKNOWN:
                    continue
                st = UNKNOWN
            state[a] = st
            end, op, args = d.insns[a]
            name = self.job.pd.cmd_name(op)
            out = st
            if name in self.MSG_OPS:
                n = args[0][1] if name.startswith('Message') and name not in ('MessageVar', 'MessageFromBank',
                                                                               'MessageFromBankInstant') else -1
                out = speaker(self, a, n)
            elif name in self.CLOSE_OPS:
                out = None
            elif name in ('Call', 'CallIf'):
                t = next(t for ty, t in args if ty == 'rel')
                if self.prints(d, t):
                    out = UNKNOWN
            elif name == 'CallCommonScript' and args[0][1] >= 2000 and args[0][1] not in NATIVE_COMMON:
                f, bank, entry = script_location(args[0][1])
                cd = self.job.pd.disasm(f)
                if self.prints(cd, cd.entries[entry - 1]):
                    out = UNKNOWN
            for t in self.succ(a):
                todo.append((t, out))
        return state

    def kind_of(self, k):
        """Entry k's trigger in the zone: 'talk' (an NPC's), 'sign', 'trigger', or 'other'."""
        if self.mode == 'proxytalk':
            return 'talk'
        if not self.zone_file or k is None:
            return self.mode
        ev = self.job.events
        import pearl_events
        sign = pearl_events.is_sign                 # (Pearl's sign objects are Black 2 sign events: no talker)
        # a script a step trigger also runs is no person's talk: Black 2's balloon over the talked-to person
        # (ParentActorMsg) shows nothing when no person was talked to (ov036 scrcmd_msg.c: no parent actor), and
        # Pearl's one box serves both (2026-10-25: Valley Windworks' Mars scene is his talk script and the trigger's)
        shared = any(c['script'] == k for c in ev['coord_events'])
        if not shared and any(o['script'] == k and not o['trainer_type'] and not sign(o) for o in ev['object_events']):
            return 'talk'
        if any(b['script'] == k for b in ev['bg_events']) or any(o['script'] == k and sign(o)
                                                                  for o in ev['object_events']):
            return 'sign'
        if any(c['script'] == k for c in ev['coord_events']):
            return 'trigger'
        return 'other'

    def levels(self, a):
        """Black 2 feature levels the code at a runs at (2 zone init, 1 field load, 0 the rest)."""
        if self.force_levels:
            return self.force_levels
        if self.mode != 'zone':
            return {0}
        return {self.job.init_level.get(k, 0) for k in self.reach_from.get(a, ())} or {0}

    # Commands translated one way in a zone init (level 2: the zone's NPC list, no live actors) and another way
    # elsewhere (live actors): a subroutine with one of them that a zone init and another script both call gets a
    # zone-init copy (2026-10-25, chapter 4b: Veilstone's zone init places the counterpart by the subroutine its
    # Pokedex scene also calls; one copy for both turned the live actor in the zone init, which hangs)
    LEVEL_CMDS = {'AddObject', 'RemoveObject', 'SetObjectEventPos', 'SetObjectEventDir', 'CheckDaycareHasEgg'}

    def call_label(self, a, t):
        """The label a Call / CallIf at a jumps to: t's, or its zone-init copy (LEVEL_CMDS)."""
        if self.mode != 'zone' or self.force_levels or self.levels(a) != {2} or self.levels(t) == {2}:
            return self.label(t)
        seen, todo = set(), [t]
        while todo:                                 # the subroutine, up to its Returns
            x = todo.pop()
            if x in seen or x not in self.d.insns:
                continue
            seen.add(x)
            end, op, args = self.d.insns[x]
            if self.job.pd.cmd_name(op) in self.LEVEL_CMDS:
                self.init_copies.setdefault(t, f'{self.prefix}_Zinit_{t:04X}')
                return self.init_copies[t]
            fl = self.job.pd.table[op]['flow']
            todo += [y for ty, y in args if ty == 'rel']
            if fl not in ('end', 'jump', 'return') and op != 0xBE:
                todo.append(end)
        return self.label(t)

    def app_bufs(self, a):
        """{buffer: Pearl app (a number) or ('var', v)} of the word buffers that hold a Pokétch app's name at a
        (Pearl GetPoketchAppName = BufferPoketchAppName idx, app or var): a forward dataflow like flow()'s, computed
        once, only for files that use the command (2026-10-25, chapter 4a: Route 207's Dowsing Machine line)."""
        if getattr(self, '_app_bufs', None) is None:
            d, pd = self.d, self.job.pd
            self._app_bufs = {}
            if any(pd.cmd_name(op) in NAME_SOURCES for e, op, args in d.insns.values()):
                for label, start, k in self.starts:
                    for x, st in self._app_walk(start, frozenset())[0].items():
                        self._app_bufs[x] = self._app_bufs.get(x, frozenset()) | st
        return {i: v for i, v in self._app_bufs.get(a, ())}

    def const_before(self, a, var, limit=8):
        """The value a SetVarFromValue gives var shortly before a in straight-line code, or None."""
        d, pd = self.d, self.job.pd
        if getattr(self, '_prev', None) is None:
            self._prev = {e: x for x, (e, op, args) in d.insns.items()}
        x = a
        for _ in range(limit):
            x = self._prev.get(x)
            if x is None:
                return None
            e, op, args = d.insns[x]
            name = pd.cmd_name(op)
            if pd.table[op]['flow'] in ('end', 'jump', 'return'):
                return None
            if name == 'SetVarFromValue' and args[0][1] == var:
                return args[1][1]
            if any(ty == 'var' and v == var for ty, v in args):
                return None                         # (something else writes or reads it: not a plain constant)
        return None

    def _app_walk(self, start, st0, depth=0):
        """(states by address, states at the Returns) of app_bufs' dataflow from start; a Call's fall-through
        gets what its subroutine set (Route 207's counterpart names the app a Call buffered)."""
        d, pd = self.d, self.job.pd
        todo, seen, rets = [(start, st0)], {}, set()
        while todo:
            x, st = todo.pop()
            if x not in d.insns or (x in seen and st <= seen[x]):
                continue
            st = st | seen.get(x, frozenset())
            seen[x] = st
            end, op, args = d.insns[x]
            name = pd.cmd_name(op)
            nst = st
            if name in BUFFER_CMDS or name in NAME_SOURCES or (name.startswith('Buffer') and args and
                                                                args[0][0] == 'u8'):
                idx = args[0][1]
                nst = frozenset(b for b in st if b[0] != idx)
                if name in NAME_SOURCES:
                    v = args[1][1]
                    if v >= 0x4000:                 # a var set just before (Route 206's gate: 0x8004 = 96)
                        k = self.const_before(x, v)
                        v = ('var', v) if k is None else k
                    nst |= {(idx, (name, v))}
            if pd.table[op]['flow'] == 'return':
                rets |= st
            if name in ('Call', 'CallIf') and depth < 8:
                t = next(t for ty, t in args if ty == 'rel')
                for y, sst in self._app_walk(t, st, depth + 1)[0].items():
                    if y not in seen or not sst <= seen[y]:
                        todo.append((y, sst))
                nst = st | self._app_walk(t, st, depth + 1)[1]
                todo += [(end, nst)]
                continue
            for t in self.succ(x):
                todo.append((t, nst))
        return seen, rets

    def is_talk(self, a):
        ks = self.reach_from.get(a, set())
        return bool(ks) and all(self.kind_of(k) == 'talk' for k in ks)

    def label(self, a):
        return f'{self.prefix}_{a:04X}'

    def var(self, v):
        """A var-or-value argument."""
        if v > 0xFFFF:                             # (a u32 value: money)
            return str(v)
        if v >= 0x8000:
            return self.job.ids.local(v)
        if v >= 0x4000:
            return self.job.ids.var(v)
        return str(v)

    def flag(self, v):
        return self.job.ids.flag(v)

    def lines(self):
        d, out = self.d, []
        names = collections.defaultdict(list)
        for label, a, k in self.starts:
            names[a].append(label)
        code = sorted(a for a in d.insns if a in self.reach_from)
        targets = {t for a in code for ty, t in d.insns[a][2] if ty == 'rel'}
        movs = sorted({t for a in code for ty, t in d.insns[a][2] if ty == 'mov'})
        prev_end = None
        self.open_speaker = None
        spk = self.speakers_in()
        for a in code:
            end, op, args = d.insns[a]
            if a in names or a in targets or prev_end != a:
                if out:
                    out.append('')
                out += [f'{n}:' for n in names.get(a, [])] + [f'{self.label(a)}:']
                # which message window may be open here (speakers_in): another speaker's line closes it first
                self.open_speaker = spk.get(a, UNKNOWN)
            for x in self.translate(a, end, op, args):
                out.append(x if x.startswith(('//', '.L')) or x.endswith(':') else f'    {x}')
            fl = self.job.pd.table[op]['flow']
            prev_end = None if fl in ('end', 'jump', 'return') or op == 0xBE else end
        for m in movs:
            out += ['', '    .balign 4, 0', f'{self.label(m)}:']
            fix = path_fixes().get((self.f, m))
            if fix is not None:
                out.append(f'// path fix (data/pearl_path_fixes.json): {fix["why"]}')
            for cmd, n in (fix['moves'] + [(0xFE, 0)] if fix is not None else d.movement[m]):
                if cmd == 0xFE:
                    out.append('    MoveEnd')
                    break
                info = MOVEMENT.get(cmd)
                if info is None or info['b2'] is None:
                    out.append(f'    Move {cmd}, {n}  // Pearl 0x{cmd:02X}: no Black 2 code (same number kept)')
                    self.job.approx[f'movement 0x{cmd:02X}'] += 1
                    continue
                if not info['exact']:
                    self.job.approx[f'movement 0x{cmd:02X} {info["pearl_name"]}'] += 1
                note = '' if info['exact'] else '  // approx.: ' + info['note'][:70]
                out.append(f'    Move {info["b2"]}, {n}  // {info["pearl_name"]}{note}')
        for t, label in self.init_copies.items():  # zone-init copies of subroutines (call_label)
            sub = FileTr(self.job, self.f, self.bank, mode='zone', starts=[(label, t, None)], prefix=f'{self.prefix}Z')
            sub.force_levels = {2}
            out += ['', f'// ---- a zone-init copy of {self.label(t)} (another script calls it outside the zone init)'] \
                + sub.lines()
        return out

    def translate(self, a, end, op, args):
        name = self.job.pd.cmd_name(op)
        h = HANDLERS.get(name)
        vals = [v for ty, v in args]
        patch = script_patches().get((self.f, a))      # (data/pearl_script_patches.json: one command changed)
        if patch is not None:
            if 'drop' in patch:
                self.job.insn_status[(self.f, a)] = (name, 'done')
                return [f'// Pearl 0x{op:03X} {name} {", ".join(map(str, vals))}: dropped '
                        f'(data/pearl_script_patches.json: {patch["drop"]})']
            assert len(patch['args']) == len(vals), (self.f, hex(a), name, patch)
            vals = list(patch['args'])
            args = [(ty, v) for (ty, _), v in zip(args, vals)]
        if h is None:
            self.job.insn_status[(self.f, a)] = (name, 'stub')
            self.job.stubs[name] += 1
            return [f'pl_stub {name}  // Pearl 0x{op:03X} {self.job.pd.table[op]["name"]} {", ".join(map(str, vals))}'
                    f': not translated yet']
        before = sum(self.job.stubs.values())
        r = h(self, a, vals, name)
        self.job.done[name] += 1
        self.job.insn_status[(self.f, a)] = (name, 'stub' if sum(self.job.stubs.values()) > before else 'done')
        return r


# ---- script patches: single Pearl commands changed or dropped (data/pearl_script_patches.json; 2026-10-26: the
# Underground Man's missions that need digging, traps or Secret Bases)
SCRIPT_PATCHES = os.path.join(ROOT, 'data', 'pearl_script_patches.json')
_SCRIPT_PATCHES = None


def script_patches():
    """{(Pearl script file, command address): {'args': [...]} or {'drop': why}}."""
    global _SCRIPT_PATCHES
    if _SCRIPT_PATCHES is None:
        _SCRIPT_PATCHES = {}
        if os.path.exists(SCRIPT_PATCHES):
            for f, cmds in json.load(open(SCRIPT_PATCHES)).items():
                if f.startswith('_'):
                    continue
                for addr, p in cmds.items():
                    if not addr.startswith('_'):
                        _SCRIPT_PATCHES[(int(f), int(addr, 16))] = p
    return _SCRIPT_PATCHES


# ---- path fixes: Pearl movement lists changed where Black 2 places the player differently (data/pearl_path_fixes.json,
# checked by b2tools/scene_check.py; 2026-10-20: Mom walking into / past the player after the stairs)
PATH_FIXES = os.path.join(ROOT, 'data', 'pearl_path_fixes.json')
_PATH_FIXES = None


def path_fixes():
    """{(Pearl script file, movement list address): {'moves': [(code, count)], 'why': str}}."""
    global _PATH_FIXES
    if _PATH_FIXES is None:
        _PATH_FIXES = {}
        if os.path.exists(PATH_FIXES):
            for f, lists in json.load(open(PATH_FIXES)).items():
                if f.startswith('_'):
                    continue
                for addr, fx in lists.items():
                    _PATH_FIXES[(int(f), int(addr, 16))] = dict(moves=[tuple(m) for m in fx['moves']], why=fx['why'])
    return _PATH_FIXES


def movement_steps(pd, f, addr):
    """[(code, count)] of Pearl file f's movement list at addr as installed (its path fix if it has one)."""
    fx = path_fixes().get((f, addr))
    if fx is not None:
        return list(fx['moves'])
    return [(c, n) for c, n in pd.disasm(f).movement.get(addr, []) if c != 0xFE]


UNKNOWN = ('unknown',)               # FileTr.open_speaker: some window may be open (see lines())

BUFFER_CMDS = {'BufferPlayerName', 'BufferRivalName', 'BufferCounterpartName', 'BufferPartyMonSpecies',
               'BufferItemName', 'BufferPocketName', 'BufferTMHMMoveName', 'BufferMoveName', 'BufferNumber',
               'BufferPartyMonNickname', 'BufferPoketchAppName', 'BufferTrainerClassName', 'BufferSpeciesNameFromVar',
               'BufferPlayerStarterSpeciesName', 'BufferRivalStarterSpeciesName',
               'BufferPlayerCounterpartStarterSpeciesName', 'BufferMapName'}

HANDLERS = {}


def handler(*names):
    def deco(fn):
        for n in names:
            HANDLERS[n] = fn
        return fn
    return deco


def simple(macro, *argfmt):
    """A handler writing `macro args`, each argument as argfmt says: 'var' (var or value), 'flag', 'n' (as it is)."""
    def fn(tr, a, vals, name):
        parts = [tr.var(v) if f == 'var' else tr.flag(v) if f == 'flag' else str(v) for f, v in zip(argfmt, vals)]
        return [f'{macro} {", ".join(parts)}'.rstrip()]
    return fn


for _pl, _macro, _fmt in [
        ('LockAll', 'pl_LockAll', ()), ('FacePlayer', 'pl_FacePlayer', ()), ('ReleaseAll', 'pl_ReleaseAll', ()),
        ('CompareVarToValue', 'pl_CompareVarToValue', ('var', 'n')),
        ('CompareVarToVar', 'pl_CompareVarToVar', ('var', 'var')),
        ('SetFlag', 'pl_SetFlag', ('flag',)), ('ClearFlag', 'pl_ClearFlag', ('flag',)), ('CheckFlag', 'pl_CheckFlag', ('flag',)),
        ('SetFlagFromVar', 'pl_SetFlagFromVar', ('var',)),
        ('SetVarFromVar', 'pl_SetVarFromVar', ('var', 'var')),
        ('AddVar', 'pl_AddVar', ('var', 'var')), ('SubVar', 'pl_SubVar', ('var', 'var')),
        ('WaitButton', 'pl_WaitButton', ()), ('WaitABPress', 'pl_WaitABPress', ()), ('WaitABPadPress', 'pl_WaitABPadPress', ()),
        ('ShowYesNoMenu', 'pl_ShowYesNoMenu', ('var',)),
        ('WaitMovement', 'pl_WaitMovement', ()), ('WaitFanfare', 'pl_WaitFanfare', ()), ('WaitCry', 'pl_WaitCry', ()),
        ('WaitFadeScreen', 'pl_WaitFadeScreen', ()),
        ('GetPlayerMapPos', 'pl_GetPlayerMapPos', ('var', 'var')), ('GetPlayerDir', 'pl_GetPlayerDir', ('var',)),
        ('GetPlayerGender', 'pl_GetPlayerGender', ('var',)), ('GetRandom', 'pl_GetRandom', ('var', 'var')),
        ('AddItem', 'pl_AddItem', ('var', 'var', 'var')), ('RemoveItem', 'pl_RemoveItem', ('var', 'var', 'var')),
        ('CanFitItem', 'pl_CanFitItem', ('var', 'var', 'var')), ('CheckItem', 'pl_CheckItem', ('var', 'var', 'var')),
        ('GetItemPocket', 'pl_GetItemPocket', ('var', 'var')),
        ('GivePokemon', 'pl_GivePokemon', ('var', 'var', 'var', 'var')),
        ('GetPartyCount', 'pl_GetPartyCount', ('var',)), ('HealParty', 'pl_HealParty', ()),
        ('GiveRunningShoes', 'pl_GiveRunningShoes', ()), ('GivePokedex', 'pl_GivePokedex', ()),
        ('BufferPlayerName', 'pl_BufferPlayerName', ('n',)), ('BufferRivalName', 'pl_BufferRivalName', ('n',)),
        ('BufferItemName', 'pl_BufferItemName', ('n', 'var')), ('BufferPocketName', 'pl_BufferPocketName', ('n', 'var')),
        ('BufferPartyMonSpecies', 'pl_BufferPartyMonSpecies', ('n', 'var')),
        ('BufferPartyMonNickname', 'pl_BufferPartyMonNickname', ('n', 'var')),
        ('BufferMoveName', 'pl_BufferMoveName', ('n', 'var')), ('BufferTMHMMoveName', 'pl_BufferTMHMMoveName', ('n', 'var')),
        ('BufferNumber', 'pl_BufferNumber', ('n', 'var')),
        ('BufferPlayerStarterSpeciesName', 'pl_BufferPlayerStarterSpeciesName', ('n',)),
        ('BufferRivalStarterSpeciesName', 'pl_BufferRivalStarterSpeciesName', ('n',)),
        ('BufferPlayerCounterpartStarterSpeciesName', 'pl_BufferCounterpartStarterSpeciesName', ('n',)),
        ('GetPlayerStarterSpecies', 'pl_GetPlayerStarterSpecies', ('var',)),
]:
    HANDLERS[_pl] = simple(_macro, *_fmt)


ITEM_VARS = (0x8004, 0x8008)     # Pearl's give-item var (common script 2044's) and the item balls' (file 370)
PEARL_TMHM = range(328, 428)     # Pearl's TM01-TM92, HM01-HM08 items


def item_value(value):
    """(Black 2 item, comment) for an item value in a Pearl script: Pearl's TM/HM ids are mapped BY MOVE to the item
    that teaches the same move here (b2tools/tm_audit.py, notes/TMS.md: Black 2's TM of that number teaches another
    move, Pearl's 25 moves Black 2 lacks are TM96-TM120); other ids are Black 2's already. The comment `// Pearl item N`
    marks every TM/HM line for tm_audit.py check."""
    if value not in PEARL_TMHM:
        return value, ''
    import tm_audit
    b2 = tm_audit.pearl_item(value)
    pearl = tm_audit.pearl_label(value - 328)
    return b2, f'  // Pearl item {value} ({pearl}) = {tm_audit.item_name(b2)}'


ITEM_ARG = {'AddItem': 0, 'RemoveItem': 0, 'CanFitItem': 0, 'CheckItem': 0, 'GetItemPocket': 0, 'IsItemTMHM': 0,
            'BufferItemName': 1, 'BufferTMHMMoveName': 1, 'GetItemNamePlural': 1}


def _item_handler(fn, k):
    """A handler of a command with an item argument (ITEM_ARG): an immediate Pearl TM/HM id becomes Black 2's
    (item_value), with its comment on the line."""
    def h(tr, a, vals, name):
        if vals[k] >= 0x4000:                       # a var: the value was mapped where it was set
            return fn(tr, a, vals, name)
        b2, note = item_value(vals[k])
        out = fn(tr, a, [b2 if i == k else v for i, v in enumerate(vals)], name)
        return [out[0] + note] + out[1:] if note else out
    return h


@handler('SetVarFromValue')
def h_setvar(tr, a, vals, name):
    var, value = vals
    if var in ITEM_VARS:                        # an item (every value Pearl's scripts put there is one: tm_audit)
        b2, note = item_value(value)
        if note:
            return [f'pl_SetVarFromValue {tr.var(var)}, {b2}{note}']
    if 0x4020 <= var < 0x4030:                  # a dynamic sprite: Black 2 reads an object code from it
        import pearl_events
        code = pearl_events.sprite_code(value)
        if code is None:
            tr.job.stubs[f'SetVarFromValue (dynamic sprite {value}: no Black 2 code)'] += 1
            code = 0
        return [f'pl_SetVarFromValue {tr.var(var)}, {code}  // dynamic sprite: Pearl graphics {value} -> Black 2 code']
    return [f'pl_SetVarFromValue {tr.var(var)}, {value}']


@handler('End')
def h_end(tr, a, vals, name):
    return ['VMReturn  // End: the sub-script ends'] if tr.mode in ('common', 'proxytalk') else ['pl_End']


@handler('ReturnCommonScript')
def h_return_common(tr, a, vals, name):
    return ['pl_ReturnCommonScript']


@handler('WaitTime')
def h_wait(tr, a, vals, name):
    return [f'pl_WaitTime {vals[0]}, {tr.var(vals[1])}']


@handler('GoTo')
def h_goto(tr, a, vals, name):
    return [f'pl_GoTo {tr.label(vals[0])}']


@handler('GoToIf')
def h_gotoif(tr, a, vals, name):
    return [f'pl_GoToIf {vals[0]}, {tr.label(vals[1])}']


@handler('Call')
def h_call(tr, a, vals, name):
    if tr.prints(tr.d, vals[0]):
        tr.open_speaker = UNKNOWN              # (the subroutine shows a line)
    return [f'pl_Call {tr.call_label(a, vals[0])}']


@handler('CallIf')
def h_callif(tr, a, vals, name):
    if tr.prints(tr.d, vals[1]):
        tr.open_speaker = UNKNOWN
    return [f'pl_CallIf {vals[0]}, {tr.call_label(a, vals[1])}']


@handler('CloseMessage', 'CloseMessageWithoutErasing')
def h_close(tr, a, vals, name):
    tr.open_speaker = None
    return [f'pl_{name}']


@handler('Return')
def h_return(tr, a, vals, name):
    return ['pl_Return']


@handler('CheckFlagFromVar')
def h_cfv(tr, a, vals, name):
    return [f'pl_CheckFlagFromVar {tr.var(vals[0])}']


def trainer(tr, v):
    """A trainer argument: a Pearl trainer id (its Black 2 id's name), 0 = none, or a var."""
    if v == 0:
        return '0'
    return tr.job.ids.trainer(v) if v < 0x4000 else tr.var(v)


@handler('CheckTrainerFlag', 'SetTrainerFlag', 'ClearTrainerFlag')
def h_trainer_flag(tr, a, vals, name):
    tid = vals[0]
    return [f'pl_{name} {tr.job.ids.trainer(tid) if tid < 0x4000 else tr.var(tid)}']


# ---- messages
def speaker(tr, a, line):
    """('talk' | 'actor' | 'sys', uid) of a Message."""
    if tr.zone_file and line in tr.job.speakers:
        who = tr.job.speakers[line]
        return ('sys', None) if who == 'sys' else ('actor', who)   # 'sys': a narration line (the plain window)
    return ('talk', None) if tr.is_talk(a) else ('sys', None)


def switch_window(tr, kind, uid):
    """[MsgWinCloseAll] when another window may be open (FileTr.speakers_in), and the window this line opens."""
    out = []
    if tr.open_speaker not in (None, (kind, uid)):
        out.append('MsgWinCloseAll  // another speaker: close the first window')
    tr.open_speaker = (kind, uid)
    return out


@handler('Message', 'MessageNoSkip', 'MessageInstant')
def h_message(tr, a, vals, name):
    n = vals[0]
    out = []
    kind, uid = speaker(tr, a, n)
    src = tr.job.gen4_text.bank(tr.bank)[n]
    cp = tuple(sorted(i for i in tr.cp_bufs.get(a, set()) if i in tr.job.gen4_text.buffers(src)))
    out += switch_window(tr, kind, uid)
    apps = {i: v for i, v in tr.app_bufs(a).items() if i in tr.job.gen4_text.buffers(src)}
    if apps and not cp:                                     # the app's name written into the line (h_app_message)
        return out + h_app_message(tr, a, n, src, apps, kind, uid)
    if cp:
        boy, girl = (tr.job.line_for(tr.bank, n, (g, cp)) for g in ('boy', 'girl'))
        tail = f'  // Pearl line {n}, naming the counterpart: Dawn (boy) / Lucas (girl)'
        if kind == 'actor':
            return out + [f'pl_msg_actor_gendered {boy}, {girl}, {uid}{tail}']
        return out + [f'pl_msg_{kind}_gendered {boy}, {girl}{tail}']
    m = tr.job.line_for(tr.bank, n)
    note = '' if m == n and tr.zone_file else f'  // Pearl bank {tr.bank} line {n}'
    return out + [(f'pl_msg_actor {m}, {uid}' if kind == 'actor' else f'pl_msg_{kind} {m}') + note]


def message_var_values(tr, a, var):
    """The values SetVarFromValue gives var on every path into a (backwards over the script's own flow, at most 64
    steps a path), or None when a path reaches a without one or a call/other write could change it."""
    d, pd = tr.d, tr.job.pd
    preds = {}
    for x in d.insns:
        for t in tr.succ(x):
            preds.setdefault(t, []).append(x)
    out, seen, todo = set(), set(), [(p, 0) for p in preds.get(a, [])]
    if not todo:
        return None
    while todo:
        x, depth = todo.pop()
        if x in seen:
            continue
        seen.add(x)
        e, op, args = d.insns[x]
        n = pd.cmd_name(op)
        if n == 'SetVarFromValue' and args[0][1] == var:
            out.add(args[1][1])
            continue
        if depth >= 64 or n in ('Call', 'CallIf', 'CallCommonScript') or \
                (not n.startswith('Compare') and any(ty == 'var' and v == var for ty, v in args)):
            return None                                       # (anything else naming var may write it)
        if x not in preds:
            return None                                       # the script's start: nothing set var on this path
        todo += [(p, depth + 1) for p in preds[x]]
    return out


@handler('MessageUnown')
def h_message_unown(tr, a, vals, name):
    """Pearl's MessageUnown n (0x26D): line n of the zone's bank in the Unown alphabet (pokediamond ScrCmd_MessageUnown:
    the plain box with font 3), the Solaceon Ruins' wall writings, among them the maze's way ("TOP RIGHT, LOWER
    LEFT, ..."). Black 2 has no Unown font: the line in Latin letters in the same window (2026-10-25, chapter 4b)."""
    n = vals[0]
    tr.job.approx['MessageUnown (the line in Latin letters: Black 2 has no Unown font)'] += 1
    kind, uid = speaker(tr, a, n)
    m = tr.job.line_for(tr.bank, n)
    return switch_window(tr, kind, uid) + [(f'pl_msg_actor {m}, {uid}' if kind == 'actor' else f'pl_msg_{kind} {m}')
                                           + f'  // MessageUnown {n}']


@handler('MessageVar')
def h_message_var(tr, a, vals, name):
    # Pearl's line number in a var: a line of the script's own bank, which in Black 2 sits at another number in the
    # zone's text (line_for). When the script sets the var to constants on every way in (the Pokémon Center nurse,
    # Pearl common script 2002: 120 "Good morning", 121 "Hello", 0 "Good evening" by the time of day; 2026-10-25, the
    # user saw an empty window at 21:26), the message is a chain over those lines; else the var as the zone's own line.
    kind, _ = speaker(tr, a, -1)
    kind = 'talk' if kind == 'talk' else 'sys'
    out = switch_window(tr, kind, None)
    values = message_var_values(tr, a, vals[0])
    bank = tr.job.gen4_text.bank(tr.bank)
    if not values or any(v >= len(bank) for v in values):
        tr.job.approx['MessageVar (line number from a var: the zone file\'s own lines only)'] += 1
        return out + [f'pl_msg_{kind} {tr.var(vals[0])}']
    values = sorted(values)
    v_ = tr.var(vals[0])
    for v in values[:-1]:
        out += [f'WorkCmpConst {v_}, {v}', f'VMJumpIf CMP_NE, .Lmv{a:x}_{v}',
                f'pl_msg_{kind} {tr.job.line_for(tr.bank, v)}  // Pearl bank {tr.bank} line {v}',
                f'VMJump .Lmv{a:x}_end', f'.Lmv{a:x}_{v}:']
    return out + [f'pl_msg_{kind} {tr.job.line_for(tr.bank, values[-1])}  // Pearl bank {tr.bank} line {values[-1]}',
                  f'.Lmv{a:x}_end:']


@handler('BufferCounterpartName')
def h_counterpart(tr, a, vals, name):
    return [f'// BufferCounterpartName {vals[0]}: the lines naming Dawn/Lucas come as a boy and a girl copy']


# ---- Pokétch app names (Pearl GetPoketchAppName, pokediamond BufferPoketchAppName: bank 406). Black 2 has no
# word-buffer command that reads a free text line (the Pokétch's commands: h_poketch below), so a
# line naming an app gets the name written in: one copy per app (Pearl's caps names in Black 2's case, as species).
# The app is a constant at Route 207, the Berry Master's house and Pal Park; in common script 2009 ("obtained the
# Pokétch app ...") it is var 0x8004, which every caller sets the line before: the line becomes a chain over the
# values this zone's callers set (FileTr.app_bufs, Job.values_before_call; 2026-10-25, chapter 4a)
# Names Black 2 has no word for: Pearl's command -> (its text bank (pokediamond message_format.c), Pearl's capitals in
# Black 2's case): Pokétch apps (BufferPoketchAppName), Contest Accessories (GetFashionName, with an article:
# GetFashionNameWithArticle; 2026-10-25, chapter 4a: Keira's "Obtained the Glitter Powder!" in the Contest Hall).
NAME_SOURCES = {'BufferPoketchAppName': (406, True), 'BufferAccessoryName': (338, False),
                'GetFashionNameWithArticle': (339, False)}
NAME_WHAT = {'BufferPoketchAppName': 'the app', 'BufferAccessoryName': 'the Accessory',
             'GetFashionNameWithArticle': 'the Accessory'}


def source_name(cmd, k):
    import gen4_text
    bank, recase = NAME_SOURCES[cmd]
    nm = gen4_text.bank(bank)[k]
    if not recase:
        return nm
    return ' '.join('-'.join(w[:1] + w[1:].lower() for w in word.split('-')) for word in nm.split(' '))


def poketch_app_name(app):
    return source_name('BufferPoketchAppName', app)


@handler('BufferPoketchAppName', 'BufferAccessoryName', 'GetFashionNameWithArticle')
def h_source_name(tr, a, vals, name):
    return [f'// {name} {vals[0]}, {tr.var(vals[1]) if vals[1] >= 0x4000 else vals[1]}: the lines naming '
            f'{NAME_WHAT[name]} have its name written in (Black 2 has no word for it: NAME_SOURCES)']


def h_app_message(tr, a, n, src, apps, kind, uid):
    """A Message whose buffers hold a name Black 2 has no word for (FileTr.app_bufs, NAME_SOURCES): a copy of the
    line per name."""
    def line(binding):
        text = tr.job.gen4_text._STRVAR.sub(lambda m: source_name(*binding[int(m.group(2))])
                                            if int(m.group(2)) in binding else m.group(0), src)
        return tr.job.line_text((tr.bank, n, tuple(sorted(binding.items()))), text)

    def msg(m, note):
        return (f'pl_msg_actor {m}, {uid}' if kind == 'actor' else f'pl_msg_{kind} {m}') + f'  // {note}'
    fixed = {i: (c, v) for i, (c, v) in apps.items() if not isinstance(v, tuple)}
    var = [(i, c, v[1]) for i, (c, v) in apps.items() if isinstance(v, tuple)]
    if not var:
        return [msg(line(fixed), f'Pearl bank {tr.bank} line {n}, naming '
                                 f'{", ".join(source_name(c, v) for c, v in fixed.values())}')]
    (idx, cmd, v), = var[:1]
    entry = tr.starts[0][2] if tr.mode == 'common' else None
    values = sorted(tr.job.values_before_call(v, tr.f, entry)) if entry else []
    plain = tr.job.line_for(tr.bank, n)
    if not values:
        tr.job.approx[f'{cmd} (from a var no caller sets: the name is not written)'] += 1
        return [msg(plain, f'Pearl bank {tr.bank} line {n} ({NAME_WHAT[cmd]} from {tr.var(v)}: not known here)')]
    done = f'{tr.prefix}_{a:04X}_AppDone'
    out = []
    for k in values:
        out += [f'pl_CompareVarToValue {tr.var(v)}, {k}', f'pl_GoToIf 1, {tr.prefix}_{a:04X}_App{k}']
    out += [msg(plain, f'Pearl bank {tr.bank} line {n}: another one (no caller here sets it)'), f'pl_GoTo {done}']
    for k in values:
        out += [f'{tr.prefix}_{a:04X}_App{k}:', msg(line({**fixed, idx: (cmd, k)}), f'naming {source_name(cmd, k)}'),
                f'pl_GoTo {done}']
    return out + [f'{done}:']


SIGN_TYPE = {0: 1, 1: 3, 2: 2, 3: 0}     # Pearl map/arrow/landmark/scrolling -> Black 2's sign windows (1, 3, 2, 0)


@handler('DrawSignpostInstantMessage')
def h_sign(tr, a, vals, name):
    n, ptype = vals[0], vals[1]
    tr.open_speaker = None                     # (pl_sign closes its window)
    return [f'pl_sign {tr.job.line_for(tr.bank, n)}, {SIGN_TYPE.get(ptype, 2)}  // Pearl sign type {ptype}']


@handler('DrawSignpostTextBox')
def h_sign_box(tr, a, vals, name):
    tr.sign_type = vals[0]
    return [f'// DrawSignpostTextBox type {vals[0]} (the window opens with the next sign message)']


@handler('DrawSignpostScrollingMessage')
def h_sign_scroll(tr, a, vals, name):
    tr.open_speaker = None
    return [f'pl_sign {tr.job.line_for(tr.bank, vals[0])}, {SIGN_TYPE.get(tr.sign_type, 0)}  // Pearl sign type '
            f'{tr.sign_type}']


@handler('SetSignpostCommand', 'WaitForSignpostDone')
def h_sign_rest(tr, a, vals, name):
    return [f'// {name}: done by pl_sign']


@handler('GetSignpostInput')
def h_sign_input(tr, a, vals, name):
    return [f'WorkSetConst {tr.var(vals[0])}, 0  // GetSignpostInput: Black 2\'s sign closes on A/B']


# ---- common scripts
NATIVE_COMMON = {
    2000: ['// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign'],
}


@handler('CallCommonScript')
def h_common(tr, a, vals, name):
    sid = vals[0]
    if sid in NATIVE_COMMON:
        return NATIVE_COMMON[sid]
    if sid < 2000:
        tr.job.stubs['CallCommonScript (a zone script)'] += 1
        return [f'pl_stub CallCommonScript  // script {sid} of the zone: not a common script']
    f, bank, entry = script_location(sid)
    cd = tr.job.pd.disasm(f)
    if tr.prints(cd, cd.entries[entry - 1]):
        tr.open_speaker = UNKNOWN              # (the common script shows lines in its own window)
    return [f'VMCall {tr.job.label_common(sid)}  // CallCommonScript {sid} (Pearl file {f} script {entry})']


# ---- objects
def actor(tr, v):
    """Black 2 actor of a Pearl object id: 0xFF the player; 0xF2 (the object that follows) and 0xFE (its id after
    EventStopFollowing) = Black 2's follower 0xFE (pair_sys.c FOLLOWER_ACTOR_ID)."""
    if v == 0xFF:
        return 'PL_PLAYER'
    if v in (0xF2, 0xFE):
        return 'PL_FOLLOWER'
    return tr.var(v)


@handler('AddObject')
def h_add(tr, a, vals, name):
    if tr.levels(a) == {2}:                    # zone init: no actors yet; the object appears by its flag
        return [f'// AddObject {vals[0]} in the zone init: it appears by its flag (ActorAdd is not allowed there)']
    o = tr.job.objects.get(vals[0]) if tr.mode != 'common' else None
    import pearl_events
    if o is not None and pearl_events.object_skipped(o, tr.job.zone) is not None:
        # (2026-10-26, chapter 8) a Pearl object with no Black 2 actor (the Elite Four rooms' doors) is not in the
        # zone's NPC list, and Black 2's ActorAdd of a uid with no entity returns an unset pointer it then writes
        # through (ov012 SpawnZoneNPCByUID's BUG): nothing
        tr.job.approx['AddObject (an object with no Black 2 actor: nothing)'] += 1
        return [f'// AddObject {vals[0]}: not installed ({pearl_events.object_skipped(o, tr.job.zone)}): nothing']
    slot = obj_slot(tr, vals[0]) if o is not None else None
    if slot is not None:                       # placed by a SetObjectEventPos of this script (if one ran)
        return [f'pl_AddObjectAt {vals[0]}, {slot}, {o["initial_dir"]}  // at its SetObjectEventPos']
    out = [f'pl_AddObject {tr.var(vals[0])}']
    pos = tr.job.pending_pos.get(vals[0])
    if pos:
        out.append(f'pl_SetPosition {vals[0]}, {pos[0]}, {pos[2]}, {pos[1]}, {pos[3]}  // its SetObjectEventPos')
    return out


ITEM_BALL_FILE = 370             # Pearl's item-ball scripts 7000+n (SCRIPT_RANGES): entry n+1 sets the item, then 256
LAST_TALKED = 0x800D             # Pearl's VAR_LAST_TALKED (Black 2's 0x8011, pearl.h PVAR_800D)


def item_ball_item(pd, sid):
    """The Pearl item an item-ball script (7000+n) gives: its SetVar 0x8008 (pokediamond scr_seq 370)."""
    f, bank, entry = script_location(sid)
    assert f == ITEM_BALL_FILE, sid
    d = pd.disasm(f)
    a = d.entries[entry - 1]
    for _ in range(3):
        end, op, args = d.insns[a]
        if pd.cmd_name(op) == 'SetVarFromValue' and args[0][1] == 0x8008:
            return args[1][1]
        a = end
    raise ValueError(f'item-ball script {sid}: no item')


@handler('IsItemTMHM')
def h_item_tmhm(tr, a, vals, name):
    """Pearl ItemIdIsTMOrHM item, result (0x7F; pokediamond scrcmd_items.c) = Black 2's ItemIsTMHM (FieldCommand 186,
    the same order): Pearl's item ids up to 467 are Black 2's (2026-10-25, chapter 4b: the item-ball script's TM/HM
    line)."""
    return [f'ItemIsTMHM {tr.var(vals[0])}, {tr.var(vals[1])}  // ItemIdIsTMOrHM']


@handler('TrySetUnusedCollectedOrbFlag')
def h_orb_flag(tr, a, vals, name):
    """Pearl 0x2A2 (pokediamond ScrCmd_Unk02A2): for the Adamant / Lustrous Orb (items 135, 136) a save record of
    Pearl's (sub_02025C30) that no script reads; nothing in Black 2."""
    return [f'// Unk02A2 {tr.var(vals[0])}: Pearl\'s orb record (items 135/136), read by no script: nothing in Black 2']


@handler('RemoveObject')
def h_remove(tr, a, vals, name):
    if tr.f == ITEM_BALL_FILE and vals[0] == LAST_TALKED:
        # Pearl's item-ball script removes the talked-to ball and its RemoveEvent sets the ball's flag: Black 2's
        # ActorDelete does not, so the ball's own flag (data/pearl_item_balls.json, pearl_events.item_ball_flag) is
        # set as Black 2's item script does it (2026-10-25, chapter 4b)
        return ['pl_RemoveTalkedObject  // RemoveEvent VAR_LAST_TALKED: the ball, and its flag']
    o = tr.job.objects.get(vals[0]) if tr.mode != 'common' else None
    flag = tr.flag(o['hidden_flag']) if o and o['hidden_flag'] else '0'
    if tr.levels(a) == {2}:
        return [f'pl_SetFlag {flag}  // RemoveObject {vals[0]} in the zone init: its flag (ActorDelete is not allowed '
                f'there)'] if flag != '0' else [f'// RemoveObject {vals[0]} in the zone init (no flag)']
    if vals[0] in tr.follow_uids or vals[0] in (0xF2, 0xFE):
        return [f'pl_follow_leave', f'pl_RemoveObject {actor(tr, vals[0])}, {flag}']
    return [f'pl_RemoveObject {tr.var(vals[0])}, {flag}']


def ev_object(tr, uid, what):
    if tr.mode == 'common' or uid not in tr.job.objects:
        tr.job.stubs[f'{what} (object not in the zone)'] += 1
        return None, None
    if uid not in tr.job.object_index:
        tr.job.stubs[f'{what} (an object Black 2 does not install: item ball, berry soil, no actor)'] += 1
        return None, None
    return tr.job.object_index[uid], tr.job.objects[uid]


_HEIGHTS = None


def grid_y(tr, x, z, pearl_y):
    """Black 2's height step (16 units) of tile (x, z) of this zone's converted map, for a script that places a person.
    Pearl's own y counts Pearl's levels (Jubilife's ground is 1 there, 2 in the converted map): a person placed with it
    stood a level below the player, so Black 2 neither drew nor let anyone talk to them (the Pokétch president after
    the third clown, found in game 2026-10-19). Pearl's y is kept only when the tile is a variable or has no height."""
    global _HEIGHTS
    if not (isinstance(x, int) and isinstance(z, int)) or x >= 0x4000 or z >= 0x4000:
        return pearl_y
    if _HEIGHTS is None:
        import pearl_events
        _HEIGHTS = pearl_events.Heights()
    h = _HEIGHTS.at(tr.job.zone, x, z)
    return pearl_y if h is None else h // 16


def same_block_before(tr, a, cmd, uid, limit=8):
    """The values of the last `cmd` on object uid earlier in a's basic block (no label, entry or jump in between), or
    None. Black 2's zone-init command for a person (ObjInitNPCGPos) sets tile and direction at once, Pearl's
    SetObjectEventPos and SetObjectEventDir one each: a pair in one block becomes one place (2026-10-20: the Dir half
    re-sent Mom's original tile and undid her move before the Running Shoes scene, so she walked off the room)."""
    d = tr.d
    if getattr(tr, '_blocks', None) is None:
        ends = {e: s for s, (e, op, args) in d.insns.items()}
        targets = {t for s, (e, op, args) in d.insns.items() for ty, t in args if ty == 'rel'}
        tr._blocks = ends, targets | {s for _, s, _ in tr.starts}
    ends, targets = tr._blocks
    for _ in range(limit):
        p = None if a in targets else ends.get(a)
        if p is None:
            return None
        e, op, args = d.insns[p]
        if tr.job.pd.table[op]['flow'] in ('end', 'jump', 'return'):
            return None
        if tr.job.pd.cmd_name(op) == cmd and args[0][1] == uid:
            return [v for ty, v in args]
        a = p
    return None


@handler('SetObjectEventPos')
def h_setobjpos(tr, a, vals, name):
    uid, x, z = vals
    i, o = ev_object(tr, uid, name)
    if o is None:
        return [f'pl_stub SetObjectEventPos  // object {uid} is not in this zone']
    y = grid_y(tr, x, z, o['y'])
    if tr.levels(a) == {2}:
        turned = same_block_before(tr, a, 'SetObjectEventDir', uid)     # (a Dir just before: keep it)
        d = tr.var(turned[1]) if turned else o['initial_dir']
        return [f'pl_SetObjectEventPos {i}, {tr.var(x)}, {tr.var(z)}, {d}, {y}  // object {uid}']
    # outside the zone init Black 2 cannot change the zone's NPC list (ObjInitNPCGPos: level 2 only): the actor is
    # moved now if it is there, and when the script adds it
    slot = obj_slot(tr, uid)
    if slot is not None:                       # and AddObject puts it there (pl_AddObjectAt), in this script's run
        return [f'pl_SetObjectEventPosLater {slot}, {uid}, {tr.var(x)}, {y}, {tr.var(z)}, {o["initial_dir"]}  '
                f'// SetObjectEventPos {uid} (the live actor; and where AddObject puts it)']
    tr.job.pending_pos[uid] = (tr.var(x), tr.var(z), y, o['initial_dir'])
    return [f'pl_SetPosition {uid}, {tr.var(x)}, {y}, {tr.var(z)}, {o["initial_dir"]}  // SetObjectEventPos {uid} '
            f'(the live actor)']


OBJ_SLOTS = 5                                  # pearl_story.inc PL_OBJ_X/Y/Z: works 0x8030-0x803E


def obj_slot(tr, uid):
    """The work slot holding where AddObject puts object uid (Pearl's SetObjectEventPos outside the zone init), or None
    (more than OBJ_SLOTS such objects in one file: the last place in address order, as before 2026-10-20)."""
    if getattr(tr, '_obj_slots', None) is None:
        tr._obj_slots = {}
        for a in sorted(tr.d.insns):
            e, op, args = tr.d.insns[a]
            if a in tr.reach_from and tr.job.pd.cmd_name(op) == 'SetObjectEventPos' and tr.levels(a) != {2}:
                u = args[0][1]
                if u not in tr._obj_slots and len(tr._obj_slots) < OBJ_SLOTS:
                    tr._obj_slots[u] = len(tr._obj_slots)
    return tr._obj_slots.get(uid)


@handler('SetObjectEventDir')
def h_setobjdir(tr, a, vals, name):
    uid, d = vals
    i, o = ev_object(tr, uid, name)
    if o is None:
        return [f'pl_stub SetObjectEventDir  // object {uid} is not in this zone']
    if tr.levels(a) == {2}:
        moved = same_block_before(tr, a, 'SetObjectEventPos', uid)      # (a Pos just before: turn there)
        if moved:
            x, z = moved[1], moved[2]
            return [f'pl_SetObjectEventPos {i}, {tr.var(x)}, {tr.var(z)}, {tr.var(d)}, {grid_y(tr, x, z, o["y"])}  '
                    f'// SetObjectEventDir {uid} (at the place SetObjectEventPos just gave)']
        return [f'pl_SetObjectEventPos {i}, {o["x"]}, {o["z"]}, {tr.var(d)}, {grid_y(tr, o["x"], o["z"], o["y"])}  '
                f'// SetObjectEventDir {uid} (at its own place)']
    return [f'pl_ApplyMovement {uid}, .Lface{a:x}  // SetObjectEventDir {uid}: the live actor turns',
            'pl_WaitMovement', f'VMJump .Lface{a:x}_end', '.balign 4, 0', f'.Lface{a:x}:',
            f'    Move {vals[1] if vals[1] < 4 else 0}, 1', '    MoveEnd', f'.Lface{a:x}_end:']


_PLANNER = None


@handler('SetWarpEventPos')
def h_setwarp(tr, a, vals, name):
    """Black 2 places the warp at y = arg * 16 units and fires it within 2 units of the walker's height
    (ObjInitWarpGPos, ov012 SetZoneWarpLocation / CheckWarpPositionMatch): y is the height, in 16-unit steps rounded,
    of the tile the player fires it from (a mat: its own tile; a bump warp: the tile its dir steps from). Before
    2026-10-20 y was 0: Valley Windworks' door, moved back to (243, 654) on 80-unit ground, would never fire."""
    global _PLANNER
    i, x, z = vals
    y = 0
    if tr.zone_file and i < 0x4000:
        if _PLANNER is None:
            from patches import sinnoh_events
            _PLANNER = (sinnoh_events, sinnoh_events.Planner())
        se, pl = _PLANNER
        ws = pl.warps(tr.job.zone['id'])[0] if tr.job.zone['id'] in pl.b2_of else []
        if i < len(ws):
            w = ws[i]
            units = (w['y'] ^ 0x8000) - 0x8000                  # the warp's own height (s16)
            if x < 0x4000 and z < 0x4000:
                step = {0: (0, -1), 1: (0, -1), 2: (0, 1), 3: (-1, 0), 4: (1, 0)}.get(w['dir'], (0, 0))
                fx, fz = (x, z) if w['type'] in (0, 1) else (x + step[0], z + step[1])
                t = pl.tile(pl.matrix(tr.job.zone['matrix']), fx, fz)
                if t is not None and t[2] is not None:
                    units = t[2]
            y = int(round(units / 16))
    return [f'pl_SetWarpEventPos {tr.var(vals[0])}, {tr.var(vals[1])}, {tr.var(vals[2])}, {y}']


@handler('InitTurnbackCave')
def h_turnback(tr, a, vals, name):
    """Pearl 0x285 (pokediamond ScrCmd_Unk0285, pokeplatinum ScrCmd_InitTurnbackCave): Turnback Cave's maze sets the
    doors of the room. Here in the zone init only the room's rocks (a zone holding two of Pearl's rooms); the doors
    after the arrival, in the zone's TurnbackDoors map script (b2tools/turnback.py, PearlData.turnback_doors)."""
    import turnback
    tr.job.approx['InitTurnbackCave (the doors in a map script after the arrival: b2tools/turnback.py)'] += 1
    return turnback.init_lines(tr, vals)


@handler('SetBgEventPos')
def h_setbg(tr, a, vals, name):
    """Pearl 0x18B (SetBgEventPosition index, x, z) moves a sign (BG event) = Black 2's ObjInitPointGPos (ov012
    SetBGEntityLocation; every level). Pearl's BG events keep their index in the zone's sign list (pearl_events.entities
    puts Pearl's sign objects after them); y = the tile's height in units, as a sign's (pearl_events sign_y). Valley
    Windworks: the door's "It's locked" sign moves away once the Works Key opened it (2026-10-25)."""
    i, x, z = vals
    y = 0
    if isinstance(x, int) and isinstance(z, int) and x < 0x4000 and z < 0x4000:
        global _HEIGHTS
        if _HEIGHTS is None:
            import pearl_events
            _HEIGHTS = pearl_events.Heights()
        y = _HEIGHTS.at(tr.job.zone, x, z) or 0
    return [f'pl_SetBgEventPos {tr.var(i)}, {tr.var(x)}, {tr.var(z)}, {y}  // SetBgEventPosition {i}, {x}, {z}']


@handler('SetPosition')
def h_setpos(tr, a, vals, name):
    uid, x, y, z, d = vals
    return [f'pl_SetPosition {tr.var(uid)}, {tr.var(x)}, {grid_y(tr, x, z, tr.var(y))}, {tr.var(z)}, {tr.var(d)}']


@handler('SetMovementType')
def h_setmove(tr, a, vals, name):
    import pearl_events
    uid, t = vals
    if t == FOLLOW:
        ally = same_block_before(tr, a, 'SetVarFromValue', PARTNER_VAR)
        if ally and ally[1] < 0x4000 and str(ally[1]) in tr.job.ids.reg['trainers']:
            # a partner this file also stops (SetObjectFlagIsPersistent X, 0: Cheryl at the forest's entrance) stays
            # in the zone: Black 2's non-persistent follower, which ActorPairEnd gives back its own id, so Pearl's
            # later moves of object X find it (a persistent one keeps 0xFE for good)
            stays = any(self_op == 'SetObjectFlagIsPersistent' and args[0][1] == uid and args[1][1] == 0
                        for self_op, args in ((tr.job.pd.cmd_name(op), args) for e, op, args in tr.d.insns.values()))
            stays = stays or partner_stays(tr, uid)
            return [f'pl_follow_start_ally {actor(tr, uid)}, {tr.job.ids.trainer(ally[1])}, {0 if stays else 1}  '
                    f'// Pearl SetMovementType {uid}, 0x30 with partner trainer {ally[1]} (var 0x403F): follows and '
                    f'battles with you{" (in this zone only)" if stays else ""}']
        return [f'pl_follow_start {actor(tr, uid)}  // Pearl SetMovementType {uid}, 0x30 (follow the player)']
    if uid in tr.follow_uids or uid in (0xF2, 0xFE):
        return [f'pl_follow_hold {actor(tr, uid)}, {pearl_events.b2_move(t)}  // Pearl SetMovementType {uid}, {t}: '
                f'the follower stops to be moved by the script']
    return [f'pl_SetMovementType {actor(tr, uid)}, {pearl_events.b2_move(t)}  // Pearl movement type {t}']


@handler('SetObjectFlagIsPersistent')
def h_keep(tr, a, vals, name):
    if vals[1] == 0 and (vals[0] in (0xF2, 0xFE) or vals[0] in tr.follow_uids):
        return [f'pl_follow_end  // SetObjectFlagIsPersistent {vals[0]}, 0: the follower stops following']
    tr.job.approx['SetObjectFlagIsPersistent (not needed: Black 2 keeps actors while the zone is loaded)'] += 1
    return [f'// SetObjectFlagIsPersistent {vals[0]}, {vals[1]}: not needed in Black 2']


# ---- sound
@handler('PlaySE', 'StopSE', 'WaitSE', 'PlayFanfare', 'PlayMusic', 'SetBGM')
def h_sound(tr, a, vals, name):
    macro = {'PlaySE': 'pl_PlaySE', 'StopSE': 'pl_StopSE', 'WaitSE': 'pl_WaitSE', 'PlayFanfare': 'pl_PlayFanfare',
             'PlayMusic': 'pl_PlayMusic', 'SetBGM': 'pl_PlayMusic'}[name]
    b2, pname = seq_name(vals[0])
    if macro == 'pl_PlayMusic' and pname in PEARL_SONGS:     # Pearl's own song (patches/sinnoh_music EVENT_SONGS)
        alt = [f'    {macro} {b2}  // Black 2 stand-in (a build without sinnoh_music)'] if b2 else \
              [f'    pl_stub {name}  // Pearl sound {pname}: no Black 2 stand-in']
        return [f'#ifdef SEQ_PEARL_{pname[4:]}', f'    {macro} SEQ_PEARL_{pname[4:]}  // Pearl {pname}', '#else',
                *alt, '#endif']
    if b2 is None:
        tr.job.stubs[f'{name} {pname or vals[0]} (no Black 2 sound chosen)'] += 1
        return [f'pl_stub {name}  // Pearl sound {pname or vals[0]}: no Black 2 sound chosen yet']
    return [f'{macro} {b2}  // Pearl {pname}']


@handler('PlayCry')
def h_cry(tr, a, vals, name):
    return [f'pl_PlayCry {tr.var(vals[0])}']


@handler('PlayDefaultMusic')
def h_defmusic(tr, a, vals, name):
    return ['pl_PlayDefaultMusic']


@handler('StopMusic')
def h_stopmusic(tr, a, vals, name):
    tr.job.approx['StopMusic (a short fade-out)'] += 1
    return ['pl_FadeOutBGM 1  // StopMusic']


# ---- the wall maps (2026-10-26; Pearl's tile behaviour 0x85 -> pearl_events.TOWN_MAP's sign events): Pearl's common
# script 2508 is PlaySE, LockAll, FadeScreen out, WaitFadeScreen, OpenRegionMap (pokediamond ScrCmd_ShowTownMapScreen:
# the Town Map app), ReturnToField, FadeScreen in, WaitFadeScreen, ReleaseAll. Black 2's CallPlaceSelect runs the town
# map as a field subprocess (ov036 s0284_CallPlaceSelect: EventFieldSubprocessCall closes and reopens the field), so
# the ReturnToField after it is dropped; patches/town_map.py opens it view-only in a zone without Fly (the rooms).
@handler('OpenRegionMap')
def h_region_map(tr, a, vals, name):
    tr.after_region_map = True
    return ['CallPlaceSelect PL_TMP, PL_TMP2  // OpenRegionMap: the Sinnoh town map, view-only here (patches/town_map.py)']


@handler('FadeOutBGM')
def h_fadebgm(tr, a, vals, name):
    return [f'pl_FadeOutBGM {vals[1]}  // FadeOutBGM to volume {vals[0]}']


# ---- screen
@handler('FadeScreen')
def h_fade(tr, a, vals, name):
    trans, frames, typ, color = vals
    if a in poke_select_fades(tr):
        return [f'// FadeScreen {trans}, {frames}, {typ}, {color:#x}: Black 2\'s party select fades itself']
    if typ == 1 and tr.after_starter:
        tr.after_starter = False
        return [f'pl_fade_in_after_starter  // FadeScreen {trans}, {frames}, {typ}, {color:#x} (the starter screen ends '
                f'white in Black 2)']
    if typ not in (0, 1):
        tr.job.approx[f'FadeScreen type {typ}'] += 1
    return [f'pl_fade_{"in" if typ == 1 else "out"}_{"white" if color else "black"}  // FadeScreen {trans}, {frames}, '
            f'{typ}, {color:#x}']


# ---- warps
# ---- elevators (ELEVATOR_FLOORS_ABOVE: the floor the player came from, and where the exit goes)
@handler('GetFloorsAbove')
def h_floors_above(tr, a, vals, name):
    return [f'WorkSet {tr.var(vals[0])}, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the '
            f'floor the player came from (PearlElevatorInit)']


@handler('SetSpecialLocation')
def h_special_location(tr, a, vals, name):
    m, w, x, z, d = vals
    pd = tr.job.pd
    if any(v >= 0x4000 for v in vals) or pd.b2_zone.get(m) is None:
        tr.job.stubs['SetSpecialLocation (a var, or a zone not installed)'] += 1
        return [f'pl_stub SetSpecialLocation  // Pearl SetDynamicWarp {vals}']
    ws = pd.events(pd.zones[m])['warp_events']
    if w < len(ws):                                 # Pearl takes a warp's tile when it names one (Location.warpId)
        x, z = ws[w]['x'], ws[w]['z']
        import pearl_events
        h = pearl_events.Heights()
        dx, dz = {0: (0, -1), 1: (0, 1), 2: (-1, 0), 3: (1, 0)}.get(d, (0, 0))
        if h.solid(pd.zones[m], x, z) and not h.solid(pd.zones[m], x + dx, z + dz):
            x, z = x + dx, z + dz                   # (a door tile: Black 2 puts the player where it is told)
    else:
        h = None
    y = h.at(pd.zones[m], x, z) if h else None
    return [f'FieldSetNextZone {pd.b2_zone[m]}, {d + 1}, {x}, {round((y or 0) / 16)}, {z}  // SetDynamicWarp: the exit '
            f'(dest 0x100) goes to Pearl map {m} ({pd.zones[m]["name"]}) warp {w}',
            f'WorkSetConst PL_ELEVATOR_FROM, {ELEVATOR_FLOORS_ABOVE.get(m, 1)}  // and that is now where the player '
            f'came from']


@handler('ShowCurrentFloor')
def h_show_floor(tr, a, vals, name):
    tr.job.approx['ShowCurrentFloor (no floor window in Black 2)'] += 1
    return [f'// ShowCurrentFloor {vals[0]}, {vals[1]}, {tr.var(vals[2])}: no floor window in Black 2']


@handler('PlayElevatorAnimation')
def h_elevator_anim(tr, a, vals, name):
    tr.job.approx['PlayElevatorAnimation (Black 2\'s elevator sounds and a wait: no shaking room)'] += 1
    return [f'pl_elevator_ride  // PlayElevatorAnimation {tr.var(vals[0])}, {tr.var(vals[1])}']


@handler('Warp')
def h_warp(tr, a, vals, name):
    m, _, x, z, d = vals
    pd = tr.job.pd
    b2 = pd.b2_zone.get(m)
    if b2 is None:
        tr.job.stubs['Warp (to a zone not installed)'] += 1
        return [f'pl_stub Warp  // to Pearl map {m}: no Black 2 zone (not installed)', 'pl_ReleaseAll', 'pl_End']
    ids, _ = pd.arrival_ids(m)
    sid = ids[(tr.f, a)]
    if (x >= 0x4000 or z >= 0x4000) and tr.f in CAMERA_PLAN_FILES and camera_plan(pd, tr.f) is not None \
            and None not in {c for xz in _WARP_PLACES[tr.f].get(a, {(None, None)}) for c in xz}:
        # Black 2's MapChangeCore takes numbers, not works (ov036 scrcmd_mapchange.c: VM_Read16): a Warp to a place
        # in vars (Spear Pillar's vistas going back to where the player stood: Pearl file 230, 0x458) is a chain over
        # the places camera_plan finds the scene there with (2026-10-26, chapter 7: the player landed at (0x8020,
        # 0x8021), the var numbers). Black 2's script works 0x8000+ live in the running script (ov012
        # script_work.c: a new, cleared ScriptWork for each script, the continuation after a map change too), so
        # vars set before an earlier Warp of the chain read 0 here: the last place, the one taken then, is the
        # middle one (Spear Pillar: the player comes back to (31, 35), the middle of the row of five).
        out, places = end_free_camera(tr, 'a Warp', a), sorted(_WARP_PLACES[tr.f][a])
        mid = places[len(places) // 2]
        places = [p_ for p_ in places if p_ != mid] + [mid]
        for i, (px, pz) in enumerate(places):
            nxt = f'.Lwarp{a:x}_{i + 1}'
            if i < len(places) - 1:
                out += [f'WorkCmpConst {tr.var(x)}, {px}' if x >= 0x4000 else '', f'VMJumpIf CMP_NE, {nxt}' if x >= 0x4000 else '',
                        f'WorkCmpConst {tr.var(z)}, {pz}' if z >= 0x4000 else '', f'VMJumpIf CMP_NE, {nxt}' if z >= 0x4000 else '']
            out += [f'RTReserveScript {sid}  // the rest of this Pearl script runs there (continuation {sid})',
                    f'pl_Warp {b2}, {px}, {pz}, {d}  // Pearl map {m} ({pd.zones[m]["name"]}) at ({tr.var(x)}, '
                    f'{tr.var(z)}) = ({px}, {pz})', 'pl_ReleaseAll', 'pl_End']
            if i < len(places) - 1:
                out.append(f'{nxt}:')
        return [l for l in out if l]
    return end_free_camera(tr, 'a Warp', a) + [f'RTReserveScript {sid}  // the rest of this Pearl script runs there (continuation {sid})',
            f'pl_Warp {b2}, {tr.var(x)}, {tr.var(z)}, {d}  // Pearl map {m} ({pd.zones[m]["name"]})',
            'pl_ReleaseAll', 'pl_End']


# ---- Chapter 6a (2026-10-25): the boats, Pearl's moving platforms, the Riolu Egg, the library's tremor
@handler('PlayBoatCutscene')
def h_boat(tr, a, vals, name):
    """Pearl 0x23D ShipAnimation (pokediamond ScrCmd_ShipAnimation: travel way, the player's facing on arrival, map, x,
    z; pokeplatinum FieldSystem_PlayBoatCutscene): the ship sails off (Canalave's drawbridge opens), the screen and the
    music fade, a voyage scene, then the map change to (x, z). Here Black 2's own boat cutscene by the way the ship
    sails (pl_BoatCutscene: Eldritch's boat = demo 4, the Snowpoint ship = demo 26, as HoennB2's boats), then the map
    change to Pearl's place, where PearlArrive fades in. Eldritch's boat (Canalave <-> Iron Island), the Snowpoint
    ship (post-game), Fullmoon / Newmoon (Chapter 9)."""
    travel, facing, m, x, z = vals
    pd = tr.job.pd
    b2 = pd.b2_zone.get(m)
    if b2 is None:
        tr.job.stubs['PlayBoatCutscene (to a zone not installed)'] += 1
        return [f'pl_stub PlayBoatCutscene  // to Pearl map {m}: no Black 2 zone']
    tr.job.approx['PlayBoatCutscene (Black 2\'s boat demo for Pearl\'s ship scenes; no drawbridge)'] += 1
    _, arrive = pd.arrival_ids(m)
    return [f'pl_BoatCutscene {travel}  // Pearl ShipAnimation {travel}, {facing}, {m}, {x}, {z}: Black 2\'s boat demo',
            f'RTReserveScript {arrive}  // PearlArrive there',
            f'pl_Warp {b2}, {x}, {z}, {facing}  // Pearl map {m} ({pd.zones[m]["name"]})']


def platform_zone(tr):
    """Whether this zone's platforms are Black 2's gimmick 59 (b2tools/pearl_gimmicks.py)."""
    import pearl_gimmicks
    return tr.job.zone['name'] in {c['name'] for c in pearl_gimmicks.zone_configs()}


@handler('InitPersistedMapFeaturesForCanalaveGym', 'InitPersistedMapFeaturesForPlatformLift', 'TriggerPlatformLift')
def h_platforms(tr, a, vals, name):
    """Pearl's platforms (the Canalave Gym's InitCanalaveGym; the platform lifts' set-up and trigger, which their zone
    script and step trigger run): Black 2's gimmick 59 sets them up on entry and moves them when the player steps on
    them (decomp src/pearlb2/pearl_platforms_itcm.c, patches/pearl_platforms.py), so the scripts have nothing to do.
    Zones not in the gimmick yet (the League's lifts) keep the stub."""
    if not platform_zone(tr):
        tr.job.stubs[f'{name} (a zone without gimmick 59 yet)'] += 1
        return [f'pl_stub {name}  // the zone is not in b2tools/pearl_gimmicks.py yet']
    import pearl_gimmicks
    if name == 'TriggerPlatformLift' and pearl_gimmicks.scripted_lift(tr.job.zone['name']):
        # (2026-10-26, chapter 8) a lift whose ride Pearl starts from a script with the player on it (Cynthia's room,
        # after her battle: no step trigger): the script asks gimmick 59 and waits for the ride
        tr.job.approx['TriggerPlatformLift from a script (gimmick 59 rides when asked: PVAR_GIMMICK_REQUEST)'] += 1
        return ['pl_TriggerPlatformLiftRide  // Pearl TriggerPlatformLift: gimmick 59 rides the lift with the player']
    tr.job.approx[f'{name} (gimmick 59 does it: patches/pearl_platforms.py)'] += 1
    return [f'// {name}: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)']


@handler('CheckPlatformLiftNotUsedWhenEnteredMap')
def h_lift_not_used(tr, a, vals, name):
    """Pearl 0x25D (pokeplatinum PlatformLift_WasNotUsedWhenEnteredMap): 1 when the player came into a League lift
    room at the bottom (Pearl's lift then waits there and its step trigger is armed), 0 at the top. Gimmick 59 places
    the lift by the player's floor and rides it on the step itself, so the trigger's script has nothing to do either
    way: 1, Pearl's answer on every way into these rooms (each is entered from below; 2026-10-26, chapter 8)."""
    if not platform_zone(tr):
        tr.job.stubs[f'{name} (a zone without gimmick 59 yet)'] += 1
        return [f'pl_stub {name}  // {tr.var(vals[0])}: the zone is not in b2tools/pearl_gimmicks.py yet']
    tr.job.approx[f'{name} (1: gimmick 59 places the lift by the player\'s floor)'] += 1
    return [f'WorkSetConst {tr.var(vals[0])}, 1  // Pearl {name}: the lift waits at the player\'s floor (gimmick 59)']


@handler('InitPersistedMapFeaturesForSunyshoreGym')
def h_sunyshore_init(tr, a, vals, name):
    """Pearl 0x175 InitSunyshoreGym room (the gym rooms' zone scripts; pokediamond InitSunyshoreGym 0x02064D88): the
    gears' start state by the room and the warp the player came in by (from the entrance: 0; else rooms 1-3 at 2, 1,
    0). Gimmick 62 (decomp src/pearlb2/sunyshore_gym_itcm.c, patches/sunyshore_gym.py) decides it on the zone's first
    frame by the player's tile, so the script has nothing to do (2026-10-26, chapter 8)."""
    tr.job.approx['InitSunyshoreGym (gimmick 62 does it)'] += 1
    return [f'// InitSunyshoreGym {vals[0]}: gimmick 62 sets the gears by the player\'s way in (sunyshore_gym_itcm.c)']


@handler('PressSunyshoreGymButton')
def h_sunyshore_button(tr, a, vals, name):
    """Pearl 0x176 RotateSunyshoreGymGear type (0 a quarter turn, 1 a quarter back, 2 a half turn; pokeplatinum
    SunyshoreGym_PressButton): every gear of the room turns and the script waits (Pearl's field task). Gimmick 62 turns
    them; pl_RotateSunyshoreGymGear asks through PVAR_GIMMICK_REQUEST (1 + the type) and waits for 0 (2026-10-26,
    chapter 8)."""
    if vals[0] >= 0x4000:
        tr.job.stubs['RotateSunyshoreGymGear (the type from a var)'] += 1
        return [f'pl_stub {name}  // {tr.var(vals[0])}']
    return [f'pl_RotateSunyshoreGymGear {vals[0]}  // Pearl RotateSunyshoreGymGear {vals[0]}: the gears turn '
            f'(sunyshore_gym_itcm.c)']


@handler('GetLeagueVictories')
def h_league_victories(tr, a, vals, name):
    """Pearl 0x28F (the Hall of Fame room: Rowan's and Cynthia's first-time lines when 0; Fight Area Barry's team at
    20 wins): Pearl counts the player's League wins in its save. Black 2's record of Hall of Fame entries
    (RECORD_HALL_OF_FAME_ENTRIES 71, counted by its game clear: ov295 game_clear_save.c) is the same count, 0 the
    first time (2026-10-26, the lead: not the game-clear flag, whose 0/1 breaks Barry's 20)."""
    tr.job.approx['GetLeagueVictories (Black 2\'s Hall of Fame entries record)'] += 1
    return [f'pl_GetLeagueVictories {tr.var(vals[0])}']


@handler('PlayHallOfFameHealingAnimation')
def h_hof_heal(tr, a, vals, name):
    """Pearl 0x25A (the Hall of Fame machine: the party's balls on it and the healing tune). Black 2's machine event
    (EventDendouMachine) needs Black 2's own Hall of Fame props, and its Pokémon Center heal needs a Center machine
    prop (a data abort without one: the heal fix, 2026-10-25), so: the healing tune only (SEQ_ME_ASA, the Center's)."""
    tr.job.approx['PlayHallOfFameHealingAnimation (the healing tune only: no machine animation)'] += 1
    return [f'pl_PlayHallOfFameHealingAnimation  // Pearl 0x25A {tr.var(vals[0])}: the healing tune']


@handler('IncrementGameRecord')
def h_game_record(tr, a, vals, name):
    """Pearl 0x1E5 IncrementGameStat n (its save's records: the Hall of Fame room's 46, times entered; Black 2's game
    clear counts its own): nothing, as IncrementTrainerScore2 (2026-10-26, chapter 8)."""
    tr.job.approx['IncrementGameRecord (Black 2 keeps its own records)'] += 1
    return [f'// IncrementGameRecord {vals[0]}: nothing in Black 2 (its own records)']


@handler('ClearGame')
def h_clear_game(tr, a, vals, name):
    """Pearl 0xB0 ShowEndGameScreen (pokeplatinum ClearGame: the game-clear flag, the Hall of Fame record, the save,
    the credits, a reset). Black 2's own Hall of Fame ending, exactly as its script does it (pokemon_league_10.s:
    FadeOutBlackQ, FadeWait, CallGameClear 0 the first time / 1 after, FinishAllEvents, ActorsUnpauseAll: HoennB2's
    black screen came from ending another way, 2fd355b), PearlB2's game clear in the decomp's event_game_clear.c
    (Pearl's start room on Continue: global 9601, src/field_scripts/1242_global_9600.s). Nothing after it runs (Pearl
    resets there too). 2026-10-26, chapter 8."""
    tr.job.approx['ClearGame (Black 2\'s game clear: record, save, credits, THE END)'] += 1
    return ['pl_ClearGame  // Pearl ShowEndGameScreen: Black 2\'s Hall of Fame record, save, credits (ends the script)']


@handler('InitPersistedMapFeaturesForHearthomeGym', 'MoveHearthomeGymDPLift')
def h_hearthome_lift(tr, a, vals, name):
    """Pearl's Hearthome Gym lift (0x171 InitHearthomeGym in the four question rooms' zone scripts, 0x172
    MoveHearthomeGymElevator on their step trigger (9, 13); 2026-10-26, the ch5b agent): gimmick 59's platform lift
    (pearl_gimmicks.HEARTHOME_LIFTS), which places it by the player's floor (the first room's up and still until flag
    0x98D, as Pearl's) and rides it on the step, so the scripts have nothing to do."""
    return h_platforms(tr, a, vals, name)


@handler('GiveEgg')
def h_give_egg(tr, a, vals, name):
    """Pearl 0x97 GiveEgg species, place (pokediamond: an Egg from a gift; Riley's Riolu at Iron Island) = Black 2's
    PokePartyAddEgg (its own met place for a gift Egg; the script checks the party's room first, as Pearl's)."""
    tr.job.approx['GiveEgg (Black 2 writes its own met place)'] += 1
    return [f'PokePartyAddEgg PL_TMP, {tr.var(vals[0])}, 0  // GiveEgg {vals[0]}, {vals[1]}']


# ---- the post-game's events built in (2026-10-26, chapter 9a; user 2026-10-25: "make it so all the events like
# darkrai shaymin etc are built into the base game already", "arceus too"; DECISIONS 2026-10-25)
# Pearl's Mystery Gift deliveryman (globals 10200 on load / 10201 talk, file 373, in every Pokémart) gives Pearl's four
# event gifts after the Hall of Fame, one a talk, in the user's order; PVAR_DELIVERY counts the ones given
# (pearl_story.inc "the deliveryman"). Pearl's lines for each are its own (bank 332).
DELIVERY_BANK = 332
DELIVERY_LINES = (14, 15, 16, 13)     # "received a Member's Card", "Oak's Letter", "an Azure Flute", "the MANAPHY Egg"
DELIVERY_PARTY_FULL = 4               # "Your party is full, I'm afraid. I can't give this to you yet."


@handler('MysteryGiftGive')
def h_mystery_gift(tr, a, vals, name):
    """Pearl 0x23E MysteryGiftGive sub, ... (pokeplatinum scrcmd_mystery_gift.c, the same subcommands in Pearl: 0 load,
    1 a gift waiting? (var), 2 its type (var), 3 can it be received? (var), 4 give it, 5 / 6 the received / can't-receive
    line (bank var, line var: MessageFromBank shows it), 7 / 8 unload). Pearl's distribution events (the Member Card,
    Oak's Letter, the Azure Flute, the Manaphy Egg) are built in here, given by the same man with the same lines."""
    sub = vals[0]
    if sub in (0, 7, 8):
        return [f'// MysteryGiftGive {sub}: nothing to load or unload (the gifts are built in)']
    if sub == 1:
        return [f'pl_DeliveryWaiting {tr.var(vals[1])}  // MysteryGiftGive 1: a gift waiting?']
    if sub == 3:
        return [f'pl_DeliveryCanReceive {tr.var(vals[1])}  // MysteryGiftGive 3: can it be received?']
    if sub == 4:
        return ['pl_DeliveryGive  // MysteryGiftGive 4: the next gift']
    if sub == 5:
        return ['pl_BufferPlayerName 0  // MysteryGiftGive 5: the received line (MessageFromBank shows it)']
    if sub == 6:
        return ['// MysteryGiftGive 6: the can\'t-receive line (MessageFromBank shows it)']
    tr.job.stubs[f'{name} {sub}'] += 1
    return [f'pl_stub {name}  // MysteryGiftGive {", ".join(map(str, vals))}']


def delivery_message(tr, a, name):
    """The deliveryman's MessageFromBank after MysteryGiftGive 5 / 6 in the same block: Pearl's own line for the gift
    PVAR_DELIVERY points at (DELIVERY_LINES), or the full party's; None for any other MessageFromBank."""
    if name != 'MessageFromBank':
        return None
    got, cant = (same_block_before(tr, a, 'MysteryGiftGive', s) for s in (5, 6))
    if got is None and cant is None:
        return None
    kind, uid = speaker(tr, a, -1)
    out = switch_window(tr, kind, uid)

    def msg(n):
        m = tr.job.line_for(DELIVERY_BANK, n)
        return (f'pl_msg_actor {m}, {uid}' if kind == 'actor' else f'pl_msg_{kind} {m}') + \
            f'  // Pearl bank {DELIVERY_BANK} line {n}'
    if got is None:
        return out + [msg(DELIVERY_PARTY_FULL) + ' (only the Egg can be refused: the key items always fit)']
    for i, n in enumerate(DELIVERY_LINES[:-1]):
        out += [f'WorkCmpConst PVAR_DELIVERY, {i}', f'VMJumpIf CMP_NE, .Ldm{a:x}_{i}', msg(n),
                f'VMJump .Ldm{a:x}_end', f'.Ldm{a:x}_{i}:']
    return out + [msg(DELIVERY_LINES[-1]), f'.Ldm{a:x}_end:']


@handler('CheckDistributionEvent')
def h_distribution_event(tr, a, vals, name):
    """Pearl 0x28B CheckDistributionEvent event, var (pokeplatinum SystemVars_CheckDistributionEvent: Mystery Gift wrote a
    magic number when the event's item came: 0 Darkrai's Member Card, 1 Shaymin's Oak's Letter, 2 Arceus's Azure
    Flute). Built in: the deliveryman gave that item (PVAR_DELIVERY past its place in DELIVERY_LINES' order)."""
    return [f'pl_CheckDistributionEvent {vals[0]}, {tr.var(vals[1])}  // CheckDistributionEvent {vals[0]}: its item '
            f'came from the deliveryman']


@handler('SetHiddenLocation')
def h_hidden_location(tr, a, vals, name):
    """Pearl SetHiddenLocation place, 1 (pokeplatinum SystemVars_SetHiddenLocationMagic: 0 Fullmoon Island, 1 Newmoon
    Island, 2 Spring Path, 3 Seabreak Path). Pearl's map loader swaps matrix cells for a revealed place (pokediamond
    map_matrix.c sub_02034678 hides the Spring Path until it is set; sub_020346CC opens Route 224 to the Seabreak Path
    once it is): Black 2's map replacement does the same (patches/pearl_paths.py: a/0/1/0 entries on events
    PL_HIDDEN_EVENT_*, set here). The Town Map's hidden places (0, 1, and these on the map) are the Town Map's."""
    place = vals[0]
    if place in (2, 3):
        return [f'pl_SetHiddenLocation {place}  // SetHiddenLocation {place}: Black 2\'s map replacement']
    tr.job.approx['SetHiddenLocation 0/1 (Fullmoon / Newmoon Island on the Town Map: not drawn yet)'] += 1
    return [f'// SetHiddenLocation {", ".join(map(str, vals))}: the Town Map\'s hidden island (not drawn yet)']


@handler('CheckHasAllLegendaryTitansInParty')
def h_check_regis(tr, a, vals, name):
    """Pearl 0x26B (Snowpoint Temple B5F's statue: pokediamond CheckRegis = Regirock, Regice and Registeel in the
    party) = three of Black 2's PokePartyFindBySpecies."""
    return [f'pl_CheckHasAllLegendaryTitansInParty {tr.var(vals[0])}  // CheckRegis: Regirock, Regice, Registeel']


@handler('ShakeObject')
def h_shake_object(tr, a, vals, name):
    """Pearl 0x269 ShakeEvent object, ... (Snowpoint Temple B5F: Regigigas's statue shakes before it wakes). Black 2 has
    no command that shakes one person: the statue stays still (the cry and the battle follow as Pearl's)."""
    tr.job.approx['ShakeObject (Black 2 cannot shake one person: Regigigas\'s statue stays still)'] += 1
    return [f'// ShakeObject {", ".join(map(str, vals))}: nothing in Black 2 (no one-person shake)']


@handler('OpenShayminTabletNamingScreen')
def h_tablet_naming(tr, a, vals, name):
    """Pearl 0x271 WriteWhiteRockInscription var (Route 224's stone tablet: the name of the one the player thanks,
    typed on the naming screen; var 1 = nothing written). Black 2's word-set name input (CallWordSetPokeNameInput, as
    its Funfest quiz: the text into word buffer 1, which Pearl's next line reads, BufferTabletName 1), with the player's
    starter as the screen's icon. Black 2 has no save string for the inscription: the tablet's later line
    (BufferTabletName after the event) shows the player's name (pl_BufferTabletName)."""
    tr.job.approx['OpenShayminTabletNamingScreen (Black 2\'s name input; the inscription is not kept)'] += 1
    return [f'pl_OpenShayminTabletNamingScreen {tr.var(vals[0])}  // WriteWhiteRockInscription']


@handler('BufferTabletName')
def h_tablet_name(tr, a, vals, name):
    """Pearl 0x272 GetWhiteRockInscription buffer: right after the naming screen the typed name is already in word
    buffer 1 (pl_OpenShayminTabletNamingScreen); later (the tablet read after the event) Black 2 has no kept
    inscription: the player's name (h_tablet_naming)."""
    after_input = any(tr.job.pd.cmd_name(op) == 'OpenShayminTabletNamingScreen'     # (a few commands before)
                      for p, (e, op, args) in tr.d.insns.items() if 0 < a - p < 0x30)
    if after_input:
        return [f'// BufferTabletName {vals[0]}: the typed name is in word buffer 1 already']
    tr.job.approx['BufferTabletName (no kept inscription: the player\'s name)'] += 1
    return [f'pl_BufferPlayerName {vals[0]}  // BufferTabletName: no kept inscription in Black 2 (the player\'s name)']


@handler('FadeInBGM')
def h_fade_in_bgm(tr, a, vals, name):
    """Pearl 0x55 FadeInBgm frames (Route 224's Shaymin scene: the music faded out by FadeOutBGM comes back). Black 2's
    BGMFadeOut stops it: the zone's music again (BGMChangeMap)."""
    tr.job.approx['FadeInBGM (the zone\'s music again, no fade)'] += 1
    return [f'pl_PlayDefaultMusic  // FadeInBGM {vals[0]}: the zone\'s music again']


@handler('29F')
def h_shake(tr, a, vals, name):
    """Pearl 0x29F ShakeCamera kind (pokediamond: 0 a short shake, 1 the long one; the tremor of Lake Valor's explosion
    in the Canalave Library) = Black 2's event camera shake with its rumble, as its own quake scenes (global 10470)."""
    if vals[0] >= 0x4000:
        tr.job.stubs['ShakeCamera (the kind from a var)'] += 1
        return [f'pl_stub ShakeCamera  // {tr.var(vals[0])}']
    cam = getattr(tr, 'cam', None)
    if cam is None:
        return [f'pl_ShakeCamera {vals[0]}  // Pearl ShakeCamera {vals[0]}']
    # Black 2's shake shakes around the camera's bound target and binds it back after (ov036 FieldCameraShakeTask):
    # with the free camera unbound there is none, and the view jumped to the map's corner (the Canalave Library's
    # tremor, found in game 2026-10-25). So the view goes back to the player for the shake, then the free camera is
    # set up again where it was.
    return ['EvCameraReturn 1  // (the free camera ends for the shake: Black 2 shakes the bound camera)', 'EvCameraWait',
            'EvCameraRebind', 'EvCameraEnd', f'pl_ShakeCamera {vals[0]}  // Pearl ShakeCamera {vals[0]}',
            f'EvCameraInit  // the free camera again at ({cam[0]}, {cam[1]})', 'EvCameraUnbind',
            f'EvCameraMoveTo {CAM_ANGLE}, {cam_point(tr, cam[0], cam[1])}, 1', 'EvCameraWait']


@handler('2B6')
def h_obj_flag18(tr, a, vals, name):
    """Pearl 0x2B6 object, clear (pokediamond MapObject_ClearFlag18 on the object: after Riley's Egg, Riley's flag 18,
    a map-object state flag of Pearl's own) has nothing to do in Black 2."""
    tr.job.approx['2B6 (Pearl\'s map-object flag 18: nothing in Black 2)'] += 1
    return [f'// Pearl 0x2B6 {vals[0]}, {vals[1]}: Pearl\'s map-object flag 18, nothing in Black 2']


# ---- the briefcase (Black 2's three-ball screen, overlay 316: patches/pearl_starters.py shows Turtwig, Chimchar,
# Piplup left to right = Pearl's index 0/1/2) and the first battle
@handler('StartChooseStarterScene')
def h_starter(tr, a, vals, name):
    return ['pl_StartChooseStarterScene']


@handler('SaveChosenStarter')
def h_starter_save(tr, a, vals, name):
    return ['pl_SaveChosenStarter']


@handler('ReturnToField')
def h_return_field(tr, a, vals, name):
    if a in poke_select_fades(tr):
        return ['// RestoreOverworld: Black 2\'s party select reopened the field itself']
    if getattr(tr, 'after_region_map', False):            # (h_region_map)
        tr.after_region_map = False
        return ['// RestoreOverworld: Black 2\'s CallPlaceSelect reopened the field itself']
    tr.after_starter = True
    return ['pl_ReturnToField']


# ---- the party select (Pearl ChoosePokemonMenu + GetSelectedPartySlot, 2026-10-25 chapter 4b: the Veilstone massage
# girl, the Jubilife TV gallery, the Eterna condominiums' nickname checker, ...). Pearl always writes it as FadeScreen
# out, WaitFadeScreen, ChoosePokemonMenu (pokediamond ScrCmd_ChoosePokemonMenu: the party menu app), GetSelectedPartySlot
# var (the slot, 0xFF when cancelled), RestoreOverworld, FadeScreen in, WaitFadeScreen. Black 2's CallPokeSelect does
# the whole round trip itself (ov020 EventPokeSelect_Callback: fade out, field closed, the list, field reopened, fade
# in), so Pearl's fades and RestoreOverworld around it are dropped (a FieldOpen on an open field, a white fade-in on a
# shown field).
def poke_select_fades(tr):
    """Addresses of the FadeScreens and the RestoreOverworld of Pearl's party-select pattern in this file."""
    if getattr(tr, '_psel', None) is None:
        d, pd = tr.d, tr.job.pd
        tr._psel = set()
        nxt = {a: e for a, (e, op, args) in d.insns.items()}
        prv = {e: a for a, e in nxt.items()}
        name = lambda x: pd.cmd_name(d.insns[x][1]) if x in d.insns else None
        for c, (e, op, args) in d.insns.items():
            if name(c) != 'SelectMoveTutorPokemon':
                continue
            w0 = prv.get(c)
            f0 = prv.get(w0)
            g = nxt.get(c)
            r = nxt.get(g)
            f1 = nxt.get(r)
            if (name(w0), name(f0), name(g), name(r), name(f1)) == ('WaitFadeScreen', 'FadeScreen', 'GetSelectedPartySlot',
                                                                  'ReturnToField', 'FadeScreen'):
                tr._psel |= {f0, r, f1}
        # the Day-Care Lady's (file 464): FadeScreen, WaitFadeScreen, SetVar, then a loop of OpenPartyMenuForDaycare /
        # GetDayCarePartyMenuResult (and the summary), then RestoreOverworld, ShowMoneyBox, FadeScreen
        for c, (e, op, args) in d.insns.items():
            if name(c) != 'OpenPartyMenuForDaycare':
                continue
            f0 = c
            for _ in range(4):
                f0 = prv.get(f0)
                if name(f0) == 'FadeScreen':
                    break
            r = c
            for _ in range(10):
                r = nxt.get(r)
                if name(r) == 'ReturnToField':
                    break
            f1 = r
            for _ in range(3):
                f1 = nxt.get(f1)
                if name(f1) == 'FadeScreen':
                    break
            if (name(f0), name(r), name(f1)) == ('FadeScreen', 'ReturnToField', 'FadeScreen'):
                tr._psel |= {f0, r, f1}
        # a move tutor's (2026-10-26, chapter 5b: Grandma Wilma; Route 228's): FadeScreen, WaitFadeScreen,
        # OpenMoveTutorMenu, CheckLearnedTutorMove, RestoreOverworld, FadeScreen (pl_OpenMoveTutorMenu stays on the
        # field and Black 2's forget-a-move screen fades and reopens it itself)
        for c, (e, op, args) in d.insns.items():
            if name(c) != 'OpenMoveTutorMenu':
                continue
            w0, k = prv.get(c), nxt.get(c)
            f0, r = prv.get(w0), nxt.get(k)
            f1 = nxt.get(r)
            if (name(f0), name(w0), name(k), name(r), name(f1)) == ('FadeScreen', 'WaitFadeScreen',
                                                                  'CheckLearnedTutorMove', 'ReturnToField',
                                                                  'FadeScreen'):
                tr._psel |= {f0, r, f1}
    return tr._psel


# ---- move tutors (2026-10-26, chapter 5b: Grandma Wilma's Draco Meteor, Route 210 N; Route 228's ultimate moves use
# the same commands): pearl_story.inc "move tutors"
TUTOR_BANK = 586        # Pearl's Move Reminder / tutor app's lines (the app Pearl's OpenMoveTutorMenu opens)
TUTOR_LINES = (1, 2, 3, 4, 5, 6, 7, 8)   # teach? / give up? / learned / trying (four moves) / poof / learned / stop? /
                                         # did not learn


@handler('GetPartyMonType')
def h_party_types(tr, a, vals, name):
    """Pearl 0x248 GetPartyMonTypes type1, type2, slot = Black 2's PokePartyGetTypes, the types numbered as Gen 4's."""
    return [f'pl_GetPartyMonTypes {tr.var(vals[0])}, {tr.var(vals[1])}, {tr.var(vals[2])}']


@handler('CheckPartyMonHasMove')
def h_party_has_move(tr, a, vals, name):
    """Pearl 0x099 PartyMonHasMove result, move, slot (1 when that party Pokémon knows the move) = Black 2's
    PokePartyHasMove (the same order and answer; an Egg answers 0 in both)."""
    return [f'PokePartyHasMove {tr.var(vals[0])}, {tr.var(vals[1])}, {tr.var(vals[2])}  // PartyMonHasMove']


@handler('OpenMoveTutorMenu')
def h_move_tutor(tr, a, vals, name):
    """Pearl 0x224 OpenMoveTutorMenu slot, move: the tutor app's choices on the field with its own lines (Pearl bank
    586), Black 2's forget-a-move screen for a Pokémon with four moves (pl_OpenMoveTutorMenu)."""
    lines = [tr.job.line_for(TUTOR_BANK, n) for n in TUTOR_LINES]
    tr.job.approx['OpenMoveTutorMenu (the tutor app\'s lines on the field; Black 2\'s forget-a-move screen)'] += 1
    return [f'pl_OpenMoveTutorMenu {tr.var(vals[0])}, {tr.var(vals[1])}, {", ".join(map(str, lines))}']


@handler('CheckLearnedTutorMove')
def h_move_tutor_result(tr, a, vals, name):
    """Pearl 0x225 CheckLearnedTutorMove var: 0 learned, 0xFF not (pl_OpenMoveTutorMenu's answer)."""
    return [f'pl_CheckLearnedTutorMove {tr.var(vals[0])}']


@handler('SelectMoveTutorPokemon')
def h_choose_pokemon(tr, a, vals, name):
    return ['pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2\'s party select (CallPokeSelect)']


def keep_stub(tr, a, vals, name):
    """The plain stub line (FileTr.translate's) for a command whose handler covers only some uses."""
    op = tr.d.insns[a][1]
    tr.job.stubs[name] += 1
    return [f'pl_stub {name}  // Pearl 0x{op:03X} {tr.job.pd.table[op]["name"]} {", ".join(map(str, vals))}: '
            f'not translated yet']


@handler('GetSelectedPartySlot')
def h_selected_slot(tr, a, vals, name):
    prev = next((x for x, (e, op, args) in tr.d.insns.items() if e == a), None)
    if prev is None or tr.job.pd.cmd_name(tr.d.insns[prev][1]) != 'SelectMoveTutorPokemon':
        return keep_stub(tr, a, vals, name)     # after another party app (OpenTradeScreen: NPC trades, not built)
    return [f'pl_GetSelectedPartySlot {tr.var(vals[0])}  // the slot, 255 when cancelled (as Pearl)']


# ---- the Day Care (2026-10-25, chapter 4b): Pearl's Day-Care Man and Lady (global scripts 9500 / 9501 = file 464) on
# Black 2's Day Care commands with Pearl's lines: macros in pearl_story.inc ("the Day Care"). The party-menu commands
# CountAliveMonsExcept, SetMonSummary and GetMonPartySlot are translated in the Day Care's file only (the Jubilife TV
# and the Contest Hall use them in other ways).
DAYCARE_FILE = 464


@handler('BufferDaycareMonNicknames', 'ResetDaycarePersonalityAndStepCounter', 'GiveEggFromDaycare')
def h_daycare0(tr, a, vals, name):
    return {'BufferDaycareMonNicknames': ['pl_BufferDaycareMonNicknames  // GetDaycarePokemonNames'],
            'ResetDaycarePersonalityAndStepCounter': ['DayCareResetSeed  // DeleteDaycareEgg: the Egg is not taken'],
            'GiveEggFromDaycare': ['DayCareBreed  // GiveDaycareEgg: the Egg into the party']}[name]


@handler('GetDaycareState', 'CheckDaycareHasEgg', 'GetDaycareCompatibilityLevel', 'CountAliveMonsAndBoxMons',
         'OpenPartyMenuForDaycare', 'StorePartyMonIntoDaycare')
def h_daycare1(tr, a, vals, name):
    if name == 'CheckDaycareHasEgg' and 2 in tr.levels(a):
        # Solaceon's zone init turns the Day-Care Man when an Egg waits; Black 2's Day Care commands are not allowed
        # there (EVCMD_PERM_TABLE), its own egg work is: 0x417F = 1 from the step an Egg appears (with room in the
        # party) until it is taken or declined (ov036 sodateya.c setPartyHasSpaceToConst)
        return [f'WorkSet {tr.var(vals[0])}, 0x417F  // Unk01BF (an Egg waits) in the zone init: Black 2\'s egg work']
    return [f'pl_{name} {tr.var(vals[0])}']


@handler('BufferDaycareGainedLevelsBySlot', 'BufferDaycarePriceBySlot', 'MoveMonToPartyFromDaycareSlot',
         'GetDayCarePartyMenuResult')
def h_daycare2(tr, a, vals, name):
    return [f'pl_{name} {tr.var(vals[0])}, {tr.var(vals[1])}']


@handler('BufferPartyMonNicknameReturnSpecies')
def h_daycare_nick(tr, a, vals, name):
    return [f'pl_BufferPartyMonNicknameReturnSpecies {tr.var(vals[1])}, {tr.var(vals[2])}  // (Pearl\'s first '
            f'argument {vals[0]} is unused)']


@handler('BufferDaycareNicknameLevelGender')
def h_daycare_menu_line(tr, a, vals, name):
    """Pearl buffers the nickname, the level and the gender symbol (a string in buffer vals[2]) for the next menu
    line; Black 2 has no gender-symbol word, so the gender goes into PL_DC_SEX and h_menu_add picks the line's copy with
    the symbol written in (as Black 2's own Day Care menu lines 34-36)."""
    tr.dc_sex_buf = vals[2]
    return [f'pl_BufferDaycareNicknameLevelGender {tr.var(vals[0])}, {tr.var(vals[1])}, {tr.var(vals[3])}']


@handler('SetMonSummary', 'GetMonPartySlot')       # (CountAliveMonsExcept: h_count_alive_except)
def h_daycare_party(tr, a, vals, name):
    if tr.f != DAYCARE_FILE:
        return keep_stub(tr, a, vals, name)
    return [f'// {name} {tr.var(vals[0])}: Black 2\'s Day Care list shows the summary itself (never reached: '
            f'GetDayCarePartyMenuResult gives 0)']


@handler('IncreasePartyMonFriendship')
def h_add_friendship(tr, a, vals, name):
    """Pearl AddPartyMonFriendship amount, slot (0x1BA; pokediamond scrcmd_party.c: plus the Soothe Bell, Luxury Ball
    and home-town bonuses) = Black 2's PokePartyAdjustHappiness slot, amount, 1 (add, capped at 255) without Pearl's
    bonuses (2026-10-25, chapter 4b: the Veilstone massage girl)."""
    tr.job.approx['IncreasePartyMonFriendship (Black 2\'s plain add: no Soothe Bell / Luxury Ball bonus)'] += 1
    return [f'PokePartyAdjustHappiness {tr.var(vals[1])}, {tr.var(vals[0])}, 1  // AddPartyMonFriendship']


@handler('TryGetRandomMassageGirlAccessory')
def h_massage_accessory(tr, a, vals, name):
    """Pearl Unk026C var: a random Contest Accessory the massage girl finds, or 0xFFFF; no Super Contests here
    (DECISIONS 2026-10-18: closed), so never one: her "found an Accessory" line would give nothing."""
    tr.job.approx['TryGetRandomMassageGirlAccessory (no Accessory: no Super Contests)'] += 1
    return [f'WorkSetConst {tr.var(vals[0])}, 65535  // Unk026C: no Accessory (no Super Contests)']


@handler('GetPartyMonNature')
def h_mon_nature(tr, a, vals, name):
    """Pearl GetPartyMonNature result, slot (0x212) = Black 2's PokePartyGetParam result, slot, PKM_PARAM_NATURE (0x70):
    the same 25 natures (2026-10-25, chapter 4b: Solaceon's nature man)."""
    return [f'PokePartyGetParam {tr.var(vals[0])}, {tr.var(vals[1])}, 0x70  // GetPartyMonNature']


@handler('BufferNatureName')
def h_nature_name(tr, a, vals, name):
    return [f'WordSetLoadNature {vals[0]}, {tr.var(vals[1])}  // GetNatureName']


@handler('CheckIsDepartmentStoreRegular')
def h_dept_regular(tr, a, vals, name):
    """Pearl Unk027E (0x27E): 1 once the player has shopped at the Veilstone Department Store 5 times (a counter in
    Pearl's save); Black 2 keeps no such count: never a regular."""
    tr.job.approx['CheckIsDepartmentStoreRegular (never: Black 2 counts no Department Store visits)'] += 1
    return [f'WorkSetConst {tr.var(vals[0])}, 0  // Unk027E: the Department Store\'s regulars (not counted here)']


@handler('GetRandomSeenSpecies')
def h_news_species(tr, a, vals, name):
    """Pearl Unk0218 var (the News Press assignment): a random seen species (pearl_story.inc pl_GetRandomSeenSpecies;
    2026-10-25, chapter 4b)."""
    return [f'pl_GetRandomSeenSpecies {tr.var(vals[0])}  // Unk0218']


@handler('SetNewsPressDeadline')
def h_news_set(tr, a, vals, name):
    """Pearl Unk0219 days: the assignment's deadline in days (Pearl gives 1: today). Here PFLAG_NEWS_PRESS_TODAY,
    which Black 2 clears at midnight (data/pearl_story_ids.json new_flags)."""
    if vals[0] >= 0x4000:
        return keep_stub(tr, a, vals, name)
    return [f'{"FlagSet" if vals[0] else "FlagReset"} PFLAG_NEWS_PRESS_TODAY  // Unk0219 {vals[0]}: the deadline '
            f'is today']


@handler('GetNewsPressDeadline')
def h_news_get(tr, a, vals, name):
    return [f'FlagGet PFLAG_NEWS_PRESS_TODAY, {tr.var(vals[0])}  // Unk021A: days left (1 today, 0 after midnight)']


@handler('CheckMoney2')
def h_check_money_var(tr, a, vals, name):
    return [f'MoneyCheck {tr.var(vals[0])}, {tr.var(vals[1])}  // HasEnoughMoneyAddress (an amount in a var)']


@handler('RemoveMoney2')
def h_remove_money_var(tr, a, vals, name):
    return [f'MoneySub {tr.var(vals[0])}  // TakeMoneyAddress (an amount in a var)']


@handler('StartFirstBattle')
def h_first_battle(tr, a, vals, name):
    tr.job.approx['StartFirstBattle (a wild battle; a loss heals and the scene goes on: no first-battle rules in '
                  'Black 2)'] += 1
    return [f'pl_StartFirstBattle {tr.var(vals[0])}, {tr.var(vals[1])}']


# ---- battles
@handler('StartCatchingTutorial')
def h_catch_tutorial(tr, a, vals, name):
    tr.job.approx['StartCatchingTutorial (Black 2\'s capture demo with Pearl\'s Pokémon, moves and lines: '
                  'patches/capture_demo.py; its fixed HP changes)'] += 1
    return ['pl_StartCatchingTutorial']


@handler('StartWildBattle')
def h_wild(tr, a, vals, name):
    tr.last_battle = 'wild'
    return end_free_camera(tr, 'a battle', a) + [f'pl_StartWildBattle {tr.var(vals[0])}, {tr.var(vals[1])}']


def insn_before(tr, a):
    """The name of the command just before a in its basic block (none when a is a label, an entry or a jump target)."""
    d = tr.d
    if getattr(tr, '_blocks', None) is None:
        same_block_before(tr, a, '', 0, limit=0)          # (builds tr._blocks)
    ends, targets = tr._blocks
    p = None if a in targets else ends.get(a)
    return None if p is None else tr.job.pd.cmd_name(d.insns[p][1])


def file_partner(tr):
    """The partner trainer this file sets Pearl's partner var 0x403F to (one known trainer), or None."""
    known = tr.job.ids.reg['trainers']
    vals = {args[1][1] for e, op, args in tr.d.insns.values()
            if tr.job.pd.cmd_name(op) == 'SetVarFromValue' and args[0][1] == PARTNER_VAR and args[1][0] != 'var'}
    vals = [v for v in vals if v < 0x4000 and str(v) in known]
    return vals[0] if len(vals) == 1 else None


@handler('StartTrainerBattle')
def h_trainer(tr, a, vals, name):
    tr.last_battle = 'trainer'
    if insn_before(tr, a) == 'SetHasPartner' and file_partner(tr) is not None:
        # Pearl's StartTrainerBattle with its "has partner" flag on is a battle at the partner's side against the two
        # (pokediamond ScrCmd_Unk00E5: the partner from var 0x403F): Iron Island's grunts with Riley (2026-10-25, ch6a)
        return [f'pl_StartTagBattle {tr.job.ids.trainer(file_partner(tr))}, {trainer(tr, vals[0])}, '
                f'{trainer(tr, vals[1])}  // StartTrainerBattle with the partner (SetHasPartner, var 0x403F)']
    return end_free_camera(tr, 'a battle', a) + [f'pl_StartTrainerBattle {trainer(tr, vals[0])}, {trainer(tr, vals[1])}']


def tag_partner_values(tr, a, var):
    """The values SetVarFromValue gives var on the way to a: in a's basic block and the subroutines it Calls before a
    (Jubilife: `Call` of the starter check that sets 0x8004 = 613-618), else anywhere in the file (0x8004 also holds
    items and other numbers elsewhere)."""
    d, pd = tr.d, tr.job.pd
    ends = {e: s for s, (e, op, args) in d.insns.items()}
    targets = {t for s, (e, op, args) in d.insns.items() for ty, t in args if ty == 'rel'}
    found, subs, b = set(), [], a
    for _ in range(16):
        p = None if b in targets else ends.get(b)
        if p is None:
            break
        e, op, args = d.insns[p]
        n = pd.cmd_name(op)
        if n == 'SetVarFromValue' and args[0][1] == var:
            found.add(args[1][1])
            break
        if n == 'Call':
            subs.append(args[0][1])
        b = p
    seen = set()
    while subs:
        s = subs.pop()
        if s in seen or s not in d.insns:
            continue
        seen.add(s)
        e, op, args = d.insns[s]
        if pd.cmd_name(op) == 'SetVarFromValue' and args[0][1] == var:
            found.add(args[1][1])
        subs += [t for ty, t in args if ty == 'rel']
        if pd.table[op]['flow'] not in ('end', 'jump', 'return'):
            subs.append(e)
    if found:
        return found
    return {args[1][1] for e, op, args in d.insns.values() if pd.cmd_name(op) == 'SetVarFromValue' and args[0][1] == var}


@handler('StartTagBattle')
def h_tag_battle(tr, a, vals, name):
    """Pearl 0x2A0 (pokediamond ScrCmd_Unk02A0: partner, opponent 1, opponent 2): you and a partner against two
    trainers (Jubilife after the Coal Badge: the counterpart against two Galactic grunts) = Black 2's
    CallTrainerMultiBattle partner, opponent 1, opponent 2 (as its Lacunosa scene). Pearl picks the partner by the
    starter in a var (0x8004 = 613-618): the var holds Pearl's trainer number, so the battle is a chain over the
    trainer numbers this file sets that var to (the last one without a check)."""
    tr.last_battle = 'trainer'
    partner, t1, t2 = vals
    o1, o2 = trainer(tr, t1), trainer(tr, t2)
    if partner < 0x4000:
        return end_free_camera(tr, 'a battle', a) + [f'pl_StartTagBattle {trainer(tr, partner)}, {o1}, {o2}']
    known = tr.job.ids.reg['trainers']
    values = sorted(v for v in tag_partner_values(tr, a, partner) if str(v) in known)
    if not values:
        tr.job.stubs['StartTagBattle (a partner from a var this file never sets)'] += 1
        return [f'pl_stub StartTagBattle  // partner {tr.var(partner)}: no trainer number set in this file']
    out = end_free_camera(tr, 'a battle', a) + \
        [f'// StartTagBattle {tr.var(partner)}, {t1}, {t2}: the partner by Pearl\'s trainer number in the var']
    for v in values[:-1]:
        out += [f'WorkCmpConst {tr.var(partner)}, {v}', f'VMJumpIf CMP_NE, .Ltag{a:x}_{v}',
                f'pl_StartTagBattle {trainer(tr, v)}, {o1}, {o2}', f'VMJump .Ltag{a:x}_end', f'.Ltag{a:x}_{v}:']
    return out + [f'pl_StartTagBattle {trainer(tr, values[-1])}, {o1}, {o2}', f'.Ltag{a:x}_end:']


@handler('PlayTrainerEncounterBGM')
def h_trainer_bgm(tr, a, vals, name):
    # Pearl 0xEA (pokediamond ScrCmd_Unk00EA: the trainer's class encounter music, sub_0204AD0C): Black 2's
    # TrainerBGMPlay, whose class song the decomp's PearlB2_EyeBGM gives (patches/battle_music.py: Pearl's with Sinnoh's
    # music); the Elite Four's and Cynthia's rooms
    return [f'pl_PlayTrainerEncounterBGM {trainer(tr, vals[0])}']


@handler('CheckWonBattle')
def h_won(tr, a, vals, name):
    return [f'pl_CheckWon{"Wild" if tr.last_battle == "wild" else ""}Battle {tr.var(vals[0])}']


@handler('BlackOutFromBattle')
def h_blackout(tr, a, vals, name):
    return [f'pl_BlackOutFrom{"Wild" if tr.last_battle == "wild" else ""}Battle']


# Pearl's 0xED (pokediamond ScrCmd_Unk00ED -> sub_020480C8): 0 if the battle was won or the Pokémon caught, else 1 (the
# player fled, a draw). Its 5 uses follow legendary battles (Valor/Acuity Cavern: a knocked-out Azelf/Uxie is gone for
# good; one the player ran from "disappeared deep into the cavern" and comes back). Pearl's 0x2BC (sub_020480D8: 0 only
# if caught) is pl_CheckDidNotCapture (Chapter 7, Palkia). (2026-10-26, ch6b, from the Chapter 7 agent's reading)
@handler('CheckLostBattle')
def h_lost_battle(tr, a, vals, name):
    return [f'pl_CheckLostBattle {tr.var(vals[0])}']



# ---- doors
@handler('LoadDoorAnimation')
def h_door_load(tr, a, vals, name):
    cx, cz, tx, tz, tag = vals
    out = []
    coords = []
    for c, t, w in ((cx, tx, 'PL_TMP'), (cz, tz, 'PL_TMP2')):
        if t < 0x4000:
            coords.append(str(c * 32 + t))
        else:                                   # a var tile: cell * 32 + the var, in a scratch work
            out += [f'WorkSetConst {w}, {c * 32}', f'WorkAdd {w}, {tr.var(t)}']
            coords.append(w)
    return out + [f'pl_LoadDoorAnimation {tag}, {coords[0]}, {coords[1]}  // the door at cell ({cx},{cz}) tile '
                  f'({tr.var(tx)},{tr.var(tz)})']


@handler('PlayDoorOpenAnimation', 'PlayDoorCloseAnimation', 'WaitForAnimation', 'UnloadAnimation')
def h_door(tr, a, vals, name):
    return [f'pl_{name} {vals[0]}']


# ---- more commands (2026-10-18: Chapter 1's)
for _pl, _macro, _fmt in [
        ('GetTimeOfDay', 'pl_GetTimeOfDay', ('var',)), ('GetLocalDexSeenCount', 'pl_GetLocalDexSeenCount', ('var',)),
        ('GetPartyMonSpecies', 'pl_GetPartyMonSpecies', ('var', 'var')),
        ('CountPartyNonEggs', 'pl_CountPartyNonEggs', ('var',)), ('CheckPartyPokerus', 'pl_CheckPartyPokerus', ('var',)),
        ('PlayPokecenterHealingAnimation', 'pl_PlayPokecenterHealingAnimation', ('var',)),
        ('OpenPokemonNamingScreen', 'pl_OpenPokemonNamingScreen', ('var', 'var')),
        ('CheckBadgeAcquired', 'pl_CheckBadgeAcquired', ('var', 'var')), ('GiveBadge', 'pl_GiveBadge', ('var',)),
        ('CountBadgesAcquired', 'pl_CountBadgesAcquired', ('var',)), ('PokeMartCommon', 'pl_PokeMartCommon', ('var',)),
        ('BufferSpeciesNameFromVar', 'pl_BufferSpeciesName', ('n', 'var')),
        ('Unk02CA', 'pl_BufferCounterpartStarterSpeciesName', ('n',))]:
    HANDLERS[_pl] = simple(_macro, *_fmt)


@handler('PokeMartSpecialties', 'PokeMartDecor')
def h_special_mart(tr, a, vals, name):
    """Pearl's specialty clerks (SpecialMart n: a Mart's second counter, the Herb Shop, the Veilstone Dept Store) and
    decoration clerks (GoodsMart n: the Dept Store 4F): Pearl's own stock is not built (notes/OPEN_CONTENT.md, the
    specialty-mart port); meanwhile the clerk opens Black 2's normal Mart, its stock by badges (decision 2026-10-19,
    "Black 2's stock where a clerk exists"; lead 2026-10-25, chapter 4b: world-wide)."""
    tr.job.approx[f'{name} (Black 2\'s normal Mart: Pearl\'s specialty stock is not built)'] += 1
    return [f'pl_PokeMartCommon {tr.var(vals[0])}  // Pearl {"SpecialMart" if name == "PokeMartSpecialties" else "GoodsMart"} '
            f'{tr.var(vals[0])}: Black 2\'s normal Mart for now']

# commands with nothing to do in Black 2 (each listed as approximated in the report, with why)
NOOP = {
    'GiveJournal': 'Black 2 has no journal',
    'SetInitialVolumeForSequence': 'Black 2 sets the volume itself',
    'Unused_06E': 'Pearl renames the follower 0xFE: Black 2\'s follower is 0xFE already',
    'LockObject': 'Black 2 pauses all actors (LockAll) only',
    'ReleaseObject': 'Black 2 pauses all actors (LockAll) only',
    'Dummy1F9': 'a debug command',
    'SetPlayerState': 'the player\'s avatar state (the Pokemon Center bow): Black 2 does its own',
    'ChangePlayerState': 'the player\'s avatar state (the Pokemon Center bow): Black 2 does its own',
    'EnableSwarms': 'no Sinnoh swarms yet (notes/ENCOUNTERS.md)',
    'SetHasPartner': 'Pearl\'s "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30',
    'CreateJournalEvent': 'Black 2 has no journal',
    'IncrementTrainerScore2': 'Pearl\'s trainer-card score (Black 2 keeps its own records)',
    'AddAccessory': 'no Super Contests (closed at first: DECISIONS.md)',
    'AddContestBackdrop': 'no Super Contests (closed at first: DECISIONS.md)',
    'PlayHMCutIn': 'the field-move cut-in (with the HM work: Black 2\'s PlayHMCutInEffect needs its player sequence)',
}


def h_noop(tr, a, vals, name):
    tr.job.approx[f'{name} ({NOOP[name]})'] += 1
    return [f'// {name} {", ".join(map(str, vals))}: nothing in Black 2 ({NOOP[name]})']


for _n in NOOP:
    HANDLERS[_n] = h_noop


@handler('CheckHasPartner')
def h_has_partner(tr, a, vals, name):
    """Pearl CheckHasPartner var (pokeplatinum ScrCmd_CheckHasPartner: the "partner walks along" flag 0x961): here
    whether a partner follows the player now, Black 2's pair flag (pearl_story.inc PL_FOLLOW_FLAG, set while one
    follows: Cheryl, Mira, Riley, Buck, Marley). Pearl's Rock Climb wall script refuses with a partner."""
    return [f'FlagGet PL_FOLLOW_FLAG, {tr.var(vals[0])}  // CheckHasPartner: 1 while a partner follows']


@handler('UseRockClimb')
def h_rock_climb(tr, a, vals, name):
    """Pearl UseRockClimb slot (pokeplatinum ScrCmd_UseRockClimb -> ov5 FieldTask_StartUseRockClimb, the same in
    Pearl): the Pokemon's cut-in, then the player hops onto the wall ahead, walks fast across it and hops off (Pearl's
    task: JUMP_NEAR_FAST, WALK_FAST while the tile ahead is a climb tile, JUMP_NEAR_FAST). Black 2 has no climb tiles:
    the zone's climb starts (data/pearl_rock_climb.json, b2tools/rock_climb.py) are compared with the player's tile and
    facing, and the matching one's moves run (no cut-in: Black 2's needs its own player sequence, as Cut's and Rock
    Smash's here). Nowhere else (the sign read sideways) nothing moves."""
    import pearl_events
    ends = pearl_events.rock_climb_ends(tr.job.zone['name'])
    tr.job.approx['UseRockClimb (the climb: hop, fast walks, hop, by data/pearl_rock_climb.json; no cut-in)'] += 1
    base = f'{tr.label(a)}_rc'
    out = [f'// UseRockClimb {tr.var(vals[0])}: {len(ends)} climb starts in this zone',
           'pl_GetPlayerMapPos PL_TMP, PL_TMP2', 'pl_GetPlayerDir PL_TMP3']
    for k, r in enumerate(ends):
        (x, z), d = r['stand'], r['dir']
        out += [f'WorkCmpConst PL_TMP, {x}', f'VMJumpIf CMP_NE, {base}{k}_next',
                f'WorkCmpConst PL_TMP2, {z}', f'VMJumpIf CMP_NE, {base}{k}_next',
                f'WorkCmpConst PL_TMP3, {d}', f'VMJumpIf CMP_NE, {base}{k}_next',
                f'pl_ApplyMovement PL_PLAYER, {base}{k}  // from {tuple(r["stand"])} to {tuple(r["land"])}',
                'pl_WaitMovement', f'VMJump {base}_end', f'{base}{k}_next:']
    out += [f'VMJump {base}_end']
    for k, r in enumerate(ends):
        out += ['.balign 4, 0', f'{base}{k}:'] + [f'    Move {c}, {n}' for c, n in r['moves']] + ['    MoveEnd']
    return out + [f'{base}_end:']


@handler('StartDestroyObstacleAnimation')
def h_destroy_anim(tr, a, vals, name):
    """Pearl's rock/tree breaking animation (pokeplatinum ScrCmd_StartDestroyObstacleAnimation: obstacle, result var)
    sets its var when the animation is over, and the scripts wait for that (Roark's Rock Smash in Oreburgh Mine loops
    until it is non-zero: the game hung there, found in game 2026-10-19). Black 2 has no such animation here: the var
    is set at once, and the script removes the object itself."""
    tr.job.approx[f'{name} (no breaking animation: done at once)'] += 1
    return [f'// StartDestroyObstacleAnimation {vals[0]}: no animation in Black 2',
            f'pl_SetVarFromValue {tr.var(vals[1])}, 1  // the animation is "over" at once (the script waits for it)']


def partner_stays(tr, uid):
    """Whether a partner (SetMovementType uid, 0x30 with var 0x403F) stays in its zone as its own NPC when it stops
    following: the file gives it another movement type right after ClearHasPartner (Riley at Iron Island: "Are you
    going back?" and the grunts; Mira, Marley, Buck the same) and never makes it persistent (Cheryl's file does:
    SetObjectFlagIsPersistent, the rule before). 2026-10-25, ch6a: Riley vanished (pl_follow_leave deleted 0xFE)"""
    names = {a: tr.job.pd.cmd_name(op) for a, (e, op, args) in tr.d.insns.items()}
    if any(n == 'SetObjectFlagIsPersistent' and tr.d.insns[a][2][0][1] == uid for a, n in names.items()):
        return False
    for a, n in names.items():
        if n != 'ClearHasPartner':
            continue
        nxt = tr.d.insns.get(tr.d.insns[a][0])
        if nxt and tr.job.pd.cmd_name(nxt[1]) == 'SetMovementType' and nxt[2][0][1] == uid \
                and nxt[2][1][1] != FOLLOW:
            return True
    return False


@handler('ClearHasPartner')
def h_clear_partner(tr, a, vals, name):
    """Pearl's "partner" flag off. If the same script makes someone follow again later (Route 201: Barry blocks the
    way back), the follower only stops for the scene; a partner that stays in its zone (partner_stays) stops following
    and is its own NPC again; else (Lake Verity: the follower stays behind) Black 2's follower ends and leaves the
    map."""
    nxt = tr.d.insns.get(tr.d.insns[a][0])
    if nxt and tr.job.pd.cmd_name(nxt[1]) == 'SetMovementType' and nxt[2][1][1] != FOLLOW \
            and nxt[2][0][1] in tr.follow_uids and partner_stays(tr, nxt[2][0][1]):
        return ['pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)']
    seen, todo = set(), list(tr.succ(a))
    while todo:
        b = todo.pop()
        if b in seen or b not in tr.d.insns:
            continue
        seen.add(b)
        e, op, args = tr.d.insns[b]
        if tr.job.pd.cmd_name(op) == 'SetMovementType' and args[1][1] == FOLLOW:
            return ['pl_follow_hold_any  // ClearHasPartner: the follower stops while the scene moves it']
        todo += tr.succ(b)
    return ['pl_follow_leave  // ClearHasPartner: the follower stays behind']


@handler('SetObjectEventMovementType')
def h_set_obj_move(tr, a, vals, name):
    import pearl_events
    uid, t = vals
    o = tr.job.objects.get(uid) if tr.mode != 'common' else None
    same = o is not None and t < 0x4000 and pearl_events.b2_move(o['movement_type']) == pearl_events.b2_move(t)
    tr.job.approx['SetObjectEventMovementType (Black 2 cannot change an NPC\'s movement before it appears: it keeps '
                  'its own' + (')' if not same else '; here the same anyway)')] += 1
    return [f'// SetObjectEventMovementType {uid}, {tr.var(t)}: Black 2 has no command for it (the NPC keeps its own'
            f'{", the same" if same else ""})']


@handler('FindPartySlotWithMove')
def h_find_move(tr, a, vals, name):
    return [f'PokePartyHasMoveAny {tr.var(vals[0])}, {tr.var(vals[1])}  // FindPartySlotWithMove: the slot, 6 = none '
            f'(the same in both games)']


@handler('CheckPartyHasSpecies')
def h_has_species(tr, a, vals, name):
    return [f'PokePartyFindBySpecies {tr.var(vals[1])}, {tr.var(vals[0])}, PL_TMP  // CheckPartyHasSpecies (1 = yes)']


# ---- the Pokétch (notes/POKETCH.md): Pearl's commands are sub-commands of PearlB2's extension command 0x15F
# (notes/EXT_COMMAND.md; src/include/pearl_story.inc pl_EnablePoketch ...), the save and the screen in the decomp's
# src/pearlb2/poketch_itcm.c. Pearl's numbers: 0x131 EnablePoketch (GivePoketch), 0x132 CheckPoketchEnabled, 0x133
# RegisterPoketchApp, 0x134 CheckPoketchAppRegistered, 0x265 HidePoketch / 0x266 ShowPoketch (Pearl's flag 0x97C).
@handler('EnablePoketch', 'HidePoketch', 'ShowPoketch')
def h_poketch(tr, a, vals, name):
    return [f'pl_{name}']


@handler('RegisterPoketchApp')
def h_poketch_register(tr, a, vals, name):
    note = f'  // {poketch_app_name(vals[0])}' if vals[0] < NUM_POKETCH_APPS else ''
    return [f'pl_RegisterPoketchApp {tr.var(vals[0])}{note}']


@handler('CheckPoketchEnabled')
def h_poketch_enabled(tr, a, vals, name):
    return [f'pl_CheckPoketchEnabled {tr.var(vals[0])}']


@handler('CheckPoketchAppRegistered')
def h_poketch_check(tr, a, vals, name):
    note = f'  // {poketch_app_name(vals[0])}' if vals[0] < NUM_POKETCH_APPS else ''
    return [f'pl_CheckPoketchAppRegistered {tr.var(vals[0])}, {tr.var(vals[1])}{note}']


NUM_POKETCH_APPS = 25


# ---- Pal Park's migration and Catching Show (notes/PAL_PARK_MIGRATION.md): Pearl's commands are sub-commands 0x40-0x45
# of PearlB2's extension command 0x15F (notes/EXT_COMMAND.md; src/include/pearl_story.inc pl_SetClearInCatchingShowFlag
# ...; decomp src/pearlb2/resident/palpark.c). Pearl's numbers: 0x253 SetClearInCatchingShowFlag (0 start, 1 end),
# 0x254 CheckHasEnoughMonForCatchingShow, 0x255 MoveCatchingShowMonsToPCBoxes, 0x256 CalcCatchingShowPoints, 0x26E
# GetGBACartridgeVersion. In the gate, with nothing stocked and a GBA game in slot 2, the receptionist asks Pearl's
# migration question (b2tools/palpark_offer.py migrate_offer) before Pearl's "six are needed" line.
@handler('SetClearInCatchingShowFlag')
def h_catching_show_flag(tr, a, vals, name):
    return [f'pl_SetClearInCatchingShowFlag {tr.var(vals[0])}']


@handler('CheckHasEnoughMonForCatchingShow')
def h_catching_show_stock(tr, a, vals, name):
    import palpark_offer
    var = tr.var(vals[0])
    return [f'pl_CheckHasEnoughMonForCatchingShow {var}'] + palpark_offer.migrate_offer(tr.job, a, var)


@handler('MoveCatchingShowMonsToPCBoxes')
def h_catching_show_pc(tr, a, vals, name):
    return ['pl_MoveCatchingShowMonsToPCBoxes']


@handler('CalcCatchingShowPoints')
def h_catching_show_points(tr, a, vals, name):
    return [f'pl_CalcCatchingShowPoints {tr.var(vals[0])}, {tr.var(vals[1])}']


@handler('GetGBACartridgeVersion')
def h_gba_cartridge(tr, a, vals, name):
    return [f'pl_GetGBACartridgeVersion {tr.var(vals[0])}']


@handler('GetGameVersion')
def h_version(tr, a, vals, name):
    return [f'WorkSetConst {tr.var(vals[0])}, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)']


@handler('CheckNationalDexCompleted')
def h_natdex_done(tr, a, vals, name):
    return [f'PokeDexIsComplete {tr.var(vals[0])}, 1  // CheckNationalDexCompleted (Black 2\'s National Dex)']


@handler('CheckIsTodayPlayerBirthday')
def h_birthday(tr, a, vals, name):
    tr.job.approx['CheckIsTodayPlayerBirthday (0)'] += 1
    return [f'WorkSetConst {tr.var(vals[0])}, 0  // CheckIsTodayPlayerBirthday: not checked']


# Pearl's "step" flag 0x965 (ops 0x163-0x165: set when Barry starts following, read by his talk script): Black 2's
# 0x965 is its own (EVENT_FLAG_CONTINUE_SCRIPT), so a map-local flag of ours, PL_STEP_FLAG
@handler('SetStepFlag')
def h_step_set(tr, a, vals, name):
    return ['FlagSet PL_STEP_FLAG  // SetStepFlag (Pearl sys flag 0x965)']


@handler('CheckStepFlag')
def h_step_check(tr, a, vals, name):
    return [f'FlagGet PL_STEP_FLAG, {tr.var(vals[0])}  // CheckStepFlag (Pearl sys flag 0x965)']


# Pearl's "Strength is on" flag (ScrCmd_DoStrengthFunc 0x1CF, the boulder script 10002: 1 sets, 0 clears, 2 reads into
# a var; a map change clears it, pokeplatinum field_map_change_flags.c) is Black 2's flag 0x964 (2404): Black 2's own
# boulder script sets it, the field pushes a boulder only while it is set (ov036 fieldmap_event.c contactFlags) and
# every zone change clears it (ov012 zone_change.c)
B2_STRENGTH_FLAG = 2404


@handler('DoStrengthFunc')
def h_strength(tr, a, vals, name):
    op = vals[0]
    if op == 1:
        return [f'FlagSet {B2_STRENGTH_FLAG}  // GetSetStrength 1: Strength on (Black 2\'s flag 0x964, the push reads it)']
    if op == 0:
        return [f'FlagReset {B2_STRENGTH_FLAG}  // GetSetStrength 0: Strength off (Black 2\'s flag 0x964)']
    return [f'FlagGet {B2_STRENGTH_FLAG}, {tr.var(vals[1])}  // GetSetStrength 2: is Strength on (Black 2\'s flag 0x964)']


@handler('ClearStepFlag')
def h_step_clear(tr, a, vals, name):
    return ['FlagReset PL_STEP_FLAG  // ClearStepFlag (Pearl sys flag 0x965)']


@handler('GetSetNationalDexEnabled')
def h_natdex(tr, a, vals, name):
    mode, var = vals
    if mode == 1:
        return ['pl_SetNationalDex']
    return [f'pl_GetNationalDex {tr.var(var)}']


@handler('GetItemNamePlural')
def h_item_plural(tr, a, vals, name):
    tr.job.approx['GetItemNamePlural (the singular name: Black 2 has no plural)'] += 1
    return [f'pl_BufferItemName {vals[0]}, {tr.var(vals[1])}  // GetItemNamePlural']


@handler('CheckItemIsPlate')
def h_plate(tr, a, vals, name):
    tr.job.approx['CheckItemIsPlate (0: the item-get line of a non-plate)'] += 1
    return [f'WorkSetConst {tr.var(vals[1])}, 0  // CheckItemIsPlate {tr.var(vals[0])}']


@handler('GetTrainerCardLevel')
def h_card_level(tr, a, vals, name):
    tr.job.approx['GetTrainerCardLevel (0: no trainer card stars in Black 2)'] += 1
    return [f'WorkSetConst {tr.var(vals[0])}, 0  // GetTrainerCardLevel']


# The National Pokédex at Champion (user 2026-10-26, DECISIONS: limited trading in a ROM hack): the checks that gate
# Oak's upgrade on the Sinnoh Pokédex seen also pass once the game-clear flag 2400 (Pearl's 0x964) is set; Oak's scene
# and every National Dex unlock then run as Pearl's. Pearl's other completion checks stay the true count: the
# Pokédex rating (Rowan's PC, file 376: it sets 0x110, which picks Rowan's "you've met every kind" line), the Grand
# Lake's diploma (file 384). (chapter 9a)
NATIONAL_DEX_AT_CHAMPION = {
    (990, 0x61): "Rowan's lab, Rowan's talk: the Sinnoh Pokédex seen -> Oak's National Pokédex scene",
    (977, 0x23): "Dawn / Lucas (global 10300: outside the lab after the Hall of Fame, and in it): 'Have you shown "
                 "your Pokédex to Prof. Rowan yet?'",
}


@handler('CheckLocalDexCompleted')
def h_dex_done(tr, a, vals, name):
    # (2026-10-20) the regional list is Pearl's Sinnoh one (patches/sinnoh_dex.py, its completion rule too)
    if (tr.f, a) in NATIONAL_DEX_AT_CHAMPION:
        return [f'pl_CheckLocalDexCompletedOrChampion {tr.var(vals[0])}  // the National Pokédex at Champion '
                f'(NATIONAL_DEX_AT_CHAMPION)']
    return [f'pl_CheckLocalDexCompleted {tr.var(vals[0])}']


# ---- the Pokédex's counts and ratings (2026-10-20; pearl_story.inc "the Pokédex")
@handler('GetNationalDexSeenCount', 'GetNationalDexCaughtCount')
def h_dex_national(tr, a, vals, name):
    return [f'pl_{name} {tr.var(vals[0])}']


@handler('LoadPokedexRating')
def h_dex_rating(tr, a, vals, name):
    """Pearl 0x123 (GetDexEvaluationMessage mode, var): var = the line of Pearl's rating bank (335: Rowan 4-14, Oak
    19-39) for the count; the script then prints it with MessageVar. Here var = that line's number in this file."""
    mode, var = vals
    first, last, macro = (19, 39, 'National') if mode else (4, 14, 'Local')
    lines = [tr.job.line_for(tr.bank, n) for n in range(first, last + 1)]
    return [f'pl_LoadPokedexRating{macro} {tr.var(var)}, {", ".join(map(str, lines))}  // Pearl bank {tr.bank} '
            f'lines {first}-{last}']


@handler('GetSwarmMapAndSpecies')
def h_swarm(tr, a, vals, name):
    tr.job.approx['GetSwarmMapAndSpecies (no swarms yet: map 0, species 0)'] += 1
    return [f'WorkSetConst {tr.var(vals[0])}, 0', f'WorkSetConst {tr.var(vals[1])}, 0  // GetSwarmMapAndSpecies']


@handler('BufferMapName')
def h_mapname(tr, a, vals, name):
    n, m = vals
    if m < 0x4000:
        b2 = tr.job.pd.b2_zone.get(m)
        if b2 is not None:
            return [f'pl_BufferMapName {n}, {b2}  // Pearl map {m}']
    tr.job.approx['BufferMapName (a Pearl map from a var: this zone\'s name)'] += 1
    return [f'WordSetPlaceName {n}, {tr.job.pd.b2_zone.get(tr.job.zone["id"], 0)}  // BufferMapName {n}, {tr.var(m)}']


# ---- Amity Square (Pearl script file 266, 2026-10-25; pearl_story.inc "Amity Square"): the walk with a Pokémon. The
# receptionists at the gates (triggers (12, 46) / (51, 46) on var 0x4099 = 0) offer each allowed Pokémon of the party in
# turn, heal the party, place its object behind the player, start Pearl's step count and pick the first find; the
# follower is Black 2's (SetMovementType 0x30); the triggers one tile south (var 0x4099 = 1) end the walk. Talking to
# the follower after 200 steps gives the find.
AMITY = 'MAP_AMITY_SQUARE'
AMITY_FIND_KIND = 0x409B                       # Pearl's kind of the next find (P266_0858: 0 a Berry, 1 an Accessory)


@handler('ClearAmitySquareStepCount')
def h_amity_clear_steps(tr, a, vals, name):
    return ['pl_ClearAmitySquareStepCount  // Pearl 0x215: Black 2\'s step counter from 0']


@handler('GetAmitySquareStepCount')
def h_amity_steps(tr, a, vals, name):
    return [f'pl_GetAmitySquareStepCount {tr.var(vals[0])}  // Pearl 0x216']


@handler('CalcAmitySquareFoundAccessory')
def h_amity_accessory(tr, a, vals, name):
    """Pearl's Accessory for the next find (by species). Black 2 has no Accessories: the user chose Pearl's Berries
    only (2026-10-25), so the find's kind becomes a Berry; the Berry is Pearl's own pick right after (P266_0894)."""
    tr.job.approx['CalcAmitySquareFoundAccessory (no Accessories: every find is one of Pearl\'s Berries, user '
                  '2026-10-25)'] += 1
    return [f'pl_AmitySquareBerryOnly {tr.var(AMITY_FIND_KIND)}, {tr.var(vals[0])}  // Pearl 0x217 '
            f'{tr.var(vals[0])}, {tr.var(vals[1])}: every find is a Berry']


@handler('CanFitAccessory')
def h_can_fit_accessory(tr, a, vals, name):
    """In Amity Square the Accessory never fits (there are none: Berries only), so a Berry that does not fit into the
    Bag gives one of the follower's lines, as Pearl does when neither fits. Elsewhere: still a stub."""
    if tr.mode == 'common' or tr.job.zone['name'] != AMITY:
        tr.job.stubs[name] += 1
        return [f'pl_stub CanFitAccessory  // Pearl 0x1D3 Unk01D3 {", ".join(map(str, vals))}: not translated yet']
    return [f'WorkSetConst {tr.var(vals[2])}, 0  // CanFitAccessory {tr.var(vals[0])}, {tr.var(vals[1])}: no '
            f'Accessories in Black 2 (the finds are Berries)']


@handler('27C')
def h_tv_amity(tr, a, vals, name):
    """Pearl's TV records (pokeplatinum ScrCmd_27C: 0 the walk's Pokémon, 1 a found item, 2 a found Accessory, for the
    "Amity Square Watch" programme). Black 2 has no Sinnoh TV."""
    tr.job.approx['27C (Pearl\'s TV records of Amity Square: no Sinnoh TV)'] += 1
    return [f'// 27C {", ".join(map(str, vals))}: Pearl\'s TV record of the walk; nothing in Black 2 (no Sinnoh TV)']


# ---- Pearl's free camera (AddFreeCamera x, z: a camera object on that tile; ApplyMovement 0xF1 walks it; RestoreCamera
# puts the view back on the player) -> Black 2's event camera, as HoennB2 ports Sapphire's camera object
# (scenes/emerald/em_ch10_lib.inc): EvCameraInit + EvCameraUnbind, EvCameraMoveTo pitch 9688, yaw 0, distance 0xed000
# (the field camera's own angle: 96 of Black 2's 120 uses) to the fx32 point looked at, EvCameraWait; back with
# EvCameraReturn, EvCameraRebind, EvCameraEnd. The camera's walk becomes one move to where the walk ends, over the walk's
# frames (Pearl's movement codes: frames a tile in data/pearl_movement.json). Lake Verity: Rowan and the counterpart
# talk on screen before the view comes back to the player and Barry (user 2026-10-19).
CAM_ANGLE = '9688, 0, 0xed000'
CAM_STEP = {'NORTH': (0, -1), 'SOUTH': (0, 1), 'WEST': (-1, 0), 'EAST': (1, 0)}


def cam_point(tr, x, z):
    h = None
    if isinstance(x, int) and isinstance(z, int) and x < 0x4000 and z < 0x4000:
        global _HEIGHTS
        if _HEIGHTS is None:
            import pearl_events
            _HEIGHTS = pearl_events.Heights()
        h = _HEIGHTS.at(tr.job.zone, x, z)
    return f'{(x * 16 + 8) << 12}, {(h or 0) << 12}, {(z * 16 + 8) << 12}'


# Pearl's AddFreeCamera on the player's tile (GetPlayerMapPos just before): the tile the scene has the player on there,
# (Pearl script file, the command's address) -> (x, z), as scene_check plays the scene (2026-10-25, ch6a). Canalave
# Library 3F's lakes scene: its frame-table script runs on the one arrival, the stairs' foot (4, 3), then the player
# walks south 2, east 3, south 2. (Spear Pillar's four and Lake Acuity's start on triggers or arrivals of several
# tiles: no single tile, the camera stays on the player.)
CAMERA_AT_PLAYER = {(42, 0x0087): (7, 7)}
# The same where the scene starts on one of a few tiles (2026-10-26, ch6b): the free camera starts where the field's
# camera is (on the player: no cut) and its walks are counted from the tile given. Lake Acuity (Galactic)'s scene runs
# on the two arrivals (14, 50) / (15, 50) from Acuity Lakefront; its camera goes up 5 to Jupiter and Barry, so from
# (14, 50) it drifts one column right on the way up.
CAMERA_NEAR_PLAYER = {(351, 0x000E): (15, 50)}
# Where the free camera is when a subroutine walks it (the translator writes code in address order, so a subroutine
# after its caller's RestoreCamera would find no camera): (Pearl script file, ApplyMovement's address) -> tile. Lake
# Acuity (Galactic): the camera comes back down with Jupiter (Pearl's Mov_0234) from (15, 45).
CAMERA_MOVE_FROM = {(351, 0x0142): (15, 45), (351, 0x0160): (15, 45)}


@handler('AddFreeCamera')
def h_cam_add(tr, a, vals, name):
    x, z = vals
    if (x >= 0x4000 or z >= 0x4000) and (tr.f, a) in CAMERA_NEAR_PLAYER:
        tr.cam = CAMERA_NEAR_PLAYER[(tr.f, a)]
        return [f'EvCameraInit  // AddFreeCamera {tr.var(x)}, {tr.var(z)} (the player\'s tile): Black 2\'s event camera '
                f'where the camera is, counted as {tr.cam}', 'EvCameraUnbind']
    if (x >= 0x4000 or z >= 0x4000) and (tr.f, a) in CAMERA_AT_PLAYER:
        x, z = CAMERA_AT_PLAYER[(tr.f, a)]
    elif (x >= 0x4000 or z >= 0x4000) and tr.f in CAMERA_PLAN_FILES and a in camera_plan(tr.job.pd, tr.f):
        tr.cam = planned_camera(tr, a) or PLAYER_CAM          # (camera_plan: where it is for each start tile)
        return [f'EvCameraInit  // AddFreeCamera {tr.var(x)}, {tr.var(z)}: the player\'s tile (camera_plan); the '
                f'view stays where it is', 'EvCameraUnbind']
    elif x >= 0x4000 or z >= 0x4000:
        tr.job.stubs['AddFreeCamera (a tile from a var)'] += 1
        tr.cam_stubbed = True
        return [f'pl_stub AddFreeCamera  // {tr.var(x)}, {tr.var(z)}: the camera stays on the player']
    tr.cam = (x, z)
    return [f'EvCameraInit  // AddFreeCamera {x}, {z}: Black 2\'s event camera on that tile', 'EvCameraUnbind',
            f'EvCameraMoveTo {CAM_ANGLE}, {cam_point(tr, x, z)}, 1', 'EvCameraWait']


@handler('RestoreCamera')
def h_cam_restore(tr, a, vals, name):
    if getattr(tr, 'cam', None) is None and getattr(tr, 'cam_stubbed', False):
        return ['// RestoreCamera: the free camera was not made (its AddFreeCamera is a stub): the camera stayed']
    tr.cam = None
    return ['EvCameraReturn 1  // RestoreCamera: the view cuts back to the player', 'EvCameraWait', 'EvCameraRebind',
            'EvCameraEnd']


# ---- the free camera on the player's tile in scenes that start on several tiles (2026-10-26, chapter 7). Spear
# Pillar's scenes start on wide step triggers (5 tiles at the altar's foot, 3 at Barry's row), put the free camera on
# the player (AddFreeCamera with GetPlayerMapPos's vars) and walk it with a movement list per branch of the player's x
# (P230_0510: from x 29 north 6 east 2, from x 30 north 6 east 1, ...), so each walk ends on one tile whatever the
# start; the vistas' warps keep the start tile in vars 0x8000/0x8001 and the scene goes on there (continuation 16).
# camera_plan plays each scene of a file in CAMERA_PLAN_FILES from every tile of the triggers that start it, the
# player's tile and Pearl's vars followed through branches, calls and Warps (Pearl's script goes on after a Warp), and
# keeps where the free camera is after each AddFreeCamera / ApplyMovement 0xF1 for each start tile. A camera walk that
# ends on one tile from every start is Black 2's EvCameraMoveTo that tile; AddFreeCamera itself is EvCameraInit +
# EvCameraUnbind (the view stays where it is: on the player, Pearl's tile). Lake Acuity (Galactic)'s scene (file 351)
# is made the same way and can use a row here.
CAMERA_PLAN_FILES = {230}
_CAM_PLANS, _CAM_ACTIVE, _WARP_PLACES = {}, {}, {}
_COND = {0: (0,), 1: (1,), 2: (2,), 3: (0, 1), 4: (1, 2), 5: (0, 2)}


def move_delta(steps):
    """(dx, dz) a Pearl movement list moves its walker."""
    dx = dz = 0
    for cmd, n in steps:
        nm = (MOVEMENT.get(cmd) or {}).get('pearl_name', '')
        d = next((v for k, v in CAM_STEP.items() if nm.endswith('_' + k)), None)
        if d is None or nm.startswith(('FACE_', 'WALK_ON_SPOT', 'JUMP_ON_SPOT')):
            continue
        k = 3 if nm.startswith('JUMP_FARTHER') else 2 if nm.startswith('JUMP_FAR') else \
            1 if nm.startswith(('WALK_', 'RUN_', 'JUMP_NEAR')) else 0
        dx, dz = dx + d[0] * k * n, dz + d[1] * k * n
    return dx, dz


def camera_plan(pd, f):
    """{address of an AddFreeCamera or ApplyMovement 0xF1 in Pearl file f: {start tile: the camera's tile after it}}."""
    if f in _CAM_PLANS:
        return _CAM_PLANS[f]
    d = pd.disasm(f)
    starts = []
    for z in pd.zones:
        if z['scripts'] == f:
            for c in pd.events(z)['coord_events']:
                if 1 <= c['script'] <= len(d.entries):
                    starts += [(d.entries[c['script'] - 1], (x, zz)) for x in range(c['x'], c['x'] + c['width'])
                               for zz in range(c['z'], c['z'] + c['length'])]
    plan, active, places = collections.defaultdict(dict), set(), collections.defaultdict(set)
    for entry, tile in starts:
        todo, seen = [(entry, (), tile, {}, None, None)], set()
        while todo:
            a, stack, player, vs, cam, cmp = todo.pop()
            for _ in range(4000):
                key = (a, stack, player, tuple(sorted(vs.items())), cam, cmp)
                if a not in d.insns or key in seen:
                    break
                seen.add(key)
                if cam is not None:
                    active.add(a)
                e, op, args = d.insns[a]
                nm, v = pd.cmd_name(op), [x[1] for x in args]
                val = lambda x: x if x < 0x4000 else vs.get(x)
                vs, nxt = dict(vs), e
                if nm in ('End', 'ReturnCommonScript'):
                    break
                if nm == 'Return':
                    if not stack:
                        break
                    nxt, stack = stack[-1], stack[:-1]
                elif nm == 'GoTo':
                    nxt = v[0]
                elif nm == 'Call':
                    nxt, stack = v[0], stack + (e,)
                elif nm in ('GoToIf', 'CallIf'):
                    go = (v[1], stack + ((e,) if nm == 'CallIf' else ()))
                    if cmp is None:                       # (not known: both ways)
                        todo.append((go[0], go[1], player, vs, cam, None))
                    elif cmp in _COND[v[0]]:
                        nxt, stack = go
                elif nm == 'CompareVarToValue':
                    x = vs.get(v[0])
                    cmp = None if x is None else (0 if x < v[1] else 1 if x == v[1] else 2)
                elif nm == 'CompareVarToVar':
                    x, y = vs.get(v[0]), vs.get(v[1])
                    cmp = None if x is None or y is None else (0 if x < y else 1 if x == y else 2)
                elif nm == 'GetPlayerMapPos':
                    vs[v[0]], vs[v[1]] = player
                elif nm == 'SetVarFromValue':
                    vs[v[0]] = v[1]
                elif nm == 'SetVarFromVar':
                    vs[v[0]] = vs.get(v[1])
                elif nm == 'AddVar' and vs.get(v[0]) is not None and val(v[1]) is not None:
                    vs[v[0]] += val(v[1])
                elif nm == 'Warp':                        # Pearl's script goes on there (a continuation)
                    player, cam = (val(v[2]), val(v[3])), None
                    places[a].add(player)
                elif nm == 'AddFreeCamera':
                    cam = (val(v[0]), val(v[1]))
                    plan[a][tile] = cam
                elif nm == 'RestoreCamera':
                    cam = None
                elif nm == 'ApplyMovement' and v[0] in (0xF1, 0xFF):
                    dx, dz = move_delta(movement_steps(pd, f, v[1]))
                    if v[0] == 0xFF and None not in player:
                        player = (player[0] + dx, player[1] + dz)
                    elif v[0] == 0xF1 and cam is not None and None not in cam:
                        cam = (cam[0] + dx, cam[1] + dz)
                        plan[a][tile] = cam
                else:                                     # any other command may write its vars
                    for ty, x in args:
                        if ty == 'var' and x >= 0x4000:
                            vs.pop(x, None)
                a = nxt
    _CAM_PLANS[f], _CAM_ACTIVE[f], _WARP_PLACES[f] = dict(plan), active, dict(places)
    return _CAM_PLANS[f]


PLAYER_CAM = (None, None)        # tr.cam: a free camera on the player's tile, not one tile from every start


def move_frames(steps):
    """Frames a Pearl movement list's walk takes (its walking steps: data/pearl_movement.json frames a tile)."""
    frames = 0
    for cmd, n in steps:
        per = re.search(r'(\d+) frames/tile', (MOVEMENT.get(cmd) or {}).get('note', ''))
        if per:
            frames += n * int(per.group(1))
    return frames


def cam_angle(tr):
    """EvCameraMoveTo's pitch, yaw and distance for a camera_plan walk: Black 2's camera 0 (distance 237) at the zone's
    own pitch, as the field camera is since 2026-10-26 (maplook 'tilt': Pearl's pitch for the zone's Pearl camera
    type, the overworld's for matrix 0), so the view does not tilt when the walk starts. (CAM_ANGLE is camera 0's own
    pitch, 9688.)"""
    import maplook
    z = tr.job.zone
    return f'{maplook.PEARL_CAMERAS[0 if z["matrix"] == 0 else z["camera"]][1]}, 0, 0xed000'


def end_free_camera(tr, why, a):
    """A camera_plan scene (CAMERA_PLAN_FILES) whose free camera is still out at a battle or a Warp (at a, in some
    start: camera_plan's _CAM_ACTIVE): Pearl rebuilds the field there (the camera is the player's again); Black 2's
    event camera is ended first."""
    if tr.f in CAMERA_PLAN_FILES and (camera_plan(tr.job.pd, tr.f) is not None) and a in _CAM_ACTIVE[tr.f]:
        tr.cam = None
        return [f'EvCameraReturn 1  // ({why}: the free camera ends first, as Pearl\'s field is rebuilt there)',
                'EvCameraWait', 'EvCameraRebind', 'EvCameraEnd']
    return []


def planned_camera(tr, a):
    """The one tile the free camera is on after the command at a in every start of camera_plan, or None."""
    if tr.f not in CAMERA_PLAN_FILES:
        return None
    ends = set(camera_plan(tr.job.pd, tr.f).get(a, {}).values())
    return ends.pop() if len(ends) == 1 and None not in next(iter(ends)) else None


@handler('ApplyMovement')
def h_move(tr, a, vals, name):
    if vals[0] == 0xF1 and tr.f in CAMERA_PLAN_FILES and a in camera_plan(tr.job.pd, tr.f):
        to = planned_camera(tr, a)
        frames = move_frames(tr.d.movement.get(vals[1]) or [])
        if to is None:
            tr.job.approx['ApplyMovement on the free camera ending on several tiles (the camera stays)'] += 1
            return [f'// ApplyMovement 0xF1 (the free camera), {tr.label(vals[1])}: it ends on several tiles, the '
                    f'camera stays']
        tr.cam = to
        return [f'EvCameraMoveTo {cam_angle(tr)}, {cam_point(tr, to[0], to[1])}, {max(1, frames)}  // ApplyMovement '
                f'0xF1 {tr.label(vals[1])}: the free camera walks to {to} (camera_plan)', 'EvCameraWait']
    if vals[0] == 0xF1:
        cam = CAMERA_MOVE_FROM.get((tr.f, a)) or getattr(tr, 'cam', None)
        steps = tr.d.movement.get(vals[1]) if hasattr(tr.d, 'movement') else None
        if cam is None or steps is None:
            tr.job.approx['ApplyMovement on the free camera without AddFreeCamera here (the camera stays)'] += 1
            return [f'// ApplyMovement 0xF1 (the free camera), {tr.label(vals[1])}: the camera stays']
        x, z, frames = cam[0], cam[1], 0
        for cmd, n in steps:
            info = MOVEMENT.get(cmd) or {}
            nm, note = info.get('pearl_name', ''), info.get('note', '')
            d = next((v for k, v in CAM_STEP.items() if nm.endswith(k)), None)
            per = re.search(r'(\d+) frames/tile', note)
            if d and per and 'WALK' in nm:
                x, z, frames = x + d[0] * n, z + d[1] * n, frames + n * int(per.group(1))
            elif per:
                frames += n * int(per.group(1))
        tr.cam = (x, z)
        return [f'EvCameraMoveTo {CAM_ANGLE}, {cam_point(tr, x, z)}, {max(1, frames)}  // ApplyMovement 0xF1 '
                f'{tr.label(vals[1])}: the free camera walks to ({x}, {z})', 'EvCameraWait']
    if vals[0] in tr.follow_uids:
        return [f'pl_ApplyMovementF {vals[0]}, {tr.label(vals[1])}  // (the follower once it follows)']
    return [f'pl_ApplyMovement {actor(tr, vals[0])}, {tr.label(vals[1])}']


# ---- menus (Pearl's multiple-choice and list menus -> Black 2's list menu, ov036 scrcmd_menu.c): Pearl's "global"
# menus take their lines from bank 321 (pokediamond ov05_021E1AD8: NewMsgDataFromNarc 0x141), "local" ones from the
# script's bank; Black 2 shows lines of the script's own text file, so they are copied there. Black 2's menus open at the
# right edge (x = 31, as its own yes/no menus); Pearl's row is kept.
MENU_BANK = 321


@handler('InitGlobalTextMenu', 'InitLocalTextMenu', 'InitGlobalTextListMenu', 'InitLocalTextListMenu')
def h_menu_init(tr, a, vals, name):
    x, y, cursor, b_exits, var = vals
    tr.menu_bank = MENU_BANK if 'Global' in name else tr.bank
    tr.job.approx['menus (Black 2\'s list menu at the right edge; B cancels as Black 2 does)'] += 1
    return [f'ListMenu_AnchorTopRight 31, {y}, {cursor}, 0, {tr.var(var)}  // Pearl {name} {x}, {y}, {cursor}, '
            f'{b_exits}, {tr.var(var)}']


@handler('AddMenuEntryImm', 'AddMenuEntry', 'AddListMenuEntry')
def h_menu_add(tr, a, vals, name):
    msg, value = vals[0], vals[1]
    if msg >= 0x4000:
        tr.job.stubs[f'{name} (the line from a var)'] += 1
        return [f'pl_stub {name}  // line from {tr.var(msg)}: Black 2 menus take a fixed line']
    bank = getattr(tr, 'menu_bank', tr.bank)
    sex = getattr(tr, 'dc_sex_buf', None)
    mark = f'{{STRVAR_1 2, {sex}}}' if sex is not None else None
    src = tr.job.gen4_text.bank(bank)[msg]
    if mark and mark in src:                    # a Day Care line with the gender symbol (h_daycare_menu_line)
        tr.dc_sex_buf = None
        # Black 2's list menu sizes its window by the text and ignores a cursor move: Pearl's {CURSOR_X 90}Lv. 100 fell
        # outside the window (seen in game 2026-10-25); Black 2's own Day Care lines put a space there
        src = re.sub(r'\{CURSOR_X \d+\}', ' ', src)
        out, end = [], f'{tr.prefix}_{a:04X}_SexDone'
        for k, sym in ((1, '♂'), (2, '♀')):
            out += [f'WorkCmpConst PL_DC_SEX, {k}', f'VMJumpIf CMP_EQ, {tr.prefix}_{a:04X}_Sex{k}']
        out += [f'ListMenuAdd {tr.job.line_text(("menu_sex", bank, msg, 0), src.replace(mark, ""))}, 65535, '
                f'{tr.var(value)}  // Pearl {name} {msg}, {tr.var(value)} (no gender)', f'VMJump {end}']
        for k, sym in ((1, '♂'), (2, '♀')):
            out += [f'{tr.prefix}_{a:04X}_Sex{k}:',
                    f'ListMenuAdd {tr.job.line_text(("menu_sex", bank, msg, k), src.replace(mark, sym))}, 65535, '
                    f'{tr.var(value)}  // ({sym})', f'VMJump {end}']
        return out + [f'{end}:']
    line = tr.job.line_for(bank, msg)
    return [f'ListMenuAdd {line}, 65535, {tr.var(value)}  // Pearl {name} {msg}, {tr.var(value)}']


@handler('ShowMenu', 'ShowListMenu')
def h_menu_show(tr, a, vals, name):
    return ['ListMenuShow']


for _pl, _macro, _fmt in [
        ('GetItemNameWithIndefArticle', 'WordSetItemNameWithArticle', ('n', 'var')),
        ('GetPartyMonFriendship', 'PokePartyGetHappiness', ('var', 'var')),
        ('GetRandom2', 'pl_GetRandom', ('var', 'var')), ('GetDayOfWeek', 'RTCGetWeekDay', ('var',)),
        ('HideMoney', 'MoneyWinClose', ()), ('UpdateMoneyDisplay', 'MoneyWinUpdate', ()),
        ('TrySaveGame', 'SaveDataWrite', ('var',))]:
    HANDLERS[_pl] = simple(_macro, *_fmt)


@handler('ShowMoney')
def h_show_money(tr, a, vals, name):
    return [f'MoneyWinDisp 31, 1  // Pearl ShowMoney {tr.var(vals[0])}, {tr.var(vals[1])} (Black 2\'s place)']


@handler('WaitABPressTime')
def h_wait_time(tr, a, vals, name):
    tr.job.approx['WaitABPressTime (waits the time; no early A/B)'] += 1
    return [f'VMSleep {tr.var(vals[0])}  // WaitABPressTime']


@handler('CheckPartyHasBadEgg')
def h_bad_egg(tr, a, vals, name):
    return [f'WorkSetConst {tr.var(vals[0])}, 0  // CheckPartyHasBadEgg: never']


@handler('CheckGameCompleted')
def h_game_done(tr, a, vals, name):
    return [f'FlagGet 2400, {tr.var(vals[0])}  // CheckGameCompleted: Black 2\'s game clear (Pearl 0x964 = 2400 here)']


@handler('GetFirstNonEggInParty')
def h_lead(tr, a, vals, name):
    return [f'pl_GetFirstNonEggInParty {tr.var(vals[0])}']


@handler('StartLegendaryBattle')
def h_legend(tr, a, vals, name):
    """Pearl 0x2BD (pokediamond LegendaryBattle: species, level): a scripted wild battle, flag 0. Black 2's legendary
    flag 1 (its Regirock, HoennB2's Kyogre) only changes the opening line to "Palkia appeared!" (ov167 btlv_scu.c
    BtlvScu_GetWildEncountMsg, setup flag 4: system text 0017 line 6); Pearl's says "A wild Palkia appeared!" (bank 324
    line 965), Black 2's flag 0 line. Pearl's legendary music comes by species (data/battle_music.json "wild")."""
    tr.last_battle = 'wild'
    tr.job.approx['StartLegendaryBattle (a wild battle: no legendary rules)'] += 1
    return end_free_camera(tr, 'a battle', a) + [f'pl_StartWildBattle {tr.var(vals[0])}, {tr.var(vals[1])}']


@handler('CapitalizeFirstChar', 'ShowSavingIcon', 'HideSavingIcon')
def h_noop2(tr, a, vals, name):
    tr.job.approx[f'{name} (nothing in Black 2)'] += 1
    return [f'// {name}: nothing in Black 2']


@handler('MessageFromBank', 'MessageFromBankInstant')
def h_msg_bank(tr, a, vals, name):
    bank, n = vals
    gift = delivery_message(tr, a, name)            # the deliveryman's received / can't-receive line (chapter 9a)
    if gift is not None:
        return gift
    if bank >= 0x4000 or n >= 0x4000:
        tr.job.stubs[f'{name} (bank or line from a var)'] += 1
        return [f'pl_stub {name}  // {tr.var(bank)}, {tr.var(n)}']
    kind, uid = speaker(tr, a, -1)
    m = tr.job.line_for(bank, n)
    return switch_window(tr, kind, uid) + [(f'pl_msg_actor {m}, {uid}' if kind == 'actor' else f'pl_msg_{kind} {m}')
                                           + f'  // Pearl bank {bank} line {n}']


@handler('GetCurrentMapID')
def h_mapid(tr, a, vals, name):
    """Pearl scripts compare it with Pearl map numbers: the number of the zone this file belongs to."""
    zs = [z['id'] for z in tr.job.pd.zones if z['scripts'] == tr.job.zone['scripts']]
    if len(zs) == 1 or tr.mode == 'common':
        return [f'WorkSetConst {tr.var(vals[0])}, {tr.job.zone["id"]}  // GetCurrentMapID: Pearl map {tr.job.zone["id"]}']
    out = [f'RTGetZoneID {tr.var(vals[0])}  // GetCurrentMapID: Black 2 zone -> Pearl map']
    for pz in zs:
        b2 = tr.job.pd.b2_zone.get(pz)
        if b2 is not None:
            out += [f'WorkCmpConst {tr.var(vals[0])}, {b2}', f'VMJumpIf CMP_NE, .Lmap{a:x}_{pz}',
                    f'WorkSetConst {tr.var(vals[0])}, {pz}', f'VMJump .Lmap{a:x}_end', f'.Lmap{a:x}_{pz}:']
    return out + [f'.Lmap{a:x}_end:']


@handler('GiveMoney', 'RemoveMoney', 'CheckMoney')
def h_money(tr, a, vals, name):
    """Pearl's amounts are 32-bit, Black 2's money commands take 16 bits: larger amounts in steps."""
    amount = vals[-1]
    macro = {'GiveMoney': 'pl_GiveMoney', 'RemoveMoney': 'pl_RemoveMoney', 'CheckMoney': 'MoneyCheck'}[name]
    if name == 'CheckMoney':
        if amount > 0xFFFF:
            tr.job.approx['CheckMoney over 65535 (checks 65535)'] += 1
            amount = 0xFFFF
        return [f'MoneyCheck {tr.var(vals[0])}, {amount}']
    out = []
    while amount > 0xFFFF:
        out.append(f'{macro} 65535')
        amount -= 0xFFFF
    return out + [f'{macro} {amount}']


@handler('CountAliveMonsExcept')
def h_count_alive_except(tr, a, vals, name):
    """Pearl 0x19B (pokeplatinum ScrCmd_CountAliveMonsExcept: var, slot): the party's Pokémon that are not eggs and
    have HP, except the one in `slot`. With a constant slot past the party (Pearl's double-battle trainers ask with 6:
    the Seven Stars Restaurant, Jubilife TV) that is Black 2's PokePartyGetCount kind 2 (howManyPokesAreAbleToFight:
    the same test). A slot from a var stays a stub (2026-10-25, chapter 5a)."""
    var, slot = vals
    if slot >= 6 and slot < 0x4000:
        return [f'PokePartyGetCount {tr.var(var)}, 2  // Pearl CountAliveMonsExcept {var}, {slot}: no slot left out']
    if tr.f == DAYCARE_FILE:                    # the Day Care's slot from its list (chapter 4b): the macro tests it
        return [f'pl_CountAliveMonsExcept {tr.var(var)}, {tr.var(slot)}']
    tr.job.stubs[f'{name} (slot from a var)'] += 1
    return [f'pl_stub {name}  // Pearl {name} {var}, {slot}: the left-out slot from a var']


@handler('GetHour')
def h_get_hour(tr, a, vals, name):
    """Pearl 0x268 GetHour var (the clock's hour, 0-23) = Black 2's RTCGetTime hour, minute (ov012
    scrcmd_game_state.c s00D1_RTCGetTime: the same clock); the minute goes to the library's scratch work. The Seven
    Stars Restaurant's trainers are there from 9 to 22 (2026-10-25, chapter 5a)."""
    return [f'RTCGetTime {tr.var(vals[0])}, PL_TMP  // Pearl GetHour (the minute in PL_TMP)']


# Chapter 9b (2026-10-26; the macros' notes in pearl_story.inc "Chapter 9b"): the Hallowed Tower's Spiritomb counter
# (the Hideaways' battles: PVAR_UG_HIDEAWAY_BATTLES), Route 221's daily level (from the date) and party level, the
# Trophy Garden's daily Pokémon (PVAR_TROPHY_GARDEN_1/2; the wild slots are the encounter code's)
for _pl, _fmt in [('GetSpiritombCounter', ('var',)), ('ClearSpiritombCounter', ()),
                  ('GetDailyRandomLevel', ('var',)), ('GetPartyMonLevel', ('var', 'var')),
                  ('AddTrophyGardenMon', ()), ('GetTrophyGardenSlot1Species', ('var',))]:
    HANDLERS[_pl] = simple(f'pl_{_pl}', *_fmt)


@handler('PressPastoriaGymButton')
def h_pastoria_button(tr, a, vals, name):
    """Pearl 0x170 CheckPastoriaGymButton (pokeplatinum PastoriaGym_PressButton): the button under the player moves
    the Pastoria Gym's water to its height and the script waits (Pearl's field task). Here the decomp's
    src/pearlb2/pastoria_gym_itcm.c (gimmick 30, patches/pastoria_gym.py) moves it; pl_PressPastoriaGymButton asks
    through PVAR_PASTORIA_GYM_PRESS and waits (2026-10-25, chapter 5a)."""
    return ['pl_PressPastoriaGymButton  // Pearl CheckPastoriaGymButton: the water moves (pastoria_gym_itcm.c)']


@handler('InitPersistedMapFeaturesForPastoriaGym')
def h_pastoria_init(tr, a, vals, name):
    """Pearl 0x16F InitPastoriaGym (the zone's on-transition script): the water starts at the middle (Pearl's green
    button). The same script sets the three button works to say so, and the gym's gimmick reads them when the field
    starts (pastoria_gym_itcm.c): nothing to do here (2026-10-25, chapter 5a)."""
    return ['// InitPastoriaGym: the water at the middle; the button works below say so (pastoria_gym_itcm.c reads them)']

@handler('StartEndSafariGame')
def h_safari(tr, a, vals, name):
    """Pearl 0x202 EnableDisableSafariZone 0 (start) / 1 (end): Pearl's Safari Game (Safari Balls, a 500-step limit,
    its own battle screen). Black 2 has none, so the Great Marsh is a normal area (user 2026-10-25: "for safari port it
    over how we did in hoenn", HoennB2 DECISIONS 2026-10-07): the start puts Pearl's 30 Safari Balls in the Bag (Black
    2's Safari Ball is a Poke Ball with a 1.5x catch rate; Pearl's own lines say "received 30 Safari Balls"), the end
    takes the ones left (Pearl: "I'll relieve you of your remaining Safari Balls"). No step count or timer
    (2026-10-25, chapter 5a)."""
    tr.job.approx['StartEndSafariGame (the Great Marsh as a normal area: Safari Balls as items, no step count)'] += 1
    return ['pl_SafariStart  // Pearl EnableDisableSafariZone 0: 30 Safari Balls into the Bag' if vals[0] == 0 else
            'pl_SafariEnd  // Pearl EnableDisableSafariZone 1: the Safari Balls left are taken back']


@handler('GetPCBoxesFreeSlotCount')
def h_pc_free(tr, a, vals, name):
    """Pearl 0x252 CountPCFreeSpace var: the free slots in the PC boxes = Black 2's BoxGetCount kind 5 (720 minus the
    Pokemon in the boxes; ov012 scrcmd_pokemon.c). Kind 4 is not a kind: it answers 0 (2026-10-25, chapter 5a)."""
    return [f'BoxGetCount {tr.var(vals[0])}, 5  // Pearl CountPCFreeSpace: free PC box slots']

# ---- Spear Pillar (2026-10-26, chapter 7)
@handler('20D')
def h_spear_pillar(tr, a, vals, name):
    """Pearl 0x20D SpearPillarSequence op, var (pokediamond ov06 SpearPillarSequence): Pearl's effects of the summoning
    (pl_SpearPillarSequence: white flashes; the polls report "over" at once, or the script loops forever)."""
    tr.job.approx['SpearPillarSequence (Pearl\'s summoning effects: white flashes; the sky\'s distortion not shown)'] += 1
    if tr.levels(a) - {0} and vals[0] in (0, 4, 5):    # (no screen fades in a map script)
        return [f'// Pearl SpearPillarSequence {vals[0]} in a map script: no flash there']
    return [f'pl_SpearPillarSequence {vals[0]}, {tr.var(vals[1])}  // Pearl SpearPillarSequence {vals[0]}']


@handler('18C')
def h_event_dir(tr, a, vals, name):
    """Pearl 0x18C SetEventDirection object, dir (pokediamond ScrCmd_SetEventDirection: the live object, or the player
    255, turns at once): a FACE move (Pearl's FACE_NORTH..EAST 0-3 = Black 2's, the directions' numbers)."""
    uid, d = vals
    if tr.levels(a) - {0}:
        tr.job.approx['SetEventDirection in a map script (Black 2 moves no actor there)'] += 1
        return [f'// SetEventDirection {uid}, {d} in a map script: Black 2 moves no actor there (left out)']
    if d >= 4:
        tr.job.stubs['SetEventDirection (the direction from a var)'] += 1
        return [f'pl_stub SetEventDirection  // {uid}, {tr.var(d)}']
    return [f'pl_ApplyMovement {actor(tr, uid)}, .Lfacee{a:x}  // SetEventDirection {uid}, {d}: turns at once',
            'pl_WaitMovement', f'VMJump .Lfacee{a:x}_end', '.balign 4, 0', f'.Lfacee{a:x}:', f'    Move {d}, 1',
            '    MoveEnd', f'.Lfacee{a:x}_end:']


@handler('HideObject', 'ShowObject')
def h_hide_show(tr, a, vals, name):
    """Pearl 0x1B2 HideObject / 0x1B1 ShowObject: the object (or the player) stays but is not drawn / is drawn again
    (Spear Pillar hides Palkia's place and the player during the vistas). Black 2 moves no actor in a map script (a
    field-load or zone-init script: ActorCmdExec hangs there, b2_script_check): there it is left out (the GTS's
    on-resume script hides the player coming back from the trade machine)."""
    if tr.levels(a) - {0}:
        tr.job.approx[f'{name} in a map script (Black 2 moves no actor there)'] += 1
        return [f'// Pearl {name} {vals[0]} in a map script: Black 2 moves no actor there (left out)']
    return [f'pl_{name} {actor(tr, vals[0])}  // Pearl {name} {vals[0]}']


# ---- the Galactic HQ lab's containment units (2026-10-26, chapter 7; b2tools/pearl_lab_units.py)
FREED_TRIO_FLAG = 0x97D             # Pearl's FLAG_FREED_GALACTIC_HQ_POKEMON (set by the lab's button)


@handler('InitLakeGuardianContainmentUnits', 'DeactivateLakeGuardianContainmentUnits')
def h_lab_units(tr, a, vals, name):
    """Pearl 0x25E / 0x25F (pokeplatinum lake_guardian_containment_units.c): the units' glass shown gone after the
    release (the lab's on-resume script) / the glass's opening animation played and waited for (the button). Black 2:
    model 496's record plays Pearl's opening as its animation 0 (pearl_lab_units): the button takes a handle per unit,
    plays it, waits, holds the shared instance on its last frame (BMAnmPlayInv) and lets the handles go; the
    on-resume script holds the last frame when the flag is set. The band's scroll is not ported (pearl_lab_units)."""
    import pearl_lab_units as U
    spots = U.tiles(tr.job.zone['matrix'])
    if not spots:
        tr.job.approx[f'{name} (no containment unit in the zone)'] += 1
        return [f'// Pearl {name}: no containment unit (build model {U.UNIT}) in this zone']
    tr.job.approx[f'{name} (the band\'s scroll not shown)'] += 1
    x0, z0 = spots[0]
    if name.startswith('Init'):
        if 2 in tr.levels(a):                 # (BMAnmPlayInv: levels 0 and 1)
            return [f'// Pearl {name} in a zone init: Black 2 animates no prop there (left out)']
        return [f'pl_CheckFlag {tr.flag(FREED_TRIO_FLAG)}  // Pearl {name}: after the release the units stay open',
                f'pl_GoToIf 5, .Lunits{a:x}',
                f'BMAnmPlayInv {U.PROP_KIND}, {x0}, {z0}  // every unit (one shared instance) on the last frame',
                f'.Lunits{a:x}:']
    if tr.levels(a) - {0}:
        return [f'// Pearl {name} in a map script: Black 2 takes no prop handle there (left out)']
    assert len(spots) <= len(U.HANDLE_TAGS), spots
    tags = U.HANDLE_TAGS[:len(spots)]
    out = [f'// Pearl {name}: the units open (Pearl\'s animation 49: the glass shrinks away)']
    out += [f'BMCreateHandleByGPos PL_DOOR({t}), {U.PROP_KIND}, {x}, {z}' for t, (x, z) in zip(tags, spots)]
    out += [f'BMHndAudioVisualAnmPlay PL_DOOR({t}), 0' for t in tags]
    out += [f'BMHndAnmWait PL_DOOR({tags[-1]})',
            f'BMAnmPlayInv {U.PROP_KIND}, {x0}, {z0}  // the units keep the last frame when the handles go']
    out += [f'BMReleaseHandle PL_DOOR({t})' for t in tags]
    return out


@handler('CheckHasTwoAliveMons')
def h_two_alive(tr, a, vals, name):
    return [f'pl_CheckHasTwoAliveMons {tr.var(vals[0])}']


@handler('CheckDidNotCapture')
def h_did_not_capture(tr, a, vals, name):
    """Pearl 0x2BC (pokediamond ScrCmd_Unk02BC -> sub_020480D8: 0 only if the Pokémon was caught, else 1; Platinum's
    CheckDidNotCapture): Spear Pillar's Palkia (not caught: it comes back after the Hall of Fame, file 192). The macro
    is chapter 6b's (Black 2's wild battle result); 0xED CheckLostBattle is a different test (6b's handler)."""
    return [f'pl_CheckDidNotCapture {tr.var(vals[0])}  // Pearl 0x2BC: 1 unless caught']


@handler('SetBGMFixed')
def h_bgm_fixed(tr, a, vals, name):
    """Pearl 0x58 (pokediamond ScrCmd_Unk0058 -> sub_020040F4: the music kept over map changes, 1 on, 0 off): Black 2
    changes to the zone's music on every map change, so a warp continuation that Pearl runs with the music kept plays
    that song again when it starts (fixed_music)."""
    tr.job.approx['SetBGMFixed (the song played again after each warp: fixed_music)'] += 1
    return [f'// SetBGMFixed {vals[0]}: the music {"kept over the next warps" if vals[0] else "follows the zone again"} '
            f'(fixed_music)']


@handler('Unused_2C3')
def h_scope_mode(tr, a, vals, name):
    tr.job.approx['ScopeMode (Pearl\'s flag for the vistas\' map loads: nothing in Black 2)'] += 1
    return [f'// ScopeMode {vals[0]} (pokediamond ScrCmd_ScopeMode, field 0xB4): nothing in Black 2']


@handler('SetSubScene63')
def h_sub_scene63(tr, a, vals, name):
    tr.job.approx['SetSubScene63 (Pearl\'s sound sequence SEQ_PV001 for the Red Chain: none)'] += 1
    return ['// Pearl 0x5D (pokediamond ScrCmd_Unk005D: sound sequence SEQ_PV001 as a sub-scene): nothing in Black 2']


def fixed_music(pd, f, after):
    """The song a warp continuation of Pearl file f starting at `after` must play again (or None): Pearl keeps the music
    over map changes after SetBGMFixed 1 (Spear Pillar's vistas: THE_EVENT03 over Valley Windworks and Hearthome and
    back at Spear Pillar), Black 2 plays the new zone's. The setting and the last song are the last ones before
    `after` in file f's code, in address order from the script it belongs to; a continuation that plays a song itself
    before anything else is left alone."""
    d = pd.disasm(f)
    entry = max((e for e in d.entries if e <= after), default=0)
    fixed, song = 0, None
    for a in sorted(d.insns):
        if not entry <= a < after:
            continue
        e, op, args = d.insns[a]
        nm = pd.cmd_name(op)
        if nm == 'SetBGMFixed':
            fixed = args[0][1]
        elif nm in ('PlayMusic', 'SetBGM'):
            song = args[0][1]
    if not fixed or song is None:
        return None
    for a in sorted(x for x in d.insns if x >= after):
        nm = pd.cmd_name(d.insns[a][1])
        if nm in ('PlayMusic', 'SetBGM'):
            return None
        if nm in ('Warp', 'End', 'PlayDefaultMusic'):
            break
    return song


# ---------------------------------------------------------------- whole files

def musical_lines():
    """The Musical's lines (MUSICAL), in the order of pearl_musical.inc's MUSL_* (checked)."""
    lines = json.load(open(MUSICAL))['lines']
    order = {int(n): name for name, n in re.findall(r'^#define MUSL_(\w+) (\d+)', open(MUSICAL_INC).read(), re.M)
             if name != 'COUNT'}
    assert [m['id'] for m in lines] == [order[n] for n in sorted(order)], \
        f'{MUSICAL}: the ids are not pearl_musical.inc\'s MUSL_* order'
    return lines


def translate(pd, zone, ids):
    """(source lines, Black 2 text lines, job) for a Pearl zone's script file."""
    job = Job(pd, zone, ids)
    f = zone['scripts']
    main = FileTr(job, f, zone['text_bank'])
    body = main.lines()
    pid = zone['id']
    newgame = zone['name'] == NEWGAME_ZONE
    arrive_ids, arrive = pd.arrival_ids(pid)
    conts = []
    for sf, a, after, sbank in pd.warp_continuations(pid):
        k = arrive_ids[(sf, a)]
        label = f'W{sf}_{a:04X}_S'
        tr = FileTr(job, sf, sbank, mode='warp', starts=[(label, after, None)], prefix=f'W{sf}_{a:04X}')
        code = tr.lines()
        song = fixed_music(pd, sf, after)          # (SetBGMFixed: Pearl kept the music over the map change)
        if song is not None:
            at = code.index(f'{label}:') + 1
            code[at:at] = ['// the music Pearl kept over the map change (SetBGMFixed, fixed_music):'] + \
                [l if l.startswith(('#', ' ')) else '    ' + l for l in h_sound(tr, after, [song], 'PlayMusic')]
        conts.append((k, label, ['', f'// ---- continuation {k}: after the Warp at {sf}:{a:04X} '
                                     f'({next((z["name"] for z in pd.zones if z["scripts"] == sf), "a common script")})']
                      + code))
    if newgame:
        job.label_common(PEARL_NEW_GAME_SCRIPT)
    blackout = job.label_common(PEARL_BLACKOUT_HOME_SCRIPT) if zone['name'] == BLACKOUT_HOME_ZONE else None
    # proxies: Pearl global scripts this zone's people, signs and triggers run
    import pearl_events
    ev = job.events
    talkers = {o['script'] for o in ev['object_events']}
    proxies = []
    for gid in pearl_events.proxies(ev, pd, zone):
        label = job.label_common(gid, 'proxytalk' if gid in talkers else 'common')
        k = pd.proxy_ids()[gid]
        if job.init_level.get(k, 0):
            cf, _, centry = script_location(gid)
            job.level_commons[(cf, centry)] = job.init_level[k]
        proxies.append((k, f'PearlProxy_{gid}', ['', f'PearlProxy_{gid}:                  // Pearl global script {gid} '
                                                    f'(run by this zone\'s events)', f'    VMCall {label}', '    VMHalt']))
    subs, done = [], set()
    while job.common_queue:
        cf, bank, entry, mode = job.common_queue.pop(0)
        if (cf, entry, mode) in done:
            continue
        done.add((cf, entry, mode))
        d = pd.disasm(cf)
        pre = f'{"C" if mode == "common" else "T"}{cf}_{entry}'
        sub = FileTr(job, cf, bank, mode=mode, starts=[(f'{pre}_S{entry}', d.entries[entry - 1], entry)], prefix=pre)
        if (cf, entry) in job.level_commons:            # run by a map script (above): its level
            sub.force_levels = {job.level_commons[(cf, entry)]}
        subs += ['', f'// ---- Pearl global script {cf}:{entry} (a subroutine here)'] + sub.lines()
    n = len(main.d.entries)
    entry_label = {k: f'P{f}_S{k}' for k in range(1, n + 1)}
    entry_label.update({k: label for k, label, _ in conts})
    entry_label[arrive] = 'PearlArrive'
    entry_label.update({k: label for k, label, _ in proxies})
    if newgame:
        entry_label.update({k: f'PearlNewGame_{k}' for k in NEWGAME_ENTRIES})
    if blackout:
        assert BLACKOUT_ENTRY not in entry_label and BLACKOUT_ENTRY < FIRST_PROXY, entry_label
        entry_label[BLACKOUT_ENTRY] = 'PearlBlackoutHome'
    closed = []                                     # data/pearl_closed_facilities.json (CLOSED)
    musical = None                                  # the zone's first Musical line (a musical row: MUSICAL)
    for i, (k, row) in enumerate(zip(pd.closed_ids(pid), pd.closed(zone))):
        line = job.line_text(('musical', 'greeting', row['text']) if row.get('musical') else ('closed', i),
                             row['text'].replace('\n', '\\n'))    # (the same greeting: one line)
        dir_ = 255 if row.get('talk') else row['dir']
        entry_label[k] = f'PearlClosed_{i}'
        what = (f'object {row["obj"]}' if 'obj' in row else f'sign {row["bg"]}') if row.get('talk') else \
            f'trigger ({row["x"]}, {row["z"]}) {row["w"]}x{row["h"]}'
        if row.get('musical'):
            assert row.get('talk') and 'obj' in row, f'{zone["name"]}: a Musical row is a person: {row}'
            if musical is None:
                musical = [job.line_text(('musical', m['id']), m['text'].replace('\n', '\\n'))
                           for m in musical_lines()][0]
            closed += ['', f'PearlClosed_{i}:                  // the Pokémon Musical\'s reception (data/pearl_closed_'
                           f'facilities.json "musical"): {what}', f'    pl_musical_reception {line}, {musical}', '    VMHalt']
            continue
        closed += ['', f'PearlClosed_{i}:                  // a closed place (data/pearl_closed_facilities.json): {what}',
                   f'    pl_closed_facility {line}, {dir_}', '    VMHalt']
    elev = pd.elevator_init(pid)                    # ELEVATOR_FLOORS_ABOVE: an elevator's floor or room
    if elev:
        entry_label[elev[0]] = 'PearlElevatorInit'
        closed += ['', 'PearlElevatorInit:                // zone init (after Pearl\'s): an elevator (ELEVATOR_FLOORS_ABOVE)']\
            + elev[1]
    objs = {o['id']: o for o in ev['object_events']}
    for uid, k in pd.item_ball_ids(pid).items():   # data/pearl_item_balls.json: Pearl's own item-ball script
        o = objs[uid]
        row = pearl_events.item_ball(zone, o)
        item = item_ball_item(pd, o['script'])
        assert item == row['item'], f'{zone["name"]} object {uid}: Pearl\'s script {o["script"]} gives item {item}, ' \
                                    f'data/pearl_item_balls.json says {row["item"]}'
        label = job.label_common(o['script'])
        entry_label[k] = f'PearlItemBall_{uid}'
        closed += ['', f'PearlItemBall_{uid}:                // item ball (data/pearl_item_balls.json): object {uid}, '
                       f'Pearl script {o["script"]} (item {item})', f'    VMCall {label}', '    VMHalt']
    rids = pd.ramanas_ids(pid)                      # Ramanas Park in Pal Park (b2tools/ramanas.py): the gate's
    if rids:                                        # slate clerk and walk-out, the park attendant's line in a visit
        import ramanas
        for name, k in rids.items():
            entry_label[k] = f'RamanasExtra_{name}'
        closed += ramanas.extra_code(job, pd, zone, rids)
    tb = pd.turnback_doors(pid)                     # Turnback Cave's maze: the doors after each arrival
    if tb:
        import turnback
        entry_label[tb] = 'TurnbackDoors'
        closed += turnback.doors_code(pid)
    ending = pd.game_clear_ids(pid)                 # GAME_CLEAR_ZONE: Black 2's game clear's two ending scripts
    if ending:
        entry_label[ending[0]] = 'PearlEndingBeforeCredits'
        entry_label[ending[1]] = 'PearlEndingAfterCredits'
        closed += ['', 'PearlEndingBeforeCredits:          // Black 2\'s game clear, before the credits (GAME_CLEAR_ZONE): '
                       'the screen stays black,', '    BGMPlay SEQ_BGM_ENDING     // the ending song (Black 2\'s: Pearl\'s '
                       'is not installed)', '    VMHalt',
                   '', 'PearlEndingAfterCredits:           // Black 2\'s game clear, after the credits: nothing (THE END '
                       'follows)', '    VMHalt']
    while job.common_queue:                         # (the item balls' sub-scripts, queued just above)
        cf, bank, entry, mode = job.common_queue.pop(0)
        if (cf, entry, mode) in done:
            continue
        done.add((cf, entry, mode))
        d = pd.disasm(cf)
        pre = f'{"C" if mode == "common" else "T"}{cf}_{entry}'
        sub = FileTr(job, cf, bank, mode=mode, starts=[(f'{pre}_S{entry}', d.entries[entry - 1], entry)], prefix=pre)
        subs += ['', f'// ---- Pearl global script {cf}:{entry} (a subroutine here)'] + sub.lines()
    head = [f'// {zone["name"]}: Pearl script file {f}, text bank {zone["text_bank"]}. Written by b2tools/pearl_story.py:',
            '// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).',
            f'// Scripts 1-{n}: Pearl\'s; {", ".join(f"{k}: after a Warp" for k, _, _ in conts) or "no warp continuations"}; '
            f'{arrive}: PearlArrive' + ('; 29-31: the new game' if newgame else '') +
            (f'; {BLACKOUT_ENTRY}: after a black-out (Pearl {PEARL_BLACKOUT_HOME_SCRIPT})' if blackout else '') +
            (f'; {", ".join(f"{k}: Pearl {l[11:]}" for k, l, _ in proxies)}' if proxies else ''),
            '#include "asm/field_script.inc"', '#include "pearl.h"', '#include "pearl_story.inc"'] + \
        (['#include "pearl_musical.inc"'] if musical is not None else []) + ['']
    for k in range(1, max(entry_label) + 1):
        head.append(f'    ScriptEntry {entry_label.get(k, "PearlNoScript")}')
    head += ['    ScriptEntriesEnd', '']
    tail = ['', 'PearlNoScript:', '    VMHalt', '',
            'PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release',
            '    FadeInBlack', '    FadeWait', '    FinishAllEvents', '    ActorsUnpauseAll', '    VMHalt']
    if blackout:
        tail += ['', f'PearlBlackoutHome:                // after a black-out at home: Pearl\'s common script {PEARL_BLACKOUT_HOME_SCRIPT}',
                 f'    VMCall {blackout}', '    VMHalt']
    if newgame:
        z0, x0, z_0, d0 = PEARL_START
        start = pd.by_name[z0]
        _, start_arrive = pd.arrival_ids(start['id'])
        tail += ['', f'#define PEARL_START_ZONE {pd.b2_zone[start["id"]]}   // {z0}',
                 f'#define PEARL_START_X {x0}', f'#define PEARL_START_Z {z_0}', f'#define PEARL_START_DIR {d0}',
                 f'#define PEARL_START_ARRIVE {start_arrive}   // its PearlArrive', '#include "pearl/newgame.inc"']
    src = head + body + [l for _, _, c in conts for l in c] + [l for _, _, c in proxies for l in c] + closed + subs + tail + \
        ['', '    .balign 4, 0', '']
    text = [job.gen4_text.b2_line(t, v) for t, v in job.text]
    return src, text, job


def slug(name):
    return name[4:].lower() if name.startswith('MAP_') else name.lower()


def write_zone(pd, ids, zone):
    src, text, job = translate(pd, zone, ids)
    num, tnum = pd.script_file(zone), pd.text_file(zone)
    base = f'pearl_{slug(zone["name"])}'
    for d, n, ext in ((SRC_SCRIPTS, num, '.s'), (SRC_TEXT, tnum, '.txt')):
        os.makedirs(d, exist_ok=True)
        for old in os.listdir(d):
            if old.startswith(f'{n:04d}_') and old != f'{n:04d}_{base}{ext}':
                raise SystemExit(f'{d}/{old} already has number {n}')
    p = os.path.join(SRC_SCRIPTS, f'{num:04d}_{base}.s')
    open(p, 'w').write('\n'.join(src))
    tp = os.path.join(SRC_TEXT, f'{tnum:04d}_{base}.txt')
    pre = 'Pearl' + ''.join(w.capitalize() for w in slug(zone['name']).split('_'))
    open(tp, 'w', encoding='utf-8').write(''.join(f'{pre}_Text_{i:03d} = {t}\n' for i, t in enumerate(text)))
    return p, tp, job


def assemble(path):
    sys.path.insert(0, os.path.join(HERE, 'patches'))
    import scripts
    return scripts.assemble(path)


def summary(job):
    s = f'{job.name}: {sum(job.done.values())} commands translated'
    if job.stubs:
        s += f', {sum(job.stubs.values())} stubbed ({", ".join(f"{k} x{v}" for k, v in job.stubs.most_common())})'
    if job.approx:
        s += f'; approximated: {", ".join(f"{k} x{v}" for k, v in job.approx.most_common())}'
    return s


def zone_arg(pd, a):
    return pd.zones[int(a)] if a.isdigit() else pd.by_name[a if a.startswith('MAP_') else 'MAP_' + a.upper()]


def _decodes(pd, f):
    try:
        pd.disasm(f)
        return True
    except Exception:
        return False


def report(pd, ids):
    """Translate every Pearl zone's script file offline, assemble each, count translated and stubbed commands."""
    os.makedirs(OFFLINE, exist_ok=True)
    done, stub, approx = collections.Counter(), collections.Counter(), collections.Counter()
    per_file, bad, seen = [], [], set()
    status = {}
    for z in pd.zones:
        if z['scripts'] in seen:
            continue
        seen.add(z['scripts'])
        try:
            src, text, job = translate(pd, z, ids)
        except Exception as e:          # one file's problem must not hide the others' results
            bad.append(f'{z["name"]} (file {z["scripts"]}): {type(e).__name__}: {e}')
            continue
        p = os.path.join(OFFLINE, f'{z["scripts"]:04d}_{slug(z["name"])}.s')
        open(p, 'w').write('\n'.join(src))
        try:
            assemble(p)
        except BaseException as e:
            bad.append(f'{z["name"]} (file {z["scripts"]}): does not assemble: {str(e)[:300]}')
        status.update(job.insn_status)
        done.update(job.done)
        stub.update(job.stubs)
        approx.update(job.approx)
        per_file.append(summary(job))
    nd, ns = sum(done.values()), sum(stub.values())
    # every Pearl command once (a common script counts once, not once per zone that calls it)
    ud = sum(1 for n, s in status.values() if s == 'done')
    us = collections.Counter(n for n, s in status.values() if s == 'stub')
    total = sum(len(pd.disasm(f).insns) for f in range(len(pd.files)) if pd.files[f] and f not in pd.level_files
                and _decodes(pd, f))
    out = [f'{len(seen)} Pearl zone script files translated offline (common scripts inside the zones that call them), '
           f'{len(bad)} with problems',
           f'command uses: {nd} translated, {ns} stubbed ({100 * nd / max(1, nd + ns):.1f} % translated); '
           f'{len(done)} commands translated, {len(stub)} stubbed',
           f'Pearl\'s own commands, each once: {ud} translated, {sum(us.values())} stubbed '
           f'({100 * ud / max(1, ud + sum(us.values())):.1f} %), of {total} decoded in all of Pearl\'s script files '
           f'({total - ud - sum(us.values())} are in code no zone, warp or person reaches: unused scripts, the extra '
           f'End after a GoTo, files of features no zone uses)', '',
           'stubbed, each Pearl command once:'] + [f'  {k}: {v}' for k, v in us.most_common()] + ['',
           'stubbed (uses in the translated files; a common script counts in every zone that calls it):']
    out += [f'  {k}: {v}' for k, v in stub.most_common()]
    out += ['', 'approximated (uses):'] + [f'  {k}: {v}' for k, v in approx.most_common()]
    out += ['', 'problems:'] + [f'  {b}' for b in bad] + ['', 'per file:'] + [f'  {s}' for s in per_file]
    open(os.path.join(OFFLINE, 'report.txt'), 'w').write('\n'.join(out) + '\n')
    print('\n'.join(out[:4]))
    print(f'full report: {os.path.relpath(os.path.join(OFFLINE, "report.txt"), ROOT)}')
    return 0


# every handler is registered: the item arguments of ITEM_ARG's commands go through item_value
for _n, _k in ITEM_ARG.items():
    if _n in HANDLERS:
        HANDLERS[_n] = _item_handler(HANDLERS[_n], _k)


def main(argv):
    import pearl_ids
    pd = PearlData()
    ids = pearl_ids.Ids()
    if argv[:1] == ['show']:
        f = int(argv[1])
        z = next(z for z in pd.zones if z['scripts'] == f)
        src, text, job = translate(pd, z, ids)
        print('\n'.join(src))
        print(summary(job), file=sys.stderr)
        return 0
    if argv[:1] in (['zones'], ['chapter']):
        for a in (CHAPTERS[int(argv[1]) if argv[1].isdigit() else argv[1]] if argv[0] == 'chapter' else argv[1:]):
            p, tp, job = write_zone(pd, ids, zone_arg(pd, a))
            assemble(p)
            print(f'{os.path.relpath(p, ROOT)} + {os.path.relpath(tp, ROOT)}: {summary(job)}')
        return 0
    if argv[:1] == ['report']:
        return report(pd, ids)
    print(__doc__)
    return 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
