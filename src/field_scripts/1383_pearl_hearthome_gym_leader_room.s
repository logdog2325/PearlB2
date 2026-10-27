// MAP_HEARTHOME_GYM_LEADER_ROOM: Pearl script file 96, text bank 104. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P96_S1
    ScriptEntry P96_S2
    ScriptEntry P96_S3
    ScriptEntry P96_S4
    ScriptEntry P96_S5
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P96_S1:
P96_0014:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P96_0056
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P96_0066
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P96_0076
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P96_0086
    pl_End

P96_0056:
    pl_ApplyMovement 0, P96_0188
    pl_WaitMovement
    pl_GoTo P96_0096

P96_0066:
    pl_ApplyMovement 0, P96_019C
    pl_WaitMovement
    pl_GoTo P96_0096

P96_0076:
    pl_ApplyMovement 0, P96_01B0
    pl_WaitMovement
    pl_GoTo P96_0096

P96_0086:
    pl_ApplyMovement 0, P96_01C4
    pl_WaitMovement
    pl_GoTo P96_0096

P96_0096:
    pl_CheckBadgeAcquired 4, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P96_016F
// CreateJournalEvent 9, 100, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_msg_talk 0
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_318, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P96_01D8
    pl_msg_talk 1
    pl_BufferPlayerName 0
    pl_msg_talk 2
    pl_PlayFanfare SEQ_ME_BADGE  // Pearl SEQ_BADGE
    pl_WaitFanfare
    pl_GiveBadge 4
// IncrementTrainerScore2 23: nothing in Black 2 (Pearl's trainer-card score (Black 2 keeps its own records))
    pl_SetTrainerFlag PTRAINER_266
    pl_SetTrainerFlag PTRAINER_280
    pl_SetTrainerFlag PTRAINER_284
    pl_SetTrainerFlag PTRAINER_325
    pl_SetTrainerFlag PTRAINER_330
    pl_SetTrainerFlag PTRAINER_340
    pl_SetTrainerFlag PTRAINER_343
    pl_SetTrainerFlag PTRAINER_357
// CreateJournalEvent 10, 100, 318, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_ClearFlag PFLAG_01C8
    pl_SetVarFromValue PVAR_40D1, 1
    pl_msg_talk 3
    pl_GoTo P96_0127

P96_S2:
P96_0127:
    pl_SetVarFromValue PVAR_8004, 392  // Pearl item 392 (TM65) = TM65 Shadow Claw
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P96_0165
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_007D
    pl_BufferItemName 0, PVAR_8004
    pl_BufferTMHMMoveName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P96_S3:
P96_0165:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P96_S4:
P96_016F:
    pl_CheckFlag PFLAG_007D
    pl_GoToIf 0, P96_0127
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P96_S5:
P96_01D8:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P96_0188:
    Move 2, 4  // FACE_WEST
    Move 0, 4  // FACE_NORTH
    Move 3, 4  // FACE_EAST
    Move 1, 4  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P96_019C:
    Move 3, 4  // FACE_EAST
    Move 1, 4  // FACE_SOUTH
    Move 2, 4  // FACE_WEST
    Move 0, 4  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P96_01B0:
    Move 0, 4  // FACE_NORTH
    Move 2, 4  // FACE_WEST
    Move 1, 4  // FACE_SOUTH
    Move 3, 4  // FACE_EAST
    MoveEnd

    .balign 4, 0
P96_01C4:
    Move 0, 4  // FACE_NORTH
    Move 3, 4  // FACE_EAST
    Move 1, 4  // FACE_SOUTH
    Move 2, 4  // FACE_WEST
    MoveEnd

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
    pl_msg_sys 6  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7  // Pearl bank 199 line 28
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
    pl_msg_sys 8  // Pearl bank 199 line 25
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
    pl_msg_sys 9  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 10  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 13  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 16  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:18 (a subroutine here)
C205_18_S18:
C205_18_0B60:
    pl_Call C205_18_0B6A
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_18_0B6A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 17  // Pearl bank 199 line 27
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
