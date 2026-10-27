// MAP_SANDGEM: Pearl script file 985, text bank 505. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-12: Pearl's; no warp continuations; 13: PearlArrive; 105: Pearl 10300
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P985_S1
    ScriptEntry P985_S2
    ScriptEntry P985_S3
    ScriptEntry P985_S4
    ScriptEntry P985_S5
    ScriptEntry P985_S6
    ScriptEntry P985_S7
    ScriptEntry P985_S8
    ScriptEntry P985_S9
    ScriptEntry P985_S10
    ScriptEntry P985_S11
    ScriptEntry P985_S12
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
    ScriptEntry PearlProxy_10300
    ScriptEntriesEnd

P985_S1:
P985_0032:
    pl_CompareVarToValue PVAR_4071, 1
    pl_CallIf 1, P985_005F
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P985_0075
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P985_007D
    pl_End

P985_005F:
    pl_SetObjectEventPos 4, 168, 845, 2, 1  // object 4
    pl_SetObjectEventPos 4, 168, 845, 0, 1  // SetObjectEventDir 4 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 4, 14: Black 2 has no command for it (the NPC keeps its own)
    pl_Return

P985_0075:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P985_007D:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P985_S2:
P985_0085:
    pl_LockAll
    pl_ApplyMovement 4, P985_03A4
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 843
    pl_GoToIf 1, P985_00E7
    pl_CompareVarToValue PVAR_8005, 844
    pl_GoToIf 1, P985_00FF
    pl_CompareVarToValue PVAR_8005, 845
    pl_GoToIf 1, P985_010F
    pl_CompareVarToValue PVAR_8005, 846
    pl_GoToIf 1, P985_011F
    pl_CompareVarToValue PVAR_8005, 847
    pl_GoToIf 1, P985_0137
    pl_CompareVarToValue PVAR_8005, 848
    pl_GoToIf 1, P985_014F
    pl_End

P985_00E7:
    pl_ApplyMovement 4, P985_03B0
    pl_ApplyMovement PL_PLAYER, P985_0474
    pl_WaitMovement
    pl_GoTo P985_0169

P985_00FF:
    pl_ApplyMovement 4, P985_03BC
    pl_WaitMovement
    pl_GoTo P985_0169

P985_010F:
    pl_ApplyMovement 4, P985_03CC
    pl_WaitMovement
    pl_GoTo P985_0169

P985_011F:
    pl_ApplyMovement 4, P985_03D4
    pl_ApplyMovement PL_PLAYER, P985_0498
    pl_WaitMovement
    pl_GoTo P985_0169

P985_0137:
    pl_ApplyMovement 4, P985_03E0
    pl_ApplyMovement PL_PLAYER, P985_04A4
    pl_WaitMovement
    pl_GoTo P985_0169

P985_014F:
    pl_ApplyMovement 4, P985_03EC
    pl_ApplyMovement PL_PLAYER, P985_04B0
    pl_WaitMovement
    pl_GoTo P985_0169

P985_0169:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P985_0189
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P985_0195
    pl_End

P985_0189:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 0
    pl_GoTo P985_01A1

P985_0195:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 2
    pl_GoTo P985_01A1

P985_01A1:
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8005, 843
    pl_GoToIf 1, P985_01F3
    pl_CompareVarToValue PVAR_8005, 844
    pl_GoToIf 1, P985_020B
    pl_CompareVarToValue PVAR_8005, 845
    pl_GoToIf 1, P985_0223
    pl_CompareVarToValue PVAR_8005, 846
    pl_GoToIf 1, P985_023B
    pl_CompareVarToValue PVAR_8005, 847
    pl_GoToIf 1, P985_0253
    pl_CompareVarToValue PVAR_8005, 848
    pl_GoToIf 1, P985_026B
    pl_End

P985_01F3:
    pl_ApplyMovement 4, P985_03F8
    pl_ApplyMovement PL_PLAYER, P985_04BC
    pl_WaitMovement
    pl_GoTo P985_0283

P985_020B:
    pl_ApplyMovement 4, P985_0404
    pl_ApplyMovement PL_PLAYER, P985_04CC
    pl_WaitMovement
    pl_GoTo P985_0283

P985_0223:
    pl_ApplyMovement 4, P985_0410
    pl_ApplyMovement PL_PLAYER, P985_04DC
    pl_WaitMovement
    pl_GoTo P985_0283

