// MAP_HEARTHOME_SUPER_CONTEST_HALL_LOBBY: Pearl script file 114, text bank 120. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-14: Pearl's; 15: after a Warp, 16: after a Warp, 17: after a Warp; 18: PearlArrive; 84: Pearl 9800, 86: Pearl 9803, 88: Pearl 9806, 89: Pearl 9807, 90: Pearl 9808, 91: Pearl 9812, 98: Pearl 10156
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"
#include "pearl_musical.inc"

    ScriptEntry P114_S1
    ScriptEntry P114_S2
    ScriptEntry P114_S3
    ScriptEntry P114_S4
    ScriptEntry P114_S5
    ScriptEntry P114_S6
    ScriptEntry P114_S7
    ScriptEntry P114_S8
    ScriptEntry P114_S9
    ScriptEntry P114_S10
    ScriptEntry P114_S11
    ScriptEntry P114_S12
    ScriptEntry P114_S13
    ScriptEntry P114_S14
    ScriptEntry W206_08EB_S
    ScriptEntry W206_0BBE_S
    ScriptEntry W206_0BF2_S
    ScriptEntry PearlArrive
    ScriptEntry PearlClosed_0
    ScriptEntry PearlClosed_1
    ScriptEntry PearlClosed_2
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_9800
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_9803
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_9806
    ScriptEntry PearlProxy_9807
    ScriptEntry PearlProxy_9808
    ScriptEntry PearlProxy_9812
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10156
    ScriptEntriesEnd

P114_S1:
P114_003A:
    pl_LockAll
    pl_ApplyMovement 6, P114_0148
    pl_WaitMovement
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 5, P114_0168
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P114_0140
    pl_WaitMovement
    pl_msg_sys 2
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_msg_sys 4
    pl_SetVarFromValue PVAR_8004, 49
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_48_S48  // CallCommonScript 2047 (Pearl file 205 script 48)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 5
    pl_msg_sys 6
    pl_CloseMessage
    pl_ApplyMovement 6, P114_0154
    pl_ApplyMovement 5, P114_0170
    pl_ApplyMovement PL_PLAYER, P114_01C4
    pl_WaitMovement
    pl_RemoveObject 6, PFLAG_0227
    pl_SetVarFromValue PVAR_40F7, 1
    pl_ApplyMovement 5, P114_0178
    pl_ApplyMovement PL_PLAYER, P114_01CC
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 7
    pl_CloseMessage
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_00E6
    pl_GoTo P114_00F1

P114_00E6:
    pl_msg_sys 8
    pl_GoTo P114_00FC

P114_00F1:
    pl_msg_sys 9
    pl_GoTo P114_00FC

P114_00FC:
    pl_WaitFanfare
    pl_msg_sys 10
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement PL_PLAYER, P114_01B4
    pl_ApplyMovement 5, P114_019C
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 5, PFLAG_0226
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetFlag PFLAG_0224
    pl_SetVarFromValue PVAR_407B, 1
    pl_SetFlag PFLAG_0978
    pl_SetVarFromValue PVAR_40EB, 1
    pl_ReleaseAll
    pl_End

P114_S2:
P114_0180:
    pl_End

P114_S3:
P114_01D4:
    pl_End

P114_S4:
P114_01D6:
    pl_End

P114_S5:
P114_01D8:
    pl_End

P114_S6:
P114_01DA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub ContestPhotoHasData  // Pearl 0x12F CheckContestPortraitSlot 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_030B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 0A8  // Pearl 0x0A8 ShowContestPokemon 0, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P114_S7:
P114_0217:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub ContestPhotoHasData  // Pearl 0x12F CheckContestPortraitSlot 1, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_030B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 0A8  // Pearl 0x0A8 ShowContestPokemon 1, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P114_S8:
P114_0254:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub ContestPhotoHasData  // Pearl 0x12F CheckContestPortraitSlot 2, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_030B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 0A8  // Pearl 0x0A8 ShowContestPokemon 2, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P114_S9:
P114_0291:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub ContestPhotoHasData  // Pearl 0x12F CheckContestPortraitSlot 3, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_030B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 0A8  // Pearl 0x0A8 ShowContestPokemon 3, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P114_S10:
P114_02CE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub ContestPhotoHasData  // Pearl 0x12F CheckContestPortraitSlot 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_030B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 0A8  // Pearl 0x0A8 ShowContestPokemon 4, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P114_030B:
    pl_msg_sys 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P114_S11:
P114_0316:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P114_S12:
P114_0329:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 21
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P114_S13:
P114_033C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P114_S14:
P114_034F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0159
    pl_GoToIf 0, P114_03C1
    pl_CheckFlag PFLAG_015A
    pl_GoToIf 0, P114_0378

P114_036D:
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P114_0378:
    pl_CheckItem 449, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_036D
    pl_msg_talk 12
    pl_stub CheckHasEmptyPoffinCaseSlot  // Pearl 0x28A Unk028A 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_03B6
    pl_Call P114_0425
    pl_SetFlag PFLAG_015A
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P114_03B6:
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P114_03C1:
    pl_SetFlag PFLAG_0159
    pl_CheckItem 449, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_0416
    pl_msg_talk 12
    pl_stub CheckHasEmptyPoffinCaseSlot  // Pearl 0x28A Unk028A 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P114_0407
    pl_Call P114_0425
    pl_SetFlag PFLAG_015A
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15
    pl_CloseMessage
    pl_Call P114_0440
    pl_ReleaseAll
    pl_End

P114_0407:
    pl_msg_talk 19
    pl_CloseMessage
    pl_Call P114_0440
    pl_ReleaseAll
    pl_End

P114_0416:
    pl_msg_talk 11
    pl_CloseMessage
    pl_Call P114_0440
    pl_ReleaseAll
    pl_End

P114_0425:
    pl_stub GivePoffin  // Pearl 0x289 Unk0289 32780, 60, 30, 30, 30, 30, 40: not translated yet
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13
    pl_WaitFanfare
    pl_msg_talk 14
    pl_Return

P114_0440:
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P114_045D
    pl_ApplyMovement 9, P114_046C
    pl_WaitMovement
    pl_Return

P114_045D:
    pl_ApplyMovement 9, P114_0478
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P114_0140:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P114_0148:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P114_0154:
    Move 15, 3  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 12, 6  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P114_0168:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P114_0170:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P114_0178:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P114_019C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P114_01B4:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P114_01C4:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P114_01CC:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P114_046C:
    Move 15, 8  // WALK_NORMAL_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P114_0478:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 8  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

// ---- continuation 15: after the Warp at 206:08EB (a common script)
W206_08EB_0052:
    pl_ApplyMovement PL_PLAYER, W206_08EB_0120
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_800C
    pl_LoadDoorAnimation 77, PL_TMP, 5  // the door at cell (0,0) tile (PVAR_800C,5)
    pl_Call W206_08EB_010D
    pl_ApplyMovement PL_PLAYER, W206_08EB_0128
    pl_WaitMovement
    pl_Call W206_08EB_0115
    pl_Return

W206_08EB_008B:
    pl_ApplyMovement PL_PLAYER, W206_08EB_0130
    pl_WaitMovement
    pl_CompareVarToValue PVAR_8007, 3
    pl_CallIf 1, W206_08EB_00C8
    pl_CompareVarToValue PVAR_8007, 5
    pl_CallIf 1, W206_08EB_00DF
    pl_CompareVarToValue PVAR_8007, 7
    pl_CallIf 1, W206_08EB_00F6
    pl_SetVarFromValue PVAR_8004, 0
    pl_ShowYesNoMenu PVAR_800C
    pl_Return

W206_08EB_00C8:
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 2, W206_08EB_00DA
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 203 line 184
    pl_Return

W206_08EB_00DA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 203 line 185
    pl_Return

W206_08EB_00DF:
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 2, W206_08EB_00F1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 203 line 194
    pl_Return

W206_08EB_00F1:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 203 line 195
    pl_Return

W206_08EB_00F6:
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 2, W206_08EB_0108
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 203 line 204
    pl_Return

W206_08EB_0108:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 203 line 205
    pl_Return

W206_08EB_010D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

