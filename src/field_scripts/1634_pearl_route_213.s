// MAP_ROUTE_213: Pearl script file 424, text bank 444. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-8: Pearl's; no warp continuations; 9: PearlArrive; 54: Pearl 2800, 93: Pearl 10001, 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P424_S1
    ScriptEntry P424_S2
    ScriptEntry P424_S3
    ScriptEntry P424_S4
    ScriptEntry P424_S5
    ScriptEntry P424_S6
    ScriptEntry P424_S7
    ScriptEntry P424_S8
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
    ScriptEntry PearlProxy_2800
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
    ScriptEntry PearlProxy_10001
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
    ScriptEntry PearlProxy_10003
    ScriptEntriesEnd

P424_S1:
P424_0022:
    pl_CheckFlag PFLAG_0104
    pl_GoToIf 0, P424_002F
    pl_End

P424_002F:
    pl_CheckBadgeAcquired 3, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P424_0044
    pl_End

P424_0044:
    pl_CheckFlag PFLAG_0103
    pl_GoToIf 1, P424_0051
    pl_End

P424_0051:
    pl_ClearFlag PFLAG_0238
    pl_End

P424_S2:
P424_0057:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 0
    pl_CloseMessage
    pl_FacePlayer
    pl_ApplyMovement 30, P424_00C4
    pl_WaitMovement
    pl_msg_talk 1
    pl_CloseMessage
    pl_GetPlayerDir PVAR_8004
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P424_0093
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P424_00A3
    pl_End

P424_0093:
    pl_ApplyMovement 30, P424_00CC
    pl_WaitMovement
    pl_GoTo P424_00B3

P424_00A3:
    pl_ApplyMovement 30, P424_00DC
    pl_WaitMovement
    pl_GoTo P424_00B3

P424_00B3:
    pl_RemoveObject 30, PFLAG_0238
    pl_SetFlag PFLAG_0104
    pl_ClearFlag PFLAG_0239
    pl_ReleaseAll
    pl_End

P424_S4:
P424_00E8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P424_S5:
P424_00FB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P424_S3:
P424_010E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P424_S6:
P424_0121:
    pl_sign 5, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P424_S7:
P424_0138:
    pl_sign 6, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P424_S8:
P424_014F:
    pl_sign 7, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P424_00C4:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P424_00CC:
    Move 18, 1  // WALK_FAST_WEST
    Move 16, 2  // WALK_FAST_NORTH
    Move 19, 10  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P424_00DC:
    Move 16, 2  // WALK_FAST_NORTH
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

PearlProxy_2800:                  // Pearl global script 2800 (run by this zone's events)
    VMCall T378_1_S1
    VMHalt

PearlProxy_10001:                  // Pearl global script 10001 (run by this zone's events)
    VMCall T375_2_S2
    VMHalt

PearlProxy_10003:                  // Pearl global script 10003 (run by this zone's events)
    VMCall C375_4_S4
    VMHalt

// ---- Pearl global script 378:1 (a subroutine here)
T378_1_S1:
T378_1_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub GetBerryItemID  // Pearl 0x17E GetBerryTreeType 32768: not translated yet
    pl_stub GetBerryYield  // Pearl 0x181 GetBerryTreeAmount 32769: not translated yet
    pl_stub GetBerryGrowthStage  // Pearl 0x17D GetBerryTreeGrowth 32780: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T378_1_033E
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T378_1_0082
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T378_1_00B9
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T378_1_00EE
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, T378_1_0123
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, T378_1_021B
    pl_GoTo T378_1_033E

T378_1_0082:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_00A6
    WordSetItemNameWithArticle 0, PVAR_8000
// CapitalizeFirstChar: nothing in Black 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 8  // Pearl bank 350 line 13
    pl_GoTo T378_1_01F2

T378_1_00A6:
    WordSetItemNameWithArticle 0, PVAR_8000
// CapitalizeFirstChar: nothing in Black 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 9  // Pearl bank 350 line 31
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00B9:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_00DC
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 10  // Pearl bank 350 line 14
    pl_GoTo T378_1_01F2

T378_1_00DC:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 11  // Pearl bank 350 line 32
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00EE:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0111
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12  // Pearl bank 350 line 15
    pl_GoTo T378_1_01F2

T378_1_0111:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13  // Pearl bank 350 line 33
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_0123:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0146
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 14  // Pearl bank 350 line 16
    pl_GoTo T378_1_01F2

