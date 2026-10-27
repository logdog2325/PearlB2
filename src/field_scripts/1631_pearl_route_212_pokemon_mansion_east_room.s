// MAP_ROUTE_212_POKEMON_MANSION_EAST_ROOM: Pearl script file 421, text bank 441. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; no warp continuations; 8: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P421_S1
    ScriptEntry P421_S2
    ScriptEntry P421_S3
    ScriptEntry P421_S4
    ScriptEntry P421_S5
    ScriptEntry P421_S6
    ScriptEntry P421_S7
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P421_S1:
P421_001E:
    RTCGetTime PVAR_4000, PL_TMP  // Pearl GetHour (the minute in PL_TMP)
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P421_004F
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P421_004F
    pl_CompareVarToValue PVAR_4000, 5
    pl_GoToIf 3, P421_005B
    pl_GoTo P421_004F

P421_004F:
    pl_ClearFlag PFLAG_02A9
    pl_SetVarFromValue PVAR_4116, 0
    pl_End

P421_005B:
    pl_SetFlag PFLAG_02A9
    pl_SetVarFromValue PVAR_4116, 1
    pl_End

P421_S2:
P421_0067:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0AA2
    pl_GoToIf 1, P421_0155
    pl_CompareVarToValue PVAR_400B, 1
    pl_GoToIf 1, P421_0155
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P421_00AA
    pl_GoTo P421_009F

P421_009F:
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P421_00AA:
    pl_msg_talk 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P421_00D8
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P421_00CD
    pl_End

P421_00CD:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P421_00D8:
    pl_msg_talk 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P421_00FB
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P421_00CD
    pl_End

P421_00FB:
    pl_AddTrophyGardenMon
    pl_GetTrophyGardenSlot1Species PVAR_8000
    pl_BufferSpeciesName 0, PVAR_8000
    pl_msg_talk 6
    pl_GetPlayerMapPos PVAR_8001, PVAR_8002
    pl_ApplyMovement 2, P421_01D4
    pl_WaitMovement
    pl_msg_talk 7
    pl_ApplyMovement 1, P421_01E4
    pl_WaitMovement
    pl_msg_talk 8
    pl_msg_talk 9
    pl_CloseMessage
    pl_ApplyMovement 2, P421_01F0
    pl_WaitMovement
    pl_RemoveObject 2, 0
    pl_SetVarFromValue PVAR_400B, 1
    pl_Call P421_016C
    pl_SetFlag PFLAG_0AA2
    pl_GoTo P421_0155

P421_0155:
    pl_GetTrophyGardenSlot1Species PVAR_8000
    pl_BufferSpeciesName 0, PVAR_8000
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P421_016C:
    pl_CompareVarToValue PVAR_8001, 4
    pl_GoToIf 1, P421_0199
    pl_CompareVarToValue PVAR_8001, 6
    pl_GoToIf 1, P421_01A5
    pl_CompareVarToValue PVAR_8002, 6
    pl_GoToIf 1, P421_01B1
    pl_GoTo P421_01BD

P421_0199:
    pl_ApplyMovement 1, P421_0204
    pl_WaitMovement
    pl_Return

P421_01A5:
    pl_ApplyMovement 1, P421_020C
    pl_WaitMovement
    pl_Return

P421_01B1:
    pl_ApplyMovement 1, P421_0214
    pl_WaitMovement
    pl_Return

P421_01BD:
    pl_ApplyMovement 1, P421_021C
    pl_WaitMovement
    pl_Return

P421_S3:
P421_0224:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P421_0244
    pl_GoTo P421_0270

P421_0244:
    pl_CheckFlag PFLAG_0164
    pl_GoToIf 1, P421_0270
    pl_GoTo P421_0257

P421_0257:
    pl_msg_talk 15
    pl_SetFlag PFLAG_0164
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 2, P421_01CC
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P421_0270:
    pl_CheckFlag PFLAG_0AA2
    pl_GoToIf 1, P421_0304
    FlagGet 2400, PVAR_800C  // CheckGameCompleted: Black 2's game clear (Pearl 0x964 = 2400 here)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P421_02C8
    pl_GetRandom PVAR_800C, 2
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P421_02BE
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P421_02C3
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 2, P421_01CC
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P421_02BE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 11
    pl_Return

P421_02C3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12
    pl_Return

P421_02C8:
    pl_GetRandom PVAR_800C, 2
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P421_02FA
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P421_02FF
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 2, P421_01CC
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P421_02FA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 11
    pl_Return

P421_02FF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13
    pl_Return

P421_0304:
    pl_GetTrophyGardenSlot1Species PVAR_8000
    pl_BufferSpeciesName 0, PVAR_8000
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 2, P421_01CC
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P421_S4:
P421_0325:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 3, P421_0344
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P421_S5:
P421_0354:
    pl_LockAll
    pl_ApplyMovement 3, P421_034C
    pl_WaitMovement
    pl_msg_sys 17
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P421_037C
    pl_ApplyMovement 3, P421_0344
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P421_S6:
P421_0388:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P421_S7:
P421_0399:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P421_01CC:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P421_01D4:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P421_01E4:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P421_01F0:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 1, 1  // FACE_SOUTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P421_0204:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P421_020C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P421_0214:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P421_021C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P421_0344:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P421_034C:
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P421_037C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 0, 1  // FACE_NORTH
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
