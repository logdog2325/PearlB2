// MAP_BATTLE_TOWER_LOBBY: Pearl script file 358, text bank 283. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-23: Pearl's; 24: after a Warp, 25: after a Warp, 26: after a Warp, 27: after a Warp, 28: after a Warp; 29: PearlArrive; 50: Pearl 2033, 107: Pearl 2508, 95: Pearl 10151
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P358_S1
    ScriptEntry P358_S2
    ScriptEntry P358_S3
    ScriptEntry P358_S4
    ScriptEntry P358_S5
    ScriptEntry P358_S6
    ScriptEntry P358_S7
    ScriptEntry P358_S8
    ScriptEntry P358_S9
    ScriptEntry P358_S10
    ScriptEntry P358_S11
    ScriptEntry P358_S12
    ScriptEntry P358_S13
    ScriptEntry P358_S14
    ScriptEntry P358_S15
    ScriptEntry P358_S16
    ScriptEntry P358_S17
    ScriptEntry P358_S18
    ScriptEntry P358_S19
    ScriptEntry P358_S20
    ScriptEntry P358_S21
    ScriptEntry P358_S22
    ScriptEntry P358_S23
    ScriptEntry W362_00BD_S
    ScriptEntry W362_00E5_S
    ScriptEntry W363_00F8_S
    ScriptEntry W363_013A_S
    ScriptEntry W364_01EA_S
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
    ScriptEntry PearlProxy_2033
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10151
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_2508
    ScriptEntriesEnd

P358_S22:
P358_005E:
    pl_CompareVarToValue PVAR_40D8, 1
    pl_CallIf 1, P358_00C5
    pl_CompareVarToValue PVAR_40D8, 3
    pl_CallIf 1, P358_00C5
    pl_CompareVarToValue PVAR_40D8, 255
    pl_CallIf 1, P358_00C5
    pl_stub 1E0  // Pearl 0x1E0 Unk01E0 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 5, P358_00B3
    pl_SetFlag PFLAG_0207

P358_009A:
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 2, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 5, P358_00BF
    pl_SetFlag PFLAG_022C
    pl_End

P358_00B3:
    pl_ClearFlag PFLAG_0207
    pl_GoTo P358_009A

P358_00BF:
    pl_ClearFlag PFLAG_022C
    pl_End

P358_00C5:
    pl_ShowPoketch
    pl_Return

P358_S23:
P358_00C9:
    pl_CompareVarToValue PVAR_40D8, 1
    pl_GoToIf 5, P358_010E
    pl_stub 1E0  // Pearl 0x1E0 Unk01E0 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 5, P358_0110
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P358_0110
    pl_CompareVarToValue PVAR_4000, 2
    pl_GoToIf 1, P358_0110
    pl_CompareVarToValue PVAR_4000, 3
    pl_GoToIf 1, P358_0110

P358_010E:
    pl_End

P358_0110:
// SetEventDirection 3, 2 in a map script: Black 2 moves no actor there (left out)
    pl_End

P358_0120:
    pl_stub FreeBattleTower  // Pearl 0x1DC Unk01DC : not translated yet
    pl_Return

P358_0124:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 3, 0, 0: not translated yet
    pl_Return

P358_012E:
    pl_SetVarFromValue PVAR_40D8, 255
    pl_SetVarFromValue PVAR_40DB, 1
    pl_SetVarFromValue PVAR_40DC, 1
    pl_SetVarFromValue PVAR_40D9, 1
    pl_Return

P358_0148:
    pl_SetVarFromValue PVAR_40D8, 255
    pl_SetVarFromValue PVAR_40DB, 3
    pl_SetVarFromValue PVAR_40DD, 1
    pl_SetVarFromValue PVAR_40DE, 1
    pl_SetVarFromValue PVAR_40DF, 1
    pl_Return

P358_0168:
    pl_SetVarFromValue PVAR_40D8, 255
    pl_SetVarFromValue PVAR_40DB, 1
    pl_SetVarFromValue PVAR_40DC, 1
    pl_SetVarFromValue PVAR_40D9, 2
    pl_Return

