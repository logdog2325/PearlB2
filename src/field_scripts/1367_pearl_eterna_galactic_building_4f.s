// MAP_ETERNA_GALACTIC_BUILDING_4F: Pearl script file 80, text bank 88. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P80_S1
    ScriptEntry P80_S2
    ScriptEntry P80_S3
    ScriptEntry P80_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P80_S1:
P80_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_ApplyMovement 2, P80_014C
    pl_WaitMovement
    pl_msg_talk 0
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_406, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P80_0146
    pl_msg_talk 1
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_RemoveObject 0, PFLAG_021B
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerDir PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_GoToIf 1, P80_00A1
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P80_00BB
    pl_CompareVarToValue PVAR_8004, 2
    pl_GoToIf 1, P80_00D5
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P80_00E7
    pl_End

P80_00A1:
    pl_ApplyMovement 2, P80_0154
    pl_ApplyMovement PL_PLAYER, P80_018C
    pl_WaitMovement
    pl_GoTo P80_0101

P80_00BB:
    pl_ApplyMovement 2, P80_0164
    pl_ApplyMovement PL_PLAYER, P80_019C
    pl_WaitMovement
    pl_GoTo P80_0101

P80_00D5:
    pl_ApplyMovement 2, P80_0174
    pl_WaitMovement
    pl_GoTo P80_0101

P80_00E7:
    pl_ApplyMovement 2, P80_0180
    pl_ApplyMovement PL_PLAYER, P80_01AC
    pl_WaitMovement
    pl_GoTo P80_0101

P80_0101:
    pl_msg_actor 4, 2
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_SetFlag PFLAG_021B
    pl_SetFlag PFLAG_0081
    pl_ClearFlag PFLAG_01B0
    pl_ClearFlag PFLAG_021E
    pl_ClearFlag PFLAG_021C
    pl_RemoveObject 2, PFLAG_021D
    pl_RemoveObject 1, PFLAG_021D
    pl_RemoveObject 3, PFLAG_021D
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetFlag PFLAG_0987
    pl_ReleaseAll
    pl_End

P80_0146:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P80_S2:
P80_01B4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 35
    pl_msg_talk 2
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P80_S3:
P80_01D3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 427
    pl_msg_talk 5
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P80_S4:
P80_01F2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0081
    pl_GoToIf 1, P80_0210
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P80_0210:
    pl_msg_actor 4, 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P80_014C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P80_0154:
    Move 63, 1  // DELAY_8
    Move 15, 2  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P80_0164:
    Move 63, 1  // DELAY_8
    Move 15, 2  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P80_0174:
    Move 63, 1  // DELAY_8
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P80_0180:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P80_018C:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 62, 1  // DELAY_4
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P80_019C:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 62, 1  // DELAY_4
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P80_01AC:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
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
