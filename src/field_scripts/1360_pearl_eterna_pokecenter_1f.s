// MAP_ETERNA_POKECENTER_1F: Pearl script file 73, text bank 82. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive; 107: Pearl 2508
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P73_S1
    ScriptEntry P73_S2
    ScriptEntry P73_S3
    ScriptEntry P73_S4
    ScriptEntry P73_S5
    ScriptEntry P73_S6
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_2508
    ScriptEntriesEnd

P73_S1:
P73_001A:
    pl_SetVarFromValue PVAR_8007, 3
    VMCall C205_3_S3  // CallCommonScript 2002 (Pearl file 205 script 3)
    pl_End

P73_S2:
P73_0026:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_S3:
P73_0039:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_S4:
P73_004C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0081
    pl_GoToIf 1, P73_006A
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_006A:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_S5:
P73_0075:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 427
    pl_msg_talk 4
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_S6:
P73_0094:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P73_010B
    pl_CheckPoketchAppRegistered 5, PVAR_800C  // Friendship Checker
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P73_00F0
    pl_GetFirstNonEggInParty PVAR_8000
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_msg_talk 7
    PokePartyGetHappiness PVAR_800C, PVAR_8000
    pl_CompareVarToValue PVAR_800C, 120
    pl_GoToIf 4, P73_0116
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P73_0121
    pl_GoTo P73_012C

P73_00F0:
    pl_msg_talk 5
    pl_SetVarFromValue PVAR_4000, 1
    pl_SetVarFromValue PVAR_8004, 5
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_010B:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_0116:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_0121:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P73_012C:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlProxy_2508:                  // Pearl global script 2508 (run by this zone's events)
    VMCall C1_9_S9
    VMHalt

// ---- Pearl global script 205:3 (a subroutine here)
C205_3_S3:
C205_3_00CE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSetConst PVAR_800C, 0  // GetTrainerCardLevel
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 4, C205_3_025A
    pl_SetVarFromValue PVAR_8004, 0
    pl_GetTimeOfDay PVAR_800C
// Dummy1F9 32780: nothing in Black 2 (a debug command)
    pl_SetVarFromValue PVAR_8004, 120
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_0121
    pl_SetVarFromValue PVAR_8004, 121
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_3_0121
    pl_SetVarFromValue PVAR_8004, 0

C205_3_0121:
    MsgWinCloseAll  // another speaker: close the first window
    WorkCmpConst PVAR_8004, 0
    VMJumpIf CMP_NE, .Lmv121_0
    pl_msg_sys 11  // Pearl bank 199 line 0
    VMJump .Lmv121_end
.Lmv121_0:
    WorkCmpConst PVAR_8004, 120
    VMJumpIf CMP_NE, .Lmv121_120
    pl_msg_sys 12  // Pearl bank 199 line 120
    VMJump .Lmv121_end
.Lmv121_120:
    pl_msg_sys 13  // Pearl bank 199 line 121
.Lmv121_end:
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_0152
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_3_0145
    VMReturn  // End: the sub-script ends

C205_3_0145:
    pl_msg_sys 14  // Pearl bank 199 line 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_0152:
// SetPlayerState 256: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    pl_ApplyMovement PL_PLAYER, C205_3_02CC
    pl_WaitMovement
    WorkSetConst PVAR_800C, 0  // GetTrainerCardLevel
    pl_CompareVarToValue PVAR_800C, 4
    pl_CallIf 4, C205_3_019C
    pl_CompareVarToValue PVAR_800C, 4
    pl_CallIf 0, C205_3_0197
    pl_Call C205_3_01A1
    pl_CheckFlag PFLAG_006A
    pl_GoToIf 0, C205_3_0222
    pl_GoTo C205_3_01C1

C205_3_0197:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15  // Pearl bank 199 line 1
    pl_Return

C205_3_019C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 7
    pl_Return

