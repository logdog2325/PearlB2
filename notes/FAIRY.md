# Fairy type and Rowan's start-of-game questions (Pearl NDS)

User's choice (2026-10-18, question 4): "Rowan's start-of-game questions: Fairy type, music, and CLASSIC/NEW sprites
(once the NEW sprites exist)". The Fairy system is HoennB2's (fairy_core + fairy_ui, 2026-10-08), ported so that
everything a Pokémon, a move or a link battle carries means the same in Pearl NDS and the Hoenn games (notes/LINK.md).
HoennB2's own design document follows below ("HoennB2's design document"); its research is notes/FAIRY_SCOPE.md.

## Pearl NDS port (2026-10-18)

### The same as HoennB2 (link battles and trades)
| What | Value |
|---|---|
| Types | 17 = Fairy, 18 = "no type" (Black 2's 17) |
| Fairy moves | 560 Fairy Wind, 561 Disarming Voice, 562 Draining Kiss, 563 Dazzling Gleam, 564 Play Rough, 565 Moonblast; Sweet Kiss, Charm, Moonlight retyped Fairy |
| Fairy items | 113 Pixie Plate, 114 Fairy Gem |
| Species | the 22 Gen 6 retypes (Clefairy, Togepi, Ralts, Marill, Mr. Mime ... lines) |
| Options u16 (trainer-data save block, SaveControl block 27) | bit 11 = Fairy on, bit 12 = classic split, bit 13 = home-region music (Hoenn's there, Sinnoh's here), bit 14 = NEW sprites (later), bit 15 = seasons (1 = Black 2's by the DS clock; HoennB2's bit, same meaning; Pearl's 0 = Pearl's own look all year, HoennB2's 0 = summer) |
| Link battles | fairy.c gLinkRules, unchanged: the battle's server machine sends its bits 11-12 in the spare nibble of the pre-battle sync (byte 0x1f of BtlMainSyncData), both machines battle by them |
| Learnsets | HoennB2's additions (Ralts line, Marill line, Jigglypuff, Wigglytuff, Mawile, Swablu, Altaria, Luvdisc; egg moves Ralts, Absol) |

Pearl is a Gen 4 game, so Rowan never asks the split question: bit 12 stays 0 in every Pearl save. The code still
honours it, so a link battle hosted by a Hoenn game with the classic split plays the classic split on both machines.

### Different from HoennB2
- **Where the questions are.** HoennB2 asks Birch's questions in ASK_RIVAL_NAME, free there because HoennB2 dropped the
  rival naming. Pearl keeps the rival naming (Barry) and every one of the 14 intro scripts runs. So the farewell script
  (sScripts[12], after "Barry, is it?", 11 entries in ov294) is rebuilt in ITCM with the questions after its SAVE_WAIT
  and before "All right, {player}, the time has come" (`b2tools/patches/pearl_intro.py` QUESTIONS,
  `src/code/rowan_questions.c` kRowanFarewell, 19 entries); sScripts[12] points there. Intro command 31 (Black 2's unused
  INTRO_CMD_SET_MSG_LANGUAGE) is HoennB2's Intro_SetConfigBit, now in rowan_questions.c (installed by pearl_intro, so a
  build without fairy never runs Black 2's SetMsgLanguage with a bit number).
- **Seasons** (bit 15, Rowan's fourth question, 2026-10-19): HoennB2 locks Hoenn to summer and bit 15 lifts the lock;
  Pearl had real seasons, so bit 15 = 1 keeps them and 0 fixes the season to spring, Pearl's own look
  (`b2tools/patches/season_choice.py`, below).
- **No shop yet.** HoennB2 sells the two items at Lilycove's Dept. Store; in Pearl's world Black 2's shop 15 is an herb
  seller, so fairy.py SHOP_ID is None (no list file, no ov036 hook; the items exist and work when held).
- `b2tools/itcm.py` installs the code (after sinnoh_encounters, sinnoh_music, pearl_rods and pearl_intro).
- The test switches are PEARL_TEST_FAIRY_SELFTEST / PEARL_TEST_FAIRY_UI.

### Rowan's questions
After the rival is named, in Rowan's words (data/text_overrides/pearl_intro.json, game_start lines Black 2 leaves blank),
in the order Fairy, music, Exp. Share, seasons (user 2026-10-19):

> **26** Before you go, four questions. / You can't change them later. / Will you meet the new Fairy type on your
> journey? — YES (bit 11 = 1) / NO
>
> **27** Would you hear the songs of Sinnoh, or of faraway Unova? — **28** SINNOH (bit 13 = 1) / **30** UNOVA
>
> **36** The Exp. Share gives Exp. Points / to your whole team. / Will you set out with one? — YES (flag PFLAG_010B
> = 329 set: the Exp. Share in the Bag from the start, switched on) / NO (Pearl's gift at the Route 206 north gate)
>
> **37** Last, would you see the seasons / change with the months? — YES (bit 15 = 1: Black 2's seasons by the DS
> clock) / NO (bit 15 = 0: spring all year, Pearl's own look)

(The shorter wording, the user's choice 2026-10-19; the first version explained Clefairy and Togepi.) The cursor starts
on YES / SINNOH (mashing A, as the test tools do, gives Fairy on, Sinnoh's music, the Exp. Share and Black 2's seasons);
B answers the second choice. Lines 31, 34 and 35 are still blank for the sprite question (CLASSIC / NEW, bit 14), which
needs the NEW sprites first (HoennB2's sprite_switch). Text 54 packs to 4,220 B, under Black 2's own 4,684 B (the intro
holds the whole file; pearl_intro.measure_text() stops the build above it): 464 B left, enough for the sprite question.

**Options bits** (the u16 at the start of save block 27): 0-10 Black 2's (pokebw2 include/save/config.h), 11 Fairy,
12 classic split (HoennB2 only; Pearl leaves it 0: link battles send bits 11-12), 13 music, 14 sprites (later), **15
seasons**: HoennB2's seasons bit, with the same meaning (1 = Black 2's seasons by the clock). The Exp. Share needs no
bit: its Bag switch has to be a flag anyway, so the answer is a flag too (as HoennB2's sixth question). Not used: the
Config's second u16 (`unk2`): no accessor in config.c reads or writes it, but it travels in battle recordings
(ov273 copies the whole Config) and the decomp does not cover every overlay, so nothing proves it free.

**How the answers are stored**: intro command 31 (Intro_SetConfigBit, src/code/rowan_questions.c): an argument < 16 is
an options bit (the new game's Config and the save's copy), >= 16 an event flag in the save's EventWork (HoennB2's
code; NewGame_Init cleared the save before the intro and nothing clears EventWork after it).

### The Exp. Share answer (`b2tools/patches/exp_share.py`, `src/code/exp_share.c`, `data/text_overrides/exp_share.json`)
HoennB2's Gen 6 Exp. Share (a key item, switched on and off with Use in the Bag; the whole party gets half exp; one
"The rest of your team gained Exp. Points thanks to the Exp. Share!" line), with Pearl's flags instead of HoennB2's
FLAG_EXP_SHARE_ON: it works while **PFLAG_010B** (Pearl's FLAG_RECEIVED_ROUTE_206_CYCLING_ROAD_NORTH_GATE_EXP_SHARE)
is set and **PFLAG_EXP_SHARE_OFF** (1053, new: b2tools/pearl_ids.py NEW_FLAGS) is clear (ExpShare_IsOn in ITCM).
- YES: the intro sets PFLAG_010B; the new game's Bag gets the Exp. Share (ov035 EventFieldFirst_Create's `bl
  InitItemBag` -> NewGame_InitBag: Black 2's Bag, then item 216 when the flag is set; the Bag is only made there,
  after the intro). The Route 206 north gate's scientist then acts as after his gift: Pearl's own map script hides him
  once the flag is set.
- NO: Pearl's gift as Pearl has it (the scientist sets PFLAG_010B and gives item 216, now this key item); the off flag
  is clear, so it is switched on as Gen 6 gives it. No script or generator change.
- Text: the Bag's two lines (system file 6, ids 161/162), the team line (files 17 and 19, id 221; file 19 gets 20
  filler lines first, as HoennB2's has them), the Bag's description (rewritten: Black 2's says the item is held).

### The seasons answer (`b2tools/patches/season_choice.py`, `src/code/season_choice.c`)
Black 2 decides the season in Season_GetRealTime ((month - 1) % 4, pokebw2 src/system/season.c) and keeps it at
GameData +0x1c8 (GameData_GetSeason, src/system/game_data.c), the same two sites HoennB2's hoenn_season/fairy hook. Both
call ITCM readers: with bit 15 set they give Black 2's own answer, with it clear **spring** (0) in every month, so the
kept season and the clock's always agree (no season card, no change on warps). Spring, not summer: both are Pearl's own
look (sinnoh_reskin keeps Pearl's own textures in both; light tables 140 and 141 are the same), and spring's day-period
hours are the closest to Pearl's (Black 2 spring: morning 5, day 10, evening 17, night 20; summer 4, 9, 19, 21; Pearl
4, 10, 20). SEASON_OFF=1 at build time gives summer. The snowy north stays winter in both answers (its sets are the same
in all four seasons). Before a save exists (title, intro) the bit reads 0: spring.

### Tests (2026-10-20, DeSmuME, one build: the RESUME list + exp_share season_choice test_story_start, TEST_START=319,140,850 TEST_TEAM=1 + a Lv 5 Starly)
The DS clock was set to 2026-11-15 (November = autumn) with story_play's PLAY_DATE (a DeSmuME movie's RTC start);
PLAY_NO answers NO to the named questions, PLAY_QSHOTS shoots each menu. Proofs in work/agents/questions/shots/.
- All YES: the four questions and their menus (yes_question1-4.png); options u16 0xaa01 (bits 11, 13, 15 set),
  PFLAG_010B = 1, Key Items = Xtransceiver, Pal Pad, Exp. Share; kept season 2: Route 201 in Black 2's autumn colours
  (yes_november_route201_autumn.png). A wild Starly KO'd by the Lv 100 lead: "The rest of your team gained Exp. Points
  thanks to the Exp. Share!", the benched Lv 5 Starly 135 -> 146 Exp. (yes_after_battle.png). The Bag's Use: "The Exp.
  Share was turned off.", PFLAG_EXP_SHARE_OFF = 1 (yes_bag_switch_off.png).
- All NO: options u16 0x0201 (bits 11-15 clear), PFLAG_010B = 0, Key Items = Xtransceiver, Pal Pad; kept season 0:
  Route 201 in Pearl's own look in November (no_november_route201_pearl_look.png); the same battle: no team line, the
  benched Starly stays at 135.
- Not tested: the Route 206 gate (its chapter is not installed yet), the new item description (added after the build).

### The music answer (`b2tools/patches/music_choice.py`, `src/code/music_choice.c`, `data/unova_music.json`)
- Zone songs: sinnoh_music's DecideZoneHeaderBGMID long jump (to night_music.c's Pearl_ZoneBGM) is pointed at
  Choice_ZoneBGM, which calls Pearl_ZoneBGM first; with UNOVA (bit 13 = 0) a Pearl song becomes its Black 2 song by
  the DS clock's season (77 Pearl songs, night versions included -> 49 Black 2 songs or season sets). sinnoh_music
  and night_music.c are not changed.
- The mapping, by what the zones are: towns -> Black 2's towns (Twinleaf -> Aspertia, Sandgem -> Floccesy, Floaroma ->
  Accumula, Survival Area -> Lentimas, Resort Area -> Undella with its four seasons), cities -> cities (Jubilife ->
  Castelia, Canalave -> Driftveil, Oreburgh -> Virbank, Eterna -> Nacrene, Hearthome -> Nimbasa, Pastoria -> Humilau,
  Veilstone -> Mistralton, Sunyshore -> Striaton, Snowpoint -> Icirrus, the League's town -> Opelucid, Fight Area ->
  Black City), routes -> Black 2's routes, with their four season versions where Black 2 has them (Pearl's route songs A-F:
  201, 202, 219, Verity Lakefront -> Route 19; 203, 204, Iron Island -> Route 1; 205, Eterna Forest's and the
  Windworks' outsides -> Route 2; 206-208 -> Route 6; 209, 212, Trophy Garden -> Route 11; 210, 211, 214, 215 ->
  Route 22; the snowy 216, 217 -> Route 23; Battle Zone 228-230 -> Route 4), caves and dungeons -> Black 2's (Mt. Coronet -> Twist Mountain, Oreburgh Mine -> Chargestone, Eterna
  Forest -> Dreamyard, Old Chateau -> Strange House, Stark Mountain -> Reversal Mountain, the lakes -> Cave of Being,
  Galactic -> Plasma Frigate, Victory Road -> Victory Road, the League -> the League), buildings -> Black 2's (Pokémon
  Center, Mart -> Shopping Mall, Gym, Lab, Contest Hall -> Musical Theater, Battle Tower -> Battle Subway, TV ->
  Pokéstar Studios, Game Corner -> Join Avenue, GTS -> Gear Station). Every Black 2 song named is one Black 2's own zones
  play (checked by the patch).
