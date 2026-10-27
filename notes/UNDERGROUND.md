# The Grand Underground (2026-10-26)

The user's decisions (DECISIONS 2026-10-19, three rows) and the lead's answers of 2026-10-26: a Grand
Underground-style version, open from the Explorer Kit (Eterna's Underground Man). Pearl's Underground tunnels; 18
Hideaways with random wild battles from **BDSP's Shining Pearl Hideaway tables** (BDSP's stages; what BDSP holds back
until the National Pokédex opens on **becoming Champion**, which is now also when Oak upgrades the Pokédex); Black 2's Hidden Grottos in the Hideaways (the Hoenn,
Kanto and Johto starters, BDSP's rare spawns, Pearl's Underground treasures); one place name "Grand Underground"; the
Underground Man trimmed to his first mission; Spiritomb by Hideaway battles; daily Mysterious Shards and Kanto /
Hoenn fossils from Champion. Not built: digging, Secret Bases,
traps, multiplayer. **Part 2** (after part 1 is tested): BDSP's visible wandering Pokémon, section 10.

**Status**: part 1 written and checked offline (`python3 b2tools/underground_check.py`: all pass; the C compiles
with the game's compiler and the three hooks keep their files' sizes). Not built yet: it needs the zone-table merge
(zones from 616, `zoneheaders.extend`, allocate's APPENDED) and the lead's "build ok". Files: section 9.

## 1. Pearl's Underground (pokediamond / pokeplatinum)
- Zone 2 (MAP_UNDERGROUND), matrix 2: 15 x 15 cells of 16 chunks (561-576). Row 0-1 and column 0 are chunk 561 (the
  Secret Base slots); 14 x 13 cells reuse 15 tunnel chunks: 5-tile tunnels, mountain floor (no encounters). Area 2,
  texture set 2, constant indoor light; header: SEQ_TANKOU, no bike / Escape Rope / Fly, battle background 3.
  Collision: work/agents/underground/plan/ug_collision.png.
- **Six networks that do not meet** (underground_check: 28,840 / 12,740 / 12,740 / 6,240 / 6,240 / 1,180 tiles):
  the player reaches the one under where they went down (south-west: Twinleaf to Canalave and Oreburgh; centre:
  Eterna to Pastoria; Celestic; south-east: Sunyshore, Routes 212-213, 222; the Battle Zone; Fullmoon / Newmoon).
  Every network has Hideaways (5, 5, 2, 2, 3, 1).
- People: 21 Sphere / trap / goods traders and Secret Base helpers: left out (nothing to trade).
- Going down: only on the overworld matrix, not surfing (Pearl: also not on a bridge, the Cycling Road or an
  object's tile, and a save first: no wireless here, so no save question). The arrival tile:
  `cell = (x/32 - 1, z/32 - 6); tunnel cell = (cell/2 + (1, 3)); tile 8 or 23 in it` (two by two overworld cells
  onto one tunnel cell). Checked: Pearl's 58,920 walkable overworld tiles land on 170 tiles, all tunnel floor.
- Going up: Pearl's "Would you like to return to the surface from where you entered?" (bank 575 line 52), back to
  the exact spot where the player went down.
- FLAG_ENTERED_UNDERGROUND (PFLAG_096E = 835) is set on going down: the Underground Man's first mission.

## 2. BDSP's Hideaways (sources: public lists; opendpr's UgPokeLottery.cs read for the rules)
- 18 types: 11 Caves (5-7 Pokémon a visit), 7 Caverns (7-10). Water spawns (Serebii's "Max Water Spawns"):
  Fountainspring 4, Swampy 4, Icy 4, Riverbank 4, Still-Water 6, Glacial 5, Bogsunk 5; none in the others.
- Stages (opendpr GetStoryNo; the highest whose condition holds): 1 start, 2 Strength, 3 Defog, 4 Icicle Badge,
  5 Waterfall, 6 National Pokédex (here: Champion). Levels by badges: 0-1 16-20, 2 25-29, 3 29-33, 4 33-37, 5 36-40,
  6 39-43, 7 42-46, 8 50-55, Champion 58-63.
- A visit's spawns: a type by the Hideaway's type weights, then a species by its per-stage weight. **Those weights are
  not public** (Serebii's % is blank, Bulbapedia says "Varies"; BDSP's UgRandMark / UgPokemonData): equal weights
  here, a weight per entry kept for a dump of the user's own BDSP.
- Rare spawns: on half the visits one spawn is the Hideaway's rare one, by weights per version (UgSpecialPokemon;
  Kaphotics' raw table, pastebin KL36BBgZ). Here each battle is rare with 50 % / the average spawns per visit (1 in
  12 in a Cave, 1 in 17 in a Cavern).
- Sources (data/underground_sources/, copied as data, checksums checked against the pages): Serebii's Grand
  Underground page, both versions (the main source, user 2026-10-26); Bulbapedia's 18 Hideaway pages (read in the
  app's browser: it refuses the fetch tool); Kaphotics' table; Serebii's spawn counts. They agree except: Serebii
  has three more National-Dex species in Spacious Cave (Rhydon, Magnemite, Swablu: kept); Serebii's rare % has two
  typos (Stargleam's Duskull 5 for 25, Icy's Glalie 10 for 15: Kaphotics' raw weights used).
- Both versions are kept (data `version`: "sp"; a Diamond version switches it).

## 3. Zones, ids, files (the lead's allocation)
- Zones **633** (the tunnels: Pearl's zone 2 through allocate_sinnoh APPENDED, with the area's models overridden to
  the four hole models 429-432: Pearl's area-2 list has 138, over the 128 limit) and **634-651** (the Hideaways).
- Script file **1900**, text file **1300**, shared by all 19 zones (Pal Park has 1901 / 1301).
- Place line **265** of system text 109: "Grand Underground" for all 19 zones (banner and met location;
  notes/LINK.md, data/text_overrides/underground.json).
- Saved works (data/pearl_story_ids.json "new"): PVAR_UG_RETURN_ZONE / X / Y / Z (where the player went down),
  PVAR_UG_HIDEAWAY_BATTLES (the Spiritomb counter). Flags: PFLAG_UG_ITEM_00..37 (1355-1392,
  Black 2's item-ball flags after Pearl's; 37 used, 1 spare), PFLAG_UG_SHARD_0..3 and PFLAG_UG_FOSSIL_0..1 (2763-2768,
  cleared at midnight). **The numbers move**: Chapter 9a took 0x40EF from the same registry run and merges first;
  after the zone merge this tree is re-based onto main and pearl_ids rerun. The C reads every id from its table
  (ug_data from the registry, by name) and the scripts use pearl.h's names: no number is written anywhere else.
  The "go up?" answer: map-local work 0x4010 (no Pearl script runs in these zones).
- Black 2's Hidden Grottos 0-17 (their Unova entrances are gone with Unova's maps; the save keeps their state, no
  layout change); zone 518 (the grotto) stays Black 2's.
- Area records the allocator must not hand out: 293 (Chargestone, kept zones use it) and 388 (Reversal Mountain's
  inner rooms; the lead reserves it with the zone merge). Bogsunk is not on the Moor of Icirrus (it reads as
  outdoors), so 198-201 are not needed.

## 4. The map
- **Tunnels** (zone 633): Pearl's matrix 2 converted by sinnoh_rooms (Pearl's model, collision, heights, light),
  SEQ_TANKOU (Unova choice: SEQ_BGM_D_02, data/unova_music.json), no wild Pokémon, no bike / Escape Rope / Fly.
- **Holes**: Pearl's Secret Base hole model 430 (ug_hole_f, a hole in a north wall: plan/holes_sheet.png) on a wall
  tile over a tunnel, in a copy of that cell's chunk (the tunnel chunks are shared by many cells); a bump warp walking
  up into it; the Hideaway's name as a sign on the same tile.
- **Hideaways** (zones 634-651) reuse an installed room's matrix and chunks with their own zone, header and events
  (no new map data): Pearl's rooms as built, Black 2's own rooms as in the dump. The room's warps keep their indices:
  its 'exits' lead to the hole, the others go off the map. Header: the room's (camera, light, area, flags without
  bike / Escape Rope / Fly / Entralink), the tunnels' music and place, a Pearl encounter table for the rate (the C
  picks the species; one with Surf slots where BDSP has water spawns).

