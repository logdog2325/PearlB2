// Porting library for Pearl's story scripts (notes/STORY.md). b2tools/pearl_story.py translates each Pearl script command
// into one of these macros: pl_ + the command's name (Platinum's name where pokediamond has none, pokediamond's number
// always; b2tools/data/gen4_script_cmds.json), each a short sequence of Black 2 field-script commands
// (external/pokebw2/include/asm/field_script.inc) used the way Black 2's own scripts use them. Include after
// "asm/field_script.inc" and "pearl.h". Emits no code by itself. Model: HoennB2 src/include/hoenn_story.inc.
//
// Facts the macros rely on (Black 2 code: pokebw2 src/ov012, src/ov036; Pearl: pokediamond, Platinum for names):
// - Comparisons: Black 2's VM is Gen 4's. WorkCmpConst/WorkCmpWork set the comparison register to 0 less, 1 equal,
//   2 greater, and VMJumpIf/VMCallIf take Pearl's conditions unchanged (0 LT, 1 EQ, 2 GT, 3 LE, 4 GE, 5 NE: ov012
//   scrcmd_vm.c VM_CMP_LUT = pokediamond's). Pearl's CheckFlag sets the register to the flag (0/1): here FlagGet +
//   WorkCmpConst against 1 gives the same 0 (unset = "less") / 1 (set = "equal").
// - Directions are the same in both games: 0 up, 1 down, 2 left, 3 right.
// - Movement codes are the same numbers in both games for every code Pearl's scripts use (b2tools/data/
//   pearl_movement.json; both fields run at 30 fps, the same frames per tile).
// - Script works: Black 2 has 0x8000-0x8061 per script; RTCallGlobal keeps 0x8020-0x805E of the caller
//   (ov012 FieldScriptEnv_Save/Restore) and shares 0x8000-0x801F with the callee; 0x8011 is the talked-to actor.
//   Pearl's 0x8000-0x800F are 0x8020-0x802F here (pearl.h PVAR_LOCAL), so a Black 2 global call never clobbers them.
// - ActorMsg / ParentActorMsg / SystemMsg return when the text is printed, like Pearl's Message; LastKeyWait = Pearl's
//   WaitButton; MsgWinCloseAll closes every message window (Pearl's CloseMessage).
// - ActorDelete does not set the NPC's hide flag; Pearl's RemoveObject does: pl_RemoveObject takes the flag.
#define PL_TMP 0x8040          // library scratch (never a Pearl var)
#define PL_TMP2 0x8041
#define PL_PLAYER 255          // Black 2's player actor (Pearl 0xFF)
#define PL_ELEVATOR_FROM 0x401E // map-local (cleared on a zone change; Pearl's 13 map-local vars take 0x4010-0x401C):
                                // in an elevator room, the floors above the floor the player came from (pearl_story
                                // ELEVATOR_FLOORS_ABOVE, PearlElevatorInit)

// ---- script frame ----------------------------------------------------------------------------------------------
    .macro pl_End                          // 0x02 End
    VMHalt
    .endm
    .macro pl_LockAll                      // 0x60 LockAll (pokediamond LockAllEvents)
    ActorsPauseAll
    .endm
    .macro pl_ReleaseAll                   // 0x61 ReleaseAll: Black 2 ends every script with these two
    FinishAllEvents
    ActorsUnpauseAll
    .endm
    .macro pl_FacePlayer                   // 0x68 FacePlayer: the talked-to NPC and the player face each other
    ActorSetEyeToEye
    .endm
    .macro pl_WaitTime frames, var         // 0x03 WaitTime frames, countdown var (both fields run at 30 fps)
    VMSleep \frames
    .endm

// ---- flow --------------------------------------------------------------------------------------------------------
    .macro pl_GoTo label                   // 0x16
    VMJump \label
    .endm
    .macro pl_GoToIf cond, label           // 0x1C
    VMJumpIf \cond, \label
    .endm
    .macro pl_Call label                   // 0x1A
    VMCall \label
    .endm
    .macro pl_CallIf cond, label           // 0x1D
    VMCallIf \cond, \label
    .endm
    .macro pl_Return                       // 0x1B
    VMReturn
    .endm
    .macro pl_ReturnCommonScript           // 0x15 ReturnCommonScript (pokediamond RestartCurrentScript): a Pearl common
    VMReturn                               // script is translated as a subroutine of the zone file (VMCall)
    .endm

// ---- flags, vars, comparisons --------------------------------------------------------------------------------------
    .macro pl_CompareVarToValue var, value // 0x11
    WorkCmpConst \var, \value
    .endm
    .macro pl_CompareVarToVar var1, var2   // 0x12
    WorkCmpWork \var1, \var2
    .endm
    .macro pl_CheckFlag flag               // 0x20: register = flag (0 "less", 1 "equal")
    FlagGet \flag, PL_TMP
    WorkCmpConst PL_TMP, 1
    .endm
    .macro pl_CheckFlagFromVar var         // 0x21: the flag whose number is in var (FlagGet reads a work's value)
    FlagGet \var, PL_TMP
    WorkCmpConst PL_TMP, 1
    .endm
    .macro pl_SetFlag flag                 // 0x1E
    FlagSet \flag
    .endm
    .macro pl_ClearFlag flag               // 0x1F
    FlagReset \flag
    .endm
    .macro pl_SetFlagFromVar var           // 0x22
    FlagSet \var
    .endm
    .macro pl_SetVarFromValue var, value   // 0x28 (pokediamond SetVar)
    WorkSetConst \var, \value
    .endm
    .macro pl_SetVarFromVar dst, src       // 0x29 (pokediamond CopyVar)
    WorkSet \dst, \src
    .endm
    .macro pl_AddVar var, value            // 0x26 (value: a number or a var, as Pearl's VarGet)
    WorkAdd \var, \value
    .endm
    .macro pl_SubVar var, value            // 0x27
    WorkSub \var, \value
    .endm
    .macro pl_GetRandom var, n             // 0x1B7 (pokediamond Random)
    Random \var, \n
    .endm
    .macro pl_SetTrainerFlag id            // 0x23 (Black 2 trainer flag = id + 1520)
    TrainerFlagSet \id
    .endm
    .macro pl_ClearTrainerFlag id          // 0x24
    TrainerFlagReset \id
    .endm
    .macro pl_CheckTrainerFlag id          // 0x25: register = 1 when beaten
    TrainerFlagGet \id, PL_TMP
    WorkCmpConst PL_TMP, 1
    .endm

// ---- messages: n = line of the zone's text file (src/text/script/NNNN_pearl_*.txt, 0-based) -------------------------
// Pearl has one plain message box; Black 2 shows a talking person's line in a balloon over them. The translator picks
// per Message (b2tools/pearl_story.py speaker): the talked-to NPC (pl_msg_talk), a named actor (pl_msg_actor), or no one
// (pl_msg_sys: Black 2's plain window, as Pearl's box).
    .macro pl_msg_talk n                   // 0x2C Message, said by the NPC the player talked to
    ParentActorMsg MSGFILE_SCRIPT, \n, 0, 0
    .endm
    .macro pl_msg_actor n, actor           // 0x2C Message, said by actor `actor` (uid; 255 = the player)
    ActorMsg MSGFILE_SCRIPT, \n, \actor, 0, 0
    .endm
    .macro pl_msg_sys n                    // 0x2C Message, nobody's (scenes, signs read as objects, "received")
    SystemMsg \n, 2
    .endm
    // a line naming the counterpart (Dawn for a boy, Lucas for a girl): two lines, Black 2's own gendered message
    .macro pl_msg_talk_gendered nboy, ngirl
    ActorMsgGendered MSGFILE_SCRIPT, \nboy, \ngirl, 0x8011, 0, 0
    .endm
    .macro pl_msg_actor_gendered nboy, ngirl, actor
    ActorMsgGendered MSGFILE_SCRIPT, \nboy, \ngirl, \actor, 0, 0
    .endm
    .macro pl_msg_sys_gendered nboy, ngirl
    TrainerCardGetSex PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_NE, .Lplg\@
    SystemMsg \nboy, 2
    VMJump .Lplg2\@
.Lplg\@:
    SystemMsg \ngirl, 2
.Lplg2\@:
    .endm
    .macro pl_WaitButton                   // 0x31 WaitButton (A/B, after a message)
    LastKeyWait
    .endm
    .macro pl_WaitABPress                  // 0x30
    LastKeyWait
    .endm
    .macro pl_WaitABPadPress               // 0x32 (A/B or the d-pad: Black 2 waits for A/B)
    LastKeyWait
    .endm
    .macro pl_CloseMessage                 // 0x34 (pokediamond CloseMessageBox)
    MsgWinCloseAll
    .endm
    .macro pl_CloseMessageWithoutErasing   // 0x35
    MsgWinCloseAll
    .endm
    .macro pl_ShowYesNoMenu var            // 0x3E: var 0 YES, 1 NO in both games
    YesNoWin \var
    .endm
    // signs (Pearl 0x36 DrawSignpostInstantMessage + 0x38/0x39/0x3B + common script 2000): Black 2's sign window.
    // Types: Pearl 0 map (town) -> Black 2 1, 1 arrow (route) -> 3, 2 landmark (houses) -> 2, 3 scrolling -> 0
    .macro pl_sign n, b2type
    ActorsPauseAll
    SEPlay SEQ_SE_MESSAGE
    MsgPlaceSign \n, \b2type
    MsgPlaceSignClose
    FinishAllEvents
    ActorsUnpauseAll
    .endm

// word buffers (Pearl {STRVAR_1 t, n} -> Black 2 {01tt:n}: the same buffer numbers)
    .macro pl_BufferPlayerName n           // 0xCD
    WordSetPlayerName \n
    .endm
    .macro pl_BufferRivalName n            // 0xCE: Barry = the rival name Black 2's opening asks for
    WordSetLoadRivalName \n
    .endm
    .macro pl_BufferItemName n, item       // 0xD1
    WordSetItemName \n, \item
    .endm
    // Pockets: Pearl numbers them 0 items, 1 medicine, 2 balls, 3 TMs, 4 berries, 5 mail, 6 battle items, 7 key items;
    // Black 2 0 items (balls, mail and battle items too), 1 medicine, 2 TMs, 3 berries, 4 key items (pokebw2
    // constants/bag.h). Black 2's WordSetItemPocketName takes an ITEM and names its pocket (scrcmd_word.c), so a Pearl
    // pocket is named through an item of that pocket. (Found in game 2026-10-18: the Journal "put in the ITEMS
    // Pocket" with the item jingle, as Pearl's key-item branches never ran.)
    .macro pl_BufferPocketName n, pocket   // 0xD2 (pocket: Pearl's number, as pl_GetItemPocket gives it)
    WorkSetConst PL_TMP2, ITEM_POKE_BALL   // items, balls, mail, battle items
    WorkCmpConst \pocket, 1
    VMJumpIf CMP_NE, .Lpbp1\@
    WorkSetConst PL_TMP2, ITEM_POTION