- Story songs (the 12 Pearl songs scripts start themselves): with UNOVA, Barry's -> Hugh's, Lucas/Dawn -> Bianca's,
  "follow me" -> Black 2's, Rowan's SEQ_THE_EVENT01 -> Juniper's (b2tools/pearl_story.py's own stand-ins), the
  caverns/marsh -> their zone choice; at HoennB2 hoenn_music's three BGM play sites (GFL_SndBGMPlayCore, the threaded
  load func_02006424, the faded change func_02005e08). SEQ_THE_EVENT02/03, SEQ_OPENING2 and SEQ_FUE stay Pearl's (no
  stand-in chosen yet). check_waits: no Pearl song that ends gets a Black 2 song that loops.
- Saves made before the question have bit 13 = 0 and play UNOVA (no release has them).
- Test switch PEARL_TEST_MUSIC=sinnoh|unova forces the answer.

### Text (needs a change in `patches/sinnoh_names.py`)
The Fairy text (move names, descriptions, "X used Y!" lines, the items, type 17's name, the Pokédex search's label;
HoennB2's words) is in **`data/text_overrides_pending/fairy.json`**. sinnoh_names' text_overrides() edits lines by label
only, and these are new lines past a file's end (moves 560-565 after `\from{moves.name}`'s 560 lines, 0016's lines
1680-1697) or lines made from pokebw2's data JSON (items 113/114 through `\from{items.*}`). Proposed (the smallest
change, HoennB2 text.py's "a line at the file's end appends", by label): a label written `+Label` is a new line
appended before the file's `\pad` line in the JSON's order; a key `res/<path>.json` merges its fields into that data
file of the clone. The same change also matches a blank line `Label =` (the current split on `' = '` misses it:
zknsearch_main's line 77). Diff in the report to the lead (2026-10-18) and below ("For the lead"). Tested offline (the
packed a/0/0/2 decoded: every line where it should be) and in game with the change applied in a test copy of b2tools.
Until the lead applies it, fairy must not be in the release build list (the moves would have no names).

