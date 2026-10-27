// MAP_STARK_MOUNTAIN_INTERIOR_3: Pearl script file 278, text bank 247. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P278_S1
    ScriptEntry P278_S2
    ScriptEntry P278_S3
    ScriptEntry P278_S4
    ScriptEntry P278_S5
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P278_S1:
P278_0016:
    pl_SetVarFromVar PVAR_4000, PVAR_409E
    pl_CompareVarToValue PVAR_409E, 1
    pl_CallIf 4, P278_0031
    pl_Call P278_0037
    pl_End

P278_0031:
    pl_SetFlag PFLAG_01F9
    pl_Return

P278_0037:
    pl_CheckFlag PFLAG_0120
    pl_GoToIf 1, P278_0083
    FlagGet 2400, PVAR_4000  // CheckGameCompleted: Black 2's game clear (Pearl 0x964 = 2400 here)
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P278_0083
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P278_0083
    pl_CheckFlag PFLAG_0125
    pl_GoToIf 0, P278_0083
    pl_CompareVarToValue PVAR_409E, 1
    pl_GoToIf 5, P278_0083
    pl_ClearFlag PFLAG_01FB
    pl_Return

P278_0083:
    pl_SetFlag PFLAG_01FB
    pl_Return

P278_S2:
P278_0089:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P278_0096
    pl_End

P278_0096:
    pl_SetFlag PFLAG_01FB
    pl_RemoveObject 1, PFLAG_01FB
    pl_ClearFlag PFLAG_008E
    pl_End

P278_S3:
P278_00A4:
    pl_LockAll
    pl_ApplyMovement 2, P278_0120
    pl_WaitMovement
    pl_BufferPlayerName 1
    pl_msg_sys 0
    pl_ApplyMovement 2, P278_0128
    pl_WaitMovement
    pl_msg_sys 1
    pl_CloseMessage
    pl_RemoveObject 3, PFLAG_01FC
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_FW089: no Black 2 sound chosen yet
    pl_ShakeCamera 0  // Pearl ShakeCamera 0
    pl_stub StopSE  // Pearl sound SEQ_SE_DP_FW089: no Black 2 sound chosen yet
    pl_ApplyMovement 2, P278_0120
    pl_WaitMovement
    pl_msg_sys 2
    pl_CloseMessage
    pl_ApplyMovement 2, P278_0130
    pl_ApplyMovement PL_PLAYER, P278_0110
    pl_WaitMovement
    pl_RemoveObject 2, PFLAG_01F9
    pl_SetVarFromValue PVAR_409E, 1
    pl_SetFlag PFLAG_00D6
    pl_ClearFlag PFLAG_01F4
    pl_ReleaseAll
    pl_End

P278_S4:
P278_013C:
    pl_BufferPlayerName 1
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P278_S5:
P278_0152:
    pl_LockAll
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_CheckFlag PFLAG_00D7
    pl_CallIf 0, P278_01CB
    pl_SetVarFromValue PVAR_409E, 2
    pl_PlayCry 485
    pl_msg_talk 3
    pl_CloseMessage
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 485, 70
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P278_01BF
    pl_CheckLostBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P278_01B4
    pl_SetFlag PFLAG_0120
    pl_SetFlag PFLAG_0983
    pl_ReleaseAll
    pl_End

P278_01B4:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P278_01BF:
    pl_SetVarFromValue PVAR_409E, 1
    pl_BlackOutFromWildBattle
    pl_ReleaseAll
    pl_End

P278_01CB:
    pl_SetFlag PFLAG_00D7
    pl_Return

    .balign 4, 0
P278_0110:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P278_0120:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P278_0128:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P278_0130:
    Move 63, 1  // DELAY_8
    Move 13, 9  // WALK_NORMAL_SOUTH
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
