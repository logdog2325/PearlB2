// MAP_CANALAVE: Pearl script file 34, text bank 47. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-24: Pearl's; no warp continuations; 25: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P34_S1
    ScriptEntry P34_S2
    ScriptEntry P34_S3
    ScriptEntry P34_S4
    ScriptEntry P34_S5
    ScriptEntry P34_S6
    ScriptEntry P34_S7
    ScriptEntry P34_S8
    ScriptEntry P34_S9
    ScriptEntry P34_S10
    ScriptEntry P34_S11
    ScriptEntry P34_S12
    ScriptEntry P34_S13
    ScriptEntry P34_S14
    ScriptEntry P34_S15
    ScriptEntry P34_S16
    ScriptEntry P34_S17
    ScriptEntry P34_S18
    ScriptEntry P34_S19
    ScriptEntry P34_S20
    ScriptEntry P34_S21
    ScriptEntry P34_S22
    ScriptEntry P34_S23
    ScriptEntry P34_S24
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P34_S1:
P34_0062:
    pl_CompareVarToValue PVAR_40F8, 2
    pl_CallIf 1, P34_00F0
    pl_CompareVarToValue PVAR_40F8, 3
    pl_CallIf 1, P34_00F8
    pl_Call P34_0160
    pl_CompareVarToValue PVAR_4000, 0
    pl_CallIf 1, P34_01DF
    pl_CompareVarToValue PVAR_4000, 1
    pl_CallIf 1, P34_010E
    pl_CompareVarToValue PVAR_4078, 1
    pl_CallIf 1, P34_012A
    pl_CompareVarToValue PVAR_4078, 2
    pl_CallIf 1, P34_012A
    pl_CompareVarToValue PVAR_4078, 4
    pl_CallIf 1, P34_0114
    pl_CompareVarToValue PVAR_4078, 5
    pl_CallIf 1, P34_0150
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P34_0140
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P34_0148
    pl_End

P34_00F0:
    pl_SetVarFromValue PVAR_40F8, 0
    pl_Return

P34_00F8:
    pl_SetObjectEventPos 10, 55, 716, 0, 1  // object 16
    pl_SetObjectEventPos 10, 55, 716, 3, 1  // SetObjectEventDir 16 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 16, 17: Black 2 has no command for it (the NPC keeps its own)
    pl_Return

P34_010E:
    pl_ClearFlag PFLAG_025E
    pl_Return

P34_0114:
    pl_SetObjectEventPos 6, 37, 721, 0, 1  // object 11
    pl_SetObjectEventPos 6, 37, 721, 1, 1  // SetObjectEventDir 11 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 11, 15: Black 2 has no command for it (the NPC keeps its own)
    pl_Return

P34_012A:
    pl_SetObjectEventPos 6, 39, 733, 0, 1  // object 11
    pl_SetObjectEventPos 6, 39, 733, 0, 1  // SetObjectEventDir 11 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 11, 14: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_Return

P34_0140:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P34_0148:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P34_0150:
    pl_SetFlag PFLAG_01D1
    pl_SetFlag PFLAG_01D3
    pl_SetVarFromValue PVAR_4078, 6
    pl_Return

P34_0160:
    pl_CheckFlag PFLAG_0158
    pl_GoToIf 1, P34_01C2
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 0, P34_01C2
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P34_01C2
    pl_CheckItem 454, 1, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P34_01C2
    pl_CheckDistributionEvent 0, PVAR_4000  // CheckDistributionEvent 0: its item came from the deliveryman
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P34_01C2
    pl_CheckFlag PFLAG_012C
    pl_GoToIf 0, P34_01C2
    pl_SetVarFromValue PVAR_4000, 1
    pl_Return

P34_01C2:
    pl_SetVarFromValue PVAR_4000, 0
    pl_Return

P34_S24:
P34_01CA:
    pl_Call P34_0160
    pl_CompareVarToValue PVAR_4000, 0
    pl_CallIf 1, P34_01DF
    pl_End

