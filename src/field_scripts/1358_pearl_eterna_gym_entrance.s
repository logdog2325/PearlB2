// MAP_ETERNA_GYM_ENTRANCE: Pearl script file 71, text bank 80. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P71_S1
    ScriptEntry P71_S2
    ScriptEntry P71_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P71_S1:
P71_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 1, P71_003C
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 1, PFLAG_023F
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ReleaseAll
    pl_End

P71_S2:
P71_0044:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P71_006A
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P71_006A:
    pl_BufferPlayerName 0
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P71_S3:
P71_0078:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckBadgeAcquired 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P71_00A2
    pl_BufferRivalName 0
    pl_BufferRivalName 1
    pl_msg_sys 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P71_00A2:
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_BufferRivalName 2
    pl_msg_sys 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P71_003C:
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
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
