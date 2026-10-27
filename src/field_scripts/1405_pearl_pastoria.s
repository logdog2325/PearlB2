// MAP_PASTORIA: Pearl script file 118, text bank 123. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-16: Pearl's; no warp continuations; 17: PearlArrive; 49: Pearl 2027, 54: Pearl 2800
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P118_S1
    ScriptEntry P118_S2
    ScriptEntry P118_S3
    ScriptEntry P118_S4
    ScriptEntry P118_S5
    ScriptEntry P118_S6
    ScriptEntry P118_S7
    ScriptEntry P118_S8
    ScriptEntry P118_S9
    ScriptEntry P118_S10
    ScriptEntry P118_S11
    ScriptEntry P118_S12
    ScriptEntry P118_S13
    ScriptEntry P118_S14
    ScriptEntry P118_S15
    ScriptEntry P118_S16
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
    ScriptEntry PearlProxy_2027
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_2800
    ScriptEntriesEnd

P118_S1:
P118_0042:
    pl_CheckFlag PFLAG_0102
    pl_GoToIf 1, P118_004F
    pl_End

P118_004F:
    pl_SetObjectEventPos 11, 637, 812, 0, 1  // object 21
    pl_SetObjectEventPos 11, 637, 812, 3, 1  // SetObjectEventDir 21 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 21, 17: Black 2 has no command for it (the NPC keeps its own)
    pl_End

P118_S2:
P118_0065:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S3:
P118_0078:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S4:
P118_008B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S5:
P118_009E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S6:
P118_00B1:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 3, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P118_00D7
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_00D7:
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S10:
P118_00E2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0128
    pl_GoToIf 1, P118_013C
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_CallIf 1, P118_0147
    pl_CompareVarToValue PVAR_800C, 390
    pl_CallIf 1, P118_014F
    pl_CompareVarToValue PVAR_800C, 393
    pl_CallIf 1, P118_0157
// BufferAccessoryName 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_msg_talk 16  // Pearl bank 123 line 16 (the Accessory from PVAR_8004: not known here)
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_16_S16  // CallCommonScript 2015 (Pearl file 205 script 16)
    pl_SetFlag PFLAG_0128
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_013C:
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_0147:
    pl_SetVarFromValue PVAR_8004, 93
    pl_Return

P118_014F:
    pl_SetVarFromValue PVAR_8004, 94
    pl_Return

P118_0157:
    pl_SetVarFromValue PVAR_8004, 92
    pl_Return

P118_S11:
P118_015F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S12:
P118_0172:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S7:
P118_0185:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S8:
P118_0198:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 35
    pl_msg_talk 15
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_S9:
P118_01B7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_0102
    pl_GoToIf 1, P118_0263
    pl_CheckFlag PFLAG_0101
    pl_GoToIf 1, P118_01DE
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_01DE:
    pl_CheckBadgeAcquired 3, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P118_021E
    pl_msg_talk 2
    pl_FacePlayer
    pl_ApplyMovement 21, P118_0558
    pl_WaitMovement
    pl_msg_talk 3
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P118_022B
    pl_GoTo P118_023D

P118_021E:
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P118_022B:
    pl_ApplyMovement 21, P118_0560
    pl_WaitMovement
    pl_GoTo P118_024F

P118_023D:
    pl_ApplyMovement 21, P118_056C
    pl_WaitMovement
    pl_GoTo P118_024F

P118_024F:
    pl_SetPosition 21, 637, 1, 812, 3
    pl_SetFlag PFLAG_0102
    pl_ReleaseAll
    pl_End

P118_0263:
    pl_FacePlayer
    pl_msg_talk 4
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P118_029D
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P118_02BD
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P118_02D5
    pl_GoTo P118_02F5

P118_029D:
    pl_SetVarFromValue PVAR_8007, 2
    pl_ApplyMovement 21, P118_0574
    pl_ApplyMovement PL_PLAYER, P118_04D8
    pl_WaitMovement
    pl_GoTo P118_0315

P118_02BD:
    pl_SetVarFromValue PVAR_8007, 3
    pl_ApplyMovement 21, P118_0584
    pl_WaitMovement
    pl_GoTo P118_0315

