// MAP_STARK_MOUNTAIN_INTERIOR_2: Pearl script file 277, text bank 246. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive; 82: Pearl 9703, 93: Pearl 10001, 94: Pearl 10002, 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P277_S1
    ScriptEntry P277_S2
    ScriptEntry P277_S3
    ScriptEntry P277_S4
    ScriptEntry P277_S5
    ScriptEntry P277_S6
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
    ScriptEntry PearlProxy_9703
    ScriptEntry PearlNoScript
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
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

P277_S6:
P277_001A:
    pl_CompareVarToValue PVAR_4094, 2
    pl_GoToIf 0, P277_0029
    pl_End

P277_0029:
    pl_SetVarFromValue PVAR_4094, 0
    pl_End

P277_S1:
P277_0031:
    pl_LockAll
    pl_stub SetPlayerBike  // Pearl 0x0C8 RideBike 0: not translated yet
    pl_ApplyMovementF 14, P277_00D8  // (the follower once it follows)
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_CheckFlag PFLAG_00DD
    pl_CallIf 0, P277_0088
    pl_CheckFlag PFLAG_00DD
    pl_CallIf 1, P277_008D
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_GONIN
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_WaitFanfare
    pl_SetFlag PFLAG_00DD
    pl_SetVarFromValue PVAR_4094, 1
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_403F, 611
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start_ally 14, PTRAINER_611, 0  // Pearl SetMovementType 14, 0x30 with partner trainer 611 (var 0x403F): follows and battles with you (in this zone only)
    pl_ReleaseAll
    pl_End

P277_0088:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_Return

P277_008D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3
    pl_Return

P277_S2:
P277_0092:
    pl_LockAll
    pl_ApplyMovementF 14, P277_00E0  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P277_00C8
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4094, 0
    pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)
    pl_follow_hold 14, 15  // Pearl SetMovementType 14, 15: the follower stops to be moved by the script
    pl_ApplyMovementF 14, P277_00D0  // (the follower once it follows)
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P277_S3:
P277_00E8:
    pl_LockAll
    pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)
    pl_follow_hold 14, 15  // Pearl SetMovementType 14, 15: the follower stops to be moved by the script
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P277_010B
    pl_GoTo P277_0125

P277_010B:
    pl_ApplyMovementF 14, P277_0184  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P277_0178
    pl_WaitMovement
    pl_GoTo P277_013F

P277_0125:
    pl_ApplyMovementF 14, P277_0190  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P277_0178
    pl_WaitMovement
    pl_GoTo P277_013F

P277_013F:
    pl_ApplyMovementF 14, P277_0198  // (the follower once it follows)
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 5
    pl_CloseMessage
    pl_ApplyMovementF 14, P277_01A8  // (the follower once it follows)
    pl_WaitMovement
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_follow_leave
    pl_RemoveObject 14, PFLAG_01F8
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetVarFromValue PVAR_4094, 2
    pl_ReleaseAll
    pl_End

P277_S4:
P277_01B0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P277_S5:
P277_01C3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P277_00C8:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P277_00D0:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P277_00D8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P277_00E0:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P277_0178:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P277_0184:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P277_0190:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P277_0198:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 2  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P277_01A8:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

PearlProxy_9703:                  // Pearl global script 9703 (run by this zone's events)
    VMCall T387_4_S4
    VMHalt

PearlProxy_10001:                  // Pearl global script 10001 (run by this zone's events)
    VMCall T375_2_S2
    VMHalt

PearlProxy_10002:                  // Pearl global script 10002 (run by this zone's events)
    VMCall T375_3_S3
    VMHalt

PearlProxy_10003:                  // Pearl global script 10003 (run by this zone's events)
    VMCall C375_4_S4
    VMHalt

// ---- Pearl global script 387:4 (a subroutine here)
T387_4_S4:
T387_4_019D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40E1, 3
    pl_GoToIf 4, T387_4_01F0
    pl_CompareVarToValue PVAR_40E1, 2
    pl_GoToIf 1, T387_4_01E5
    pl_CompareVarToValue PVAR_40E1, 1
    pl_GoToIf 1, T387_4_01DA
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12  // Pearl bank 378 line 44
    pl_GoTo T387_4_01FB

T387_4_01DA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13  // Pearl bank 378 line 45
    pl_GoTo T387_4_01FB

T387_4_01E5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 14  // Pearl bank 378 line 46
    pl_GoTo T387_4_01FB

