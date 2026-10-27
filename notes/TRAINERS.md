# Trainers: Pearl's 850 in Black 2's format (prepared 2026-10-18, not installed)

These records are prepared for the story phase. Nothing is in the ROM yet; the trainers go in together with their NPCs
and scripts.

- Tool: `python3 b2tools/sinnoh_trainers.py [--b2-moves]`. It reads `work/pearl/trainers.json`
  (`gen4_trainers.py`, checked against pokediamond for all 850), pokediamond's names, and Pearl's learnsets and prize
  table from the dump.
- Output in `work/pearl/b2_trainers/`:
  - `data/NNN.json`: one per Pearl trainer id, in pokebw2's `res/trainers/data` format (`trainer.schema.json`).
  - `trdata.narc` and `trpoke.narc`: the a/0/9/1 and a/0/9/2 layouts, one entry per Pearl id, packed with pokebw2's
    own `trainer_bytes`.
  - `index.json`: per trainer, its category, Pearl and Black 2 classes, money and moves source.
  - `report.txt`: the class map and the name differences.
- Black 2's format: pokebw2 `tools/data/trainer_data.py`, `include/battle/trainer_data.h`, `src/system/tr_tool.c`.
  Each trainer has a 20-byte record: party kind, class, battle style, count, 4 items, AI flags, heals, money, reward.
  Each party member has difficulty, sex/ability, level, species and form, plus an item and 4 moves when the party
  kind says so.

## Conversion
| Pearl | Black 2 | Note |
|---|---|---|
| type (moves / item bits) | party kind: the same bits (1 moves, 2 item) | |
| Pokémon without moves (620 trainers) | **Pearl's own default moves written out** | The last 4 level-up moves at the Pokémon's level, from Pearl's learnsets (pokediamond `InitBoxMonMoveset`). Without this, Black 2 would fill them from its own Gen 5 learnsets. `--b2-moves` leaves them empty instead. |
| species, moves, items | the same numbers | Black 2's names, e.g. MOVE_FEINT_ATTACK → MOVE_FAINT_ATTACK, SMOKESCREEN → SMOKE_SCREEN, SOFT_BOILED → SOFTBOILED. |
| difficulty, level, form | copied | Difficulty 0-255 means IVs 0-31 in both games. |
| (no field) | sex/ability 0 = the game decides | Black 2 makes its own personality values, so trainer Pokémon natures and sexes can differ from Pearl's. |
| double flag (23 trainers) | BTL_STYLE_DOUBLE | |
| items (Full Restore ×29, Hyper Potion ×7, Super Potion ×7, Potion ×2) | the same items | |
| AI: bit 0 "basic" (846 trainers; 4 have none) | AI_FLAG_BASIC (bit 0 in both games) | No other Pearl flag is used. See question 3. |
| prize: class multiplier × 4 × last level (×2 in doubles) | money × 4 × last level | money = Pearl's class multiplier (×2 for doubles), so the prize is the same. The table is read from the dump (ROM 0x1dfd60); it is the same as pokeplatinum's first 98 classes. |
| heals, reward, messages | false, none, empty | Pearl's trainer texts come with the story phase. |

## Black 2's table vs Pearl's 849
- Black 2 has trainer ids 1-813. Each trainer's defeat flag is id + 1520. HoennB2 found that **about 637 ids are
  usable**: the rest have defeat flags that Black 2's code still touches (`notes/STORY_PORTING.md` in HoennB2).
  Ids above 813 would collide with Black 2's system flags unless the code changes.
- Pearl's ids sort into four groups (`index.json` "category"):

