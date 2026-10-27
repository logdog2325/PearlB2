// MAP_JUBLIFE: Pearl script file 2, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-27: Pearl's; no warp continuations; 28: PearlArrive; 75: Pearl 9300
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P2_S1
    ScriptEntry P2_S2
    ScriptEntry P2_S3
    ScriptEntry P2_S4
    ScriptEntry P2_S5
    ScriptEntry P2_S6
    ScriptEntry P2_S7
    ScriptEntry P2_S8
    ScriptEntry P2_S9
    ScriptEntry P2_S10
    ScriptEntry P2_S11
    ScriptEntry P2_S12
    ScriptEntry P2_S13
    ScriptEntry P2_S14
    ScriptEntry P2_S15
    ScriptEntry P2_S16
    ScriptEntry P2_S17
    ScriptEntry P2_S18
    ScriptEntry P2_S19
    ScriptEntry P2_S20
    ScriptEntry P2_S21
    ScriptEntry P2_S22
    ScriptEntry P2_S23
    ScriptEntry P2_S24
    ScriptEntry P2_S25
    ScriptEntry P2_S26
    ScriptEntry P2_S27
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
    ScriptEntry PearlProxy_9300
    ScriptEntriesEnd

P2_S1:
P2_006E:
    pl_CompareVarToValue PVAR_4077, 3
    pl_CallIf 4, P2_009B
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P2_00B1
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P2_00B9
    pl_End

P2_009B:
    pl_SetObjectEventPos 7, 176, 739, 1, 2  // object 7
    pl_SetObjectEventPos 7, 176, 739, 2, 2  // SetObjectEventDir 7 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 7, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_Return

P2_00B1:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P2_00B9:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P2_S2:
P2_00C1:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 173
    pl_GoToIf 1, P2_00F2
    pl_CompareVarToValue PVAR_8004, 174
    pl_GoToIf 1, P2_0102
    pl_CompareVarToValue PVAR_8004, 175
    pl_GoToIf 1, P2_0112
    pl_End

P2_00F2:
    pl_SetObjectEventPosLater 0, 7, 173, 2, 788, 1  // SetObjectEventPos 7 (the live actor; and where AddObject puts it)
    pl_GoTo P2_0122

P2_0102:
    pl_SetObjectEventPosLater 0, 7, 174, 2, 788, 1  // SetObjectEventPos 7 (the live actor; and where AddObject puts it)
    pl_GoTo P2_0122

P2_0112:
    pl_SetObjectEventPosLater 0, 7, 175, 2, 788, 1  // SetObjectEventPos 7 (the live actor; and where AddObject puts it)
    pl_GoTo P2_0122

P2_0122:
    pl_ClearFlag PFLAG_0198
    pl_AddObjectAt 7, 0, 1  // at its SetObjectEventPos
// LockObject 7: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 7, P2_0214
    pl_WaitMovement
    VMCall C205_41_S41  // CallCommonScript 2040 (Pearl file 205 script 41)
    pl_ApplyMovement 7, P2_0224
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0166
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_01AD
    pl_End

P2_0166:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 0
    pl_GetPartyCount PVAR_800C
    pl_BufferNumber 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 4
    pl_CallIf 4, P2_01A3
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 3, P2_01A8
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4
    pl_GoTo P2_01F4

P2_01A3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_Return

P2_01A8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2
    pl_Return

P2_01AD:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 5
    pl_GetPartyCount PVAR_800C
    pl_BufferNumber 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 4
    pl_CallIf 4, P2_01EA
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 3, P2_01EF
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9
    pl_GoTo P2_01F4

P2_01EA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6
    pl_Return

P2_01EF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7
    pl_Return

P2_01F4:
    pl_CloseMessage
    pl_ApplyMovement 7, P2_022C
    pl_WaitMovement
    pl_RemoveObject 7, PFLAG_0198
    VMCall C205_42_S42  // CallCommonScript 2041 (Pearl file 205 script 42)
    pl_SetVarFromValue PVAR_4077, 1
    pl_ReleaseAll
    pl_End