### How it was tested (2026-10-18)
Offline:
- `python3 b2tools/fairy_check.py --rom-code <code dir>` on a dry run of every code patch in build order
  (sinnoh_encounters, sinnoh_music, pearl_rods, pearl_intro, fairy, fairy_ui, music_choice on a clone of Black 2's
  code): the sweep finds 103 instructions with #17 in ov167/ov169/ov170, **0 unexplained** (PearlB2's newer pokebw2
  disassembles ov169 at its VRAM base with new helper names; its three 17s were read in the C and listed in
  fairy_check MANUAL: a loop bound and CONDITION_FORESIGHT twice); fairy.py's 18x18 chart = the published Gen 6 chart
  (324/324); Black 2's own 17x17 = Gen 6 without Fairy with Gen 5 Steel; the 14 sentinel bytes are 18 and the 4
  replaced functions jump into ITCM. Every patch's byte checks pass in that order; ITCM ends at 0x01FFA9A0 (10,656 of
  32,768 bytes; Black 2's own code is 5,024).
- The text: the proposed text_overrides() on a pokebw2_mod clone with fairy.json, packed with pokebw2's packer and
  decoded again: type 17 "Fairy", move names 560-565 (both files), descriptions, 0016 lines 1680-1697, items 113/114
  (name, with article, plural, description), zknsearch line 77 "Fairy", game_start 26-30.
- `python3 b2tools/patches/music_choice.py`: the table (77 Pearl songs, 49 Black 2 songs or season sets, no zone song
  left out), the story songs, check_waits (86 pairs).
