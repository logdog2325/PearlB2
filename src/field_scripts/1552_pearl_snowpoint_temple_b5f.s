// MAP_SNOWPOINT_TEMPLE_B5F: Pearl script file 309, text bank 252. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P309_S1
    ScriptEntry P309_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P309_S1:
P309_000A:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P309_0017
    pl_End

P309_0017:
    pl_SetFlag PFLAG_0261
    pl_RemoveObject 0, PFLAG_0261
    pl_ClearFlag PFLAG_008E
    pl_End

P309_S2:
P309_0025:
    pl_LockAll
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_CheckFlag PFLAG_011A
    pl_GoToIf 1, P309_0081
    pl_CheckHasAllLegendaryTitansInParty PVAR_800C  // CheckRegis: Regirock, Regice, Registeel
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P309_0073
    pl_SetFlag PFLAG_011A
    pl_BufferPlayerName 0
    pl_msg_talk 1
    pl_CloseMessage
// ReleaseObject 0: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
// ShakeObject 0, 8, 90, 3, 0: nothing in Black 2 (no one-person shake)
// LockObject 0: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_GoTo P309_0081

P309_0073:
    pl_BufferPlayerName 0
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P309_0081:
    pl_msg_talk 2
    pl_CloseMessage
    pl_PlayCry 486
    pl_WaitCry
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 486, 70
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P309_00D1
    pl_CheckLostBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P309_00C6
    pl_SetFlag PFLAG_011B
    pl_ReleaseAll
    pl_End

P309_00C6:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P309_00D1:
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
