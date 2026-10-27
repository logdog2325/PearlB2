// MAP_VEILSTONE_GALACTIC_HEADQUARTERS_1F: Pearl script file 333, text bank 262. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-8: Pearl's; no warp continuations; 9: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P333_S1
    ScriptEntry P333_S2
    ScriptEntry P333_S3
    ScriptEntry P333_S4
    ScriptEntry P333_S5
    ScriptEntry P333_S6
    ScriptEntry P333_S7
    ScriptEntry P333_S8
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P333_S1:
P333_0022:
    pl_SetFlag PFLAG_09DD
    pl_End

P333_S2:
P333_0028:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P333_0046
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_0046:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_S3:
P333_0051:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P333_006F
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_006F:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_S4:
P333_007A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P333_0098
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_0098:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_S5:
P333_00A3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P333_00C1
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_00C1:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_S8:
P333_00CC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_S6:
P333_00DF:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckItem 440, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P333_0107
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_0107:
    pl_msg_talk 10
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P333_012A
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P333_015E
    pl_End

P333_012A:
    pl_BufferPlayerName 0
    pl_msg_talk 11
    pl_WaitButton
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlaySE SEQ_SE_OPEN1  // Pearl SEQ_SE_DP_DOOR10
    pl_ApplyMovement 5, P333_0164
    pl_ApplyMovement 6, P333_016C
    pl_WaitMovement
    pl_SetFlag PFLAG_0242
    pl_RemoveObject 5, PFLAG_0242
    pl_RemoveObject 6, PFLAG_0242
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_015E:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P333_S7:
P333_0174:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P333_0164:
    Move 18, 1  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P333_016C:
    Move 19, 1  // WALK_FAST_EAST
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
