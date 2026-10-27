// MAP_SUNYSHORE_MARKET: Pearl script file 158, text bank 158. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P158_S1
    ScriptEntry P158_S2
    ScriptEntry P158_S3
    ScriptEntry P158_S4
    ScriptEntry P158_S5
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P158_S5:
P158_0014:
    pl_End

P158_S1:
P158_0016:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetFirstNonEggInParty PVAR_8000
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 0, 24: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P158_0082
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_msg_talk 0
    pl_stub GetPartyMonEVTotal  // Pearl 0x233 GetTotalPokemonEVs 32780, 32768: not translated yet
    pl_CompareVarToValue PVAR_800C, 510
    pl_GoToIf 0, P158_0077
    pl_msg_talk 1
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32768, 24: not translated yet
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_BufferPlayerName 1
    pl_msg_talk 2
    pl_WaitFanfare
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P158_0077:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P158_0082:
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P158_S2:
P158_0092:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P158_S3:
P158_00A5:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckItem 434, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P158_00D5
    pl_msg_talk 7
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_Call P158_00E0
    pl_ReleaseAll
    pl_End

P158_00D5:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P158_00E0:
    RTCGetWeekDay PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P158_016B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P158_0147
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P158_014D
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P158_0153
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P158_0159
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, P158_015F
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, P158_0165
    pl_End

P158_0147:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 0: not translated yet
    pl_Return

P158_014D:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 1: not translated yet
    pl_Return

P158_0153:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 2: not translated yet
    pl_Return

P158_0159:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 3: not translated yet
    pl_Return

P158_015F:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 4: not translated yet
    pl_Return

P158_0165:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 5: not translated yet
    pl_Return

P158_016B:
    pl_stub PokeMartSeal  // Pearl 0x14A SealsMart 6: not translated yet
    pl_Return

P158_S4:
P158_0171:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    RTCGetWeekDay PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P158_01BA
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P158_01BA
    pl_CompareVarToValue PVAR_4000, 2
    pl_GoToIf 1, P158_01BA
    pl_CompareVarToValue PVAR_4000, 3
    pl_GoToIf 1, P158_01BA
    pl_GoTo P158_01C5

P158_01BA:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P158_01C5:
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

// ---- Pearl global script 205:20 (a subroutine here)
C205_20_S20:
C205_20_0F28:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 37
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