P358_0182:
    pl_SetVarFromValue PVAR_40D8, 255
    pl_SetVarFromValue PVAR_40DB, 2
    pl_SetVarFromValue PVAR_40DD, 1
    pl_SetVarFromValue PVAR_40DE, 2
    pl_SetVarFromValue PVAR_40DF, 0
    pl_Return

P358_01A2:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 6, 0, 0: not translated yet
    pl_Call P358_0124
    pl_Return

P358_01B2:
    pl_SetVarFromValue PVAR_40D8, 0
    pl_SetVarFromValue PVAR_40DB, 0
    pl_SetVarFromValue PVAR_40DC, 0
    pl_SetVarFromValue PVAR_40DD, 0
    pl_SetVarFromValue PVAR_40D9, 0
    pl_SetVarFromValue PVAR_40DE, 0
    pl_SetVarFromValue PVAR_40DF, 0
    pl_Return

P358_01DE:
    pl_Call P358_01B2
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 6, 0, 0: not translated yet
    pl_Return

P358_01EE:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 9, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_023B
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 10, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8000, PVAR_800C
    pl_BufferNumber 0, PVAR_8000
    pl_msg_sys 65
    pl_GoTo P358_023B

P358_S6:
P358_0221:
    pl_LockAll
    pl_msg_sys 19
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 14, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P358_01EE

P358_023B:
    pl_Call P358_01A2

P358_0241:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2
    pl_WaitButton

P358_0246:
    pl_CloseMessage
    pl_Call P358_0120
    pl_Call P358_01B2
    pl_ReleaseAll
    pl_End

P358_0258:
    ListMenu_AnchorTopRight 31, 11, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 11, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 117, 65535, 0  // Pearl AddMenuEntryImm 141, 0
    ListMenuAdd 118, 65535, 1  // Pearl AddMenuEntryImm 142, 1
    ListMenuAdd 119, 65535, 2  // Pearl AddMenuEntryImm 143, 2
    ListMenuShow
    pl_Return

P358_0273:
    ListMenu_AnchorTopRight 31, 9, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 9, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 117, 65535, 0  // Pearl AddMenuEntryImm 141, 0
    ListMenuAdd 120, 65535, 1  // Pearl AddMenuEntryImm 151, 1
    ListMenuAdd 118, 65535, 2  // Pearl AddMenuEntryImm 142, 2
    ListMenuAdd 119, 65535, 3  // Pearl AddMenuEntryImm 143, 3
    ListMenuShow
    pl_Return

P358_0292:
    ListMenu_AnchorTopRight 31, 7, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 7, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 117, 65535, 0  // Pearl AddMenuEntryImm 141, 0
    ListMenuAdd 120, 65535, 1  // Pearl AddMenuEntryImm 151, 1
    ListMenuAdd 121, 65535, 2  // Pearl AddMenuEntryImm 152, 2
    ListMenuAdd 118, 65535, 3  // Pearl AddMenuEntryImm 142, 3
    ListMenuAdd 119, 65535, 4  // Pearl AddMenuEntryImm 143, 4
    ListMenuShow
    pl_Return

P358_02B5:
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_Return

P358_02C1:
// ShowSavingIcon: nothing in Black 2
    SaveDataWrite PVAR_800C
// HideSavingIcon: nothing in Black 2
    pl_PlaySE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    pl_WaitSE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    pl_Return

P358_02D3:
    pl_stub ClearReceivedTempDataAllPlayers  // Pearl 0x136 Unk0136 : not translated yet
    pl_stub 135  // Pearl 0x135 Unk0135 8: not translated yet
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_Return

P358_02DD:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub Warp  // to Pearl map 327: no Black 2 zone (not installed)
    pl_ReleaseAll
    pl_End

P358_0305:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 30, 0, 0: not translated yet
    pl_ReturnToField
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 31, 0, 32780: not translated yet
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_Return

P358_0333:
    pl_msg_talk 9
    pl_GoTo P358_0241

P358_033E:
    pl_msg_talk 10
    pl_GoTo P358_0241

P358_0349:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 0B3  // Pearl 0x0B3 Unk00B3 16384: not translated yet
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 16, 16385, 16384: not translated yet
    pl_SetVarFromVar PVAR_4001, PVAR_4000
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_SetVarFromVar PVAR_800C, PVAR_4001
    pl_Return