P34_01DF:
    pl_SetBgEventPos 0, 58, 713, 16  // SetBgEventPosition 0, 58, 713
    pl_SetWarpEventPos 5, 59, 712, 1
    pl_Return

P34_S2:
P34_01F1:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 723
    pl_GoToIf 1, P34_023C
    pl_CompareVarToValue PVAR_8005, 724
    pl_GoToIf 1, P34_024A
    pl_CompareVarToValue PVAR_8005, 725
    pl_GoToIf 1, P34_0258
    pl_CompareVarToValue PVAR_8005, 726
    pl_GoToIf 1, P34_0266
    pl_CompareVarToValue PVAR_8005, 727
    pl_GoToIf 1, P34_0274
    pl_End

P34_023C:
    pl_SetObjectEventPosLater 0, 11, 38, 1, 723, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_GoTo P34_0282

P34_024A:
    pl_SetObjectEventPosLater 0, 11, 38, 1, 724, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_GoTo P34_0282

P34_0258:
    pl_SetObjectEventPosLater 0, 11, 38, 1, 725, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_GoTo P34_0282

P34_0266:
    pl_SetObjectEventPosLater 0, 11, 38, 1, 726, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_GoTo P34_0282

P34_0274:
    pl_SetObjectEventPosLater 0, 11, 38, 1, 727, 0  // SetObjectEventPos 11 (the live actor; and where AddObject puts it)
    pl_GoTo P34_0282

P34_0282:
// SetObjectEventMovementType 11, 17: Black 2 has no command for it (the NPC keeps its own)
    pl_ClearFlag PFLAG_01D0
    pl_AddObjectAt 11, 0, 0  // at its SetObjectEventPos
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_ApplyMovement 11, P34_032C
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 0
    pl_CloseMessage
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P34_02D9
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P34_02E5
    pl_GoTo P34_02CD

P34_02CD:
    pl_StartTrainerBattle PTRAINER_476, 0
    pl_GoTo P34_02F1

P34_02D9:
    pl_StartTrainerBattle PTRAINER_477, 0
    pl_GoTo P34_02F1

P34_02E5:
    pl_StartTrainerBattle PTRAINER_478, 0
    pl_GoTo P34_02F1

P34_02F1:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P34_0322
    pl_BufferRivalName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement 11, P34_0334
    pl_WaitMovement
    pl_RemoveObject 11, PFLAG_01D0
    pl_SetVarFromValue PVAR_4078, 1
    pl_ReleaseAll
    pl_End

P34_0322:
    pl_SetFlag PFLAG_01D0
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P34_S3:
P34_033C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_S4:
P34_034F:
    pl_LockAll
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 2
    pl_CloseMessage
    pl_ApplyMovement 11, P34_0384
    pl_ApplyMovement PL_PLAYER, P34_0394
    pl_WaitMovement
    pl_RemoveObject 11, PFLAG_01D0
    pl_SetVarFromValue PVAR_4078, 3
    pl_SetVarFromValue PVAR_40B2, 1
    pl_ReleaseAll
    pl_End

P34_S5:
P34_03A0:
    pl_LockAll
    pl_ApplyMovement 13, P34_0470
    pl_WaitMovement
    pl_msg_sys 3
    pl_CloseMessage
    pl_ClearFlag PFLAG_01D2
    pl_AddObject 14
// LockObject 14: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 14, P34_0484
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_ApplyMovement 14, P34_0490
    pl_WaitMovement
    pl_RemoveObject 14, PFLAG_01D2
    pl_ApplyMovement 11, P34_0498
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 5
    pl_CloseMessage
    pl_ApplyMovement 11, P34_04A0
    pl_WaitMovement
    pl_RemoveObject 11, PFLAG_01D0
    pl_ApplyMovement 13, P34_0478
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 6
    pl_CloseMessage
    pl_ApplyMovement 12, P34_0468
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P34_0436
    pl_GoTo P34_0442

P34_0436:
    pl_BufferPlayerName 0
    pl_msg_sys 7
    pl_GoTo P34_044B

P34_0442:
    pl_msg_sys 8
    pl_GoTo P34_044B

