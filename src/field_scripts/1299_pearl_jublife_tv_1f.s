// MAP_JUBLIFE_TV_1F: Pearl script file 11, text bank 25. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-17: Pearl's; no warp continuations; 18: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P11_S1
    ScriptEntry P11_S2
    ScriptEntry P11_S3
    ScriptEntry P11_S4
    ScriptEntry P11_S5
    ScriptEntry P11_S6
    ScriptEntry P11_S7
    ScriptEntry P11_S8
    ScriptEntry P11_S9
    ScriptEntry P11_S10
    ScriptEntry P11_S11
    ScriptEntry P11_S12
    ScriptEntry P11_S13
    ScriptEntry P11_S14
    ScriptEntry P11_S15
    ScriptEntry P11_S16
    ScriptEntry P11_S17
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P11_S8:
P11_0046:
    pl_CheckFlag PFLAG_0AAF
    pl_GoToIf 1, P11_006D
    pl_ClearTrainerFlag PTRAINER_371
    pl_ClearTrainerFlag PTRAINER_370
    pl_ClearTrainerFlag PTRAINER_369
    pl_ClearTrainerFlag PTRAINER_460
    pl_ClearTrainerFlag PTRAINER_368
    pl_ClearTrainerFlag PTRAINER_465
    pl_ClearTrainerFlag PTRAINER_431

P11_006D:
    pl_SetFlag PFLAG_0271
    pl_SetFlag PFLAG_0272
    pl_SetFlag PFLAG_0273
    pl_SetFlag PFLAG_0274
    pl_SetFlag PFLAG_0275
    pl_SetFlag PFLAG_0276
    pl_SetFlag PFLAG_0277
    pl_SetFlag PFLAG_0278
    RTCGetWeekDay PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P11_00EE
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P11_00F4
    pl_CompareVarToValue PVAR_4000, 2
    pl_GoToIf 1, P11_00FA
    pl_CompareVarToValue PVAR_4000, 3
    pl_GoToIf 1, P11_0100
    pl_CompareVarToValue PVAR_4000, 4
    pl_GoToIf 1, P11_0106
    pl_CompareVarToValue PVAR_4000, 5
    pl_GoToIf 1, P11_0110
    pl_CompareVarToValue PVAR_4000, 6
    pl_GoToIf 1, P11_0116
    pl_End

P11_00EE:
    pl_ClearFlag PFLAG_0271
    pl_End

P11_00F4:
    pl_ClearFlag PFLAG_0272
    pl_End

P11_00FA:
    pl_ClearFlag PFLAG_0273
    pl_End

P11_0100:
    pl_ClearFlag PFLAG_0274
    pl_End

P11_0106:
    pl_ClearFlag PFLAG_0275
    pl_ClearFlag PFLAG_0276
    pl_End

P11_0110:
    pl_ClearFlag PFLAG_0277
    pl_End

P11_0116:
    pl_ClearFlag PFLAG_0278
    pl_End

P11_S1:
P11_011C:
    pl_End

P11_S2:
P11_011E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S3:
P11_0131:
    pl_End

P11_S4:
P11_0133:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40F2, 0
    pl_GoToIf 5, P11_0351
    pl_CheckFlag PFLAG_0AA9
    pl_GoToIf 1, P11_016D
    pl_msg_talk 4
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0183
    pl_GoTo P11_0178

P11_016D:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0178:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0183:
    pl_SetFlag PFLAG_0AA9
    pl_msg_talk 7
    pl_stub GetJubilifeLotteryTrainerID  // Pearl 0x24E Unk024E 32768: not translated yet
    pl_stub BufferVarPaddingDigits  // Pearl 0x280 Unk0280 0, 32768, 2, 5: not translated yet
    pl_msg_talk 8
    pl_stub CheckForJubilifeLotteryWinner  // Pearl 0x24F Unk024F 32769, 32770, 32771, 32768: not translated yet
    pl_CompareVarToValue PVAR_8002, 0
    pl_GoToIf 1, P11_0222
    pl_CompareVarToValue PVAR_8002, 1
    pl_GoToIf 1, P11_01CF
    pl_CompareVarToValue PVAR_8003, 0
    pl_GoToIf 1, P11_022D
    pl_GoTo P11_023B

P11_01CF:
    pl_CheckFlag PFLAG_0114
    pl_GoToIf 1, P11_0222
    pl_SetVarFromValue PVAR_8004, 1

P11_01E0:
    pl_stub CheckBackdrop  // Pearl 0x1D6 Unk01D6 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0210
    pl_AddVar PVAR_8004, 1
    pl_CompareVarToValue PVAR_8004, 13
    pl_GoToIf 3, P11_01E0
    pl_SetFlag PFLAG_0114
    pl_GoTo P11_0222

P11_0210:
    pl_msg_talk 12
// AddContestBackdrop 32772: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0222:
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_022D:
    pl_BufferPartyMonNickname 0, PVAR_8001
    pl_msg_talk 9
    pl_GoTo P11_0249