P118_02D5:
    pl_SetVarFromValue PVAR_8007, 0
    pl_ApplyMovement 21, P118_0584
    pl_ApplyMovement PL_PLAYER, P118_04F8
    pl_WaitMovement
    pl_GoTo P118_0315

P118_02F5:
    pl_SetVarFromValue PVAR_8007, 1
    pl_ApplyMovement 21, P118_0584
    pl_ApplyMovement PL_PLAYER, P118_04F0
    pl_WaitMovement
    pl_GoTo P118_0315

P118_0315:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 21, PFLAG_022A
    pl_WaitTime 15, PVAR_800C
    pl_ClearFlag PFLAG_01C7
    pl_AddObject 22
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_CompareVarToValue PVAR_8007, 2
    pl_CallIf 1, P118_039C
    pl_CompareVarToValue PVAR_8007, 3
    pl_CallIf 1, P118_03A8
    pl_CompareVarToValue PVAR_8007, 0
    pl_CallIf 1, P118_03B4
    pl_CompareVarToValue PVAR_8007, 1
    pl_CallIf 1, P118_03C0
    pl_ApplyMovement PL_PLAYER, P118_04D0
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_talk 5
    pl_CloseMessage
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P118_03DA
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P118_03E8
    pl_GoTo P118_03CC

P118_039C:
    pl_ApplyMovement 22, P118_0530
    pl_WaitMovement
    pl_Return

P118_03A8:
    pl_ApplyMovement 22, P118_0538
    pl_WaitMovement
    pl_Return

P118_03B4:
    pl_ApplyMovement 22, P118_0540
    pl_WaitMovement
    pl_Return

P118_03C0:
    pl_ApplyMovement 22, P118_054C
    pl_WaitMovement
    pl_Return

P118_03CC:
    pl_StartTrainerBattle PTRAINER_473, 0
    pl_GoTo P118_03F6

P118_03DA:
    pl_StartTrainerBattle PTRAINER_474, 0
    pl_GoTo P118_03F6

P118_03E8:
    pl_StartTrainerBattle PTRAINER_475, 0
    pl_GoTo P118_03F6

P118_03F6:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P118_04C0
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_talk 6
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8007, 2
    pl_GoToIf 1, P118_0448
    pl_CompareVarToValue PVAR_8007, 3
    pl_GoToIf 1, P118_0462
    pl_CompareVarToValue PVAR_8007, 0
    pl_GoToIf 1, P118_047C
    pl_CompareVarToValue PVAR_8007, 1
    pl_GoToIf 1, P118_0496
    pl_End

P118_0448:
    pl_ApplyMovement 22, P118_0590
    pl_ApplyMovement PL_PLAYER, P118_0500
    pl_WaitMovement
    pl_GoTo P118_04B0

P118_0462:
    pl_ApplyMovement 22, P118_05A0
    pl_ApplyMovement PL_PLAYER, P118_050C
    pl_WaitMovement
    pl_GoTo P118_04B0

P118_047C:
    pl_ApplyMovement 22, P118_05B0
    pl_ApplyMovement PL_PLAYER, P118_0518
    pl_WaitMovement
    pl_GoTo P118_04B0

P118_0496:
    pl_ApplyMovement 22, P118_05C0
    pl_ApplyMovement PL_PLAYER, P118_0524
    pl_WaitMovement
    pl_GoTo P118_04B0

P118_04B0:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 22, PFLAG_01C7
    pl_SetFlag PFLAG_0103
    pl_ReleaseAll
    pl_End

P118_04C0:
    pl_ClearFlag PFLAG_022A
    pl_SetFlag PFLAG_01C7
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P118_S13:
P118_05D0:
    pl_sign 20, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P118_S14:
P118_05E7:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 21, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P118_S15:
P118_05FC:
    pl_sign 22, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P118_S16:
P118_0613:
    pl_sign 23, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P118_04D0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P118_04D8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P118_04F0:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P118_04F8:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P118_0500:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P118_050C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P118_0518:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P118_0524:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P118_0530:
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_0538:
    Move 19, 7  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_0540:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 8  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_054C:
    Move 16, 1  // WALK_FAST_NORTH
    Move 19, 8  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_0558:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P118_0560:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 10  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_056C:
    Move 19, 10  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_0574:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 2  // WALK_FAST_EAST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_0584:
    Move 19, 2  // WALK_FAST_EAST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_0590:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 2  // WALK_FAST_EAST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_05A0:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 4  // WALK_FAST_EAST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_05B0:
    Move 16, 1  // WALK_FAST_NORTH
    Move 19, 3  // WALK_FAST_EAST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P118_05C0:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 19, 3  // WALK_FAST_EAST
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

