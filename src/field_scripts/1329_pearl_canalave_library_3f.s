// MAP_CANALAVE_LIBRARY_3F: Pearl script file 42, text bank 53. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-12: Pearl's; no warp continuations; 13: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P42_S1
    ScriptEntry P42_S2
    ScriptEntry P42_S3
    ScriptEntry P42_S4
    ScriptEntry P42_S5
    ScriptEntry P42_S6
    ScriptEntry P42_S7
    ScriptEntry P42_S8
    ScriptEntry P42_S9
    ScriptEntry P42_S10
    ScriptEntry P42_S11
    ScriptEntry P42_S12
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P42_S1:
P42_0032:
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P42_0052
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P42_005A
    pl_End

P42_0052:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P42_005A:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P42_S2:
P42_0062:
    pl_LockAll
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 4, P42_02D4
    pl_ApplyMovement PL_PLAYER, P42_0298
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    EvCameraInit  // AddFreeCamera 7, 7: Black 2's event camera on that tile
    EvCameraUnbind
    EvCameraMoveTo 9688, 0, 0xed000, 491520, -8192, 491520, 1
    EvCameraWait
    EvCameraMoveTo 9688, 0, 0xed000, 688128, -8192, 491520, 48  // ApplyMovement 0xF1 P42_02B0: the free camera walks to (10, 7)
    EvCameraWait
    pl_WaitMovement
    pl_WaitTime 30, PVAR_800C
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement 4, P42_02C0
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 2
    pl_BufferRivalName 0
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement 4, P42_02CC
    pl_WaitMovement
    pl_WaitTime 10, PVAR_800C
    pl_BufferPlayerName 0
    pl_msg_sys 4
    pl_CloseMessage
    pl_ApplyMovement 2, P42_0250
    pl_WaitMovement
    pl_msg_sys 5
    pl_CloseMessage
    pl_ApplyMovement 2, P42_025C
    pl_WaitMovement
    pl_msg_sys 6
    pl_BufferRivalName 0
    pl_msg_sys 7
    pl_msg_sys 8
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_0116
    pl_GoTo P42_0124

P42_0116:
    pl_BufferPlayerName 0
    pl_msg_sys 9
    pl_GoTo P42_0132

P42_0124:
    pl_BufferPlayerName 0
    pl_msg_sys 10
    pl_GoTo P42_0132

P42_0132:
    pl_msg_sys 11
    pl_CloseMessage
    pl_ApplyMovement 2, P42_0268
    pl_ApplyMovement 3, P42_0334
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_0162
    pl_GoTo P42_0173

P42_0162:
    pl_msg_sys 12
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 13
    pl_GoTo P42_0184

P42_0173:
    pl_msg_sys 14
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 15
    pl_GoTo P42_0184

P42_0184:
    pl_CloseMessage
    pl_ApplyMovement 2, P42_0270
    pl_ApplyMovement 3, P42_033C
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 16
    pl_CloseMessage
    pl_ApplyMovement 4, P42_0308
    pl_WaitMovement
    pl_msg_sys 17
    pl_CloseMessage
    pl_ApplyMovement 4, P42_0310
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 18
    pl_CloseMessage
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    EvCameraReturn 1  // (the free camera ends for the shake: Black 2 shakes the bound camera)
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    pl_ShakeCamera 1  // Pearl ShakeCamera 1
    EvCameraInit  // the free camera again at (10, 7)
    EvCameraUnbind
    EvCameraMoveTo 9688, 0, 0xed000, 688128, -8192, 491520, 1
    EvCameraWait
    pl_msg_sys 19
    pl_CloseMessage
    pl_ApplyMovement 3, P42_0318
    pl_ApplyMovement 4, P42_02F0
    pl_ApplyMovement 2, P42_0278
    EvCameraMoveTo 9688, 0, 0xed000, 491520, -8192, 491520, 48  // ApplyMovement 0xF1 P42_02B8: the free camera walks to (7, 7)
    EvCameraWait
    pl_WaitMovement
    pl_RemoveObject 4, PFLAG_01D6
    pl_RemoveObject 3, PFLAG_01D4
    EvCameraReturn 1  // RestoreCamera: the view cuts back to the player
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    pl_ApplyMovement PL_PLAYER, P42_0248
    pl_WaitMovement
    pl_msg_sys 20
    pl_CloseMessage
    pl_StopSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_ApplyMovement 2, P42_0290
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 2, PFLAG_01D5
    pl_StopSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetVarFromValue PVAR_4078, 4
    pl_SetVarFromValue PVAR_40B2, 2
    pl_SetFlag PFLAG_00A8
    pl_SetFlag PFLAG_01CC
    pl_ClearFlag PFLAG_01D1
    pl_ClearFlag PFLAG_01D3
    pl_ClearFlag PFLAG_01D0
    pl_ReleaseAll
    pl_End

