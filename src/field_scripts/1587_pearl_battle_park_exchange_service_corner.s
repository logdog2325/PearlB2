// MAP_BATTLE_PARK_EXCHANGE_SERVICE_CORNER: Pearl script file 356, text bank 282. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-9: Pearl's; no warp continuations; 10: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P356_S1
    ScriptEntry P356_S2
    ScriptEntry P356_S3
    ScriptEntry P356_S4
    ScriptEntry P356_S5
    ScriptEntry P356_S6
    ScriptEntry P356_S7
    ScriptEntry P356_S8
    ScriptEntry P356_S9
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P356_S1:
P356_0024:
    pl_SetVarFromValue PVAR_4000, 0
    pl_SetVarFromValue PVAR_4001, 26
    pl_GoTo P356_0048

P356_S2:
P356_0036:
    pl_SetVarFromValue PVAR_4000, 1
    pl_SetVarFromValue PVAR_4001, 15
    pl_GoTo P356_0048

P356_0048:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub ShowBattlePoints  // Pearl 0x294 Unk0294 21, 1: not translated yet
    pl_msg_talk 0

P356_0057:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_Call P356_0131
    pl_CompareVarToValue PVAR_800C, 65534
    pl_GoToIf 1, P356_00F4
    pl_CompareVarToVar PVAR_800C, PVAR_4001
    pl_GoToIf 1, P356_00F4
    pl_SetVarFromVar PVAR_4003, PVAR_800C
    pl_stub GetExchangeServiceCornerItemAndCost  // Pearl 0x29B Unk029B 16384, 16387, 32768, 32769: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_CallIf 1, P356_0101
    pl_CompareVarToValue PVAR_4000, 1
    pl_CallIf 1, P356_010B
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P356_0057
    pl_stub CheckBattlePoints  // Pearl 0x29A Unk029A 32769, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P356_011A
    pl_CanFitItem PVAR_8000, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P356_0123
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_AddItem PVAR_8000, 1, PVAR_800C
    pl_stub RemoveBattlePoints  // Pearl 0x299 Unk0299 32769: not translated yet
    pl_stub UpdateBPDisplay  // Pearl 0x296 Unk0296 : not translated yet
    pl_GoTo P356_0057

P356_00F4:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_stub HideBattlePoints  // Pearl 0x295 Unk0295 : not translated yet
    pl_ReleaseAll
    pl_End

P356_0101:
    pl_BufferItemName 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_Return

P356_010B:
    pl_BufferItemName 0, PVAR_8000
    pl_BufferTMHMMoveName 1, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7
    pl_Return

P356_011A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_GoTo P356_0057

P356_0123:
    pl_BufferItemName 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_GoTo P356_0057

P356_0131:
    pl_SetVarFromValue PVAR_8008, 0
    pl_SetVarFromValue PVAR_8009, 0
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextListMenu 1, 1, 0, 1, PVAR_800C

P356_0145:
    pl_stub GetExchangeServiceCornerItemAndCost  // Pearl 0x29B Unk029B 16384, 32776, 32768, 32769: not translated yet
    pl_BufferItemName 0, PVAR_8000
    pl_stub BufferVarPaddingDigits  // Pearl 0x280 Unk0280 1, 32769, 1, 3: not translated yet
    ListMenuAdd 15, 65535, 255  // Pearl AddListMenuEntry 231, 255
    pl_AddVar PVAR_8008, 1
    pl_CompareVarToVar PVAR_8008, PVAR_4001
    pl_GoToIf 0, P356_0145
    ListMenuAdd 16, 65535, 255  // Pearl AddListMenuEntry 232, 255
    ListMenuShow
    pl_Return

P356_S3:
P356_0182:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P356_S4:
P356_0195:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P356_S5:
P356_01A8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P356_S6:
P356_01BB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P356_S7:
P356_01CE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P356_S8:
P356_S9:
P356_01E1:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 11
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
