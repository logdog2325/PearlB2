// MAP_VEILSTONE: Pearl script file 131, text bank 135. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-30: Pearl's; no warp continuations; 31: PearlArrive; 49: Pearl 2027, 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P131_S1
    ScriptEntry P131_S2
    ScriptEntry P131_S3
    ScriptEntry P131_S4
    ScriptEntry P131_S5
    ScriptEntry P131_S6
    ScriptEntry P131_S7
    ScriptEntry P131_S8
    ScriptEntry P131_S9
    ScriptEntry P131_S10
    ScriptEntry P131_S11
    ScriptEntry P131_S12
    ScriptEntry P131_S13
    ScriptEntry P131_S14
    ScriptEntry P131_S15
    ScriptEntry P131_S16
    ScriptEntry P131_S17
    ScriptEntry P131_S18
    ScriptEntry P131_S19
    ScriptEntry P131_S20
    ScriptEntry P131_S21
    ScriptEntry P131_S22
    ScriptEntry P131_S23
    ScriptEntry P131_S24
    ScriptEntry P131_S25
    ScriptEntry P131_S26
    ScriptEntry P131_S27
    ScriptEntry P131_S28
    ScriptEntry P131_S29
    ScriptEntry P131_S30
    ScriptEntry PearlArrive
    ScriptEntry PearlItemBall_23
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

P131_S1:
P131_007A:
    pl_CompareVarToValue PVAR_411A, 2
    pl_CallIf 4, P131_Zinit_00A7
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P131_00BD
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P131_00C5
    pl_End

P131_00A7:
    pl_SetObjectEventPosLater 0, 6, 696, 1, 596, 3  // SetObjectEventPos 6 (the live actor; and where AddObject puts it)
// SetObjectEventMovementType 6, 17: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_ApplyMovement 6, .Lfaceb5  // SetObjectEventDir 6: the live actor turns
    pl_WaitMovement
    VMJump .Lfaceb5_end
    .balign 4, 0
.Lfaceb5:
        Move 3, 1
        MoveEnd
.Lfaceb5_end:
    pl_Return

P131_00BD:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P131_00C5:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P131_S16:
P131_00CD:
    pl_LockAll
    pl_ApplyMovement 6, P131_0214
    pl_WaitMovement
    VMCall C205_41_S41  // CallCommonScript 2040 (Pearl file 205 script 41)
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 681
    pl_CallIf 1, P131_0193
    pl_CompareVarToValue PVAR_8004, 682
    pl_CallIf 1, P131_019F
    pl_CompareVarToValue PVAR_8004, 683
    pl_CallIf 1, P131_01AB
    pl_CompareVarToValue PVAR_8004, 684
    pl_CallIf 1, P131_01B7
    pl_GetPlayerGender PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P131_0183
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P131_018B
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 681
    pl_CallIf 1, P131_01C3
    pl_CompareVarToValue PVAR_8004, 682
    pl_CallIf 1, P131_01D7
    pl_CompareVarToValue PVAR_8004, 683
    pl_CallIf 1, P131_01EB
    pl_CompareVarToValue PVAR_8004, 684
    pl_CallIf 1, P131_01FF
    pl_RemoveObject 6, PFLAG_01C6
    VMCall C205_42_S42  // CallCommonScript 2041 (Pearl file 205 script 42)
    pl_SetVarFromValue PVAR_40F5, 1
    pl_ReleaseAll
    pl_End

P131_0183:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2
    pl_Return

P131_018B:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3
    pl_Return

P131_0193:
    pl_ApplyMovement 6, P131_0220
    pl_WaitMovement
    pl_Return

P131_019F:
    pl_ApplyMovement 6, P131_022C
    pl_WaitMovement
    pl_Return

P131_01AB:
    pl_ApplyMovement 6, P131_0234
    pl_WaitMovement
    pl_Return

P131_01B7:
    pl_ApplyMovement 6, P131_0240
    pl_WaitMovement
    pl_Return

