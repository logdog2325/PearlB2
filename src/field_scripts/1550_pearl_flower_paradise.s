// MAP_FLOWER_PARADISE: Pearl script file 302, text bank 251. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P302_S1
    ScriptEntry P302_S2
    ScriptEntry P302_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P302_S1:
P302_000E:
    pl_SetFlag PFLAG_09D5
    pl_End

P302_S2:
P302_0014:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P302_0021
    pl_End

P302_0021:
    pl_SetFlag PFLAG_026F
    pl_RemoveObject 0, PFLAG_026F
    pl_ClearFlag PFLAG_008E
    pl_End

P302_S3:
P302_002F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_PlayCry 492
    pl_msg_talk 0
    pl_CloseMessage
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 492, 30
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P302_0089
    pl_CheckDidNotCapture PVAR_800C  // Pearl 0x2BC: 1 unless caught
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P302_007A
    pl_SetFlag PFLAG_0123
    pl_ReleaseAll
    pl_End

P302_007A:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ClearFlag PFLAG_026F
    pl_ReleaseAll
    pl_End

P302_0089:
    pl_BlackOutFromWildBattle
    pl_ClearFlag PFLAG_026F
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
