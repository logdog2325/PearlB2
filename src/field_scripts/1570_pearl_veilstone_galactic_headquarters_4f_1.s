// MAP_VEILSTONE_GALACTIC_HEADQUARTERS_4F_1: Pearl script file 336, text bank 265. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P336_S1
    ScriptEntry P336_S2
    ScriptEntry P336_S3
    ScriptEntry P336_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P336_S1:
P336_0012:
    pl_LockAll
    pl_ApplyMovement 0, P336_00E8
    pl_WaitMovement
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 0, P336_00F0
    pl_WaitMovement
    pl_msg_sys 1
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 8
    pl_GoToIf 1, P336_0054
    pl_CompareVarToValue PVAR_8004, 9
    pl_GoToIf 1, P336_0064
    pl_End

P336_0054:
    pl_ApplyMovement 0, P336_00F8
    pl_WaitMovement
    pl_GoTo P336_0074

P336_0064:
    pl_ApplyMovement 0, P336_0100
    pl_WaitMovement
    pl_GoTo P336_0074

P336_0074:
    pl_StartTrainerBattle PTRAINER_403, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P336_00E1
    pl_msg_sys 2
    pl_SetVarFromValue PVAR_8004, 1
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P336_00DB
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement 0, P336_0110
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_ApplyMovement 0, P336_0124
    pl_WaitMovement
    pl_RemoveObject 0, PFLAG_01DC
    pl_SetVarFromValue PVAR_40D6, 1
    pl_ReleaseAll
    pl_End

P336_00DB:
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_Return

P336_00E1:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P336_S2:
P336_012C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckItem 440, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P336_0154
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P336_0154:
    pl_msg_talk 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P336_0177
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P336_01AB
    pl_End

P336_0177:
    pl_BufferPlayerName 0
    pl_msg_talk 7
    pl_WaitButton
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlaySE SEQ_SE_OPEN1  // Pearl SEQ_SE_DP_DOOR10
    pl_ApplyMovement 1, P336_01B4
    pl_ApplyMovement 2, P336_01BC
    pl_WaitMovement
    pl_SetFlag PFLAG_0244
    pl_RemoveObject 1, PFLAG_0244
    pl_RemoveObject 2, PFLAG_0244
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P336_01AB:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P336_S3:
P336_01C4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P336_S4:
P336_01D5:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 9
    pl_GoTo P336_01E6

P336_01E6:
    pl_msg_sys 10
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 14, 65535, 0  // Pearl AddMenuEntry 267, 0
    ListMenuAdd 15, 65535, 1  // Pearl AddMenuEntry 268, 1
    ListMenuAdd 16, 65535, 2  // Pearl AddMenuEntry 269, 2
    ListMenuAdd 17, 65535, 3  // Pearl AddMenuEntry 270, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P336_0240
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P336_024B
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P336_0256
    pl_GoTo P336_0261

P336_0240:
    pl_msg_sys 11
    pl_GoTo P336_01E6

P336_024B:
    pl_msg_sys 12
    pl_GoTo P336_01E6

P336_0256:
    pl_msg_sys 13
    pl_GoTo P336_01E6

P336_0261:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P336_00E8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P336_00F0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P336_00F8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P336_0100:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P336_0110:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 4  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P336_0124:
    Move 15, 7  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P336_01B4:
    Move 18, 1  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P336_01BC:
    Move 19, 1  // WALK_FAST_EAST
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
    pl_msg_sys 18  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 28
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
    pl_msg_sys 20  // Pearl bank 199 line 25
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
    pl_msg_sys 21  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 117
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
