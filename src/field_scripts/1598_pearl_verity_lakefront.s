// MAP_VERITY_LAKEFRONT: Pearl script file 379, text bank 352. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; 7: after a Warp; 8: PearlArrive; 80: Pearl 9701
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P379_S1
    ScriptEntry P379_S2
    ScriptEntry P379_S3
    ScriptEntry P379_S4
    ScriptEntry P379_S5
    ScriptEntry P379_S6
    ScriptEntry W342_040C_S
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
    ScriptEntry PearlProxy_9701
    ScriptEntriesEnd

P379_S1:
P379_001A:
    pl_CheckFlag PFLAG_013E
    pl_GoToIf 0, P379_0032
    pl_CheckFlag PFLAG_013E
    pl_GoToIf 1, P379_0044
    pl_End

P379_0032:
    pl_SetWarpEventPos 2, 80, 840, 1
    pl_SetWarpEventPos 3, 81, 840, 1
    pl_End

P379_0044:
    pl_SetWarpEventPos 1, 80, 840, 1
    pl_SetWarpEventPos 0, 81, 840, 1
    pl_End

P379_S2:
P379_0056:
    pl_CheckFlag PFLAG_013E
    pl_GoToIf 0, P379_0032
    pl_CheckFlag PFLAG_013E
    pl_GoToIf 1, P379_0044
    pl_End

P379_S3:
P379_006E:
    pl_LockAll
    pl_ApplyMovement PL_FOLLOWER, P379_0124
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 0
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 80
    pl_GoToIf 1, P379_00D8
    pl_CompareVarToValue PVAR_8004, 81
    pl_GoToIf 1, P379_00D8
    pl_CompareVarToValue PVAR_8004, 82
    pl_GoToIf 1, P379_00D8
    pl_CompareVarToValue PVAR_8004, 83
    pl_GoToIf 1, P379_00D8
    pl_CompareVarToValue PVAR_8004, 84
    pl_GoToIf 1, P379_00D8
    pl_CompareVarToValue PVAR_8004, 85
    pl_GoToIf 1, P379_00D8
    pl_End

P379_00D8:
    pl_ApplyMovement PL_PLAYER, P379_0138
    pl_ApplyMovement PL_FOLLOWER, P379_012C
    pl_WaitMovement
    pl_GoTo P379_00F0

P379_00F0:
    pl_SetVarFromValue PVAR_4082, 1
    pl_ReleaseAll
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 8  // the rest of this Pearl script runs there (continuation 8)
    pl_Warp 421, 46, 54, 0  // Pearl map 311 (MAP_LAKE_VERITY)
    pl_ReleaseAll
    pl_End

P379_S4:
P379_0144:
    pl_LockAll
    pl_follow_hold_any  // ClearHasPartner: the follower stops while the scene moves it
    pl_follow_hold PL_FOLLOWER, 15  // Pearl SetMovementType 254, 15: the follower stops to be moved by the script
    pl_ApplyMovement PL_FOLLOWER, P379_01DC
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 2
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 80
    pl_GoToIf 1, P379_01B6
    pl_CompareVarToValue PVAR_8004, 81
    pl_GoToIf 1, P379_01B6
    pl_CompareVarToValue PVAR_8004, 82
    pl_GoToIf 1, P379_01B6
    pl_CompareVarToValue PVAR_8004, 83
    pl_GoToIf 1, P379_01B6
    pl_CompareVarToValue PVAR_8004, 84
    pl_GoToIf 1, P379_01B6
    pl_CompareVarToValue PVAR_8004, 85
    pl_GoToIf 1, P379_01B6
    pl_End

P379_01B6:
    pl_ApplyMovement PL_PLAYER, P379_01EC
    pl_ApplyMovement PL_FOLLOWER, P379_01E4
    pl_WaitMovement
    pl_GoTo P379_01CE

P379_01CE:
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start PL_FOLLOWER  // Pearl SetMovementType 254, 0x30 (follow the player)
    pl_ReleaseAll
    pl_End

P379_S5:
P379_01F4:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P379_0254
    pl_ApplyMovementF 0, P379_0234  // (the follower once it follows)
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovementF 0, P379_0248  // (the follower once it follows)
    pl_WaitMovement
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start 0  // Pearl SetMovementType 0, 0x30 (follow the player)
// SetObjectFlagIsPersistent 0, 1: not needed in Black 2
// Unused_06E : nothing in Black 2 (Pearl renames the follower 0xFE: Black 2's follower is 0xFE already)
    pl_SetVarFromValue PVAR_4082, 3
    pl_ReleaseAll
    pl_End

P379_S6:
P379_0270:
    pl_sign 3, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P379_0124:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P379_012C:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P379_0138:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P379_01DC:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P379_01E4:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P379_01EC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P379_0234:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P379_0248:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P379_0254:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- continuation 7: after the Warp at 342:040C (MAP_LAKE_VERITY)
W342_040C_S:
W342_040C_0418:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlProxy_9701:                  // Pearl global script 9701 (run by this zone's events)
    VMCall T387_2_S2
    VMHalt

// ---- Pearl global script 387:2 (a subroutine here)
T387_2_S2:
T387_2_00EC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40CB, 2
    pl_GoToIf 4, T387_2_011C
    pl_CompareVarToValue PVAR_40CB, 1
    pl_GoToIf 1, T387_2_012A
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4  // Pearl bank 378 line 8
    pl_GoTo T387_2_0138

T387_2_011C:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5  // Pearl bank 378 line 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T387_2_012A:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6  // Pearl bank 378 line 9
    pl_GoTo T387_2_0138

T387_2_0138:
    pl_WaitButton
    pl_CloseMessage
    pl_AddVar PVAR_40CB, 1
    pl_ReleaseAll
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