P2_S12:
P2_0234:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_025A
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_025A:
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S13:
P2_0265:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 72
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S19:
P2_0278:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 779
    pl_GoToIf 1, P2_02A9
    pl_CompareVarToValue PVAR_8005, 780
    pl_GoToIf 1, P2_02D2
    pl_CompareVarToValue PVAR_8005, 781
    pl_GoToIf 1, P2_02FB
    pl_End

P2_02A9:
    pl_ApplyMovement 27, P2_0328
    pl_WaitMovement
    pl_msg_sys 71
    pl_CloseMessage
    pl_ApplyMovement 27, P2_0358
    pl_ApplyMovement PL_PLAYER, P2_03A0
    pl_WaitMovement
    pl_GoTo P2_0324

P2_02D2:
    pl_ApplyMovement 27, P2_0338
    pl_WaitMovement
    pl_msg_sys 71
    pl_CloseMessage
    pl_ApplyMovement 27, P2_0370
    pl_ApplyMovement PL_PLAYER, P2_03A0
    pl_WaitMovement
    pl_GoTo P2_0324

P2_02FB:
    pl_ApplyMovement 27, P2_0348
    pl_WaitMovement
    pl_msg_sys 71
    pl_CloseMessage
    pl_ApplyMovement 27, P2_0388
    pl_ApplyMovement PL_PLAYER, P2_03A0
    pl_WaitMovement
    pl_GoTo P2_0324

P2_0324:
    pl_ReleaseAll
    pl_End

P2_S3:
P2_03A8:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 757
    pl_GoToIf 1, P2_03E6
    pl_CompareVarToValue PVAR_8005, 758
    pl_GoToIf 1, P2_0400
    pl_CompareVarToValue PVAR_8005, 759
    pl_GoToIf 1, P2_041A
    pl_CompareVarToValue PVAR_8005, 760
    pl_GoToIf 1, P2_0434
    pl_End

P2_03E6:
    pl_ApplyMovement PL_PLAYER, P2_053C
    pl_ApplyMovement 19, P2_0550
    pl_WaitMovement
    pl_GoTo P2_044E

P2_0400:
    pl_ApplyMovement PL_PLAYER, P2_053C
    pl_ApplyMovement 19, P2_0564
    pl_WaitMovement
    pl_GoTo P2_044E

P2_041A:
    pl_ApplyMovement PL_PLAYER, P2_053C
    pl_ApplyMovement 19, P2_0578
    pl_WaitMovement
    pl_GoTo P2_044E

P2_0434:
    pl_ApplyMovement PL_PLAYER, P2_053C
    pl_ApplyMovement 19, P2_058C
    pl_WaitMovement
    pl_GoTo P2_044E

P2_044E:
    pl_Call P2_04A4
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P2_0548
    pl_ApplyMovement 19, P2_05A0
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 757
    pl_GoToIf 1, P2_04EE
    pl_CompareVarToValue PVAR_8005, 758
    pl_GoToIf 1, P2_0500
    pl_CompareVarToValue PVAR_8005, 759
    pl_GoToIf 1, P2_0512
    pl_CompareVarToValue PVAR_8005, 760
    pl_GoToIf 1, P2_0524
    pl_End

P2_04A4:
    pl_CheckFlag PFLAG_00F1
    pl_GoToIf 0, P2_04BF
    pl_CheckFlag PFLAG_00F3
    pl_GoToIf 0, P2_04C4
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12
    pl_Return

P2_04BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 13
    pl_Return

P2_04C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15
    pl_Return

P2_04C9:
    pl_CheckFlag PFLAG_00F1
    pl_GoToIf 0, P2_04E4
    pl_CheckFlag PFLAG_00F3
    pl_GoToIf 0, P2_04E9
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 18
    pl_Return

P2_04E4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 19
    pl_Return

P2_04E9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20
    pl_Return

P2_04EE:
    pl_ApplyMovement 19, P2_05B0
    pl_WaitMovement
    pl_GoTo P2_0536