| Group | Count | What |
|---|---|---|
| battled | 490 | a trainer NPC on a map (script 3000/5000 + id − 1) or a script battle command with the id |
| other | 30 | battle partners (Cheryl, Riley, Marley, Buck, Mira), Lucas/Dawn tag partners (12), Artist Kevin ×3, Roland/Carrie/Norman ×9, Palmer |
| variant | 158 | the same class and name as a battled trainer: Vs. Seeker rematch tiers, plus trainers that scripts pick through variables (Barry's starter variants, same-named Galactic Grunts) |
| placeholder | 171 | Pearl's unused entries (names Mickey, Angelica, Tara & Tim) |

- About **520 trainers are needed for the story** (battled + other); that fits in about 637. With every rematch tier
  it would be about 680, which does not fit, and Black 2 has no Vs. Seeker anyway (question 2).

## Classes and pictures
- **Black 2 already has 9 Sinnoh trainer pictures**, from the PWT: Roark, Gardenia, Maylene, Crasher Wake, Fantina,
  Byron, Candice and Volkner (classes `ROARK` … `VOLKNER`), and Cynthia (`PKMN_TRAINER_CYNTHIA`).
  - Black 2 names these classes after the person ("Roark"), so their class names need a text edit to "Leader" and
    "Champion".
  - Cynthia's class is one of Black 2's special classes (its own battle music and intro).
- **37 Pearl classes have the same class in Black 2** (Youngster, Lass, Hiker, Fisherman, Swimmers, Psychics, Black
  Belt, Ace Trainers, Breeders, Rangers, Pokéfans, Policeman, Scientist, Worker, Veteran, …).
- **4 are close**: Ace Trainer (snow) → Ace Trainer; Clown → Harlequin; Guitarist → Guitarist (Black 2's is a woman,
  Pearl's a man).
- **46 Pearl classes have no Black 2 equivalent** (336 trainers, 201 of them battled): Camper, Picnicker, Bug Catcher,
  Aroma Lady, Cowgirl, Jogger, Poké Kid, Young Couple, Ninja Boy, Dragon Tamer, Bird Keeper, Double Team, Collector,
  Tuber M/F, Sailor, Sis and Bro, Ruin Maniac, PI, Skier M/F, Belle & Pa, Rancher, Interviewers, Cameraman,
  Reporter, Idol, Barry, Lucas, Dawn, the Elite Four (Aaron, Bertha, Flint, Lucian), Team Galactic (grunts M/F, Mars,
  Jupiter, Saturn, Cyrus), Cheryl, Riley, Marley, Buck, Mira, Palmer.
  - The prepared records give each of them a **stand-in** Black 2 class with the nearest picture (`CLASS_MAP` in the
    tool; "stand-in" in `index.json`), so the records are valid now.
  - Installing them needs spare Black 2 classes with new names and pictures, as HoennB2 did for Hoenn's classes.
  - Black 2's Elite Four and Plasma classes are special classes (their own cut-ins). HoennB2 had to change their
    encounter effect, because an Elite Four battle outside the League hung on a white screen.

## Pearl's trainer pictures (done 2026-10-18, not shown by any class yet)
The user chose Pearl's own pictures for the 46 classes (question 1, A). They are ready as new Black 2 sprites.

- Tool: `python3 b2tools/pearl_trainer_pics.py` (build, then check and preview). It reads the dump's
  `poketool/trgra/trfgra.narc`.
- Pearl's picture of class c is member 2c (pixels) and 2c + 1 (colours). Source: pokediamond `pokemon.c`
  (`sub_020690AC`). Class numbers come from pokediamond's `trainer_classes.h`.
- Pearl's pixels are encrypted, as all DP pictures. The tool decodes them as pokediamond's `nitrogfx` does.
- Each picture is 160x80: two 80x80 frames. The second frame is empty in all 98 classes. So the picture is the left
  half.
- Both games use 80x80 pictures with 16 colours. So nothing is resized or redrawn. Each picture keeps its own 16
  colours.
- Output: `work/trainer_pics/<CLASS>/`, one folder per class, in `sprites.py`'s trainer format (`sprite.json`,
  `palette.pal`, `static.png`, `parts.png`). The folders are not committed (extracted game graphics). The build makes
  them if they are missing.
- Animation: none for now. The figure stands still. Each sprite copies the cell and animation files of Black 2's front
  sprite 20 (a placeholder). Those files show texture (0,0)-(80,80) as one whole figure, standing on the ground line.
  So `parts.png` holds the picture at its top-left, and the rest is clear.
- New sprite ids: **188-233**, in Pearl class-number order (Camper 188 … Palmer 233). The list is fixed in the tool;
  never reorder it. `work/world/trainer_pics.json` maps each Pearl class name to its id.

### How it was checked
- All 46 decoded pictures and palettes equal pokediamond's own PNGs (pixels by index, colours as BGR555).
- Each folder's `static.png` and `parts.png` have Pearl's exact pixels, and `palette.pal` Pearl's exact 16 colours.
- Installed into a copy of Black 2's archive, the new files decode back to the same pixels and colours. Black 2's
  own 1504 files stay byte-identical.
- The sprite's two animations, drawn tick by tick (`mcss.py`), show exactly Pearl's picture and nothing else.
- Result: 46/46 exact. Sheet: `work/trainer_pics/preview.png` (Pearl's picture next to the drawn Black 2 sprite).
- The build patch was run offline on a copy of `a/0/7/1` (no ROM build: the disk is nearly full). The archive grows
  from 1504 to 1872 files (+112 KB). That fits build_rom.py's 1 MB reserve, so the ROM layout does not move.
- **Not yet seen in game.** The test patch below is ready for the lead's next build.

### Build patches
- `patches/pearl_trainer_pics.py`: appends the 46 sprites (8 files each) to `a/0/7/1` and writes
  `work/world/trainer_pics.json`. It does not change any trainer class. It refuses an archive that does not have
  exactly Black 2's 188 sprites, so list it before any patch that appends sprites (`sprite_switch`).
- `patches/test_trainer_pic.py` (TEST ONLY): a new game gives a Piplup and starts a battle with Black 2's Youngster
  Terrell right after arriving in Twinleaf. Black 2's Youngster class then shows a Pearl picture
  (`TEST_TRAINER_PIC`, default Barry). Use it instead of `test_wildmon` (both rewrite script 1289):
  `build_rom.py --clean antipiracy sinnoh_world scripts pearl_trainer_pics test_trainer_pic`.

### How a class picks its picture (pokebw2's C)
- `GetTrSpriteBaseDatID(class, flags)` (`src/system/tr_tool.c`, arm9 `0x02030740`). For a front picture it returns
  `TRAINER_CLASS_RESOURCES[class].sprite` (arm9 `0x02092394`, 4 bytes per class: sprite, sex, u16 eye-contact song).
- The eight `GetTrSprite*DatID` functions (`src/system/pokegra.c`, arm9 `0x02033cf0`-`0x02033d50`) turn that into a
  file number: sprite × 8 + 0..7. The battle's MCSS (`GetTrainerSpriteResIDs`, `mcss_tool.c`) and the still-picture
  loaders use them. HoennB2 found that the Hall of Fame, trainer card and PWT pictures also go through it.
- The archive read takes any file number the archive has. So **new sprite ids work with no code change, up to 255**:
  the `sprite` field and the function's return value are both a u8. Ids 234-255 are still free.
- HoennB2's `sprite_switch` already appends sprites after Black 2's 188 in the same way, and checks they stay below
  256.
- A class number must be below `TRAINER_CLASS_COUNT` (236). A higher class gets sprite 0. So the Sinnoh classes must
  reuse Black 2's class slots 0-235, as HoennB2 did with spare classes.
- **To show a picture:** set the class's byte at `0x02092394 + 4 × class` to the id in `trainer_pics.json` (in an
  `apply_code`, as HoennB2's `patches/trainers.py` does with its class "edits"). Also set the sex byte (0 male,
  1 female) for the class.
- Back pictures are separate: `TRAINER_CLASS_BACK_SPRITES` (arm9 `0x02092314`, 32 class/sprite pairs). A class not
  in it gets Nate's or Rosa's back. Black 2's battle view swaps the player of every link battle to class 180/181 (and
  182/183 to 184/185: ov168 `BtlvEffect_SetTrainer`), so no Pearl class may use 180-185.