.Lpbp1\@:
    WorkCmpConst \pocket, 3
    VMJumpIf CMP_NE, .Lpbp3\@
    WorkSetConst PL_TMP2, ITEM_TM01
.Lpbp3\@:
    WorkCmpConst \pocket, 4
    VMJumpIf CMP_NE, .Lpbp4\@
    WorkSetConst PL_TMP2, ITEM_CHERI_BERRY
.Lpbp4\@:
    WorkCmpConst \pocket, 7
    VMJumpIf CMP_NE, .Lpbp7\@
    WorkSetConst PL_TMP2, ITEM_BICYCLE
.Lpbp7\@:
    WordSetItemPocketName \n, PL_TMP2
    .endm
    .macro pl_BufferSpeciesName n, species // species from a number or a var
    WordSetPokeSpecies \n, \species
    .endm
    .macro pl_BufferPartyMonSpecies n, slot    // 0xD0
    WordSetPartyPokeSpecies \n, \slot
    .endm
    .macro pl_BufferPartyMonNickname n, slot   // 0xD6
    WordSetPartyPokeName \n, \slot
    .endm
    .macro pl_BufferMoveName n, move       // 0xD4
    WordSetMoveName \n, \move
    .endm
    .macro pl_BufferTMHMMoveName n, item   // 0xD3
    WordSetTMMoveName \n, \item
    .endm
    .macro pl_BufferNumber n, value, digits=0   // 0xD5: a number (Black 2 counts its own digits with 0)
    WordSetNumber \n, \value, \digits
    .endm
    .macro pl_BufferMapName n, zone        // 0xE2: zone = a Black 2 zone
    WordSetPlaceName \n, \zone
    .endm
    .macro pl_BufferTrainerClassName n, cls    // 0xD8
    WordSetTrainerClassName \n, \cls
    .endm
    // the starters: Pearl keeps the player's choice in its save; here PVAR_STARTER (pearl.h) holds the species
    .macro pl_GetPlayerStarterSpecies var      // 0xDE
    WorkSet \var, PVAR_STARTER
    .endm
    .macro pl_BufferPlayerStarterSpeciesName n // 0xDB
    WordSetPokeSpecies \n, PVAR_STARTER
    .endm
    .macro pl_rival_starter var                // the starter strong against the player's (Turtwig > Piplup > Chimchar)
    WorkSetConst \var, SPECIES_CHIMCHAR
    WorkCmpConst PVAR_STARTER, SPECIES_TURTWIG
    VMJumpIf CMP_EQ, .Lprs\@
    WorkSetConst \var, SPECIES_PIPLUP
    WorkCmpConst PVAR_STARTER, SPECIES_CHIMCHAR
    VMJumpIf CMP_EQ, .Lprs\@
    WorkSetConst \var, SPECIES_TURTWIG
.Lprs\@:
    .endm
    .macro pl_counterpart_starter var          // the one left in the briefcase
    WorkSetConst \var, SPECIES_PIPLUP
    WorkCmpConst PVAR_STARTER, SPECIES_TURTWIG
    VMJumpIf CMP_EQ, .Lpcs\@
    WorkSetConst \var, SPECIES_TURTWIG
    WorkCmpConst PVAR_STARTER, SPECIES_CHIMCHAR
    VMJumpIf CMP_EQ, .Lpcs\@
    WorkSetConst \var, SPECIES_CHIMCHAR
.Lpcs\@:
    .endm
    .macro pl_BufferRivalStarterSpeciesName n  // 0xDC
    pl_rival_starter PL_TMP2
    WordSetPokeSpecies \n, PL_TMP2
    .endm
    .macro pl_BufferCounterpartStarterSpeciesName n    // 0xDD
    pl_counterpart_starter PL_TMP2
    WordSetPokeSpecies \n, PL_TMP2
    .endm

// ---- player and gender -------------------------------------------------------------------------------------------
    .macro pl_GetPlayerGender var          // 0x14D: Pearl 0 boy, 1 girl = Black 2's TrainerCardGetSex
    TrainerCardGetSex \var
    .endm
    .macro pl_GetPlayerMapPos varx, varz   // 0x69 (pokediamond GetPlayerPosition): the same tile numbers (matrix 0 and
    PlayerGetGPos \varx, \varz             // the rooms keep Pearl's layout)
    .endm
    .macro pl_GetPlayerDir var             // 0x1BD
    PlayerGetDir \var
    .endm

// ---- objects ---------------------------------------------------------------------------------------------------
    .macro pl_ApplyMovement actor, list    // 0x5E: actor = Pearl's local id = the Black 2 NPC uid; 255 the player
    ActorCmdExec \actor, \list
    .endm
    .macro pl_WaitMovement                 // 0x5F
    ActorCmdWait
    .endm
    .macro pl_AddObject uid                // 0x64 (Pearl clears the hide flag itself before)
    ActorAdd \uid
    .endm
    .macro pl_RemoveObject uid, flag       // 0x65: deletes the actor and sets its hide flag, as Pearl's does
    ActorDelete \uid
    .if \flag
    FlagSet \flag
    .endif
    .endm
// Pearl's item-ball script (file 370 script 256) removes the talked-to ball (RemoveEvent VAR_LAST_TALKED), and Pearl's
// RemoveEvent sets the object's flag; here the ball's own hide flag (data/pearl_item_balls.json), read from the actor
// as Black 2's item script does (global 7000 Script_401: ActorGetSpawnFlag 0x8011 + FlagSet + ActorDelete).
    .macro pl_RemoveTalkedObject
    WorkSetConst PL_TMP, 0
    ActorGetSpawnFlag 0x8011, PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lprto\@
    FlagSet PL_TMP
.Lprto\@:
    ActorDelete 0x8011
    .endm
    .macro pl_SetMovementType uid, move    // 0x6D: live actor (Black 2 move code)
    ActorSetMoveCode \uid, \move
    .endm
    .macro pl_SetPosition uid, x, y, z, dir    // 0x187: live actor
    ActorSetGPos \uid, \x, \y, \z, \dir
    .endm
// Pearl's SetObjectEventPos outside the zone init sets where an object appears when AddObject adds it; Black 2 cannot
// change its NPC list there (ObjInitNPCGPos: level 2 only), so the place goes into script works and pl_AddObjectAt sets
// the new actor there. Works 0x8030-0x803E (3 per object slot, 5 slots): script-local (ov012 ScriptWork localWork
// 0x8000-0x8061, cleared when the script starts: GFL_HeapAllocate(.., TRUE, ..)), kept across RTCallGlobal
// (ScriptWork_CreateVarCopy saves 0x8020-0x805E); x = 0 means "not set in this run" (2026-10-20: the counterpart at
// Jublife's entrance always appeared at x 175, the last of Pearl's three branches, not above the player)
#define PL_OBJ_X(slot) (0x8030 + 3 * (slot))
#define PL_OBJ_Y(slot) (0x8031 + 3 * (slot))
#define PL_OBJ_Z(slot) (0x8032 + 3 * (slot))
    .macro pl_SetObjectEventPosLater slot, uid, x, y, z, dir    // 0x186 outside the zone init
    ActorSetGPos \uid, \x, \y, \z, \dir    // (the live actor, if it is there, as before)
    WorkSet PL_OBJ_X(\slot), \x
    WorkSet PL_OBJ_Y(\slot), \y
    WorkSet PL_OBJ_Z(\slot), \z
    .endm
    .macro pl_AddObjectAt uid, slot, dir   // 0x64 after a pl_SetObjectEventPosLater of this object: there
    ActorAdd \uid
    WorkCmpConst PL_OBJ_X(\slot), 0
    VMJumpIf CMP_EQ, .Lpaoa\@
    ActorSetGPos \uid, PL_OBJ_X(\slot), PL_OBJ_Y(\slot), PL_OBJ_Z(\slot), \dir
.Lpaoa\@:
    .endm
    // event data before the actors exist (Pearl ON_TRANSITION = Black 2 zone init, level 2 only): index = position in the
    // zone's NPC list (the events patch keeps Pearl's order), y in 16-unit steps
    .macro pl_SetObjectEventPos index, x, z, dir, y=0     // 0x186 (+ the NPC's direction from its event)
    ObjInitNPCGPos \index, \dir, \x, \y, \z
    .endm
    .macro pl_SetWarpEventPos index, x, z, y=0  // 0x18A (Black 2 tiles, as Pearl's)
    ObjInitWarpGPos \index, \x, \y, \z
    .endm

    .macro pl_SetBgEventPos index, x, z, y=0    // 0x18B: a sign (BG event) moved (Black 2 tiles, y in units)
    ObjInitPointGPos \index, \x, \z, \y
    .endm

// ---- sound -----------------------------------------------------------------------------------------------------
    .macro pl_PlaySE se                    // 0x49 (pokediamond PlayFanfare)
    SEPlay \se
    .endm
    .macro pl_WaitSE se                    // 0x4B
    SEWait
    .endm
    .macro pl_StopSE se                    // 0x4A
    SEStop
    .endm
    .macro pl_PlayFanfare me               // 0x4E (pokediamond PlaySound): pauses the music, Black 2's ME
    MEPlay \me
    .endm
    .macro pl_WaitFanfare                  // 0x4F
    MEWait
    .endm
    .macro pl_PlayCry species              // 0x4C
    PVPlay \species, 0
    .endm
    .macro pl_WaitCry                      // 0x4D
    PVWait
    .endm
    .macro pl_PlayMusic bgm                // 0x50 / 0x57 SetBGM
    BGMPlay \bgm
    .endm
    .macro pl_PlayDefaultMusic             // 0x52: the zone's music again
    BGMChangeMap
    .endm
    .macro pl_FadeOutBGM frames            // 0x54
    BGMFadeOut \frames
    .endm

// ---- screen ------------------------------------------------------------------------------------------------------
    .macro pl_fade_out_black               // 0xBC FadeScreen _, _, 0 (out), black
    FadeOutBlack
    .endm
    .macro pl_fade_in_black                // 0xBC FadeScreen _, _, 1 (in), black
    FadeInBlack
    .endm
    .macro pl_fade_out_white
    FadeOutWhite
    .endm
    .macro pl_fade_in_white
    FadeInWhite
    .endm
    .macro pl_WaitFadeScreen               // 0xBD
    FadeWait
    .endm

// ---- warps ---------------------------------------------------------------------------------------------------------
    .macro pl_Warp zone, x, z, dir         // 0xBE Warp: Black 2 zone, Pearl's tile (the same tiles), dir 0-3. Black 2 puts
    MapChangeCore \zone, \x, 0, \z, \dir   // the player on the ground at the tile
    .endm
