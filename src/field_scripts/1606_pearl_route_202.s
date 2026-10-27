// MAP_ROUTE_202: Pearl script file 393, text bank 416. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P393_S1
    ScriptEntry P393_S2
    ScriptEntry P393_S3
    ScriptEntry P393_S4
    ScriptEntry P393_S5
    ScriptEntry P393_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P393_S1:
P393_001A:
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P393_003A
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P393_0042
    pl_End

P393_003A:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P393_0042:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P393_S2:
P393_004A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P393_S3:
P393_005D:
    pl_sign 11, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P393_S4:
P393_0074:
    pl_sign 12, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P393_S5:
P393_008B:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 13, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P393_S6:
P393_00A0:
    pl_LockAll
    pl_ApplyMovement 3, P393_039C
    pl_ApplyMovement PL_PLAYER, P393_0478
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 825
    pl_GoToIf 1, P393_00FD
    pl_CompareVarToValue PVAR_8005, 826
    pl_GoToIf 1, P393_010D
    pl_CompareVarToValue PVAR_8005, 827
    pl_GoToIf 1, P393_011D
    pl_CompareVarToValue PVAR_8005, 828
    pl_GoToIf 1, P393_012D
    pl_CompareVarToValue PVAR_8005, 829
    pl_GoToIf 1, P393_013D
    pl_End

P393_00FD:
    pl_ApplyMovement 3, P393_03AC
    pl_WaitMovement
    pl_GoTo P393_014D

P393_010D:
    pl_ApplyMovement 3, P393_03BC
    pl_WaitMovement
    pl_GoTo P393_014D

P393_011D:
    pl_ApplyMovement 3, P393_03CC
    pl_WaitMovement
    pl_GoTo P393_014D

P393_012D:
    pl_ApplyMovement 3, P393_03D8
    pl_WaitMovement
    pl_GoTo P393_014D

P393_013D:
    pl_ApplyMovement 3, P393_03E8
    pl_WaitMovement
    pl_GoTo P393_014D

P393_014D:
    pl_CheckFlag PFLAG_008F
    pl_GoToIf 0, P393_0255
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P393_0178
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P393_018B
    pl_End

P393_0178:
    VMCall C205_41_S41  // CallCommonScript 2040 (Pearl file 205 script 41)
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 2
    pl_GoTo P393_019E

P393_018B:
    VMCall C205_41_S41  // CallCommonScript 2040 (Pearl file 205 script 41)
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_msg_sys 7
    pl_GoTo P393_019E

P393_019E:
    pl_CloseMessage
    pl_ApplyMovement 3, P393_0460
    pl_ApplyMovement PL_PLAYER, P393_0494
    pl_WaitMovement
    pl_StartCatchingTutorial
    pl_ApplyMovement 3, P393_0468
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P393_01DE
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P393_01EA
    pl_End

P393_01DE:
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_GoTo P393_01F6

P393_01EA:
    pl_BufferPlayerName 0
    pl_msg_sys 8
    pl_GoTo P393_01F6

P393_01F6:
    pl_SetVarFromValue PVAR_8004, 4
    pl_SetVarFromValue PVAR_8005, 5
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P393_0226
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P393_0232
    pl_End

P393_0226:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4
    pl_GoTo P393_023B

P393_0232:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 9
    pl_GoTo P393_023B

P393_023B:
    pl_CloseMessage
    pl_ApplyMovement 3, P393_0470
    pl_WaitMovement
    pl_RemoveObject 3, PFLAG_01A6
    pl_SetVarFromValue PVAR_4087, 1
    pl_ReleaseAll
    pl_End

P393_0255:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P393_0275
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P393_02A1
    pl_End

P393_0275:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_CheckFlag PFLAG_0115
    pl_CallIf 0, P393_0297
    pl_CheckFlag PFLAG_0115
    pl_CallIf 1, P393_029C
    pl_GoTo P393_02CD

P393_0297:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_Return

P393_029C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_Return

