// MAP_CELESTIC_SHOP: Pearl script file 1018, text bank 530. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1018_S1
    ScriptEntry P1018_S2
    ScriptEntry P1018_S3
    ScriptEntry P1018_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P1018_S1:
P1018_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 0
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 1
    pl_ReleaseAll
    pl_End

P1018_S2:
P1018_002B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 1
    pl_ReleaseAll
    pl_End

P1018_S3:
P1018_0041:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 14  // Pearl SpecialMart 14: Black 2's normal Mart for now
    pl_ReleaseAll
    pl_End

P1018_S4:
P1018_0057:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    RTCGetTime PVAR_800C, PL_TMP  // Pearl GetHour (the minute in PL_TMP)
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 0, P1018_0113
    pl_CompareVarToValue PVAR_800C, 10
    pl_GoToIf 0, P1018_0093
    pl_CompareVarToValue PVAR_800C, 20
    pl_GoToIf 0, P1018_00D3
    pl_GoTo P1018_0113

P1018_0093:
    pl_CheckFlag PFLAG_0134
    pl_GoToIf 1, P1018_0153
    pl_msg_talk 2
    pl_SetVarFromValue PVAR_8004, 297
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1018_0174
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0134
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_GoTo P1018_0153

P1018_00D3:
    pl_CheckFlag PFLAG_0135
    pl_GoToIf 1, P1018_015E
    pl_msg_talk 2
    pl_SetVarFromValue PVAR_8004, 240
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1018_0174
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0135
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_GoTo P1018_015E

P1018_0113:
    pl_CheckFlag PFLAG_0136
    pl_GoToIf 1, P1018_0169
    pl_msg_talk 2
    pl_SetVarFromValue PVAR_8004, 267
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1018_0174
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0136
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_GoTo P1018_0169

P1018_0153:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1018_015E:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1018_0169:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1018_0174:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

// ---- Pearl global script 205:20 (a subroutine here)
C205_20_S20:
C205_20_0F28:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 10  // Pearl bank 199 line 37
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:45 (a subroutine here)
C205_45_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_03B2
    VMReturn  // End: the sub-script ends

C205_45_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_45_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_45_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_45_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

C205_45_S45:
C205_45_09B7:
    pl_Call C205_45_09C1
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_45_09C1:
    pl_Call C205_45_0336
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, C205_45_09F4
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 5, C205_45_0A05
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 28
    pl_GoTo C205_45_0A2B

C205_45_0A05:
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A1D
    pl_BufferItemName 0, PVAR_8004
    pl_GoTo C205_45_0A22

C205_45_0A1D:
    pl_BufferItemName 0, PVAR_8004  // GetItemNamePlural

C205_45_0A22:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 13  // Pearl bank 199 line 25
    pl_GoTo C205_45_0A2B

C205_45_0A2B:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_45_1330
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A5B
    pl_BufferItemName 1, PVAR_8004
    pl_GoTo C205_45_0A60

C205_45_0A5B:
    pl_BufferItemName 1, PVAR_8004  // GetItemNamePlural

C205_45_0A60:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_0AE7
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_0AD6
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_0B2B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_0B1A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_0B3C
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_0AF8
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_0B09
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_0B4D
    VMReturn  // End: the sub-script ends

C205_45_0AD6:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AE7:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AF8:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B09:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B1A:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B2B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B3C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B4D:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B5E:
    pl_Return

C205_45_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_45_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_45_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_45_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_45_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_45_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_45_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_45_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_45_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_45_13D8
    pl_Return

C205_45_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_45_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 17  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 18  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 117
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
