// MAP_VEILSTONE_GALACTIC_HEADQUARTERS_2F: Pearl script file 334, text bank 263. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P334_S1
    ScriptEntry P334_S2
    ScriptEntry P334_S3
    ScriptEntry P334_S4
    ScriptEntry P334_S5
    ScriptEntry P334_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P334_S1:
P334_001A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P334_003A
    pl_GoTo P334_0070

P334_003A:
    pl_BufferPlayerName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_PlayFanfare SEQ_ME_ASA  // Pearl SEQ_ASA
    pl_WaitFanfare
    pl_HealParty
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_BufferPlayerName 0
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P334_0070:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P334_S2:
P334_0076:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P334_S3:
P334_0087:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P334_S4:
P334_0098:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P334_S5:
P334_00A9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P334_S6:
P334_00BA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 7
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
