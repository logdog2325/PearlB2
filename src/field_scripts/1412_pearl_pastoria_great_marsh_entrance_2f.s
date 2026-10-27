// MAP_PASTORIA_GREAT_MARSH_ENTRANCE_2F: Pearl script file 125, text bank 129. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P125_S1
    ScriptEntry P125_S2
    ScriptEntry P125_S3
    ScriptEntry P125_S4
    ScriptEntry P125_S5
    ScriptEntry PearlArrive
    ScriptEntry PearlClosed_0
    ScriptEntry PearlClosed_1
    ScriptEntry PearlClosed_2
    ScriptEntriesEnd

P125_S1:
P125_0016:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
    pl_msg_sys 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P125_003E
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P125_003E:
    MoneyCheck PVAR_800C, 100
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P125_0063
    pl_RemoveMoney 100
    MoneyWinUpdate
    MoneyWinClose
    pl_stub StartGreatMarshLookout  // Pearl 0x206 UseGreatMarshBinoculars : not translated yet
    pl_ReleaseAll
    pl_End

P125_0063:
    pl_msg_sys 1
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P125_S2:
P125_0070:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P125_S3:
P125_0083:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P125_S4:
P125_0096:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P125_S5:
P125_00A9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlClosed_0:                  // a closed place (data/pearl_closed_facilities.json): sign 0
    pl_closed_facility 6, 255
    VMHalt

PearlClosed_1:                  // a closed place (data/pearl_closed_facilities.json): sign 1
    pl_closed_facility 7, 255
    VMHalt

PearlClosed_2:                  // a closed place (data/pearl_closed_facilities.json): sign 2
    pl_closed_facility 8, 255
    VMHalt

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
