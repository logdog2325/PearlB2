// MAP_ROUTE_217: Pearl script file 436, text bank 456. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P436_S1
    ScriptEntry P436_S2
    ScriptEntry P436_S3
    ScriptEntry PearlArrive
    ScriptEntry PearlItemBall_10
    ScriptEntriesEnd

P436_S1:
P436_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P436_S2:
P436_001F:
    pl_sign 2, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P436_S3:
P436_0036:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlItemBall_10:                // item ball (data/pearl_item_balls.json): object 10, Pearl script 7174 (item 427)
    VMCall C370_175_S175
    VMHalt

// ---- Pearl global script 370:175 (a subroutine here)
C370_175_S175:
C370_175_119A:
    pl_SetVarFromValue PVAR_8008, 529  // Pearl item 427 (HM08) = TM120 Rock Climb
    pl_SetVarFromValue PVAR_8009, 1
    pl_GoTo C370_175_17EE

C370_175_17EE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_SetVarFromVar PVAR_8004, PVAR_8008
    pl_SetVarFromVar PVAR_8005, PVAR_8009
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C370_175_1830
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C370_175_19E8
    VMReturn  // End: the sub-script ends

C370_175_182A:
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C370_175_1830:
    VMCall C205_2_S2  // CallCommonScript 2001 (Pearl file 205 script 2)
    pl_RemoveTalkedObject  // RemoveEvent VAR_LAST_TALKED: the ball, and its flag
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
// Unk02A2 PVAR_8004: Pearl's orb record (items 135/136), read by no script: nothing in Black 2
    pl_CompareVarToValue PVAR_8004, 463
    pl_CallIf 1, C370_175_1A00
    ItemIsTMHM PVAR_8004, PVAR_800C  // ItemIdIsTMOrHM
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C370_175_19BD
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C370_175_19D5
    VMReturn  // End: the sub-script ends

C370_175_1873:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C370_175_1A06
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C370_175_1919
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C370_175_1906
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C370_175_1965
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C370_175_1952
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C370_175_1978
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C370_175_198B
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C370_175_193F
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C370_175_192C
    VMReturn  // End: the sub-script ends

C370_175_1906:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_1919:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_192C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_193F:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_1952:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_1965:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_1978:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_198B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_175_199E

C370_175_199E:
// CreateJournalEvent 18, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4  // Pearl bank 325 line 9
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 1
    pl_GoTo C370_175_182A

C370_175_19BD:
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    pl_BufferTMHMMoveName 2, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 5  // Pearl bank 325 line 6
    pl_GoTo C370_175_1873

C370_175_19D5:
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6  // Pearl bank 325 line 3
    pl_GoTo C370_175_1873

C370_175_19E8:
    pl_BufferItemName 0, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7  // Pearl bank 325 line 4
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 0
    pl_GoTo C370_175_182A

C370_175_1A00:
    pl_SetFlag PFLAG_0986
    pl_Return

C370_175_1A06:
    VMCall C205_39_S39  // CallCommonScript 2038 (Pearl file 205 script 39)
    pl_Return

// ---- Pearl global script 205:2 (a subroutine here)
C205_2_S2:
C205_2_032C:
    pl_Call C205_2_0336
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_2_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_2_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_2_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_2_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_2_03B2
    VMReturn  // End: the sub-script ends

C205_2_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_2_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_2_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_2_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

// ---- Pearl global script 205:39 (a subroutine here)
C205_39_S39:
C205_39_1326:
    pl_Call C205_39_1330
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_39_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_39_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_39_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_39_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_39_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_39_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_39_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_39_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_39_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_39_13D8
    pl_Return

C205_39_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_39_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 8  // Pearl bank 199 line 110
    pl_Return

C205_39_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9  // Pearl bank 199 line 111
    pl_Return

C205_39_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 10  // Pearl bank 199 line 112
    pl_Return

C205_39_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 113
    pl_Return

C205_39_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 114
    pl_Return

C205_39_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 13  // Pearl bank 199 line 115
    pl_Return

C205_39_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 14  // Pearl bank 199 line 116
    pl_Return

C205_39_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15  // Pearl bank 199 line 117
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
