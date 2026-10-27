// MAP_SANDGEM_ROWANS_LAB: Pearl script file 990, text bank 509. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-14: Pearl's; 15: after a Warp; 16: PearlArrive; 105: Pearl 10300
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P990_S1
    ScriptEntry P990_S2
    ScriptEntry P990_S3
    ScriptEntry P990_S4
    ScriptEntry P990_S5
    ScriptEntry P990_S6
    ScriptEntry P990_S7
    ScriptEntry P990_S8
    ScriptEntry P990_S9
    ScriptEntry P990_S10
    ScriptEntry P990_S11
    ScriptEntry P990_S12
    ScriptEntry P990_S13
    ScriptEntry P990_S14
    ScriptEntry W985_0389_S
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
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10300
    ScriptEntriesEnd

P990_S1:
P990_003A:
    pl_End

P990_S3:
P990_003C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_0621
    pl_CheckFlag PFLAG_09BA
    pl_GoToIf 0, P990_0072
    pl_CheckLocalDexCompletedOrChampion PVAR_800C  // the National Pokédex at Champion (NATIONAL_DEX_AT_CHAMPION)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_0487

P990_0072:
    pl_CompareVarToValue PVAR_4071, 2
    pl_GoToIf 4, P990_008D
    pl_BufferPlayerName 0
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_008D:
    VMCall C376_1_S1  // CallCommonScript 9950 (Pearl file 376 script 1)
    pl_End

P990_S4:
P990_0093:
    pl_End

P990_S2:
P990_0095:
    pl_LockAll
    pl_ApplyMovement 3, P990_0338
    pl_ApplyMovement PL_PLAYER, P990_035C
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 0
    pl_ApplyMovement 0, P990_0328
    pl_WaitMovement
    pl_SetVarFromValue PVAR_8004, 0
    pl_GetPartyMonSpecies PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 387
    pl_GoToIf 1, P990_00F8
    pl_CompareVarToValue PVAR_8008, 390
    pl_GoToIf 1, P990_00F8
    pl_CompareVarToValue PVAR_8008, 393
    pl_GoToIf 1, P990_00F8
    pl_GoTo P990_0101

P990_00F8:
    pl_msg_sys 1
    pl_GoTo P990_010A

P990_0101:
    pl_msg_sys 2
    pl_GoTo P990_010A

P990_010A:
    pl_BufferPartyMonSpecies 0, 0
    pl_msg_sys 3
    pl_msg_sys 4
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_0170
    pl_GoTo P990_012E

P990_012E:
    pl_SetVarFromValue PVAR_800C, 0
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_OpenPokemonNamingScreen 0, PVAR_800C
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_msg_sys 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_012E
    pl_GoTo P990_0170

P990_0170:
    pl_BufferPartyMonSpecies 0, 0
    pl_BufferRivalName 1
    pl_msg_sys 6
    pl_CloseMessage
    pl_ApplyMovement 3, P990_034C
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P990_0370
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P990_01B0
    pl_GoTo P990_01CA

P990_01B0:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 7
    pl_CloseMessage
    pl_ApplyMovement 3, P990_0384
    pl_WaitMovement
    pl_GoTo P990_01E4

P990_01CA:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 8
    pl_CloseMessage
    pl_ApplyMovement 3, P990_0384
    pl_WaitMovement
    pl_GoTo P990_01E4

P990_01E4:
    pl_FadeOutBGM 40  // FadeOutBGM to volume 0
    pl_ApplyMovement 0, P990_0330
    pl_ApplyMovement PL_PLAYER, P990_0368
    pl_WaitMovement
    pl_WaitTime 35, PVAR_800C
    pl_SetFlag PFLAG_0993
    #ifdef SEQ_PEARL_OPENING2
        pl_PlayMusic SEQ_PEARL_OPENING2  // Pearl SEQ_OPENING2
    #else
        pl_stub PlayMusic  // Pearl sound SEQ_OPENING2: no Black 2 stand-in
    #endif
    pl_msg_sys 9
    pl_msg_sys 10
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_0229
    pl_GoTo P990_0248

P990_0229:
    pl_BufferPlayerName 0
    pl_msg_sys 11
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_0229
    pl_GoTo P990_0248

P990_0248:
    pl_msg_sys 12
    pl_GivePokedex
    pl_SetFlag PFLAG_0090
    pl_BufferPlayerName 0
    pl_msg_sys 13
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_BufferPlayerName 0
    pl_msg_sys 14
    pl_CloseMessage
    pl_ApplyMovement 3, P990_0354
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P990_028E
    pl_GoTo P990_029C