P2_0500:
    pl_ApplyMovement 19, P2_05BC
    pl_WaitMovement
    pl_GoTo P2_0536

P2_0512:
    pl_ApplyMovement 19, P2_05C8
    pl_WaitMovement
    pl_GoTo P2_0536

P2_0524:
    pl_ApplyMovement 19, P2_05D4
    pl_WaitMovement
    pl_GoTo P2_0536

P2_0536:
    pl_ReleaseAll
    pl_End

P2_S5:
P2_05E0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_061F
    pl_CheckFlag PFLAG_00F3
    pl_GoToIf 1, P2_0614
    pl_Call P2_04C9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0614:
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_061F:
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S4:
P2_062A:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8000, PVAR_8001
    pl_CompareVarToValue PVAR_8000, 173
    pl_GoToIf 1, P2_065B
    pl_CompareVarToValue PVAR_8000, 174
    pl_GoToIf 1, P2_0675
    pl_CompareVarToValue PVAR_8000, 175
    pl_GoToIf 1, P2_068F
    pl_End

P2_065B:
    pl_ApplyMovement 16, P2_0A8C
    pl_ApplyMovement PL_PLAYER, P2_09AC
    pl_WaitMovement
    pl_GoTo P2_06A9

P2_0675:
    pl_ApplyMovement 16, P2_0A8C
    pl_ApplyMovement PL_PLAYER, P2_09C0
    pl_WaitMovement
    pl_GoTo P2_06A9

P2_068F:
    pl_ApplyMovement 16, P2_0A8C
    pl_ApplyMovement PL_PLAYER, P2_09CC
    pl_WaitMovement
    pl_GoTo P2_06A9

P2_06A9:
    pl_BufferPlayerName 0
// BufferCounterpartName 1: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 46
    pl_ApplyMovement 17, P2_0A6C
    pl_ApplyMovement 16, P2_0A98
    pl_WaitMovement
    pl_msg_sys 47
    pl_ApplyMovement 7, P2_0A1C
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_06F1
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_0702
    pl_End

P2_06F1:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 48
    pl_GoTo P2_0713

P2_0702:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 49
    pl_GoTo P2_0713

P2_0713:
    pl_CloseMessage
    pl_ApplyMovement 7, P2_0A24
    pl_WaitMovement
    pl_Call P2_07AD
// StartTagBattle PVAR_8004, 414, 415: the partner by Pearl's trainer number in the var
    WorkCmpConst PVAR_8004, 613
    VMJumpIf CMP_NE, .Ltag725_613
    pl_StartTagBattle PTRAINER_613, PTRAINER_414, PTRAINER_415
    VMJump .Ltag725_end
.Ltag725_613:
    WorkCmpConst PVAR_8004, 614
    VMJumpIf CMP_NE, .Ltag725_614
    pl_StartTagBattle PTRAINER_614, PTRAINER_414, PTRAINER_415
    VMJump .Ltag725_end
.Ltag725_614:
    WorkCmpConst PVAR_8004, 615
    VMJumpIf CMP_NE, .Ltag725_615
    pl_StartTagBattle PTRAINER_615, PTRAINER_414, PTRAINER_415
    VMJump .Ltag725_end
.Ltag725_615:
    WorkCmpConst PVAR_8004, 616
    VMJumpIf CMP_NE, .Ltag725_616
    pl_StartTagBattle PTRAINER_616, PTRAINER_414, PTRAINER_415
    VMJump .Ltag725_end
.Ltag725_616:
    WorkCmpConst PVAR_8004, 617
    VMJumpIf CMP_NE, .Ltag725_617
    pl_StartTagBattle PTRAINER_617, PTRAINER_414, PTRAINER_415
    VMJump .Ltag725_end
.Ltag725_617:
    pl_StartTagBattle PTRAINER_618, PTRAINER_414, PTRAINER_415
