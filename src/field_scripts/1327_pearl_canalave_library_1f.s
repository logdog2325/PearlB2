// MAP_CANALAVE_LIBRARY_1F: Pearl script file 40, text bank 51. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P40_S1
    ScriptEntry P40_S2
    ScriptEntry P40_S3
    ScriptEntry P40_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P40_S1:
P40_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P40_0030
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P40_0030:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P40_S2:
P40_003B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P40_0064
    pl_msg_talk 2
    pl_FacePlayer
    pl_msg_talk 3
    pl_CloseMessage
    pl_ApplyMovement 1, P40_0074
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P40_0064:
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P40_S3:
P40_007C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P40_S4:
P40_008D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P40_0074:
    Move 0, 1  // FACE_NORTH
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