W206_08EB_0115:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

W206_08EB_070D:
    pl_stub NewContest  // Pearl 0x0FA Unk00FA 32772, 32773, 32775, 16386: not translated yet
    pl_CompareVarToValue PVAR_4003, 1
    pl_CallIf 1, W206_08EB_07B5
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, W206_08EB_078A
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 22: not translated yet
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 64: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 25: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 25: not translated yet
    pl_CloseMessage

W206_08EB_0761:
    pl_CompareVarToValue PVAR_4003, 0
    pl_GoToIf 1, W206_08EB_07BC
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, W206_08EB_07F1
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, W206_08EB_0830
    pl_End

W206_08EB_078A:
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 203 line 177
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_CloseMessage
    pl_GoTo W206_08EB_0761

W206_08EB_07B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 203 line 210
    pl_stub WaitForLinkContestSetup  // Pearl 0x100 Unk0100 : not translated yet
    pl_Return

W206_08EB_07BC:
    pl_LoadDoorAnimation 77, 19, 5  // the door at cell (0,0) tile (19,5)
    pl_Call W206_08EB_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, W206_08EB_0DA0
    pl_ApplyMovement 0, W206_08EB_0E08
    pl_WaitMovement
    pl_Call W206_08EB_0115
    pl_WaitMovement
    pl_GoTo W206_08EB_086A

W206_08EB_07F1:
    pl_SetFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 5
    pl_LoadDoorAnimation 77, 7, 5  // the door at cell (0,0) tile (7,5)
    pl_Call W206_08EB_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, W206_08EB_0DB0
    pl_ApplyMovement 1, W206_08EB_0E18
    pl_WaitMovement
    pl_Call W206_08EB_0115
    pl_WaitMovement
    pl_GoTo W206_08EB_086A

W206_08EB_0830:
    pl_LoadDoorAnimation 77, 28, 5  // the door at cell (0,0) tile (28,5)
    pl_Call W206_08EB_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, W206_08EB_0DC0
    pl_ApplyMovement 2, W206_08EB_0E28
    pl_WaitMovement
    pl_Call W206_08EB_0115
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 211: not translated yet
    pl_CloseMessage
    pl_GoTo W206_08EB_086A

W206_08EB_086A:
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, W206_08EB_08CD
    pl_stub ChangeIntoContestAttire  // Pearl 0x0C6 ApplyContestDress : not translated yet
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, W206_08EB_0892
    pl_GoTo W206_08EB_08A0

W206_08EB_0892:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 66: not translated yet
    pl_GoTo W206_08EB_08AE

W206_08EB_08A0:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 67: not translated yet
    pl_GoTo W206_08EB_08AE

W206_08EB_08AE:
    pl_ApplyMovement PL_PLAYER, W206_08EB_0E00
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 68: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 26: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 26: not translated yet
    pl_CloseMessage
    pl_GoTo W206_08EB_0947

W206_08EB_08CD:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub RunContestApplication  // Pearl 0x101 Unk0101 : not translated yet
    pl_stub GetContestInfo  // Pearl 0x110 Unk0110 32772, 32773, 32775, 16386: not translated yet
    pl_SetVarFromValue PVAR_40CC, 0
    RTReserveScript 15  // the rest of this Pearl script runs there (continuation 15)
    pl_Warp 171, 28, 3, 1  // Pearl map 117 (MAP_HEARTHOME_SUPER_CONTEST_HALL_LOBBY)
    pl_ReleaseAll
    pl_End

W206_08EB_S:
W206_08EB_08F7:
    pl_LockAll
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_stub GetContestMode  // Pearl 0x10C Unk010C 16387: not translated yet
    pl_stub GetContestInfo  // Pearl 0x110 Unk0110 32772, 32773, 32775, 16386: not translated yet
    pl_stub GetPlayerContestPlacement  // Pearl 0x107 Unk0107 32772: not translated yet
    pl_stub LockTextSpeed  // Pearl 0x118 Unk0118 : not translated yet
    pl_stub EndContest  // Pearl 0x0FB Unk00FB 16386: not translated yet
    pl_SetVarFromValue PVAR_800C, 28
    pl_Call W206_08EB_0052
    pl_Call W206_08EB_008B
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, W206_08EB_070D
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 203 line 116
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

W206_08EB_0947:
    pl_ClearFlag PFLAG_023E
    pl_SetVarFromValue PVAR_40CC, 1
    pl_Call W206_08EB_0D20
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ClearFlag PFLAG_021F
    pl_ClearFlag PFLAG_0220
    pl_ClearFlag PFLAG_0221
    pl_ClearFlag PFLAG_0222
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub Warp  // to Pearl map 118: no Black 2 zone (not installed)
    pl_ReleaseAll
    pl_End

W206_08EB_0D20:
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 0, 16416: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 1, 16417: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 2, 16418: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 3, 16419: not translated yet
    pl_Return

    .balign 4, 0
W206_08EB_0120:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W206_08EB_0128:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W206_08EB_0130:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
W206_08EB_0DA0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
W206_08EB_0DB0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
W206_08EB_0DC0:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
W206_08EB_0E00:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
W206_08EB_0E08:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
W206_08EB_0E18:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
W206_08EB_0E28:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

// ---- continuation 16: after the Warp at 206:0BBE (a common script)
W206_0BBE_0052:
    pl_ApplyMovement PL_PLAYER, W206_0BBE_0120
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_800C
    pl_LoadDoorAnimation 77, PL_TMP, 5  // the door at cell (0,0) tile (PVAR_800C,5)
    pl_Call W206_0BBE_010D
    pl_ApplyMovement PL_PLAYER, W206_0BBE_0128
    pl_WaitMovement
    pl_Call W206_0BBE_0115
    pl_Return

W206_0BBE_010D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

W206_0BBE_0115:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

W206_0BBE_S:
W206_0BBE_0BCA:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_800C, 7
    pl_Call W206_0BBE_0052
    pl_ClearFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 0
    pl_GoTo W206_0BBE_0C45

W206_0BBE_0C45:
    pl_End

    .balign 4, 0
W206_0BBE_0120:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W206_0BBE_0128:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- continuation 17: after the Warp at 206:0BF2 (a common script)
W206_0BF2_0052:
    pl_ApplyMovement PL_PLAYER, W206_0BF2_0120
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_800C
    pl_LoadDoorAnimation 77, PL_TMP, 5  // the door at cell (0,0) tile (PVAR_800C,5)
    pl_Call W206_0BF2_010D
    pl_ApplyMovement PL_PLAYER, W206_0BF2_0128
    pl_WaitMovement
    pl_Call W206_0BF2_0115
    pl_Return

W206_0BF2_007F:
    pl_ApplyMovement PL_PLAYER, W206_0BF2_013C
    pl_WaitMovement
    pl_Return

W206_0BF2_010D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

W206_0BF2_0115:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

W206_0BF2_S:
W206_0BF2_0BFE:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_800C, 19
    pl_Call W206_0BF2_0052
    pl_Call W206_0BF2_007F
    pl_CompareVarToValue PVAR_8004, 65535
    pl_GoToIf 1, W206_0BF2_0C3E
    pl_BufferPlayerName 0
// BufferAccessoryName 1, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 203 line 80
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_48_S48  // CallCommonScript 2047 (Pearl file 205 script 48)

W206_0BF2_0C3E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 203 line 82
    pl_WaitButton
    pl_CloseMessage
    pl_End

    .balign 4, 0
W206_0BF2_0120:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W206_0BF2_0128:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
W206_0BF2_013C:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

PearlProxy_9800:                  // Pearl global script 9800 (run by this zone's events)
    VMCall C206_1_S1
    VMHalt

PearlProxy_9803:                  // Pearl global script 9803 (run by this zone's events)
    VMCall C206_4_S4
    VMHalt

PearlProxy_9806:                  // Pearl global script 9806 (run by this zone's events)
    VMCall T206_7_S7
    VMHalt

PearlProxy_9807:                  // Pearl global script 9807 (run by this zone's events)
    VMCall T206_8_S8
    VMHalt

PearlProxy_9808:                  // Pearl global script 9808 (run by this zone's events)
    VMCall T206_9_S9
    VMHalt