.Ltag725_end:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0995
    pl_ApplyMovement 18, P2_0A84
    pl_WaitMovement
    pl_msg_sys 50
    pl_CloseMessage
    pl_ApplyMovement 17, P2_0A74
    pl_ApplyMovement 18, P2_0A7C
    pl_WaitMovement
    pl_RemoveObject 17, PFLAG_01BA
    pl_RemoveObject 18, PFLAG_01BA
    pl_SetFlag PFLAG_01BA
    pl_ApplyMovement 16, P2_0AC0
    pl_ApplyMovement 7, P2_0A2C
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 51
    pl_ApplyMovement 7, P2_0A38
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0833
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_0844
    pl_End

P2_07AD:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_07CD
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_07FF
    pl_End

P2_07CD:
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_SetVarFromValue PVAR_8004, 616
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P2_0831
    pl_SetVarFromValue PVAR_8004, 617
    pl_CompareVarToValue PVAR_800C, 393
    pl_GoToIf 1, P2_0831
    pl_SetVarFromValue PVAR_8004, 618
    pl_Return

P2_07FF:
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_SetVarFromValue PVAR_8004, 613
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P2_0831
    pl_SetVarFromValue PVAR_8004, 614
    pl_CompareVarToValue PVAR_800C, 393
    pl_GoToIf 1, P2_0831
    pl_SetVarFromValue PVAR_8004, 615
    pl_Return

P2_0831:
    pl_Return

P2_0833:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 55
    pl_GoTo P2_0855

P2_0844:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 56
    pl_GoTo P2_0855

P2_0855:
    pl_CloseMessage
    pl_ApplyMovement 7, P2_0A40
    pl_ApplyMovement 16, P2_0AA0
    pl_ApplyMovement PL_PLAYER, P2_09E0
    pl_WaitMovement
    pl_GoTo P2_0879

P2_0879:
    pl_RemoveObject 7, PFLAG_0198
    pl_RemoveObject 16, PFLAG_01BB
    pl_ClearFlag PFLAG_01B6
    pl_SetVarFromValue PVAR_4077, 4
    pl_SetVarFromValue PVAR_4079, 3
    pl_RemoveObject 25, PFLAG_0213
    pl_RemoveObject 26, PFLAG_0213
    pl_RemoveObject 28, PFLAG_0256
    pl_SetObjectEventPosLater 1, 31, 174, 2, 750, 0  // SetObjectEventPos 31 (the live actor; and where AddObject puts it)
// SetObjectEventMovementType 31, 14: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_ClearFlag PFLAG_01A9
    pl_AddObjectAt 31, 1, 0  // at its SetObjectEventPos
// LockObject 31: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 31, P2_099C
    pl_WaitMovement
    pl_msg_sys 57
    pl_Call P2_08E7
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 58
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 31, P2_09A4
    pl_WaitMovement
    pl_RemoveObject 31, PFLAG_01A9
    pl_ReleaseAll
    pl_End

P2_08E7:
    pl_SetVarFromValue PVAR_8004, 435
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_00F2
    pl_Call P2_0949
    pl_Call P2_0949
    pl_Call P2_0949
    pl_Call P2_0949
    pl_Call P2_0949
    pl_Call P2_0963
    pl_Call P2_0963
    pl_Call P2_0963
    pl_Call P2_0963
    pl_Call P2_0963
// AddContestBackdrop 0: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
    pl_Call P2_097D
    pl_Call P2_097D
    pl_Return

P2_0949:
    pl_GetRandom PVAR_800C, 6
    pl_SetVarFromValue PVAR_8004, 0
    pl_AddVar PVAR_8004, PVAR_800C
// AddAccessory 32772, 1: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
    pl_Return

P2_0963:
    pl_GetRandom PVAR_800C, 6
    pl_SetVarFromValue PVAR_8004, 18
    pl_AddVar PVAR_8004, PVAR_800C
// AddAccessory 32772, 1: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
    pl_Return

P2_097D:
    pl_GetRandom PVAR_800C, 8
    pl_SetVarFromValue PVAR_8004, 1
    pl_AddVar PVAR_8004, PVAR_800C
// AddContestBackdrop 32772: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
    pl_Return

