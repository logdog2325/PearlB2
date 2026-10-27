// MAP_SANDGEM_PROFESSOR_ASSISTANT_HOUSE_1F: Pearl script file 991, text bank 510. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P991_S1
    ScriptEntry P991_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P991_S1:
P991_000A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P991_002F
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P991_002F:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P991_S2:
P991_003A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P991_009A
    pl_GoTo P991_005A

P991_005A:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P991_007A
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P991_0086
    pl_End

P991_007A:
    pl_BufferPlayerName 0
    pl_msg_talk 2
    pl_GoTo P991_0092

P991_0086:
    pl_BufferPlayerName 0
    pl_msg_talk 3
    pl_GoTo P991_0092

P991_0092:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P991_009A:
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 0, P991_005A
    pl_CheckFlag PFLAG_00F0
    pl_GoToIf 1, P991_00C4
    pl_SetFlag PFLAG_00F0
// EnableSwarms : nothing in Black 2 (no Sinnoh swarms yet (notes/ENCOUNTERS.md))
    pl_BufferPlayerName 0
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P991_00C4:
    pl_BufferPlayerName 0
    WorkSetConst PVAR_4001, 0
    WorkSetConst PVAR_4000, 0  // GetSwarmMapAndSpecies
    WordSetPlaceName 1, 527  // BufferMapName 1, PVAR_4001
    pl_BufferSpeciesName 2, PVAR_4000
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P991_00FA
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P991_0103
    pl_End

P991_00FA:
    pl_msg_talk 5
    pl_GoTo P991_010F

P991_0103:
    pl_BufferPlayerName 0
    pl_msg_talk 6
    pl_GoTo P991_010F

P991_010F:
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
