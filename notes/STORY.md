# Pearl's story in Black 2 (started 2026-10-18)

Pearl's scripts, text, people, signs and step triggers, translated from the dump into Black 2's formats by tools, then
Chapter 1 (Twinleaf, Route 201, Lake Verity, Sandgem) installed with them. Model: HoennB2's story port
(`notes/STORY_PORTING.md`, `STORY_COMMON.md`, `src/include/hoenn_story.inc`). Sources in that order: the Pearl dump,
pokediamond, pokeplatinum (names and formats only, never its story), pokebw2.

## 1. The pieces

| Piece | File | What it does |
|---|---|---|
| Translator | `b2tools/pearl_story.py` | Pearl script file -> Black 2 field-script source (`zones NAME...`, `chapter 1`, `report`, `show FILE`) |
| Porting library | `src/include/pearl_story.inc` | `pl_` + Pearl's command name -> Black 2 commands (one macro per Pearl command, with the facts it relies on) |
| Ids | `b2tools/pearl_ids.py` -> `data/pearl_story_ids.json` (registry) + `src/include/pearl.h` | Pearl flags/vars/trainers -> Black 2 saved flags, works, trainer ids |
| Text | `b2tools/gen4_text.py` | Pearl's message files read from the dump, converted to Black 2's text format |
| Events | `b2tools/pearl_events.py` | Pearl people/signs/triggers/map scripts -> Black 2 zone entities |
| Patches | `patches/pearl_text.py`, `patches/sinnoh_story.py`, `patches/pearl_starters.py` | text into a/0/0/3; scripts, text and entities into the zones; the starter screen |
| Checker | `b2tools/b2_script_check.py` | decodes an assembled file with Black 2's command table; every command allowed at its script's level |
| Test driver | `b2tools/hwtest/story_shot.py` | new game -> steps (walk, face, A/B, wait for a zone) with screenshots |
| Play driver | `b2tools/hwtest/story_play.py` | plays scenes from a new game or a savestate: walks on Pearl's collision, advances text, YES/NO, battles and the starter screen, prints every line shown, reads works/flags/party/Bag, makes contact sheets of a scene |
| Tables | `b2tools/data/pearl_movement.json`, `data/pearl_sprite_map.json`, `data/pearl_movement_types.json`, `data/pearl_npc_fields.json` | movement codes, sprites, movement types, the NPC record (sources in each `_doc`) |

