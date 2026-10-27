// MAP_VALOR_LAKEFRONT: Pearl script file 381, text bank 354. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-10: Pearl's; 11: after a Warp; 12: PearlArrive; 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P381_S1
    ScriptEntry P381_S2
    ScriptEntry P381_S3
    ScriptEntry P381_S4
    ScriptEntry P381_S5
    ScriptEntry P381_S6
    ScriptEntry P381_S7
    ScriptEntry P381_S8
    ScriptEntry P381_S9
    ScriptEntry P381_S10
    ScriptEntry W382_0304_S
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10003
    ScriptEntriesEnd

P381_S1:
P381_002A:
    pl_CheckFlag PFLAG_0106
    pl_CallIf 1, P381_005A
    pl_CheckFlag PFLAG_015E
    pl_CallIf 1, P381_0088
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 0, P381_0094
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P381_00A6
    pl_End

P381_005A:
    pl_SetObjectEventPos 3, 723, 769, 0, 1  // object 5
    pl_SetObjectEventPos 3, 723, 769, 0, 1  // SetObjectEventDir 5 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 5, 14: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_Return

P381_S2:
P381_0070:
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 0, P381_0094
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P381_00A6
    pl_End

P381_0088:
    pl_SetFlag PFLAG_029B
    pl_SetVarFromValue PVAR_4112, 1
    pl_Return

P381_0094:
    pl_SetWarpEventPos 5, 713, 760, 1
    pl_SetWarpEventPos 6, 713, 761, 1
    pl_End

P381_00A6:
    pl_SetWarpEventPos 3, 713, 760, 1
    pl_SetWarpEventPos 4, 713, 761, 1
    pl_End

P381_S3:
P381_00B8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_0106
    pl_GoToIf 1, P381_0155
    pl_msg_talk 0
    pl_FacePlayer
    pl_ApplyMovement 5, P381_0228
    pl_WaitMovement
    pl_msg_talk 1
    pl_CloseMessage
    pl_GetPlayerDir PVAR_8004
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P381_0101
    pl_CompareVarToValue PVAR_8004, 0
    pl_GoToIf 1, P381_0119
    pl_GoTo P381_0129

P381_0101:
    pl_ApplyMovement 5, P381_0230
    pl_ApplyMovement PL_PLAYER, P381_01F4
    pl_WaitMovement
    pl_GoTo P381_0141

P381_0119:
    pl_ApplyMovement 5, P381_023C
    pl_WaitMovement
    pl_GoTo P381_0141

P381_0129:
    pl_ApplyMovement 5, P381_023C
    pl_ApplyMovement PL_PLAYER, P381_0200
    pl_WaitMovement
    pl_GoTo P381_0141

P381_0141:
    pl_SetPosition 5, 723, 1, 769, 0
    pl_SetFlag PFLAG_0106
    pl_ReleaseAll
    pl_End

P381_0155:
    pl_FacePlayer
    pl_msg_talk 2
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_847, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P381_01EC
    pl_msg_talk 3
    pl_CloseMessage
    pl_GetPlayerDir PVAR_8004
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P381_019C
    pl_CompareVarToValue PVAR_8004, 0
    pl_GoToIf 1, P381_01B4
    pl_GoTo P381_01C4

P381_019C:
    pl_ApplyMovement 5, P381_0244
    pl_ApplyMovement PL_PLAYER, P381_0208
    pl_WaitMovement
    pl_GoTo P381_01DC

P381_01B4:
    pl_ApplyMovement 5, P381_0250
    pl_WaitMovement
    pl_GoTo P381_01DC

P381_01C4:
    pl_ApplyMovement 5, P381_0250
    pl_ApplyMovement PL_PLAYER, P381_021C
    pl_WaitMovement
    pl_GoTo P381_01DC

P381_01DC:
    pl_RemoveObject 5, PFLAG_0239
    pl_ClearFlag PFLAG_01CB
    pl_AddObject 0
    pl_ReleaseAll
    pl_End

P381_01EC:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P381_S4:
P381_025C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P381_0287
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P381_0290
    pl_End

P381_0287:
    pl_msg_talk 5
    pl_GoTo P381_0299

P381_0290:
    pl_msg_talk 6
    pl_GoTo P381_0299

