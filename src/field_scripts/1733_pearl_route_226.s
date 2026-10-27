// MAP_ROUTE_226: Pearl script file 1047, text bank 583. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive; 54: Pearl 2800, 106: Pearl 10003
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1047_S1
    ScriptEntry P1047_S2
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
    ScriptEntry PearlProxy_10003
    ScriptEntriesEnd

P1047_S1:
P1047_000A:
    pl_sign 0, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P1047_S2:
P1047_0021:
    pl_sign 1, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

PearlProxy_2800:                  // Pearl global script 2800 (run by this zone's events)
    VMCall T378_1_S1
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
    pl_msg_talk 2  // Pearl bank 350 line 13
    pl_GoTo T378_1_01F2

T378_1_00A6:
    WordSetItemNameWithArticle 0, PVAR_8000
// CapitalizeFirstChar: nothing in Black 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3  // Pearl bank 350 line 31
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00B9:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_00DC
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4  // Pearl bank 350 line 14
    pl_GoTo T378_1_01F2

T378_1_00DC:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5  // Pearl bank 350 line 32
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_00EE:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0111
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6  // Pearl bank 350 line 15
    pl_GoTo T378_1_01F2

T378_1_0111:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7  // Pearl bank 350 line 33
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_0123:
    pl_Call T378_1_0158
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0146
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 8  // Pearl bank 350 line 16
    pl_GoTo T378_1_01F2

T378_1_0146:
    pl_stub BufferBerryName  // Pearl 0x17B GetBerryName 0, 32768, 32769: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 9  // Pearl bank 350 line 34
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
    pl_msg_talk 10  // Pearl bank 350 line 17
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T378_1_053A
    pl_CloseMessage
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 0: not translated yet
    pl_msg_talk 11  // Pearl bank 350 line 20
    pl_WaitButton
    pl_stub SetBerryWateringState  // Pearl 0x184 Unk0184 1: not translated yet
    pl_GoTo T378_1_053A

T378_1_021B:
    pl_BufferNumber 1, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 2, T378_1_023B
    WordSetItemNameWithArticle 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12  // Pearl bank 350 line 35
    pl_GoTo T378_1_0243

T378_1_023B:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13  // Pearl bank 350 line 21

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
    pl_msg_talk 14  // Pearl bank 350 line 37
    pl_GoTo T378_1_0291

T378_1_0289:
    pl_BufferItemName 0, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 15  // Pearl bank 350 line 25

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
    pl_msg_talk 16  // Pearl bank 350 line 27
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
    pl_msg_talk 17  // Pearl bank 350 line 26
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
    pl_msg_talk 18  // Pearl bank 350 line 36
    pl_GoTo T378_1_0336

T378_1_032E:
    pl_BufferItemName 1, PVAR_8000  // GetItemNamePlural
    pl_msg_talk 19  // Pearl bank 350 line 24

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
    pl_msg_talk 20  // Pearl bank 350 line 1
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
    pl_msg_talk 21  // Pearl bank 350 line 0
    pl_GoTo T378_1_04DA

T378_1_03B4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 21  // Pearl bank 350 line 0
    pl_stub CheckPocketHasItems  // Pearl 0x17A CheckPocketNotEmpty 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T378_1_0413
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 22, 65535, 0  // Pearl AddMenuEntryImm 2, 0
    ListMenuAdd 23, 65535, 1  // Pearl AddMenuEntryImm 3, 1
    ListMenuAdd 24, 65535, 2  // Pearl AddMenuEntryImm 4, 2
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
    pl_msg_talk 25  // Pearl bank 350 line 5
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
    pl_msg_talk 26  // Pearl bank 350 line 11
    pl_GoTo T378_1_04DA

T378_1_04CA:
    pl_BufferItemName 0, PVAR_8005
    pl_msg_talk 27  // Pearl bank 350 line 30
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_04DA:
    pl_msg_talk 28  // Pearl bank 350 line 8
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
    pl_msg_talk 29  // Pearl bank 350 line 12
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
    pl_msg_talk 30  // Pearl bank 350 line 28
    pl_WaitButton
    pl_GoTo T378_1_053A

