# Black 2 zones kept out of Sinnoh (2026-10-25, chapter 5a)

Black 2 has 615 zones. Sinnoh uses 450 of them (data/sinnoh_world.json: 66 overworld zones, 384 rooms). The other 165
are kept for Black 2: b2tools/allocate_sinnoh.py's DENY (code or a system needs them) and AVOID (special map types,
or names in Black 2's code). Free Black 2 zones left: **none**; new places take zones appended after Black 2's
615 (616-1023; 615 itself is Black 2's "no zone" dummy: notes/ZONE_TABLE.md, allocate_sinnoh APPEND_BLOCKS).
The table below says, for each kept zone:
- code: decomp files that name it (data/b2_special_zones.json, from every ZONE_ name in pokebw2's C), plus zonedata.c's
  range checks (Entree Forest 280-288 = GetZoneIsEntreeForest, the gate range 289-316 = GetZoneIsEntralinkAny);
- scripts: Black 2's own field scripts that name it (res/field/scripts: warps there or checks it). Only global_*
  scripts can run in Sinnoh; a Unova zone's own script runs only in that zone;
- tables: zone-keyed data that lists it (a/1/0/2 gimmick, a/1/4/9 Flash, a/0/8/0 file 29 fog, ISS sound). For any zone
  Sinnoh uses, patches/zone_effects.py clears those entries at build time.
Made with the analysis script of the chapter 5a agent (rerun it against data/sinnoh_world.json when zones change).

## Taken from the kept list (2026-10-25)
Great Marsh areas 1-5 (allocate_sinnoh GREAT_MARSH_ZONES; the marsh is one Pearl matrix with a zone per cell):
585 (the last free zone), 550 DRIFTVEIL_CITY_16, 608 LENTIMAS_TOWN_3 (AVOID only as HoennB2's fixed-weather copies;
PearlB2's copy of fixed_weather.py is not in the build), 84 NIMBASA_CITY_8, 85 NIMBASA_CITY_9 (in HoennB2's "Nimbasa
Stadium 81-87" DENY block; the decomp names 81-83, 86 and 87, not these). None has code, a script or a table entry.

## Reserved and spare
- **489 ASPERTIA_CITY_GYM: reserved for Pearl's Hall of Origin** (Pearl map 510, Arceus; the user wants the event
  Pokémon in the game: Chapter 9 allocates it). Nothing in code, scripts or tables names 489.
- Spares, if another place ever needs a zone (cleanest first): 605 VILLAGE_BRIDGE_9 (a Memory Link zone: nothing names
  it), 253 DRIFTVEIL_DRAWBRIDGE (no table entry), 263 MARVELOUS_BRIDGE and 250 BRIDGE_GATE (a fog entry only),
  609-613 (Underground Ruins and the Regi chambers: only their own Unova scripts name them).
- Not spares: 147 UNITY_TOWER and 235 LIBERTY_GARDEN (Unova scripts warp there), 488 CASTELIA_CITY_GYM_2 and 604
  GIANT_CHASM_6 (gimmicks), 602 VICTORY_ROAD_27 (Chargestone Cave's script names it); and everything reachable or
  wanted: Union Room 422/150/151, PWT 191-193 (the Battle Frontier, Chapter 9), Musical 75-78 (Contests become the
  Musical), Join Avenue 490/491, Pokéstar Studios, Hidden Grotto 518 (the Underground's Hideaways use it,
  DECISIONS 2026-10-19), Royal Unova, Battle Subway, Black Tower / White Treehollow, Memory Link 597-607.
- **The Entralink's zones are kept but not wanted** (corrected 2026-10-26: this list said "Entralink 518 (the
  C-Gear)"; 518 is the Hidden Grotto): the C-Gear and its extras, the Entralink included, go (DECISIONS
  2026-10-19: the Pokétch replaces the C-Gear). Its 38 zones, 279 ENTRALINK, Entree Forest 280-288 and the gate
  copies 289-316, stay out of Sinnoh only because Black 2's code treats them specially (GetZoneIsEntralinkAny,
  GetZoneIsEntreeForest, the edge colours, the intrude code). Freeing them would need those checks changed in C;
  appended zones make that unnecessary.