P34_044B:
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4078, 5
    pl_ClearFlag PFLAG_01B2
    pl_ClearFlag PFLAG_0193
    pl_ClearFlag PFLAG_02B1
    pl_ReleaseAll
    pl_End

P34_S6:
P34_04AC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_S7:
P34_04BF:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P34_04DE
    pl_GoTo P34_04E7

P34_04DE:
    pl_msg_talk 9
    pl_GoTo P34_04F0

P34_04E7:
    pl_msg_talk 10
    pl_GoTo P34_04F0

P34_04F0:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_S8:
P34_04F8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P34_0514
    pl_msg_talk 12
    pl_GoTo P34_051D

P34_0514:
    pl_msg_talk 13
    pl_GoTo P34_051D

P34_051D:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_S9:
P34_0525:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P34_0541
    pl_msg_talk 14
    pl_GoTo P34_051D

P34_0541:
    pl_msg_talk 15
    pl_GoTo P34_051D

P34_S10:
P34_054A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P34_0566
    pl_msg_talk 16
    pl_GoTo P34_051D

P34_0566:
    pl_msg_talk 17
    pl_GoTo P34_051D

P34_S11:
P34_056F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P34_058B
    pl_msg_talk 18
    pl_GoTo P34_051D

P34_058B:
    pl_msg_talk 19
    pl_GoTo P34_051D

P34_S12:
P34_0594:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P34_05B6
    pl_PlayCry 54
    pl_msg_talk 20
    pl_GoTo P34_051D

P34_05B6:
    pl_PlayCry 54
    pl_msg_talk 21
    pl_GoTo P34_051D

P34_S13:
P34_05C5:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A8
    pl_GoToIf 1, P34_05E1
    pl_msg_talk 22
    pl_GoTo P34_051D

P34_05E1:
    pl_msg_talk 23
    pl_GoTo P34_051D

P34_S14:
P34_05EA:
    pl_sign 33, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P34_S15:
P34_0601:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 34, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P34_S16:
P34_0616:
    pl_sign 35, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P34_S17:
P34_062D:
    pl_sign 36, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P34_S18:
P34_0644:
    pl_sign 37, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P34_S19:
P34_065B:
    pl_Call P34_0160
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P34_0683
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 39, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P34_0683:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 38, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P34_S21:
P34_0698:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 40
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_S20:
P34_06A9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerDir PVAR_8004
    pl_FacePlayer
    pl_CompareVarToValue PVAR_4106, 2
    pl_GoToIf 1, P34_08A0
    pl_msg_talk 24
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 41, 65535, 0  // Pearl AddMenuEntryImm 213, 0
    pl_CheckFlag PFLAG_0133
    pl_CallIf 1, P34_0731
    pl_CheckFlag PFLAG_013C
    pl_CallIf 1, P34_072B
    ListMenuAdd 42, 65535, 4  // Pearl AddMenuEntryImm 218, 4
    ListMenuShow
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P34_0737
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P34_0772
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P34_07AD
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P34_07E8
    pl_GoTo P34_07E8

P34_072B:
    ListMenuAdd 43, 65535, 2  // Pearl AddMenuEntryImm 215, 2
    pl_Return

P34_0731:
    ListMenuAdd 44, 65535, 1  // Pearl AddMenuEntryImm 214, 1
    pl_Return

P34_0737:
    pl_Call P34_07F3
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P34_0812
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, P34_082C
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P34_0846
    pl_BoatCutscene 3  // Pearl ShipAnimation 3, 3, 288, 100, 502: Black 2's boat demo
    RTReserveScript 3  // PearlArrive there
    pl_Warp 240, 100, 502, 3  // Pearl map 288 (MAP_IRON_ISLAND_EXTERIOR)
    pl_ReleaseAll
    pl_End

P34_0772:
    pl_Call P34_07F3
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P34_0812
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, P34_082C
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P34_0846
    pl_BoatCutscene 3  // Pearl ShipAnimation 3, 2, 260, 39, 277: Black 2's boat demo
    RTReserveScript 3  // PearlArrive there
    pl_Warp 205, 39, 277, 2  // Pearl map 260 (MAP_FULLMOON_ISLAND_EXTERIOR)
    pl_ReleaseAll
    pl_End

