// MAP_NEWMOON_ISLAND_EXTERIOR: Pearl script file 353, text bank 279. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; 3: after a Warp; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P353_S1
    ScriptEntry P353_S2
    ScriptEntry W45_0114_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P353_S1:
P353_000A:
    pl_SetFlag PFLAG_09E4
// SetHiddenLocation 1, 1: the Town Map's hidden island (not drawn yet)
    pl_ClearFlag PFLAG_0297
    pl_CheckFlag PFLAG_0158
    pl_CallIf 0, P353_0024
    pl_End

P353_0024:
    pl_CompareVarToValue PVAR_40F8, 2
    pl_GoToIf 5, P353_0035
    pl_SetFlag PFLAG_0297

P353_0035:
    pl_Return

P353_S2:
P353_0037:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerDir PVAR_8004
    pl_msg_talk 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P353_005D
    pl_GoTo P353_009D

P353_005D:
    pl_msg_talk 1
    pl_CloseMessage
    pl_Call P353_00A8
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P353_00C2
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, P353_00DC
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P353_00F6
    pl_BoatCutscene 0  // Pearl ShipAnimation 0, 2, 33, 44, 750: Black 2's boat demo
    RTReserveScript 25  // PearlArrive there
    pl_Warp 16, 44, 750, 2  // Pearl map 33 (MAP_CANALAVE)
    pl_ReleaseAll
    pl_End

P353_009D:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P353_00A8:
    pl_ApplyMovement 0, P353_0110
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement 0, P353_011C
    pl_WaitMovement
    pl_Return

P353_00C2:
    pl_ApplyMovement PL_PLAYER, P353_0124
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P353_011C
    pl_WaitMovement
    pl_Return

P353_00DC:
    pl_ApplyMovement PL_PLAYER, P353_0134
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P353_011C
    pl_WaitMovement
    pl_Return

P353_00F6:
    pl_ApplyMovement PL_PLAYER, P353_0140
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P353_011C
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P353_0110:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P353_011C:
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P353_0124:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P353_0134:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P353_0140:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 64, 1  // DELAY_15
    MoveEnd

// ---- continuation 3: after the Warp at 45:0114 (MAP_CANALAVE_HARBOR_INN)
W45_0114_S:
W45_0114_0120:
    pl_fade_in_black  // FadeScreen 6, 6, 1, 0x0
    pl_WaitFadeScreen
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
