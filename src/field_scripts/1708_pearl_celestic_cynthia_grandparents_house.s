// MAP_CELESTIC_CYNTHIA_GRANDPARENTS_HOUSE: Pearl script file 1017, text bank 529. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1017_S1
    ScriptEntry P1017_S2
    ScriptEntry P1017_S3
    ScriptEntry P1017_S4
    ScriptEntry P1017_S5
    ScriptEntry P1017_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P1017_S5:
P1017_001A:
    pl_End

P1017_S1:
P1017_001C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1017_S2:
P1017_002F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_015E
    pl_GoToIf 1, P1017_0060
    pl_CheckBadgeAcquired 4, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1017_00A8
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1017_0060:
    pl_msg_talk 3
    WorkSetConst PVAR_800C, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_CompareVarToValue PVAR_800C, 10
    pl_CallIf 1, P1017_0092
    pl_CompareVarToValue PVAR_800C, 11
    pl_CallIf 1, P1017_009D
    pl_stub RemovePokemonPreview  // Pearl 0x209 Unk0209 : not translated yet
    pl_SetFlag PFLAG_0145
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1017_0092:
    pl_stub DrawPokemonPreview  // Pearl 0x208 ShowPokemonPic 484, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_Return

P1017_009D:
    pl_stub DrawPokemonPreview  // Pearl 0x208 ShowPokemonPic 483, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_Return

P1017_00A8:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1017_S3:
P1017_00B3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1017_S4:
P1017_00C6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1017_S6:
P1017_00D7:
    pl_BufferPlayerName 0
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
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
