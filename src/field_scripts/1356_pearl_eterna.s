// MAP_ETERNA: Pearl script file 69, text bank 78. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-23: Pearl's; no warp continuations; 24: PearlArrive; 49: Pearl 2027, 92: Pearl 10000
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P69_S1
    ScriptEntry P69_S2
    ScriptEntry P69_S3
    ScriptEntry P69_S4
    ScriptEntry P69_S5
    ScriptEntry P69_S6
    ScriptEntry P69_S7
    ScriptEntry P69_S8
    ScriptEntry P69_S9
    ScriptEntry P69_S10
    ScriptEntry P69_S11
    ScriptEntry P69_S12
    ScriptEntry P69_S13
    ScriptEntry P69_S14
    ScriptEntry P69_S15
    ScriptEntry P69_S16
    ScriptEntry P69_S17
    ScriptEntry P69_S18
    ScriptEntry P69_S19
    ScriptEntry P69_S20
    ScriptEntry P69_S21
    ScriptEntry P69_S22
    ScriptEntry P69_S23
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
    ScriptEntry PearlProxy_2027
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10000
    ScriptEntriesEnd

P69_S21:
P69_005E:
    pl_CheckItem 450, 1, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P69_0090
    pl_CheckItem 428, 1, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P69_0090
    pl_SetVarFromValue PVAR_4114, 0
    pl_End

P69_0090:
    pl_SetVarFromValue PVAR_4114, 1
    pl_End

P69_S5:
P69_0098:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S7:
P69_00AB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S6:
P69_00BE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0081
    pl_GoToIf 1, P69_00DC
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_00DC:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S8:
P69_00E7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0081
    pl_GoToIf 1, P69_0105
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_0105:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S12:
P69_0110:
    pl_sign 21, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P69_S13:
P69_0127:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 22, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P69_S14:
P69_013C:
    pl_sign 23, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P69_S15:
P69_0153:
    pl_sign 24, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P69_S16:
P69_016A:
    pl_sign 25, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P69_S17:
P69_0181:
    pl_sign 26, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P69_S1:
P69_0198:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 523
    pl_GoToIf 1, P69_01C9
    pl_CompareVarToValue PVAR_8005, 524
    pl_GoToIf 1, P69_01D9
    pl_CompareVarToValue PVAR_8005, 525
    pl_GoToIf 1, P69_01E9
    pl_End

P69_01C9:
    pl_SetObjectEventPosLater 0, 12, 312, 7, 523, 2  // SetObjectEventPos 12 (the live actor; and where AddObject puts it)
    pl_GoTo P69_01F9

P69_01D9:
    pl_SetObjectEventPosLater 0, 12, 312, 7, 524, 2  // SetObjectEventPos 12 (the live actor; and where AddObject puts it)
    pl_GoTo P69_01F9

P69_01E9:
    pl_SetObjectEventPosLater 0, 12, 312, 7, 525, 2  // SetObjectEventPos 12 (the live actor; and where AddObject puts it)
    pl_GoTo P69_01F9

P69_01F9:
    pl_ClearFlag PFLAG_019E
    pl_AddObjectAt 12, 0, 2  // at its SetObjectEventPos
    pl_ApplyMovement 12, P69_02C0
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 12, P69_02D0
    pl_WaitMovement
    pl_msg_sys 1
    pl_SetVarFromValue PVAR_8004, 420  // Pearl item 420 (HM01) = HM01 Cut
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 523
    pl_GoToIf 1, P69_0264
    pl_CompareVarToValue PVAR_8005, 524
    pl_GoToIf 1, P69_027E
    pl_CompareVarToValue PVAR_8005, 525
    pl_GoToIf 1, P69_0298
    pl_End

P69_0264:
    pl_ApplyMovement 12, P69_02E0
    pl_ApplyMovement PL_PLAYER, P69_0300
    pl_WaitMovement
    pl_GoTo P69_02B2

P69_027E:
    pl_ApplyMovement 12, P69_02E0
    pl_ApplyMovement PL_PLAYER, P69_0300
    pl_WaitMovement
    pl_GoTo P69_02B2

P69_0298:
    pl_ApplyMovement 12, P69_02F0
    pl_ApplyMovement PL_PLAYER, P69_0314
    pl_WaitMovement
    pl_GoTo P69_02B2