In game (DeSmuME, muted; `b2tools/hwtest/rowan_shot.py`; builds into work/rom_lead with the lead's list + `pearl_intro
fairy fairy_ui music_choice`, sinnoh_names = the proposed version in a test copy of b2tools; screenshots in
work/fairy_proofs/):
- Build 1, + `test_fairy` (TEST_START=319,145,858 = Route 201's grass, TEST_WILD=319:SPECIES_CLEFAIRY, party Gible
  Lv 10 and Clefairy Lv 10):
  - YES / SINNOH: both questions show with their menus (01, 02); Intro_SetConfigBit is called with (11, 1) and
    (13, 1); Route 201 plays sequence 22 (Pearl's SEQ_ROAD_A_D); Gible's Dragon Rage on a wild Clefairy: "It doesn't
    affect the wild Clefairy..." (03); Clefairy's summary: type FAIRY (04).
  - NO / UNOVA: (11, 0) and (13, 0); Route 201 plays 1177 = SEQ_BGM_SW_R_19_SU (Black 2's Route 19, summer version:
    October is summer in Black 2's calendar); Dragon Rage hits the Clefairy (05); its summary: NORMAL (06).
- Build 2 (a normal new game, no test patch), YES / UNOVA: the bedroom, the 1F and Twinleaf play 1104 =
  SEQ_BGM_SW_C_12 (Aspertia's, for Pearl's SEQ_TOWN01); the TV report's jingle plays and Twinleaf's song comes back.
  **Not seen in game: the story-song redirect** (with UNOVA, Barry's theme, Pearl 84, should play as 1237 =
  SEQ_BGM_E_HUE): the test driver did not get Barry's "Thud!!" scene to start (stepping in front of his door at the
  tile it was walked to did nothing); to check with story_shot's known path or by hand.
- The three BGM play hooks run in every test above in both answers (the intro, the field, wild battles, the TV
  jingle) with nothing changed for the SINNOH answer.

### Left to do
- **The lead**: music_choice can join the build list now (it needs nothing else: `... pearl_intro ... music_choice`;
  without it the UNOVA answer is stored but Sinnoh's songs play). fairy and fairy_ui join after sinnoh_names' text
  change ("For the lead" below): `... pearl_intro pearl_intro_art pearl_player_sprites fairy fairy_ui music_choice`.
  pearl_intro alone (the default list today) asks both questions and stores the answers; nothing reads them yet.
- **The user**: Rowan's two lines; the Unova songs (data/unova_music.json, easy to change); where Pixie Plate and
  Fairy Gem are sold (proposal: Veilstone Dept. Store's battle-items clerk, when the specialty marts are ported; set
  fairy.py SHOP_ID); whether Sinnoh species get Gen 6 Fairy moves beyond HoennB2's list (e.g. Clefairy/Clefable
  Moonblast, Togetic Fairy Wind; HoennB2 should add the same ones so both games keep one data set).
- The sprite question (CLASSIC / NEW, bit 14) once the NEW sprites exist (HoennB2's sprite_switch.py, seeded).
- With UNOVA, four story songs still play Pearl's (SEQ_THE_EVENT02, SEQ_THE_EVENT03, SEQ_OPENING2, SEQ_FUE: no
  stand-in chosen); battle, trainer and victory music are Black 2's under both answers (Pearl's are not installed).
- A link battle between Pearl NDS and a Hoenn game (two emulators: the user's melonDS test). The sync is HoennB2's
  code at the same sites; with Fairy answered differently on the two machines, the server's answer applies.
- fairy_check.py --emu (the ROM self-test of every type pair, move and species in the four toggle states) was not
  run here (HoennB2 ran it on the same code: 0 errors).
- Savestates: ITCM grew (an autoload): states made before need a cold boot.

### For the lead
1. `b2tools/patches/sinnoh_names.py`, text_overrides(): replace the function with this (the diff is the whole change;
   tested as described above):
```python
def text_overrides(tree):
    """data/text_overrides/*.json -> the clone's res/text/system/<file>.txt (by label; every label must exist).
    A label written "+Label" is a NEW line, appended at the file's end (before its \\pad line) in the JSON's order,
    e.g. new moves' names after the 560 lines \\from{moves.name} makes (HoennB2's text.py appends past a file's end
    the same way). A key "res/<path>.json" instead of a file name merges its fields into that data file of the clone:
    the texts pokebw2 makes from its data through \\from{...} (an item's name, plural, description ...)."""
    d, done = os.path.join(ROOT, 'data', 'text_overrides'), 0
    for name in sorted(os.listdir(d)) if os.path.isdir(d) else []:
        if not name.endswith('.json'): continue
        for f, lines in json.load(open(os.path.join(d, name), encoding='utf-8')).items():
            if f.startswith('_'): continue
            if f.startswith('res/'):
                path = os.path.join(tree, f)
                data = json.load(open(path, encoding='utf-8'))
                assert set(lines) <= set(data), f'{name}: {f} has no field {sorted(set(lines) - set(data))}'
                data.update(lines)
                json.dump(data, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=4)
                done += len(lines)
                continue
            path = os.path.join(tree, 'res', 'text', 'system', f + '.txt')
            text = open(path, encoding='utf-8').read().split('\n')
            end = next((i for i in range(len(text) - 1, -1, -1) if text[i].startswith('\\pad{')), len(text) - 1)
            for label, value in lines.items():
                new = label.startswith('+')
                at = [i for i, l in enumerate(text) if l.split('=', 1)[0].strip() == label.lstrip('+')]   # 'X =' too
                assert len(at) == (0 if new else 1), f'{name}: label {label} found {len(at)} times in {f}.txt'
                if new:
                    text.insert(end, f'{label[1:]} = {value}'); end += 1
                else:
                    text[at[0]] = f'{label} = {value}'
                done += 1
            open(path, 'w', encoding='utf-8').write('\n'.join(text))
    return done
```
2. Then `git mv data/text_overrides_pending/fairy.json data/text_overrides/fairy.json` (and drop the empty folder).
3. Build list: `... pearl_trainer_pics pearl_intro pearl_intro_art pearl_player_sprites fairy fairy_ui music_choice`
   (pearl_intro, fairy, fairy_ui and music_choice append to ITCM through itcm.py's chain, so any order after pearl_rods
   works; fairy_ui must follow fairy, music_choice must follow sinnoh_music).
4. Nothing to change in sinnoh_music.py or night_music.c: music_choice re-points DecideZoneHeaderBGMID's long-jump word
   and calls Pearl_ZoneBGM itself (it checks the jump byte for byte). If you prefer the choice inside night_music.c
   instead: `if (!(options & (1 << 13)))` map the song through the generated table before returning (music_choice.py
   table() makes it).

## HoennB2's design document (reference)

HoennB2 notes/FAIRY.md at main ae80a9d, unchanged but for its headings (one level down). Its paths (screenshots/, work/agents/, src/text/, Birch's questions, the Lilycove shop, the seasons bit) are HoennB2's; the Black 2 addresses, the data and the engine are the same here.

**Fairy type and the physical/special toggle (fairy_core, 2026-10-08)**

Design doc of the v16 Fairy type (user decision 2026-10-08, notes/DECISIONS.md) and of the physical/special toggle
(user request the same day). Research: notes/FAIRY_SCOPE.md. Engine, data, toggle, moves and items: fairy_core
(`b2tools/patches/fairy.py` + `fairy.c`). The type screens, Hall of Fame and Pokédex search: fairy_ui
(`b2tools/patches/fairy_ui.py`, runs after fairy). Proofs: `b2tools/fairy_check.py`, screenshots/fairy_core/.

### Agreed constants (fairy_core + fairy_ui)
| What | Value |
|---|---|
| TYPE_FAIRY | **17** (type name text 0398 line 17 "Fairy") |
| TYPE_NONE ("no type") | **18** everywhere (Black 2 used 17). fairy_core moves ov167's 14 sentinels and replaces the two chart readers; fairy_ui does ov296 (Pokédex entry) and ov300 (search list) |
| Toggle storage | the options u16 at the start of the trainer-data save block (`getTrainerDataBlkAddress`, SaveControl block 27): **bit 11 = Fairy on**, **bit 12 = classic (Gen 3) split**. Bits 0-10 are Black 2's options (accessors 0x0200898c-0x02008b0c, each masks its own bits); 11-15 were unused. A new game starts with both 0; v15 saves read as Fairy off, modern split |
| Readers for other code | `Fairy_IsOn()` / `Split_IsClassic()` in ITCM: Thumb, 0/1 in r0, C calling convention (clobber r0-r3, r12, lr). Addresses (with \|1) in `<code>/fairy_symbols.json` of each build (fairy.py writes it; it also has `itcm_start`, `itcm_end`) |
| What the UI sees | nothing to do: with Fairy off the data readers give the old types back (no 17 ever reaches a screen); in classic mode `PML_MoveGetParam(move, 2)` gives the by-type category, so every screen that shows a move's category icon shows the classic one |
| Icons / palettes | type 17's icon = a/0/8/2 entry 51 (type + 0x22), palette row byte 0x0209209d, battle buttons a/0/1/1, Hall of Fame a/2/1/3: fairy_ui. Pixie Plate / Fairy Gem item icons: fairy_core (plate char 619 + Mind Plate's palette 629, gem char 934 + Psychic Gem's palette 944) |
| ITCM | fairy_core from the roamers' end (0x01FF9DC0, ~3.3 KB), fairy_ui after it |
| No Fairy TM | Gen 6's only Fairy TM is TM99 Dazzling Gleam; Black 2 has no TM99 and Hoenn's TM items stay as they are |

### Birch's questions (intro, after the name)
Script: ov294 ASK_RIVAL_NAME (the last script hoenn_intro runs; the dead FAREWELL script after it gives the room), 15
of its 21 entries: "Ah, okay! You're X who's moving to my hometown..." → **question 1** (Fairy) → YES/NO → **question 2**
(split) → YES/NO → **question 3** (music, music_check's: notes/MUSIC.md, patch hoenn_music) → HOENN/UNOVA → GOTO script
10 (RIVAL_NAMED, dead since hoenn_intro dropped the rival naming; 10 of its 14 entries) → **question 4** (sprite style,
sprite_switch's: patch sprite_switch, 2026-10-11) → CLASSIC/NEW → "All right, are you ready?" ... The answers go through
intro command 31 (Black 2's unused INTRO_CMD_SET_MSG_LANGUAGE, now `Intro_SetConfigBit bit, value`) into the new game's
Config (ov162 copies it into the save) and the save's own copy. The cursor starts on YES / HOENN / CLASSIC: mashing A
gives Fairy on, modern split, Hoenn music, the classic sprites.

Text (src/text/overrides_fairy.json, file 0054 lines 26-30; lines 29, 32, 33 were dead rival/Juniper lines, blanked or
reused, for room in the fixed text slot). One exchange, pages separated by " / ":

> **26** Before you go, I have three quick questions for you. / You can't change your answers once your adventure
> begins, so think them over carefully. / First: some researchers now say Pokémon like Ralts and Marill belong to a
> brand-new type: the Fairy type! / Would you like to meet the Fairy type on your adventure? — YES = Fairy on
>
> **27** Second, about moves... / Nowadays, every move is either physical or special on its own. / But some
> old-school Trainers say a move's type decides that: Fire, Water, Grass, Electric, Ice, Psychic, Dragon and Dark moves
> are special, and the others physical. / Should each move keep its own physical or special nature? — YES = modern
> (Black 2's), NO = classic
>
> **28** (music_check) Third... the music! Every region has its own songs. / Would you like to hear Hoenn's music
> on your journey, or Unova's? — **29** HOENN (bit 13 = 1) / **30** UNOVA
>
> **31** (sprite_switch) And last... how everyone looks! / Would you like to see people the way they looked in Hoenn
> long ago, or in Unova's newer style? — **32** CLASSIC / **33** NEW (bit 14 = 1)

(Line 26 says "four quick questions" since the 4th. Lines 0, 34 and 36, Black 2's unused space-filled placeholders,
were shortened for the 152 B the 4th question needed in 0054's fixed text slot.)

| Options bit | Meaning (1) | Set by |
|---|---|---|
| 11 | Fairy type on | question 1, YES |
| 12 | classic (Gen 3) physical/special rule | question 2, NO |
| 13 | Hoenn music (music_check) | question 3, HOENN |
| 14 | NEW (Gen 5 community) character sprites, src/sprites_gen5 (sprite_switch: b2tools/patches/sprite_switch.py) | question 4, NEW |
| 15 | free | |

### How it works
| Piece | Where | What |
|---|---|---|
| Chart | ov167 GetTypeEffectiveness 0x021bd160, GetTypeWeaknesses 0x021bd2b0 → ITCM `Fairy_TypeEff`, `Fairy_TypeWeaknesses` | Fairy on: an 18×18 Gen 6 chart in ITCM (codes 0/2/3/4); off: Black 2's own untouched 17×17 table (ov167 0x021d7500, Gen 5 Steel). Types ≥ 18 (on) / ≥ 17 (off) are neutral, as Black 2's 17 was |
| Sentinels | ov167, 14 one-byte `mov/cmp #17` → 18 | fairy.py `SENTINELS` (no STAB / neutral for a typeless move, Struggle's type, last-hit type default ×3, Roost's splitTypeCore ×5, DoesMonHaveType, Color Change, Conversion 2) |
| Species types | arm9 PML_PersonalFetchBW2 0x02020234, PML_PersonalLoadBW2 0x0201eee0 → ITCM | the data has the Gen 6 types; off: the 22 records get Black 2's back after the read. The one-record cache's key carries the toggle (bit 15 of its form key), so no record read before Birch's answer is handed out after it |
| Move type / category | arm9 PML_MoveGetParam 0x020212fe (the `bl PML_MoveGetParamCore`) → `Fairy_MoveParamShim` | type: off and 17 → the fallback below. Category: classic and not status → by the (remapped) type. Every reader goes through it: battle, AI scripts (ov170 GetMoveData), every screen |
| Classic split in battle | ov167 ServerEvent_GetMoveParam's end (0x021aa06c) + the category reads of ServerEvent_CalcDamage 0x021a5928, GetAttackPower 0x021aae98, GetTargetDefenses 0x021aaf9a | the category from the move's **final** type (Hidden Power, Weather Ball, Normalize ...). AI damage estimates (AICalcDamage) use the same two functions |
| New moves' animations | ov167 func_ov167_021cfc60's call 0x021cfc9c → `Fairy_AnimShim` | ids 560+ play a donor's animation (a/0/6/5 holds 561 entries; ov168 plays a/0/6/6 past them) |
| Metronome | ov167 0x021bd060 buffer 0x230 → 0x238 u16; 0x021bd686 loop bound → `Fairy_MoveCount()` (566) | can call the new moves |
| Held items | ov167 ItemEvent_AddItemCore: table (172 entries at 0x021d8f28, the last free) → ITCM `kItemEvents` (173), count `cmp #0xac` → 0xad | Pixie Plate: `CommonTypeBoostingItem(.., 17)` (×1.2, item param 20), Fairy Gem: `CommonGemDecide/Power(.., 17)` + Black 2's shared "gem used" handler. Neither fires with Fairy off (no move is Fairy then) |
| Shop | ov036 ShopUI_LoadPokeMartItems' list read 0x021ac77c → `Fairy_ShopShim` | Fairy on: Lilycove Dept. Store 3F's right clerk (shop 15) reads list file 79 (its list + Pixie Plate + Fairy Gem); off: its normal list |
| Intro | ov294 sCommands[31] → `Intro_SetConfigBit`; ASK_RIVAL_NAME rewritten | above |
| Not changed, on purpose | arm9 func_0201f14c and ov055 (PWT): 17 = "any type" in their own entry-rule data, and no Fairy rule exists; ov055's simulated-match chart reads 17 as neutral. Hidden Power: 1-16 (Gen 6: never Fairy). Arceus: the Pixie Plate does not change its form or Judgment (no Fairy Arceus art; Arceus is not in Hoenn). Medal Rally (ov065, its own 17-type archive). Xtransceiver matchup lines (ov259/text 0397): only reachable through Unova contacts the PokéNav doesn't have. No Roseli Berry (the 64-berry list is full) |

**Classic rule.** Damaging moves of Fire, Water, Grass, Electric, Ice, Psychic, Dragon, Dark **and Fairy** are special,
all others (and typeless) physical; status moves stay status. Fairy is special because 5 of its 6 damaging moves are
special in Gen 6 and its Pokémon (Gardevoir, Togekiss, Clefable ...) are mostly special attackers, like Psychic. The
summary/battle icons follow the move's data type (a screen can't know Hidden Power's or Weather Ball's battle type);
the damage follows the final type.