P358_037D:
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4001, 1
    pl_Call P358_0349
    pl_Return

P358_038D:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 11, 1, 0: not translated yet
    pl_Call P358_01A2
    pl_msg_sys 56
    pl_Call P358_02C1
    pl_msg_sys 57
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_0241
    pl_Call P358_037D
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P358_0241
    pl_msg_sys 60
    pl_GoTo P358_0241

P358_S1:
P358_03D6:
    pl_LockAll
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_stub SetBattleTowerNull  // Pearl 0x1DA Unk01DA : not translated yet
    pl_msg_talk 0

P358_03E1:
    pl_msg_talk 1
    pl_Call P358_0258
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P358_042A
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_041F
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_0241
    pl_GoTo P358_0241

P358_041F:
    pl_msg_talk 3
    pl_GoTo P358_03E1

P358_042A:
    pl_msg_talk 4
    ListMenu_AnchorTopRight 31, 11, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 11, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 122, 65535, 0  // Pearl AddMenuEntryImm 6, 0
    ListMenuAdd 123, 65535, 1  // Pearl AddMenuEntryImm 7, 1
    ListMenuAdd 124, 65535, 2  // Pearl AddMenuEntryImm 94, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P358_047B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_04A6
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_0241
    pl_GoTo P358_0241

P358_047B:
    pl_stub InitBattleTower  // Pearl 0x1DB Unk01DB 0, 0: not translated yet

P358_0481:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 1, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_04D1
    pl_stub MessageSeenBanlistSpecies  // Pearl 0x1FF Unk01FF 88, 3, 0, 0: not translated yet
    pl_GoTo P358_0246

P358_04A6:
    pl_stub InitBattleTower  // Pearl 0x1DB Unk01DB 0, 1: not translated yet
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 1, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_04D1
    pl_stub MessageSeenBanlistSpecies  // Pearl 0x1FF Unk01FF 88, 4, 0, 0: not translated yet
    pl_GoTo P358_0246

P358_04D1:
    pl_msg_talk 8
    pl_Call P358_0305
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0241
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 32, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_0333
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_033E
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 43, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P358_05AE
    pl_Call P358_012E
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 5, 0, 0: not translated yet
    pl_HealParty
    pl_Call P358_02B5
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_023B
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 57, 0, 32780: not translated yet
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 52, 0, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 11
    pl_WaitABPress

P358_055C:
    pl_CloseMessage
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 43, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P358_109A
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, P358_109A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_10B4
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P358_10CE
    pl_GoTo P358_1080

P358_05A6:
    pl_GoTo P358_02DD

P358_05AE:
    pl_Call P358_02B5
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_023B
    pl_Call P358_012E
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 5, 0, 0: not translated yet
    pl_HealParty
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4001, 0
    pl_Call P358_0349
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P358_023B

P358_05EC:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 47
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_055C
    pl_msg_talk 48
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_05EC
    pl_SetVarFromValue PVAR_40D8, 2
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 39, 0, 0: not translated yet
    pl_stub FreeBattleTower  // Pearl 0x1DC Unk01DC : not translated yet
    pl_msg_talk 56
    pl_Call P358_02C1
    VMSleep 30  // WaitABPressTime
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 2, 0, 0: not translated yet
    pl_ReleaseAll
    pl_End

P358_S3:
P358_064B:
    pl_LockAll
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_stub SetBattleTowerNull  // Pearl 0x1DA Unk01DA : not translated yet
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 12, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_0797
    pl_msg_talk 36

P358_066B:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 15, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_06CB
    pl_msg_talk 37
    pl_Call P358_0273
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P358_077B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_072E
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_0723
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P358_0241
    pl_GoTo P358_0241

P358_06CB:
    pl_msg_talk 37
    pl_Call P358_0292
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P358_077B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_072E
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_0789
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P358_0723
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P358_0241
    pl_GoTo P358_0241

P358_0723:
    pl_msg_talk 38
    pl_GoTo P358_066B

P358_072E:
    pl_Call P358_02B5
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0241
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4001, 2
    pl_Call P358_0349
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P358_0241
    pl_stub 1E3  // Pearl 0x1E3 Unk01E3 32772, 32773: not translated yet
    pl_BufferNumber 0, PVAR_8004
    pl_stub BufferVarPaddingDigits  // Pearl 0x280 Unk0280 1, 32773, 2, 3: not translated yet
    pl_msg_talk 52
    pl_WaitABPress
    pl_GoTo P358_0246

