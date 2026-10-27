// MAP_IRON_ISLAND_EXTERIOR: Pearl script file 316, text bank 257. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P316_S1
    ScriptEntry P316_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P316_S1:
P316_000A:
    pl_SetFlag PFLAG_09DA
    pl_End

P316_S2:
P316_0010:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerDir PVAR_8004
    pl_FacePlayer
    pl_msg_talk 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P316_003A
    pl_GoTo P316_006D

P316_003A:
    pl_msg_talk 1
    pl_CloseMessage
    pl_Call P316_0078
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P316_0092
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, P316_00AC
    pl_BoatCutscene 0  // Pearl ShipAnimation 0, 2, 33, 44, 750: Black 2's boat demo
    RTReserveScript 25  // PearlArrive there
    pl_Warp 16, 44, 750, 2  // Pearl map 33 (MAP_CANALAVE)
    pl_ReleaseAll
    pl_End

P316_006D:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P316_0078:
    pl_ApplyMovement 0, P316_00C8
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement 0, P316_00D4
    pl_WaitMovement
    pl_Return

P316_0092:
    pl_ApplyMovement PL_PLAYER, P316_00DC
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P316_00D4
    pl_WaitMovement
    pl_Return

P316_00AC:
    pl_ApplyMovement PL_PLAYER, P316_00EC
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P316_00D4
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P316_00C8:
    Move 2, 1  // FACE_WEST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P316_00D4:
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P316_00DC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 2, 1  // FACE_WEST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P316_00EC:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 64, 1  // DELAY_15
    MoveEnd

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
