// MAP_MOUNT_CORONET_SPEAR_PILLAR: Pearl script file 230, text bank 220. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-14: Pearl's; 15: after a Warp, 16: after a Warp, 17: after a Warp; 18: PearlArrive; 53: Pearl 2039
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P230_S1
    ScriptEntry P230_S2
    ScriptEntry P230_S3
    ScriptEntry P230_S4
    ScriptEntry P230_S5
    ScriptEntry P230_S6
    ScriptEntry P230_S7
    ScriptEntry P230_S8
    ScriptEntry P230_S9
    ScriptEntry P230_S10
    ScriptEntry P230_S11
    ScriptEntry P230_S12
    ScriptEntry P230_S13
    ScriptEntry P230_S14
    ScriptEntry W230_03B7_S
    ScriptEntry W230_0458_S
    ScriptEntry W230_0FB0_S
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
    ScriptEntry PearlProxy_2039
    ScriptEntriesEnd

P230_S1:
P230_003A:
    pl_SetFlag PFLAG_09C7
    pl_Call P230_011F
    pl_Call P230_0086
    pl_Call P230_00A5
    pl_Call P230_00C2
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P230_0076
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P230_007E
    pl_End

P230_0076:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P230_007E:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P230_0086:
    pl_SetVarFromValue PVAR_4021, 4632  // dynamic sprite: Pearl graphics 154 -> Black 2 code
    WorkSetConst PVAR_4000, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_CompareVarToValue PVAR_4000, 10
    pl_GoToIf 1, P230_00A3
    pl_SetVarFromValue PVAR_4021, 4633  // dynamic sprite: Pearl graphics 155 -> Black 2 code

P230_00A3:
    pl_Return

P230_00A5:
    WorkSetConst PVAR_4000, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_CompareVarToValue PVAR_4000, 10
    pl_GoToIf 1, P230_00BC
    pl_SetFlag PFLAG_03FF
    pl_Return

P230_00BC:
    pl_SetFlag PFLAG_0401
    pl_Return

P230_00C2:
    FlagGet 2400, PVAR_4000  // CheckGameCompleted: Black 2's game clear (Pearl 0x964 = 2400 here)
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P230_011D
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P230_011D
    pl_CheckItem 455, 1, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P230_011D
    pl_CheckDistributionEvent 2, PVAR_4000  // CheckDistributionEvent 2: its item came from the deliveryman
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P230_011D
    pl_CheckFlag PFLAG_011E
    pl_GoToIf 1, P230_011D
    pl_SetVarFromValue PVAR_4118, 1

P230_011D:
    pl_Return

P230_011F:
// Dummy1F9 16536: nothing in Black 2 (a debug command)
    pl_CompareVarToValue PVAR_4098, 0
    pl_GoToIf 1, P230_0173
    pl_CompareVarToValue PVAR_4098, 1
    pl_GoToIf 1, P230_0173
    pl_CompareVarToValue PVAR_4098, 2
    pl_GoToIf 1, P230_018D
    pl_CompareVarToValue PVAR_4098, 3
    pl_GoToIf 1, P230_018F
    pl_CompareVarToValue PVAR_4098, 4
    pl_GoToIf 1, P230_01A1
    pl_CompareVarToValue PVAR_4098, 5
    pl_GoToIf 1, P230_01AF
    pl_Return

P230_0173:
    pl_SetFlag PFLAG_01E4
    pl_SetFlag PFLAG_01E5
    pl_SetFlag PFLAG_01E3
    pl_SetFlag PFLAG_01EC
    pl_SetFlag PFLAG_01ED
    pl_SetFlag PFLAG_01EE
    pl_Return

P230_018D:
    pl_Return

P230_018F:
    pl_SetObjectEventPos 7, 30, 32, 0, 3  // object 7
    pl_SetObjectEventPos 8, 32, 32, 1, 3  // object 8
    pl_Return

P230_01A1:
    pl_SetFlag PFLAG_01E4
    pl_SetFlag PFLAG_01E5
    pl_SetFlag PFLAG_01E3
    pl_Return

P230_01AF:
    pl_SetFlag PFLAG_01E4
    pl_SetFlag PFLAG_01E5
    pl_ClearFlag PFLAG_01E2
    pl_Return

P230_S2:
P230_01BD:
    pl_CheckFlag PFLAG_00BE
    pl_GoToIf 0, P230_01CD
    pl_SpearPillarSequence 2, PVAR_4000  // Pearl SpearPillarSequence 2

P230_01CD:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P230_01DA
    pl_End

P230_01DA:
    pl_SetFlag PFLAG_01E2
    pl_RemoveObject 5, PFLAG_01E2
    pl_ClearFlag PFLAG_008E
    pl_End

P230_01E8:
    WorkSetConst PVAR_800C, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_SetVarFromVar PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_800C, 10
    pl_GoToIf 1, P230_0205
    pl_SetVarFromVar PVAR_8004, PVAR_8006

P230_0205:
    pl_Return

P230_0207:
    pl_GetPlayerGender PVAR_800C
    pl_SetVarFromVar PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P230_0224
    pl_SetVarFromVar PVAR_8004, PVAR_8006

P230_0224:
    pl_Return