| Hideaway | room | hole (tunnel tile, under) | balls |
|---|---|---|---|
| Spacious Cave | Mt. Coronet South 1F | (96, 372) Jubilife | Rare Candy x2, PP Max, Shiny Stone |
| Grassland Cave | Sendoff Spring | (144, 325) Valley Windworks | TM111 Silver Wind (BDSP's TM62 Bug Buzz) |
| Fountainspring Cave | Oreburgh Gate B1F | (224, 325) Hearthome | TM12 Taunt, Deep Sea Tooth |
| Rocky Cave | Oreburgh Mine B1F | (159, 372) Oreburgh | Nugget, PP Up, TM37, TM04, TM39; Shard S |
| Volcanic Cave | Stark Mountain inside 1 | (447, 116) Stark Mountain | TM55 Scald |
| Swampy Cave | Ravaged Path | (336, 453) Route 213 | TM96 Focus Punch, TM06 Toxic |
| Dazzling Cave | **Unova: Chargestone Cave (matrix 24)** | (279, 229) Mt. Coronet | TM45 Attract, Twisted Spoon; Shard S |
| Whiteout Cave | Snowpoint Temple 1F | (80, 84) Fullmoon / Newmoon | Dawn Stone, Sharp Beak |
| Icy Cave | Snowpoint Temple B2F | (160, 148) Route 217 | Lucky Egg, Deep Sea Scale |
| Riverbank Cave | Mt. Coronet 4F room 1 | (122, 340) Floaroma | Big Mushroom |
| Sandsear Cave | Oreburgh Mine B2F | (389, 197) Route 228 | Charcoal, Dragon Fang |
| Still-Water Cavern | Mt. Coronet B1F | (376, 372) Lake Valor | TM98 Bullet Seed, Big Mushroom |
| Sunlit Cavern | Eterna Forest | (64, 421) Route 201 | TM81 X-Scissor, PP Up |
| Big Bluff Cavern | Victory Road 1F | (320, 308) Route 215 | TM101 Shock Wave; Shard S |
| Stargleam Cavern | **Unova: Chargestone Cave (matrix 23)** | (248, 261) Celestic | TM109 Dragon Pulse, Nugget; Shard L |
| Glacial Cavern | Snowpoint Temple B4F | (192, 116) Snowpoint | Leftovers, TM80 Rock Slide |
| Bogsunk Cavern | Victory Road 1F back room 2 | (432, 436) Sunyshore | TM99 Giga Drain, Dusk Stone |
| Typhlo Cavern | **Unova: Reversal Mountain (matrix 328)** | (415, 165) Route 229 | TM50 Overheat, TM71 Stone Edge |

  Renders for the choice: work/agents/underground/plan/rooms/ (sheet1-3, sheet_multi: Pearl; sheet_b2: Unova).
  Reachable on foot from the exit (underground_check): 95 (Whiteout) to 1,605 tiles (Sunlit). The Unova rooms'
  in-game shots go to the lead after the build.

## 5. Going down and up (C, decomp branch)
- The Bag: the Explorer Kit (item 428) gets the Xtransceiver's field-use id and "important" (Black 2's could be
  tossed). ov142 itemmenu.c: `{ITEM_XTRANSCEIVER_MALE, 1, ItemMenu_UseXtransceiver}` becomes `{ITEM_EXPLORER_KIT,
  ...}` and that handler's result 21 becomes 13. The new game's Bag still holds Black 2's Xtransceiver: its Use
  now answers "It won't have any effect." (seen in game).
