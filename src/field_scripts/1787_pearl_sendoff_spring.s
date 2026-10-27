// MAP_SENDOFF_SPRING: Pearl script file 368, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive; 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P368_S1
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10003
    ScriptEntriesEnd

P368_S1:
P368_0006:
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
    pl_msg_sys 81  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 82  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 83  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 84  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 4 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 33
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 12
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (33, 12) to (33, 17)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 33
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 17
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (33, 17) to (33, 12)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    WorkCmpConst PL_TMP, 32
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP2, 40
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc2  // from (32, 40) to (32, 46)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc2_next:
    WorkCmpConst PL_TMP, 32
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP2, 46
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc3  // from (32, 46) to (32, 40)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc3_next:
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
        Move 17, 4
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc3:
        Move 52, 1
        Move 16, 4
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 267  // GetCurrentMapID: Pearl map 267
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