P990_028E:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 15
    pl_GoTo P990_02AA

P990_029C:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 16
    pl_GoTo P990_02AA

P990_02AA:
    pl_BufferPlayerName 0
    pl_msg_sys 17
    pl_CloseMessage
    pl_ApplyMovement 3, P990_0354
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P990_0370
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P990_02DF
    pl_GoTo P990_02F0

P990_02DF:
    pl_BufferPlayerName 0
    pl_BufferCounterpartStarterSpeciesName 1
    pl_msg_sys 19
    pl_GoTo P990_0301

P990_02F0:
    pl_BufferPlayerName 0
    pl_BufferRivalStarterSpeciesName 1
    pl_msg_sys 20
    pl_GoTo P990_0301

P990_0301:
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P990_0378
    pl_ApplyMovement 3, P990_038C
    pl_WaitMovement
    pl_RemoveObject 3, PFLAG_01B7
    pl_ClearFlag PFLAG_0195
    pl_SetVarFromValue PVAR_40A6, 1
    pl_ReleaseAll
    pl_End

P990_S5:
P990_0394:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_03BC
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_talk_gendered 52, 53  // Pearl line 21, naming the counterpart: Dawn (boy) / Lucas (girl)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_03BC:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_talk_gendered 54, 55  // Pearl line 50, naming the counterpart: Dawn (boy) / Lucas (girl)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S6:
P990_03CA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_03EF
    pl_msg_talk 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_03EF:
    pl_msg_talk 51
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S7:
P990_03FA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S8:
P990_040D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 24
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S9:
P990_041E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 25
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S10:
P990_042F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S11:
P990_0440:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S12:
P990_0451:
    pl_BufferPlayerName 0
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 47
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S13:
P990_0465:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 48
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_S14:
P990_0476:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 49
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_0487:
    pl_CheckFlag PFLAG_0110
    pl_GoToIf 1, P990_049A
    pl_GoTo P990_04AA

P990_049A:
    pl_BufferPlayerName 0
    pl_msg_talk 32
    pl_CloseMessage
    pl_GoTo P990_04F0

P990_04AA:
    pl_BufferPlayerName 0
    pl_msg_talk 28
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P990_04C9
    pl_GoTo P990_04D4

P990_04C9:
    pl_msg_talk 30
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_04D4:
    pl_GetLocalDexSeenCount PVAR_800C
    pl_BufferNumber 0, PVAR_800C
    pl_msg_talk 29
    pl_BufferPlayerName 0
    pl_msg_talk 31
    pl_CloseMessage
    pl_GoTo P990_04F0

P990_04F0:
    pl_GetPlayerDir PVAR_8007
    pl_CompareVarToValue PVAR_8007, 0
    pl_CallIf 1, P990_062C
    pl_CompareVarToValue PVAR_8007, 1
    pl_CallIf 1, P990_062E
    pl_CompareVarToValue PVAR_8007, 2
    pl_CallIf 1, P990_0642
    pl_CompareVarToValue PVAR_8007, 3
    pl_CallIf 1, P990_0656
    pl_ClearFlag PFLAG_0248
    pl_AddObject 4
    pl_ApplyMovement PL_PLAYER, P990_06CC
    pl_ApplyMovement 4, P990_06F8
    pl_ApplyMovement 0, P990_0678
    pl_WaitMovement
    pl_msg_actor 33, 4
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 34
    pl_CloseMessage
    pl_ApplyMovement 0, P990_0680
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_msg_talk 35
    pl_CloseMessage
    pl_ApplyMovement 4, P990_0700
    pl_ApplyMovement PL_PLAYER, P990_06E0
    pl_WaitMovement
    pl_msg_actor 36, 4
    pl_CheckFlag PFLAG_0964
    pl_CallIf 1, P990_0610
    pl_ClearFlag PFLAG_021A
    pl_SetFlag PFLAG_02B2
    pl_SetNationalDex
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37
    pl_WaitFanfare
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_actor 38, 4
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 39
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_actor 40, 4
    pl_BufferPlayerName 0
    pl_GetPlayerGender PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P990_0617
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P990_061C
    pl_CloseMessage
    pl_ApplyMovement 4, P990_070C
    pl_WaitMovement
    pl_RemoveObject 4, PFLAG_0248
    pl_msg_talk 43
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement PL_PLAYER, P990_06EC
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_talk 44
    pl_SetVarFromValue PVAR_8004, 431
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 45
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_0610:
    pl_SetHiddenLocation 2  // SetHiddenLocation 2: Black 2's map replacement
    pl_Return

