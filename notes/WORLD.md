# Sinnoh's world in Black 2 (started 2026-10-18)

User's choice: **Pearl's map shapes and buildings, re-skinned with Black 2's textures**; seasons with the snowy north
fixed winter (DECISIONS.md). Black 2's map formats: HoennB2 `notes/GEN5_MAPS.md` (the reference used here).

## First light (2026-10-18): Black 2 draws Pearl's map models as they are
- Test patch `b2tools/patches/test_firstlight.py` (test only): Pearl's Twinleaf model (land_data 0) in Aspertia's two
  chunks (a/0/0/8 279, 280) with Black 2's collision kept and no buildings; the 14 Pearl textures it names (Pearl
  texture set 6) merged into Aspertia's four seasonal sets (a/0/1/4 210-213, `nsbtx.merge`).
- `b2tools/hwtest/intro_shot.py ROM OUT 427` runs a new game (A presses, START on the name keyboard; zone 427 after
  ~293 presses) and screenshots the field: **the model draws correctly with its textures** (grass, sand path, trees,
  the fenced pond; `work/firstlight/field_1.png`). Gen 4 BMD0 map models need no conversion.
- Both games bind map textures by name from the area's texture set (no textures inside the chunk models), so the
  re-skin is a texture-name mapping (material -> Black 2 texture), plus the material's texture size where the Black 2
  texture differs.

## Converter plan (Pearl chunk -> Black 2 `WB` chunk)
1. **Model**: Pearl's NSBMD; materials renamed to Black 2 textures by a mapping table (189 distinct textures in the
   175 overworld chunks: `work/pearl/overworld_textures.json`), sizes adjusted. Season sets: each Black 2 texture's
   spring/summer/autumn/winter version.
2. **Collision and tile types**: Pearl's tile attributes (collision bit, behaviour byte) -> Black 2 terrain cells
   (class, flags); behaviour table from pokediamond first.
3. **Heights**: Pearl's BDHC layout is unknown (DATA.md); take them from the model's own triangles (ray down at each
   tile), then the nearest plane in Black 2's global slope/height tables (HoennB2 TERRAIN_HEIGHTS.md).
4. **Buildings**: Pearl's placed props -> Black 2 placements; Pearl's building models into Black 2 building packs
   (≤ 128 per pack: Pearl's list 2 has 138, split it), re-skinned like the terrain.
5. **Matrix, zones, events**: Pearl's matrix 0 -> a Black 2 matrix; zone headers (area, music, encounters, fly
   points); warps, NPCs, signs, triggers from `work/pearl/events` (scripts come with the story phase).

## Converter status (`b2tools/pearl_chunk.py`, 2026-10-18)
- Model: Pearl's BMD0 unchanged. Tile types: 84 Pearl behaviours, the common ones mapped to Black 2 classes with
  Black 2's own flags (table `BEHAVIOURS`); the rest (berry patches, bike bridges/slopes/ramps, Rock Climb walls,
  warp tiles, slides, one-way blocks) are floor or wall by Pearl's collision for now.
- Heights: from the model's triangles (and the 8 neighbours' models, which overhang), matched to Black 2's slope and
  offset tables. Twinleaf: every tile exact.