// ---- boats (Pearl 0x23D ShipAnimation: its ship scenes) -----------------------------------------------------------
// As HoennB2's boats (its src/field_scripts/common/boat.inc, notes/DECISIONS.md 2026-10-07): Black 2's own 3D boat
// cutscenes (Call3DDemo, overlay 293), which play on a closed field: fade out, FieldClose, the demo, FieldOpen on a
// black screen; then the generator's RTReserveScript + pl_Warp change the map, and the destination's arrival script
// (PearlArrive) fades in. Pearl's own docked boats stay on the maps. Pearl's ShipAnimation names the way the ship
// sails (pokeplatinum BOAT_TRAVEL_DIR_*): north-south and south-north are Canalave's regular ship, Eldritch's boat
// (Iron Island, Fullmoon and Newmoon Islands); east-west and west-east are the Snowpoint steamship (the Fight Area).
//   PL_BOAT_DEMO_SMALL = demo 4, Black 2's white motorboat (Castelia -> Unity Tower) with Castelia's pier hidden
//     (patches/boat_demos.py): a sailor's own small boat, as Eldritch's is, speeding off on the open sea;
//   PL_BOAT_DEMO_SHIP = demo 26, Black 2's Virbank ferry crossing the open sea: a big two-funnel passenger ship, as
//     Pearl's Snowpoint steamship is.
// Pearl silences the field music for its ship scenes (pokeplatinum FieldSystem_PlayBoatCutscene: SEQ_NONE), so the
// music fades out for both (demo 4 then has only its engine sounds, demo 26 its own ship music). Test from a cold boot:
// a savestate made on another build's file layout plays a black screen (HoennB2's finding).
#define PL_BOAT_DEMO_SMALL 4
#define PL_BOAT_DEMO_SHIP 26
    .macro pl_boat_ride demo
    FadeOutBlackQ
    BGMFadeOut 30
    FadeWait
    FieldClose
    Call3DDemo \demo, 0
    FieldOpen
    .endm
    .macro pl_BoatCutscene travel          // travel: Pearl's way (0 S->N, 1 E->W, 2 W->E, 3 N->S), a constant
    .if \travel == 1 || \travel == 2
    pl_boat_ride PL_BOAT_DEMO_SHIP
    .else
    pl_boat_ride PL_BOAT_DEMO_SMALL
    .endif
    .endm

// ---- the camera shake (Pearl 0x29F ShakeCamera: the Canalave Library's tremor) ----------------------------------
// Black 2's event camera shake with a rumble, the values of its own quake scenes (global 10470: "A dull sound echoed"
// 5, 0, 3, 8, 1, 0, 1, 5; "The dull sound is close!" 8, 0, 3, 15, 1, 0, 1, 5): x amplitude, y amplitude, period, steps
    .macro pl_ShakeCamera kind             // kind: Pearl's 0 (short) or 1 (long), a constant
    .if \kind == 0
    SEPlay SEQ_SE_FLD_154
    EvCameraShake 5, 0, 3, 8, 1, 0, 1, 5
    .else
    SEPlay SEQ_SE_FLD_155
    EvCameraShake 8, 0, 3, 15, 1, 0, 1, 5
    .endif
    SEWait
    .endm

// ---- Spear Pillar (chapter 7, 2026-10-26) ------------------------------------------------------------------------
// Pearl 0x20D SpearPillarSequence op, var (pokediamond ov06 SpearPillarSequence): Pearl's own effects of the summoning
// at the altar, which Black 2 has no counterpart for. Ops 1 and 6 report through the var whether the effect started by
// op 0 / op 5 is over, and the script loops until they say so (the var holds 0 from the WaitTime before it: a hang if
// nothing sets it): here the effect is a white flash, over at once. Ops 0 (the Red Chain opens the portal), 4 (the new
// galaxy) and 5 (the lake trio's power) flash white; ops 2 and 3 (an effect kept from the portal until after the tag
// battle) and 7-9 (the sky distorting at Spear Pillar, Valley Windworks, Hearthome, each shown 90 frames with Pearl's
// music) show nothing. The flash's sound is a [guess] (Black 2's Hypnosis wave).
    .macro pl_SpearPillarSequence op, var
    .if \op == 1 || \op == 6
    WorkSetConst \var, 1
    .elseif \op == 0 || \op == 4 || \op == 5
    .if \op == 0
    SEPlay SEQ_SE_W095_01
    .endif
    FadeOutWhiteQ
    FadeWait
    FadeInWhiteQ
    FadeWait
    .endif
    .endm
// Pearl 0xEE CheckHasTwoAliveMons var (pokediamond HasEnoughAlivePokemonForDoubleBattle): var = 1 if two Pokémon can
// battle (Black 2's PokePartyGetCount kind 2: not eggs, HP left), else 0 (Spear Pillar's two grunts, a double battle)
    .macro pl_CheckHasTwoAliveMons var
    PokePartyGetCount \var, 2
    WorkCmpConst \var, 2
    VMJumpIf CMP_GE, .Lptm1\@
    WorkSetConst \var, 0
    VMJump .Lptme\@
.Lptm1\@:
    WorkSetConst \var, 1
.Lptme\@:
    .endm
// Pearl 0x1B2 HideObject / 0x1B1 ShowObject (pokeplatinum MapObject_SetHidden; pokediamond names them the other way
// round): the person (or the player, 255) stays but is not drawn = Black 2's SetInvisible / SetVisible moves (69, 70,
// the same codes as Pearl's 0x45 / 0x46)
    .macro pl_HideObject actor
    ActorCmdExec \actor, .Lpho\@
    ActorCmdWait
    VMJump .Lphoe\@
    .balign 4, 0
.Lpho\@:
    Move 69, 1
    MoveEnd
.Lphoe\@:
    .endm
    .macro pl_ShowObject actor
    ActorCmdExec \actor, .Lpso\@
    ActorCmdWait
    VMJump .Lpsoe\@
    .balign 4, 0
.Lpso\@:
    Move 70, 1
    MoveEnd
.Lpsoe\@:
    .endm

// ---- items, Pokémon, money ---------------------------------------------------------------------------------------
    .macro pl_AddItem item, count, var     // 0x7B (silent, as Pearl's; var = 1 added)
    ItemAdd \item, \count, \var
    .endm
    .macro pl_RemoveItem item, count, var  // 0x7C
    ItemSub \item, \count, \var
    .endm
    .macro pl_CanFitItem item, count, var  // 0x7D
    ItemCheckSpace \item, \count, \var
    .endm
    .macro pl_CheckItem item, count, var   // 0x7E
    ItemCheckAmount \item, \count, \var
    .endm
    .macro pl_GetItemPocket item, var      // 0x80: Black 2's pocket -> Pearl's number (above)
    ItemGetPocket \item, \var
    WorkCmpConst \var, 2                   // TMs
    VMJumpIf CMP_NE, .Lpgp2\@
    WorkSetConst \var, 3
    VMJump .Lpgpe\@
.Lpgp2\@:
    WorkCmpConst \var, 3                   // berries
    VMJumpIf CMP_NE, .Lpgp3\@
    WorkSetConst \var, 4
    VMJump .Lpgpe\@
.Lpgp3\@:
    WorkCmpConst \var, 4                   // key items
    VMJumpIf CMP_NE, .Lpgp4\@
    WorkSetConst \var, 7
    VMJump .Lpgpe\@
.Lpgp4\@:
    WorkCmpConst \var, 5                   // (Black 2's free-space pocket: none in Pearl)
    VMJumpIf CMP_LT, .Lpgpe\@
    WorkSetConst \var, 0
.Lpgpe\@:
    .endm
    .macro pl_GivePokemon species, level, item, var    // 0x96: form 0 (the held item is not given: Black 2's
    PokePartyAdd \var, \species, 0, \level             // PokePartyAdd has none); flag 2401 = Black 2's "has a
    FlagSet 2401                                       // Pokemon" (set right after its own starter)
    .endm
    .macro pl_GetPartyCount var            // 0x177
    PokePartyGetCount \var, 0
    .endm
    .macro pl_HealParty                    // 0x14E (pokediamond HealParty)
    PokePartyRecoverAll
    .endm
    .macro pl_GiveMoney amount             // 0x6F (16 bits: pearl_story.py splits larger amounts)
    MoneyAdd \amount
    .endm
    .macro pl_RemoveMoney amount           // 0x70
    MoneySub \amount
    .endm
    .macro pl_GiveRunningShoes             // 0x15A: Black 2's own (flag 2403)
    GiveRunningShoes
    .endm
    .macro pl_GivePokedex                  // 0x158: Black 2's Pokedex, and flag 2402, which shows it in the start menu
    PokeDexEnable                          // (ov162 startmenu.c; Black 2's own scene sets it: aspertia_city.s)
    FlagSet 2402
    .endm

// ---- battles -------------------------------------------------------------------------------------------------------
    .macro pl_StartWildBattle species, level   // 0x124: a scripted wild battle
    CallWildBattle \species, \level, 0
    .endm
    .macro pl_StartTrainerBattle id1, id2  // 0xE5: Black 2 trainer ids (b2tools/pearl_story.py trainer registry)
    CallTrainerBattle \id1, \id2, 0
    .endm
    .macro pl_StartTagBattle partner, id1, id2 // 0x2A0: you and a partner trainer against two (Black 2's multi
    CallTrainerMultiBattle \partner, \id1, \id2, 0     // battle, as its Lacunosa scene; pl_CheckWonBattle after it)
    .endm
    .macro pl_PlayTrainerEncounterBGM id   // 0xEA: the trainer class's encounter music (patches/battle_music.py)
    TrainerBGMPlay \id
    .endm
    .macro pl_CheckWonBattle var           // 0xEC: var = 1 won; on a win Black 2 needs its battle end (the field again)
    TrainerBattleIsVictory \var
    WorkCmpConst \var, 1
    VMJumpIf CMP_NE, .Lpwb\@
    CallTrainerBattleEnd
.Lpwb\@:
    .endm
    .macro pl_CheckWonWildBattle var       // Pearl's CheckWonBattle after a wild battle
    WildBattleIsVictory \var
    WorkCmpConst \var, 1
    VMJumpIf CMP_NE, .Lpww\@
    CallWildBattleEnd
.Lpww\@:
    .endm
    .macro pl_BlackOutFromBattle           // 0xEB (after a lost trainer battle)
    CallTrainerLose
    .endm
    .macro pl_BlackOutFromWildBattle       // 0xEB after a lost wild battle
    CallWildLose
    .endm
    .macro pl_CheckLostBattle var          // 0xED after a wild (legendary) battle: var = 1 if it ended without a win
    WildBattleGetResult \var              // or a catch (fled, a draw). Black 2's result (ov012 GetWildBattleResult-
    WorkCmpConst \var, 1                  // ByCombined): 0 caught, 1 fled / draw / defeat, 2 knocked out
    VMJumpIf CMP_EQ, .Lpcl\@
    WorkSetConst \var, 0
