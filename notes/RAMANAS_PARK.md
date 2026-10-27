# Ramanas Park in Pearl's Pal Park (2026-10-26)

Part 1 of the user's decision of 2026-10-26 (DECISIONS.md, "Pal Park: both"): BDSP's Ramanas Park, built on Pearl's
Pal Park, for everyone. Part 2 (Pearl's GBA migration and Catching Show, offered at the gate when a GBA game is in
slot 2) is notes/PAL_PARK_MIGRATION.md. Plan approved by the lead with the user's answers (DECISIONS 2026-10-26):
the name stays **Pal Park**; Shining Pearl's 9 rooms now, Brilliant Diamond's two kept in the data for a later Diamond
version (every version split data-switchable); Black 2's own overworld sprites on the pedestal for all 14 Pokémon;
BDSP's exact movesets through a C hook; the park opens at **Champion** (not the National Pokédex).

State: **built and tested in a ROM** (2026-10-26, build 2 and quick rebuilds; section 5). Left: the black-out and the Altered Forme sprite's look, one quick build when the disk has room (section 6).

## 1. What BDSP does (sources)

No BDSP dump here, so the facts come from the public lists, as the Underground's tables did (DECISIONS 2026-10-19):
Serebii (brilliantdiamondshiningpearl/ramanaspark.shtml, pokearth/sinnoh/ramanaspark.shtml, the itemdex pages),
checked against Gamer Guides' and RankedBoost's Ramanas Park pages. Bulbapedia refuses our fetches (HTTP 403); its
wording reached us only through search snippets ("Bulbapedia, quoted by search").

- Ramanas Park replaces Pal Park on Route 221; rooms ("caves scattered around the park") each have a pedestal.
  Placing the room's slate calls one legendary Pokémon, battled and caught there. Sub-legendaries are fought in rooms
  that look like "Pure Space", the big legendaries in "Strange Space" (Serebii).
- Slates come only from the slate clerk in the gatehouse, for **3 Mysterious Shards S or 1 Mysterious Shard L** each.
  Shards come from digging in the Grand Underground; L is rarer than S.
- Each attempt uses a slate: if the Pokémon is knocked out, or the player loses or runs, "the Legendary Pokémon can be
  fought again by inserting another slate" (Bulbapedia quoted by search). In a three-Pokémon room the one that appears
  is random among the uncaught (Gamer Guides); in the Soul Room the player chooses Latias or Latios (Serebii).
- After a capture the statue appears on the pedestal (Secret Bases); some rooms then hold Berries, the Soul Room the
  Soul Dew. All are Lv 70 with fixed moves, hidden abilities where they have one. The Distortion Room is a Lv 100
  Origin Forme Giratina that can't be caught; beating it gives the Griseous Orb.