C205_3_01A1:
    pl_ApplyMovement PVAR_8007, C205_3_11C8
    pl_WaitMovement
    pl_CountPartyNonEggs PVAR_8006
    pl_PlayPokecenterHealingAnimation PVAR_8006
    pl_ApplyMovement PVAR_8007, C205_3_11E0
    pl_WaitMovement
    pl_HealParty
    pl_Return

C205_3_01C1:
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, C205_3_01F8
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 17  // Pearl bank 199 line 2
    pl_ApplyMovement PL_PLAYER, C205_3_02D4
    pl_WaitMovement
// SetPlayerState 1: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    pl_ApplyMovement PVAR_8007, C205_3_02C0
    pl_WaitMovement
    pl_msg_sys 14  // Pearl bank 199 line 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_01F8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 18  // Pearl bank 199 line 8
    pl_ApplyMovement PL_PLAYER, C205_3_02D4
    pl_WaitMovement
// SetPlayerState 1: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    pl_ApplyMovement PVAR_8007, C205_3_02C0
    pl_WaitMovement
    pl_msg_sys 19  // Pearl bank 199 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_0222:
    pl_CheckPartyPokerus PVAR_8006
    pl_CompareVarToValue PVAR_8006, 1
    pl_GoToIf 1, C205_3_0239
    pl_GoTo C205_3_01C1

C205_3_0239:
    pl_SetFlag PFLAG_006A
    pl_ApplyMovement PL_PLAYER, C205_3_02D4
    pl_WaitMovement
// SetPlayerState 1: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_025A:
    pl_CheckFlag PFLAG_0069
    pl_GoToIf 1, C205_3_0290
    pl_SetFlag PFLAG_0069
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 4
    pl_BufferPlayerName 0
    pl_msg_sys 22  // Pearl bank 199 line 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_02B4
    pl_msg_sys 19  // Pearl bank 199 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_0290:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_02B4
    pl_msg_sys 19  // Pearl bank 199 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_02B4:
    pl_SetVarFromValue PVAR_8004, 1
    pl_GoTo C205_3_0152

    .balign 4, 0
C205_3_02C0:
    Move 100, 1  // POKECENTER_NURSE_BOW  // approx.: Pearl: bow anim 8 frames then face south; B2: bow anim until it ends. 
    Move 62, 1  // DELAY_4
    MoveEnd

    .balign 4, 0
C205_3_02CC:
    Move 102, 1  // PLAYER_GIVE  // approx.: Pearl: player anim 0 for 21 frames; B2: anim 1 for 40 frames. Same rol
    MoveEnd

    .balign 4, 0
C205_3_02D4:
    Move 104, 1  // PLAYER_RECEIVE  // approx.: Pearl: player anim 1 for 21 frames; B2: anim 2 for 41 frames. Same rol
    MoveEnd

    .balign 4, 0
C205_3_11C8:
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
C205_3_11E0:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

// ---- Pearl global script 205:10 (a subroutine here)
C205_10_S10:
C205_10_069C:
    pl_Call C205_10_06A6
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_10_06A6:
    pl_BufferPlayerName 0
