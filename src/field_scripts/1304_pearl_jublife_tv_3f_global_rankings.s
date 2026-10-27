// MAP_JUBLIFE_TV_3F_GLOBAL_RANKINGS: Pearl script file 16, text bank 30. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; no warp continuations; 8: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P16_S1
    ScriptEntry P16_S2
    ScriptEntry P16_S3
    ScriptEntry P16_S4
    ScriptEntry P16_S5
    ScriptEntry P16_S6
    ScriptEntry P16_S7
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P16_S1:
P16_001E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub StartRankingsMachine  // Pearl 0x1B5 Unk01B5 0: not translated yet
    pl_ReleaseAll
    pl_End

P16_S2:
P16_002C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub StartRankingsMachine  // Pearl 0x1B5 Unk01B5 1: not translated yet
    pl_ReleaseAll
    pl_End

P16_S3:
P16_003A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub StartRankingsMachine  // Pearl 0x1B5 Unk01B5 2: not translated yet
    pl_ReleaseAll
    pl_End

P16_S4:
P16_0048:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P16_S5:
P16_005B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P16_S6:
P16_006E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P16_S7:
P16_0081:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
