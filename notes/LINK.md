# Trading and link battles with the Hoenn games (plan, 2026-10-18)

User (2026-10-18): trading must work between Pearl (later Diamond/Platinum) and the Hoenn remakes (HoennB2's
Sapphire/Ruby/Emerald NDS), as HoennB2 just made it work between its three versions. Reference: HoennB2
notes/LINK.md (read-only; its link files were not yet committed when read).

## What must match HoennB2's link builds
1. **Link protocol id**: HoennB2's patches/link.py: the Union Room GGID 0x1380 -> 0x4842 (ov028 0x02172ce4) and the
   Wi-Fi Club status bytes moved (+0x18 -> +0x1d, +0x17 -> +0x1e, ov173 0x021a61c0-0x021a61cc). PearlB2 uses the same
   values (copy link.py once HoennB2 commits it), so Pearl NDS and the Hoenn games see each other and nothing else.
2. **Battle rules**: HoennB2's fairy.c link sync (the server's Fairy/split answers in BtlMainSyncData's spare nibble).
   Pearl's Fairy option (Rowan's question) uses HoennB2's fairy patch, so the sync matches.
3. **Shared numbers**:
   - Fairy items 113/114 and Fairy moves 560-565: the same in both (Pearl keeps 113/114 for them).
   - New TM items: HoennB2's TM96-TM104 are items 120-128; Pearl's TM96-TM120 are items **505-529** (the Data Cards
     01-25, BW1 items Black 2 never uses; the user, 2026-10-26). TMs can't be held, so they never travel in a trade.
   - **Place names (met locations)**: a Pokémon's met location is a line of system text 109. Pearl's Sinnoh names are
     on lines 4-114 today (sinnoh_names.py), where HoennB2 has Hoenn's names: a Pokémon met in Twinleaf would say
     "Littleroot Town" in the Hoenn games. Both projects need one registry: Sinnoh's names on lines the Hoenn games
     don't use (and the Hoenn names in Pearl), probably past Black 2's 155 lines (to check: does the game bound the
     place-name index?). To agree with the HoennB2 session.
4. **Trade evolutions**: Pearl keeps Black 2's trade entries (as HoennB2's keep_trade_methods) next to its in-game
   ones (the user chose trade evolutions always on).

## Pokémon Center 2F (the desks)
Pearl's 17 Center 2F rooms are needed (Union Room + Wi-Fi Club desks), but Black 2 has 6 zones too few for all of
Pearl's rooms. Plan: ONE shared 2F zone. Each Center 1F's stairs become a step script that stores the town in a work
and changes map to the shared 2F; the 2F stairs script changes map back to that town's 1F stairs (one zone instead
of 17: frees 16). Desks: Black 2's global 2101 (Union Room) / 10100 (Wi-Fi Club) after flag 106, as HoennB2's
centers_rooms.py LINK_COUNTER, after the Pokédex. Needs the story scripts' id plan (data/pearl_story_ids.json).

## Agreed with the HoennB2 session (2026-10-18)
- **Place names**: Hoenn keeps its lines in all three Hoenn versions: 4-89, 91, 106, 107, 109-112. Black 2's file 109
  has 154 lines (0-153); free: 0-3, 90, 92-105, 108, 113-153 (too few for Sinnoh's 111). So **Sinnoh moves to lines
  154+** once a test shows the game takes met locations above 153 (set a Pokémon's met location to 200, open its
  summary/Trainer Memo, do a link trade; nobody has checked a clamp yet). Then Pearl sends HoennB2 its line list
  (line -> name) to append, and Pearl carries Hoenn's names on 4-112.
- **TM item ids**: HoennB2 keeps 120-128 (its TM96-TM104); 113/114 (Pixie Plate, Fairy Gem) shared and identical.
  Pearl's TM96-TM120 were agreed on 115, 129-133, 426, 427, 622 + Unova-only ids; **built 2026-10-26 on 505-529
  instead** (the user's choice: the Data Cards 01-25, one block, so Pearl's code is range checks; 115, 129-133, 426,
  427 and 622 stay free). Their machine bits are 101-125 (HoennB2's are 101-109 on its own species data; bits don't
  travel either: each game reads its own personal data). Where set: the decomp's include/pearlb2.h
  (PEARLB2_TM_FIRST_ITEM), notes/TMS.md.
  For the HoennB2 session (2026-10-26): "Pearl NDS's TM96-TM120 are items 505-529 (the Data Cards 01-25), not the
  115/129-133/426/427/622 + Unova-only ids we agreed; nothing of yours changes, and 115, 129-133, 426, 427, 622 are
  free again on Pearl's side."
- **Link code**: committed in HoennB2 main ae80a9d (link.py GGID 0x4842 + Wi-Fi status bytes; fairy.c/fairy.py link
  battle rules; trade_evos keep_trade_methods; centers_rooms desks; src/field_scripts/1231_global_2100.s;
  overrides_link.json); sapphire-ruby 2869f86. The user tested Sapphire <-> Emerald trades and battles in melonDS.
  HoennB2 tells PearlB2 first if the link id changes. Link battles depend on the Fairy option bit and the split bit.

## Progress (2026-10-18, evening, user away)
- `b2tools/patches/link.py`: HoennB2's link patch copied (same Union Room GGID 0x4842 and Wi-Fi Club status bytes
  +0x1d/+0x1e), so Pearl NDS and the Hoenn games see each other and nothing else. Built, not yet tested between two
  emulators.
