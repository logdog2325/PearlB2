// MAP_VEILSTONE_PRIZE_EXCHANGE: Pearl script file 144, text bank 147. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P144_S1
    ScriptEntry P144_S2
    ScriptEntry P144_S3
    ScriptEntry PearlArrive
    ScriptEntry PearlClosed_0
    ScriptEntriesEnd

P144_S1:
P144_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetVarFromValue PVAR_4001, 19
    pl_msg_talk 0
    pl_stub ShowCoins  // Pearl 0x075 ShowCoinBox 21, 1: not translated yet
    pl_GoTo P144_002B

P144_002B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_Call P144_0105
    pl_CompareVarToValue PVAR_800C, 65534
    pl_GoToIf 1, P144_00C8
    pl_CompareVarToVar PVAR_800C, PVAR_4001
    pl_GoToIf 1, P144_00C8
    pl_stub GetGameCornerPrizeData  // Pearl 0x2A6 GetPrizeItemIdAndCost 32780, 32768, 32769: not translated yet
    pl_CompareVarToValue PVAR_8000, 328
    pl_CallIf 0, P144_00EC
    pl_CompareVarToValue PVAR_8000, 328
    pl_CallIf 4, P144_00F6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P144_002B
    pl_stub HasCoinsFromVar  // Pearl 0x2A9 HasEnoughCoinsAddress 32780, 32769: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P144_00E3
    pl_CanFitItem PVAR_8000, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P144_00D5
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_AddItem PVAR_8000, 1, PVAR_800C
    pl_stub SubtractCoinsFromVar  // Pearl 0x2A8 TakeCoinsAddress 32769: not translated yet
    pl_stub UpdateCoinDisplay  // Pearl 0x077 UpdateCoinBox : not translated yet
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_GoTo P144_002B

P144_00C8:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_stub HideCoins  // Pearl 0x076 HideCoinBox : not translated yet
    pl_ReleaseAll
    pl_End

P144_00D5:
    pl_BufferItemName 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_GoTo P144_002B

P144_00E3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_GoTo P144_002B

P144_00EC:
    pl_BufferItemName 0, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_Return

P144_00F6:
    pl_BufferItemName 0, PVAR_8000
    pl_BufferTMHMMoveName 1, PVAR_8000
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_Return

P144_0105:
    pl_SetVarFromValue PVAR_8008, 0
    pl_SetVarFromValue PVAR_8009, 0
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextListMenu 1, 1, 0, 1, PVAR_800C

P144_0119:
    pl_stub GetGameCornerPrizeData  // Pearl 0x2A6 GetPrizeItemIdAndCost 32776, 32768, 32769: not translated yet
    pl_BufferItemName 0, PVAR_8000
    pl_stub BufferVarPaddingDigits  // Pearl 0x280 Unk0280 1, 32769, 1, 5: not translated yet
    ListMenuAdd 10, 65535, 255  // Pearl AddListMenuEntry 168, 255
    pl_AddVar PVAR_8008, 1
    pl_CompareVarToVar PVAR_8008, PVAR_4001
    pl_GoToIf 0, P144_0119
    ListMenuAdd 11, 65535, 255  // Pearl AddListMenuEntry 169, 255
    ListMenuShow
    pl_Return

P144_S2:
P144_0154:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P144_S3:
P144_0167:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlClosed_0:                  // a closed place (data/pearl_closed_facilities.json): object 0
    pl_closed_facility 12, 255
    VMHalt

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
