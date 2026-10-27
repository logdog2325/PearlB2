// MAP_SUNYSHORE_GYM_ROOM_1: Pearl script file 152, text bank 155. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P152_S1
    ScriptEntry P152_S2
    ScriptEntry P152_S3
    ScriptEntry P152_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P152_S1:
P152_0012:
    pl_SetVarFromValue PVAR_4000, 0
// InitSunyshoreGym 0: gimmick 62 sets the gears by the player's way in (sunyshore_gym_itcm.c)
    pl_End

P152_S2:
P152_001D:
    pl_RotateSunyshoreGymGear 0  // Pearl RotateSunyshoreGymGear 0: the gears turn (sunyshore_gym_itcm.c)
    pl_End

P152_S3:
P152_0022:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 7, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P152_0048
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P152_0048:
    pl_BufferPlayerName 0
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P152_S4:
P152_0056:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckBadgeAcquired 7, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P152_007A
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P152_007A:
    pl_CompareVarToValue PVAR_40EF, 1
    pl_GoToIf 4, P152_0098
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_sys 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P152_0098:
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_sys 4
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