P990_0617:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_actor 41, 4
    pl_Return

P990_061C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_actor 42, 4
    pl_Return

P990_0621:
    pl_msg_talk 46
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P990_062C:
    pl_Return

P990_062E:
    pl_ApplyMovement PL_PLAYER, P990_0698
    pl_ApplyMovement 0, P990_066C
    pl_WaitMovement
    pl_Return

P990_0642:
    pl_ApplyMovement PL_PLAYER, P990_06AC
    pl_ApplyMovement 0, P990_066C
    pl_WaitMovement
    pl_Return

P990_0656:
    pl_ApplyMovement PL_PLAYER, P990_06BC
    pl_ApplyMovement 0, P990_066C
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P990_0328:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P990_0330:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P990_0338:
    Move 65, 1  // DELAY_16
    Move 12, 8  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P990_034C:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P990_0354:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P990_035C:
    Move 65, 1  // DELAY_16
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_0368:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_0370:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P990_0378:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P990_0384:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P990_038C:
    Move 13, 8  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P990_066C:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P990_0678:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P990_0680:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 63, 2  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P990_0698:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_06AC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_06BC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_06CC:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 5  // DELAY_8
    Move 14, 1  // WALK_NORMAL_WEST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P990_06E0:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P990_06EC:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_06F8:
    Move 12, 7  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_0700:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P990_070C:
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

// ---- continuation 15: after the Warp at 985:0389 (MAP_SANDGEM)
W985_0389_S:
W985_0389_0395:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlProxy_10300:                  // Pearl global script 10300 (run by this zone's events)
    VMCall T977_1_S1
    VMHalt

// ---- Pearl global script 376:1 (a subroutine here)
C376_1_S1:
C376_1_000E:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 56  // Pearl bank 335 line 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C376_1_002D
    pl_GoTo C376_1_003A

C376_1_002D:
    pl_msg_sys 57  // Pearl bank 335 line 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C376_1_003A:
    pl_Call C376_1_00E4
    pl_CloseMessage
    pl_ReleaseAll
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C376_1_00E4:
    pl_CheckFlag PFLAG_09BA
    pl_GoToIf 0, C376_1_0100
    pl_CheckLocalDexCompleted PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C376_1_011C

C376_1_0100:
    pl_GetLocalDexSeenCount PVAR_8004
    pl_BufferNumber 0, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 58  // Pearl bank 335 line 1
    pl_LoadPokedexRatingLocal PVAR_800C, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69  // Pearl bank 335 lines 4-14
    pl_BufferPlayerName 0
    pl_msg_sys PVAR_800C
    pl_WaitABPress
    pl_Return

C376_1_011C:
    pl_SetFlag PFLAG_0110
    pl_Return

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
    pl_msg_sys 70  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 71  // Pearl bank 199 line 28
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
    pl_msg_sys 72  // Pearl bank 199 line 25
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
    pl_msg_sys 73  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 74  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 75  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 76  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 77  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 78  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 79  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 80  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 977:1 (a subroutine here)
T977_1_S1:
T977_1_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerGender PVAR_8004
    WorkSetConst PVAR_800C, 0  // CheckIsTodayPlayerBirthday: not checked
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_00E0
    pl_CheckLocalDexCompletedOrChampion PVAR_800C  // the National Pokédex at Champion (NATIONAL_DEX_AT_CHAMPION)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_005D
    pl_CheckFlag PFLAG_0145
    pl_GoToIf 0, T977_1_0239
    pl_CheckFlag PFLAG_015F
    pl_GoToIf 1, T977_1_02B5
    pl_CompareVarToValue PVAR_4098, 5
    pl_GoToIf 5, T977_1_02B5
    pl_GoTo T977_1_025E

T977_1_005D:
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T977_1_0214
    pl_CheckFlag PFLAG_00F0
    pl_GoToIf 0, T977_1_01EF
    pl_CheckFlag PFLAG_0131
    pl_GoToIf 0, T977_1_01CA
    PokeDexIsComplete PVAR_800C, 1  // CheckNationalDexCompleted (Black 2's National Dex)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_0105
    pl_GoTo T977_1_009E

