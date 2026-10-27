// MAP_SNOWPOINT_NORTHEAST_HOUSE: Pearl script file 175, text bank 172. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P175_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P175_S1:
P175_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0AAD
    pl_GoToIf 1, P175_0060
    pl_stub CheckAllToughWordsUnlocked  // Pearl 0x27F Unk027F 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P175_0076
    pl_msg_talk 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P175_006B
    pl_stub TryBufferAndUnlockRandomToughWord  // Pearl 0x27D BufferRandomTrendySaying 32780, 0: not translated yet
    pl_CompareVarToValue PVAR_800C, 65535
    pl_GoToIf 1, P175_0076
    pl_SetFlag PFLAG_0AAD
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P175_0060:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P175_006B:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P175_0076:
    MsgWinCloseAll  // another speaker: close the first window
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
