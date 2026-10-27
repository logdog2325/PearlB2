# Zone header flags: battle backgrounds, bike, Escape Rope, Fly, camera, banner icon (2026-10-25)

Patch: `b2tools/patches/zone_flags.py`, in the build list right after `sinnoh_rooms` (it stops the build if it runs
before sinnoh_world or sinnoh_rooms). Offline: `python3 b2tools/patches/zone_flags.py` prints every Sinnoh place:
Pearl's values -> the header a build had before -> ours, and checks the rules below. C (decomp, branch
pearlb2-zoneflags): `src/pearlb2/battle_season_itcm.c` (new), `src/ov036/field_encount.c`, `src/system/tr_tool.c`,
`include/pearlb2.h` (below).

## The problem
Sinnoh's places reuse Black 2's zone ids (data/sinnoh_world.json zones and rooms -> b2_zone). The zone header's flags
word (u16 at 0x1E) was never set from Pearl: the 66 overworld zones kept the Unova zone's word, the 376 rooms got a
template's (sinnoh_rooms: building = Floccesy house 441, cave = Wellspring Cave 324, outdoor = Route 19 437). Seen in
game: Eterna Forest (zone 272) fought on Wellspring Cave's grey cave background. Found offline as well: 14 overworld
places sat on Unova building, gate or cave zones (Acuity Lakefront, Spring Path, Routes 213-216, 220, 222, 224, 225,
227, 228, 230, 231): no Fly there (and no bike on 10 of them), building fades on their warps, the indoor battle
background; Eterna Forest, the lakes and Floaroma Meadow had Escape Rope instead of Fly; 58 overworld places allowed
the Entralink warp.

## The flags word (decomp `src/system/zonedata.c` ZoneHeader) and where each part comes from
| Bits | Field | Ours |
|---|---|---|
| 0-4 | mapTransitionEffectType (warp fades, ov036 field_transition.c: 0 outdoors, 1 building, 2 gate, 3 cave, 4 bridge, 5 special) | by Pearl's map type, as Pearl picks its own warp fade (pokediamond asm/unk_0204C1B4.s): town/route -> 0, cave -> 3, building -> 1. Pearl's "cave" maps include Eterna Forest, the lakes, Floaroma Meadow, Sendoff Spring, the Old Chateau and the Valley Windworks / Fuego Ironworks insides; Pearl's gatehouses are buildings (1, not Black 2's gate fade) |
| 5-9 | battleBGId | Pearl's battle_bg through the table below |
| 10 | enableCycling | Pearl's bike flag |
| 11 | unk1E_11 | 1 (read by nothing; 1 in every Black 2 zone) |
| 12 | enableEscapeRope (and Dig) | Pearl's |
| 13 | enableFlyFrom (Fly, Teleport; Black 2's sun lens flare outdoors) | Pearl's |
| 14 | enableCycleSurfBGM | 1: Pearl plays its surf song while surfing on every map and its bike song wherever the bike goes |
| 15 | enableEntralinkWarp | 0: the C-Gear and its Entralink go (decision 2026-10-19, the Pokétch replaces the C-Gear) |

## Battle backgrounds
Black 2's 21 (a/1/5/1 file 0: light by time of day, seasonal, backdrop and platform by the tile's terrain; textures
looked at 2026-10-25): 0/1 grass (1 = 0 plus spring, autumn and winter variants), 2/3 city (3 seasonal), 4/5 cave (same
backdrop; Dusk Ball always 3.5x), 6 forest, 7 mountain, 8 sea, 9 indoors, 10 desert, 11 Shauntal, 12 Marshal,
13 Grimsley, 14 Caitlin, 15/17 N's Castle and Dragonspiral Tower's top, 16 Champion, 18-20 PWT / tournament /
Kyurem (set by code). The seasonal ones (1, 3, and 6-8 through their platforms) change with the season as Black 2's do.