P358_077B:
    pl_stub InitBattleTower  // Pearl 0x1DB Unk01DB 0, 4: not translated yet
    pl_GoTo P358_0481

P358_0789:
    pl_stub InitBattleTower  // Pearl 0x1DB Unk01DB 0, 5: not translated yet
    pl_GoTo P358_0481

P358_0797:
    pl_msg_talk 61
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_07DC
    pl_Call P358_02B5
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0241
    pl_Call P358_037D
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P358_0241
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 60
    pl_GoTo P358_0241

P358_07DC:
    pl_GoTo P358_066B

P358_S2:
P358_07E4:
    pl_LockAll
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_stub SetBattleTowerNull  // Pearl 0x1DA Unk01DA : not translated yet
    pl_msg_talk 20

P358_07EF:
    pl_msg_talk 21
    pl_Call P358_0258
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P358_0838
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_082D
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_0241
    pl_GoTo P358_0241

P358_082D:
    pl_msg_talk 23
    pl_GoTo P358_07EF

P358_0838:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 1, 2, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_085D
    pl_stub MessageSeenBanlistSpecies  // Pearl 0x1FF Unk01FF 88, 2, 0, 0: not translated yet
    pl_GoTo P358_0246

P358_085D:
    pl_msg_talk 26
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0885
    pl_stub InitBattleTower  // Pearl 0x1DB Unk01DB 0, 2: not translated yet
    pl_SetVarFromValue PVAR_4001, 0
    pl_GoTo P358_0899

P358_0885:
    pl_stub InitBattleTower  // Pearl 0x1DB Unk01DB 0, 3: not translated yet
    pl_SetVarFromValue PVAR_4001, 1
    pl_GoTo P358_0899

P358_0899:
    pl_msg_talk 8
    pl_Call P358_0305
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0241
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 32, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_0333
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_033E
    pl_CompareVarToValue PVAR_4001, 1
    pl_GoToIf 1, P358_0928
    pl_Call P358_0148
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 5, 0, 0: not translated yet
    pl_HealParty
    pl_Call P358_02B5
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_023B
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 57, 0, 32780: not translated yet
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 52, 0, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 35
    pl_GoTo P358_055C

P358_0920:
    pl_GoTo P358_02DD

P358_0928:
    pl_Call P358_02B5
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_023B

P358_093B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 27
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 30, 1, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 125, 65535, 0  // Pearl AddMenuEntryImm 13, 0
    ListMenuAdd 126, 65535, 1  // Pearl AddMenuEntryImm 14, 1
    ListMenuAdd 127, 65535, 2  // Pearl AddMenuEntryImm 5, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P358_097F
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_09D3
    pl_GoTo P358_023B

P358_097F:
    pl_msg_talk 115
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_093B
    pl_CloseMessage
    pl_stub StartBattleClient  // Pearl 0x0F2 Unk00F2 16, 0, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_09C1
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P358_09C9
    pl_GoTo P358_0A27

P358_09C1:
    pl_GoTo P358_093B

P358_09C9:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo P358_093B

P358_09D3:
    pl_msg_talk 115
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_093B
    pl_CloseMessage
    pl_stub StartBattleServer  // Pearl 0x0F3 Unk00F3 16, 0, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_0A15
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P358_0A1D
    pl_GoTo P358_0A27

P358_0A15:
    pl_GoTo P358_093B

P358_0A1D:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo P358_093B

P358_0A27:
    pl_stub ClearReceivedTempDataAllPlayers  // Pearl 0x136 Unk0136 : not translated yet
    pl_stub 135  // Pearl 0x135 Unk0135 1: not translated yet
    pl_stub 1E1  // Pearl 0x1E1 Unk01E1 0, 0: not translated yet
    pl_stub 1E2  // Pearl 0x1E2 Unk01E2 0, 16384: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_4000
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_0AC7
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_0AE5
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P358_0B03
    pl_stub ClearReceivedTempDataAllPlayers  // Pearl 0x136 Unk0136 : not translated yet
    pl_stub 135  // Pearl 0x135 Unk0135 2: not translated yet
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 57, 0, 32772: not translated yet
    pl_stub GetCurNetID  // Pearl 0x207 Unk0207 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0B2E
    pl_stub 1E2  // Pearl 0x1E2 Unk01E2 1, 16384: not translated yet

