// MAP_POKEMON_LEAGUE_LOBBY_2F: Pearl script file 193, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive; 62: Pearl 9000, 63: Pearl 9001, 64: Pearl 9003, 65: Pearl 9011, 66: Pearl 9012, 67: Pearl 9013, 68: Pearl 9014, 69: Pearl 9015
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P193_S1
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
    ScriptEntry PearlProxy_9000
    ScriptEntry PearlProxy_9001
    ScriptEntry PearlProxy_9003
    ScriptEntry PearlProxy_9011
    ScriptEntry PearlProxy_9012
    ScriptEntry PearlProxy_9013
    ScriptEntry PearlProxy_9014
    ScriptEntry PearlProxy_9015
    ScriptEntriesEnd

P193_S1:
P193_0006:
    pl_End

PearlProxy_9000:                  // Pearl global script 9000 (run by this zone's events)
    VMCall C207_1_S1
    VMHalt

PearlProxy_9001:                  // Pearl global script 9001 (run by this zone's events)
    VMCall T207_2_S2
    VMHalt

PearlProxy_9003:                  // Pearl global script 9003 (run by this zone's events)
    VMCall T207_4_S4
    VMHalt

PearlProxy_9011:                  // Pearl global script 9011 (run by this zone's events)
    VMCall T207_12_S12
    VMHalt

PearlProxy_9012:                  // Pearl global script 9012 (run by this zone's events)
    VMCall C207_13_S13
    VMHalt

PearlProxy_9013:                  // Pearl global script 9013 (run by this zone's events)
    VMCall C207_14_S14
    VMHalt

PearlProxy_9014:                  // Pearl global script 9014 (run by this zone's events)
    VMCall C207_15_S15
    VMHalt

PearlProxy_9015:                  // Pearl global script 9015 (run by this zone's events)
    VMCall C207_16_S16
    VMHalt

// ---- Pearl global script 207:1 (a subroutine here)
C207_1_S1:
C207_1_0046:
    pl_CompareVarToValue PVAR_40D5, 0
    pl_CallIf 5, C207_1_0055
    VMReturn  // End: the sub-script ends

C207_1_0055:
// Pearl HideObject 255 in a map script: Black 2 moves no actor there (left out)
    pl_Return

// ---- Pearl global script 207:2 (a subroutine here)
T207_2_S2:
T207_2_0108:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSetConst PVAR_800C, 0  // CheckPartyHasBadEgg: never
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_2_073E
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 81  // Pearl bank 207 line 0
    pl_GoTo T207_2_012C

T207_2_012C:
    pl_msg_talk 82  // Pearl bank 207 line 1
    ListMenu_AnchorTopRight 31, 1, 1, 0, PVAR_800C  // Pearl InitGlobalTextListMenu 1, 1, 1, 1, PVAR_800C
    ListMenuAdd 83, 65535, 255  // Pearl AddListMenuEntry 163, 255
    ListMenuAdd 84, 65535, 255  // Pearl AddListMenuEntry 6, 255
    ListMenuAdd 85, 65535, 255  // Pearl AddListMenuEntry 7, 255
    ListMenuAdd 86, 65535, 255  // Pearl AddListMenuEntry 8, 255
    ListMenuAdd 87, 65535, 255  // Pearl AddListMenuEntry 164, 255
    ListMenuAdd 88, 65535, 255  // Pearl AddListMenuEntry 9, 255
    ListMenuAdd 89, 65535, 255  // Pearl AddListMenuEntry 10, 255
    ListMenuAdd 90, 65535, 255  // Pearl AddListMenuEntry 11, 255
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T207_2_01DE
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T207_2_01F2
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T207_2_021A
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T207_2_0242
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, T207_2_01C8
    pl_GoTo T207_2_01D3

T207_2_01C8:
    pl_msg_talk 91  // Pearl bank 207 line 2
    pl_GoTo T207_2_012C

T207_2_01D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 92  // Pearl bank 207 line 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_01DE:
    pl_SetVarFromValue PVAR_8004, 1
    pl_GoTo T207_2_026A

T207_2_01F2:
    pl_SetVarFromValue PVAR_8004, 2
    pl_CountPartyNonEggs PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 0, T207_2_020F
    pl_GoTo T207_2_026A

T207_2_020F:
    pl_msg_talk 93  // Pearl bank 207 line 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_021A:
    pl_SetVarFromValue PVAR_8004, 3
    pl_CountPartyNonEggs PVAR_800C
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 0, T207_2_0237
    pl_GoTo T207_2_0290