P11_023B:
    pl_stub BufferMonNicknameFromPC  // Pearl 0x251 Unk0251 0, 32769: not translated yet
    pl_msg_talk 10
    pl_GoTo P11_0249

P11_0249:
    pl_SetVarFromVar PVAR_8008, PVAR_8002
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P11_0285
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P11_028E
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P11_0297
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, P11_02A0
    pl_End

P11_0285:
    pl_msg_talk 14
    pl_GoTo P11_02A9

P11_028E:
    pl_msg_talk 15
    pl_GoTo P11_02A9

P11_0297:
    pl_msg_talk 16
    pl_GoTo P11_02A9

P11_02A0:
    pl_msg_talk 17
    pl_GoTo P11_02A9

P11_02A9:
    pl_SetVarFromVar PVAR_8008, PVAR_8002
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P11_02E5
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P11_02F1
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P11_02FD
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, P11_0309
    pl_End

P11_02E5:
    pl_SetVarFromValue PVAR_8003, 51
    pl_GoTo P11_0315

P11_02F1:
    pl_SetVarFromValue PVAR_8003, 216
    pl_GoTo P11_0315

P11_02FD:
    pl_SetVarFromValue PVAR_8003, 29
    pl_GoTo P11_0315

P11_0309:
    pl_SetVarFromValue PVAR_8003, 1
    pl_GoTo P11_0315

P11_0315:
    pl_SetVarFromVar PVAR_8004, PVAR_8003
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0340
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_GoTo P11_0363

P11_0340:
    pl_SetVarFromVar PVAR_40F2, PVAR_8002
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0351:
    pl_BufferPlayerName 0
    pl_msg_talk 19
    pl_SetVarFromVar PVAR_8002, PVAR_40F2
    pl_GoTo P11_02A9

P11_0363:
    pl_SetVarFromValue PVAR_40F2, 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S5:
P11_0374:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 21
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S6:
P11_0387:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S7:
P11_039A:
    pl_End

P11_S9:
P11_039C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_371
    pl_GoToIf 1, P11_03EB
    pl_msg_sys 24
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_03F6
    pl_msg_sys 25
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_371, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_371
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_03EB:
    pl_msg_sys 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_03F6:
    pl_msg_sys 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S10:
P11_0401:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_370
    pl_GoToIf 1, P11_0450
    pl_msg_sys 28
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_045B
    pl_msg_sys 29
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_370, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_370
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_0450:
    pl_msg_sys 31
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_045B:
    pl_msg_sys 30
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S11:
P11_0466:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_369
    pl_GoToIf 1, P11_04B5
    pl_msg_sys 32
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_04C0
    pl_msg_sys 33
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_369, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_369
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_04B5:
    pl_msg_sys 35
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_04C0:
    pl_msg_sys 34
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S12:
P11_04CB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_460
    pl_GoToIf 1, P11_051A
    pl_msg_sys 36
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_0525
    pl_msg_sys 37
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_460, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_460
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_051A:
    pl_msg_sys 39
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0525:
    pl_msg_sys 38
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S13:
P11_0530:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_368
    pl_GoToIf 1, P11_059D
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 4, P11_0561
    pl_msg_sys 40
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0561:
    pl_msg_sys 41
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_05A8
    pl_msg_sys 42
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_368, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_368
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_059D:
    pl_msg_sys 44
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_05A8:
    pl_msg_sys 43
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S14:
P11_05B3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_368
    pl_GoToIf 1, P11_0620
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 4, P11_05E4
    pl_msg_sys 45
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_05E4:
    pl_msg_sys 46
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_062B
    pl_msg_sys 47
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_368, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_368
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_0620:
    pl_msg_sys 49
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_062B:
    pl_msg_sys 48
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S15:
P11_0636:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_465
    pl_GoToIf 1, P11_0685
    pl_msg_sys 50
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_0690
    pl_msg_sys 51
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_465, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_465
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_0685:
    pl_msg_sys 53
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0690:
    pl_msg_sys 52
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_S16:
P11_069B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckTrainerFlag PTRAINER_431
    pl_GoToIf 1, P11_06EA
    pl_msg_sys 54
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P11_06F5
    pl_msg_sys 55
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_431, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P11_0700
    pl_SetTrainerFlag PTRAINER_431
    pl_SetFlag PFLAG_0AAF
    pl_ReleaseAll
    pl_End

P11_06EA:
    pl_msg_sys 57
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_06F5:
    pl_msg_sys 56
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P11_0700:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P11_S17:
P11_0706:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 3  // this floor's floors above (an elevator reads it)
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
    pl_msg_sys 58  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 59  // Pearl bank 199 line 28
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
    pl_msg_sys 60  // Pearl bank 199 line 25
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
    pl_msg_sys 61  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 62  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 63  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 64  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 65  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 66  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 67  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 68  // Pearl bank 199 line 117
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