P358_0A8B:
    pl_Call P358_0148
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 5, 0, 0: not translated yet
    pl_HealParty
    pl_msg_talk 69
    pl_Call P358_02C1
    pl_msg_talk 32
    pl_WaitTime 30, PVAR_800C
    pl_stub ClearReceivedTempDataAllPlayers  // Pearl 0x136 Unk0136 : not translated yet
    pl_stub 135  // Pearl 0x135 Unk0135 3: not translated yet
    pl_GoTo P358_055C

P358_0AB9:
    pl_SetVarFromValue PVAR_40DB, 2
    pl_GoTo P358_02DD

P358_0AC7:
    pl_Call P358_02D3
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 53, 0, 32780: not translated yet
    pl_BufferPartyMonSpecies 0, PVAR_800C
    pl_msg_talk 33
    pl_GoTo P358_023B

P358_0AE5:
    pl_Call P358_02D3
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 53, 1, 32780: not translated yet
    pl_BufferPartyMonSpecies 0, PVAR_800C
    pl_msg_talk 33
    pl_GoTo P358_023B

P358_0B03:
    pl_Call P358_02D3
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 53, 0, 32780: not translated yet
    pl_BufferPartyMonSpecies 0, PVAR_800C
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 53, 1, 32780: not translated yet
    pl_BufferPartyMonSpecies 1, PVAR_800C
    pl_msg_talk 34
    pl_GoTo P358_023B

P358_0B2E:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 52, 0, 0: not translated yet
    pl_stub 1E1  // Pearl 0x1E1 Unk01E1 1, 0: not translated yet
    pl_GoTo P358_0A8B

P358_S8:
P358_0B44:
    pl_LockAll
    pl_Call P358_01DE
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 100, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_0241
    pl_msg_sys 56
    pl_Call P358_02C1
    pl_GoTo P358_023B

P358_S4:
P358_0B72:
    pl_LockAll
    pl_Call P358_01DE
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 100, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_0241
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 35, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_0CA4
    pl_msg_sys 53
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 43, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_4000, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_4000
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, P358_0BEA
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P358_0C45
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 49, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P358_0C0A

P358_0BEA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 56
    pl_Call P358_02C1
    pl_CloseMessage
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P358_0C15
    pl_GoTo P358_023B

P358_0C0A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 73
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_WaitFanfare
    pl_Return

P358_0C15:
    pl_stub 1DF  // Pearl 0x1DF Unk01DF 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_023B
    pl_msg_sys 116
    pl_CloseMessage
    pl_SetVarFromVar PVAR_4002, PVAR_800C
    pl_SetVarFromValue PVAR_4001, 1
    pl_Call P358_10E8
    pl_GoTo P358_0EFE

P358_0C45:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 9, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P358_0C62
    pl_GoTo P358_038D

P358_0C62:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 10, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8000, PVAR_800C
    pl_BufferNumber 0, PVAR_8000
    pl_msg_sys 65
    pl_GoTo P358_038D

P358_0C80:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 46, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPlayerName 0
    pl_BufferNumber 1, PVAR_8004
    pl_msg_sys 58
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_Return

P358_0CA4:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 43, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_4000, PVAR_800C
    pl_CompareVarToValue PVAR_4000, 5
    pl_GoToIf 1, P358_0D07
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P358_0D12
    pl_CompareVarToValue PVAR_4000, 4
    pl_GoToIf 1, P358_0DD8
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 49, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P358_0DA5
    pl_Call P358_0C80

P358_0CF4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14
    pl_Call P358_02C1
    pl_CloseMessage
    pl_GoTo P358_023B

P358_0D07:
    pl_msg_sys 54
    pl_GoTo P358_0CF4

P358_0D12:
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 45, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0D66
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 46, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_4000, PVAR_800C
    pl_BufferPlayerName 0
    pl_BufferNumber 1, PVAR_4000
    pl_msg_sys 13
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 48, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0D6C
    pl_msg_sys 84
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_WaitFanfare
    pl_GoTo P358_0D6C

