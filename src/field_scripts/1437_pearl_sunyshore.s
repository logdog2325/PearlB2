// MAP_SUNYSHORE: Pearl script file 150, text bank 153. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-19: Pearl's; 20: after a Warp; 21: PearlArrive; 49: Pearl 2027, 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P150_S1
    ScriptEntry P150_S2
    ScriptEntry P150_S3
    ScriptEntry P150_S4
    ScriptEntry P150_S5
    ScriptEntry P150_S6
    ScriptEntry P150_S7
    ScriptEntry P150_S8
    ScriptEntry P150_S9
    ScriptEntry P150_S10
    ScriptEntry P150_S11
    ScriptEntry P150_S12
    ScriptEntry P150_S13
    ScriptEntry P150_S14
    ScriptEntry P150_S15
    ScriptEntry P150_S16
    ScriptEntry P150_S17
    ScriptEntry P150_S18
    ScriptEntry P150_S19
    ScriptEntry W166_0082_S
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
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
    ScriptEntry PearlProxy_10003
    ScriptEntriesEnd

P150_S19:
P150_004E:
    pl_CompareVarToValue PVAR_407E, 0
    pl_GoToIf 1, P150_005D
    pl_End

P150_005D:
    pl_SetObjectEventPos 10, 841, 790, 1, 1  // object 18
// SetObjectEventMovementType 18, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 10, 841, 790, 2, 1  // SetObjectEventDir 18 (at the place SetObjectEventPos just gave)
    pl_End

P150_S8:
P150_0073:
    pl_LockAll
    pl_SetVarFromValue PVAR_407E, 2
    pl_ApplyMovement 9, P150_0170
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 853
    pl_GoToIf 1, P150_00CE
    pl_CompareVarToValue PVAR_8004, 854
    pl_GoToIf 1, P150_00DE
    pl_CompareVarToValue PVAR_8004, 855
    pl_GoToIf 1, P150_00EE
    pl_CompareVarToValue PVAR_8004, 856
    pl_GoToIf 1, P150_00FE
    pl_CompareVarToValue PVAR_8004, 857
    pl_GoToIf 1, P150_010E
    pl_End

P150_00CE:
    pl_ApplyMovement 9, P150_017C
    pl_WaitMovement
    pl_GoTo P150_011E

P150_00DE:
    pl_ApplyMovement 9, P150_0188
    pl_WaitMovement
    pl_GoTo P150_011E

P150_00EE:
    pl_ApplyMovement 9, P150_0194
    pl_WaitMovement
    pl_GoTo P150_011E

P150_00FE:
    pl_ApplyMovement 9, P150_01A0
    pl_WaitMovement
    pl_GoTo P150_011E

P150_010E:
    pl_ApplyMovement 9, P150_01AC
    pl_WaitMovement
    pl_GoTo P150_011E

P150_011E:
    pl_SetFlag PFLAG_00B5
    pl_msg_sys 4
    pl_CheckBadgeAcquired 7, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P150_0162
    pl_Call P150_0146
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_0146:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6
    pl_SetVarFromValue PVAR_8004, 424  // Pearl item 426 (HM07) = HM05 Waterfall
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_009A
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7
    pl_Return

P150_0162:
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S9:
P150_01B4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_009A
    pl_GoToIf 1, P150_01F6
    pl_msg_talk 8
    pl_CheckBadgeAcquired 7, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P150_01EB
    pl_Call P150_0146
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_01EB:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_01F6:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S1:
P150_0201:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 790
    pl_GoToIf 1, P150_0225
    pl_CompareVarToValue PVAR_8005, 791
    pl_GoToIf 1, P150_0235
    pl_End

P150_0225:
    pl_ApplyMovement 18, P150_02AC
    pl_WaitMovement
    pl_GoTo P150_0245

P150_0235:
    pl_ApplyMovement 18, P150_02C0
    pl_WaitMovement
    pl_GoTo P150_0245

P150_0245:
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 18, P150_02D8
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 18, P150_02E0
    pl_WaitMovement
    pl_msg_sys 1
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 18, P150_02E8
    pl_WaitMovement
    pl_RemoveObject 18, PFLAG_0257
    pl_WaitTime 1, PVAR_800C
    pl_SetObjectEventPosLater 0, 18, 845, 5, 748, 1  // SetObjectEventPos 18 (the live actor; and where AddObject puts it)
// SetObjectEventMovementType 18, 15: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_ApplyMovement 18, .Lface291  // SetObjectEventDir 18: the live actor turns
    pl_WaitMovement
    VMJump .Lface291_end
    .balign 4, 0