- Tiers: the Discovery Room first; Kanto (or Johto) and Soul after the three Regis; the third tier after the version's
  tier-2 Pokémon (Gamer Guides, RankedBoost, Serebii's Rainbow entry); Distortion after Turnback Cave's Giratina
  (Serebii, RankedBoost).

### The rooms (data/ramanas_park.json; version "sp" = Pearl NDS)
(The "Look" column is BDSP's; built, every room uses the Strange look: section 2, "The rooms".)

| # | Room | Look | Slate (item) | Pokémon, Lv | Ability | BDSP moves (-> Black 2) | Opens when | After |
|---|---|---|---|---|---|---|---|---|
| 1 | Discovery Room | Pure | Discovery Slate (120) | Regirock / Regice / Registeel, 70, random among the uncaught | hidden (Sturdy, Ice Body, Light Metal) | Stone Edge / Blizzard / Heavy Slam, Superpower, Lock-On, Zap Cannon | the park opens | - |
| 2 | Kanto Room | Pure | Kanto Slate (121) | Articuno / Zapdos / Moltres, 70, random | hidden (Snow Cloak; Lightning Rod = Black 2's, BDSP Static; Flame Body) | Hurricane, Mind Reader, Blizzard, Sheer Cold / Thunder, Detect, Magnetic Flux -> Charge, Zap Cannon / Hurricane, Endure, Burn Up -> Overheat, Sky Attack | 3 Regis caught | - |
| 3 | Soul Room | Pure | Soul Slate (122) | Latias or Latios, 70, the player's choice | Levitate | Reflect Type, Psychic, Guard Split, Healing Wish / Dragon Dance, Dragon Pulse, Zen Headbutt, Luster Purge | 3 Regis | Petaya / Apicot Berry; the Soul Dew with both |
| 4 | Distortion Room | Strange | Distortion Slate (123) | Giratina Origin Forme, 100, can't be caught | Levitate | Dragon Claw, Earth Power, Shadow Force, Aura Sphere | 3 Regis + Turnback Cave's Giratina caught (PFLAG_0121) | the Griseous Orb on a win |
| 5 | Squall Room | Strange | Squall Slate (124) | Lugia, 70 | hidden (Multiscale) | Extrasensory, Recover, Aeroblast, Rain Dance | the birds + Latias + Latios caught | - |
| 6 | Oceanic Room | Strange | Oceanic Slate (125) | Kyogre, 70 | Drizzle | Ice Beam, Sheer Cold, Aqua Ring, Origin Pulse -> Hydro Pump | as 5 | Enigma, Micle, Custap Berries |
| 7 | Tectonic Room | Strange | Tectonic Slate (126) | Groudon, 70 | Drought | Hammer Arm, Fissure, Rest, Precipice Blades -> Earthquake | as 5 | Liechi, Salac, Ganlon Berries |
| 8 | Stratospheric Room | Strange | Stratosph. Slate (127) | Rayquaza, 70 | Air Lock | Dragon Pulse, Hyper Voice, Rest, Fly | as 5 | Rowap, Jaboca Berries (no Roseli in Black 2) |
| 9 | Genome Room | Strange | Genome Slate (128) | Mewtwo, 70 | hidden (Unnerve) | Psychic, Power Swap, Guard Swap, Mist | as 5 | - |

Diamond version (version "bd", in the data, not built): the Johto Room (Raikou, Entei, Suicune; Johto Slate 131,
zone 661) instead of Kanto, the Rainbow Room (Ho-Oh; Rainbow Slate 132, zone 662) instead of Squall; the third tier
then needs the beasts. Same entrances as the rooms they replace. `PEARL_VERSION=bd` switches every tool.

Newer moves become the closest Black 2 move in type, category and power (as the TMs did): Origin Pulse -> Hydro
Pump (Water, special, 110 both), Precipice Blades -> Earthquake, Burn Up -> Overheat (130 both), Magnetic Flux ->
Charge. The Bag's list shows 96 px of a name: "Stratospheric Slate" (107 px) is "Stratosph. Slate", the shards
"Myst. Shard S" / "Myst. Shard L"; the lines say the full names.

## 2. How it works

### Ids (the lead's allocations, 2026-10-26)
| What | Ids |
|---|---|
| Zones | 652-660 (the 9 rooms), 661-662 reserved (Diamond's Johto and Rainbow Rooms) |
| Items | slates 120-128, Mysterious Shard S 129, L 130; 131-132 reserved (Diamond's slates) |
| Flags (registry new_flags, b2tools/pearl_ids.py) | 1054-1066 caught (Regirock .. Mewtwo), 1067 PFLAG_RP_DISTORTION_WON, 1068 PFLAG_RP_CLERK_MET, 1069-1072 reserved (Raikou, Entei, Suicune, Ho-Oh) |
| Files | script 1901, text 1301 (the rooms' shared files; notes/DATA.md "File numbers") |
| Works | Pearl's VAR_PAL_PARK_STATE (PVAR_40F3 = 0x40B1) gets value 3 = a Ramanas visit; map-local 0x401D (the room name shown); script temps 0x8050-0x8057 |
| Open | PFLAG_0964 = Black 2 flag 2400, the game clear (Chapter 8's pl_ClearGame and global 9601) |

### The gate (MAP_ROUTE_221_PAL_PARK_ENTRANCE, zone 509)
- Pearl's own scripts and people stay as Pearl's (Chapter 9b), with two extra entries (pearl_story hook,
  b2tools/ramanas.py extra_code): **the slate clerk**, a new person (uid 100, Pearl's Pal Park staff, graphics 40) behind
  the right-hand desk at (10, 10), talked to across it from (10, 12):
  - before Champion: "the rooms are open only to the Pokémon League Champion";
  - after: the first talk explains the slates (once, PFLAG_RP_CLERK_MET), then a menu: **Trade for a slate / Go to the
    park / Cancel**;
  - trade: the open, unfinished rooms' slates (computed from the caught flags; one of each at a time, Key Items), then
    3 Shards S or 1 Shard L (asks which only when both are there), Black 2's item-get;
  - go to the park: Pearl's own Catching Show entry without the show: the player walks to the counters' gap (7, 12),
    Pearl's receptionist steps aside (Pearl's movement 0x02B8), the player walks in (0x02CC), the park state = 3,
    the fade, the warp to (24, 47) as Pearl's script does.
- **The walk-out** (frame table, park state 3): Pearl's own after-retiring movements (0x03E4 the player out, 0x03D8 the
  receptionist back), state 0; if the player is not at the door (7, 7) (a Continue or black-out elsewhere), only the
  receptionist is put back.

### The park (MAP_PAL_PARK, zone 366)
- The park attendant (Pearl's object 0, "retire from the Catching Show?") says a Ramanas line during a visit (state 3),
  else Pearl's script.
- **9 doorways** (b2tools/ramanas.py entrances / chunk / models, called by patches/sinnoh_rooms.py as pearl_signs is):
  a Pearl building model set against a cliff, its front on the door tile's south edge, its body's tiles solid, a bump
  warp on the door tile (walking north) into the room. Placement rules (ramanas.py check_entrances): the body only on
  tiles Pearl already makes solid (nothing blocked), one chunk, no overlap, the tile in front walkable, no tall grass or
  sand, reachable from the park's entry.
  - Picked in the first build's comparison (work/agents/palpark/shots/comparison_doorways_rooms.png): **515, the
    Celestic Ruins' carved panel** (3 x 2 tiles, Pearl's own art: it reads as a sealed ancient door) for all 9; 516 (the
    dark panel) barely shows, 514 (Spear Pillar's gate) fits only a few spots (5 tiles wide), 195 (Amity Square's rock
    house) reads as a boulder. Pearl has no cave-mouth model (its cave mouths are terrain).
  - **The opening** (the user, 2026-10-26: "make the opening you walk in black so it looks like an actual entrance"):
    Pal Park's copy of 515 (Celestic's own stay as they are) has a black, door-shaped opening at the bottom centre of
    its face, one tile wide and three quarters of the slab's height with a rounded top: its face texture's texels
    painted in the palette's darkest colour, the carving over them made transparent (b2tools/ramanas.py
    door_opening; sinnoh_rooms builds Pal Park's pack with it, patches/ramanas_park.py paints the pack's texture set
    again, so quick builds take it too). No lake cavern is used for any room (the user: those are places of the game).
  - Spots: Discovery (30, 37), Kanto (34, 37), Soul (27, 35), Distortion (30, 12), Squall (23, 24), Oceanic (27, 24),
    Tectonic (33, 11), Stratospheric (37, 11), Genome (41, 11) (Diamond's Johto and Rainbow take Kanto's and Squall's).
    Found in the first build: a doorway whose front tile is in the next chunk got the wrong height and did not show
    (the model takes its height from the door's own chunk): check_entrances now refuses that, and these 9 are exactly
    the reachable cliff spots that pass.
- No wild Pokémon outside the show (Pearl's header has none).

### The rooms (zones 652-660)
- One zone per room, all on one script file (1901) and one text file (1301) (b2tools/ramanas.py write_rooms); per
  room i the entries 1+4i pedestal, 2+4i zone init (hide the sprites: map-local flags 0x30+), 3+4i the room's name on
  arrival (frame table: work 0x401D == 0; an info window for 60 frames), 4+4i the Catching Show block (frame table:
  state 1 -> "closed during the Catching Show", back to the room's door).
- Each zone (patches/ramanas_park.py) is a copy of its look's zone header (matrix, area, camera, lights, music,
  weather, battle background) with the shared files, no wild Pokémon, Pal Park's place name and parent (no banner;
  met location "Pal Park"), no Escape Rope / Fly. Its events: the look's warps (Pearl's own, sinnoh_events.Planner) all
  back to the room's doorway, each at the height Black 2 stands the player on its tile in the built map (Black 2 fires
  a warp only within 2 units of its record; the Giratina room's mats stand the player at 56 where the records say 40:
  found in the test, the rooms had no way out; patches/ramanas_park.py _on_floor), the pedestal sign events, the Pokémon's sprites on the pedestal.
- Look (picked in the first build): **every room is Turnback Cave's Giratina room** (zone 624, through APPENDED): the
  player comes in by its south door (Pearl's warp 2; its other doorways lead out too), and its dais with the carved
  tablet is a real pedestal (the sign on the tablet's three tiles, read facing north). The
  Pure Space candidates (Fullmoon Island's clearing, Newmoon Island's, Verity Cavern) all put the legendary on plain
  walkable floor (the player walks onto the pedestal; in Newmoon into the pond), so a lighter Pure Space would need a
  pedestal object (a stone person) in Fullmoon's clearing: an option for later (data/ramanas_park.json keeps the three
  looks, unused).
- The pedestal: complete -> "The <slate> rests in the pedestal."; no slate -> "It's a pedestal of ancient stone. A
  slate looks as if it would fit."; else "Will you place the <slate> on the pedestal?" -> the Pokémon (the only one /
  random among the uncaught / a list of the uncaught Lati@s) -> the slate taken -> "The <slate> began to shine!" ->
  the player steps back one tile, white flash, **the Pokémon's Black 2 sprite in front of the tablet** (on the tile
  the player read it from: Black 2 stands a person on its own tile's ground, and the tablet's tiles have none, so a
  sprite placed on the tablet stood inside the dais, unseen; found in the test) (the Regis' big statue sprites OBJ_CODE_350-352, the
  walking sprites of the rest: OBJ_CODE_POKEMON_*; Giratina the Altered Forme's 0x121C, as Turnback Cave's: the Origin Forme's 0x121D is Mt. Coronet's cave-painting wall since Chapter 7), its cry -> Black 2's static battle
  (CallWildBattleEx: flag 1 legendary as Black 2's own, flag 8 hidden ability, form 1 for Giratina) -> the sprite
  removed; caught: its flag, "Something was left behind on the pedestal!" and the Berries (Black 2's item-get), the
  Soul Dew when both Latis are caught; Giratina beaten: its flag, the Griseous Orb; lost: state 0, Black 2's black-out.

### Items (patches/ramanas_park.py, data/text_overrides/ramanas_park.json)
Slates: Black 2's Light Stone record (Key Items, can't be tossed), price 0; shards: the Red Shard's record (Items),
price 0. Names and BDSP's descriptions (Serebii's itemdex, "Ramanas Park" -> "Pal Park"), wrapped to the Bag's 3 lines.
Pockets, icons and "can't be held" are decomp tables (section 3).

### Shards
From the Underground (the lead passed it on): Grotto lists / daily Hideaway items, from Champion. For tests:
TEST_LINES with ItemAdd.

## 3. C (the decomp, after "build ok")
Draft in work/agents/palpark/decomp_draft/ (CHANGES.md + src/pearlb2/ramanas_itcm.c):
- **Moves**: ov036 field_encount.c EventWildBattleCall_CreateStatic's last call EventWildBattleCall_Create ->
  PearlB2_RamanasWildCall (same arguments): in a slate room's zone, the wild Pokémon of the table gets its 4 moves.
- **No capture**: ov167 btl_client.c IsPokeBallTargetHiding's IsSemiInvulnMove call -> PearlB2_BallTargetHides: also
  TRUE for a wild Pokémon the table marks "no capture" (species + form), so Black 2 refuses balls as at a hidden target.
- **Items**: include/pearlb2.h PEARLB2_RAMANAS_* (120-132), myitem_savedata.c pockets, pml_item.c DUMMY_ITEMS
  (cleared) / UNHOLDABLE_ITEMS (set) / the icon table (the Plates' disc in the room's Plate colours, the shards'
  icons).
- The table gPearlB2Ramanas (patches/ramanas_park.py apply_code): {zone, species, moves[4], flags, form} per Pokémon.

## 4. Files
- data/ramanas_park.json (the source), data/text_overrides/ramanas_park.json (written by
  `python3 b2tools/patches/ramanas_park.py --text`).
- b2tools/ramanas.py: writes src/field_scripts/1901_ramanas_rooms.s and src/text/script/1301_ramanas_rooms.txt
  (`python3 b2tools/ramanas.py`; `check`, `show`), the gate's and park's extra entries (hooks), the doorways.
- b2tools/patches/ramanas_park.py: the zones, their events, Pal Park's warps, the items, the ITCM table. Build list:
  after sinnoh_story (and sinnoh_music), before the patches that size tables from the headers.
- Hooks (additive): pearl_story.py PearlData.ramanas_ids + translate (the extra entries), pearl_events.py entities
  (the clerk, the attendant's override) and map_script_table (the walk-out row), patches/sinnoh_rooms.py (the
  doorways' placements, solid tiles, the model in Pal Park's pack), pearl_ids.py NEW_FLAGS.
- Generated here for testing: Pal Park's and the gate's zone files (Chapter 9b's zones: 1516/0873, 1654/0980); 9b's
  regeneration keeps the additions (they come from the hooks).

## 5. Test (DeSmuME headless, muted; shots in work/agents/palpark/shots/, b1_* build 1, q_* the quick rebuilds)
Build 1: the clerk (first talk, the menu lists only open slates, a trade paid with 3 S, the slate in Key Items), the
walk into the park (Pearl's scene), the doorways' warps, the room-name popup, the pedestal's lines. Build 2: a trade
paid with L; the doorway opening (in-game shot); Discovery's random pick (Registeel), "Registeel appeared!", a Master
Ball catch, flag 1055, BDSP's moves [484, 276, 199, 192], the slate used up, the sprite removed after. Quick rebuilds
(test start in the park, Lv 100 team): the Soul Room's menu lists only Latias when Latios is caught; the player steps
back and Latias' sprite stands in front of the tablet (q_soul_latias_sprite.png: whole, facing the player, drawn
behind him); the catch gives the Petaya Berry and the Soul Dew; then "The Soul Slate rests in the pedestal."; the
room's south mat leads back to the park in front of its doorway (q_room_exit_to_park.png); Oceanic: Kyogre knocked
out = slate used up, no flag, sprite gone; a second try (from a state) caught: flag 1062, Enigma, Micle and Custap
Berries; Distortion: a Master Ball refused with Black 2's line "It's no good! It's impossible to aim at a Pokémon
that's not in sight!" (the ball kept), Giratina (Earth Power) beaten: "Giratina faded into the distortion...", the
Griseous Orb, flag 1066; a run from it: slate used up, no flag, no Orb; the gallery of all 14 sprites (Genome Room,
RAMANAS_TEST_SPRITES: q_gallery_14_sprites_4637_wall.png: all face south, whole, Giratina's 4637 a brick wall:
fixed to 4636, not yet seen); leaving by the park's south exit runs Pearl's walk-out (gate 509: player (7, 12), the
receptionist back at (7, 11), state 0x40B1 = 0; q_park_walk_out.png).
Found and fixed in the test: the sprite on the tablet's tile stood inside the dais (Black 2 grounds a person on its
own tile); the rooms had no way out (warp heights: section 2); the Origin Forme sprite code is Chapter 7's wall.

## 6. Left
1. One quick build (needs 3 GB free; the disk had 2.2 GB): TEST_START=366,30,38 TEST_LEVEL=5 TEST_ITEMS=120
   TEST_SET=PFLAG_0964,PFLAG_0121,PVAR_40C6=1,PVAR_40F3=3 RAMANAS_TEST_SPRITES=genome, `build_rom.py ramanas_park
   test_story_start`: lose to a Regi (black-out: state 0x40B1 = 0 after), and Giratina's 4636 in the Genome gallery.
2. warp_check / scene_check for the doorways' warps (added by the patch, not in sinnoh_events' records).
3. A quick build that changes 1901's script needs `scripts` in the patch list (found in the test).

## 7. Not built / different from BDSP
Statues and Secret Bases; the gatehouse's item shop; Brilliant Diamond's rooms (data only); several copies of one
slate at a time; BDSP's own dialogue (our wording, in the data file, for review); BDSP's room interiors (Pearl's rooms
stand in); the Roseli Berry.