P131_01C3:
    pl_ApplyMovement 6, P131_024C
    pl_ApplyMovement PL_PLAYER, P131_0264
    pl_WaitMovement
    pl_Return

P131_01D7:
    pl_ApplyMovement 6, P131_024C
    pl_ApplyMovement PL_PLAYER, P131_0264
    pl_WaitMovement
    pl_Return

P131_01EB:
    pl_ApplyMovement 6, P131_0258
    pl_ApplyMovement PL_PLAYER, P131_0274
    pl_WaitMovement
    pl_Return

P131_01FF:
    pl_ApplyMovement 6, P131_0258
    pl_ApplyMovement PL_PLAYER, P131_0274
    pl_WaitMovement
    pl_Return

P131_S17:
P131_0284:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerGender PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_GoToIf 1, P131_02AC
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P131_02DD
    pl_End

P131_02AC:
    pl_BufferPlayerName 0
    pl_msg_talk 12
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_02C9
    pl_GoTo P131_02D2

P131_02C9:
    pl_msg_talk 13
    pl_GoTo P131_030E

P131_02D2:
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_02DD:
    pl_BufferPlayerName 0
    pl_msg_talk 17
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_02FA
    pl_GoTo P131_0303

P131_02FA:
    pl_msg_talk 18
    pl_GoTo P131_030E

P131_0303:
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_030E:
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, P131_04E2
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P131_04F6
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P131_050A
    pl_Call P131_045C
// StartTagBattle PVAR_8004, 848, 849: the partner by Pearl's trainer number in the var
    WorkCmpConst PVAR_8004, 621
    VMJumpIf CMP_NE, .Ltag341_621
    pl_StartTagBattle PTRAINER_621, PTRAINER_848, PTRAINER_849
    VMJump .Ltag341_end
.Ltag341_621:
    WorkCmpConst PVAR_8004, 622
    VMJumpIf CMP_NE, .Ltag341_622
    pl_StartTagBattle PTRAINER_622, PTRAINER_848, PTRAINER_849
    VMJump .Ltag341_end
.Ltag341_622:
    WorkCmpConst PVAR_8004, 623
    VMJumpIf CMP_NE, .Ltag341_623
    pl_StartTagBattle PTRAINER_623, PTRAINER_848, PTRAINER_849
    VMJump .Ltag341_end
.Ltag341_623:
    WorkCmpConst PVAR_8004, 624
    VMJumpIf CMP_NE, .Ltag341_624
    pl_StartTagBattle PTRAINER_624, PTRAINER_848, PTRAINER_849
    VMJump .Ltag341_end
.Ltag341_624:
    WorkCmpConst PVAR_8004, 625
    VMJumpIf CMP_NE, .Ltag341_625
    pl_StartTagBattle PTRAINER_625, PTRAINER_848, PTRAINER_849
    VMJump .Ltag341_end
.Ltag341_625:
    pl_StartTagBattle PTRAINER_626, PTRAINER_848, PTRAINER_849
.Ltag341_end:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_05AE
    pl_msg_actor 9, 7
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 595
    pl_CallIf 1, P131_051E
    pl_CompareVarToValue PVAR_8005, 597
    pl_CallIf 1, P131_052A
    pl_msg_actor 10, 7
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 595
    pl_CallIf 1, P131_0536
    pl_CompareVarToValue PVAR_8005, 597
    pl_CallIf 1, P131_0542
    pl_RemoveObject 7, PFLAG_01DD
    pl_msg_actor 11, 20
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 595
    pl_CallIf 1, P131_054E
    pl_CompareVarToValue PVAR_8005, 597
    pl_CallIf 1, P131_055A
    pl_RemoveObject 20, PFLAG_01DD
    pl_GetPlayerGender PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P131_0566
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P131_056B
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 595
    pl_CallIf 1, P131_057A
    pl_CompareVarToValue PVAR_8005, 597
    pl_CallIf 1, P131_058E
    pl_WaitTime 10, PVAR_800C
    pl_BufferPlayerName 0
    pl_GetPlayerGender PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P131_0570
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P131_0575
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 6, P131_0634
    pl_ApplyMovement PL_PLAYER, P131_068C
    pl_WaitMovement
    pl_GoTo P131_05A2