.Lpcl\@:
    .endm
    .macro pl_CheckDidNotCapture var       // 0x2BC after a wild (legendary) battle: var = 1 if the Pokémon was not
    WildBattleGetResult \var              // caught. Black 2's result (ov012 GetWildBattleResultByCombined): 0 caught,
    WorkCmpConst \var, 0                  // 1 fled / draw / defeat, 2 knocked out (won)
    VMJumpIf CMP_EQ, .Lpdc\@
    WorkSetConst \var, 1
.Lpdc\@:
    .endm

// ---- stubs -------------------------------------------------------------------------------------------------------
// A Pearl command with no translation yet becomes `pl_stub` with its Pearl name: no code, listed per file in
// work/pearl/b2_scripts/report.txt and notes/STORY.md (never dropped silently).
    .macro pl_stub name
    .endm

// ---- doors (Pearl's door animations -> Black 2's building-model handles, ov036 scrcmd_buildmodel.c) -------------
// Pearl LoadDoorAnimation cellX, cellZ, tileX, tileZ, tag: a handle on the door prop at that tile, kept in a work per
// tag (PL_DOOR); prop kind 1 = a door (Black 2's own doors: aspertia_city.s). With no animated door there (Pearl's
// doors are plain models until the map converter gives them Black 2's door animation) the handle is 0 and the other
// commands do nothing (FieldPropSystem_GetHandleID / FindHandleByID are null-safe; BMHndAnmWait ends at once).
#define PL_DOOR(tag) (0x8048 + ((tag) & 15))
    .macro pl_LoadDoorAnimation tag, x, z
    BMCreateHandleByGPos PL_DOOR(\tag), 1, \x, \z
    .endm
    .macro pl_PlayDoorOpenAnimation tag
    BMHndAudioVisualAnmPlay PL_DOOR(\tag), 0
    .endm
    .macro pl_PlayDoorCloseAnimation tag
    BMHndAudioVisualAnmPlay PL_DOOR(\tag), 1
    .endm
    .macro pl_WaitForAnimation tag
    BMHndAnmWait PL_DOOR(\tag)
    .endm
    .macro pl_UnloadAnimation tag
    BMReleaseHandle PL_DOOR(\tag)
    .endm

// ---- more Pearl commands --------------------------------------------------------------------------------------------
    .macro pl_GetTimeOfDay var             // 0x1B6: Pearl 0 morning, 1 day, 2 evening, 3 night, 4 late night; Black 2's
    RTCGetDayPart \var                     // day period (GameData_GetDayPeriod) has the same five
    .endm
    .macro pl_GetNationalDex var           // 0x22D get
    PokeDexHaveNational \var
    .endm
    .macro pl_SetNationalDex               // 0x22D set
    PokeDexGiveNational
    .endm
    .macro pl_GetLocalDexSeenCount var     // 0x11E CountSinnohDexSeen: the regional (Sinnoh) list's seen count
    pl_DexSinnohSeen \var, 0               // (Pokédex macros at the end of this file)
    .endm
    .macro pl_GetPartyMonSpecies slot, var // 0x198
    PokePartyGetSpecies \var, \slot
    .endm
    .macro pl_CountPartyNonEggs var        // 0x19A
    PokePartyGetCount \var, 1
    .endm
    .macro pl_CheckPartyPokerus var        // 0x119
    PokePartyCheckPokerus \var
    .endm
    .macro pl_PlayPokecenterHealingAnimation count   // 0x23B: Black 2's Pokemon Center machine (balls = party count)
    PokecenPlayHealingSequence \count
    .endm
    .macro pl_OpenPokemonNamingScreen slot, var  // 0xBB: Black 2's nickname screen (as HoennB2 h_name_received_mon)
    MsgWinCloseAll
    FadeOutBlackQ
    FadeWait
    CallPokeNameInput \var, \slot, 0
    FadeInBlackQ
    FadeWait
    .endm
    .macro pl_CheckBadgeAcquired badge, var    // 0x15B (badge 0-7 in both)
    TrainerCardHasBadge \var, \badge
    .endm
    .macro pl_GiveBadge badge                  // 0x15C: Black 2's badge, its per-badge flag 2414+ and the party record
    TrainerCardSaveGymVictoryParty \badge      // (as every Black 2 gym; HoennB2 h_givebadge)
    TrainerCardAddBadge \badge
    FlagSet (2414 + \badge)
    .endm
    .macro pl_CountBadgesAcquired var          // 0x15D
    TrainerCardGetBadgeCount \var
    .endm
    .macro pl_PokeMartCommon var               // 0x147: Black 2's own Poke Mart, its stock by badges: shop id 255
    CallFriendlyShopBuy 255, PL_TMP            // (ov036 SHOP_ID_BADGE_MART, as Black 2's Centers pass to global 10110;
    .endm                                      //  shop id 0 is one town's list: Repeat/Nest/Quick Balls, mail; 2026-10-25)

// ---- the follower (Pearl: SetMovementType X, 0x30 + SetObjectFlagIsPersistent; Black 2: ov012 pair_sys.c) ----------
// Black 2's follower: ActorPairSet makes the NPC follow (move code 0x30) and renames it 0xFE (Pearl's own id for the
// follower after EventStopFollowing; Pearl's 0xF2 = the object that follows: both are PL_FOLLOWER), persistent across
// zone changes (Pearl's SetObjectFlagIsPersistent 1), with its own script; flag 0x966 is set while it follows. The same
// steps as Black 2's global scripts 10535 (start) / 10536 (end). During a script every actor is paused (LockAll), the
// follower too, and the script moves it with ActorCmdExec as any NPC (Black 2's ActorPairSetMoveEnable 1 is for the
// opposite: letting it follow while the script walks the player; Pearl's scenes move both themselves).
#define PL_FOLLOWER 0xFE
#define PL_FOLLOW_FLAG 0x966
    .macro pl_follow_start uid             // follow the player (Pearl gives the movement type again after a scene:
    FlagGet PL_FOLLOW_FLAG, PL_TMP         // already following, nothing to do)
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_EQ, .Lpfs\@
    ActorPairSet \uid, 0, 1, 0, 0          // follower slot 0, persistent, no partner trainer, keeps its own script
    Cmd_022E 254                           // (as global 10535)
.Lpfs\@:
    .endm
    .macro pl_follow_start_ally uid, trainer, keep  // follow and battle at your side (Pearl's partner var 0x403F
    FlagGet PL_FOLLOW_FLAG, PL_TMP         // + SetHasPartner: Cheryl): Black 2's follower with an ally trainer, so
    WorkCmpConst PL_TMP, 1                 // two trainers who see you are a multi battle with it (ov036
    VMJumpIf CMP_EQ, .Lpfa\@               // event_trainer_eye: GetNowFollowerAllyTrID) and wild battles a wild
    ActorPairSet \uid, 0, \keep, \trainer, 0  // multi battle (field_encount.c pairActive). keep 0: only in this
                                           // zone (ActorPairEnd gives it back its id; a warp ends the following)
    Cmd_022E 254
.Lpfa\@:
    .endm
    .macro pl_follow_hold uid, move        // Pearl gives the follower another movement type for a scene: while it
    FlagGet PL_FOLLOW_FLAG, PL_TMP         // follows, Black 2's script moves it anyway (paused); else the NPC's code
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_EQ, .Lpfh\@
    ActorSetMoveCode \uid, \move
.Lpfh\@:
    .endm
    .macro pl_follow_hold_any              // (Pearl's partner flag off for a scene: nothing to do while paused)
    .endm
    .macro pl_follow_end                   // stops following and stays as an NPC (Pearl SetObjectFlagIsPersistent X, 0)
    FlagGet PL_FOLLOW_FLAG, PL_TMP
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_NE, .Lpfe\@
    ActorPairEnd 0, 0
.Lpfe\@:
    .endm
    .macro pl_follow_leave                 // stops following and leaves the map (the scene has its own copy of the NPC)
    FlagGet PL_FOLLOW_FLAG, PL_TMP
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_NE, .Lpfl\@
    ActorPairEnd 0, 0
    ActorDelete PL_FOLLOWER
.Lpfl\@:
    .endm
    .macro pl_ApplyMovementF uid, list     // an object that may be the follower now (Black 2 renamed it 0xFE)
    FlagGet PL_FOLLOW_FLAG, PL_TMP
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_EQ, .Lpam\@
    ActorCmdExec \uid, \list
    VMJump .Lpam2\@
.Lpam\@:
    ActorCmdExec PL_FOLLOWER, \list
.Lpam2\@:
    .endm

// ---- Amity Square (Pearl script file 266; pokediamond scrcmd_amity_square.c; 2026-10-25) -------------------------
// Pearl counts every step in a saved var (pokeplatinum field_control.c SystemVars_IncrementAmitySquareStepCount, up to
// 10000); the square clears it when the walk starts and after each find, and reads it when you talk to the follower
// (a find from 200 steps on). Black 2's own saved step counter does the same (ov012 scrcmd_pedometer.c: PedometerStart
// starts it at 0 when it is off, PedometerEnd turns it off, PedometerGet reads it; it counts up to 9999; Fly, Teleport,
// the Escape Rope and a black-out turn it off, none of which can happen with a follower).
    .macro pl_ClearAmitySquareStepCount    // 0x215
    PedometerEnd
    PedometerStart
    .endm
    .macro pl_GetAmitySquareStepCount var  // 0x216
    PedometerGet \var
    .endm
// 0x217 CalcAmitySquareFoundAccessory: Pearl picks the next find's Accessory from a table per species (4 finds in 5;
// the other is one of Pearl's Berries). Black 2 has no Accessories: every find is a Berry (user 2026-10-25, "Amity
// Square: A, Pearl's Berries only"): the kind var Pearl set just before (0 Berry, 1 Accessory) becomes 0.
    .macro pl_AmitySquareBerryOnly kind, var
    WorkSetConst \kind, 0
    WorkSetConst \var, 0
    .endm

