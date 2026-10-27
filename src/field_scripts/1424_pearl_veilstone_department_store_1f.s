// MAP_VEILSTONE_DEPARTMENT_STORE_1F: Pearl script file 137, text bank 140. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-8: Pearl's; no warp continuations; 9: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P137_S1
    ScriptEntry P137_S2
    ScriptEntry P137_S3
    ScriptEntry P137_S4
    ScriptEntry P137_S5
    ScriptEntry P137_S6
    ScriptEntry P137_S7
    ScriptEntry P137_S8
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P137_S1:
P137_0022:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P137_S2:
P137_0035:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P137_S3:
P137_0048:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P137_S4:
P137_005B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 8  // Pearl SpecialMart 8: Black 2's normal Mart for now
    pl_ReleaseAll
    pl_End

P137_S5:
P137_0071:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 9  // Pearl SpecialMart 9: Black 2's normal Mart for now
    pl_ReleaseAll
    pl_End

P137_S6:
P137_0087:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P137_S7:
P137_0098:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P137_S8:
P137_00A9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0129
    pl_GoToIf 1, P137_0109
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_CallIf 1, P137_0119
    pl_CompareVarToValue PVAR_800C, 390
    pl_CallIf 1, P137_0121
    pl_CompareVarToValue PVAR_800C, 393
    pl_CallIf 1, P137_0129
    pl_SetVarFromVar PVAR_4107, PVAR_8004
// GetFashionNameWithArticle 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_msg_talk 3
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_16_S16  // CallCommonScript 2015 (Pearl file 205 script 16)
    pl_SetFlag PFLAG_0129
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P137_0109:
// BufferAccessoryName 0, PVAR_4107: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_msg_talk 4  // Pearl bank 140 line 4 (the Accessory from PVAR_4107: not known here)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P137_0119:
    pl_SetVarFromValue PVAR_8004, 94
    pl_Return

P137_0121:
    pl_SetVarFromValue PVAR_8004, 92
    pl_Return

P137_0129:
    pl_SetVarFromValue PVAR_8004, 93
    pl_Return

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 4  // this floor's floors above (an elevator reads it)
    VMHalt

// ---- Pearl global script 205:20 (a subroutine here)
C205_20_S20:
C205_20_0F28:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7  // Pearl bank 199 line 37
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:16 (a subroutine here)
C205_16_S16:
C205_16_0906:
    pl_Call C205_16_0922
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 8  // Pearl bank 199 line 31 (the Accessory from PVAR_8004: not known here)
    pl_WaitButton
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_16_0922:
    pl_PlayFanfare SEQ_ME_ACCE  // Pearl SEQ_ACCE
// AddAccessory 32772, 32773: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
// BufferAccessoryName 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9  // Pearl bank 199 line 25 (the Accessory from PVAR_8004: not known here)
    pl_WaitFanfare
    pl_BufferPlayerName 0
// BufferAccessoryName 1, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
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
