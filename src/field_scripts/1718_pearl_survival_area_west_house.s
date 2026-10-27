// MAP_SURVIVAL_AREA_WEST_HOUSE: Pearl script file 1027, text bank 537. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1027_S1
    ScriptEntry P1027_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P1027_S1:
P1027_000A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00D7
    pl_GoToIf 1, P1027_003E
    pl_CheckFlag PFLAG_00D6
    pl_GoToIf 1, P1027_0033
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1027_0033:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1027_003E:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1027_S2:
P1027_0049:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetFlag PFLAG_0125
    pl_msg_talk 3
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 4
    pl_CallIf 1, P1027_008A
    pl_CompareVarToValue PVAR_8005, 5
    pl_CallIf 1, P1027_009E
    pl_RemoveObject 1, PFLAG_01F4
    pl_SetFlag PFLAG_00E7
    pl_SetFlag PFLAG_01F4
    pl_ReleaseAll
    pl_End

P1027_008A:
    pl_ApplyMovement PL_PLAYER, P1027_00B4
    pl_ApplyMovement 1, P1027_00CC
    pl_WaitMovement
    pl_Return

P1027_009E:
    pl_ApplyMovement PL_PLAYER, P1027_00BC
    pl_ApplyMovement 1, P1027_00DC
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P1027_00B4:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P1027_00BC:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P1027_00CC:
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 14, 4  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P1027_00DC:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 14, 3  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
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
