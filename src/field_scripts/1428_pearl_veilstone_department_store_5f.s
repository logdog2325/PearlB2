// MAP_VEILSTONE_DEPARTMENT_STORE_5F: Pearl script file 141, text bank 144. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P141_S1
    ScriptEntry P141_S2
    ScriptEntry P141_S3
    ScriptEntry P141_S4
    ScriptEntry P141_S5
    ScriptEntry P141_S6
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P141_S1:
P141_001A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P141_S2:
P141_002D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P141_S3:
P141_0040:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0105
    pl_GoToIf 1, P141_0087
    pl_msg_talk 2
    pl_SetVarFromValue PVAR_8004, 288
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P141_0092
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0105
    pl_GoTo P141_0087

P141_0087:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P141_0092:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P141_S4:
P141_009C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P141_S5:
P141_00AF:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P141_S6:
P141_00C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 6
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
    pl_GoTo P141_00D5

P141_00D5:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8000  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_8000
    ListMenuAdd 11, 65535, 0  // Pearl AddMenuEntryImm 219, 0
    ListMenuAdd 12, 65535, 1  // Pearl AddMenuEntryImm 220, 1
    ListMenuAdd 13, 65535, 2  // Pearl AddMenuEntryImm 221, 2
    ListMenuAdd 14, 65535, 3  // Pearl AddMenuEntryImm 222, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_8000
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P141_0125
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P141_0131
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P141_013D
    pl_msg_sys 10
    pl_GoTo P141_027A

P141_0125:
    pl_SetVarFromValue PVAR_8001, 30
    pl_GoTo P141_017F

P141_0131:
    pl_SetVarFromValue PVAR_8001, 31
    pl_GoTo P141_017F

P141_013D:
    pl_SetVarFromValue PVAR_8001, 32
    pl_GoTo P141_017F

P141_0149:
    MoneyCheck PVAR_800C, 200
    pl_Return

P141_0153:
    MoneyCheck PVAR_800C, 300
    pl_Return

P141_015D:
    MoneyCheck PVAR_800C, 350
    pl_Return

P141_0167:
    pl_RemoveMoney 200
    pl_Return

P141_016F:
    pl_RemoveMoney 300
    pl_Return

P141_0177:
    pl_RemoveMoney 350
    pl_Return

P141_017F:
    pl_CompareVarToValue PVAR_8000, 0
    pl_CallIf 1, P141_0149
    pl_CompareVarToValue PVAR_8000, 1
    pl_CallIf 1, P141_0153
    pl_CompareVarToValue PVAR_8000, 2
    pl_CallIf 1, P141_015D
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P141_0265
    pl_CanFitItem PVAR_8001, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P141_026E
    pl_CompareVarToValue PVAR_8000, 0
    pl_CallIf 1, P141_0167
    pl_CompareVarToValue PVAR_8000, 1
    pl_CallIf 1, P141_016F
    pl_CompareVarToValue PVAR_8000, 2
    pl_CallIf 1, P141_0177
    MoneyWinUpdate
    pl_BufferItemName 0, PVAR_8001
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_JIHANKI: no Black 2 sound chosen yet
    pl_BufferItemName 0, PVAR_8001
    pl_msg_sys 7
    pl_SetVarFromVar PVAR_8004, PVAR_8001
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_GetRandom PVAR_800C, 64
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P141_025C
    pl_CanFitItem PVAR_8001, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P141_026E
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_JIHANKI: no Black 2 sound chosen yet
    pl_BufferItemName 0, PVAR_8001
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 8
    pl_SetVarFromVar PVAR_8004, PVAR_8001
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_GoTo P141_025C

P141_025C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6
    pl_GoTo P141_00D5

P141_0265:
    pl_msg_sys 9
    pl_GoTo P141_027A

P141_026E:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P141_027A:
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 0  // this floor's floors above (an elevator reads it)
    VMHalt

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
    pl_msg_sys 15  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 28
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
    pl_msg_sys 17  // Pearl bank 199 line 25
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
    pl_msg_sys 18  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:18 (a subroutine here)
C205_18_S18:
C205_18_0B60:
    pl_Call C205_18_0B6A
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_18_0B6A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 27
    pl_WaitButton
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