Build (after the lead's patches): `... sinnoh_events sinnoh_names sinnoh_encounters scripts pearl_text sinnoh_story
pearl_starters`. Regenerate the sources: `python3 b2tools/pearl_ids.py` (only when Pearl data changes),
`python3 b2tools/pearl_story.py chapter 1` (or `zones NAME ...`).

## 2. How the translator works

- **Reading.** Every Pearl script file is read from the dump with `gen4_script.py`'s disassembler (pokediamond's command
  table). Only code reachable from a script entry is emitted, labels are Pearl's byte offsets (`P978_0067`).
- **Names.** A command is named after Platinum's macro for its opcode below 0x2C4 (where Platinum's numbering is
  pokediamond's, checked: DATA.md) and after pokediamond's name above it. Each handler turns it into one `pl_` macro or
  a few Black 2 commands. A command with no handler becomes `pl_stub Name` (no code) with Pearl's command and arguments
  in a comment, and is counted in the report: nothing is dropped silently.
- **Black 2's VM is Gen 4's.** Comparisons (0 less, 1 equal, 2 greater; conditions 0-5) are the same, so
  `CompareVarToValue`/`GoToIf`/`CallIf` map one to one; `CheckFlag` = `FlagGet` + compare with 1. Directions (0 up,
  1 down, 2 left, 3 right) and every movement code Pearl uses are the same numbers (both fields run at 30 fps).
- **Messages.** Pearl has one plain box. A line of a person's talk script is said by that person (Black 2's balloon,
  `ParentActorMsg`); other lines use Black 2's plain window (`SystemMsg`). `data/pearl_speakers.json` (empty for now)
  can name a speaker per line. Two speakers in a row: the first window closes. Lines naming the counterpart (Dawn for a
  boy, Lucas for a girl; Pearl fills a buffer with `BufferCounterpartName`) come as a boy and a girl copy shown with
  Black 2's gendered message (a dataflow over each script finds which buffers hold the name).
- **Common scripts.** Pearl's `CallCommonScript id` runs another script file's script with the same vars. Each one a
  zone uses becomes a subroutine of the zone's file (`VMCall`), its lines appended to the zone's text file. The sign
  helper 2000 is Black 2's own sign window.
- **Global scripts of people and signs** (Barry following you = 9700, Dawn/Lucas = 10300, ...): a proxy entry in the
  zone's file, at the same number in every file (from 48), so a follower can carry its script id from zone to zone.
- **Warps.** Pearl's script goes on in the new map after `Warp`; Black 2 changes the map when the script ends and runs
  a reserved script there. So the rest of a Pearl script after a `Warp` becomes a script of the destination zone
  ("continuation", numbered after Pearl's own), and the `Warp` becomes `RTReserveScript` + `MapChangeCore`. Every file
  ends with `PearlArrive` (fade in, release).
- **Map scripts.** Pearl's level scripts become Black 2's map-script table in the entity file: on-transition -> zone
  init (level 2), on-load and on-resume -> field load (levels 1, both of Black 2's kinds), the frame table -> Black 2's
  condition table (the same check). Commands that hang at a level are avoided (`SetObjectEventPos` outside a zone init
  moves the live actor; `AddObject`/`RemoveObject` in a zone init use the flag) and `b2_script_check.py` checks every
  installed script at its level (the build stops otherwise).
- **The follower.** Pearl's `SetMovementType X, 0x30` (Barry follows you) = Black 2's own follower (`ActorPairSet`,
  as Black 2's global 10535; Black 2 renames him 0xFE, which is Pearl's own id for the follower). Pearl's 0xF2 / 0xFE
  = Black 2's 0xFE; while a script runs he is paused like everyone and the script moves him itself; following ends
  where Pearl ends it (`SetObjectFlagIsPersistent X, 0`), and where Pearl drops him (Lake Verity has its own Barry)
  he ends and leaves the map. A command that may address him before or after he follows checks flag 0x966.
- **The new game.** Black 2 still plays its intro and naming (the rival name it asks is Barry's), loads Twinleaf
  (zone 427) and runs its scripts 29/30 (`src/field_scripts/pearl/newgame.inc`, inside Twinleaf's file): Pearl's
  new-game flags (Pearl's script 9600), then the player's room, where Pearl starts (the TV report, then Mom).

## 3. Ids (`data/pearl_story_ids.json`, `src/include/pearl.h`)

Every flag and var any Pearl script, level script or map event uses got a Black 2 id once; the registry keeps them.
Black 2's free ids: HoennB2's survey of everything Black 2's code and scripts touch, rechecked against pokebw2 (858
saved flags, 277 works, trainer ids 1-813 without the 154 Black 2 resets).

| Pearl | Count | Black 2 | Why |
|---|---|---|---|
| map-local flags 1-0x3F | 32 | the same numbers (1 -> 0x50) | Black 2 clears 0-0x63 on every zone change, as Pearl clears its own; Black 2's global 2260 sets flag 1 |
| story and hide flags 0x40-729 | 503 | free saved flags (276 left) | |
| system flags 0x960+ | 80 | game clear 0x964 -> Black 2's 2400; the rest free flags | Pearl's 0x960-0x965 must not keep their numbers (Black 2's game clear, Pokédex, Running Shoes, continue flag) |
| hidden-item flags 730+n | 229 | Black 2's hidden-item flags 2820+n (n >= 213: 3033+) | for the hidden-item port |
| item-ball flags 986+n | 253 | 1100+n (Black 2's item-ball flags) | for the item-ball port |
| daily flags 2720+ | 18 | Black 2's free midnight flags 2744+ | Black 2 clears 2720-2819 at midnight |
| map-local vars 0x4000-0x401F | 13 | 0x4010-0x401E | cleared on map change; Black 2 itself uses 0x4000-0x400F |
| dynamic sprites 0x4020+ | 5 | the same works | Black 2's codes 162-177 read them (scripts store Black 2 codes) |
| saved vars | 131 | free works (145 left) | |
| script vars 0x8000-0x800C, 0x800D | | 0x8020-0x802C, 0x8011 | kept across Black 2's global calls; 0x8011 is Black 2's talked-to person |
| trainers (battled + partners) | 520 | Black 2 ids (146 left) | defeat flag = id + 1520 |
| the starter's species | | new work `PVAR_STARTER` | Pearl keeps it in its save |

System equivalents used: badges = trainer-card badges (`TrainerCardAddBadge`/`HasBadge`/`GetBadgeCount`, plus the
per-badge flag 2414+), Pokédex = `PokeDexEnable` + flag 2402 (the start-menu entry), "has a Pokémon" = flag 2401, National Dex = `PokeDexGiveNational`/`HaveNational`, Running
Shoes = `GiveRunningShoes` (2403), game clear = 2400, follower = flag 0x966. None in Black 2: Bag flag, Pokétch,
Underground, Safari, Vs. Seeker, contests, Defog, Journal.

## 4. Text

- Read from the dump (`gen4_text.py`: Pearl's own message files; every one of the 30,211 messages equals pokediamond's
  text; Diamond and Pearl share the file), one Black 2 text file per Pearl zone bank, at a/0/0/3 676 + (rank of the
  bank), packed with pokebw2's packer and read back (equal) by `patches/pearl_text.py`.
- Codes: `\r` (wait, clear) -> `{be01}`, `\f` (wait, scroll) -> `{be00}` (a one-line page: a clear, as Pearl shows it),
  placeholders `{STRVAR_1 t, n}` -> `{01tt:n}` (the same buffer numbers; Black 2's field text reads only the number),
  colours `{ff00:n}` (same palettes), pause, cursor. Pearl's big "Thud!!" (`{SIZE}`) has no Black 2 code: normal size.
- **Word for word.** Pearl's punctuation is kept (’ “ ”: Black 2's font has them, same widths). **Chosen: species
  written in capitals in Pearl's text (GYARADOS) get Black 2's case (Gyarados)**, because names Black 2 fills in
  (your starter, any Pokémon) come in Black 2's case and both must match; everything else is Pearl's. Every Pearl
  line fits Black 2's window (widest Chapter 1 line 206 px of 224).
- Zone headers get their zone's text file (`sinnoh_story`).

## 5. What is translated (all of Pearl, `python3 b2tools/pearl_story.py report`, work/pearl/b2_scripts/report.txt)

- **All 446 zone script files translate and assemble** (0 problems).
- **Pearl's own commands, each counted once: 37,208 translated, 1,605 stubbed (95.9 %)**; 3,547 more are in code no
  zone reaches (unused scripts, the End after a GoTo). Counted per use in the translated files (a common script in
  every zone that calls it): 95.4 % (78,562 / 3,825). 173 different commands translated, 412 still stubbed (most
  used once or twice).
- Stubbed, by use: berry trees (Black 2 has none), saving/communication/Union Room/Battle Tower/GTS, Mystery Gift, the
  Bag screen, Pokétch apps, contests, the Underground, field-move cut-ins (Cut, Rock Smash: with the HM work), the
  Journal, TV interviews, and Pearl-only gimmicks (Pastoria/Hearthome/Sunyshore gyms, Great Marsh, Turnback Cave).
- Approximated (listed per file): Pearl's free camera (the scene plays with the camera on the player), `StopMusic`
  (a quick fade), menus (Black 2's list menu at the right edge), plural item names (singular), object locks, the
  Pokémon Center bow, the first battle (no first-battle rules: see question 1).

## 6. Chapter 1 status (2026-10-18)

Translated and installed: Twinleaf, the player's house (1F Mom, 2F the room and TV), Barry's house and room, the two
other houses, Route 201, Verity Lakefront, Lake Verity, Sandgem, Rowan's lab, Dawn/Lucas's house, the Sandgem Mart
and Pokémon Center 1F, Sandgem's south-west house. 17 script files, 17 text files, the people, signs, triggers and
map scripts; the starter screen shows Turtwig, Chimchar, Piplup. Not in Chapter 1: Barry's first battle (Route 203).
Stubs left in Chapter 1: Pearl's TV jingle and the Starly's wing sound (no Black 2 sound chosen), Rowan's Pokédex
rating (needs the Sinnoh Pokédex), the Mart's Mystery Gift deliveryman (8), and three new-game counters (contest
record, lottery, daily level). Left out of the zones: one item ball (Lake Verity) and two hidden items (Twinleaf,
Lakefront), until the item systems are ported.

Test results: section 8 (offline) and section 9 (in game: **Chapter 1 played from the new game to the Parcel,
2026-10-18 night**).

## 7. Open questions (plain words; recommended option first)

1. **Losing the first battle (the Starly at the lake).** Pearl has no plan for losing it. In Black 2 a normal loss
   **Answered 2026-10-19: as Pearl: the scene goes on and heals, win or lose, plus Pearl's first-battle rules (no critical hits, Fight only).**
   would send you home and replay the lake, giving a second starter.
   - A (now, recommended): your Pokémon are healed and the scene goes on, as Black 2 does for its first rival battle.
   - B: a normal whiteout, with the lake scene marked done before the battle (part of the scene would be skipped).
2. **Signs.** Pearl's signs, signposts and mailboxes are objects that block the way; Black 2 has no such object, its
   **Answered 2026-10-19: B, Black 2's signboard models.** Done 2026-10-20 (b2tools/pearl_signs.py): every Pearl sign
   is Black 2's sign model on its tile (town sign02, route sign04, Trainer Tips and Gym sign01, signboards and
   mailboxes the sign03 plaque, fitted to one tile), the tile solid, and a sign event readable from any side.
   signs are part of the map with a sign event.
   - A (now): each is a person-like object with Black 2's notice-board picture, which blocks the way and is read by
     talking to it, as in Pearl.
   - B (recommended, with the map converter's next round): Black 2's own signboard models placed in the maps, and plain
     sign events. The sign events are ready; the models are map work (the lead's `pearl_buildings`).
3. **Dawn, Lucas and Barry's looks.** Black 2 has no Sinnoh characters walking around. Now: Dawn = Rosa, Lucas = Nate
   (Black 2's player sprites), Barry = Hugh, Rowan = an old professor sheet. Recommended: draw Pearl's characters later
   (the CLASSIC/NEW sprite question).
4. **Music and sounds.** (Decided 2026-10-18: Pearl's own story songs are now installed by sinnoh_music and the
   scripts use them, notes/MUSIC.md "Story songs"; the fanfares and sound effects stay Black 2's.) Before that, stand-ins: Barry's theme = Hugh's, Rowan = Juniper's, "follow me" =
   Black 2's. Two sounds have none yet (TV jingle, Starly's wings). Recommended: keep until the music port.
5. **Where a new game starts.** Now: your room, as Pearl (Black 2's intro and naming first). The alternative is
   Twinleaf's square (skipping Pearl's TV and Mom scenes). Recommended: your room.

## 8. Verified, and how

Offline (no ROM), on copies of Black 2's archives (`sinnoh_events`, `scripts`, `pearl_text`, `sinnoh_story` run on a
scratch folder with a/0/1/2, a/1/2/6, a/0/0/3, a/0/5/6):
- every translated file assembles with pokebw2's macros (the 17 Chapter 1 files and all 446 of the report);
- `sinnoh_story` reports 0 problems: every installed file decodes with Black 2's command table, every script uses
  only commands allowed at its level (this caught a hang: Pearl's `SetObjectEventPos` in Lake Verity's scene, now the
  live-actor form), every line shown exists in the zone's text file, every person/sign/trigger/map script points at
  an entry of the zone's file (this caught Sandgem Mart's map script running Pearl's global 10200, now a proxy);
- a/0/0/3 read back with pokebw2's reader equals the sources; zone headers and entity files read back with `zones.py`
  (Twinleaf: 8 people, 2 triggers, its 4 warps unchanged);
- the starter screen: overlay 316's table becomes `83 01 86 01 89 01` and the art patch runs, on copies;
- **Chapter 1 run through Black 2's bytecode** (`python3 b2tools/story_sim.py chapter1 [--girl] [--lose]`: a small
  interpreter of the assembled files, their text, Pearl's triggers and map-script tables): new game -> TV in the
  player's room -> Mom -> the door warning -> Twinleaf -> Barry's "Thud!!" -> Barry's mom and room -> Route 201
  (Barry joins) -> Lakefront -> Lake Verity (Rowan and Dawn/Lucas, the briefcase: Turtwig/Chimchar/Piplup given at
  Lv 5, the Starly battle, Dawn/Lucas takes the case) -> Lakefront -> Route 201 (Rowan) -> home (Running Shoes) ->
  Sandgem (Dawn/Lucas, Barry's second "Thud!!") -> the lab (nickname question, the Pokédex) -> the town tour ->
  home (Journal, Barry's mom, the Parcel). Every scene ends, the vars it sets start the next one, the counterpart is
  Dawn for a boy and Lucas for a girl, Barry's starter is the one strong against yours and Dawn's the one left (all
  three choices run), a lost Starly battle goes on. Talking to Twinleaf's three people and reading its three signs
  shows their Pearl lines.

Not verified: anything on screen (movement, windows, the battle, the starter screen's pictures, the follower), see
section 9.

## 9. Emulator test

### First run in game (2026-10-18 evening, the lead; DeSmuME muted, `hwtest/story_shot.py`)
Build: `build_rom.py --clean antipiracy sinnoh_world sinnoh_reskin sinnoh_rooms sinnoh_events sinnoh_names
sinnoh_encounters sinnoh_music scripts pearl_text sinnoh_story pearl_starters pearl_title pearl_rods link
pearl_trainer_pics` (work/rom_lead).
- New game -> the player's room (zone 521): the TV report plays with Pearl's text. **Found and fixed**: the TV's
  closing jingle (SEQ_TV_END) had no Black 2 sound, so its PlayFanfare was a stub and the following WaitFanfare
  waited forever. Now SEQ_ME_QUIZ (a stand-in); it was the only unmapped fanfare in all of Pearl's scripts.
- Stairs (8,4) -> the 1F (zone 520): Mom sees you ("!"), gets up, walks over and talks ("... came calling for you a
  little while ago"). At the door Mom's trigger stops you ("Oh, yes! ..."), then the exit mat leads out to Twinleaf.
- Twinleaf: walking to Barry's door runs the "Thud!!" scene: Barry (Hugh's sprite) bursts out, "Hey! I'm going to the
  lake...", "I'm fining you $1 million if you're late!", "Oh, jeez! Forgot something!", back inside.
- The north exit: the man's trigger ("Hiya ... was looking for you.") sends you back, every time, until Barry's room
  scene (Pearl's own order: var 0x4070, VAR_TWINLEAF_TOWN_GUITARIST_TRIGGER_STATE). Not run further yet.
- **Found and fixed**: the rival's name was "Hugh" (Black 2's intro asks for the rival's name with Hugh as the
  default). data/text_overrides/pearl_intro.json makes the default **Barry** (next build).
- Test notes: story_shot's T<x>:<z> can overshoot a tile; exact steps (R4, U1) are reliable. A trigger's scene uses
  up the key press that walked onto it.

### Rowan's intro (2026-10-18, the lead)
- `data/text_overrides/pearl_intro.json`: Black 2's intro lines carry Rowan's speech (pokediamond narc_0341), the
  rival's default name Barry. `patches/pearl_intro.py`: Munchlax (Pearl's intro Pokémon) instead of Cinccino, no
  Aspertia flyover or season card on a new game, no season card on Continue (HoennB2's hoenn_intro edits).
- Tested in game: the whole intro with Rowan's words, Munchlax from the Poké Ball, naming the rival ("Barry..., is
  it? That's your friend's name?"), the farewell, then straight into the bedroom.
- **Rowan's questions (2026-10-18; details and tests: notes/FAIRY.md "Rowan's questions")**: after
  "Barry..., is it?" and before "All right, {player}, the time has come", Rowan asks two questions: "Before you go, I
  have two questions. Your answers can't be changed later. Some researchers now say that Pokémon like Clefairy and
  Togepi are of a new type: the Fairy type. Will you meet the Fairy type on your journey?" (YES / NO, options bit 11)
  and "And the music of your journey... Would you hear the songs of Sinnoh, or those of faraway Unova?" (SINNOH /
  UNOVA, bit 13). The cursor starts on YES / SINNOH. Pearl keeps the rival naming, so no intro script is free (HoennB2
  asks in its dropped ASK_RIVAL_NAME): `patches/pearl_intro.py` QUESTIONS rebuilds the farewell script in ITCM with the
  questions (`src/code/rowan_questions.c`, 19 entries; sScripts[12] points there) and makes intro command 31 HoennB2's
  Intro_SetConfigBit. Text: `data/text_overrides/pearl_intro.json` (game_start lines 26, 27, 28 SINNOH, 30 UNOVA).
  List pearl_intro before fairy (ITCM order). Tested in game both ways (YES/SINNOH and NO/UNOVA; screenshots in
  work/fairy_proofs/). The sprite question (CLASSIC / NEW, bit 14) waits for the NEW sprites; lines 31, 34, 35 stay
  blank for it.
- Open: Rowan's and Barry's pictures (Juniper's model and Hugh's picture still show); the sprite question; the title
  menu still says "UNOVA LINK".

### Pearl's people in the intro and Lucas / Dawn as the player (2026-10-18, user request; the lead)
- `patches/pearl_intro_art.py` (a/1/6/8 graphics only): Rowan's Pearl picture as the professor (Juniper's 64 x 128
  cell 1, one node per pose; checked offline: drawn pixel-exact and still at every tick of her three animations);
  Barry's Pearl battle picture as the friend (Hugh's 80 x 80 slot); the user's Lucas / Dawn artwork
  (`art_sources/intro/`, git-ignored) on the boy/girl choice textures (bright + 28 % dark copies).
- `patches/pearl_player_sprites.py`: the 18 player overworld sheets (Nate 231-239, Rosa 240-248) from Pearl's own
  Lucas / Dawn sheets (walk/run, bike, surf, field-move pose, save pose, Center pose, Poké Ball, arms-out, fishing;
  fishing lines continued past Pearl's 32 x 32 edge), and the battle backs 0/1 (Pearl's standing + throwing frames in
  the donor's big cells; checked offline: every one of the 104 ticks shows exactly one of Pearl's two frames).
- In game (2026-10-18, DeSmuME muted, `hwtest/intro_frames.py`): Rowan stands still through the whole intro, Munchlax,
  Lucas / Dawn on the boy/girl choice, Barry's picture on the friend's band, the Fairy helper's two questions, then
  Lucas (red beret) in the bedroom. Not yet seen in game: the battle back (checked offline only), riding / surfing /
  fishing sheets.

### Every Pokémon Center 1F (2026-10-18, the lead)
- `pearl_story.py chapter 90`: the 16 other Center 1F rooms translated ahead of the story (nurse, PC, people), so
  every Center heals. Built with all 33 zones: 0 problems. Tested in Sandgem's Center (test patch
  `patches/test_story_start.py`, TEST_START=525,8,6): the nurse's YES/NO, "I'll take your Pokémon for a few
  seconds", "We've restored your Pokémon to full health", "We hope to see you again!".

### Chapter 1 played to the end (2026-10-18 night)
Build (work/rom_story, --clean): the full story build list plus `pearl_trainers` (it changes nothing in Chapter 1).
Driver: `hwtest/story_play.py` (muted; one emulator at a time). A cold boot, then the whole chapter in short runs with
savestates in between:

    story_play.py ROM OUT boot 521 4 6 ADV GO8,5 STEPU WAITZONE520 ADV GO6,9 STEPD ADV STEPD WAITZONE427 ADV ...

- **Works in game, in order:** the TV report; Mom ("BARRY came calling"); the door warning; Twinleaf; Barry's
  "Thud!!" at his door; Barry's mom; Barry's room ("...I'd better take my Bag and Journal", "$10 million fine");
  the north exit opens; Route 201: Barry joins and follows; Verity Lakefront ("To the lake!"); Lake Verity: Rowan
  and Dawn talk and leave, the briefcase, the Starly attack, the starter screen (Turtwig, Chimchar, Piplup), the Starly
  battle (won), Barry's comment, Dawn takes the briefcase; the Lakefront (Barry stays behind); Route 201: Rowan and
  Dawn, then home; Mom and the Running Shoes (flag 2403 set); Sandgem: Dawn's escort, Barry's second "Thud!!", the
  lab: Rowan gives the starter, the nickname question (NO), the Pokédex question (YES): "obtained the Pokédex" (flag
  2402 set); Dawn's town tour (Pokémon Center, Mart, "let your family know"); home: Mom heals, gives the Journal, Barry's
  mom brings the Parcel. Both end up in the Key Items pocket. The Sandgem nurse still heals.
- Not run in game: losing the Starly battle, a girl player (Lucas as the counterpart), Turtwig or Piplup on screen
  (offline all three run: section 8).
- **Found and fixed:**
  - Sandgem's Dawn trigger never fired: Black 2 checks a trigger's height (within 2 units, ov012
    CheckTriggerPositionMatchXYZ), and the trigger took the height of its corner tile (22, a raised edge) instead of
    the path's (16). `pearl_events.py` now gives a trigger the most common height of its walkable tiles (the only
    trigger of all installed zones that changed).
  - Mom's Journal scene hung (and the emulator later hit an undefined instruction): her balloon and the "Obtained the
    Journal!" window were open at once when her next line came. Pearl has one message box. The translator now tracks
    which window may be open at every line (a dataflow over each script, sub-scripts and common scripts that show
    lines included) and closes it before another speaker's line (`MsgWinCloseAll`). This also added a few closes in
    the Pokémon Center nurse's script (retested in Sandgem: heals as before).
  - The Journal and Parcel went "into the ITEMS Pocket" with the item jingle: Black 2 numbers the pockets differently
    (0 items, 1 medicine, 2 TMs, 3 berries, 4 key items; Pearl 7 = key items) and its pocket-name command takes an
    item, not a pocket. `pl_GetItemPocket` now gives Pearl's numbers and `pl_BufferPocketName` names a Pearl pocket
    through an item of it. Now: "PLAYER obtained the Journal!", "put the Journal in the KEY ITEMS Pocket."
- Still open in Chapter 1: Barry's mom's lines appear in a balloon over Mom (the talked-to person; the lines carry
  "BARRY's mom:" so they read right; `data/pearl_speakers.json` can give them to her); the Starly's wing sound (no
  Black 2 sound chosen); the test names (A presses typed "AAAAAAA"/"BarryAA": not a game problem).
- Shots: work/shots_2026-10-18/story_ch1_sandgem_tour.png, story_ch1_home_mom.png.

### Chapter 1 as Dawn, and Chapter 2 (2026-10-19, the lead)
Build: the full list plus `pearl_trainers` (sinnoh_story 83 zones, 0 problems; 28 trainers). Driver: story_play.py with
`PLAY_GIRL=1` (the intro's boy/girl menu is left/right: RIGHT picks Dawn) and `PLAY_RUN=1` (run from wild battles:
DOWN goes to BAG, so RUN is DOWN, RIGHT).
- **As Dawn, works in game:** the pink bottom screen and Dawn's sprite; the TV; Mom; Barry's "Thud!!" and his room;
  Route 201; Lake Verity with **Lucas** as Rowan's assistant ("Lucas: Whew! You found the briefcase?"), the starter
  screen, the Starly battle (Chimchar), Barry picks Piplup; Rowan and Lucas on Route 201; Mom and the Running Shoes.
- **Found and fixed: a black-out at home.** Black 2 runs script 2 of the zone you wake up in (ov012
  EventBattleLose_Callback; 2001 at a Center). In the translated house that is Pearl's script 2, Mom's opening scene
  ("Barry came calling..."): the party stayed fainted (Black 2 heals in that script), the story went back, and talking
  to Mom then crashed the emulator. Pearl runs common script 2020 there (pokediamond blackout.c): the house file now
  has it as entry 40 (pearl_story BLACKOUT_ENTRY) and patches/sinnoh_respawn.py changes the call (0x0215A126 `movs r1,
  #2` -> #40).

- Chapter 1's end as Dawn: Lucas's Sandgem tour, Mom's Journal and the Parcel (talk to Mom: her talk script checks
  the Pokédex flag), both in Key Items. A second black-out (Route 202) also ran Pearl's 2020 scene and healed.
