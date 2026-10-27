# Wild Pokémon: Pearl's tables in Black 2 (2026-10-18)

Pearl's own wild Pokémon tables (species, levels, slot order) go into Black 2's encounter files. The user's decisions:
seasons on, but the same wild Pokémon all year; Pearl's own tables exactly.

- Patch: `b2tools/patches/sinnoh_encounters.py`. It runs after `sinnoh_world` (and after `sinnoh_rooms` when that is in
  the list). Its docstring has every rule and the reason for it.
- Checker: `b2tools/encounters_check.py [FILES_DIR]`. It reads back a build's a/1/2/7 and zone headers and compares
  every Sinnoh zone with Pearl's JSON.
- Sources: Pearl's 183 encounter files come from `work/pearl/encounters/NNN.json` (`gen4_extract.py`). Black 2's rules
  come from pokebw2: `src/ov012/field_encount_st.c`, `src/ov036/field_encount.c`, `enc_pokeset.c` and
  `effect_encount.c`. Pearl's rules come from pokediamond overlay 6 (asm) and pokeplatinum `wild_encounters.c`.
  Platinum is used only where pokediamond's C has a gap; every Platinum rule used here was checked against
  pokediamond's asm or Pearl's data.

## Where the tables go
- **Black 2 table 135 + N is Pearl's encounter file N** (tables 135-317). Black 2's own 135 tables are left as they
  are, so a Black 2 zone that has not been replaced yet keeps its wild Pokémon.
- All 183 Pearl files are written now, including caves and other files no zone uses yet. a/1/2/7 therefore keeps
  the same layout from now on, and adding caves later only changes zone headers. HoennB2 found that the game keeps
  a/1/2/7's file table in RAM, so savestates break when this layout changes. The tables take 42 KB, inside the
  archive's 64 KB build reserve.
- Each table is one 232-byte table with no seasons. Black 2 then uses it all year (`EncData_Load`), which matches the
  user's "same wild Pokémon all year".
- Zone headers: every overworld zone in `data/sinnoh_world.json` gets 135 + its Pearl zone's file, or 0x1FFF (none).
  Zone numbers are read at build time and never hard-coded.
- Room zones ("rooms": caves and interiors) get their table only once they are installed. The patch checks that the
  zone header's matrix is the room's own Black 2 matrix; until then the room is skipped. Of the 375 rooms, 83 have
  wild Pokémon in Pearl (caves, Great Marsh, Solaceon Ruins, Iron Island and others); their tables are already in
  a/1/2/7.

