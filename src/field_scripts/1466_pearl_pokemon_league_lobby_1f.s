// MAP_POKEMON_LEAGUE_LOBBY_1F: Pearl script file 180, text bank 175. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; no warp continuations; 8: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P180_S1
    ScriptEntry P180_S2
    ScriptEntry P180_S3
    ScriptEntry P180_S4
    ScriptEntry P180_S5
    ScriptEntry P180_S6
    ScriptEntry P180_S7
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P180_S5:
P180_001E:
    pl_SetFlag PFLAG_09F4
    pl_SetFlag PFLAG_02A0
    pl_SetFlag PFLAG_02A1
    pl_SetFlag PFLAG_02A2
    pl_SetFlag PFLAG_02A3
    pl_ClearFlag PFLAG_02A4
    pl_ClearFlag PFLAG_02A5
    pl_ClearFlag PFLAG_02A6
    pl_ClearFlag PFLAG_02A7
    pl_ClearFlag PFLAG_00B0
    pl_ClearFlag PFLAG_00B1
    pl_ClearFlag PFLAG_00B2
    pl_ClearFlag PFLAG_00B3
    pl_CheckFlag PFLAG_00AF
    pl_GoToIf 1, P180_005F
    pl_End

P180_005F:
    pl_SetObjectEventPos 0, 12, 3, 1, -1  // object 0
    pl_End

P180_S1:
P180_0069:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00AF
    pl_GoToIf 1, P180_00F3
    pl_msg_talk 2
    pl_CloseMessage
    pl_PlayFanfare SEQ_ME_BADGE  // Pearl SEQ_BADGE
    pl_WaitFanfare
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P180_00B4
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P180_00C4
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P180_00D4
    pl_End

P180_00B4:
    pl_ApplyMovement 0, P180_0100
    pl_WaitMovement
    pl_GoTo P180_00E4

P180_00C4:
    pl_ApplyMovement 0, P180_010C
    pl_WaitMovement
    pl_GoTo P180_00E4

P180_00D4:
    pl_ApplyMovement 0, P180_0118
    pl_WaitMovement
    pl_GoTo P180_00E4

P180_00E4:
    pl_SetFlag PFLAG_00AF
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P180_00F3:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P180_S2:
P180_0124:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 1
    pl_ReleaseAll
    pl_End

P180_S3:
P180_013A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 18  // Pearl SpecialMart 18: Black 2's normal Mart for now
    pl_ReleaseAll
    pl_End

P180_S4:
P180_0150:
    pl_LockAll
    pl_ClearFlag PFLAG_023B
    pl_AddObject 5
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 10
    pl_GoToIf 1, P180_018D
    pl_CompareVarToValue PVAR_8004, 11
    pl_GoToIf 1, P180_019D
    pl_CompareVarToValue PVAR_8004, 12
    pl_GoToIf 1, P180_01AD
    pl_End

P180_018D:
    pl_ApplyMovement 5, P180_02BC
    pl_WaitMovement
    pl_GoTo P180_01BD

P180_019D:
    pl_ApplyMovement 5, P180_02CC
    pl_WaitMovement
    pl_GoTo P180_01BD

P180_01AD:
    pl_ApplyMovement 5, P180_02D4
    pl_WaitMovement
    pl_GoTo P180_01BD

P180_01BD:
    pl_ApplyMovement PL_PLAYER, P180_02B4
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 0
    pl_CloseMessage
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P180_01FF
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P180_020B
    pl_GoTo P180_01F3

P180_01F3:
    pl_StartTrainerBattle PTRAINER_479, 0
    pl_GoTo P180_0217

P180_01FF:
    pl_StartTrainerBattle PTRAINER_480, 0
    pl_GoTo P180_0217

P180_020B:
    pl_StartTrainerBattle PTRAINER_481, 0
    pl_GoTo P180_0217

P180_0217:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P180_02A8
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 1
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 10
    pl_GoToIf 1, P180_0262
    pl_CompareVarToValue PVAR_8004, 11
    pl_GoToIf 1, P180_0272
    pl_CompareVarToValue PVAR_8004, 12
    pl_GoToIf 1, P180_0282
    pl_End

P180_0262:
    pl_ApplyMovement 5, P180_02E4
    pl_WaitMovement
    pl_GoTo P180_0292

P180_0272:
    pl_ApplyMovement 5, P180_02F4
    pl_WaitMovement
    pl_GoTo P180_0292

P180_0282:
    pl_ApplyMovement 5, P180_02FC
    pl_WaitMovement
    pl_GoTo P180_0292

P180_0292:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 5, PFLAG_023B
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetVarFromValue PVAR_40EF, 1
    pl_ReleaseAll
    pl_End

P180_02A8:
    pl_SetFlag PFLAG_023B
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P180_S6:
P180_030C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P180_S7:
P180_031F:
    pl_SetVarFromValue PVAR_8007, 3
    VMCall C205_3_S3  // CallCommonScript 2002 (Pearl file 205 script 3)
    pl_End

    .balign 4, 0
P180_0100:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P180_010C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P180_0118:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P180_02B4:
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P180_02BC:
    Move 16, 3  // WALK_FAST_NORTH
    Move 18, 1  // WALK_FAST_WEST
    Move 16, 3  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P180_02CC:
    Move 16, 6  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P180_02D4:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 1  // WALK_FAST_EAST
    Move 16, 3  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P180_02E4:
    Move 17, 3  // WALK_FAST_SOUTH
    Move 19, 1  // WALK_FAST_EAST
    Move 17, 3  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P180_02F4:
    Move 17, 6  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P180_02FC:
    Move 17, 3  // WALK_FAST_SOUTH
    Move 18, 1  // WALK_FAST_WEST
    Move 17, 3  // WALK_FAST_SOUTH
    MoveEnd

// ---- Pearl global script 205:20 (a subroutine here)
C205_20_S20:
C205_20_0F28:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6  // Pearl bank 199 line 37
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

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

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
