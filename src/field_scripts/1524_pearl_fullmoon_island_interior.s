// MAP_FULLMOON_ISLAND_INTERIOR: Pearl script file 274, text bank 243. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P274_S1
    ScriptEntry P274_S2
    ScriptEntry PearlArrive
    ScriptEntry PearlItemBall_1
    ScriptEntriesEnd

P274_S1:
P274_000A:
    pl_End

P274_S2:
P274_000C:
    pl_LockAll
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_stub DrawPokemonPreview  // Pearl 0x208 ShowPokemonPic 488, 1: not translated yet
    pl_WaitABPress
    pl_stub RemovePokemonPreview  // Pearl 0x209 Unk0209 : not translated yet
    pl_PlayCry 488
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P274_0069
// ReleaseObject 0: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_stub FlickerObject  // Pearl 0x26A BlinkEvent 0, 6, 8: not translated yet
// LockObject 0: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_SetFlag PFLAG_026D
    pl_RemoveObject 0, PFLAG_026D
    pl_ClearFlag PFLAG_0436
    pl_AddObjectAt 1, 0, 0  // at its SetObjectEventPos
    pl_stub ActivateRoamingPokemon  // Pearl 0x21C CreateRoamer 1: not translated yet
    pl_SetFlag PFLAG_011F
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P274_0069:
    pl_SetObjectEventPosLater 0, 1, 16, 0, 14, 0  // SetObjectEventPos 1 (the live actor; and where AddObject puts it)
    pl_ApplyMovement 0, P274_0080
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P274_0080:
    Move 71, 1  // LOCK_DIR
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

PearlItemBall_1:                // item ball (data/pearl_item_balls.json): object 1, Pearl script 7252 (item 453)
    VMCall C370_253_S253
    VMHalt

// ---- Pearl global script 370:253 (a subroutine here)
C370_253_S253:
C370_253_17B2:
    pl_SetVarFromValue PVAR_8008, 453
    pl_SetVarFromValue PVAR_8009, 1
    pl_GoTo C370_253_17EE

C370_253_17EE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_SetVarFromVar PVAR_8004, PVAR_8008
    pl_SetVarFromVar PVAR_8005, PVAR_8009
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C370_253_1830
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C370_253_19E8
    VMReturn  // End: the sub-script ends

C370_253_182A:
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C370_253_1830:
    VMCall C205_2_S2  // CallCommonScript 2001 (Pearl file 205 script 2)
    pl_RemoveTalkedObject  // RemoveEvent VAR_LAST_TALKED: the ball, and its flag
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
// Unk02A2 PVAR_8004: Pearl's orb record (items 135/136), read by no script: nothing in Black 2
    pl_CompareVarToValue PVAR_8004, 463
    pl_CallIf 1, C370_253_1A00
    ItemIsTMHM PVAR_8004, PVAR_800C  // ItemIdIsTMOrHM
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C370_253_19BD
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C370_253_19D5
    VMReturn  // End: the sub-script ends

C370_253_1873:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C370_253_1A06
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C370_253_1919
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C370_253_1906
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C370_253_1965
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C370_253_1952
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C370_253_1978
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C370_253_198B
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C370_253_193F
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C370_253_192C
    VMReturn  // End: the sub-script ends

C370_253_1906:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_1919:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_192C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_193F:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_1952:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_1965:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_1978:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_198B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C370_253_199E

C370_253_199E:
// CreateJournalEvent 18, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1  // Pearl bank 325 line 9
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 1
    pl_GoTo C370_253_182A

C370_253_19BD:
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    pl_BufferTMHMMoveName 2, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2  // Pearl bank 325 line 6
    pl_GoTo C370_253_1873

C370_253_19D5:
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3  // Pearl bank 325 line 3
    pl_GoTo C370_253_1873

C370_253_19E8:
    pl_BufferItemName 0, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4  // Pearl bank 325 line 4
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 0
    pl_GoTo C370_253_182A

C370_253_1A00:
    pl_SetFlag PFLAG_0986
    pl_Return

C370_253_1A06:
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
    pl_msg_sys 5  // Pearl bank 199 line 110
    pl_Return

C205_39_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6  // Pearl bank 199 line 111
    pl_Return

C205_39_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 7  // Pearl bank 199 line 112
    pl_Return

C205_39_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 8  // Pearl bank 199 line 113
    pl_Return

C205_39_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9  // Pearl bank 199 line 114
    pl_Return

C205_39_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 10  // Pearl bank 199 line 115
    pl_Return

C205_39_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 116
    pl_Return

C205_39_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 117
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