T977_1_009E:
    pl_GetRandom PVAR_800C, 4
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T977_1_01A1
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T977_1_0178
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, T977_1_014F
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, T977_1_012A
    VMReturn  // End: the sub-script ends

T977_1_00E0:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_02E2
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_030F
    pl_GoTo T977_1_02DA

T977_1_0105:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_03A0
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_03A5
    pl_GoTo T977_1_02DA

T977_1_012A:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0396
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_039B
    pl_GoTo T977_1_02DA

T977_1_014F:
    pl_SetFlag PFLAG_0148
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_038C
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0391
    pl_GoTo T977_1_02DA

T977_1_0178:
    pl_SetFlag PFLAG_0147
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0382
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0387
    pl_GoTo T977_1_02DA

T977_1_01A1:
    pl_SetFlag PFLAG_0146
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0378
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_037D
    pl_GoTo T977_1_02DA

T977_1_01CA:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_036E
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0373
    pl_GoTo T977_1_02DA

T977_1_01EF:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0364
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0369
    pl_GoTo T977_1_02DA

T977_1_0214:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_035A
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_035F
    pl_GoTo T977_1_02DA

T977_1_0239:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0350
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0355
    pl_GoTo T977_1_02DA

T977_1_025E:
    pl_BufferPlayerName 0
    WorkSetConst PVAR_800C, 11  // GetGameVersion: Pearl (pokediamond VERSION_PEARL 11)
    pl_CompareVarToValue PVAR_800C, 10
    pl_CallIf 1, T977_1_02A1
    pl_CompareVarToValue PVAR_800C, 11
    pl_CallIf 1, T977_1_02AB
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_0346
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_034B
    pl_GoTo T977_1_02DA

T977_1_02A1:
    pl_BufferSpeciesName 1, 483
    pl_Return

T977_1_02AB:
    pl_BufferSpeciesName 1, 484
    pl_Return

T977_1_02B5:
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, T977_1_033C
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, T977_1_0341
    pl_GoTo T977_1_02DA

T977_1_02DA:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T977_1_02E2:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 81  // Pearl bank 496 line 10
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T977_1_0305
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_030A
    VMReturn  // End: the sub-script ends

T977_1_0305:
    pl_msg_talk 82  // Pearl bank 496 line 11
    pl_Return

T977_1_030A:
    pl_msg_talk 83  // Pearl bank 496 line 12
    pl_Return

T977_1_030F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 84  // Pearl bank 496 line 24
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T977_1_0332
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T977_1_0337
    VMReturn  // End: the sub-script ends

T977_1_0332:
    pl_msg_talk 85  // Pearl bank 496 line 25
    pl_Return

T977_1_0337:
    pl_msg_talk 86  // Pearl bank 496 line 26
    pl_Return

T977_1_033C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 87  // Pearl bank 496 line 13
    pl_Return

T977_1_0341:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 88  // Pearl bank 496 line 27
    pl_Return

T977_1_0346:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 89  // Pearl bank 496 line 0
    pl_Return

T977_1_034B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 90  // Pearl bank 496 line 14
    pl_Return

T977_1_0350:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 91  // Pearl bank 496 line 1
    pl_Return

T977_1_0355:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 92  // Pearl bank 496 line 15
    pl_Return

T977_1_035A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 93  // Pearl bank 496 line 2
    pl_Return

T977_1_035F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 94  // Pearl bank 496 line 16
    pl_Return

T977_1_0364:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 95  // Pearl bank 496 line 3
    pl_Return

T977_1_0369:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 96  // Pearl bank 496 line 17
    pl_Return

T977_1_036E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 97  // Pearl bank 496 line 4
    pl_Return

T977_1_0373:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 98  // Pearl bank 496 line 18
    pl_Return

T977_1_0378:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 99  // Pearl bank 496 line 5
    pl_Return

T977_1_037D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 100  // Pearl bank 496 line 19
    pl_Return

T977_1_0382:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 101  // Pearl bank 496 line 6
    pl_Return

T977_1_0387:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 102  // Pearl bank 496 line 20
    pl_Return

T977_1_038C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 103  // Pearl bank 496 line 7
    pl_Return

T977_1_0391:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 104  // Pearl bank 496 line 21
    pl_Return

T977_1_0396:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 105  // Pearl bank 496 line 8
    pl_Return

T977_1_039B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 106  // Pearl bank 496 line 22
    pl_Return

T977_1_03A0:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 107  // Pearl bank 496 line 9
    pl_Return

T977_1_03A5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 108  // Pearl bank 496 line 23
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
