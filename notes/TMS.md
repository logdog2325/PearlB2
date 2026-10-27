# Pearl's TMs and HMs in Black 2 (design 2026-10-18, built 2026-10-26)

The user's choice (question 9, A): every Pearl TM teaches Pearl's move, and Defog and Rock Climb work as field moves.
Way 2 (question 9b, B): Black 2's TMs stay, Pearl's 25 missing moves are TM96-TM120.
Audit: `b2tools/tm_audit.py` (73 same, 2 renumbered, 25 missing). All facts below are from pokebw2's C unless marked.

## Built (2026-10-26): TM96-TM120
The user's answers of 2026-10-26: items 505-529 (Black 2's unused Data Cards 01-25); Unova Pokémon learn a new TM where
they learn a close Black 2 move (as HoennB2); the three lines that call a TM a Hidden Machine say Technical Machine.

| Here | Pearl | Move | Item |   | Here | Pearl | Move | Item |
|---|---|---|---|---|---|---|---|---|
| TM96 | TM01 | Focus Punch | 505 | | TM109 | TM59 | Dragon Pulse | 518 |
| TM97 | TM03 | Water Pulse | 506 | | TM110 | TM60 | Drain Punch | 519 |
| TM98 | TM09 | Bullet Seed | 507 | | TM111 | TM62 | Silver Wind | 520 |
| TM99 | TM19 | Giga Drain | 508 | | TM112 | TM67 | Recycle | 521 |
| TM100 | TM23 | Iron Tail | 509 | | TM113 | TM72 | Avalanche | 522 |
| TM101 | TM34 | Shock Wave | 510 | | TM114 | TM76 | Stealth Rock | 523 |
| TM102 | TM43 | Secret Power | 511 | | TM115 | TM78 | Captivate | 524 |
| TM103 | TM47 | Steel Wing | 512 | | TM116 | TM79 | Dark Pulse | 525 |
| TM104 | TM48 | Skill Swap | 513 | | TM117 | TM82 | Sleep Talk | 526 |
| TM105 | TM49 | Snatch | 514 | | TM118 | TM83 | Natural Gift | 527 |
| TM106 | TM51 | Roost | 515 | | TM119 | HM05 | Defog | 528 |
| TM107 | TM55 | Brine | 516 | | TM120 | HM08 | Rock Climb | 529 |
| TM108 | TM58 | Endure | 517 | | | | | |

Pearl's other TM/HMs teach the same move under Black 2's number: 73 the same number, HM06 Rock Smash = Black 2's TM94,
HM07 Waterfall = Black 2's HM05 (`python3 b2tools/tm_audit.py` prints all 100).

How (decomp branch pearlb2, notes/DECOMP_WORKFLOW.md; data: b2tools/patches/pearl_tms.py):
- `include/pearlb2.h`: `PEARLB2_TM_FIRST_ITEM 505` and the machine bits from 101: the ONE place the ids are set (the
  tables below, the patch, the generator and the audit all follow it).