T207_2_0237:
    pl_msg_talk 94  // Pearl bank 207 line 126
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_0242:
    pl_SetVarFromValue PVAR_8004, 4
    pl_CountPartyNonEggs PVAR_800C
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 0, T207_2_025F
    pl_GoTo T207_2_0290

T207_2_025F:
    pl_msg_talk 95  // Pearl bank 207 line 125
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_026A:
    pl_stub OpenBattleRegulationMenu  // Pearl 0x239 Unk0239 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_2_0290
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T207_2_0290
    pl_GoTo T207_2_01D3

T207_2_0290:
    pl_SetVarFromValue PVAR_8005, 0
    pl_GoTo T207_2_02E4

T207_2_02E4:
    pl_HealParty
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_2_0305
    pl_GoTo T207_2_01D3

T207_2_0305:
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T207_2_037A
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, T207_2_037A
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, T207_2_037A
    pl_CompareVarToValue PVAR_8004, 4
    pl_CallIf 1, T207_2_037F
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 30, 1, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 96, 65535, 0  // Pearl AddMenuEntryImm 13, 0
    ListMenuAdd 97, 65535, 1  // Pearl AddMenuEntryImm 14, 1
    ListMenuAdd 98, 65535, 2  // Pearl AddMenuEntryImm 5, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T207_2_0384
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T207_2_03F7
    pl_GoTo T207_2_01D3

T207_2_037A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 99  // Pearl bank 207 line 22
    pl_Return

T207_2_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 100  // Pearl bank 207 line 43
    pl_Return

T207_2_0384:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 101  // Pearl bank 207 line 124
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_2_0305
    pl_CloseMessage
    pl_stub StartBattleClient  // Pearl 0x0F2 Unk00F2 32772, 32773, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_2_03D3
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T207_2_03DD
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, T207_2_03EA
    pl_GoTo T207_2_046A

T207_2_03D3:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo T207_2_0305

T207_2_03DD:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_msg_talk 102  // Pearl bank 207 line 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_03EA:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_msg_talk 92  // Pearl bank 207 line 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_03F7:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 101  // Pearl bank 207 line 124
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_2_0305
    pl_CloseMessage
    pl_stub StartBattleServer  // Pearl 0x0F3 Unk00F3 32772, 32773, 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_2_0446
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T207_2_0450
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, T207_2_045D
    pl_GoTo T207_2_046A

T207_2_0446:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_GoTo T207_2_0305

T207_2_0450:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_msg_talk 102  // Pearl bank 207 line 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_045D:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_msg_talk 92  // Pearl bank 207 line 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_046A:
    pl_SetVarFromValue PVAR_40D5, 1
    pl_SetFlag PFLAG_0966
    pl_msg_talk 103  // Pearl bank 207 line 52
    VMSleep 45  // WaitABPressTime
    pl_stub 135  // Pearl 0x135 Unk0135 96: not translated yet
    pl_CloseMessage
    pl_LoadDoorAnimation 77, 13, 5  // the door at cell (0,0) tile (13,5)
    pl_Call T207_2_050B
    pl_ApplyMovement PL_PLAYER, T207_2_0524
    pl_WaitMovement
    pl_Call T207_2_0513
    pl_ApplyMovement PL_PLAYER, T207_2_0530
    pl_WaitMovement
    pl_LoadDoorAnimation 77, 13, 2  // the door at cell (0,0) tile (13,2)
    pl_Call T207_2_050B
    pl_ApplyMovement PL_PLAYER, T207_2_0538
    pl_WaitMovement
    pl_Call T207_2_0513
    pl_CompareVarToValue PVAR_8004, 4
    pl_GoToIf 1, T207_2_04F3
    pl_stub GetCurNetID  // Pearl 0x207 Unk0207 32780: not translated yet
    pl_AddVar PVAR_800C, 7
    pl_stub WarpToColosseum  // Pearl 0x203 BattleRoomWarp 332, 0, 32780, 11, 0: not translated yet
    VMReturn  // End: the sub-script ends

T207_2_04F3:
    pl_stub GetCurNetID  // Pearl 0x207 Unk0207 32780: not translated yet
    pl_AddVar PVAR_800C, 6
    pl_stub WarpToColosseum  // Pearl 0x203 BattleRoomWarp 333, 0, 32780, 11, 0: not translated yet
    VMReturn  // End: the sub-script ends

T207_2_050B:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

T207_2_0513:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

