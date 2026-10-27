// MAP_VEILSTONE_DEPARTMENT_STORE_2F: Pearl script file 138, text bank 141. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; no warp continuations; 8: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P138_S1
    ScriptEntry P138_S2
    ScriptEntry P138_S3
    ScriptEntry P138_S4
    ScriptEntry P138_S5
    ScriptEntry P138_S6
    ScriptEntry P138_S7
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P138_S1:
P138_001E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSetConst PVAR_800C, 0  // Unk027E: the Department Store's regulars (not counted here)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P138_005F
    pl_msg_talk 0
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 14, 65535, 1  // Pearl AddMenuEntryImm 229, 1
    ListMenuAdd 15, 65535, 0  // Pearl AddMenuEntryImm 228, 0
    ListMenuShow
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P138_00C2
    pl_GoTo P138_00B7

P138_005F:
    pl_BufferPlayerName 0
    pl_msg_talk 1
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 14, 65535, 0  // Pearl AddMenuEntryImm 229, 0
    ListMenuAdd 15, 65535, 1  // Pearl AddMenuEntryImm 228, 1
    ListMenuShow
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P138_00B7
    pl_GetRandom PVAR_800C, 4
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P138_00C2
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P138_00CD
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P138_00D8
    pl_GoTo P138_00E3

P138_00B7:
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_00C2:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_00CD:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_00D8:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_00E3:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_S2:
P138_00EE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_S3:
P138_0101:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_S4:
P138_0114:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckPoketchAppRegistered 10, PVAR_800C  // Counter
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P138_0158
    pl_msg_talk 9
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P138_0163
    pl_msg_talk 10
    pl_SetVarFromValue PVAR_8004, 10
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_0158:
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_0163:
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P138_S5:
P138_0181:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 10  // Pearl SpecialMart 10: Black 2's normal Mart for now
    pl_ReleaseAll
    pl_End

P138_S6:
P138_0197:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 11  // Pearl SpecialMart 11: Black 2's normal Mart for now
    pl_ReleaseAll
    pl_End

P138_S7:
P138_01AD:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 3  // this floor's floors above (an elevator reads it)
    VMHalt

// ---- Pearl global script 205:10 (a subroutine here)
C205_10_S10:
C205_10_069C:
    pl_Call C205_10_06A6
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_10_06A6:
    pl_BufferPlayerName 0
// BufferPoketchAppName 1, PVAR_8004: the lines naming the app have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_POCKETCH
    MsgWinCloseAll  // another speaker: close the first window
    pl_CompareVarToValue PVAR_8004, 10
    pl_GoToIf 1, C205_10_06B2_App10
    pl_msg_sys 16  // Pearl bank 199 line 24: another one (no caller here sets it)
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App10:
    pl_msg_sys 17  // naming Counter
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_AppDone:
    pl_WaitFanfare
    pl_msg_sys 18  // Pearl bank 199 line 26
    pl_RegisterPoketchApp PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, C205_10_0805
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, C205_10_080A
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, C205_10_080F
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, C205_10_0814
    pl_CompareVarToValue PVAR_8004, 4
    pl_CallIf 1, C205_10_0819
    pl_CompareVarToValue PVAR_8004, 5
    pl_CallIf 1, C205_10_081E
    pl_CompareVarToValue PVAR_8004, 6
    pl_CallIf 1, C205_10_0823
    pl_CompareVarToValue PVAR_8004, 7
    pl_CallIf 1, C205_10_0828
    pl_CompareVarToValue PVAR_8004, 8
    pl_CallIf 1, C205_10_082D
    pl_CompareVarToValue PVAR_8004, 9
    pl_CallIf 1, C205_10_0832
    pl_CompareVarToValue PVAR_8004, 10
    pl_CallIf 1, C205_10_0837
    pl_CompareVarToValue PVAR_8004, 11
    pl_CallIf 1, C205_10_083C
    pl_CompareVarToValue PVAR_8004, 12
    pl_CallIf 1, C205_10_0841
    pl_CompareVarToValue PVAR_8004, 13
    pl_CallIf 1, C205_10_0846
    pl_CompareVarToValue PVAR_8004, 14
    pl_CallIf 1, C205_10_084B
    pl_CompareVarToValue PVAR_8004, 15
    pl_CallIf 1, C205_10_0850
    pl_CompareVarToValue PVAR_8004, 16
    pl_CallIf 1, C205_10_0855
    pl_CompareVarToValue PVAR_8004, 17
    pl_CallIf 1, C205_10_085A
    pl_CompareVarToValue PVAR_8004, 18
    pl_CallIf 1, C205_10_085F
    pl_CompareVarToValue PVAR_8004, 19
    pl_CallIf 1, C205_10_0864
    pl_CompareVarToValue PVAR_8004, 20
    pl_CallIf 1, C205_10_0869
    pl_CompareVarToValue PVAR_8004, 21
    pl_CallIf 1, C205_10_086E
    pl_CompareVarToValue PVAR_8004, 22
    pl_CallIf 1, C205_10_0873
    pl_CompareVarToValue PVAR_8004, 23
    pl_CallIf 1, C205_10_0878
    pl_CompareVarToValue PVAR_8004, 24
    pl_CallIf 1, C205_10_087D
    pl_Return

C205_10_0805:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 83
    pl_Return

C205_10_080A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 84
    pl_Return

C205_10_080F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 85
    pl_Return

C205_10_0814:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 86
    pl_Return

C205_10_0819:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 87
    pl_Return

C205_10_081E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 88
    pl_Return

C205_10_0823:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 89
    pl_Return

C205_10_0828:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 90
    pl_Return

C205_10_082D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 91
    pl_Return

C205_10_0832:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 92
    pl_Return

C205_10_0837:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 93
    pl_Return

C205_10_083C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 94
    pl_Return

C205_10_0841:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 95
    pl_Return

C205_10_0846:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 96
    pl_Return

C205_10_084B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 97
    pl_Return

C205_10_0850:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 98
    pl_Return

C205_10_0855:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 99
    pl_Return

C205_10_085A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 199 line 100
    pl_Return

C205_10_085F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 199 line 101
    pl_Return

C205_10_0864:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 199 line 102
    pl_Return

C205_10_0869:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 103
    pl_Return

C205_10_086E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 40  // Pearl bank 199 line 104
    pl_Return

C205_10_0873:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41  // Pearl bank 199 line 105
    pl_Return

C205_10_0878:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 42  // Pearl bank 199 line 106
    pl_Return

C205_10_087D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 43  // Pearl bank 199 line 107
    pl_Return

// ---- Pearl global script 205:20 (a subroutine here)
C205_20_S20:
C205_20_0F28:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 44  // Pearl bank 199 line 37
    pl_ReturnCommonScript
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