PearlProxy_9812:                  // Pearl global script 9812 (run by this zone's events)
    VMCall C206_13_S13
    VMHalt

PearlProxy_10156:                  // Pearl global script 10156 (run by this zone's events)
    VMCall T1042_7_S7
    VMHalt

PearlClosed_0:                  // the Pokémon Musical's reception (data/pearl_closed_facilities.json "musical"): object 1
    pl_musical_reception 167, 168
    VMHalt

PearlClosed_1:                  // the Pokémon Musical's reception (data/pearl_closed_facilities.json "musical"): object 0
    pl_musical_reception 167, 168
    VMHalt

PearlClosed_2:                  // the Pokémon Musical's reception (data/pearl_closed_facilities.json "musical"): object 2
    pl_musical_reception 167, 168
    VMHalt

// ---- Pearl global script 205:48 (a subroutine here)
C205_48_S48:
C205_48_0915:
    pl_Call C205_48_0922
    MsgWinCloseAll  // another speaker: close the first window
    pl_CompareVarToValue PVAR_8004, 49
    pl_GoToIf 1, C205_48_091B_App49
    pl_msg_sys 38  // Pearl bank 199 line 127: another one (no caller here sets it)
    pl_GoTo C205_48_091B_AppDone
C205_48_091B_App49:
    pl_msg_sys 39  // naming Glitter Powder
    pl_GoTo C205_48_091B_AppDone
C205_48_091B_AppDone:
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_48_0922:
    pl_PlayFanfare SEQ_ME_ACCE  // Pearl SEQ_ACCE
// AddAccessory 32772, 32773: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
// BufferAccessoryName 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    MsgWinCloseAll  // another speaker: close the first window
    pl_CompareVarToValue PVAR_8004, 49
    pl_GoToIf 1, C205_48_0931_App49
    pl_msg_sys 40  // Pearl bank 199 line 25: another one (no caller here sets it)
    pl_GoTo C205_48_0931_AppDone
C205_48_0931_App49:
    pl_msg_sys 41  // naming Glitter Powder
    pl_GoTo C205_48_0931_AppDone
C205_48_0931_AppDone:
    pl_WaitFanfare
    pl_BufferPlayerName 0
// BufferAccessoryName 1, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_Return

// ---- Pearl global script 206:1 (a subroutine here)
C206_1_S1:
C206_1_0036:
    pl_LockAll
    pl_SetVarFromValue PVAR_800C, 7
    pl_Call C206_1_0052
    pl_ClearFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C206_1_0052:
    pl_ApplyMovement PL_PLAYER, C206_1_0120
    pl_WaitMovement
    WorkSetConst PL_TMP, 0
    WorkAdd PL_TMP, PVAR_800C
    pl_LoadDoorAnimation 77, PL_TMP, 5  // the door at cell (0,0) tile (PVAR_800C,5)
    pl_Call C206_1_010D
    pl_ApplyMovement PL_PLAYER, C206_1_0128
    pl_WaitMovement
    pl_Call C206_1_0115
    pl_Return

C206_1_010D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

C206_1_0115:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

    .balign 4, 0
C206_1_0120:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
C206_1_0128:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- Pearl global script 206:4 (a subroutine here)
C206_4_0168:
    pl_SetVarFromValue PVAR_40CC, 0
    pl_SetFlag PFLAG_021F
    pl_SetFlag PFLAG_0220
    pl_SetFlag PFLAG_0221
    pl_SetFlag PFLAG_0222
    pl_SetFlag PFLAG_0223
    pl_Return

C206_4_S4:
C206_4_0184:
    pl_ShowPoketch
    pl_Call C206_4_01B1
    pl_Call C206_4_0168
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 7, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, C206_4_01AB
    pl_ClearFlag PFLAG_0231
    VMReturn  // End: the sub-script ends

C206_4_01AB:
    pl_SetFlag PFLAG_0231
    VMReturn  // End: the sub-script ends

C206_4_01B1:
    pl_CheckFlag PFLAG_0159
    pl_GoToIf 1, C206_4_01BE
    pl_Return

C206_4_01BE:
    pl_stub SetObjectEventPos  // object 9 is not in this zone
// SetObjectEventMovementType 9, 15: Black 2 has no command for it (the NPC keeps its own)
    pl_stub SetObjectEventDir  // object 9 is not in this zone
    pl_Return

// ---- Pearl global script 206:7 (a subroutine here)
T206_7_010D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

T206_7_0115:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

T206_7_S7:
T206_7_01FC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetVarFromValue PVAR_4003, 0
    pl_SetVarFromValue PVAR_8007, 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 42  // Pearl bank 203 line 3
    pl_GoTo T206_7_023A

T206_7_023A:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_7_0250
    pl_msg_talk 43  // Pearl bank 203 line 4
    pl_GoTo T206_7_0253

T206_7_0250:
    pl_msg_talk 44  // Pearl bank 203 line 12

T206_7_0253:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 45, 65535, 0  // Pearl AddMenuEntryImm 8, 0
    ListMenuAdd 46, 65535, 1  // Pearl AddMenuEntryImm 9, 1
    ListMenuAdd 47, 65535, 2  // Pearl AddMenuEntryImm 10, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_7_02A8
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_7_02F0
    pl_GoTo T206_7_0291

T206_7_0291:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ClearFlag PFLAG_0966
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 48  // Pearl bank 203 line 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T206_7_02A8:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_7_02BD
    pl_GoTo T206_7_040D

T206_7_02BD:
    pl_HealParty
    pl_ClearFlag PFLAG_0966
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_7_02E2
    pl_GoTo T206_7_0291

T206_7_02E2:
    pl_SetVarFromValue PVAR_8004, 2
    pl_GoTo T206_7_04A8

T206_7_02F0:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_7_0305
    pl_GoTo T206_7_030E

T206_7_0305:
    pl_msg_talk 49  // Pearl bank 203 line 13
    pl_GoTo T206_7_023A

T206_7_030E:
    pl_msg_talk 50  // Pearl bank 203 line 5

T206_7_0311:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 51, 65535, 0  // Pearl AddMenuEntryImm 96, 0
    ListMenuAdd 52, 65535, 1  // Pearl AddMenuEntryImm 97, 1
    ListMenuAdd 53, 65535, 2  // Pearl AddMenuEntryImm 98, 2
    ListMenuAdd 54, 65535, 3  // Pearl AddMenuEntryImm 99, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_7_0360
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_7_0368
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_7_0373
    pl_GoTo T206_7_023A

T206_7_0360:
    pl_GoTo T206_7_0381

T206_7_0368:
    pl_msg_talk 55  // Pearl bank 203 line 18
    pl_GoTo T206_7_030E

T206_7_0373:
    pl_msg_talk 56  // Pearl bank 203 line 19
    pl_GoTo T206_7_030E

T206_7_037E:
    pl_msg_talk 57  // Pearl bank 203 line 117

T206_7_0381:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 58, 65535, 0  // Pearl AddMenuEntryImm 36, 0
    ListMenuAdd 59, 65535, 1  // Pearl AddMenuEntryImm 37, 1
    ListMenuAdd 60, 65535, 2  // Pearl AddMenuEntryImm 38, 2
    ListMenuAdd 61, 65535, 3  // Pearl AddMenuEntryImm 39, 3
    ListMenuAdd 62, 65535, 4  // Pearl AddMenuEntryImm 40, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_7_03E1
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_7_03EC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_7_03F7
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_7_0402
    pl_GoTo T206_7_0311

T206_7_03E1:
    pl_msg_talk 63  // Pearl bank 203 line 14
    pl_GoTo T206_7_037E

T206_7_03EC:
    pl_msg_talk 64  // Pearl bank 203 line 15
    pl_GoTo T206_7_037E

T206_7_03F7:
    pl_msg_talk 65  // Pearl bank 203 line 16
    pl_GoTo T206_7_037E

T206_7_0402:
    pl_msg_talk 66  // Pearl bank 203 line 17
    pl_GoTo T206_7_037E