P131_045C:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_047C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P131_04AE
    pl_End

P131_047C:
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_SetVarFromValue PVAR_8004, 625
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P131_04E0
    pl_SetVarFromValue PVAR_8004, 626
    pl_CompareVarToValue PVAR_800C, 393
    pl_GoToIf 1, P131_04E0
    pl_SetVarFromValue PVAR_8004, 624
    pl_Return

P131_04AE:
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_SetVarFromValue PVAR_8004, 622
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P131_04E0
    pl_SetVarFromValue PVAR_8004, 623
    pl_CompareVarToValue PVAR_800C, 393
    pl_GoToIf 1, P131_04E0
    pl_SetVarFromValue PVAR_8004, 621
    pl_Return

P131_04E0:
    pl_Return

P131_04E2:
    pl_ApplyMovement 6, P131_05B4
    pl_ApplyMovement PL_PLAYER, P131_0640
    pl_WaitMovement
    pl_Return

P131_04F6:
    pl_ApplyMovement 6, P131_05C0
    pl_ApplyMovement PL_PLAYER, P131_064C
    pl_WaitMovement
    pl_Return

P131_050A:
    pl_ApplyMovement 6, P131_05CC
    pl_ApplyMovement PL_PLAYER, P131_0654
    pl_WaitMovement
    pl_Return

P131_051E:
    pl_ApplyMovement 20, P131_0698
    pl_WaitMovement
    pl_Return

P131_052A:
    pl_ApplyMovement 7, P131_0698
    pl_WaitMovement
    pl_Return

P131_0536:
    pl_ApplyMovement 7, P131_06A0
    pl_WaitMovement
    pl_Return

P131_0542:
    pl_ApplyMovement 7, P131_06A0
    pl_WaitMovement
    pl_Return

P131_054E:
    pl_ApplyMovement 20, P131_06B0
    pl_WaitMovement
    pl_Return

P131_055A:
    pl_ApplyMovement 20, P131_06B0
    pl_WaitMovement
    pl_Return

P131_0566:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15
    pl_Return

P131_056B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20
    pl_Return

P131_0570:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 16
    pl_Return

P131_0575:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 21
    pl_Return

P131_057A:
    pl_ApplyMovement 6, P131_0624
    pl_ApplyMovement PL_PLAYER, P131_067C
    pl_WaitMovement
    pl_Return

P131_058E:
    pl_ApplyMovement 6, P131_062C
    pl_ApplyMovement PL_PLAYER, P131_0684
    pl_WaitMovement
    pl_Return

P131_05A2:
    pl_SetFlag PFLAG_0101
    pl_RemoveObject 6, PFLAG_01C6
    pl_ReleaseAll
    pl_End

P131_05AE:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P131_S2:
P131_06C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 25
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S3:
P131_06D3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 32
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S4:
P131_06E6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S5:
P131_06F9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S6:
P131_070C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S7:
P131_071F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 33
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S8:
P131_0732:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00CC
    pl_GoToIf 1, P131_0777
    pl_msg_talk 34
    pl_SetVarFromValue PVAR_8004, 390  // Pearl item 390 (TM63) = TM63 Embargo
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_0782
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_00CC
    pl_GoTo P131_0777

