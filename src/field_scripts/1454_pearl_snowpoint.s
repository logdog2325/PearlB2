// MAP_SNOWPOINT: Pearl script file 168, text bank 167. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-12: Pearl's; no warp continuations; 13: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P168_S1
    ScriptEntry P168_S2
    ScriptEntry P168_S3
    ScriptEntry P168_S4
    ScriptEntry P168_S5
    ScriptEntry P168_S6
    ScriptEntry P168_S7
    ScriptEntry P168_S8
    ScriptEntry P168_S9
    ScriptEntry P168_S10
    ScriptEntry P168_S11
    ScriptEntry P168_S12
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P168_S1:
P168_0032:
    pl_CompareVarToValue PVAR_407F, 1
    pl_GoToIf 4, P168_0041
    pl_End

P168_0041:
    pl_SetFlag PFLAG_0211
    pl_End

P168_S3:
P168_0047:
    pl_LockAll
    pl_ApplyMovement 6, P168_009C
    pl_WaitMovement
    pl_msg_sys 0
    pl_CloseMessage
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P168_0088
    pl_GoTo P168_0072

P168_0072:
    pl_ApplyMovement 6, P168_00A4
    pl_ApplyMovement PL_PLAYER, P168_00AC
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P168_0088:
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 0, P168_0072
    pl_GoTo P168_0111

P168_S2:
P168_00B4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P168_00DF
    pl_GoTo P168_00D4

P168_00D4:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_00DF:
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 0, P168_00D4
    pl_CompareVarToValue PVAR_407F, 0
    pl_GoToIf 1, P168_0102
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_0102:
    pl_msg_talk 0
    pl_CloseMessage
    pl_Call P168_011B
    pl_ReleaseAll
    pl_End

P168_0111:
    pl_Call P168_011B
    pl_ReleaseAll
    pl_End

P168_011B:
    pl_WaitTime 30, PVAR_800C
    pl_ClearFlag PFLAG_0211
    pl_AddObject 7
    pl_ApplyMovement 7, P168_016C
    pl_WaitMovement
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P168_0164
    pl_ApplyMovement 6, P168_015C
    pl_WaitMovement
    pl_SetVarFromValue PVAR_407F, 1
    pl_msg_sys 4
    pl_WaitButton
    pl_CloseMessage
    pl_Return

P168_S4:
P168_0174:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_S5:
P168_0187:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_S6:
P168_019A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_S7:
P168_01AD:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_S8:
P168_01C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_407F, 1
    pl_GoToIf 4, P168_01E0
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_01E0:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_S9:
P168_01EB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_S10:
P168_01FE:
    pl_sign 15, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P168_S11:
P168_0215:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 16, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P168_S12:
P168_022A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 0, P168_0260
    pl_msg_talk 10
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P168_0276
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P168_026B
    pl_End

P168_0260:
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_026B:
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P168_0276:
    pl_msg_talk 11
    pl_CloseMessage
    pl_Call P168_0295
    pl_Call P168_02AF
    pl_BoatCutscene 2  // Pearl ShipAnimation 2, 0, 188, 623, 434: Black 2's boat demo
    RTReserveScript 18  // PearlArrive there
    pl_Warp 448, 623, 434, 0  // Pearl map 188 (MAP_FIGHT_AREA)
    pl_ReleaseAll
    pl_End

P168_0295:
    pl_ApplyMovement 8, P168_02CC
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement 8, P168_02D8
    pl_WaitMovement
    pl_Return

P168_02AF:
    pl_ApplyMovement PL_PLAYER, P168_02E0
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P168_02D8
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P168_009C:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P168_00A4:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P168_00AC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P168_015C:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P168_0164:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P168_016C:
    Move 12, 7  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P168_02CC:
    Move 1, 1  // FACE_SOUTH
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P168_02D8:
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P168_02E0:
    Move 13, 1  // WALK_NORMAL_SOUTH
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
