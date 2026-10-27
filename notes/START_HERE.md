# Pokémon Pearl NDS: start here (2026-10-18)

## What I did today

- **Set up the project.** New private repo `~/Documents/GitHub/PearlB2` (no online copy). Your Pearl dump is copied
  into `roms/` and checked: Pearl (USA) Rev 5, SHA-1 `99083bf15ec7c6b81b4ba241ee10abd9e80999ac`.
- **Got the reference code.** pokediamond, pokeplatinum and the newest Black 2 decomp (pokebw2, from
  fuddlesworth/pokebw2, with your fork added for pull requests) are in `external/`. No ROMs there.
- **Copied HoennB2's tools** (build, checkers, release kit, hardware tests), with no Hoenn maps or story. HoennB2
  itself was not touched.
- **Wrote the feasibility report and plan:** `notes/PLAN.md`.
- **No maps, story or code yet.** Those wait for the answers below.

## What I found (plain version)

- **Pearl fits in Black 2.** Pearl's maps are already 3D DS maps made of the same kind of pieces Black 2 uses, so
  converting them is much simpler than Hoenn was. Pearl's music is already in the right format. Sinnoh's map size,
  number of places and file sizes are all inside Black 2's limits. One exception: one area uses 138 building models
  where Black 2 allows 128, which is solved by splitting that area in two.
- **Pearl's data is mostly read straight from your dump.** The Diamond/Pearl decomp has the text, trainers and items
  in readable form. The maps, events, scripts and wild Pokémon tables are still raw bytes there, but the Platinum decomp
  documents those formats, so a reader for them is the first job.
- **The Black 2 decomp now covers most of what HoennB2 had to work out by hand**, for example the seasons and the
  Escape Rope code I checked today.
- **Seasons work well for Sinnoh.** Black 2 picks the season look from the area you arrive in. That means the snowy
  north (Routes 216-217, Snowpoint) can stay snowy all year while the rest of Sinnoh changes with the month. The
  north is only reached through Mt. Coronet or by Fly, so the two never show side by side. It can all stay one map,
  which keeps the Escape Rope working.
- **Later on 2026-10-18 (after you said to keep going):** the Black 2 decomp is built; PearlB2 builds a Black 2 ROM
  identical to your dump, and with the anti-piracy fix it boots to the menu. Pearl's places, maps, doors, people,
  wild Pokémon (the right Pearl exclusives), all 850 trainers and all 1,051 scripts are now read from your dump into
  readable files, using the Diamond/Pearl decomp first (Platinum only where it had gaps). Details: `notes/DATA.md`.
  One new question below (9, TMs).
- **Disk space is tight:** about 3.5 GB free (you said to go past the 5 GB rule, 2026-10-18). Emptying the Trash
  would help when you can.

## Decisions
All first decisions were answered on 2026-10-18; they are logged in `notes/DECISIONS.md`. In short: Pearl's map shapes
with Black 2's textures; real seasons with a snowy north all year; Sinnoh music with a Black 2 option; Rowan asks
about Fairy type, music and (later) the sprite style; trade evolutions always on; the recommended mix of Sinnoh-only
features; code public after the first release; a custom top screen plus Pearl's own Palkia bottom screen; TMs 96-120
after the main work.

## Next steps
1. Log your answers in `notes/DECISIONS.md`.
2. Finish Phase 1 (scripts, trainers, items, Pokédex text): it needs none of the answers, so it continues meanwhile.
3. Phase 2: convert one test town end to end and show it to you in melonDS before doing the rest.
