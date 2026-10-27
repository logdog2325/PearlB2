// MAP_CELESTIC_POKECENTER_1F: Pearl script file 1014, text bank 528. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive; 107: Pearl 2508
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1014_S1
    ScriptEntry P1014_S2
    ScriptEntry P1014_S3
    ScriptEntry P1014_S4
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_2508
    ScriptEntriesEnd

P1014_S1:
P1014_0012:
    pl_SetVarFromValue PVAR_8007, 0
    VMCall C205_3_S3  // CallCommonScript 2002 (Pearl file 205 script 3)
    pl_End

P1014_S2:
P1014_001E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1014_S3:
P1014_0031:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1014_S4:
P1014_0044:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0AA1
    pl_GoToIf 1, P1014_00C0
    pl_msg_talk 2
    pl_GetFirstNonEggInParty PVAR_8000
    PokePartyGetHappiness PVAR_800C, PVAR_8000
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P1014_0084
    pl_CompareVarToValue PVAR_800C, 50
    pl_GoToIf 4, P1014_00CB
    pl_GoTo P1014_00D6

P1014_0084:
    pl_msg_talk 3
    pl_SetVarFromValue PVAR_8004, 3
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1014_00B6
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0AA1
    pl_GoTo P1014_00C0

P1014_00B6:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1014_00C0:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1014_00CB:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1014_00D6:
    pl_msg_talk 6
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
    pl_msg_sys 7  // Pearl bank 199 line 0
    VMJump .Lmv121_end
.Lmv121_0:
    WorkCmpConst PVAR_8004, 120
    VMJumpIf CMP_NE, .Lmv121_120
    pl_msg_sys 8  // Pearl bank 199 line 120
    VMJump .Lmv121_end
.Lmv121_120:
    pl_msg_sys 9  // Pearl bank 199 line 121
.Lmv121_end:
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_0152
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_3_0145
    VMReturn  // End: the sub-script ends

C205_3_0145:
    pl_msg_sys 10  // Pearl bank 199 line 3
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
    pl_msg_sys 11  // Pearl bank 199 line 1
    pl_Return

C205_3_019C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 7
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
    pl_msg_sys 13  // Pearl bank 199 line 2
    pl_ApplyMovement PL_PLAYER, C205_3_02D4
    pl_WaitMovement
// SetPlayerState 1: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    pl_ApplyMovement PVAR_8007, C205_3_02C0
    pl_WaitMovement
    pl_msg_sys 10  // Pearl bank 199 line 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_01F8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 199 line 8
    pl_ApplyMovement PL_PLAYER, C205_3_02D4
    pl_WaitMovement
// SetPlayerState 1: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    pl_ApplyMovement PVAR_8007, C205_3_02C0
    pl_WaitMovement
    pl_msg_sys 15  // Pearl bank 199 line 9
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
    pl_msg_sys 16  // Pearl bank 199 line 10
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
    pl_msg_sys 17  // Pearl bank 199 line 4
    pl_BufferPlayerName 0
    pl_msg_sys 18  // Pearl bank 199 line 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_02B4
    pl_msg_sys 15  // Pearl bank 199 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_0290:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_02B4
    pl_msg_sys 15  // Pearl bank 199 line 9
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
    pl_msg_sys 20  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 28
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
    pl_msg_sys 22  // Pearl bank 199 line 25
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
    pl_msg_sys 23  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:18 (a subroutine here)
C205_18_S18:
C205_18_0B60:
    pl_Call C205_18_0B6A
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_18_0B6A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 27
    pl_WaitButton
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