T206_7_040D:
    pl_msg_talk 67  // Pearl bank 203 line 27
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 68, 65535, 0  // Pearl AddMenuEntryImm 105, 0
    ListMenuAdd 69, 65535, 1  // Pearl AddMenuEntryImm 106, 1
    ListMenuAdd 70, 65535, 2  // Pearl AddMenuEntryImm 107, 2
    ListMenuAdd 71, 65535, 3  // Pearl AddMenuEntryImm 108, 3
    ListMenuAdd 72, 65535, 4  // Pearl AddMenuEntryImm 109, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_7_0470
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_7_047E
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_7_048C
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_7_049A
    pl_GoTo T206_7_0291

T206_7_0470:
    pl_SetVarFromValue PVAR_8004, 0
    pl_GoTo T206_7_04A8

T206_7_047E:
    pl_SetVarFromValue PVAR_8004, 1
    pl_GoTo T206_7_04A8

T206_7_048C:
    pl_SetVarFromValue PVAR_8004, 2
    pl_GoTo T206_7_04A8

T206_7_049A:
    pl_SetVarFromValue PVAR_8004, 3
    pl_GoTo T206_7_04A8

T206_7_04A8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 73  // Pearl bank 203 line 28
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 74, 65535, 0  // Pearl AddMenuEntryImm 110, 0
    ListMenuAdd 75, 65535, 1  // Pearl AddMenuEntryImm 111, 1
    ListMenuAdd 76, 65535, 2  // Pearl AddMenuEntryImm 112, 2
    ListMenuAdd 77, 65535, 3  // Pearl AddMenuEntryImm 113, 3
    ListMenuAdd 78, 65535, 4  // Pearl AddMenuEntryImm 114, 4
    ListMenuAdd 79, 65535, 5  // Pearl AddMenuEntryImm 115, 5
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_7_051C
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_7_052A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_7_0538
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_7_0546
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, T206_7_0554
    pl_GoTo T206_7_0291

T206_7_051C:
    pl_SetVarFromValue PVAR_8005, 0
    pl_GoTo T206_7_0562

T206_7_052A:
    pl_SetVarFromValue PVAR_8005, 1
    pl_GoTo T206_7_0562

T206_7_0538:
    pl_SetVarFromValue PVAR_8005, 2
    pl_GoTo T206_7_0562

T206_7_0546:
    pl_SetVarFromValue PVAR_8005, 3
    pl_GoTo T206_7_0562

T206_7_0554:
    pl_SetVarFromValue PVAR_8005, 4
    pl_GoTo T206_7_0562

T206_7_0562:
    pl_msg_talk 80  // Pearl bank 203 line 20
    pl_msg_talk 81  // Pearl bank 203 line 21
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_4003, 0
    pl_CallIf 1, T206_7_0600
    pl_CompareVarToValue PVAR_4003, 1
    pl_CallIf 1, T206_7_0608
    pl_SetVarFromValue PVAR_800C, 0

T206_7_0596:
    pl_stub OpenPartyMenuForContest  // Pearl 0x194 Unk0194 32780, 32772, 32773, 16388: not translated yet
    pl_stub GetContestPartyMenuResult  // Pearl 0x195 Unk0195 16386, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_7_05C1
    pl_stub SetMonSummary  // Pearl 0x196 Unk0196 16386: not translated yet
    pl_stub GetMonPartySlot  // Pearl 0x197 Unk0197 32780: not translated yet
    pl_GoTo T206_7_0596

T206_7_05C1:
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_4002, 255
    pl_GoToIf 1, T206_7_05E4
    pl_GoTo T206_7_0610

T206_7_05E4:
    pl_msg_talk 82  // Pearl bank 203 line 215
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_7_0291
    pl_GoTo T206_7_0562

T206_7_0600:
    pl_SetVarFromValue PVAR_4004, 0
    pl_Return

T206_7_0608:
    pl_SetVarFromValue PVAR_4004, 1
    pl_Return

T206_7_0610:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_7_0625
    pl_GoTo T206_7_070D

T206_7_0625:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 83  // Pearl bank 203 line 219
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 30, 1, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 84, 65535, 0  // Pearl AddMenuEntryImm 13, 0
    ListMenuAdd 85, 65535, 1  // Pearl AddMenuEntryImm 14, 1
    ListMenuAdd 86, 65535, 2  // Pearl AddMenuEntryImm 5, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_7_0669
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_7_06BB
    pl_GoTo T206_7_0291

T206_7_0669:
    pl_msg_talk 87  // Pearl bank 203 line 212
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_7_0625
    pl_CloseMessage
    pl_stub StartBattleClient  // Pearl 0x0F2 Unk00F2 8, 32773, 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_7_06AB
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T206_7_06B3
    pl_GoTo T206_7_070D

T206_7_06AB:
    pl_GoTo T206_7_0625

T206_7_06B3:
    pl_GoTo T206_7_0625

T206_7_06BB:
    pl_msg_talk 87  // Pearl bank 203 line 212
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_7_0625
    pl_CloseMessage
    pl_stub StartBattleServer  // Pearl 0x0F3 Unk00F3 8, 32773, 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_7_06FD
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T206_7_0705
    pl_GoTo T206_7_070D

T206_7_06FD:
    pl_GoTo T206_7_0625

T206_7_0705:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T206_7_070D:
    pl_stub NewContest  // Pearl 0x0FA Unk00FA 32772, 32773, 32775, 16386: not translated yet
    pl_CompareVarToValue PVAR_4003, 1
    pl_CallIf 1, T206_7_07B5
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_7_078A
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 22: not translated yet
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 64: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 25: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 25: not translated yet
    pl_CloseMessage

T206_7_0761:
    pl_CompareVarToValue PVAR_4003, 0
    pl_GoToIf 1, T206_7_07BC
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_7_07F1
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_7_0830
    VMReturn  // End: the sub-script ends

T206_7_078A:
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 33  // Pearl bank 203 line 177
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_CloseMessage
    pl_GoTo T206_7_0761

T206_7_07B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 34  // Pearl bank 203 line 210
    pl_stub WaitForLinkContestSetup  // Pearl 0x100 Unk0100 : not translated yet
    pl_Return

T206_7_07BC:
    pl_LoadDoorAnimation 77, 19, 5  // the door at cell (0,0) tile (19,5)
    pl_Call T206_7_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_7_0DA0
    pl_ApplyMovement 0, T206_7_0E08
    pl_WaitMovement
    pl_Call T206_7_0115
    pl_WaitMovement
    pl_GoTo T206_7_086A

T206_7_07F1:
    pl_SetFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 5
    pl_LoadDoorAnimation 77, 7, 5  // the door at cell (0,0) tile (7,5)
    pl_Call T206_7_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_7_0DB0
    pl_ApplyMovement 1, T206_7_0E18
    pl_WaitMovement
    pl_Call T206_7_0115
    pl_WaitMovement
    pl_GoTo T206_7_086A

T206_7_0830:
    pl_LoadDoorAnimation 77, 28, 5  // the door at cell (0,0) tile (28,5)
    pl_Call T206_7_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_7_0DC0
    pl_ApplyMovement 2, T206_7_0E28
    pl_WaitMovement
    pl_Call T206_7_0115
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 211: not translated yet
    pl_CloseMessage
    pl_GoTo T206_7_086A

T206_7_086A:
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_7_08CD
    pl_stub ChangeIntoContestAttire  // Pearl 0x0C6 ApplyContestDress : not translated yet
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_7_0892
    pl_GoTo T206_7_08A0

T206_7_0892:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 66: not translated yet
    pl_GoTo T206_7_08AE

T206_7_08A0:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 67: not translated yet
    pl_GoTo T206_7_08AE

T206_7_08AE:
    pl_ApplyMovement PL_PLAYER, T206_7_0E00
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 68: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 26: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 26: not translated yet
    pl_CloseMessage
    pl_GoTo T206_7_0947

T206_7_08CD:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub RunContestApplication  // Pearl 0x101 Unk0101 : not translated yet
    pl_stub GetContestInfo  // Pearl 0x110 Unk0110 32772, 32773, 32775, 16386: not translated yet
    pl_SetVarFromValue PVAR_40CC, 0
    RTReserveScript 15  // the rest of this Pearl script runs there (continuation 15)
    pl_Warp 171, 28, 3, 1  // Pearl map 117 (MAP_HEARTHOME_SUPER_CONTEST_HALL_LOBBY)
    pl_ReleaseAll
    pl_End

