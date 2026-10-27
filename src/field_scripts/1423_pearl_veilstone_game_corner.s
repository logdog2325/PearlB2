// MAP_VEILSTONE_GAME_CORNER: Pearl script file 136, text bank 139. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-21: Pearl's; no warp continuations; 22: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P136_S1
    ScriptEntry P136_S2
    ScriptEntry P136_S3
    ScriptEntry P136_S4
    ScriptEntry P136_S5
    ScriptEntry P136_S6
    ScriptEntry P136_S7
    ScriptEntry P136_S8
    ScriptEntry P136_S9
    ScriptEntry P136_S10
    ScriptEntry P136_S11
    ScriptEntry P136_S12
    ScriptEntry P136_S13
    ScriptEntry P136_S14
    ScriptEntry P136_S15
    ScriptEntry P136_S16
    ScriptEntry P136_S17
    ScriptEntry P136_S18
    ScriptEntry P136_S19
    ScriptEntry P136_S20
    ScriptEntry P136_S21
    ScriptEntry PearlArrive
    ScriptEntry PearlClosed_0
    ScriptEntriesEnd

P136_S1:
P136_0056:
    pl_SetVarFromValue PVAR_8004, 0
    pl_GoTo P136_00E6

P136_S2:
P136_0062:
    pl_SetVarFromValue PVAR_8004, 1
    pl_GoTo P136_00E6

P136_S3:
P136_006E:
    pl_SetVarFromValue PVAR_8004, 2
    pl_GoTo P136_00E6

P136_S4:
P136_007A:
    pl_SetVarFromValue PVAR_8004, 3
    pl_GoTo P136_00E6

P136_S5:
P136_0086:
    pl_SetVarFromValue PVAR_8004, 4
    pl_GoTo P136_00E6

P136_S6:
P136_0092:
    pl_SetVarFromValue PVAR_8004, 5
    pl_GoTo P136_00E6

P136_S7:
P136_009E:
    pl_SetVarFromValue PVAR_8004, 6
    pl_GoTo P136_00E6

P136_S8:
P136_00AA:
    pl_SetVarFromValue PVAR_8004, 7
    pl_GoTo P136_00E6

P136_S9:
P136_00B6:
    pl_SetVarFromValue PVAR_8004, 8
    pl_GoTo P136_00E6

P136_S10:
P136_00C2:
    pl_SetVarFromValue PVAR_8004, 9
    pl_GoTo P136_00E6

P136_S11:
P136_00CE:
    pl_SetVarFromValue PVAR_8004, 10
    pl_GoTo P136_00E6

P136_S12:
P136_00DA:
    pl_SetVarFromValue PVAR_8004, 11
    pl_GoTo P136_00E6

P136_00E6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckItem 444, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_012F
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
// CreateJournalEvent 16, 0, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_stub 267  // Pearl 0x267 SlotMachine 32772: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P136_012F:
    pl_msg_sys 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S13:
P136_013A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_CheckItem 444, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_019D
    pl_CheckFlag PFLAG_0130
    pl_GoToIf 1, P136_01A8
    pl_stub CheckBonusRoundStreak  // Pearl 0x275 Unk0275 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_01A8
    pl_SetVarFromValue PVAR_8004, 391  // Pearl item 391 (TM64) = TM64 Explosion
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_01A8
    pl_GoTo P136_02BE

P136_019D:
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_01A8:
    pl_stub ShowCoins  // Pearl 0x075 ShowCoinBox 20, 2: not translated yet
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 7 (Black 2's place)

P136_01B4:
    pl_msg_talk 2
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 23, 65535, 0  // Pearl AddMenuEntryImm 125, 0
    ListMenuAdd 24, 65535, 1  // Pearl AddMenuEntryImm 126, 1
    ListMenuAdd 25, 65535, 2  // Pearl AddMenuEntryImm 127, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P136_01F3
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P136_0242
    pl_GoTo P136_02AF

P136_01F3:
    MoneyCheck PVAR_800C, 1000
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_0291
    pl_stub CheckCanAddCoins  // Pearl 0x276 CanGiveCoins 32780, 50: not translated yet
    pl_stub Noop  // Pearl 0x000 Nop : not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_02A0
    pl_RemoveMoney 1000
    pl_stub AddCoins  // Pearl 0x079 GiveCoins 50: not translated yet
    pl_stub UpdateCoinDisplay  // Pearl 0x077 UpdateCoinBox : not translated yet
    MoneyWinUpdate
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_msg_talk 3
    pl_WaitTime 30, PVAR_800C
    pl_GoTo P136_01B4

P136_0242:
    MoneyCheck PVAR_800C, 10000
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_0291
    pl_stub CheckCanAddCoins  // Pearl 0x276 CanGiveCoins 32780, 500: not translated yet
    pl_stub Noop  // Pearl 0x000 Nop : not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_02A0
    pl_RemoveMoney 10000
    pl_stub AddCoins  // Pearl 0x079 GiveCoins 500: not translated yet
    pl_stub UpdateCoinDisplay  // Pearl 0x077 UpdateCoinBox : not translated yet
    MoneyWinUpdate
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_msg_talk 3
    pl_WaitTime 30, PVAR_800C
    pl_GoTo P136_01B4

P136_0291:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_stub HideCoins  // Pearl 0x076 HideCoinBox : not translated yet
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P136_02A0:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_stub HideCoins  // Pearl 0x076 HideCoinBox : not translated yet
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P136_02AF:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_stub HideCoins  // Pearl 0x076 HideCoinBox : not translated yet
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P136_02BE:
    pl_msg_talk 7
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0130
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S14:
P136_02DF:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S15:
P136_02F2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckItem 444, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_034D
    pl_CheckFlag PFLAG_012E
    pl_GoToIf 1, P136_0358
    pl_stub CheckCanAddCoins  // Pearl 0x276 CanGiveCoins 32780, 20: not translated yet
    pl_stub Noop  // Pearl 0x000 Nop : not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_0358
    pl_SetFlag PFLAG_012E
    pl_stub AddCoins  // Pearl 0x079 GiveCoins 20: not translated yet
    pl_BufferPlayerName 0
    pl_msg_talk 13
    pl_WaitButton
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_034D:
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_0358:
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S16:
P136_0363:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckItem 444, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_03BE
    pl_CheckFlag PFLAG_012F
    pl_GoToIf 1, P136_03C9
    pl_stub CheckCanAddCoins  // Pearl 0x276 CanGiveCoins 32780, 50: not translated yet
    pl_stub Noop  // Pearl 0x000 Nop : not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P136_03C9
    pl_SetFlag PFLAG_012F
    pl_stub AddCoins  // Pearl 0x079 GiveCoins 50: not translated yet
    pl_BufferPlayerName 0
    pl_msg_talk 16
    pl_WaitButton
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_03BE:
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_03C9:
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S17:
P136_03D4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S18:
P136_03E7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S19:
P136_03FA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S20:
P136_040D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 21
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_S21:
P136_0420:
    pl_CompareVarToValue PVAR_4040, 999
    pl_GoToIf 2, P136_0443
    pl_BufferNumber 0, PVAR_4040
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P136_0443:
    pl_BufferNumber 0, 999
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlClosed_0:                  // a closed place (data/pearl_closed_facilities.json): trigger (2, 10) 13x1
    pl_closed_facility 37, 1
    VMHalt

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
    pl_msg_sys 26  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 28
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
    pl_msg_sys 28  // Pearl bank 199 line 25
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
    pl_msg_sys 29  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 199 line 117
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
