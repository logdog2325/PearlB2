// MAP_RESORT_AREA_RIBBON_SYNDICATE_ELEVATOR: Pearl script file 1037, text bank 545. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1037_S1
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P1037_S1:
P1037_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    pl_SetVarFromVar PVAR_8008, PVAR_40CE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P1037_0034
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P1037_003F
    pl_End

P1037_0034:
    pl_BufferNumber 0, 2
    pl_GoTo P1037_004A

P1037_003F:
    pl_BufferNumber 0, 1
    pl_GoTo P1037_004A

P1037_004A:
// ShowCurrentFloor 20, 1, PVAR_40CE: no floor window in Black 2
    pl_msg_talk 0
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 5, 65535, 0  // Pearl AddMenuEntryImm 117, 0
    ListMenuAdd 6, 65535, 1  // Pearl AddMenuEntryImm 116, 1
    ListMenuAdd 7, 65535, 2  // Pearl AddMenuEntryImm 124, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P1037_008F
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P1037_00CA
    pl_GoTo P1037_0152

P1037_008F:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    pl_stub SetSpecialLocation  // Pearl SetDynamicWarp [462, 0, 18, 2, 1]
    pl_CompareVarToValue PVAR_40CE, 0
    pl_GoToIf 1, P1037_0164
    pl_SetVarFromValue PVAR_8004, 0
    pl_Call P1037_0105
    pl_SetVarFromValue PVAR_40CE, 0
    pl_GoTo P1037_0147

P1037_00CA:
    pl_WaitTime 1, PVAR_800C
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    FieldSetNextZone 576, 2, 5, 0, 3  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 461 (MAP_RESORT_AREA_RIBBON_SYNDICATE_1F) warp 1
    WorkSetConst PL_ELEVATOR_FROM, 1  // and that is now where the player came from
    pl_CompareVarToValue PVAR_40CE, 1
    pl_GoToIf 1, P1037_0164
    pl_SetVarFromValue PVAR_8004, 1
    pl_Call P1037_0105
    pl_SetVarFromValue PVAR_40CE, 1
    pl_GoTo P1037_0147

P1037_0105:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P1037_013D
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P1037_0142
    pl_CloseMessage
    pl_ApplyMovement 0, P1037_017C
    pl_WaitMovement
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_elevator_ride  // PlayElevatorAnimation PVAR_8004, 4
    pl_Return

P1037_013D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_Return

P1037_0142:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_Return

P1037_0147:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1037_0152:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_WaitTime 1, PVAR_800C
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1037_0164:
    pl_SetVarFromValue PVAR_40CE, 65535
    pl_WaitTime 1, PVAR_800C
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P1037_017C:
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