P230_S3:
P230_0226:
    pl_LockAll
    pl_ApplyMovement 0, P230_0270
    pl_ApplyMovement 3, P230_0280
    pl_WaitMovement
    pl_CheckHasTwoAliveMons PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P230_02C2
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P230_0290
    pl_WaitMovement
    pl_ApplyMovement 0, P230_0278
    pl_ApplyMovement 3, P230_0288
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P230_S6:
P230_029C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_4098, 0
    pl_GoToIf 5, P230_02FE
    pl_CheckHasTwoAliveMons PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_02EF

P230_02C2:
    pl_msg_sys 0
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_521, PTRAINER_527
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_02F8
    pl_SetVarFromValue PVAR_4098, 1
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_02EF:
    pl_msg_talk 1
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_02F8:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P230_02FE:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_S4:
P230_0309:
    pl_LockAll
    pl_HideObject 5  // Pearl HideObject 5
// ReleaseObject 5: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_GetPlayerMapPos PVAR_8000, PVAR_8001
    EvCameraInit  // AddFreeCamera PVAR_8000, PVAR_8001: the player's tile (camera_plan); the view stays where it is
    EvCameraUnbind
    pl_Call P230_0510
    pl_WaitMovement
    pl_SetVarFromValue PVAR_8005, 3
    pl_SetVarFromValue PVAR_8006, 4
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_CloseMessage
    pl_FadeOutBGM 60  // FadeOutBGM to volume 0
    pl_ApplyMovement 1, P230_0504
    pl_WaitMovement
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1474560, 56  // ApplyMovement 0xF1 P230_069C: the free camera walks to (31, 22) (camera_plan)
    EvCameraWait
    pl_WaitMovement
// Pearl 0x5D (pokediamond ScrCmd_Unk005D: sound sequence SEQ_PV001 as a sub-scene): nothing in Black 2
    pl_SpearPillarSequence 0, PVAR_800C  // Pearl SpearPillarSequence 0
    pl_WaitTime 162, PVAR_800C
    #ifdef SEQ_PEARL_THE_EVENT02
        pl_PlayMusic SEQ_PEARL_THE_EVENT02  // Pearl SEQ_THE_EVENT02
    #else
        pl_stub PlayMusic  // Pearl sound SEQ_THE_EVENT02: no Black 2 stand-in
    #endif

P230_036A:
    pl_SpearPillarSequence 1, PVAR_800C  // Pearl SpearPillarSequence 1
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_036A
    pl_SpearPillarSequence 2, PVAR_800C  // Pearl SpearPillarSequence 2
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 56  // ApplyMovement 0xF1 P230_06A8: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_SetVarFromValue PVAR_8005, 5
    pl_SetVarFromValue PVAR_8006, 6
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
// SetBGMFixed 1: the music kept over the next warps (fixed_music)
// ScopeMode 1 (pokediamond ScrCmd_ScopeMode, field 0xB4): nothing in Black 2
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    EvCameraReturn 1  // RestoreCamera: the view cuts back to the player
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    pl_CloseMessage
    RTReserveScript 15  // the rest of this Pearl script runs there (continuation 15)
    pl_Warp 330, 31, 25, 3  // Pearl map 220 (MAP_MOUNT_CORONET_SPEAR_PILLAR)
    pl_ReleaseAll
    pl_End

P230_0510:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 29
    pl_GoToIf 1, P230_055F
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_0569
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_0573
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_057D
    pl_CompareVarToValue PVAR_8008, 33
    pl_GoToIf 1, P230_0587
    pl_Return

P230_055F:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 64  // ApplyMovement 0xF1 P230_0594: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

P230_0569:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 56  // ApplyMovement 0xF1 P230_05A4: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

P230_0573:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 48  // ApplyMovement 0xF1 P230_05B4: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

P230_057D:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 56  // ApplyMovement 0xF1 P230_05C0: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

P230_0587:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 64  // ApplyMovement 0xF1 P230_05D0: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

P230_S11:
P230_0794:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_S12:
P230_07A7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_S13:
P230_07BA:
    pl_LockAll
    pl_msg_sys 16
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P230_07D0
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P230_S5:
P230_07DC:
    pl_LockAll
    pl_Call P230_08FA
    pl_msg_sys 12
    pl_msg_sys 13
    pl_CloseMessage
    pl_Call P230_0867
    pl_BufferRivalName 0
    pl_msg_sys 14
    pl_msg_sys 15
    pl_CloseMessage
    pl_Call P230_09B0
// StartTagBattle PVAR_8004, 528, 407: the partner by Pearl's trainer number in the var
    WorkCmpConst PVAR_8004, 607
    VMJumpIf CMP_NE, .Ltag803_607
    pl_StartTagBattle PTRAINER_607, PTRAINER_528, PTRAINER_407
    VMJump .Ltag803_end
.Ltag803_607:
    WorkCmpConst PVAR_8004, 619
    VMJumpIf CMP_NE, .Ltag803_619
    pl_StartTagBattle PTRAINER_619, PTRAINER_528, PTRAINER_407
    VMJump .Ltag803_end
.Ltag803_619:
    pl_StartTagBattle PTRAINER_620, PTRAINER_528, PTRAINER_407
.Ltag803_end:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_0857
    pl_Call P230_09E2
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 20
    pl_PlayFanfare SEQ_ME_ASA  // Pearl SEQ_ASA
    pl_WaitFanfare
    pl_HealParty
    pl_msg_sys 21
    pl_msg_sys 22
    pl_WaitABPress
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, .Lfacee83d  // SetEventDirection 255, 1: turns at once
    pl_WaitMovement
    VMJump .Lfacee83d_end
    .balign 4, 0
