// MAP_HEARTHOME_GYM_FIRST_QUESTION_ROOM: Pearl script file 92, text bank 100. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P92_S1
    ScriptEntry P92_S2
    ScriptEntry P92_S3
    ScriptEntry P92_S4
    ScriptEntry P92_S5
    ScriptEntry P92_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P92_S1:
P92_001A:
    pl_SetVarFromValue PVAR_4000, 0
// InitPersistedMapFeaturesForHearthomeGym: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_CheckFlag PFLAG_098D
    pl_GoToIf 0, P92_002F
    pl_End

P92_S2:
P92_002F:
    pl_SetVarFromValue PVAR_4000, 1
    pl_End

P92_S3:
P92_0037:
// MoveHearthomeGymDPLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_End

P92_S4:
P92_003B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 0
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_MAZYO4: no Black 2 sound chosen yet
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P92_S5:
P92_0050:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00A5
    pl_GoToIf 0, P92_008F
    pl_CheckBadgeAcquired 4, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P92_0081
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P92_0081:
    pl_BufferPlayerName 0
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P92_008F:
    pl_CheckFlag PFLAG_00A3
    pl_GoToIf 1, P92_00A9
    pl_SetFlag PFLAG_00A3
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P92_00A9:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P92_S6:
P92_00B4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckBadgeAcquired 4, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P92_00DE
    pl_BufferRivalName 0
    pl_BufferRivalName 1
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P92_00DE:
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_BufferRivalName 2
    pl_msg_sys 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