P34_07AD:
    pl_Call P34_07F3
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P34_0812
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, P34_082C
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P34_0846
    pl_BoatCutscene 3  // Pearl ShipAnimation 3, 3, 320, 152, 277: Black 2's boat demo
    RTReserveScript 4  // PearlArrive there
    pl_Warp 444, 152, 277, 3  // Pearl map 320 (MAP_NEWMOON_ISLAND_EXTERIOR)
    pl_ReleaseAll
    pl_End

P34_07E8:
    pl_msg_talk 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_07F3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25
    pl_CloseMessage
    pl_ApplyMovement 16, P34_0860
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement 16, P34_086C
    pl_WaitMovement
    pl_Return

P34_0812:
    pl_ApplyMovement PL_PLAYER, P34_0874
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P34_086C
    pl_WaitMovement
    pl_Return

P34_082C:
    pl_ApplyMovement PL_PLAYER, P34_0884
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P34_086C
    pl_WaitMovement
    pl_Return

P34_0846:
    pl_ApplyMovement PL_PLAYER, P34_0890
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ApplyMovement PL_PLAYER, P34_086C
    pl_WaitMovement
    pl_Return

P34_S22:
P34_08A0:
    pl_CheckItem 453, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P34_08EE
    pl_msg_sys 28
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P34_08D8
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P34_08E3
    pl_End

P34_08D8:
    pl_msg_sys 29
    pl_CloseMessage
    pl_GoTo P34_0772

P34_08E3:
    pl_msg_sys 30
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_08EE:
    pl_msg_sys 31
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P34_S23:
P34_08F9:
    pl_LockAll
    pl_ApplyMovement 16, P34_093C
    pl_WaitMovement
    pl_msg_sys 32
    pl_CloseMessage
    pl_ApplyMovement 16, P34_094C
    pl_WaitMovement
    pl_RemoveObject 16, 0
    pl_SetObjectEventPosLater 1, 16, 45, 1, 750, 0  // SetObjectEventPos 16 (the live actor; and where AddObject puts it)
    pl_ApplyMovement 16, .Lface920  // SetObjectEventDir 16: the live actor turns
    pl_WaitMovement
    VMJump .Lface920_end
    .balign 4, 0
.Lface920:
        Move 2, 1
        MoveEnd
.Lface920_end:
// SetObjectEventMovementType 16, 16: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_AddObjectAt 16, 1, 0  // at its SetObjectEventPos
    pl_SetVarFromValue PVAR_40F8, 4
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P34_032C:
    Move 19, 8  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P34_0334:
    Move 18, 9  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P34_0384:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 18, 5  // WALK_FAST_WEST
    Move 16, 10  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P34_0394:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P34_0468:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P34_0470:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P34_0478:
    Move 63, 2  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P34_0484:
    Move 18, 5  // WALK_FAST_WEST
    Move 16, 2  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P34_0490:
    Move 17, 6  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P34_0498:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P34_04A0:
    Move 17, 3  // WALK_FAST_SOUTH
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P34_0860:
    Move 3, 1  // FACE_EAST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P34_086C:
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P34_0874:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 3, 1  // FACE_EAST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P34_0884:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P34_0890:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 3, 1  // FACE_EAST
    Move 64, 1  // DELAY_15
    MoveEnd

    .balign 4, 0
P34_093C:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 15, 3  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P34_094C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 3  // WALK_NORMAL_WEST
    Move 13, 8  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- Pearl global script 205:43 (a subroutine here)
C205_43_S43:
C205_43_14FF:
    pl_FadeOutBGM 1  // StopMusic
    #ifdef SEQ_PEARL_THE_RIV
        pl_PlayMusic SEQ_PEARL_THE_RIV  // Pearl SEQ_THE_RIV
    #else
        pl_PlayMusic SEQ_BGM_E_HUE  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_ReturnCommonScript
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
