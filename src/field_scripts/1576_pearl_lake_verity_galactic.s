// MAP_LAKE_VERITY_GALACTIC: Pearl script file 343, text bank 271. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; no warp continuations; 8: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P343_S1
    ScriptEntry P343_S2
    ScriptEntry P343_S3
    ScriptEntry P343_S4
    ScriptEntry P343_S5
    ScriptEntry P343_S6
    ScriptEntry P343_S7
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P343_S1:
P343_001E:
    pl_CheckFlag PFLAG_00BA
    pl_CallIf 1, P343_009D
    pl_CheckFlag PFLAG_00BA
    pl_CallIf 0, P343_0087
    pl_CompareVarToValue PVAR_4097, 0
    pl_CallIf 1, P343_0071
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P343_0061
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P343_0069
    pl_End

P343_0061:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P343_0069:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P343_0071:
    pl_SetObjectEventPos 4, 46, 50, 3, 1  // object 5
// SetObjectEventMovementType 5, 14: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 4, 46, 50, 0, 1  // SetObjectEventDir 5 (at the place SetObjectEventPos just gave)
    pl_Return

P343_0087:
    pl_SetObjectEventPos 4, 46, 51, 3, 1  // object 5
// SetObjectEventMovementType 5, 15: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 4, 46, 51, 1, 1  // SetObjectEventDir 5 (at the place SetObjectEventPos just gave)
    pl_Return

P343_009D:
    pl_SetObjectEventPos 4, 50, 37, 3, 1  // object 5
// SetObjectEventMovementType 5, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 4, 50, 37, 2, 1  // SetObjectEventDir 5 (at the place SetObjectEventPos just gave)
    pl_SetObjectEventPos 5, 50, 39, 3, 1  // object 6
// SetObjectEventMovementType 6, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 5, 50, 39, 2, 1  // SetObjectEventDir 6 (at the place SetObjectEventPos just gave)
    pl_Return

P343_S2:
P343_00C7:
    pl_End

P343_S3:
P343_00CB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_00BA
    pl_GoToIf 1, P343_0128
    pl_ApplyMovement 5, P343_01C8
    pl_WaitMovement
    pl_msg_talk 6
    pl_FacePlayer
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P343_0104
    pl_GoTo P343_0112

P343_0104:
    pl_BufferPlayerName 0
    pl_msg_talk 7
    pl_GoTo P343_0120

P343_0112:
    pl_BufferPlayerName 0
    pl_msg_talk 9
    pl_GoTo P343_0120

P343_0120:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P343_0128:
    pl_FacePlayer
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P343_S4:
P343_013B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00BA
    pl_GoToIf 1, P343_018B
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P343_0167
    pl_GoTo P343_0175

P343_0167:
    pl_BufferPlayerName 0
    pl_msg_talk 11
    pl_GoTo P343_0183

P343_0175:
    pl_BufferPlayerName 0
    pl_msg_talk 12
    pl_GoTo P343_0183

P343_0183:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P343_018B:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P343_01A4
    pl_GoTo P343_01B2

P343_01A4:
    pl_BufferPlayerName 0
    pl_msg_talk 19
    pl_GoTo P343_01C0

P343_01B2:
    pl_BufferPlayerName 0
    pl_msg_talk 20
    pl_GoTo P343_01C0

P343_01C0:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P343_S5:
P343_01D0:
    pl_LockAll
    pl_ApplyMovement 5, P343_0220
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P343_01F5
    pl_GoTo P343_0203

P343_01F5:
    pl_BufferPlayerName 0
    pl_msg_sys 4
    pl_GoTo P343_0211

P343_0203:
    pl_BufferPlayerName 0
    pl_msg_sys 5
    pl_GoTo P343_0211

P343_0211:
    pl_SetVarFromValue PVAR_4097, 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P343_S6:
P343_0230:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_ApplyMovement 6, P343_02F4
    pl_WaitMovement
    pl_msg_talk 13
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_405, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P343_02DB
    pl_msg_talk 14
    pl_msg_talk 15
    pl_msg_talk 16
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_RemoveObject 7, PFLAG_01DE
    pl_RemoveObject 8, PFLAG_01DE
    pl_RemoveObject 0, PFLAG_01DE
    pl_RemoveObject 1, PFLAG_01DE
    pl_RemoveObject 2, PFLAG_01DE
    pl_RemoveObject 3, PFLAG_01DE
    pl_SetFlag PFLAG_098E
    pl_ApplyMovement 6, P343_02FC
    pl_ApplyMovement PL_PLAYER, P343_0304
    pl_WaitMovement
    pl_SetPosition 5, 53, 1, 39, 3
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetFlag PFLAG_00BA
    pl_ClearFlag PFLAG_01D8
    pl_ClearFlag PFLAG_0252
    pl_SetVarFromValue PVAR_40D3, 1
    pl_BufferRivalName 0
    pl_msg_actor 17, 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P343_02DB:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P343_S7:
P343_030C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P343_01C8:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P343_0220:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P343_02F4:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P343_02FC:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P343_0304:
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