P42_S3:
P42_0344:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P42_0362
    pl_msg_talk 21
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_0362:
    pl_msg_talk 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S4:
P42_036D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P42_038B
    pl_msg_talk 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_038B:
    pl_msg_talk 24
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S5:
P42_0396:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 25
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_03CD
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_03BF
    pl_End

P42_03BF:
    pl_BufferPlayerName 0
    pl_msg_sys 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_03CD:
    pl_msg_sys 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S6:
P42_03D8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 28
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_040F
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_0401
    pl_End

P42_0401:
    pl_BufferPlayerName 0
    pl_msg_sys 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_040F:
    pl_msg_sys 30
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S7:
P42_041A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 31
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_0451
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_0443
    pl_End

P42_0443:
    pl_BufferPlayerName 0
    pl_msg_sys 32
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_0451:
    pl_msg_sys 33
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S8:
P42_045C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 34
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_0493
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_0485
    pl_End

P42_0485:
    pl_BufferPlayerName 0
    pl_msg_sys 35
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_0493:
    pl_msg_sys 36
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_0485
    pl_msg_sys 37
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_0485
    pl_msg_sys 38
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S9:
P42_04C6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 39
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_04FD
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_04EF
    pl_End

P42_04EF:
    pl_BufferPlayerName 0
    pl_msg_sys 40
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_04FD:
    pl_msg_sys 41
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_04EF
    pl_msg_sys 42
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_04EF
    pl_msg_sys 43
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S10:
P42_0530:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 44
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_0567
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_0559
    pl_End

P42_0559:
    pl_BufferPlayerName 0
    pl_msg_sys 45
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_0567:
    pl_msg_sys 46
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S11:
P42_0572:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 47
    pl_msg_sys 48
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 54, 65535, 0  // Pearl AddMenuEntry 259, 0
    ListMenuAdd 55, 65535, 1  // Pearl AddMenuEntry 260, 1
    ListMenuAdd 56, 65535, 2  // Pearl AddMenuEntry 261, 2
    ListMenuAdd 57, 65535, 3  // Pearl AddMenuEntry 262, 3
    ListMenuShow
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P42_05CF
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P42_05DA
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P42_05E5
    pl_GoTo P42_05F0

P42_05CF:
    pl_msg_sys 50
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_05DA:
    pl_msg_sys 51
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_05E5:
    pl_msg_sys 52
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_05F0:
    pl_BufferPlayerName 0
    pl_msg_sys 49
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P42_S12:
P42_05FE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 53
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P42_0248:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P42_0250:
    Move 11, 1  // WALK_SLOW_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P42_025C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P42_0268:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P42_0270:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P42_0278:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 5  // WALK_NORMAL_NORTH
    Move 14, 5  // WALK_NORMAL_WEST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P42_0290:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P42_0298:
    Move 63, 3  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P42_02B0:
    Move 11, 3  // WALK_SLOW_EAST
    MoveEnd

    .balign 4, 0
P42_02B8:
    Move 10, 3  // WALK_SLOW_WEST
    MoveEnd

    .balign 4, 0
P42_02C0:
    Move 16, 2  // WALK_FAST_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P42_02CC:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P42_02D4:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 2  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 4  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P42_02F0:
    Move 16, 2  // WALK_FAST_NORTH
    Move 18, 4  // WALK_FAST_WEST
    Move 16, 2  // WALK_FAST_NORTH
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P42_0308:
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P42_0310:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P42_0318:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 5  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P42_0334:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P42_033C:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
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