T378_1_0146:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15  // Pearl bank 350 line 34
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_0158:
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, T378_1_0186
    pl_CheckItem 448, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0186
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

T378_1_0186:
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

T378_1_018E:
    pl_CheckItem 95, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_CheckItem 96, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_CheckItem 97, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_CheckItem 98, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_01EA
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

T378_1_01EA:
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

T378_1_01F2:
    pl_msg_talk 16  // Pearl bank 350 line 17
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_053A
    pl_CloseMessage
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 0: not translated yet
    pl_msg_talk 17  // Pearl bank 350 line 20
    pl_WaitButton
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 1: not translated yet
    pl_GoTo T378_1_053A

T378_1_021B:
    pl_BufferNumber 1, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_023B
    WordSetItemNameWithArticle 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 18  // Pearl bank 350 line 35
    pl_GoTo T378_1_0243

T378_1_023B:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 19  // Pearl bank 350 line 21

T378_1_0243:
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_02F7
    pl_CanFitItem PVAR_8000, PVAR_8001, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_02CF
    pl_BufferNumber 1, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_0289
    pl_BufferItemName 0, PVAR_8000
    pl_msg_talk 20  // Pearl bank 350 line 37
    pl_GoTo T378_1_0291

T378_1_0289:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 21  // Pearl bank 350 line 25

T378_1_0291:
    pl_PlayFanfare SEQ_ME_KINOMI  // Pearl SEQ_KINOMI
    pl_WaitFanfare
    pl_stub HarvestBerry  // Pearl 0x185 TakeBerryTreeBerries : not translated yet
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_02B4
    pl_BufferItemName 1, PVAR_8000
    pl_GoTo T378_1_02B9

T378_1_02B4:
    pl_BufferItemName 1, PVAR_8000  // GetItemNamePlural

T378_1_02B9:
    pl_GetItemPocket PVAR_8000, PVAR_800C
    pl_BufferPocketName 3, PVAR_800C
    pl_msg_talk 22  // Pearl bank 350 line 27
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_02CF:
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_02E7
    pl_BufferItemName 0, PVAR_8000
    pl_GoTo T378_1_02EC

T378_1_02E7:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural

T378_1_02EC:
    pl_msg_talk 23  // Pearl bank 350 line 26
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_02F7:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0310
    pl_GoTo T378_1_01F2

T378_1_0310:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_032E
    pl_BufferItemName 1, PVAR_8000
    pl_msg_talk 24  // Pearl bank 350 line 36
    pl_GoTo T378_1_0336

T378_1_032E:
    pl_BufferItemName 1, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 25  // Pearl bank 350 line 24

T378_1_0336:
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_033E:
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0374
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_054B
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_BufferItemName 0, PVAR_800C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 26  // Pearl bank 350 line 1
    pl_GoTo T378_1_04DA

T378_1_0374:
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, T378_1_0540
    pl_Call T378_1_018E
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_03B4
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0540
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 27  // Pearl bank 350 line 0
    pl_GoTo T378_1_04DA

T378_1_03B4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 27  // Pearl bank 350 line 0
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0413
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 28, 65535, 0  // Pearl AddMenuEntryImm 2, 0
    ListMenuAdd 29, 65535, 1  // Pearl AddMenuEntryImm 3, 1
    ListMenuAdd 30, 65535, 2  // Pearl AddMenuEntryImm 4, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T378_1_042D
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T378_1_04EE
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T378_1_053A
    pl_GoTo T378_1_053A

T378_1_0413:
    pl_msg_talk 31  // Pearl bank 350 line 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_042D
    pl_GoTo T378_1_053A

T378_1_042D:
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenBag  // Pearl 0x178 ShowBagScreen 0: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_stub GetSelectedItem  // Pearl 0x179 GetBagScreenSelection 32773: not translated yet
    pl_SetVarFromVar PVAR_8008, PVAR_8005
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T378_1_053C
    pl_CompareVarToValue PVAR_8008, 95
    pl_GoToIf 1, T378_1_049D
    pl_CompareVarToValue PVAR_8008, 96
    pl_GoToIf 1, T378_1_049D
    pl_CompareVarToValue PVAR_8008, 97
    pl_GoToIf 1, T378_1_049D
    pl_CompareVarToValue PVAR_8008, 98
    pl_GoToIf 1, T378_1_049D
    pl_GoTo T378_1_053C