T206_7_0947:
    pl_ClearFlag PFLAG_023E
    pl_SetVarFromValue PVAR_40CC, 1
    pl_Call T206_7_0D20
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ClearFlag PFLAG_021F
    pl_ClearFlag PFLAG_0220
    pl_ClearFlag PFLAG_0221
    pl_ClearFlag PFLAG_0222
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub Warp  // to Pearl map 118: no Black 2 zone (not installed)
    pl_ReleaseAll
    pl_End

T206_7_0D20:
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 0, 16416: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 1, 16417: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 2, 16418: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 3, 16419: not translated yet
    pl_Return

    .balign 4, 0
T206_7_0DA0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
T206_7_0DB0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
T206_7_0DC0:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T206_7_0E00:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T206_7_0E08:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
T206_7_0E18:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
T206_7_0E28:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

// ---- Pearl global script 206:8 (a subroutine here)
T206_8_010D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

T206_8_0115:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

T206_8_S8:
T206_8_021B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetVarFromValue PVAR_4003, 1
    pl_SetVarFromValue PVAR_8007, 2
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 88  // Pearl bank 203 line 7
    pl_GoTo T206_8_023A

T206_8_023A:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_8_0250
    pl_msg_talk 43  // Pearl bank 203 line 4
    pl_GoTo T206_8_0253

T206_8_0250:
    pl_msg_talk 44  // Pearl bank 203 line 12

T206_8_0253:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 45, 65535, 0  // Pearl AddMenuEntryImm 8, 0
    ListMenuAdd 46, 65535, 1  // Pearl AddMenuEntryImm 9, 1
    ListMenuAdd 47, 65535, 2  // Pearl AddMenuEntryImm 10, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_8_02A8
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_8_02F0
    pl_GoTo T206_8_0291

T206_8_0291:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_SetVarFromValue PVAR_40D5, 0
    pl_ClearFlag PFLAG_0966
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 48  // Pearl bank 203 line 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T206_8_02A8:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_8_02BD
    pl_GoTo T206_8_040D

T206_8_02BD:
    pl_HealParty
    pl_ClearFlag PFLAG_0966
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_8_02E2
    pl_GoTo T206_8_0291

T206_8_02E2:
    pl_SetVarFromValue PVAR_8004, 2
    pl_GoTo T206_8_04A8

T206_8_02F0:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_8_0305
    pl_GoTo T206_8_030E

T206_8_0305:
    pl_msg_talk 49  // Pearl bank 203 line 13
    pl_GoTo T206_8_023A

T206_8_030E:
    pl_msg_talk 50  // Pearl bank 203 line 5

T206_8_0311:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 51, 65535, 0  // Pearl AddMenuEntryImm 96, 0
    ListMenuAdd 52, 65535, 1  // Pearl AddMenuEntryImm 97, 1
    ListMenuAdd 53, 65535, 2  // Pearl AddMenuEntryImm 98, 2
    ListMenuAdd 54, 65535, 3  // Pearl AddMenuEntryImm 99, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_8_0360
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_8_0368
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_8_0373
    pl_GoTo T206_8_023A

T206_8_0360:
    pl_GoTo T206_8_0381

T206_8_0368:
    pl_msg_talk 55  // Pearl bank 203 line 18
    pl_GoTo T206_8_030E

T206_8_0373:
    pl_msg_talk 56  // Pearl bank 203 line 19
    pl_GoTo T206_8_030E

T206_8_037E:
    pl_msg_talk 57  // Pearl bank 203 line 117

T206_8_0381:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 58, 65535, 0  // Pearl AddMenuEntryImm 36, 0
    ListMenuAdd 59, 65535, 1  // Pearl AddMenuEntryImm 37, 1
    ListMenuAdd 60, 65535, 2  // Pearl AddMenuEntryImm 38, 2
    ListMenuAdd 61, 65535, 3  // Pearl AddMenuEntryImm 39, 3
    ListMenuAdd 62, 65535, 4  // Pearl AddMenuEntryImm 40, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_8_03E1
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_8_03EC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_8_03F7
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_8_0402
    pl_GoTo T206_8_0311

T206_8_03E1:
    pl_msg_talk 63  // Pearl bank 203 line 14
    pl_GoTo T206_8_037E

T206_8_03EC:
    pl_msg_talk 64  // Pearl bank 203 line 15
    pl_GoTo T206_8_037E

T206_8_03F7:
    pl_msg_talk 65  // Pearl bank 203 line 16
    pl_GoTo T206_8_037E

T206_8_0402:
    pl_msg_talk 66  // Pearl bank 203 line 17
    pl_GoTo T206_8_037E

T206_8_040D:
    pl_msg_talk 67  // Pearl bank 203 line 27
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 68, 65535, 0  // Pearl AddMenuEntryImm 105, 0
    ListMenuAdd 69, 65535, 1  // Pearl AddMenuEntryImm 106, 1
    ListMenuAdd 70, 65535, 2  // Pearl AddMenuEntryImm 107, 2
    ListMenuAdd 71, 65535, 3  // Pearl AddMenuEntryImm 108, 3
    ListMenuAdd 72, 65535, 4  // Pearl AddMenuEntryImm 109, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_8_0470
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_8_047E
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_8_048C
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_8_049A
    pl_GoTo T206_8_0291

T206_8_0470:
    pl_SetVarFromValue PVAR_8004, 0
    pl_GoTo T206_8_04A8

T206_8_047E:
    pl_SetVarFromValue PVAR_8004, 1
    pl_GoTo T206_8_04A8

T206_8_048C:
    pl_SetVarFromValue PVAR_8004, 2
    pl_GoTo T206_8_04A8

T206_8_049A:
    pl_SetVarFromValue PVAR_8004, 3
    pl_GoTo T206_8_04A8

T206_8_04A8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 73  // Pearl bank 203 line 28
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 74, 65535, 0  // Pearl AddMenuEntryImm 110, 0
    ListMenuAdd 75, 65535, 1  // Pearl AddMenuEntryImm 111, 1
    ListMenuAdd 76, 65535, 2  // Pearl AddMenuEntryImm 112, 2
    ListMenuAdd 77, 65535, 3  // Pearl AddMenuEntryImm 113, 3
    ListMenuAdd 78, 65535, 4  // Pearl AddMenuEntryImm 114, 4
    ListMenuAdd 79, 65535, 5  // Pearl AddMenuEntryImm 115, 5
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_8_051C
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_8_052A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_8_0538
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_8_0546
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, T206_8_0554
    pl_GoTo T206_8_0291

T206_8_051C:
    pl_SetVarFromValue PVAR_8005, 0
    pl_GoTo T206_8_0562

T206_8_052A:
    pl_SetVarFromValue PVAR_8005, 1
    pl_GoTo T206_8_0562

T206_8_0538:
    pl_SetVarFromValue PVAR_8005, 2
    pl_GoTo T206_8_0562

T206_8_0546:
    pl_SetVarFromValue PVAR_8005, 3
    pl_GoTo T206_8_0562

T206_8_0554:
    pl_SetVarFromValue PVAR_8005, 4
    pl_GoTo T206_8_0562

T206_8_0562:
    pl_msg_talk 80  // Pearl bank 203 line 20
    pl_msg_talk 81  // Pearl bank 203 line 21
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_4003, 0
    pl_CallIf 1, T206_8_0600
    pl_CompareVarToValue PVAR_4003, 1
    pl_CallIf 1, T206_8_0608
    pl_SetVarFromValue PVAR_800C, 0

T206_8_0596:
    pl_stub OpenPartyMenuForContest  // Pearl 0x194 Unk0194 32780, 32772, 32773, 16388: not translated yet
    pl_stub GetContestPartyMenuResult  // Pearl 0x195 Unk0195 16386, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_8_05C1
    pl_stub SetMonSummary  // Pearl 0x196 Unk0196 16386: not translated yet
    pl_stub GetMonPartySlot  // Pearl 0x197 Unk0197 32780: not translated yet
    pl_GoTo T206_8_0596