// ---- the briefcase and the first battle (Black 2's starter screen, as its Aspertia scene: aspertia_city.s) --------
// Pearl: StartChooseStarterScene (0xB4) opens the briefcase, SaveChosenStarter (0xB5) keeps the species (Pearl's var
// 0x4030; index 0/1/2 = Turtwig/Chimchar/Piplup, pokediamond overlay 64), ReturnToField (0xA1), then a fade in.
// Black 2: callPoke3Select gives 0/1/2 = the left/middle/right ball, which patches/pearl_starters.py makes Turtwig,
// Chimchar, Piplup. Black 2 keeps the index in work 0x4030 (its own code reads it); PVAR_STARTER holds the species.
#define PL_STARTER_INDEX 0x8042
    .macro pl_StartChooseStarterScene
    WorkSetConst PL_STARTER_INDEX, 0
    FieldClose
    callPoke3Select PL_STARTER_INDEX
    .endm
    .macro pl_SaveChosenStarter
    WorkSet 0x4030, PL_STARTER_INDEX
    WorkSetConst PVAR_STARTER, SPECIES_TURTWIG
    Cmd_0209 8, 3                          // (Black 2's survey answer: grass 3, fire 1, water 2)
    WorkCmpConst PL_STARTER_INDEX, 1
    VMJumpIf CMP_NE, .Lpss\@
    WorkSetConst PVAR_STARTER, SPECIES_CHIMCHAR
    Cmd_0209 8, 1
.Lpss\@:
    WorkCmpConst PL_STARTER_INDEX, 2
    VMJumpIf CMP_NE, .Lpss2\@
    WorkSetConst PVAR_STARTER, SPECIES_PIPLUP
    Cmd_0209 8, 2
.Lpss2\@:
    .endm
// Pearl's party select (0x191 ChoosePokemonMenu, 0x193 GetSelectedPartySlot; pearl_story poke_select_fades): Black 2's
// CallPokeSelect (ov036 s0107: flag 0 = the plain party list; picked = 1 when a Pokemon was chosen, index = its slot;
// ov020 EventPokeSelect_Callback fades, closes and reopens the field itself). Pearl's slot is 0xFF when cancelled.
#define PL_PSEL_PICKED 0x8044
#define PL_PSEL_SLOT 0x8045
    .macro pl_ChoosePokemonMenu
    CallPokeSelect 0, PL_PSEL_PICKED, PL_PSEL_SLOT, 0
    .endm
    .macro pl_GetSelectedPartySlot var
    WorkSet \var, PL_PSEL_SLOT
    WorkCmpConst PL_PSEL_PICKED, 1
    VMJumpIf CMP_EQ, .Lpgsps\@
    WorkSetConst \var, 255
.Lpgsps\@:
    .endm
    .macro pl_ReturnToField                // 0xA1
    FieldOpen
    .endm
    .macro pl_fade_in_after_starter        // Black 2's starter screen leaves the screens white (psel.c PselProc_Exit)
    FadeInWhiteQ
    .endm
    // Pearl FirstBattle species, level (0x125: a wild battle with no loss branch in Pearl's script). Here a wild battle;
    // a loss heals the party and the scene goes on (as Black 2's first Hugh battle; a whiteout would replay the lake and
    // give a second starter: notes/STORY.md question). Pearl's map script removes the Starly when the field reloads.
    .macro pl_StartFirstBattle species, level
    CallWildBattle \species, \level, 0
    WildBattleIsVictory PL_TMP
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_EQ, .Lpfb\@
    PokePartyRecoverAll
.Lpfb\@:
    CallWildBattleEnd
    .endm
    // Pearl StartCatchingTutorial (0x126: the counterpart's starter Lv 5 catches a Bidoof Lv 2, pokeplatinum
    // FieldBattleDTO_NewCatchingTutorial): Black 2's capture demo as Black 2's Route 19 scene (CallCaptureDemo then
    // CallWildBattleEnd), made Pearl's by patches/capture_demo.py (Pokémon, moves, back picture, lines)
    .macro pl_StartCatchingTutorial
    CallCaptureDemo
    CallWildBattleEnd
    .endm
#define PL_STEP_FLAG 0x51              // Pearl's "step" flag (sys flag 0x965) as a map-local flag (see pearl_story.py)
    .macro pl_GetFirstNonEggInParty var    // 0x247: the first party slot that is not an Egg (HoennB2 h_get_lead_mon)
    WorkSetConst \var, 0
.Lpln\@:
    PokePartyIsEgg PL_TMP, \var
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lpln2\@
    WorkAdd \var, 1
    VMJump .Lpln\@
.Lpln2\@:
    .endm

// ---- the Pokédex: counts and the professors' ratings (2026-10-20) ---------------------------------------------------
// Black 2's regional list is Pearl's Sinnoh #1-#151 (patches/sinnoh_dex.py: Victini kept as the hidden #000). Black 2's
// regional counts (PokeDexGetEvaluationParams 2/3: PokeDex_GetSeenNoUnova / GetCaughtNoUnova) count Victini too; Pearl's
// (pokediamond arm9/src/pokedex.c) count the 151 Sinnoh species, and its "omit mythicals" counts leave out Manaphy
// (Sinnoh) or Mew, Lugia, Ho-Oh, Celebi, Jirachi, Deoxys, Phione, Manaphy, Darkrai, Shaymin, Arceus (National).
// Pearl's "Sinnoh Pokédex complete" (CheckLocalDexCompleted) = PokeDexIsComplete 2 (sinnoh_dex: seen without Manaphy
// >= 150, Pearl's Pokedex_SinnohDexIsComplete).
#define PL_DEX 0x8043          // the Pokédex macros' count (never a Pearl var)
    .macro pl_DexSinnohSeen var, nomyth    // Pearl Pokedex_CountSinnohDexSeen (nomyth 1: _OmitMythicals)
    PokeDexGetEvaluationParams 2, PL_TMP, \var, PL_TMP
    PokeDexIsRegist 0, SPECIES_VICTINI, PL_TMP
    WorkSub \var, PL_TMP
    .if \nomyth
    PokeDexIsRegist 0, SPECIES_MANAPHY, PL_TMP
    WorkSub \var, PL_TMP
    .endif
    .endm
    .macro pl_DexNationalCaughtNoMythical var  // Pearl Pokedex_CountNationalDexOwned_OmitMythicals (Black 2 counts 1-649)
    PokeDexGetCount 1, \var
    .irp sp, SPECIES_MEW, SPECIES_LUGIA, SPECIES_HO_OH, SPECIES_CELEBI, SPECIES_JIRACHI, SPECIES_DEOXYS, SPECIES_PHIONE, SPECIES_MANAPHY, SPECIES_DARKRAI, SPECIES_SHAYMIN, SPECIES_ARCEUS
    PokeDexIsRegist 1, \sp, PL_TMP
    WorkSub \var, PL_TMP
    .endr
    .endm
    .macro pl_GetNationalDexSeenCount var  // 0x120 CountNationalDexSeen
    PokeDexGetCount 0, \var
    .endm
    .macro pl_GetNationalDexCaughtCount var    // 0x121 CountNationalDexOwned
    PokeDexGetCount 1, \var
    .endm
    .macro pl_CheckLocalDexCompleted var   // 0x1E8 CheckSinnohDexComplete
    PokeDexIsComplete \var, 2
    .endm
    .macro pl_CheckLocalDexCompletedOrChampion var  // 0x1E8 where it gates Oak's National Pokédex: 1 also once the
    FlagGet 2400, \var                     // game-clear flag is set (user 2026-10-26: the National Pokédex at
    WorkCmpConst \var, 1                   // Champion; pearl_story NATIONAL_DEX_AT_CHAMPION)
    VMJumpIf CMP_EQ, .Lpcsc\@
    PokeDexIsComplete \var, 2
.Lpcsc\@:
    .endm
    // a step of the rating chains below: the count is at least `min` -> var = line
    .macro pl_dex_tier var, min, line, done
    WorkCmpConst PL_DEX, \min
    VMJumpIf CMP_LT, \done
    WorkSetConst \var, \line
    .endm
    // 0x123 LoadPokedexRating 0, var (Rowan; pokediamond ScrCmd_GetDexEvaluationMessage -> sub_02054CC8): var = the
    // line for the Sinnoh seen count without Manaphy: up to 14 / 24 / 39 / 59 / 89 / 114 / 134 / 144 / 149 -> Pearl's bank
    // 335 lines 6-14; all 150 -> line 4 when Pearl's flag 0x9BA is set, else 5. l4..l14: those lines' numbers in the
    // calling script's own text file (MessageVar prints var).
    .macro pl_LoadPokedexRatingLocal var, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14
    pl_DexSinnohSeen PL_DEX, 1
    WorkSetConst \var, \l6
    pl_dex_tier \var, 15, \l7, .Lpdr\@
    pl_dex_tier \var, 25, \l8, .Lpdr\@
    pl_dex_tier \var, 40, \l9, .Lpdr\@
    pl_dex_tier \var, 60, \l10, .Lpdr\@
    pl_dex_tier \var, 90, \l11, .Lpdr\@
    pl_dex_tier \var, 115, \l12, .Lpdr\@
    pl_dex_tier \var, 135, \l13, .Lpdr\@
    pl_dex_tier \var, 145, \l14, .Lpdr\@
    pl_dex_tier \var, 150, \l5, .Lpdr\@
    FlagGet PFLAG_09BA, PL_TMP
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_NE, .Lpdr\@
    WorkSetConst \var, \l4
.Lpdr\@:
    .endm
    // 0x123 LoadPokedexRating 1, var (Oak; sub_02054D1C): the National caught count without Pearl's 11 mythicals: up to
    // 39 / 59 / 89 / 119 / 149 / 189 / 229 / 269 / 309 / 349 / 379 / 409 / 429 / 449 / 459 / 469 / 475 / 481 -> lines
    // 19-37 (429: 31 for a boy, 32 for a girl); 482 -> 38 boy / 39 girl (the same words). l19..l39: the lines' numbers.
    .macro pl_LoadPokedexRatingNational var, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39
    pl_DexNationalCaughtNoMythical PL_DEX
    TrainerCardGetSex PL_TMP2
    WorkSetConst \var, \l19
    pl_dex_tier \var, 40, \l20, .Lpdn\@
    pl_dex_tier \var, 60, \l21, .Lpdn\@
    pl_dex_tier \var, 90, \l22, .Lpdn\@
    pl_dex_tier \var, 120, \l23, .Lpdn\@
    pl_dex_tier \var, 150, \l24, .Lpdn\@
    pl_dex_tier \var, 190, \l25, .Lpdn\@
    pl_dex_tier \var, 230, \l26, .Lpdn\@
    pl_dex_tier \var, 270, \l27, .Lpdn\@
    pl_dex_tier \var, 310, \l28, .Lpdn\@
    pl_dex_tier \var, 350, \l29, .Lpdn\@
    pl_dex_tier \var, 380, \l30, .Lpdn\@
    pl_dex_tier \var, 410, \l31, .Lpdn\@
    WorkCmpConst PL_TMP2, 0
    VMJumpIf CMP_EQ, .Lpdn1\@
    WorkSetConst \var, \l32