// BufferPoketchAppName 1, PVAR_8004: the lines naming the app have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_POCKETCH
    MsgWinCloseAll  // another speaker: close the first window
    pl_CompareVarToValue PVAR_8004, 5
    pl_GoToIf 1, C205_10_06B2_App5
    pl_msg_sys 24  // Pearl bank 199 line 24: another one (no caller here sets it)
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App5:
    pl_msg_sys 25  // naming Friendship Checker
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_AppDone:
    pl_WaitFanfare
    pl_msg_sys 26  // Pearl bank 199 line 26
    pl_RegisterPoketchApp PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, C205_10_0805
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, C205_10_080A
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, C205_10_080F
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, C205_10_0814
    pl_CompareVarToValue PVAR_8004, 4
    pl_CallIf 1, C205_10_0819
    pl_CompareVarToValue PVAR_8004, 5
    pl_CallIf 1, C205_10_081E
    pl_CompareVarToValue PVAR_8004, 6
    pl_CallIf 1, C205_10_0823
    pl_CompareVarToValue PVAR_8004, 7
    pl_CallIf 1, C205_10_0828
    pl_CompareVarToValue PVAR_8004, 8
    pl_CallIf 1, C205_10_082D
    pl_CompareVarToValue PVAR_8004, 9
    pl_CallIf 1, C205_10_0832
    pl_CompareVarToValue PVAR_8004, 10
    pl_CallIf 1, C205_10_0837
    pl_CompareVarToValue PVAR_8004, 11
    pl_CallIf 1, C205_10_083C
    pl_CompareVarToValue PVAR_8004, 12
    pl_CallIf 1, C205_10_0841
    pl_CompareVarToValue PVAR_8004, 13
    pl_CallIf 1, C205_10_0846
    pl_CompareVarToValue PVAR_8004, 14
    pl_CallIf 1, C205_10_084B
    pl_CompareVarToValue PVAR_8004, 15
    pl_CallIf 1, C205_10_0850
    pl_CompareVarToValue PVAR_8004, 16
    pl_CallIf 1, C205_10_0855
    pl_CompareVarToValue PVAR_8004, 17
    pl_CallIf 1, C205_10_085A
    pl_CompareVarToValue PVAR_8004, 18
    pl_CallIf 1, C205_10_085F
    pl_CompareVarToValue PVAR_8004, 19
    pl_CallIf 1, C205_10_0864
    pl_CompareVarToValue PVAR_8004, 20
    pl_CallIf 1, C205_10_0869
    pl_CompareVarToValue PVAR_8004, 21
    pl_CallIf 1, C205_10_086E
    pl_CompareVarToValue PVAR_8004, 22
    pl_CallIf 1, C205_10_0873
    pl_CompareVarToValue PVAR_8004, 23
    pl_CallIf 1, C205_10_0878
    pl_CompareVarToValue PVAR_8004, 24
    pl_CallIf 1, C205_10_087D
    pl_Return

C205_10_0805:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 83
    pl_Return

C205_10_080A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 84
    pl_Return

C205_10_080F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 85
    pl_Return

C205_10_0814:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 86
    pl_Return

C205_10_0819:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 87
    pl_Return

C205_10_081E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 88
    pl_Return

C205_10_0823:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 89
    pl_Return

C205_10_0828:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 90
    pl_Return

C205_10_082D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 91
    pl_Return

C205_10_0832:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 199 line 92
    pl_Return

C205_10_0837:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 199 line 93
    pl_Return

C205_10_083C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 199 line 94
    pl_Return

C205_10_0841:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 95
    pl_Return

C205_10_0846:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 40  // Pearl bank 199 line 96
    pl_Return

C205_10_084B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41  // Pearl bank 199 line 97
    pl_Return

C205_10_0850:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 42  // Pearl bank 199 line 98
    pl_Return

C205_10_0855:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 43  // Pearl bank 199 line 99
    pl_Return

C205_10_085A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 44  // Pearl bank 199 line 100
    pl_Return

C205_10_085F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 45  // Pearl bank 199 line 101
    pl_Return

C205_10_0864:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 46  // Pearl bank 199 line 102
    pl_Return

C205_10_0869:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 47  // Pearl bank 199 line 103
    pl_Return

C205_10_086E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 48  // Pearl bank 199 line 104
    pl_Return

C205_10_0873:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 49  // Pearl bank 199 line 105
    pl_Return

C205_10_0878:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 50  // Pearl bank 199 line 106
    pl_Return

C205_10_087D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 51  // Pearl bank 199 line 107
    pl_Return

// ---- Pearl global script 1:9 (a subroutine here)
C1_9_S9:
C1_9_00AE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    CallPlaceSelect PL_TMP, PL_TMP2  // OpenRegionMap: the Sinnoh town map, view-only here (patches/town_map.py)
// RestoreOverworld: Black 2's CallPlaceSelect reopened the field itself
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
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