T206_8_05C1:
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_4002, 255
    pl_GoToIf 1, T206_8_05E4
    pl_GoTo T206_8_0610

T206_8_05E4:
    pl_msg_talk 82  // Pearl bank 203 line 215
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_8_0291
    pl_GoTo T206_8_0562

T206_8_0600:
    pl_SetVarFromValue PVAR_4004, 0
    pl_Return

T206_8_0608:
    pl_SetVarFromValue PVAR_4004, 1
    pl_Return

T206_8_0610:
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_8_0625
    pl_GoTo T206_8_070D

T206_8_0625:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 83  // Pearl bank 203 line 219
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 30, 1, 0, 1, PVAR_800C
    pl_stub Unk02CF  // Pearl 0x2CF Unk02CF 1: not translated yet
    ListMenuAdd 84, 65535, 0  // Pearl AddMenuEntryImm 13, 0
    ListMenuAdd 85, 65535, 1  // Pearl AddMenuEntryImm 14, 1
    ListMenuAdd 86, 65535, 2  // Pearl AddMenuEntryImm 5, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_8_0669
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_8_06BB
    pl_GoTo T206_8_0291

T206_8_0669:
    pl_msg_talk 87  // Pearl bank 203 line 212
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_8_0625
    pl_CloseMessage
    pl_stub StartBattleClient  // Pearl 0x0F2 Unk00F2 8, 32773, 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_8_06AB
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T206_8_06B3
    pl_GoTo T206_8_070D

T206_8_06AB:
    pl_GoTo T206_8_0625

T206_8_06B3:
    pl_GoTo T206_8_0625

T206_8_06BB:
    pl_msg_talk 87  // Pearl bank 203 line 212
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_8_0625
    pl_CloseMessage
    pl_stub StartBattleServer  // Pearl 0x0F3 Unk00F3 8, 32773, 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T206_8_06FD
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, T206_8_0705
    pl_GoTo T206_8_070D

T206_8_06FD:
    pl_GoTo T206_8_0625

T206_8_0705:
    pl_stub EndCommunication  // Pearl 0x150 Unk0150 : not translated yet
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T206_8_070D:
    pl_stub NewContest  // Pearl 0x0FA Unk00FA 32772, 32773, 32775, 16386: not translated yet
    pl_CompareVarToValue PVAR_4003, 1
    pl_CallIf 1, T206_8_07B5
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_8_078A
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 22: not translated yet
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 64: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 25: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 25: not translated yet
    pl_CloseMessage

T206_8_0761:
    pl_CompareVarToValue PVAR_4003, 0
    pl_GoToIf 1, T206_8_07BC
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_8_07F1
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_8_0830
    VMReturn  // End: the sub-script ends

T206_8_078A:
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 33  // Pearl bank 203 line 177
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_CloseMessage
    pl_GoTo T206_8_0761

T206_8_07B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 34  // Pearl bank 203 line 210
    pl_stub WaitForLinkContestSetup  // Pearl 0x100 Unk0100 : not translated yet
    pl_Return

T206_8_07BC:
    pl_LoadDoorAnimation 77, 19, 5  // the door at cell (0,0) tile (19,5)
    pl_Call T206_8_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_8_0DA0
    pl_ApplyMovement 0, T206_8_0E08
    pl_WaitMovement
    pl_Call T206_8_0115
    pl_WaitMovement
    pl_GoTo T206_8_086A

T206_8_07F1:
    pl_SetFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 5
    pl_LoadDoorAnimation 77, 7, 5  // the door at cell (0,0) tile (7,5)
    pl_Call T206_8_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_8_0DB0
    pl_ApplyMovement 1, T206_8_0E18
    pl_WaitMovement
    pl_Call T206_8_0115
    pl_WaitMovement
    pl_GoTo T206_8_086A

T206_8_0830:
    pl_LoadDoorAnimation 77, 28, 5  // the door at cell (0,0) tile (28,5)
    pl_Call T206_8_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_8_0DC0
    pl_ApplyMovement 2, T206_8_0E28
    pl_WaitMovement
    pl_Call T206_8_0115
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 211: not translated yet
    pl_CloseMessage
    pl_GoTo T206_8_086A

T206_8_086A:
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_8_08CD
    pl_stub ChangeIntoContestAttire  // Pearl 0x0C6 ApplyContestDress : not translated yet
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_8_0892
    pl_GoTo T206_8_08A0

T206_8_0892:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 66: not translated yet
    pl_GoTo T206_8_08AE

T206_8_08A0:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 67: not translated yet
    pl_GoTo T206_8_08AE

T206_8_08AE:
    pl_ApplyMovement PL_PLAYER, T206_8_0E00
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 68: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 26: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 26: not translated yet
    pl_CloseMessage
    pl_GoTo T206_8_0947

T206_8_08CD:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub RunContestApplication  // Pearl 0x101 Unk0101 : not translated yet
    pl_stub GetContestInfo  // Pearl 0x110 Unk0110 32772, 32773, 32775, 16386: not translated yet
    pl_SetVarFromValue PVAR_40CC, 0
    RTReserveScript 15  // the rest of this Pearl script runs there (continuation 15)
    pl_Warp 171, 28, 3, 1  // Pearl map 117 (MAP_HEARTHOME_SUPER_CONTEST_HALL_LOBBY)
    pl_ReleaseAll
    pl_End

T206_8_0947:
    pl_ClearFlag PFLAG_023E
    pl_SetVarFromValue PVAR_40CC, 1
    pl_Call T206_8_0D20
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ClearFlag PFLAG_021F
    pl_ClearFlag PFLAG_0220
    pl_ClearFlag PFLAG_0221
    pl_ClearFlag PFLAG_0222
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub Warp  // to Pearl map 118: no Black 2 zone (not installed)
    pl_ReleaseAll
    pl_End

T206_8_0D20:
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 0, 16416: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 1, 16417: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 2, 16418: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 3, 16419: not translated yet
    pl_Return

    .balign 4, 0
T206_8_0DA0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
T206_8_0DB0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
T206_8_0DC0:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T206_8_0E00:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T206_8_0E08:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
T206_8_0E18:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
T206_8_0E28:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

// ---- Pearl global script 206:9 (a subroutine here)
T206_9_010D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

T206_9_0115:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

T206_9_070D:
    pl_stub NewContest  // Pearl 0x0FA Unk00FA 32772, 32773, 32775, 16386: not translated yet
    pl_CompareVarToValue PVAR_4003, 1
    pl_CallIf 1, T206_9_07B5
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_9_078A
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 22: not translated yet
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 64: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 25: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 25: not translated yet
    pl_CloseMessage

T206_9_0761:
    pl_CompareVarToValue PVAR_4003, 0
    pl_GoToIf 1, T206_9_07BC
    pl_CompareVarToValue PVAR_4003, 1
    pl_GoToIf 1, T206_9_07F1
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_9_0830
    VMReturn  // End: the sub-script ends

T206_9_078A:
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_AddVar PVAR_800C, 1
    pl_stub BufferContestRegistrationEntryNumber  // Pearl 0x0FF Unk00FF 32780, 0: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 33  // Pearl bank 203 line 177
    pl_stub GetContestRegistrationEntryNum  // Pearl 0x109 Unk0109 32780: not translated yet
    pl_stub BufferContestantTrainerName  // Pearl 0x0FD Unk00FD 32780, 0: not translated yet
    pl_stub BufferContestantMonName  // Pearl 0x0FE Unk00FE 32780, 1: not translated yet
    pl_CloseMessage
    pl_GoTo T206_9_0761

T206_9_07B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 34  // Pearl bank 203 line 210
    pl_stub WaitForLinkContestSetup  // Pearl 0x100 Unk0100 : not translated yet
    pl_Return

T206_9_07BC:
    pl_LoadDoorAnimation 77, 19, 5  // the door at cell (0,0) tile (19,5)
    pl_Call T206_9_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_9_0DA0
    pl_ApplyMovement 0, T206_9_0E08
    pl_WaitMovement
    pl_Call T206_9_0115
    pl_WaitMovement
    pl_GoTo T206_9_086A

