// MAP_SOLACEON_NEWS_PRESS: Pearl script file 1009, text bank 524. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1009_S1
    ScriptEntry P1009_S2
    ScriptEntry P1009_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P1009_S1:
P1009_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00DC
    pl_GoToIf 1, P1009_0206
    pl_CheckFlag PFLAG_0AB1
    pl_GoToIf 1, P1009_028F
    pl_CheckFlag PFLAG_00D8
    pl_GoToIf 0, P1009_004A
    pl_CompareVarToValue PVAR_40E5, 0
    pl_GoToIf 1, P1009_0057
    pl_GoTo P1009_0081

P1009_004A:
    pl_SetFlag PFLAG_00D8
    pl_msg_talk 0
    pl_GoTo P1009_0060

P1009_0057:
    pl_msg_talk 1
    pl_GoTo P1009_0060

P1009_0060:
    pl_GetRandomSeenSpecies PVAR_800C  // Unk0218
    pl_SetVarFromVar PVAR_40E5, PVAR_800C
    FlagSet PFLAG_NEWS_PRESS_TODAY  // Unk0219 1: the deadline is today
    pl_BufferSpeciesName 0, PVAR_40E5
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_0081:
    pl_msg_talk 3
    FlagGet PFLAG_NEWS_PRESS_TODAY, PVAR_800C  // Unk021A: days left (1 today, 0 after midnight)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1009_027E
    PokePartyFindBySpecies PVAR_40E5, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1009_0262
    pl_GoTo P1009_00AE

P1009_00AE:
    pl_BufferSpeciesName 0, PVAR_40E5
    pl_msg_talk 4
    pl_GetRandom PVAR_800C, 12
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P1009_0189
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P1009_0191
    pl_CompareVarToValue PVAR_800C, 2
    pl_CallIf 1, P1009_0199
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, P1009_01A1
    pl_CompareVarToValue PVAR_800C, 4
    pl_CallIf 1, P1009_01A9
    pl_CompareVarToValue PVAR_800C, 5
    pl_CallIf 1, P1009_01B1
    pl_CompareVarToValue PVAR_800C, 6
    pl_CallIf 1, P1009_01B9
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, P1009_01C1
    pl_CompareVarToValue PVAR_800C, 8
    pl_CallIf 1, P1009_01C9
    pl_CompareVarToValue PVAR_800C, 9
    pl_CallIf 1, P1009_01D1
    pl_CompareVarToValue PVAR_800C, 10
    pl_CallIf 1, P1009_01D9
    pl_CompareVarToValue PVAR_800C, 11
    pl_CallIf 1, P1009_01E1
    pl_SetVarFromValue PVAR_8005, 3
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P1009_01E9
    pl_SetFlag PFLAG_0AB1
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1009_0236
    pl_End

P1009_0189:
    pl_SetVarFromValue PVAR_8004, 2
    pl_Return

P1009_0191:
    pl_SetVarFromValue PVAR_8004, 3
    pl_Return

P1009_0199:
    pl_SetVarFromValue PVAR_8004, 4
    pl_Return

P1009_01A1:
    pl_SetVarFromValue PVAR_8004, 6
    pl_Return

P1009_01A9:
    pl_SetVarFromValue PVAR_8004, 7
    pl_Return

P1009_01B1:
    pl_SetVarFromValue PVAR_8004, 8
    pl_Return

P1009_01B9:
    pl_SetVarFromValue PVAR_8004, 9
    pl_Return

P1009_01C1:
    pl_SetVarFromValue PVAR_8004, 10
    pl_Return

P1009_01C9:
    pl_SetVarFromValue PVAR_8004, 11
    pl_Return

P1009_01D1:
    pl_SetVarFromValue PVAR_8004, 13
    pl_Return

P1009_01D9:
    pl_SetVarFromValue PVAR_8004, 14
    pl_Return

P1009_01E1:
    pl_SetVarFromValue PVAR_8004, 15
    pl_Return

P1009_01E9:
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_ClearFlag PFLAG_00DC
    pl_SetVarFromValue PVAR_40E5, 0
    pl_SetFlag PFLAG_0AB1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_0206:
    pl_SetVarFromVar PVAR_8004, PVAR_4117
    pl_SetVarFromValue PVAR_8005, 3
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1009_0236
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P1009_024B
    pl_End

P1009_0236:
    pl_SetVarFromVar PVAR_4117, PVAR_8004
    pl_SetFlag PFLAG_00DC
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_024B:
    pl_msg_talk 7
    pl_ClearFlag PFLAG_00DC
    pl_SetVarFromValue PVAR_40E5, 0
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_0262:
    pl_BufferSpeciesName 0, PVAR_40E5
    FlagGet PFLAG_NEWS_PRESS_TODAY, PVAR_800C  // Unk021A: days left (1 today, 0 after midnight)
    pl_BufferNumber 1, PVAR_800C
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_027E:
    pl_msg_talk 9
    pl_SetVarFromValue PVAR_40E5, 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_028F:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_S2:
P1009_029A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_S3:
P1009_02AD:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 12
    pl_msg_sys 13
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 18, 1, 0, 1, PVAR_800C
    ListMenuAdd 17, 65535, 0  // Pearl AddMenuEntry 263, 0
    ListMenuAdd 18, 65535, 1  // Pearl AddMenuEntry 264, 1
    ListMenuAdd 19, 65535, 2  // Pearl AddMenuEntry 265, 2
    ListMenuAdd 20, 65535, 3  // Pearl AddMenuEntry 266, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P1009_0310
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P1009_031B
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P1009_0326
    pl_GoTo P1009_0331

P1009_0310:
    pl_msg_sys 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_031B:
    pl_msg_sys 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_0326:
    pl_msg_sys 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1009_0331:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

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
    pl_msg_sys 21  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 28
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
    pl_msg_sys 23  // Pearl bank 199 line 25
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
    pl_msg_sys 24  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 117
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
    pl_msg_sys 32  // Pearl bank 199 line 30
    pl_WaitButton
    pl_Return

C205_17_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 28
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
    pl_msg_sys 23  // Pearl bank 199 line 25
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
    pl_msg_sys 24  // Pearl bank 199 line 110
    pl_Return

C205_17_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 111
    pl_Return

C205_17_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 112
    pl_Return

C205_17_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 113
    pl_Return

C205_17_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 114
    pl_Return

C205_17_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 115
    pl_Return

C205_17_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 116
    pl_Return

C205_17_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 117
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
