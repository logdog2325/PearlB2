// MAP_ETERNA_UNDERGROUND_MAN_HOUSE: Pearl script file 89, text bank 97. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; no warp continuations; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P89_S1
    ScriptEntry P89_S2
    ScriptEntry P89_S3
    ScriptEntry P89_S4
    ScriptEntry P89_S5
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P89_S1:
P89_0016:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40B6, 9
    pl_GoToIf 4, P89_00AE
    pl_CheckFlag PFLAG_0113
    pl_GoToIf 1, P89_015E
    pl_CheckFlag PFLAG_0079
    pl_GoToIf 1, P89_007A
    pl_msg_talk 0
    pl_SetVarFromValue PVAR_8004, 428
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0079
    pl_ClearFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P89_0098
    pl_SetFlag PFLAG_0113
    pl_GoTo P89_015E

P89_007A:
    pl_msg_talk 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P89_0098
    pl_SetFlag PFLAG_0113
    pl_GoTo P89_015E

P89_0098:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_00A3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_00AE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 33
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_00B9:
    pl_SetFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_00C8:
    pl_SetFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_00D7:
    pl_SetFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_00E6:
    pl_SetFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_00F5:
    pl_SetFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0104:
    pl_SetFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 24
    pl_Call P89_0579
    pl_msg_talk 25
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_011C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0127:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0132:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_013D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0148:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 21
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0153:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_015E:
    pl_CompareVarToValue PVAR_40B6, 0
    pl_GoToIf 1, P89_01D9
    pl_CompareVarToValue PVAR_40B6, 1
    pl_GoToIf 1, P89_00A3
    pl_CompareVarToValue PVAR_40B6, 2
    pl_GoToIf 1, P89_0295
    pl_CompareVarToValue PVAR_40B6, 3
    pl_GoToIf 1, P89_02D3
    pl_CompareVarToValue PVAR_40B6, 4
    pl_GoToIf 1, P89_0341
    pl_CompareVarToValue PVAR_40B6, 5
    pl_GoToIf 1, P89_03D3
    pl_CompareVarToValue PVAR_40B6, 6
    pl_GoToIf 1, P89_0442
    pl_CompareVarToValue PVAR_40B6, 7
    pl_GoToIf 1, P89_04A3
    pl_CompareVarToValue PVAR_40B6, 8
    pl_GoToIf 1, P89_0504
    pl_GoTo P89_00AE

P89_01D9:
    pl_CheckFlag PFLAG_0111
    pl_GoToIf 0, P89_00B9
    pl_CheckFlag PFLAG_096E
    pl_GoToIf 0, P89_011C
    pl_SetVarFromValue PVAR_40B6, 1
    pl_ClearFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_SetVarFromValue PVAR_8004, 1
    pl_SetVarFromValue PVAR_8005, 1
// Pearl 0x014 CallCommonScript 2013: dropped (data/pearl_script_patches.json: no Underground Traps (first of the mission-1 reward's three GiveUndergroundTrap calls))
    pl_SetVarFromValue PVAR_8004, 23
    pl_SetVarFromValue PVAR_8005, 1
// Pearl 0x014 CallCommonScript 2013: dropped (data/pearl_script_patches.json: no Underground Traps)
    pl_SetVarFromValue PVAR_8004, 28
    pl_SetVarFromValue PVAR_8005, 1
// Pearl 0x014 CallCommonScript 2013: dropped (data/pearl_script_patches.json: no Underground Traps)
    pl_msg_talk 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0237:
    pl_CheckFlag PFLAG_0111
    pl_GoToIf 0, P89_00C8
    pl_CheckFlag PFLAG_096F
    pl_GoToIf 0, P89_0127
    pl_SetVarFromValue PVAR_40B6, 2
    pl_ClearFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 10
    pl_SetVarFromValue PVAR_8004, 1
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_15_S15  // CallCommonScript 2014 (Pearl file 205 script 15)
    pl_SetVarFromValue PVAR_8004, 3
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_15_S15  // CallCommonScript 2014 (Pearl file 205 script 15)
    pl_SetVarFromValue PVAR_8004, 4
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_15_S15  // CallCommonScript 2014 (Pearl file 205 script 15)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0295:
    pl_CheckFlag PFLAG_0111
    pl_GoToIf 0, P89_00D7
    pl_CheckFlag PFLAG_0970
    pl_GoToIf 0, P89_0132
    pl_SetVarFromValue PVAR_40B6, 3
    pl_ClearFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 14
    pl_SetVarFromValue PVAR_8004, 33
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_14_S14  // CallCommonScript 2013 (Pearl file 205 script 14)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_02D3:
    pl_CheckFlag PFLAG_0111
    pl_GoToIf 0, P89_00E6
    pl_CheckFlag PFLAG_0971
    pl_GoToIf 0, P89_013D
    pl_SetVarFromValue PVAR_40B6, 4
    pl_ClearFlag PFLAG_0111
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 18
    pl_SetVarFromValue PVAR_8004, 11
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    pl_SetVarFromValue PVAR_8004, 9
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    pl_SetVarFromValue PVAR_8004, 17
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    pl_SetVarFromValue PVAR_8004, 113
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0341:
    pl_CheckFlag PFLAG_0111
    pl_GoToIf 0, P89_00F5
    pl_CheckFlag PFLAG_0972
    pl_GoToIf 0, P89_0148
    pl_SetVarFromValue PVAR_40B6, 5
    pl_ClearFlag PFLAG_0111
    pl_ClearFlag PFLAG_00FC
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 22
    pl_Call P89_0379
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0379:
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P89_039D
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P89_03AF
    pl_GoTo P89_03C1