P2_0995:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P2_S6:
P2_0AF0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 59
    ListMenu_AnchorTopRight 31, 11, 0, 0, PVAR_800C  // Pearl InitGlobalTextListMenu 29, 11, 0, 0, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 81, 65535, 255  // Pearl AddListMenuEntry 45, 255
    ListMenuAdd 82, 65535, 255  // Pearl AddListMenuEntry 46, 255
    ListMenuAdd 83, 65535, 255  // Pearl AddListMenuEntry 47, 255
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P2_0B4B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P2_0B56
    pl_msg_talk 62
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0B4B:
    pl_msg_talk 60
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0B56:
    pl_msg_talk 61
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S7:
P2_0B61:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 63
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S10:
P2_0B74:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 67
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S8:
P2_0B87:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 64
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S11:
P2_0B9A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 68
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0BC5
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_0BD0
    pl_End

P2_0BC5:
    pl_msg_talk 69
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0BD0:
    pl_msg_talk 70
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S9:
P2_0BDB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 65
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S22:
P2_0BEE:
    pl_sign 75, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P2_S23:
P2_0C05:
    pl_sign 76, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P2_S24:
P2_0C1C:
    pl_sign 77, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P2_S25:
P2_0C33:
    pl_sign 78, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P2_S26:
P2_0C4A:
    pl_sign 79, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P2_S27:
P2_0C61:
    pl_sign 80, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P2_S17:
P2_0C78:
    pl_LockAll
    pl_ApplyMovement 24, P2_0D2C
    pl_ApplyMovement PL_PLAYER, P2_0D24
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 172
    pl_CallIf 1, P2_0CE7
    pl_CompareVarToValue PVAR_8004, 173
    pl_CallIf 1, P2_0CF3
    pl_CompareVarToValue PVAR_8004, 174
    pl_CallIf 1, P2_0CFF
    pl_CompareVarToValue PVAR_8004, 175
    pl_CallIf 1, P2_0D0B
    pl_CompareVarToValue PVAR_8004, 176
    pl_CallIf 1, P2_0D17
    pl_msg_sys 21
    pl_SetVarFromValue PVAR_40E7, 2
    pl_msg_sys 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0CE7:
    pl_ApplyMovement 24, P2_0D38
    pl_WaitMovement
    pl_Return

P2_0CF3:
    pl_ApplyMovement 24, P2_0D48
    pl_WaitMovement
    pl_Return

P2_0CFF:
    pl_ApplyMovement 24, P2_0D58
    pl_WaitMovement
    pl_Return

P2_0D0B:
    pl_ApplyMovement 24, P2_0D60
    pl_WaitMovement
    pl_Return

P2_0D17:
    pl_ApplyMovement 24, P2_0D70
    pl_WaitMovement
    pl_Return

P2_S18:
P2_0D80:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetVarFromValue PVAR_8004, 0
    pl_Call P2_0DAC
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P2_0DD7
    pl_msg_talk 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0DAC:
    pl_CheckFlag PFLAG_00ED
    pl_CallIf 1, P2_0DCF
    pl_CheckFlag PFLAG_00EE
    pl_CallIf 1, P2_0DCF
    pl_CheckFlag PFLAG_00EF
    pl_CallIf 1, P2_0DCF
    pl_Return

P2_0DCF:
    pl_AddVar PVAR_8004, 1
    pl_Return

P2_0DD7:
    pl_msg_talk 24
    pl_RemoveItem 460, 1, PVAR_800C
    pl_RemoveItem 461, 1, PVAR_800C
    pl_RemoveItem 462, 1, PVAR_800C
    pl_EnablePoketch
    pl_SetVarFromValue PVAR_4077, 2
    pl_RegisterPoketchApp 0  // Digital Watch
    pl_RegisterPoketchApp 1  // Calculator
    pl_RegisterPoketchApp 3  // Pedometer
    pl_RegisterPoketchApp 4  // Pokémon List
    pl_BufferPlayerName 0
    pl_msg_talk 25
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_msg_talk 26
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0E55
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_0E6F
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P2_0E55
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P2_0E55
    pl_End

