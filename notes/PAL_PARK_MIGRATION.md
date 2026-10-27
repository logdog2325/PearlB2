# Pal Park's GBA migration and Catching Show (plan, 2026-10-26)

Part 2 of the user's decision of 2026-10-26 ("Pal Park: both"): Pearl's real migration from the GBA games as an
extra, built from Platinum's decompiled migrator. The user's addition (2026-10-26, through the lead): "make it so for
pal park/ramanas park you can enter without a GBA game being in the bottom slot, but if there is one in the bottom
slot you get to catch the pokemon you want to bring up". Plan only: nothing is built. Part 1 (Ramanas Park) is
notes/RAMANAS_PARK.md.

## 1. What the player sees

- Pal Park opens when the player becomes Champion (PFLAG_0964, Black 2's game-clear flag 2400, set by Chapter 8's
  Hall of Fame: pl_ClearGame / global 9601). Before that the gate is Pearl's as it is.
- **No GBA game in slot 2** (or a DSi / 3DS, which have no slot 2): the gate is Part 1's: the slate clerk, the park,
  the rooms. Pearl's Catching Show receptionist says the show needs Pokémon brought from a GBA game.
- **A GBA game in slot 2** (Ruby, Sapphire, Emerald, FireRed, LeafGreen, same language): the Catching Show
  receptionist offers it: "Would you like to bring Pokémon from <game>?" -> Pearl's migration screen (the GBA game's PC
  boxes; pick 6, Pearl's rules) -> they leave the GBA game (its save is rewritten, as Pearl does) -> straight into the
  Catching Show in the park: six Park Balls, the six to catch in the grass and water, the score, the prizes, and
  the six go to the PC boxes ("Pal Park" as their met location).
- Nothing picked (B, or fewer than 6 in the boxes): no show, just the park. No time limit: the player may migrate
  again as soon as the last show is over (the user, 2026-10-26).
- Pearl's own entry point was the title screen's "Migrate from <game>" (Pearl and Platinum: the main menu; the gate
  only started the show once six were stocked). Here the gate does both: no title-screen entry (decided, section 6).

## 2. Sources (what exists)

