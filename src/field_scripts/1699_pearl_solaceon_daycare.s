// MAP_SOLACEON_DAYCARE: Pearl script file 1007, text bank 522. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive; 78: Pearl 9501
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1007_S1
    ScriptEntry P1007_S2
    ScriptEntry P1007_S3
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
    ScriptEntry PearlProxy_9501
    ScriptEntriesEnd

P1007_S1:
P1007_000E:
    pl_CheckFlag PFLAG_00FE
    pl_CallIf 1, P1007_001B
    pl_End

P1007_001B:
    pl_ClearFlag PFLAG_01EF
    pl_Return

P1007_S2:
P1007_0021:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckPoketchAppRegistered 8, PVAR_800C  // Day-Care Checker
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1007_0051
    pl_msg_talk 0
    pl_SetVarFromValue PVAR_8004, 8
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1007_0051:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1007_S3:
P1007_005C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlProxy_9501:                  // Pearl global script 9501 (run by this zone's events)
    VMCall T464_2_S2
    VMHalt

// ---- Pearl global script 205:10 (a subroutine here)
C205_10_S10:
C205_10_069C:
    pl_Call C205_10_06A6
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_10_06A6:
    pl_BufferPlayerName 0
// BufferPoketchAppName 1, PVAR_8004: the lines naming the app have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_POCKETCH
    MsgWinCloseAll  // another speaker: close the first window
    pl_CompareVarToValue PVAR_8004, 8
    pl_GoToIf 1, C205_10_06B2_App8
    pl_msg_sys 3  // Pearl bank 199 line 24: another one (no caller here sets it)
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App8:
    pl_msg_sys 4  // naming Day-Care Checker
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_AppDone:
    pl_WaitFanfare
    pl_msg_sys 5  // Pearl bank 199 line 26
    pl_RegisterPoketchApp PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, C205_10_0805
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, C205_10_080A
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, C205_10_080F
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, C205_10_0814
    pl_CompareVarToValue PVAR_8004, 4
    pl_CallIf 1, C205_10_0819
    pl_CompareVarToValue PVAR_8004, 5
    pl_CallIf 1, C205_10_081E
    pl_CompareVarToValue PVAR_8004, 6
    pl_CallIf 1, C205_10_0823
    pl_CompareVarToValue PVAR_8004, 7
    pl_CallIf 1, C205_10_0828
    pl_CompareVarToValue PVAR_8004, 8
    pl_CallIf 1, C205_10_082D
    pl_CompareVarToValue PVAR_8004, 9
    pl_CallIf 1, C205_10_0832
    pl_CompareVarToValue PVAR_8004, 10
    pl_CallIf 1, C205_10_0837
    pl_CompareVarToValue PVAR_8004, 11
    pl_CallIf 1, C205_10_083C
    pl_CompareVarToValue PVAR_8004, 12
    pl_CallIf 1, C205_10_0841
    pl_CompareVarToValue PVAR_8004, 13
    pl_CallIf 1, C205_10_0846
    pl_CompareVarToValue PVAR_8004, 14
    pl_CallIf 1, C205_10_084B
    pl_CompareVarToValue PVAR_8004, 15
    pl_CallIf 1, C205_10_0850
    pl_CompareVarToValue PVAR_8004, 16
    pl_CallIf 1, C205_10_0855
    pl_CompareVarToValue PVAR_8004, 17
    pl_CallIf 1, C205_10_085A
    pl_CompareVarToValue PVAR_8004, 18
    pl_CallIf 1, C205_10_085F
    pl_CompareVarToValue PVAR_8004, 19
    pl_CallIf 1, C205_10_0864
    pl_CompareVarToValue PVAR_8004, 20
    pl_CallIf 1, C205_10_0869
    pl_CompareVarToValue PVAR_8004, 21
    pl_CallIf 1, C205_10_086E
    pl_CompareVarToValue PVAR_8004, 22
    pl_CallIf 1, C205_10_0873
    pl_CompareVarToValue PVAR_8004, 23
    pl_CallIf 1, C205_10_0878
    pl_CompareVarToValue PVAR_8004, 24
    pl_CallIf 1, C205_10_087D
    pl_Return

C205_10_0805:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6  // Pearl bank 199 line 83
    pl_Return

C205_10_080A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7  // Pearl bank 199 line 84
    pl_Return

C205_10_080F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 8  // Pearl bank 199 line 85
    pl_Return