.Lpdn1\@:
    pl_dex_tier \var, 430, \l33, .Lpdn\@
    pl_dex_tier \var, 450, \l34, .Lpdn\@
    pl_dex_tier \var, 460, \l35, .Lpdn\@
    pl_dex_tier \var, 470, \l36, .Lpdn\@
    pl_dex_tier \var, 476, \l37, .Lpdn\@
    pl_dex_tier \var, 482, \l38, .Lpdn\@
    WorkCmpConst PL_TMP2, 0
    VMJumpIf CMP_EQ, .Lpdn\@
    WorkSetConst \var, \l39
.Lpdn\@:
    .endm

// ---- closed places (data/pearl_closed_facilities.json, b2tools/pearl_story.py CLOSED; 2026-10-25, chapters 4a/5a)
// A place Pearl has and this game does not build yet (the Contest counters, Amity Square, the Great Marsh): a short
// line in the plain window, then the player takes one step in direction `dir` (Pearl's 0 up, 1 down, 2 left, 3 right:
// WALK_NORMAL_NORTH 12 + dir in both games); dir 4 or more: no step (a person or sign talked to).
    .macro pl_closed_facility line, dir
    pl_LockAll
    pl_msg_sys \line
    pl_WaitButton
    pl_CloseMessage
    .if \dir < 4
    pl_ApplyMovement PL_PLAYER, .Lpcf_step\@
    pl_WaitMovement
    VMJump .Lpcf_end\@
    .balign 4, 0
.Lpcf_step\@:
    Move 12 + \dir, 1
    MoveEnd
.Lpcf_end\@:
    .endif
    pl_ReleaseAll
    .endm

// ---- the post-game's events built in (2026-10-26, chapter 9a; DECISIONS 2026-10-25) ------------------------------
// The deliveryman: Pearl's Mystery Gift man (globals 10200 / 10201 in every Pokémart, pearl_story h_mystery_gift)
// gives Pearl's four event gifts after the Hall of Fame (Black 2's game clear 2400 = Pearl's 0x964), one a talk, in
// the user's order: 0 the Member Card (454: Darkrai), 1 Oak's Letter (452: Shaymin), 2 the Azure Flute (455:
// Arceus), 3 the Manaphy Egg (490). PVAR_DELIVERY = how many were given; his map script hides him once it is 4.
    .macro pl_DeliveryWaiting var          // MysteryGiftGive 1: var = 1 after the Hall of Fame while gifts remain
    FlagGet 2400, \var
    WorkCmpConst PVAR_DELIVERY, 4
    VMJumpIf CMP_LT, .Lpdw\@
    WorkSetConst \var, 0
.Lpdw\@:
    .endm
    .macro pl_DeliveryCanReceive var       // MysteryGiftGive 3: the Egg needs room in the party; key items always fit
    WorkSetConst \var, 1
    WorkCmpConst PVAR_DELIVERY, 3
    VMJumpIf CMP_NE, .Lpdc\@
    PokePartyGetCount PL_TMP, 0
    WorkCmpConst PL_TMP, 6
    VMJumpIf CMP_LT, .Lpdc\@
    WorkSetConst \var, 0
.Lpdc\@:
    .endm
    .macro pl_DeliveryGive                 // MysteryGiftGive 4: the next gift into the Bag / the party
    WorkCmpConst PVAR_DELIVERY, 0
    VMJumpIf CMP_NE, .Lpdg1\@
    ItemAdd 454, 1, PL_TMP                 // the Member Card
    VMJump .Lpdge\@
.Lpdg1\@:
    WorkCmpConst PVAR_DELIVERY, 1
    VMJumpIf CMP_NE, .Lpdg2\@
    ItemAdd 452, 1, PL_TMP                 // Oak's Letter
    VMJump .Lpdge\@
.Lpdg2\@:
    WorkCmpConst PVAR_DELIVERY, 2
    VMJumpIf CMP_NE, .Lpdg3\@
    ItemAdd 455, 1, PL_TMP                 // the Azure Flute
    VMJump .Lpdge\@
.Lpdg3\@:
    PokePartyAddEgg PL_TMP, 490, 0         // the Manaphy Egg (Pearl: the Pokémon Ranger's gift)
.Lpdge\@:
    WorkAdd PVAR_DELIVERY, 1
    .endm
    .macro pl_CheckDistributionEvent event, var  // Pearl 0x28B: var = 1 once the deliveryman gave the event's item
    WorkSetConst \var, 0                   // (event 0 Member Card, 1 Oak's Letter, 2 Azure Flute: his order)
    WorkCmpConst PVAR_DELIVERY, \event
    VMJumpIf CMP_LE, .Lpcde\@
    WorkSetConst \var, 1
.Lpcde\@:
    .endm
// Pearl's hidden places (SetHiddenLocation 2 the Spring Path, 3 the Seabreak Path): Black 2's map replacement events
// (ov012 map_replace.c EVENT_MAP_REPLACE_TABLE: uid 7 = work 0x4038 == 0x408, uid 9 = work 0x403A == 0x1028, the same
// number as Pearl's own Seabreak magic) swap the matrix cells (patches/pearl_hidden_paths.py writes a/0/1/0's entries)
#define PL_HIDDEN_EVENT_SPRING 7
#define PL_HIDDEN_EVENT_SEABREAK 9
    .macro pl_SetHiddenLocation place
    .if \place == 2                       // (set indoors: Rowan's lab, the Hall of Fame: nothing to reload)
    MapReplaceSetEvent PL_HIDDEN_EVENT_SPRING, 1, 0
    .elseif \place == 3                   // (on Route 224: matrix 0 reloaded with the path, as Black 2's own scripts)
    MapReplaceSetEvent PL_HIDDEN_EVENT_SEABREAK, 1, 1
    .endif
    .endm
    .macro pl_CheckHasAllLegendaryTitansInParty var  // Pearl 0x26B CheckRegis: Regirock, Regice, Registeel
    WorkSetConst \var, 0
    PokePartyFindBySpecies 377, PL_TMP, PL_TMP2
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_NE, .Lpcr\@
    PokePartyFindBySpecies 378, PL_TMP, PL_TMP2
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_NE, .Lpcr\@
    PokePartyFindBySpecies 379, PL_TMP, PL_TMP2
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_NE, .Lpcr\@
    WorkSetConst \var, 1
.Lpcr\@:
    .endm
// Route 224's stone tablet (Pearl 0x271 / 0x272): Black 2's word-set name input (ov036 event_name_entry.c
// EventPokeNameWordSetInput: result 0 = cancelled or nothing typed, 1 / 2 = a name, into word buffer 1, which Pearl's
// "You most want to express your thanks to {1}?" reads), the player's starter as the screen's icon; var = 1 for
// "nothing written", as Pearl's
    .macro pl_OpenShayminTabletNamingScreen var
    MsgWinCloseAll
    CallWordSetPokeNameInput PVAR_STARTER, 1, \var
    WorkCmpConst \var, 0
    VMJumpIf CMP_EQ, .Lpts0\@
    WorkSetConst \var, 0
    VMJump .Lptse\@
.Lpts0\@:
    WorkSetConst \var, 1
.Lptse\@:
    .endm

// ---- the Day Care (2026-10-25, chapter 4b): Pearl's Day-Care Man and Lady (global scripts 9500/9501, file 464) on
// Black 2's own Day Care (ov012 scrcmd_sodateya.c, ov036 sodateya.c: the same save slots, compacted when one leaves;
// its egg comes by steps everywhere, as Pearl's). Pearl's semantics from pokediamond scrcmd_daycare.c / ov05.
#define PL_DC_SEX 0x8046                    // BufferDaycareNicknameLevelGender's gender (0 none, 1 male, 2 female)
    .macro pl_BufferDaycareMonNicknames        // 0x16D: buffer 0 the first Pokemon's nickname, 1 the second's (Pearl
    DayCareGetPkmCount PL_TMP                  // also puts the first's trainer in 2: no Pearl line shows it)
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lpbdn\@
    WordSetDaycarePokeName 0, 0
    WorkCmpConst PL_TMP, 2
    VMJumpIf CMP_NE, .Lpbdn\@
    WordSetDaycarePokeName 1, 1
.Lpbdn\@:
    .endm
    .macro pl_GetDaycareState var              // 0x16E: 1 an Egg waits, else 0 / 2 / 3 for 0 / 1 / 2 Pokemon
    DayCareCheckSpawnFlag PL_TMP
    WorkSetConst \var, 1
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_NE, .Lpgds\@
    DayCareGetPkmCount \var
    WorkCmpConst \var, 0
    VMJumpIf CMP_EQ, .Lpgds\@
    WorkAdd \var, 1
.Lpgds\@:
    .endm
    .macro pl_CheckDaycareHasEgg var           // 0x1BF: 1 when an Egg waits
    DayCareCheckSpawnFlag \var
    .endm
    .macro pl_GetDaycareCompatibilityLevel var // 0x1BE: Pearl's 0-3 from the egg chance 70 / 50 / 20 / 0 (Black 2's
    DayCareCalcEggSpawnChance PL_TMP           // 88 / 80 / 40 with the Oval Charm)
    WorkSetConst \var, 3
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lpgdc\@
    WorkSetConst \var, 2
    WorkCmpConst PL_TMP, 50
    VMJumpIf CMP_LT, .Lpgdc\@
    WorkSetConst \var, 1
    WorkCmpConst PL_TMP, 70
    VMJumpIf CMP_LT, .Lpgdc\@
    WorkCmpConst PL_TMP, 80
    VMJumpIf CMP_EQ, .Lpgdc\@
    WorkSetConst \var, 0
.Lpgdc\@:
    .endm
    .macro pl_CountAliveMonsAndBoxMons var     // 0x19C: party Pokemon able to battle + every Pokemon in the boxes
    PokePartyGetCount \var, 2
    BoxGetCount PL_TMP, 0
    WorkAdd \var, PL_TMP
    .endm
    .macro pl_CountAliveMonsExcept var, slot   // 0x19B: party Pokemon able to battle, not counting that slot's
    PokePartyGetCount \var, 2
    PokePartyIsEgg PL_TMP, \slot
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_NE, .Lpcame\@
    PokePartyGetParam PL_TMP, \slot, 160       // PKM_PARAM_HP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lpcame\@
    WorkSub \var, 1
.Lpcame\@:
    .endm
    .macro pl_OpenPartyMenuForDaycare var      // 0x290: Black 2's Day Care list (fades and reopens the field itself;
    DayCareCallPokeSelect PL_PSEL_SLOT         // its summary is in the list: Pearl's cursor var is not needed)
    .endm
    .macro pl_GetDayCarePartyMenuResult slot, summary   // 0x291: the slot (255 cancelled); no summary asked (0)
    WorkSetConst \summary, 0
    WorkSet \slot, PL_PSEL_SLOT
    PokePartyGetCount PL_TMP, 0
    WorkCmpWork PL_PSEL_SLOT, PL_TMP
    VMJumpIf CMP_LT, .Lpgdr\@
    WorkSetConst \slot, 255