T207_2_073E:
    pl_Call T207_2_0756
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_2_0756:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 104  // Pearl bank 207 line 127
    pl_Return

    .balign 4, 0
T207_2_0524:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T207_2_0530:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T207_2_0538:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

// ---- Pearl global script 207:4 (a subroutine here)
T207_4_01D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 92  // Pearl bank 207 line 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_4_050B:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

T207_4_0513:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

T207_4_S4:
T207_4_0544:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSetConst PVAR_800C, 0  // CheckPartyHasBadEgg: never
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_4_073E
    pl_GoTo T207_4_0565

T207_4_0565:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 105  // Pearl bank 207 line 57
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 106, 65535, 0  // Pearl AddMenuEntryImm 41, 0
    ListMenuAdd 107, 65535, 1  // Pearl AddMenuEntryImm 42, 1
    ListMenuAdd 89, 65535, 2  // Pearl AddMenuEntryImm 10, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T207_4_05CF
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T207_4_01D3
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T207_4_05B3
    pl_GoTo T207_4_01D3

T207_4_05B3:
    pl_msg_talk 108  // Pearl bank 207 line 58
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T207_4_05CF
    pl_GoTo T207_4_01D3

T207_4_05CF:
    pl_SetVarFromValue PVAR_8004, 9
    pl_HealParty
    pl_msg_talk 101  // Pearl bank 207 line 124
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_4_01D3
    pl_SetVarFromValue PVAR_40D5, 2
    pl_SetFlag PFLAG_0966
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T207_4_061C
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ClearFlag PFLAG_0966
    pl_GoTo T207_4_01D3

T207_4_061C:
    pl_SetVarFromValue PVAR_40D5, 2
    pl_SetFlag PFLAG_0966
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 109  // Pearl bank 207 line 63
    pl_CloseMessage
    pl_LoadDoorAnimation 77, 8, 5  // the door at cell (0,0) tile (8,5)
    pl_Call T207_4_050B
    pl_ApplyMovement PL_PLAYER, T207_4_0524
    pl_WaitMovement
    pl_Call T207_4_0513
    pl_ApplyMovement PL_PLAYER, T207_4_0530
    pl_WaitMovement
    pl_LoadDoorAnimation 77, 8, 2  // the door at cell (0,0) tile (8,2)
    pl_Call T207_4_050B
    pl_ApplyMovement PL_PLAYER, T207_4_0538
    pl_WaitMovement
    pl_Call T207_4_0513
    pl_ReleaseAll
    pl_stub 153  // Pearl 0x153 Unk0153 : not translated yet
    VMReturn  // End: the sub-script ends

T207_4_073E:
    pl_Call T207_4_0756
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T207_4_0756:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 104  // Pearl bank 207 line 127
    pl_Return

    .balign 4, 0
T207_4_0524:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T207_4_0530:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T207_4_0538:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

// ---- Pearl global script 207:12 (a subroutine here)
T207_12_S12:
T207_12_069D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetFlag PFLAG_00AA
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 110  // Pearl bank 207 line 102
    pl_GoTo T207_12_06B4

T207_12_06B4:
    pl_msg_talk 111  // Pearl bank 207 line 103
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 106, 65535, 0  // Pearl AddMenuEntryImm 41, 0
    ListMenuAdd 107, 65535, 1  // Pearl AddMenuEntryImm 42, 1
    ListMenuAdd 89, 65535, 2  // Pearl AddMenuEntryImm 10, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T207_12_070D
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T207_12_0733
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T207_12_0702
    pl_GoTo T207_12_0733

T207_12_0702:
    pl_msg_talk 112  // Pearl bank 207 line 105
    pl_GoTo T207_12_06B4

T207_12_070D:
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub StartSignatureApp  // Pearl 0x12B ShowSignatureScreen : not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_GoTo T207_12_0733

T207_12_0733:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 113  // Pearl bank 207 line 104
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 207:13 (a subroutine here)
C207_13_S13:
C207_13_005B:
    pl_SetVarFromValue PVAR_4000, 13
    pl_SetVarFromValue PVAR_4001, 5
    pl_SetVarFromValue PVAR_4002, 2
    pl_GoTo C207_13_008F

C207_13_008F:
    pl_LockAll
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4002
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4002)
    pl_Call C207_13_050B
    pl_ShowObject PL_PLAYER  // Pearl ShowObject 255
    pl_ApplyMovement PL_PLAYER, C207_13_00F0
    pl_WaitMovement
    pl_Call C207_13_0513
    pl_ApplyMovement PL_PLAYER, C207_13_00F8
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4001
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4001)
    pl_Call C207_13_050B
    pl_ApplyMovement PL_PLAYER, C207_13_0100
    pl_WaitMovement
    pl_Call C207_13_0513
    pl_ClearFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C207_13_050B:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

