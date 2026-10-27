// MAP_VALLEY_WINDWORKS_INTERIOR: Pearl script file 211, text bank 211. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P211_S1
    ScriptEntry P211_S2
    ScriptEntry P211_S3
    ScriptEntry P211_S4
    ScriptEntry P211_S5
    ScriptEntry P211_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P211_S1:
P211_001A:
    pl_SetFlag PFLAG_09C3
    pl_CompareVarToValue PVAR_4089, 2
    pl_GoToIf 4, P211_002D
    pl_End

P211_002D:
    pl_SetObjectEventPos 5, 21, 5, 3, -1  // object 5
    pl_SetObjectEventPos 5, 21, 5, 2, -1  // SetObjectEventDir 5 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 5, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 2, 18, 4, 1, -1  // object 2
    pl_SetObjectEventPos 2, 18, 4, 1, -1  // SetObjectEventDir 2 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 2, 15: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_End

P211_S2:
P211_0057:
    pl_LockAll
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 0, P211_0078
    pl_WaitMovement
    pl_RemoveObject 0, PFLAG_01C2
    pl_SetVarFromValue PVAR_40CF, 1
    pl_ReleaseAll
    pl_End

P211_S3:
P211_0080:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P211_S4:
P211_0093:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 6
    pl_GoToIf 1, P211_00B7
    pl_CompareVarToValue PVAR_8005, 7
    pl_GoToIf 1, P211_00C9
    pl_End

P211_00B7:
    pl_ApplyMovement 1, P211_02E0
    pl_WaitMovement
    pl_GoTo P211_00DB

P211_00C9:
    pl_ApplyMovement 1, P211_02F0
    pl_WaitMovement
    pl_GoTo P211_00DB

P211_00DB:
    pl_msg_sys 2
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_295, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P211_0250
    pl_msg_sys 3
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_RemoveObject 1, PFLAG_01C3
    pl_RemoveObject 6, PFLAG_01C3
    pl_RemoveObject 3, PFLAG_01C3
    pl_RemoveObject 4, PFLAG_01C3
    pl_SetFlag PFLAG_01C4
    pl_SetFlag PFLAG_01C0
    pl_SetVarFromValue PVAR_4089, 2
    pl_SetFlag PFLAG_0AA8
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 6
    pl_GoToIf 1, P211_0158
    pl_CompareVarToValue PVAR_8005, 7
    pl_GoToIf 1, P211_016A
    pl_End

P211_0158:
    pl_ApplyMovement 2, P211_0280
    pl_WaitMovement
    pl_GoTo P211_017C

P211_016A:
    pl_ApplyMovement 2, P211_028C
    pl_WaitMovement
    pl_GoTo P211_017C

P211_017C:
    pl_msg_sys 4
    pl_CloseMessage
    pl_SetFlag PFLAG_0216
    pl_ClearFlag PFLAG_0217
// SetObjectEventMovementType 5, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_AddObject 5
// LockObject 5: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 6
    pl_GoToIf 1, P211_01B9
    pl_CompareVarToValue PVAR_8005, 7
    pl_GoToIf 1, P211_01D3
    pl_End

P211_01B9:
    pl_ApplyMovement 5, P211_0258
    pl_ApplyMovement 2, P211_0298
    pl_WaitMovement
    pl_GoTo P211_01ED

P211_01D3:
    pl_ApplyMovement 5, P211_026C
    pl_ApplyMovement 2, P211_02A4
    pl_WaitMovement
    pl_GoTo P211_01ED

P211_01ED:
    pl_msg_sys 5
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 6
    pl_GoToIf 1, P211_0214
    pl_CompareVarToValue PVAR_8005, 7
    pl_GoToIf 1, P211_0226
    pl_End

P211_0214:
    pl_ApplyMovement 2, P211_02B0
    pl_WaitMovement
    pl_GoTo P211_0238

P211_0226:
    pl_ApplyMovement 2, P211_02C8
    pl_WaitMovement
    pl_GoTo P211_0238

P211_0238:
    pl_msg_sys 6
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_40CF, 2
    pl_SetFlag PFLAG_0988
    pl_ReleaseAll
    pl_End

P211_0250:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P211_S5:
P211_02FC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40CF, 3
    pl_GoToIf 4, P211_031C
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P211_031C:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P211_S6:
P211_0327:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40CF, 3
    pl_GoToIf 4, P211_0347
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P211_0347:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P211_0078:
    Move 18, 9  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P211_0258:
    Move 19, 4  // WALK_FAST_EAST
    Move 16, 1  // WALK_FAST_NORTH
    Move 19, 6  // WALK_FAST_EAST
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P211_026C:
    Move 19, 4  // WALK_FAST_EAST
    Move 16, 2  // WALK_FAST_NORTH
    Move 19, 6  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P211_0280:
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P211_028C:
    Move 13, 4  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P211_0298:
    Move 63, 6  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P211_02A4:
    Move 63, 6  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P211_02B0:
    Move 3, 1  // FACE_EAST
    Move 63, 2  // DELAY_8
    Move 2, 1  // FACE_WEST
    Move 63, 2  // DELAY_8
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P211_02C8:
    Move 3, 1  // FACE_EAST
    Move 63, 2  // DELAY_8
    Move 2, 1  // FACE_WEST
    Move 63, 2  // DELAY_8
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P211_02E0:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P211_02F0:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
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
