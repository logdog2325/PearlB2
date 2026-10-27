// MAP_WAYWARD_CAVE_1F: Pearl script file 310, text bank 253. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive; 93: Pearl 10001, 94: Pearl 10002
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P310_S1
    ScriptEntry P310_S2
    ScriptEntry P310_S3
    ScriptEntry P310_S4
    ScriptEntry P310_S5
    ScriptEntry P310_S6
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
    ScriptEntry PearlProxy_10001
    ScriptEntry PearlProxy_10002
    ScriptEntriesEnd

P310_S1:
P310_001A:
    pl_SetFlag PFLAG_09D7
    pl_CheckFlag PFLAG_00E4
    pl_GoToIf 0, P310_002B
    pl_End

P310_002B:
    pl_SetVarFromValue PVAR_4091, 0
    pl_End

P310_S2:
P310_0033:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub SetPlayerBike  // Pearl 0x0C8 RideBike 0: not translated yet
    pl_CompareVarToValue PVAR_4091, 1
    pl_GoToIf 4, P310_009D
    pl_BufferPlayerName 0
    pl_CheckFlag PFLAG_00E0
    pl_CallIf 0, P310_0093
    pl_CheckFlag PFLAG_00E0
    pl_CallIf 1, P310_0098
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_GONIN
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_WaitFanfare
    pl_SetFlag PFLAG_00E0
    pl_SetVarFromValue PVAR_4091, 1
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_403F, 612
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start_ally 4, PTRAINER_612, 0  // Pearl SetMovementType 4, 0x30 with partner trainer 612 (var 0x403F): follows and battles with you (in this zone only)
    pl_ReleaseAll
    pl_End

P310_0093:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 0
    pl_Return

P310_0098:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_Return

P310_009D:
    pl_CompareVarToValue PVAR_40E2, 2
    pl_GoToIf 4, P310_00CC
    pl_CompareVarToValue PVAR_40E2, 1
    pl_GoToIf 1, P310_00C3
    pl_BufferPlayerName 0
    pl_msg_talk 9
    pl_GoTo P310_00DA

P310_00C3:
    pl_msg_talk 10
    pl_GoTo P310_00DA

P310_00CC:
    pl_BufferPlayerName 0
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P310_00DA:
    pl_AddVar PVAR_40E2, 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P310_S3:
P310_00E8:
    pl_End

P310_S4:
P310_00EA:
    pl_LockAll
    pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)
    pl_follow_hold 4, 16  // Pearl SetMovementType 4, 16: the follower stops to be moved by the script
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P310_010B
    pl_GoTo P310_0123

P310_010B:
    pl_ApplyMovement PL_PLAYER, P310_019C
    pl_ApplyMovementF 4, P310_01E0  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P310_013B

P310_0123:
    pl_ApplyMovement PL_PLAYER, P310_01A4
    pl_ApplyMovementF 4, P310_01EC  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P310_013B

P310_013B:
    pl_BufferPlayerName 0
    pl_msg_sys 5
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P310_015A
    pl_GoTo P310_0172

P310_015A:
    pl_ApplyMovement PL_PLAYER, P310_01AC
    pl_ApplyMovementF 4, P310_01F8  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P310_018A

P310_0172:
    pl_ApplyMovement PL_PLAYER, P310_01B8
    pl_ApplyMovementF 4, P310_0208  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P310_018A

P310_018A:
    pl_follow_leave
    pl_RemoveObject 4, PFLAG_0202
    pl_SetFlag PFLAG_00E4
    pl_SetVarFromValue PVAR_4091, 2
    pl_ReleaseAll
    pl_End

P310_S5:
P310_0218:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P310_S6:
P310_022B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P310_019C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P310_01A4:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P310_01AC:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P310_01B8:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P310_01E0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P310_01EC:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P310_01F8:
    Move 63, 3  // DELAY_8
    Move 14, 1  // WALK_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P310_0208:
    Move 63, 3  // DELAY_8
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

PearlProxy_10001:                  // Pearl global script 10001 (run by this zone's events)
    VMCall T375_2_S2
    VMHalt

PearlProxy_10002:                  // Pearl global script 10002 (run by this zone's events)
    VMCall T375_3_S3
    VMHalt

// ---- Pearl global script 375:2 (a subroutine here)
T375_2_S2:
T375_2_0139:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    PokePartyHasMoveAny PVAR_800C, 249  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_2_018B
    pl_CheckBadgeAcquired 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_018B
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12  // Pearl bank 334 line 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_019A
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_018B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13  // Pearl bank 334 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_019A:
    pl_BufferPartyMonNickname 0, PVAR_8004
    pl_msg_talk 14  // Pearl bank 334 line 5
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 1: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 284  // GetCurrentMapID: Pearl map 284
// CreateJournalEvent 24, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)

T375_2_01C8:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, T375_2_01C8
    pl_GoTo T375_2_055B

T375_2_055B:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 375:3 (a subroutine here)
T375_3_S3:
T375_3_022A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    FlagGet 2404, PVAR_800C  // GetSetStrength 2: is Strength on (Black 2's flag 0x964)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T375_3_02D3
    PokePartyHasMoveAny PVAR_800C, 70  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_3_0288
    pl_CheckBadgeAcquired 5, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_3_0288
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15  // Pearl bank 334 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_3_0297
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0288:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 16  // Pearl bank 334 line 8
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0297:
    FlagSet 2404  // GetSetStrength 1: Strength on (Black 2's flag 0x964, the push reads it)
    PokePartyHasMoveAny PVAR_800C, 70  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_talk 17  // Pearl bank 334 line 10
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
    pl_CloseMessage
    pl_msg_talk 18  // Pearl bank 334 line 11
    pl_WaitButton
    pl_CloseMessage
    WorkSetConst PVAR_8004, 284  // GetCurrentMapID: Pearl map 284
// CreateJournalEvent 22, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo T375_3_055B

T375_3_02D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 19  // Pearl bank 334 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_055B:
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