### Left to do
- Point each Sinnoh class at its picture (story phase, with the class table and names).
- See one picture in game (the test patch above).
- Tag partners (Cheryl, Riley, Marley, Buck, Mira, Lucas, Dawn): **done 2026-10-25** (`patches/pearl_partner_backs.py`).
  Pearl's own backs with their five-cell throws (batt_obj.narc, as the player's) are back sprites 31-37 (Cheryl,
  Riley, Marley, Buck, Mira, then Lucas and Dawn as the counterpart: the player's backs 0/1 stay separate). The
  partners left the link classes: Riley 228, Marley 229, Mira 230, Buck 207, Lucas 199, Dawn 200 (Pokéstar Studios'
  Guy, Hero, Heroine: only its movies use them); Cheryl keeps 111. Their back pairs replace Pokéstar's (Hero,
  Heroine, Guy, Ninja M/F, UDF Trooper M/F). Classes 180/181 (the player in link battles) now show the player's backs
  0/1 and Pearl's Lucas/Dawn fronts (sprites 231/232); they showed Riley/Marley while those had 180/181.
- Pearl's front pictures of Cheryl, Marley, Buck and Mira are near-copies of Aroma Lady, Picnicker, Camper and Poké Kid
  (Pearl never shows them). They are converted as they are.