### Data (Gen 6 values typed in from memory: please check)
#### Species (a/0/1/6 types; Black 2's in brackets, given back when Fairy is off)
Clefairy, Clefable, Cleffa: Fairy (Normal) · Jigglypuff, Wigglytuff, Igglybuff, Azurill: Normal/Fairy (Normal) ·
Mr. Mime, Mime Jr., Ralts, Kirlia, Gardevoir: Psychic/Fairy (Psychic) · Togepi: Fairy (Normal) · Togetic, Togekiss:
Fairy/Flying (Normal/Flying) · Marill, Azumarill: Water/Fairy (Water) · Snubbull, Granbull: Fairy (Normal) · Mawile:
Steel/Fairy (Steel) · Cottonee, Whimsicott: Grass/Fairy (Grass).

#### Moves
| Id | Move | Type | Cat. | Power | Acc. | PP | Effect / target | Template (Black 2) | Fairy off: type | Animation |
|---|---|---|---|---|---|---|---|---|---|---|
| 186 | Sweet Kiss | Fairy (was Normal) | status | – | 75 | 10 | confuse | – | Normal | own |
| 204 | Charm | Fairy (was Normal) | status | – | 100 | 20 | Atk −2 | – | Normal | own |
| 236 | Moonlight | Fairy (was Normal) | status | – | – | 5 | heal | – | Normal | own |
| 560 | Fairy Wind | Fairy | special | 40 | 100 | 30 | – | Water Gun | Normal | Silver Wind (318) |
| 561 | Disarming Voice | Fairy | special | 40 | never misses | 15 | adjacent foes, sound | Hyper Voice | Normal | Echoed Voice (497) |
| 562 | Draining Kiss | Fairy | special | 50 | 100 | 10 | user heals 75% of damage, contact | Giga Drain | Normal | Sweet Kiss (186) |
| 563 | Dazzling Gleam | Fairy | special | 80 | 100 | 10 | adjacent foes | Hyper Voice minus sound | Normal | Flash (148) |
| 564 | Play Rough | Fairy | physical | 90 | 90 | 10 | 10% target Atk −1, contact | Aurora Beam's effect | Normal | Double Hit (458) |
| 565 | Moonblast | Fairy | special | 95 | 100 | 15 | 30% target Sp. Atk −1 | Mist Ball's effect | Normal | Mist Ball (296) |

