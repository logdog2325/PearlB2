// MAP_BATTLE_PARK: Pearl script file 355, text bank 281. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-12: Pearl's; no warp continuations; 13: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P355_S1
    ScriptEntry P355_S2
    ScriptEntry P355_S3
    ScriptEntry P355_S4
    ScriptEntry P355_S5
    ScriptEntry P355_S6
    ScriptEntry P355_S7
    ScriptEntry P355_S8
    ScriptEntry P355_S9
    ScriptEntry P355_S10
    ScriptEntry P355_S11
    ScriptEntry P355_S12
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P355_S1:
P355_0032:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 23
    pl_CallIf 1, P355_01A8
    pl_CompareVarToValue PVAR_8004, 24
    pl_CallIf 1, P355_01BA
    pl_CompareVarToValue PVAR_8004, 25
    pl_CallIf 1, P355_01CC
    pl_CompareVarToValue PVAR_8004, 26
    pl_CallIf 1, P355_01DE
    pl_ClearFlag PFLAG_0294
    pl_AddObjectAt 11, 0, 0  // at its SetObjectEventPos
// LockObject 11: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 11, P355_02C8
    pl_ApplyMovement PL_PLAYER, P355_0290
    pl_WaitMovement
    pl_PlaySE SEQ_SE_WALL_HIT  // Pearl SEQ_SE_DP_WALL_HIT2
    pl_BufferPlayerName 1
    pl_msg_sys 0
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    pl_ApplyMovement 11, P355_02D0
    pl_WaitMovement
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement 11, P355_02E0
    pl_WaitMovement
    pl_msg_sys 2
    pl_ApplyMovement 11, P355_02E8
    pl_WaitMovement
    pl_msg_sys 3
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 23
    pl_CallIf 1, P355_01F0
    pl_CompareVarToValue PVAR_8004, 24
    pl_CallIf 1, P355_0204
    pl_CompareVarToValue PVAR_8004, 25
    pl_CallIf 1, P355_0218
    pl_CompareVarToValue PVAR_8004, 26
    pl_CallIf 1, P355_022C
    pl_RemoveObject 11, PFLAG_0294
    pl_ClearFlag PFLAG_0295
    pl_AddObjectAt 12, 1, 0  // at its SetObjectEventPos
// LockObject 12: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 12, P355_02C8
    pl_ApplyMovement PL_PLAYER, P355_0290
    pl_WaitMovement
    pl_PlaySE SEQ_SE_WALL_HIT  // Pearl SEQ_SE_DP_WALL_HIT2
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 4
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    pl_CompareVarToValue PVAR_409E, 1
    pl_CallIf 0, P355_019E
    pl_CompareVarToValue PVAR_409E, 1
    pl_CallIf 4, P355_01A3
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 23
    pl_CallIf 1, P355_0240
    pl_CompareVarToValue PVAR_8004, 24
    pl_CallIf 1, P355_0254
    pl_CompareVarToValue PVAR_8004, 25
    pl_CallIf 1, P355_0268
    pl_CompareVarToValue PVAR_8004, 26
    pl_CallIf 1, P355_027C
    pl_RemoveObject 12, PFLAG_0295
    pl_SetVarFromValue PVAR_410E, 1
    pl_ReleaseAll
    pl_End

P355_019E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 5
    pl_Return

P355_01A3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6
    pl_Return

P355_01A8:
    pl_SetObjectEventPosLater 0, 11, 23, 1, 41, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 1, 12, 23, 1, 40, 0  // SetObjectEventPos 12 (the live actor; and where AddObject puts it)
    pl_Return

P355_01BA:
    pl_SetObjectEventPosLater 0, 11, 24, 1, 41, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 1, 12, 24, 1, 40, 0  // SetObjectEventPos 12 (the live actor; and where AddObject puts it)
    pl_Return

P355_01CC:
    pl_SetObjectEventPosLater 0, 11, 25, 1, 41, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 1, 12, 25, 1, 40, 0  // SetObjectEventPos 12 (the live actor; and where AddObject puts it)
    pl_Return

P355_01DE:
    pl_SetObjectEventPosLater 0, 11, 26, 1, 41, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 1, 12, 26, 1, 40, 0  // SetObjectEventPos 12 (the live actor; and where AddObject puts it)
    pl_Return

P355_01F0:
    pl_ApplyMovement 11, P355_02F0
    pl_ApplyMovement PL_PLAYER, P355_02A8
    pl_WaitMovement
    pl_Return

P355_0204:
    pl_ApplyMovement 11, P355_02F0
    pl_ApplyMovement PL_PLAYER, P355_02A8
    pl_WaitMovement
    pl_Return

P355_0218:
    pl_ApplyMovement 11, P355_02FC
    pl_ApplyMovement PL_PLAYER, P355_02B8
    pl_WaitMovement
    pl_Return

P355_022C:
    pl_ApplyMovement 11, P355_02FC
    pl_ApplyMovement PL_PLAYER, P355_02B8
    pl_WaitMovement
    pl_Return

P355_0240:
    pl_ApplyMovement 12, P355_02F0
    pl_ApplyMovement PL_PLAYER, P355_02A8
    pl_WaitMovement
    pl_Return

P355_0254:
    pl_ApplyMovement 12, P355_02F0
    pl_ApplyMovement PL_PLAYER, P355_02A8
    pl_WaitMovement
    pl_Return

P355_0268:
    pl_ApplyMovement 12, P355_02FC
    pl_ApplyMovement PL_PLAYER, P355_02B8
    pl_WaitMovement
    pl_Return

P355_027C:
    pl_ApplyMovement 12, P355_02FC
    pl_ApplyMovement PL_PLAYER, P355_02B8
    pl_WaitMovement
    pl_Return

P355_S2:
P355_0308:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S5:
P355_031B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S6:
P355_032C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S7:
P355_033D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S8:
P355_0350:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S9:
P355_0361:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S10:
P355_0374:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S11:
P355_0387:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S12:
P355_039A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P355_S3:
P355_03AD:
    pl_sign 7, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P355_S4:
P355_03C4:
    pl_sign 8, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P355_0290:
    Move 62, 7  // DELAY_4
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 71, 1  // LOCK_DIR
    Move 16, 1  // WALK_FAST_NORTH
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P355_02A8:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P355_02B8:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P355_02C8:
    Move 16, 8  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P355_02D0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P355_02E0:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P355_02E8:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P355_02F0:
    Move 19, 1  // WALK_FAST_EAST
    Move 16, 8  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P355_02FC:
    Move 18, 1  // WALK_FAST_WEST
    Move 16, 8  // WALK_FAST_NORTH
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