P2_0E55:
    pl_ApplyMovement 24, P2_0EA8
    pl_ApplyMovement PL_PLAYER, P2_0EC0
    pl_WaitMovement
    pl_GoTo P2_0E89

P2_0E6F:
    pl_ApplyMovement 24, P2_0E9C
    pl_ApplyMovement PL_PLAYER, P2_0EB0
    pl_WaitMovement
    pl_GoTo P2_0E89

P2_0E89:
    pl_RemoveObject 24, PFLAG_0214
    pl_SetFlag PFLAG_00F3
    pl_ClearFlag PFLAG_0215
    pl_ReleaseAll
    pl_End

P2_S14:
P2_0ECC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00ED
    pl_GoToIf 1, P2_0F38
    pl_msg_talk 27
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0F02
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_0F29
    pl_End

P2_0F02:
    pl_PlaySE SEQ_SE_DECIDE2  // Pearl SEQ_SE_DP_PINPON
    pl_msg_talk 28
    pl_msg_talk 30
    pl_msg_talk 31
    pl_SetVarFromValue PVAR_8004, 460
    pl_SetVarFromValue PVAR_8005, 1
    pl_SetFlag PFLAG_00ED
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0F29:
    pl_PlaySE SEQ_SE_PC_ON  // Pearl SEQ_SE_DP_BOX03
    pl_msg_talk 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0F38:
    pl_msg_talk 32
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S15:
P2_0F43:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00EE
    pl_GoToIf 1, P2_0FAF
    pl_msg_talk 33
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0F79
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_0FA0
    pl_End

P2_0F79:
    pl_PlaySE SEQ_SE_DECIDE2  // Pearl SEQ_SE_DP_PINPON
    pl_msg_talk 34
    pl_msg_talk 36
    pl_msg_talk 37
    pl_SetVarFromValue PVAR_8004, 461
    pl_SetVarFromValue PVAR_8005, 1
    pl_SetFlag PFLAG_00EE
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0FA0:
    pl_PlaySE SEQ_SE_PC_ON  // Pearl SEQ_SE_DP_BOX03
    pl_msg_talk 35
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_0FAF:
    pl_msg_talk 38
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S16:
P2_0FBA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40E7, 2
    pl_GoToIf 0, P2_104A
    pl_CheckFlag PFLAG_00EF
    pl_GoToIf 1, P2_103F
    pl_msg_talk 39
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P2_0FFD
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P2_1030
    pl_End

P2_0FFD:
    pl_PlaySE SEQ_SE_DECIDE2  // Pearl SEQ_SE_DP_PINPON
    pl_msg_talk 40
    pl_msg_talk 42
    pl_msg_talk 43
    pl_SetPosition 24, 174, 2, 771, 1
    pl_SetVarFromValue PVAR_8004, 462
    pl_SetVarFromValue PVAR_8005, 1
    pl_SetFlag PFLAG_00EF
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_1030:
    pl_PlaySE SEQ_SE_PC_ON  // Pearl SEQ_SE_DP_BOX03
    pl_msg_talk 41
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_103F:
    pl_msg_talk 45
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_104A:
    pl_msg_talk 44
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S20:
P2_1055:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 73
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P2_S21:
P2_1068:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 74
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P2_0214:
    Move 13, 4  // WALK_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
P2_0224:
    Move 13, 3  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_022C:
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_0328:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_0338:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_0348:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_0358:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 63, 2  // DELAY_8
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0370:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 63, 2  // DELAY_8
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0388:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 63, 2  // DELAY_8
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_03A0:
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_053C:
    Move 63, 5  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P2_0548:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P2_0550:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_0564:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_0578:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_058C:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    Move 13, 4  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_05A0:
    Move 71, 1  // LOCK_DIR
    Move 14, 1  // WALK_NORMAL_WEST
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P2_05B0:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_05BC:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_05C8:
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_05D4:
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_099C:
    Move 12, 8  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_09A4:
    Move 13, 8  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_09AC:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_09C0:
    Move 63, 2  // DELAY_8
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_09CC:
    Move 63, 2  // DELAY_8
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_09E0:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0A1C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0A24:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P2_0A2C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0A38:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0A40:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0A6C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_0A74:
    Move 16, 9  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P2_0A7C:
    Move 16, 10  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P2_0A84:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P2_0A8C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P2_0A98:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P2_0AA0:
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0AC0:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0D24:
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P2_0D2C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P2_0D38:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0D48:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0D58:
    Move 13, 4  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0D60:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0D70:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 2  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P2_0E9C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_0EA8:
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_0EB0:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P2_0EC0:
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

