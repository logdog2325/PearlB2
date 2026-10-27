// MAP_ROUTE_212_SHARD_WEATHER_TM_HOUSE: Pearl script file 423, text bank 443. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P423_S1
    ScriptEntry P423_S2
    ScriptEntry P423_S3
    ScriptEntry P423_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P423_S1:
P423_0012:
    pl_SetFlag PFLAG_09EC
    pl_End

P423_S2:
P423_0018:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P423_S3:
P423_002B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_Call P423_0534
    pl_CompareVarToValue PVAR_8000, 0
    pl_GoToIf 1, P423_05B0
    pl_msg_talk 2
    pl_SetVarFromVar PVAR_8008, PVAR_8000
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_0100
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P423_012D
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P423_015A
    pl_CompareVarToValue PVAR_8008, 8
    pl_GoToIf 1, P423_0187
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P423_01B4
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, P423_01F2
    pl_CompareVarToValue PVAR_8008, 9
    pl_GoToIf 1, P423_0230
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, P423_026E
    pl_CompareVarToValue PVAR_8008, 10
    pl_GoToIf 1, P423_02AC
    pl_CompareVarToValue PVAR_8008, 12
    pl_GoToIf 1, P423_02EA
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, P423_0328
    pl_CompareVarToValue PVAR_8008, 11
    pl_GoToIf 1, P423_0377
    pl_CompareVarToValue PVAR_8008, 14
    pl_GoToIf 1, P423_03C6
    pl_GoTo P423_0415

P423_0100:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 209, 0
    ListMenuAdd 11, 65535, 1  // Pearl AddMenuEntryImm 44, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0475
    pl_GoTo P423_04F1

P423_012D:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 12, 65535, 0  // Pearl AddMenuEntryImm 210, 0
    ListMenuAdd 11, 65535, 1  // Pearl AddMenuEntryImm 44, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0494
    pl_GoTo P423_04F1

P423_015A:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 13, 65535, 0  // Pearl AddMenuEntryImm 211, 0
    ListMenuAdd 11, 65535, 1  // Pearl AddMenuEntryImm 44, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_04B3
    pl_GoTo P423_04F1

P423_0187:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 14, 65535, 0  // Pearl AddMenuEntryImm 212, 0
    ListMenuAdd 11, 65535, 1  // Pearl AddMenuEntryImm 44, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_04D2
    pl_GoTo P423_04F1

P423_01B4:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 209, 0
    ListMenuAdd 12, 65535, 1  // Pearl AddMenuEntryImm 210, 1
    ListMenuAdd 11, 65535, 2  // Pearl AddMenuEntryImm 44, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0475
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_0494
    pl_GoTo P423_04F1

P423_01F2:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 209, 0
    ListMenuAdd 13, 65535, 1  // Pearl AddMenuEntryImm 211, 1
    ListMenuAdd 11, 65535, 2  // Pearl AddMenuEntryImm 44, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0475
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_04B3
    pl_GoTo P423_04F1

P423_0230:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 209, 0
    ListMenuAdd 14, 65535, 1  // Pearl AddMenuEntryImm 212, 1
    ListMenuAdd 11, 65535, 2  // Pearl AddMenuEntryImm 44, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0475
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_04D2
    pl_GoTo P423_04F1

P423_026E:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 12, 65535, 0  // Pearl AddMenuEntryImm 210, 0
    ListMenuAdd 13, 65535, 1  // Pearl AddMenuEntryImm 211, 1
    ListMenuAdd 11, 65535, 2  // Pearl AddMenuEntryImm 44, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0494
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_04B3
    pl_GoTo P423_04F1

P423_02AC:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 12, 65535, 0  // Pearl AddMenuEntryImm 210, 0
    ListMenuAdd 14, 65535, 1  // Pearl AddMenuEntryImm 212, 1
    ListMenuAdd 11, 65535, 2  // Pearl AddMenuEntryImm 44, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0494
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_04D2
    pl_GoTo P423_04F1

P423_02EA:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 13, 65535, 0  // Pearl AddMenuEntryImm 211, 0
    ListMenuAdd 14, 65535, 1  // Pearl AddMenuEntryImm 212, 1
    ListMenuAdd 11, 65535, 2  // Pearl AddMenuEntryImm 44, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_04B3
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_04D2
    pl_GoTo P423_04F1

P423_0328:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 209, 0
    ListMenuAdd 12, 65535, 1  // Pearl AddMenuEntryImm 210, 1
    ListMenuAdd 13, 65535, 2  // Pearl AddMenuEntryImm 211, 2
    ListMenuAdd 11, 65535, 3  // Pearl AddMenuEntryImm 44, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0475
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_0494
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P423_04B3
    pl_GoTo P423_04F1

