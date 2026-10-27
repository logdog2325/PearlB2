// MAP_JUBLIFE_TRAINER_SCHOOL: Pearl script file 29, text bank 42. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-12: Pearl's; no warp continuations; 13: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P29_S1
    ScriptEntry P29_S2
    ScriptEntry P29_S3
    ScriptEntry P29_S4
    ScriptEntry P29_S5
    ScriptEntry P29_S6
    ScriptEntry P29_S7
    ScriptEntry P29_S8
    ScriptEntry P29_S9
    ScriptEntry P29_S10
    ScriptEntry P29_S11
    ScriptEntry P29_S12
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P29_S1:
P29_0032:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_talk 0
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_WaitFanfare
    pl_RemoveItem 459, 1, PVAR_800C
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_SetVarFromValue PVAR_8004, 442
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_BufferRivalName 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P29_00A4
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P29_00BE
    pl_GoTo P29_00D8

P29_00A4:
    pl_ApplyMovement 1, P29_0114
    pl_ApplyMovement PL_PLAYER, P29_0138
    pl_WaitMovement
    pl_GoTo P29_00F2

P29_00BE:
    pl_ApplyMovement 1, P29_0124
    pl_ApplyMovement PL_PLAYER, P29_0148
    pl_WaitMovement
    pl_GoTo P29_00F2

P29_00D8:
    pl_ApplyMovement 1, P29_0124
    pl_ApplyMovement PL_PLAYER, P29_0148
    pl_WaitMovement
    pl_GoTo P29_00F2

P29_00F2:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 1, PFLAG_0212
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetVarFromValue PVAR_40E7, 1
    pl_SetFlag PFLAG_00F1
    pl_ClearFlag PFLAG_0214
    pl_ClearFlag PFLAG_0213
    pl_ReleaseAll
    pl_End

P29_S2:
P29_0154:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_S3:
P29_0167:
    pl_End

P29_S4:
P29_0169:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_S5:
P29_017C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_S6:
P29_018F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_S7:
P29_01A2:
    pl_End

P29_S8:
P29_01A4:
    pl_End

P29_S9:
P29_01A6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0112
    pl_GoToIf 1, P29_025E
    pl_CheckFlag PFLAG_010C
    pl_GoToIf 1, P29_0273
    pl_msg_talk 9
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P29_01E7
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P29_0289
    pl_End

P29_01E7:
    pl_msg_talk 10
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_342, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P29_0294
    pl_SetFlag PFLAG_010C
    pl_CheckFlag PFLAG_010D
    pl_GoToIf 1, P29_022A
    pl_CheckFlag PFLAG_010D
    pl_GoToIf 0, P29_021F
    pl_End

P29_021F:
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_022A:
    pl_msg_talk 13
    pl_SetVarFromValue PVAR_8004, 337  // Pearl item 337 (TM10) = TM10 Hidden Power
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P29_0269
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0112
    pl_GoTo P29_025E

P29_025E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_0269:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_0273:
    pl_CheckFlag PFLAG_010D
    pl_GoToIf 1, P29_022A
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_0289:
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_0294:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P29_S10:
P29_029A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_010D
    pl_GoToIf 1, P29_0308
    pl_msg_talk 15
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P29_02D0
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P29_0313
    pl_End

P29_02D0:
    pl_msg_talk 16
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_345, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P29_033F
    pl_SetFlag PFLAG_010D
    pl_CheckFlag PFLAG_010C
    pl_GoToIf 1, P29_0329
    pl_CheckFlag PFLAG_010C
    pl_GoToIf 0, P29_031E
    pl_End

P29_0308:
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_0313:
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_031E:
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_0329:
    pl_CheckFlag PFLAG_0112
    pl_GoToIf 1, P29_031E
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_033F:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P29_S11:
P29_0345:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 20
    pl_GoTo P29_0356

P29_0356:
    pl_msg_sys 21
    ListMenu_AnchorTopRight 31, 2, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 7, 2, 0, 1, PVAR_800C
    ListMenuAdd 28, 65535, 0  // Pearl AddMenuEntryImm 0, 0
    ListMenuAdd 29, 65535, 1  // Pearl AddMenuEntryImm 1, 1
    ListMenuAdd 30, 65535, 2  // Pearl AddMenuEntryImm 2, 2
    ListMenuAdd 31, 65535, 3  // Pearl AddMenuEntryImm 3, 3
    ListMenuAdd 32, 65535, 4  // Pearl AddMenuEntryImm 4, 4
    ListMenuAdd 33, 65535, 5  // Pearl AddMenuEntryImm 5, 5
    pl_stub ShowMenuMultiColumn  // Pearl 0x048 Unk0048 2: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P29_03CB
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P29_03D6
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P29_03E1
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P29_03EC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P29_03F7
    pl_GoTo P29_0402

P29_03CB:
    pl_msg_sys 22
    pl_GoTo P29_0356

P29_03D6:
    pl_msg_sys 23
    pl_GoTo P29_0356

P29_03E1:
    pl_msg_sys 24
    pl_GoTo P29_0356

P29_03EC:
    pl_msg_sys 25
    pl_GoTo P29_0356

P29_03F7:
    pl_msg_sys 26
    pl_GoTo P29_0356

P29_0402:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P29_S12:
P29_0408:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P29_0114:
    Move 19, 1  // WALK_FAST_EAST
    Move 17, 8  // WALK_FAST_SOUTH
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P29_0124:
    Move 17, 4  // WALK_FAST_SOUTH
    Move 19, 1  // WALK_FAST_EAST
    Move 17, 4  // WALK_FAST_SOUTH
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P29_0138:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P29_0148:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

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
    pl_msg_sys 34  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 28
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
    pl_msg_sys 36  // Pearl bank 199 line 25
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
    pl_msg_sys 37  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 40  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 42  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 43  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 44  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:18 (a subroutine here)
C205_18_S18:
C205_18_0B60:
    pl_Call C205_18_0B6A
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_18_0B6A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 45  // Pearl bank 199 line 27
    pl_WaitButton
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