| Piece | Platinum (C) | Pearl (pokediamond) | Black 2 (pokebw2) |
|---|---|---|---|
| Slot-2 cart detection, GBA flash read/write | ov97_02235D18.c (CTRDG_IsAgbCartridge, CTRDG_GetAgbGameCode against a 30-row table of the five games x six languages, logo + header checksum at 0x080000BD, CTRDG_IdentifyAgbBackup FLASH_1M, CTRDG_ReadAgbFlash per 4 KiB sector, CTRDG_WriteAndVerifyAgbFlashAsync; pull-out interrupt) | overlay 83, assembly; SDK CTRDG_backup.c / _common.c / _flash_AT29LV512.c in C, the rest .s | only a stub: lib/nitro/src/ctrdg (CTRDG_IsExisting, CTRDGi_InitCommon); machine_use.c replaces CTRDG_Init with CTRDG_DummyInit. No AGB backup/flash code |
| Gen 3 save (2 slots x 14 sectors, footer id/checksum/0x08012025/counter, newest slot by counter) | gba_save.h, constants/gba/save.h, ov97_02235E7C / _02235FFC / _022360D8 | asm | none |
| Gen 3 -> Gen 4 Pokémon | gba_pokemon.c BoxMonGBAToBoxMon (substructs by PID % 24, XOR otId^PID, checksum = bad egg; species table, items Item_FromGBAID, moves as is, ability slot, PID/OT/IVs/EVs/ribbons/ball/met game kept; Unown by PID, Deoxys by cart) | rs_migrate_string.c, itemtool.c UpConvertItemId_Gen3to4 (C) | Gen 4 -> Gen 5 only inside Poké Transfer's child program (dl_rom/child_r_eng.srl, not decompiled): nothing reusable; Gen 5's own Pokémon setters (PML_PkmSetParam) are |
| Strings | gba_convert_string.c (Gen 3 -> Gen 4 codes, Japanese / international tables) | rs_migrate_string.c | Black 2 text is Unicode: chain Gen 3 -> Gen 4 code (Platinum's table) -> Unicode (pokediamond charmap.txt, as gen4_text.py reads it) |
| Rules | main_menu.c (save exists, cart known, 1M flash, National Dex, same language), gba_migrator.c GetCanMigrateStatus (MAC + RTC offset match, else "make adjustments"; 86,400 s since this GBA trainer id's last transfer, 20 ids kept), >= 6 in the boxes, stock empty; per Pokémon: eggs / bad eggs, the 8 HMs (Cut, Fly, Surf, Strength, Flash, Rock Smash, Waterfall, Dive), items in sInvalidGBAItems (mail, key items, unused) refused; boxes only, exactly 6 | the same (asm) | - |
| Selection screen | gba_migrator.c (2,202 lines): box view, icons, touch yes/no; graphics in mystery.narc (gba_migration_*), text migrate_from_gba | overlay 83's (Pearl's own art in the dump) | - |
| The stock + history | pal_park_transfers.c: MigratedPokemon {Pokemon mons[6], u32 gbaTrainerIds[20], s64 timeStamps[20], s64 rtcOffset, u8 mac[6]} | unk_0202BE98.s (asm) | no block; TrainerGameInfo has Poké Transfer's result + high score (PalParkHighScore) |
| Saving | ov97_02233B8C: convert the 6, species 0 in the RAM copy of the GBA save, history, a random 1-120 frame wait, our save to its last step, the GBA flash (the other slot, counter + 1), our save's end, the GBA's last sector | the same | - |
| Catching Show | catching_show.c (ppark.narc: per species area land/water, points, rarity; FieldBattleDTO_NewPalPark), scrcmd_catching_show.c: 0x253 start/end, 0x254 six stocked?, 0x255 to the PC (met location Pal Park, date, met level = level), 0x256 points | scrcmd_13.c (C) for the four commands, unk_0204B9EC.s (asm) for the encounters | Black 2's own "Pal Park" is the Poké Transfer Lab (ov053 scrcmd_palpark.c: plugin 4, launches overlay 181 through EventFieldSubprocessCall_CreateWithCallback: the template for launching our migrator from a gate script) |
| DSi / 3DS | - | - | src/system/dsi.c isRunningOnDSi() = OS_IsRunOnTwl(); a DSi or 3DS runs Black 2 in DSi mode, which has no slot 2: the gate acts as "no cart" without touching the slot |

## 3. Design

### 3.1 Slot 2 (C, a new module)
- `PearlB2_GbaCart_Detect()`: OS_IsRunOnTwl() -> none. Else ARM9 takes the slot (EXMEMCNT bit 7), reads the header,
  checks the logo and the header checksum (as Platinum), the game code against Platinum's 30-row table (game, set,
  language), and the flash chip's id (the 1 Mbit chips Gen 3 used; GBATEK's command sequences, bank switch at 0x0000).
  Same language as our game, else none (Pearl's rule).
- `Read(sector)`, `WriteSector(sector)` (erase + program + verify): our own C from GBATEK and the shape of pokediamond's
  C CTRDG files (no SDK library to link: Black 2 has none, Platinum's comes from outside its tree). The pull-out check
  (CTRDG_IsPulledOut's role): read the header again before each write; a missing cart aborts with Pearl's message.
- Black 2 keeps CTRDG_DummyInit (the slot unused at boot): we never call the SDK's CTRDG at all.

### 3.2 The Gen 3 save and the conversion (C)
- The newest valid slot (checksums, counter), the 14 PC boxes (sectors 5-13), each Gen 3 BoxPokemon decrypted as
  Platinum does; bad egg on a checksum mismatch.
- **Gen 3 -> Gen 5** in one step, Platinum's rules: species (Platinum's table), item (Pearl's UpConvertItemId_Gen3to4;
  Gen 4 ids are Black 2's), moves as is with max PP, ability from the slot (Black 2's personal data; no hidden
  ability), PID, OT id, IVs, EVs, contest stats, ribbons (Gen 5 has their bits), Pokérus, ball, met level, OT gender,
  origin game, Unown from the PID, Deoxys by the cart; Gen 5's own fields: the nature (PID % 25, as Gen 5 stores it),
  friendship to the base value, nickname / OT through the string chain above, then Black 2's own
  PML_PkmSetParam / box-to-party regeneration (as MBParent_StorePokemon does: setMetCurrentDateTime, the Pokédex).
- Fairy (the user's option): no data change here; Black 2's types come from personal data at run time.

### 3.3 The selection screen (C, a new overlay)
- Platinum's gba_migrator.c on Black 2's graphics libraries (BG, OAM, touch, text), with **Pearl's own migration
  art** from the dump (Pearl's overlay 83 / mystery graphics), the box view of the GBA game's 14 boxes, the six
  chosen at the top, Pearl's lines (Pearl's text bank, word for word). This is the big part (Platinum's screen is
  ~2,200 lines plus ~1,100 of conversion and ~800 of cart and save code).
- Where the code lives: not in ITCM (2,496 B left with main and the followers, notes/RESUME.md 2026-10-26). The
  Pokétch's step 0 measured 221 KB of DS-mode arena no heap uses after overlay 290 (0x023A8AE4-0x023E0000, the
  Pokétch's 35 KB taken). The migration screen runs alone (the field is closed while it shows), so it can be its own
  overlay loaded into that area only while it runs, as Black 2's Poké Transfer Lab launches overlay 181 (ov053
  scrcmd_palpark.c), from the gate through a field subprocess call; only a small launcher (the 0x15F sub-commands)
  needs to stay resident (the "PearlB2 resident code" section RESUME plans after the Pokétch merges).
- Pearl's screen is built directly (decided, section 6): no interim list-menu picker.

### 3.4 Rules
Pearl's, as far as they fit: 6 at a time and only 6; from the PC boxes; eggs, bad eggs, the 8 HMs and the refused items
not allowed; the stock must be empty (the show finished or retired). **No time limit** (the user, 2026-10-26): Pearl's
once-a-day rule per GBA trainer id and its MAC + RTC-offset check ("make adjustments") are both left out, so no
clock, trainer-id history or console id is kept. Pearl's National Dex requirement becomes the Champion (the user's
change).

### 3.5 The stock and the save
A save area of about 1.3 KB (the stock only: 6 x 220-byte Gen 5 party Pokémon and a count; Pearl's transfer history
of GBA trainer ids, times, clock offset and console id is not needed without the time limit): a block Black 2
features PearlB2 drops (the Pokétch took the Funfest block; candidates: the Dream World / Game Sync block, Join
Avenue's, Black Tower's: to check against what other agents use: the lead allocates). The save order is Pearl's (our
save, then the GBA flash, the last sectors last), so a power cut never leaves a Pokémon in both or neither.