- Optional later: Gen 5-style motion (cut the picture into parts, as HoennB2's `sprite_upgrade.py` does).

## Ready to install (2026-10-18 night): `patches/pearl_trainers.py` (not in the build list yet)
Build: `... sinnoh_story ... pearl_trainer_pics pearl_trainers` (after sinnoh_names, which packs the other system text).
Chapter 1 has no trainers, so it is not needed yet. Not seen in game yet (see "Left to test" below).

- **Which trainers.** Every trainer an installed story zone uses: its trainer NPCs and the `PTRAINER_n` its scripts
  battle. With Chapter 2's zones generated (`pearl_story.py chapter 2`) that is 28: Route 202, Jubilife's buildings,
  Route 203 (with Barry 247-249), Oreburgh Gate, the Mine's Workers, Roark's Gym. `PEARL_TRAINERS=all` installs all
  520 (checked offline: a/0/9/2 grows 5.6 KB of its 32 KB reserve, a/0/8/9 by 336 B; a/0/9/0 and a/0/9/1 keep their
  size).
- **How.** pokebw2's own sources and packers on a clone (`pokebw2_mod.py`): each trainer's
  `res/trainers/data/<Black 2 constant>.json` becomes Pearl's (the prepared `work/pearl/b2_trainers/data/NNN.json`),
  then `tools/data/trainer_data.py pack` writes a/0/9/1, a/0/9/2, a/0/8/9 and a/0/9/0. An unchanged clone packs all four
  byte-identical to Black 2's (checked). The system text is packed from the same clone, and only files 381 (messages),
  382 (names), 383 and 485 (class names) go into the build's a/0/0/2, so sinnoh_names' text stays.
- **Messages.** Pearl's own (`poketool/trmsg/trtbl.narc` + message bank 558, pokediamond trainer_data.c). Types 0-10
  are numbered alike in both games. Pearl's in-battle lines 13-16 (first hit, half HP, last Pokémon, last at half HP)
  are Black 2's 17-20 (ov167 btl_client.c). A double trainer's two defeat lines (4, 8) are joined into Black 2's one
  defeat line (type 1; Black 2's 8 means "the trainer won"). Rematch lines are left out. Checked by reading the packed
  files back: Tristan's 0/1/2, Roark's 19/20/1, Barry's 17/18/1, Liv & Liz's lines, the names and class names.
- **Classes** (`data/pearl_trainer_classes.json`, the registry: fixed once given; `python3
  b2tools/patches/pearl_trainers.py --classes` only adds missing ones):
  - Pearl classes Black 2 also has keep Black 2's class (`sinnoh_trainers.py` CLASS_MAP 'same'/'near').
  - Gym Leaders: Black 2's Unova leader classes 112-119 (special classes: the leader battle music), in gym order
    (Roark 112 ... Volkner 119), with Black 2's own PWT pictures of the Sinnoh leaders (sprites 129-136). Their music
    group plays Black 2's PWT version of Pearl's leader theme (SEQ_BGM_VS_DP_LEADER).
  - Champion Cynthia: class 193 (Champion) with Black 2's picture of Cynthia (sprite 91), SEQ_BGM_VS_DP_CHAMP.
  - Elite Four: classes 78-81 with Pearl's pictures. Barry: class 145, the rival's class (Black 2 names him from the
    save's rival name), Pearl's picture. Team Galactic: the Team Plasma classes (grunts 187/188, Mars 191, Jupiter 192,
    Saturn 186, Cyrus 189), Pearl's pictures, Plasma's battle music; the three Commanders share one music group.
  - Every special class above: Black 2's character cut-in replaced by its plain trainer effect (5), as HoennB2 did
    (the Elite Four cut-in hangs outside the League).
  - The other 35 Sinnoh-only classes (Camper ... Tower Tycoon): spare Black 2 classes no trainer or facility uses
    (the NO_DATA classes, then the PKMN_TRAINER placeholders), with Pearl's pictures, Pearl's class names and the
    eye-contact music of the nearest Black 2 class.
- **NPCs.** sinnoh_story already places Pearl's trainer NPCs (evType 1, Pearl's sight range, script 3000 + Black 2 id):
  Black 2's own trainer script does the sight, "!", walk-up, lines, battle and defeat flag (id + 1520).
- **Left to test in game** (with Chapter 2): an eye-contact battle and its after-battle line (e.g. Youngster Tristan on
  Route 202), a script battle (Barry on Route 203, Roark), that the field comes back after each (the error screen seen
  after the new-game test battle), each class's picture and name, and the leader music. A try on 2026-10-18 failed for
  test reasons only: the test start tile (166, 820) is inside a tree (Route 202's walkable tiles next to Tristan's sight
  line are e.g. (170, 821)); savestates from an older build hang in battle (a/0/0/2 and overlay 36 differ), so test
  from a cold boot.

## Open questions (for the user)
1. **Pictures for the 46 Sinnoh-only classes** — answered 2026-10-18: A (see "Pearl's trainer pictures" above).
   This ties in with your CLASSIC/NEW sprite question for Rowan. Options:
   - A (recommended): Pearl's own trainer pictures, taken from your dump.
   - B: Black 2 stand-ins (the prepared default).
   - C: new Gen 5-style art.
2. **Rematches.** Pearl's Vs. Seeker rematch tiers do not all fit in Black 2's trainer table, and Black 2 has no Vs.
   **Answered 2026-10-19: C, all rematches through the defeat-flag code change.**
   Seeker. Options:
   - A (recommended): first battles only for now (about 520 ids).
   - B: add some rematches in the ids that are left (about 110).
   - C: a code change that moves the defeat flags, so more ids can be used.
3. **Trainer AI.** Pearl's trainers use only the basic AI. Most of Black 2's trainers also use its "evaluate attacks"
   **Answered 2026-10-19: A, Pearl's basic AI everywhere.**
   and "expert" AI. Options:
   - A (recommended): Pearl's (basic) everywhere, which is faithful.
   - B: Black 2's stronger AI for Gym Leaders, the Elite Four, Cynthia and Team Galactic's bosses.
   - C: Black 2's stronger AI for everyone.

## Not done yet (story phase)
- Allocate Black 2 ids. Keep a registry fixed once given, as HoennB2's `data/hoenn_trainers.json` does.
- Names (system text 382), class names (383/485), and Pearl's trainer messages (text 381 + a/0/8/9 + a/0/9/0).
- Trainer NPCs (evType 1, sight range, script 3000 + id).
- Spare classes (Pearl's pictures are ready, see above), and battle music for the special classes.
