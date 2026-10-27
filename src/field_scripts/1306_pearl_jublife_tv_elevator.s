// MAP_JUBLIFE_TV_ELEVATOR: Pearl script file 18, text bank 32. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P18_S1
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P18_S1:
P18_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    pl_SetVarFromVar PVAR_8008, PVAR_40CE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P18_004E
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P18_005B
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P18_0068
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P18_0075
    pl_End

P18_004E:
    pl_BufferNumber 0, 4
    pl_GoTo P18_0082

P18_005B:
    pl_BufferNumber 0, 3
    pl_GoTo P18_0082

P18_0068:
    pl_BufferNumber 0, 2
    pl_GoTo P18_0082

P18_0075:
    pl_BufferNumber 0, 1
    pl_GoTo P18_0082

P18_0082:
// ShowCurrentFloor 20, 1, PVAR_40CE: no floor window in Black 2
    pl_msg_talk 0
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 6, 65535, 0  // Pearl AddMenuEntryImm 119, 0
    ListMenuAdd 7, 65535, 1  // Pearl AddMenuEntryImm 118, 1
    ListMenuAdd 8, 65535, 2  // Pearl AddMenuEntryImm 117, 2
    ListMenuAdd 9, 65535, 3  // Pearl AddMenuEntryImm 116, 3
    ListMenuAdd 10, 65535, 4  // Pearl AddMenuEntryImm 124, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P18_01DE
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P18_018D
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P18_013C
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P18_00EB
    pl_GoTo P18_0285

P18_00EB:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 13, 2, 18, 0, 4  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 11 (MAP_JUBLIFE_TV_1F) warp 2
    WorkSetConst PL_ELEVATOR_FROM, 3  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 3
    pl_GoToIf 1, P18_026E
    pl_CompareVarToValue PVAR_40CE, 3
    pl_CallIf 2, P18_022F
    pl_CompareVarToValue PVAR_40CE, 3
    pl_CallIf 0, P18_023A
    pl_Call P18_0245
    pl_SetVarFromValue PVAR_40CE, 3
    pl_GoTo P18_0263

P18_013C:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 14, 2, 18, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 12 (MAP_JUBLIFE_TV_2F) warp 3
    WorkSetConst PL_ELEVATOR_FROM, 2  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 2
    pl_GoToIf 1, P18_026E
    pl_CompareVarToValue PVAR_40CE, 2
    pl_CallIf 2, P18_022F
    pl_CompareVarToValue PVAR_40CE, 2
    pl_CallIf 0, P18_023A
    pl_Call P18_0245
    pl_SetVarFromValue PVAR_40CE, 2
    pl_GoTo P18_0263

P18_018D:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 15, 2, 18, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 13 (MAP_JUBLIFE_TV_3F) warp 4
    WorkSetConst PL_ELEVATOR_FROM, 1  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 1
    pl_GoToIf 1, P18_026E
    pl_CompareVarToValue PVAR_40CE, 1
    pl_CallIf 2, P18_022F
    pl_CompareVarToValue PVAR_40CE, 1
    pl_CallIf 0, P18_023A
    pl_Call P18_0245
    pl_SetVarFromValue PVAR_40CE, 1
    pl_GoTo P18_0263

P18_01DE:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 21, 2, 18, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 14 (MAP_JUBLIFE_TV_4F) warp 1
    WorkSetConst PL_ELEVATOR_FROM, 0  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 0
    pl_GoToIf 1, P18_026E
    pl_CompareVarToValue PVAR_40CE, 0
    pl_CallIf 2, P18_022F
    pl_CompareVarToValue PVAR_40CE, 0
    pl_CallIf 0, P18_023A
    pl_Call P18_0245
    pl_SetVarFromValue PVAR_40CE, 0
    pl_GoTo P18_0263

P18_022F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_SetVarFromValue PVAR_8004, 0
    pl_Return

P18_023A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_SetVarFromValue PVAR_8004, 1
    pl_Return

P18_0245:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_CloseMessage
    pl_ApplyMovement 0, P18_029C
    pl_WaitMovement
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_elevator_ride  // PlayElevatorAnimation PVAR_8004, 4
    pl_Return

P18_0263:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P18_026E:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_WaitTime 1, PVAR_800C
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P18_0285:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_WaitTime 1, PVAR_800C
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P18_029C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSet PL_ELEVATOR_FROM, PVAR_40CE  // the floor the player came from
    VMHalt

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