P358_0D66:
    pl_Call P358_0C80

P358_0D6C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14
    pl_Call P358_02C1
    pl_stub 1DF  // Pearl 0x1DF Unk01DF 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_023B
    pl_msg_sys 116
    pl_CloseMessage
    pl_SetVarFromVar PVAR_4002, PVAR_800C
    pl_SetVarFromValue PVAR_4001, 1
    pl_Call P358_10E8
    pl_GoTo P358_0EFE

P358_0DA5:
    pl_msg_sys 12
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 46, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPlayerName 0
    pl_BufferNumber 1, PVAR_8004
    pl_msg_sys 58
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_msg_sys 73
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_WaitFanfare
    pl_GoTo P358_0CF4

P358_0DD8:
    pl_msg_sys 12
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 46, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPlayerName 0
    pl_BufferNumber 1, PVAR_8004
    pl_msg_sys 58
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 54, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_038D
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 10, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_4000, PVAR_800C
    pl_BufferPlayerName 0
    pl_BufferNumber 1, PVAR_4000
    pl_msg_sys 55
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 49, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_038D
    pl_BufferNumber 0, PVAR_4000
    pl_msg_sys 70
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_WaitFanfare
    pl_GoTo P358_038D

P358_S5:
P358_0E53:
    pl_LockAll
    pl_SetVarFromValue PVAR_40D8, 0
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 4, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_0221
    pl_msg_sys 16
    pl_stub InitBattleTower  // Pearl 0x1DB Unk01DB 1, 65535: not translated yet
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 43, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P358_0EAF
    pl_Call P358_0168
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 5, 0, 0: not translated yet
    pl_Call P358_02C1
    pl_msg_sys 11
    pl_WaitABPress
    pl_GoTo P358_055C

P358_0EAF:
    pl_Call P358_0182
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 5, 0, 0: not translated yet
    pl_Call P358_02C1
    pl_stub CallBattleTowerFunction  // Pearl 0x1DD Unk01DD 51, 0, 32780: not translated yet
    pl_SetVarFromVar PVAR_4009, PVAR_800C
    pl_msg_sys 32
    pl_WaitABPress
    pl_GoTo P358_055C

P358_0EDE:
    pl_Call P358_01A2
    pl_GoTo P358_0246

P358_S7:
P358_0EEC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetVarFromValue PVAR_4001, 0
    pl_stub 1DF  // Pearl 0x1DF Unk01DF 16386: not translated yet

P358_0EFE:
    pl_SetVarFromVar PVAR_8008, PVAR_4002
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P358_0F5B
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P358_0F6E
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P358_0F81
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P358_0F50
    pl_msg_sys 15

P358_0F3B:
    pl_WaitABPress
    pl_CompareVarToValue PVAR_4001, 1
    pl_GoToIf 1, P358_0EDE
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_0F50:
    pl_msg_sys 86
    pl_GoTo P358_0F3B

P358_0F5B:
    pl_BufferNumber 0, 20
    pl_SetVarFromValue PVAR_8004, 85
    pl_GoTo P358_0F94

P358_0F6E:
    pl_BufferNumber 0, 50
    pl_SetVarFromValue PVAR_8004, 86
    pl_GoTo P358_0F94

P358_0F81:
    pl_BufferNumber 0, 100
    pl_SetVarFromValue PVAR_8004, 87
    pl_GoTo P358_0F94

P358_0F94:
    pl_msg_sys 85
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15
    pl_GoTo P358_0F3B

P358_S9:
P358_0FAC:
    pl_End

P358_0FAE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenBattleTowerRecordsApp  // Pearl 0x1D9 Unk01D9 32768, 32769: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_Return

P358_S10:
P358_0FD8:
    pl_SetVarFromValue PVAR_8000, 0
    pl_SetVarFromValue PVAR_8001, 0
    pl_Call P358_0FAE
    pl_End

P358_S11:
P358_0FEC:
    pl_SetVarFromValue PVAR_8000, 0
    pl_SetVarFromValue PVAR_8001, 1
    pl_Call P358_0FAE
    pl_End

