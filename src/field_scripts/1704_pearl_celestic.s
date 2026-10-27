// MAP_CELESTIC: Pearl script file 1012, text bank 527. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-11: Pearl's; no warp continuations; 12: PearlArrive; 49: Pearl 2027
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1012_S1
    ScriptEntry P1012_S2
    ScriptEntry P1012_S3
    ScriptEntry P1012_S4
    ScriptEntry P1012_S5
    ScriptEntry P1012_S6
    ScriptEntry P1012_S7
    ScriptEntry P1012_S8
    ScriptEntry P1012_S9
    ScriptEntry P1012_S10
    ScriptEntry P1012_S11
    ScriptEntry PearlArrive
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_2027
    ScriptEntriesEnd

P1012_S1:
P1012_002E:
    pl_SetFlag PFLAG_0980
    pl_End

P1012_S4:
P1012_0034:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1012_006A
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1012_005F
    pl_End

P1012_005F:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1012_006A:
    pl_msg_talk 2
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_416, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1012_018D
    pl_msg_talk 4
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1012_00B8
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P1012_00E8
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P1012_0110
    pl_End

P1012_00B8:
    pl_ApplyMovement 2, P1012_0194
    pl_ApplyMovement PL_PLAYER, P1012_01DC
    pl_WaitMovement
    pl_Call P1012_0138
    pl_ApplyMovement 3, P1012_01B0
    pl_ApplyMovement PL_PLAYER, P1012_0200
    pl_WaitMovement
    pl_GoTo P1012_0162

P1012_00E8:
    pl_ApplyMovement 2, P1012_0194
    pl_ApplyMovement PL_PLAYER, P1012_01EC
    pl_WaitMovement
    pl_Call P1012_0138
    pl_ApplyMovement 3, P1012_01BC
    pl_WaitMovement
    pl_GoTo P1012_0162

P1012_0110:
    pl_ApplyMovement 2, P1012_01A0
    pl_ApplyMovement PL_PLAYER, P1012_01F8
    pl_WaitMovement
    pl_Call P1012_0138
    pl_ApplyMovement 3, P1012_01CC
    pl_WaitMovement
    pl_GoTo P1012_0162

P1012_0138:
    pl_RemoveObject 2, PFLAG_01CD
    pl_RemoveObject 3, PFLAG_01CA
    pl_SetObjectEventPosLater 0, 3, 466, 5, 531, 0  // SetObjectEventPos 3 (the live actor; and where AddObject puts it)
    pl_ApplyMovement 3, .Lface148  // SetObjectEventDir 3: the live actor turns
    pl_WaitMovement
    VMJump .Lface148_end
    .balign 4, 0
.Lface148:
        Move 0, 1
        MoveEnd
.Lface148_end:
// SetObjectEventMovementType 3, 14: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_ClearFlag PFLAG_01CA
    pl_AddObjectAt 3, 0, 0  // at its SetObjectEventPos
// LockObject 3: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_Return

P1012_0162:
    pl_msg_talk 5
    pl_BufferPlayerName 0
    pl_BufferItemName 1, 439
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_msg_talk 6
    pl_WaitFanfare
    pl_RemoveItem 439, 1, PVAR_800C
    pl_SetFlag PFLAG_00A6
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1012_018D:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P1012_S3:
P1012_0224:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P1012_025C
    pl_ApplyMovement 3, P1012_0254
    pl_WaitMovement
    pl_Call P1012_0242
    pl_ReleaseAll
    pl_End

P1012_0242:
    pl_SetVarFromValue PVAR_40F1, 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_WaitButton
    pl_CloseMessage
    pl_Return

P1012_S2:
P1012_0264:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A6
    pl_GoToIf 1, P1012_0281
    pl_Call P1012_0242
    pl_ReleaseAll
    pl_End

P1012_0281:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1012_S5:
P1012_028C:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P1012_02D8
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_msg_sys 9
    pl_CloseMessage
    pl_ApplyMovement 4, P1012_02EC
    pl_WaitMovement
    pl_msg_sys 10
    pl_CloseMessage
    pl_ApplyMovement 4, P1012_02F4
    pl_ApplyMovement PL_PLAYER, P1012_02E0
    pl_WaitMovement
    pl_RemoveObject 4, PFLAG_01DB
    pl_SetFlag PFLAG_00A5
    pl_SetVarFromValue PVAR_4074, 2
    pl_ReleaseAll
    pl_End

P1012_S6:
P1012_0300:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1012_S7:
P1012_0313:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1012_S8:
P1012_0326:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1012_S9:
P1012_0339:
    pl_sign 14, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P1012_S10:
P1012_0350:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1012_S11:
P1012_0361:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P1012_0194:
    Move 18, 3  // WALK_FAST_WEST
    Move 17, 9  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P1012_01A0:
    Move 17, 2  // WALK_FAST_SOUTH
    Move 18, 3  // WALK_FAST_WEST
    Move 17, 7  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P1012_01B0:
    Move 12, 8  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P1012_01BC:
    Move 12, 8  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P1012_01CC:
    Move 12, 8  // WALK_NORMAL_NORTH
    Move 14, 4  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P1012_01DC:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P1012_01EC:
    Move 63, 3  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P1012_01F8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P1012_0200:
    Move 63, 8  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P1012_0254:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P1012_025C:
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P1012_02D8:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P1012_02E0:
    Move 63, 3  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P1012_02EC:
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P1012_02F4:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

PearlProxy_2027:                  // Pearl global script 2027 (run by this zone's events)
    VMCall T205_28_S28
    VMHalt

// ---- Pearl global script 205:28 (a subroutine here)
T205_28_S28:
T205_28_1222:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 17  // Pearl bank 199 line 67
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
