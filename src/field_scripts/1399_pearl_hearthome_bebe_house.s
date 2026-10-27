// MAP_HEARTHOME_BEBE_HOUSE: Pearl script file 112, text bank 118. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P112_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P112_S1:
P112_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0131
    pl_GoToIf 1, P112_012E
    pl_CheckFlag PFLAG_097E
    pl_GoToIf 1, P112_0033
    pl_SetFlag PFLAG_097E
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P112_0033:
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P112_0050
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P112_0050:
    pl_CheckFlag PFLAG_0132
    pl_GoToIf 1, P112_0079
    pl_SetFlag PFLAG_0132
    pl_msg_talk 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P112_0093
    pl_GoTo P112_0123

P112_0079:
    pl_msg_talk 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P112_0093
    pl_GoTo P112_0123

P112_0093:
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, P112_0118
    pl_msg_talk 4
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_msg_talk 5
    pl_WaitFanfare
    pl_GivePokemon 133, 5, 0, PVAR_800C
    pl_SetFlag PFLAG_0131
    pl_msg_talk 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P112_00E4
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P112_0112
    pl_End

P112_00E4:
    pl_CloseMessage
    pl_GetPartyCount PVAR_4000
    pl_SubVar PVAR_4000, 1
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_OpenPokemonNamingScreen PVAR_4000, PVAR_800C
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P112_0112:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P112_0118:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P112_0123:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P112_012E:
    pl_msg_talk 9
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