PearlProxy_9300:                  // Pearl global script 9300 (run by this zone's events)
    VMCall T372_1_S1
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
    pl_msg_sys 84  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 85  // Pearl bank 199 line 28
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
    pl_msg_sys 86  // Pearl bank 199 line 25
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
    pl_msg_sys 87  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 88  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 89  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 90  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 91  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 92  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 93  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 94  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:17 (a subroutine here)
C205_17_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_17_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_17_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_17_03B2
    VMReturn  // End: the sub-script ends

C205_17_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_17_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_17_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_17_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

C205_17_S17:
C205_17_0978:
    pl_Call C205_17_0982
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_17_0982:
    pl_Call C205_17_0336
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, C205_17_09F4
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 5, C205_17_0A05
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 95  // Pearl bank 199 line 30
    pl_WaitButton
    pl_Return

C205_17_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 85  // Pearl bank 199 line 28
    pl_GoTo C205_17_0A2B

C205_17_0A05:
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_17_0A1D
    pl_BufferItemName 0, PVAR_8004
    pl_GoTo C205_17_0A22

C205_17_0A1D:
    pl_BufferItemName 0, PVAR_8004  // GetItemNamePlural

C205_17_0A22:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 86  // Pearl bank 199 line 25
    pl_GoTo C205_17_0A2B

C205_17_0A2B:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_17_1330
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_17_0A5B
    pl_BufferItemName 1, PVAR_8004
    pl_GoTo C205_17_0A60

C205_17_0A5B:
    pl_BufferItemName 1, PVAR_8004  // GetItemNamePlural

C205_17_0A60:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_17_0AE7
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_17_0AD6
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_17_0B2B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_17_0B1A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_17_0B3C
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_17_0AF8
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_17_0B09
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_17_0B4D
    VMReturn  // End: the sub-script ends

C205_17_0AD6:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0AE7:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0AF8:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B09:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B1A:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B2B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B3C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B4D:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B5E:
    pl_Return

C205_17_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_17_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_17_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_17_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_17_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_17_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_17_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_17_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_17_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_17_13D8
    pl_Return

C205_17_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_17_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 87  // Pearl bank 199 line 110
    pl_Return

C205_17_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 88  // Pearl bank 199 line 111
    pl_Return

C205_17_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 89  // Pearl bank 199 line 112
    pl_Return

C205_17_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 90  // Pearl bank 199 line 113
    pl_Return

C205_17_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 91  // Pearl bank 199 line 114
    pl_Return

C205_17_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 92  // Pearl bank 199 line 115
    pl_Return

C205_17_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 93  // Pearl bank 199 line 116
    pl_Return

C205_17_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 94  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 372:1 (a subroutine here)
T372_1_S1:
T372_1_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 1, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_0070
    pl_Call T372_1_0102
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_003C
    pl_GoTo T372_1_0055

T372_1_003C:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 3, 1, 0: not translated yet
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 1, 1: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 96  // Pearl bank 329 line 0
    pl_GoTo T372_1_00A8

T372_1_0055:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 3, 1, 0: not translated yet
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 1, 1: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 97  // Pearl bank 329 line 1
    pl_GoTo T372_1_008C

T372_1_0070:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 98  // Pearl bank 329 line 2

T372_1_0073:
    pl_Call T372_1_0102
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_00A8
    pl_GoTo T372_1_008C

T372_1_008C:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_8004
    ListMenuAdd 99, 65535, 1  // Pearl AddMenuEntryImm 11, 1
    ListMenuAdd 100, 65535, 3  // Pearl AddMenuEntryImm 13, 3
    ListMenuAdd 101, 65535, 4  // Pearl AddMenuEntryImm 14, 4
    ListMenuShow
    pl_GoTo T372_1_00C2