P381_0299:
    pl_msg_talk 7
    pl_SetVarFromValue PVAR_8004, 464
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 8
    pl_CloseMessage
    pl_GetPlayerDir PVAR_8004
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P381_02C8
    pl_GoTo P381_02E0

P381_02C8:
    pl_ApplyMovement 0, P381_030C
    pl_ApplyMovement PL_PLAYER, P381_032C
    pl_WaitMovement
    pl_GoTo P381_02F8

P381_02E0:
    pl_ApplyMovement 0, P381_0318
    pl_ApplyMovement PL_PLAYER, P381_033C
    pl_WaitMovement
    pl_GoTo P381_02F8

P381_02F8:
    pl_RemoveObject 0, PFLAG_01CB
    pl_SetVarFromValue PVAR_4083, 2
    pl_SetFlag PFLAG_00B7
    pl_ReleaseAll
    pl_End

P381_S5:
P381_0348:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P381_S7:
P381_035B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P381_S6:
P381_036E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckItem 451, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P381_0396
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P381_0396:
    pl_msg_talk 14
    pl_CloseMessage
    pl_RemoveItem 451, 1, PVAR_800C
    pl_ApplyMovement 8, P381_03E4
    pl_WaitMovement
    pl_LoadDoorAnimation 77, 715, 781  // the door at cell (22,24) tile (11,13)
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_ApplyMovement 8, P381_03EC
    pl_WaitMovement
    pl_RemoveObject 8, PFLAG_027B
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_ClearFlag PFLAG_027C
    pl_SetFlag PFLAG_027B
    pl_ReleaseAll
    pl_End

P381_S8:
P381_03F4:
    pl_sign 15, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P381_S9:
P381_040B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P381_S10:
P381_041E:
    pl_LockAll
    pl_ApplyMovement 9, P381_04E4
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8000, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 789
    pl_CallIf 1, P381_0499
    pl_CompareVarToValue PVAR_8001, 790
    pl_CallIf 1, P381_04A5
    pl_CompareVarToValue PVAR_8001, 791
    pl_CallIf 1, P381_04B1
    pl_ApplyMovement 9, P381_0538
    pl_ApplyMovement PL_PLAYER, P381_0540
    pl_WaitMovement
    pl_msg_sys 11
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8001, 789
    pl_CallIf 1, P381_04BD
    pl_CompareVarToValue PVAR_8001, 790
    pl_CallIf 1, P381_04C9
    pl_CompareVarToValue PVAR_8001, 791
    pl_CallIf 1, P381_04D5
    pl_ReleaseAll
    pl_End

P381_0499:
    pl_ApplyMovement 9, P381_04F0
    pl_WaitMovement
    pl_Return

P381_04A5:
    pl_ApplyMovement 9, P381_04FC
    pl_WaitMovement
    pl_Return

P381_04B1:
    pl_ApplyMovement 9, P381_0508
    pl_WaitMovement
    pl_Return

P381_04BD:
    pl_ApplyMovement 9, P381_0514
    pl_WaitMovement
    pl_Return

P381_04C9:
    pl_ApplyMovement 9, P381_0520
    pl_WaitMovement
    pl_Return

P381_04D5:
    pl_ApplyMovement 9, P381_052C
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P381_01F4:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_0200:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_0208:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_021C:
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_0228:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P381_0230:
    Move 19, 1  // WALK_FAST_EAST
    Move 16, 11  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P381_023C:
    Move 16, 10  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P381_0244:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 8, 9  // WALK_SLOW_NORTH
    MoveEnd

    .balign 4, 0
P381_0250:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 8, 9  // WALK_SLOW_NORTH
    MoveEnd

    .balign 4, 0
P381_030C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_0318:
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_032C:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_033C:
    Move 63, 1  // DELAY_8
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P381_03E4:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_03EC:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P381_04E4:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
P381_04F0:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P381_04FC:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P381_0508:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 3  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P381_0514:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P381_0520:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P381_052C:
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P381_0538:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P381_0540:
    Move 71, 1  // LOCK_DIR
    Move 14, 1  // WALK_NORMAL_WEST
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

// ---- continuation 11: after the Warp at 382:0304 (MAP_VALOR_LAKEFRONT_SEVEN_STARS_RESTAURANT)
W382_0304_S:
W382_0304_0310:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlProxy_10003:                  // Pearl global script 10003 (run by this zone's events)
    VMCall C375_4_S4
    VMHalt

