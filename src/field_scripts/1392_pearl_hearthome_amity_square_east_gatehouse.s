// MAP_HEARTHOME_AMITY_SQUARE_EAST_GATEHOUSE: Pearl script file 105, text bank 111. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive; 102: Pearl 10162
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P105_S1
    ScriptEntry P105_S2
    ScriptEntry P105_S3
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
    ScriptEntry PearlProxy_10162
    ScriptEntriesEnd

P105_S3:
P105_000E:
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 13, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P105_0027
    pl_ClearFlag PFLAG_0237
    pl_End

P105_0027:
    pl_SetFlag PFLAG_0237
    pl_End

P105_S1:
P105_002D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P105_S2:
P105_0040:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlProxy_10162:                  // Pearl global script 10162 (run by this zone's events)
    VMCall T1042_13_S13
    VMHalt

// ---- Pearl global script 1042:13 (a subroutine here)
T1042_13_S13:
T1042_13_00C6:
    pl_SetVarFromValue PVAR_8000, 13
    pl_GoTo T1042_13_00D2

T1042_13_00D2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 32768, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_13_0214
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2  // Pearl bank 562 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_13_0107
    pl_GoTo T1042_13_021F

T1042_13_0107:
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 0, 32768, 32772, 32773: not translated yet
    pl_stub MessageFromBank  // PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8000, 10
    pl_GoToIf 1, T1042_13_0165
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32772: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_13_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_13_0214

T1042_13_0165:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextListMenu 1, 1, 0, 1, PVAR_8004
    ListMenuAdd 3, 65535, 255  // Pearl AddListMenuEntry 16, 255
    ListMenuAdd 4, 65535, 255  // Pearl AddListMenuEntry 17, 255
    ListMenuAdd 5, 65535, 255  // Pearl AddListMenuEntry 18, 255
    ListMenuAdd 6, 65535, 255  // Pearl AddListMenuEntry 19, 255
    ListMenuAdd 7, 65535, 255  // Pearl AddListMenuEntry 20, 255
    ListMenuAdd 8, 65535, 255  // Pearl AddListMenuEntry 21, 255
    ListMenuAdd 9, 65535, 255  // Pearl AddListMenuEntry 22, 255
    ListMenuAdd 10, 65535, 255  // Pearl AddListMenuEntry 23, 255
    ListMenuAdd 11, 65535, 255  // Pearl AddListMenuEntry 24, 255
    ListMenuAdd 12, 65535, 255  // Pearl AddListMenuEntry 25, 255
    ListMenuAdd 13, 65535, 255  // Pearl AddListMenuEntry 26, 255
    ListMenuAdd 14, 65535, 255  // Pearl AddListMenuEntry 27, 255
    ListMenuAdd 15, 65535, 255  // Pearl AddListMenuEntry 28, 255
    ListMenuAdd 16, 65535, 255  // Pearl AddListMenuEntry 29, 255
    ListMenuAdd 17, 65535, 255  // Pearl AddListMenuEntry 30, 255
    ListMenuAdd 18, 65535, 255  // Pearl AddListMenuEntry 31, 255
    ListMenuAdd 19, 65535, 255  // Pearl AddListMenuEntry 32, 255
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 65534
    pl_GoToIf 1, T1042_13_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_13_0214

T1042_13_0214:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20  // Pearl bank 562 line 2
    pl_WaitButton
    pl_GoTo T1042_13_022A

T1042_13_021F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 21  // Pearl bank 562 line 1
    pl_WaitButton
    pl_GoTo T1042_13_022A

T1042_13_022A:
    pl_CloseMessage
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