T372_1_00A8:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_8004
    ListMenuAdd 99, 65535, 1  // Pearl AddMenuEntryImm 11, 1
    ListMenuAdd 102, 65535, 2  // Pearl AddMenuEntryImm 12, 2
    ListMenuAdd 100, 65535, 3  // Pearl AddMenuEntryImm 13, 3
    ListMenuAdd 101, 65535, 4  // Pearl AddMenuEntryImm 14, 4
    ListMenuShow

T372_1_00C2:
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T372_1_01CF
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T372_1_0261
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T372_1_03DA
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, T372_1_03E5
    pl_GoTo T372_1_03E5

T372_1_0102:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_012C
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_01BF

T372_1_012C:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 2, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_0156
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 2, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_01BF

T372_1_0156:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 3, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_0180
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 3, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_01BF

T372_1_0180:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_01AA
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_01BF

T372_1_01AA:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 5, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_01C7

T372_1_01BF:
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

T372_1_01C7:
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

T372_1_01CF:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_01F8
    pl_msg_talk 103  // Pearl bank 329 line 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, T372_1_03E5

T372_1_01F8:
    pl_msg_talk 104  // Pearl bank 329 line 6
    pl_WaitABPress
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 4, 32780: not translated yet
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_03E5
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T372_1_0256
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 6: not translated yet
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 0, 0: not translated yet
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 3, 0, 1: not translated yet
    pl_msg_talk 105  // Pearl bank 329 line 7
    pl_WaitButton
    pl_GoTo T372_1_03EA

T372_1_0256:
    pl_msg_talk 106  // Pearl bank 329 line 22
    pl_WaitButton
    pl_GoTo T372_1_03EA

T372_1_0261:
    pl_msg_talk 107  // Pearl bank 329 line 3
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_8004
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_02A2
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_02A2
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 0, 0: not translated yet
    ListMenuAdd 108, 65535, 0  // Pearl AddMenuEntryImm 15, 0

T372_1_02A2:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 2, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_02D8
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 2, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_02D8
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 2, 1: not translated yet
    ListMenuAdd 109, 65535, 2  // Pearl AddMenuEntryImm 16, 2

T372_1_02D8:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 3, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_030E
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 3, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_030E
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 3, 2: not translated yet
    ListMenuAdd 110, 65535, 3  // Pearl AddMenuEntryImm 17, 3

T372_1_030E:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_0344
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_0344
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 4, 3: not translated yet
    ListMenuAdd 111, 65535, 4  // Pearl AddMenuEntryImm 18, 4

T372_1_0344:
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 0, 5, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T372_1_037A
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 1, 5, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T372_1_037A
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 5, 4: not translated yet
    ListMenuAdd 112, 65535, 5  // Pearl AddMenuEntryImm 19, 5

T372_1_037A:
    ListMenuAdd 113, 65535, 6  // Pearl AddMenuEntryImm 20, 6
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 6
    pl_GoToIf 1, T372_1_03E5
    pl_CompareVarToValue PVAR_8004, 65534
    pl_GoToIf 1, T372_1_03E5
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 32772, 0: not translated yet
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 3, 32772, 1: not translated yet
    pl_msg_talk 114  // Pearl bank 329 line 8
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, T372_1_0261
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 5, 32772: not translated yet
    pl_BufferPlayerName 0
    pl_stub DoGroupConnectionAction  // Pearl 0x21D UnionGroup 2, 32772, 1: not translated yet
    pl_msg_talk 115  // Pearl bank 329 line 9
    pl_WaitButton
    pl_GoTo T372_1_03EA

T372_1_03DA:
    pl_msg_talk 116  // Pearl bank 329 line 10
    pl_WaitABPress
    pl_GoTo T372_1_0073

T372_1_03E5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 117  // Pearl bank 329 line 4
    pl_WaitButton

T372_1_03EA:
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