- Chapter 2 so far: Route 202's catching demo runs (Pearl's since 2026-10-20: patches/capture_demo.py, the
  counterpart's starter catches a Bidoof with Pearl's lines and Dawn's/Lucas's back picture); Lucas gives the
  Poké Balls. Trainers: Youngster Tristan (eye contact from (166, 813), walks up, battle, "Too strong!", prize, the
  field comes back) and Lass Natalie (two Bidoof) work; Youngster Logan's Shinx (Intimidate) beat a Lv 8 Chimchar ->
  black-out home. The win line "Player defeated Youngster Tristan!" is Black 2's own text (system 0017
  PlayerDefeated). Route 202's north half is reached through the west grass (row 823 is a ledge).
- With the test team (as Dawn): Route 202's three trainers (Tristan, Natalie, Logan); Jubilife: Lucas at the south
  entrance ("Whoa! You already have 6 Pokémon"), the Trainers' School (Barry takes the Parcel, gives the Town Map,
  leaves for Oreburgh), the Pokétch president outside the school (he wanders: move 13), the three clowns' quizzes
  (Coupons 1-3, the third with a YES/NO menu), the president takes the Coupons and gives the Pokétch; the east exit
  opens; Route 203: Barry's battle (Starly, Piplup; "PKMN Trainer" class; prize $900). The driver needed: B only at
  Black 2's "Will you switch your Pokémon?" (Shift style opens the party screen at once).
- **Found and fixed: Route 203 drew nothing** (only the sky colour: no map, no player) from its first step: its zone
  header kept a Unova camera boundary (431), which held the camera on Unova coordinates. `sinnoh_world` now gives every
  Sinnoh overworld zone 0xFFFF (none), as `sinnoh_rooms` gives the rooms; Black 2 uses 0 as a real boundary too.
- **Found and fixed: the Pokétch president could not be talked to** after the third clown: Pearl's SetPosition put
  him at Pearl's y 1, a level below Jubilife's converted ground (2), so Black 2 neither drew him nor let the player
  talk to him (and the player walked through him). `pearl_story.grid_y` now uses the converted map's tile height
  (Black 2 steps of 16 units, floored as the engine) for SetPosition / SetObjectEventPos / SetObjectEventDir on
  constant tiles: Lucas at Jubilife's entrance, Barry in Oreburgh, Mom and a Sandgem person moved too. (The first run
  only worked because the president was talked to before the third clown moved him.)
- Oreburgh Gate (HM06 from the man inside, Camper Curtis, Picnicker Diana), Oreburgh (a local walks the player to the
  Gym; Barry: "the Gym Leader's... at Oreburgh Mine") work. The gate is entered walking east (as Pearl) and left by
  its exit mat (stand on it, press right).
- **Found and fixed: Roark's Rock Smash scene in Oreburgh Mine hung.** Pearl's StartDestroyObstacleAnimation
  (obstacle, result var) sets its var when the animation ends and the script loops until then; the translation now
  sets the var at once (no breaking animation in Black 2), also in Oreburgh Gate 1F/B1F.
- Barry walks around with Pearl's sprite (pearl_npc_sprites: Hugh's 17-frame sheet).
- **Chapter 2 plays to the end (2026-10-20, test ROM starting at Oreburgh Mine: TEST_START=62,302,793 TEST_TEAM=1):**
  Mine B1F/B2F (the exit mats), Roark's Rock Smash scene now ends (the boulder, "Fallen boulders need to be smashed"),
  Roark leaves, Barry has left the Gym door, Oreburgh Gym: Youngsters Jonathon and Darius, Roark (Geodude, Cranidos,
  Onix; his in-battle lines), the Coal Badge (flag 2414), TM76 with Pearl's lines (Black 2's TM76 move until the TM
  work). Still to do (visual recheck, user 2026-10-19): film Chapter 2's scenes after the opening agent's fixes;
  visuals agent: black void below rooms/caves at map edges, the Gym's colours.
- Testing from here uses a test build with `test_team` (TEST ONLY: Lv 100 Palkia, Dialga, Giratina, Heatran, Darkrai,
  Arceus in the PC; the user's idea, as HoennB2's Lv 100 Groudon).
- **Glitch pass on Chapter 1 (2026-10-20, the opening agent; the user's reports from playing it):** filmed again from
  a new game, as Lucas and as Dawn (work/agents/opening/shots/ch1_01-19). Found and fixed:
  - **Stairs worked like a door / Mom walked into the player.** Pearl's stairs tile 0x5E/0x5F is the FOOT (walkable);
    the flight is the tile beyond it. The one type-2 warp now sits on the flight (solid, a 45-degree slope from the
    foot's edge), and arriving players land on the foot, where Pearl's scenes expect them (sinnoh_events, pearl_chunk).
  - **Mom walked off the map (Running Shoes).** Pearl's SetPosition + SetDirection pair: the second was translated by
    sending the old tile again. Now the direction keeps the new tile (also one line each in Jubilife and Sandgem).
  - **Rowan stood outside Twinleaf for good; Dawn/Lucas came back in Sandgem.** Pearl's copies of a neighbouring
    zone's objects (script 0xFFFF) reuse the original's id, and their "hide flag" field is the original zone's id.
    Scripts now never address copies, and each copy hides exactly when its original does.
  - Barry's mom's lines in Mom's window (data/pearl_speakers.json); the Parcel line in Barry's window in the Trainer
    School (plain window); Jubilife's counterpart always at x 175 (places set mid-scene are kept in vars
    0x8030-0x803E); SetWarpEventPos gave height 0 (Valley Windworks, Chapter 3); dropped item balls shifted later
    people's index (11 later zones); warps on plain floor fired on any bump (now arrival points only, dest 0xFFFF).
  - The player at home after the starter stands where Pearl puts them (2,6); "head in the table" is the counter model
    drawn over the sprite (the user to look in melonDS).
  - New checkers: `python3 b2tools/scene_check.py [chapter N]` (plays every scene offline, from Pearl's script and from
    the generated .s: walks into walls/people, wrong facing, people on solid tiles, wrong hide flags, arrivals on
    triggers; reproduces all four reports on the old files) and `python3 b2tools/warp_check.py offline`. Both clean on
    chapters 1, 2, 90; scene_check lists 14 possible problems in chapters 4-9 for their agents.
  - Saves made before this build keep Rowan's old flag: only new games show the Rowan fix.
- **Found and fixed (2026-10-20): Jubilife's counterpart was only a shadow** (and 3 Jubilife people were invisible).
  Black 2 has 32 billboard materials per field, one per sprite code in use; a zone header's npc_cache < 24 preloads
  an a/0/5/7 list of Unova codes into them for the whole field. sinnoh_world/sinnoh_rooms had kept Black 2's value in
  43 overworld zones and 7 outdoor rooms: Jubilife's list 1 (26 codes) + the player left 5 entries, all taken before
  the counterpart (RAM: cache 32/32, no entry for 240). Every Pearl zone now has 24 (no list); Jubilife at the scene
  holds 13 of 32, 240 among them. The counterpart keeps codes 231/240: Pearl draws the counterpart with the player's
  own sheet (hero/heroine), which those codes carry. sinnoh_story's 30-sprite check counts a kept list. Filmed as
  Lucas and as Dawn, and Sandgem's tour (work/agents/counterpart/shots/).

### Chapter 2 (prepared 2026-10-18; installed 2026-10-19)
- `pearl_story.py` CHAPTERS[2] lists Route 202 to Roark's Gym (50 zones: Route 202, Jubilife and its buildings,
  Route 203, Oreburgh Gate, Oreburgh and its buildings, the Mine, the Gym). Left out: Jubilife's south-east house 4F
  (its script file 368 is the empty file of 114 zones: sinnoh_story would install all of them), the Center 2F/B1F
  rooms (the shared 2F) and the Route 218 gate. All 50 translate and assemble, and one build installed them with
  0 problems (83 zones). The generated files are NOT in src/ now (untested; in the Trash): run
  `python3 b2tools/pearl_story.py chapter 2` to make them again.
