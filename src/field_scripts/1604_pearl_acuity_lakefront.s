// MAP_ACUITY_LAKEFRONT: Pearl script file 385, text bank 358. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P385_S1
    ScriptEntry P385_S2
    ScriptEntry P385_S3
    ScriptEntry P385_S4
    ScriptEntry P385_S5
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P385_S2:
P385_0016:
    pl_CheckFlag PFLAG_00BA
    pl_GoToIf 0, P385_002E
    pl_CheckFlag PFLAG_00BA
    pl_GoToIf 1, P385_0040
    pl_End

P385_002E:
    pl_SetWarpEventPos 2, 310, 235, 2
    pl_SetWarpEventPos 3, 311, 235, 2
    pl_End

P385_0040:
    pl_SetWarpEventPos 0, 310, 235, 2
    pl_SetWarpEventPos 1, 311, 235, 2
    pl_End

P385_S1:
P385_0052:
    pl_CheckBadgeAcquired 6, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 1
    pl_CallIf 1, P385_007D
    pl_CheckFlag PFLAG_00BA
    pl_GoToIf 0, P385_002E
    pl_CheckFlag PFLAG_00BA
    pl_GoToIf 1, P385_0040
    pl_End

P385_007D:
    pl_SetObjectEventPos 0, 312, 240, 1, 2  // object 1
    pl_SetObjectEventPos 1, 308, 242, 1, 2  // object 2
    pl_Return

P385_S3:
P385_008F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 6, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P385_00B5
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P385_00B5:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P385_S4:
P385_00C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 6, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P385_00E6
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P385_00E6:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P385_S5:
P385_00F1:
    pl_sign 4, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
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