PearlProxy_2027:                  // Pearl global script 2027 (run by this zone's events)
    VMCall T205_28_S28
    VMHalt

PearlProxy_2800:                  // Pearl global script 2800 (run by this zone's events)
    VMCall T378_1_S1
    VMHalt

// ---- Pearl global script 205:16 (a subroutine here)
C205_16_S16:
C205_16_0906:
    pl_Call C205_16_0922
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 31 (the Accessory from PVAR_8004: not known here)
    pl_WaitButton
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_16_0922:
    pl_PlayFanfare SEQ_ME_ACCE  // Pearl SEQ_ACCE
// AddAccessory 32772, 32773: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
// BufferAccessoryName 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 25 (the Accessory from PVAR_8004: not known here)
    pl_WaitFanfare
    pl_BufferPlayerName 0
// BufferAccessoryName 1, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_Return

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

// ---- Pearl global script 205:28 (a subroutine here)
T205_28_S28:
T205_28_1222:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 26  // Pearl bank 199 line 67
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 378:1 (a subroutine here)
T378_1_S1:
T378_1_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub GetBerryItemID  // Pearl 0x17E GetBerryTreeType 32768: not translated yet
    pl_stub GetBerryYield  // Pearl 0x181 GetBerryTreeAmount 32769: not translated yet
    pl_stub GetBerryGrowthStage  // Pearl 0x17D GetBerryTreeGrowth 32780: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T378_1_033E
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T378_1_0082
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T378_1_00B9
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T378_1_00EE
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, T378_1_0123
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, T378_1_021B
    pl_GoTo T378_1_033E

T378_1_0082:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_00A6
    WordSetItemNameWithArticle 0, PVAR_8000
// CapitalizeFirstChar: nothing in Black 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 27  // Pearl bank 350 line 13
    pl_GoTo T378_1_01F2

T378_1_00A6:
    WordSetItemNameWithArticle 0, PVAR_8000
// CapitalizeFirstChar: nothing in Black 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 28  // Pearl bank 350 line 31
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00B9:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_00DC
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 29  // Pearl bank 350 line 14
    pl_GoTo T378_1_01F2

T378_1_00DC:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 30  // Pearl bank 350 line 32
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00EE:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0111
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 31  // Pearl bank 350 line 15
    pl_GoTo T378_1_01F2

T378_1_0111:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 32  // Pearl bank 350 line 33
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_0123:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0146
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 33  // Pearl bank 350 line 16
    pl_GoTo T378_1_01F2

T378_1_0146:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 34  // Pearl bank 350 line 34
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_0158:
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, T378_1_0186
    pl_CheckItem 448, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0186
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

T378_1_0186:
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

T378_1_018E:
    pl_CheckItem 95, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_CheckItem 96, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_CheckItem 97, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_CheckItem 98, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

T378_1_01EA:
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

T378_1_01F2:
    pl_msg_talk 35  // Pearl bank 350 line 17
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_053A
    pl_CloseMessage
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 0: not translated yet
    pl_msg_talk 36  // Pearl bank 350 line 20
    pl_WaitButton
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 1: not translated yet
    pl_GoTo T378_1_053A

T378_1_021B:
    pl_BufferNumber 1, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_023B
    WordSetItemNameWithArticle 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 37  // Pearl bank 350 line 35
    pl_GoTo T378_1_0243

T378_1_023B:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 38  // Pearl bank 350 line 21

T378_1_0243:
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_02F7
    pl_CanFitItem PVAR_8000, PVAR_8001, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_02CF
    pl_BufferNumber 1, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_0289
    pl_BufferItemName 0, PVAR_8000
    pl_msg_talk 39  // Pearl bank 350 line 37
    pl_GoTo T378_1_0291

T378_1_0289:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 40  // Pearl bank 350 line 25

T378_1_0291:
    pl_PlayFanfare SEQ_ME_KINOMI  // Pearl SEQ_KINOMI
    pl_WaitFanfare
    pl_stub HarvestBerry  // Pearl 0x185 TakeBerryTreeBerries : not translated yet
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_02B4
    pl_BufferItemName 1, PVAR_8000
    pl_GoTo T378_1_02B9