C205_10_0814:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9  // Pearl bank 199 line 86
    pl_Return

C205_10_0819:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 10  // Pearl bank 199 line 87
    pl_Return

C205_10_081E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 88
    pl_Return

C205_10_0823:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 89
    pl_Return

C205_10_0828:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 13  // Pearl bank 199 line 90
    pl_Return

C205_10_082D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 199 line 91
    pl_Return

C205_10_0832:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15  // Pearl bank 199 line 92
    pl_Return

C205_10_0837:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 93
    pl_Return

C205_10_083C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 17  // Pearl bank 199 line 94
    pl_Return

C205_10_0841:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 18  // Pearl bank 199 line 95
    pl_Return

C205_10_0846:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 96
    pl_Return

C205_10_084B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 97
    pl_Return

C205_10_0850:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 98
    pl_Return

C205_10_0855:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 99
    pl_Return

C205_10_085A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 100
    pl_Return

C205_10_085F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 101
    pl_Return

C205_10_0864:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 102
    pl_Return

C205_10_0869:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 103
    pl_Return

C205_10_086E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 104
    pl_Return

C205_10_0873:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 105
    pl_Return

C205_10_0878:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 106
    pl_Return

C205_10_087D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 107
    pl_Return

// ---- Pearl global script 464:2 (a subroutine here)
T464_2_S2:
T464_2_0124:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
    pl_GetDaycareState PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T464_2_02CF
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T464_2_02F6
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T464_2_048C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 31  // Pearl bank 492 line 15
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_017E
    pl_msg_talk 32  // Pearl bank 492 line 20
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_017E:
    pl_CountPartyNonEggs PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T464_2_02A8
    pl_CountAliveMonsAndBoxMons PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T464_2_02C2
    pl_msg_talk 33  // Pearl bank 492 line 16
    pl_CloseMessage
    MoneyWinClose
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_800C, 0

T464_2_01B9:
    pl_OpenPartyMenuForDaycare PVAR_800C
    pl_GetDayCarePartyMenuResult PVAR_8000, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_01DE
// SetMonSummary PVAR_8000: Black 2's Day Care list shows the summary itself (never reached: GetDayCarePartyMenuResult gives 0)
// GetMonPartySlot PVAR_800C: Black 2's Day Care list shows the summary itself (never reached: GetDayCarePartyMenuResult gives 0)
    pl_GoTo T464_2_01B9

T464_2_01DE:
// RestoreOverworld: Black 2's party select reopened the field itself
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_8000, 255
    pl_GoToIf 1, T464_2_027F
    pl_GetPartyMonSpecies PVAR_8000, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_0272
    pl_CountAliveMonsExcept PVAR_800C, PVAR_8000
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_02B5
    pl_BufferPartyMonNicknameReturnSpecies PVAR_8000, PVAR_8001  // (Pearl's first argument 0 is unused)
    pl_StorePartyMonIntoDaycare PVAR_8000
    pl_SetFlag PFLAG_00FE
    pl_GetDaycareState PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T464_2_024C
    pl_GoTo T464_2_025D

T464_2_024C:
    pl_PlayCry PVAR_8001
    pl_msg_talk 34  // Pearl bank 492 line 17
    pl_WaitCry
    pl_GoTo T464_2_028C

T464_2_025D:
    pl_PlayCry PVAR_8001
    pl_msg_talk 35  // Pearl bank 492 line 36
    pl_WaitButton
    pl_CloseMessage
    pl_WaitCry
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_0272:
    pl_msg_talk 36  // Pearl bank 492 line 35
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_027F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 37  // Pearl bank 492 line 23
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_028C:
    pl_msg_talk 38  // Pearl bank 492 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_017E
    pl_GoTo T464_2_027F

T464_2_02A8:
    pl_msg_talk 39  // Pearl bank 492 line 31
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_02B5:
    pl_msg_talk 40  // Pearl bank 492 line 33
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_02C2:
    pl_msg_talk 41  // Pearl bank 492 line 34
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_02CF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 42  // Pearl bank 492 line 19
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_02DC:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 43  // Pearl bank 492 line 25
    pl_Return

T464_2_02E1:
    pl_BufferDaycareGainedLevelsBySlot PVAR_800C, PVAR_8000
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 5, T464_2_02DC
    pl_Return

T464_2_02F6:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 44  // Pearl bank 492 line 24
    pl_SetVarFromValue PVAR_8000, 0
    pl_Call T464_2_02E1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 38  // Pearl bank 492 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_017E
    pl_msg_talk 45  // Pearl bank 492 line 32
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_0333
    pl_GoTo T464_2_027F