P423_0377:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 209, 0
    ListMenuAdd 12, 65535, 1  // Pearl AddMenuEntryImm 210, 1
    ListMenuAdd 14, 65535, 2  // Pearl AddMenuEntryImm 212, 2
    ListMenuAdd 11, 65535, 3  // Pearl AddMenuEntryImm 44, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0475
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_0494
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P423_04D2
    pl_GoTo P423_04F1

P423_03C6:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 12, 65535, 0  // Pearl AddMenuEntryImm 210, 0
    ListMenuAdd 13, 65535, 1  // Pearl AddMenuEntryImm 211, 1
    ListMenuAdd 14, 65535, 2  // Pearl AddMenuEntryImm 212, 2
    ListMenuAdd 11, 65535, 3  // Pearl AddMenuEntryImm 44, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0494
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_04B3
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P423_04D2
    pl_GoTo P423_04F1

P423_0415:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 209, 0
    ListMenuAdd 12, 65535, 1  // Pearl AddMenuEntryImm 210, 1
    ListMenuAdd 13, 65535, 2  // Pearl AddMenuEntryImm 211, 2
    ListMenuAdd 14, 65535, 3  // Pearl AddMenuEntryImm 212, 3
    ListMenuAdd 11, 65535, 4  // Pearl AddMenuEntryImm 44, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P423_0475
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P423_0494
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P423_04B3
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P423_04D2
    pl_GoTo P423_04F1

P423_0475:
    pl_BufferItemName 0, 338  // Pearl item 338 (TM11) = TM11 Sunny Day
    pl_BufferTMHMMoveName 1, 338  // Pearl item 338 (TM11) = TM11 Sunny Day
    pl_SetVarFromValue PVAR_8004, 338  // Pearl item 338 (TM11) = TM11 Sunny Day
    pl_SetVarFromValue PVAR_8006, 72
    pl_msg_talk 3
    pl_GoTo P423_04FC

P423_0494:
    pl_BufferItemName 0, 345  // Pearl item 345 (TM18) = TM18 Rain Dance
    pl_BufferTMHMMoveName 1, 345  // Pearl item 345 (TM18) = TM18 Rain Dance
    pl_SetVarFromValue PVAR_8004, 345  // Pearl item 345 (TM18) = TM18 Rain Dance
    pl_SetVarFromValue PVAR_8006, 73
    pl_msg_talk 4
    pl_GoTo P423_04FC

P423_04B3:
    pl_BufferItemName 0, 364  // Pearl item 364 (TM37) = TM37 Sandstorm
    pl_BufferTMHMMoveName 1, 364  // Pearl item 364 (TM37) = TM37 Sandstorm
    pl_SetVarFromValue PVAR_8004, 364  // Pearl item 364 (TM37) = TM37 Sandstorm
    pl_SetVarFromValue PVAR_8006, 74
    pl_msg_talk 5
    pl_GoTo P423_04FC

P423_04D2:
    pl_BufferItemName 0, 334  // Pearl item 334 (TM07) = TM07 Hail
    pl_BufferTMHMMoveName 1, 334  // Pearl item 334 (TM07) = TM07 Hail
    pl_SetVarFromValue PVAR_8004, 334  // Pearl item 334 (TM07) = TM07 Hail
    pl_SetVarFromValue PVAR_8006, 75
    pl_msg_talk 6
    pl_GoTo P423_04FC

P423_04F1:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P423_04FC:
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P423_0529
    pl_RemoveItem PVAR_8006, 10, PVAR_800C
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P423_0529:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P423_0534:
    pl_SetVarFromValue PVAR_8000, 0
    pl_CheckItem 72, 10, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P423_0590
    pl_CheckItem 73, 10, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P423_0598
    pl_CheckItem 74, 10, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P423_05A0
    pl_CheckItem 75, 10, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P423_05A8
    pl_Return

P423_0590:
    pl_AddVar PVAR_8000, 1
    pl_Return

P423_0598:
    pl_AddVar PVAR_8000, 2
    pl_Return

P423_05A0:
    pl_AddVar PVAR_8000, 4
    pl_Return

P423_05A8:
    pl_AddVar PVAR_8000, 8
    pl_Return

P423_05B0:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P423_S4:
P423_05BB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

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
    pl_msg_sys 15  // Pearl bank 199 line 30
    pl_WaitButton
    pl_Return

C205_17_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 28
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
    pl_msg_sys 17  // Pearl bank 199 line 25
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
    pl_msg_sys 18  // Pearl bank 199 line 110
    pl_Return

C205_17_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 111
    pl_Return

C205_17_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 112
    pl_Return

C205_17_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 113
    pl_Return

C205_17_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 114
    pl_Return

C205_17_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 115
    pl_Return

C205_17_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 116
    pl_Return

C205_17_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 117
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