## Mapping
| Pearl | Black 2 | Why |
|---|---|---|
| Land, 12 slots, one level each | Grass, 12 slots, min = max = level | Both games pick slots with the same odds, 20/20/10/10/10/10/5/5/4/4/1/1. |
| Morning / day / night (slots 2-3) | **4 tables per file: morning, day, night, (rods)** | User's choice: the DS clock picks the table, as in Pearl. A small code change (`src/code/time_encounters.c`) loads table 0 in Black 2's morning, 1 by day and in the evening, 2 at night and midnight. Black 2 would otherwise pick these tables by season. |
| Pearl's tall grass and very tall grass | Both are single-battle grass (`pearl_chunk.py` classes 0x04 and 0x08) | Both use the grass table. |
| (none) | Dark grass = copy of grass, same rate | `pearl_chunk` makes no dark grass today. If it ever does, those tiles still give Pearl's Pokémon. |
| (Poké Radar patches) | Shaking grass empty, rate 0 | The Radar is closed (user). With rate 0 Black 2 makes no shaking-grass spots. |
| Surf, 5 slots | Surf, 5 slots | Same odds in both games: 60/30/5/4/1. |
| Super Rod | **Fishing** in tables 0-2 | User's choice: three real rods. The Super Rod is Black 2's own rod, code and odds (40/40/15/4/1, the same as Pearl's). |
| Old Rod | **Fishing** in table 3 | Read only by the rods code (`src/code/rods.c`, from HoennB2's), with Pearl's Old Rod odds 60/30/5/4/1. |
| Good Rod | **Rippling fishing** in table 3 | Read only by the rods code, with Pearl's odds 40/40/15/4/1. |
| (none) | Rippling surf and rippling fishing off in tables 0-2 | Pearl has no rippling water, so Sinnoh gets no rippling spots. |
| Swarm (0-1), Poké Radar (4-5, 10-11), GBA slot (8-9) | not installed | These are Pearl-only features, listed per route below. |
| Shellos/Gastrodon east-sea flags | form 1 (East Sea) where Pearl's file says so | Pearl's `rate_form0/1` fields. |
| Unown room letters (Solaceon Ruins) | that letter (or ! / ?) | Group 1 has 20 letters, too many for 12 slots, so it gets form 31 (any letter). Caves only; to review then. |

## Rates
Pearl's chance per step is 40 % × rate % (70 % on a bike or in very tall grass). After a battle or a map load, the
first 8 − rate/10 steps only get 5 % of that chance (pokediamond `ov06_0223C470`, `ov06_0223C55C`).

Black 2's rate byte does not set a chance. It picks one of 12 fixed rules, and each rule ramps the chance up after
every reset. The patch picks the rule whose expected number of battles on walks of 10-100 steps is closest to Pearl's:

| Pearl rate (grass/surf) | Black 2 rule | worst error in expected battles (walks of 10-100 steps) |
|---|---|---|
| 10 | 11 | 13 % |
| 15 | 11 | 38 % |
| 20 | 3 | 17 % |
| 25 | 4 | 20 % |
| 30 | 4 | 18 % |
| 35 | 4 | 27 % |

- Routes (rate 30) get rule 4. Its chance per step goes 0, 0, 2, 4, 4, 6 … % and reaches 20 % at the 20th step.
  That gives the same mean as Pearl's, 13 steps per battle.
- Fishing: Pearl bites when Random(100) < rate. Black 2 bites unless Random(100) > rate. So the byte is the rate − 1.
  Pearl's rods bite at different rates (Old 25 %, Good 50 %, Super 75 % in 52 of the 53 water tables). Black 2 rolls
  with the Super Rod's byte (74) for every rod; the rods code then rolls again for the Old and Good Rod (25/75 and
  50/75), so each rod bites as often as in Pearl.

## Verified (2026-10-18)
- Build: `PEARL_BUILD_DIR=work/rom_enc build_rom.py --clean antipiracy sinnoh_world scripts sinnoh_encounters`.
  The patch reported: 183 Pearl tables written to 135..317; 66 zones set, 49 of them with wild Pokémon; rooms not
  installed (sinnoh_rooms was not in this build).
- `encounters_check.py work/rom_enc/files`: **49 zones, 2744 slots, 0 differences**. Black 2's 135 tables are
  byte-equal to pokebw2's build.
  - A deliberately corrupted copy was also tested: the checker reported a level change, a rate change and a changed
    Black 2 table.
- In game (DeSmuME, muted, clock at 12:17 = day): built with the test-only `patches/test_wildmon.py`, which gives a
  new game a Lv 10 Piplup, because a wild battle with an empty party hangs.
  - `b2tools/hwtest/wild_shot.py ROM OUT` boots a new game, walks from Twinleaf to Route 201's grass and walks back
    and forth until a battle.
  - **A wild Bidoof Lv 2 appeared after 19 grass steps** (Pearl's Route 201: Starly/Bidoof Lv 2-3).
  - Screenshots: `work/encounters/route201_grass.png`, `route201_wild_bidoof.png`.

## Verified in game: time of day and the three rods (2026-10-18, evening)
- Build: `PEARL_BUILD_DIR=work/rom_lead TEST_ITEMS=445,446,447 build_rom.py --clean antipiracy sinnoh_world
  sinnoh_reskin sinnoh_rooms sinnoh_events sinnoh_names sinnoh_encounters sinnoh_music scripts pearl_title pearl_rods
  link test_wildmon` (test_wildmon: a Lv 10 Piplup and the three rods in a new game).
- `encounters_check.py work/rom_lead/files`: **132 zones, 29,568 slots, 0 differences** (all 4 tables of each file).
- Tool: `b2tools/hwtest/fish_shot.py` (DeSmuME, muted). It reads the wild table in RAM (EventData + 0x38) and compares
  it with the zone's 4 tables, and logs each cast (the rod code, the Pokémon Black 2 picked, the bite).
- **Time of day**: walking from Twinleaf into Route 201 at 12:00 loads table 0/1 (morning/day: the same on Route 201),
  at 23:00 table 2 (night). Without the hook Black 2 would load table 2 at any hour (October = autumn = season 2).
- **Old Rod** (Bag USE and Y): USE / REGISTER / TO FREE SPACE / CANCEL, no Give. Seven casts at Twinleaf's pond: six
  times Black 2's bite roll passed and the rod code ran, five times its own Pearl roll (25/75) said no bite, once it
  picked **Magikarp** from Pearl's Old Rod table -> "Landed a Pokémon!" -> a wild Magikarp Lv 5 battle.
- **Good Rod** (Bag USE): the rod variable read 446; it picked **Goldeen Lv 10** (Pearl's Good Rod table: Magikarp /
  Goldeen 10-25) -> bite.
- **Super Rod** (Bag USE): the rod variable read 447; Black 2's own fishing path used the zone's fishing slots, which
  are Pearl's Super Rod table (Gyarados 30-40, Seaking 30-40, Gyarados 40-55, Seaking 20-50 ×2) -> a wild **Seaking
  Lv 39** battle.
- Y-menu names "Old Rod"/"Good Rod" (system text) are in the build; the Y popup with all three registered is not
  screenshotted yet.

## Open questions (for the user)
1. ~~Morning and night Pokémon~~: answered (2026-10-18): the DS clock picks Pearl's morning/day/night Pokémon (small
   code change). Built; to test in game.
2. ~~Fishing rods~~: answered (2026-10-18): three real rods, reusing HoennB2's rods code (`patches/pearl_rods.py`,
   `src/code/rods.c`, `ROD_LAYOUT = 'pearl3'`). Built; to test in game.
