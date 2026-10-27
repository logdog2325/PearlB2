# HoennB2's lessons, applied to PearlB2 (2026-10-19)

Source: HoennB2 `notes/PEARL_LESSONS_2026-10-19.md` (its v18 / Emerald v1.1 release cycle; lessons 23-33 sent the same day). One line per lesson: where
PearlB2 stands and what to do. The checkers PearlB2 inherited from HoennB2 (rooms_check, door_check, check_exits,
npc_check, outdoor_check, exterior_check) read Hoenn's data (Sapphire's maps, data/interiors, world.py output), so none
of them checks Pearl's build yet: the "add" items below are PearlB2's own versions.

Measured 2026-10-19 (data only, no build):
- Stacked warps (several warps on one tile) in installed Pearl zones: **5 zones** (all switched by Pearl's scripts, see 2). Valor Cavern (14,29); Verity Lakefront
  (80,843) and (81,843); Valor Lakefront (717,760) and (717,761); Acuity Lakefront (310,239) and (311,239); Route 214
  (713,670). Only the first warp of a stack fires in Black 2.
- Largest built map chunk: 99,884 B of Black 2's 110,600 B buffer (chunk 1028; next 98,860 and 89,680). No chunk is over.
- People sprites: Pearl's busiest zone (Hearthome) uses 21 distinct sprites; with the player's two that is 23 of 32
  (Pearl's object data only; berry-tree stages and the player's bike/surf/fishing forms not counted yet).
- Intro text (a/0/0/2 file 54, Rowan): 4,436 B; Black 2's own file is 4,684 B. The Exp. Share question needs about
  250 B; the shorter wording of Rowan's questions (decision 2026-10-19) frees some.

| # | Lesson | PearlB2 now | To do |
|---|---|---|---|
| 1 | A door/stairs warp fires only when walking into a solid tile | sinnoh_events puts door warps on solid tiles (warp_kind: type 3/4, direction from the walkable neighbour) | add a warp check: every door/stairs warp tile solid in the built map |
| 2 | Only the first of stacked warps fires | 5 stacks (above), all story versions that Pearl's own map scripts switch at run time with SetWarpEventPos (translated: pl_SetWarpEventPos): the three lakes and their Galactic versions, Valor Cavern, Route 214's Ruin Maniac cave stages 1-3 | check each once in game when the story reaches it (the switched warp must be the one that fires) |
| 3 | The warp's direction decides where an arriving player is stepped to | not checked | warp check: every arrival lands on walkable floor |
| 4 | Where Escape Rope/Fly are blocked, every reachable tile needs a walking way out | not checked | warp check: from every arrival, an exit is reachable (with the HM rules) |
| 5 | A hand-written list replacing an automatic one must cover everything the automatic one found | hand lists: SHARED_ROOMS, respawn, the Center 1F list, CHAPTERS | assert each hand list covers what the data finds |
| 6 | Reused scripts keep the other version's hard-coded tiles | one version (Pearl); scripts from pokediamond, Platinum only for gaps | check any coordinate taken from pokeplatinum against Pearl's maps; keep pokediamond's Pearl branch where D/P differ |
| 7 | Never ship with unexplained checker findings | sinnoh_rooms prints its problems; sinnoh_story 0; encounters 0 | every finding fixed or accepted in writing (a "findings accepted" list in the release notes) |
| 8 | 32 people sprites, berry trees and the player's two included | 23 of 32 at worst so far (above). 2026-10-20: 43 of the 66 overworld zones and 7 outdoor rooms had kept a Black 2 preload list (zone header npc_cache < 24, up to 26 Unova codes, each holding one of the 32 for the whole field); Jubilife's list 1 left 5 entries, so the counterpart (and 3 people) showed only a shadow. sinnoh_world / sinnoh_rooms now set npc_cache 24 (no list) for every Pearl zone; sinnoh_story counts a kept list in its 30-sprite check | port npc_check to Pearl's zones: worst case with berry stages and every player form |
| 9 | Chunk buffer 110,600 B, no length check | build_rom.py check_chunks stops above it; the model fixes keep every chunk under 100,000 B (pearl_chunk.CHUNK_BUDGET; largest 96,020 B, 2026-10-20) | unchanged |
| 10 | Fixed text slots fill up; growing one shifts later text | intro text 4,436 B (above); place names (file 109) grew 12,420 B | measure each text file's headroom before adding lines; remake savestates after a layout change |
| 11 | Check archive reserves before release builds | build_rom.py RESERVE exists | report how full each reserve is before a release build |
| 12 | Hardware reports: ask for the loader and version first | nothing in the README | README: an "update your loader (TWiLight Menu++ / nds-bootstrap)" line; ask first on any hardware-only report |
| 13 | zsh: `export WATCH=1` never reaches Python | hwtest/pt/dsprot.py documents `WATCH=1 python ...` | always put WATCH=1 in front of the command |
| 14 | 1-pixel cracks along polygon edges (water, chunk borders) | 2026-10-20: measured and fixed (pearl_seams_check.py, pearl_model_fix.py: under-floor, T-junction splits with the neighbours', layers 2 units apart; notes/MAP_LOOK.md "The world pass") | look at Route 202, the sea, Jubilife's plaza and the caves in melonDS |
| 15 | Build releases in a clean git worktree | no release yet | release builds from a clean worktree |
| 16 | Full disk: the ROM pack writes a 0-byte file silently | build_rom.py has no disk check | check free space before every build and assert the ROM is not empty |
| 17 | Ask: hotfix now or one combined update | no release yet | ask at each release |
| 18 | No AI co-author lines; format-patch files carry the email | done 2026-10-18 (history rewritten, README disclosure kept); PR footer dropped 2026-10-19 | keep format-patch files out of public exports |
| 19 | Keep unbuilt optional content in one visible list | scattered over the notes | `notes/OPEN_CONTENT.md` (this commit) |
| 20 | Clean up after each helper | standing rule | unchanged |
| 21 | Helpers can't screenshot other apps' windows | the hwtest harness takes the emulator's own screenshots | unchanged |
| 22 | Pause by stopping helpers, resume with SendMessage | | unchanged |
| 23 | Branch on the player's gender wherever the original does; test both | pearl_story translates GetPlayerGender and Pearl's boy/girl message pairs; only a boy was played through | play Chapter 1 as Dawn too (Lucas/Dawn, Rowan's assistant, Barry, Mom's house); grep each new chapter for gender branches |
| 24 | Generate player docs from the game's data early: it doubles as an audit | none yet | generate the player pages (encounters, trainers, items, levels) from the build's data with the first chapters |
| 25 | A version inherits every table, not just maps and scripts | scripts, maps and wild tables come from the Pearl dump itself (Pearl's own branch); Platinum used only for command names below 0x2C4 and the start tile (checked walkable) | when trades, static/gift Pokémon, the Safari (Great Marsh) and respawn rules are ported, take each from the Pearl dump and check against pokediamond's Pearl side, never Diamond's or Platinum's |
| 26 | Decide how one-off encounters follow level changes, and what a knocked-out legendary does | Pearl's levels kept; nothing decided for knocked-out legendaries | follow Pearl's own scripts (Palkia, Azelf/Uxie, Giratina, the roamers), and ask the user before changing any of it |
| 27 | Give each helper its own id range, or the lead hands out ids | pearl_ids.py keeps one registry (data/pearl_story_ids.json, src/include/pearl.h) | the lead runs pearl_ids; a helper that needs new flags/vars/trainer ids gets a fixed range in its brief |
| 28 | Start the slow world build early; fold script/text fixes in with a quick ROM-only build | build_rom.py reuses work/rom/files without --clean and takes a patch list | release: start the full build while helpers finish; script/text/data fixes = quick rebuild; full rebuild only for maps, zones or rooms |
| 29 | Keep release tests short; hand the user a test ROM with 4-6 steps when an emulator test struggles | | one proof per change; a numbered-steps test ROM for the user instead of a long helper test |
| 30 | Helpers break "never delete" on their own temp files | PearlB2's tools only unlink a symlink before rewriting a file (the APFS-clone pattern), no data | every helper brief: "no rm at all, not even temp files: move to ~/.Trash"; a hook that blocks rm is an option for the user |
| 31 | Trigger every one-time event once before a release | none ported yet | before each release, one "does it start" run per legendary, gift and island in what is installed (Palkia, the lake trio, Giratina, Heatran, Regigigas, Cresselia, Rotom, Spiritomb, Drifloon; Eevee, the Togepi, Riolu and Happiny eggs, Porygon; the event islands once decided) |
| 32 | New notes files leak into the public source export | no public export yet (release_kit not adapted to Pearl) | an exclude list (session notes, these lessons, helper briefs) and a grep of each export for names, home paths and emails |
| 33 | Update the store page text with each release | no store page yet | update it with each release |

Order when work resumes (before Chapter 2, all cheap): the disk and empty-ROM check (16), the chunk-size assert (9),
the warp check (1-4) with the 5 stacks fixed (2), then npc_check for Pearl (8).