P131_0777:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 35
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_0782:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S9:
P131_078C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 30
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S10:
P131_079F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 31
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S11:
P131_07B2:
    pl_LockAll
    pl_ApplyMovement 7, P131_07EC
    pl_ApplyMovement PL_PLAYER, P131_07E4
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_ApplyMovement 7, P131_07F8
    pl_ApplyMovement PL_PLAYER, P131_0810
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P131_S12:
P131_0818:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 2, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P131_083E
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_083E:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S13:
P131_0849:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 2, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P131_086F
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_086F:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S14:
P131_087A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 22
    pl_CloseMessage
    pl_FacePlayer
    pl_ApplyMovement 24, P131_0938
    pl_WaitMovement
    pl_msg_talk 23
    pl_CloseMessage
    pl_ClearFlag PFLAG_04C8
    pl_AddObject 23
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_08D8
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P131_08F0
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P131_0918
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P131_0900
    pl_End

P131_08D8:
    pl_ApplyMovement PL_PLAYER, P131_0964
    pl_ApplyMovement 24, P131_0940
    pl_WaitMovement
    pl_GoTo P131_0930

P131_08F0:
    pl_ApplyMovement 24, P131_0940
    pl_WaitMovement
    pl_GoTo P131_0930

P131_0900:
    pl_ApplyMovement PL_PLAYER, P131_0978
    pl_ApplyMovement 24, P131_0940
    pl_WaitMovement
    pl_GoTo P131_0930

P131_0918:
    pl_ApplyMovement PL_PLAYER, P131_0984
    pl_ApplyMovement 24, P131_0954
    pl_WaitMovement
    pl_GoTo P131_0930

P131_0930:
    pl_RemoveObject 24, PFLAG_0241
    pl_ReleaseAll
    pl_End

P131_S15:
P131_0990:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 24
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S18:
P131_09A3:
    pl_sign 41, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S19:
P131_09BA:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 42, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S20:
P131_09CF:
    pl_sign 43, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S21:
P131_09E6:
    pl_sign 44, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S22:
P131_09FD:
    pl_sign 45, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S23:
P131_0A14:
    pl_sign 46, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S24:
P131_0A2B:
    pl_sign 47, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S25:
P131_0A42:
    pl_sign 48, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P131_S26:
P131_0A59:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub CheckPartyHasSpecies2  // Pearl 0x262 CheckPokemonInParty 386, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_0B19
    pl_stub ChangeDeoxysForm  // Pearl 0x263 SetDeoxysForm 3: not translated yet
    pl_PlayCry 386
    pl_msg_sys 37
    pl_WaitButton
    pl_WaitCry
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S27:
P131_0A89:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub CheckPartyHasSpecies2  // Pearl 0x262 CheckPokemonInParty 386, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_0B19
    pl_stub ChangeDeoxysForm  // Pearl 0x263 SetDeoxysForm 2: not translated yet
    pl_PlayCry 386
    pl_msg_sys 38
    pl_WaitButton
    pl_WaitCry
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S28:
P131_0AB9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub CheckPartyHasSpecies2  // Pearl 0x262 CheckPokemonInParty 386, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_0B19
    pl_stub ChangeDeoxysForm  // Pearl 0x263 SetDeoxysForm 1: not translated yet
    pl_PlayCry 386
    pl_msg_sys 39
    pl_WaitButton
    pl_WaitCry
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S29:
P131_0AE9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub CheckPartyHasSpecies2  // Pearl 0x262 CheckPokemonInParty 386, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P131_0B19
    pl_stub ChangeDeoxysForm  // Pearl 0x263 SetDeoxysForm 0: not translated yet
    pl_PlayCry 386
    pl_msg_sys 40
    pl_WaitButton
    pl_WaitCry
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_0B19:
    pl_msg_sys 36
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P131_S30:
P131_0B24:
    pl_LockAll
    pl_ApplyMovement 6, P131_0B88
    pl_WaitMovement
    pl_GetPlayerGender PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P131_0B76
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P131_0B7E
    pl_CloseMessage
    pl_ApplyMovement 6, P131_0B9C
    pl_WaitMovement
    pl_RemoveObject 6, PFLAG_01C6
    pl_Call P131_00A7
    pl_ClearFlag PFLAG_01C6
    pl_AddObjectAt 6, 0, 3  // at its SetObjectEventPos
    pl_SetVarFromValue PVAR_411A, 2
    pl_ReleaseAll
    pl_End

