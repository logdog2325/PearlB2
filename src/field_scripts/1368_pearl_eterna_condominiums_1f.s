// MAP_ETERNA_CONDOMINIUMS_1F: Pearl script file 81, text bank 89. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P81_S1
    ScriptEntry P81_S2
    ScriptEntry P81_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P81_S1:
P81_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P81_0032
    pl_GoTo P81_00B3

P81_0032:
    pl_msg_talk 1
    pl_WaitABPress
    pl_CloseMessage
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2's party select (CallPokeSelect)
    pl_GetSelectedPartySlot PVAR_800C  // the slot, 255 when cancelled (as Pearl)
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P81_00B3
    pl_SetVarFromVar PVAR_8005, PVAR_800C
    pl_GetPartyMonSpecies PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P81_00BE
    pl_stub CheckIsPartyMonOutsider  // Pearl 0x199 CheckPartyMonOTID 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P81_00C9
    pl_BufferPartyMonNickname 0, PVAR_8005
    pl_msg_talk 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P81_00D9
    pl_GoTo P81_00B3

P81_00B3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_00BE:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_00C9:
    pl_BufferPartyMonNickname 0, PVAR_8005
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_00D9:
    pl_msg_talk 3
    pl_WaitABPress
    pl_CloseMessage
    pl_SetVarFromValue PVAR_800C, 0
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_OpenPokemonNamingScreen PVAR_8005, PVAR_800C
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P81_0125
    pl_stub 2B8  // Pearl 0x2B8 Unk02B8 32773: not translated yet
    pl_BufferPartyMonNickname 0, PVAR_8005
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_0125:
    pl_BufferPartyMonNickname 0, PVAR_8005
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_S2:
P81_0135:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0086
    pl_GoToIf 1, P81_01E0
    pl_msg_talk 9
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P81_0164
    pl_GoTo P81_01D5

P81_0164:
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenPartyMenuForTrade  // Pearl 0x2A5 OpenTradeScreen : not translated yet
    pl_stub GetSelectedPartySlot  // Pearl 0x193 GetSelectedPartySlot 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P81_01D5
    pl_stub InitNPCTrade  // Pearl 0x226 NPCTradeInit 1: not translated yet
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_GetPartyMonSpecies PVAR_8004, PVAR_8005
    pl_stub GetNPCTradeRequestedSpecies  // Pearl 0x228 NPCTradeGetRequestedSpecies 32780: not translated yet
    pl_CompareVarToVar PVAR_8005, PVAR_800C
    pl_GoToIf 5, P81_01C8
    pl_stub StartNPCTrade  // Pearl 0x229 NPCTradeExecute 32772: not translated yet
    pl_stub FinishNPCTrade  // Pearl 0x22A NPCTradeEnd : not translated yet
    pl_SetFlag PFLAG_0086
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_01C8:
    pl_stub FinishNPCTrade  // Pearl 0x22A NPCTradeEnd : not translated yet
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_01D5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_01E0:
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_S3:
P81_01EB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetTimeOfDay PVAR_800C
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P81_0217
    pl_GoTo P81_020C

P81_020C:
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P81_0217:
    pl_msg_talk 15
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
