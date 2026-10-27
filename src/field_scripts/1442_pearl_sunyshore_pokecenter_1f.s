// MAP_SUNYSHORE_POKECENTER_1F: Pearl script file 155, text bank 157. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive; 107: Pearl 2508
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P155_S1
    ScriptEntry P155_S2
    ScriptEntry P155_S3
    ScriptEntry P155_S4
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

P155_S1:
P155_0012:
    pl_SetVarFromValue PVAR_8007, 0
    VMCall C205_3_S3  // CallCommonScript 2002 (Pearl file 205 script 3)
    pl_End

P155_S2:
P155_001E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P155_S3:
P155_0031:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 7, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P155_0057
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P155_0057:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P155_S4:
P155_0062:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
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
    pl_msg_sys 4  // Pearl bank 199 line 0
    VMJump .Lmv121_end
.Lmv121_0:
    WorkCmpConst PVAR_8004, 120
    VMJumpIf CMP_NE, .Lmv121_120
    pl_msg_sys 5  // Pearl bank 199 line 120
    VMJump .Lmv121_end
.Lmv121_120:
    pl_msg_sys 6  // Pearl bank 199 line 121
.Lmv121_end:
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_0152
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_3_0145
    VMReturn  // End: the sub-script ends

C205_3_0145:
    pl_msg_sys 7  // Pearl bank 199 line 3
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
    pl_msg_sys 8  // Pearl bank 199 line 1
    pl_Return

C205_3_019C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9  // Pearl bank 199 line 7
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
    pl_msg_sys 10  // Pearl bank 199 line 2
    pl_ApplyMovement PL_PLAYER, C205_3_02D4
    pl_WaitMovement
// SetPlayerState 1: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    pl_ApplyMovement PVAR_8007, C205_3_02C0
    pl_WaitMovement
    pl_msg_sys 7  // Pearl bank 199 line 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_01F8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 8
    pl_ApplyMovement PL_PLAYER, C205_3_02D4
    pl_WaitMovement
// SetPlayerState 1: nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
// ChangePlayerState : nothing in Black 2 (the player's avatar state (the Pokemon Center bow): Black 2 does its own)
    pl_ApplyMovement PVAR_8007, C205_3_02C0
    pl_WaitMovement
    pl_msg_sys 12  // Pearl bank 199 line 9
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
    pl_msg_sys 13  // Pearl bank 199 line 10
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
    pl_msg_sys 14  // Pearl bank 199 line 4
    pl_BufferPlayerName 0
    pl_msg_sys 15  // Pearl bank 199 line 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_02B4
    pl_msg_sys 12  // Pearl bank 199 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_3_0290:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_3_02B4
    pl_msg_sys 12  // Pearl bank 199 line 9
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