Fallback rule: every Fairy move is Normal with Fairy off, as Black 2 has Sweet Kiss, Charm and Moonlight (one table in
fairy.py `NEW_MOVES`, per move: change any entry there). Names (0403/0488), descriptions (0402) and "X used Y!" lines
(0016) are appended (text.py now appends a line past a file's end). Flags come from the template (+ contact for Play
Rough and Draining Kiss, − sound for Dazzling Gleam). "Others if cheap": no other Gen 6 Fairy move is data-only with a
Hoenn learner I can vouch for (Baby-Doll Eyes' learners are not Hoenn's; Crafty Shield, Misty Terrain, Flower Shield,
Aromatic Mist, Fairy Lock, Geomancy need new effect code).

#### Learnsets (a/0/1/8 level-up, a/1/2/4 egg moves; Hoenn species only; added to Black 2's lists, which keep their Gen 5 levels)
| Species | Added | How sure |
|---|---|---|
| Ralts, Kirlia, Gardevoir | Draining Kiss Lv 19 | fairly (XY/ORAS) |
| Gardevoir | Moonblast Lv 1 (Move Reminder) | unsure of the level |
| Marill | Play Rough Lv 47 | unsure of the level |
| Azumarill | Play Rough Lv 55 | unsure of the level |
| Jigglypuff | Disarming Voice Lv 11 | fairly |
| Wigglytuff | Play Rough Lv 1 | fairly |
| Mawile | Play Rough Lv 1, Fairy Wind Lv 5 | unsure (ORAS) |
| Swablu | Disarming Voice Lv 11, Moonblast Lv 46 | unsure (ORAS) |
| Altaria | Disarming Voice Lv 11, Moonblast Lv 52 | unsure (ORAS) |
| Luvdisc | Draining Kiss Lv 9 | unsure |
| Ralts (egg) | Disarming Voice | fairly |
| Absol (egg) | Play Rough | fairly |
Not added: non-Hoenn species (Clefairy, Togepi, Snubbull, Cottonee lines); TMs and tutors (no Fairy TM, see above).

#### Items
| Id | Item | Data (template) | Effect | Icon | Where |
|---|---|---|---|---|---|
| 113 | Pixie Plate | Mind Plate's (price 1000, Fling 90, hold param 20); hold effect 147 (Black 2's "by item id" value) | Fairy moves ×1.2 | plate 619 + palette 629 | Lilycove Dept. Store 3F, right clerk, Fairy on only |
| 114 | Fairy Gem | Psychic Gem's (price 200) | one Fairy move ×1.5, then used up | gem 934 + palette 944 | same |
Proposal behind the shop: that clerk already sells Hoenn's battle and evolution items (trade_evos added Metal Coat ...);
with Fairy off the list stays exactly as before, so the items never appear where they would do nothing.

### Savestates, layout, save
- ITCM (arm9 autoload) grows ~3.3 KB, ov036/ov167/ov294 change, a/0/2/1, a/0/1/8, a/1/2/4 grow (fixed sizes of their
  own in fairy.py: vanilla + 4/4/2 KB, so later data edits keep the layout), a/2/8/2 gets list file 79, a/0/0/2 text
  grows inside its fixed slots. One layout change: the lead remakes the base states (make_states.py: the intro now
  has the two questions; mashing A answers YES/YES — see "Tests" for the extra presses).
- Sapphire and Ruby: one patch, no version switch (rom_layout_diff.py result in "Tests").