3. **Encounter rate.** Black 2 cannot copy Pearl's rate with data alone; rule 4 matches the average within about
   **Answered 2026-10-19: Pearl's exact pattern (the 4-byte edit).**
   20 %. A 4-byte edit of one of Black 2's spare rules (HoennB2 tested this kind of edit, RESEARCH_ENCOUNTERS.md)
   would give Pearl's exact pattern: no battle in the first 5 steps, then 12 % per step. Options: keep rule 4 (now),
   or make that edit (recommended if you want Pearl's feel exactly). Either way, Pearl's extra chance on a bike and
   in very tall grass has no Black 2 equivalent.

## Open items (not questions)
- **Black 2 code that keys off zone numbers in ov036 uses raw numbers, which `data/b2_special_zones.json` (built from
  `ZONE_` names) misses.**
  - Swarms (`enc_pokeset.c`, 19 zones): Routes 202, 203, 204 S/N, 205 S/N, 206-209, 211 W, 212 N, Valor Lakefront,
    and the rooms on 152 and 376.
  - N's Pokémon (zones 0x13f = Route 201, 0x9a = Valley Windworks, 0x144 = a Mt. Coronet room).
  - Roamers (`ROAMING_POKEMON_ZONES`: Routes 201-209 and Celestic).
  - Dust-cloud shard zones 503-505 and 531-542 (Sinnoh rooms).
  All of these are switched off unless Black 2's FLAG_SWARMS or FLAG_N_POKEMON is set, or a roamer is released, and
  only Black 2's own story does that. They become relevant if Pearl's swarms or roamers (Mesprit, Cresselia) are
  built on Black 2's systems.
- Black 2's Pokédex area maps (`zukan_habitat.c`) are separate data and will still show Unova until rebuilt.
- Cave floors: `pearl_chunk.py` maps Pearl's CAVE_FLOOR, OLD_CHATEAU_FLOOR and bridge-over-cave tiles (encounter tiles
  in Pearl) to plain floor without Black 2's encounter flag (0x04). Caves will have no wild battles until those tiles
  get an encounter class. Pearl's plain MUD tiles (0xa4/0xa5) become swamp with the encounter flag, but in Pearl only
  mud with grass (0xa6/0xa7) has encounters. Both are for the lead (`pearl_chunk.BEHAVIOURS`).
