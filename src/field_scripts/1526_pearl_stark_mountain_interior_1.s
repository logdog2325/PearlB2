// MAP_STARK_MOUNTAIN_INTERIOR_1: Pearl script file 276, text bank 245. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive; 93: Pearl 10001, 94: Pearl 10002
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P276_S1
    ScriptEntry P276_S2
    ScriptEntry P276_S3
    ScriptEntry P276_S4
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
    ScriptEntry PearlProxy_10001
    ScriptEntry PearlProxy_10002
    ScriptEntriesEnd

P276_S1:
P276_0012:
    pl_SetFlag PFLAG_09D2
    pl_CheckFlag PFLAG_00DB
    pl_CallIf 1, P276_0030
    pl_CompareVarToValue PVAR_409E, 1
    pl_GoToIf 4, P276_0036
    pl_End

P276_0030:
    pl_SetFlag PFLAG_01F7
    pl_Return

P276_0036:
    pl_SetFlag PFLAG_01F7
    pl_CompareVarToValue PVAR_410E, 1
    pl_GoToIf 4, P276_0049
    pl_End

P276_0049:
    RTCGetWeekDay PVAR_4000
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P276_0090
    pl_CompareVarToValue PVAR_4000, 2
    pl_GoToIf 1, P276_0090
    pl_CompareVarToValue PVAR_4000, 3
    pl_GoToIf 1, P276_0090
    pl_CompareVarToValue PVAR_4000, 4
    pl_GoToIf 1, P276_0090
    pl_CompareVarToValue PVAR_4000, 5
    pl_GoToIf 1, P276_0090
    pl_End

P276_0090:
    pl_ClearFlag PFLAG_01F7
    pl_End

P276_S2:
P276_0096:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_409E, 1
    pl_GoToIf 4, P276_0118
    pl_CheckFlag PFLAG_00DB
    pl_GoToIf 1, P276_00CB
    pl_SetFlag PFLAG_00DB
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P276_00CB:
    pl_BufferRivalName 0
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P276_S3:
P276_00D9:
    pl_LockAll
    pl_ApplyMovement 14, P276_0104
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 14, P276_0110
    pl_WaitMovement
    pl_RemoveObject 14, PFLAG_01F7
    pl_ReleaseAll
    pl_End

P276_S4:
P276_0118:
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P276_0104:
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P276_0110:
    Move 17, 8  // WALK_FAST_SOUTH
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
    pl_msg_talk 3  // Pearl bank 334 line 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_019A
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_018B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4  // Pearl bank 334 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_019A:
    pl_BufferPartyMonNickname 0, PVAR_8004
    pl_msg_talk 5  // Pearl bank 334 line 5
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 1: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 263  // GetCurrentMapID: Pearl map 263
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
    pl_msg_talk 6  // Pearl bank 334 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_3_0297
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0288:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7  // Pearl bank 334 line 8
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0297:
    FlagSet 2404  // GetSetStrength 1: Strength on (Black 2's flag 0x964, the push reads it)
    PokePartyHasMoveAny PVAR_800C, 70  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_talk 8  // Pearl bank 334 line 10
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
    pl_CloseMessage
    pl_msg_talk 9  // Pearl bank 334 line 11
    pl_WaitButton
    pl_CloseMessage
    WorkSetConst PVAR_8004, 263  // GetCurrentMapID: Pearl map 263
// CreateJournalEvent 22, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo T375_3_055B

T375_3_02D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 10  // Pearl bank 334 line 9
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