## The table
Counted: 615 zones; 450 used by Sinnoh; free: none; kept: 165 (appended zones 616+ are not in this table)

| zone | Black 2 name | kept as | code naming it | Black 2 scripts naming it | zone-keyed tables |
|---|---|---|---|---|---|
| 0 | BLACK_CITY | DENY | townmap.c, townmap_util.c, zonedata.c | - | - |
| 1 | BLACK_CITY_POKEMON_CENTER | AVOID | zonedata.c | chargestone_cave_5 | - |
| 2 | BLACK_CITY_2 | AVOID | zonedata.c | - | - |
| 3 | BLACK_CITY_3 | AVOID | zonedata.c | - | - |
| 4 | BLACK_CITY_4 | AVOID | zonedata.c | - | - |
| 5 | BLACK_CITY_5 | AVOID | zonedata.c | - | - |
| 28 | CASTELIA_CITY | AVOID | zonedata.c, zukan_common.c, zukan_habitat.c | - | - |
| 30 | CASTELIA_CITY_2 | AVOID | zonedata.c | - | - |
| 36 | CASTELIA_CITY_8 | AVOID | demo3d_data.c, zonedata.c | liberty_garden | - |
| 40 | CASTELIA_CITY_12 | AVOID | demo3d_data.c, event_mapchange.c | - | - |
| 52 | ROYAL_UNOVA | DENY | zonedata.c | castelia_city_11 | - |
| 66 | GEAR_STATION | AVOID | zonedata.c | - | - |
| 67 | GEAR_STATION_2 | AVOID | zonedata.c | battle_subway, battle_subway_2 | gimmick 16 |
| 68 | GEAR_STATION_3 | AVOID | zonedata.c | battle_subway, battle_subway_2 | gimmick 17 |
| 69 | GEAR_STATION_4 | AVOID | zonedata.c | battle_subway, battle_subway_2 | gimmick 18 |
| 70 | GEAR_STATION_5 | AVOID | zonedata.c | battle_subway, battle_subway_2 | gimmick 19 |
| 71 | GEAR_STATION_6 | AVOID | zonedata.c | battle_subway, battle_subway_2 | gimmick 20 |
| 72 | GEAR_STATION_7 | AVOID | zonedata.c | battle_subway, battle_subway_2 | gimmick 21 |
| 73 | GEAR_STATION_8 | AVOID | zonedata.c | battle_subway, battle_subway_2 | gimmick 22 |
| 75 | BATTLE_SUBWAY | DENY | zonedata.c | battle_subway, battle_subway_2, global_10330 | gimmick 23 |
| 76 | BATTLE_SUBWAY_2 | DENY | zonedata.c | battle_subway | gimmick 24 |
| 78 | MUSICAL_THEATER_2 | DENY | zonedata.c | - | - |
| 81 | NIMBASA_CITY_5 | DENY | zonedata.c | nimbasa_city_3 | - |
| 82 | NIMBASA_CITY_6 | DENY | zonedata.c | nimbasa_city_3 | - |
| 83 | NIMBASA_CITY_7 | DENY | zonedata.c | nimbasa_city_3 | - |
| 86 | NIMBASA_CITY_10 | DENY | zonedata.c | nimbasa_city_8 | - |
| 87 | NIMBASA_CITY_11 | DENY | zonedata.c | nimbasa_city_8 | - |
| 114 | ICIRRUS_CITY_2 | AVOID | zonedata.c | floccesy_town_5 | gimmick 9, fog |
| 121 | OPELUCID_CITY_GYM | AVOID | zonedata.c | - | gimmick 10 |
| 136 | POKEMON_LEAGUE | AVOID | event_mapchange.c | victory_road_2 | - |
| 137 | POKEMON_LEAGUE_2 | AVOID | zonedata.c | pokemon_league_5, pokemon_league_6, pokemon_league_7, pokemon_league_8 | gimmick 14 |
| 138 | POKEMON_LEAGUE_3 | AVOID | zonedata.c | - | gimmick 15 |
| 140 | POKEMON_LEAGUE_5 | AVOID | zonedata.c | - | gimmick 39, fog |
| 141 | POKEMON_LEAGUE_6 | AVOID | zonedata.c | - | gimmick 40 |
| 142 | POKEMON_LEAGUE_7 | AVOID | zonedata.c | - | gimmick 41 |
| 143 | POKEMON_LEAGUE_8 | AVOID | zonedata.c | - | gimmick 42 |
| 144 | POKEMON_LEAGUE_9 | AVOID | zonedata.c | - | gimmick 46 |
| 147 | UNITY_TOWER | AVOID | - | castelia_city_9 | - |
| 150 | UNION_ROOM_COLOSSEUM | DENY | union_subproc.c, zonedata.c | - | - |
| 151 | UNION_ROOM_COLOSSEUM_2 | DENY | union_subproc.c, zonedata.c | - | - |
| 155 | PINWHEEL_FOREST_2 | AVOID | shinka_check.c | - | fog |
| 157 | DESERT_RESORT | AVOID | zonedata.c, zukan_common.c, zukan_habitat.c | - | gimmick 25 |
| 158 | DESERT_RESORT_2 | AVOID | event_mapchange.c | - | - |
| 191 | PWT | DENY | - | plasma_frigate | - |
| 192 | PWT_2 | DENY | - | global_10665, pwt | gimmick 51 |
| 193 | PWT_3 | DENY | zonedata.c | global_10655 | gimmick 36 |
| 195 | CHARGESTONE_CAVE_2 | AVOID | field_gimmick_d06.c, shinka_check.c | - | gimmick 13, fog, ISS dungeon |
| 196 | CHARGESTONE_CAVE_3 | AVOID | field_gimmick_d06.c, shinka_check.c | - | gimmick 13, fog, ISS dungeon |
| 197 | CHARGESTONE_CAVE_4 | AVOID | field_gimmick_d06.c, shinka_check.c | - | gimmick 13, fog, ISS dungeon |
| 203 | TWIST_MOUNTAIN_6 | AVOID | shinka_check.c | - | fog |
| 209 | DRAGONSPIRAL_TOWER_5 | AVOID | zonedata.c | - | - |
| 211 | DRAGONSPIRAL_TOWER_7 | AVOID | zonedata.c | - | - |
| 214 | VICTORY_ROAD_2 | AVOID | zonedata.c | - | fog, ISS fade |
| 235 | LIBERTY_GARDEN | AVOID | - | castelia_city_8 | - |
| 241 | ABYSSAL_RUINS | DENY | zonedata.c | - | - |
| 242 | ABYSSAL_RUINS_2 | DENY | zonedata.c | - | - |
| 243 | ABYSSAL_RUINS_3 | DENY | zonedata.c | - | - |
| 244 | ABYSSAL_RUINS_4 | DENY | zonedata.c | - | - |
| 245 | ABYSSAL_RUINS_5 | DENY | zonedata.c | abyssal_ruins_6 | fog |
| 246 | ABYSSAL_RUINS_6 | DENY | zonedata.c | abyssal_ruins_5, abyssal_ruins_7 | fog |
| 247 | ABYSSAL_RUINS_7 | DENY | zonedata.c | abyssal_ruins_6, abyssal_ruins_8 | fog |
| 248 | ABYSSAL_RUINS_8 | DENY | zonedata.c | abyssal_ruins_7 | fog |
| 249 | SKYARROW_BRIDGE | AVOID | zonedata.c | - | gimmick 1, fog, ISS fade |
| 250 | BRIDGE_GATE | AVOID | - | - | fog |
| 253 | DRIFTVEIL_DRAWBRIDGE | AVOID | - | - | - |
| 254 | TUBELINE_BRIDGE | AVOID | - | - | gimmick 11, fog |
| 255 | VILLAGE_BRIDGE | AVOID | zonedata.c, zukan_common.c, zukan_habitat.c | village_bridge_9 | - |
| 263 | MARVELOUS_BRIDGE | AVOID | - | - | fog |
| 279 | ENTRALINK | DENY | zonedata.c | - | gimmick 29 |
| 280 | ENTREE_FOREST | DENY | zonedata.c, Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 281 | ENTREE_FOREST_2 | DENY | Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 282 | ENTREE_FOREST_3 | DENY | Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 283 | ENTREE_FOREST_4 | DENY | Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 284 | ENTREE_FOREST_5 | DENY | Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 285 | ENTREE_FOREST_6 | DENY | Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 286 | ENTREE_FOREST_7 | DENY | Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 287 | ENTREE_FOREST_8 | DENY | Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 288 | ENTREE_FOREST_9 | DENY | zonedata.c, Entree Forest range (GetZoneIsEntreeForest) | - | - |
| 289 | NIMBASA_CITY_GATE | DENY | zonedata.c, gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 290 | DRIFTVEIL_CITY_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 291 | MISTRALTON_CITY_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 292 | ICIRRUS_CITY_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 293 | OPELUCID_CITY_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 294 | BLACK_CITY_GATE | DENY | zonedata.c, gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 295 | WHITE_FOREST_GATE | DENY | zonedata.c, gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 296 | COLD_STORAGE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 297 | CHARGESTONE_CAVE_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 298 | TWIST_MOUNTAIN_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 299 | DRAGONSPIRAL_TOWER_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 300 | GIANT_CHASM_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 301 | DRIFTVEIL_DRAWBRIDGE_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 302 | TUBELINE_BRIDGE_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 303 | MARVELOUS_BRIDGE_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 304 | ROUTE_5_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 305 | ROUTE_6_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 306 | ROUTE_7_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 307 | ROUTE_8_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 308 | ROUTE_9_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 309 | ROUTE_11_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 310 | ROUTE_12_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 311 | ROUTE_13_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 312 | ROUTE_14_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 313 | ROUTE_15_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 314 | ROUTE_16_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 315 | LACUNOSA_TOWN_GATE | DENY | gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 316 | UNDELLA_TOWN_GATE | DENY | zonedata.c, gate range = Entralink (GetZoneIsEntralinkAny) | - | - |
| 317 | ROUTE_1 | AVOID | beacon_detail_sub.c, zukan_common.c, zukan_habitat.c | - | gimmick 32 |
| 326 | ROUTE_4 | AVOID | dowsing.c, field_encount_st.c, townmap.c, zonedata.c, zukan_common.c, zukan_habitat.c | global_10685 | gimmick 25 |
| 337 | ROUTE_7 | AVOID | field_encount_st.c, local_tvt_calldata.c, zone_weather.c, zukan_common.c, zukan_habitat.c | - | - |
| 338 | CELESTIAL_TOWER_2 | AVOID | zonedata.c, zukan_common.c, zukan_habitat.c | - | - |
| 339 | CELESTIAL_TOWER_3 | AVOID | zonedata.c | - | - |
| 340 | CELESTIAL_TOWER_4 | AVOID | zonedata.c | - | - |
| 341 | CELESTIAL_TOWER_5 | AVOID | zonedata.c | - | - |
| 374 | ROUTE_14 | AVOID | field_encount_st.c, local_tvt_calldata.c, zonedata.c, zukan_common.c, zukan_habitat.c | - | - |
| 378 | ROUTE_15 | AVOID | field_encount_st.c, zonedata.c, zukan_common.c, zukan_habitat.c | - | - |
| 418 | ANVILLE_TOWN | AVOID | zonedata.c | global_10330 | ISS city |
| 422 | UNION_ROOM | DENY | event_mapchange.c, townmap_util.c, union_actor.c, union_subproc.c, zonedata.c | - | - |
| 424 | WHITE_FOREST | DENY | townmap.c, townmap_util.c, zonedata.c | - | - |
| 425 | WHITE_FOREST_POKEMON_CENTER | AVOID | zonedata.c | chargestone_cave_5 | - |
| 426 | WHITE_FOREST_2 | AVOID | zonedata.c | - | - |
| 428 | ASPERTIA_CITY_2 | DENY | - | aspertia_city | - |
| 455 | VIRBANK_CITY_GYM | AVOID | gym_virbank.c | - | gimmick 37 |
| 464 | MARINE_TUBE | AVOID | zonedata.c | - | gimmick 50, fog |
| 478 | WHITE_TREEHOLLOW | DENY | game_beacon_accessor.c, infinity_dungeon_gimmick.c, infinity_dungeon_rooms.c, townmap_util.c | white_forest | gimmick 35 |
| 479 | BLACK_TOWER | DENY | game_beacon_accessor.c, infinity_dungeon_gimmick.c, infinity_dungeon_rooms.c | black_city | gimmick 35 |
| 480 | WHITE_TREEHOLLOW_2 | DENY | infinity_dungeon_gimmick.c, infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 481 | BLACK_TOWER_2 | DENY | infinity_dungeon_gimmick.c, infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 482 | WHITE_TREEHOLLOW_3 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 483 | BLACK_TOWER_3 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 484 | BLACK_TOWER_4 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 485 | WHITE_TREEHOLLOW_4 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 486 | BLACK_TOWER_5 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35, flash |
| 487 | WHITE_TREEHOLLOW_5 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 488 | CASTELIA_CITY_GYM_2 | DENY | - | castelia_city_gym | gimmick 6 |
| 489 | ASPERTIA_CITY_GYM | DENY | - | - | - |
| 490 | JOIN_AVENUE | DENY | townmap.c, zonedata.c | global_10685, join_avenue_2 | gimmick 33 |
| 491 | JOIN_AVENUE_2 | DENY | zonedata.c | global_10685, join_avenue | gimmick 34 |
| 492 | WHITE_TREEHOLLOW_6 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 493 | BLACK_TOWER_6 | DENY | infinity_dungeon_rooms.c, zonedata.c | - | gimmick 35 |
| 495 | CASTELIA_SEWERS | AVOID | event_mapchange.c, zukan_common.c, zukan_habitat.c | - | fog |
| 502 | VIRBANK_CITY_GYM_2 | AVOID | gym_virbank.c | - | gimmick 37 |
| 518 | HIDDEN_GROTTO | DENY | dowsing.c, townmap_util.c, zonedata.c | - | - |
| 551 | ROUTE_4_16 | AVOID | dowsing.c, zonedata.c | - | gimmick 25 |
| 561 | PLASMA_FRIGATE_10 | AVOID | zonedata.c | plasma_frigate_3, plasma_frigate_4, plasma_frigate_6 | gimmick 43 |
| 564 | PLASMA_FRIGATE_13 | AVOID | zonedata.c | plasma_frigate_3, plasma_frigate_4, plasma_frigate_6 | gimmick 43 |
| 566 | POKESTAR_STUDIOS | AVOID | zonedata.c | global_10865 | gimmick 49 |
| 573 | VICTORY_ROAD | DENY | event_mapchange.c, zonedata.c, zukan_common.c, zukan_habitat.c | - | gimmick 44 |
| 586 | POKESTAR_STUDIOS_5 | AVOID | - | pokestar_studios | - |
| 597 | STRIATON_CITY_10 | DENY | zonedata.c | striaton_city_2 | - |
| 598 | NACRENE_CITY_11 | DENY | zonedata.c | nacrene_city_2 | - |
| 599 | UNDELLA_TOWN_5 | DENY | zonedata.c | mistralton_city | - |
| 600 | FLOCCESY_TOWN_5 | DENY | zonedata.c | icirrus_city_2 | - |
| 601 | OPELUCID_CITY_12 | DENY | zonedata.c | opelucid_city | - |
| 602 | VICTORY_ROAD_27 | DENY | - | chargestone_cave_5 | - |
| 603 | DRIFTVEIL_CITY_17 | DENY | zonedata.c | driftveil_city_6 | - |
| 604 | GIANT_CHASM_6 | DENY | - | giant_chasm_6 | gimmick 52, fog |
| 605 | VILLAGE_BRIDGE_9 | DENY | - | - | - |
| 606 | MUSICAL_THEATER_3 | DENY | zonedata.c | musical_theater | - |
| 607 | CHARGESTONE_CAVE_5 | DENY | zonedata.c | global_2100 | - |
| 609 | UNDERGROUND_RUINS_2 | AVOID | - | underground_ruins | - |
| 610 | UNDERGROUND_RUINS_3 | AVOID | - | underground_ruins | - |
| 611 | ROCK_PEAK_CHAMBER | AVOID | - | underground_ruins | - |
| 612 | ICEBERG_CHAMBER | AVOID | - | underground_ruins | - |
| 613 | IRON_CHAMBER | AVOID | - | underground_ruins | - |
| 614 | PLEDGE_GROVE | AVOID | game_beacon_accessor.c, zonedata.c | - | gimmick 57 |