.Lface291:
        Move 1, 1
        MoveEnd
.Lface291_end:
    pl_ClearFlag PFLAG_0257
    pl_AddObjectAt 18, 0, 1  // at its SetObjectEventPos
    pl_SetVarFromValue PVAR_407E, 1
    pl_ReleaseAll
    pl_End

P150_S2:
P150_02F0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S3:
P150_0303:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S4:
P150_0316:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S5:
P150_0329:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S6:
P150_033C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S7:
P150_034F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_S10:
P150_0362:
    pl_sign 17, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P150_S11:
P150_0379:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 18, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P150_S12:
P150_038E:
    pl_sign 19, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P150_S13:
P150_03A5:
    pl_sign 20, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P150_S14:
P150_03BC:
    pl_sign 21, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P150_S15:
P150_03D3:
    pl_sign 22, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P150_S16:
P150_03EA:
    pl_sign 23, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P150_S17:
P150_0401:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    RTCGetWeekDay PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P150_0476
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P150_0480
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P150_048A
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P150_0494
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P150_049E
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, P150_04A8
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, P150_04B2
    pl_End

P150_0476:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 0: not translated yet
    pl_GoTo P150_04BC

P150_0480:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 1: not translated yet
    pl_GoTo P150_04BC

P150_048A:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 2: not translated yet
    pl_GoTo P150_04BC

P150_0494:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 3: not translated yet
    pl_GoTo P150_04BC

P150_049E:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 4: not translated yet
    pl_GoTo P150_04BC

P150_04A8:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 5: not translated yet
    pl_GoTo P150_04BC

P150_04B2:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 6: not translated yet
    pl_GoTo P150_04BC

P150_04BC:
    pl_ReleaseAll
    pl_End

P150_S18:
P150_04C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0162
    pl_GoToIf 1, P150_04DE
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P150_04DE:
    pl_msg_talk 3
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P150_0516
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P150_052E
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P150_0546
    pl_End

P150_0516:
    pl_ApplyMovement 18, P150_0568
    pl_ApplyMovement PL_PLAYER, P150_0584
    pl_WaitMovement
    pl_GoTo P150_055E

P150_052E:
    pl_ApplyMovement 18, P150_0578
    pl_ApplyMovement PL_PLAYER, P150_0590
    pl_WaitMovement
    pl_GoTo P150_055E

P150_0546:
    pl_ApplyMovement 18, P150_0578
    pl_ApplyMovement PL_PLAYER, P150_0584
    pl_WaitMovement
    pl_GoTo P150_055E

P150_055E:
    pl_RemoveObject 18, PFLAG_0257
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P150_0170:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P150_017C:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P150_0188:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P150_0194:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P150_01A0:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P150_01AC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P150_02AC:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 14, 5  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P150_02C0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 3  // WALK_NORMAL_WEST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 14, 5  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P150_02D8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P150_02E0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P150_02E8:
    Move 15, 9  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P150_0568:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 8  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P150_0578:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 9  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P150_0584:
    Move 63, 1  // DELAY_8
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P150_0590:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

// ---- continuation 20: after the Warp at 166:0082 (MAP_SUNYSHORE_VISTA_LIGHTHOUSE_ELEVATOR)
W166_0082_S:
W166_0082_008E:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlProxy_2027:                  // Pearl global script 2027 (run by this zone's events)
    VMCall T205_28_S28
    VMHalt

PearlProxy_10003:                  // Pearl global script 10003 (run by this zone's events)
    VMCall C375_4_S4
    VMHalt

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 1  // this floor's floors above (an elevator reads it)
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
    pl_msg_sys 24  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 28
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
    pl_msg_sys 26  // Pearl bank 199 line 25
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
    pl_msg_sys 27  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:20 (a subroutine here)
C205_20_S20:
C205_20_0F28:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 37
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:28 (a subroutine here)
T205_28_S28:
T205_28_1222:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 36  // Pearl bank 199 line 67
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 375:4 (a subroutine here)
C375_4_S4:
C375_4_0324:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, C375_4_037F
    pl_CheckBadgeAcquired 6, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_037F
    FlagGet PL_FOLLOW_FLAG, PVAR_800C  // CheckHasPartner: 1 while a partner follows
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C375_4_038E
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 40  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 2 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 890
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 772
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (890, 772) to (890, 776)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 890
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 776
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (890, 776) to (890, 772)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 53, 1
        Move 17, 2
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 52, 1
        Move 16, 2
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 150  // GetCurrentMapID: Pearl map 150
// CreateJournalEvent 26, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo C375_4_055F

C375_4_055F:
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