C207_13_0513:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

    .balign 4, 0
C207_13_00F0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_13_00F8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_13_0100:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- Pearl global script 207:14 (a subroutine here)
C207_14_S14:
C207_14_0075:
    pl_SetVarFromValue PVAR_4000, 8
    pl_SetVarFromValue PVAR_4001, 5
    pl_SetVarFromValue PVAR_4002, 2
    pl_GoTo C207_14_008F

C207_14_008F:
    pl_LockAll
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4002
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4002)
    pl_Call C207_14_050B
    pl_ShowObject PL_PLAYER  // Pearl ShowObject 255
    pl_ApplyMovement PL_PLAYER, C207_14_00F0
    pl_WaitMovement
    pl_Call C207_14_0513
    pl_ApplyMovement PL_PLAYER, C207_14_00F8
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4001
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4001)
    pl_Call C207_14_050B
    pl_ApplyMovement PL_PLAYER, C207_14_0100
    pl_WaitMovement
    pl_Call C207_14_0513
    pl_ClearFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C207_14_050B:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

C207_14_0513:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

    .balign 4, 0
C207_14_00F0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_14_00F8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_14_0100:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- Pearl global script 207:15 (a subroutine here)
C207_15_S15:
C207_15_005B:
    pl_SetVarFromValue PVAR_4000, 13
    pl_SetVarFromValue PVAR_4001, 5
    pl_SetVarFromValue PVAR_4002, 2
    pl_GoTo C207_15_008F

C207_15_008F:
    pl_LockAll
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4002
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4002)
    pl_Call C207_15_050B
    pl_ShowObject PL_PLAYER  // Pearl ShowObject 255
    pl_ApplyMovement PL_PLAYER, C207_15_00F0
    pl_WaitMovement
    pl_Call C207_15_0513
    pl_ApplyMovement PL_PLAYER, C207_15_00F8
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4001
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4001)
    pl_Call C207_15_050B
    pl_ApplyMovement PL_PLAYER, C207_15_0100
    pl_WaitMovement
    pl_Call C207_15_0513
    pl_ClearFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C207_15_050B:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

C207_15_0513:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

    .balign 4, 0
C207_15_00F0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_15_00F8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_15_0100:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- Pearl global script 207:16 (a subroutine here)
C207_16_S16:
C207_16_005B:
    pl_SetVarFromValue PVAR_4000, 13
    pl_SetVarFromValue PVAR_4001, 5
    pl_SetVarFromValue PVAR_4002, 2
    pl_GoTo C207_16_008F

C207_16_008F:
    pl_LockAll
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4002
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4002)
    pl_Call C207_16_050B
    pl_ShowObject PL_PLAYER  // Pearl ShowObject 255
    pl_ApplyMovement PL_PLAYER, C207_16_00F0
    pl_WaitMovement
    pl_Call C207_16_0513
    pl_ApplyMovement PL_PLAYER, C207_16_00F8
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_4000
    WorkSetConst PL_TMP2, 0
    WorkAdd PL_TMP2, PVAR_4001
    pl_LoadDoorAnimation 77, PL_TMP, PL_TMP2  // the door at cell (0,0) tile (PVAR_4000,PVAR_4001)
    pl_Call C207_16_050B
    pl_ApplyMovement PL_PLAYER, C207_16_0100
    pl_WaitMovement
    pl_Call C207_16_0513
    pl_ClearFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C207_16_050B:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

C207_16_0513:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

    .balign 4, 0
C207_16_00F0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_16_00F8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C207_16_0100:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

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
    pl_msg_sys 114  // Pearl bank 199 line 13
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
    pl_msg_sys 115  // Pearl bank 199 line 20
    pl_WaitABPress
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_04E1:
    pl_msg_sys 116  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E

C205_7_04F5:
    pl_msg_sys 117  // Pearl bank 199 line 21
    pl_GoTo C205_7_051B

C205_7_04FE:
    pl_msg_sys 116  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_msg_sys 118  // Pearl bank 199 line 15
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
    pl_msg_sys 119  // Pearl bank 199 line 16
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
    pl_msg_sys 120  // Pearl bank 199 line 18
    pl_WaitABPress
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
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