P89_039D:
    pl_SetVarFromValue PVAR_8004, 101
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    pl_Return

P89_03AF:
    pl_SetVarFromValue PVAR_8004, 102
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    pl_Return

P89_03C1:
    pl_SetVarFromValue PVAR_8004, 103
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    pl_Return

P89_03D3:
    pl_CheckFlag PFLAG_0111
    pl_GoToIf 0, P89_0104
    pl_CheckFlag PFLAG_0973
    pl_GoToIf 0, P89_0153
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 1, P89_0574
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 0, P89_043D
    pl_SetVarFromValue PVAR_8004, 81
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P89_0565
    VMCall C205_47_S47  // CallCommonScript 2046 (Pearl file 205 script 47)
    pl_SetVarFromValue PVAR_40B6, 6
    pl_ClearFlag PFLAG_0111
    pl_ClearFlag PFLAG_00FC
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 28
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_043D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 27
    pl_Return

P89_0442:
    pl_stub GetCapturedFlagCount  // Pearl 0x24A Unk024A 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 0, P89_00A3
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 1, P89_0574
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 0, P89_049E
    pl_SetVarFromValue PVAR_8004, 82
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P89_0565
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetVarFromValue PVAR_40B6, 7
    pl_ClearFlag PFLAG_00FC
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_049E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 30
    pl_Return

P89_04A3:
    pl_stub GetCapturedFlagCount  // Pearl 0x24A Unk024A 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 10
    pl_GoToIf 0, P89_00A3
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 1, P89_0574
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 0, P89_04FF
    pl_SetVarFromValue PVAR_8004, 83
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P89_0565
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetVarFromValue PVAR_40B6, 8
    pl_ClearFlag PFLAG_00FC
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_04FF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 31
    pl_Return

P89_0504:
    pl_stub GetCapturedFlagCount  // Pearl 0x24A Unk024A 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 50
    pl_GoToIf 0, P89_00A3
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 1, P89_0574
    pl_CheckFlag PFLAG_00FC
    pl_CallIf 0, P89_0560
    pl_SetVarFromValue PVAR_8004, 84
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P89_0565
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetVarFromValue PVAR_40B6, 9
    pl_ClearFlag PFLAG_00FC
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0560:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 32
    pl_Return

P89_0565:
    pl_SetFlag PFLAG_00FC
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 34
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0574:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 35
    pl_Return

P89_0579:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 5
    pl_GoToIf 1, P89_05AC
    pl_CompareVarToValue PVAR_8004, 7
    pl_GoToIf 1, P89_05B8
    pl_CompareVarToValue PVAR_8005, 4
    pl_GoToIf 1, P89_05C4
    pl_GoTo P89_05D0

P89_05AC:
    pl_ApplyMovement 2, P89_05DC
    pl_WaitMovement
    pl_Return

P89_05B8:
    pl_ApplyMovement 2, P89_05F0
    pl_WaitMovement
    pl_Return

P89_05C4:
    pl_ApplyMovement 2, P89_0604
    pl_WaitMovement
    pl_Return

P89_05D0:
    pl_ApplyMovement 2, P89_0618
    pl_WaitMovement
    pl_Return

P89_S2:
P89_062C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 36
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_S3:
P89_063F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00BD
    pl_GoToIf 1, P89_0661
    pl_SetFlag PFLAG_00BD
    pl_msg_talk 37
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_0661:
    pl_msg_talk 38
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_S4:
P89_066C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 39
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P89_S5:
P89_067D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 40
    pl_GoTo P89_068E