P985_023B:
    pl_ApplyMovement 4, P985_0420
    pl_ApplyMovement PL_PLAYER, P985_04F0
    pl_WaitMovement
    pl_GoTo P985_0283

P985_0253:
    pl_ApplyMovement 4, P985_0434
    pl_ApplyMovement PL_PLAYER, P985_0508
    pl_WaitMovement
    pl_GoTo P985_0283

P985_026B:
    pl_ApplyMovement 4, P985_0444
    pl_ApplyMovement PL_PLAYER, P985_0518
    pl_WaitMovement
    pl_GoTo P985_0283

P985_0283:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P985_02A3
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P985_02AC
    pl_End

P985_02A3:
    pl_msg_sys 1
    pl_GoTo P985_02B5

P985_02AC:
    pl_msg_sys 3
    pl_GoTo P985_02B5

P985_02B5:
    pl_LoadDoorAnimation 77, 168, 842  // the door at cell (5,26) tile (8,10)
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_ClearFlag PFLAG_01B5
    pl_AddObject 3
    pl_ApplyMovement 3, P985_054C
    pl_WaitMovement
    pl_ApplyMovement 3, P985_0554
    pl_WaitMovement
    pl_PlaySE SEQ_SE_WALL_HIT  // Pearl SEQ_SE_DP_WALL_HIT2
    pl_msg_sys 4
    pl_ApplyMovement 3, P985_055C
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 5
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P985_0540
    pl_ApplyMovement 4, P985_0468
    pl_ApplyMovement 3, P985_0564
    pl_WaitMovement
    pl_RemoveObject 3, PFLAG_01B5
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P985_033C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P985_034A
    pl_End

P985_033C:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 6
    pl_GoTo P985_0356

P985_034A:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 7
    pl_GoTo P985_0356

P985_0356:
    pl_CloseMessage
    pl_ApplyMovement 4, P985_0454
    pl_ApplyMovement PL_PLAYER, P985_0528
    pl_WaitMovement
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_RemoveObject 4, PFLAG_0195
    pl_SetVarFromValue PVAR_4071, 1
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 15  // the rest of this Pearl script runs there (continuation 15)
    pl_Warp 526, 7, 15, 0  // Pearl map 422 (MAP_SANDGEM_ROWANS_LAB)
    pl_ReleaseAll
    pl_End

P985_S3:
P985_0574:
    pl_LockAll
    pl_ApplyMovement 4, P985_0714
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P985_05A0
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P985_05AF
    pl_End

P985_05A0:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 8
    pl_GoTo P985_05BE

P985_05AF:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys_gendered 26, 27  // Pearl line 13, naming the counterpart: Dawn (boy) / Lucas (girl)
    pl_GoTo P985_05BE

P985_05BE:
    pl_CloseMessage
    VMCall C205_49_S49  // CallCommonScript 2048 (Pearl file 205 script 49)
    pl_ApplyMovement 4, P985_071C
    pl_ApplyMovement PL_PLAYER, P985_06DC
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P985_05F6
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P985_0605
    pl_End

P985_05F6:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 9
    pl_GoTo P985_0614

P985_0605:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 14
    pl_GoTo P985_0614

P985_0614:
    pl_CloseMessage
    pl_ApplyMovement 4, P985_0728
    pl_ApplyMovement PL_PLAYER, P985_06EC
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P985_0648
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P985_0654
    pl_End

P985_0648:
    pl_BufferPlayerName 0
    pl_msg_sys 10
    pl_GoTo P985_0660

P985_0654:
    pl_BufferPlayerName 0
    pl_msg_sys 15
    pl_GoTo P985_0660

P985_0660:
    pl_CloseMessage
    pl_ApplyMovement 4, P985_0734
    pl_ApplyMovement PL_PLAYER, P985_06F8
    pl_WaitMovement
    pl_ApplyMovement 4, P985_073C
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P985_069E
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P985_06AA
    pl_End

P985_069E:
    pl_BufferPlayerName 1
    pl_msg_sys 11
    pl_GoTo P985_06B6

P985_06AA:
    pl_BufferPlayerName 1
    pl_msg_sys 16
    pl_GoTo P985_06B6

