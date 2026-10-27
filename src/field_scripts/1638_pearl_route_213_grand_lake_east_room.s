// MAP_ROUTE_213_GRAND_LAKE_EAST_ROOM: Pearl script file 428, text bank 448. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P428_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P428_S1:
P428_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_GetRandom PVAR_800C, 4
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P428_0044
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P428_004F
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P428_005A
    pl_GoTo P428_0065

P428_0044:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P428_004F:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P428_005A:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P428_0065:
    pl_msg_talk 4
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