P69_02B2:
    pl_RemoveObject 12, PFLAG_019E
    pl_SetVarFromValue PVAR_407A, 1
    pl_ReleaseAll
    pl_End

P69_S2:
P69_0328:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S3:
P69_033B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S4:
P69_034E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S9:
P69_0361:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S10:
P69_0374:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S11:
P69_0387:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S18:
P69_039A:
    WorkSetConst PVAR_800C, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_CompareVarToValue PVAR_800C, 10
    pl_GoToIf 1, P69_03BC
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 28
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_03BC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S19:
P69_03CD:
    pl_CompareVarToValue PVAR_4114, 0
    pl_GoToIf 1, P69_03ED
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_03ED:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P69_S20:
P69_0400:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 303
    pl_CallIf 1, P69_04A7
    pl_CompareVarToValue PVAR_8004, 304
    pl_CallIf 1, P69_04B3
    pl_CompareVarToValue PVAR_8004, 305
    pl_CallIf 1, P69_04BF
    pl_CompareVarToValue PVAR_8004, 306
    pl_CallIf 1, P69_04CB
    pl_CompareVarToValue PVAR_8004, 307
    pl_CallIf 1, P69_04D7
    pl_ApplyMovement PL_PLAYER, P69_05B0
    pl_WaitMovement
    pl_msg_sys 15
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8004, 303
    pl_CallIf 1, P69_04E3
    pl_CompareVarToValue PVAR_8004, 304
    pl_CallIf 1, P69_04E5
    pl_CompareVarToValue PVAR_8004, 305
    pl_CallIf 1, P69_04F1
    pl_CompareVarToValue PVAR_8004, 306
    pl_CallIf 1, P69_04FD
    pl_CompareVarToValue PVAR_8004, 307
    pl_CallIf 1, P69_0509
    pl_ApplyMovement PL_PLAYER, P69_05B8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P69_04A7:
    pl_ApplyMovement 28, P69_0518
    pl_WaitMovement
    pl_Return

P69_04B3:
    pl_ApplyMovement 28, P69_0528
    pl_WaitMovement
    pl_Return

P69_04BF:
    pl_ApplyMovement 28, P69_053C
    pl_WaitMovement
    pl_Return

P69_04CB:
    pl_ApplyMovement 28, P69_0550
    pl_WaitMovement
    pl_Return

P69_04D7:
    pl_ApplyMovement 28, P69_0564
    pl_WaitMovement
    pl_Return

P69_04E3:
    pl_Return

P69_04E5:
    pl_ApplyMovement 28, P69_0580
    pl_WaitMovement
    pl_Return

P69_04F1:
    pl_ApplyMovement 28, P69_058C
    pl_WaitMovement
    pl_Return

P69_04FD:
    pl_ApplyMovement 28, P69_0598
    pl_WaitMovement
    pl_Return

P69_0509:
    pl_ApplyMovement 28, P69_05A4
    pl_WaitMovement
    pl_Return

P69_S22:
P69_05C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0082
    pl_GoToIf 0, P69_05F5
    pl_CompareVarToValue PVAR_408C, 1
    pl_GoToIf 4, P69_05F5
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 30, P69_06E8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P69_05F5:
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 30, P69_06E8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P69_S23:
P69_060A:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 532
    pl_CallIf 1, P69_0673
    pl_CompareVarToValue PVAR_8005, 533
    pl_CallIf 1, P69_067F
    pl_CompareVarToValue PVAR_8005, 534
    pl_CallIf 1, P69_068B
    pl_ApplyMovement PL_PLAYER, P69_06E0
    pl_WaitMovement
    pl_msg_sys 18
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8005, 532
    pl_CallIf 1, P69_0697
    pl_CompareVarToValue PVAR_8005, 533
    pl_CallIf 1, P69_06AB
    pl_CompareVarToValue PVAR_8005, 534
    pl_CallIf 1, P69_06BF
    pl_ReleaseAll
    pl_End

P69_0673:
    pl_ApplyMovement 30, P69_06F0
    pl_WaitMovement
    pl_Return

P69_067F:
    pl_ApplyMovement 30, P69_06FC
    pl_WaitMovement
    pl_Return

P69_068B:
    pl_ApplyMovement 30, P69_070C
    pl_WaitMovement
    pl_Return