.Lfacee83d:
        Move 1, 1
        MoveEnd
.Lfacee83d_end:
    pl_ApplyMovement 6, P230_0A8C
    pl_WaitMovement
    pl_RemoveObject 6, PFLAG_01E3
    pl_GoTo P230_0A94

P230_0857:
    pl_SetVarFromValue PVAR_4098, 1
    pl_ClearFlag PFLAG_00BE
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P230_0867:
    pl_ClearFlag PFLAG_01E3
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_08A0
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_08BE
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_08DC
    pl_Return

P230_08A0:
    pl_SetObjectEventPosLater 0, 6, 31, 3, 40, 0  // SetObjectEventPos 6 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 6, 0, 0  // at its SetObjectEventPos
    pl_ApplyMovement 6, P230_0A80
    pl_WaitMovement
    pl_ApplyMovement 6, .Lfacee8b6  // SetEventDirection 6, 3: turns at once
    pl_WaitMovement
    VMJump .Lfacee8b6_end
    .balign 4, 0
.Lfacee8b6:
        Move 3, 1
        MoveEnd
.Lfacee8b6_end:
    pl_Return

P230_08BE:
    pl_SetObjectEventPosLater 0, 6, 30, 3, 40, 0  // SetObjectEventPos 6 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 6, 0, 0  // at its SetObjectEventPos
    pl_ApplyMovement 6, P230_0A80
    pl_WaitMovement
    pl_ApplyMovement 6, .Lfacee8d4  // SetEventDirection 6, 2: turns at once
    pl_WaitMovement
    VMJump .Lfacee8d4_end
    .balign 4, 0
.Lfacee8d4:
        Move 2, 1
        MoveEnd
.Lfacee8d4_end:
    pl_Return

P230_08DC:
    pl_SetObjectEventPosLater 0, 6, 31, 3, 40, 0  // SetObjectEventPos 6 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 6, 0, 0  // at its SetObjectEventPos
    pl_ApplyMovement 6, P230_0A80
    pl_WaitMovement
    pl_ApplyMovement 6, .Lfacee8f2  // SetEventDirection 6, 2: turns at once
    pl_WaitMovement
    VMJump .Lfacee8f2_end
    .balign 4, 0
.Lfacee8f2:
        Move 2, 1
        MoveEnd
.Lfacee8f2_end:
    pl_Return

P230_08FA:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_092F
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_0949
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_0963
    pl_Return

P230_092F:
    pl_ApplyMovement PL_PLAYER, .Lfacee92f  // SetEventDirection 255, 2: turns at once
    pl_WaitMovement
    VMJump .Lfacee92f_end
    .balign 4, 0
.Lfacee92f:
        Move 2, 1
        MoveEnd
.Lfacee92f_end:
    pl_ApplyMovement 4, P230_0980
    pl_ApplyMovement 2, P230_0988
    pl_WaitMovement
    pl_Return

P230_0949:
    pl_ApplyMovement PL_PLAYER, .Lfacee949  // SetEventDirection 255, 3: turns at once
    pl_WaitMovement
    VMJump .Lfacee949_end
    .balign 4, 0
.Lfacee949:
        Move 3, 1
        MoveEnd
.Lfacee949_end:
    pl_ApplyMovement 4, P230_0990
    pl_ApplyMovement 2, P230_0998
    pl_WaitMovement
    pl_Return

P230_0963:
    pl_ApplyMovement PL_PLAYER, .Lfacee963  // SetEventDirection 255, 3: turns at once
    pl_WaitMovement
    VMJump .Lfacee963_end
    .balign 4, 0
.Lfacee963:
        Move 3, 1
        MoveEnd
.Lfacee963_end:
    pl_ApplyMovement 4, P230_09A0
    pl_ApplyMovement 2, P230_09A8
    pl_WaitMovement
    pl_Return

P230_09B0:
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_SetVarFromValue PVAR_8004, 620
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P230_09E0
    pl_SetVarFromValue PVAR_8004, 619
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P230_09E0
    pl_SetVarFromValue PVAR_8004, 607

P230_09E0:
    pl_Return

P230_09E2:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_0A17
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_0A25
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_0A33
    pl_Return

P230_0A17:
    pl_ApplyMovement PL_PLAYER, .Lfaceea17  // SetEventDirection 255, 3: turns at once
    pl_WaitMovement
    VMJump .Lfaceea17_end
    .balign 4, 0
.Lfaceea17:
        Move 3, 1
        MoveEnd
.Lfaceea17_end:
    pl_ApplyMovement 6, .Lfaceea1d  // SetEventDirection 6, 2: turns at once
    pl_WaitMovement
    VMJump .Lfaceea1d_end
    .balign 4, 0
.Lfaceea1d:
        Move 2, 1
        MoveEnd
.Lfaceea1d_end:
    pl_Return

P230_0A25:
    pl_ApplyMovement PL_PLAYER, .Lfaceea25  // SetEventDirection 255, 2: turns at once
    pl_WaitMovement
    VMJump .Lfaceea25_end
    .balign 4, 0
.Lfaceea25:
        Move 2, 1
        MoveEnd