- **All 175 overworld chunks: 164 clean.** Open: chunk 114 (Pokémon League, 55 tiles: slopes not in Black 2's table),
  chunks 21/24 (1 tile each), and walkable tiles with no ground in the terrain model in chunks 25, 74, 114, 139-141,
  155, 157, 158 (Valor Lakefront, Routes 228-230, the League: probably ground drawn by placed props, step 4).

## Buildings (`b2tools/pearl_buildings.py`, 2026-10-18)
Pearl's building models carry their own TEX0; Black 2's are MDL0-only with textures from the pack's texture set. So:
strip the TEX0 (`mdl_only`), merge every model's textures into one BTX0 (`build_pack`), info records from Black 2's
plain-building template (pack 52 resId 0x15), placements with z negated and the resId big-endian. Doors are their own
Pearl props (Twinleaf: model 67), placed like the houses; since 2026-10-20 they open with Pearl's own animations
(Black 2 door records, b2tools/pearl_doors.py; notes/MAP_LOOK.md "Doors that open").
Test `patches/test_twinleaf.py` (test only): Twinleaf (Pearl chunk 0) and Route 201's south chunk (5) in Aspertia's
chunks 279/280, Pearl collision and heights, the 8 props in a new pack 70: **the houses and doors draw with their
textures, at the right place and height** (`work/twinleaf/field_2.png`; the water reflection works too).

## Sinnoh's overworld installed (2026-10-18)
- `b2tools/allocate_sinnoh.py` -> `data/sinnoh_world.json`: 66 Pearl overworld zones -> Black 2 zones (Twinleaf 427,
  the new-game zone; Unova's town/route zones first, never the ids Black 2's code special-cases), 13 Pearl areas ->
  seasonal area groups 2, 6, ... 50, building packs 70-82 (each: the area's Pearl list + every model placed in its
  chunks and their neighbours), 133 global building ids, Pearl chunks -> 1065..1239.
- `patches/sinnoh_world.py`: chunks, matrix 0 (30x30, chunk + zone per cell), zone headers (empty events/scripts/
  wild Pokémon for now), area records + Pearl's texture sets in all four seasons, packs. Fly points -> work/world/fly.json.
- **Black 2's opening stripped** (user, 2026-10-18: it disturbs overworld tests, as in HoennB2): zone 427's script
  file is `src/field_scripts/1289_twinleaf_newgame.s` (scripts 29/30/31: fade out, reserve 31, warp onto Twinleaf's
  fly point, 31 fades in: Black 2's own order from aspertia_city.s Script_30 / aspertia_city_2.s Script_17). Without
  the reserved fade-in the screen stayed black after the warp. To check in melonDS (HoennB2's same-tile fade trick
  failed there; this one is Black 2's own pattern, to a different tile).
- `patches/scripts.py`: assembles src/field_scripts/NNNN_*.s with pokebw2's macros (+ FLY_<zone>_X/Y/Z defines).
- Test (DeSmuME, `hwtest/intro_shot.py ... 427 4 "D3,R5,U6,L6,U10,U10"`): new game -> Twinleaf, the player visible,
  walks, houses block, camera follows; walking north reached Route 201's zone (319) in an earlier run.
  Build: `python3 build_rom.py --clean antipiracy sinnoh_world scripts`.

## Rooms, warps, names, re-skin (2026-10-18, later)
- **Rooms**: `patches/sinnoh_rooms.py` installs the 375 reachable rooms/caves (Pokémon Center 2F left out: their stairs
  warp is moved off the map). `patches/sinnoh_events.py`: 970 warps. **Tested in DeSmuME** (`intro_shot.py ... "T105:876;
  U1;W120;..."`): Twinleaf -> the player's house (door), back out (exit mat; Black 2 steps the player off the door),
  back in, and up the stairs to the bedroom (zone 519). Pearl's furniture and rooms draw correctly.
- **How Black 2 fires warps** (GetWarpIDByPlayerPos, ov012 eventdata_system.c:124): type 1 = standing on the tile and
  trying to move (exit mats); other types = bumping into the warp tile from the next tile in the warp's direction
  (2 up, 1 down, 4 left, 3 right). Black 2 checks walk-into warps only on a bump, so Pearl's step-on warp tiles
  (stairs everywhere, entrances on the overworld) are made solid by the converter (`pearl_chunk.STAIRS/ENTRANCES`),
  with one stairs warp per open side.
- **Warp heights (2026-10-26)**: Black 2 fires a warp only when the player's height is within 2 units of the record's
  (ov012 CheckWarpPositionMatch). `python3 b2tools/warp_check.py heights` (offline, converts each chunk: ~5 min)
  checks every firing warp's y against the built floor where the player stands (mats, panels: their tile; doors,
  stairs, bump warps: the tile walked in from). Before: 6 of 986 off (Sunyshore Gym rooms 1-2: exit mats with no
  floor drawn under them sat at 0 under walkways at 14 and 62; Ruin Maniac Cave stage 3; Turnback Cave's Giratina
  room x 3: mats on a sloping neighbour's plane recorded at the neighbour's height). pearl_chunk.floor_mats now puts
  a heightless mat on its neighbour's floor too and records the copied plane's height at the mat's own centre: 0 off.
  The overworld bump warps' heights (sinnoh_events: the first walkable side) all matched: not a cause.
- **Warp timing (2026-10-26, ladders)**: Pearl (pokeplatinum overlay005/field_control.c, shared with Diamond/Pearl)
  fires on the STEP onto the tile: north entrances/mats 0x64/0x6E (the ladders up: Oreburgh Mine, Mt. Coronet, Stark
  Mountain, ...), the escalators 0x6A (the Pokémon Centers' and League lobby's stairs) and 0x6B (Veilstone Department
  Store), the warp panels 0x67; and on a PUSH against collision (the held direction = the facing one): the door in
  front 0x69, standing on the E/W/S entrances and mats 0x62/0x63/0x65/0x6C/0x6D/0x6F or on the stairs' foot 0x5E/0x5F
  (Victory Road's 1F/2F/B1F "ladders" are stairs tiles). Black 2 fires types 0/5/6 on the step (IsStepOnWarp), type 1
  on a push while standing on it, 2-4 on a walk into it. sinnoh_events now gives Pearl's step-on mats in rooms type 0
  (133: 69 north mats/ladders, 56 Center/League stairs, 8 escalators; before: type 1, a second press); everything else
  already matched. Left: 16 warps on solid non-door tiles (Jublife's and Sunyshore's unused houses, Lake Valor's and
  Lake Acuity's leftover exits, Pal Park's exit (24-25, 52)) fire when walked into; Pearl never fires them (Pal Park's
  exit is its agent's). No hole tiles in any installed zone.
  Tested every frame (DeSmuME, work/agents/ladders/shots/): a 2-frame tap onto the League Center's stairs (2,10)
  warps as the step ends (frame 16), as does one onto the shared 2F's stairs down; holding left in Victory Road 1F from
  (6,37): (5,37) at frame 9, the stairs' foot (4,37) at 25, the warp at 41 as the step ends (no pause, as Pearl's push
  while held); a 2-frame tap onto Oreburgh Mine B2F's ladder (15,1) warps at frame 17 to B1F (12,21).
- **Place names**: `patches/sinnoh_names.py` (Pearl's 111 map sections on lines 4-114 of system text 109; zones'
  place + banner style).
- **Re-skin** (`patches/sinnoh_reskin.py`, data/texture_map.json): per overworld area set and season, 403 textures
  swapped for Black 2's (stored under Pearl's names), 238 Pearl textures recoloured to Black 2's seasonal colours
  (trees, tall grass, shadows, path/lawn/road edges; `recolour.py`), 210 kept (flowers, Sinnoh landmarks, 38 palette
  clashes). In-game (summer): Black 2 grass and paths, teal Black 2 trees.
  **Replaced 2026-10-19** (decision; notes/MAP_LOOK.md): by default `sinnoh_reskin` now gives Pearl's own textures in
  spring and summer and Pearl's art recoloured to Black 2's autumn/winter colours (north: winter all year), plus the
  map-look fixes (zone fog, light tables, lamps, material colours; `b2tools/maplook.py`). The style above is
  `MAPLOOK_FIXES=none`.
- Build: `python3 build_rom.py --clean antipiracy sinnoh_world sinnoh_reskin sinnoh_rooms sinnoh_events sinnoh_names
  sinnoh_encounters scripts` (PEARL_BUILD_DIR to keep test ROMs apart).
- Open: rooms' own textures are still Pearl's (re-skin covers the overworld); 11 overworld chunks with small height
  gaps; special tiles (bike bridges, Rock Climb, berry patches) are floor/wall; Pokémon Center 2F; camera override of
  zone 427 (Aspertia's); B2 zone tables in raw numbers (swarms, roamers: inactive until Black 2 story flags).

## Black-out and Pokémon Center respawn (2026-10-18, `patches/sinnoh_respawn.py`)
- Found in game: a black-out (a Lv 10 Piplup against a fished Gyarados Lv 50) sent the player to zone 435 at (7, 12),
  inside Lake Acuity's trees: Black 2's respawn table (RESPAWN_ZONE_INFO, ov012) still named Unova's zones.
- Now entries 1 and 18 (the new game's and the fallback) are the player's house 1F at (8, 8) in Twinleaf, entries
  2-17 and 19 Sinnoh's 17 Pokémon Centers 1F at (8, 6) (Pearl/Platinum's spots), the other 63 are switched off.
- Tested in game: the same black-out now wakes the player at home on the living-room rug.
- Not tested yet: entering a Center makes it the respawn (Black 2's own rule, unchanged); Teleport; Fly's town list
  (with the HMs).

## Bridges: two levels (2026-10-25, b2tools/pearl_chunk.py "two levels", bridge_check.py)
Found in Chapter 4b: Route 215's road runs east-west under wooden bridges and was a wall under the first one (from
Route 210 S you stood on the bridge; on the road (590,591) -> (591,591) was refused).
- **Cause**: the converter took every tile's height from the terrain model's highest surface, so a road tile under
  a bridge got the deck's height (64; the road is 32): a 32-unit step, a wall in both games.
- **Pearl** (pokeplatinum for the names; Pearl's own data): the BDHC (now decoded: gen4_land.read_bdhc_dp, DATA.md)
  holds both levels where a way passes under a bridge (Route 215: deck 64 and road 32, only on the road's 4 rows).
  A walker takes the plate nearest its own height (bdhc.c CalculateObjectHeight); 20 units or more up or down is a
  wall (terrain_collision_manager.c). The tile attribute is one for both levels: the collision bit, and the bridge
  behaviours 0x70-0x7d naming what is under the deck (water 0x73/0x78/0x7c, sand 0x74/0x79/0x7d, snow 0x75, cave
  0x72, tall grass 0x77/0x7b). The "on a bridge" state (set on 0x70 BRIDGE_START, cleared on a non-bridge tile:
  map_object_move.c) only makes bridge-over-water/sand/snow tiles act as the deck (no water wall, splash, footprints;
  no Surf or fishing from the deck); the level itself is the BDHC's.
- **Black 2**: a 'GC' chunk (ov036 field_map_chunk_gc.c; 60 of Black 2's own chunks) has two terrain layers;
  FieldG3DMapper_GetTerrain takes the valid layer nearest the walker's height, ActorRouteCollCheckCore walls 20+
  units. Its bridges keep layer 0 = the ground and layer 1 = a copy with the decks. No C needed (the Gym gimmicks'
  GetTerrainAll hook is separate: PearlB2_AppendTerrainLayers adds layers after the chunk's).
- **Converter** (pearl_chunk two_levels, lower_layer, deck_planes): a chunk is written as GC where a tile Pearl
  walks has two BDHC levels LEVEL_GAP (8) or more apart and the lower one can be walked or surfed onto (Pearl's
  nearest-level rule from a neighbour; Canalave's canal bed and a Contest Hall seam can't: no layer for them). Layer
  1 = as before (the model's surface), layer 0 = BDHC's lower level with what is under the deck (pearl_chunk.LOWER;
  plain bridges: the deck's own class, a road). BDHC's height replaces the model's (deck_planes) on decks the model
  doesn't draw (Canalave's bridge is a placed model: its 24 tiles stood at the canal's 8, now 16) and on overhangs
  beside a bridge (the model 20+ units over Pearl's level: the Cycling Road's edges over Route 206's path, 55 tiles;
  Sunyshore's walkway railings, 20); water a deck's plate reaches over is a wall above (Route 208, 4 tiles: no Surf
  from the deck). 36 chunks become GC: Routes 205 S, 206, 207, 208, 210 N, 211 W, 212 S, 215, 216, 225, 227, 228,
  Sunyshore, Mt. Coronet S 2F, Victory Road 1F, Sendoff Spring, Wayward Cave B1F. The Gyms' chunks are left alone
  (their gimmicks). sinnoh_world / sinnoh_rooms put both layers in (signs solid on both); work/world/
  heights_*_low.json hold the lower levels; pearl_events.Heights.at(near=) puts a person on the level nearest
  Pearl's own y (Pearl's rule: the Sunyshore vent at (853, 751), y 0, stands on the road under the walkway; Route
  206's three cyclists stay on the Cycling Road). Size: a GC chunk is 8,200 B more, the model fixes unchanged
  (largest: Route 225 chunk 164, 104,076 B, under the 110,600 limit; over season_decals' 104,000, so no leaves
  are added to it).
- **Check** (`python3 b2tools/bridge_check.py [--json OUT]`, ~20 min): 68 bridges (every 0x70-0x7d group and
  two-level group of every installed map). For each step from every level Pearl reaches on and next to a bridge,
  and for reachability (on foot and surfing) from the tiles around it, Pearl's rules on Pearl's data against Black
  2's on the converted chunk: all equal except Route 228's bike slopes (0xda BIKE_SLOPE_BOTTOM beside 3 bridges:
  no model ground, height 0: the open bike-slope item). Route 215 from (590, 591): Pearl and converted reach the
  gatehouse at x 671; before, x 593 (the first bridge).
- **Tested in game** (DeSmuME, 2026-10-26, full build at main d72629b, TEST_START=20,586,591; shots in
  work/agents/bridges/shots): Route 215 from the road west of the first bridge east under bridge 1 (591-593) at y 32
  (the deck hides the player), up onto bridge 3 from its south end (614,598 -> 597) and along its deck at y 64 over
  the road; a step sideways off the deck onto the road (613,591 -> 612,591) refused; along bridge 3's and bridge 2's
  decks, down the ramp and under bridge 2 (604, 582-583) and bridge 3 (612 -> 616, 591) at y 32; on to the gatehouse
  (671, 598) and Veilstone (678, 598). Route 208 (quick rebuild, TEST_START=383,399,719): surfed under the river
  bridge (400, 722 -> 726) at y 24, the deck drawn over the player's head (56 units up, Black 2's lower camera
  shows the player below its edge), its shadow on the water. Note: story_play's TO plans on Pearl's flat
  collision, so on two-level ground it can walk onto a deck and stop; use STEP commands there.
- Not changed, for the lead: elsewhere the model is 20+ units over Pearl's only BDHC level on ~800 walkable tiles
  (Pal Park, Route 224, Victory Road, Ravaged Path, Galactic HQ 4F, caves, door frames): sometimes Pearl's BDHC is a
  flat stand-in under raised ground there, so the model stays (b2tools/bridge_check.py's BDHC reader can list them).
- **Flower carpets** (2026-10-26): the t3_fl_* meshes (Floaroma 32/33, Floaroma Meadow 414-417, Flower Paradise
  123, the Seabreak Path 119/124-131) stand 12 units over Pearl's BDHC with no ground mesh under them, so they were
  taken as ground: 5,145 walkable tiles 12 units high and 20-unit walls Pearl walks (Flower Paradise's stairs up to
  Shaymin's bed, 72 -> 92). Now pearl_chunk skips them (SKIP_MATERIALS) and a tile with only carpet takes the
  carpet's surface minus FLOWER_LIFT (12): every walkable tile of those maps matches the BDHC (within 2 units) but 7
  enclosed one- and two-tile pockets in map 119 (unreachable; 6 of them were off before); the model is unchanged.
- `BRIDGE_LEVELS=none` (environment): the one-layer converter as before.