P393_02A1:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerName 1
    pl_CheckFlag PFLAG_0115
    pl_CallIf 0, P393_02C3
    pl_CheckFlag PFLAG_0115
    pl_CallIf 1, P393_02C8
    pl_GoTo P393_02CD

P393_02C3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 5
    pl_Return

P393_02C8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 6
    pl_Return

P393_02CD:
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8005, 825
    pl_GoToIf 1, P393_0312
    pl_CompareVarToValue PVAR_8005, 826
    pl_GoToIf 1, P393_032A
    pl_CompareVarToValue PVAR_8005, 827
    pl_GoToIf 1, P393_0342
    pl_CompareVarToValue PVAR_8005, 828
    pl_GoToIf 1, P393_035A
    pl_CompareVarToValue PVAR_8005, 829
    pl_GoToIf 1, P393_0372
    pl_End

P393_0312:
    pl_ApplyMovement 3, P393_03F8
    pl_ApplyMovement PL_PLAYER, P393_0484
    pl_WaitMovement
    pl_GoTo P393_038A

P393_032A:
    pl_ApplyMovement 3, P393_040C
    pl_ApplyMovement PL_PLAYER, P393_0484
    pl_WaitMovement
    pl_GoTo P393_038A

P393_0342:
    pl_ApplyMovement 3, P393_0420
    pl_ApplyMovement PL_PLAYER, P393_0484
    pl_WaitMovement
    pl_GoTo P393_038A

P393_035A:
    pl_ApplyMovement 3, P393_0430
    pl_ApplyMovement PL_PLAYER, P393_0484
    pl_WaitMovement
    pl_GoTo P393_038A

P393_0372:
    pl_ApplyMovement 3, P393_0444
    pl_ApplyMovement PL_PLAYER, P393_0484
    pl_WaitMovement
    pl_GoTo P393_038A

P393_038A:
    pl_ApplyMovement 3, P393_0458
    pl_WaitMovement
    pl_SetFlag PFLAG_0115
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P393_039C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
P393_03AC:
    Move 15, 4  // WALK_NORMAL_EAST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P393_03BC:
    Move 15, 4  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P393_03CC:
    Move 15, 4  // WALK_NORMAL_EAST
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P393_03D8:
    Move 15, 4  // WALK_NORMAL_EAST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P393_03E8:
    Move 15, 4  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P393_03F8:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 14, 4  // WALK_NORMAL_WEST
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P393_040C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 14, 4  // WALK_NORMAL_WEST
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P393_0420:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 14, 4  // WALK_NORMAL_WEST
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P393_0430:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 14, 4  // WALK_NORMAL_WEST
    Move 14, 2  // WALK_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P393_0444:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 14, 4  // WALK_NORMAL_WEST
    Move 14, 2  // WALK_NORMAL_WEST
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P393_0458:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P393_0460:
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P393_0468:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P393_0470:
    Move 14, 12  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P393_0478:
    Move 63, 1  // DELAY_8
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P393_0484:
    Move 71, 1  // LOCK_DIR
    Move 15, 1  // WALK_NORMAL_EAST
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P393_0494:
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

// ---- Pearl global script 205:41 (a subroutine here)
C205_41_S41:
C205_41_14CD:
    pl_FadeOutBGM 1  // StopMusic
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, C205_41_14F3
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_41_14F9
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_41_14F3:
    #ifdef SEQ_PEARL_THE_GIRL
        pl_PlayMusic SEQ_PEARL_THE_GIRL  // Pearl SEQ_THE_GIRL
    #else
        pl_PlayMusic SEQ_BGM_E_BERU  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_Return

C205_41_14F9:
    #ifdef SEQ_PEARL_THE_BOY
        pl_PlayMusic SEQ_PEARL_THE_BOY  // Pearl SEQ_THE_BOY
    #else
        pl_PlayMusic SEQ_BGM_E_BERU  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_Return

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
    pl_msg_sys 14  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 15  // Pearl bank 199 line 28
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
    pl_msg_sys 16  // Pearl bank 199 line 25
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
    pl_msg_sys 17  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 18  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 19  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 20  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 21  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 117
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
