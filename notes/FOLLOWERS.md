# The following Pokémon (one of Rowan's questions)

User (2026-10-26): "since following Pokémon are possible in Amity Square, can we make it a Rowan question to have
them follow you all game?", and the follower must be portable to the HoennB2 games. Plan and research:
work/agents/followers/FOLLOWERS_PLAN.md (Black 2's sprites, the pair system, every special case).

## What it does (the user's answers, 2026-10-26)
- Rowan asks it as the fourth of five questions, after the Exp. Share and before the seasons (which stay "Last, ..."):
  "Will your first Pokémon walk with / you wherever you go?" YES/NO, the cursor on YES like the others (B = NO).
  Stored as the event flag PFLAG_POKE_FOLLOWER (a new saved flag, b2tools/pearl_ids.py NEW_FLAGS); clear (NO, and
  every save from before the question) = no follower. Fixed for the game, like the other answers.
- Who follows: **party slot 1**; an Egg or a fainted slot 1 = nobody. When slot 1's species has no walking sprite
  (103 Gen 5 species, Origin Giratina), the **next party Pokémon that has one** (and isn't an Egg or fainted).
- Sprites: Pearl's own walkers where Pearl has them (the 11 Amity Square species, and Machop and Shaymin's Land Forme,
  converted for this: codes 337 and 338, patches/pearl_amity_sprites), else Black 2's official walking Pokémon
  (ARCID_TPOKE: every species 1-493 and their forms, 53 Gen 5 species), never made-up pixels. Shiny Pokémon show
  their normal colours (no shiny overworld palettes exist). 64 x 64 sheets (31: the big legendaries, Steelix,
  Wailord) only on the overworld.
- It hides on the bike and the water and comes back behind the player on the first step on foot; after a map change
  it appears on the first step; a follower left behind (ledges, lifts, scripted moves) is put back behind the player
  at the next step. While an NPC partner follows (Black 2's pair: Cheryl, Riley, Buck, Amity Square's walk) there is
  no Pokémon follower.
- Not there (yet): rooms and caves (step 2), the Battle Tower block and the Hall of Fame, Black 2's link zones.

## Files
The module (portable: nothing in it names a hack):
| File | What |
|---|---|
| decomp `include/follower.h` | the API, the config's layout, the hook list |
| decomp `src/pearlb2/resident/follower.c` | the core (PearlB2's resident section, overlay 371; ITCM until 2026-10-26): who follows, which sprite, the hook functions |
| decomp `include/follower_port.h` | PearlB2's adapter: `#include "pearlb2.h"`, `#define FOLLOWER_MODULE PEARLB2` |
PearlB2's side:
| File | What |
|---|---|
| decomp `src/ov036/fieldmap.c`, `fieldmap_event.c`, `fldmmdl_movecode_pair.c` | the three hooks (`#if PEARLB2`) |
| `b2tools/patches/followers.py` | the config into the resident pool (`resident.install`), its address into `gFollowerConfig` |
| `b2tools/patches/pearl_intro.py`, `data/text_overrides/pearl_intro.json` | the question (line 38) and "five questions" |
| `b2tools/pearl_ids.py` | PFLAG_POKE_FOLLOWER |
| `b2tools/patches/pearl_amity_sprites.py`, `data/pearl_sprite_map.json` | Pearl's Machop and Shaymin walkers |
| `b2tools/patches/test_story_start.py` | TEST_PARTY (a test party in order; EGG = an Egg) |

Build list: the RESUME list plus `followers` after `pearl_intro` and `pearl_amity_sprites` (both are in the list).
Test builds (TEST_START) leave the config out unless `TEST_FOLLOW=1`: the test drivers answer YES to every question.

## The hooks (Black 2's own functions; each only changes the function a call goes to)
| Decomp file (`complete`) | Function | Call | Becomes |
|---|---|---|---|
| ov036 fieldmap.c | Field_InitActorSystem | `FldActSys_WakeUpAllActors(field->actorSystem)` | `Follower_FieldOpen(...)`: the same, then a follower no longer wanted goes (fainted lead, new order, option off, partner) |
| ov036 fieldmap_event.c | CheckPerStepEvents | `GameData_CheckPairFlag(gameData)` (with `wk->stepStarted`) | `Follower_Step(gameData)`: makes / brings back / puts back the follower, returns the pair flag |
| ov036 fldmmdl_movecode_pair.c | func_ov036_02192aac (move code 0x30's step) | `IsActorHidden(actor)` | `Follower_Hold(actor)`: hides it the frame the player rides or surfs |
| ov036 scrcmd_fldmmdl.c | s0064_ActorCmdExec, s024F_ActorWalkRoute | `FieldAcmdTCB_Create(actor, list)` | `Follower_ScriptAcmd(...)` (step 2): a list that walks or jumps someone else to another tile puts the follower away until the player's next step |
| ov012 event_action_call.c | EventActionCall_Callback | `FieldAcmdTCB_Create(actor, work->action)` | `Follower_ScriptAcmd(...)` (step 2): the same for events that walk the player (a step back) |
| ov036 entrance_camera.c | EventWarpSequence_CreateIn | `TryRespawnFollowActor(warp->gameData, TRUE / FALSE)` | `Follower_WarpIn(...)` (step 2): on a door's walk out (TRUE) the follower stands behind the player, as Black 2's pair |
| ov036 entrance_camera.c | EventWarpSequence_StartWalkTask | `GameData_CheckPairFlag(warp->gameData)` | `Follower_WarpWalk(...)` (step 2): lets the follower walk out of the door with the player, then answers the pair flag |
| ov012 pair_sys.c | s0250_ActorPairSet | `ChangeActorMoveCodeSeq(actor, 0x30)` | `Follower_PairStart(actor, 0x30)` (step 3): a partner (or Amity Square's walk) takes the follower's place at once |
| ov036 event_trainer_eye.c | EventTrainerEye_CheckPathObstacle | `ActorRouteCollCheck(...)` (both calls) | `Follower_SightCollCheck(...)` (step 3): the follower is no wall for a trainer's eyes |
`decomp.py changed` lists exactly these functions (4 bytes each: the bl; 8 for the two sight calls) and the resident section. PearlB2's own gimmick code calls
`Follower_Hide()` when it carries the player (step 2): the lifts' rides (pearl_platforms_itcm.c, both starts), the
Sunyshore gears' turn (sunyshore_gym_itcm.c), Pastoria's water (pastoria_gym_itcm.c). A hidden follower is no obstacle
(actor flag 0x80) and comes back behind the player at their next step.

The follower is actor uid 0xFD with Black 2's follow move code 0x30 and actor flag 32 (kept across the overworld's
zone lines); it is not Black 2's pair (flag 0x966, PlayerSave's FieldFollowWk), so wild battles, healing, Surf, Fly,
the bike, the Escape Rope and the Entralink behave as without it. Nothing new is saved: the actor rides in Black 2's
actor block like any person.

## The config (`FollowerConfig`, include/follower.h; little-endian u16)
`flag, scrId, rooms, nSheets, nOff, nHuge, nNever, slotWork`, then `sheets[nSheets] {species, object code}` (form 0),
`off[nOff]` zone ids, `huge[nHuge]` object codes (overworld only), `never[nNever]` object codes. PearlB2's
(followers.py): the flag PFLAG_POKE_FOLLOWER (by name from src/include/pearl.h), the talk script 10017, rooms 1
(step 2), 13 sheets (Pearl's walkers), off = 616-622 (Battle Tower) and 261 (the Hall of Fame), the 31 huge codes from
a/0/4/7 (billboard size 2), never = 4637 (Origin Giratina's code, Pearl's wall painting), slotWork PVAR_FOLLOWER_SLOT.
148 B.

## Talking to it (step 4)
Its script is global 10017 (`Script_18` of src/field_scripts/1243_global_10000.s; b2tools/patches/pearl_defog.py
--sources writes it with Defog's Script_17): the cry of the Pokémon in the party slot the core keeps in
PVAR_FOLLOWER_SLOT, and one of Pearl's 9 Amity Square lines at random (Pearl bank 236 lines 13-21: "{name} is happily
keeping up.", ... "seems to be enjoying the walk."; text file 1236, lines 35-43). No finds outside Amity Square.

## Budgets
- Code: the core with steps 2-4 is 1,808 B of code and data (step 1's was about 1,020 B), the config 148 B; both in
  PearlB2's resident section since 2026-10-26 (ITCM was full).
- Sprite slots (Black 2's 32 billboard materials a field, HoennB2 notes/NPC_LIMIT.md): the follower is one more. The
  busiest Pearl map has 22 sprite codes, so with the player's two entries and the follower: 25 of 32. No change needed.
- Actors (64): the busiest Pearl map has 42 objects; +1.
- The TPOKE table (4,960 B) is read into the field heap's tail only when the party changes (8 answers are kept).

## Step 1 (built and tested 2026-10-26, DeSmuME; work/agents/followers/shots1, shots3)
Step 1: the question; the follower on the overworld (rooms off); bike/Surf hiding; the pair rule. Played: the question
(4th of 5, its box and menu: question7.png; YES sets the flag, NO leaves it clear and nothing follows); Snivy first
(no sprite), so Piplup follows: it appears behind on the first step, follows turns, swaps places when walked into; a
wild battle leaves the pair flag 0x966 clear and the follower there; the Route 201 -> Sandgem and Sandgem -> Route 219
lines; a Sandgem house: none inside (rooms off), behind again on the first step out; Surf: hidden at once, stays
hidden on the water, back behind on the first step on land; in-game save, soft reset, Continue: back where it was;
the party screen: Magikarp first (Black 2's sheet), the Egg first (nobody), Pikachu first (Pearl's sheet, code 111),
Steelix first (64 x 64, code 4336, on the overworld). Not played: a fainted slot 1 (the battle driver could not
make the lead faint; it takes the Egg's branch of the same check), the bike (the same exState check as Surf).
Seen on the way: Sandgem's first-visit scene (Dawn takes the player to the lab) started with the follower there and
ran to the end; not filmed (scenes are step 2).
Next (FOLLOWERS_PLAN.md): step 2 rooms and caves on, scripted walks hide it (ActorCmdExec's FieldAcmdTCB_Create),
door exits (EventWarpSequence_CreateIn), gimmick rides; step 3 the pair start deletes it at once (s0250_ActorPairSet's
ChangeActorMoveCodeSeq) and trainers see past it (EventTrainerEye_CheckPathObstacle's ActorRouteCollCheck); step 4
talking (a global script: the cry and one of Pearl's 9 Amity Square lines).

## Porting to another B2 hack (the HoennB2 games)
Checked against HoennB2 (read only, 2026-10-26): its decomp `external/pokebw2_new` is the same upstream commit
(0f2e215061) with the same hook lines in `complete` files (fieldmap.c:1035, fieldmap_event.c:886,
fldmmdl_movecode_pair.c:155; and steps 2-3's: scrcmd_fldmmdl.c's two FieldAcmdTCB_Create, event_action_call.c's,
entrance_camera.c's two TryRespawnFollowActor and the walk task's GameData_CheckPairFlag, pair_sys.c's
ChangeActorMoveCodeSeq, event_trainer_eye.c's two ActorRouteCollCheck); it links `src/hoennb2/*_itcm.c` into ITCM the same way (tools/hoennb2/link_itcm.py)
under `#if HOENNB2` (include/hoennb2.h); its outdoor zones are on matrix 0 too; its Birch questions run through the
same Intro_SetConfigBit, whose arguments >= 16 set an event flag.
1. **Copy** `include/follower.h` and `src/pearlb2/resident/follower.c` (to `src/hoennb2/follower_itcm.c`, or the hack's
   own always-loaded section) unchanged. Write
   `include/follower_port.h`: `#include "hoennb2.h"` and `#define FOLLOWER_MODULE HOENNB2`.
2. **Hooks**: the call changes above, each as `#if HOENNB2 <new call> #else <original> #endif`, and
   `#include "follower.h"` in those files; optionally `Follower_Hide()` where the hack's own code carries the player. Check: the decomp's "changed" list shows those three functions only
   (plus ITCM), and the `HOENNB2 0` build is the original game.
3. **Data**: a build step that writes the config into always-loaded memory (ITCM or the like) and its address into
   `gFollowerConfig` (followers.py is
   the model: replace its sources); the talk script's id and a saved work for the party slot (PearlB2: global 10017 in
   its global 10000 file, text file 1236 lines 35-43, PVAR_FOLLOWER_SLOT; any global script with a text bank of the
   hack's own will do: the script reads the slot work, WordSetPartyPokeName / PokePartyGetSpecies / PVPlay and one
   line); the option's flag (a free saved flag), the hack's own walking sheets by species
   (HoennB2's Pokémon person codes, if any; none is fine), the zones with no follower (its Battle Frontier, link
   rooms, Hall of Fame), the 64 x 64 codes (from a/0/4/7: the same list unless the hack changed records), and any
   ARCID_TPOKE codes the hack painted over (its sprite map). `rooms` 0 or 1.
4. **The question**: one more entry in the intro's question list (HoennB2: Birch's, fairy.py / hoenn_intro.py) on a
   blank line of system text 54 (measure its size), setting the flag; the test driver should leave it off in
   other tests (PearlB2: TEST_FOLLOW).
5. **Partners** need nothing: any NPC that follows through Black 2's pair (ActorPairSet, flag 0x966) makes the
   Pokémon step aside.
6. **Budget**: about 2 KB of ITCM or other always-loaded code (the core 1,808 B + the config 148 B). HoennB2's Sapphire and Ruby have room (8,896 B left with
   the Exp. Share in C); **Emerald has 160 B left** (HoennB2 notes/POKEBW2_UPGRADE.md 8.6): it needs its ITCM freed
   first. One sprite slot per field (Emerald raised its cache to 40) and one actor.
7. **Test** (one build): a new game answering the question YES and NO; a walk with turns and back into the follower;
   a seamless zone line; a door out and back; the lead an Egg, fainted, a species without a sprite, a hack sheet, a
   64 x 64 one; bike and Surf; a wild battle (single, nothing healed) and a trainer; save, soft reset, Continue; a
   partner scene. Look at every frame for graphical errors.