T464_2_0333:
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T464_2_044B
    pl_GetDaycareState PVAR_800C
    pl_SetVarFromValue PVAR_8001, 0
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T464_2_03AB
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8001  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_8001
    pl_BufferDaycareNicknameLevelGender 0, 1, 0
    WorkCmpConst PL_DC_SEX, 1
    VMJumpIf CMP_EQ, T464_2_036D_Sex1
    WorkCmpConst PL_DC_SEX, 2
    VMJumpIf CMP_EQ, T464_2_036D_Sex2
    ListMenuAdd 46, 65535, 0  // Pearl AddMenuEntryImm 134, 0 (no gender)
    VMJump T464_2_036D_SexDone
T464_2_036D_Sex1:
    ListMenuAdd 47, 65535, 0  // (♂)
    VMJump T464_2_036D_SexDone
T464_2_036D_Sex2:
    ListMenuAdd 48, 65535, 0  // (♀)
    VMJump T464_2_036D_SexDone
T464_2_036D_SexDone:
    pl_BufferDaycareNicknameLevelGender 0, 1, 1
    WorkCmpConst PL_DC_SEX, 1
    VMJumpIf CMP_EQ, T464_2_037B_Sex1
    WorkCmpConst PL_DC_SEX, 2
    VMJumpIf CMP_EQ, T464_2_037B_Sex2
    ListMenuAdd 49, 65535, 1  // Pearl AddMenuEntryImm 135, 1 (no gender)
    VMJump T464_2_037B_SexDone
T464_2_037B_Sex1:
    ListMenuAdd 50, 65535, 1  // (♂)
    VMJump T464_2_037B_SexDone
T464_2_037B_Sex2:
    ListMenuAdd 51, 65535, 1  // (♀)
    VMJump T464_2_037B_SexDone
T464_2_037B_SexDone:
    ListMenuAdd 52, 65535, 2  // Pearl AddMenuEntryImm 136, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_8001
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T464_2_03AB
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T464_2_03AB
    pl_GoTo T464_2_027F

T464_2_03AB:
    pl_BufferDaycarePriceBySlot PVAR_8004, PVAR_8001
    pl_msg_talk 53  // Pearl bank 492 line 28
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_03CB
    pl_GoTo T464_2_027F

T464_2_03CB:
    MoneyCheck PVAR_800C, PVAR_8004  // HasEnoughMoneyAddress (an amount in a var)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T464_2_03EB
    pl_msg_talk 54  // Pearl bank 492 line 21
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_03EB:
    pl_ApplyMovement 0, T464_2_0458
    pl_WaitMovement
    pl_MoveMonToPartyFromDaycareSlot PVAR_8002, PVAR_8001
    MoneySub PVAR_8004  // TakeMoneyAddress (an amount in a var)
    MoneyWinUpdate
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_msg_talk 55  // Pearl bank 492 line 29
    pl_PlayCry PVAR_8002
    pl_BufferPlayerName 1
    pl_msg_talk 56  // Pearl bank 492 line 30
    pl_WaitCry
    pl_GetDaycareState PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T464_2_0431
    pl_GoTo T464_2_027F

T464_2_0431:
    pl_msg_talk 57  // Pearl bank 492 line 22
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_0333
    pl_GoTo T464_2_027F

T464_2_044B:
    pl_msg_talk 58  // Pearl bank 492 line 26
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T464_2_048C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 44  // Pearl bank 492 line 24
    pl_SetVarFromValue PVAR_8000, 0
    pl_Call T464_2_02E1
    pl_SetVarFromValue PVAR_8000, 1
    pl_Call T464_2_02E1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 45  // Pearl bank 492 line 32
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T464_2_0333
    pl_msg_talk 37  // Pearl bank 492 line 23
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

    .balign 4, 0
T464_2_0458:
    Move 62, 3  // DELAY_4
    Move 2, 1  // FACE_WEST
    Move 62, 3  // DELAY_4
    Move 3, 1  // FACE_EAST
    Move 62, 3  // DELAY_4
    Move 0, 1  // FACE_NORTH
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    Move 63, 3  // DELAY_8
    Move 1, 1  // FACE_SOUTH
    Move 70, 1  // SET_VISIBLE
    Move 13, 2  // WALK_NORMAL_SOUTH
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