.Lfaceea25_end:
    pl_ApplyMovement 6, .Lfaceea2b  // SetEventDirection 6, 3: turns at once
    pl_WaitMovement
    VMJump .Lfaceea2b_end
    .balign 4, 0
.Lfaceea2b:
        Move 3, 1
        MoveEnd
.Lfaceea2b_end:
    pl_Return

P230_0A33:
    pl_ApplyMovement PL_PLAYER, .Lfaceea33  // SetEventDirection 255, 2: turns at once
    pl_WaitMovement
    VMJump .Lfaceea33_end
    .balign 4, 0
.Lfaceea33:
        Move 2, 1
        MoveEnd
.Lfaceea33_end:
    pl_ApplyMovement 6, .Lfaceea39  // SetEventDirection 6, 3: turns at once
    pl_WaitMovement
    VMJump .Lfaceea39_end
    .balign 4, 0
.Lfaceea39:
        Move 3, 1
        MoveEnd
.Lfaceea39_end:
    pl_Return

P230_0A94:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, .Lfaceea96  // SetEventDirection 255, 0: turns at once
    pl_WaitMovement
    VMJump .Lfaceea96_end
    .balign 4, 0
.Lfaceea96:
        Move 0, 1
        MoveEnd
.Lfaceea96_end:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    EvCameraInit  // AddFreeCamera PVAR_8004, PVAR_8005: the player's tile (camera_plan); the view stays where it is
    EvCameraUnbind
    pl_Call P230_0C35
    pl_SpearPillarSequence 3, PVAR_800C  // Pearl SpearPillarSequence 3
    pl_ClearFlag PFLAG_00BE
    pl_SpearPillarSequence 4, PVAR_800C  // Pearl SpearPillarSequence 4
    pl_WaitTime 30, PVAR_800C
    pl_PlaySE SEQ_SE_W026_01  // Pearl SEQ_SE_DP_W025
    pl_WaitTime 90, PVAR_800C
    pl_SetVarFromValue PVAR_8005, 23
    pl_SetVarFromValue PVAR_8006, 24
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_CloseMessage
    pl_WaitTime 60, PVAR_800C
    #ifdef SEQ_PEARL_D_RYAYHY
        pl_PlayMusic SEQ_PEARL_D_RYAYHY  // Pearl SEQ_D_RYAYHY
    #else
        pl_stub PlayMusic  // Pearl sound SEQ_D_RYAYHY: no Black 2 stand-in
    #endif
    pl_WaitTime 90, PVAR_800C
    pl_msg_sys 25
    pl_WaitTime 60, PVAR_800C
    pl_ClearFlag PFLAG_01EC
    pl_AddObject 9
    pl_PlayCry 480
    pl_msg_sys 26
    pl_WaitCry
    pl_ClearFlag PFLAG_01ED
    pl_AddObjectAt 10, 1, 1  // at its SetObjectEventPos
    pl_PlayCry 481
    pl_msg_sys 27
    pl_WaitCry
    pl_ClearFlag PFLAG_01EE
    pl_AddObject 11
    pl_PlayCry 482
    pl_msg_sys 28
    pl_WaitCry
    pl_CloseMessage
    pl_SpearPillarSequence 5, PVAR_800C  // Pearl SpearPillarSequence 5
    pl_WaitTime 30, PVAR_800C
    pl_PlaySE SEQ_SE_W095_01  // Pearl SEQ_SE_DP_W060C

P230_0B47:
    pl_SpearPillarSequence 6, PVAR_800C  // Pearl SpearPillarSequence 6
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_0B47
    pl_WaitTime 60, PVAR_800C
    pl_RemoveObject 9, PFLAG_01EC
    pl_WaitTime 30, PVAR_800C
    pl_RemoveObject 11, PFLAG_01EE
    pl_WaitTime 30, PVAR_800C
    pl_RemoveObject 10, PFLAG_01ED
    pl_WaitTime 30, PVAR_800C
    pl_Call P230_0CBC
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetObjectEventPosLater 1, 10, PVAR_8004, 0, 31, 1  // SetObjectEventPos 10 (the live actor; and where AddObject puts it)
    pl_ClearFlag PFLAG_01ED
    pl_AddObjectAt 10, 1, 1  // at its SetObjectEventPos
    pl_PlayCry 481
    pl_WaitCry
    pl_WaitTime 60, PVAR_800C
    pl_RemoveObject 10, PFLAG_01ED
    pl_FadeOutBGM 60  // FadeOutBGM to volume 0
    pl_WaitTime 30, PVAR_800C
    pl_PlayDefaultMusic
    pl_msg_sys 29
    pl_WaitABPress
    pl_CloseMessage
    EvCameraReturn 1  // (a battle: the free camera ends first, as Pearl's field is rebuilt there)
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    pl_StartTrainerBattle PTRAINER_404, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_0C29
    pl_PlayDefaultMusic
    pl_SetVarFromValue PVAR_8005, 30
    pl_SetVarFromValue PVAR_8006, 31
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_RemoveObject 0, PFLAG_01E6
    pl_RemoveObject 3, PFLAG_01E6
    pl_RemoveObject 4, PFLAG_01E7
    pl_RemoveObject 2, PFLAG_01E7
    pl_RemoveObject 1, PFLAG_01E8
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetFlag PFLAG_0986
    pl_GoTo P230_0D44

