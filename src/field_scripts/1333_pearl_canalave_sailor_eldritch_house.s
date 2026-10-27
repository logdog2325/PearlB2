// MAP_CANALAVE_SAILOR_ELDRITCH_HOUSE: Pearl script file 46, text bank 57. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P46_S1
    ScriptEntry P46_S2
    ScriptEntry P46_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P46_S1:
P46_000E:
    pl_CompareVarToValue PVAR_4106, 0
    pl_GoToIf 1, P46_0037
    pl_CompareVarToValue PVAR_4106, 3
    pl_CallIf 1, P46_0073
    pl_CompareVarToValue PVAR_4106, 1
    pl_CallIf 4, P46_007B

P46_0035:
    pl_End

P46_0037:
    pl_CheckFlag PFLAG_012C
    pl_GoToIf 1, P46_0035
    FlagGet 2400, PVAR_4000  // CheckGameCompleted: Black 2's game clear (Pearl 0x964 = 2400 here)
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P46_0035
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P46_0035
    pl_SetVarFromValue PVAR_4106, 1
    pl_Call P46_007B
    pl_End

P46_0073:
    pl_SetVarFromValue PVAR_4106, 0
    pl_Return

P46_007B:
    pl_SetObjectEventPos 0, 8, 6, 0, -1  // object 0
    pl_SetObjectEventPos 0, 8, 6, 1, -1  // SetObjectEventDir 0 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 0, 0: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 1, 9, 6, 0, -1  // object 1
    pl_SetObjectEventPos 1, 9, 6, 2, -1  // SetObjectEventDir 1 (at the place SetObjectEventPos just gave)
    pl_Return

P46_S3:
P46_00A5:
    pl_SetVarFromVar PVAR_8008, PVAR_4106
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P46_00E5
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P46_00E5
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P46_00F8
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P46_00E5:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P46_00F8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P46_S2:
P46_010B:
    pl_CompareVarToValue PVAR_4106, 1
    pl_GoToIf 1, P46_0158
    pl_CompareVarToValue PVAR_4106, 2
    pl_GoToIf 1, P46_0158
    pl_CompareVarToValue PVAR_4106, 3
    pl_GoToIf 1, P46_0145
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P46_0145:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P46_0158:
    pl_CheckFlag PFLAG_0133
    pl_GoToIf 0, P46_01EA
    pl_CheckFlag PFLAG_011F
    pl_GoToIf 0, P46_01D9
    pl_CheckItem 453, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P46_01D9
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_SetFlag PFLAG_012C
    pl_SetVarFromValue PVAR_4106, 3
    pl_RemoveItem 453, 1, PVAR_800C
    pl_BufferPlayerName 0
    pl_msg_talk 2
    pl_msg_talk 3
    pl_PlayFanfare SEQ_ME_ASA  // Pearl SEQ_ASA
    pl_WaitFanfare
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_Call P46_01FC
    pl_msg_talk 5
    pl_Call P46_0256
    pl_msg_talk 6
    pl_Call P46_0262
    pl_msg_talk 7
    pl_CloseMessage
    pl_Call P46_026E
    pl_ReleaseAll
    pl_End

P46_01D9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P46_01EA:
    pl_SetFlag PFLAG_0133
    pl_SetVarFromValue PVAR_4106, 2
    pl_GoTo P46_01D9

P46_01FC:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ClearFlag PFLAG_0279
    pl_AddObject 2
    pl_WaitTime 5, PVAR_800C
    pl_ApplyMovement 1, P46_0294
    pl_ApplyMovement 0, P46_0294
    pl_ApplyMovement PL_PLAYER, P46_0294
    pl_WaitMovement
    pl_ApplyMovement 2, P46_02B4
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P46_02C0
    pl_WaitMovement
    pl_ApplyMovement 2, P46_02D4
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P46_029C
    pl_WaitMovement
    pl_Return

P46_0256:
    pl_ApplyMovement 2, P46_02A4
    pl_WaitMovement
    pl_Return

P46_0262:
    pl_ApplyMovement 2, P46_02AC
    pl_WaitMovement
    pl_Return

P46_026E:
    pl_ApplyMovement PL_PLAYER, P46_0294
    pl_ApplyMovement 2, P46_02DC
    pl_WaitMovement
    pl_SetFlag PFLAG_0279
    pl_RemoveObject 2, PFLAG_0279
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_Return

    .balign 4, 0
P46_0294:
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P46_029C:
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P46_02A4:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P46_02AC:
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P46_02B4:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P46_02C0:
    Move 0, 1  // FACE_NORTH
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P46_02D4:
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P46_02DC:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
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