P358_S12:
P358_1000:
    pl_SetVarFromValue PVAR_8000, 0
    pl_SetVarFromValue PVAR_8001, 2
    pl_Call P358_0FAE
    pl_End

P358_S13:
P358_1014:
    pl_stub 1E4  // Pearl 0x1E4 Unk01E4 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P358_1039
    pl_SetVarFromValue PVAR_8000, 1
    pl_SetVarFromValue PVAR_8001, 0
    pl_Call P358_0FAE
    pl_End

P358_1039:
    pl_msg_sys 114
    pl_CloseMessage
    pl_End

P358_1040:
    pl_ApplyMovement PVAR_4002, P358_10F4
    pl_ApplyMovement PL_PLAYER, P358_110C
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4003
    pl_LoadDoorAnimation 77, PL_TMP, 2  // the door at cell (0,0) tile (PVAR_4003,2)
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_ApplyMovement PVAR_4002, P358_1100
    pl_ApplyMovement PL_PLAYER, P358_1118
    pl_WaitMovement
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

P358_1080:
    pl_SetVarFromValue PVAR_4002, 0
    pl_SetVarFromValue PVAR_4003, 11
    pl_Call P358_1040
    pl_GoTo P358_05A6

P358_109A:
    pl_SetVarFromValue PVAR_4002, 2
    pl_SetVarFromValue PVAR_4003, 15
    pl_Call P358_1040
    pl_GoTo P358_05A6

P358_10B4:
    pl_SetVarFromValue PVAR_4002, 1
    pl_SetVarFromValue PVAR_4003, 7
    pl_Call P358_1040
    pl_GoTo P358_0920

P358_10CE:
    pl_SetVarFromValue PVAR_4002, 1
    pl_SetVarFromValue PVAR_4003, 7
    pl_Call P358_1040
    pl_GoTo P358_0AB9

P358_10E8:
    pl_ApplyMovement PL_PLAYER, P358_1124
    pl_WaitMovement
    pl_Return

P358_S14:
P358_112C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 74
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_S15:
P358_113F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 75
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_S16:
P358_1152:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 76
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_S17:
P358_1165:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 77
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_S18:
P358_1178:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 78
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_S19:
P358_118B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 79
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_S20:
P358_119E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 80
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P358_S21:
P358_11B1:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 25
    pl_msg_talk 81
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P358_10F4:
    Move 62, 1  // DELAY_4
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P358_1100:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P358_110C:
    Move 62, 1  // DELAY_4
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P358_1118:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P358_1124:
    Move 3, 1  // FACE_EAST
    MoveEnd

// ---- continuation 24: after the Warp at 362:00BD (MAP_BATTLE_TOWER_ARENA_MULTI)
W362_00BD_S:
W362_00BD_00C9:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

// ---- continuation 25: after the Warp at 362:00E5 (MAP_BATTLE_TOWER_ARENA_MULTI)
W362_00E5_S:
W362_00E5_00F1:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

// ---- continuation 26: after the Warp at 363:00F8 (MAP_BATTLE_TOWER_ARENA_WIFI)
W363_00F8_S:
W363_00F8_0104:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

// ---- continuation 27: after the Warp at 363:013A (MAP_BATTLE_TOWER_ARENA_WIFI)
W363_013A_S:
W363_013A_0146:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

// ---- continuation 28: after the Warp at 364:01EA (MAP_BATTLE_TOWER_PARTNER_ROOM)
W364_01EA_S:
W364_01EA_01F6:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlProxy_2033:                  // Pearl global script 2033 (run by this zone's events)
    VMCall T205_34_S34
    VMHalt

PearlProxy_2508:                  // Pearl global script 2508 (run by this zone's events)
    VMCall C1_9_S9
    VMHalt

PearlProxy_10151:                  // Pearl global script 10151 (run by this zone's events)
    VMCall T1042_2_S2
    VMHalt

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
    pl_msg_sys 128  // Pearl bank 199 line 13
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
    pl_msg_sys 129  // Pearl bank 199 line 20
    pl_WaitABPress
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_04E1:
    pl_msg_sys 130  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E

C205_7_04F5:
    pl_msg_sys 131  // Pearl bank 199 line 21
    pl_GoTo C205_7_051B

