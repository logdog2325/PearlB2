// MAP_VEILSTONE_GALACTIC_HEADQUARTERS_3F: Pearl script file 335, text bank 264. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P335_S1
    ScriptEntry P335_S2
    ScriptEntry P335_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P335_S1:
P335_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P335_S2:
P335_0021:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckItem 440, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P335_0049
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P335_0049:
    pl_msg_talk 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P335_006C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P335_00A0
    pl_End

P335_006C:
    pl_BufferPlayerName 0
    pl_msg_talk 3
    pl_WaitButton
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlaySE SEQ_SE_OPEN1  // Pearl SEQ_SE_DP_DOOR10
    pl_ApplyMovement 5, P335_00A8
    pl_ApplyMovement 6, P335_00B0
    pl_WaitMovement
    pl_SetFlag PFLAG_0243
    pl_RemoveObject 5, PFLAG_0243
    pl_RemoveObject 6, PFLAG_0243
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P335_00A0:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P335_S3:
P335_00B8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P335_00A8:
    Move 18, 1  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P335_00B0:
    Move 19, 1  // WALK_FAST_EAST
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