- ov012 itemuse_event.c: the field's common event 1 (the Entralink's; the C-Gear goes) is
  `PearlB2_UndergroundEvent_Create`; the action check 10 (the Xtransceiver's) is `PearlB2_UndergroundCheck` (allowed
  in the Underground, and on the overworld matrix not surfing or diving; else the Bag's "can't use" line).
- `src/pearlb2/underground_itcm.c`:
  - down: the spot (zone, x, y, z) into PVAR_UG_RETURN_*, FLAG_ENTERED_UNDERGROUND set, Black 2's Dig map change to
    Pearl's arrival tile (the escape-rope spot holds the destination while the event is made, then is restored);
  - up (in zones 633-651): the zones' script 1 asks Pearl's question; yes = Black 2's Escape Rope map change to the
    saved spot. Saving and continuing underground works (the works are saved); a black-out goes to the last Center.
- Chargestone Cave's electric floor (Dazzling Cave, Stargleam Cavern): ov012 field_actor_tool.c
  ActorTerrainEffect_ElectricField calls `PearlB2_ElectricSpark` (same size) in place of the sparks' maker, and it
  makes them only where their field effect (10) is loaded, which only Chargestone's gimmick 13 does. The Hideaways'
  zones have no gimmick (no pushable stones, no floor sparks): before this, the first step on an electric tile made a
  spark of no effect and the game jumped into VRAM (found in the test, 2026-10-26).
- patches/exp_share.py merges the Xtransceivers' two Use entries; where entry 8 is already the Kit's it keeps it.

## 6. The Hideaways' Pokémon (C)
- ov036 field_encount.c, EventWildBattleCall_CreateRandom: `FieldEncount_GenWilds` -> `PearlB2_GenWilds` (same
  size). In zones 634-651, for grass/cave-floor and Surf battles: the stage (data "unlock": HM04, TM119 Defog, badge
  6, HM05, the game-clear flag 2400), the level row (badges; Champion: the last), a rare spawn with the Hideaway's
  rare share and weights (land only), else an entry whose stage has come, by weight, on land or on water (none on
  water: no battle). The pick fills every slot of a copy of the zone's table and Black 2's FieldEncount_GenWilds makes
  the Pokémon (Repel, Pressure, Synchronize, items, Shiny Charm). Shellos / Gastrodon: East Sea form in eastern
  Hideaways. Each battle counts in PVAR_UG_HIDEAWAY_BATTLES. Fishing (pearl_rods) is untouched.
- The table (gPearlB2Underground, ug_data.table_blob): 72-byte header, 18 Hideaways x 12, 11 distinct lists of
  4-byte entries (species, stage | where << 4, weight), rares (species, weight): **2,320 B of ITCM**; the code
  about 1.5 KB (mwcc, -O4).
- Land / water: in a Hideaway with BDSP water spawns, its Water types are met surfing too, and the swimmers
  (Tentacool, Octillery, Mantyke, Shellder, Horsea, Staryu, Chinchou, Lanturn, Qwilfish, Corsola, Carvanha, Clamperl,
  Barboach, Whiscash, Seel, Dewgong, Dratini, Tentacruel) only surfing; elsewhere everyone on land.
- Odds: `underground_check.py --odds rockycave` (Rocky Cave, stage 1: Geodude, Onix, Skorupi 30.6 % each, Rhyhorn
  5.8 %, Teddiursa 2.5 %; at Champion 26 species at 3.4 %, Rhyhorn 9.2 %).

## 7. Hidden Grottos
- Black 2's (pokebw2 scrcmd_hidden_hollow.c): 20 grottos, each refilled with 5 % per 256 steps when empty; a file in
  a/2/7/3 per grotto; global script 10795 + n is grotto n's "narrow path" sign; leaving returns to
  HIDDEN_HOLLOW_ENTRANCES[n] (ov012). Grotto Pokémon have their Hidden Ability. Black 2's field sprites cover every
  Pokémon 1-493 (a/2/0/8, a/0/4/8: shots/b2_poke_ow_starters.png).
- Here: grottos 0-17, one per Hideaway, the narrow path on a wall nook (read facing north), HIDDEN_HOLLOW_ENTRANCES
  0-17 -> the tile below it (Black 2's bytes asserted). Pokémon (levels 25-29): the 15 % slot the past-generation
  starters of its theme (grass: Grassland, Sunlit; fire: Volcanic, Sandsear, Typhlo; water: Fountainspring,
  Riverbank, Still-Water, Swampy with Bulbasaur) or its rare spawns; 4 % and 1 % its rare spawns. Not held back to
  Champion (decision 2026-10-19: grotto starters from the Kit on; to confirm with the user). Items: Pearl's
  Underground treasures, which have no other source here without digging: the 16 plates (1 %), the Armor Fossil
  (Pearl's) and evolution stones (4 %), the four shards (10 %), Heart Scales (25 %); B: a slot kept for the Discovery
  Slates (Heart Scale until Ramanas Park's ids), Star Pieces, Rare Bones, the weather rocks, Heart Scales.
- The Kanto and Hoenn fossils (Pearl digs them up after the National Dex; here the National Pokédex comes at Champion,
  user 2026-10-26): two daily balls from Champion, in the two Oreburgh Mine rooms (Rocky Cave (13, 10), Sandsear Cave
  (23, 16)), each a Root, Claw, Helix, Dome Fossil or Old Amber at random when picked up (the lead 2026-10-26; flags
  PFLAG_UG_FOSSIL_0..1, the daily range).

## 8. The Underground Man (Chapter 3's zone, generated)
data/pearl_script_patches.json (a new generator table: single Pearl commands changed or dropped) and
data/pearl_text_edits.json: the first mission (go down) completes with Pearl's line 6 without "Take these as
rewards!", no traps given; from then on his line 29 ("So, my spelunker, are you going underground..."). Regenerated:
chapter 3 changes only his file; chapters 1, 2, 90 unchanged.
Pearl's mission flags 0x96E-0x973 (entered, dug for fossils, Sphere, Secret Base made, decorated, Flag delivered;
only his script reads them, only Pearl's Underground code set them): 0x96E (PFLAG_096E, 835) is the first trip down's
flag, set by the C (enteredFlag; seen set in game after the Kit's first use), which ends mission 1. 0x96F-0x973 are
read only in missions 2-6 (var 0x40B6 = 2-8), which nothing reaches any more (0x40B6 = 1 goes to line 29 for good,
and only mission 2's block set it to 2), so no script waits on them; they stay unused.

## 9. Files
data/underground.json (layout), data/underground_pokemon.json (written by b2tools/underground_lists.py from
data/underground_sources/), b2tools/ug_data.py, b2tools/underground_lists.py, b2tools/underground_scripts.py (writes
src/field_scripts/1900_underground.s, src/text/script/1300_underground.txt), b2tools/underground_check.py,
b2tools/patches/underground.py (build list: after sinnoh_story), data/text_overrides/underground.json,
data/pearl_script_patches.json, data/pearl_text_edits.json (97:6), b2tools/pearl_story.py (script_patches),
b2tools/pearl_ids.py (+ registry, src/include/pearl.h), the Underground Man's regenerated files.
Decomp (branch pearlb2): src/pearlb2/underground_itcm.c, include/pearlb2.h (prototypes), the same-size calls in
field_encount.c, itemuse_event.c, itemmenu.c, field_actor_tool.c; part 2: src/pearlb2/resident/hideaway.c,
include/pearlb2/underground.h (the table's layout and the shared picks), gimmick_itcm.c's row 63.
allocate_sinnoh.py APPEND_BLOCKS 'Underground': 633-651, APPENDED {'MAP_UNDERGROUND': 633}, the area-2 models.

## 10. Part 2: visible wandering Pokémon (BDSP's), coded 2026-10-26, not built yet
The user (2026-10-26): Pokémon that walk around in the Hideaways, touched = a battle, BDSP's spawn counts, a new set
on re-entry. Data switch: data/underground.json "visible" (false = part 1's random battles).
- **Gimmick 63** (decomp src/pearlb2/resident/hideaway.c, a row of src/pearlb2/gimmick_itcm.c's table; pearlb2.h
  PEARLB2_GIMMICK_HIDEAWAY): patches/underground.py gives zones 634-651 gimmick 63 in a/1/0/2 (rows appended, as the
  gyms' patches do). No Black 2 function changes (decomp.py changed: ITCM only): the gimmick dispatcher's step check
  (the event check's Mistralton-Gym slot, every frame) starts the battles, so the planned contact hook isn't needed.
- **A visit** (the gimmick's init, when the field opens in a Hideaway with none of its Pokémon there): BDSP's land
  count (the Hideaway's minimum or maximum, even odds) and its water maximum (pearlb2/underground.h UG_SPAWNS_*,
  4 bits each in the Hideaway record's spare u16), on half the visits the first one a rare spawn (PearlB2Ug_PickRare),
  the others PearlB2Ug_PickEntry (part 1's stage and weights), the level in the part 1 range. Tiles: a breadth-first
  walk from the player over the map's collision (FieldG3DMapper_GetTerrain; on foot, water by Surf), so every
  Pokémon is reachable from the entrance; random reached tiles at least 3 apart and from the player, not on an item
  ball. The map is loaded at once first (FieldG3DMapper_UpdateSync, as the map load does next). Big rooms
  (Sunlit, Big Bluff, Stargleam, Dazzling, Typhlo, Bogsunk) only have their loaded chunks: the Pokémon are around the
  entrance's part.
- **Actors**: uids 0xB0-0xBF, Black 2's walking-Pokémon sheets (ARCID_TPOKE: GetPokemonFieldOBJCODE, every species
  1-493), land: move code 3 (wander in a 2-tile area), water: move code 2 (looks around). Species | form << 11 and
  the level in the actor's user parameters 0 and 1, so a battle, a menu or a save keeps the set (Black 2 keeps
  actors in GameData and in the save); leaving the zone deletes them: the next visit is a new set.
- **Battle**: walking into one, A in front of one, or one on the next tile facing the player (the player on a tile,
  heights within one step): Black 2's static wild battle (EventWildBattleCall_CreateStatic: catchable, flee allowed)
  and the random battle's ending (EventWildBattleCall_Callback's: the field's entrance transition, or the black-out).
  Its user parameter 2 marks it: at the next field open it is hidden, without collision, still (the visit's marker
  until the zone is left). Each battle counts on the Spiritomb counter. Random battles are off where gimmick 63 is
  (PearlB2_GenWilds).
- **Cost**: in PearlB2's resident section (decomp src/pearlb2/resident/hideaway.c: 1,876 B code, 11 B data); ITCM
  +128 B (underground_itcm.c's picks shared through include/pearlb2/underground.h, the gimmick row); no new table
  data (the counts sit in the Hideaway records' spare u16). Field heap at a new visit: the walk's tile list and bitmap
  (2 B + 1 bit a map tile: 19 KB for Sunlit's 96 x 96) and the TPOKE table, freed at once.
- Offline (underground_check 5): the gimmick id agrees with the decomp's; spawns (5-7 / 7-10 land, 0-6 water).
  Rooms without reachable water: Icy and Glacial (Snowpoint Temple, no water), Riverbank (its lake is a level below
  the exit): their water Pokémon don't appear (each is in other Hideaways too).
- Renders of all 18 as built (work/agents/underground2/renders/: exits, balls, the narrow path, the reached tiles).
- Test (after "build ok"): spawns in Stargleam (Unova) and Rocky Cave (Pearl), a bump battle, a Pokémon walking
  into the player, a catch, re-entry (a new set), save / Continue (the same set); every frame looked at.

## 11. Open / to tell
- Chapter 9b: Pearl's GetSpiritombTalkCounter / ResetSpiritombTalkCounter (Route 209's Hallowed Tower) read and
  clear PVAR_UG_HIDEAWAY_BATTLES (notes/STORY_HANDOFFS.md).
- Ramanas Park: the Mysterious Shards are items 129 / 130 for now (data "shard_items": change there); Discovery
  Slates for the grottos' kept slot when their ids exist.
- HoennB2's link registry: place line 265 (notes/LINK.md).
- Not checked offline: the in-game look of the holes and Unova rooms, the Dig / Escape Rope transitions, the grotto
  return height in cave rooms (HIDDEN_HOLLOW_ENTRANCES y: Black 2 stands the player on the ground there?).

## 12. Test (part 1, played 2026-10-26; the lead's essentials list)
Builds into work/agents/underground/rom (decomp pearlb2-underground, ff1c427d86 + this C); the Lv 100 test team;
shots in work/agents/underground/shots/part1/. Starting points are overworld tiles (test_story_start needs a
translated zone), so each run goes down with the Kit first.
- Build 1 (pre-Champion, 2 badges; TEST_START=355,459,528 Celestic, TEST_LINES `HiddenHollowSet 14, 2, 0, 1`):
  Bag -> Key Items -> Explorer Kit -> USE: Dig's dust, white fade, tunnels at (247, 264) as underground_check gives;
  flag 835 (Pearl's 0x96E) set, return works 355 / 459 / 80 / 528. The hole's sign reads "Stargleam Cavern"; up into
  the hole -> Stargleam Cavern (Chargestone room) at its exit. Battles: Gastly, Misdreavus (stage 1), Houndoom (a rare),
  Lv 25-29; the battle counter counts (6). No shard ball before Champion. TM109 Dragon Pulse from its ball (Pearl's
  item-ball lines). The narrow path (51, 50) -> the grotto: Houndoom with Unnerve (its Hidden Ability), out again to
  (51, 51). Saved there; Continue (a cold boot with that save) opens in Stargleam at (51, 51) with the works kept.
  Kit -> "Would you like to return to the surface from where you entered?" -> YES: Escape Rope's exit, Celestic
  (459, 528). The Xtransceiver's Use: "It won't have any effect."
- Found and fixed in it: the first step on Chargestone's electric floor crashed (section 5, PearlB2_ElectricSpark);
  patches/exp_share.py's Use-table edit failed on the Kit's entry (section 5).
- Build 2 (quick, on build 1's files; TEST_SET=PFLAG_0964, 8 badges; TEST_START=62,278,752 Oreburgh): down to (151,
  375), the Rocky Cave hole -> Oreburgh Mine B1F room: 7 balls (5 items, the Shard S ball, the fossil ball: the
  Champion gate). Battles: Beldum Lv 63 and 60, Cacnea, Furret, Numel, Beldum, Bronzor (the National Dex stage 6), Lv
  58-63.
- Frames looked at (the way down and up frame by frame, the rooms, the grotto, the battles): no graphical errors seen.
  Stargleam's exit sits at its map's south edge, so the screen below it is dark there.
- Not played (offline checks only): the other 16 Hideaways and Dazzling / Typhlo's looks, water battles, the
  grotto's level, a black-out underground.