T378_1_02B4:
    pl_BufferItemName 1, PVAR_8000  // GetItemNamePlural

T378_1_02B9:
    pl_GetItemPocket PVAR_8000, PVAR_800C
    pl_BufferPocketName 3, PVAR_800C
    pl_msg_talk 41  // Pearl bank 350 line 27
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_02CF:
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_02E7
    pl_BufferItemName 0, PVAR_8000
    pl_GoTo T378_1_02EC

T378_1_02E7:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural

T378_1_02EC:
    pl_msg_talk 42  // Pearl bank 350 line 26
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_02F7:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0310
    pl_GoTo T378_1_01F2

T378_1_0310:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_032E
    pl_BufferItemName 1, PVAR_8000
    pl_msg_talk 43  // Pearl bank 350 line 36
    pl_GoTo T378_1_0336

T378_1_032E:
    pl_BufferItemName 1, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 44  // Pearl bank 350 line 24

T378_1_0336:
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_033E:
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0374
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_054B
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_BufferItemName 0, PVAR_800C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 45  // Pearl bank 350 line 1
    pl_GoTo T378_1_04DA

T378_1_0374:
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, T378_1_0540
    pl_Call T378_1_018E
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_03B4
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0540
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 46  // Pearl bank 350 line 0
    pl_GoTo T378_1_04DA

T378_1_03B4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 46  // Pearl bank 350 line 0
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0413
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 47, 65535, 0  // Pearl AddMenuEntryImm 2, 0
    ListMenuAdd 48, 65535, 1  // Pearl AddMenuEntryImm 3, 1
    ListMenuAdd 49, 65535, 2  // Pearl AddMenuEntryImm 4, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T378_1_042D
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T378_1_04EE
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T378_1_053A
    pl_GoTo T378_1_053A

T378_1_0413:
    pl_msg_talk 50  // Pearl bank 350 line 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_042D
    pl_GoTo T378_1_053A

T378_1_042D:
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenBag  // Pearl 0x178 ShowBagScreen 0: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_stub GetSelectedItem  // Pearl 0x179 GetBagScreenSelection 32773: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_8005
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T378_1_053C
    pl_CompareVarToValue PVAR_8008, 95
    pl_GoToIf 1, T378_1_049D
    pl_CompareVarToValue PVAR_8008, 96
    pl_GoToIf 1, T378_1_049D
    pl_CompareVarToValue PVAR_8008, 97
    pl_GoToIf 1, T378_1_049D
    pl_CompareVarToValue PVAR_8008, 98
    pl_GoToIf 1, T378_1_049D
    pl_GoTo T378_1_053C

T378_1_049D:
    pl_RemoveItem PVAR_8005, 1, PVAR_8004
    pl_stub SetBerryMulch  // Pearl 0x182 SetBerryTreeMulch 32773: not translated yet
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_04CA
    pl_BufferItemName 0, PVAR_8005
    pl_msg_talk 51  // Pearl bank 350 line 11
    pl_GoTo T378_1_04DA

T378_1_04CA:
    pl_BufferItemName 0, PVAR_8005
    pl_msg_talk 52  // Pearl bank 350 line 30
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_04DA:
    pl_msg_talk 53  // Pearl bank 350 line 8
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_053A

T378_1_04EE:
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenBag  // Pearl 0x178 ShowBagScreen 1: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_stub GetSelectedItem  // Pearl 0x179 GetBagScreenSelection 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_053C
    pl_BufferItemName 0, PVAR_800C
    pl_msg_talk 54  // Pearl bank 350 line 12
    pl_WaitButton
    pl_RemoveItem PVAR_800C, 1, PVAR_8004
    pl_stub PlantBerry  // Pearl 0x183 SetBerryTreeType 32780: not translated yet
    pl_GoTo T378_1_053A

T378_1_053A:
    pl_CloseMessage

T378_1_053C:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T378_1_0540:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 55  // Pearl bank 350 line 28
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_054B:
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_BufferItemName 0, PVAR_800C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 56  // Pearl bank 350 line 29
    pl_WaitButton
    pl_GoTo T378_1_053A

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
