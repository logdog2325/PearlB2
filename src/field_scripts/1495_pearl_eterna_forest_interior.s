// MAP_ETERNA_FOREST_INTERIOR: Pearl script file 213, text bank 213. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-12: Pearl's; no warp continuations; 13: PearlArrive; 81: Pearl 9702, 92: Pearl 10000
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P213_S1
    ScriptEntry P213_S2
    ScriptEntry P213_S3
    ScriptEntry P213_S4
    ScriptEntry P213_S5
    ScriptEntry P213_S6
    ScriptEntry P213_S7
    ScriptEntry P213_S8
    ScriptEntry P213_S9
    ScriptEntry P213_S10
    ScriptEntry P213_S11
    ScriptEntry P213_S12
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
    ScriptEntry PearlProxy_9702
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10000
    ScriptEntriesEnd

P213_S12:
P213_0032:
    pl_CheckFlag PFLAG_00E3
    pl_GoToIf 0, P213_003F
    pl_End

P213_003F:
    pl_SetVarFromValue PVAR_40B1, 0
    pl_End

P213_S1:
P213_0047:
    pl_LockAll
    pl_stub SetPlayerBike  // Pearl 0x0C8 RideBike 0: not translated yet
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 28
    pl_GoToIf 1, P213_006E
    pl_CompareVarToValue PVAR_8004, 29
    pl_GoToIf 1, P213_007E
    pl_End

P213_006E:
    pl_ApplyMovementF 0, P213_00E8  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P213_008E

P213_007E:
    pl_ApplyMovementF 0, P213_00F4  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P213_008E

P213_008E:
    pl_CheckFlag PFLAG_008B
    pl_CallIf 0, P213_00D8
    pl_CheckFlag PFLAG_008B
    pl_CallIf 1, P213_00E0
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_GONIN
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_WaitFanfare
    pl_SetFlag PFLAG_008B
    pl_SetVarFromValue PVAR_40B1, 1
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_403F, 608
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start_ally 0, PTRAINER_608, 0  // Pearl SetMovementType 0, 0x30 with partner trainer 608 (var 0x403F): follows and battles with you (in this zone only)
// SetObjectFlagIsPersistent 0, 1: not needed in Black 2
    pl_ReleaseAll
    pl_End

P213_00D8:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_Return

P213_00E0:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3
    pl_Return

P213_S2:
P213_0108:
    pl_LockAll
    pl_follow_leave  // ClearHasPartner: the follower stays behind
    pl_follow_hold 0, 15  // Pearl SetMovementType 0, 15: the follower stops to be moved by the script
    pl_follow_end  // SetObjectFlagIsPersistent 0, 0: the follower stops following
    pl_ApplyMovementF 0, P213_0190  // (the follower once it follows)
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 28
    pl_GoToIf 1, P213_0148
    pl_CompareVarToValue PVAR_8004, 29
    pl_GoToIf 1, P213_0158
    pl_End

P213_0148:
    pl_ApplyMovementF 0, P213_0174  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P213_0168

P213_0158:
    pl_ApplyMovementF 0, P213_0180  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P213_0168

P213_0168:
    pl_SetVarFromValue PVAR_40B1, 0
    pl_ReleaseAll
    pl_End

P213_S3:
P213_0198:
    pl_LockAll
    pl_ApplyMovementF 0, P213_02B0  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P213_031C
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 5
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 34
    pl_GoToIf 1, P213_0203
    pl_CompareVarToValue PVAR_8005, 35
    pl_GoToIf 1, P213_021B
    pl_CompareVarToValue PVAR_8005, 36
    pl_GoToIf 1, P213_0233
    pl_CompareVarToValue PVAR_8005, 37
    pl_GoToIf 1, P213_024B
    pl_CompareVarToValue PVAR_8005, 38
    pl_GoToIf 1, P213_0263
    pl_GoTo P213_027B

P213_0203:
    pl_ApplyMovementF 0, P213_02BC  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P213_0328
    pl_WaitMovement
    pl_GoTo P213_0293

P213_021B:
    pl_ApplyMovementF 0, P213_02CC  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P213_033C
    pl_WaitMovement
    pl_GoTo P213_0293

P213_0233:
    pl_ApplyMovementF 0, P213_02DC  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P213_0350
    pl_WaitMovement
    pl_GoTo P213_0293

P213_024B:
    pl_ApplyMovementF 0, P213_02EC  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P213_0364
    pl_WaitMovement
    pl_GoTo P213_0293

