// MAP_ACUITY_CAVERN: Pearl script file 352, text bank 278. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P352_S1
    ScriptEntry P352_S2
    ScriptEntry P352_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P352_S1:
P352_000E:
    pl_SetFlag PFLAG_09E3
    pl_End

P352_S2:
P352_0014:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P352_0021
    pl_End

P352_0021:
    pl_SetFlag PFLAG_01FF
    pl_RemoveObject 0, PFLAG_01FF
    pl_ClearFlag PFLAG_008E
    pl_End

P352_S3:
P352_002F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_PlayCry 480
    pl_msg_talk 0
    pl_CloseMessage
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 480, 50
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P352_0085
    pl_CheckLostBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P352_007A
    pl_SetFlag PFLAG_0127
    pl_ReleaseAll
    pl_End

P352_007A:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P352_0085:
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
