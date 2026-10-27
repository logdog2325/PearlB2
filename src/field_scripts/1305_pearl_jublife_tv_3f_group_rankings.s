// MAP_JUBLIFE_TV_3F_GROUP_RANKINGS: Pearl script file 17, text bank 31. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P17_S1
    ScriptEntry P17_S2
    ScriptEntry P17_S3
    ScriptEntry P17_S4
    ScriptEntry P17_S5
    ScriptEntry P17_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P17_S1:
P17_001A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub StartRankingsMachine  // Pearl 0x1B5 Unk01B5 3: not translated yet
    pl_ReleaseAll
    pl_End

P17_S2:
P17_0028:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub StartRankingsMachine  // Pearl 0x1B5 Unk01B5 4: not translated yet
    pl_ReleaseAll
    pl_End

P17_S3:
P17_0036:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub StartRankingsMachine  // Pearl 0x1B5 Unk01B5 5: not translated yet
    pl_ReleaseAll
    pl_End

P17_S4:
P17_0044:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P17_S5:
P17_0057:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P17_S6:
P17_006A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
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