.Lpgdr\@:
    .endm
    .macro pl_BufferPartyMonNicknameReturnSpecies slot, var   // 0x1AF: buffer 0 the party Pokemon's nickname
    WordSetPartyPokeName 0, \slot
    PokePartyGetSpecies \var, \slot
    .endm
    .macro pl_StorePartyMonIntoDaycare slot    // 0x1B0
    DayCareDeposit \slot
    .endm
    .macro pl_BufferDaycareGainedLevelsBySlot var, slot   // 0x1AE: levels gained; buffer 0 the nickname, 1 the number
    DayCareCalcLevelGain \var, \slot
    WordSetDaycarePokeName 0, \slot
    WordSetNumber 1, \var, 3
    .endm
    .macro pl_BufferDaycarePriceBySlot var, slot   // 0x1AA: the price; buffer 0 the nickname, 1 the price
    DayCareCalcWithdrawCost \var, \slot
    WordSetDaycarePokeName 0, \slot
    WordSetNumber 1, \var, 5
    .endm
    .macro pl_BufferDaycareNicknameLevelGender name, level, slot   // 0x1BC: the nickname, the level now; the gender
    WordSetDaycarePokeName \name, \slot        // in PL_DC_SEX (the menu line's copy with the symbol: pearl_story)
    DayCareCalcNewLevel PL_TMP, \slot
    WordSetNumber \level, PL_TMP, 3
    DayCareGetSexForNamePrint PL_DC_SEX, 0, \slot
    .endm
    .macro pl_MoveMonToPartyFromDaycareSlot var, slot   // 0x1A4: back to the party; buffer 0 the nickname, var the species
    DayCareGetSpecies \var, \slot
    WordSetDaycarePokeName 0, \slot
    DayCareWithdraw \slot
    .endm

// ---- the Solaceon News Press (2026-10-25, chapter 4b): Pearl's assignment is a random Pokemon the player has seen,
// to bring the same day (pokediamond ScrCmd_Unk0218-021A: a deadline counted in days in its save). Here the species by
// a walk over the Pokedex's seen flags (Pearl's own species, 1-493; Pearl takes its Sinnoh Pokedex's only, which is
// all a player sees before the National Pokedex), the day by PFLAG_NEWS_PRESS_TODAY (Black 2 clears it at midnight).
#define PL_TMP3 0x8047
    .macro pl_GetRandomSeenSpecies var         // 0x218: the r-th seen species, r random (Pikachu when none, as Pearl)
    WorkSetConst \var, 25
    PokeDexGetCount 0, PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lpgrs_end\@
    Random PL_TMP2, PL_TMP
    WorkSetConst PL_TMP, 0
.Lpgrs_loop\@:
    WorkAdd PL_TMP, 1
    WorkCmpConst PL_TMP, 494
    VMJumpIf CMP_EQ, .Lpgrs_end\@
    PokeDexIsRegist 0, PL_TMP, PL_TMP3
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_EQ, .Lpgrs_loop\@
    WorkCmpConst PL_TMP2, 0
    VMJumpIf CMP_EQ, .Lpgrs_found\@
    WorkSub PL_TMP2, 1
    VMJump .Lpgrs_loop\@
.Lpgrs_found\@:
    WorkSet \var, PL_TMP
.Lpgrs_end\@:
    .endm

// ---- elevators (pearl_story ELEVATOR_FLOORS_ABOVE; 2026-10-25, chapter 4a) -----------------------------------------
// Pearl's ElevatorAnimation (0x23C) shakes the room while it rides; Black 2 has no shaking room, so the ride is Black 2's
// own elevator sounds (global 10405, Castelia's lifts: SEQ_SE_FLD_23 while it moves, SEQ_SE_FLD_87 on arrival) over
// about as long as Pearl's four shakes.
    .macro pl_elevator_ride
    SEPlay SEQ_SE_FLD_23
    VMSleep 45
    SEStop
    SEPlay SEQ_SE_FLD_87
    SEWait
    .endm

// ---- Pearl's Pastoria Gym (chapter 5a, 2026-10-25) --------------------------------------------------------------
    // 0x170 CheckPastoriaGymButton (pokeplatinum PastoriaGym_PressButton): the button under the player moves the gym's
    // water (blue: the top, green: the middle, orange: the bottom), and the script waits until it stops. The decomp's
    // src/pearlb2/pastoria_gym_itcm.c (gimmick 30 of the gym's zone, patches/pastoria_gym.py) moves it while
    // PVAR_PASTORIA_GYM_PRESS is 1 and sets it back to 0. Without that code the wait gives up after 8 s (240 frames).
    // The sound is a [guess] for Pearl's SEQ_SE_DP_FW056 (water moving): Humilau Gym's platform ride.
    .macro pl_PressPastoriaGymButton
    SEPlay SEQ_SE_SW_MIZUGYM_01
    WorkSetConst PVAR_PASTORIA_GYM_PRESS, 1
    WorkSetConst PL_TMP, 0
.Lpgb\@:
    VMSleep 1
    WorkAdd PL_TMP, 1
    WorkCmpConst PL_TMP, 240
    VMJumpIf CMP_GE, .Lpgbx\@
    WorkCmpConst PVAR_PASTORIA_GYM_PRESS, 0
    VMJumpIf CMP_NE, .Lpgb\@
.Lpgbx\@:
    WorkSetConst PVAR_PASTORIA_GYM_PRESS, 0
    .endm

// ---- Chapter 8 (2026-10-26): the Sunyshore Gym's gears, the League's scripted lift, the Hall of Fame -------------
    // A request to the zone's PearlB2 gimmick (PVAR_GIMMICK_REQUEST, map-local: the lead's one handshake work): set it,
    // then wait until the gimmick's C sets it back to 0 (at most \frames frames: without the gimmick the script goes on)
    .macro pl_gimmick_request value, frames
    WorkSetConst PVAR_GIMMICK_REQUEST, \value
    WorkSetConst PL_TMP, 0
.Lgrq\@:
    VMSleep 1
    WorkAdd PL_TMP, 1
    WorkCmpConst PL_TMP, \frames
    VMJumpIf CMP_GE, .Lgrqx\@
    WorkCmpConst PVAR_GIMMICK_REQUEST, 0
    VMJumpIf CMP_NE, .Lgrq\@
.Lgrqx\@:
    WorkSetConst PVAR_GIMMICK_REQUEST, 0
    .endm
    // 0x176 RotateSunyshoreGymGear type (0 a quarter turn, 1 a quarter back, 2 a half turn; pokeplatinum
    // SunyshoreGym_PressButton): every gear of the room turns 5.625 degrees a frame (16 or 32 frames), the script waits.
    // The decomp's src/pearlb2/sunyshore_gym_itcm.c (gimmick 62) plays the sound and turns them while the request is
    // 1 + type.
    .macro pl_RotateSunyshoreGymGear type
    pl_gimmick_request (1 + \type), 120
    .endm
    // Pearl's TriggerPlatformLift from a script (Cynthia's room after her battle, the player on the lift): gimmick 59
    // (pearl_platforms_itcm.c) rides the zone's lift with the player while the request is 1 (240 units at 2 a frame)
    .macro pl_TriggerPlatformLiftRide
    pl_gimmick_request 1, 300
    .endm
    // 0x28F (Pearl's League win count: the Hall of Fame room's first-time lines at 0, Fight Area Barry's team at 20):
    // Black 2's record of Hall of Fame entries (RECORD_HALL_OF_FAME_ENTRIES 71, which its game clear counts:
    // ov295 game_clear_save.c), 0 before the first, as Pearl's count
    .macro pl_GetLeagueVictories var
    RecordGet 71, \var
    .endm
    // 0x25A PlayHallOfFameHealingAnimation: Pearl's machine takes the party's balls with the healing tune. Black 2's
    // machine event needs its own Hall of Fame props, so: the tune (Black 2's Pokémon Center heal ME)
    .macro pl_PlayHallOfFameHealingAnimation
    MEPlay SEQ_ME_ASA
    MEWait
    .endm
    // 0xB0 ShowEndGameScreen: Black 2's own Hall of Fame ending, as its script ends it (pokemon_league_10.s): the
    // field's fade, CallGameClear (0 the first time: Black 2's game-clear flag 2400 = Pearl's 0x964 not yet set; 1 after,
    // the credits skippable), FinishAllEvents, unpause, end. CallGameClear runs the record screen, global 9601 (heal,
    // Continue in the player's room: src/field_scripts/1242_global_9600.s), the save, the credits and THE END
    // (PearlB2's ending places: the decomp's event_game_clear.c). Ending any other way (a raw GFL fade, a VMHalt
    // straight after CallGameClear) left HoennB2 on a black screen on melonDS and hardware (HoennB2 2fd355b).
    .macro pl_ClearGame
    MsgWinCloseAll
    FlagGet PFLAG_0964, PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_NE, .Lcga\@
    FlagSet PFLAG_0964
    FadeOutBlackQ
    FadeWait
    CallGameClear 0
    VMJump .Lcge\@
.Lcga\@:
    FadeOutBlackQ
    FadeWait
    CallGameClear 1
.Lcge\@:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt
    .endm

// ---- Pearl's Great Marsh as a normal area (chapter 5a, 2026-10-25; HoennB2's Safari Zone rule) -------------------
    // 0x202 EnableDisableSafariZone 0: Pearl's 30 Safari Balls into the Bag (no step count, no Safari battle screen)
    .macro pl_SafariStart
    ItemAdd ITEM_SAFARI_BALL, 30, PL_TMP
    .endm
    // 0x202 EnableDisableSafariZone 1: the Safari Balls left are taken back (HoennB2 c8b_take_safari_balls)
    .macro pl_SafariEnd
    ItemGetCount ITEM_SAFARI_BALL, PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lpse\@
    ItemSub ITEM_SAFARI_BALL, PL_TMP, PL_TMP2
.Lpse\@:
    .endm

// ---- move tutors (2026-10-26, chapter 5b: Grandma Wilma's Draco Meteor on Route 210 N; Route 228's ultimate moves,
// chapter 9, use the same) ------------------------------------------------------------------------------------------
    // 0x248 GetPartyMonTypes type1, type2, slot: Black 2's PokePartyGetTypes (the same order), its numbers made Gen 4's
    // (Gen 4 has the ??? type at 9, so Fire and every type after it is one higher: Dragon 16, Dark 17)
    .macro pl_GetPartyMonTypes t1, t2, slot
    PokePartyGetTypes \t1, \t2, \slot
    WorkCmpConst \t1, 9
    VMJumpIf CMP_LT, .Lgpt1\@
    WorkAdd \t1, 1
.Lgpt1\@:
    WorkCmpConst \t2, 9
    VMJumpIf CMP_LT, .Lgpt2\@
    WorkAdd \t2, 1