P131_0B76:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_Return

P131_0B7E:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_Return

    .balign 4, 0
P131_0214:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P131_0220:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_022C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0234:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0240:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_024C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0258:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0264:
    Move 63, 2  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0274:
    Move 63, 2  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_05B4:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P131_05C0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P131_05CC:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P131_0624:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P131_062C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0634:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 13, 10  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0640:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P131_064C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P131_0654:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P131_067C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0684:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P131_068C:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P131_0698:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P131_06A0:
    Move 19, 4  // WALK_FAST_EAST
    Move 16, 4  // WALK_FAST_NORTH
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P131_06B0:
    Move 19, 4  // WALK_FAST_EAST
    Move 16, 6  // WALK_FAST_NORTH
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P131_07E4:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P131_07EC:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P131_07F8:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P131_0810:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P131_0938:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P131_0940:
    Move 19, 1  // WALK_FAST_EAST
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 1  // WALK_FAST_EAST
    Move 17, 9  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P131_0954:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 2  // WALK_FAST_EAST
    Move 17, 9  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P131_0964:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 63, 2  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0978:
    Move 63, 4  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0984:
    Move 63, 2  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P131_0B88:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P131_0B9C:
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- a zone-init copy of P131_00A7 (another script calls it outside the zone init)
P131_Zinit_00A7:
P131Z_00A7:
    pl_SetObjectEventPos 6, 696, 596, 3, 1  // object 6
// SetObjectEventMovementType 6, 17: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_SetObjectEventPos 6, 696, 596, 3, 1  // SetObjectEventDir 6 (at the place SetObjectEventPos just gave)
    pl_Return

PearlProxy_2027:                  // Pearl global script 2027 (run by this zone's events)
    VMCall T205_28_S28
    VMHalt

PearlProxy_10003:                  // Pearl global script 10003 (run by this zone's events)
    VMCall C375_4_S4
    VMHalt

PearlItemBall_23:                // item ball (data/pearl_item_balls.json): object 23, Pearl script 7121 (item 463)
    VMCall C370_122_S122
    VMHalt

// ---- Pearl global script 205:41 (a subroutine here)
C205_41_S41:
C205_41_14CD:
    pl_FadeOutBGM 1  // StopMusic
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, C205_41_14F3
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_41_14F9
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_41_14F3:
    #ifdef SEQ_PEARL_THE_GIRL
        pl_PlayMusic SEQ_PEARL_THE_GIRL  // Pearl SEQ_THE_GIRL
    #else
        pl_PlayMusic SEQ_BGM_E_BERU  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_Return

C205_41_14F9:
    #ifdef SEQ_PEARL_THE_BOY
        pl_PlayMusic SEQ_PEARL_THE_BOY  // Pearl SEQ_THE_BOY
    #else
        pl_PlayMusic SEQ_BGM_E_BERU  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_Return

// ---- Pearl global script 205:42 (a subroutine here)
C205_42_S42:
C205_42_1517:
    pl_FadeOutBGM 30  // FadeOutBGM to volume 0
    pl_FadeOutBGM 1  // StopMusic
    pl_PlayDefaultMusic
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

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
    pl_msg_sys 49  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 50  // Pearl bank 199 line 28
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
    pl_msg_sys 51  // Pearl bank 199 line 25
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
    pl_msg_sys 52  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 53  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 54  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 55  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 56  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 57  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 58  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 59  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:18 (a subroutine here)
C205_18_S18:
C205_18_0B60:
    pl_Call C205_18_0B6A
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_18_0B6A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 60  // Pearl bank 199 line 27
    pl_WaitButton
    pl_Return

