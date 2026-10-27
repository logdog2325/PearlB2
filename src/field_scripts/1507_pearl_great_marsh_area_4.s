// MAP_GREAT_MARSH_AREA_4: Pearl script file 238, text bank 226. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive; 55: Pearl 8800, 59: Pearl 8806
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P238_S1
    ScriptEntry P238_S2
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_8800
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_8806
    ScriptEntriesEnd

P238_S1:
P238_000A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P238_S2:
P238_001D:
    pl_sign 1, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

PearlProxy_8800:                  // Pearl global script 8800 (run by this zone's events)
    VMCall C462_1_S1
    VMHalt

PearlProxy_8806:                  // Pearl global script 8806 (run by this zone's events)
    VMCall C462_7_S7
    VMHalt

PearlClosed_0:                  // a closed place (data/pearl_closed_facilities.json): sign 0
    pl_closed_facility 9, 255
    VMHalt

// ---- Pearl global script 462:1 (a subroutine here)
C462_1_S1:
C462_1_005E:
    pl_stub InitGreatMarshTram  // Pearl 0x20E KeepSafariTrain : not translated yet
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 462:7 (a subroutine here)
C462_7_S7:
C462_7_03D6:
    pl_LockAll
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2  // Pearl bank 485 line 3
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 3, 65535, 0  // Pearl AddMenuEntryImm 186, 0
    ListMenuAdd 4, 65535, 1  // Pearl AddMenuEntryImm 187, 1
    ListMenuAdd 5, 65535, 2  // Pearl AddMenuEntryImm 190, 2
    ListMenuAdd 6, 65535, 3  // Pearl AddMenuEntryImm 191, 3
    ListMenuAdd 7, 65535, 4  // Pearl AddMenuEntryImm 192, 4
    ListMenuShow
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, C462_7_06C2
    pl_CompareVarToValue PVAR_800C, 65534
    pl_GoToIf 1, C462_7_06C2
    pl_stub CheckGreatMarshTramLocation  // Pearl 0x210 CheckSafariTrainPosition 1, 32772: not translated yet
    pl_SetVarFromValue PVAR_8005, 1
    pl_CompareVarToValue PVAR_8004, 6
    pl_CallIf 1, C462_7_0634
    pl_stub SetPlayerHeightCalculationEnabled  // Pearl 0x211 IgnoreHeights 0: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, C462_7_06F4
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C462_7_06E8
    pl_CompareVarToValue PVAR_800C, 2
    pl_CallIf 1, C462_7_06F4
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, C462_7_06E8
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, C462_7_066E
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C462_7_067C
    pl_CompareVarToValue PVAR_800C, 2
    pl_CallIf 1, C462_7_06A6
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, C462_7_06B4
    pl_stub SetPlayerHeightCalculationEnabled  // Pearl 0x211 IgnoreHeights 1: not translated yet
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C462_7_0634:
    pl_stub MoveGreatMarshTram  // Pearl 0x20F MoveSafariTrain 32773, 3: not translated yet
    pl_Return

C462_7_063C:
    pl_stub MoveGreatMarshTram  // Pearl 0x20F MoveSafariTrain 32774, 4: not translated yet
    pl_Return

C462_7_0644:
    pl_SetVarFromValue PVAR_8006, 0
    pl_Call C462_7_063C
    pl_Return

C462_7_0660:
    pl_SetVarFromValue PVAR_8006, 2
    pl_Call C462_7_063C
    pl_Return

C462_7_066E:
    pl_Call C462_7_0644
    pl_Call C462_7_070C
    pl_Return

C462_7_067C:
    pl_Call C462_7_0644
    pl_Call C462_7_0700
    pl_Return

C462_7_06A6:
    pl_Call C462_7_0660
    pl_Call C462_7_070C
    pl_Return

C462_7_06B4:
    pl_Call C462_7_0660
    pl_Call C462_7_0700
    pl_Return

C462_7_06C2:
    pl_BufferPlayerName 0
    pl_msg_sys 8  // Pearl bank 485 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C462_7_06E8:
    pl_ApplyMovement PL_PLAYER, C462_7_0730
    pl_WaitMovement
    pl_Return

C462_7_06F4:
    pl_ApplyMovement PL_PLAYER, C462_7_073C
    pl_WaitMovement
    pl_Return

C462_7_0700:
    pl_ApplyMovement PL_PLAYER, C462_7_0748
    pl_WaitMovement
    pl_Return

C462_7_070C:
    pl_ApplyMovement PL_PLAYER, C462_7_0754
    pl_WaitMovement
    pl_Return

    .balign 4, 0
C462_7_0730:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
C462_7_073C:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
C462_7_0748:
    Move 70, 1  // SET_VISIBLE
    Move 15, 3  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
C462_7_0754:
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
