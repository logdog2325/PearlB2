// MAP_TWINLEAF_PLAYER_HOUSE_1F: Pearl script file 979, text bank 499. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P979_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P979_S1:
P979_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0090
    pl_GoToIf 1, P979_00B0
    pl_CompareVarToValue PVAR_4095, 1
    pl_GoToIf 4, P979_0082
    pl_CheckFlag PFLAG_006E
    pl_GoToIf 1, P979_0090
    pl_CheckFlag PFLAG_00EA
    pl_GoToIf 1, P979_009E
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P979_005C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P979_006B
    pl_End

P979_005C:
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_talk 0
    pl_GoTo P979_007A

P979_006B:
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_talk 1
    pl_GoTo P979_007A

P979_007A:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P979_0082:
    pl_BufferRivalName 1
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P979_0090:
    pl_BufferRivalName 1
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P979_009E:
    pl_SetFlag PFLAG_006E
    pl_BufferRivalName 1
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P979_00B0:
    pl_BufferRivalName 1
    pl_msg_talk 5
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
