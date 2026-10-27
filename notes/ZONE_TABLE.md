# Growing the zone table past Black 2's 615 zones (research and plan, 2026-10-26)

Asked by the lead (DECISIONS 2026-10-26, chapter 9a: "zones are short: a zone-table study started"). Nothing is
changed yet: this is the study and a plan for the lead and the user to decide on.

## Answer
**Yes, zones can be appended, and it costs almost nothing.** The zone count lives in one data file (a/0/1/2 file 0,
615 x 0x30 B) that the game reads by offset with no bound. No array in code or data is sized by the zone count,
every zone-keyed table is a searched list, and every saved zone id is 16 bits. What has to be respected:
- **615 (0x267) is Black 2's "no zone" value** in 9 places. Keep it: zone 615 becomes a dummy header that nothing uses,
  and new zones start at **616**.
- **Stay at or below 1023.** The game beacon (the C-Gear / passerby broadcast) carries the zone in 10 bits, and the
  receiving game drops any beacon whose zone is 615 or higher. Nothing else is narrower than 11 bits.
- Never use 0x7FF or 0xFFFF: zone_effects.py, the dowsing code and the matrices use them as "no zone".

With that, **no C change is needed**: PearlB2 never sends a game beacon (checked: plan step 6), and a same-size
change is ready if it ever does. Saves and the link with HoennB2 need nothing.

## Where a zone id matters (decomp external/pokebw2, 1207 of 1218 files complete)

### The header archive and its loader
| What | Where | Width / bound | Zones 616+ |
|---|---|---|---|
| Zone headers a/0/1/2 (`ARCID_ZONEDATA` 12), one file, 615 x 0x30 | `src/system/zonedata.c` `ZoneData_GetHeaderCore`: `GFL_ArcToolReadRange(arc, 0, zoneId * 0x30, 0x30)` | none: `GFL_ArcToolReadRange` checks only the file id (`src/gfl/arc_tool.c:251`), not the offset | append headers to file 0 (`zoneheaders.save` already writes any length) |
| `ZONE_COUNT` (= `ZONE_PLEDGE_GROVE + 1`) | zonedata.c:30, used once: the header cache key starts at 615 (`InitZoneDataSystem`) | sentinel | zone 615 must stay unused (its first read returns the zeroed cache) |
| Everything else per zone | the header's own fields: area, matrix, scripts, init scripts, text, 4 BGMs, encounters (13 bits), entities, parent zone, place name (10 bits), weather, camera, fades, battle background (5 bits), flags, camera boundary, Fly point | file ids, not zone ids | a new zone points at its own (or shared) files, as the rooms do today |

No other per-zone array exists. A size scan of every NARC of the dump for 615/616-entry tables (1, 2, 4 ... 48-byte
entries) finds only a/0/1/2 file 0 (the other hits are graphics and scripts of coincidental size); HoennB2's own scan
(RESEARCH_WORLD.md) found the same. a/1/2/6 (entities, 616 files) is indexed by the header's `entities` field.

### Zone-keyed tables: all searched lists (no change, no bound)
| Table | Code | Entry |
|---|---|---|
| Gimmick a/1/0/2 | ov035 `GameData_SetGimmickByZone` | `u32 zoneId, u16 gimmickId`, count = file size |
| Fog a/0/8/0 #29, light a/0/8/1 #1, Flash a/1/4/9 | zonedata.c (`fogCount` u16, `lightCount`/`flashCount` u8 = entries, not ids) | `u16 zone, u16 value` |
| ISS zone / city / switch / dungeon / 3D | `system/iss_*` | u16 zone lists (`ISS_ZONE_NONE` 0xff is an entry index) |
| Calendar weather a/0/9/6 | ov012 calender.c, 24 entries | u16 |
| Rails, cameras | zonedata.c `ZONE_RAIL_ASSIGNMENTS`, `ZONE_CAMERA_ASSIGNMENTS` | `zoneId : 11` (to 2047; 0x7FF = none in zone_effects) |
| Map replace a/0/1/0 | ov012 map_replace.c | matrix/chunk ids, no zone |
| Fly / respawn | ov012 respawn_zone.c `RESPAWN_ZONE_INFO[82]` | u16 |
| Town map | ov144 townmap_data.c (searched records); PearlB2's file 21 zone table | see "PearlB2's own tables" |
| Hidden items, dowsing, roamers, N's Pokémon, Xtransceiver, Funfest, PWT, Battle Subway, Abyssal Ruins | their own const lists of Unova zones | u16 (N's `firstZone : 14`) |
| Range checks | zonedata.c Entree Forest 279-287, gates 288-316 | bounded both ways: ids above 614 never match |