T206_9_07F1:
    pl_SetFlag PFLAG_0966
    pl_SetVarFromValue PVAR_40D5, 5
    pl_LoadDoorAnimation 77, 7, 5  // the door at cell (0,0) tile (7,5)
    pl_Call T206_9_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_9_0DB0
    pl_ApplyMovement 1, T206_9_0E18
    pl_WaitMovement
    pl_Call T206_9_0115
    pl_WaitMovement
    pl_GoTo T206_9_086A

T206_9_0830:
    pl_LoadDoorAnimation 77, 28, 5  // the door at cell (0,0) tile (28,5)
    pl_Call T206_9_010D
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, T206_9_0DC0
    pl_ApplyMovement 2, T206_9_0E28
    pl_WaitMovement
    pl_Call T206_9_0115
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 211: not translated yet
    pl_CloseMessage
    pl_GoTo T206_9_086A

T206_9_086A:
    pl_CompareVarToValue PVAR_4003, 2
    pl_GoToIf 1, T206_9_08CD
    pl_stub ChangeIntoContestAttire  // Pearl 0x0C6 ApplyContestDress : not translated yet
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_9_0892
    pl_GoTo T206_9_08A0

T206_9_0892:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 66: not translated yet
    pl_GoTo T206_9_08AE

T206_9_08A0:
    pl_BufferPlayerName 0
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 67: not translated yet
    pl_GoTo T206_9_08AE

T206_9_08AE:
    pl_ApplyMovement PL_PLAYER, T206_9_0E00
    pl_WaitMovement
    pl_stub MessageSynchronized  // Pearl 0x02F Unk002F 68: not translated yet
    pl_stub StartContestCommSync  // Pearl 0x0F8 Unk00F8 26: not translated yet
    pl_stub WaitForCommSyncState  // Pearl 0x0F9 Unk00F9 26: not translated yet
    pl_CloseMessage
    pl_GoTo T206_9_0947

T206_9_08CD:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub RunContestApplication  // Pearl 0x101 Unk0101 : not translated yet
    pl_stub GetContestInfo  // Pearl 0x110 Unk0110 32772, 32773, 32775, 16386: not translated yet
    pl_SetVarFromValue PVAR_40CC, 0
    RTReserveScript 15  // the rest of this Pearl script runs there (continuation 15)
    pl_Warp 171, 28, 3, 1  // Pearl map 117 (MAP_HEARTHOME_SUPER_CONTEST_HALL_LOBBY)
    pl_ReleaseAll
    pl_End

T206_9_0947:
    pl_ClearFlag PFLAG_023E
    pl_SetVarFromValue PVAR_40CC, 1
    pl_Call T206_9_0D20
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_ClearFlag PFLAG_021F
    pl_ClearFlag PFLAG_0220
    pl_ClearFlag PFLAG_0221
    pl_ClearFlag PFLAG_0222
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub Warp  // to Pearl map 118: no Black 2 zone (not installed)
    pl_ReleaseAll
    pl_End

T206_9_0D20:
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 0, 16416: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 1, 16417: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 2, 16418: not translated yet
    pl_stub GetContestantObjEventGFX  // Pearl 0x10A Unk010A 3, 16419: not translated yet
    pl_Return

T206_9_S9:
T206_9_0E74:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetVarFromValue PVAR_4003, 2
    pl_SetVarFromValue PVAR_8004, 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 89  // Pearl bank 203 line 111
    pl_GoTo T206_9_0E93

T206_9_0E93:
    pl_msg_talk 90  // Pearl bank 203 line 112
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 91, 65535, 0  // Pearl AddMenuEntryImm 113, 0
    ListMenuAdd 92, 65535, 1  // Pearl AddMenuEntryImm 114, 1
    ListMenuAdd 93, 65535, 2  // Pearl AddMenuEntryImm 115, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_9_0EE1
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_9_1169
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_9_138E
    pl_GoTo T206_9_138E

T206_9_0EE1:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 94, 65535, 0  // Pearl AddMenuEntryImm 155, 0
    ListMenuAdd 95, 65535, 1  // Pearl AddMenuEntryImm 156, 1
    ListMenuAdd 96, 65535, 2  // Pearl AddMenuEntryImm 157, 2
    ListMenuAdd 97, 65535, 3  // Pearl AddMenuEntryImm 158, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_9_0F30
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_9_0F44
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_9_0F5E
    pl_GoTo T206_9_0F72

T206_9_0F30:
    pl_SetVarFromValue PVAR_4004, 0
    pl_SetVarFromValue PVAR_8007, 3
    pl_GoTo T206_9_1027

T206_9_0F44:
    pl_SetVarFromValue PVAR_4004, 1
    pl_SetVarFromValue PVAR_8005, 0
    pl_SetVarFromValue PVAR_8007, 5
    pl_GoTo T206_9_1027

T206_9_0F5E:
    pl_SetVarFromValue PVAR_4004, 0
    pl_SetVarFromValue PVAR_8007, 7
    pl_GoTo T206_9_1027

T206_9_0F72:
    pl_msg_talk 98  // Pearl bank 203 line 159
    pl_WaitButton
    pl_GoTo T206_9_1393

T206_9_1027:
    pl_CompareVarToValue PVAR_4004, 1
    pl_GoToIf 1, T206_9_1101
    pl_GoTo T206_9_103A

T206_9_103A:
    pl_msg_talk 99  // Pearl bank 203 line 160
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 100, 65535, 0  // Pearl AddMenuEntryImm 161, 0
    ListMenuAdd 101, 65535, 1  // Pearl AddMenuEntryImm 162, 1
    ListMenuAdd 102, 65535, 2  // Pearl AddMenuEntryImm 163, 2
    ListMenuAdd 103, 65535, 3  // Pearl AddMenuEntryImm 164, 3
    ListMenuAdd 104, 65535, 4  // Pearl AddMenuEntryImm 165, 4
    ListMenuAdd 105, 65535, 5  // Pearl AddMenuEntryImm 166, 5
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_9_10AE
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_9_10BC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_9_10CA
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_9_10D8
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, T206_9_10E6
    pl_GoTo T206_9_10F4

T206_9_10AE:
    pl_SetVarFromValue PVAR_8005, 0
    pl_GoTo T206_9_1101

T206_9_10BC:
    pl_SetVarFromValue PVAR_8005, 1
    pl_GoTo T206_9_1101

T206_9_10CA:
    pl_SetVarFromValue PVAR_8005, 2
    pl_GoTo T206_9_1101

T206_9_10D8:
    pl_SetVarFromValue PVAR_8005, 3
    pl_GoTo T206_9_1101

T206_9_10E6:
    pl_SetVarFromValue PVAR_8005, 4
    pl_GoTo T206_9_1101

T206_9_10F4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 106  // Pearl bank 203 line 167
    pl_WaitButton
    pl_GoTo T206_9_1393

T206_9_1101:
    pl_msg_talk 107  // Pearl bank 203 line 175
    pl_msg_talk 108  // Pearl bank 203 line 176
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_800C, 0

T206_9_111B:
    pl_stub OpenPartyMenuForContest  // Pearl 0x194 Unk0194 32780, 32772, 32773, 0: not translated yet
    pl_stub GetContestPartyMenuResult  // Pearl 0x195 Unk0195 16386, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T206_9_1146
    pl_stub SetMonSummary  // Pearl 0x196 Unk0196 16386: not translated yet
    pl_stub GetMonPartySlot  // Pearl 0x197 Unk0197 32780: not translated yet
    pl_GoTo T206_9_111B

T206_9_1146:
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_4002, 255
    pl_GoToIf 1, T206_9_10F4
    pl_GoTo T206_9_070D

T206_9_1169:
    pl_msg_talk 57  // Pearl bank 203 line 117

T206_9_116C:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 109, 65535, 0  // Pearl AddMenuEntryImm 121, 0
    ListMenuAdd 110, 65535, 1  // Pearl AddMenuEntryImm 118, 1
    ListMenuAdd 111, 65535, 2  // Pearl AddMenuEntryImm 119, 2
    ListMenuAdd 112, 65535, 3  // Pearl AddMenuEntryImm 120, 3
    ListMenuAdd 113, 65535, 4  // Pearl AddMenuEntryImm 122, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_9_1375
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_9_11CF
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_9_124A
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_9_12E1
    pl_GoTo T206_9_0E93

