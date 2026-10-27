# Changing Black 2's code in C (the decomp as our code base)

Since 2026-10-25 PearlB2's code binaries come from the Black 2 decomp (fuddlesworth/pokebw2, about 99% C), built by
its own ninja from a branch `pearlb2` that holds our C changes. Our binary patches (b2tools/patches/*.py) still apply
on top, as before. A change is easier in C when the decomp has the function in C (with names, structs and headers),
when it needs logic rather than a few bytes, or when a table is keyed by Unova zone ids.

## Where things are

| Path | What |
|---|---|
| `external/pokebw2` | the decomp: upstream `origin/main` + our branch `pearlb2` (remote `fork` = logdog2325/pokebw2) |
| `external/pokebw2/include/pearlb2.h` | `#define PEARLB2 1`, our prototypes, the rules below |
| `external/pokebw2/src/pearlb2/resident/*.c` | our new code: PearlB2's resident section (overlay 371, after overlay 290, read once at boot) |
| `external/pokebw2/src/pearlb2/*_itcm.c` | our new code that must be in ITCM (runs before the resident section is read, or in an interrupt) |
| `external/pokebw2/tools/pearlb2/link_itcm.py` | adds the ITCM objects to dsd's linker script (configure.py runs it) |
| `external/pokebw2/tools/pearlb2/link_overlays.py` | links our overlays after overlay 290: the resident section, the Pokétch's |
| `b2tools/resident.py`, `b2tools/pearlb2_overlays.py` | the resident pool for the build's tables; our overlays into the ROM |
| `external/pokebw2/build/b2_us/build/` | the code binaries build_rom.py starts from (ninja target `b2_us_pearlb2`) |
| `external/pokebw2/build/b2_us/files/` | the NitroFS files it starts from (the same target) |
| `external/pokebw2/extract/b2_us/` | the dump's own modules: what "original" means in the checks |
| `b2tools/decomp.py` | ninja + layout check (`build`), `check`, `changed`, `vanilla`, `symbol()`, `dsd_compat()` |

Toolchain (all local, git-ignored in the decomp's `tools/`): mwccarm (dsi/1.1p1 for the game, 1.2/base, 2.0/sp1p2,
2.0/sp2, 2.0/sp2p2, dsi/1.2 for libraries), wibo, sjiswrap, dsd v0.12.1-dsi.9 (the decomp's own build). Homebrew LLVM
(`/opt/homebrew/opt/llvm/bin`) must be first on PATH when configure.py runs (decomp.py sets it for ninja).
build_rom.py keeps writing the ROM with dsd v0.12.1-dsi.1 (`tools/dsd-v0.12.1-dsi.1`, see build_rom.py `DSD`).

## How a PearlB2 build uses it

`build_rom.py --clean ...`:
1. `decomp.build()`: `ninja b2_us_pearlb2` in the decomp (incremental; under a lock, since every agent tree that
   shares `external/` calls it), then the **layout check**;
2. clones the decomp's `files/` and code binaries into the build dir, `decomp.dsd_compat()` on the copy (below);
3. our patches, in order, as before; 4. dsd writes the ROM.

Cost on top of a build: a no-op ninja plus the check, 3 s; after a C change, its files' compile, the link (mwld
for the whole game: most of it) and `dsd rom config`, about 1.5 min. A full decomp build from nothing: 5 min 51 s
(`ninja -j6`, 1,788 C files). `decomp.py vanilla`: 2.5 min (two links). Disk: the tree's sources are APFS clones
(near 0); build/ about 430 MB, extract/ 278 MB. `ninja check` (and `decomp.py vanilla --rom`) also
writes the matching ROM, 512 MB: it is the dump byte for byte, so `cp -c orig/baserom_b2_us.nds` over it (an APFS
clone) gives the space back.

`dsd_compat`: since dsd v0.12.1-dsi.5/-dsi.9 the decomp links the overlay digests (`OverlayTableDigests` ..
`SDK_OVERLAY_DIGEST_END`, 6.9 KB) and one word of `LtdModuleParams` as zeros and lets its dsd fill them when it
writes the ROM. Our dsd keeps what arm9.bin holds, so dsd_compat puts the dump's bytes back there and the old yaml
values (`overlay_signatures: 0`, `table_signed: false`). With that the decomp's code binaries and files are byte for
byte the earlier decomp's, and our ROM the same as before (checked 2026-10-25: see "The switch" below).

## The rules (why: our binary patches)

Our patches edit the code at fixed addresses and assert the bytes they replace. Black 2's overlays are chained in
memory (each placed AFTER others in dsd's linker script), so a C change that makes a function one byte longer or
shorter moves everything after it, in its module and in every overlay after that one: the patches would stop
applying (they assert, so the build stops). So:

1. **A change in place keeps its function's size**: a constant, a table value, a condition, the function a call goes
   to. Keep the original beside it:
   ```c
   #include "pearlb2.h"
   ...
   #if PEARLB2
       weather = PearlB2_SeasonWeather(gameData, zoneId);
   #else
       weather = GetDefaultWeatherValue(gameData, zoneId);
   #endif
   ```
2. **New code goes to PearlB2's resident section, `src/pearlb2/resident/<name>.c`** (2026-10-26), the whole file
   inside `#if PEARLB2 ... #endif`, unless it must be in ITCM. The resident section is overlay 371, linked after the
   last overlay of main memory (overlay 290, 0x021FD080) by `tools/pearlb2/link_overlays.py`; it is read once at
   boot, right after GFL's overlay manager is set up (`src/pearlb2/resident_itcm.c`, from `GFLAppInit`), and never
   unloaded: nothing else loads into its addresses, it takes none of GFL's 20 overlay slots, and the DS-mode main
   arena starts after it (`os_arena.c`: PEARLB2_REGION_END; a DSi's arena starts at 0x0276DDE0). So its code and
   data are always there, like ITCM's, and any code (Black 2's, an overlay's, ITCM's) calls it with a plain `bl`.
   The build puts it into the ROM's overlay table by itself (`b2tools/pearlb2_overlays.py`, from build_rom). Call it
   from rule 1 (same-size call).
   **ITCM (`src/pearlb2/<name>_itcm.c`) is only for code that runs before the resident section is read (before
   GFLAppInit's overlay set-up) or from an interrupt.** ITCM is 32 KB: Black 2 uses 5 KB and was nearly full with
   ours (2026-10-26).
3. **Data our tools generate** (zone tables from data/sinnoh_world.json, anything per build) is not compiled into
   the decomp: the decomp tree is shared by every agent's build. The C reads it through a pointer
   (`#pragma explicit_zero_data on`, `Type *gPearlB2Name = NULL;`: the pointer must be in .data, which is in the
   binary's file; an overlay's .bss is cleared when it loads); the patch puts the data in the resident section's
   pool (`resident.install(code, build_fn)`, the same call as `itcm.install`: 16 KB, PEARLB2_RESIDENT_POOL in the
   linker script) and its address in the pointer (`decomp.symbol('gPearlB2Name', code)`; `resident.write(code,
   addr, bytes)` finds the binary that holds an address: ITCM, ARM9, the resident section). NULL = the game's
   behaviour, so a build without the patch is Black 2's.
4. **Only files marked `complete`** in `config/b2_us/arm9/**/delinks.txt` are linked from their C. An incomplete
   file is compiled (for objdiff) but the ROM takes the dump's delinked bytes: a change there does nothing.
5. **The layout check** (`python3 b2tools/decomp.py check`, also inside every build): every module keeps the dump's
   size (ITCM may grow), and each of the ~48,500 symbols of the decomp's symbols.txt that the link has is at its
   address. It stops the build otherwise.
6. **Vanilla stays reachable**: `python3 b2tools/decomp.py vanilla` sets `PEARLB2 0` (only the files that include
   pearlb2.h recompile), runs the decomp's own `ninja check` (the original ROM's SHA-1), and switches back.

## Changing a function in C, step by step

1. Find it: `external/pokebw2_latest` or `external/pokebw2/src`, `config/b2_us/arm9/**/symbols.txt` (address ->
   name), `grep -rn Name src include`. Check its file is `complete` (rule 4).
2. Work in your own decomp tree (below), never in the shared `external/pokebw2`.
3. Edit with rules 1-3. New `src/pearlb2/*_itcm.c` files are picked up by configure.py, which ninja reruns by itself
   (the directory is one of its inputs).
4. `python3 b2tools/decomp.py build` (ninja + layout check), then `python3 b2tools/decomp.py changed`: the functions
   whose bytes differ from the dump's. Expect your function(s), the ITCM, and nothing else.
5. A PearlB2 build (`build_rom.py --clean ...`, the usual list). A patch whose asserted bytes you changed stops the
   build: move that patch into C too (or drop the C change).
6. Test the behaviour once in the emulator (STORY_AGENT_BRIEF.md "Test").
7. Report the decomp files you changed (`git -C external/pokebw2 status`); the lead commits them on `pearlb2`.

### Your own decomp tree (agents)
An agent that changes C works in a worktree of the decomp, so other builds never compile a half-made change (the
same reason as our own trees). After `agent_tree.py new NAME`:
```sh
python3 b2tools/agent_tree.py decomp NAME     # external/pokebw2_NAME on branch pearlb2-NAME, tools and base ROM
                                              # cloned, configured; work/wt/NAME/external/pokebw2 -> it
PATH=/opt/homebrew/opt/llvm/bin:$PATH ninja -C external/pokebw2_NAME b2_us_pearlb2   # once: ~6 min, 0.7 GB
```
Then build from work/wt/NAME as usual: its build_rom.py runs that tree's ninja. Agents don't commit: the lead
commits the agent's decomp changes on `pearlb2-NAME`, merges it into `pearlb2` (`git -C external/pokebw2 merge
pearlb2-NAME`), and every build after that has it (build_rom.py runs the decomp's ninja). `agent_tree.py retire
NAME` moves the agent's decomp tree to the Trash too (its branch stays).

## Moving a binary patch into C (the pilot: season_weather, 2026-10-25)

Before: `patches/season_weather.py` compiled `src/code/season_weather.c` with clang into ITCM (with its zone tables)
and pointed GetWeatherAll's first call (arm9 0x02032eac, `bl GetDefaultWeatherValue`) at it, asserting the bl.
After:
- decomp `src/system/zone_weather.c`: GetWeatherAll calls `PearlB2_SeasonWeather` in place of
  `GetDefaultWeatherValue` (same size: only the call's target differs; rule 1);
- decomp `src/pearlb2/season_weather_itcm.c`: `PearlB2_SeasonWeather`, the same logic as before, in mwcc C with the
  decomp's prototypes (RTCDate, GameData_GetSeason, GetZoneEnvFlagsWeather) instead of addresses (rule 2);
- `patches/season_weather.py`: builds the same tables, puts them in ITCM and their address in
  `gPearlB2SeasonWeather` (rule 3). With an earlier decomp (no such symbol) it still does the old thing.
Result (2026-10-25):
- in the decomp, `decomp.py changed` lists only GetWeatherAll (the call: 4 bytes), OS_GetInitArenaLo (the ITCM
  arena start: 1 byte), BuildInfo (the autoload list, 2 bytes) and the ITCM after the game's code (256 B of ours);
  every symbol is at its address; with PEARLB2 0 the code is the dump's again;
- the table season_weather.py builds is byte for byte the clang version's arrays (440 B);
- the full build applies every other patch unchanged. Total ITCM use is 32 B smaller (256 B of code + 448 B of
  table, against the clang blob's 736 B). The other ITCM installers' hooks moved with it: each bl into ITCM, in 15
  modules;
- one test (DeSmuME, TEST_START=319,140,850 = Route 201, PLAY_DATE=2026-12-01, a heavy-snow day of the calendar
  year): old and new builds both give weather 5 (heavy snow) and season 3 (winter), and snow falls on screen. The
  shots differ only in where the flakes are.

## When upstream moves on

```sh
cd external/pokebw2 && git fetch origin
git switch pearlb2 && git rebase origin/main        # or: git merge origin/main
```
- Conflicts can only be in our `#if PEARLB2` blocks, configure.py (three small PearlB2 blocks: the ITCM objects, the
  `pearlb2` targets, `src/pearlb2` as a configure input) and our new files. Keep upstream's code in the `#else`.
- A renamed function or header: fix our calls (the compiler says which).
- configure.py may pin a newer dsd / wibo / sjiswrap / mwccarm (`DSD_VERSION`, `WIBO_SHA256`, ...): `configure.py
  --no-download` keeps the local ones; if the build needs the new one, ask the lead (downloads need the user's OK).
- Then: `PATH=/opt/homebrew/opt/llvm/bin:$PATH python3 configure.py --no-download b2_us`,
  `python3 b2tools/decomp.py vanilla` (must give the original ROM), `python3 b2tools/decomp.py build` (layout
  check), a full PearlB2 build, and compare its ROM with the one before (`cmp -l`; only the expected differences).
- If upstream changes what dsd fills at ROM time again, dsd_compat's assert says so.
- Our patches mostly use fixed addresses, which a matching decomp never moves; the few by-name lookups
  (fairy_ui.py `symbols()`) also look names up by address (`func_ovNNN_xxxxxxxx`).

## The switch (2026-10-25)

The latest upstream (0f2e215061, 2026-10-25) is a full checkout at `external/pokebw2_pearlb2`: its own repository
(an APFS clone of external/pokebw2's .git, so the same remotes and history), branch `pearlb2`. Its git-ignored
tools: the local mwccarm, wibo and sjiswrap (the same SHA-256 as configure.py pins), plus two downloads the user
approved: mwccarm 2.0/sp1p2 and 2.0/sp2 (from configure.py's MWCCARM_URL zip; four libraries now need them) and dsd
v0.12.1-dsi.9 (configure.py's DSD_VERSION: the decomp's link needs its features from dsi.5 to dsi.9). `orig/` is an
APFS clone of the old tree's.

Checked: its ninja builds the original ROM (SHA-1 e51e6dfb...); its NitroFS files equal the old base's (318 of 318)
and its code binaries too after dsd_compat (358 of 358). A PearlB2 build on it with PEARLB2 0 and the RESUME list
(commit fe57d73, whose code equals 73bc931's) gives SHA-1 268a65db50e3f22ce52e2d7f6dc7dc0de424ad65, the same as the
lead's build at 73bc931 on the old base (the v4 test ROM): byte for byte the same ROM.

To switch the main tree (no build running; every agent tree merged or retired first: a tree with an older
build_rom.py would build the new base without dsd_compat, and its season_weather.py stops on the changed call):
```sh
cd ~/Documents/GitHub/PearlB2
python3 b2tools/agent_tree.py merge decomp            # review, commit the named files
git -C external/pokebw2_pearlb2 add configure.py include/pearlb2.h src/system/zone_weather.c src/pearlb2 tools/pearlb2
git -C external/pokebw2_pearlb2 commit -m "PearlB2: C changes (ITCM link, season weather)"
mv external/pokebw2 external/pokebw2_old && ln -s pokebw2_pearlb2 external/pokebw2
git -C external/pokebw2_old worktree repair ../pokebw2_latest     # the read-only reference keeps its git
```
Every path in b2tools stays `external/pokebw2`. Undo: move the link to the Trash and `mv external/pokebw2_old
external/pokebw2`. `external/pokebw2_old` (its build/ and extract/: about 0.6 GB) can go to the Trash once a lead
build on the new base has been played.