P230_0C29:
    pl_SetVarFromValue PVAR_4098, 1
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P230_0C35:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_0C6A
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_0C76
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_0C82
    pl_Return

P230_0C6A:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1343488, 52  // ApplyMovement 0xF1 P230_0C90: the free camera walks to (31, 20) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_Return

P230_0C76:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1343488, 48  // ApplyMovement 0xF1 P230_0CA0: the free camera walks to (31, 20) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_Return

P230_0C82:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1343488, 52  // ApplyMovement 0xF1 P230_0CAC: the free camera walks to (31, 20) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_Return

P230_0CBC:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_0CF1
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_0CFD
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_0D09
    pl_Return

P230_0CF1:
    EvCameraMoveTo 10749, 0, 0xed000, 1998848, 196608, 2129920, 52  // ApplyMovement 0xF1 P230_0D18: the free camera walks to (30, 32) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_Return

P230_0CFD:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 2129920, 48  // ApplyMovement 0xF1 P230_0D28: the free camera walks to (31, 32) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_Return

P230_0D09:
    EvCameraMoveTo 10749, 0, 0xed000, 2129920, 196608, 2129920, 52  // ApplyMovement 0xF1 P230_0D34: the free camera walks to (32, 32) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_Return

P230_0D44:
    pl_WaitTime 90, PVAR_800C
    pl_Call P230_0DB7
    pl_ClearFlag PFLAG_01E4
    pl_AddObjectAt 7, 2, 0  // at its SetObjectEventPos
    pl_ClearFlag PFLAG_01E5
    pl_AddObjectAt 8, 3, 1  // at its SetObjectEventPos
    pl_ApplyMovement 7, P230_0E44
    pl_ApplyMovement 8, P230_0E4C
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, .Lfaceed72  // SetEventDirection 255, 1: turns at once
    pl_WaitMovement
    VMJump .Lfaceed72_end
    .balign 4, 0
.Lfaceed72:
        Move 1, 1
        MoveEnd
.Lfaceed72_end:
    pl_BufferPlayerName 0
    pl_SetVarFromValue PVAR_8005, 36
    pl_SetVarFromValue PVAR_8006, 37
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_WaitABPress
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_Call P230_0E22
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P230_0E3C
    pl_WaitMovement
    pl_SetVarFromValue PVAR_4098, 3
    pl_ReleaseAll
    pl_End

P230_0DB7:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_0DEC
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_0DFE
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_0E10
    pl_Return

P230_0DEC:
    pl_SetObjectEventPosLater 2, 7, 30, 3, 40, 0  // SetObjectEventPos 7 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 3, 8, 31, 3, 40, 1  // SetObjectEventPos 8 (the live actor; and where AddObject puts it)
    pl_Return

P230_0DFE:
    pl_SetObjectEventPosLater 2, 7, 30, 3, 40, 0  // SetObjectEventPos 7 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 3, 8, 32, 3, 40, 1  // SetObjectEventPos 8 (the live actor; and where AddObject puts it)
    pl_Return

P230_0E10:
    pl_SetObjectEventPosLater 2, 7, 31, 3, 40, 0  // SetObjectEventPos 7 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 3, 8, 32, 3, 40, 1  // SetObjectEventPos 8 (the live actor; and where AddObject puts it)
    pl_Return

P230_0E22:
    pl_SetVarFromValue PVAR_8005, 40
    pl_SetVarFromValue PVAR_8006, 39
    pl_Call P230_0207
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys PVAR_8004
    pl_Return

P230_S9:
P230_0E58:
    pl_LockAll
    pl_BufferPlayerName 0
    pl_SetVarFromValue PVAR_8005, 38
    pl_SetVarFromValue PVAR_8006, 38
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P230_0E84
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P230_S10:
P230_0E8C:
    pl_LockAll
    pl_Call P230_1014
    pl_WaitMovement
    pl_SetVarFromValue PVAR_8005, 483
    pl_SetVarFromValue PVAR_8006, 484
    pl_Call P230_01E8
    pl_PlayCry PVAR_8004
    pl_SetVarFromValue PVAR_8005, 32
    pl_SetVarFromValue PVAR_8006, 33
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_WaitABPress
    pl_WaitCry
    pl_CloseMessage
    pl_SetVarFromValue PVAR_8005, 483
    pl_SetVarFromValue PVAR_8006, 484
    pl_Call P230_01E8
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle PVAR_8004, 47
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_100E
    pl_CheckDidNotCapture PVAR_800C  // Pearl 0x2BC: 1 unless caught
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P230_0F16
    pl_SetFlag PFLAG_015F
    pl_GoTo P230_0F30

P230_0F16:
    pl_SetVarFromValue PVAR_8005, 34
    pl_SetVarFromValue PVAR_8006, 35
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_WaitABPress
    pl_CloseMessage

P230_0F30:
    pl_Call P230_1088
    pl_ApplyMovement 8, P230_111C
    pl_ApplyMovement 7, P230_1114
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, .Lfaceef48  // SetEventDirection 255, 1: turns at once
    pl_WaitMovement
    VMJump .Lfaceef48_end
    .balign 4, 0
.Lfaceef48:
        Move 1, 1
        MoveEnd
