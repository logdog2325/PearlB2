// MAP_VEILSTONE_GALACTIC_HEADQUARTERS_4F_BACK: Pearl script file 339, text bank 268. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-14: Pearl's; no warp continuations; 15: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P339_S1
    ScriptEntry P339_S2
    ScriptEntry P339_S3
    ScriptEntry P339_S4
    ScriptEntry P339_S5
    ScriptEntry P339_S6
    ScriptEntry P339_S7
    ScriptEntry P339_S8
    ScriptEntry P339_S9
    ScriptEntry P339_S10
    ScriptEntry P339_S11
    ScriptEntry P339_S12
    ScriptEntry P339_S13
    ScriptEntry P339_S14
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P339_S1:
P339_003A:
    pl_CheckFlag PFLAG_097D
    pl_GoToIf 1, P339_0047
    pl_End

P339_0047:
    pl_SetObjectEventPos 0, 9, 6, 0, -1  // object 0
    pl_End

P339_S2:
P339_0051:
    pl_CheckFlag PFLAG_097D  // Pearl InitLakeGuardianContainmentUnits: after the release the units stay open
    pl_GoToIf 5, .Lunits51
    BMAnmPlayInv 9, 8, 10  // every unit (one shared instance) on the last frame
.Lunits51:
    pl_End

P339_S3:
P339_0055:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_097D
    pl_GoToIf 1, P339_0105
    pl_CheckFlag PFLAG_00AD
    pl_GoToIf 1, P339_0110
    pl_msg_talk 0
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_409, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P339_011B
    pl_SetFlag PFLAG_00AD
    pl_SetVarFromValue PVAR_410D, 1
    pl_msg_talk 1
    pl_CloseMessage
    pl_GetPlayerDir PVAR_8004
    pl_SetVarFromVar PVAR_4002, PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_GoToIf 1, P339_00D1
    pl_CompareVarToValue PVAR_8004, 2
    pl_GoToIf 1, P339_00E1
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P339_00F1
    pl_End

P339_00D1:
    pl_ApplyMovement 0, P339_0124
    pl_WaitMovement
    pl_GoTo P339_0101

P339_00E1:
    pl_ApplyMovement 0, P339_0130
    pl_WaitMovement
    pl_GoTo P339_0101

P339_00F1:
    pl_ApplyMovement 0, P339_013C
    pl_WaitMovement
    pl_GoTo P339_0101

P339_0101:
    pl_ReleaseAll
    pl_End

P339_0105:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_0110:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_011B:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P339_S4:
P339_0148:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_097D
    pl_GoToIf 1, P339_0164
    pl_msg_sys 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_0164:
    pl_msg_sys 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_S5:
P339_016F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_097D
    pl_GoToIf 1, P339_018B
    pl_msg_sys 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_018B:
    pl_msg_sys 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_S6:
P339_0196:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_097D
    pl_GoToIf 1, P339_01B2
    pl_msg_sys 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_01B2:
    pl_msg_sys 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_S7:
P339_01BD:
    pl_End

P339_S8:
P339_01BF:
    pl_End

P339_S9:
P339_01C1:
    pl_End

P339_S10:
P339_01C3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_097D
    pl_GoToIf 1, P339_02F1
    pl_msg_sys 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P339_01F7
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P339_02EB
    pl_End

P339_01F7:
    pl_SetVarFromValue PVAR_410D, 0
    pl_PlaySE SEQ_SE_DECIDE1  // Pearl SEQ_SE_DP_BUTTON3
    pl_BufferPlayerName 0
    pl_msg_sys 6
    pl_CloseMessage
    pl_ClearFlag PFLAG_02B3
    pl_SetFlag PFLAG_097D
// Pearl DeactivateLakeGuardianContainmentUnits: the units open (Pearl's animation 49: the glass shrinks away)
    BMCreateHandleByGPos PL_DOOR(13), 9, 8, 10
    BMCreateHandleByGPos PL_DOOR(14), 9, 2, 4
    BMCreateHandleByGPos PL_DOOR(15), 9, 14, 4
    BMHndAudioVisualAnmPlay PL_DOOR(13), 0
    BMHndAudioVisualAnmPlay PL_DOOR(14), 0
    BMHndAudioVisualAnmPlay PL_DOOR(15), 0
    BMHndAnmWait PL_DOOR(15)
    BMAnmPlayInv 9, 8, 10  // the units keep the last frame when the handles go
    BMReleaseHandle PL_DOOR(13)
    BMReleaseHandle PL_DOOR(14)
    BMReleaseHandle PL_DOOR(15)
    pl_WaitTime 30, PVAR_800C
    pl_ApplyMovement 2, P339_0314
    pl_ApplyMovement 1, P339_031C
    pl_ApplyMovement 3, P339_0324
    pl_WaitMovement
    pl_WaitTime 30, PVAR_800C
    pl_RemoveObject 2, PFLAG_0254
    pl_RemoveObject 1, PFLAG_0254
    pl_RemoveObject 3, PFLAG_0254
    pl_WaitTime 30, PVAR_800C
    pl_CompareVarToValue PVAR_4002, 0
    pl_GoToIf 1, P339_0274
    pl_CompareVarToValue PVAR_4002, 2
    pl_GoToIf 1, P339_028E
    pl_CompareVarToValue PVAR_4002, 3
    pl_GoToIf 1, P339_02A8
    pl_End

P339_0274:
    pl_ApplyMovement 0, P339_02FC
    pl_ApplyMovement PL_PLAYER, P339_032C
    pl_WaitMovement
    pl_GoTo P339_02C2

P339_028E:
    pl_ApplyMovement 0, P339_0308
    pl_ApplyMovement PL_PLAYER, P339_0334
    pl_WaitMovement
    pl_GoTo P339_02C2

P339_02A8:
    pl_ApplyMovement 0, P339_02FC
    pl_ApplyMovement PL_PLAYER, P339_032C
    pl_WaitMovement
    pl_GoTo P339_02C2

P339_02C2:
    pl_msg_sys 3
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_RemoveObject 0, PFLAG_0255
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetFlag PFLAG_0253
    pl_ReleaseAll
    pl_End

P339_02EB:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_02F1:
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_S14:
P339_033C:
    pl_LockAll
    pl_msg_sys 4
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P339_0354
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P339_S11:
P339_035C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_S12:
P339_036F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P339_S13:
P339_0382:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P339_0124:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P339_0130:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P339_013C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P339_02FC:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P339_0308:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P339_0314:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P339_031C:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P339_0324:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P339_032C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P339_0334:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P339_0354:
    Move 12, 1  // WALK_NORMAL_NORTH
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