- `src/pearlb2/tms_itcm.c` (ITCM): which items are TMs/HMs, each one's move (Black 2's `TM_MOVE_LIST`, made global, and
  `sPearlTMMoves`), its machine bit, the Bag's "No. N" (3 digits from 100) and sort (TM01-TM120, then HM01-HM06), the
  shop's TM numbers (Black 2 printed item - 327). `src/system/pml_item.c`: `PML_ItemIsTMHM`, `PML_ItemIsTM`,
  `PML_ItemGetTMWazaID`, `PML_ItemGetTMBitMask` are same-size thumb stubs (push, bl, pop, nops) that call them; the
  icon table (the TM disc in the move type's palette), the dummy bits (cleared) and the unholdable bits (set) for
  505-529. `src/system/myitem_savedata.c`: 505-529 in the TM pocket. `src/ov142/itemmenu_disp.c` / `itemmenu.c`
  and `src/ov036/scrcmd_shop.c`: the calls above (call targets only). The day care's TM loop (TM01..ITEM_LAST) and
  the scripts' TM count (TM01..TM95) already run over 505-529. `decomp.py changed`: only these functions and tables.
- `patches/pearl_tms.py`: a/0/2/4 505-529 = Black 2 TM01's record with Pearl's price and sort index = bit; a/0/1/6
  machine bits: species 1-493 and their forms learn each of Pearl's 100 TM/HM moves exactly as in Pearl (the dump's
  personal_pearl.narc; Pearl's own Deoxys and Wormadam form records, else the species'), on the bit of the item that
  teaches it here; Black 2's TMs Pearl lacks keep Black 2's bits. Text: data/text_overrides/pearl_tms.json (names
  "TM96"..., each move's Black 2 description; sinnoh_names packs it).
- Unova species (494-649 and forms) learn a new TM where they learn its close Black 2 move (`tm_audit.PROXY`):
  Focus Punch <- TM52 Focus Blast; Water Pulse, Brine <- TM55 Scald; Bullet Seed <- tutor Seed Bomb; Shock Wave <-
  TM57 Charge Beam; Secret Power, Natural Gift <- TM27 Return; Steel Wing, Defog <- HM02 Fly; Endure <- TM17 Protect;
  Silver Wind <- TM76 Struggle Bug; Avalanche <- TM79 Frost Breath; Captivate <- TM45 Attract; Rock Climb <- HM04
  Strength; Giga Drain, Iron Tail, Skill Swap, Snatch, Roost, Dragon Pulse, Drain Punch, Recycle, Stealth Rock,
  Dark Pulse, Sleep Talk <- Black 2's own tutor for that move.
- The story: `pearl_story.py` maps every Pearl item value by move (`tm_audit.pearl_item`: the give-item var 0x8004,
  the item balls' 0x8008, CheckItem / AddItem / BufferItemName ...) and marks each line `// Pearl item N`. Roark's
  TM76 gives TM114 Stealth Rock, Maylene's TM60 TM110 Drain Punch, the Oreburgh Gate man TM94 Rock Smash, the Great
  Marsh man TM119 Defog; Jasmine (Sunyshore) HM05 Waterfall and Route 217's ball TM120 Rock Climb once their
  chapters are installed. Gift lines name the item through
  its buffer (TM114 ...). `data/pearl_text_edits.json` (gen4_text applies it): "Hidden Machine" -> "Technical
  Machine" in the Oreburgh Gate man's two lines, the Great Marsh man's and a Pastoria resident's.
- Shops: Pearl NDS's Marts are Black 2's badge Mart (lists 0-5: no TMs). Pearl's Veilstone Department Store TM lists
  and Game Corner prizes are not ported; when they are, map them by move too (Natural Gift = TM118, Endure = TM108;
  `tm_audit.py check` lists them).
- Proof: `python3 b2tools/tm_audit.py check [FILES]`: every Pearl TM/HM -> its item -> the move -> its learners
  against Pearl's data (all 100: equal), the Unova bits against their close moves, Black 2's own TMs unchanged, the
  items' data, every TM line of the installed scripts, the built code's move table.
- **Save**: no change. The TM pocket keeps 109 slots and holds item ids as before; 505-529 are existing ids (Pearl
  hands out 100 different TM/HMs here, Black 2 had 101). PKHeX opens the saves and names 505-529 Data Cards.
- Not built: Defog and Rock Climb as field moves (below; the lead asks the user first), the Fly list.

## What Black 2 fixes in place [code]
- TM/HM moves: `TM_MOVE_LIST` (`src/system/pml_item.c:124`), 101 entries: TM01-TM92, HM01-HM06, TM93-TM95.
  `PML_ItemIsTMHM` / `PML_ItemGetTMWazaID` / `PML_ItemGetTMBitMask` map item ids to it by fixed ranges.
- Which Pokémon can learn each: 128 bits per species in the personal data; 101 used, 27 spare.
- Items: ids 0-638 (`ITEM_LAST`); 20 are unused (113-115, 120-133, 426-427, 622). Many in-memory tables are sized
  `ITEM_LAST + 1` (pockets per item `sItemPockets`, the bag screen's lists), so ids above 638 need code changes.
- Save: the TM pocket holds 109 slots, and the Free Space bits cover ids 0-671. Pearl hands out 100 TMs/HMs.
- Field moves: `HIDEN_EVENTS_NORMAL[11]` (`src/ov012/hiden_event.c:115`), `sHidenMoves` and `PokeList_GetHidenResult`
  in the party menu (`src/ov165/plist_sys.c:126`, `:2474`), `ItemMenuDisp_IsFieldMoveTM` in the bag
  (`src/ov142/itemmenu_disp.c:713`). Black 2's Rock Smash is a script on each rock ("use Rock Smash?").

## Two ways to build "every Pearl TM teaches Pearl's move"

**1. Reuse the TM slots of Black 2's moves that Pearl never hands out (recommended).** 26 Black 2 TMs/HMs teach moves
that are not Pearl TMs (Hone Claws, Psyshock, Scald, Volt Switch, Dive, ...). Pearl's story never gives them, so Black
2's table can simply become Pearl's: TM01-TM92 are Pearl's TM01-TM92 with **Pearl's numbers**, HM01-HM04 stay, and the
HM slots and TM93-TM95 take Waterfall, Rock Smash, Defog and Rock Climb.
- Changes: the 101-entry move table, item names/descriptions of the changed TMs, and each species' TM bits (from
  Pearl's own list: pokediamond `files/poketool/personal_pearl/personal.json` "tms"/"hms").
- No new items, no bigger tables in the code, no change to the save (PKHeX keeps opening saves).
- Small code patch: Pearl has 8 HMs and Black 2's code treats 6 slots as HMs (`PML_MoveIsHM`, `HM_COUNT`), so 2 more
  slots must count as HMs (cannot be forgotten casually).
- Cost: Black 2's own TM moves (Scald, Volt Switch...) are not TMs in Pearl NDS. They can stay available from move
  tutors if wanted.

**2. New TMs numbered TM96 and up (the wording of option A).** 25 new items.
- Black 2 has only 20 unused item ids, so 5 more need ids above 638: every `ITEM_LAST`-sized table in the code grows.
- The id-to-TM ranges, the 101-entry move table (moved to free space), names, descriptions, icons, prices.
- Pearl's TM numbers would differ from Pearl (Focus Punch would be TM96, not TM01).
- Roughly 2-3 times the code work of way 1, with more risk to the bag screens.

Either way, Gen 5 Pokémon (Unova species, only obtainable by trade) need compatibility for the moves Pearl adds;
default: copy it from Black 2's own data where the move is a Gen 5 tutor move, else none.

## Defog and Rock Climb as field moves
- **Rock Climb:** like Black 2's Rock Smash, each climbable wall gets an event: "This rock wall looks climbable. Use
  Rock Climb?" then the climb movement. Pearl's walls are tile behaviours in its chunks (`work/pearl/land`), so the
  converter can place these events automatically. The party menu entry is optional (Pearl's also works by facing the
  wall).
- **Defog:** clears Pearl's fog. Black 2 has no fog weather [to check: its weather list and lights]; plan: a fog look
  per zone, and Defog from the party menu (a new `HIDEN_EVENTS_NORMAL` entry and a party-menu move) clears it until
  you leave the zone, as in Pearl.
- Both need the HM-free option (HoennB2's start-of-game option) to cover them too. (The user did not choose the
  HM-free option: DECISIONS 2026-10-18 question 4.)

### Rock Climb, built offline (2026-10-26; no C)
- Pearl's walls: tiles with behaviour 0x4B (climbed facing up/down) or 0x4C (left/right), all solid (collision bit),
  so the converted maps keep them as walls. `b2tools/rock_climb.py` lists them world-wide: **60 walls, 245 tiles, in
  21 zones**, each one lane wide: Mt. Coronet (south 1F, 4F room 1 to Spear Pillar, both mountainsides, the tunnel
  room), Routes 207, 208, 210 North, 211 East, 213, 216, 225-227, Valor Lakefront, Veilstone, Sunyshore, Victory Road
  1F, Sendoff Spring, Stark Mountain.
- `rock_climb.py --write` -> `data/pearl_rock_climb.json`: every place a climb starts (118: the walkable tile at each
  end of a lane, facing along it; 2 left out, Mt. Coronet north mountainside's (31, 51-52), whose south end is off
  Pearl's map), with Pearl's moves (pokeplatinum ov5 FieldTask_StartUseRockClimb: hop JUMP_NEAR_FAST onto the wall,
  WALK_FAST while the tile ahead is a climb tile, hop off: L + 1 tiles, 3 for a 1-tile wall) and the landing tile.
- `pearl_events`: each start is a sign event on the first climb tile, read facing the wall (its direction), at the
  standing tile's height, running a proxy of Pearl's own global script 10003 (scr_seq 375: "The wall is very rocky...
  Would you like to use Rock Climb?": a party Pokémon with Rock Climb, the Icicle Badge, no partner following).
- `pearl_story`: CheckHasPartner = Black 2's pair flag (PL_FOLLOW_FLAG); UseRockClimb compares the player's tile and
  facing with the zone's starts and runs that start's moves (Pearl's codes, the same in Black 2). No cut-in (as Cut
  and Rock Smash here) and no dust effect or sound yet. Rock Climb from the party menu (Pearl's 10011) is not built:
  that needs the party menu's field-move list (C); facing the wall and pressing A is enough to climb.
- Installed with the zones already generated (Mt. Coronet south 1F, Routes 207, 208, 213, Valor Lakefront,
  Veilstone); the other 15 zones get their climbs when their chapters generate them.

### Defog, built offline (2026-10-26; C approved by the lead)
- Pearl's fog that Defog clears is weather 14 (WEATHER_DEFOG): Route 210 North, Mt. Coronet B1F, Turnback Cave (all
  rooms), Victory Road 1F back 2. Weather 8 (WEATHER_FOG: Routes 206 and 208, Iron Island, the League, Sendoff
  Spring) is a lighter mist Defog does not touch (not built: open). Pearl has no "use Defog?" prompt (its script for
  one, 375 entry 6, is unused): Defog is used from the party menu only, with the Relic Badge (pokeplatinum
  FieldMoves_CheckDefog, FieldMoves_UseDefogFromMenu).
- The look: Black 2's mist, weather 9 (a 3D fog with a light tint; Black 2 gives it to Routes 14 and 15 on some days).
  `patches/pearl_defog.py` gives it to the installed deep-fog zones' headers (Route 210 North 437, Mt. Coronet B1F
  328, Turnback Cave's entrance 382, Victory Road 1F back 2 362; Turnback Cave's other rooms have no Black 2 zone yet);
  season_weather leaves them to their header.
- The code (decomp, include/pearlb2.h, src/pearlb2/defog_itcm.c; each change in place is a call target or a table
  value): the party menu lists Defog (PearlB2_PokeList_GetHidenResult at PokeList_GetHidenResult's two calls: result
  24); the field turns result 24 into hidden-move kind 13 (PearlB2_GetPokeListResult, the party screen's entry of
  FIELD_PROC_LINK_LIST); kind 13's check and event (PearlB2_GetHidenEventCheckFunc / CtorFunc at CheckAllowHidenEvent's
  and CreateHidenEvent's calls): usable when the field's weather is the mist (else Black 2's "can't be used here")
  and with the Relic Badge (else Black 2's badge message); the event runs global script 10016.
- The script: `src/field_scripts/1243_global_10000.s` = Black 2's field-move scripts with Script_17 (10016): "X used
  Defog!" (Pearl's line), Black 2's HM cut-in, map-local flag 0x52, `FieldSetWeather 0, 0` (the mist fades out).
  The clear sky stays through battles (their return resets the weather: GetWeatherAll asks PearlB2_ZoneWeather
  first, which answers none for a fog zone while 0x52 is set) and ends when the player leaves (Black 2 clears
  map-local flags at every zone init), as in Pearl. Its text: `src/text/script/
  1236_field_moves.txt` = Black 2's global 10000 lines + Pearl's line 34; the decomp points global 10000's text there
  (script_sys.c). `pearl_defog.py --sources` writes both from pokebw2's files; the build checks they are current.
- Tested (2026-10-26, DeSmuME, Route 210 North with a test start): the mist; Giratina's party menu lists Defog; "Giratina
  used Defog!", Black 2's cut-in with Giratina, the mist fading (weather 9 -> 0); in and out of Grandma Wilma's house
  brings it back (9). Shots: work/agents/tms/shots/defog_*.png. The fog came back after a trainer battle: fixed with
  flag 0x52 (above) and retested: after Defog and a won battle with Dragon Tamer Patrick the weather stays 0 (flag
  0x52 set); in and out of the house the flag is clear and the mist is back (9).
- Not built: Pearl's Defog sound and its clearing animation (Black 2's mist fades out instead), the battle's fog
  (Pearl lowers accuracy in battles under fog; Black 2's mist has no battle effect), Rock Climb from the party menu
  (the same machinery could list it).

## Next steps (2026-10-18; done: see "Built")
1. User: confirm way 1 or way 2 (START_HERE question 9b).
2. Build it as a patch (`b2tools/patches/pearl_tms.py`), test in a ROM: the TM case, teaching each changed TM, a
   Pokémon that can and one that can't learn it, and an old Black 2 save still opening.

## Status (2026-10-18, paused: the user put TMs/HMs after the main work)
- Chosen: way 2 (TM96-TM120). Item ids (agreed with HoennB2 2026-10-18, notes/LINK.md: HoennB2 keeps 120-128 for
  its TM96-TM104): free 115, 129-133, 426, 427, 622 (113/114 reserved for the Fairy items), plus 16 Unova-only items
  to pick (was: free 115, 120-133, 426, 427, 622 + Unova-only items Gram 1-3 (623-625), Plasma Card (633), Grubby Hanky (634), Liberty Pass (574),
  Dragon Skull (579): only the pocket and icon tables refer to them, no script hands them out in Pearl's world.
- Every user of the TM code is known (relocations in pokebw2 config/b2_us): 6 functions in arm9 (PML_ItemIsTMHM
  0x02026a94, PML_ItemIsTM 0x02026abc, PML_ItemGetTMWazaID 0x02026ae4, PML_MoveIsHM 0x02026b18,
  PML_ItemGetTMBitMask 0x02026b40, PML_ItemGetHMID 0x02026b84), sItemPockets 0x0208f4d0, TM_MOVE_LIST 0x02090c84.
  New code goes to ITCM (HoennB2's method: append to itcm.bin, raise code_size, move the arena literal 0x0207B400).
- TM numbers are printed in 3 places that must call a new helper (3 digits for 100+): bag
  (ov142 itemmenu_disp.c:483, BitMask + 1), shop list and shop confirm (ov036 scrcmd_shop.c:1054, :1614,
  item - ITEM_TM01 + 1). Bag sort (itemmenu.c:1678) sorts by bit: new TMs land after the HMs unless patched.
- Compatibility bits: new TMs use bits 101-125 (pokebw2's species_data.py names TM96 as HM01's bit, so set the bits in
  the packed a/0/1/6 directly). Gen 1-4 species from Pearl's list; Unova species from Black 2's tutor lists where the
  move is a tutor move.
- Started: `b2tools/pokebw2_mod.py` (edit pokebw2's JSON on a clone, pack with its own packers). Its check still fails:
  species_data.py also reads `src/ov036/scrcmd_shop.c` (the tutor lists), so the clone needs `src/` too.

## Lessons from HoennB2's TM96-TM104 (message from the HoennB2 session, 2026-10-18; files in ~/Documents/GitHub/HoennB2)
HoennB2 built real new TMs (b2tools/patches/new_tms.py + new_tms.c, docstring lists every address); the user passed
its test (TM pocket, "No. 96-104", ABLE/NOT ABLE, teaching). Apply to Pearl's TM96-TM120:
- Item ids must stay <= 638 (ids above are cut to 0 in ~30 places): this confirms the plan (free ids + reused
  Unova-only items, all <= 638).
- Long-jump the four arm9 functions (IsTMHM 0x02026a94, IsTM 0x02026abc, GetTMWazaID 0x02026ae4, GetTMBitMask
  0x02026b40) to ITCM replacements. Compatibility bits 101-127 are free (personal a/0/1/6 +0x28, 128 bits).
- Bag pocket table ITEM_CATEGORIES 0x0208f4d0 = 2 (TMs); pocket holds 109.
- Bag "No. N" = BitMask+1 with 2 digits: patch ov142 0x0219dfa4 / 0x0219dfe0 (3 digits) and 0x0219ba36 (sort key).
- Day care TM-move loop starts at item 328 (ov036 0x021be4e2): lower it to the first new id.
- Item data: copy TM01's a/0/2/4 record, set the sort index; icons table 0x02090d50 (TM disc 397 + the move type's
  palette); clear the dummy bits and set the unholdable bits (0x02090a48 / 0x02090a98).
- Shops print item - 327: patch before selling a new TM (Veilstone sells Natural Gift = TM118).
- Regenerate every item source after the mapping and check the BUILT ROM; gift text must name the same move.
- Test like the user: a melonDS test ROM whose town sign gives a Lv 100 Pokémon + FLAG_SYS_POKEMON_GET + the TMs
  (never in a zone init).
