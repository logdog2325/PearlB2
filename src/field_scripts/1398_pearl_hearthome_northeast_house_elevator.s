// MAP_HEARTHOME_NORTHEAST_HOUSE_ELEVATOR: Pearl script file 111, text bank 117. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P111_S1
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P111_S1:
P111_0006:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P111_00B8
    pl_WaitMovement
    WorkSet PVAR_40CE, PL_ELEVATOR_FROM  // GetDynamicWarpFloorNumber: the floors above the floor the player came from (PearlElevatorInit)
    pl_SetVarFromVar PVAR_8008, PVAR_40CE
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P111_0038
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P111_006A
    pl_End

P111_0038:
    pl_SetVarFromValue PVAR_8004, 0
    pl_Call P111_009C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 5  // the rest of this Pearl script runs there (continuation 5)
    pl_Warp 574, 18, 3, 1  // Pearl map 113 (MAP_HEARTHOME_NORTHEAST_HOUSE_2F)
    pl_ReleaseAll
    pl_End

P111_006A:
    pl_SetVarFromValue PVAR_8004, 1
    pl_Call P111_009C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 10  // the rest of this Pearl script runs there (continuation 10)
    pl_Warp 167, 18, 3, 1  // Pearl map 112 (MAP_HEARTHOME_NORTHEAST_HOUSE_1F)
    pl_ReleaseAll
    pl_End

P111_009C:
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_elevator_ride  // PlayElevatorAnimation PVAR_8004, 4
    pl_ApplyMovement PL_PLAYER, P111_00C4
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_Return

    .balign 4, 0
P111_00B8:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P111_00C4:
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
