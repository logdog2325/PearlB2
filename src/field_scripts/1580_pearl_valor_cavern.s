// MAP_VALOR_CAVERN: Pearl script file 348, text bank 275. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P348_S1
    ScriptEntry P348_S2
    ScriptEntry P348_S3
    ScriptEntry P348_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P348_S1:
P348_0012:
    pl_SetFlag PFLAG_09E1
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 0, P348_002E
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P348_0038
    pl_End

P348_002E:
    pl_SetWarpEventPos 1, 10, 29, 1
    pl_End

P348_0038:
    pl_SetWarpEventPos 0, 10, 29, 1
    pl_End

P348_S2:
P348_0042:
    pl_SetFlag PFLAG_09E1
    pl_CheckFlag PFLAG_008E
    pl_CallIf 1, P348_0069
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 0, P348_002E
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P348_0038
    pl_End

P348_0069:
    pl_SetFlag PFLAG_01FE
    pl_RemoveObject 0, PFLAG_01FE
    pl_ClearFlag PFLAG_008E
    pl_Return

P348_S3:
P348_0077:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_PlayCry 482
    pl_msg_talk 3
    pl_CloseMessage
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 482, 50
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P348_00CD
    pl_CheckLostBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P348_00C2
    pl_SetFlag PFLAG_0126
    pl_ReleaseAll
    pl_End

P348_00C2:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P348_00CD:
    pl_BlackOutFromWildBattle
    pl_ReleaseAll
    pl_End

P348_S4:
P348_00D3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 0
    pl_CloseMessage
    pl_FacePlayer
    pl_ApplyMovement 1, P348_013C
    pl_WaitMovement
    pl_WaitTime 30, PVAR_800C
    pl_msg_talk 1
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_408, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P348_0144
    pl_msg_talk 2
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_RemoveObject 1, PFLAG_01DA
    pl_SetFlag PFLAG_013E
    pl_SetFlag PFLAG_0984
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P348_0144:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P348_013C:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