| Pearl (4 bits, Platinum's names) | Black 2 | Places |
|---|---|---|
| 0 PLAIN | 1 grass, seasonal | 28: most routes, lakefronts, Spring Path, Pal Park, Amity Square, Valley Windworks, Flower Paradise |
| 1 WATER | 8 sea | 5: Routes 213, 220, 223, 230 (231) |
| 2 CITY | 3 city, seasonal | 17: the towns, the League outside, Fight Area, Resort Area, Battle Park |
| 3 FOREST | 6 forest | 12: Eterna Forest, Routes 215, 229, the lakes, Floaroma Meadow, Sendoff Spring, Trophy Garden, Great Marsh |
| 4 MOUNTAIN | 7 mountain | 15: Routes 205 S, 207, 208, 210 N, 211, 214, 225-228, Spear Pillar, Stark Mountain, Survival Area, drained Lake Valor |
| 5 SNOW | 1 grass, seasonal, **winter all year** (C below) | 8: Snowpoint, Routes 216-217, Acuity Lakefront, Lake Acuity (and its Galactic version), Mt. Coronet's two sides |
| 6-8 INDOORS | 9 indoors | 292 rooms: houses, the Gyms (Black 2's Gyms use 9 too), the League's rooms with the Elite Four and Cynthia |
| 9 CAVE_1 | 4 cave | 6: Oreburgh Gate and Mine, Ravaged Path |
| 10 CAVE_2 / 11 CAVE_3 | 5 cave | 59: Mt. Coronet, Victory Road, Solaceon Ruins, Iron Island, Wayward Cave, the lake caverns, ... |

**The Elite Four and Champion rooms keep Pearl's own** (indoors, like every League room in Pearl; lead 2026-10-25:
Black 2's Unova Elite Four backdrops are themed for other types). The switch is `PLACE_BG` in zone_flags.py (Pearl map
name -> Black 2 background); the file's comment has the type-matched set (Aaron 11 Shauntal's purple, Bertha 13
Grimsley's orange-brown, Flint 12 Marshal's golden glow, Lucian 14 psychic Caitlin's grey, Cynthia 16 the Champion's).

### The snowy north in winter all year (C)
Black 2 has no all-year snow background: its snow is the winter variant of the seasonal backgrounds and platforms (snow
tiles, class 0x0e/0x0f, take the seasonal grass platform). The north's maps are winter all year (sinnoh_reskin), so
without this a battle there in spring to autumn showed green grass. SaveBtlFieldStatus (ov036 field_encount.c) now asks
`PearlB2_BattleSeason(gameData)` (src/pearlb2/battle_season_itcm.c) in place of GameData_GetSeason (same size: only the
call's target): winter in the zones of `gPearlB2WinterZones` (the player's zone), else the game's season. zone_flags'
`apply_code` puts the table in ITCM: the Black 2 zones of Pearl's SNOW places, [7, 29, 37, 277, 278, 412, 434, 435]
(32 B). No table (an older decomp): the game's season. The battle's season also picks its light and the Dusk Ball's
day period: winter's there, as the north looks. With PearlB2's seasons off the north still battles in winter (its maps
are winter then too).

