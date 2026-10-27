# The Pokétch (plan, 2026-10-26)

The user's decision (DECISIONS.md 2026-10-26): the real Pokétch, all 25 of Pearl's apps, on the bottom screen in place
of Black 2's C-Gear, with Pearl's own art. The C-Gear's place stays as decided on 2026-10-19: a bottom-screen mode of
Black 2's FieldSubscreen system; the X menu is its own mode and returns to it on close; the C-Gear's extras (Entralink,
infrared, the wireless shortcut) go; trading and link battles stay at the Pokémon Center counters.

Sources, in this order (user, 2026-10-26: "grab it from the Diamond and Pearl decomp ... it's different than the
Platinum one"): **pokediamond** first (C where it has C: `arm9/src/poketch.c`, overlays 19, 21, 24; asm for the rest),
**the Pearl dump** (`roms/pearl.nds`: `graphic/poketch.narc`, text banks 405-410), **pokeplatinum's C only as a
reading guide** for Pearl's asm (`src/applications/poketch/`). Black 2's side: the decomp (`external/pokebw2`).

## 1. How Pearl's Pokétch runs

### Where its code is (pokediamond)
| Pearl | What | Size | Platinum's C (reading guide) |
|---|---|---|---|
| arm9 `src/poketch.c` | the save data (232 B) and its accessors | C | `src/poketch.c` |
| overlay 19 | the bottom screen before the Pokétch is given (Pearl's art: a Poké Ball outline on blue) | 256 B, C | `unavailable/` |
| overlay 20 | the system: `ov20_02252440.s` system, `_02252C5C.s` graphics, `_022536F4.s` task, `_02253BA4.s` animation (sprites), `_02254130.s` button, `_02254420.s` map tables | 9,216 B, asm | `poketch_system.c`, `_graphics.c`, `_task.c`, `_animation.c`, `_button.c`, `_map.c` |
| overlays 21-31, 35-45, 47-49 | the 25 apps, one overlay each (table `sPoketchAppOverlayMapping`, end of `ov20_02252440.s`) | 800-6,400 B each, 21 and 24 in C, the rest asm | one folder per app |
| overlays 32, 33, 34, 46, 50 | not in the app table: Backlight Toggle (unreachable), three placeholder apps, a button test | - | `backlight_toggle/`, `unused/` |
| overlay 51 | not the Pokétch: the Union Room's bottom screen | - | - |
| overlay 5 (field) | the glue: `ov05_021EFA9C.s` (create/shutdown/events), `ov05_021E3340.s` (the give sequence) | asm | `overlay005/` |

Apps and their overlays (app id = Pearl's order of cycling): 0 Digital Watch (ov21), 1 Calculator (23), 2 Memo Pad (24),
3 Pedometer (31), 4 Pokémon List (27), 5 Friendship Checker (28), 6 Dowsing Machine (29), 7 Berry Searcher (43),
8 Day-Care Checker (35), 9 Pokémon History (49), 10 Counter (30), 11 Analog Watch (25), 12 Marking Map (42),
13 Link Searcher (47), 14 Coin Toss (37), 15 Move Tester (38), 16 Calendar (45), 17 Dot Artist (26), 18 Roulette (36),
19 Trainer Counter (48; Poké Radar chains), 20 Kitchen Timer (41), 21 Color Changer (44), 22 Matchup Checker (39;
breeding compatibility), 23 Stopwatch (22), 24 Alarm Clock (40). Pearl's code sizes add up to about 77 KB of apps
plus 9 KB of system.

### The system (overlay 20)
- **Memory.** Two heaps of 0xC000 each from heap 3 (heap 7 the system, heap 8 the apps). The system struct is 0x60 B,
  the graphics struct 0x3A8 B, the sprite manager 0x90 B per OAM slot. Plus a 0x3000-byte arm9 buffer, the
  "Pokétch memory", tagged with the app that wrote it: the Stopwatch, Counter, Memo Pad, Coin Toss, Move Tester,
  Kitchen Timer and Roulette keep their state there, so it survives closing the Pokétch (menus, battles) but not
  switching apps (the system clears the tag on every switch).
- **Screen.** Sub engine mode 0, VRAM bank H (32 KB sub BG) and bank I (16 KB sub OBJ), OBJ 1D 32K. Sub BG0 = the
  case (member 14 tiles at tile 64, member 15 map, member 13 palette into slot 15: blue for a boy, pink for a girl),
  BG1 = the screen fill (tile 0xD8, palette 15), BG2/BG3 = the app's (screen base 0x7000 / 0x7800, char base 0).
  Palettes: member 0 holds 16 palettes = 8 screen colours (Color Changer) x (normal, backlight); the watches load the
  backlight one while the screen is held.
- **Task loop.** A main SysTask (priority 0) with states INIT, UPDATE, CHANGE_APP, SHUTDOWN, UNLOAD; a post-render
  task (priority 4) clears the per-frame flags; apps start their own SysTasks (priorities 1-3) and VBlank tasks.
- **Apps.** Loading an app's overlay runs its static initializer, which hands the system its init and shutdown
  functions (`Poketch_InitApp`); the system calls init(&appData, system, bgConfig, appId); the app reports "loaded" and
  later "unloaded". Only the Dot Artist sets a save hook.
- **Button.** ONE button on the right (x 220-244, y 96-172; tiles 4 x 11 at (27, 11); normal / pressed / blocked
  graphics). A tap or a 7-frame hold goes to the next app (by app id, wrapping): the screen closes in 5 frames, waits
  3, the next app opens in 4. Tapping again while it closes shows the app number (two digit sprites at (176, 40) and
  (192, 40)); each tap advances it; 30 frames without a tap opens that app.
- **While a script or field event runs** (`fieldSystem + 0x10`): no app switch, the button shows its blocked graphic
  (sound DENSI04), a touch on the screen beeps, apps keep running but their sounds and touches are ignored.
- **Sounds** (SEQ_SE_DP_*, the same numbers in Platinum): POKETCH_003, 006, 009, 010-014, BEEP, DENSI01, 04, 09-12;
  cries by species only (Pearl passes no form); the Alarm Clock rings with Loudred's cry.
- **Field glue.** The field creates the Pokétch when the field map starts (if given and flag 0x97C clear, else overlay
  19) and shuts it down when the field map ends (full-screen menus, battles, warps). Events: 1 = the player stepped
  to a new tile (each frame of movement), 4 = saving (runs the app's save hook), 5 = one step for the pedometer (after
  coord events and warps, not in forced movement; +1, past 99,999 back to 0, only once the Pedometer is registered).
  Touching the screen while standing still turns the player to the "looking at the Pokétch" pose; it never blocks
  the player's input.
- **Script commands (Pearl):** 0x131 GivePoketch (sub-screen fade out, swap overlay 19 for the Pokétch, fade in),
  0x132 CheckPoketch var, 0x133 UnlockPoketchApp app (the Pedometer also turns step counting on), 0x134
  CheckPoketchApp app, var, 0x0D7 GetPoketchAppName (bank 406), 0x265 / 0x266 set / clear flag 0x97C (hide / show the
  Pokétch from the next bottom-screen start: the Battle Tower lobby and elevator).
- **Other writers of the save:** Pokémon History entries are added on a battle catch, an evolution (and Shedinja),
  and through the "got a Pokémon" helper (`unk_0202C144.c`: script gifts, hatching, NPC trades, Pal Park, Mystery
  Gift); the apps themselves write the Dot Artist drawing, the step count, the alarm, the map markers, the screen
  colour and the calendar marks.

### Pearl's save data (pokediamond `include/poketch.h`, 232 bytes)
isGiven, pedometerActive, dotArtistEnabled, color (3 bits); numApps; selectedApp; unlockedApps[32] (25 used);
stepCounter u32; alarm (on, hour, minute); dotArtistGrid[120] (24 x 20 dots, 2 bits); calendarFlags u32 + month;
markingMapPos[6][2]; pokemonHistory[12] = {species u16, form u16}. A new game registers the Digital Watch.

## 2. Pearl vs Platinum (Pearl wins everywhere; checked function by function, 2026-10-26)

Every Pearl module matches Platinum's C function for function, in the same order, with the same struct sizes,
timings, touch rectangles, NARC members (the 126 members of `graphic/poketch.narc` have Platinum's order and types) and
sound numbers, except:

| Where | Pearl | Platinum |
|---|---|---|
| Buttons | one button (x 220-244, y 96-172), forward only, 7-frame hold | up and down buttons (y 32-96, 96-160), back and forward (`Poketch_DecrementAppID`), hold on up only |
| Case art | Pearl's border (member 14: 21 x 8 tiles, one long red button; blank tiles 0xD4-0xDB) | Platinum's (32 x 6 tiles, two buttons; blank 224-231) |
| Graphics | 15 tasks, 3 button tilemaps (4 x 11) from a row table | 18 tasks, 6 tilemaps (4 x 8) |
| App number | also tints sub-BG palette 15 entry 1 with the screen colour | no |
| System struct | 0x60 B | 0x64 B (+ the button direction) |
| Save | 232 B; history entry {species, form} | 280 B; {species, icon, form u32} |
| Cries | species only, everywhere (Party, Friendship, Calculator, Trainer Counter, History, Alarm) | species + form |
| Text | shadow colour TEXT_COLOR(1, 1, 4) | (1, 8, 4) |
| Digital Watch | redraws when the minute changes | minute or hour |
| Memo Pad | its stroke array is never cleared; the eraser skips cells on fast strokes (only each segment's end is erased for sure); no cache flush before uploads | cleared; erases a 4 x 4 block along the whole path |
| Calculator | "=" plays the cry of dex number n: Pearl's 151 Sinnoh dex, or species 1-493 with the National Dex; seen only | Platinum's 210 dex |
| Friendship, Day-Care, Matchup | sprite flip by species (not form) | by form |
| Day-Care Checker | shows the egg only when the low byte of its PID is not 0 (Pearl's bug: 1 egg in 256 hidden) | PID != 0 |
| Matchup Checker | eggs can be picked (egg icon, the species' palette and egg groups); a button sound when switching | eggs skipped; the Pokémon's cry |
| Marking Map | 3 roamer slots: Mesprit, Cresselia, Darkrai (Lv 40) | 6 (+ the three birds); the map tables are the same |
| Link Searcher | link lists: Union Room {9, 13, 7, 18}, Underground {10}, Colosseum {1-5}, others {0, 6, 8, 11, 12, 14}; the second intro line at y 56 | more link types; computed position |
| Not in Pearl's table | Backlight Toggle (ov32) and placeholder apps exist but are unreachable | the same |

No differences at all in: Analog Watch, Dot Artist, Counter, Pedometer, Dowsing Machine, Stopwatch, Roulette, Coin Toss,
Alarm Clock, Kitchen Timer, Color Changer, Calendar, Trainer Counter (and the Move Tester's 17-type chart, which is
byte for byte Platinum's). Things both games share that look like bugs (the `hour %= 60` guard, the Roulette's stop
delay) are kept.

## 3. What the apps need from the game, and Black 2's side

| App | Needs | Black 2 |
|---|---|---|
| Digital / Analog Watch, Calendar, Alarm Clock | the clock and date | GFL RTC (as season_weather uses) |
| Stopwatch, Kitchen Timer | a running tick (Timer 3) | OS_GetTick |
| Memo Pad, Dot Artist, Roulette, Counter, Coin Toss, Color Changer | nothing (Pokétch memory, the Pokétch save) | - |
| Pedometer | one event per step | a call after `GameData_UpdateGlobalStepCounter` (ov036 fieldmap_event.c, the per-step counter) |
| Calculator | dex seen flags, National Dex, Pearl's Sinnoh dex order, cries (Chatot's Chatter) | Black 2's dex save; PearlB2's Sinnoh dex table; PokeVoice (Chatter is in Black 2's save) |
| Pokémon List | party: species, form, egg, HP, max HP, status, held item (mail), icons, cries | PokeParty / pml params; Black 2's icon archive and icon palette table (649 species), luminance remap to the 4 Pokétch shades as Pearl does |
| Friendship Checker | party friendship, species, form, egg; icons; base-stat flip | the same; Black 2's personal data flip bit |
| Day-Care Checker | the 2 Day-Care Pokémon (species, form, gender, level from steps), the egg | Black 2's Day Care (sodateya: PearlB2's Solaceon Day Care uses it) |
| Matchup Checker | party + the Day Care's compatibility (0-3) | Black 2's sodateya compatibility |
| Move Tester | Pearl's own 17-type chart (hard-coded), type names (bank 565) | none: Pearl's table; Black 2's type names (see question 7) |
| Pokémon History | a list of the last 12 Pokémon obtained | hooks: battle catch, hatch, evolution, NPC trade, script gift, Pal Park (the Pal Park agent's code) |
| Marking Map | the player's map cell (Pearl's matrix 0, 30 x 30, 32-tile cells; indoors: the last outdoor spot), roamers' Pearl map ids, Pearl's hidden places (vars 0x4036+) | PearlB2's matrix 0 IS Pearl's matrix 0 (notes/WORLD.md), so cell = tile / 32; indoors: Black 2's escape/special location; **roamers: not built yet** (OPEN_CONTENT); hidden places: not built yet (SetHiddenLocation is a no-op): until then the map shows only the player and the markers |
| Dowsing Machine | hidden items in a 15 x 14 window around the player, their flags and range | **hidden items not placed yet** (OPEN_CONTENT "Item balls and hidden items"): reads Black 2's hidden-item events once the item pass places them; shows nothing meanwhile |
| Berry Searcher | Pearl's 118 berry patches and their growth | **Black 2 has no berry patches and PearlB2 has not built them** (not on OPEN_CONTENT yet): an empty map until they exist |
| Trainer Counter | Poké Radar chain and its 3 records | **no Poké Radar** (not planned): its empty screen, as in Pearl before the radar |
| Link Searcher | DS wireless beacon scan by link type | see question 6 |

## 4. Where it goes in Black 2

### Code (sizes are Pearl's; the port will be about the same plus a small layer for Black 2's libraries)
- **The Pokétch's own code as new overlays** (`src/pearlb2/poketch/*.c` in the decomp, outside the dump's modules,
  so nothing of Black 2 moves): one system overlay (Pearl's overlay 20 + overlay 19's screen + the layer: ~12 KB)
  and 25 app overlays (one at a time after it: the biggest ~7 KB). Not ITCM: ITCM is 32 KB with ~13 KB used and other
  modules need it.
  - **Where in RAM (proposal):** right after the last overlay of main memory (overlay 290's end, 0x021FD080), where
    the DS-mode main arena starts. The region (~12 KB system + ~7.5 KB app slot + 12 KB Pokétch memory = ~32 KB)
    moves the arena start up (`OS_GetInitArenaLo`, one literal, as the ITCM arena move). By arithmetic the arena has
    ~220 KB that no heap uses (Black 2's root heaps are fixed: 0x6000 + 0x1A3E00 of 0x023E0000 - 0x021FD080), to be
    measured in the emulator first (step 0). In DSi mode the arena starts at 0x027xxxxx, so the region is free there.
  - **Fallback:** the C-Gear's own slot (0x021EA860-0x021EEC80, 17,440 B, used only by the bottom-screen overlays
    79-88): Pearl's 9,216 + 6,400 B fit, ours with the layer probably not, and the Pokétch memory would need a heap.
  - **How they get into the ROM:** a configure.py block + `tools/pearlb2/link_overlays.py` (like link_itcm.py) add
    the overlays to the linker script (MEMORY / SECTIONS), and the build adds them to the overlay table (ids 344-369).
    Black 2 opens its files by path (GFL ArcSys, FS_OpenFile), so NitroFS file ids moving up by 26 should not matter;
    step 0 checks what dsd does. Second fallback: the same linked binaries as plain NitroFS files that a small ITCM
    loader reads to the region (no overlay table change).
- **ITCM (~2 KB, `src/pearlb2/poketch_itcm.c`):** the save accessors (Pearl's `poketch.c`), the script command, the
  bottom-screen entry points (load the system overlay, call it), the step hook, the History hooks. These must work
  while the Pokétch overlay is not loaded.
- **Same-size changes in Black 2's C (#if PEARLB2 ... #else):**
  - `ov036/field_subscreen.c`: the C-Gear's two entries of `sFieldSubscreenDefs` (DEFAULT, CGEAR_WELCOME) -> the
    Pokétch (or Pearl's "no Pokétch" screen when not given / hidden); the NoGear entries -> Pearl's "no Pokétch" screen
    (no Unova C-Gear art); `FieldSubscreen_GetOverrideScreen`'s C-Gear-off check -> the Pokétch's; 
    `FieldSubscreen_GetCGear` -> never our screens (the Xtransceiver code calls C-Gear functions on it).
  - `ov036/fieldmap_event.c`: the per-step counter call -> ours (the original, then the pedometer).
  - `ov012/scrcmd_vm.c`: one command table entry -> the Pokétch command (question 3).
  - `lib/nitro/src/os/os_arena.c`: the DS-mode arena start -> the region's end.
  - History hooks: the catch / hatch / evolution / trade / gift calls (found in step 4).
  All four files are `complete` in the decomp's delinks.
- **Graphics on Black 2:** the field's VRAM is the Pokétch's (FIELDMAP_VRAM_CONFIG: sub BG = bank H 32 KB, sub OBJ =
  bank I 16 KB, as Pearl), so Pearl's BG layout carries over. Sprites: Pearl's sprite module makes OAMs from NNS cells
  (NNS_G2dTickCellAnimation, GetUnpacked*Bank are in Black 2's arm9; MakeCellToOams is ported) and enters them into
  the field cell-actor system's sub OAM manager (`g_ClActSys->oamMans[1]`, OAMs 4-127), which the field sends to the
  hardware each VBlank. BG: Black 2's GFL BG system. Text: BmpWin + PRINTSYS with Black 2's font. Tasks: a GFL TCB
  list of our own run from the bottom screen's update (30 fps, as Pearl's field), VBlank tasks on Black 2's VBlank
  TCB. Touch: GFL_UI_TP. Heaps: GFL heaps (step 0 measures how much the field's heap has free with the C-Gear gone;
  Pearl reserves 2 x 48 KB, its real peak is estimated at about 45 KB: the Roulette's 23 KB work is the biggest).

### Data
- **Art:** Pearl's `graphic/poketch.narc` (126 members, 58,820 B) as it is, Pearl's indices: in place of the C-Gear's
  archive if nothing reachable in PearlB2 still reads it (step 0 lists the readers), else as a new file.
- **Icons:** Black 2's Pokémon icons and palettes (Pearl's are 493 species), remapped to the Pokétch shades as Pearl does.
- **Text:** Pearl's banks 405 (Move Tester), 407 (History), 408 (Berry Searcher), 410 (Link Searcher) as a new member
  of Black 2's system text archive; type names from Black 2's. Bank 406 (app names) stays in the generator.
- **Sounds:** Pearl's 15 Pokétch sounds imported into Black 2's sound archive the way patches/sinnoh_music.py adds
  Pearl's songs (question 5); cries through Black 2's PokeVoice.

### Save data
- **Where:** Black 2's Funfest block (SAVE_BLOCK_FUNFEST, 0xFC B): only the Funfest missions use it, and they go with
  the Entralink (decision 2026-10-19; zone flag 15 = 0 everywhere). Pearl's 232 B + a PearlB2 header (magic,
  version, Pearl's flag 0x97C "Pokétch hidden") in bytes 0x00-0xEF; bytes 0xF0-0xFB are left as Black 2 keeps them
  (the trainer card reads the completed-missions count there, Pass Power the level points). No block moves, so
  every existing save still loads.
- **Old saves:** the first time the Pokétch code reads the block without the magic it runs Pearl's
  `Save_Poketch_Init`. A save made past Jubilife's Pokétch scene before this existed (the scene ran, the commands did
  nothing) then gets the Pokétch and the four first apps: the scene sets Pearl's VAR_JUBILIFE_CITY_STATE (0x4077,
  Black 2 0x4042) to 2 right after GivePoketch, so state >= 2 means "given". Other apps come when the player talks
  to their givers again (each giver asks CheckPoketchApp first, as in Pearl).
- Alternatives if the lead prefers: the Pokéstar Studios block (0x3E4) if Pokéstar is not kept; Black 2 event
  vars (ids from the lead).

### Story (the generator)
- New macros in `src/include/pearl_story.inc`, handlers in `b2tools/pearl_story.py` replacing today's stubs:
  `pl_GivePoketch` (Pearl's sequence: the bottom screen fades out, the Pokétch comes in, fades in: Black 2's
  `FieldSubscreen_ReqChange` does the wipe), `pl_CheckPoketch var`, `pl_UnlockPoketchApp app` (a number or var),
  `pl_CheckPoketchApp app, var`, `pl_HidePoketch` / `pl_ShowPoketch` (Pearl's 0x265 / 0x266). App names stay written
  into the lines (bank 406).
- Zones: Chapter 2 (Jubilife: GivePoketch + apps 0, 1, 3, 4; the Pokétch Company 1F/3F), 4 (Route 207, the Berry
  Master's house, Solaceon, the Day Care, Veilstone Dept. Store 2F), 5 (Route 213's Grand Lake room, Celestic), 6
  (Verity Cavern), 8 (Sunyshore's Pokétch developer), 9 (Pal Park entrance, the Battle Tower), 90 (Eterna's Pokémon
  Center), and Pearl's common script 2009 ("obtained the app"). After the change every chapter is regenerated and
  `git diff src/` must show only these lines (chapters 8 and 9 belong to agents now at work: their regenerated files
  come with the lead's merge).

## 5. Order of building

**Step 0, no C (for the lead's OK):** (a) a dsd probe: the decomp's own build plus one dummy overlay -> a ROM in
work/agents/poketch (512 MB, trashed right after): are NitroFS ids moved, does it boot; (b) one emulator run:
the DS-mode arena (start, end, free) after boot, and the field heap's free bytes with today's NoGear screen; (c) every
reader of the C-Gear archive, the Funfest block and `FieldSubscreen_GetCGear`; (d) the decomp tree
(`agent_tree.py decomp poketch`, ~0.7-2 GB: with the lead's OK).

**Step 1, the shell:** the overlay link support and the arena move; the ITCM part (save, command, bottom-screen
entry, step hook); the system overlay (Pearl's overlay 20 port + Black 2 layer + the "no Pokétch" screen); the
Digital Watch (pokediamond's C); the generator's commands (Chapter 2 first). Test build 1: Jubilife gives the
Pokétch and the watch shows; the button (tap, hold, blocked during a script, the app number); the X menu and back;
save and reload; the boy's blue and the girl's pink case (one girl check: a new kind of gender difference).
**Step 2, the first apps:** Pokémon List, Marking Map (the player's cell, the six markers). Test build 2.
**Step 3, apps without game data:** Calculator, Memo Pad, Pedometer (+ the step hook), Analog Watch, Dot Artist,
Counter, Stopwatch, Coin Toss, Roulette, Kitchen Timer, Alarm Clock, Calendar, Color Changer. Test build 3.
**Step 4, apps with game data:** Friendship Checker, Day-Care Checker, Matchup Checker, Move Tester, Pokémon History
(+ hooks), Dowsing Machine, Berry Searcher, Trainer Counter, Link Searcher. Test build 4.
**Step 5:** all chapters regenerated with the diff proof, an old save loaded, every app compared with Pearl's frame.

Every step: `decomp.py build` (the layout check) and `decomp.py changed` (only the functions named above, ITCM and the
new overlays). Tests start right at the Pokétch (`test_story_start` with `TEST_LINES="pl_GivePoketch;
pl_UnlockPoketchApp 0;..."`); reference frames from Pearl itself (DeSmuME on roms/pearl.nds with the Pokétch given in
RAM) so each app is compared with Pearl's own screen; every frame is looked at for graphical errors. The test driver
needs touch input (`TOUCH x y [frames]`): a change to the shared story_play.py, for the lead to allow.

## 6. Decisions (lead, 2026-10-26)

1. Code: after the last overlay of main memory (step 0 measures the free arena first; the C-Gear's slot only as a
   fallback).
2. Save: Black 2's Funfest block, bytes 0x00-0xef as planned (include/pearlb2/poketch.h `PearlB2PoketchSave`).
3. Command 0x15F becomes PearlB2's shared extension command with a sub-command byte: 0x00-0x1F the Pokétch,
   0x20-0x3F the Underground, 0x40-0x5F Pal Park, 0x60+ ask the lead (notes/EXT_COMMAND.md; the dispatcher is
   `src/pearlb2/ext_cmd_itcm.c`).
4. Pearl's NARC replaces the C-Gear's archive only if step 0 finds nothing that still reads it; else a new file.
5. Pearl's 15 Pokétch sounds (POKETCH_003, 006, 009, 010-014, BEEP, DENSI01, 04, 09-12: every sound overlays 20-49
   play) are imported the way Pearl's music is.
6. Link Searcher: Pearl's screen with nobody found, for now.
7. Move Tester: Fairy is added only when the Fairy option is on.
8. Calculator: cries up to 649 with the National Dex, Pearl's 151 Sinnoh numbers without it.
9. Pearl's two bugs are fixed: the Day-Care Checker shows every egg; the Memo Pad's eraser erases every cell along
   the stroke (Platinum's way).
10. OPEN_CONTENT.md gets a berry-patches row (the Berry Searcher waits for it).
11. No "looking at the Pokétch" pose.
- The test driver gets a touch command, additive only (story_play.py: a new command, nothing existing changes).
- Chapters 8 and 9 keep their stubs until those chapters are merged; the exact macro swaps for them are in section 7.
- A Diamond version may follow: anything that differs between versions, or comes from the build, is data
  (gPearlB2Poketch, filled by patches/poketch.py from the dump), not code.
- Step 0's dsd ROM and the decomp tree wait for the lead's "build ok" (disk ~3 GB). Meanwhile the C is written and
  compile-checked offline (work/poketch_decomp in the agent's tree, compiled with the decomp's own compiler and flags
  into work/agents/poketch/obj; nothing written to the shared decomp).

## 7. Work log

### 2026-10-26: offline, before step 0
- `include/pearlb2/poketch.h`: Pearl's save struct field for field (0xe8), PearlB2's header (magic, version, the
  hidden flag; 0xf0 in all), the build data `PearlB2PoketchConfig`, Pearl's accessors' names, the overlay ids
  (system 344, apps 345-369 in Pearl's app order).
- `src/pearlb2/poketch_itcm.c` (ITCM, ~2.2 KB): Pearl's `poketch.c` function for function; the block's set-up and the
  old-save rule (Pearl's VAR_JUBILIFE_CITY_STATE >= 2: the Pokétch with apps 0, 1, 3, 4); the step
  (`PearlB2_StepRecordAddOne`, RecordAddOne's place in the field's per-step counter); the History hook's entry;
  the Pokétch sub-commands 0x00-0x05; the bottom screen's entries (C-Gear entries -> the Pokétch or Pearl's "no
  Pokétch" screen; C-Gear-off entries -> Pearl's "no Pokétch" screen; no build data -> Black 2's no_gear.c as now).
- `src/pearlb2/ext_cmd_itcm.c`, `include/pearlb2/ext_cmd.h`: the dispatcher (one row per module).
- Compile-checked with the decomp's compiler and flags, no warnings.
- The generator (`b2tools/pearl_story.py` h_poketch, h_poketch_register, h_poketch_enabled, h_poketch_check; the
  NOOP entries and the "0: no Pokétch yet" check removed) and `src/include/pearl_story.inc` (pl_ext and the six
  Pokétch macros). Chapters 1, 2, 3, 4, 5, 6 and 90 regenerated: `git diff src/` changes only Pokétch lines (13
  files: 38 checks, 4 "enabled" checks, 13 registers, 1 give, 1 show; chapters 1 and 3 unchanged).
- **Chapters 8 and 9 (left as they are; their regeneration after their merge makes these swaps by itself):**
  | File | Today's stub | Becomes |
  |---|---|---|
  | 1451_pearl_sunyshore_poketch_developer_house.s (ch 8) | `WorkSetConst PVAR_800C, 0  // CheckPoketchAppRegistered: no Pokétch yet` x3 | `pl_CheckPoketchAppRegistered 18, PVAR_800C  // Roulette`, `... 17 ...  // Dot Artist`, `... 16 ...  // Calendar` |
  | the same | `// RegisterPoketchApp 32772: nothing in Black 2 (...)` | `pl_RegisterPoketchApp PVAR_8004` |
  | 1654_pearl_route_221_pal_park_entrance.s (ch 9) | the check stub x2 | `pl_CheckPoketchAppRegistered 21, PVAR_800C  // Color Changer`, `... 20 ...  // Kitchen Timer` |
  | the same | the RegisterPoketchApp comment | `pl_RegisterPoketchApp PVAR_8004` |
  | 1588_pearl_battle_tower_lobby.s (ch 9) | `pl_stub ShowPoketch  // Pearl 0x266 ...` | `pl_ShowPoketch` |
  Pearl's Battle Tower elevator (0x265 HidePoketch) and common script file 206 (0x265 / 0x266) are in no chapter yet.
- **The decomp side, written and compile-checked offline** (staged in the agent tree's `work/poketch_decomp/`, the
  decomp's paths, originals in `orig/` for a 3-way apply; it goes into the decomp tree once there is one):
  - same-size changes, each compiled before and after with the decomp's compiler: every function and section keeps
    its size (`field_subscreen.c`, `fieldmap_event.c`, `scrcmd_vm.c`, `script_sys.c`). field_subscreen.c needed one
    trick: its C-Gear and C-Gear-off functions, once the table no longer names them, would not be compiled (static,
    unused: -448 B), so under PEARLB2 they lose `static` (PEARLB2_KEPT) and stay where they are (-nodead keeps them);
    `script_sys.c`: command 0x15F allowed at every feature level (Black 2 forbade it at all: { 0, 0, 0 });
    `os_arena.c`: the DS-mode arena starts at PEARLB2_POKETCH_REGION_END;
  - `configure.py` + `tools/pearlb2/link_overlays.py`: the Pokétch's 27 overlays (344 system, 345-369 apps, 370
    Pearl's placeholder app) after OV290, and PKTMEM (the 0x3000-byte Pokétch memory) after them (dry-run on the
    shared decomp's linker script: the MEMORY, SECTIONS, ids and object list come out as dsd's own);
  - the system overlay, Pearl's overlay 20 in C (`src/pearlb2/poketch/`: poketch_system, _graphics, _task,
    _animation, _button; Pearl's one button, task numbers, case tiles, app-number tint), its Black 2 layer
    (`poketch_port.c`: heaps, task lists, GFL BG, the archives, Pearl's touch tests, sounds, cries, OAM buffer and
    vertical-blank writer, the Pokétch memory), the bottom screen (`poketch_screen.c`: Pearl's overlay 19 "no
    Pokétch" screen, the player-moved and step events, the synchronous shutdown); the Digital Watch (Pearl's
    overlay 21) and Pearl's placeholder app (overlay 50) for apps not ported yet. Sizes: system ~13.5 KB (Pearl's
    9.2 KB + the layer), Digital Watch 1.3 KB, ITCM 2.2 KB.
- `b2tools/patches/poketch.py`: Pearl's poketch.narc in place of a/2/7/0 (ARC 270, the Funfest missions app's
  graphics: only overlay 309, the Entralink's, reads it; the C-Gear's own archive 287 is read by the diplomas, the
  battle recorder and more, so it stays); the overlays from the decomp's ELF into the ROM's overlay table; the build
  data (gPearlB2Poketch) in ITCM. Sounds: silent until the import (next).
- `b2tools/b2_script_check.py`: the extension command's sub-command lengths (EXT_ARGS) and the PEARLB2 side of
  `#if` blocks in EVCMD_PERM_TABLE. The scripts with the Pokétch's macros decode cleanly; their 0x15F permission
  complaint goes once the decomp's script_sys.c change is in. **So the generator change and the decomp change must
  be merged together** (a ROM with the new scripts and the old decomp would stop on the first Pokétch command).
- Found on the way: Black 2's field writes its cell actors' sub-screen OAMs every vertical blank and clears them at
  each frame's draw, after the bottom screen's update; Pearl's sprites therefore go into the Pokétch's own buffer and
  a vertical-blank task of priority 10 (after the field's, priority 0) writes them over OAMs 4-127.

### 2026-10-26 (later): steps 2 and 3, the apps, offline
Written in the staged decomp (`work/poketch_decomp/src/pearlb2/poketch/apps/`) and compile-checked with the decomp's
compiler into work/agents/poketch/obj; nothing in the shared decomp. 16 of the 25 apps now have their own code
(the rest show Pearl's placeholder app until step 4):

| App (id) | Pearl overlay | Size | Notes |
|---|---|---|---|
| Digital Watch (0) | 21 | 1.3 KB | (before) |
| Calculator (1) | 23 | 5.9 KB | cries: see below |
| Memo Pad (2) | 24 (Pearl's own C) | 2.3 KB | the eraser fixed (decision 9), see below |
| Pedometer (3) | 31 | 1.4 KB | the save's step count |
| Pokémon List (4) | 27 | 2.8 KB | Black 2's party and icons |
| Counter (10) | 30 | 1.4 KB | Pokétch memory |
| Analog Watch (11) | 25 | 1.3 KB | |
| Marking Map (12) | 42 | 2.1 KB + map tables 0.7 KB in the system | see below |
| Coin Toss (14) | 37 | 1.3 KB | Black 2's Mersenne Twister for Pearl's |
| Calendar (16) | 45 | 2.3 KB | the save's marks |
| Dot Artist (17) | 26 | 1.9 KB | the save's drawing; Pearl's first drawing "Touch!" |
| Roulette (18) | 36 | 3.0 KB | Pokétch memory |
| Kitchen Timer (20) | 41 | 4.0 KB | Pokétch memory, runs on while hidden |
| Color Changer (21) | 44 | 1.1 KB | the save's tint |
| Stopwatch (23) | 22 | 3.5 KB | Pokétch memory, runs on while hidden |
| Alarm Clock (24) | 40 | 3.0 KB | Loudred's cry (294), species only |

The system overlay is now 14.7 KB (with the map tables and the layer's additions); the biggest app is the
Calculator, so the Pokétch's code region is about 14.7 + 5.9 + 12 (the memory) = 33 KB.

- **Checked against Pearl's own code, app by app** (pokediamond's asm; Platinum's C as the reading guide): every hit
  table, sprite position and animation, background template, NARC member, sound id, timer and tile table compared
  with Pearl's rodata and immediates (the Calculator's 17 pressed-button tile tables and button
  rectangles, the Calendar's 37 day cells, the Kitchen Timer's 11 buttons, the Alarm Clock's 13 sprites...). All
  equal to Platinum's but the Pokémon List's cry (species only), the Marking Map's 3 roamer slots and the
  Calculator's dex (Pearl: 1-151 Sinnoh, 1-493 national).
- **Pearl's own slips kept** (Pearl wins): the watches' and alarm's `hour %= 60` guard; the Roulette's line steps along
  x that mark cells as not drawn (`= 0`), and its stop delay (ends at once unless the random number is 0); the Coin
  Toss, Memo Pad and Roulette let an exit request fall through to the same frame's input (Pearl's: a tap in that
  frame can skip the background's free); the Calculator's setup that reports success after a failed allocation;
  the Stopwatch's graphics block not freed when its BG config can't be made.
- **The Memo Pad's eraser (decision 9)**: Pearl kept a cell array to skip cells already holding the tool's value, but
  never cleared it, erased only the centre cell of each 4 x 4 eraser block from it, and knew nothing of a drawing
  brought back from the Pokétch memory, so eraser strokes skipped cells (only each segment's end was erased for sure)
  and pencil strokes over erased cells could leave gaps. Now (Platinum's way): the array starts clear, the first
  touch always paints, every eraser step erases and clears its 4 x 4 block in the array. The pencil, the buttons, the
  window and Pearl's line stepping are Pearl's.
- **Cache**: the Memo Pad and the Roulette upload drawn tiles straight to BG3 (GXS_LoadBG3Char); Pearl did not flush
  the data cache first (Platinum does); here they flush (on hardware a stale line would show a missing dot).
- **The Marking Map** (`poketch_map.c`, Pearl's ov20_02254420 tables in the system overlay): the player's cell is
  Black 2's player tile / 32 on matrix 0 (PearlB2's matrix 0 is Pearl's); elsewhere Black 2's Escape Rope spot,
  which Black 2 sets by Pearl's own rule (leaving matrix 0 for a building or cave: ov035
  EventMapChangeWarp_CreateFromEntity). The hidden places (Fullmoon Island, Newmoon Island, Spring Path, Seabreak
  Path) and the roamers go through two functions that answer "none" until PearlB2 has them (OPEN_CONTENT); the
  roamers' map table keeps Pearl's map ids for then. The six markers are the save's.
- **The Calculator's cries** (decision 8): the dex number n plays a cry if the Pokédex (Black 2's) has seen it: with
  the National Dex the species n up to 649, without it Sinnoh number n (1-151) through Pearl's own table. That table
  (Pearl's poketool/shinzukan, 152 entries, its entry 0 Arceus as Pearl has it) is build data: the patch reads it
  from Pearl's dump and writes it into the Calculator's overlay at `gPearlB2SinnohDex` (so no ITCM; a Diamond build
  gives its own); the 151 and 649 are in gPearlB2Poketch, which is now 44 bytes (the table pointer is gone).
- **The port layer, additions**: Pearl's window calls (the Pokémon List's HP bars, the Memo Pad's and Roulette's
  boards); NitroSDK's 32-bit divider inlines and the 64-bit remainder (Black 2's nitro/cp.h has only the 64-bit
  ones); Pearl's timer 3 = NitroSDK's tick (Black 2 starts it in machine_use.c) with Pearl's clock constant
  (33,513,982 Hz) for the milliseconds and seconds.
- **Found**: Pearl's InitBgFromTemplate also turns the layer on (GfGfx_EngineBTogglePlanes). The Memo Pad and the
  Roulette never turn on their BG3 themselves, so without this their boards would not show; the port's
  Bg_InitFromTemplate now does it too (all apps, as Pearl).
- **Found**: Black 2's Pokémon icon palette file has 3 palettes, Pearl's 4; the icon palettes' load now takes what
  the file has (at most 4).
- **Symbols**: every function the Pokétch's objects call is defined by our objects or the decomp's link, but for the
  two the generated linker script makes (OVERLAY_344_ID, PEARLB2_POKETCH_MEMORY).
- **Heaps (for step 0's measurement)**: the apps' heap peaks are the Roulette's ~37 KB (its 156 x 150 board array 23.4
  KB + the 12.2 KB window) and the Memo Pad's ~18 KB; Pearl gave the apps a 48 KB heap and the system another 48 KB.
- Open (solved below, step 4): the Dot Artist's save hook (Pearl's event 4) had no sender yet.
- To see in the step-2 test: Black 2's icons in the Pokémon List (first frame of each icon file, palettes from Black
  2's file), the HP bars' windows, the Marking Map's cursor indoors and outdoors.
- Left for step 4 (game data): Friendship Checker, Dowsing Machine, Berry Searcher, Day-Care Checker, Pokémon
  History, Link Searcher, Move Tester, Trainer Counter, Matchup Checker.

### 2026-10-26 (later still): step 4, the game-data apps, offline; the save hook; the text
The nine apps that read the game, written and compile-checked the same way (staged decomp, the decomp's compiler,
objects in work/agents/poketch/obj). **All 25 of Pearl's apps now have their code** and the system's table names
every one (`sAppEntries`; Pearl's placeholder app stays as the fallback of an empty entry):

| App (id) | Pearl overlay | Size | Black 2's side |
|---|---|---|---|
| Friendship Checker (5) | 28 | 5.2 KB | the party (eggs left out), friendship, icons (both frames), the no-flip flag of the species' first form; cry by species |
| Dowsing Machine (6) | 29 | 2.2 KB | hidden items: `PoketchMap_GetNearbyHiddenItems` (none yet, below) |
| Berry Searcher (7) | 43 | 2.3 KB | berry patches: `PoketchMap_BerryPatchHasFruit` (none, below); the title from the text file |
| Day-Care Checker (8) | 35 | 2.4 KB | Black 2's Day Care save block (below) |
| Pokémon History (9) | 49 | 1.4 KB | the save's 12 entries (Pearl's {species, form}), icons by species and form, cry by species; the title from the text file |
| Link Searcher (13) | 47 | 2.8 KB | decision 6: Pearl's screens; the scan runs and finds nobody (all counts 0) |
| Move Tester (15) | 38 | 2.8 KB | Pearl's chart; Black 2's type names; Fairy with the option (below) |
| Trainer Counter (19) | 48 | 2.1 KB | no Poké Radar: Pearl's screen without a chain (Pearl's radar calls answer 0 / no species) |
| Matchup Checker (22) | 39 | 3.3 KB | the party, eggs too; Black 2's day-care rule (below) |

Sizes with data. The biggest app is still the Calculator (6.2 KB).

- **Checked against Pearl's own code** (the asm of overlays 28, 29, 35, 38, 39, 43, 47, 48 and 49): every table
  (hit boxes, sprite tables, the Luvdisc's command lists, the Dowsing Machine's three ranges, the 118 berry patches
  extracted from Pearl's rodata), background template, NARC member, sound id and timer.
  Pearl's own, kept (section 2): eggs in the Matchup Checker (the egg's icon in its species' palette, rated as its
  species), the button sound instead of the cry there, mirroring by species, cries by species, text shadow 1. The
  Matchup Checker's step back divides a negative step by the frame count as unsigned (Pearl's `_u32_div_f`): the step
  comes out as 65535 pixels a frame, which the OBJ's 9-bit x turns into -1 pixel, so it looks right; kept (to watch
  in step 5: if Black 2's cell renderer clips the far-off position, the two Luvdisc would vanish for 15 frames).
- **Day-Care Checker**: reads Black 2's Day Care save block (`getDaycareBlockAddress`; the field's day-care object
  lives in the field overlay and is made late in the field's start): a slot counts when its status is set (Black 2's
  `DayCareSave_GetPkm` gives the first slot's Pokémon for an empty slot), the level is Black 2's own rule (experience
  + steps, capped, `CalcLevelByExp`), the sex is the stored one, and **the egg shows when Black 2's egg flag is set:
  Pearl's bug fixed (decision 9: Pearl hid the egg when the low byte of its personality was 0)**. Pearl's mosaic and
  its `/ 20` icon offset kept.
- **Matchup Checker**: the rating is Black 2's day-care rule word for word (ov036 `DayCare_CalcBaseEggSpawnChance`, a
  static function, so a copy in the app): egg groups of the species' form, either group Undiscovered, Ditto by
  species, the stored sex, same species / same trainer id; its 70/50/20/0 are Pearl's levels 0/1/2/3. The icon palette
  is Pearl's (species and form, never the egg's) with Black 2's sex, so a female icon gets its own palette.
- **Move Tester, Fairy (decision 7)**: with the Fairy option on, Fairy is the 18th type in the list (after Pearl's
  17) and the chart uses Fairy's Gen 6 matchups, Steel's change included (Ghost and Dark do normal damage to Steel),
  as PearlB2's battles do with the option on; with it off the list and chart are Pearl's 17 types byte for byte. A
  Fairy choice saved while the option was on resets to Pearl's start when the option is off. **Lead's call to
  confirm**: the Steel change with Fairy.
- **Dowsing Machine and Berry Searcher**: their world data goes through two functions of the system's map module,
  which answer "none" today: hidden items (Pearl's BG events of type hidden item; PearlB2 leaves Pearl's 8000+ scripts
  out until the item pass, DECISIONS 2026-10-25; Black 2's own hidden-item table lists Unova zones) and berry patches
  (Black 2 has no soil; pearl_events.py leaves Pearl's soil objects out). The world pass fills them; the apps need no
  change. Both are on OPEN_CONTENT.
- **The Dot Artist's save (event 4) now has its sender**: a same-size hook in Black 2's `GameData_SaveBackup` (the
  function every save goes through: the menu's, a script's, the extra blocks'): its first store
  `bl TrainerDataSave_StorePlayerInfo` becomes `bl PearlB2_Poketch_StorePlayerInfo` (ITCM, poketch_itcm.c), which
  calls the Pokétch's hook (`gPearlB2PoketchSaveHook`, set while the Pokétch screen is up: it sends Pearl's save event
  to the running app, the Dot Artist writes its drawing) and then the original store. Same size: game_data.c compiled
  before and after with the decomp's compiler, every section and function the same size (objects game_data_orig.o /
  game_data_new.o). Merge note: src/system/game_data.c, under `#if PEARLB2`.
- **The apps' text**: the patch now converts Pearl's banks 405, 407, 408 and 410 from the dump (20 lines: the Move
  Tester's 7, "OBTAINED POKéMON", "BERRIES", the Link Searcher's 11) into one Black 2 text file, packs it with
  pokebw2's packer and adds it after Black 2's 495 files of a/0/0/2 (file 495), reads it back line by line, and puts
  ARC 2 / file 495 into gPearlB2Poketch (textArc, textFile). Tested offline on a clone of Black 2's a/0/0/2: equal on
  read back. **Patch order**: poketch after every patch that repacks a/0/0/2 from sources (sinnoh_names); its
  apply_code checks the file is still there. The port's text layer (PoketchText) prints with Black 2's font 0 into a
  window's pixels; the type names are Black 2's (system text 398).
- **Symbols**: every external function the objects call is defined by our objects or the decomp's link (all in main
  ARM9 or the field overlay, which is loaded while the Pokétch runs), but the three the linker makes (OVERLAY_344_ID,
  OVERLAY_80_ID, PEARLB2_POKETCH_MEMORY).
- **Still to build**: the Pokémon History's senders (Pearl adds an entry at a catch, a hatch, an evolution, an NPC
  trade and a script gift: five hooks in Black 2's game code, to find in the tree once step 0 is in); Pearl's 15
  sounds (silent until imported). To see in step 5: the Matchup Checker's step back, the Day-Care Checker's mosaic,
  the Berry Searcher's title window over the map, the Link Searcher's two-line messages in Black 2's font.


### 2026-10-26 (evening): step 0, then step 1's build
**Step 0** (the lead's "build ok"; the tree re-based onto main 7fb1f9e):
- (d) The decomp tree: `external/pokebw2_poketch`, branch pearlb2-poketch from pearlb2 ce47c4a14d; its first ninja
  passed.
- (a) The dsd probe (the decomp's own build + one 32-byte dummy overlay 344 at 0x021FD080, right after overlay 290's
  end; work/agents/poketch/tools/dsd_probe.py): dsd numbers NitroFS files after the overlays, so **every one of the
  318 NitroFS files moves up one id** (first file id 344 -> 345; names, sizes and order unchanged); overlay 344 gets
  its table entry and file 344. **The ROM boots** to the Game Freak intro, the title and the main menu: Black 2 opens
  its files by path. (So the 27 Pokétch overlays move them up 27: nothing reads ids.) The probe ROM is in the Trash.
- (b) Measured in DeSmuME (tools/measure.py: OSArenaInfo at 0x02fffda0, GFL's sHeapMgr 0x0214181c and the NNS free
  lists): the DS-mode main arena after the root heaps runs 0x023A8AE4-0x023E0000: **221 KB that no heap ever uses**
  (the same at the title and in the field). The region after overlay 290 the Pokétch takes (system 14.7 KB + the
  biggest app 6.2 KB + the 12 KB memory, ~34 KB) moves the arena's start up and leaves ~187 KB. The field's heap
  (HEAPID_FIELDMAP, 1.21 MB) with Black 2's NoGear screen in Twinleaf's bedroom (build v5): 311,600 B free in one block;
  the field menu heap 61 KB free; root heap 1 110 KB free. The Pokétch's heaps come from the field's heap (304 KB free
  vs Pearl's worst ~45 KB: the Roulette's).
- (c) Readers: ARC 270 (the Pokétch art goes there) is read only by overlay 309 (the Funfest missions app: the
  Entralink, gone); the C-Gear's ARC 287 by 11 overlays (C-Gear, NoGear, power on/off, C-Gear help, guru2 receipt,
  battle recorder, the three diplomas, subway map, Marine Tube board: it stays). The Funfest block: the trainer card
  (the completed count, byte 0xF4, which the Pokétch leaves alone) and the Entralink's Funfest/Monolith code (ov021,
  ov143, ov157, ov309). `FieldSubscreen_GetCGear`: field_subscreen.c itself and fieldmap_event.c's Xtransceiver
  ringtone stop (it gets NULL for our screens, as planned). Every module of the game is decompiled C but 20 library
  modules (Wi-Fi, JPEG) and 83 32-byte empty overlays, so the list is complete.

**Step 1's code into the decomp tree**: the staged files applied (script_sys.c and fieldmap_event.c 3-way merged
over upstream changes, cleanly). Found at the first link: **ITCM has no .bss**, and mwcc puts a function pointer
initialised to NULL there (the DS Protect prelink stops on "referenced but has not been written"); the save hook
now sits under `#pragma explicit_zero_data on` like the other ITCM modules' globals. `decomp.py check`: layout kept
(48,572 symbols; ITCM +11,040 B of PearlB2 code in all). `decomp.py changed` against pearlb2's own build: the only new
changes are ours (GameData_SaveBackup 2 B, OS_GetInitArenaLo, EVCMD_PERM_TABLE 1 B, EVCMD_TABLE 4 B,
GameData_UpdateGlobalStepCounter, FieldSubscreen_GetOverrideScreen, FieldSubscreen_GetCGear, sFieldSubscreenDefs);
the others differ by their calls' targets only.

**The generator, re-run on main**: every merged zone regenerated (376; the 52 of chapters not merged yet, 7 and 8,
left alone): first with main's pearl_story.py (identical to the committed files: no noise), then with ours. `git diff
src/` changes 14 files, Pokétch lines only: 38 app checks, 4 enabled checks, 9 + 4 registers, the give, and Chapter
9a's Battle Tower lobby ShowPoketch (2 lines). Proof: work/agents/poketch/regen_proof.diff. Chapter 8's Sunyshore
developer house and Route 221's checks still swap at their own merge (table above).

**ITCM cut (the lead, 2026-10-26: ITCM is nearly full)**: the ITCM part went from 2,269 B to 618 B
(poketch_itcm.o 515 B + the 0x15F dispatcher 103 B). Pearl's save code, the block's set-up, the step's and the
History's bodies and the script's Pokétch sub-commands moved into the system overlay
(`src/pearlb2/poketch/poketch_save.c`: PoketchResident_Step / _History / _Command). The overlay sits after overlay 290,
where nothing else ever loads, so once in memory it stays (unloading an overlay leaves its bytes): ITCM reads it with
FS_LoadOverlay on first use (a step, a History entry or a command before any Pokétch screen) or notes that the bottom
screen's GFL load did, and never reads it again (a second read would clear a running screen's data). It takes none of
GFL's 20 main-overlay slots. ITCM keeps the globals, the entries and Black 2's NoGear fallback (no build data: no
Pokétch overlays in the ROM; the commands then read their arguments and answer 0). The Pokétch region is now
0x021FD080-0x02205C60 (35 KB); `decomp.py check`: layout kept, ITCM +9,376 B of PearlB2 code in this tree.
**A general "PearlB2 resident code" section** fits the same way: after overlay 290 (before or after the Pokétch's
region), loaded once (at boot or on first use) and the DS arena's start moved past it; about 186 KB of the arena's
never-used tail is left after the Pokétch.

**Step 1's build and test (2026-10-26 evening)**. Two fixes found on the way, both in:
- `tools/pearlb2/link_overlays.py` now raises the linker's `__OVERLAY_COUNT` (344 -> 371): NitroSDK's
  FS_LoadOverlayInfo refuses ids past it in DS mode (a DSi takes any), so the system overlay never loaded and its
  zeros ran into ITCM (traced with execution hooks: work/agents/poketch/tools/trace_boot.py). One literal in
  FS_LoadOverlayInfo changes (decomp.py changed: 1 byte; layout kept).
- `b2tools/patches/poketch.py` reads the overlays' bytes from the build's arm9_ovNNN.bin: the linked ELF's overlay
  sections carry no bytes and the 25 apps share one address.
The test build was the full patch list + test_story_start (Jubilife, TEST_START=6,174,773, the coupons' flags, the
president shown) + poketch; the overlay-count fix went into that build's code copy as its one byte, and the ROM was
rewritten. Tested (shots: work/agents/poketch/shots/step1/):
- Before the Pokétch: Pearl's "no Pokétch" screen, pixel for pixel Pearl's render (no_poketch.png).
- The president's script gives the Pokétch: the screen fades to the Digital Watch (12:37), the boy's blue case equal
  to Pearl's (give_sequence.png, case_vs_pearl.png); the girl's pink case (girl_case.png).
- The button: a tap goes to the next registered app (Calculator), the pressed button shows while held, a hold
  switches too (Pedometer); a second press during the switch shows Pearl's app number (02) for 30 frames
  (app_number.png, button_pressed.png, app_switch.png: Pearl's screen-collapse animation, clean frames).
- Blocked during a script: a press during an NPC's message changes nothing.
- The X menu replaces it with Black 2's menu; B brings back the same app (button_xmenu_blocked.png).
- The Pedometer counted the 15 steps walked; save from the X menu, reload (Continue): the Pokétch comes back on the
  Pedometer with 00015 (reload.png).