- Place names: `sinnoh_names.py` PLACE_LINES 'high' (default now): Sinnoh's 111 names on new lines 154-264, the Hoenn
  games' names on their lines (`data/hoenn_places.json`, a snapshot of HoennB2's lines; line 69 is "Aqua Hideout",
  Sapphire's name, where Ruby says "Magma Hideout"). Checked offline: the packed file has 265 lines with Twinleaf
  Town on 154. In game (met location above 153 in the summary, the place banner): next test build.
  `data/sinnoh_places.json` is the list to send HoennB2 once the in-game check passes.
- **Met locations above 153 (tested in game 2026-10-18)**: a Piplup given in Twinleaf stores met location **154**
  (read from its encrypted data in RAM), but its summary said **"Faraway place"**. Cause, in pokebw2's C:
  MetLocation_GetNameIndex (arm9 0x02035fac, src/system/pml_met_data.c) returns line 2 for any location from 154 to
  30000. Fix (sinnoh_names.apply_code): `cmp r0, #154; blo` -> `lsrs r3, r0, #9; beq` (0-511 show their own line), and
  the place-name file padded to 512 lines with "Faraway place". **The Hoenn games need this same 4-byte edit and the
  padding** to show Sinnoh's names for Pokémon traded from Pearl NDS. **Tested after the fix**: the same Piplup's
  summary shows "Twinleaf Town". Sent to the HoennB2 session (2026-10-18): the line list (data/sinnoh_places.json),
  the 4-byte edit and the padding.
- **Place line 265 = "Grand Underground"** (2026-10-26, notes/UNDERGROUND.md): the banner and met location of the
  Underground's 19 zones (data/text_overrides/underground.json; one of sinnoh_names' "Faraway place" padding lines).
  For HoennB2's copy of Sinnoh's lines: line 265 "Grand Underground" (the user passes it on).
- Still to do: the shared Pokémon Center 2F with the Union Room / Wi-Fi Club desks (needs the story scripts), and
  HoennB2's fairy.c link-battle sync (with the Fairy option).

### The shared 2F: how it can return you to your own town (found in pokebw2's C, 2026-10-18)
- A Black 2 warp whose destination warp id is 0x100 does not use its own destination: it goes to the game's saved
  "next zone" spot (EventMapChangeWarp_CreateFromEntity -> IsWarpDestId256 -> GameData_GetNextZone,
  src/ov035/event_mapchange.c, src/ov012/eventdata_system.c).
- Scripts set that spot: FieldSetNextZone zone, dir, x, y, z (command 0xDC; every argument may be a var) or
  FieldSetNextZoneHere (0xDB). The Union Room's own warp also uses it (it saves the 2F desk spot to come back to),
  so the 2F must set it again every time it loads.
- Plan: every Pokémon Center 1F stores its zone in a var (RTGetZoneID VAR) when the player goes up (a step trigger
  in front of the stairs, or the 1F's load script); the shared 2F's load script does FieldSetNextZone VAR, down,
  x, y, z (Pearl's 1F rooms share one layout, so the stairs spot is the same in every town: to check), and its
  stairs-down warp has destination id 0x100. One zone instead of 17.
- Where the two little scripts live: Black 2's Pokémon Center common script file (global 2100-2199, a/0/5/6 file
  1231 = SCRIPTS_GLOBAL_2100, src/ov012/script_sys.c table), which HoennB2 already extends with the desk scripts
  (src/field_scripts/1231_global_2100.s, commit ae80a9d): a trigger or load script in any zone can run a global id,
  so no per-town script file is needed.

## The shared Pokémon Center 2F: built and tested (2026-10-18, evening)
- `allocate_sinnoh.py` SHARED_ROOMS: Pearl's Jubilife Center 2F is installed once (Black 2 zone 567, the League lobby
  2F's matrix and furniture already there), appended after every other room (no other number moved); the other 16
  Center 2F rooms are its aliases (data/sinnoh_world.json rooms "shared").
- `sinnoh_events.py`: every 1F's stairs lead to zone 567; its stairs down are destination 0x100.
- `pearl_centers.py` (after sinnoh_events / sinnoh_story): each Center 1F gets map scripts (types 3 and 4) running
  global 2111 (`src/field_scripts/1231_global_2100.s` Script_12: RTGetZoneID PVAR_PC_TOWN = 0x40E0, a new saved work in
  data/pearl_story_ids.json); the 2F's own script file (a/0/5/6 1294) has the three counters (left and middle:
  Black 2's Union Room counter 2101, right: Black 2's Wi-Fi Club counter 10100, after flag 106) and a load script
  FieldSetNextZone PVAR_PC_TOWN, down, (2, 0, 10). 1231 is HoennB2's version (the lift replaced by a fade).
- Tested in game (DeSmuME, muted; `hwtest/fish_shot.py boot` with test_wildmon TEST_START=525,8,6 = Sandgem's 1F):
  PVAR_PC_TOWN = 525 on arrival; stairs -> zone 567; the saved spot = zone 525 (2, 10); stairs down -> Sandgem 1F.
  The middle receptionist runs Black 2's Union Room counter ("Welcome to the Pokémon Wireless Club Union Room"),
  the trainer-title talk, "DS Wireless Communications will be launched", the save, then **Black 2's Union Room**
  (zone 422, "I've entered the Union Room"); leaving it returns to the 2F desk and the way down is Sandgem again.
- Found while testing: the first version's stack compare (VMStackPush/VMStackCmp) did not branch as meant; the
  WorkCmpConst + VMJumpIf form (as pearl_story.inc) works.
- Not testable here: a trade between two machines (two emulators at once; the user's melonDS two-window test, as
  HoennB2's) and the Wi-Fi Club (online).
