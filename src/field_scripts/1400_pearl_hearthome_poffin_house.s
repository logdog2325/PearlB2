// MAP_HEARTHOME_POFFIN_HOUSE: Pearl script file 113, text bank 119. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive; 76: Pearl 9400, 101: Pearl 10160
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P113_S1
    ScriptEntry P113_S2
    ScriptEntry P113_S3
    ScriptEntry P113_S4
    ScriptEntry P113_S5
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
    ScriptEntry PearlProxy_9400
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10160
    ScriptEntriesEnd

P113_S5:
P113_0016:
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 11, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_CallIf 1, P113_004B
    pl_End

P113_S4:
P113_002B:
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 11, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 5, P113_0051
    pl_CheckFlag PFLAG_0235
    pl_CallIf 0, P113_004B
    pl_End

P113_004B:
    pl_SetFlag PFLAG_0235
    pl_Return

P113_0051:
    pl_CheckFlag PFLAG_0235
    pl_GoToIf 1, P113_0062
    pl_ClearFlag PFLAG_0235
    pl_End

P113_0062:
    pl_ClearFlag PFLAG_0235
    pl_AddObject 4
    pl_End

P113_S1:
P113_006C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P113_S2:
P113_007F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P113_S3:
P113_0092:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlProxy_9400:                  // Pearl global script 9400 (run by this zone's events)
    VMCall T391_1_S1
    VMHalt

PearlProxy_10160:                  // Pearl global script 10160 (run by this zone's events)
    VMCall T1042_11_S11
    VMHalt

// ---- Pearl global script 391:1 (a subroutine here)
T391_1_S1:
T391_1_0008:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3  // Pearl bank 381 line 0
    pl_GoTo T391_1_001B

T391_1_001B:
    pl_msg_talk 4  // Pearl bank 381 line 1
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 5, 65535, 0  // Pearl AddMenuEntryImm 9, 0
    ListMenuAdd 6, 65535, 1  // Pearl AddMenuEntryImm 10, 1
    ListMenuAdd 7, 65535, 2  // Pearl AddMenuEntryImm 11, 2
    ListMenuAdd 8, 65535, 3  // Pearl AddMenuEntryImm 12, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T391_1_00D0
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T391_1_0121
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T391_1_0078
    pl_GoTo T391_1_006D

T391_1_006D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 9  // Pearl bank 381 line 33
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T391_1_0078:
    pl_msg_talk 10  // Pearl bank 381 line 32
    pl_WaitButton
    pl_GoTo T391_1_001B

T391_1_0085:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_ReleaseAll
    pl_Return

T391_1_0097:
    pl_ReturnToField
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_Return

T391_1_00AF:
    pl_msg_talk 11  // Pearl bank 381 line 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T391_1_00BA:
    pl_msg_talk 12  // Pearl bank 381 line 6
    pl_GoTo T391_1_006D

T391_1_00C5:
    pl_msg_talk 13  // Pearl bank 381 line 7
    pl_GoTo T391_1_006D

T391_1_00D0:
    pl_CheckItem 449, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T391_1_00AF
    pl_stub CheckCanCookPoffin  // Pearl 0x1D8 Unk01D8 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T391_1_00BA
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T391_1_00C5
    pl_WaitTime 30, PVAR_800C
    pl_Call T391_1_0085
    pl_stub OpenPoffinCooking  // Pearl 0x1D7 Unk01D7 0: not translated yet
    pl_Call T391_1_0097
    pl_GoTo T391_1_006D

T391_1_0121:
    pl_CheckItem 449, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T391_1_00AF
    pl_stub CheckCanCookPoffin  // Pearl 0x1D8 Unk01D8 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T391_1_00BA
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, T391_1_00C5
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T391_1_0173
    pl_GoTo T391_1_006D

T391_1_0173:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 14  // Pearl bank 381 line 13
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 30, 1, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 15, 65535, 0  // Pearl AddMenuEntryImm 13, 0
    ListMenuAdd 16, 65535, 1  // Pearl AddMenuEntryImm 14, 1
    ListMenuAdd 17, 65535, 2  // Pearl AddMenuEntryImm 5, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T391_1_01B7
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T391_1_020D
    pl_GoTo T391_1_006D

T391_1_01B7:
    pl_msg_talk 18  // Pearl bank 381 line 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T391_1_0173
    pl_CloseMessage
    pl_stub StartBattleClient  // Pearl 0x0F2 Unk00F2 6, 0, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T391_1_01F9
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T391_1_0203
    pl_GoTo T391_1_0263

T391_1_01F9:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo T391_1_0173

T391_1_0203:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo T391_1_0173

T391_1_020D:
    pl_msg_talk 18  // Pearl bank 381 line 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T391_1_0173
    pl_CloseMessage
    pl_stub StartBattleServer  // Pearl 0x0F3 Unk00F3 6, 0, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T391_1_024F
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T391_1_0259
    pl_GoTo T391_1_0263