- Not covered by a/1/2/7 (Pearl's `encdata_ex`, later): Honey trees, Great Marsh daily Pokémon, Trophy Garden daily
  Pokémon (slots 6-7), Feebas tiles, roamers.

## Pearl-only features and what each route loses
"table" is the Black 2 table number (135 + Pearl file). The "lost" columns list species that are not anywhere else in
that zone's daytime table. Generated by `python3 b2tools/patches/sinnoh_encounters.py --report`.

| Zone (Pearl) | table | lost: morning-only | lost: night-only | swarm (slots 0-1) | Poké Radar (4-5, 10-11) | GBA slots R/S/E/FR/LG (8-9) |
|---|---|---|---|---|---|---|
| Acuity Lakefront | 274 | - | Noctowl, Zubat | Sneasel, Snover | Snorunt | Medicham / Medicham / Teddiursa / Medicham / Medicham |
| Canalave | 135 | (water only) | | | | |
| Celestic | 312 | (water only) | | | | |
| Eterna | 136 | (water only) | | | | |
| Fuego Ironworks Exterior | 144 | - | - | Magnemite | Hoppip, Skiploom | Floatzel, Gastrodon (all five) |
| Iron Island Exterior | 253 | (water only) | | | | |
| Pastoria | 137 | (water only) | | | | |
| Pokemon League | 139 | (water only) | | | | |
| Resort Area | 313 | (water only) | | | | |
| Route 201 | 275 | - | - | Doduo | Nidoran M, Nidoran F | Starly / Starly / Starly / Growlithe / Starly |
| Route 202 | 276 | Kricketot | Kricketot | Zigzagoon | Sentret | Starly, Bidoof / Starly, Bidoof / Starly, Bidoof / Growlithe / Starly, Bidoof |
| Route 203 | 277 | Kricketot | Kricketot, Zubat | Cubone | Ralts, Kirlia | Seedot / Lotad / Pineco / Starly, Bidoof / Starly, Bidoof |
| Route 204 North | 279 | Kricketot | Kricketot, Zubat | Bidoof, Starly | Sunkern | Seedot / Lotad / Pineco / Starly, Bidoof / Starly, Bidoof |
| Route 204 South | 278 | Kricketot | Kricketot, Zubat | Bidoof, Starly | Ralts, Kirlia | Seedot / Lotad / Pineco / Caterpie / Weedle |
| Route 205 North | 281 | - | - | Bidoof, Buizel | Slowpoke | Buizel, Bidoof / Lotad / Buizel, Bidoof / Buizel, Bidoof / Buizel, Bidoof |
| Route 205 South | 280 | - | - | Buizel, Shellos | Hoppip | Buizel, Shellos / Buizel, Shellos / Buizel, Shellos / Elekid / Buizel, Shellos |
| Route 206 | 282 | Kricketot | Zubat | Nosepass | Baltoy | Ponyta, Geodude / Ponyta, Geodude / Gligar / Ponyta, Geodude / Ponyta, Geodude |
| Route 207 | 283 | Kricketot | Kricketot, Zubat | Phanpy | Stantler | Machop, Geodude / Machop, Geodude / Gligar / Machop, Geodude / Machop, Geodude |
| Route 208 | 284 | - | Zubat | Dunsparce | Tyrogue | Zangoose / Seviper / Psyduck, Bibarel / Psyduck, Bibarel / Psyduck, Bibarel |
| Route 209 | 285 | - | Gastly, Zubat | Snubbull | Miltank, Tauros | Chansey, Bonsly / Chansey, Bonsly / Chansey, Bonsly / Chansey, Bonsly / Vulpix |
| Route 210 North | 292 | - | Hoothoot, Noctowl | Bibarel, Psyduck | Bagon | Zangoose / Seviper / Machoke, Meditite / Machoke, Meditite / Machoke, Meditite |
| Route 210 South | 291 | - | - | Geodude, Ponyta | Miltank, Tauros | Seedot, Nuzleaf / Chansey, Bonsly / Pineco / Chansey, Bonsly / Chansey, Bonsly |
| Route 211 East | 294 | - | Noctowl, Zubat | Graveler, Meditite | Swablu | Meditite, Ponyta / Meditite, Ponyta / Teddiursa / Meditite, Ponyta / Meditite, Ponyta |
| Route 211 West | 293 | - | Hoothoot, Zubat | Bidoof, Meditite | Tyrogue | Bidoof, Meditite / Bidoof, Meditite / Teddiursa / Bidoof, Meditite / Bidoof, Meditite |
| Route 212 North | 295 | - | - | Budew, Starly | Smeargle | Kricketune (all five) |
| Route 212 South | 296 | - | - | Bibarel, Wooper | Grimer | Bibarel, Wooper / Lombre, Lotad / Bibarel, Wooper / Ekans / Bibarel, Wooper |
| Route 213 | 297 | - | - | Absol | Swellow | Floatzel, Shellos (all five) |
| Route 214 | 298 | - | - | Spoink | Houndoom | Sudowoodo, Graveler / Sudowoodo, Graveler / Gligar / Sudowoodo, Graveler / Vulpix |
| Route 215 | 299 | - | - | Drowzee | Houndoom | Geodude, Kadabra / Geodude, Kadabra / Gligar / Geodude, Kadabra / Geodude, Kadabra |
| Route 216 | 300 | - | Noctowl, Zubat | Delibird | Snorunt | Graveler / Graveler / Ursaring / Graveler / Graveler |
| Route 217 | 301 | - | Noctowl, Zubat | Swinub | Snorunt | Medicham / Medicham / Ursaring / Medicham / Medicham |
| Route 218 | 302 | - | - | Voltorb | Ditto | Glameow, Gastrodon (all five) |
| Route 219 | 303 | (water only) | | | | |
| Route 220 | 314 | (water only) | | | | |
| Route 221 | 304 | - | - | Farfetchd | Nidorino, Nidorina | Sudowoodo, Gastrodon (all five) |
| Route 222 | 305 | - | - | Skitty | Flaaffy | Purugly, Gastrodon (all five) |
| Route 223 | 315 | (water only) | | | | |
| Route 224 | 306 | - | - | Natu | Dusclops, Duskull | Buizel, Beautifly / Buizel, Beautifly / Shuckle / Buizel, Beautifly / Buizel, Beautifly |
| Route 225 | 307 | - | Banette | Makuhita | Primeape, Mankey | Spearow, Rattata (all five) |
| Route 226 | 316 | - | Banette | Krabby | Primeape, Mankey | Spearow, Rattata (all five) |
| Route 227 | 308 | - | Banette, Golbat | Spinda | Torkoal | Numel, Rhyhorn / Numel, Rhyhorn / Gligar / Numel, Rhyhorn / Magby |
| Route 228 | 309 | - | - | Beldum | Vibrava, Trapinch | Diglett, Cacnea / Diglett, Cacnea / Diglett, Cacnea / Diglett, Cacnea / Sandslash |
| Route 229 | 310 | Ledian | Ariados | Pidgey | Venomoth, Venonat | Nuzleaf / Lombre / Pineco / Bellsprout, Oddish / Bellsprout, Oddish |
| Route 230 | 317 | - | - | Corsola | Togepi | Floatzel (all five) |
| Stark Mountain Exterior | 191 | - | Banette, Golbat | Camerupt, Rhydon | Torkoal | Numel, Rhyhorn / Numel, Rhyhorn / Gligar / Numel, Rhyhorn / Magby |
| Sunyshore | 138 | (water only) | | | | |
| Twinleaf | 311 | (water only) | | | | |
| Valley Windworks Exterior | 142 | - | - | Electrike | Mareep | Buizel, Shellos / Buizel, Shellos / Buizel, Shellos / Elekid / Buizel, Shellos |
| Valor Lakefront | 273 | - | - | Geodude, Girafarig | Nidorino, Nidorina | Bibarel, Graveler (all five) |

95 species appear in Pearl only through swarms, the Poké Radar or the GBA slots. Most of them are post-game
(National Dex) features in Pearl. They all need one of those features, or another place, to be catchable.