### Tests (fairy_core, 2026-10-08; proofs in screenshots/fairy_core/)
- **Sweep (static)**: `python3 b2tools/fairy_check.py --rom-code <build>/keep` — 99 instructions with #17 in ov167/ov169/
  ov170: 14 sentinels (now 18), 3 inside the replaced chart readers, 22 shifts, 60 shown not to be types (ability
  parameter 17, event/condition/var ids, struct offsets, UI), **0 unexplained**; the 18x18 chart equals the Gen 6 chart
  typed out separately (324/324); Black 2's table = Gen 6 without Fairy with Gen 5 Steel; patched bytes checked. OK.
- **Self-test (emulator)**: HOENN_TEST_FAIRY_SELFTEST build, in a battle, the real entry points (GetTypeEffectiveness,
  GetTypeWeaknesses, PML_MoveGetParam type + category, PML_PersonalGetParamSingle types) for types 0-18 x 0-18, all 566
  moves and 650 species, in all four toggle states: 6,384 values, **0 errors** (selftest_final.json).
- **Intro** (release build): YES/YES/HOENN → options 0x2a01, NO/NO/UNOVA → 0x1201 (01, 02). Save → reset → Continue:
  0x2a01 kept, field heap 112,900 B free at the save (needs 83,004) (03, 04). The Options screen changes the text
  speed (0x2a01 → 0x2a02) and keeps bits 11-13 (05). **make_states.py: 40 + 58 A presses no longer reach the truck;
  40 + 72 do; use 80** (tested, work/agents/fairy_core/tools/cycle80.py).
- **Layout**: Sapphire and Ruby release builds with fairy: rom_layout_diff.py LAYOUT IDENTICAL.
- **Battles** (tools/battle_test.py + src/field_scripts/scenes/fairy_test.inc, Lv 50, both sides' stats and stages fixed
  in RAM, battle RNG fixed; final_tests.log). Damage dealt by the player's first move:

| Case | Fairy off | Fairy on |
|---|---|---|
| Gardevoir Moonblast → Altaria (Dragon/Flying) | 47 (Normal) | **140, "It's super effective!"** (x2, Fairy STAB) (10) |
| Altaria Dragon Pulse → Marill | 66 | **0, "It doesn't affect the wild Marill..."** (11, 12) |
| Gardevoir Moonblast → Skarmory (Steel) | 23 | **35, not very effective** (x0.5 with STAB) (13) |
| Moonblast → Mawile (Steel/Fairy) | – | 35 (x0.5) |
| Altaria Moonblast → Marill (Water/Fairy) | – | 47 (x1) |
| Azumarill Play Rough → Salamence | 44 | **132** (x2, Water/Fairy STAB) (14) |
| Shadow Ball → Skarmory / Mawile (Gen 6 Steel) | 20 / 20 | **40 / 40** |
| Moonblast + Pixie Plate / Fairy Gem | gem: 47 (unused) | 168 (x1.2) / 210 (x1.5, gem used) (15) |
| Battle types (RAM) | Marill 10/10, Azumarill 10/10, Gardevoir 13/13, Mawile 8/8 | **10/17, 10/17, 13/17, 8/17** |

  **Fairy off vs the ROM without the patch** (same kit, same numbers): 11 of 12 cases identical (Psychic, Shadow Ball,
  Dragon Pulse, Dragon Breath, Thunderbolt vs Skarmory, Shadow Ball vs Mawile, Tyranitar's Shadow Ball / Crunch,
  Azumarill's Aqua Tail / Ice Punch). The 12th, Thunderbolt → Mawile, is 48 vs 47: the wild Mawile picked Sucker Punch
  (priority) in one run and Crunch in the other, so the damage roll came at another point of the RNG (18: the message
  sequences); no engine difference.
- **Split** (Tyranitar with Atk 200, Sp. Atk 100 → Wobbuffet): Shadow Ball modern 72 (special) / classic **122**
  (physical); Crunch modern 174 (physical) / classic **98** (special). The ROM without the patch = modern exactly;
  Fairy off + classic = Fairy on + classic (16, 17). The AI's damage estimate (ov167 AICalcDamage) calls the same two
  hooked functions (ServerEvent_GetMoveParam, ServerEvent_CalcDamage); AI scripts and screens read the category through
  PML_MoveGetParam (fairy_ui checked the summary and battle "check moves" icons).
- **Not tested in the emulator**: the Lilycove shop list (built: list file 79 + the ov036 hook), the new moves'
  learnsets in a level-up, Metronome calling a new move, Roost on Togekiss.

### For the lead
1. Patch lists (b2tools/rebuild_slice.sh, b2tools/story_build.sh): `... roamers fairy fairy_ui` (+ music_check's
   `hoenn_music` after them). fairy must come after hoenn_intro, shops, trade_evos and roamers (it asserts each).
2. Remake the base savestates on a ROM with them (one layout change, "Savestates, layout, save" above). make_states.py
   (and save_check's cycle.py, world_fixes' mkstate.py): the second mashing loop `range(58)` → `range(80)` (Birch's three
   questions; 72 is the minimum measured). The mashing answers YES / YES / HOENN.
3. Optional: move fairy.py `FAIRY_RESERVE` (a/0/2/1, a/0/1/8, a/1/2/4) into build_rom.py RESERVE.
4. Shared-file edits: b2tools/patches/text.py (append past a file's end; no existing override changes),
   src/field_scripts/0778_littleroot_town.s (HOENN_TEST_CHFA hook, test builds only).
5. The user approves: Birch's lines (above) and the Gen 6 values marked "please check".

### Screens (fairy_ui, 2026-10-08)
`b2tools/patches/fairy_ui.py` (after fairy; reads fairy's `<code>/fairy_symbols.json` for `Fairy_IsOn`) and
`b2tools/fairy_art.py` (the icon; `python3 b2tools/fairy_art.py OUT.png` draws the review sheet). Screenshots:
screenshots/fairy_ui/ (`01_icon_review.png`, `on_*` / `battle_*` / `dex_*` = Fairy on, `off_*` = Fairy off next to
v15.2, `split_*` = modern vs classic split). Tools and the raw proof logs: work/agents/fairy_ui/ (tools/constscan.py,
tools/sitediff.py, tests/memwatch.py, proof_static.txt).

#### Icons
| Set | What | Made from |
|---|---|---|
| Type icon (summary, Bag, PC, Pokédex entry, battle buttons, battle party/move info, Move Reminder, trade, Pokéstar: all read a/0/8/2 entry type+34) | a/0/8/2 **entry 51** (was the unused COOL contest icon, same size) | FIRE's frame recoloured, letters F, I (FIRE), A, R (DARK), Y (FLYING) copied pixel for pixel, spaced like GRASS |
| Its colours | palette a/0/8/2 entry 33 **row 2 colours 8/9** (0x7c1f fillers before) + arm9 **0x0209209d = 2** (row of type 17) | fill 0x567d = Gen 6 #EE99AC, border 0x2d2f (half the fill, as Black 2's icons) |
| Battle move button | a/0/1/1 **entry 572** (appended) | Psychic's button palette (469), colours 8-13 = its ramp recoloured to the Fairy pink |
| Pokédex foreign-language sheets (FR, DE, IT, JA, KO, ES entries) | a/1/5/7 entries 19-24, the free cell (row 5, col 3) | the FAIRY icon's pixels (same indices; English word, the sheets have no free glyphs for each language) |
| Hall of Fame | a/2/1/3 **entry 52** (particles) + **53** (palette), appended | Normal's star field with its texture palette tinted pink (= pink sparkles); Psychic's ramp recoloured |
| Bag TM disc | none: no TM teaches a Fairy move | - |

#### Each screen: fix and proof
Black 2 keeps the type graphics in 17-entry arrays of each screen's work struct, with other fields right after them
(index 17 = the next field). The arrays moved into new space at the end of a bigger struct, or got extra fields there.
Every access was found by a constant tracker over the disassembly of the whole overlay (literal pools included) and
every changed instruction is listed in work/agents/fairy_ui/proof_static.txt.
| Screen | Black 2 | Fix | Tested (screenshot) |
|---|---|---|---|
| Summary ov207 | struct 0x264 (proc work); 17 type chars at +0x130, +0x174 used everywhere | struct **0x2ac**; chars at **+0x264 x18**; 9 access sites re-based (load, free, 3 actor inits, 2 info pages, move types), loops 17 -> 18 | Fairy/Ground Groudon, Psychic/Fairy Gardevoir + Moonblast (real data) |
| Bag ov142 (TM/HM type) | struct 0x1f54 (its literal also addresses +0x1f50, so it stays and 2 ITCM thunks pass the new size); 17 chars +0x5ac, 17 actors +0x6e0, both followed by used fields | struct **0x2008**; chars **+0x1f60**, actors **+0x1fc0** x18; the cell-actor unit 0x36 -> **0x37** actors (without it switching pockets asserts: no free actor) | HM03 Surf as a Fairy move (test data) |
| PC ov255 | struct 0xa5bc; char table 0x81 at +0xa0dc and actor slots 0x91 at +0x9e98 are both full (slot 0x31 = first box icon) | struct **0xa5c8**: Fairy's char at +0xa5bc (= char index 0x138), actor at +0xa5c0 (= slot **0x1ca**, which every slot helper of the PC takes as is), loaded flag +0xa5c4; ITCM thunks load/create/show/hide/free it; unit 0xe9 -> 0xea | box view of Fairy/Ground Groudon, two open/close cycles |
| Pokédex entry ov296 | struct 0x2b4; English mode: 17 chars +0xe8, 17 actors +0x12c, shown types as bytes +0x170/+0x171 (17 = none) | struct **0x328**; actors at **+0x2e0** (0xb8 << 2 = 0x170 << 1, so each site stays one instruction); chars grow in place to 18 (old actor 0 slot); **"none" = 18** at all 12 sentinel sites; foreign-language table data_ov296_0219fac8[17] = its 2 padding bytes = cell (5,3) | Gardevoir (real data), Mudkip (test) |
| Pokédex search ov300 | type list 0..16 (`cmp r4,#0x10`), labels data_ov300_021a40ae ([17] = '-', read by nothing); item texts in a 50-entry array | list = 17 + `Fairy_IsOn()` (ITCM thunk); label [17] = text 0479 line **77 "Fairy"** (src/text/overrides_fairy_ui.json; a blank line of Black 2's); the search engine (ov302) compares types generically | Fairy finds Gardevoir; Fairy off: list pixel-identical to v15.2 |
| Battle buttons ov168 | palette file = data_ov168_021f3864[type], 17 u32 (index 17 read the next table) | the one literal points at an 18-entry table in ITCM (+ a/0/1/1 572) | Moonblast / Dazzling Gleam / Draining Kiss buttons |
| Hall of Fame ov265 | particle and palette file tables, 17 u32 each (the palette table is the last data of the overlay: index 17 read past it; tested: "An error has occurred" with a Fairy Pokémon) | both literals point at 18-entry tables in ITCM (+ a/2/1/3 52/53) | Fairy/Ground Groudon: pink stars, then saved and credits |
| Battle party summary / check moves ov287, Move Reminder ov258, trade ov194, Pokéstar ov322 | load one icon by type when drawn | nothing needed (entry 51 + the palette row) | battle summary and check moves (real data) |

#### Memory / overrun proof
- Static: tools/constscan.py lists every instruction of the overlay that builds or uses an offset in the old array's
  range (and the neighbours); all were re-based (proof_static.txt has every changed instruction before/after).
- Dynamic (tests/memwatch.py): catches the work struct at its allocation (the screen's own code: bytes checked) and
  counts every read/write of the old array, the new array and the 16 bytes after the new struct size until the
  struct is freed. Results: summary, Bag, Pokédex entry (6 structs over INFO/page changes) and PC (2 visits): the
  old arrays only get the allocation memset (0 reads); the new arrays are written by the load loops 18 times and
  read by the screens' own code / my thunks; the bytes after each struct are touched only by the heap manager (the
  next block's header), never by screen code. The allocation memsets stop exactly at the new sizes.
- ITCM: fairy_ui's 472 B are appended after fairy's code by the same rule as roamers/fairy (the arena literal moves).

#### Fairy off and the split
- Off: with fairy's data hooks no 17 reaches a screen. Compared with a v15.2-list build on the same scripted input:
  battle move buttons (bottom screen pixel-identical), Pokédex type list (pixel-identical, 17 entries), Pokédex entry,
  summary, Bag, PC, Hall of Fame (same icons/particles; only nature/stats differ: different saves).
- Split: every screen that shows a move's category reads it through `PML_MoveGetParam(move, 2)` (summary ov207, Bag
  ov142, battle UI ov168, battle party info ov287, Move Reminder ov258; nothing else reads a/0/2/1), which fairy's hook
  answers. Tested: Shadow Ball special (modern) / physical (classic), Crunch physical / special, Stone Edge physical in
  both, on the battle "check moves" screen and the summary.

#### Layout and savestates (fairy_ui's part)
ITCM +472 B (after fairy's), overlays ov142, ov168, ov207, ov255, ov265, ov296, ov300 change; a/0/1/1 +1 entry
(552 B), a/2/1/3 +2 entries (65,836 + 552 B); a/0/8/2 and a/1/5/7 keep their sizes; a/0/0/2 text inside its slot.
No RESERVE archive changes size beyond its reserve. One layout change together with fairy's.