.Lgpt2\@:
    .endm
    // 0x224 OpenMoveTutorMenu slot, move (pokeplatinum ScrCmd_OpenMoveTutorMenu: the Move Reminder app showing that one
    // move, between a fade-out and RestoreOverworld + a fade-in, which the generator drops here) and 0x225
    // CheckLearnedTutorMove var (0 learned, 0xFF not). The app's own choices and lines (Pearl bank 586, the line numbers
    // the generator passes) on Black 2's commands, on the field: teach it? (no: give up?), a free move slot takes it
    // (PokePartyLearnMove), a Pokémon with four goes to Black 2's forget-a-move screen (CallPokeMoveReplace, as Black 2's
    // own tutors); no Heart Scale. The result waits in PL_TMP2 for pl_CheckLearnedTutorMove.
    .macro pl_OpenMoveTutorMenu slot, move, lteach, lgiveup, llearned, ltrying, lpoof, llearned2, lstop, ldidnot
.Lmta\@:
    WordSetPartyPokeName 0, \slot
    WordSetMoveName 1, \move
    SystemMsg \lteach, 2
    YesNoWin PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lmtt\@
    SystemMsg \lgiveup, 2
    YesNoWin PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_NE, .Lmta\@
    WorkSetConst PL_TMP2, 255
    VMJump .Lmte\@
.Lmtt\@:
    PokePartyGetMoveCount PL_TMP, \slot
    WorkCmpConst PL_TMP, 4
    VMJumpIf CMP_EQ, .Lmtf\@
    PokePartyLearnMove \slot, PL_TMP, \move
    MEPlay SEQ_ME_LVUP
    SystemMsg \llearned, 2
    MEWait
    WorkSetConst PL_TMP2, 0
    VMJump .Lmte\@
.Lmtf\@:
    WordSetPartyPokeName 0, \slot
    WordSetMoveName 1, \move
    SystemMsg \ltrying, 2
    YesNoWin PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_EQ, .Lmtr\@
    SystemMsg \lstop, 2
    YesNoWin PL_TMP
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_NE, .Lmtf\@
    SystemMsg \ldidnot, 2
    WorkSetConst PL_TMP2, 255
    VMJump .Lmte\@
.Lmtr\@:
    MsgWinCloseAll
    CallPokeMoveReplace PL_TMP3, PL_TMP, \slot, \move
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, .Lmtf\@
    PokePartyGetMove PL_TMP3, \slot, PL_TMP
    WordSetPartyPokeName 0, \slot
    WordSetMoveName 1, PL_TMP3
    SystemMsg \lpoof, 2
    PokePartyLearnMove \slot, PL_TMP, \move
    WordSetMoveName 1, \move
    MEPlay SEQ_ME_LVUP
    SystemMsg \llearned2, 2
    MEWait
    WorkSetConst PL_TMP2, 0
.Lmte\@:
    MsgWinCloseAll
    .endm
    .macro pl_CheckLearnedTutorMove var
    WorkSet \var, PL_TMP2
    .endm

// ---- PearlB2's extension command (notes/EXT_COMMAND.md): Black 2's command 0x15F (s015F_Nop, used by no Black 2
// script) is PearlB2's dispatcher (decomp src/pearlb2/ext_cmd_itcm.c): a sub-command byte, then its arguments.
// Sub-commands 0x00-0x1F the Pokétch, 0x20-0x3F the Underground, 0x40-0x5F Pal Park.
    .macro pl_ext sub
    FieldCommand 351
    .byte \sub
    .endm

// ---- the Pokétch (notes/POKETCH.md; decomp src/pearlb2/poketch_itcm.c PearlB2_Ext_Poketch) ----------------------
    .macro pl_EnablePoketch                // 0x131 (pokediamond GivePoketch): given; the bottom screen fades to it
    pl_ext 0x00
    .endm
    .macro pl_CheckPoketchEnabled var      // 0x132 (CheckPoketch): var = 1 when given
    pl_ext 0x01
    .2byte \var
    .endm
    .macro pl_RegisterPoketchApp app       // 0x133 (UnlockPoketchApp): app = a number or a var (Pearl's VarGet)
    pl_ext 0x02
    .2byte \app
    .endm
    .macro pl_CheckPoketchAppRegistered app, var   // 0x134 (CheckPoketchApp): var = 1 when registered
    pl_ext 0x03
    .2byte \app
    .2byte \var
    .endm
    .macro pl_HidePoketch                  // 0x265: Pearl's flag 0x97C set (the Pokétch not shown from the next start)
    pl_ext 0x04
    .endm
    .macro pl_ShowPoketch                  // 0x266: flag 0x97C cleared
    pl_ext 0x05
    .endm
// ---- Chapter 9b (2026-10-26)
    .macro pl_GetSpiritombCounter var          // 0x214 GetSpiritombTalkCounter (people talked to in Pearl's multiplayer
    WorkSet \var, PVAR_UG_HIDEAWAY_BATTLES     // Underground): the Hideaways' wild battles here (underground_itcm.c;
    .endm                                      // the lead 2026-10-26: 32 Hideaway battles wake the Hallowed Tower)
    .macro pl_ClearSpiritombCounter            // 0x26F ResetSpiritombTalkCounter
    WorkSetConst PVAR_UG_HIDEAWAY_BATTLES, 0
    .endm
    .macro pl_GetPartyMonLevel var, slot       // 0x278 (pokediamond ScrCmd_GetPartyMonLevel): 0 for an Egg
    WorkSetConst \var, 0
    PokePartyIsEgg PL_TMP, \slot
    WorkCmpConst PL_TMP, 0
    VMJumpIf CMP_NE, .Lpgml\@
    PokePartyGetParam \var, \slot, 158         // PKM_PARAM_LEVEL
.Lpgml\@:
    .endm
    .macro pl_GetDailyRandomLevel var          // 0x277: Pearl's daily level 2-99 (pokeplatinum SystemVars_InitDailyRandomLevel:
    RTCGetDate \var, PL_TMP                    // a random one each day, kept in Pearl's save); here a level 2-99 from
    WorkMul \var, 31                           // the date (each date its own): ((month * 31 + day) * 53 + 17) % 98 + 2
    WorkAdd \var, PL_TMP
    WorkMul \var, 53
    WorkAdd \var, 17
    WorkMod \var, 98
    WorkAdd \var, 2
    .endm
// The Trophy Garden's daily Pokémon (Mr. Backlot, the Pokémon Mansion): Pearl's save keeps two slots (pokeplatinum
// special_encounter.c trophyGarden, trophy_garden_daily_encounters.c); here the species in PVAR_TROPHY_GARDEN_1/2.
// The 16 are Pearl's encdata_ex member 8, in its order (read from the dump). The wild side (grass slots 6 and 7 of the
// Trophy Garden become slots 1 and 2 with the National Pokédex: pokeplatinum wild_encounters.c
// WildEncounters_ReplaceTrophyGardenEncounters) is the encounter code's (STORY_HANDOFFS 9b).
    .macro pl_tg_pick index, species
    WorkCmpConst PL_TMP, \index
    VMJumpIf CMP_NE, .Lptgp\@
    WorkSetConst PL_TMP2, \species
.Lptgp\@:
    .endm
    .macro pl_AddTrophyGardenMon               // 0x1EC AddTrophyGardenMon: one of the 16 at random, not one of the two
.Lptga\@:                                      // there now; slot 1 moves to slot 2, the new one is slot 1
    Random PL_TMP, 16
    pl_tg_pick 0, 133                          // Eevee
    pl_tg_pick 1, 438                          // Bonsly
    pl_tg_pick 2, 440                          // Happiny
    pl_tg_pick 3, 52                           // Meowth
    pl_tg_pick 4, 173                          // Cleffa
    pl_tg_pick 5, 35                           // Clefairy
    pl_tg_pick 6, 174                          // Igglybuff
    pl_tg_pick 7, 311                          // Plusle
    pl_tg_pick 8, 39                           // Jigglypuff
    pl_tg_pick 9, 137                          // Porygon
    pl_tg_pick 10, 351                         // Castform
    pl_tg_pick 11, 312                         // Minun
    pl_tg_pick 12, 439                         // Mime Jr.
    pl_tg_pick 13, 183                         // Marill
    pl_tg_pick 14, 113                         // Chansey
    pl_tg_pick 15, 298                         // Azurill
    WorkCmpWork PL_TMP2, PVAR_TROPHY_GARDEN_1
    VMJumpIf CMP_EQ, .Lptga\@
    WorkCmpWork PL_TMP2, PVAR_TROPHY_GARDEN_2
    VMJumpIf CMP_EQ, .Lptga\@
    WorkSet PVAR_TROPHY_GARDEN_2, PVAR_TROPHY_GARDEN_1
    WorkSet PVAR_TROPHY_GARDEN_1, PL_TMP2
    .endm
    .macro pl_GetTrophyGardenSlot1Species var  // 0x1ED: slot 1's species
    WorkSet \var, PVAR_TROPHY_GARDEN_1
    .endm

// ---- Pal Park (notes/PAL_PARK_MIGRATION.md; decomp src/pearlb2/resident/palpark.c PearlB2_Ext_PalPark): sub-commands
// 0x40-0x45 of PearlB2's extension command 0x15F (pl_ext, notes/EXT_COMMAND.md). A value may be a var.
    .macro pl_GetGBACartridgeVersion var   // 0x26E: the GBA game in slot 2, 0 none, 1 Sapphire, 2 Ruby, 3 Emerald,
    pl_ext 0x40                            // 4 FireRed, 5 LeafGreen (never one on a DSi or 3DS)
    .2byte \var
    .byte 0xff
    .endm
    .macro pl_GetGBACartridgeAndName var, word   // the same, and its player's name in word buffer `word`
    pl_ext 0x40
    .2byte \var
    .byte \word
    .endm
    .macro pl_PalParkMigrate var           // the migration screen (overlay 372): var = 6 when six came, else 0
    pl_ext 0x41
    .2byte \var
    .endm
    .macro pl_CheckHasEnoughMonForCatchingShow var   // 0x254: var = 1 when six are stocked
    pl_ext 0x42
    .2byte \var
    .endm
    .macro pl_SetClearInCatchingShowFlag value   // 0x253: 0 the show starts, 1 it ends (the time points)
    pl_ext 0x43
    .2byte \value
    .endm
    .macro pl_MoveCatchingShowMonsToPCBoxes     // 0x255: the six to the PC (met in Pal Park, in Park Balls)
    pl_ext 0x44
    .endm
    .macro pl_CalcCatchingShowPoints kind, var  // 0x256: kind 0 catching, 1 time, 2 type, 3 total
    pl_ext 0x45
    .2byte \kind
    .2byte \var
    .endm