// ---- Pearl global script 205:28 (a subroutine here)
T205_28_S28:
T205_28_1222:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 61  // Pearl bank 199 line 67
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
    pl_msg_sys 62  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 63  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 64  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 65  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 2 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 691
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 614
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (691, 614) to (691, 617)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 691
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 617
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (691, 617) to (691, 614)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 132  // GetCurrentMapID: Pearl map 132
// CreateJournalEvent 26, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo C375_4_055F

C375_4_055F:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 370:122 (a subroutine here)
C370_122_S122:
C370_122_0D76:
    pl_SetVarFromValue PVAR_8008, 463
    pl_SetVarFromValue PVAR_8009, 1
    pl_GoTo C370_122_17EE

C370_122_17EE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_SetVarFromVar PVAR_8004, PVAR_8008
    pl_SetVarFromVar PVAR_8005, PVAR_8009
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C370_122_1830
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C370_122_19E8
    VMReturn  // End: the sub-script ends

C370_122_182A:
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C370_122_1830:
    VMCall C205_2_S2  // CallCommonScript 2001 (Pearl file 205 script 2)
    pl_RemoveTalkedObject  // RemoveEvent VAR_LAST_TALKED: the ball, and its flag
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
// Unk02A2 PVAR_8004: Pearl's orb record (items 135/136), read by no script: nothing in Black 2
    pl_CompareVarToValue PVAR_8004, 463
    pl_CallIf 1, C370_122_1A00
    ItemIsTMHM PVAR_8004, PVAR_800C  // ItemIdIsTMOrHM
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C370_122_19BD
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C370_122_19D5
    VMReturn  // End: the sub-script ends

C370_122_1873:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C370_122_1A06
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C370_122_1919
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C370_122_1906
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C370_122_1965
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C370_122_1952
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C370_122_1978
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C370_122_198B
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C370_122_193F
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C370_122_192C
    VMReturn  // End: the sub-script ends

C370_122_1906:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_1919:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_192C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_193F:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_1952:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_1965:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_1978:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_198B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_122_199E

C370_122_199E:
// CreateJournalEvent 18, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 66  // Pearl bank 325 line 9
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 1
    pl_GoTo C370_122_182A

C370_122_19BD:
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    pl_BufferTMHMMoveName 2, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 67  // Pearl bank 325 line 6
    pl_GoTo C370_122_1873

C370_122_19D5:
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 68  // Pearl bank 325 line 3
    pl_GoTo C370_122_1873

C370_122_19E8:
    pl_BufferItemName 0, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 69  // Pearl bank 325 line 4
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 0
    pl_GoTo C370_122_182A

C370_122_1A00:
    pl_SetFlag PFLAG_0986
    pl_Return

C370_122_1A06:
    VMCall C205_39_S39  // CallCommonScript 2038 (Pearl file 205 script 39)
    pl_Return

// ---- Pearl global script 205:2 (a subroutine here)
C205_2_S2:
C205_2_032C:
    pl_Call C205_2_0336
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_2_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_2_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_2_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_2_03B2
    VMReturn  // End: the sub-script ends

C205_2_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_2_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_2_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_2_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

// ---- Pearl global script 205:39 (a subroutine here)
C205_39_S39:
C205_39_1326:
    pl_Call C205_39_1330
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_39_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_39_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_39_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_39_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_39_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_39_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_39_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_39_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_39_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_39_13D8
    pl_Return

C205_39_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_39_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 52  // Pearl bank 199 line 110
    pl_Return

C205_39_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 53  // Pearl bank 199 line 111
    pl_Return

C205_39_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 54  // Pearl bank 199 line 112
    pl_Return

C205_39_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 55  // Pearl bank 199 line 113
    pl_Return

C205_39_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 56  // Pearl bank 199 line 114
    pl_Return

C205_39_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 57  // Pearl bank 199 line 115
    pl_Return

C205_39_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 58  // Pearl bank 199 line 116
    pl_Return

C205_39_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 59  // Pearl bank 199 line 117
    pl_Return

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
