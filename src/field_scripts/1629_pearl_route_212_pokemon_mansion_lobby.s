// MAP_ROUTE_212_POKEMON_MANSION_LOBBY: Pearl script file 419, text bank 439. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; no warp continuations; 8: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P419_S1
    ScriptEntry P419_S2
    ScriptEntry P419_S3
    ScriptEntry P419_S4
    ScriptEntry P419_S5
    ScriptEntry P419_S6
    ScriptEntry P419_S7
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P419_S1:
P419_001E:
    pl_SetFlag PFLAG_09EB
    pl_End

P419_S2:
P419_0024:
    pl_End

P419_S3:
P419_0026:
    pl_End

P419_S4:
P419_0028:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 0, P419_009C
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P419_S5:
P419_0045:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 1, P419_00A4
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P419_S6:
P419_0062:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 2, P419_00AC
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P419_S7:
P419_007F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 3, P419_00B4
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P419_009C:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P419_00A4:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P419_00AC:
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P419_00B4:
    Move 2, 1  // FACE_WEST
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
