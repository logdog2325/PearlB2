# Pokémon Pearl NDS: feasibility report and plan (Phase 0, 2026-10-18)

Model: HoennB2 `notes/EMERALD_PLAN.md`. Tags: **[measured]** = read from the dump or a decomp today; **[code]** = read in
pokebw2's decompiled C; **[HoennB2]** = known from HoennB2; **[guess]** = not yet checked.

## In short

- **It is feasible, and in most ways easier than Hoenn.** Pearl's maps are already DS 3D maps in the same building
  blocks as Black 2's (32x32-tile chunks, NSBMD models, NSBTX textures), so it is a 3D-to-3D conversion, not a rebuild
  from flat Gen 3 tiles. Pearl's music is already in Black 2's sound format.
- **Everything fits in Black 2's limits** except one building list (138 models, limit 128), which needs splitting.
- **The Pearl data we need is mostly not readable source in pokediamond** (maps, events, scripts, encounters are binary
  blobs there). It is readable from the dump with documented formats (pokeplatinum documents them all, and its JSON and
  script macros are near-identical). Text, trainers, items and the zone list *are* readable in pokediamond.
- **Seasons work, and Sinnoh suits them.** Black 2 picks a map's texture set from the zone you arrive in, every time
  you change maps [code]. So Sinnoh's snowy north can be fixed winter while the south changes with the month, without
  a separate map (which keeps Escape Rope working).
- **Nothing is built yet.** The first decisions are in `notes/START_HERE.md`.

## 1. Setup done today

| What | Where | Notes |
|---|---|---|
| Pearl dump | `roms/pearl.nds` (APFS clone of the Desktop file) | "POKEMON P", game code **APAE**, revision **5**, 64 MB, SHA-1 **99083bf15ec7c6b81b4ba241ee10abd9e80999ac** [measured] |
| Repo | `~/Documents/GitHub/PearlB2`, private, no remote | commits as `logdog2325 <226450061+logdog2325@users.noreply.github.com>` |
| pokediamond | `external/pokediamond` (shallow clone, code only) | last commit 2026-10-11 |
| pokeplatinum | `external/pokeplatinum` (shallow clone, code only) | last commit 2026-10-14 |
| pokebw2 | `external/pokebw2`, latest **fuddlesworth/pokebw2** (`45d3a72`, 2026-10-18); remote `fork` = logdog2325/pokebw2 | constants headers generated (section 5) |
| Tools | `b2tools/` seeded from HoennB2 `88d1d82` | list and changes in `notes/SETUP.md` |

`external/`, `roms/`, `work/` and `builds/` are git-ignored (game files and third-party code never get committed).

## 2. Pearl measured against Black 2's limits

| Thing | Pearl [measured] | Black 2 limit [HoennB2] | Verdict |
|---|---|---|---|
| Zones (map headers) | 559 (many are interiors and duplicates) | < 615 total | fits; HoennB2 reuses Black 2's zone slots, and Emerald fits with zones shared |
| Overworld matrix | 30x30 = 900 cells; land in all 30 columns, rows 5-29 (750 cells if trimmed); 468 cells hold chunks, 169 cells belong to 67 named zones | ≤ 900 cells | fits (at the limit untrimmed, 750 trimmed). Includes the Battle Zone |
| Other matrices | 245 in total (caves, buildings, Underground 15x15) | — | fine |
| Map chunks | 578, largest 66,712 B, average 25,558 B | ≤ 110,600 B each | fits with room (sizes change in conversion) |
| Buildings per area list | 55 lists; largest **138** (list 2), next 104 | ≤ 128 models per pack | **list 2 needs splitting or trimming** |
| Map textures per area | largest map set 46,320 B + largest building set 74,308 B ≈ 121 KB | ~200 KB VRAM budget | fits if Pearl's own textures are kept; with Black 2's textures measure per area |
| Script files / event files | 1,051 / 512 | archive reserves | fine |
| Music | one SDAT, 7.5 MB | same format | direct port |
| Cartridge | 64 MB | 512 MB (Black 2 uses 280 MB) | not a problem |

