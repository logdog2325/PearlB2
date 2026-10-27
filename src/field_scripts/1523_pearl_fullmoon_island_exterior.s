// MAP_FULLMOON_ISLAND_EXTERIOR: Pearl script file 273, text bank 242. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P273_S1
    ScriptEntry P273_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P273_S1:
P273_000A:
    pl_SetFlag PFLAG_09D0
// SetHiddenLocation 0, 1: the Town Map's hidden island (not drawn yet)
    pl_End

P273_S2:
P273_0015:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerDir PVAR_8004
    pl_CheckItem 453, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P273_0052
    pl_msg_talk 1
    pl_ShowYesNoMenu PVAR_800C
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P273_005D
    pl_GoTo P273_0098

P273_0052:
    pl_msg_talk 0
    pl_CloseMessage
    pl_GoTo P273_005D

P273_005D:
    pl_Call P273_00A3
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P273_00BD
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, P273_00D7
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P273_00F1
    pl_BoatCutscene 0  // Pearl ShipAnimation 0, 2, 33, 44, 750: Black 2's boat demo
    RTReserveScript 25  // PearlArrive there
    pl_Warp 16, 44, 750, 2  // Pearl map 33 (MAP_CANALAVE)
    pl_ReleaseAll
    pl_End

P273_0098:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P273_00A3:
    pl_ApplyMovement 0, P273_010C
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement 0, P273_0118
    pl_WaitMovement
    pl_Return

P273_00BD:
    pl_ApplyMovement PL_PLAYER, P273_0120
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P273_0118
    pl_WaitMovement
    pl_Return

P273_00D7:
    pl_ApplyMovement PL_PLAYER, P273_0130
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P273_0118
    pl_WaitMovement
    pl_Return

P273_00F1:
    pl_ApplyMovement PL_PLAYER, P273_013C
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P273_0118
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P273_010C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P273_0118:
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P273_0120:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 2  // WALK_NORMAL_EAST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P273_0130:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P273_013C:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
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
