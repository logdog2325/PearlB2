// MAP_POKEMON_LEAGUE_LOBBY_B1F: Pearl script file 194, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive; 72: Pearl 9200, 73: Pearl 9201, 74: Pearl 9202
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P194_S1
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
    ScriptEntry PearlProxy_9200
    ScriptEntry PearlProxy_9201
    ScriptEntry PearlProxy_9202
    ScriptEntriesEnd

P194_S1:
P194_0006:
    pl_End

PearlProxy_9200:                  // Pearl global script 9200 (run by this zone's events)
    VMCall C388_1_S1
    VMHalt

PearlProxy_9201:                  // Pearl global script 9201 (run by this zone's events)
    VMCall T388_2_S2
    VMHalt

PearlProxy_9202:                  // Pearl global script 9202 (run by this zone's events)
    VMCall T388_3_S3
    VMHalt

// ---- Pearl global script 388:1 (a subroutine here)
C388_1_S1:
C388_1_000E:
    pl_LockAll
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 81  // Pearl bank 379 line 0
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, C388_1_00CC
    pl_WaitMovement
    pl_msg_sys 82  // Pearl bank 379 line 1
    pl_SetVarFromValue PVAR_8004, 437
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_GoTo C388_1_003A

C388_1_003A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 83  // Pearl bank 379 line 2
    ListMenu_AnchorTopRight 31, 13, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 13, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 84, 65535, 0  // Pearl AddMenuEntryImm 153, 0
    ListMenuAdd 85, 65535, 1  // Pearl AddMenuEntryImm 154, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C388_1_007A
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C388_1_00BA
    pl_GoTo C388_1_00BA

C388_1_007A:
    pl_msg_sys 86  // Pearl bank 379 line 3
    ListMenu_AnchorTopRight 31, 13, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 13, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 87, 65535, 0  // Pearl AddMenuEntryImm 155, 0
    ListMenuAdd 85, 65535, 1  // Pearl AddMenuEntryImm 154, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C388_1_007A
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C388_1_00BA
    pl_GoTo C388_1_00BA

C388_1_00BA:
    pl_SetVarFromValue PVAR_40D4, 1
    pl_msg_sys 88  // Pearl bank 379 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

    .balign 4, 0
C388_1_00CC:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 2  // DELAY_8
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 0, 1  // FACE_NORTH
    Move 63, 2  // DELAY_8
    MoveEnd

// ---- Pearl global script 388:2 (a subroutine here)
T388_2_S2:
T388_2_00E8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 89  // Pearl bank 379 line 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T388_2_0117
    pl_GoTo T388_2_010C

T388_2_010C:
    pl_msg_talk 88  // Pearl bank 379 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T388_2_0117:
    pl_msg_talk 90  // Pearl bank 379 line 6
    ListMenu_AnchorTopRight 31, 13, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 13, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 84, 65535, 0  // Pearl AddMenuEntryImm 153, 0
    ListMenuAdd 85, 65535, 1  // Pearl AddMenuEntryImm 154, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T388_2_0157
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T388_2_010C
    pl_GoTo T388_2_010C

T388_2_0157:
    pl_msg_talk 86  // Pearl bank 379 line 3
    ListMenu_AnchorTopRight 31, 13, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 31, 13, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 87, 65535, 0  // Pearl AddMenuEntryImm 155, 0
    ListMenuAdd 85, 65535, 1  // Pearl AddMenuEntryImm 154, 1
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T388_2_0157
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T388_2_010C
    pl_GoTo T388_2_010C

// ---- Pearl global script 388:3 (a subroutine here)
T388_3_S3:
T388_3_0197:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSetConst PVAR_800C, 0  // CheckPartyHasBadEgg: never
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T388_3_03D8
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 91  // Pearl bank 379 line 7
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T388_3_01CC
    pl_GoTo T388_3_0223

T388_3_01CC:
    pl_stub GetWiFListValidFriendsCount  // Pearl 0x2A4 Unk02A4 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T388_3_01E3
    pl_GoTo T388_3_022E

T388_3_01E3:
    pl_stub CheckHasWiFiListValidLogin  // Pearl 0x2A3 Unk02A3 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T388_3_0218
    pl_GoTo T388_3_01FC

T388_3_01FC:
    pl_msg_talk 92  // Pearl bank 379 line 11
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T388_3_022E
    pl_GoTo T388_3_0223

T388_3_0218:
    pl_msg_talk 93  // Pearl bank 379 line 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T388_3_0223:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 94  // Pearl bank 379 line 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T388_3_022E:
    pl_HealParty
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T388_3_024F
    pl_GoTo T388_3_0223

T388_3_024F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 95  // Pearl bank 379 line 10
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 7
    pl_GoToIf 1, T388_3_0276
    pl_CompareVarToValue PVAR_8004, 9
    pl_GoToIf 1, T388_3_0288
    VMReturn  // End: the sub-script ends

T388_3_0276:
    pl_ApplyMovement PL_PLAYER, T388_3_0388
    pl_WaitMovement
    pl_GoTo T388_3_029A