T387_4_01F0:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15  // Pearl bank 378 line 47
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T387_4_01FB:
    pl_AddVar PVAR_40E1, 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

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
    pl_msg_talk 16  // Pearl bank 334 line 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_019A
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_018B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 17  // Pearl bank 334 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_019A:
    pl_BufferPartyMonNickname 0, PVAR_8004
    pl_msg_talk 18  // Pearl bank 334 line 5
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 1: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 264  // GetCurrentMapID: Pearl map 264
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
    pl_msg_talk 19  // Pearl bank 334 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_3_0297
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0288:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20  // Pearl bank 334 line 8
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0297:
    FlagSet 2404  // GetSetStrength 1: Strength on (Black 2's flag 0x964, the push reads it)
    PokePartyHasMoveAny PVAR_800C, 70  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_talk 21  // Pearl bank 334 line 10
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
    pl_CloseMessage
    pl_msg_talk 22  // Pearl bank 334 line 11
    pl_WaitButton
    pl_CloseMessage
    WorkSetConst PVAR_8004, 264  // GetCurrentMapID: Pearl map 264
// CreateJournalEvent 22, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo T375_3_055B

T375_3_02D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 23  // Pearl bank 334 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_055B:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

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
    pl_msg_sys 24  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 27  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 16 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 52
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 3
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (52, 3) to (52, 10)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 52
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 10
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (52, 10) to (52, 3)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    WorkCmpConst PL_TMP, 86
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP2, 3
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc2  // from (86, 3) to (86, 10)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc2_next:
    WorkCmpConst PL_TMP, 86
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP2, 10
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc3  // from (86, 10) to (86, 3)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc3_next:
    WorkCmpConst PL_TMP, 44
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP2, 15
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc4  // from (44, 15) to (44, 22)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc4_next:
    WorkCmpConst PL_TMP, 44
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP2, 22
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc5  // from (44, 22) to (44, 15)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc5_next:
    WorkCmpConst PL_TMP, 41
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP2, 23
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc6  // from (41, 23) to (41, 30)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc6_next:
    WorkCmpConst PL_TMP, 41
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP2, 30
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc7  // from (41, 30) to (41, 23)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc7_next:
    WorkCmpConst PL_TMP, 69
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP2, 27
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc8  // from (69, 27) to (69, 36)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc8_next:
    WorkCmpConst PL_TMP, 69
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP2, 36
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc9  // from (69, 36) to (69, 27)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc9_next:
    WorkCmpConst PL_TMP, 38
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP2, 30
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc10  // from (38, 30) to (38, 37)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc10_next:
    WorkCmpConst PL_TMP, 38
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP2, 37
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc11  // from (38, 37) to (38, 30)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc11_next:
    WorkCmpConst PL_TMP, 38
    VMJumpIf CMP_NE, C375_4_03B3_rc12_next
    WorkCmpConst PL_TMP2, 50
    VMJumpIf CMP_NE, C375_4_03B3_rc12_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc12_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc12  // from (38, 50) to (38, 57)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc12_next:
    WorkCmpConst PL_TMP, 38
    VMJumpIf CMP_NE, C375_4_03B3_rc13_next
    WorkCmpConst PL_TMP2, 57
    VMJumpIf CMP_NE, C375_4_03B3_rc13_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc13_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc13  // from (38, 57) to (38, 50)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc13_next:
    WorkCmpConst PL_TMP, 21
    VMJumpIf CMP_NE, C375_4_03B3_rc14_next
    WorkCmpConst PL_TMP2, 65
    VMJumpIf CMP_NE, C375_4_03B3_rc14_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc14_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc14  // from (21, 65) to (21, 73)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc14_next:
    WorkCmpConst PL_TMP, 21
    VMJumpIf CMP_NE, C375_4_03B3_rc15_next
    WorkCmpConst PL_TMP2, 73
    VMJumpIf CMP_NE, C375_4_03B3_rc15_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc15_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc15  // from (21, 73) to (21, 65)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc15_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 53, 1
        Move 17, 5
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 52, 1
        Move 16, 5
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc2:
        Move 53, 1
        Move 17, 5
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc3:
        Move 52, 1
        Move 16, 5
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc4:
        Move 53, 1
        Move 17, 5
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc5:
        Move 52, 1
        Move 16, 5
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc6:
        Move 53, 1
        Move 17, 5
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc7:
        Move 52, 1
        Move 16, 5
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc8:
        Move 53, 1
        Move 17, 7
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc9:
        Move 52, 1
        Move 16, 7
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc10:
        Move 53, 1
        Move 17, 5
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc11:
        Move 52, 1
        Move 16, 5
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc12:
        Move 53, 1
        Move 17, 5
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc13:
        Move 52, 1
        Move 16, 5
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc14:
        Move 53, 1
        Move 17, 6
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc15:
        Move 52, 1
        Move 16, 6
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 264  // GetCurrentMapID: Pearl map 264
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
