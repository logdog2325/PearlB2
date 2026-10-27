// MAP_HEARTHOME_SOUTHEAST_HOUSE_ELEVATOR: Pearl script file 102, text bank 108. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P102_S1
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P102_S1:
P102_0006:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P102_00B8
    pl_WaitMovement
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    pl_SetVarFromVar PVAR_8008, PVAR_40CE
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P102_0038
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P102_006A
    pl_End

P102_0038:
    pl_SetVarFromValue PVAR_8004, 0
    pl_Call P102_009C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 3  // the rest of this Pearl script runs there (continuation 3)
    pl_Warp 568, 18, 3, 1  // Pearl map 104 (MAP_HEARTHOME_SOUTHEAST_HOUSE_2F)
    pl_ReleaseAll
    pl_End

P102_006A:
    pl_SetVarFromValue PVAR_8004, 1
    pl_Call P102_009C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 3  // the rest of this Pearl script runs there (continuation 3)
    pl_Warp 156, 18, 3, 1  // Pearl map 103 (MAP_HEARTHOME_SOUTHEAST_HOUSE_1F)
    pl_ReleaseAll
    pl_End

P102_009C:
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_elevator_ride  // PlayElevatorAnimation PVAR_8004, 4
    pl_ApplyMovement PL_PLAYER, P102_00C4
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_Return

    .balign 4, 0
P102_00B8:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P102_00C4:
    Move 13, 2  // WALK_NORMAL_SOUTH
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
