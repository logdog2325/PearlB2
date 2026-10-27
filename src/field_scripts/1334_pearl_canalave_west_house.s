// MAP_CANALAVE_WEST_HOUSE: Pearl script file 47, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive; 100: Pearl 10159
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P47_S1
    ScriptEntry P47_S2
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
    ScriptEntry PearlProxy_10159
    ScriptEntriesEnd

P47_S2:
P47_000A:
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 10, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P47_0023
    pl_ClearFlag PFLAG_0234
    pl_End

P47_0023:
    pl_SetFlag PFLAG_0234
    pl_End

P47_S1:
P47_0029:
    pl_End

PearlProxy_10159:                  // Pearl global script 10159 (run by this zone's events)
    VMCall T1042_10_S10
    VMHalt

// ---- Pearl global script 1042:10 (a subroutine here)
T1042_10_S10:
T1042_10_00A2:
    pl_SetVarFromValue PVAR_8000, 10
    pl_GoTo T1042_10_00D2

T1042_10_00D2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 32768, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_10_0214
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 81  // Pearl bank 562 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_10_0107
    pl_GoTo T1042_10_021F

T1042_10_0107:
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 0, 32768, 32772, 32773: not translated yet
    pl_stub MessageFromBank  // PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8000, 10
    pl_GoToIf 1, T1042_10_0165
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32772: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_10_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_10_0214

T1042_10_0165:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextListMenu 1, 1, 0, 1, PVAR_8004
    ListMenuAdd 82, 65535, 255  // Pearl AddListMenuEntry 16, 255
    ListMenuAdd 83, 65535, 255  // Pearl AddListMenuEntry 17, 255
    ListMenuAdd 84, 65535, 255  // Pearl AddListMenuEntry 18, 255
    ListMenuAdd 85, 65535, 255  // Pearl AddListMenuEntry 19, 255
    ListMenuAdd 86, 65535, 255  // Pearl AddListMenuEntry 20, 255
    ListMenuAdd 87, 65535, 255  // Pearl AddListMenuEntry 21, 255
    ListMenuAdd 88, 65535, 255  // Pearl AddListMenuEntry 22, 255
    ListMenuAdd 89, 65535, 255  // Pearl AddListMenuEntry 23, 255
    ListMenuAdd 90, 65535, 255  // Pearl AddListMenuEntry 24, 255
    ListMenuAdd 91, 65535, 255  // Pearl AddListMenuEntry 25, 255
    ListMenuAdd 92, 65535, 255  // Pearl AddListMenuEntry 26, 255
    ListMenuAdd 93, 65535, 255  // Pearl AddListMenuEntry 27, 255
    ListMenuAdd 94, 65535, 255  // Pearl AddListMenuEntry 28, 255
    ListMenuAdd 95, 65535, 255  // Pearl AddListMenuEntry 29, 255
    ListMenuAdd 96, 65535, 255  // Pearl AddListMenuEntry 30, 255
    ListMenuAdd 97, 65535, 255  // Pearl AddListMenuEntry 31, 255
    ListMenuAdd 98, 65535, 255  // Pearl AddListMenuEntry 32, 255
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 65534
    pl_GoToIf 1, T1042_10_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_10_0214

T1042_10_0214:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 99  // Pearl bank 562 line 2
    pl_WaitButton
    pl_GoTo T1042_10_022A

T1042_10_021F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 100  // Pearl bank 562 line 1
    pl_WaitButton
    pl_GoTo T1042_10_022A

T1042_10_022A:
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
