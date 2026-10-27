// MAP_ROUTE_226_HOUSE: Pearl script file 1048, text bank 584. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1048_S1
    ScriptEntry P1048_S2
    ScriptEntry P1048_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P1048_S1:
P1048_000E:
    pl_SetFlag PFLAG_09F1
    pl_End

P1048_S2:
P1048_0014:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00F5
    pl_GoToIf 1, P1048_00DC
    pl_CheckFlag PFLAG_00F6
    pl_GoToIf 1, P1048_0046
    pl_msg_talk 0
    pl_stub TurnOnPokedexLanguageDetection  // Pearl 0x22B UnlockForeignEntries : not translated yet
    pl_SetFlag PFLAG_00F6
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1048_0046:
    pl_msg_talk 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1048_0060
    pl_GoTo P1048_00D1

P1048_0060:
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenPartyMenuForTrade  // Pearl 0x2A5 OpenTradeScreen : not translated yet
    pl_stub GetSelectedPartySlot  // Pearl 0x193 GetSelectedPartySlot 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P1048_00D1
    pl_stub InitNPCTrade  // Pearl 0x226 NPCTradeInit 3: not translated yet
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_GetPartyMonSpecies PVAR_8004, PVAR_8005
    pl_stub GetNPCTradeRequestedSpecies  // Pearl 0x228 NPCTradeGetRequestedSpecies 32780: not translated yet
    pl_CompareVarToVar PVAR_8005, PVAR_800C
    pl_GoToIf 5, P1048_00C4
    pl_stub StartNPCTrade  // Pearl 0x229 NPCTradeExecute 32772: not translated yet
    pl_stub FinishNPCTrade  // Pearl 0x22A NPCTradeEnd : not translated yet
    pl_SetFlag PFLAG_00F5
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1048_00C4:
    pl_stub FinishNPCTrade  // Pearl 0x22A NPCTradeEnd : not translated yet
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1048_00D1:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1048_00DC:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1048_S3:
P1048_00E7:
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
