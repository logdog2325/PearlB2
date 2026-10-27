# Title screen (plan, 2026-10-18)

User's choice (question 7): a custom Gen 5-style top screen like Ruby/Sapphire/Emerald NDS; the bottom screen is
Pearl's own title bottom screen with Palkia's outline, taken straight from the Pearl dump.

## Pearl's title (pokediamond files/demo/title/titledemo/, = the dump's demo/title/titledemo.narc)
- file 3: the "Pokémon Pearl Version" logo (file 1 is Diamond's), 256x128, 8 bpp.
- file 15: "© 2007 GAME FREAK inc." line; files 0/8/12/17 screens, 2/4/9/10/13/14/16 palettes.
- **Palkia's outline is 3D**: file 5 `title_air` (textures `pal`, `air_pink`, `air_blinn`, `outUV1`: the pink
  energy aura) + texture animation file 18 (NSBTA) scrolling the aura over Palkia's silhouette. File 6 `title_iar`
  + 19 are Dialga's (Diamond, later).

## Black 2's title (HoennB2 notes/RESEARCH_TITLE.md; overlay 162, fully decompiled: src/ov162/title.c)
- Top (sub engine): the logo is an 8 bpp BG (a/0/2/6 files 0/1/2) over a crystal strip (file 3) and PRESS START.
- Bottom (main engine): 3D Black Kyurem (a/1/5/8 446-453) through a motion blur, credit line on BG3 (a/0/2/6 8/9/10).

## Plan
1. Top: a new Gen 5-style "Pokémon Pearl" logo, 3 drafts for the user to pick (HoennB2 b2tools/title_art.py
   drafts the Hoenn logos; its packer writes a/0/2/6 0/1/2/3), Black 2's crystal strip and PRESS START.
2. Bottom: replace TitleG3D_Init/Draw/Free (as HoennB2's patches/title_scene.c does) with code that loads Pearl's
   Palkia model (file 5, its own textures) and texture animation (file 18) and draws them with a fixed camera;
   Pearl's copyright line on BG3; no motion blur, no 29 s swap; Palkia's cry on Start (cry species literal).
3. Skip Black 2's opening movie (HoennB2: arm9 0x02036332 `movs r0, #2` -> `#3`).
Needs: copy HoennB2's title_art.py / title_scene.c pieces (read-only source), a test build (disk), user's logo pick.

## Built and tested (2026-10-18, DeSmuME)
- `b2tools/patches/pearl_title.py`: top = logo draft 3 (user's pick) over the pink-tinted crystal strip, PRESS START;
  bottom = Pearl's Palkia (titledemo 5 + 18 appended to a/1/5/8 479/480) as the title scene's only actor.
- Black 2's title code loops over 3 actors (bind, draw, step, set frame) whatever the setup says: with 1 actor and
  the loops at 3 the game crashed into VRAM (PC 0x06369000); the four `cmp #3` -> `#1` (addresses by bytes:
  0x0219d5b6, d756, d7a0, d836; armdis's listing drifts by 2 after a literal pool).
- Black 2's camera path framed Kyurem (Palkia filled the screen): the per-frame `bl GFL_G3DCurveApplyCamera`
  (0x0219d726) is removed and the camera's position/target (sCameraPosition 0x021A148C, sCameraTarget 0x021A1498)
  are set: (-105, -30, 25) looking at (0, 0, -10), tuned by eye against a DeSmuME shot of Pearl's own title
  (work/pearl_ref): Palkia side-on, head and arm at the right, striped wing up-left, tail down-left.
  Tuning: `b2tools/hwtest/title_tune.sh "x y z" "tx ty tz" tag` (title-only build, ~2 min).
- Open: Pearl's aura flashes on/off (its title alternates the aura brightness); here the texture animation runs but
  no flashing. Pearl's "© 2007 GAME FREAK inc." vs Black 2's "Developed by GAME FREAK inc.": Black 2's kept, as in
  the Hoenn games.
