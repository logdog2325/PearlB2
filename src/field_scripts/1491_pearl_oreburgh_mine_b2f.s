// MAP_OREBURGH_MINE_B2F: Pearl script file 209, text bank 209. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive; 93: Pearl 10001
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P209_S1
    ScriptEntry P209_S2
    ScriptEntry P209_S3
    ScriptEntry P209_S4
    ScriptEntry P209_S5
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
    ScriptEntry PearlProxy_10001
    ScriptEntriesEnd

P209_S1:
P209_0016:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GoTo P209_0034

P209_0034:
    pl_ApplyMovement 0, P209_00D8
    pl_WaitMovement
    pl_GoTo P209_0044

P209_0044:
    pl_msg_talk 0
    pl_CloseMessage
// StartDestroyObstacleAnimation 2: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject 1, PFLAG_0020

P209_0059:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, P209_0059
    pl_FacePlayer
    pl_msg_talk 1
    pl_CloseMessage
    pl_GoTo P209_0091

P209_0091:
    pl_ApplyMovement 0, P209_00C0
    pl_WaitMovement
    pl_GoTo P209_00A1

P209_00A1:
    pl_RemoveObject 0, PFLAG_01A8
    pl_SetFlag PFLAG_007A
    pl_SetFlag PFLAG_019A
    pl_ReleaseAll
    pl_End

P209_S2:
P209_00FC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 66
    pl_msg_talk 2
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P209_S3:
P209_011B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 66
    pl_msg_talk 3
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P209_S4:
P209_013A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 66
    pl_msg_talk 4
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P209_S5:
P209_0159:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P209_00C0:
    Move 15, 10  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P209_00D8:
    Move 63, 2  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 63, 4  // DELAY_8
    MoveEnd

PearlProxy_10001:                  // Pearl global script 10001 (run by this zone's events)
    VMCall T375_2_S2
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
    pl_msg_talk 6  // Pearl bank 334 line 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_019A
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_018B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7  // Pearl bank 334 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_019A:
    pl_BufferPartyMonNickname 0, PVAR_8004
    pl_msg_talk 8  // Pearl bank 334 line 5
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 1: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 199  // GetCurrentMapID: Pearl map 199
// CreateJournalEvent 24, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)

T375_2_01C8:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, T375_2_01C8
    pl_GoTo T375_2_055B

T375_2_055B:
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