T378_1_054B:
    pl_stub GetBerryMulchType  // Pearl 0x17F GetBerryTreeMulch 32780: not translated yet
    pl_BufferItemName 0, PVAR_800C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 31  // Pearl bank 350 line 29
    pl_WaitButton
    pl_GoTo T378_1_053A

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
    pl_msg_sys 32  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 35  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 18 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 678
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 324
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (678, 324) to (678, 329)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 678
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 329
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (678, 329) to (678, 324)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    WorkCmpConst PL_TMP, 690
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP2, 330
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc2_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc2  // from (690, 330) to (690, 335)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc2_next:
    WorkCmpConst PL_TMP, 690
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP2, 335
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc3_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc3  // from (690, 335) to (690, 330)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc3_next:
    WorkCmpConst PL_TMP, 705
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP2, 331
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc4_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc4  // from (705, 331) to (705, 340)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc4_next:
    WorkCmpConst PL_TMP, 705
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP2, 340
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc5_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc5  // from (705, 340) to (705, 331)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc5_next:
    WorkCmpConst PL_TMP, 709
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP2, 331
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc6_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc6  // from (709, 331) to (709, 338)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc6_next:
    WorkCmpConst PL_TMP, 709
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP2, 338
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc7_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc7  // from (709, 338) to (709, 331)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc7_next:
    WorkCmpConst PL_TMP, 700
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP2, 333
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc8_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc8  // from (700, 333) to (700, 339)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc8_next:
    WorkCmpConst PL_TMP, 700
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP2, 339
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc9_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc9  // from (700, 339) to (700, 333)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc9_next:
    WorkCmpConst PL_TMP, 721
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP2, 335
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc10_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc10  // from (721, 335) to (721, 338)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc10_next:
    WorkCmpConst PL_TMP, 721
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP2, 338
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc11_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc11  // from (721, 338) to (721, 335)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc11_next:
    WorkCmpConst PL_TMP, 686
    VMJumpIf CMP_NE, C375_4_03B3_rc12_next
    WorkCmpConst PL_TMP2, 336
    VMJumpIf CMP_NE, C375_4_03B3_rc12_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc12_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc12  // from (686, 336) to (686, 342)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc12_next:
    WorkCmpConst PL_TMP, 686
    VMJumpIf CMP_NE, C375_4_03B3_rc13_next
    WorkCmpConst PL_TMP2, 342
    VMJumpIf CMP_NE, C375_4_03B3_rc13_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc13_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc13  // from (686, 342) to (686, 336)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc13_next:
    WorkCmpConst PL_TMP, 690
    VMJumpIf CMP_NE, C375_4_03B3_rc14_next
    WorkCmpConst PL_TMP2, 336
    VMJumpIf CMP_NE, C375_4_03B3_rc14_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc14_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc14  // from (690, 336) to (690, 340)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc14_next:
    WorkCmpConst PL_TMP, 690
    VMJumpIf CMP_NE, C375_4_03B3_rc15_next
    WorkCmpConst PL_TMP2, 340
    VMJumpIf CMP_NE, C375_4_03B3_rc15_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc15_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc15  // from (690, 340) to (690, 336)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc15_next:
    WorkCmpConst PL_TMP, 700
    VMJumpIf CMP_NE, C375_4_03B3_rc16_next
    WorkCmpConst PL_TMP2, 341
    VMJumpIf CMP_NE, C375_4_03B3_rc16_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc16_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc16  // from (700, 341) to (700, 344)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc16_next:
    WorkCmpConst PL_TMP, 700
    VMJumpIf CMP_NE, C375_4_03B3_rc17_next
    WorkCmpConst PL_TMP2, 344
    VMJumpIf CMP_NE, C375_4_03B3_rc17_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc17_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc17  // from (700, 344) to (700, 341)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc17_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc2:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc3:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc4:
        Move 53, 1
        Move 17, 7
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc5:
        Move 52, 1
        Move 16, 7
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc6:
        Move 53, 1
        Move 17, 5
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc7:
        Move 52, 1
        Move 16, 5
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc8:
        Move 53, 1
        Move 17, 4
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc9:
        Move 52, 1
        Move 16, 4
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc10:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc11:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc12:
        Move 53, 1
        Move 17, 4
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc13:
        Move 52, 1
        Move 16, 4
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc14:
        Move 53, 1
        Move 17, 2
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc15:
        Move 52, 1
        Move 16, 2
        Move 52, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc16:
        Move 53, 1
        Move 17, 1
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc17:
        Move 52, 1
        Move 16, 1
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 469  // GetCurrentMapID: Pearl map 469
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