### The "no zone" value 615 (0x267): every use
zonedata.c:233 (header cache key), system/player_savedata.c:23 (`placeNameZoneId` of a new save), ov036
field_place_name.c:796-797 (banner's previous/requested zone), ov036 field_bbd_color.c:80/90 (Abyssal Ruins dive: none),
ov104 field_gimmick_gate.c:663/975/986/1003/1011 and gimmick_obj_elboard.c:374 (Unova gate boards: empty slot), ov012
game_beacon_search.c:118 (set, never compared). Range checks: system/game_beacon_accessor.c:296 `BEACON_ZONE_COUNT`
(beacon invalid if zone or parent >= 615), ov308 beacon_detail_sub.c:39/338/529 (a received beacon >= 615 shows
Route 1's name and no map marker). HoennB2 RESEARCH_WORLD.md lists the same spots by address.
With zone 615 kept as a dummy header (place 0, no scripts, people, encounters or table entries, in no matrix), each of
these behaves as now. The banner and the new-save value read zone 615's header, which in Black 2 runs past the end of
the file; with the dummy they read place 0 instead.

### Stored zone ids: widths (saves need no change)
| Where | Width |
|---|---|
| `ZoneSpawnInfo.zoneId` (save: now / next / escape-rope / unk spawn; Entralink parent, outbound warp) | s16 |
| PlayerSave `zoneId`, `returnZoneId`, `placeNameZoneId`; field actor save; roamers; Pokédex habitat save | u16 |
| GimmickState (save block 0x30) | a gimmick id, not a zone |
| Battle field status (`BtlFieldStatus.zoneId`, also in battle videos) | u16 |
| Matrix zone layer | u32 per cell in the file, u16 in RAM (`MapMatrix.zoneIds[900]`); 0xFFFF = keep the zone |
| Script commands and vars (FieldSetNextZone, warps, RTGetZoneID) | u16 |
| Game beacon `zoneId : 10`, `parentZoneId : 10` (include/system/game_beacon.h) | **10 bits**, broadcast to others |
| `ZoneAssignment.zoneId : 11` | 11 bits (const tables only) |

A save made in a new zone needs a ROM that has that zone, as with any new room. The save layout does not change.

### Met locations are not zones
A Pokémon's met location is the place-name id from the zone header (`ZoneData_GetPlaceNameID`, called by the
catch, the egg hatch and the in-game gifts), not the zone id. New zones reuse Sinnoh's place lines (154-264, sinnoh_names),
so the met-location registry agreed with HoennB2 (notes/LINK.md) is unaffected.

### Link: Union Room, trades, battles, beacons, HoennB2
- Union Room (ov028/ov034 union_*): only checks "am I in the Union Room" (`GetZoneIsUnionRoom`). No zone id is sent.
- Trades and link battles: Pokémon data (met location = place id) and battle rules; no zone id is sent.
- **Game beacon**: `GameBeacon_Init` (game_beacon.c:715) and `GameBeacon_UpdateZone` (:1129) put the player's zone and
  its town-map zone in the beacon. A receiver (another PearlB2, HoennB2, a retail Black 2) drops a beacon whose zone
  is 615 or higher (`GameBeacon_IsInvalid`). Effect: a PearlB2 player in a new zone is invisible to beacon scans
  (C-Gear passerby / Entralink lists) until they leave it. Nothing else. PearlB2 never sends one: the C-Gear
  is never switched on (plan step 6).
- HoennB2 needs nothing: no zone id crosses in a trade or battle, and zone ids already name different places in the two
  games (zone 300 is a Sinnoh room here and a Hoenn place there).

### PearlB2's own zone tables
All are sized from `len(headers)` at build time and bounds-checked in the code, so they grow by themselves once the
headers are appended before them (they all run after sinnoh_rooms in the build list):
season_weather.py (`zoneCount`, `zoneKind[]`; zones past the table get no weather), town_map.py (file 21 zone table,
`nz` bound in `find_entry_code`), sinnoh_pokedex.py / src/code/dex_area.c (`N_ZONES`, `kZonePlace[]`). The others
(battle_season, evolve_place, pearl_platforms, gimmick, zone_effects) are zone lists.

## Costs of appending
| Item | Cost |
|---|---|
| C / ITCM | none. A beacon clamp (about 20 B of ITCM + two same-size call changes) only if the C-Gear comes back |
| Data | +0x30 B per zone in a/0/1/2; each room's own matrix, chunks, scripts, text and entity files as today |
| Saves | none (16-bit fields) |
| Link (HoennB2, retail) | none; with the clamp, beacons stay valid for every receiver |
| Tooling | a header-append step, an allocation pool, an audit of the ~25 tools that load headers (below) |
| Test | one build, one short test in a new zone |

Other limits a new room still meets (not the zone count): areas are capped at 409 (`AREA_COUNT`, area_data.c; 43
interior ids are free today: 329, 347, 355-357, 359-367, 369-377, 380, 382-392, 401-408, and rooms of one Pearl area
share one); a matrix holds at most 900 cells; 30 NPC sprite codes per zone; flags and works.

## Cheaper alternatives, compared
1. **One zone for rooms that are never the same place** (the shared Pokémon Center 2F pattern: one zone, the stairs
   down return through the "next zone" warp 0x100). Works only where the rooms share a layout and their people can be
   set by script. It costs scripting per room and a risk at Continue (the save restores the zone, not which room it
   stood for). Good for a few look-alike rooms (some Turnback Cave rooms), not as the general answer.
2. **Free more Unova zones.** The candidates are blocks whose feature PearlB2 drops, but each is named by code:
   the Entralink block 279-316 (38 zones: `GetZoneIsEntralinkAny`, `GetZoneIsEntreeForest`, the edge-colour check, the
   intrude code), Black Tower / White Treehollow 478-487, 492, 493 (12: infinity_dungeon_*), Battle Subway 66-76. Each
   needs a feature decision (ZONES_KEPT.md still lists the Entralink as wanted, against DECISIONS 2026-10-19) and C
   edits in several files. That is more work and more risk than appending, and it removes Black 2 content.
3. **One zone with several layouts** (map replace a/0/1/0 by event work). It swaps matrices and chunks only, not
   people or warps. Narrow.

## The plan (decided 2026-10-26: DECISIONS) and where it stands
Append zones from 616 (up to 1023), keep 615 as the no-zone dummy, and allocate the new features there. The 165 kept
Black 2 zones stay as they are.

**Blocks** (b2tools/allocate_sinnoh.py `APPEND_BLOCKS`; a feature's Pearl maps go in `APPENDED`, map name -> zone):
| Zones | Feature | Pearl maps (not allocated yet) |
|---|---|---|
| 615 | Black 2's "no zone": the dummy header, never a place | - |
| 616-622 | Battle Tower | elevator, corridors (multi, Wi-Fi), arenas (multi, Wi-Fi), partner room (the lobby is on 443) |
| 623-632 | Turnback Cave | allocated 2026-10-26 (b2tools/turnback.py): 623 pillar room, 624 Giratina's room, 625-632 the random rooms by layout and wild tier (two of Pearl's rooms per zone); the entrance is on 382 |
| 633-651 | the Underground (19) | the tunnels and the Hideaways (Pearl's Underground is zone 2, matrix 2) |
| 652-660 | Ramanas Park (9) | Shining Pearl's 9 slate rooms (the user, 2026-10-26) |
| 661-662 | Ramanas Park, Diamond version only | Brilliant Diamond's Johto and Rainbow Rooms, for the planned Diamond version of PearlB2 (`DIAMOND_ONLY`: a Pearl build refuses them) |
| 663-664 | Turnback Cave (2) | (the lead, 2026-10-26: Pearl's maze needs 12 zones) 663 Random Room 17, 664 Random Room 14 (no wild Pokémon in Pearl) |
| 665- | the next feature | ask the lead |

**Reserved Black 2 areas** (`RESERVED_AREAS`): the Underground reuses Black 2's own rooms with their areas, 388
(Reversal Mountain 8-13's interior area) and 198-201 (the Moor of Icirrus' seasonal group). Their zones are Sinnoh
places, so nothing else kept these areas out of the free lists: allocate_sinnoh (room areas, overworld groups) and
sinnoh_rooms' `free_season_groups` (outdoor rooms) now skip them. Checked: today's numbers are unchanged (room areas
end at 354, outdoor-room groups at 154-157).

Done (tree `zones`, not built yet):
1. **Ids**: `zoneheaders.check_zone` accepts 0-614 and 616-1023 only (never 615, 0x7FF, 0xFFFF); `B2_ZONES`, `NO_ZONE`,
   `FIRST_APPENDED`, `LAST_APPENDED` in b2tools/zoneheaders.py.
2. **zoneheaders.py**: `extend(headers, n)` appends the dummy for 615 and blank headers up to n; `blank(zone)` is a
   copy of Black 2's Floccesy house (441, the rooms' building template) with the empty script / init / entity files,
   no wild Pokémon, place 0, no camera boundary, no preloaded sprites, itself as parent. `zones_needed(world)` = one
   past the highest zone of sinnoh_world.json.
3. **sinnoh_world.py** (the first zone patch of the build list) extends the header file before anything indexes it,
   to the end of the last reserved block (`APPEND_END`, 665 since Turnback Cave's second block: 50 headers, 2.4 KB), so that the features whose
   rooms are not Pearl maps (the Hideaways, Ramanas Park) find a blank header to fill in their own patches; its
   report says how many headers were appended. sinnoh_rooms, sinnoh_events, zone_flags, sinnoh_names, ... then
   find every zone as before.
4. **allocate_sinnoh.py**: `APPENDED` rooms are allocated last (after the Great Marsh's cell zones), each as a
   script-Warp room is (its matrix, area, chunks, furniture: the shared `install()`), listed in `rooms['appended']`;
   a zone outside 616-1023 or outside its block stops it. **Released numbers never move**: `keep_released()` puts
   back every value the committed sinnoh_world.json has, and `check_unique()` refuses a zone, matrix, chunk, area or
   building id used twice. (A fresh run today gives two furniture ids the other way round, models 151 and 517: 98 and
   290 since commit cacb015; the guard keeps the committed ones and says so.)
   Proof: against HEAD's data/sinnoh_world.json, all 4107 old values are the same and the only new key is
   `rooms/appended` (empty). A dry run with three test entries (Battle Tower partner room on 616, Turnback's pillar
   and Giratina rooms on 623/624) also left all 4107 unchanged and added only those rooms, their matrices (622-624)
   and chunks; zone 615 was refused.
5. **The tools audit** (the 28 files of b2tools, patches and hwtest that call `zoneheaders.load`): they index the
   build's own headers, which sinnoh_world has extended, or a vanilla list for a template zone (441, 324, 437, 427).
   Fixed: zone_flags' offline table (`vanilla[z]` for every place: a blank header past 615). Unaffected:
   season_weather, town_map, sinnoh_pokedex (sized from the build's header count, bounds-checked); sinnoh_rooms'
   season groups (the blank's area 349 is not a seasonal record); check_exits.py (a HoennB2 tool, Sapphire's world).
6. **Beacon (C): not needed.** PearlB2 never broadcasts a game beacon: only the beacon-search communication sends it
   (`GSYS_TryBootGameComm`, src/system/game_system.c: needs the C-Gear on), the C-Gear is switched on only by script
   command 0x197 `CGearPowerOn` (only Black 2's own aspertia_city.s uses it; no PearlB2 script does) or by Continue's
   "C-Gear on" (offered only once that command has run: ov162 startmenu.c), and its default is off (config.c). If
   the C-Gear or the Entralink ever comes back, do the clamp first: in `GameBeacon_Init` and `GameBeacon_UpdateZone`,
   change the call to `IsZoneBlackCityOrWhiteForestLobby(zoneId)` to an ITCM `PearlB2_BeaconUsesTownZone(zoneId)`
   (= that check, or `zoneId >= 615`), so the beacon carries the town-map zone; same size, only the call target.

7. **Tested in game (2026-10-26, DeSmuME)**: a build with Oreburgh Gate 1F moved to zone 616 for the test only
   (one value of sinnoh_world.json, restored after; the ROM, states and battery are in the Trash). The header file
   had 663 zones (48 appended: 615 the dummy, 616 Oreburgh Gate 1F's, the rest blank). Shots:
   work/agents/zones/shots/zone616_*.png.
   - TEST_START=616,20,22: the room, its people and its trainers are there; Picnicker Diana's eye contact starts her
     battle on the cave background (Pearl's cave: zone 616's flags); losing it blacks out to the player's home.
   - Warps: out of the west exit to Route 203 (zone 329, (246, 749)), back in from Route 203 (arriving in 616 at
     (4, 22)) and out again; the hiker's Rock Smash scene in 616 runs as before.
   - Save inside 616, then a cold boot from that battery and Continue: back in 616 at (5, 22), the room drawn.
   - Escape Rope inside 616: out at the gate's mouth on Route 203 (329, (245, 749)).
   - Town Map from inside: "Oreburgh Gate" with the player's marker on it (the zone table of file 21 has 663 zones).
   - Pokédex from inside: the list, an entry and its area page open.
   - The place banner: its work (PlaceName, read from RAM) gets 616 as the previous zone and 329 as the new one on
     leaving, and the banner is requested, so the zone side works. **No banner shows, though, and that is not the
     zones: no Sinnoh place banner can show in any build.** `PlaceName_LoadMessage` (decomp src/ov036/
     field_place_name.c:588) turns a place line of 0x9a (154) or more into 0 and cancels the banner, and
     sinnoh_names puts every Sinnoh name on lines 154-264 (the met-location fix did the same bound for
     MetLocation_GetNameIndex, not for the banner). A same-size C change fixes it (as the met-location one: lines
     0-511 show); left to the lead.

## Open checks
1. HoennB2 can use the same approach for its own shortage. Its RESEARCH_WORLD.md "Unknown 4" (are ids >= 615 safe in
   saves and records?) is answered above: yes, apart from 615 itself and the 10-bit beacon. It is not changed from here.