.Lfaceef48_end:
    pl_BufferPlayerName 1
    pl_msg_sys 41
    pl_BufferPlayerName 1
    pl_SetVarFromValue PVAR_8005, 43
    pl_SetVarFromValue PVAR_8006, 42
    pl_Call P230_0207
    pl_msg_sys PVAR_8004
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    EvCameraInit  // AddFreeCamera PVAR_8004, PVAR_8005: the player's tile (camera_plan); the view stays where it is
    EvCameraUnbind
    pl_ApplyMovement 7, P230_1128
    pl_WaitMovement
    pl_ApplyMovement 7, P230_1130
    pl_ApplyMovement PL_PLAYER, P230_1130
    pl_WaitMovement
    pl_ApplyMovement 8, .Lfaceef97  // SetEventDirection 8, 1: turns at once
    pl_WaitMovement
    VMJump .Lfaceef97_end
    .balign 4, 0
.Lfaceef97:
        Move 1, 1
        MoveEnd
.Lfaceef97_end:
    pl_msg_sys 44
    pl_WaitABPress
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    EvCameraReturn 1  // (a Warp: the free camera ends first, as Pearl's field is rebuilt there)
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    RTReserveScript 17  // the rest of this Pearl script runs there (continuation 17)
    pl_Warp 330, 31, 52, 1  // Pearl map 220 (MAP_MOUNT_CORONET_SPEAR_PILLAR)
    pl_ReleaseAll
    pl_End

P230_100E:
    pl_BlackOutFromWildBattle
    pl_ReleaseAll
    pl_End

P230_1014:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_1049
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_1053
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_105D
    pl_Return

P230_1049:
    pl_ApplyMovement PL_PLAYER, P230_1068
    pl_Return

P230_1053:
    pl_ApplyMovement PL_PLAYER, P230_1074
    pl_Return

P230_105D:
    pl_ApplyMovement PL_PLAYER, P230_107C
    pl_Return

P230_1088:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_AddVar PVAR_8005, 8
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P230_10C3
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P230_10DD
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P230_10F7
    pl_Return

P230_10C3:
    pl_SetPosition 7, 30, 10, PVAR_8005, 0
    pl_SetPosition 8, 31, 10, PVAR_8005, 0
    pl_Return

P230_10DD:
    pl_SetPosition 7, 31, 10, PVAR_8005, 0
    pl_SetPosition 8, 32, 10, PVAR_8005, 0
    pl_Return

P230_10F7:
    pl_SetPosition 7, 32, 10, PVAR_8005, 0
    pl_SetPosition 8, 31, 10, PVAR_8005, 0
    pl_Return

P230_S7:
P230_1138:
    pl_CompareVarToValue PVAR_4098, 3
    pl_GoToIf 5, P230_1161
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_Call P230_0E22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_1161:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_1194
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P230_1181
    pl_End

P230_1181:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 47
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_1194:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 46
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_S8:
P230_11A7:
    pl_CompareVarToValue PVAR_4098, 3
    pl_GoToIf 5, P230_11DD
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_BufferPlayerName 0
    pl_SetVarFromValue PVAR_8005, 36
    pl_SetVarFromValue PVAR_8006, 37
    pl_Call P230_01E8
    pl_msg_talk PVAR_8004
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_11DD:
    pl_BufferPlayerName 0
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 45
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_S14:
P230_11F3:
    pl_LockAll
    pl_Call P230_1014
    pl_WaitMovement
    pl_SetVarFromValue PVAR_8005, 483
    pl_SetVarFromValue PVAR_8006, 484
    pl_Call P230_01E8
    pl_PlayCry PVAR_8004
    pl_SetVarFromValue PVAR_8005, 32
    pl_SetVarFromValue PVAR_8006, 33
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_WaitABPress
    pl_WaitCry
    pl_CloseMessage
    pl_SetVarFromValue PVAR_8005, 483
    pl_SetVarFromValue PVAR_8006, 484
    pl_Call P230_01E8
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle PVAR_8004, 47
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P230_129F
    pl_SetVarFromValue PVAR_4098, 4
    pl_CheckDidNotCapture PVAR_800C  // Pearl 0x2BC: 1 unless caught
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P230_1281
    pl_SetFlag PFLAG_015F
    pl_ReleaseAll
    pl_End