### Cyrus (C)
Pearl's GALACTIC_BOSS (Cyrus, trainers 403 and 404 -> Black 2 445 and 446: Galactic HQ, Spear Pillar) has Black 2's
Ghetsis class (189), and Black 2 forced background 20 (Kyurem's frozen backdrop) for that class in every zone
(tr_tool.c TR_CLASS_BATTLE_BG_OVERRIDES, read only by field_encount.c's trainer battles). Black 2's only trainer of the
class is Ghetsis at the Giant Chasm, a place PearlB2 doesn't have, so under PEARLB2 the table's one entry names class
0xffff (no class): Cyrus fights on his zone's background, as in Pearl (HQ indoors 9, Spear Pillar mountain 7). The
PWT never reads the table.

## The other header fields (lead 2026-10-25)
- Weather word bits 6-8, objectProjectionMatrixType (people sprites' projection, ov036 fieldmap.c): 1 on every outdoor
  Sinnoh place (transition 0), as Black 2's routes. 16 places change (15 overworld
  places on Unova indoor zones, Battle Park). Caves and buildings keep their template's.
- Bits 9-15, defaultCameraIndex: 0 on every overworld zone, as Black 2's routes; 5 change (Route 215 had 3, Route 216
  40 = Castelia Gym's, Routes 217-219 25 = Castelia's streets). With `MAPLOOK_FIXES=...,camera` (maplook's Pearl
  camera, set before this patch on every overworld zone alike) the camera is kept. The rooms keep theirs (sinnoh_rooms
  sized their camera boundaries with it). Both fields are read when the field loads (warp, Fly, continue).
- Icon word bits 0-12, nameIcon (the place banner's icon, place_name_letter.c, file icon + 2 of a/0/8/3; looked at
  2026-10-25): 11 Black 2's city icon for Pearl's cities, 107 its town icon for towns and the Fight/Survival/Resort
  Areas, 15 (no icon) for the League (as Black 2's), the routes, the other places, caves and buildings. Black 2's
  route shields are numbered 1-23 (icons 23 + 4n), none fits Routes 201-230 (Route 201 showed Route 2's "2"). 32 change.
- Bits 13-15, the Easy / Challenge Mode level adjust (btl_setup.c adjustPkmLvForChallengeKeys; Challenge raises, Easy
  lowers trainers' levels by it): kept, Unova's per zone. Now, overworld places: 1: 10 (Twinleaf, Routes 210 N, 211 W, 220, 223,
  226, Pokémon League, Newmoon Island, Fight Area, Verity Lakefront); 2: 9 (Oreburgh, Routes 203, 208, 216-219, 221,
  228); 3: 10 (Eterna, Hearthome, Eterna Forest outside, Fuego Ironworks outside, Routes 204 S, 222, 224, 225, 227,
  231); 4: 19 (Sandgem, Floaroma, Solaceon, Celestic, Veilstone, Sunyshore, Snowpoint, Routes 205 S/N, 206, 207,
  211 E, 212 N/S, 229, 230, Stark Mountain, Iron Island, Valor Lakefront); 5: 18 (Jubilife, Canalave, Pastoria,
  Routes 201, 202, 204 N, 209, 210 S, 213-215, Valley Windworks, Fullmoon Island, Flower Paradise, Acuity Lakefront,
  Spring Path, Survival Area, Resort Area). Rooms take their template's: 1 (289 rooms, the Floccesy house's) or 5
  (87, Wellspring Cave's and Route 19's). Only matters with the Challenge/Easy keys.
- Place banners: see "Place banners" below (2026-10-26: shown wherever Pearl shows its sign).

Counted (offline, 442 places): 160 headers change; per field: transition 16, background 142, cycling 34, Escape
Rope 35, Fly 29, Entralink 58, projection 16, camera 5, icon 32 (bike/surf music and unk1E_11 were already 1).

## Checked
- Offline: the table above; every Sinnoh zone has Pearl data; no Black 2 zone holds two Sinnoh places; cycling, Escape
  Rope and Fly equal Pearl's; transition 3 exactly on Pearl's caves; no background id >= 21 or set-by-code; one camera
  for all overworld zones; weather and level adjust untouched. A run on a copy of the base files changes only the 442
  Sinnoh zones' flags, weather and icon words (no other zone, no other field); a second run changes nothing.
  apply_code on a copy of the decomp's ITCM: the table reads back as above.
- C: clang syntax check of the changed files with the decomp's flags; the mwcc build, `decomp.py changed` and the
  layout check run in the agent's decomp tree with the test build.
- C in the decomp (2026-10-25, tree pearlb2-zoneflags on 8b751aa5cd): layout check kept (48,572 symbols);
  `decomp.py changed` lists, of ours, only SaveBtlFieldStatus (3 bytes: the call) and TR_CLASS_BATTLE_BG_OVERRIDES
  (2 bytes: class 189 -> 0xffff), besides the ITCM. In the game's RAM: gPearlB2WinterZones points at the 8 zones.
- In game (DeSmuME, test build 2026-10-25, October = summer, Lv 100 team; shots in work/agents/zoneflags/shots/):
  Oreburgh Gate 1F wild Zubat: cave background 4; Route 203 wild Starly and Lass Madeline: grass 1, summer (green);
  Oreburgh Gym Youngster Jonathon: indoors 9; Eterna Forest wild Buneary: forest 6; Acuity Lakefront wild Sneasel
  in October: the snowy winter variant of grass 1 (PearlB2_BattleSeason). The Bicycle from the Bag works on Route
  203, stays on through Oreburgh Gate (Pearl lets you ride in the cave) into Oreburgh, the player gets off entering
  Oreburgh Gym, and the Bag's Bicycle there is refused. Cyrus's background: offline only (his battles are Chapter 7's).

## Place banners (2026-10-26)
Before: **no Sinnoh place banner ever showed.** The banner's PlaceName_LoadMessage (decomp src/ov036/field_place_name.c)
cancels a place-name line of 154 or more, and sinnoh_names puts Sinnoh's names on lines 154-264 (the met-location
bound was lifted in 2026-10-18, the banner's was not). And every room had the "no banner" style.

Pearl (pokediamond ov05_021E331C, called by the warp-in code; pokeplatinum FieldTask_StartMapAndFadeIn ->
FieldSystem_RequestLocationName): its sign shows on **every arrival through a warp anywhere but in a building**
(map types 4/5), even with the same name (out of a building into its town, between a cave's floors), and on walking
into another map section (a mapsec change). Black 2 shows its banner on a zone change only if the zone's display
type allows it (header place_display: 0 never, 1 always, 2 only on Continue, 3 not on Continue) and the place name
changed.

Now:
| Where | What |
|---|---|
| decomp field_place_name.c PlaceName_LoadMessage | `nameId >= 0x9a` -> `nameId >> 9`: lines 0-511 show (the file is padded to 512) |
| decomp entrance_camera.c EventWarpSequenceIn_ShowPlaceName | PlaceName_OnZoneChange -> PlaceName_ShowForZone: a warp's arrival shows the banner whenever the zone's display type allows it, as Pearl's sign (same size: the call's target) |
| decomp place_name_letter.c (the season frame's slide-in) | the season word and its frame stay hidden (the user, DECISIONS 2026-10-18: no season word) |
| sinnoh_names.py | rooms: Pearl buildings (map types 4/5, 284 rooms) keep Floccesy house's style (0); every other room (100: caves, the lakes, Eterna Forest, Mt. Coronet's sides, Spear Pillar, the Great Marsh, Amity Square, Trophy Garden, Pal Park, Battle Park, Old Chateau, the Windworks and Ironworks insides, Snowpoint Temple, ...) Wellspring Cave's (1). Overworld zones as before (1) |
Walking between zones keeps Black 2's rule (a banner when the place name changes), as Pearl. The banner's icon is
zone_flags' (city, town, none). Black 2's own kept zones (PWT, Musical, ...) also show their banner on every warp
arrival now if their display type allows it.

In game (DeSmuME, test builds 2026-10-26; work/agents/banners/shots/): Oreburgh Gate 1F -> Route 203 "Route 203",
Route 203 -> the gate "Oreburgh Gate", the gate -> "Oreburgh City" (city icon), into a house: none, out of it:
"Oreburgh City"; Route 201 -> Sandgem walking: "Sandgem Town" (town icon), no season word; the Fight Area's
Pokémon Center -> "Fight Area"; into the Battle Park gatehouse: none; the gatehouse -> "Battle Park" (same place
name: only Pearl's arrival rule shows it).

## Position triggers (2026-10-26)
Pearl runs a position (step) trigger only when the player steps onto its tile. Black 2 checks its any-direction
triggers (type 0: every Pearl trigger) on each finished MOVE of the player (fieldmap_event.c
FieldEventProvider_Grid_CheckForEvent -> CheckNoneDirTriggerScrEvent), so a move that ends on the tile it began can
run the same trigger again (Chapter 8 saw it at a wall). Decomp src/pearlb2/step_trigger_itcm.c (same-size calls in
fieldmap_event.c): the field's check keeps the tile the player stands still on (PearlB2_UpdatePlayerObserver in place
of FieldPlayer_UpdateActionStatusObserver) and a step's trigger check on that same tile finds nothing
(PearlB2_GetStepTriggerSCRID in place of GetTriggerSCRIDAtPosGrid, direction PLAYER_DIR_NONE only; turning and
direction triggers are Black 2's). A script that moves the player off a trigger leaves them standing still, so
stepping on again runs it. Not touched: warps, warp mats, ledges and slides (each lands on another tile), the
Pastoria and Snowpoint gimmicks (their own step hooks).
In game (test build 1): Oreburgh Gate 1F's hiker trigger (7, 22), re-armed in RAM (work 0x4064 = 1) with the player
on it: four wall bumps (down x 3, up) run nothing; a step off and back on runs it again ("Oh, lookie there!", the
work back to 2). With the check made Black 2's in RAM (the hook's `cmp r3, #9` -> `#0xff`), the same wall bumps ran
nothing either: a plain wall bump is a "brake" (move status NONE, field_player_grid.c), not a MOVE, so Chapter 8's
re-run came another way (not reproduced here; its spot is to retest). The hook stops any step check on the tile the
player has not left, whatever made it.