P985_06B6:
    pl_CloseMessage
    pl_ApplyMovement 4, P985_0744
    pl_ApplyMovement PL_PLAYER, P985_0700
    pl_WaitMovement
    VMCall C205_50_S50  // CallCommonScript 2049 (Pearl file 205 script 50)
    pl_RemoveObject 4, PFLAG_0195
    pl_SetVarFromValue PVAR_4071, 2
    pl_ReleaseAll
    pl_End

P985_S4:
P985_0754:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P985_S5:
P985_0767:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P985_S6:
P985_077A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P985_S7:
P985_078D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P985_S8:
P985_07A0:
    pl_sign 21, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P985_S9:
P985_07B7:
    pl_sign 22, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P985_S10:
P985_07CE:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_sign 23, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P985_S11:
P985_07E8:
    pl_sign 24, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P985_S12:
P985_07FF:
    pl_sign 25, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P985_03A4:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
P985_03B0:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_03BC:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P985_03CC:
    Move 14, 3  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P985_03D4:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P985_03E0:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P985_03EC:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P985_03F8:
    Move 15, 5  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0404:
    Move 15, 4  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0410:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 4  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0420:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0434:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0444:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0454:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P985_0468:
    Move 62, 1  // DELAY_4
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P985_0474:
    Move 63, 3  // DELAY_8
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P985_0498:
    Move 63, 3  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_04A4:
    Move 63, 3  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_04B0:
    Move 63, 3  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_04BC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 4  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_04CC:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 15, 2  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_04DC:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_04F0:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0508:
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 15, 4  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0518:
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 15, 4  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0528:
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 2  // DELAY_8
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P985_0540:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P985_054C:
    Move 17, 1  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P985_0554:
    Move 37, 2  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P985_055C:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P985_0564:
    Move 19, 2  // WALK_FAST_EAST
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 7  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P985_06DC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 9  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_06EC:
    Move 15, 10  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_06F8:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P985_0700:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 62, 1  // DELAY_4
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P985_0714:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_071C:
    Move 15, 10  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0728:
    Move 15, 10  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P985_0734:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P985_073C:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P985_0744:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 5  // WALK_NORMAL_WEST
    Move 12, 10  // WALK_NORMAL_NORTH
    MoveEnd

PearlProxy_10300:                  // Pearl global script 10300 (run by this zone's events)
    VMCall T977_1_S1
    VMHalt

// ---- Pearl global script 205:49 (a subroutine here)
C205_49_S49:
C205_49_150B:
    pl_FadeOutBGM 1  // StopMusic
    #ifdef SEQ_PEARL_TSURETEKE
        pl_PlayMusic SEQ_PEARL_TSURETEKE  // Pearl SEQ_TSURETEKE
    #else
        pl_PlayMusic SEQ_BGM_E_TSURETEKE2  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:50 (a subroutine here)
C205_50_S50:
C205_50_1517:
    pl_FadeOutBGM 30  // FadeOutBGM to volume 0
    pl_FadeOutBGM 1  // StopMusic
    pl_PlayDefaultMusic
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 977:1 (a subroutine here)
T977_1_S1:
T977_1_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerGender PVAR_8004
    WorkSetConst PVAR_800C, 0  // CheckIsTodayPlayerBirthday: not checked
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_00E0
    pl_CheckLocalDexCompletedOrChampion PVAR_800C  // the National Pokédex at Champion (NATIONAL_DEX_AT_CHAMPION)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_005D
    pl_CheckFlag PFLAG_0145
    pl_GoToIf 0, T977_1_0239
    pl_CheckFlag PFLAG_015F
    pl_GoToIf 1, T977_1_02B5
    pl_CompareVarToValue PVAR_4098, 5
    pl_GoToIf 5, T977_1_02B5
    pl_GoTo T977_1_025E

T977_1_005D:
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T977_1_0214
    pl_CheckFlag PFLAG_00F0
    pl_GoToIf 0, T977_1_01EF
    pl_CheckFlag PFLAG_0131
    pl_GoToIf 0, T977_1_01CA
    PokeDexIsComplete PVAR_800C, 1  // CheckNationalDexCompleted (Black 2's National Dex)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_0105
    pl_GoTo T977_1_009E

T977_1_009E:
    pl_GetRandom PVAR_800C, 4
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T977_1_01A1
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T977_1_0178
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T977_1_014F
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T977_1_012A
    VMReturn  // End: the sub-script ends

