// MAP_LAKE_ACUITY_GALACTIC: Pearl script file 351, text bank 277. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P351_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P351_S1:
P351_0006:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    EvCameraInit  // AddFreeCamera PVAR_8004, PVAR_8005 (the player's tile): Black 2's event camera where the camera is, counted as (15, 50)
    EvCameraUnbind
    EvCameraMoveTo 9688, 0, 0xed000, 1015808, 65536, 2981888, 40  // ApplyMovement 0xF1 P351_022C: the free camera walks to (15, 45)
    EvCameraWait
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 2, P351_01C8
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 1, P351_01F0
    pl_WaitMovement
    pl_msg_sys 1
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 14
    pl_CallIf 1, P351_013A
    pl_CompareVarToValue PVAR_8004, 15
    pl_CallIf 1, P351_0158
    EvCameraReturn 1  // RestoreCamera: the view cuts back to the player
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    pl_msg_sys 2
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 14
    pl_CallIf 1, P351_016C
    pl_CompareVarToValue PVAR_8004, 15
    pl_CallIf 1, P351_0178
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 1, PFLAG_01D8
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 14
    pl_CallIf 1, P351_0184
    pl_CompareVarToValue PVAR_8004, 15
    pl_CallIf 1, P351_0190
    pl_ApplyMovement 2, P351_01D0
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement 2, P351_01D8
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    pl_ApplyMovement 2, P351_01D0
    pl_WaitMovement
    pl_msg_sys 5
    pl_CloseMessage
    pl_ApplyMovement 2, P351_01E0
    pl_ApplyMovement PL_PLAYER, P351_01BC
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 2, PFLAG_01D7
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetFlag PFLAG_098F
    pl_ClearFlag PFLAG_0241
    pl_SetFlag PFLAG_0252
    pl_SetVarFromValue PVAR_40D3, 2
    pl_ClearFlag PFLAG_01B6
    pl_SetFlag PFLAG_01B2
    pl_SetFlag PFLAG_0193
    pl_SetFlag PFLAG_02AB
    pl_SetFlag PFLAG_02AA
    pl_ClearFlag PFLAG_00A8
    pl_ReleaseAll
    pl_End

P351_013A:
    pl_ApplyMovement 1, P351_01F8
    EvCameraMoveTo 9688, 0, 0xed000, 1015808, 65536, 3309568, 40  // ApplyMovement 0xF1 P351_0234: the free camera walks to (15, 50)
    EvCameraWait
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P351_01B4
    pl_WaitMovement
    pl_Return

P351_0158:
    pl_ApplyMovement 1, P351_0208
    EvCameraMoveTo 9688, 0, 0xed000, 1015808, 65536, 3309568, 40  // ApplyMovement 0xF1 P351_0234: the free camera walks to (15, 50)
    EvCameraWait
    pl_WaitMovement
    pl_Return

P351_016C:
    pl_ApplyMovement 1, P351_0214
    pl_WaitMovement
    pl_Return

P351_0178:
    pl_ApplyMovement 1, P351_021C
    pl_WaitMovement
    pl_Return

P351_0184:
    pl_ApplyMovement PL_PLAYER, P351_019C
    pl_WaitMovement
    pl_Return

P351_0190:
    pl_ApplyMovement PL_PLAYER, P351_01A8
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P351_019C:
    Move 12, 5  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P351_01A8:
    Move 12, 5  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P351_01B4:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P351_01BC:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P351_01C8:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P351_01D0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P351_01D8:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P351_01E0:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 3  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P351_01F0:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P351_01F8:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P351_0208:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 5  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P351_0214:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P351_021C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P351_022C:
    Move 12, 5  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P351_0234:
    Move 13, 5  // WALK_NORMAL_SOUTH
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