- New translations for it: the catching tutorial (Black 2's capture demo; patches/capture_demo.py makes it Pearl's:
  the counterpart's starter vs Bidoof, pokeplatinum FieldBattleDTO_NewCatchingTutorial), FindPartySlotWithMove
  (= Black 2's PokePartyHasMoveAny),
  CheckPartyHasSpecies (PokePartyFindBySpecies), the Pokétch (EnablePoketch, apps: nothing; checks: 0 until the
  simplified Pokétch exists), journal events, contest accessories, the HM cut-in and rock-breaking animation (nothing;
  the scripts remove the rock themselves).
- Still stubbed there (no story effect): Jubilife's group commands (38), the TV station's interviews and rankings, the
  GTS, the Mining Museum's fossils, an NPC trade (Oreburgh), Strength (Oreburgh Gate B1F), the Galactic tag battle
  (Jubilife, after Roark: Chapter 3).
- Known: Roark gives Pearl's TM76 (item 403), which is Black 2's TM76 move until the TM work; the east exit of
  Jubilife opens after the Pokétch (var 0x4077 = 2), whose scene is translated.
- Trainers for it: notes/TRAINERS.md "Ready to install".

### Chapter 3: Floaroma and Eterna (2026-10-25, the ch3 agent)
40 zones (data/story_chapters.json "3"; Jubilife's south-east house 4F and five Old Chateau 2F rooms, on Pearl's
empty script file 368 with nothing to install, moved to "skip"). Generator additions (b2tools/pearl_story.py,
src/include/pearl_story.inc):
- PearlData.text_file: 72 script files use Pearl's bank 18 (Jubilife's) as "no text"; each translated file appends
  its common scripts' lines to its own text file, so a file on a shared bank gets its own a/0/0/3 number after the last
  bank's (1051 + rank), unless it shows the bank's lines (Jubilife). sinnoh_story and story_sim use it.
- StartTagBattle (Pearl 0x2A0 partner, opponent 1, opponent 2) -> pl_StartTagBattle = Black 2's
  CallTrainerMultiBattle (as its Lacunosa scene). Jubilife's partner is a var set by the starter (613-618): a chain
  over the values the script sets it to just before (tag_partner_values).
- SetMovementType X, 0x30 after Pearl's partner var 0x403F (Cheryl 608) -> pl_follow_start_ally: ActorPairSet with
  the ally trainer. Black 2 then does Pearl's partner battles itself (ov036 event_trainer_eye: two trainers who see
  you + GetNowFollowerAllyTrID = CallTrainerMultiBattle; field_encount pairActive: wild doubles with the ally; global
  3816 heals the party after a multi battle won). Not persistent when the same file ends the follow, so
  ActorPairEnd gives the NPC back its id (Cheryl's "Are you going back?" moves object 0 afterwards).
- A script that a step trigger also runs is not a talk script (kind_of): Black 2's ParentActorMsg shows nothing when
  no person was talked to (ov036 scrcmd_msg.c), and Valley Windworks' Mars scene is both his talk script and the
  trigger's. Its lines use the plain window.
- SetBgEventPos (Pearl 0x18B) -> ObjInitPointGPos: the Windworks door's "It's locked" sign moves away once opened.
- data/pearl_speakers.json: Eterna Galactic Building 4F line 4 (said after Jupiter, the talked-to person, left),
  Floaroma's and Route 205 S's grunt pairs (one talk script, one line each), the Windworks door's "Ker-chunk!".
- World: pearl_chunk.floor_mats (rooms): walkable warp mats sat on their door frames (Eterna Gym entrance (8, 2) 30
  units over a -2 floor: the Gym could not be entered); they take the floor of the tile they are walked onto from.

Played in game (test starts Jubilife after Roark, then Eterna; Lv 100 test team), proof in work/agents/ch3/shots/:
Jubilife's Galactic tag battle with Dawn (and once with Lucas), Route 204, Ravaged Path Rock Smash (Coal Badge),
Floaroma's gate grunts, Route 205 S's girl, Floaroma Meadow (two grunts, Works Key, Honey), Valley Windworks (door
grunt, the Works Key door, Mars, the father and his daughter), Eterna Forest (Cheryl joins, a partner multi battle,
wild doubles with her, her goodbye at the exit), Cynthia's HM01, Gardenia at the Gym entrance; then (second
test start in Eterna, on the latest decomp base) the Gym entrance mat into the Gym, the four Gym trainers in order
(each one appears after the last), Gardenia, Forest Badge (flag 2415), TM86, Cut on the Galactic Building's trees
(Forest Badge), the building's stairs, Commander Jupiter (the owner's line in her own balloon), the Bicycle, the
Explorer Kit, Eterna's south exit to Route 206 with the Kit, and the Old Chateau entrance through the forest's Cut
tree (before the Bicycle: after it, Pearl's bike girl turns you back at Eterna's west exit until Route 207 sets var
0x411B to 2). Not entered: Old Chateau 1F (a wild Gastly knocked out a test Pokémon and story_play stalled on the
"choose the next Pokémon" screen), Fuego Ironworks (Surf). floor_mats moved 62 tiles in 46 room chunks (60 north mats,
the GTS's exit mat, one Ruin Maniac Cave mat); warp_check offline clean; pearl_rooms_view totals 1 / 158 / 7041 ->
1 / 157 / 7040 (feet, people, player).
Left as Pearl-only or other systems: Pearl's alternate zone music (OPEN_CONTENT), the Eterna Gym trainers' facing
after their battle (SetObjectEventDir on an object from a var), the Bicycle's SetSpawn (Black 2 sets its own Center),
SetPlayerBike (the forest gets the player off the Bicycle), CheckShouldShowGhost (Old Chateau's ghost never shows),
Underground goods/spheres/traps (the Underground Man's missions after the Kit), berry soil, NPC trades, specialty
shops (Herb Shop, Floaroma flower shop), Mystery Gift.

### Chapter 4a: Route 206 to Hearthome (2026-10-25, the ch4a agent)
28 zones (data/story_chapters.json "4": Route 206 and its Cycling Road gatehouse, Wayward Cave 1F/B1F, Route 207,
Mt. Coronet south 1F, Route 208 and the Berry Master's house, Hearthome and its 18 buildings, Amity Square); Chapter
4b's zones (Route 209 to Veilstone) are generated by its own agent. Generator and world additions (shared):
- Pearl's empty script file 368 (114 zones with no scripts of their own): each such zone gets its own script and text
  file (PearlData.shared_file_zones, script_file, text_file, zones_of_script_file; sinnoh_story and pearl_trainers
  install by zone). Zones there with items or people are no longer skipped (Wayward Cave B1F, Old Chateau 2F rooms).
- Names Black 2 has no word for (NAME_SOURCES): Pokétch apps (BufferPoketchAppName, Pearl bank 406 in Black 2's
  case) and Contest Accessories (GetFashionName / GetFashionNameWithArticle, banks 338/339): a line naming one gets
  the name written in, a copy per name (FileTr.app_bufs; a var set just before is a constant; common scripts'
  var 0x8004 is a chain over what the zone's callers set). Route 207's "obtained the Pokétch app Dowsing Machine"
  (before: the Vs. Seeker's name), Keira's "Obtained the Glitter Powder!" (before: the player's name), Cheryl's Big
  Tree in Eterna Forest.
- Closed places: data/pearl_closed_facilities.json + pl_closed_facility (a plain-window line, then one step back):
  the Contest counters and the Amity Square gatehouses. The Contest Hall lobby stays open: its first visit is Mom's
  and Keira's scene, which opens Hearthome's east exit and arms Barry's battle.
- Rooms only a script Warp reaches get zones (allocate_sinnoh script_warp, appended: the Hearthome houses' 2F, the
  Vista Lighthouse deck); elevators translated (pearl_story ELEVATOR_FLOORS_ABOVE: a zone-init entry per floor and
  elevator room, GetFloorsAbove, SetSpecialLocation = FieldSetNextZone, the ride = Black 2's lift sounds).
- warp_check also checks where every script Warp lands.
Played in game (test start Route 206 below the Eterna gate, Lv 100 test team, as Lucas; proof in
work/agents/ch4a/shots/): Cycling Road walked down with three Cyclists' battles, the Cycling Road gatehouse (the
Bicycle check passes), Route 207's scene (Dawn walks up from the south to the player's side, the "which hand" menu,
the Vs. Seeker, the Dowsing Machine app, var 0x411B = 2: Eterna's west exit opens), a Camper/Picnicker double
battle, Mt. Coronet south 1F (east-facing entrance, Cyrus comes down the stairs, his monologue, the player steps
aside, Cyrus leaves west), Route 208 (Hiker), the Hearthome gate, Keira's Buneary scene, Fantina at the Contest
Hall door (her talk, she walks away), the Contest Hall lobby (Keira and Mom: the Accessory, the Tuxedo; the Route
209 blockade hidden), Amity Square's gatehouse closed ("Amity Square is being prepared. Please come again!", the
player steps back), Barry's Hearthome battle (trigger at the north street; Starly, Grotle, Ponyta, Buizel; his
lines; var 0x407B = 2). Not played: the accessory name line (fixed after the run: offline only), a closed Contest
counter (the middle one has Pearl's own NPC on its tile; the side ones use Amity's tested macro), Mira (Wayward
Cave: waits for 6a's partner change), the elevators and the Hearthome houses' 2F (in the build, not walked:
the Shell Bell house is a side visit), riding the Bicycle (Black 2's own; Y-register in the Bag: melonDS).
Graphics seen: the Cycling Road gatehouse roof hides the player at its north door (Black 2's camera; RESUME's
graphics list), Fantina drawn as a white X while walking (PWT sheet lacks her movement frames; the sprite pass),
stand-ins: Keira (pink-hat girl), the Rock Smash rocks (Black 2's grey rock).
Left as Black 2 gaps: Pearl's Cycling Road mode (ForceBicycling / RideBike: the road can be walked; Black 2's bike
works as everywhere), the Vs. Seeker (given; rematches wait for the rematch work), the Dowsing Machine app (no
Pokétch yet), berry soil, Poffins, Contests, Amity Square, the Underground's Mr. Goods.

### Chapter 4b: Route 209 to Veilstone (2026-10-25, the ch4b agent)
50 zones (data/story_chapters.json "4" without 4a's 28: Route 209 and the Lost Tower 1F-5F, Solaceon and its 6
buildings, the Solaceon Ruins (18 rooms), Route 210 South, Route 215, Veilstone and its 15 buildings). Pearl's order,
from its scripts: Route 209 (Good Rod), Lost Tower 5F (the old ladies: HM04 Strength and the Cleanse Tag; no Spell
Tag), Solaceon (Day Care, Pokémon History app), Route 210 South, Route 215, Veilstone: the counterpart meets you
(trigger), Maylene (Cobble Badge = badge 2, TM60; sets 0x411A = 1, 0x407D = 1), leaving the Gym the counterpart's
Pokédex is gone (frame table 0x411A == 1), the tag battle with the counterpart (621-626) against grunts 848/849 at the
warehouse (flag 0x101), then HM02 Fly is an item ball in the warehouse's front room. HM05 Defog is Pearl's Great Marsh
Area 6 (Chapter 5a), not the Solaceon Ruins. Beats of later chapters in these zones: Route 210 South's Psyduck and
Cynthia's SecretPotion scene (5b), the Storage Key under the grunt Lake Acuity brings back (6b/7) and the warehouse's
inner door.
Generator and data additions (shared):
- Story item balls: data/pearl_item_balls.json installs Pearl's 5 HM / key-item balls (HM02 and the Storage Key here;
  the Galactic Key, HM08, the Lunar Wing in Chapters 7, 6b, 9) as people with the item-ball sprite, each running
  Pearl's own item-ball script (file 370 n + 256) from an entry after PearlArrive (PearlData.item_ball_ids); the flag
  rule in one place (pearl_events.item_ball_flag); the ball's RemoveEvent sets its flag (pl_RemoveTalkedObject).
  Every other ball waits for the item-ball port (the table can grow).
- Zone-init copies of subroutines (FileTr.call_label): a subroutine with level-dependent commands (AddObject,
  RemoveObject, SetObjectEventPos/Dir) that a zone init and another script both call gets a level-2 copy. Veilstone's
  zone init placed the counterpart through the subroutine its Pokédex scene also calls: it turned the live actor
  (not allowed in a zone init: a hang on every entry after the Gym). No other installed zone has the pattern.
- Black 2's party select for Pearl's ChoosePokemonMenu + GetSelectedPartySlot (CallPokeSelect; Pearl's fades and
  RestoreOverworld around it dropped): the Veilstone massage girl, the Jubilife TV gallery, the Eterna nickname
  checker. Specialty / decoration clerks (SpecialMart, GoodsMart) open Black 2's normal Mart until the specialty
  marts are ported: the Veilstone Department Store's 8 clerks, the Pokémon Marts' second counters, the Herb Shop.
- The Day Care on Black 2's Day Care commands with Pearl's lines (pearl_story.inc "the Day Care": state, names,
  deposit through Black 2's Day Care list, levels, price, withdraw, the Egg, compatibility; the withdraw menu's gender
  symbol as line copies). Solaceon's zone init reads Black 2's egg work 0x417F (its Day Care commands are not allowed
  there).
- MessageUnown (the Ruins' walls, the maze's "TOP RIGHT, LOWER LEFT..." hint) in Latin letters; ItemIdIsTMOrHM;
  natures (Solaceon); friendship (massage girl, no Accessory: no Contests); the News Press assignment (a random seen
  Pokémon, pl_GetRandomSeenSpecies; "today" = the new daily flag PFLAG_NEWS_PRESS_TODAY 2762, pearl_ids
  NEW_DAILY_FLAGS, which Black 2 clears at midnight).
- Closed (data/pearl_closed_facilities.json): the Game Corner's floor (slots and coins: Black 2 has neither) and the
  Prize Exchange clerk. data/pearl_speakers.json: Veilstone's grunts after the tag battle, Route 210 South's Psyduck
  narration and Cynthia.
- b2tools/pearl_veilstone_gym.py: Pearl's Gym panels read from the dump (12 sliding wall panels, models 287-293, push
  spots, collision per state), the data for gimmick id 60 (after Chapter 6a's dispatcher is merged); until then the
  Gym is open as converted (Maylene reachable).
Checked offline: Chapters 1, 2, 90, 3, 4a regenerate unchanged except the 7 specialty clerks and the 2 party selects
(work/agents/ch4b/other_chapters.diff); scene_check and warp_check offline clean; sinnoh_story's checks (a copy that
needs no ROM) pass on all 204 installed zones.
Played in game (two test builds, as Lucas, Lv 100 test team; proof in work/agents/ch4b/shots and play/): from
Hearthome's east exit (4a's end state): Route 209 and its trainers, the Lost Tower 1F-5F (stairs entered walking east
onto Pearl's stairs foot), the 5F ladies (HM04 Strength, the Cleanse Tag), Solaceon's Day Care (two Pokémon left
through Black 2's list, the Day-Care Man's lines and compatibility, both taken back through the menu at $100 each),
the Solaceon Ruins' wall hint (reached by Pearl's south ledges), the News Press assignment (a random seen Pokémon,
"today"), Route 210 South's Psyduck block holding, Route 215's first trainers. Route 215 cannot be crossed in the
converted map (its road passes under Pearl's two-level bridges; the bridges world fix), so the second build starts in
Veilstone (TEST_START=120,680,598): the counterpart's first meeting (trigger south of the Gym), the Gym (Black Belts,
Maylene: Meditite, Machoke, Lucario), the Cobble Badge and TM60, the Pokédex scene on leaving the Gym, the tag battle
with the counterpart against the two grunts (the grunts' lines in their balloons), HM02 Fly from the warehouse's ball
(Pearl's "found an HM02 Fly!", the ball gone), the warehouse grunt and the locked inner door, a Dept Store specialty
clerk, the Game Corner floor and the Prize Exchange clerk closed, the massage girl through Black 2's party select,
Fly (Veilstone on the Sinnoh map, landing at the Center). End state read back: 0x411A = 2, 0x407D = 1, 0x40F5 = 1,
flags 0x101, 0x1DD, 0x1C6, 0x9D, the Cobble Badge flag 2416.
Found and fixed in game: Pearl's 6 elevator rooms put an entering player at (0, 0) off the room (their exit, Pearl's
dynamic warp, was dropped as "not installed": now Black 2's next-zone warp, patches/sinnoh_events.py); every Mart's
regular clerk opened one Unova town's list (pl_PokeMartCommon shop id 0; now 255, Black 2's badge Mart); the Day
Care withdraw menu cut "Lv. 100" off (Black 2's list menu ignores Pearl's cursor move: a space). Third build: the Dept
Store elevator rides (walk in on its mat, the attendant, 5F, out onto 5F) and a clerk sells Black 2's badge Mart
(Poké Ball ... Parlyz Heal at 2 badges); sinnoh_events now drops 0 warps.
Graphics seen: the Day Care room shows sky and a grass floor east of its wall (zone 549; the rooms world fix); trees
south of the warehouse hide the player and the counterpart during the tag-battle scene (Black 2's camera); the Fly
cut-in and landing show Black 2's Nate (the sprite pass); the usual black area under room edges (Ruins 1F).
Black 2 gaps left: Maylene's TM60 teaches Black 2's TM60 (Quash) while her line describes Drain Punch (the TM work);
the Day Care's "took X back" and "received the Egg" narration in the talker's balloon (common-script lines);
Seals and Ball Capsules (the Seal House gives the Seal Case only); the Game Corner and its prizes (closed); berry soil;
the meteorites' Deoxys forms; the Hallowed Tower (post-game); Pearl's sounds for the cash register, vending machine and
massage (no Black 2 sound chosen).

### Chapter 5a: Route 214 to Pastoria (2026-10-25, the ch5a agent)
32 zones (Route 214 and its Veilstone gatehouse, the Ruin Maniac's cave stages 1-3, Valor Lakefront with the Hotel
Grand Lake's two rooms and the Seven Stars Restaurant, Route 213 with its Pastoria gatehouse, Dr. Footstep's house
and the Grand Lake reception and rooms, Pastoria and its Mart, Gym and houses, the Great Marsh gate 1F/2F and areas
1-6); Chapter 5b's zones (Route 212 to Celestic) are generated by its own agent (`pearl_story.py zones ...`).
Additions (shared):
- **The Pastoria Gym's water** (Pearl: pokeplatinum overlay008/gym_features.c PastoriaGym_*; without it the gaps
  between the walkways are 64-unit pits and Wake can't be reached): decomp src/pearlb2/pastoria_gym_itcm.c, gimmick 30
  of GIMMICK_OVERLAY_INFO (an empty slot) for the Gym's zone, Pearl's water model (build model 242) as an expanded
  object moving a unit a frame, and the water as one more terrain layer (FieldG3DMapper_GetTerrainAll ->
  PearlB2_AppendTerrainLayers): solid over the pool's tiles, walkable over the gaps, so Black 2's nearest-layer and
  20-unit rules give Pearl's puzzle. patches/pastoria_gym.py (the table: plate tiles from Pearl's behaviour 0x59, the
  10 buttons from Pearl's props 239-241 checked against the step triggers, the converted floors -2/30/62 for Pearl's
  water 0/32/64), handlers PressPastoriaGymButton (pl_PressPastoriaGymButton: a water sound, the press work
  PVAR_PASTORIA_GYM_PRESS = 0x401D, waits for the C, gives up after 8 s) and InitPersistedMapFeaturesForPastoriaGym.
- **The Great Marsh as HoennB2's Safari Zone** (user 2026-10-25): StartEndSafariGame -> pl_SafariStart (30 Safari
  Balls into the Bag) / pl_SafariEnd (the leftovers taken); GetPCBoxesFreeSlotCount -> BoxGetCount kind 5; Pearl's
  register sound SEQ_SE_DP_REGI -> SEQ_SE_SYS_22 (HoennB2's). Its six areas share one Pearl matrix with a zone per
  cell: areas 1-5 got zones 585, 550, 608, 84, 85 (allocate_sinnoh GREAT_MARSH_ZONES; notes/ZONES_KEPT.md: the
  last free zone and four that nothing in Black 2's code, scripts or zone tables names) and sinnoh_rooms writes the
  marsh's matrix in format 1 (rooms['cell_zones']); every old zone kept its number (data/sinnoh_world.json: only
  additions). The 2F binoculars and the six Quick Tram stops: data/pearl_closed_facilities.json bg rows.
- GetHour -> RTCGetTime (the Seven Stars Restaurant's open hours), CountAliveMonsExcept with a slot past the party ->
  PokePartyGetCount kind 2 (the restaurant's and Jubilife TV's double-battle checks).
- story_play: "doesn't affect" counts like "no PP" (the next move); WILDSTOP<dir> (a wild battle, then stop: a ball
  thrown by TOUCH: BAG 40,165, the Poké Balls pocket 192,48, the first ball 64,30, USE 128,175).
Played in game (two builds, the Lv 100 test team, as Lucas; proof in work/agents/ch5a/shots/):
- Build 1 (start: Pastoria at the Gym door): the Gym (the water rises and falls a unit a frame, the rafts bridge the
  gaps at each level, 6 presses in the solved order, the Gym trainers, Wake: Fen Badge (flag 2417), TM55), out by the
  outer corridor at the top water; Pastoria's grunt ("the package", the "!", his run east), his second talk, Barry's
  "Whoops!" and battle; the Route 213 gatehouse both ways; the Route 213 grunt's run; the Grand Lake reception's two
  doors; Valor Lakefront: the grunt's talk, his run, his battle, Cynthia's SecretPotion (5b's Psyduck item, given in
  5a's zone); the Ruin Maniac's cave (entered walking west, as Pearl's 0x6D warp).
- Build 2 (on main's HEAD; start inside the Gym): a Gym battle on Black 2's indoor background (zone_flags), out of
  the Gym; the Great Marsh gate: the 2F binoculars' closed line, the attendant's $500 and 30 Safari Balls, area 6
  (zone 536: a wild Quagsire caught with a Safari Ball after 4 throws), walking west into area 5 (the zone changes
  to 85: a wild Azurill, its person's lines about the Quick Trams), the Quick Tram's stop (the menu showed and the ride did nothing: its six
  stops now show a closed line, data/pearl_closed_facilities.json, generated after the run, the binoculars' tested
  form), out of the marsh ("I'll relieve you of your remaining Safari Balls": none left, var 0x40DA back to
  0); Route 213 -> the reception -> Valor Lakefront -> Route 214 (Psychic Abigail's Gastly beaten) -> the Veilstone
  gatehouse's south door both ways.
Not played: the Seven Stars Restaurant's double battles (translated: GetHour, CountAliveMonsExcept), the hotel rooms,
Dr. Footstep, Pastoria's houses, the Ruin Maniac's stages 2-3 (Unown count: stub).
Graphics seen: Black 2's wider camera shows the void past room edges (the Gym's entrance and outer corridor, the
Route 213 gatehouse's west end: MAP_LOOK 1d, pending); the Great Marsh gate 1F has a black block between the
corridor and the stairs (tiles (6-9, 4-7): to compare with Pearl); Pearl's Gym buttons stay up when pressed.
### Chapter 5b: Route 212 to Celestic, Fantina (2026-10-26, the ch5b agent)
32 zones (Fantina's Gym: 4 question rooms, 8 trainer rooms, the Leader's room; Route 212 N/S with the Pokémon Mansion's
3 rooms and the weather/shard TM house; Route 210 N with the café and Grandma Wilma's house; Routes 211 W/E; Mt.
Coronet north 1F rooms 1-2; Celestic and its 5 rooms). Additions:
- **Fantina's Gym, Pearl's own** (DP's quiz rooms, not Platinum's; pokediamond InitHearthomeGym 0x02064CC8, the lift's
  set-up ov06_0224186C, MoveHearthomeGymElevator 0x02241914): each question room's lift (Iron Island's model 258, put
  there by Pearl's code at (152, 216) units over a 3 x 2 plate, trigger (9, 13), 0 <-> 160 a unit a frame) is a
  gimmick 59 platform lift (b2tools/pearl_gimmicks.py HEARTHOME_LIFTS: the converted floors -2/158, the model at
  Pearl's 0/160; rooms 2-4 share one chunk and its one added prop). Pearl closes the Gym while Fantina is away by
  leaving the first room's lift up and its trigger off until flag 0x98D (Celestic Ruins' mural): gimmick 59's
  platform struct got a flag (the old pad; decomp pearl_platforms_itcm.c IsWaiting: up at B and still while the flag
  is clear), patches/pearl_platforms.py writes it by its pearl.h name. check_prop_indices: Pearl's door records name
  no door resource (NO_DOOR), so its doors before a lift take one prop index (the Gym's three top doors).
  Generator: h_hearthome_lift (the two Pearl commands: gimmick 59 does it); Pearl's "Correct!" board sound
  SEQ_SE_DP_UG_020 -> SEQ_SE_DECIDE2 [guess]; SEQ_SE_DP_MAZYO4 (the quiz board) still has no Black 2 sound.
- **Move tutors** (Grandma Wilma's Draco Meteor; Route 228's ultimate moves, chapter 9): GetPartyMonTypes =
  PokePartyGetTypes renumbered as Gen 4's types (??? at 9), PartyMonHasMove = PokePartyHasMove, OpenMoveTutorMenu +
  CheckLearnedTutorMove = pl_OpenMoveTutorMenu: the tutor app's own choices and lines (Pearl bank 586: teach it?, give
  up?, learned, four moves: delete one?, stop?, did not learn, "1, 2, and... Poof!") on the field, Black 2's
  forget-a-move screen (CallPokeMoveReplace) for a Pokémon with four; Pearl's fades and RestoreOverworld around it
  are dropped (poke_select_fades). Not played in game (Wilma's house is behind Rock Climb).
- Strength boulders: Mt. Coronet north 1F room 1's four Pearl boulder puzzles can't be solved with Black 2's 2x2
  boulders (two close the way to Route 211 West and to B1F for good): reported; DECISIONS 2026-10-26 makes them
  Pearl's 1x1 (the boulders agent).
Checked offline: the other 258 installed zones regenerate unchanged; scene_check (5b + Route 210 S + Hearthome),
warp_check offline and the sinnoh_story checks (34 zones) clean; gimmick 59's old rows byte-equal with flag 0;
decomp: layout kept, `decomp.py changed` = pearlb2's list (BuildInfo's ITCM length only), ITCM +64 B.
Played in game (one --clean build on main 4def13c, start in the Gym's first room, Lv 100 test team, as Lucas; proof
in work/agents/ch5b/play/): the closed Gym (the lift up, the shaft can't be entered, the guide's "she's not here"),
Fly to Solaceon, Route 210 S's Psyduck (the SecretPotion, the Psyduck leave, Cynthia walks up, the Old Charm, she
leaves south), Route 210 N to Celestic (trainers; under the bridge at x 501 since the bridges fix), Celestic: the
elder's trigger, the shrine grunt's battle and run, the elder takes the Old Charm, the ruins' mural, the elder's
walk-in and HM03, Cyrus at the ruins' door (var 0x4074 = 2, 0xA5); Fly to Hearthome; the Gym open: the guide's
Ghost advice, the four lifts up (and down on the way out), the quiz boards (arrows shown), "Correct!" boards, a
wrong door's trainer room (Camper), Fantina (Drifblim, Mismagius, Gengar), the Relic Badge (flag 2418), TM65; out
through every room; Cynthia's Hearthome scene (var 0x40D1 = 2).
Graphics seen: a light-blue sky band under Celestic's south cliff with the tilted camera (cel_south.png); Route 210
N's north-south bridge drawn as a thin stripe over the road (r210n_bridge1/2.png: to compare with Pearl); the
room-edge void at the Gym's quiz floor (MAP_LOOK 1d).
Not played: Grandma Wilma, the café, Route 212 N/S and the Mansion, Routes 211 and Mt. Coronet north 1F, Surf.

### Chapter 6a: Canalave and Iron Island (2026-10-25, the ch6a agent)
20 zones generated (Route 218 and its two gatehouses, Canalave and its 10 buildings, Iron Island's exterior, 1F,
B1F room 2, B2F room 2, B3F and house); the two file-368 zones (B1F room 1, B2F room 1: trainers only) wait for
Chapter 4a's file-368 fix. Additions:
- **Gimmick 59, Pearl's moving platforms (C, decomp branch pearlb2-ch6a):** src/pearlb2/gimmick_itcm.c dispatches
  gimmick ids from 59 (fieldmap.c's Field_Init/Update/TerminateGimmick calls, the event check's step check in
  Mistralton Gym's place, the terrain sampler's height-area call: PearlB2_AppendTerrainLayers, one table per id);
  src/pearlb2/pearl_platforms_itcm.c is Pearl's Canalave Gym (floors 2-4 and 24 platforms as props of the gym's chunk,
  moved and hidden as Pearl does; a terrain layer per floor with Pearl's 4 collision maps, floor 1's rails solid; a
  ride as a field event after the step: up/down with the player's height set each frame, as Driftveil's lift; along
  x/z by walking the player with ACMD_WALK_2F while the platform follows, Pearl's WALK_FASTER) and Iron Island's 3
  platform lifts (the plate a terrain layer at the lift's height; the lift waits at the floor the player came in on).
  Data from the Pearl dump (b2tools/pearl_gimmicks.py: the 24 paths, 4 collision maps and 9 lift configurations,
  equal to pokeplatinum's), patches/pearl_platforms.py (a/1/0/2 rows, the ITCM table), sinnoh_rooms (the props Pearl's
  code adds), pearl_events (gym people on floors 2-4 at Pearl's heights), pearl_chunk (every lift plate at its bottom
  floor's height: Iron Island's 3, the League's 6).
- Boats (the user, 2026-10-25: as HoennB2's): Pearl's ShipAnimation = Black 2's 3D boat demo by Pearl's travel way
  (pl_BoatCutscene: Eldritch's boat = demo 4, the white motorboat, Castelia's pier hidden by patches/boat_demos.py,
  HoennB2's; the Snowpoint ship = demo 26, the Virbank ferry at sea), then the warp; Pearl's docked boats stay.
- Generator: GiveEgg = PokePartyAddEgg; ShakeCamera = EvCameraShake with a
  rumble (around a free camera: back to the player for the shake); StartTrainerBattle after SetHasPartner = a tag
  battle with the file's partner; partners that stay in their zone (pearl_story.partner_stays: Riley, Mira, Marley,
  Buck) follow in that zone only and become their own NPC again; AddFreeCamera on the player's tile from
  CAMERA_AT_PLAYER; RestoreCamera after a stubbed AddFreeCamera emits nothing. Chapters 1, 2, 90 and 3 regenerate
  byte-identical.

Played in game (one --clean build, test start Route 218 east; then a second test start in Library 3F for the tremor
fix), proof in work/agents/ch6a/shots/: Route 218 with Surf and its trainers, the Canalave gatehouse (the
counterpart's father's Pokédex upgrade), Barry's battle on the drawbridge, the whole Canalave Gym (12 platform rides
to Byron, Byron, the Mine Badge (flag 2419), TM91, 5 rides back out), Barry's "come to the library", Library 3F's
lakes scene (the camera pan, the tremor), the explosion scene outside (var 0x4078 = 5), Eldritch's boat to Iron Island
and back (demo 4 both ways, a third build), the B1F, B2F and B3F lifts (riding down and up with the lift), Riley joining, wild doubles and a trainer
pair with Riley, the grunts' tag battle with Riley, the Riolu Egg, Riley staying behind as his own NPC.
Found and fixed: Riley vanished at "Are you going back?" (pl_follow_leave deleted the follower: partner_stays); the
grunts were a double battle without Riley (the tag battle); the tremor's camera shake turned the view to the room's
corner (Black 2's shake needs a bound camera).

### Chapter 6b: the lakes and Snowpoint (2026-10-26, the ch6b agent)
20 zones (Snowpoint and its Mart, Gym and two houses, Mt. Coronet's north mountainside, Lake Verity / Valor / Acuity
(Galactic) and their caverns, Lake Valor and Lake Acuity, Acuity Lakefront, Routes 216-217 with the Snowbound Lodge and
Route 217's two houses). Pearl's order, from its scripts: after the library (6a), Lake Valor (Galactic, drained) ->
Valor Cavern: Commander Saturn (flag 0x13E, 0x984) -> Lake Verity switches to its Galactic version: Rowan's arrival
scene (0x4097), the grunts, Commander Mars (0xBA; clears 0x1D8 Jupiter and 0x252 the Acuity Lakefront grunts, 0x40D3 =
1) -> Snowpoint, Candice (Icicle Badge, TM72) -> the Acuity Lakefront grunts step aside (badge 6) -> Lake Acuity
(Galactic): Jupiter and Barry (0x40D3 = 2; 0x241 cleared: the Veilstone grunt with the Storage Key appears; 0xA8
cleared). The three lakefronts and Valor Cavern switch their stacked warps with SetWarpEventPos on 0x13E (Verity),
0x15E (Valor, Spear Pillar: Chapter 7) and 0xBA (Acuity).
Additions:
- **Gimmick 61, Pearl's ice in the Snowpoint Gym (C, decomp branch pearlb2-ch6b):** src/pearlb2/snowpoint_gym_itcm.c
  (pokediamond sub_020560A0/sub_020560D0, ov05_021E6904 = pokeplatinum PlayerAvatar_TileMove_Ice and ov5_021E06A8):
  the slide's speed 0-3 by the slope a quarter tile ahead (down +1, up -1, at 0 uphill or into a wall uphill one slow
  step back and stop), Pearl's walk speeds (4 frames a tile at 0; 2 at 1-3: Pearl's 3 frames at 1 has no Black 2
  walk), snowballs (object code 144) that break at speed 1+ before the step (removed, no flag: back on the next entry;
  sound SEQ_SE_FLD_11, Black 2's snow step, a guess for Pearl's SEQ_SE_DP_FW291; no break animation), Pearl's one-way
  tiles 0x49 / 0x4A (no moves up-down / left-right into or out of them: the centre stairs). Three same-size call swaps
  in field_player_grid.c (ConstMoveUpdate_STRAIGHT's GetActorMotionDir and GetAcmdForDir, PlayerMoveCollCheck's
  ActorRouteCollCheck), Black 2's own outside the gym; gimmick_itcm.c row 61 (row 60 a NULL placeholder kept for
  Veilstone; a row with no init is no gimmick). patches/snowpoint_gym.py: the gimmick table row (zone 225) and the ITCM
  table (gPearlB2Ice). Offline model: work/agents/ch6b/tools/icegym.py (Pearl's rules: Candice reachable after the
  middle column's snowballs break; Black 2's one-speed ice would reach her around them).
- Lake Acuity (Galactic)'s camera pans as Pearl's: pearl_story CAMERA_NEAR_PLAYER (the free camera starts where the
  field camera is: the scene runs on two arrival tiles) and CAMERA_MOVE_FROM (its walk back down in a subroutine).
- Pearl's 0xED after a legendary battle (pokediamond sub_020480C8: 1 only if the player fled / a draw) =
  pl_CheckLostBattle (Black 2's WildBattleGetResult: 0 caught, 1 fled / draw / defeat, 2 knocked out): Valor and
  Acuity Cavern (Azelf, Uxie: knocked out = gone, ran = back). pl_CheckDidNotCapture is Pearl's 0x2BC (Chapter 7).
- data/pearl_speakers.json: Rowan's line after the Mars battle (Mars's talk script, Mars already gone).
Played in game (one build, test start Verity Lakefront with Chapters 1, 3-5 and 6a's end state, as Lucas; proof in
work/agents/ch6b/play/): the normal Lake Verity before Saturn (Rowan, Dawn: "how was Lake Valor?"), Fly to Pastoria,
Route 213 and the Grand Lake reception to Valor Lakefront, Lake Valor (Galactic: zone 431, the Magikarp, two grunt
battles), Valor Cavern (the cave mat), Saturn (his lines, battle, gone; flags 0x13E, 0x984), back out to the Galactic
lake (the cavern's switched warp); Fly to Twinleaf, Route 201, Verity Lakefront -> Lake Verity (Galactic: zone 429):
Rowan's arrival scene, his and the grunt's talk, the grunt pairs (double battles: two trainers who see you), Mars (her
lines, battle, the fade, Rowan's line in his balloon; 0xBA, 0x252 / 0x1D8 cleared, 0x40D3 = 1); Fly to Snowpoint, the
Acuity Lakefront grunts blocking ("make sure Snowpoint's Gym Leader doesn't disturb us"); the Gym: 68 slides from the
door to Candice, every stop the one the offline model gives (downhill speed-ups to 2 frames a tile, uphill slow-downs
and steps back, 11 snowballs broken, the stairs blocking sideways moves), Candice (Icicle Badge flag 2420, TM72),
the way out; the grunts moved aside (their badge-6 lines); Lake Acuity (Galactic: zone 435): the camera pans up to
Jupiter and Barry and back down with Jupiter, their lines, both leave (0x40D3 = 2, 0x241 cleared); Route 217's HM08
ball. End state read back in game: flags 237, 406, 868, 881, 884, 650, 456, 486, 799, 803, 524, 525, 526, 530, 2420,
206, 1261 set; 626, 216, 439 clear; works 0x4088 = 2, 0x4068 = 1.
Not played: the normal Lake Acuity before Mars (Barry: the same warp switch as Verity's), Routes 216's west part and
the Snowbound Lodge's bed, Snowpoint's houses, the caverns' legendaries (Chapter 7: after Spear Pillar; 0xED's new
macro is offline-checked only), Snowpoint's ship and temple guard (post-game).
Graphics seen (world fixes, logged by the lead): trees hide the player along tree lines with the tilted camera (the
lakes' entrances, Valor Lakefront's lake path); the Fly map has no room for Snowpoint, Acuity Lakefront and Snowpoint
Temple (above the visible map; the D-pad cursor reaches them); snowballs as grey balls (stand-in sprite 144); the
void past Valor Cavern's edges; Nate for a moment at Fly's landing. Fixed in main by the TMs merge: HM08's "???" and
Candice's TM72 move.

### Chapter 7: Galactic HQ, Mt. Coronet and Spear Pillar (2026-10-26, the ch7 agent)
18 zones (pearl_story CHAPTERS[7]: the Galactic HQ's 1F, 2F, 3F, 4F (Cyrus's office, the corridor, Saturn's
lab), B1F, B2F; Mt. Coronet south 2F, 3F and mountainside, 4F rooms 1 and 3, 5F, 6F, the Tunnel Room, B1F; Spear
Pillar). Pearl's order, from its scripts: the Veilstone grunt Lake Acuity brings back (flag 0x241) drops the Storage
Key; the warehouse's inner door, stairs to HQ B2F (the Galactic Key ball); the HQ's front door, its locked doors
(Galactic Key) and warp panels up to Cyrus (4F_1 trigger, var 0x40D6: the battle, the Master Ball); the corridor (4F_2)
to Saturn's lab (4F_BACK): Saturn, the button frees Uxie, Mesprit and Azelf (flag 0x97D), Saturn leaves (flag 0x255
hides every HQ grunt) and the wall with the cave painting on Mt. Coronet 2F is gone (flag 0x253): the way up the
mountain; Spear Pillar (var 0x4098): two grunts (a double battle; one Pokémon: "Scram!"), Cyrus and the Red Chain
(Palkia appears; the vistas: Spear Pillar, Valley Windworks, Hearthome), Mars and Jupiter with Barry (a tag battle),
the lake trio break the chain, Cyrus's battle, Rowan and the counterpart, Palkia (caught: flag 0x15F; knocked out:
"returned to the world from which it came", back after the Hall of Fame: Pearl's file 192), home (continuation 17:
the lake trio in their caverns, Saturn on HQ 1F, the Coronet grunts gone).
Additions (shared):
- Pearl's warp panels (behaviour 0x67, the HQ's 25) are Black 2's type-5 step-on warps (patches/sinnoh_events.py
  PEARL_WARP_PANEL; they were type-1 mats that fire only when pushing into a wall); warp_check knows type 5.
- Spear Pillar's commands: SpearPillarSequence 0x20D (pl_SpearPillarSequence: Pearl's summoning effects become white
  flashes; its two polls answer "over" at once: the var held 0 from the WaitTime before, a hang), HideObject /
  ShowObject 0x1B2 / 0x1B1 (SetInvisible / SetVisible moves; left out in map scripts, where Black 2 moves no actor),
  SetEventDirection 0x18C (a turn at once), CheckHasTwoAliveMons 0xEE, CheckDidNotCapture 0x2BC (chapter 6b's macro),
  SetBGMFixed 0x58 (fixed_music: THE_EVENT03 played again after each vista's warp, as Pearl keeps it), ScopeMode and
  SetSubScene63 (nothing); Barry's tag-battle partner from the starter (607/619/620, registered: pearl_ids
  PARTNER_VARIANTS); the dynamic sprites Dialga/Palkia (data/pearl_sprite_map.json 154/155).
- The free camera on the player's tile (camera_plan, CAMERA_PLAN_FILES = {230}): Pearl's scenes start on wide
  triggers and walk the camera by the player's x; each scene is played from every trigger tile (vars, branches, calls
  and the vistas' Warps followed) and every camera walk ends on one tile from every start (Spear Pillar's 25), so it
  is an EvCameraMoveTo there, at the zone's own pitch (the tilted camera's: no snap); the camera ends before a battle
  or Warp it is still out at (end_free_camera).
- Pearl's own sprites (patches/pearl_npc_sprites.py): Palkia, Uxie, Mesprit, Azelf on Black 2's codes 4633, 4629-4631
  (Pearl's two frames on each frame pair); Mt. Coronet 2F's wall with the cave painting (gfx 203, mmodel 370: the bricks
  with colour 0 opaque as in Pearl, the painting over them) on code 4637 (Black 2's unused Giratina Origin walker), no
  shadow: it stands on the mat to the upper mountain until the trio are freed (flag 0x253); before, it had no actor and
  the way up was open from the start.
Played in game (as Lucas, Lv 100 test team; proof in work/agents/ch7/play/):
- Run A (start Mt. Coronet south 2F before the HQ): the wall blocks the mat and shows Pearl's line (a02, a04); out over
  2F's bridges to Route 207, Fly to Veilstone; the grunt Lake Acuity sent back ("There! Would you look at those
  antennae?"... the Storage Key ball, his run), the Storage Key, the warehouse's inner door ("The Storage Key snapped
  off inside the keyhole..."), HQ B2F (two grunts), B1F, 1F (panels), 2F (panels), 1F, B2F: the Galactic Key, the B2F
  door; the warehouse and the HQ's front door; 1F door, 2F (two grunts, panels), 3F (a grunt pair: a double battle),
  4F: the door, Cyrus's scene and battle (Murkrow, Sneasel, Golbat: "My last Pokemon."), the Master Ball (Items
  pocket), Cyrus leaves; the panel to the corridor, Saturn's lab: Saturn's battle, he steps aside, the button: the
  trio come out of the units and vanish, Saturn's line, he is gone; flags 0x97D, 0x253, 0x255 set, var 0x410D back to
  0; out through the corridor's panel, the 4F bollards gone, the panel to 1F. (a24_cyrus, a28b_release: sheets.)
- The lab's containment units (b2tools/pearl_lab_units.py, hooked in pearl_buildings.build_pack): Pearl's model 496
  is a capsule whose chamber (floor 20 units up) sits behind an orange glass (A3I5, alpha 72-255); its BCA0 49 shrinks
  the glass away. Its record is now a dynamic prop of type 12 (kind 9: no Black 2 code looks for it) with that
  animation as animation 0: the button (DeactivateLakeGuardianContainmentUnits) takes a handle per unit, plays it,
  waits, holds the shared instance on its last frame (BMAnmPlayInv) and lets the handles go; the on-resume script
  (InitLakeGuardianContainmentUnits, level 1) holds the last frame once 0x97D is set. Not ported: the glass band's
  scroll (BTA0 48): Black 2's commands for a chunk's prop reach its animation 0 only.
- The lake trio float 24 units up, as Pearl draws them everywhere (pokediamond ov05_021F0514.s: graphics 0x97-0x99
  take the draw table ov05_021F8D1C, whose init ov05_021F1BD0 sets the sprite offset (0, 24, 0); pokeplatinum
  ov5_021ECB34): pearl_npc_sprites FLOAT_Y sets the ow records' wPosOffsetY of codes 4629-4631 (CopyActorPosAllAdd) and
  turns their shadow off (Black 2's shadow would float with them; Pearl's stays on the ground). In the lab they now
  stand in the chambers behind the glass (before they stood on the room floor inside the units' bases: hidden, in
  Pearl's look too, work/agents/ch7/lab_pair.png; now lab_float24_b.png); the caverns offline: cavern_*_cmp.png.
- Run B (start Mt. Coronet 4F room 3 after the HQ): 5F, 6F (grunts), Spear Pillar: the two grunts (a double battle,
  0x4098 = 1), Cyrus's scene (the camera's pans, the flash, the vistas: Spear Pillar with Palkia, Valley Windworks,
  Hearthome; b05_cyrus). The way back from the vistas put the player at (-32736, -32735): MapChangeCore reads no vars
  and the works 0x8000+ are cleared for each script; now a chain over the places the scene can return to (h_warp,
  the middle one the default).
- Run B2 (a quick build: start Spear Pillar (31, 40), 0x4098 = 1): Cyrus's scene again, back on (31, 35) after the
  vistas (e_cyrus); Mars and Jupiter with Barry (the tag battle), Barry heals the team, Palkia's scene, the trio come
  ("Piiih!", floating), the Red Chain crumbles, Cyrus's battle (Honchkrow, Gyarados, Weavile, Crobat), he leaves,
  Rowan and Dawn (e_tag_top0-2, e_trio_zoom); Palkia knocked out ("Palkia returned to the world from which it
  came...", e_palkia_top) and, from a save before the battle, caught with the Master Ball ("Gotcha!", f_catch_top);
  both end at the entrance (31, 52) with Rowan and Dawn (continuation 17). Read back: Black 2 flags 439, 542, 806,
  817, 852 set, 559-561 (the caverns' trio) and 813 clear, 440 = 0 knocked out / 1 caught, work 0x4069 = 4.
- Run D (a quick build: start in the lab before Saturn): the trio float in the units behind the orange glass (d05_q);
  Saturn's battle, he steps aside; the button: every frame recorded (d_open: the glass shrinks in two updates and is
  gone, d_open_zoom; the trio float out over the units' fronts, d_walk_sel; they vanish together, Saturn's lines,
  d_rest_sel); out to the corridor and back in: the units are open from the first frame (d_back_units).
- Run C (a quick build: start Mt. Coronet south 2F after the HQ): the wall is gone (c00_nowall), the mat to 2F's north
  part, 3F (a trainer), the south mountainside up to its Rock Climb wall (31, 14-22; c09_rockclimb): Rock Climb is not
  in this tree (main has it since 756b3c1).
Rock Climb on Chapter 7's way (STORY_HANDOFFS "Chapter 7"): the south mountainside (31, 14-22) and the north
mountainside's east-west wall (40-44, 22) on the way from 2F; the Tunnel Room's (4-7, 52) from Route 211.
Not played: the caverns' trio in game (Chapter 6b's zones, not in this tree's builds: offline renders only), Mesprit's
roaming (ActivateRoamingPokemon is a stub: open content), the 4F room 1 to north mountainside part of the climb.
Graphics seen: the trio's heads show over the top of the units' domes (Black 2 draws a person over geometry up to
~9 units nearer, its people margin; Pearl's look hides the head behind the dome's back); no shadow under the
floating trio (Pearl's is on the ground); the void past the HQ's room edges and Spear Pillar's top corners (the
camera topic). Fixed: the 2F wall's bricks were see-through (colour 0), the trio hidden in the units.
Black 2 gaps: Pearl's summoning effects (the sky's distortion) are white flashes; the units' band scroll; Pearl's
"A wild X appeared!" kept for Palkia (Black 2's legendary flag changes the line).

### Before (earlier notes)

A test build was started (`PEARL_BUILD_DIR=work/rom_story build_rom.py --clean antipiracy sinnoh_world sinnoh_reskin
sinnoh_rooms sinnoh_events sinnoh_names sinnoh_encounters scripts pearl_text sinnoh_story pearl_starters`) with 3.8 GB
free, and stopped when other builds brought the disk under 2 GB (the rule); its folder is in the Trash. To run when
there is room:

    cd b2tools && PEARL_BUILD_DIR=$HOME/Documents/GitHub/PearlB2/work/rom_lead python3 build_rom.py --clean antipiracy \
        sinnoh_world sinnoh_reskin sinnoh_rooms sinnoh_events sinnoh_names sinnoh_encounters sinnoh_music scripts \
        pearl_text sinnoh_story pearl_starters pearl_title pearl_rods link sinnoh_respawn pearl_centers pearl_trainer_pics pearl_intro

(sinnoh_music before `scripts` and `sinnoh_story`: the scripts then play Pearl's story songs.)
    ~/Documents/GitHub/HoennB2/.venv/bin/python hwtest/story_shot.py ../work/rom_story/pearl.nds ../work/story_test 521 \
        "A14;T8:5;U1;Z520;A12;T6:9;D1;A6;D1;Z427;A2;T114:886;FU;A1;Ssign;A3;T108:890;FU;A1;Snpc;A3;SAVEtwinleaf"

(the room's TV, Mom, the door, Twinleaf; read the player's mailbox sign from below, talk to the man south of it).
`pearl_text` must run after any patch that rebuilds a/0/0/3 from pokebw2's sources (`patches/text.py`).

### Amity Square opened (2026-10-25, the amity agent; user: "open Amity Square with the Pokémon following like in Pearl")
Pearl (script file 266, pokediamond scrcmd_amity_square.c, field_control.c's step count, the start menu): the
receptionists inside the square's two gates (objects 0 / 1; triggers (12,46) / (51,46) on var 0x4099 = 0) go through
the whole party in order and offer each allowed Pokémon ("Would you like to go for a stroll with your X?", then "Then
you would rather go for a stroll with your Y?"): Pikachu, Clefairy, Psyduck, Pachirisu, Drifloon, Buneary, Happiny, and
with the National Pokédex also Jigglypuff, Torchic, Skitty, Shroomish. None: "Please do come back with one!", one step
back. Yes: the party is healed, that Pokémon's object (one of 11, objects 5, 6, 15-23, hidden by flags 0x200, 0x201,
0x249-0x251) appears behind the player, both step north, it follows (SetMovementType 0x30); var 0x4099 = 1, the step
count starts. Talking to it: one of 9 lines, or from 200 steps a find. The triggers one tile south (var 0x4099 = 1)
end the walk ("Are you feeling refreshed?"). Pearl's start menu hides POKéMON and BAG in the square; its header has no
Fly, Escape Rope or bike.
Here:
- data/pearl_closed_facilities.json: the two gatehouse rows removed (the gates are open).
- Generator (pearl_story.py "Amity Square", pearl_story.inc "Amity Square"): ClearAmitySquareStepCount /
  GetAmitySquareStepCount = Black 2's saved step counter (PedometerEnd + PedometerStart / PedometerGet, ov012
  scrcmd_pedometer.c); CalcAmitySquareFoundAccessory: every find is one of Pearl's Berries at Pearl's rates (user
  2026-10-25, DECISIONS); CanFitAccessory in Amity Square answers "no" (a Berry that does not fit gives a line, as
  Pearl when neither fits; elsewhere still a stub); 27C (Pearl's TV records of the walk) nothing. The follower is
  Black 2's own (pl_follow_start, persistent); pl_follow_leave at the exit triggers.
- Pearl's own overworld sprites for the 11 Pokémon (patches/pearl_amity_sprites, after pearl_npc_sprites; codes 111,
  192, 195, 217, 218, 219, 220, 308, 344, 363, 376 in data/pearl_sprite_map.json: 12-frame person walkers no kept Black
  2 zone, script, table or C names). Every other Pearl Pikachu, Drifloon, ... in Sinnoh (gatehouses, the Fan Club,
  Valley Windworks) now shows Pearl's sprite too.
- Save and continue inside: Black 2 saves the actors (block 0x29) and the follow work (PlayerSave), so the follower
  comes back where it was. Fly, Teleport, Dig, the Escape Rope, the bike and the Entralink are refused while a
  follower walks with you (Black 2's own pair checks: ov012 hiden_event.c, itemuse_event.c, event_mapchange.c).
Played in game (test start in the west gatehouse, zone 162 (5,5), Chapter 4a's end state; party Piplup, Torchic,
Pikachu, no National Pokédex; work/agents/amity/shots/): the gatehouse's north door into the square, the receptionist
offers only Pikachu (Piplup and Torchic skipped), NO: "I see. Please come back ..." and the step back; YES: Pikachu
appears behind, both step north, it follows through turns and when the player walks back into it (they swap, as
Pearl's); talking to it before 200 steps: "Pikachu seems to be so happy it can't keep still."; after 208 steps: "Oh?
Pikachu is holding something!", "Obtained the Rabuta Berry!"; in-game save, soft reset, Continue: the follower is back
behind the player and follows; the exit trigger: "Are you feeling refreshed? ...", the follower gone (flag 0x966 and
var 0x4099 back to 0); back in the gatehouse with no follower.
Left: Pearl's start menu rule (POKéMON and BAG hidden in the square): Black 2's field menu keeps them, so the party
can be reordered (the follower's lines name the Pokémon in its party slot) or a Pokémon evolved with an item during a
walk; a field-menu type for the zone in C would match Pearl (Black 2's FieldMenu_GetMenuType). The square's 4 item
balls (TM45, TM43, the Spooky Plate, the Spell Tag) wait for the item-ball pass. Scene lines of the receptionists
(trigger scripts) come in the plain window, as every scene's.

### Chapter 8: Sunyshore and the Pokémon League (2026-10-26, the ch8 agent)
41 zones (pearl_story CHAPTERS[8]):
- Route 222 with its gatehouse, the Pikachu Fan Club and the size-contest house.
- Sunyshore and its 11 rooms, including the Vista Lighthouse's elevator and deck.
- The Gym's 3 rooms; Route 223.
- Victory Road 1F/2F/B1F and its back rooms.
- The League: exterior, lobby 1F/2F/B1F, entrance, the Elite Four's rooms and links, Cynthia's room, the Hall of
  Fame corridor and room.

Pearl's order, from its scripts:
- The road at Valor Lakefront opens after Spear Pillar (0x15E). Route 222 -> Sunyshore: Flint walks up at the gate
  (var 0x407E 0 -> 1).
- The Vista Lighthouse (elevator, deck): Volkner, who goes back to his Gym (0x162).
- The Gym's three gear rooms -> Volkner: the Beacon Badge (flag 2421) and TM57.
- Jasmine on the north beach (0x407E 1 -> 2): HM07 Waterfall (Black 2's HM05).
- Route 223: Surf, then the waterfall onto the League's south shore (its Pokémon Center).
- Victory Road: Rock Climb on 1F, Strength and Rock Smash on 2F, Surf and Waterfall on B1F (its row-10 falls). Out
  through the west-facing exit at 1F (34, 4).
- The League plateau: Surf the pool in front of the building and climb its waterfall (row 569) to the door.
- The lobby: the guard checks the badges (0xAF); Barry's battle on the way up (0x40EF).
- The entrance lift -> Aaron, Bertha, Flint, Lucian. Each room's door opens when the member is beaten (flags
  0xB0-0xB3, 0x2A4-0x2A7); a lift in each link.
- Cynthia (her battle starts as the player walks in), then her lift -> the corridor (Rowan) -> the Hall of Fame.
- The record, the save, the staff roll, THE END -> Continue in the player's room (521, (4, 6)).

Additions:
- **Gimmick 62, the Sunyshore Gym's gears (C):** decomp src/pearlb2/sunyshore_gym_itcm.c.
  - Sources: pokediamond InitSunyshoreGym and pokeplatinum gym_features.c SunyshoreGym_*. Pearl's tables were found
    byte for byte in the dump.
  - Pearl's gear models 458-464 form one expanded-object scene: Black 2's chunk props turn only about y, and five
    gears stand up.
  - The buttons' scripts turn them 5.625 degrees a frame (pl_RotateSunyshoreGymGear through
    PVAR_GIMMICK_REQUEST 0x401F).
  - The walkways are terrain layers at the gears' height (gimmick_itcm.c sTerrainLayers). Each state's arm regions are
    solid.
  - The state is taken from the way in (entrance: 0, else 2/1/0) and kept in the gimmick's work.
  - patches/sunyshore_gym.py writes the ITCM table and appends the models to a/2/9/5.
  - The gym-local press guard (one press per stepping onto a button) is off since main's step_trigger_itcm
    (#ifdef SUNYSHORE_PRESS_GUARD); two bumps on a button turned nothing (build 2).
  - The buttons' step triggers are raised to the walkway height (raise_buttons). Black 2 fires a trigger only
    within 2 units of its y.
  - The exit doorways (8, 2) / (9, 2) are raised to the platform's height (fix_doorways). The converter gave them the
    pit's 0: room 1's exit never fired and room 2's was a 62-unit wall.
- **The League's six lifts on gimmick 59** (pearl_gimmicks.LEAGUE_LIFTS: model 502, Pearl's 2 units per field frame).
  - LIFT_ONE_WAY is Pearl's preventGoingDown.
  - LIFT_SCRIPTED is Cynthia's lift, started by her script (pl_TriggerPlatformLiftRide).
  - Both flags live in the platform's floorB byte, which lifts don't otherwise use.
- **The Elite Four's doors:** Pearl's graphics 209 on Black 2's unused OBJ_CODE_MODEL_2 (patches/pearl_e4_doors.py:
  Pearl's fldeff model 110 "door2"). They open as Pearl's do.
  - The generator no longer adds objects that aren't installed: Black 2's ActorAdd of a missing uid writes through an
    unset pointer.
  - The record copies MODEL_7's (scene node 12, the 3D-object drawer). MODEL_0/1/2/4's own records have scene
    node 0, which draws nothing: the first install was invisible.
- **The Hall of Fame and the ending:** pl_ClearGame = Black 2's own ending (FadeOutBlackQ, FadeWait, CallGameClear,
  FinishAllEvents, ActorsUnpauseAll).
  - Decomp src/ov012/event_game_clear.c changes only call targets (function sizes kept).
  - src/pearlb2/game_clear_itcm.c: Black 2's two epilogue map changes go to the Hall of Fame room, and its ending
    scripts are the room's two ending entries. There is no Unova Link key screen.
  - src/field_scripts/1242_global_9600.s: global 9601 = the respawn at home and Continue in the player's room.
  - patches/game_clear.py: the ITCM table, the credits list and the photos.
- **The credits:**
  - Pearl's 216 staff lines (Pearl bank 493) on Black 2's roll (b2tools/pearl_credits.py), with Black 2's timing
    (21,172 frames).
  - "Pokémon Pearl" sits on Black 2's version title (its LINE_AT points 7 records past END, so the list keeps the
    whole tail); "Fin" replaces DEVELOPED BY.
  - 12 greyscale Sinnoh photos without the player, plus a colour final picture of the player's room
    (b2tools/credits_photos.py, data/credits/; specs in work/agents/ch8/photos/credits_spec.json).
- Smaller:
  - GetLeagueVictories = RecordGet 71.
  - CheckPlatformLiftNotUsedWhenEnteredMap.
  - PlayHallOfFameHealingAnimation (the heal ME only).
  - IncrementGameRecord (nothing).
  - KI_GASYAN = SEQ_SE_FLD_94.

Tested in game (build 1 plus quick test starts, Lucas; work/agents/ch8/play, play2, play3):
- Flint's arrival; the lighthouse elevator both ways; Volkner's deck scene; Flint stepping aside.
- Gym room 1's gears drawn and turning.
- Jasmine's HM; Route 223 surf and waterfall.
- Victory Road end to end: every climb, the 2F boulders and rocks, B1F surf and waterfall, the ladders, the exit.
- The pool waterfall; the lobby: heal, Barry, the guard.
- The entrance lift (-2 -> 158) and the link lifts.
- All four Elite Four battles, with each door actor removed on the win.
- Cynthia; then the corridor, the Hall of Fame, the record and save, the staff roll, the title and Continue.
  - Under HoennB2's protection watcher, with zero ARM9 hits (the only hits were ARM7 BIOS ones).
  - After Continue: flag 2400 set; the title's save shows 8 badges in Twinleaf Town.

Build 2 (re-based on main af82dfa and decomp ce47c4a14d; work/agents/ch8/play4), only what changed:
- Gym room 1: the button turns the gears (filmed); the walkways crossed both ways; the exit to room 2.
- Room 2: its buttons turn the gears; the standing gear's bridge at x 2 crossed.
- Room 3 (test start): the double button at (16, 18) turns the gears; the gear at (11, 18) crossed.
- Bumps on a button turn nothing.
- Aaron's room (test start): both doors are drawn.

Not walked:
- Rooms 2 and 3 to their ends: the test tool's solver (tools/gym_solve.py) ignores the rooms' levels and stairs.
- Volkner's battle in game.

Found and fixed:
- The credits list was cut at END, so LINE_AT read past the file: about 15,000 frames of black before "Fin".
  Checked offline: LINE_AT now points at "Pokémon Pearl".
- Build 2: no gym button fired (trigger heights); room 1's exit never fired and room 2's doorway was a wall
  (doorway heights); the E4 doors were invisible (scene node 0).
- Generator: a field-load script's proxy (the League lobby 2F's global 9000) translated HideObject 255 as a live
  actor command, and sinnoh_story refused it. Proxy subroutines run by map scripts now translate at their level
  (job.level_commons).

Left:
- The lighthouse deck's black shaft top.
- The grey-ball vent stand-ins in Sunyshore.
- The void east of the gatehouse.
- Victory Road 2F's black rectangle east of the boulder corridor.
- The VR entrance's black void.
- Text drawn over the credit photos while names scroll: compare with Black 2's own roll.
- Test tools: work/agents/ch8/tools/ (WALK/PHOTO/ENDING/PLAY_SLOT in watch_play.py; vr_plan3.py plans with heights,
  surf, waterfall and climbs).

### Chapter 9a: the National Pokédex, the Battle Zone, Stark Mountain, the event Pokémon (2026-10-26, the ch9a agent)
49 zones (data/story_chapters.json "9" without 9b's: the Fight Area and its 5 rooms, the Battle Park, its Exchange
Service Corner and the Battle Tower lobby, Routes 224-230 with their houses and gatehouse, the Survival Area and the
Resort Area with their rooms, Stark Mountain (outside and 3 rooms), Snowpoint Temple 1F-B5F, the Spring Path, Sendoff
Spring, Turnback Cave's entrance, Flower Paradise, Eterna's Oak house, and the Hall of Origin). Pearl's order, from its
scripts: Rowan's lab (Ch1's zone: Oak, the National Pokédex, the Poké Radar, SetHiddenLocation 2; Pearl asks for the
whole Sinnoh Pokédex seen, here the Hall of Fame is enough: user 2026-10-26, pearl_story NATIONAL_DEX_AT_CHAMPION:
Rowan's check and Dawn's / Lucas's outside the lab also pass once 2400 is set; the PC rating and the Grand Lake's
diploma keep the true count; the five lines that would say every Sinnoh Pokémon was seen are reworded, the smallest
change each: data/pearl_text_edits.json "_national_dex") -> Snowpoint's sailor (game clear) -> the ship to the Fight
Area (Barry and Buck: frame table var 0x4081) -> the Battle Park (Barry's "Thud!!", Palmer) -> Barry's daily Fight
Area battle (flag 0xAB2) -> Route 225 -> the Survival Area -> Routes 226/227 (Barry and Wake: triggers on 0x408B / 0x4119) -> Stark Mountain outside (Rock
Climb), room 1 (Barry beaten by Buck), room 2 (Buck joins as partner: pl_follow_start_ally, partner_stays), room 3
(Buck takes the Magma Stone: 0x409E = 1, 0xD6) -> Buck at his grandfather's (Survival Area west house: 0x125) ->
Heatran in room 3 (game clear, National Pokédex, 0x125, 0x409E = 1). No Mars and Jupiter at Stark Mountain and no
Villa in the Resort Area: both are Platinum's. Snowpoint Temple: Candice lets you in (6b's Snowpoint trigger: game
clear + National Pokédex); B5F's Regigigas wakes with Regirock, Regice and Registeel in the party (Pearl's CheckRegis).
The event Pokémon, built in (DECISIONS 2026-10-25/26):
- **The deliveryman** (Pearl's globals 10200 on load / 10201 talk, file 373, in every Pokémart): Pearl's
  MysteryGiftGive subcommands (pokeplatinum scrcmd_mystery_gift.c order: load, waiting?, type, can receive?, give,
  received line, can't-receive line, unload) on the new work PVAR_DELIVERY (gifts given, 0-4): after the Hall of Fame
  (2400) he stands in every Mart while gifts remain and gives one a talk, in the user's order: the Member Card,
  Oak's Letter, the Azure Flute, the Manaphy Egg (PokePartyAddEgg 490; refused with Pearl's "Your party is full" line
  when it is). His lines are Pearl's (bank 332: the greetings by the time of day, "received a Member's Card",
  "...Oak's Letter", "...an Azure Flute", "...the MANAPHY Egg", "We look forward to your next visit").
- CheckDistributionEvent n (Pearl's Mystery Gift magic numbers: 0 Darkrai, 1 Shaymin, 2 Arceus) = the deliveryman gave
  that event's item (pl_CheckDistributionEvent): Canalave's Harbor Inn sailor (9b), Route 224's Oak, Spear Pillar's
  Azure Flute trigger (Pearl common script 2039 -> Warp 510).
- **Shaymin**: Route 224's Oak (game clear, National Pokédex, Oak's Letter, the event) asks whom the player thanks:
  Black 2's word-set name input (CallWordSetPokeNameInput, its Funfest quiz's; the starter as the icon; nothing typed =
  Pearl's "You're not suggesting there's no one?"). Pearl's SetHiddenLocation 3 opens the Seabreak Path: Pearl's map
  loader swaps Route 224's cells (28,15) (27,16) (28,16) (27,17) from maps 115-118 to 119-122 (pokediamond
  map_matrix.c sub_020346CC); here Black 2's map replacement does it (b2tools/pearl_hidden_paths.py,
  patches/pearl_paths.py: the four maps converted as extra chunks, a/0/1/0 entries on Black 2's map-replace event uid
  9, work 0x403A == 0x1028, set by MapReplaceSetEvent from pl_SetHiddenLocation). Route 224's Shaymin (object 16)
  takes the opened map's height (its tile is the sea on the closed one). The inscription is not kept (no Black 2 save
  string): the tablet's later line names the player.
- The Spring Path is hidden until Rowan's National Pokédex (Pearl's sub_02034678: map 176 on its four cells until
  hidden location 2): the same patch, map-176 copies on its cells, uid 7 (work 0x4038 == 0x408).
- **Arceus**: the Hall of Origin (Pearl map 510) on zone 489 (allocate_sinnoh EVENT_ROOM_ZONES: matrix 622, chunks
  1561-1564, Spear Pillar's area 50); Spear Pillar's trigger (31, 52) on var 0x4118 runs Pearl's 2039 (game clear,
  National Pokédex, the Azure Flute's event): "{player}'s Azure Flute is making a sound!", the Warp to 510.
- Regigigas: Pearl's CheckRegis = three PokePartyFindBySpecies (377-379); the statue's shake (ShakeObject) is not
  drawn (no one-person shake in Black 2).
- Flower Paradise: Pearl's flower carpets stand 12 units over its ground, so the converter took them as ground and
  the stairs up to Shaymin's bed ended at a 20-unit wall (72 -> 92); pearl_chunk now takes the ground under the
  carpets (WORLD.md "Flower carpets"): 72 -> 80 there, every flower map on Pearl's heights. Not yet seen in game.
Played as Lucas (2026-10-26, DeSmuME, a full build of main d48a2e9 + 9a, then seconds-long test-start rebuilds): Rowan's
National Pokédex at Champion with two Pokémon seen (Oak's lines in Oak's own box), the Poké Radar and the five reworded
boxes (Lucas's as Dawn); the Sandgem Mart deliveryman's four gifts, then "no other gifts"; the Spring Path closed, then
open, Sendoff Spring, Turnback Cave's entrance; the Snowpoint ship to the Fight Area (Barry and Buck), the Battle
Park's gatehouse and Palmer's scene, Route 227's Wake and Buck; Heatran knocked out (0x120 set, as Pearl) and caught;
Arceus caught in the Hall of Origin; Route 224's Oak, the tablet's name, the Shaymin scene and the Seabreak Path
opening (walked into it); Shaymin caught (from a start on its bed: the stairs were the wall above). Not played: Stark
Mountain's rooms with Buck, Snowpoint Temple and Regigigas, Barry's daily battle, the Survival and Resort Areas' rooms.

### Turnback Cave: Pearl's maze and Giratina (2026-10-26, the turnback agent)
b2tools/turnback.py (its docstring has the details). Pearl's rule (InitTurnbackCave, 0x285: pokediamond
ScrCmd_Unk0285): each room's four doors lead back to the entrance; arriving in a room, Pearl counts it and points the
three doors the player did not come in by at one room: 3 pillars seen -> Giratina's room, 30 rooms -> the entrance,
25 % the pillar room, else its table [rand % 6 + 6 x pillars seen]. Here:
- Zones (the lead: 623-632 + 663-664): 623 pillar room, 624 Giratina's room, and one zone per layout and wild tier of
  the 18 random rooms (Pearl's encounter tables differ only by tier: Lv 45 / 55 / 65), each holding Pearl's two rooms
  of that layout and tier; the zone init draws which (1 in 2) and moves the rocks to the second room's tiles
  (ObjInitNPCGPos, level 2), so each room stays 1 in 6. Rooms 17 (663) and 14 (664, no wild Pokémon as in Pearl)
  alone. data/sinnoh_world.json: only additions (6125 old values unchanged).
- Doors: no Black 2 command changes a warp's destination, and ObjInitWarpGPos places a warp only at multiples of 16
  units (the doors stand at 48 / 56). So each door has Pearl's warp (to the entrance) and a copy per destination on
  the same tile (sinnoh_events Planner.warps -> turnback.extra_warps: 48 copies a room); Black 2 fires the first warp of
  a tile, and parking a warp off the map needs no height. Pearl's InitTurnbackCave runs in the zone init, where
  Black 2 refuses PlayerGetGPos (level 2), so the doors are set by an extra map script of type 4 (once after each map
  change, level 1: pearl_events map_script_table, TurnbackDoors): the player's tile -> the way in, Pearl's draw, the
  parking. Battles, menus and Continue run type 3, and Continue reloads the event file: every door to the entrance, as
  Pearl (no ON_TRANSITION on Continue there either).
- Heights: the door copies take their door's record. Giratina's room's three mats (40, the player stands at 56) are
  right since the warp-height fix (e7822d6); checked in the built ROM (the built floor's height of every door of the
  maze = its record).
- Giratina: Pearl's own script (Lv 70, Altered Forme, Pearl's legendary music by species). Pearl's 0xED answers 0 for a
  catch AND a knockout, so both set PFLAG_0121 (FLAG_CAUGHT_GIRATINA, Ramanas Park's Distortion Room reads it), hide
  Giratina and show the item ball (Reaper Cloth at exactly 3 rooms, Rare Bone under 15, else Stardust); fleeing keeps
  it there.
Played (2026-10-26, DeSmuME, one full build of main 5fb4b23 + this; work/agents/turnback/shots/): a start in the
entrance, then one pass of 18 rooms (maze_run.log): entrance -> pillar room x2 -> zone 632 (Room 13's rocks: the second
room) -> back through the way in -> the entrance (counters reset) -> 627 -> 626 (Room 4's rocks) -> pillar x2 -> 631
three times (Rooms 18 and 15: a door to the same zone) -> 663 -> 632 -> 664 -> 632 -> 631 -> pillar 3 -> Giratina's
room; every arrival on the door opposite the one taken, every random room of the tier the pillars give, wild battles
only in the random rooms. Giratina: knocked out (0x121, 0x26E set, 0x296 clear, Giratina gone), and from the same
save caught with a Master Ball (Lv 70, the same flags); out by the south door to the entrance's north door. Not
played: the 30-room limit, the item ball after Giratina (shown on the next visit: Pearl's hide flag), Continue in a
room.
### Chapter 9b: the moon islands, Routes 219-221, Pal Park's gate, Trophy Garden, Rotom, Spiritomb (2026-10-26, the ch9b agent)
Generated: Fullmoon Island (outside, forest), Newmoon Island (outside, inside), the Trophy Garden, Routes 219, 220, 221
and its level-item house; Pal Park, its gate and Eterna's Oak house regenerate byte-identical (Ramanas additions
kept). Pearl's order: the Hall of Fame + the National Pokédex -> Eldritch's house (Canalave: the boy's nightmare,
0x133) -> the harbour sailor's Fullmoon trip -> Cresselia flies off (0x11F; CreateRoamer stays a stub for the roamers
agent), the Lunar Wing ball -> the boy wakes (0x12C) -> with the Member Card (deliveryman, 9a) the Harbor Inn's dream
-> Newmoon Island -> Darkrai (0x158), the sailor's Newmoon trip (0x13C). Rotom (Old Chateau TV, night, game clear +
National Pokédex) and Oak's gate scene / Eterna house were already translated.
New handlers (pearl_story.inc "Chapter 9b"): GetSpiritombTalkCounter / Reset on PVAR_UG_HIDEAWAY_BATTLES (Route 209's
file); GetDailyRandomLevel (a level 2-99 from the date) and GetPartyMonLevel (Route 221's house); AddTrophyGardenMon /
GetTrophyGardenSlot1Species on the new works PVAR_TROPHY_GARDEN_1/2 (Mr. Backlot, Route 212's Mansion file; Pearl's 16
species from encdata_ex 8). The Trophy Garden's grass slots 6-7: the encounter code (STORY_HANDOFFS 9b).
Checked offline: scene_check chapter 9 (7 'stand': Pearl's dock bollards on both islands, the gate receptionist at
(7, 11): to look at in game), warp_check offline 0, the offline story check 14 zones 0 problems, check_local_works.
Not played in game (usage: the build on 5fb4b23 was stopped in the queue; the first one hit ITCM full before the
resident section). Still stubbed: Cresselia's picture (DrawPokemonPreview) and blink, Route 221's berry soil.