Anti-piracy: the hack runs on Black 2's code, so the check that matters is **Black 2's**, and HoennB2's
`b2tools/patches/antipiracy.py` (copied) handles it. Pearl's own copy protection doesn't ship in the hack. No
protection strings were found in the Pearl dump [measured; Pearl's is known to be weak].

## 3. Where Pearl's data comes from

| Data | pokediamond | pokeplatinum | Plan |
|---|---|---|---|
| Zone list / map headers | readable C (`arm9/src/map_header.c`, 559 zones with names) | readable | pokediamond |
| Matrices, events (warps, NPCs, signs, triggers) | binary only | readable JSON, formats documented (`docs/maps/file_format_specifications.md`) | read from the dump with Platinum's formats |
| Map chunks (models, collision, BDHC heights) | binary only | binary, documented | read from the dump |
| Field scripts | binary only (1,051 files, no disassembly) | readable `.s` with named commands | disassembler for the dump using Platinum's command macros |
| Text | readable `.gmm` (623 banks, English) | readable JSON | pokediamond |
| Trainers | readable JSON (`trdata.json`) | readable | pokediamond |
| Wild encounters (Pearl `p_enc_data`, 183) | binary only | JSON schema (day/night, radar, swarm, GBA slots) | read from the dump with Platinum's schema |
| Items, TMs, species data | readable JSON | readable | pokediamond |
| Music | one SDAT | readable sources | copy Pearl's SDAT songs |
| Sinnoh-only systems code | mostly assembly (41 C vs 198 .s in overlays) | readable C (Underground, Pokétch, Contests, Amity Square, Poké Radar, Great Marsh, Honey trees) | Platinum explains how they work; rebuild on Black 2 engines |

Notes:
- pokediamond special-cases Pearl's Spear Pillar: matrix 22 becomes 23 when the game is Pearl
  (`arm9/src/map_header.c:668`). Per-version details like this must come from the Pearl dump, not Diamond's data.
- Platinum's *content* (story, maps changed for Distortion World, Giratina) is never the source of Pearl's story. Only
  its formats and code are used.
- Step one of Phase 1 is a "Gen 4 reader" in `b2tools/` that dumps the matrices, events, scripts and encounters from the
  dump to JSON in Platinum's schema, then checks a sample against Platinum's files for the maps the two games share.
  `b2tools/gen4rom.py` (new, read-only) already reads the dump's file system and NARCs.

## 4. Seasons (the user's question of 2026-10-18)

**How Black 2 does it** [code + HoennB2 `notes/SEASONS.md`]:
- The season is the DS clock's month: `(month - 1) & 3`, so Jan/May/Sep spring, Feb/Jun/Oct summer, Mar/Jul/Nov autumn,
  Apr/Aug/Dec winter. It is set when the game starts and is not in the save.
- An area whose id is 2 to 281 (`AreaData_HasSeasons`, `src/system/area_data.c:67`) loads record `area + season`:
  its own texture set, lights, and (through the zone) encounter table and music for each season.
- **The area is chosen from the zone you arrive in, each time a map loads** (`Field_Create`, `src/ov036/fieldmap.c:279`:
  `ZoneData_GetAreaID(zoneId)`), not per matrix. Walking between zones does not reload it.

**What that means for Sinnoh:**
- The south (Twinleaf to Hearthome, Veilstone, Pastoria, Sunyshore, the Battle Zone) gets one seasonal area: four
  texture sets, using Black 2's seasonal version of each texture where one exists, as HoennB2's study did.
- The snowy north (Routes 216 and 217, Acuity Lakefront, Snowpoint) gets a second area that is snowy all year (four
  identical winter records, or a non-seasonal area). In Pearl the north is reached only through Mt. Coronet or by Fly,
  that is, always by a map load, so each side always loads its own area.
- Both stay on the **one overworld matrix**. That matters: Black 2 records the Escape Rope exit only when you leave
  matrix 0 (`src/ov035/event_mapchange.c:1248`, `GetIsZoneMatrix0`). A separate snow matrix would break Escape Rope in
  caves entered from the north.
- The north's chunks must not be visible from the south's (the far edge would show with the wrong set). Pearl's own
  layout already separates them with Mt. Coronet [guess: check the matrix rows when the converter exists].
- Cost: building texture sets for both areas from the start. HoennB2 found this cheap (about 72 KB per set, inside the
  budget). Retrofitting later would mean redoing every area's sets.
- Lights and night start follow Black 2's table per season (winter nights start at 19:00, summer at 21:00).
- Wild Pokémon: Black 2 reads one table per season if a zone's file has four. Pearl has one set (morning/day/night),
  so the default is the same Pokémon all year; seasonal tables are an option.
- Season card: HoennB2 removed it on Continue and new game (user's choice). Same here by default.
- Caves and rooms are not seasonal (fixed areas).

**Open:** whether Black 2 also swaps whole winter chunks (a/0/1/0, keyed by matrix) for snow on routes. HoennB2 found
Black 2's snow comes from such swaps and a snow decal, not from the texture sets. For Sinnoh's south a mild winter (no
snow, as in HoennB2) is the simple default; a snowy southern winter is a later option.

## 5. pokebw2 (Black 2 decomp) today

- 87.18% by the user's figure (2026-10-18); the latest commit is `45d3a72`.
- **Its helper scripts moved** since HoennB2's copy: `tools/scripts/` became `tools/data/` (narc), `tools/script/`
  (field scripts), `tools/text/` (text). The seeded tools are updated for this (`notes/SETUP.md`).
- **Constants headers:** generated with its own generators (`tools/data/gen_constants.py` for all 37 `generated/*.txt`,
  `tools/text/text_ids.py` for 1,174 text banks, `tools/text/pms_words.py`) into `build/include/generated/`, the path
  `compile_flags.txt` uses. A test compile of `src/ov166/event_battle_return.c` finds every constants header; the only
  error is Metrowerks-only inline `asm` that clang can't parse, which is expected. The ROM-blob headers (DSP programs)
  need the Black 2 ROM and were not made.
- **A full pokebw2 build is not done yet.** HoennB2's build pipeline (`b2tools/build_rom.py`) starts from pokebw2's
  extracted Black 2 files (`external/pokebw2/build/b2_us/files`), which needs the Black 2 dump in
  `external/pokebw2/orig/` and roughly 1 GB of disk. That is a question for the user (START_HERE question 8), and the disk
  had 5.1 GB free at the end of today.
- Read in C today: season and area loading (`fieldmap.c`, `area_data.c`), Escape Rope (`event_mapchange.c`), the C-Gear
  (`ov079/c_gear_sw.c`, the bottom-screen system a Pokétch would replace or sit beside).

## 6. Risks and unknowns

| Risk | Why | What to do |
|---|---|---|
| Building list 2 has 138 models | Black 2 packs hold ≤ 128 | split the area (fits, since areas are per zone) or drop unused models |
| Gen 4 BDHC heights to Black 2's height format | different height systems [HoennB2 built heights from scratch] | Phase 2 converter's first test: one sloped town (Jubilife or Hearthome) |
| Gen 4 scripts to Gen 5 scripts | command sets differ | as HoennB2: scope note per chapter, then builders. A disassembler first |
| The Pokétch vs the C-Gear | both live on the bottom screen | decision 4; Platinum's Pokétch C explains the apps |
| Underground, Contests | large systems Black 2 doesn't have | decision 4 (closed at first is the cheap path) |
| Disk | 5.1 GB free today; the limit is 5 GB | empty the Trash before any build |
| PKHeX compatibility | HoennB2's Emerald broke it | never change Black 2's save sizes or layout; check before each release |
| Real hardware | bad reads, anti-piracy, seams | the HoennB2 checkers are copied (`anim_tex_check`, `hwtest/pt/watcher.py`, `antipiracy.py`) |

## 7. Phases (HoennB2's order)

0. **Setup** (done today, except the pokebw2 build): dump, repo, decomps, tools, this report. Then the user's
   decisions (`START_HERE.md`), logged in `DECISIONS.md`.
1. **Data:** the Gen 4 reader (matrices, events, scripts, encounters to JSON); trainers, wild Pokémon (Pearl's tables),
   items and marts, Pokédex text; TMs mapped by move, audited by script.
2. **World:** the 3D converter (Pearl chunk to Black 2 chunk: model, collision, heights), then one test town end to
   end in melonDS, then all towns and routes, rooms and caves. The season texture sets from the start if seasons are
   chosen. Checkers and a glitch-check agent per area; warp pairs both ways; Escape Rope in every cave.
3. **Story:** scope note per chapter, then builders; each scene played to its end, win and loss.
4. **Mechanics:** the Sinnoh-only systems chosen in decision 4, plus Rowan's start-of-game options.
5. **Art and music:** the title (3 logo drafts, Palkia), outfits, songs.
6. **Release:** smoke tests per option set, a forced loss, save and Continue, PKHeX, hardware checks, `.bps`, README,
   GitHub release (ask first), Hackdex text.

Diamond later works like Ruby did for Sapphire: one build flag (`PEARL_VERSION=diamond` style), with Diamond's
encounter tables, Dialga and Spear Pillar's matrix 22.