T977_1_00E0:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_02E2
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_030F
    pl_GoTo T977_1_02DA

T977_1_0105:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_03A0
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_03A5
    pl_GoTo T977_1_02DA

T977_1_012A:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0396
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_039B
    pl_GoTo T977_1_02DA

T977_1_014F:
    pl_SetFlag PFLAG_0148
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_038C
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0391
    pl_GoTo T977_1_02DA

T977_1_0178:
    pl_SetFlag PFLAG_0147
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0382
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0387
    pl_GoTo T977_1_02DA

T977_1_01A1:
    pl_SetFlag PFLAG_0146
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0378
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_037D
    pl_GoTo T977_1_02DA

T977_1_01CA:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_036E
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0373
    pl_GoTo T977_1_02DA

T977_1_01EF:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0364
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0369
    pl_GoTo T977_1_02DA

T977_1_0214:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_035A
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_035F
    pl_GoTo T977_1_02DA

T977_1_0239:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0350
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0355
    pl_GoTo T977_1_02DA

T977_1_025E:
    pl_BufferPlayerName 0
    WorkSetConst PVAR_800C, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_CompareVarToValue PVAR_800C, 10
    pl_CallIf 1, T977_1_02A1
    pl_CompareVarToValue PVAR_800C, 11
    pl_CallIf 1, T977_1_02AB
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0346
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_034B
    pl_GoTo T977_1_02DA

T977_1_02A1:
    pl_BufferSpeciesName 1, 483
    pl_Return

T977_1_02AB:
    pl_BufferSpeciesName 1, 484
    pl_Return

T977_1_02B5:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_033C
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0341
    pl_GoTo T977_1_02DA

T977_1_02DA:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T977_1_02E2:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 28  // Pearl bank 496 line 10
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T977_1_0305
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_030A
    VMReturn  // End: the sub-script ends

T977_1_0305:
    pl_msg_talk 29  // Pearl bank 496 line 11
    pl_Return

T977_1_030A:
    pl_msg_talk 30  // Pearl bank 496 line 12
    pl_Return

T977_1_030F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 31  // Pearl bank 496 line 24
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T977_1_0332
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_0337
    VMReturn  // End: the sub-script ends

T977_1_0332:
    pl_msg_talk 32  // Pearl bank 496 line 25
    pl_Return

T977_1_0337:
    pl_msg_talk 33  // Pearl bank 496 line 26
    pl_Return

T977_1_033C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 34  // Pearl bank 496 line 13
    pl_Return

T977_1_0341:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 35  // Pearl bank 496 line 27
    pl_Return

T977_1_0346:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 36  // Pearl bank 496 line 0
    pl_Return

T977_1_034B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 37  // Pearl bank 496 line 14
    pl_Return

T977_1_0350:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 38  // Pearl bank 496 line 1
    pl_Return

T977_1_0355:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 39  // Pearl bank 496 line 15
    pl_Return

T977_1_035A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 40  // Pearl bank 496 line 2
    pl_Return

T977_1_035F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 41  // Pearl bank 496 line 16
    pl_Return

T977_1_0364:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 42  // Pearl bank 496 line 3
    pl_Return

T977_1_0369:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 43  // Pearl bank 496 line 17
    pl_Return

T977_1_036E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 44  // Pearl bank 496 line 4
    pl_Return

T977_1_0373:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 45  // Pearl bank 496 line 18
    pl_Return

T977_1_0378:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 46  // Pearl bank 496 line 5
    pl_Return

T977_1_037D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 47  // Pearl bank 496 line 19
    pl_Return

T977_1_0382:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 48  // Pearl bank 496 line 6
    pl_Return

T977_1_0387:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 49  // Pearl bank 496 line 20
    pl_Return

T977_1_038C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 50  // Pearl bank 496 line 7
    pl_Return

T977_1_0391:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 51  // Pearl bank 496 line 21
    pl_Return

T977_1_0396:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 52  // Pearl bank 496 line 8
    pl_Return

T977_1_039B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 53  // Pearl bank 496 line 22
    pl_Return

T977_1_03A0:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 54  // Pearl bank 496 line 9
    pl_Return

T977_1_03A5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 55  // Pearl bank 496 line 23
    pl_Return

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