// ---- Pearl global script 205:45 (a subroutine here)
C205_45_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_03B2
    VMReturn  // End: the sub-script ends

C205_45_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_45_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_45_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_45_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

C205_45_S45:
C205_45_09B7:
    pl_Call C205_45_09C1
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_45_09C1:
    pl_Call C205_45_0336
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, C205_45_09F4
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 5, C205_45_0A05
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 17  // Pearl bank 199 line 28
    pl_GoTo C205_45_0A2B

C205_45_0A05:
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A1D
    pl_BufferItemName 0, PVAR_8004
    pl_GoTo C205_45_0A22

C205_45_0A1D:
    pl_BufferItemName 0, PVAR_8004  // GetItemNamePlural

C205_45_0A22:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 18  // Pearl bank 199 line 25
    pl_GoTo C205_45_0A2B

C205_45_0A2B:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_45_1330
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A5B
    pl_BufferItemName 1, PVAR_8004
    pl_GoTo C205_45_0A60

C205_45_0A5B:
    pl_BufferItemName 1, PVAR_8004  // GetItemNamePlural

C205_45_0A60:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_0AE7
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_0AD6
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_0B2B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_0B1A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_0B3C
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_0AF8
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_0B09
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_0B4D
    VMReturn  // End: the sub-script ends

C205_45_0AD6:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AE7:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AF8:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B09:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B1A:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B2B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B3C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B4D:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B5E:
    pl_Return

C205_45_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_45_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_45_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_45_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_45_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_45_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_45_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_45_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_45_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_45_13D8
    pl_Return

C205_45_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_45_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 375:4 (a subroutine here)
C375_4_S4:
C375_4_0324:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, C375_4_037F
    pl_CheckBadgeAcquired 6, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_037F
    FlagGet PL_FOLLOW_FLAG, PVAR_800C  // CheckHasPartner: 1 while a partner follows
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C375_4_038E
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 30  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 12 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 689
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 781
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 3
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (689, 781) to (692, 781)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 692
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 781
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 2
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (692, 781) to (689, 781)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    WorkCmpConst PL_TMP, 709
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP2, 781
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP3, 3
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc2  // from (709, 781) to (712, 781)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc2_next:
    WorkCmpConst PL_TMP, 711
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP2, 781
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP3, 2
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc3  // from (711, 781) to (708, 781)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc3_next:
    WorkCmpConst PL_TMP, 697
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP2, 781
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc4  // from (697, 781) to (697, 785)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc4_next:
    WorkCmpConst PL_TMP, 697
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP2, 785
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc5  // from (697, 785) to (697, 781)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc5_next:
    WorkCmpConst PL_TMP, 708
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP2, 781
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc6  // from (708, 781) to (708, 785)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc6_next:
    WorkCmpConst PL_TMP, 708
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP2, 785
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc7  // from (708, 785) to (708, 781)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc7_next:
    WorkCmpConst PL_TMP, 694
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP2, 785
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc8  // from (694, 785) to (694, 789)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc8_next:
    WorkCmpConst PL_TMP, 694
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP2, 789
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc9  // from (694, 789) to (694, 785)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc9_next:
    WorkCmpConst PL_TMP, 720
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP2, 796
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc10  // from (720, 796) to (720, 799)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc10_next:
    WorkCmpConst PL_TMP, 720
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP2, 798
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc11  // from (720, 798) to (720, 795)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc11_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 55, 1
        Move 19, 1
        Move 55, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 54, 1
        Move 18, 1
        Move 54, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc2:
        Move 55, 1
        Move 19, 1
        Move 55, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc3:
        Move 54, 1
        Move 18, 1
        Move 54, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc4:
        Move 53, 1
        Move 17, 2
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc5:
        Move 52, 1
        Move 16, 2
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc6:
        Move 53, 1
        Move 17, 2
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc7:
        Move 52, 1
        Move 16, 2
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc8:
        Move 53, 1
        Move 17, 2
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc9:
        Move 52, 1
        Move 16, 2
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc10:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc11:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 336  // GetCurrentMapID: Pearl map 336
// CreateJournalEvent 26, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo C375_4_055F

C375_4_055F:
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