P69_0697:
    pl_ApplyMovement 30, P69_071C
    pl_ApplyMovement PL_PLAYER, P69_06D4
    pl_WaitMovement
    pl_Return

P69_06AB:
    pl_ApplyMovement 30, P69_072C
    pl_ApplyMovement PL_PLAYER, P69_06D4
    pl_WaitMovement
    pl_Return

P69_06BF:
    pl_ApplyMovement 30, P69_073C
    pl_ApplyMovement PL_PLAYER, P69_06D4
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P69_02C0:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 14, 6  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P69_02D0:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 63, 2  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P69_02E0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 5  // WALK_NORMAL_WEST
    Move 13, 8  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P69_02F0:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 5  // WALK_NORMAL_WEST
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P69_0300:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P69_0314:
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P69_0518:
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 62, 1  // DELAY_4
    MoveEnd

    .balign 4, 0
P69_0528:
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 62, 1  // DELAY_4
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P69_053C:
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 62, 1  // DELAY_4
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P69_0550:
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 62, 1  // DELAY_4
    Move 15, 3  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P69_0564:
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 62, 1  // DELAY_4
    Move 15, 4  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P69_0580:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P69_058C:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P69_0598:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P69_05A4:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P69_05B0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P69_05B8:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P69_06D4:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P69_06E0:
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P69_06E8:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P69_06F0:
    Move 1, 1  // FACE_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P69_06FC:
    Move 1, 1  // FACE_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P69_070C:
    Move 1, 1  // FACE_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P69_071C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P69_072C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P69_073C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

PearlProxy_2027:                  // Pearl global script 2027 (run by this zone's events)
    VMCall T205_28_S28
    VMHalt

PearlProxy_10000:                  // Pearl global script 10000 (run by this zone's events)
    VMCall T375_1_S1
    VMHalt

// ---- Pearl global script 205:45 (a subroutine here)
C205_45_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_03B2
    VMReturn  // End: the sub-script ends

C205_45_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_45_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_45_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_45_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

C205_45_S45:
C205_45_09B7:
    pl_Call C205_45_09C1
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_45_09C1:
    pl_Call C205_45_0336
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, C205_45_09F4
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 5, C205_45_0A05
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 28
    pl_GoTo C205_45_0A2B

C205_45_0A05:
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A1D
    pl_BufferItemName 0, PVAR_8004
    pl_GoTo C205_45_0A22

C205_45_0A1D:
    pl_BufferItemName 0, PVAR_8004  // GetItemNamePlural

C205_45_0A22:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 25
    pl_GoTo C205_45_0A2B

C205_45_0A2B:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_45_1330
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A5B
    pl_BufferItemName 1, PVAR_8004
    pl_GoTo C205_45_0A60

C205_45_0A5B:
    pl_BufferItemName 1, PVAR_8004  // GetItemNamePlural

C205_45_0A60:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_0AE7
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_0AD6
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_0B2B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_0B1A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_0B3C
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_0AF8
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_0B09
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_0B4D
    VMReturn  // End: the sub-script ends

C205_45_0AD6:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AE7:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AF8:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B09:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B1A:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B2B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B3C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B4D:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B5E:
    pl_Return

C205_45_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_45_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_45_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_45_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_45_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_45_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_45_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_45_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_45_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_45_13D8
    pl_Return

C205_45_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_45_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:28 (a subroutine here)
T205_28_S28:
T205_28_1222:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 40  // Pearl bank 199 line 67
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 375:1 (a subroutine here)
T375_1_S1:
T375_1_0042:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    PokePartyHasMoveAny PVAR_800C, 15  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_1_008E
    pl_CheckBadgeAcquired 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_1_008E
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 41  // Pearl bank 334 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_1_009D
    pl_CloseMessage
    pl_GoTo T375_1_055B

T375_1_008E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 42  // Pearl bank 334 line 2
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_1_055B

T375_1_009D:
    PokePartyHasMoveAny PVAR_800C, 15  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_talk 43  // Pearl bank 334 line 1
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 0: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 7, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 65  // GetCurrentMapID: Pearl map 65
// CreateJournalEvent 19, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)

T375_1_00D7:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, T375_1_00D7
    pl_GoTo T375_1_055B

T375_1_055B:
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