C205_7_04FE:
    pl_msg_sys 130  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_msg_sys 132  // Pearl bank 199 line 15
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
    pl_msg_sys 133  // Pearl bank 199 line 16
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
    pl_msg_sys 134  // Pearl bank 199 line 18
    pl_WaitABPress
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_Return

// ---- Pearl global script 205:47 (a subroutine here)
C205_47_S47:
C205_47_0893:
    pl_Call C205_47_08A0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 135  // Pearl bank 199 line 128
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_47_08A0:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_stub SendGoodToPC  // Pearl 0x083 GiveSecretBaseDecoration 32772, 32773, 32780: not translated yet
    pl_stub GetDecorationNameWithArticle  // Pearl 0x2C6 GetDecorationNameWithArticle 0, 32772: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 136  // Pearl bank 199 line 108
    pl_stub BufferUndergroundGoodsName  // Pearl 0x0DF GetDecorationName 0, 32772: not translated yet
    pl_WaitFanfare
    pl_Return

// ---- Pearl global script 205:34 (a subroutine here)
T205_34_S34:
T205_34_1305:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub 0A5  // Pearl 0x0A5 Unk00A5 : not translated yet
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 1:9 (a subroutine here)
C1_9_S9:
C1_9_00AE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    CallPlaceSelect PL_TMP, PL_TMP2  // OpenRegionMap: the Sinnoh town map, view-only here (patches/town_map.py)
// RestoreOverworld: Black 2's CallPlaceSelect reopened the field itself
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 1042:2 (a subroutine here)
T1042_2_S2:
T1042_2_0042:
    pl_SetVarFromValue PVAR_8000, 2
    pl_GoTo T1042_2_00D2

T1042_2_00D2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 32768, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_2_0214
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 137  // Pearl bank 562 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_2_0107
    pl_GoTo T1042_2_021F

T1042_2_0107:
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 0, 32768, 32772, 32773: not translated yet
    pl_stub MessageFromBank  // PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8000, 10
    pl_GoToIf 1, T1042_2_0165
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32772: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_2_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_2_0214

T1042_2_0165:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextListMenu 1, 1, 0, 1, PVAR_8004
    ListMenuAdd 138, 65535, 255  // Pearl AddListMenuEntry 16, 255
    ListMenuAdd 139, 65535, 255  // Pearl AddListMenuEntry 17, 255
    ListMenuAdd 140, 65535, 255  // Pearl AddListMenuEntry 18, 255
    ListMenuAdd 141, 65535, 255  // Pearl AddListMenuEntry 19, 255
    ListMenuAdd 142, 65535, 255  // Pearl AddListMenuEntry 20, 255
    ListMenuAdd 143, 65535, 255  // Pearl AddListMenuEntry 21, 255
    ListMenuAdd 144, 65535, 255  // Pearl AddListMenuEntry 22, 255
    ListMenuAdd 145, 65535, 255  // Pearl AddListMenuEntry 23, 255
    ListMenuAdd 146, 65535, 255  // Pearl AddListMenuEntry 24, 255
    ListMenuAdd 147, 65535, 255  // Pearl AddListMenuEntry 25, 255
    ListMenuAdd 148, 65535, 255  // Pearl AddListMenuEntry 26, 255
    ListMenuAdd 149, 65535, 255  // Pearl AddListMenuEntry 27, 255
    ListMenuAdd 150, 65535, 255  // Pearl AddListMenuEntry 28, 255
    ListMenuAdd 151, 65535, 255  // Pearl AddListMenuEntry 29, 255
    ListMenuAdd 152, 65535, 255  // Pearl AddListMenuEntry 30, 255
    ListMenuAdd 153, 65535, 255  // Pearl AddListMenuEntry 31, 255
    ListMenuAdd 154, 65535, 255  // Pearl AddListMenuEntry 32, 255
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 65534
    pl_GoToIf 1, T1042_2_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_2_0214

T1042_2_0214:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 155  // Pearl bank 562 line 2
    pl_WaitButton
    pl_GoTo T1042_2_022A

T1042_2_021F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 156  // Pearl bank 562 line 1
    pl_WaitButton
    pl_GoTo T1042_2_022A

T1042_2_022A:
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
