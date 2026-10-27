// MAP_OLD_CHATEAU_2F_ROOM_2: Pearl script file 329, text bank 261. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P329_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P329_S1:
P329_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_0149
    pl_GoToIf 1, P329_00BF
    pl_CheckFlag PFLAG_0AB0
    pl_GoToIf 1, P329_00BF
    FlagGet 2400, PVAR_800C  // CheckGameCompleted: Black 2's game clear (Pearl 0x964 = 2400 here)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P329_00BF
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P329_00BF
    pl_GetTimeOfDay PVAR_800C
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 0, P329_00BF
    pl_msg_sys 1
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P329_00B9
    pl_BufferPlayerName 0
    pl_msg_sys 2
    pl_CloseMessage
    pl_PlayCry 479
    pl_WaitCry
    pl_SetFlag PFLAG_0AB0
    pl_StartWildBattle 479, 15
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P329_00CA
    pl_CheckDidNotCapture PVAR_800C  // Pearl 0x2BC: 1 unless caught
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P329_00AE
    pl_SetFlag PFLAG_0149
    pl_ReleaseAll
    pl_End

P329_00AE:
    pl_msg_sys 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P329_00B9:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P329_00BF:
    pl_msg_sys 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P329_00CA:
    pl_BlackOutFromWildBattle
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
