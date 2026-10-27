// MAP_VICTORY_ROAD_1F: Pearl script file 259, text bank 233. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-9: Pearl's; no warp continuations; 10: PearlArrive; 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P259_S1
    ScriptEntry P259_S2
    ScriptEntry P259_S3
    ScriptEntry P259_S4
    ScriptEntry P259_S5
    ScriptEntry P259_S6
    ScriptEntry P259_S7
    ScriptEntry P259_S8
    ScriptEntry P259_S9
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
    ScriptEntry PearlProxy_10003
    ScriptEntriesEnd

P259_S1:
P259_0026:
    pl_SetFlag PFLAG_09CA
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 0, P259_004B
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P259_004B
    pl_SetFlag PFLAG_029C

P259_004B:
    pl_End

P259_S2:
P259_004D:
    pl_End

P259_S3:
P259_004F:
    pl_End

P259_S4:
P259_0051:
    pl_End

P259_S5:
P259_0053:
    pl_End

P259_S6:
P259_0055:
    pl_End

P259_S7:
P259_0057:
    pl_End

P259_S8:
P259_0059:
    pl_End

P259_S9:
P259_005B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlProxy_10003:                  // Pearl global script 10003 (run by this zone's events)
    VMCall C375_4_S4
    VMHalt

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
    pl_msg_sys 12  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 13  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 15  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 10 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 38
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 32
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (38, 32) to (38, 37)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 38
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 37
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (38, 37) to (38, 32)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    WorkCmpConst PL_TMP, 22
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP2, 33
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc2  // from (22, 33) to (22, 38)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc2_next:
    WorkCmpConst PL_TMP, 22
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP2, 38
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc3  // from (22, 38) to (22, 33)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc3_next:
    WorkCmpConst PL_TMP, 22
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP2, 48
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc4  // from (22, 48) to (22, 53)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc4_next:
    WorkCmpConst PL_TMP, 22
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP2, 53
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc5  // from (22, 53) to (22, 48)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc5_next:
    WorkCmpConst PL_TMP, 36
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP2, 48
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc6  // from (36, 48) to (36, 53)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc6_next:
    WorkCmpConst PL_TMP, 36
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP2, 53
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc7  // from (36, 53) to (36, 48)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc7_next:
    WorkCmpConst PL_TMP, 18
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP2, 64
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc8  // from (18, 64) to (18, 69)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc8_next:
    WorkCmpConst PL_TMP, 18
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP2, 69
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc9  // from (18, 69) to (18, 64)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc9_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc2:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc3:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc4:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc5:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc6:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc7:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc8:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc9:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 244  // GetCurrentMapID: Pearl map 244
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