### 3.6 The Catching Show
- Pearl's gate and park scripts are already generated (Chapter 9b, with Part 1's additions); their four stubbed
  Catching Show commands (0x253-0x256) and GetGBACartridgeVersion (0x26E) become sub-commands of the shared
  PearlB2 extension command 0x15F in Pal Park's range 0x40-0x5F (DECISIONS 2026-10-26; the Pokétch agent writes the
  dispatcher): 0x40 cart present / game, 0x41 open the migration screen, 0x42 six stocked?, 0x43 start / end the show,
  0x44 move the caught to the PC, 0x45 points (catching, time, type, total).
- Encounters during the show: a hook in Black 2's wild encounter (as the Underground's weighted list and rods.c):
  in Pal Park with the show running, a step in grass or water gives an uncaught stocked Pokémon by Pearl's area and
  rarity (Pearl's ppark.narc, from the dump), the stocked Pokémon's own data as the wild one.
- The battle: Pearl's Pal Park battle has no fighting: Park Balls or run, as the Safari Zone. Black 2's battle has
  no Safari mode and only the Master Ball always catches (btl_server_flow_sub.c): a hook makes the Park Ball catch
  every time in the show and the battle menu offers only the balls and Run (to find in ov167's action selection;
  HoennB2's Safari Zone port first: decided, section 6).
- Points, the record (Black 2's PalParkHighScore in TrainerGameInfo can hold it), Pearl's prizes at 2,000-3,500
  points, the "Pal Park" met location (sinnoh_names' Pal Park line) when they go to the PC.

### 3.7 The Diamond version
Nothing here depends on the version: the GBA games, rules and conversion are the same in Diamond and Pearl. Pearl's
"dual-slot" wild Pokémon (routes that change with a GBA game inserted: CheckGBACartridge 0x26E) are a separate
feature, a later extra (decided; notes/OPEN_CONTENT.md), version-specific when built (Pearl's / Diamond's lists in data).

## 4. Testing
- melonDS in DS mode with a GBA ROM and its save in slot 2: **only the user's own dumps** (the lead is asked before one
  is needed). The headless DeSmuME may take a GBA cart too (its slot-2 GBA cartridge add-on): checked before
  asking, so the routine tests run without the user.
- What to test once each: no cart (Part 1 unchanged), a DSi-mode boot (the gate acts as no cart), a cart of each kind
  of save (FireRed/LeafGreen/Emerald header-driven, Ruby/Sapphire hardcoded sizes), the refusals, a second migration
  right after a show (no limit), the
  GBA save afterwards (the six gone, the game still loads in mGBA/melonDS), the show to the end, the PC.

## 5. Size and order
1. Cart + save reader + conversion (C, ~1,500 lines) with an offline test harness on a save file (python reads it the
   same way, compares with the C). 2. The stock, the commands, the gate's offer (scripts). 3. The show's encounters,
   the battle hook, points and prizes. 4. The selection screen. 5. Tests in melonDS with the user's dumps.
Depends on: the code area after the last overlay (the Pokétch agent), the 0x15F dispatcher, a save block (the lead).

## 6. Decided (the lead, 2026-10-26; the user may override)
1. No title-screen "Migrate from <game>": the gate does it.
2. Pearl's own selection screen, built directly (no interim Black 2 list menus), after Part 1 passes.
3. **No migration time limit at all** (the user, 2026-10-26, replacing the lead's "once a day per cart"): neither
   Pearl's daily rule per GBA trainer id nor its MAC + DS-clock check; the save keeps only the stock.
4. The Catching Show's battles are Pearl's: Park Balls and Run only, every throw catches. Reuse what HoennB2's Safari
   Zone port did for its battle mode where it fits (read-only: ~/Documents/GitHub/HoennB2).
5. Pearl's dual-slot wild Pokémon: a later extra (notes/OPEN_CONTENT.md), not now.
Part 2's code: the Pokétch's step-0 measurement is in (section 3's "Where the code lives"); it starts after the
Pokétch merges (its resident section and 0x15F dispatcher), on the lead's go. The sub-commands 0x40-0x45 stay in the Pal Park range 0x40-0x5F of the shared extension command 0x15F
(the Pokétch agent's notes/EXT_COMMAND.md: Pal Park adds its row there once the file is merged).
Still for the lead: a ~1.3 KB save area (the stock); whether the user has GBA dumps for melonDS tests (asked once the code exists).

## 7. Building it (2026-10-26, tree palpark2 at main 670085a, decomp palpark2 from pearlb2 bf2429b4c5)
Where the code goes (the lead, through the coordinator): the migration screen and everything only it needs are their
own overlay; what must always be there goes in the Pokétch agent's "PearlB2 resident code" section (overlay 371,
src/pearlb2/resident/*.c, its data pool b2tools/resident.py; notes/DECOMP_WORKFLOW.md once merged), not ITCM; the
script sub-commands 0x40-0x45 go through the shared 0x15F dispatcher (src/pearlb2/resident/ext_cmd.c). Both arrive with
the Pokétch's merge, so the first build waits for it.

### 7.1 Step 1, done offline: the cartridge, the GBA save, the conversion
- `b2tools/gba_migrate.py` (the offline half, Python): Gen 3 save slots and sections, the PC, a boxed Pokémon's
  decryption, Pearl's rules, the tables the C reads (`tables` -> decomp include/pearlb2/palpark_tables.h: Gen 3 species
  -> National Dex from Platinum's gba_pokemon.c, Gen 3 items -> Gen 4 ids from Pearl's itemtool.c, Gen 3 characters ->
  Unicode through Platinum's gba_convert_string.c and Pearl's charmap, the refused items from Platinum's
  sInvalidGBAItems), `show SAVE` (a save's boxes as the game reads them) and `testcart DIR` (a test cartridge for
  DeSmuME's slot-2 GBA device: a header with the logo from our own Black 2 dump, the game code, the header checksum and
  "FLASH1M_V" for its save-type scan, no game code; and a save made here with six good Pokémon, an egg, one with Surf,
  one holding mail and a Bad Egg). Routine tests need no user dump; the user's own dumps only for the last check.
- Decomp `src/pearlb2/palpark/` (the migration overlay's), `include/pearlb2/palpark.h`:
  - `gba_cart.c`: slot 2 with no SDK library (Black 2 has only the start-up stub): DSi mode (a DSi or 3DS) -> no
    cartridge without touching the slot; the start-up's note of a GBA cartridge and CTRDG_IsExisting; the header
    (0x96, the logo compared with the DS header's own copy in RAM, the checksum), the game code against Platinum's
    five games and six languages, English only (Pearl's same-language rule), the save sizes (Ruby/Sapphire Platinum's
    constants, the others the ROM's table at 0x08000188), the flash chip's id (Macronix or Sanyo 1 Mbit), 4 KiB sector
    reads (bank switch), and a sector write a step a frame (erase, 256 bytes, verify; three tries; the cartridge's
    presence checked every step).
  - `gba_save.c`: Platinum's slot choice (both slots scanned, the newer complete one by its counter, the wrap),
    the slot loaded whole (57 KiB); the write-back to the other slot with counter + 1 and the next rotation, every
    section but the last, then the last after Black 2's own save (SaveControl_ContinueSave's SAVE_RESULT_LAST step:
    Pearl's order).
  - `gba_mon.c` (no Black 2 call: also built on the host): decryption, Pearl's rules (egg, Bad Egg, the 8 HMs, the
    refused items), the string conversion with Platinum's per-language quote marks; `gba_mon_b2.c`: the Black 2 boxed
    Pokémon as Black 2's Mystery Gift makes one (PokeParty_NewTempPkm, PokeParty_CreatePkm with the GBA PID, OT id and
    IVs; exp, item, friendship = base, the ability from the GBA ability bit, nature PID % 25, markings, region = GBA
    language, EVs, contest stats, moves with PP Ups and full PP, the contest ribbons by rank and the 12 others, fateful
    encounter, Pokérus, met location/level/game, ball, OT gender and name; Unown's letter from the PID, Deoxys's form
    by the game as Platinum; a name equal to the species' upper-case English name is no nickname).
- Checked: all of it compiles with the decomp's mwcc (objects; not linked until the overlay exists:
  work/agents/palpark2/tools/cc.sh); gba_save.c and gba_mon.c built on the host (tools/host) against the Python on the
  test save: the slot and counter, the ten Pokémon, the four refusals; the six removed and written back land in the
  other slot with counter 6, and between the two phases the GBA game still loads the old slot with all ten.

### 7.2 Step 2, done offline: the stock, the commands, the show and its battle, the gate
Decided by the lead (2026-10-26): the stock in Pokéstar Studios' save block (notes/DATA.md, the save-block registry);
the migration screen overlay 372 after the Pokétch's (the linker change through the coordinator, with or after the
Pokétch's merge); the show's battle as below (no PARK BALL button art: notes/OPEN_CONTENT.md).
- `include/pearlb2/palpark.h`: PalParkStock (magic 'PPRK', count, the game, show running, start time, time points,
  per Pokémon its area / rarity / points / caught order / types, six Black 2 boxed Pokémon; 880 B at PokewoodSave +
  0x28, checked when compiled), PalParkConfig (the build's data in the resident pool: Pal Park's zone, Pearl's
  arc/ppark.narc for 1-386), the hooks' prototypes.
- `src/pearlb2/resident/palpark.c` (resident): PearlB2_Ext_PalPark, the sub-commands 0x40 the cartridge's game and
  its player's name into a word (loads overlay 372 for PalParkMigrate_CartInfo), 0x41 the migration screen (a field
  subprocess, as Black 2's Poké Transfer Lab starts overlay 181), 0x42 six stocked, 0x43 the show's start (caught
  orders cleared, the start time) and end (2 points a second under 1,000 s), 0x44 the six to the PC (met in Pal Park,
  today, at their level, in a Park Ball, the GBA Trainer and game kept, the Pokédex), 0x45 the points (Platinum's
  catching, time, type, total); the show's encounters (Platinum's TryStartEncounter: every 5-14 steps, an encounter
  tile, the park's quarter, water or land, the uncaught stocked by rarity against a no-encounter weight of 20; Black
  2's wild battle with the stocked Pokémon); the battle hooks.
- Call swaps in Black 2's C (same size: each function's size compared before and after with the decomp's compiler):
  ov036 fieldmap_event.c (the encounter), ov167 btl_server_flow_sub.c (PassPower_ApplyCapture: every throw catches),
  btl_server_flow.c (the sure-escape check: Run always works), btl_client.c (the command screen started again on
  FIGHT / POKéMON; BAG: no bag, a Park Ball aimed at the wild one: seven calls of the item selection), ov012
  event_battle.c (Black 2's battle return queued after the capture is noted and turned into a run, so the caught one
  doesn't join the party). Not yet: a trapping ability (Shadow Tag, Arena Trap, Magnet Pull) on the wild one still
  shows Black 2's "can't escape" on the client side (its static CheckEscapeBlocked): to see in the first build.
- `b2tools/pearl_story.py` translates 0x253-0x256 and 0x26E (pl_SetClearInCatchingShowFlag, ...;
  src/include/pearl_story.inc, through pl_palpark_ext, the Pokétch's pl_ext under its own name); `b2tools/pal_park.py`:
  in the gate, after Pearl's six-stocked check, none stocked and a GBA game in slot 2 -> Pearl's question (bank 403
  lines 0-4 by game, the GBA player's name in word 1) -> YES opens the screen. Regenerated: 1516 (Pal Park) and 1654
  (the gate) translate everything but Pearl's contest commands and one sound.
- gba_save.c gained PalParkGbaSave_ReadPlayerName (the newest slot's name with one sector of memory) and
  cart_info.c PalParkMigrate_CartInfo; the host test reads "TEST" from the test save.

### Testing without the user's dumps (checked 2026-10-26)
The headless DeSmuME (HoennB2's .venv) takes a GBA cartridge in slot 2: libdesmume's globals GBACartridge_RomPath and
GBACartridge_SRAMPath (libc++ std::string in its alternate layout: data pointer, size, capacity with the top bit set)
and slot2_Change(4 = NDS_SLOT2_GBACART) before the ROM opens; DeSmuME scans the test cartridge for "FLASH1M_V", maps
the .sav as a Macronix 1 Mbit flash (id C2 09), and its erase / program / bank switch work and reach the .sav at once
(work/agents/palpark2/tools/slot2_probe.py, on Black 2's own ROM: the ARM9 reads "BPEE" and 0x96 once it takes the
bus, EXMEMCNT 0x880 -> 0x800). Black 2 boots with slot 2 given to the ARM7, as the SDK's lock gives it back. The
start-up's note of the cartridge (0x027FFC30) stays empty in DeSmuME, and Black 2 starts the slot-2 library as a stub,
so gba_cart.c checks the header itself (0x96, the logo, the checksum) instead of CTRDG_IsExisting. story_play.py
gets the same switch when the first build tests the screen.
Pearl's migration art decoded (work/agents/palpark2/art/): the box screen (header bars, the 6 x 5 box, the bottom
buttons) and the confirm screen are member 20 / 21 on member 22's tiles and member 19's palette; the sprites (member
26, 581 tiles, 1D, cells in member 25) hold the arrows, labels and markers.

### 7.3 Step 3, written offline: the migration screen and the build patch (compiled, not yet linked or run)
- `src/pearlb2/palpark/migrate_app.c` (overlay 372, PALPARK_MIGRATE_PROC_FUNCTIONS): Platinum's gba_migrator.c states
  and layout on Black 2's systems, all on the touch screen (the main engine shown on the bottom). BG 2 Pearl's box /
  confirm screen (archive 271 members 20-22, palette row by game), BG 1 the box name and the info line (nickname,
  species, Lv., item, the markings as Pearl's tiles), BG 0 the message window (Black 2's frame and font, Pearl's lines
  from member 42, Black 2's touch YES/NO menu, the wait icon while saving). Pearl's sprites (members 23-26, on the
  1D 32K mapping their cells were made for: the arrows, QUIT, the six marks, the held-item marks, the 30 icon slots)
  with Black 2's icons written into Pearl's slots (ClActSys_WriteCharData) and Black 2's icon palettes at row 8, as
  Platinum writes its own icons in. Pearl's rules and lines: fewer than six that can come, already stocked, egg,
  hidden move, not permitted; six chosen -> the confirm screen -> "The six chosen Pokémon will migrate." YES ->
  "Pokémon CANNOT be returned ... OK?" YES -> "Saving data on Pokémon <game> and Pokémon Pearl..." -> the save in
  Pearl's order (the six converted into the stock and cleared from the GBA boxes in memory, Pearl's 1-120 frame wait,
  Black 2's save to its last step, the GBA's sections but the last, Black 2's save's end, the GBA's last section; a GBA
  write failing before Black 2's save ends cancels it and empties the stock) -> "Six Pokémon safely migrated to the
  Pokémon Pearl Game Card." NO goes back to the box with the six still chosen. Heap: Poké Transfer's (never together).
- `b2tools/patches/pal_park.py` (after the Pokétch's patch in the build list): archive 271 = Pearl's
  graphic/mystery.narc (LZ members unpacked) + member 42, the text (Pearl's bank 403, 46 lines, then YES / NO), read
  back equal; PalParkConfig into the resident pool (1,552 B) with gPearlB2PalPark. Tested offline on an empty files
  tree. The generator's gate helper is now `b2tools/palpark_offer.py` (a module named pal_park would shadow the patch).
- Shipping (the user, 2026-10-26, through the coordinator): in alpha 0.1 as untested / experimental. After the
  Pokétch's merge: overlay 372 in link_overlays.py (after the Pokétch's region, the arena start past it), compile,
  link, layout check, and one smoke run: boot; the gate with no cartridge as Part 1; with the test cartridge the
  screen opens without a crash. No other tests.
- Wired in after the Pokétch's merge (main 5fb4b23, decomp pearlb2 4bce5c1eb1): the decomp's
  tools/pearlb2/link_overlays.py links src/pearlb2/palpark/*.c as OV372 after PKTMEM, PEARLB2_REGION_END (the DS
  arena's start) after it, PEARLB2_OVERLAY_COUNT 373; configure.py passes them (--palpark); the 0x15F dispatcher's
  row 0x40-0x5F is PearlB2_Ext_PalPark; b2tools/pearlb2_overlays.py puts 372 into the ROM's overlay table with the
  others. The build list has pal_park after poketch (notes/RESUME.md).
