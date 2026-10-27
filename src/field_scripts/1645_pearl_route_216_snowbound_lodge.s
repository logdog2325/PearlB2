// MAP_ROUTE_216_SNOWBOUND_LODGE: Pearl script file 435, text bank 455. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P435_S1
    ScriptEntry P435_S2
    ScriptEntry P435_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P435_S1:
P435_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P435_S2:
P435_0021:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P435_S3:
P435_0034:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P435_005D
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P435_0093
    pl_End

P435_005D:
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_PlayFanfare SEQ_ME_ASA  // Pearl SEQ_ASA
    pl_WaitFanfare
    pl_HealParty
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_BufferPlayerName 0
    pl_msg_sys 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P435_0093:
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