T206_9_11CC:
    pl_msg_talk 57  // Pearl bank 203 line 117

T206_9_11CF:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 114, 65535, 0  // Pearl AddMenuEntryImm 125, 0
    ListMenuAdd 115, 65535, 1  // Pearl AddMenuEntryImm 126, 1
    ListMenuAdd 116, 65535, 2  // Pearl AddMenuEntryImm 127, 2
    ListMenuAdd 117, 65535, 3  // Pearl AddMenuEntryImm 129, 3
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_9_121E
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_9_1229
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_9_1234
    pl_GoTo T206_9_123F

T206_9_121E:
    pl_msg_talk 118  // Pearl bank 203 line 130
    pl_GoTo T206_9_11CC

T206_9_1229:
    pl_msg_talk 119  // Pearl bank 203 line 131
    pl_GoTo T206_9_11CC

T206_9_1234:
    pl_msg_talk 120  // Pearl bank 203 line 132
    pl_GoTo T206_9_11CC

T206_9_123F:
    pl_GoTo T206_9_116C

T206_9_1247:
    pl_msg_talk 57  // Pearl bank 203 line 117

T206_9_124A:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 121, 65535, 0  // Pearl AddMenuEntryImm 135, 0
    ListMenuAdd 122, 65535, 1  // Pearl AddMenuEntryImm 136, 1
    ListMenuAdd 123, 65535, 2  // Pearl AddMenuEntryImm 137, 2
    ListMenuAdd 124, 65535, 3  // Pearl AddMenuEntryImm 138, 3
    ListMenuAdd 125, 65535, 4  // Pearl AddMenuEntryImm 139, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_9_12AA
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_9_12B5
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_9_12C0
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_9_12CB
    pl_GoTo T206_9_12D6

T206_9_12AA:
    pl_msg_talk 126  // Pearl bank 203 line 140
    pl_GoTo T206_9_1247

T206_9_12B5:
    pl_msg_talk 127  // Pearl bank 203 line 141
    pl_GoTo T206_9_1247

T206_9_12C0:
    pl_msg_talk 128  // Pearl bank 203 line 142
    pl_GoTo T206_9_1247

T206_9_12CB:
    pl_msg_talk 129  // Pearl bank 203 line 143
    pl_GoTo T206_9_1247

T206_9_12D6:
    pl_GoTo T206_9_116C

T206_9_12DE:
    pl_msg_talk 57  // Pearl bank 203 line 117

T206_9_12E1:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitLocalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 130, 65535, 0  // Pearl AddMenuEntryImm 145, 0
    ListMenuAdd 131, 65535, 1  // Pearl AddMenuEntryImm 146, 1
    ListMenuAdd 132, 65535, 2  // Pearl AddMenuEntryImm 147, 2
    ListMenuAdd 133, 65535, 3  // Pearl AddMenuEntryImm 148, 3
    ListMenuAdd 134, 65535, 4  // Pearl AddMenuEntryImm 149, 4
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T206_9_1341
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T206_9_134C
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T206_9_1357
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T206_9_1362
    pl_GoTo T206_9_136D

T206_9_1341:
    pl_msg_talk 135  // Pearl bank 203 line 150
    pl_GoTo T206_9_12DE

T206_9_134C:
    pl_msg_talk 136  // Pearl bank 203 line 151
    pl_GoTo T206_9_12DE

T206_9_1357:
    pl_msg_talk 137  // Pearl bank 203 line 152
    pl_GoTo T206_9_12DE

T206_9_1362:
    pl_msg_talk 138  // Pearl bank 203 line 153
    pl_GoTo T206_9_12DE

T206_9_136D:
    pl_GoTo T206_9_116C

T206_9_1375:
    pl_msg_talk 139  // Pearl bank 203 line 124
    pl_msg_talk 57  // Pearl bank 203 line 117
    pl_GoTo T206_9_116C

T206_9_138E:
    pl_msg_talk 35  // Pearl bank 203 line 116
    pl_WaitButton

T206_9_1393:
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

    .balign 4, 0
T206_9_0DA0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
T206_9_0DB0:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
T206_9_0DC0:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T206_9_0E00:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
T206_9_0E08:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
T206_9_0E18:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
T206_9_0E28:
    Move 63, 2  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

// ---- Pearl global script 206:13 (a subroutine here)
C206_13_S13:
C206_13_1399:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub ShowLinkContestRecords  // Pearl 0x116 Unk0116 : not translated yet
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 1042:7 (a subroutine here)
T1042_7_S7:
T1042_7_007E:
    pl_SetVarFromValue PVAR_8000, 7
    pl_GoTo T1042_7_00D2

T1042_7_00D2:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub CheckTVInterviewEligible  // Pearl 0x238 Unk0238 32768, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_7_0214
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 140  // Pearl bank 562 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_7_0107
    pl_GoTo T1042_7_021F

T1042_7_0107:
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 0, 32768, 32772, 32773: not translated yet
    pl_stub MessageFromBank  // PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8000, 10
    pl_GoToIf 1, T1042_7_0165
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32772: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T1042_7_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_7_0214

T1042_7_0165:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitLocalTextListMenu 1, 1, 0, 1, PVAR_8004
    ListMenuAdd 141, 65535, 255  // Pearl AddListMenuEntry 16, 255
    ListMenuAdd 142, 65535, 255  // Pearl AddListMenuEntry 17, 255
    ListMenuAdd 143, 65535, 255  // Pearl AddListMenuEntry 18, 255
    ListMenuAdd 144, 65535, 255  // Pearl AddListMenuEntry 19, 255
    ListMenuAdd 145, 65535, 255  // Pearl AddListMenuEntry 20, 255
    ListMenuAdd 146, 65535, 255  // Pearl AddListMenuEntry 21, 255
    ListMenuAdd 147, 65535, 255  // Pearl AddListMenuEntry 22, 255
    ListMenuAdd 148, 65535, 255  // Pearl AddListMenuEntry 23, 255
    ListMenuAdd 149, 65535, 255  // Pearl AddListMenuEntry 24, 255
    ListMenuAdd 150, 65535, 255  // Pearl AddListMenuEntry 25, 255
    ListMenuAdd 151, 65535, 255  // Pearl AddListMenuEntry 26, 255
    ListMenuAdd 152, 65535, 255  // Pearl AddListMenuEntry 27, 255
    ListMenuAdd 153, 65535, 255  // Pearl AddListMenuEntry 28, 255
    ListMenuAdd 154, 65535, 255  // Pearl AddListMenuEntry 29, 255
    ListMenuAdd 155, 65535, 255  // Pearl AddListMenuEntry 30, 255
    ListMenuAdd 156, 65535, 255  // Pearl AddListMenuEntry 31, 255
    ListMenuAdd 157, 65535, 255  // Pearl AddListMenuEntry 32, 255
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 65534
    pl_GoToIf 1, T1042_7_021F
    pl_stub CallTVInterview  // Pearl 0x237 Unk0237 1, 32768, 32772, 32773: not translated yet
    pl_GoTo T1042_7_0214

T1042_7_0214:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 158  // Pearl bank 562 line 2
    pl_WaitButton
    pl_GoTo T1042_7_022A

T1042_7_021F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 159  // Pearl bank 562 line 1
    pl_WaitButton
    pl_GoTo T1042_7_022A

T1042_7_022A:
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

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
    pl_msg_sys 160  // Pearl bank 199 line 13
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
    pl_msg_sys 161  // Pearl bank 199 line 20
    pl_WaitABPress
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_04E1:
    pl_msg_sys 162  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E

C205_7_04F5:
    pl_msg_sys 163  // Pearl bank 199 line 21
    pl_GoTo C205_7_051B

C205_7_04FE:
    pl_msg_sys 162  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_msg_sys 164  // Pearl bank 199 line 15
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
    pl_msg_sys 165  // Pearl bank 199 line 16
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
    pl_msg_sys 166  // Pearl bank 199 line 18
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