T388_3_0288:
    pl_ApplyMovement PL_PLAYER, T388_3_0394
    pl_WaitMovement
    pl_GoTo T388_3_029A

T388_3_029A:
    pl_LoadDoorAnimation 77, 8, 5  // the door at cell (0,0) tile (8,5)
    pl_Call T388_3_02EE
    pl_ApplyMovement PL_PLAYER, T388_3_03A0
    pl_WaitMovement
    pl_Call T388_3_02F6
    pl_ApplyMovement PL_PLAYER, T388_3_03A8
    pl_WaitMovement
    pl_LoadDoorAnimation 77, 8, 2  // the door at cell (0,0) tile (8,2)
    pl_Call T388_3_02EE
    pl_ApplyMovement PL_PLAYER, T388_3_03B0
    pl_WaitMovement
    pl_Call T388_3_02F6
    pl_GoTo T388_3_0301

T388_3_02EE:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

T388_3_02F6:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

T388_3_0301:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub WaitForTransition  // Pearl 0x1F8 TerminateOverworldProcess : not translated yet
    pl_stub GetWiFListValidFriendsCount  // Pearl 0x2A4 Unk02A4 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T388_3_0328
    pl_stub 0A3  // Pearl 0x0A3 Unk00A3 : not translated yet
    pl_GoTo T388_3_032A

T388_3_0328:
    pl_stub 0A3  // Pearl 0x0A3 Unk00A3 : not translated yet

T388_3_032A:
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_LoadDoorAnimation 77, 8, 2  // the door at cell (0,0) tile (8,2)
    pl_Call T388_3_02EE
    pl_ApplyMovement PL_PLAYER, T388_3_03BC
    pl_WaitMovement
    pl_Call T388_3_02F6
    pl_ApplyMovement PL_PLAYER, T388_3_03C8
    pl_WaitMovement
    pl_LoadDoorAnimation 77, 8, 5  // the door at cell (0,0) tile (8,5)
    pl_Call T388_3_02EE
    pl_ApplyMovement PL_PLAYER, T388_3_03D0
    pl_WaitMovement
    pl_Call T388_3_02F6
    VMReturn  // End: the sub-script ends

T388_3_03D8:
    VMCall C207_17_S17  // CallCommonScript 9016 (Pearl file 207 script 17)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

    .balign 4, 0
T388_3_0388:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T388_3_0394:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T388_3_03A0:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T388_3_03A8:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T388_3_03B0:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
T388_3_03BC:
    Move 70, 1  // SET_VISIBLE
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
T388_3_03C8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
T388_3_03D0:
    Move 13, 2  // WALK_NORMAL_SOUTH
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
    pl_msg_sys 96  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 97  // Pearl bank 199 line 28
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
    pl_msg_sys 98  // Pearl bank 199 line 25
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
    pl_msg_sys 99  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 100  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 101  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 102  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 103  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 104  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 105  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 106  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:7 (a subroutine here)
C205_7_S7:
C205_7_0470:
    pl_Call C205_7_0480
    pl_SetVarFromVar PVAR_4000, PVAR_800C
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_7_0480:
    pl_stub CheckSaveType  // Pearl 0x12C CheckSaveStatus 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_7_04D4
    pl_stub OpenSaveInfo  // Pearl 0x2C1 ShowSaveStats : not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 107  // Pearl bank 199 line 13
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_stub CheckSaveType  // Pearl 0x12C CheckSaveStatus 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_04F5
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, C205_7_04E1
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, C205_7_04FE
    VMReturn  // End: the sub-script ends

C205_7_04D4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 108  // Pearl bank 199 line 20
    pl_WaitABPress
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_04E1:
    pl_msg_sys 109  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E

C205_7_04F5:
    pl_msg_sys 110  // Pearl bank 199 line 21
    pl_GoTo C205_7_051B

C205_7_04FE:
    pl_msg_sys 109  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_msg_sys 111  // Pearl bank 199 line 15
    pl_GoTo C205_7_051B

C205_7_051B:
    pl_stub 258  // Pearl 0x258 Unk0258 : not translated yet
    pl_WaitTime 2, PVAR_800C
    pl_Call C205_7_0531
    pl_stub 259  // Pearl 0x259 Unk0259 : not translated yet
    pl_GoTo C205_7_053B

C205_7_0531:
// ShowSavingIcon: nothing in Black 2
    SaveDataWrite PVAR_800C
// HideSavingIcon: nothing in Black 2
    pl_Return

C205_7_053B:
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_7_0568
    pl_BufferPlayerName 0
    pl_msg_sys 112  // Pearl bank 199 line 16
    pl_PlaySE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    pl_WaitSE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    VMSleep 30  // WaitABPressTime
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_Return

C205_7_055E:
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_0568:
    pl_msg_sys 113  // Pearl bank 199 line 18
    pl_WaitABPress
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_Return

// ---- Pearl global script 207:17 (a subroutine here)
C207_17_S17:
C207_17_074C:
    pl_Call C207_17_0756
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C207_17_0756:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 114  // Pearl bank 207 line 127
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