T391_1_024F:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo T391_1_0173

T391_1_0259:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo T391_1_0173

T391_1_0263:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_stub OpenPoffinCooking  // Pearl 0x1D7 Unk01D7 1: not translated yet
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_Call T391_1_0097
    pl_GoTo T391_1_006D

// ---- Pearl global script 1042:11 (a subroutine here)
T1042_11_S11:
T1042_11_00AE:
    pl_SetVarFromValue PVAR_8000, 11
    pl_GoTo T1042_11_00D2

T1042_11_00D2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 32768, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_11_0214
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 19  // Pearl bank 562 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_11_0107
    pl_GoTo T1042_11_021F

T1042_11_0107:
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 0, 32768, 32772, 32773: not translated yet
    pl_stub MessageFromBank  // PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8000, 10
    pl_GoToIf 1, T1042_11_0165
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32772: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_11_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_11_0214

T1042_11_0165:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextListMenu 1, 1, 0, 1, PVAR_8004
    ListMenuAdd 20, 65535, 255  // Pearl AddListMenuEntry 16, 255
    ListMenuAdd 21, 65535, 255  // Pearl AddListMenuEntry 17, 255
    ListMenuAdd 22, 65535, 255  // Pearl AddListMenuEntry 18, 255
    ListMenuAdd 23, 65535, 255  // Pearl AddListMenuEntry 19, 255
    ListMenuAdd 24, 65535, 255  // Pearl AddListMenuEntry 20, 255
    ListMenuAdd 25, 65535, 255  // Pearl AddListMenuEntry 21, 255
    ListMenuAdd 26, 65535, 255  // Pearl AddListMenuEntry 22, 255
    ListMenuAdd 27, 65535, 255  // Pearl AddListMenuEntry 23, 255
    ListMenuAdd 28, 65535, 255  // Pearl AddListMenuEntry 24, 255
    ListMenuAdd 29, 65535, 255  // Pearl AddListMenuEntry 25, 255
    ListMenuAdd 30, 65535, 255  // Pearl AddListMenuEntry 26, 255
    ListMenuAdd 31, 65535, 255  // Pearl AddListMenuEntry 27, 255
    ListMenuAdd 32, 65535, 255  // Pearl AddListMenuEntry 28, 255
    ListMenuAdd 33, 65535, 255  // Pearl AddListMenuEntry 29, 255
    ListMenuAdd 34, 65535, 255  // Pearl AddListMenuEntry 30, 255
    ListMenuAdd 35, 65535, 255  // Pearl AddListMenuEntry 31, 255
    ListMenuAdd 36, 65535, 255  // Pearl AddListMenuEntry 32, 255
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 65534
    pl_GoToIf 1, T1042_11_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_11_0214

T1042_11_0214:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 37  // Pearl bank 562 line 2
    pl_WaitButton
    pl_GoTo T1042_11_022A

T1042_11_021F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 38  // Pearl bank 562 line 1
    pl_WaitButton
    pl_GoTo T1042_11_022A

T1042_11_022A:
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:7 (a subroutine here)
C205_7_S7:
C205_7_0470:
    pl_Call C205_7_0480
    pl_SetVarFromVar PVAR_4000, PVAR_800C
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_7_0480:
    pl_stub CheckSaveType  // Pearl 0x12C CheckSaveStatus 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_7_04D4
    pl_stub OpenSaveInfo  // Pearl 0x2C1 ShowSaveStats : not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 13
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_stub CheckSaveType  // Pearl 0x12C CheckSaveStatus 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_04F5
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, C205_7_04E1
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, C205_7_04FE
    VMReturn  // End: the sub-script ends

C205_7_04D4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 40  // Pearl bank 199 line 20
    pl_WaitABPress
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_04E1:
    pl_msg_sys 41  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E

C205_7_04F5:
    pl_msg_sys 42  // Pearl bank 199 line 21
    pl_GoTo C205_7_051B

C205_7_04FE:
    pl_msg_sys 41  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_msg_sys 43  // Pearl bank 199 line 15
    pl_GoTo C205_7_051B

C205_7_051B:
    pl_stub 258  // Pearl 0x258 Unk0258 : not translated yet
    pl_WaitTime 2, PVAR_800C
    pl_Call C205_7_0531
    pl_stub 259  // Pearl 0x259 Unk0259 : not translated yet
    pl_GoTo C205_7_053B

C205_7_0531:
// ShowSavingIcon: nothing in Black 2
    SaveDataWrite PVAR_800C
// HideSavingIcon: nothing in Black 2
    pl_Return

C205_7_053B:
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_7_0568
    pl_BufferPlayerName 0
    pl_msg_sys 44  // Pearl bank 199 line 16
    pl_PlaySE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    pl_WaitSE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    VMSleep 30  // WaitABPressTime
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_Return

C205_7_055E:
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_0568:
    pl_msg_sys 45  // Pearl bank 199 line 18
    pl_WaitABPress
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
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