P230_1281:
    pl_SetVarFromValue PVAR_8005, 34
    pl_SetVarFromValue PVAR_8006, 35
    pl_Call P230_01E8
    pl_msg_sys PVAR_8004
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P230_129F:
    pl_BlackOutFromWildBattle
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P230_0270:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P230_0278:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P230_0280:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P230_0288:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P230_0290:
    Move 62, 5  // DELAY_4
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P230_0504:
    Move 63, 1  // DELAY_8
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P230_0594:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P230_05A4:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P230_05B4:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_05C0:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P230_05D0:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P230_069C:
    Move 63, 1  // DELAY_8
    Move 12, 7  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_06A8:
    Move 63, 1  // DELAY_8
    Move 13, 7  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P230_07D0:
    Move 62, 1  // DELAY_4
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_0980:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P230_0988:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P230_0990:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P230_0998:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P230_09A0:
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P230_09A8:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P230_0A80:
    Move 62, 2  // DELAY_4
    Move 16, 8  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P230_0A8C:
    Move 17, 8  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P230_0C90:
    Move 62, 1  // DELAY_4
    Move 19, 1  // WALK_FAST_EAST
    Move 16, 12  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P230_0CA0:
    Move 62, 1  // DELAY_4
    Move 16, 12  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P230_0CAC:
    Move 62, 1  // DELAY_4
    Move 18, 1  // WALK_FAST_WEST
    Move 16, 12  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P230_0D18:
    Move 62, 1  // DELAY_4
    Move 18, 1  // WALK_FAST_WEST
    Move 17, 12  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P230_0D28:
    Move 62, 1  // DELAY_4
    Move 17, 12  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P230_0D34:
    Move 62, 1  // DELAY_4
    Move 19, 1  // WALK_FAST_EAST
    Move 17, 12  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P230_0E3C:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_0E44:
    Move 12, 7  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_0E4C:
    Move 63, 3  // DELAY_8
    Move 12, 7  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_0E84:
    Move 16, 1  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P230_1068:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 4  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_1074:
    Move 12, 4  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_107C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 4  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_1114:
    Move 12, 6  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_111C:
    Move 61, 1  // DELAY_2
    Move 12, 6  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_1128:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P230_1130:
    Move 13, 8  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- continuation 15: after the Warp at 230:03B7 (MAP_MOUNT_CORONET_SPEAR_PILLAR)
W230_03B7_S:
W230_03B7_03C3:
    pl_HideObject PL_PLAYER  // Pearl HideObject 255
    pl_SpearPillarSequence 7, PVAR_800C  // Pearl SpearPillarSequence 7
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    #ifdef SEQ_PEARL_THE_EVENT03
        pl_PlayMusic SEQ_PEARL_THE_EVENT03  // Pearl SEQ_THE_EVENT03
    #else
        pl_stub PlayMusic  // Pearl sound SEQ_THE_EVENT03: no Black 2 stand-in
    #endif
    pl_WaitFadeScreen
    pl_WaitTime 90, PVAR_800C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 8  // the rest of this Pearl script runs there (continuation 8)
    pl_Warp 154, 240, 660, 3  // Pearl map 200 (MAP_VALLEY_WINDWORKS_EXTERIOR)
    pl_ReleaseAll
    pl_End

// ---- continuation 16: after the Warp at 230:0458 (MAP_MOUNT_CORONET_SPEAR_PILLAR)
W230_0458_01E8:
    WorkSetConst PVAR_800C, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_SetVarFromVar PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_800C, 10
    pl_GoToIf 1, W230_0458_0205
    pl_SetVarFromVar PVAR_8004, PVAR_8006

W230_0458_0205:
    pl_Return

W230_0458_S:
// the music Pearl kept over the map change (SetBGMFixed, fixed_music):
#ifdef SEQ_PEARL_THE_EVENT03
    pl_PlayMusic SEQ_PEARL_THE_EVENT03  // Pearl SEQ_THE_EVENT03
#else
    pl_stub PlayMusic  // Pearl sound SEQ_THE_EVENT03: no Black 2 stand-in
#endif
W230_0458_0464:
    pl_ShowObject PL_PLAYER  // Pearl ShowObject 255
    EvCameraInit  // AddFreeCamera PVAR_8000, PVAR_8001: the player's tile (camera_plan); the view stays where it is
    EvCameraUnbind
    pl_Call W230_0458_0510
    pl_WaitMovement
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
// SetBGMFixed 0: the music follows the zone again (fixed_music)
// ScopeMode 0 (pokediamond ScrCmd_ScopeMode, field 0xB4): nothing in Black 2
    pl_SetVarFromValue PVAR_8005, 7
    pl_SetVarFromValue PVAR_8006, 8
    pl_Call W230_0458_01E8
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys PVAR_8004
    pl_CloseMessage
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1474560, 56  // ApplyMovement 0xF1 W230_0458_069C: the free camera walks to (31, 22) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_SetVarFromValue PVAR_8005, 483
    pl_SetVarFromValue PVAR_8006, 484
    pl_Call W230_0458_01E8
    pl_PlayCry PVAR_8004
    pl_SetVarFromValue PVAR_8005, 9
    pl_SetVarFromValue PVAR_8006, 10
    pl_Call W230_0458_01E8
    pl_msg_sys PVAR_8004
    pl_WaitCry
    pl_CloseMessage
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 56  // ApplyMovement 0xF1 W230_0458_06A8: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_WaitMovement
    pl_msg_sys 11  // Pearl bank 220 line 11
    pl_WaitABPress
    pl_CloseMessage
    pl_Call W230_0458_06C4
    pl_WaitMovement
    EvCameraReturn 1  // RestoreCamera: the view cuts back to the player
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    pl_SetVarFromValue PVAR_4098, 2
    pl_ReleaseAll
    pl_End

W230_0458_0510:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 29
    pl_GoToIf 1, W230_0458_055F
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, W230_0458_0569
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, W230_0458_0573
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, W230_0458_057D
    pl_CompareVarToValue PVAR_8008, 33
    pl_GoToIf 1, W230_0458_0587
    pl_Return