P213_0263:
    pl_ApplyMovementF 0, P213_02FC  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P213_0378
    pl_WaitMovement
    pl_GoTo P213_0293

P213_027B:
    pl_ApplyMovementF 0, P213_030C  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P213_038C
    pl_WaitMovement
    pl_GoTo P213_0293

P213_0293:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_follow_leave  // ClearHasPartner: the follower stays behind
    pl_follow_leave
    pl_RemoveObject 0, PFLAG_01B9
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetFlag PFLAG_00E3
    pl_SetVarFromValue PVAR_40B1, 2
    pl_ReleaseAll
    pl_End

P213_S4:
P213_03A0:
    pl_LockAll
    pl_BufferPlayerName 0
    pl_ReleaseAll
    pl_End

P213_S5:
P213_03A9:
    pl_LockAll
    pl_BufferPlayerName 0
    pl_ReleaseAll
    pl_End

P213_S6:
P213_03B2:
    pl_LockAll
    pl_SetVarFromValue PVAR_40CD, 1
    pl_ReleaseAll
    pl_End

P213_S7:
P213_03BE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P213_S8:
P213_03D1:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_CloseMessage
    pl_ApplyMovement 24, P213_047C
    pl_WaitMovement
    pl_msg_talk 10
    pl_FacePlayer
    pl_msg_talk 11
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P213_042C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P213_043E
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P213_0450
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P213_0462
    pl_End

P213_042C:
    pl_ApplyMovement 24, P213_0490
    pl_WaitMovement
    pl_GoTo P213_0474

P213_043E:
    pl_ApplyMovement 24, P213_0484
    pl_WaitMovement
    pl_GoTo P213_0474

P213_0450:
    pl_ApplyMovement 24, P213_0484
    pl_WaitMovement
    pl_GoTo P213_0474

P213_0462:
    pl_ApplyMovement 24, P213_0484
    pl_WaitMovement
    pl_GoTo P213_0474

P213_0474:
    pl_RemoveObject 24, PFLAG_021A
    pl_ReleaseAll
    pl_End

P213_S9:
P213_04A0:
    pl_sign 12, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P213_S10:
P213_04B7:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 13, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P213_S11:
P213_04CC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P213_00E8:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P213_00F4:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P213_0174:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P213_0180:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P213_0190:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P213_02B0:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P213_02BC:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_02CC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_02DC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_02EC:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_02FC:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_030C:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 15, 5  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_031C:
    Move 63, 3  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P213_0328:
    Move 63, 2  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_033C:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_0350:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_0364:
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_0378:
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_038C:
    Move 63, 2  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_047C:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P213_0484:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 9  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P213_0490:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 10  // WALK_NORMAL_EAST
    MoveEnd

PearlProxy_9702:                  // Pearl global script 9702 (run by this zone's events)
    VMCall T387_3_S3
    VMHalt

PearlProxy_10000:                  // Pearl global script 10000 (run by this zone's events)
    VMCall T375_1_S1
    VMHalt

// ---- Pearl global script 387:3 (a subroutine here)
T387_3_S3:
T387_3_0146:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40E8, 2
    pl_GoToIf 4, T387_3_0181
    pl_CompareVarToValue PVAR_40E8, 1
    pl_GoToIf 1, T387_3_0176
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 14  // Pearl bank 378 line 14
    pl_GoTo T387_3_018F

T387_3_0176:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15  // Pearl bank 378 line 15
    pl_GoTo T387_3_018F

T387_3_0181:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 16  // Pearl bank 378 line 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T387_3_018F:
    pl_AddVar PVAR_40E8, 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 375:1 (a subroutine here)
T375_1_S1:
T375_1_0042:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    PokePartyHasMoveAny PVAR_800C, 15  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_1_008E
    pl_CheckBadgeAcquired 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_1_008E
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 17  // Pearl bank 334 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_1_009D
    pl_CloseMessage
    pl_GoTo T375_1_055B

T375_1_008E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 18  // Pearl bank 334 line 2
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_1_055B

T375_1_009D:
    PokePartyHasMoveAny PVAR_800C, 15  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_talk 19  // Pearl bank 334 line 1
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 0: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 7, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 203  // GetCurrentMapID: Pearl map 203
// CreateJournalEvent 19, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)

T375_1_00D7:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, T375_1_00D7
    pl_GoTo T375_1_055B

T375_1_055B:
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
