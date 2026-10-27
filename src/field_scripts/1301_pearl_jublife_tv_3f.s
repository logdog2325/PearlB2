// MAP_JUBLIFE_TV_3F: Pearl script file 13, text bank 27. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P13_S1
    ScriptEntry P13_S2
    ScriptEntry P13_S3
    ScriptEntry P13_S4
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P13_S1:
P13_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P13_S2:
P13_0025:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P13_S3:
P13_0038:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P13_S4:
P13_004B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P13_006D
    pl_GoTo P13_012C

P13_006D:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub ChooseTwoCustomMessageWords  // Pearl 0x244 Unk0244 0, 32780, 32768, 32769: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P13_012C
    pl_msg_talk 4
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub ChooseTwoCustomMessageWords  // Pearl 0x244 Unk0244 0, 32780, 32770, 32771: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P13_012C
    pl_stub GetWallpaperFromCustomMessageWords  // Pearl 0x249 GiveWallpaper 32780, 32768, 32769, 32770, 32771: not translated yet
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P13_0102
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P13_0102
    pl_GoTo P13_0137

P13_0102:
    pl_stub CheckIsMysteryGiftPhrase  // Pearl 0x2AA CompareMysteryGiftEasyChatInput 32780, 32768, 32769, 32770, 32771: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P13_0121
    pl_GoTo P13_0142

P13_0121:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P13_012C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P13_0137:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P13_0142:
    pl_msg_talk 8
    pl_WaitButton
    pl_stub UnlockMysteryGift  // Pearl 0x2AC ActivateMysteryGift : not translated yet
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 1  // this floor's floors above (an elevator reads it)
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
