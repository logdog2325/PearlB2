// MAP_VEILSTONE_DEPARTMENT_STORE_ELEVATOR: Pearl script file 142, text bank 145. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P142_S1
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P142_S1:
P142_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    pl_SetVarFromVar PVAR_8008, PVAR_40CE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P142_005B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P142_0066
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P142_0071
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P142_007C
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P142_0087
    pl_End

P142_005B:
    pl_BufferNumber 0, 5
    pl_GoTo P142_0092

P142_0066:
    pl_BufferNumber 0, 4
    pl_GoTo P142_0092

P142_0071:
    pl_BufferNumber 0, 3
    pl_GoTo P142_0092

P142_007C:
    pl_BufferNumber 0, 2
    pl_GoTo P142_0092

P142_0087:
    pl_BufferNumber 0, 1
    pl_GoTo P142_0092

P142_0092:
// ShowCurrentFloor 20, 1, PVAR_40CE: no floor window in Black 2
    pl_msg_talk 0
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 10, 65535, 0  // Pearl AddMenuEntryImm 120, 0
    ListMenuAdd 11, 65535, 1  // Pearl AddMenuEntryImm 119, 1
    ListMenuAdd 12, 65535, 2  // Pearl AddMenuEntryImm 118, 2
    ListMenuAdd 13, 65535, 3  // Pearl AddMenuEntryImm 117, 3
    ListMenuAdd 14, 65535, 4  // Pearl AddMenuEntryImm 116, 4
    ListMenuAdd 15, 65535, 5  // Pearl AddMenuEntryImm 124, 5
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P142_0246
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P142_01F7
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P142_01A8
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P142_0159
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P142_010A
    pl_GoTo P142_0368

P142_010A:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 186, 2, 15, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 137 (MAP_VEILSTONE_DEPARTMENT_STORE_1F) warp 2
    WorkSetConst PL_ELEVATOR_FROM, 4  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 4
    pl_GoToIf 1, P142_0351
    pl_CompareVarToValue PVAR_40CE, 4
    pl_CallIf 2, P142_0295
    pl_CompareVarToValue PVAR_40CE, 4
    pl_CallIf 0, P142_02A0
    pl_Call P142_02AB
    pl_SetVarFromValue PVAR_40CE, 4
    pl_GoTo P142_02C9

P142_0159:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 187, 2, 15, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 138 (MAP_VEILSTONE_DEPARTMENT_STORE_2F) warp 2
    WorkSetConst PL_ELEVATOR_FROM, 3  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 3
    pl_GoToIf 1, P142_0351
    pl_CompareVarToValue PVAR_40CE, 3
    pl_CallIf 2, P142_0295
    pl_CompareVarToValue PVAR_40CE, 3
    pl_CallIf 0, P142_02A0
    pl_Call P142_02AB
    pl_SetVarFromValue PVAR_40CE, 3
    pl_GoTo P142_02C9

P142_01A8:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 188, 2, 15, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 139 (MAP_VEILSTONE_DEPARTMENT_STORE_3F) warp 2
    WorkSetConst PL_ELEVATOR_FROM, 2  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 2
    pl_GoToIf 1, P142_0351
    pl_CompareVarToValue PVAR_40CE, 2
    pl_CallIf 2, P142_0295
    pl_CompareVarToValue PVAR_40CE, 2
    pl_CallIf 0, P142_02A0
    pl_Call P142_02AB
    pl_SetVarFromValue PVAR_40CE, 2
    pl_GoTo P142_02C9

P142_01F7:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 189, 2, 15, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 140 (MAP_VEILSTONE_DEPARTMENT_STORE_4F) warp 2
    WorkSetConst PL_ELEVATOR_FROM, 1  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 1
    pl_GoToIf 1, P142_0351
    pl_CompareVarToValue PVAR_40CE, 1
    pl_CallIf 2, P142_0295
    pl_CompareVarToValue PVAR_40CE, 1
    pl_CallIf 0, P142_02A0
    pl_Call P142_02AB
    pl_SetVarFromValue PVAR_40CE, 1
    pl_GoTo P142_02C9

P142_0246:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 190, 2, 15, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 141 (MAP_VEILSTONE_DEPARTMENT_STORE_5F) warp 1
    WorkSetConst PL_ELEVATOR_FROM, 0  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 0
    pl_GoToIf 1, P142_0351
    pl_CompareVarToValue PVAR_40CE, 0
    pl_CallIf 2, P142_0295
    pl_CompareVarToValue PVAR_40CE, 0
    pl_CallIf 0, P142_02A0
    pl_Call P142_02AB
    pl_SetVarFromValue PVAR_40CE, 0
    pl_GoTo P142_02C9

P142_0295:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_SetVarFromValue PVAR_8004, 0
    pl_Return

P142_02A0:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_SetVarFromValue PVAR_8004, 1
    pl_Return

P142_02AB:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_CloseMessage
    pl_ApplyMovement 0, P142_0380
    pl_WaitMovement
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_elevator_ride  // PlayElevatorAnimation PVAR_8004, 4
    pl_Return

P142_02C9:
    pl_SetVarFromVar PVAR_8008, PVAR_40CE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P142_0312
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P142_031D
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P142_0328
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P142_0333
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P142_033E
    pl_End

P142_0312:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 9
    pl_GoTo P142_0349

P142_031D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 8
    pl_GoTo P142_0349

P142_0328:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7
    pl_GoTo P142_0349

P142_0333:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_GoTo P142_0349

P142_033E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_GoTo P142_0349

P142_0349:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P142_0351:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_WaitTime 1, PVAR_800C
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P142_0368:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_WaitTime 1, PVAR_800C
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P142_0380:
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
