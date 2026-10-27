// MAP_SUNYSHORE_VISTA_LIGHTHOUSE_OBSERVATION_DECK: Pearl script file 165, text bank 165. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; 5: after a Warp; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P165_S1
    ScriptEntry P165_S2
    ScriptEntry P165_S3
    ScriptEntry P165_S4
    ScriptEntry W166_0050_S
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P165_S1:
P165_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P165_S2:
P165_0025:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P165_S3:
P165_0038:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_CloseMessage
    pl_stub UseVistaLighthouseBinoculars  // Pearl 0x27A UseSunyshoreBinoculars : not translated yet
    pl_ReleaseAll
    pl_End

P165_S4:
P165_004C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_msg_talk 1
    pl_msg_talk 2
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P165_0092
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P165_00AA
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P165_00C2
    pl_End

P165_0092:
    pl_ApplyMovement 2, P165_0104
    pl_ApplyMovement PL_PLAYER, P165_013C
    pl_WaitMovement
    pl_GoTo P165_00D2

P165_00AA:
    pl_ApplyMovement 2, P165_0118
    pl_ApplyMovement PL_PLAYER, P165_0148
    pl_WaitMovement
    pl_GoTo P165_00D2

P165_00C2:
    pl_ApplyMovement 2, P165_0118
    pl_WaitMovement
    pl_GoTo P165_00D2

P165_00D2:
    pl_LoadDoorAnimation 77, 6, 9  // the door at cell (0,0) tile (6,9)
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_ApplyMovement 2, P165_0130
    pl_WaitMovement
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_RemoveObject 2, PFLAG_029F
    pl_SetFlag PFLAG_0162
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P165_0104:
    Move 15, 3  // WALK_NORMAL_EAST
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 14, 3  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P165_0118:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 13, 5  // WALK_NORMAL_SOUTH
    Move 14, 3  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P165_0130:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P165_013C:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P165_0148:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

// ---- continuation 5: after the Warp at 166:0050 (MAP_SUNYSHORE_VISTA_LIGHTHOUSE_ELEVATOR)
W166_0050_S:
W166_0050_005C:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 0  // this floor's floors above (an elevator reads it)
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
