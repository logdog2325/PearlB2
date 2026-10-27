// MAP_TWINLEAF_RIVAL_HOUSE_2F: Pearl script file 982, text bank 502. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P982_S1
    ScriptEntry P982_S2
    ScriptEntry P982_S3
    ScriptEntry P982_S4
    ScriptEntry P982_S5
    ScriptEntry P982_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P982_S5:
P982_001A:
    pl_CompareVarToValue PVAR_40F9, 0
    pl_GoToIf 1, P982_0029
    pl_End

P982_0029:
// SetInitialVolumeForSequence 1030, 50: nothing in Black 2 (Black 2 sets the volume itself)
    pl_End

P982_S3:
P982_0031:
    pl_LockAll
    pl_SetVarFromValue PVAR_40F9, 1
    pl_msg_sys 1
    pl_PlayFanfare SEQ_ME_QUIZ  // Pearl SEQ_TV_END
    pl_msg_sys 2
    pl_WaitFanfare
    pl_CloseMessage
    pl_PlayDefaultMusic
    pl_ReleaseAll
    pl_End

P982_S1:
P982_004D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P982_S2:
P982_005E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_BufferPlayerName 0
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P982_S4:
P982_0072:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 4, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P982_S6:
P982_0087:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 3
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
