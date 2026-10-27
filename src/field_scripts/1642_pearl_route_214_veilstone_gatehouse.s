// MAP_ROUTE_214_VEILSTONE_GATEHOUSE: Pearl script file 432, text bank 452. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P432_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P432_S1:
P432_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub GetUnownFormsSeenCount  // Pearl 0x284 CountSeenUnown 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 26
    pl_GoToIf 4, P432_002A
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P432_002A:
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
