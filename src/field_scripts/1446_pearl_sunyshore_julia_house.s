// MAP_SUNYSHORE_JULIA_HOUSE: Pearl script file 159, text bank 159. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P159_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P159_S1:
P159_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0AA4
    pl_GoToIf 1, P159_006A
    pl_CheckFlag PFLAG_0AA7
    pl_GoToIf 1, P159_005F
    pl_CheckFlag PFLAG_00F7
    pl_GoToIf 0, P159_004C
    pl_GetFirstNonEggInParty PVAR_8002
    pl_Call P159_0070
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P159_0136
    pl_GoTo P159_0146

P159_004C:
    pl_SetFlag PFLAG_00F7
    pl_SetFlag PFLAG_0AA7
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P159_005F:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P159_006A:
    pl_GoTo P159_012B

P159_0070:
    RTCGetWeekDay PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_00C8
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P159_00D2
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P159_00DC
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P159_00E6
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P159_00F0
    pl_CompareVarToValue PVAR_800C, 5
    pl_GoToIf 1, P159_00FA
    pl_GoTo P159_0104

P159_00C8:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 65: not translated yet
    pl_Return

P159_00D2:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 59: not translated yet
    pl_Return

P159_00DC:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 60: not translated yet
    pl_Return

P159_00E6:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 61: not translated yet
    pl_Return

P159_00F0:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 62: not translated yet
    pl_Return

P159_00FA:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 63: not translated yet
    pl_Return

P159_0104:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 64: not translated yet
    pl_Return

P159_010E:
    pl_BufferPartyMonSpecies 1, PVAR_8002
    pl_BufferPlayerName 2
    pl_msg_talk 4
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_msg_talk 5
    pl_WaitFanfare
    pl_msg_talk 6
    pl_GoTo P159_012B

P159_012B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P159_0136:
    pl_BufferPartyMonSpecies 1, PVAR_8002
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P159_0146:
    RTCGetWeekDay PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_019E
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P159_01F2
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P159_0246
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P159_029A
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P159_02EE
    pl_CompareVarToValue PVAR_800C, 5
    pl_GoToIf 1, P159_0342
    pl_GoTo P159_0396

P159_019E:
    pl_msg_talk 20
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32768: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_03EA
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32768: not translated yet
    pl_msg_talk 21
    pl_SetFlag PFLAG_0AA4
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 65: not translated yet
    pl_stub BufferRibbonName  // Pearl 0x232 GetRibbonName 3, 65: not translated yet
    pl_GoTo P159_010E

P159_01F2:
    pl_msg_talk 2
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32768: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_03EA
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32768: not translated yet
    pl_msg_talk 3
    pl_SetFlag PFLAG_0AA4
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 59: not translated yet
    pl_stub BufferRibbonName  // Pearl 0x232 GetRibbonName 3, 59: not translated yet
    pl_GoTo P159_010E

P159_0246:
    pl_msg_talk 10
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32768: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_03EA
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32768: not translated yet
    pl_msg_talk 11
    pl_SetFlag PFLAG_0AA4
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 60: not translated yet
    pl_stub BufferRibbonName  // Pearl 0x232 GetRibbonName 3, 60: not translated yet
    pl_GoTo P159_010E

P159_029A:
    pl_msg_talk 12
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32768: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_03EA
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32768: not translated yet
    pl_msg_talk 13
    pl_SetFlag PFLAG_0AA4
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 61: not translated yet
    pl_stub BufferRibbonName  // Pearl 0x232 GetRibbonName 3, 61: not translated yet
    pl_GoTo P159_010E

P159_02EE:
    pl_msg_talk 14
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32768: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_03EA
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32768: not translated yet
    pl_msg_talk 15
    pl_SetFlag PFLAG_0AA4
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 62: not translated yet
    pl_stub BufferRibbonName  // Pearl 0x232 GetRibbonName 3, 62: not translated yet
    pl_GoTo P159_010E

P159_0342:
    pl_msg_talk 16
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32768: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_03EA
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32768: not translated yet
    pl_msg_talk 17
    pl_SetFlag PFLAG_0AA4
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 63: not translated yet
    pl_stub BufferRibbonName  // Pearl 0x232 GetRibbonName 3, 63: not translated yet
    pl_GoTo P159_010E

P159_0396:
    pl_msg_talk 18
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32768: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P159_03EA
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32768: not translated yet
    pl_msg_talk 19
    pl_SetFlag PFLAG_0AA4
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 64: not translated yet
    pl_stub BufferRibbonName  // Pearl 0x232 GetRibbonName 3, 64: not translated yet
    pl_GoTo P159_010E

P159_03EA:
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
