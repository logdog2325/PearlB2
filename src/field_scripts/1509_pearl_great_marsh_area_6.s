// MAP_GREAT_MARSH_AREA_6: Pearl script file 240, text bank 228. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; 3: after a Warp, 4: after a Warp; 5: PearlArrive; 55: Pearl 8800, 61: Pearl 8808
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P240_S1
    ScriptEntry P240_S2
    ScriptEntry W124_011D_S
    ScriptEntry W124_0219_S
    ScriptEntry PearlArrive
    ScriptEntry PearlClosed_0
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_8800
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_8808
    ScriptEntriesEnd

P240_S1:
P240_000A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0160
    pl_GoToIf 1, P240_004F
    pl_msg_talk 0
    pl_SetVarFromValue PVAR_8004, 528  // Pearl item 424 (HM05) = TM119 Defog
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P240_004F
    pl_SetFlag PFLAG_0160
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P240_004F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P240_S2:
P240_005A:
    pl_sign 2, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

// ---- continuation 3: after the Warp at 124:011D (MAP_PASTORIA_GREAT_MARSH_ENTRANCE_1F)
W124_011D_S:
W124_011D_0129:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

// ---- continuation 4: after the Warp at 124:0219 (MAP_PASTORIA_GREAT_MARSH_ENTRANCE_1F)
W124_0219_S:
W124_0219_0225:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlProxy_8800:                  // Pearl global script 8800 (run by this zone's events)
    VMCall C462_1_S1
    VMHalt

PearlProxy_8808:                  // Pearl global script 8808 (run by this zone's events)
    VMCall C462_9_S9
    VMHalt

PearlClosed_0:                  // a closed place (data/pearl_closed_facilities.json): sign 0
    pl_closed_facility 21, 255
    VMHalt

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
    pl_msg_sys 3  // Pearl bank 199 line 30
    pl_WaitButton
    pl_Return

C205_17_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4  // Pearl bank 199 line 28
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
    pl_msg_sys 5  // Pearl bank 199 line 25
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
    pl_msg_sys 6  // Pearl bank 199 line 110
    pl_Return

C205_17_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7  // Pearl bank 199 line 111
    pl_Return

C205_17_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 8  // Pearl bank 199 line 112
    pl_Return

C205_17_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9  // Pearl bank 199 line 113
    pl_Return

C205_17_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 10  // Pearl bank 199 line 114
    pl_Return

C205_17_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 115
    pl_Return

C205_17_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 116
    pl_Return

C205_17_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 13  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 462:1 (a subroutine here)
C462_1_S1:
C462_1_005E:
    pl_stub InitGreatMarshTram  // Pearl 0x20E KeepSafariTrain : not translated yet
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 462:9 (a subroutine here)
C462_9_S9:
C462_9_056A:
    pl_LockAll
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 485 line 3
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 15, 65535, 0  // Pearl AddMenuEntryImm 186, 0
    ListMenuAdd 16, 65535, 1  // Pearl AddMenuEntryImm 187, 1
    ListMenuAdd 17, 65535, 2  // Pearl AddMenuEntryImm 188, 2
    ListMenuAdd 18, 65535, 3  // Pearl AddMenuEntryImm 189, 3
    ListMenuAdd 19, 65535, 4  // Pearl AddMenuEntryImm 192, 4
    ListMenuShow
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, C462_9_06C2
    pl_CompareVarToValue PVAR_800C, 65534
    pl_GoToIf 1, C462_9_06C2
    pl_stub CheckGreatMarshTramLocation  // Pearl 0x210 CheckSafariTrainPosition 2, 32772: not translated yet
    pl_SetVarFromValue PVAR_8005, 2
    pl_CompareVarToValue PVAR_8004, 6
    pl_CallIf 1, C462_9_0634
    pl_stub SetPlayerHeightCalculationEnabled  // Pearl 0x211 IgnoreHeights 0: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, C462_9_06F4
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C462_9_06E8
    pl_CompareVarToValue PVAR_800C, 2
    pl_CallIf 1, C462_9_06F4
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, C462_9_06E8
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, C462_9_066E
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C462_9_067C
    pl_CompareVarToValue PVAR_800C, 2
    pl_CallIf 1, C462_9_068A
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, C462_9_0698
    pl_stub SetPlayerHeightCalculationEnabled  // Pearl 0x211 IgnoreHeights 1: not translated yet
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C462_9_0634:
    pl_stub MoveGreatMarshTram  // Pearl 0x20F MoveSafariTrain 32773, 3: not translated yet
    pl_Return

C462_9_063C:
    pl_stub MoveGreatMarshTram  // Pearl 0x20F MoveSafariTrain 32774, 4: not translated yet
    pl_Return

C462_9_0644:
    pl_SetVarFromValue PVAR_8006, 0
    pl_Call C462_9_063C
    pl_Return

C462_9_0652:
    pl_SetVarFromValue PVAR_8006, 1
    pl_Call C462_9_063C
    pl_Return

C462_9_066E:
    pl_Call C462_9_0644
    pl_Call C462_9_070C
    pl_Return

C462_9_067C:
    pl_Call C462_9_0644
    pl_Call C462_9_0700
    pl_Return

C462_9_068A:
    pl_Call C462_9_0652
    pl_Call C462_9_070C
    pl_Return

C462_9_0698:
    pl_Call C462_9_0652
    pl_Call C462_9_0700
    pl_Return

C462_9_06C2:
    pl_BufferPlayerName 0
    pl_msg_sys 20  // Pearl bank 485 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C462_9_06E8:
    pl_ApplyMovement PL_PLAYER, C462_9_0730
    pl_WaitMovement
    pl_Return

C462_9_06F4:
    pl_ApplyMovement PL_PLAYER, C462_9_073C
    pl_WaitMovement
    pl_Return

C462_9_0700:
    pl_ApplyMovement PL_PLAYER, C462_9_0748
    pl_WaitMovement
    pl_Return

C462_9_070C:
    pl_ApplyMovement PL_PLAYER, C462_9_0754
    pl_WaitMovement
    pl_Return

    .balign 4, 0
C462_9_0730:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
C462_9_073C:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
C462_9_0748:
    Move 70, 1  // SET_VISIBLE
    Move 15, 3  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
C462_9_0754:
    Move 70, 1  // SET_VISIBLE
    Move 14, 3  // WALK_NORMAL_WEST
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
