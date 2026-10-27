// MAP_SUNYSHORE_POKETCH_DEVELOPER_HOUSE: Pearl script file 164, text bank 164. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P164_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P164_S1:
P164_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40B5, 1
    pl_GoToIf 4, P164_002C
    pl_SetVarFromValue PVAR_40B5, 1
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P164_002C:
    pl_CheckPoketchAppRegistered 18, PVAR_800C  // Roulette
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P164_0125
    pl_CheckPoketchAppRegistered 17, PVAR_800C  // Dot Artist
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P164_00A7
    pl_CheckPoketchAppRegistered 16, PVAR_800C  // Calendar
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P164_0089
    pl_GoTo P164_006B

P164_006B:
    pl_stub FindPartySlotWithNature  // Pearl 0x213 FindPartyMonWithNature 32768, 12: not translated yet
    pl_CompareVarToValue PVAR_8000, 255
    pl_GoToIf 5, P164_00C5
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P164_0089:
    pl_stub FindPartySlotWithNature  // Pearl 0x213 FindPartyMonWithNature 32768, 14: not translated yet
    pl_CompareVarToValue PVAR_8000, 255
    pl_GoToIf 5, P164_00E5
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P164_00A7:
    pl_stub FindPartySlotWithNature  // Pearl 0x213 FindPartyMonWithNature 32768, 24: not translated yet
    pl_CompareVarToValue PVAR_8000, 255
    pl_GoToIf 5, P164_0105
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P164_00C5:
    pl_GetPartyMonSpecies PVAR_8000, PVAR_8001
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_msg_talk 4
    pl_SetVarFromValue PVAR_8004, 16
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P164_00E5:
    pl_GetPartyMonSpecies PVAR_8000, PVAR_8001
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_msg_talk 5
    pl_SetVarFromValue PVAR_8004, 17
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P164_0105:
    pl_GetPartyMonSpecies PVAR_8000, PVAR_8001
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_msg_talk 6
    pl_SetVarFromValue PVAR_8004, 18
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P164_0125:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

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
    pl_CompareVarToValue PVAR_8004, 16
    pl_GoToIf 1, C205_10_06B2_App16
    pl_CompareVarToValue PVAR_8004, 17
    pl_GoToIf 1, C205_10_06B2_App17
    pl_CompareVarToValue PVAR_8004, 18
    pl_GoToIf 1, C205_10_06B2_App18
    pl_msg_sys 8  // Pearl bank 199 line 24: another one (no caller here sets it)
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App16:
    pl_msg_sys 9  // naming Calendar
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App17:
    pl_msg_sys 10  // naming Dot Artist
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App18:
    pl_msg_sys 11  // naming Roulette
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_AppDone:
    pl_WaitFanfare
    pl_msg_sys 12  // Pearl bank 199 line 26
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
    pl_msg_sys 13  // Pearl bank 199 line 83
    pl_Return

C205_10_080A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 199 line 84
    pl_Return

C205_10_080F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15  // Pearl bank 199 line 85
    pl_Return

C205_10_0814:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 86
    pl_Return

C205_10_0819:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 17  // Pearl bank 199 line 87
    pl_Return

C205_10_081E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 18  // Pearl bank 199 line 88
    pl_Return

C205_10_0823:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 89
    pl_Return

C205_10_0828:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 90
    pl_Return

C205_10_082D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 91
    pl_Return

C205_10_0832:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 92
    pl_Return

C205_10_0837:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 93
    pl_Return

C205_10_083C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 94
    pl_Return

C205_10_0841:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 95
    pl_Return

C205_10_0846:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 96
    pl_Return

C205_10_084B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 97
    pl_Return

C205_10_0850:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 98
    pl_Return

C205_10_0855:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 99
    pl_Return

C205_10_085A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 100
    pl_Return

C205_10_085F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 101
    pl_Return

C205_10_0864:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 102
    pl_Return

C205_10_0869:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 103
    pl_Return

C205_10_086E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 104
    pl_Return

C205_10_0873:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 105
    pl_Return

C205_10_0878:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 199 line 106
    pl_Return

C205_10_087D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 199 line 107
    pl_Return

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
