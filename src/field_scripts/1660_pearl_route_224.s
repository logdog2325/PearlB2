// MAP_ROUTE_224: Pearl script file 450, text bank 470. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; 5: after a Warp; 6: PearlArrive; 54: Pearl 2800
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P450_S1
    ScriptEntry P450_S2
    ScriptEntry P450_S3
    ScriptEntry P450_S4
    ScriptEntry W450_0163_S
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
    ScriptEntry PearlProxy_2800
    ScriptEntriesEnd

P450_S1:
P450_0012:
    pl_CheckFlag PFLAG_012D
    pl_GoToIf 1, P450_006B
    FlagGet 2400, PVAR_4000  // CheckGameCompleted: Black 2's game clear (Pearl 0x964 = 2400 here)
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P450_006B
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P450_006B
    pl_CheckItem 452, 1, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P450_006B
    pl_CheckDistributionEvent 1, PVAR_4000  // CheckDistributionEvent 1: its item came from the deliveryman
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P450_006B
    pl_ClearFlag PFLAG_0270

P450_006B:
    pl_End

P450_S2:
P450_006D:
    pl_CheckFlag PFLAG_012D
    pl_GoToIf 1, P450_0085
    pl_CompareVarToValue PVAR_408D, 1
    pl_CallIf 1, P450_0087

P450_0085:
    pl_End

P450_0087:
// SetEventDirection 3, 0 in a map script: Black 2 moves no actor there (left out)
    pl_Return

P450_S3:
P450_008F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_012D
    pl_GoToIf 1, P450_00AD
    pl_msg_sys 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P450_00AD:
    pl_BufferPlayerName 1  // BufferTabletName: no kept inscription in Black 2 (the player's name)
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P450_S4:
P450_00BB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_012D
    pl_GoToIf 1, P450_01B8
    pl_SetVarFromValue PVAR_408D, 1
    pl_BufferPlayerName 0
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P450_01A4
    pl_msg_talk 0

P450_00EB:
    pl_CloseMessage
    pl_Call P450_01CB
    pl_BufferPlayerName 0
    pl_msg_talk 2
    pl_CloseMessage

P450_00FB:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_OpenShayminTabletNamingScreen PVAR_800C  // WriteWhiteRockInscription
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P450_01AD
    pl_BufferPlayerName 0
// BufferTabletName 1: the typed name is in word buffer 1 already
    pl_msg_talk 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P450_00FB
    pl_Call P450_0225
    pl_WaitTime 15, PVAR_800C
    pl_FadeOutBGM 10  // FadeOutBGM to volume 0
    pl_fade_out_white  // FadeScreen 6, 6, 0, 0x7fff
    pl_WaitFadeScreen
    pl_SetHiddenLocation 3  // SetHiddenLocation 3: Black 2's map replacement
    RTReserveScript 5  // the rest of this Pearl script runs there (continuation 5)
    pl_Warp 108, 908, 492, 0  // Pearl map 399 (MAP_ROUTE_224)
    pl_ReleaseAll
    pl_End

P450_01A4:
    pl_msg_talk 1
    pl_GoTo P450_00EB

P450_01AD:
    pl_msg_talk 5
    pl_CloseMessage
    pl_GoTo P450_00FB

P450_01B8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P450_01CB:
    pl_GetPlayerMapPos PVAR_8000, PVAR_8001
    pl_SetVarFromVar PVAR_8008, PVAR_8000
    pl_CompareVarToValue PVAR_8008, 909
    pl_GoToIf 1, P450_01FD
    pl_CompareVarToValue PVAR_8008, 910
    pl_GoToIf 1, P450_0211
    pl_ApplyMovement PL_PLAYER, P450_029C
    pl_WaitMovement
    pl_Return

P450_01FD:
    pl_ApplyMovement PL_PLAYER, P450_02AC
    pl_ApplyMovement 3, P450_02D8
    pl_WaitMovement
    pl_Return

