// MAP_RESORT_AREA_SOUTHEAST_HOUSE: Pearl script file 1039, text bank 547. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1039_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P1039_S1:
P1039_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00D4
    pl_GoToIf 1, P1039_002E
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 0, P1039_0044
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P1039_002E:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 0, P1039_0044
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P1039_0044:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
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
