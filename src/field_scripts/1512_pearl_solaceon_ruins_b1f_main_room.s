// MAP_SOLACEON_RUINS_B1F_MAIN_ROOM: Pearl script file 245, text bank 231. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P245_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P245_S1:
P245_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P245_004D
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P245_005D
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P245_006D
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P245_007D
    pl_End

P245_004D:
    pl_ApplyMovement 0, P245_00A4
    pl_WaitMovement
    pl_GoTo P245_008D

P245_005D:
    pl_ApplyMovement 0, P245_00B0
    pl_WaitMovement
    pl_GoTo P245_008D

P245_006D:
    pl_ApplyMovement 0, P245_00A4
    pl_WaitMovement
    pl_GoTo P245_008D

P245_007D:
    pl_ApplyMovement 0, P245_00A4
    pl_WaitMovement
    pl_GoTo P245_008D

P245_008D:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 0, PFLAG_023D
    pl_StopSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ClearFlag PFLAG_023C
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P245_00A4:
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P245_00B0:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
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