T378_1_049D:
    pl_RemoveItem PVAR_8005, 1, PVAR_8004
    pl_stub SetBerryMulch  // Pearl 0x182 SetBerryTreeMulch 32773: not translated yet
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_04CA
    pl_BufferItemName 0, PVAR_8005
    pl_msg_talk 32  // Pearl bank 350 line 11
    pl_GoTo T378_1_04DA

T378_1_04CA:
    pl_BufferItemName 0, PVAR_8005
    pl_msg_talk 33  // Pearl bank 350 line 30
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_04DA:
    pl_msg_talk 34  // Pearl bank 350 line 8
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_053A

T378_1_04EE:
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenBag  // Pearl 0x178 ShowBagScreen 1: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_stub GetSelectedItem  // Pearl 0x179 GetBagScreenSelection 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_053C
    pl_BufferItemName 0, PVAR_800C
    pl_msg_talk 35  // Pearl bank 350 line 12
    pl_WaitButton
    pl_RemoveItem PVAR_800C, 1, PVAR_8004
    pl_stub PlantBerry  // Pearl 0x183 SetBerryTreeType 32780: not translated yet
    pl_GoTo T378_1_053A

T378_1_053A:
    pl_CloseMessage

T378_1_053C:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T378_1_0540:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 36  // Pearl bank 350 line 28
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_054B:
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_BufferItemName 0, PVAR_800C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 37  // Pearl bank 350 line 29
    pl_WaitButton
    pl_GoTo T378_1_053A

// ---- Pearl global script 375:2 (a subroutine here)
T375_2_S2:
T375_2_0139:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    PokePartyHasMoveAny PVAR_800C, 249  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_2_018B
    pl_CheckBadgeAcquired 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_018B
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 38  // Pearl bank 334 line 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_019A
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_018B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 39  // Pearl bank 334 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_019A:
    pl_BufferPartyMonNickname 0, PVAR_8004
    pl_msg_talk 40  // Pearl bank 334 line 5
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 1: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 373  // GetCurrentMapID: Pearl map 373
// CreateJournalEvent 24, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)

T375_2_01C8:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, T375_2_01C8
    pl_GoTo T375_2_055B

T375_2_055B:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 375:4 (a subroutine here)
C375_4_S4:
C375_4_0324:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, C375_4_037F
    pl_CheckBadgeAcquired 6, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_037F
    FlagGet PL_FOLLOW_FLAG, PVAR_800C  // CheckHasPartner: 1 while a partner follows
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C375_4_038E
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 42  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 43  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 44  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 12 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 721
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 799
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (721, 799) to (721, 802)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 721
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 801
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (721, 801) to (721, 798)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    WorkCmpConst PL_TMP, 715
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP2, 800
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc2  // from (715, 800) to (715, 803)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc2_next:
    WorkCmpConst PL_TMP, 715
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP2, 803
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc3  // from (715, 803) to (715, 800)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc3_next:
    WorkCmpConst PL_TMP, 717
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP2, 803
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP3, 3
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc4  // from (717, 803) to (720, 803)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc4_next:
    WorkCmpConst PL_TMP, 720
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP2, 803
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP3, 2
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc5  // from (720, 803) to (717, 803)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc5_next:
    WorkCmpConst PL_TMP, 722
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP2, 803
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc6  // from (722, 803) to (722, 806)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc6_next:
    WorkCmpConst PL_TMP, 722
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP2, 806
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc7  // from (722, 806) to (722, 803)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc7_next:
    WorkCmpConst PL_TMP, 716
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP2, 806
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc8  // from (716, 806) to (716, 809)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc8_next:
    WorkCmpConst PL_TMP, 716
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP2, 809
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc9  // from (716, 809) to (716, 806)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc9_next:
    WorkCmpConst PL_TMP, 677
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP2, 820
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP3, 3
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc10  // from (677, 820) to (683, 820)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc10_next:
    WorkCmpConst PL_TMP, 683
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP2, 820
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP3, 2
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc11  // from (683, 820) to (677, 820)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc11_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc2:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc3:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc4:
        Move 55, 1
        Move 19, 1
        Move 55, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc5:
        Move 54, 1
        Move 18, 1
        Move 54, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc6:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc7:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc8:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc9:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc10:
        Move 55, 1
        Move 19, 4
        Move 55, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc11:
        Move 54, 1
        Move 18, 4
        Move 54, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 373  // GetCurrentMapID: Pearl map 373
// CreateJournalEvent 26, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo C375_4_055F

C375_4_055F:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