P450_0211:
    pl_ApplyMovement PL_PLAYER, P450_02C0
    pl_ApplyMovement 3, P450_02E4
    pl_WaitMovement
    pl_Return

P450_0225:
    pl_ApplyMovement PL_PLAYER, P450_02F8
    pl_ApplyMovement 3, P450_02F8
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P450_029C:
    Move 0, 1  // FACE_NORTH
    Move 65, 1  // DELAY_16
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P450_02AC:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 65, 1  // DELAY_16
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P450_02C0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 65, 1  // DELAY_16
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P450_02D8:
    Move 63, 1  // DELAY_8
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P450_02E4:
    Move 63, 1  // DELAY_8
    Move 1, 1  // FACE_SOUTH
    Move 63, 2  // DELAY_8
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P450_02F8:
    Move 0, 1  // FACE_NORTH
    MoveEnd

// ---- continuation 5: after the Warp at 450:0163 (MAP_ROUTE_224)
W450_0163_S:
W450_0163_016F:
    pl_WaitTime 15, PVAR_800C
    pl_fade_in_white  // FadeScreen 6, 6, 1, 0x7fff
    pl_WaitFadeScreen
    pl_Call W450_0163_0239
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4  // Pearl bank 470 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_PlayDefaultMusic  // FadeInBGM 10: the zone's music again
    pl_SetFlag PFLAG_012D
    pl_SetFlag PFLAG_0270
    pl_SetVarFromValue PVAR_408D, 0
    pl_ReleaseAll
    pl_End

W450_0163_0239:
    pl_ApplyMovement 3, W450_0163_0378
    pl_ApplyMovement PL_PLAYER, W450_0163_033C
    pl_ApplyMovement 16, W450_0163_03A4
    pl_WaitMovement
    pl_PlayCry 492
    pl_WaitCry
    pl_ApplyMovement 3, W450_0163_0300
    pl_ApplyMovement 16, W450_0163_0324
    pl_ApplyMovement PL_PLAYER, W450_0163_0310
    pl_WaitMovement
    pl_ApplyMovement 16, W450_0163_03AC
    pl_WaitMovement
    pl_SetFlag PFLAG_027A
    pl_RemoveObject 16, PFLAG_027A
    pl_PlayCry 492
    pl_WaitCry
    pl_ApplyMovement 3, W450_0163_0334
    pl_WaitMovement
    pl_Return

    .balign 4, 0
W450_0163_0300:
    Move 3, 1  // FACE_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
W450_0163_0310:
    Move 65, 1  // DELAY_16
    Move 3, 1  // FACE_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
W450_0163_0324:
    Move 2, 1  // FACE_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
W450_0163_0334:
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
W450_0163_033C:
    Move 2, 1  // FACE_WEST
    Move 65, 1  // DELAY_16
    Move 1, 1  // FACE_SOUTH
    Move 65, 1  // DELAY_16
    Move 3, 1  // FACE_EAST
    Move 65, 1  // DELAY_16
    Move 1, 1  // FACE_SOUTH
    Move 65, 1  // DELAY_16
    Move 2, 1  // FACE_WEST
    Move 65, 1  // DELAY_16
    Move 0, 1  // FACE_NORTH
    Move 65, 1  // DELAY_16
    Move 1, 1  // FACE_SOUTH
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
W450_0163_0378:
    Move 1, 1  // FACE_SOUTH
    Move 65, 1  // DELAY_16
    Move 3, 1  // FACE_EAST
    Move 65, 1  // DELAY_16
    Move 1, 1  // FACE_SOUTH
    Move 65, 1  // DELAY_16
    Move 2, 1  // FACE_WEST
    Move 65, 1  // DELAY_16
    Move 0, 1  // FACE_NORTH
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
W450_0163_03A4:
    Move 13, 12  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W450_0163_03AC:
    Move 0, 1  // FACE_NORTH
    Move 65, 1  // DELAY_16
    Move 76, 12  // WALK_SLIGHTLY_FAST_NORTH
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

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
