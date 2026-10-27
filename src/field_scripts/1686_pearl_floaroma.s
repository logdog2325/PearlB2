// MAP_FLOAROMA: Pearl script file 994, text bank 513. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-11: Pearl's; no warp continuations; 12: PearlArrive; 54: Pearl 2800
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P994_S1
    ScriptEntry P994_S2
    ScriptEntry P994_S3
    ScriptEntry P994_S4
    ScriptEntry P994_S5
    ScriptEntry P994_S6
    ScriptEntry P994_S7
    ScriptEntry P994_S8
    ScriptEntry P994_S9
    ScriptEntry P994_S10
    ScriptEntry P994_S11
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
    ScriptEntry PearlProxy_2800
    ScriptEntriesEnd

P994_S1:
P994_002E:
    pl_End

P994_S2:
P994_0030:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 170
    pl_GoToIf 1, P994_0061
    pl_CompareVarToValue PVAR_8004, 171
    pl_GoToIf 1, P994_0071
    pl_CompareVarToValue PVAR_8004, 172
    pl_GoToIf 1, P994_0081
    pl_End

P994_0061:
    pl_ApplyMovement 3, P994_0108
    pl_WaitMovement
    pl_GoTo P994_0091

P994_0071:
    pl_ApplyMovement 3, P994_0118
    pl_WaitMovement
    pl_GoTo P994_0091

P994_0081:
    pl_ApplyMovement 3, P994_0120
    pl_WaitMovement
    pl_GoTo P994_0091

P994_0091:
    pl_msg_sys 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 170
    pl_GoToIf 1, P994_00C8
    pl_CompareVarToValue PVAR_8004, 171
    pl_GoToIf 1, P994_00D8
    pl_CompareVarToValue PVAR_8004, 172
    pl_GoToIf 1, P994_00E8
    pl_End

P994_00C8:
    pl_ApplyMovement 3, P994_0130
    pl_WaitMovement
    pl_GoTo P994_00F8

P994_00D8:
    pl_ApplyMovement 3, P994_0138
    pl_WaitMovement
    pl_GoTo P994_00F8

P994_00E8:
    pl_ApplyMovement 3, P994_0140
    pl_WaitMovement
    pl_GoTo P994_00F8

P994_00F8:
    pl_RemoveObject 3, PFLAG_01C1
    pl_SetVarFromValue PVAR_4072, 1
    pl_ReleaseAll
    pl_End

P994_S3:
P994_0148:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_ApplyMovement 7, P994_0174
    pl_WaitMovement
    pl_msg_actor 5, 7
    pl_CloseMessage
    pl_ApplyMovement 8, P994_017C
    pl_WaitMovement
    pl_msg_actor 6, 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P994_S4:
P994_0184:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40CF, 2
    pl_GoToIf 4, P994_01B1
    pl_msg_talk 7
    pl_ApplyMovement 2, P994_01BC
    pl_WaitMovement
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P994_01B1:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P994_S5:
P994_01C8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P994_S6:
P994_01DB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P994_S7:
P994_01EE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P994_S8:
P994_0201:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P994_S9:
P994_0214:
    pl_sign 14, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P994_S10:
P994_022B:
    pl_sign 15, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P994_S11:
P994_0242:
    pl_sign 16, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P994_0108:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P994_0118:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P994_0120:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P994_0130:
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P994_0138:
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P994_0140:
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P994_0174:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P994_017C:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P994_01BC:
    Move 0, 1  // FACE_NORTH
    Move 63, 3  // DELAY_8
    MoveEnd

PearlProxy_2800:                  // Pearl global script 2800 (run by this zone's events)
    VMCall T378_1_S1
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
    pl_msg_talk 17  // Pearl bank 350 line 13
    pl_GoTo T378_1_01F2

T378_1_00A6:
    WordSetItemNameWithArticle 0, PVAR_8000
// CapitalizeFirstChar: nothing in Black 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 18  // Pearl bank 350 line 31
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00B9:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_00DC
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 19  // Pearl bank 350 line 14
    pl_GoTo T378_1_01F2

T378_1_00DC:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20  // Pearl bank 350 line 32
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00EE:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0111
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 21  // Pearl bank 350 line 15
    pl_GoTo T378_1_01F2

T378_1_0111:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 22  // Pearl bank 350 line 33
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_0123:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0146
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 23  // Pearl bank 350 line 16
    pl_GoTo T378_1_01F2

T378_1_0146:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 24  // Pearl bank 350 line 34
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
    pl_msg_talk 25  // Pearl bank 350 line 17
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_053A
    pl_CloseMessage
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 0: not translated yet
    pl_msg_talk 26  // Pearl bank 350 line 20
    pl_WaitButton
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 1: not translated yet
    pl_GoTo T378_1_053A

T378_1_021B:
    pl_BufferNumber 1, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_023B
    WordSetItemNameWithArticle 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 27  // Pearl bank 350 line 35
    pl_GoTo T378_1_0243

T378_1_023B:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 28  // Pearl bank 350 line 21

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
    pl_msg_talk 29  // Pearl bank 350 line 37
    pl_GoTo T378_1_0291

T378_1_0289:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 30  // Pearl bank 350 line 25

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
    pl_msg_talk 31  // Pearl bank 350 line 27
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
    pl_msg_talk 32  // Pearl bank 350 line 26
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
    pl_msg_talk 33  // Pearl bank 350 line 36
    pl_GoTo T378_1_0336

T378_1_032E:
    pl_BufferItemName 1, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 34  // Pearl bank 350 line 24

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
    pl_msg_talk 35  // Pearl bank 350 line 1
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
    pl_msg_talk 36  // Pearl bank 350 line 0
    pl_GoTo T378_1_04DA

T378_1_03B4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 36  // Pearl bank 350 line 0
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0413
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 37, 65535, 0  // Pearl AddMenuEntryImm 2, 0
    ListMenuAdd 38, 65535, 1  // Pearl AddMenuEntryImm 3, 1
    ListMenuAdd 39, 65535, 2  // Pearl AddMenuEntryImm 4, 2
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
    pl_msg_talk 40  // Pearl bank 350 line 5
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
    pl_msg_talk 41  // Pearl bank 350 line 11
    pl_GoTo T378_1_04DA

T378_1_04CA:
    pl_BufferItemName 0, PVAR_8005
    pl_msg_talk 42  // Pearl bank 350 line 30
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_04DA:
    pl_msg_talk 43  // Pearl bank 350 line 8
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
    pl_msg_talk 44  // Pearl bank 350 line 12
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
    pl_msg_talk 45  // Pearl bank 350 line 28
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_054B:
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_BufferItemName 0, PVAR_800C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 46  // Pearl bank 350 line 29
    pl_WaitButton
    pl_GoTo T378_1_053A

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