W230_0458_055F:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 64  // ApplyMovement 0xF1 W230_0458_0594: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_0569:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 56  // ApplyMovement 0xF1 W230_0458_05A4: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_0573:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 48  // ApplyMovement 0xF1 W230_0458_05B4: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_057D:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 56  // ApplyMovement 0xF1 W230_0458_05C0: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_0587:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 1933312, 64  // ApplyMovement 0xF1 W230_0458_05D0: the free camera walks to (31, 29) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_06C4:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 29
    pl_GoToIf 1, W230_0458_0713
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, W230_0458_071D
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, W230_0458_0727
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, W230_0458_0731
    pl_CompareVarToValue PVAR_8008, 33
    pl_GoToIf 1, W230_0458_073B
    pl_Return

W230_0458_0713:
    EvCameraMoveTo 10749, 0, 0xed000, 1933312, 196608, 2326528, 64  // ApplyMovement 0xF1 W230_0458_0748: the free camera walks to (29, 35) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_071D:
    EvCameraMoveTo 10749, 0, 0xed000, 1998848, 196608, 2326528, 56  // ApplyMovement 0xF1 W230_0458_0758: the free camera walks to (30, 35) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_0727:
    EvCameraMoveTo 10749, 0, 0xed000, 2064384, 196608, 2326528, 48  // ApplyMovement 0xF1 W230_0458_0768: the free camera walks to (31, 35) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_0731:
    EvCameraMoveTo 10749, 0, 0xed000, 2129920, 196608, 2326528, 56  // ApplyMovement 0xF1 W230_0458_0774: the free camera walks to (32, 35) (camera_plan)
    EvCameraWait
    pl_Return

W230_0458_073B:
    EvCameraMoveTo 10749, 0, 0xed000, 2195456, 196608, 2326528, 64  // ApplyMovement 0xF1 W230_0458_0784: the free camera walks to (33, 35) (camera_plan)
    EvCameraWait
    pl_Return

    .balign 4, 0
W230_0458_0594:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
W230_0458_05A4:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
W230_0458_05B4:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
W230_0458_05C0:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
W230_0458_05D0:
    Move 63, 1  // DELAY_8
    Move 12, 6  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
W230_0458_069C:
    Move 63, 1  // DELAY_8
    Move 12, 7  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
W230_0458_06A8:
    Move 63, 1  // DELAY_8
    Move 13, 7  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W230_0458_0748:
    Move 63, 1  // DELAY_8
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
W230_0458_0758:
    Move 63, 1  // DELAY_8
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
W230_0458_0768:
    Move 63, 1  // DELAY_8
    Move 13, 6  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W230_0458_0774:
    Move 63, 1  // DELAY_8
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
W230_0458_0784:
    Move 63, 1  // DELAY_8
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

// ---- continuation 17: after the Warp at 230:0FB0 (MAP_MOUNT_CORONET_SPEAR_PILLAR)
W230_0FB0_S:
W230_0FB0_0FBC:
    pl_SetPosition 7, 32, 1, 51, 1
    pl_SetPosition 8, 30, 1, 51, 1
    pl_ClearFlag PFLAG_01FD
    pl_ClearFlag PFLAG_01FE
    pl_ClearFlag PFLAG_01FF
    pl_SetFlag PFLAG_0981
    pl_SetFlag PFLAG_01EB
    pl_ClearFlag PFLAG_02B0
    pl_SetFlag PFLAG_015E
    pl_SetFlag PFLAG_02B3
    pl_SetFlag PFLAG_02AD
    pl_SetVarFromValue PVAR_4098, 4
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

PearlProxy_2039:                  // Pearl global script 2039 (run by this zone's events)
    VMCall C205_40_S40
    VMHalt

// ---- Pearl global script 205:40 (a subroutine here)
C205_40_S40:
C205_40_13DF:
    pl_LockAll
    WorkSetConst PVAR_8004, 220  // GetCurrentMapID: Pearl map 220
    pl_CompareVarToValue PVAR_8004, 220
    pl_GoToIf 5, C205_40_14BC
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 31
    pl_GoToIf 5, C205_40_14BC
    pl_CompareVarToValue PVAR_8005, 52
    pl_GoToIf 5, C205_40_14BC
    FlagGet 2400, PVAR_4000  // CheckGameCompleted: Black 2's game clear (Pearl 0x964 = 2400 here)
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, C205_40_14BC
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, C205_40_14BC
    pl_CheckDistributionEvent 2, PVAR_4000  // CheckDistributionEvent 2: its item came from the deliveryman
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, C205_40_14BC
    pl_CheckFlag PFLAG_011E
    pl_GoToIf 1, C205_40_14BC
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 52  // Pearl bank 199 line 122
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_40_14C7
    pl_BufferPlayerName 0
    pl_msg_sys 53  // Pearl bank 199 line 123
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    #ifdef SEQ_PEARL_FUE
        pl_PlayMusic SEQ_PEARL_FUE  // Pearl SEQ_FUE
    #else
        pl_stub PlayMusic  // Pearl sound SEQ_FUE: no Black 2 stand-in
    #endif
    pl_WaitTime 540, PVAR_800C
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_fade_out_white  // FadeScreen 6, 6, 0, 0x7fff
    pl_WaitFadeScreen
    RTReserveScript 5  // the rest of this Pearl script runs there (continuation 5)
    pl_Warp 489, PVAR_8004, PVAR_8005, 0  // Pearl map 510 (MAP_HALL_OF_ORIGIN)
    pl_ReleaseAll
    pl_End

C205_40_14BC:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 54  // Pearl bank 199 line 125
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C205_40_14C7:
    pl_CloseMessage
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
