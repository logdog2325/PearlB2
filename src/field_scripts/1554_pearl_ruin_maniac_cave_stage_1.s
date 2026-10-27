// MAP_RUIN_MANIAC_CAVE_STAGE_1: Pearl script file 312, text bank 254. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P312_S1
    ScriptEntry P312_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P312_S1:
P312_000A:
    pl_SetFlag PFLAG_09D8
    pl_End

P312_S2:
P312_0010:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub GetUnownFormsSeenCount  // Pearl 0x284 CountSeenUnown 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 10
    pl_GoToIf 4, P312_0034
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P312_0034:
    pl_msg_talk 1
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