P89_068E:
    pl_msg_sys 41
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 47, 65535, 0  // Pearl AddMenuEntryImm 180, 0
    ListMenuAdd 48, 65535, 1  // Pearl AddMenuEntryImm 181, 1
    ListMenuAdd 49, 65535, 2  // Pearl AddMenuEntryImm 182, 2
    ListMenuAdd 50, 65535, 3  // Pearl AddMenuEntryImm 183, 3
    ListMenuAdd 51, 65535, 4  // Pearl AddMenuEntryImm 184, 4
    ListMenuAdd 52, 65535, 5  // Pearl AddMenuEntryImm 12, 5
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P89_0702
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P89_070D
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P89_0718
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, P89_0723
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, P89_072E
    pl_GoTo P89_0739

P89_0702:
    pl_msg_sys 42
    pl_GoTo P89_068E

P89_070D:
    pl_msg_sys 43
    pl_GoTo P89_068E

P89_0718:
    pl_msg_sys 44
    pl_GoTo P89_068E

P89_0723:
    pl_msg_sys 45
    pl_GoTo P89_068E

P89_072E:
    pl_msg_sys 46
    pl_GoTo P89_068E

P89_0739:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P89_05DC:
    Move 8, 1  // WALK_SLOW_NORTH
    Move 9, 2  // WALK_SLOW_SOUTH
    Move 8, 1  // WALK_SLOW_NORTH
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    MoveEnd

    .balign 4, 0
P89_05F0:
    Move 8, 1  // WALK_SLOW_NORTH
    Move 9, 2  // WALK_SLOW_SOUTH
    Move 8, 1  // WALK_SLOW_NORTH
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P89_0604:
    Move 10, 1  // WALK_SLOW_WEST
    Move 11, 2  // WALK_SLOW_EAST
    Move 10, 1  // WALK_SLOW_WEST
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P89_0618:
    Move 10, 1  // WALK_SLOW_WEST
    Move 11, 2  // WALK_SLOW_EAST
    Move 10, 1  // WALK_SLOW_WEST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
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
    pl_msg_sys 53  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 54  // Pearl bank 199 line 28
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
    pl_msg_sys 55  // Pearl bank 199 line 25
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
    pl_msg_sys 56  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 57  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 58  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 59  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 60  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 61  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 62  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 63  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:15 (a subroutine here)
C205_15_S15:
C205_15_08DF:
    pl_Call C205_15_08E9
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_15_08E9:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_stub GiveSphere  // Pearl 0x08F GiveUndergroundSphere 32772, 32773, 32780: not translated yet
    pl_stub BufferUndergroundItemName  // Pearl 0x0E1 GetUndergroundItemName 0, 32772: not translated yet
    pl_BufferNumber 1, PVAR_8005
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 64  // Pearl bank 199 line 81
    pl_WaitFanfare
    pl_Return

// ---- Pearl global script 205:14 (a subroutine here)
C205_14_S14:
C205_14_08BD:
    pl_Call C205_14_08C7
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_14_08C7:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_stub GiveTrap  // Pearl 0x087 GiveUndergroundTrap 32772, 32773, 32780: not translated yet
    pl_stub BufferUndergroundTrapName  // Pearl 0x0E0 GetUndergroundTrapName 0, 32772: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 65  // Pearl bank 199 line 80
    pl_WaitFanfare
    pl_Return

// ---- Pearl global script 205:47 (a subroutine here)
C205_47_S47:
C205_47_0893:
    pl_Call C205_47_08A0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 66  // Pearl bank 199 line 128
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_47_08A0:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_stub SendGoodToPC  // Pearl 0x083 GiveSecretBaseDecoration 32772, 32773, 32780: not translated yet
    pl_stub GetDecorationNameWithArticle  // Pearl 0x2C6 GetDecorationNameWithArticle 0, 32772: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 67  // Pearl bank 199 line 108
    pl_stub BufferUndergroundGoodsName  // Pearl 0x0DF GetDecorationName 0, 32772: not translated yet
    pl_WaitFanfare
    pl_Return

// ---- Pearl global script 205:13 (a subroutine here)
C205_13_S13:
C205_13_0884:
    pl_Call C205_13_08A0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 68  // Pearl bank 199 line 109
    pl_WaitButton
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_13_08A0:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_stub SendGoodToPC  // Pearl 0x083 GiveSecretBaseDecoration 32772, 32773, 32780: not translated yet
    pl_stub GetDecorationNameWithArticle  // Pearl 0x2C6 GetDecorationNameWithArticle 0, 32772: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 67  // Pearl bank 199 line 108
    pl_stub BufferUndergroundGoodsName  // Pearl 0x0DF GetDecorationName 0, 32772: not translated yet
    pl_WaitFanfare
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
