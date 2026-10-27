// MAP_POKEMON_LEAGUE_FLINT_ROOM: Pearl script file 186, text bank 178. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive; 52: Pearl 2037
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P186_S1
    ScriptEntry P186_S2
    ScriptEntry PearlArrive
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_2037
    ScriptEntriesEnd

P186_S1:
P186_000A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00B2
    pl_GoToIf 1, P186_0066
    pl_PlayTrainerEncounterBGM PTRAINER_263
    pl_msg_talk 0
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_263, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P186_0060
    pl_SetFlag PFLAG_00B2
    pl_PlaySE SEQ_SE_FLD_94  // Pearl SEQ_SE_DP_KI_GASYAN
    pl_RemoveObject 1, PFLAG_02A6
// CreateJournalEvent 11, 263, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P186_0060:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P186_0066:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P186_S2:
P186_0071:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P186_0094
    pl_WaitMovement
    pl_PlaySE SEQ_SE_FLD_94  // Pearl SEQ_SE_DP_KI_GASYAN
    pl_ClearFlag PFLAG_02A2
    pl_AddObject 2
    pl_SetVarFromValue PVAR_4001, 1
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P186_0094:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

PearlProxy_2037:                  // Pearl global script 2037 (run by this zone's events)
    VMCall T205_38_S38
    VMHalt

// ---- Pearl global script 205:38 (a subroutine here)
T205_38_S38:
T205_38_13DD:
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
