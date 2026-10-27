// MAP_ROUTE_221_PAL_PARK_ENTRANCE: Pearl script file 444, text bank 464. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-13: Pearl's; 14: after a Warp; 15: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P444_S1
    ScriptEntry P444_S2
    ScriptEntry P444_S3
    ScriptEntry P444_S4
    ScriptEntry P444_S5
    ScriptEntry P444_S6
    ScriptEntry P444_S7
    ScriptEntry P444_S8
    ScriptEntry P444_S9
    ScriptEntry P444_S10
    ScriptEntry P444_S11
    ScriptEntry P444_S12
    ScriptEntry P444_S13
    ScriptEntry W265_01D0_S
    ScriptEntry PearlArrive
    ScriptEntry RamanasExtra_clerk
    ScriptEntry RamanasExtra_return
    ScriptEntriesEnd

P444_S1:
P444_0036:
    pl_ClearFlag PFLAG_0995
    pl_SetFlag PFLAG_09F3
    pl_CompareVarToValue PVAR_40F3, 0
    pl_GoToIf 5, P444_004D
    pl_End

P444_004D:
    pl_SetObjectEventPos 7, 8, 9, 1, -1  // object 7
    pl_SetObjectEventPos 7, 8, 9, 2, -1  // SetObjectEventDir 7 (at the place SetObjectEventPos just gave)
    pl_End

P444_005D:
    pl_CompareVarToValue PVAR_40E0, 2000
    pl_GoToIf 1, P444_0074
    pl_BufferPlayerName 1
    pl_BufferNumber 2, PVAR_40E0
    pl_Return

P444_0074:
    pl_BufferRivalName 1
    pl_BufferNumber 2, PVAR_40E0
    pl_Return

P444_S2:
P444_007E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_009D
    pl_GoTo P444_00D2

P444_009D:
    pl_CheckFlag PFLAG_00D3
    pl_GoToIf 1, P444_01D6
    pl_SetFlag PFLAG_00D3
    pl_BufferPlayerName 0
    pl_msg_talk 21
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_0107
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_01CB
    pl_End

P444_00D2:
    pl_CheckFlag PFLAG_00D3
    pl_GoToIf 1, P444_01E2
    pl_SetFlag PFLAG_00D3
    pl_BufferPlayerName 0
    pl_msg_talk 22
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_0107
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_01CB
    pl_End

P444_0107:
    pl_msg_talk 23
    pl_GoTo P444_012B

P444_0110:
    pl_msg_talk 24
    pl_GoTo P444_012B

P444_0119:
    pl_msg_talk 25
    pl_GoTo P444_012B

P444_0122:
    pl_msg_talk 26
    pl_GoTo P444_012B

P444_012B:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 75, 65535, 0  // Pearl AddMenuEntryImm 198, 0
    ListMenuAdd 76, 65535, 1  // Pearl AddMenuEntryImm 199, 1
    ListMenuAdd 77, 65535, 2  // Pearl AddMenuEntryImm 200, 2
    ListMenuAdd 78, 65535, 4  // Pearl AddMenuEntryImm 202, 4
    ListMenuShow
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_0110
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_0119
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P444_0122
    pl_GoTo P444_0172

P444_0172:
    pl_msg_talk 28
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_01CB

P444_0186:
    pl_SetVarFromValue PVAR_800C, 0
    BoxGetCount PVAR_800C, 5  // Pearl CountPCFreeSpace: free PC box slots
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 0, P444_02AD
    pl_SetVarFromValue PVAR_800C, 0
    pl_CheckHasEnoughMonForCatchingShow PVAR_800C
// Pal Park's migration (b2tools/palpark_offer.py): none stocked and a GBA game in slot 2 -> Pearl's question
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, .Lpp1a3_done
    pl_GetGBACartridgeAndName PL_TMP, 1
    pl_CompareVarToValue PL_TMP, 0
    pl_GoToIf 1, .Lpp1a3_done
    pl_CompareVarToValue PL_TMP, 1
    pl_GoToIf 1, .Lpp1a3_v1
    pl_CompareVarToValue PL_TMP, 2
    pl_GoToIf 1, .Lpp1a3_v2
    pl_CompareVarToValue PL_TMP, 3
    pl_GoToIf 1, .Lpp1a3_v3
    pl_CompareVarToValue PL_TMP, 4
    pl_GoToIf 1, .Lpp1a3_v4
    pl_CompareVarToValue PL_TMP, 5
    pl_GoToIf 1, .Lpp1a3_v5
    pl_GoTo .Lpp1a3_done
.Lpp1a3_v1:
    pl_msg_talk 79
    pl_GoTo .Lpp1a3_ask
.Lpp1a3_v2:
    pl_msg_talk 80
    pl_GoTo .Lpp1a3_ask
.Lpp1a3_v3:
    pl_msg_talk 81
    pl_GoTo .Lpp1a3_ask
.Lpp1a3_v4:
    pl_msg_talk 82
    pl_GoTo .Lpp1a3_ask
.Lpp1a3_v5:
    pl_msg_talk 83
    pl_GoTo .Lpp1a3_ask
.Lpp1a3_ask:
    pl_ShowYesNoMenu PL_TMP
    pl_CompareVarToValue PL_TMP, 0
    pl_GoToIf 5, .Lpp1a3_no
    pl_CloseMessage
    pl_PalParkMigrate PVAR_800C
    pl_GoTo .Lpp1a3_done
.Lpp1a3_no:
    pl_CloseMessage
.Lpp1a3_done:
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_0299
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_0231
    pl_GoTo P444_0245

P444_01CB:
    pl_msg_talk 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_01D6:
    pl_BufferPlayerName 0
    pl_msg_talk 30
    pl_GoTo P444_01EE

P444_01E2:
    pl_BufferPlayerName 0
    pl_msg_talk 31
    pl_GoTo P444_01EE

P444_01EE:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 84, 65535, 0  // Pearl AddMenuEntryImm 203, 0
    ListMenuAdd 85, 65535, 1  // Pearl AddMenuEntryImm 204, 1
    ListMenuAdd 86, 65535, 2  // Pearl AddMenuEntryImm 205, 2
    ListMenuShow
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_0186
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_02A4
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P444_01CB
    pl_GoTo P444_01CB

P444_0231:
    pl_Call P444_005D
    pl_BufferPlayerName 0
    pl_msg_talk 32
    pl_CloseMessage
    pl_GoTo P444_0259

P444_0245:
    pl_Call P444_005D
    pl_BufferPlayerName 0
    pl_msg_talk 33
    pl_CloseMessage
    pl_GoTo P444_0259

P444_0259:
    pl_ApplyMovement 7, P444_02B8
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P444_02CC
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 7  // the rest of this Pearl script runs there (continuation 7)
    pl_Warp 366, 24, 47, 0  // Pearl map 251 (MAP_PAL_PARK)
    pl_ReleaseAll
    pl_End

P444_0299:
    pl_msg_talk 34
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_02A4:
    pl_msg_talk 35
    pl_GoTo P444_012B

P444_02AD:
    pl_msg_talk 37
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S12:
P444_02D8:
    pl_LockAll
    pl_SetVarFromValue PVAR_40F3, 0
    pl_ApplyMovement PL_PLAYER, P444_03E4
    pl_WaitMovement
    pl_ApplyMovement 7, P444_03D8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P444_S3:
P444_02F8:
    pl_LockAll
    pl_SetVarFromValue PVAR_40F3, 0
    pl_ApplyMovement PL_PLAYER, P444_03EC
    pl_WaitMovement
    pl_CalcCatchingShowPoints 0, PVAR_800C
    pl_BufferNumber 0, PVAR_800C
    pl_CalcCatchingShowPoints 1, PVAR_800C
    pl_BufferNumber 1, PVAR_800C
    pl_CalcCatchingShowPoints 2, PVAR_800C
    pl_BufferNumber 2, PVAR_800C
    pl_CalcCatchingShowPoints 3, PVAR_800C
    pl_BufferNumber 3, PVAR_800C
    pl_msg_sys 38
    pl_CalcCatchingShowPoints 3, PVAR_800C
    pl_CompareVarToVar PVAR_800C, PVAR_40E0
    pl_GoToIf 2, P444_035B
    pl_msg_sys 40
    pl_Call P444_07BE
    pl_GoTo P444_0370

P444_035B:
    pl_msg_sys 39
    pl_Call P444_07BE
    pl_CalcCatchingShowPoints 3, PVAR_40E0
    pl_GoTo P444_0370

P444_0370:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_03AB
    pl_msg_sys 46
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_039E
    pl_GoTo P444_0370

P444_039E:
    pl_msg_sys 43
    pl_WaitABPress
    pl_CloseMessage
    pl_GoTo P444_03BD

P444_03AB:
    pl_MoveCatchingShowMonsToPCBoxes
    pl_msg_sys 42
    pl_msg_sys 44
    pl_WaitABPress
    pl_CloseMessage
    pl_GoTo P444_03BD

P444_03BD:
    pl_ApplyMovement PL_PLAYER, P444_03F8
    pl_WaitMovement
    pl_ApplyMovement 7, P444_03D8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P444_S4:
P444_0400:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 57
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S5:
P444_0413:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P444_0454
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_0449
    pl_GoTo P444_043E

P444_043E:
    pl_msg_talk 52
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_0449:
    pl_msg_talk 53
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_0454:
    pl_msg_talk 54
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S6:
P444_045F:
    pl_BufferPlayerName 0
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 55
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S7:
P444_0475:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 56
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S8:
P444_0488:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 65
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S9:
P444_049B:
    pl_Call P444_005D
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 57
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S10:
P444_04B4:
    pl_LockAll
    pl_ClearFlag PFLAG_0260
    pl_SetVarFromValue PVAR_40E0, 2000
    pl_ApplyMovement 1, P444_0548
    pl_WaitMovement
    pl_GetPlayerGender PVAR_4000
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P444_04E4
    pl_GoTo P444_04ED

P444_04E4:
    pl_msg_sys 0
    pl_GoTo P444_04F6

P444_04ED:
    pl_msg_sys 1
    pl_GoTo P444_04F6

P444_04F6:
    pl_msg_sys 2
    pl_CloseMessage
    pl_ApplyMovement 1, P444_0558
    pl_WaitMovement
    pl_msg_sys 3
    pl_SetVarFromValue PVAR_8004, 19
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement PL_PLAYER, P444_0570
    pl_WaitMovement
    pl_ApplyMovement 1, P444_0564
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 1, PFLAG_01F0
    pl_WaitSE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_SetVarFromValue PVAR_40C6, 1
    pl_ReleaseAll
    pl_End

P444_S11:
P444_057C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_400A, 1
    pl_GoToIf 1, P444_062C
    pl_CompareVarToValue PVAR_400A, 2
    pl_GoToIf 1, P444_063C
    pl_CheckPoketchAppRegistered 21, PVAR_800C  // Color Changer
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_0657
    pl_msg_talk 5
    pl_msg_talk 6
    pl_CheckPoketchAppRegistered 20, PVAR_800C  // Kitchen Timer
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_05FB
    pl_msg_talk 10
    PokePartyFindBySpecies 143, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_064C
    pl_msg_talk 11
    pl_SetVarFromValue PVAR_8004, 20
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_SetVarFromValue PVAR_400A, 1
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_05FB:
    pl_msg_talk 13
    PokePartyFindBySpecies 352, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_064C
    pl_msg_talk 14
    pl_SetVarFromValue PVAR_8004, 21
    VMCall C205_10_S10  // CallCommonScript 2009 (Pearl file 205 script 10)
    pl_WaitButton
    pl_SetVarFromValue PVAR_400A, 2
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_062C:
// BufferPoketchAppName 0, 20: the lines naming the app have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_msg_talk 87  // Pearl bank 464 line 12, naming Kitchen Timer
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_063C:
// BufferPoketchAppName 0, 21: the lines naming the app have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_064C:
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_0657:
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_S13:
P444_0662:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_4009, 1
    pl_GoToIf 1, P444_06CF
    pl_GetGBACartridgeVersion PVAR_800C
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P444_06DA
    pl_CompareVarToValue PVAR_800C, 5
    pl_GoToIf 1, P444_0706
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_0732
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P444_0756
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P444_077A
    pl_GoTo P444_06C4

P444_06C4:
    pl_msg_talk 66
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_06CF:
    pl_msg_talk 72
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_06DA:
    pl_SetVarFromValue PVAR_8004, 97
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CanFitAccessory  // Pearl 0x1D3 Unk01D3 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_06C4
    pl_msg_talk 67
    pl_GoTo P444_079E

P444_0706:
    pl_SetVarFromValue PVAR_8004, 98
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CanFitAccessory  // Pearl 0x1D3 Unk01D3 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P444_06C4
    pl_msg_talk 68
    pl_GoTo P444_079E

P444_0732:
    pl_SetVarFromValue PVAR_8004, 14
    pl_stub CheckBackdrop  // Pearl 0x1D6 Unk01D6 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_06C4
    pl_msg_talk 69
    pl_GoTo P444_07AE

P444_0756:
    pl_SetVarFromValue PVAR_8004, 15
    pl_stub CheckBackdrop  // Pearl 0x1D6 Unk01D6 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_06C4
    pl_msg_talk 70
    pl_GoTo P444_07AE

P444_077A:
    pl_SetVarFromValue PVAR_8004, 16
    pl_stub CheckBackdrop  // Pearl 0x1D6 Unk01D6 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P444_06C4
    pl_msg_talk 71
    pl_GoTo P444_07AE

P444_079E:
    VMCall C205_16_S16  // CallCommonScript 2015 (Pearl file 205 script 16)
    pl_SetVarFromValue PVAR_4009, 1
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_07AE:
    VMCall C205_37_S37  // CallCommonScript 2036 (Pearl file 205 script 37)
    pl_SetVarFromValue PVAR_4009, 1
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P444_07BE:
    pl_CalcCatchingShowPoints 3, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 3000
    pl_CallIf 0, P444_07FA
    pl_CompareVarToValue PVAR_800C, 3300
    pl_CallIf 0, P444_0870
    pl_CompareVarToValue PVAR_800C, 3500
    pl_CallIf 0, P444_08BF
    pl_CompareVarToValue PVAR_800C, 10000
    pl_CallIf 0, P444_0928
    pl_Return

P444_07FA:
    pl_GetRandom PVAR_8006, 8
    pl_CompareVarToValue PVAR_8006, 0
    pl_CallIf 1, P444_09B6
    pl_CompareVarToValue PVAR_8006, 1
    pl_CallIf 1, P444_09BE
    pl_CompareVarToValue PVAR_8006, 2
    pl_CallIf 1, P444_09C6
    pl_CompareVarToValue PVAR_8006, 3
    pl_CallIf 1, P444_09CE
    pl_CompareVarToValue PVAR_8006, 4
    pl_CallIf 1, P444_09D6
    pl_CompareVarToValue PVAR_8006, 5
    pl_CallIf 1, P444_09DE
    pl_CompareVarToValue PVAR_8006, 6
    pl_CallIf 1, P444_09E6
    pl_CompareVarToValue PVAR_8006, 7
    pl_CallIf 1, P444_09EE
    pl_Call P444_0984
    pl_Return

P444_0870:
    pl_GetRandom PVAR_8006, 5
    pl_CompareVarToValue PVAR_8006, 0
    pl_CallIf 1, P444_09F6
    pl_CompareVarToValue PVAR_8006, 1
    pl_CallIf 1, P444_09FE
    pl_CompareVarToValue PVAR_8006, 2
    pl_CallIf 1, P444_0A06
    pl_CompareVarToValue PVAR_8006, 3
    pl_CallIf 1, P444_0A0E
    pl_CompareVarToValue PVAR_8006, 4
    pl_CallIf 1, P444_0A16
    pl_Call P444_0984
    pl_Return

P444_08BF:
    pl_GetRandom PVAR_8006, 7
    pl_CompareVarToValue PVAR_8006, 0
    pl_CallIf 1, P444_0A1E
    pl_CompareVarToValue PVAR_8006, 1
    pl_CallIf 1, P444_0A26
    pl_CompareVarToValue PVAR_8006, 2
    pl_CallIf 1, P444_0A2E
    pl_CompareVarToValue PVAR_8006, 3
    pl_CallIf 1, P444_0A36
    pl_CompareVarToValue PVAR_8006, 4
    pl_CallIf 1, P444_0A3E
    pl_CompareVarToValue PVAR_8006, 5
    pl_CallIf 1, P444_0A46
    pl_CompareVarToValue PVAR_8006, 6
    pl_CallIf 1, P444_0A4E
    pl_Call P444_0984
    pl_Return

P444_0928:
    pl_GetRandom PVAR_8006, 6
    pl_CompareVarToValue PVAR_8006, 0
    pl_CallIf 1, P444_0A56
    pl_CompareVarToValue PVAR_8006, 1
    pl_CallIf 1, P444_0A5E
    pl_CompareVarToValue PVAR_8006, 2
    pl_CallIf 1, P444_0A66
    pl_CompareVarToValue PVAR_8006, 3
    pl_CallIf 1, P444_0A6E
    pl_CompareVarToValue PVAR_8006, 4
    pl_CallIf 1, P444_0A76
    pl_CompareVarToValue PVAR_8006, 5
    pl_CallIf 1, P444_0A7E
    pl_Call P444_0984
    pl_Return

P444_0984:
    pl_CanFitItem PVAR_8006, 1, PVAR_8007
    pl_CompareVarToValue PVAR_8007, 0
    pl_CallIf 5, P444_09A1
    pl_SetVarFromValue PVAR_800C, 10000
    pl_Return

P444_09A1:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 45
    pl_SetVarFromVar PVAR_8004, PVAR_8006
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_Return

P444_09B6:
    pl_SetVarFromValue PVAR_8006, 149
    pl_Return

P444_09BE:
    pl_SetVarFromValue PVAR_8006, 150
    pl_Return

P444_09C6:
    pl_SetVarFromValue PVAR_8006, 151
    pl_Return

P444_09CE:
    pl_SetVarFromValue PVAR_8006, 152
    pl_Return

P444_09D6:
    pl_SetVarFromValue PVAR_8006, 153
    pl_Return

P444_09DE:
    pl_SetVarFromValue PVAR_8006, 154
    pl_Return

P444_09E6:
    pl_SetVarFromValue PVAR_8006, 155
    pl_Return

P444_09EE:
    pl_SetVarFromValue PVAR_8006, 156
    pl_Return

P444_09F6:
    pl_SetVarFromValue PVAR_8006, 159
    pl_Return

P444_09FE:
    pl_SetVarFromValue PVAR_8006, 160
    pl_Return

P444_0A06:
    pl_SetVarFromValue PVAR_8006, 161
    pl_Return

P444_0A0E:
    pl_SetVarFromValue PVAR_8006, 162
    pl_Return

P444_0A16:
    pl_SetVarFromValue PVAR_8006, 163
    pl_Return

P444_0A1E:
    pl_SetVarFromValue PVAR_8006, 164
    pl_Return

P444_0A26:
    pl_SetVarFromValue PVAR_8006, 165
    pl_Return

P444_0A2E:
    pl_SetVarFromValue PVAR_8006, 166
    pl_Return

P444_0A36:
    pl_SetVarFromValue PVAR_8006, 167
    pl_Return

P444_0A3E:
    pl_SetVarFromValue PVAR_8006, 168
    pl_Return

P444_0A46:
    pl_SetVarFromValue PVAR_8006, 157
    pl_Return

P444_0A4E:
    pl_SetVarFromValue PVAR_8006, 158
    pl_Return

P444_0A56:
    pl_SetVarFromValue PVAR_8006, 169
    pl_Return

P444_0A5E:
    pl_SetVarFromValue PVAR_8006, 170
    pl_Return

P444_0A66:
    pl_SetVarFromValue PVAR_8006, 171
    pl_Return

P444_0A6E:
    pl_SetVarFromValue PVAR_8006, 172
    pl_Return

P444_0A76:
    pl_SetVarFromValue PVAR_8006, 173
    pl_Return

P444_0A7E:
    pl_SetVarFromValue PVAR_8006, 174
    pl_Return

    .balign 4, 0
P444_02B8:
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    MoveEnd

    .balign 4, 0
P444_02CC:
    Move 12, 5  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P444_03D8:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P444_03E4:
    Move 13, 5  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P444_03EC:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P444_03F8:
    Move 13, 4  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P444_0548:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 63, 1  // DELAY_8
    Move 13, 3  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P444_0558:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 63, 1  // DELAY_8
    MoveEnd

    .balign 4, 0
P444_0564:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P444_0570:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

// ---- continuation 14: after the Warp at 265:01D0 (MAP_PAL_PARK)
W265_01D0_S:
W265_01D0_01DC:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_Return

RamanasExtra_clerk:               // the slate clerk (data/ramanas_park.json "clerk")
    pl_LockAll
    pl_FacePlayer
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 1
    VMJumpIf CMP_EQ, .LRX_1open
    pl_msg_talk 130
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMHalt
.LRX_1open:
    FlagGet 1067, 0x8057
    WorkCmpConst 0x8057, 1
    VMJumpIf CMP_EQ, .LRX_4seen
    pl_msg_talk 131
    pl_WaitButton
    pl_CloseMessage
    FlagSet 1067
.LRX_4seen:
.LRX_2menu:
    pl_msg_talk 132
    ListMenu_AnchorTopRight 31, 10, 0, 1, 0x8050
    ListMenuAdd 133, 65535, 0
    ListMenuAdd 134, 65535, 1
    ListMenuAdd 135, 65535, 2
    ListMenuShow
    pl_CloseMessage
    WorkCmpConst 0x8050, 0
    VMJumpIf CMP_EQ, .LRX_5exchange
    WorkCmpConst 0x8050, 1
    VMJumpIf CMP_EQ, .LRX_6enter
.LRX_3bye:
    pl_msg_talk 136
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMHalt
.LRX_5exchange:
    WorkSetConst 0x8051, 0
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_7
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_8
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_8
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_8
    VMJump .LRX_7
.LRX_8:
    WorkAdd 0x8051, 1
.LRX_7:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_9
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_9
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_9
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_9
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_10
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_10
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_10
    VMJump .LRX_9
.LRX_10:
    WorkAdd 0x8051, 1
.LRX_9:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_11
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_11
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_11
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_11
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_12
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_12
    VMJump .LRX_11
.LRX_12:
    WorkAdd 0x8051, 1
.LRX_11:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_13
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_13
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_13
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_13
    FlagGet 363, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_13
    FlagGet 1066, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_14
    VMJump .LRX_13
.LRX_14:
    WorkAdd 0x8051, 1
.LRX_13:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_15
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_15
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_15
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_15
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_15
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_15
    FlagGet 1061, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_16
    VMJump .LRX_15
.LRX_16:
    WorkAdd 0x8051, 1
.LRX_15:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_17
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_17
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_17
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_17
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_17
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_17
    FlagGet 1062, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_18
    VMJump .LRX_17
.LRX_18:
    WorkAdd 0x8051, 1
.LRX_17:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_19
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_19
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_19
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_19
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_19
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_19
    FlagGet 1063, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_20
    VMJump .LRX_19
.LRX_20:
    WorkAdd 0x8051, 1
.LRX_19:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_21
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_21
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_21
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_21
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_21
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_21
    FlagGet 1064, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_22
    VMJump .LRX_21
.LRX_22:
    WorkAdd 0x8051, 1
.LRX_21:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_23
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_23
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_23
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_23
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_23
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_23
    FlagGet 1065, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_24
    VMJump .LRX_23
.LRX_24:
    WorkAdd 0x8051, 1
.LRX_23:
    WorkCmpConst 0x8051, 0
    VMJumpIf CMP_NE, .LRX_25some
    pl_msg_talk 137
    pl_WaitButton
    pl_CloseMessage
    VMJump .LRX_2menu
.LRX_25some:
    pl_msg_talk 138
    pl_WaitButton
    pl_CloseMessage
    pl_msg_talk 139
    ListMenu_AnchorTopRight 31, 10, 0, 1, 0x8050
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_26
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_27
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_27
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_27
    VMJump .LRX_26
.LRX_27:
    ListMenuAdd 140, 65535, 0
.LRX_26:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_28
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_28
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_28
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_28
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_29
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_29
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_29
    VMJump .LRX_28
.LRX_29:
    ListMenuAdd 141, 65535, 1
.LRX_28:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_30
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_30
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_30
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_30
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_31
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_31
    VMJump .LRX_30
.LRX_31:
    ListMenuAdd 142, 65535, 2
.LRX_30:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_32
    FlagGet 902, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_32
    FlagGet 1054, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_32
    FlagGet 1055, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_32
    FlagGet 363, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_32
    FlagGet 1066, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_33
    VMJump .LRX_32
.LRX_33:
    ListMenuAdd 143, 65535, 3
.LRX_32:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_34
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_34
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_34
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_34
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_34
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_34
    FlagGet 1061, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_35
    VMJump .LRX_34
.LRX_35:
    ListMenuAdd 144, 65535, 4
.LRX_34:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_36
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_36
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_36
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_36
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_36
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_36
    FlagGet 1062, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_37
    VMJump .LRX_36
.LRX_37:
    ListMenuAdd 145, 65535, 5
.LRX_36:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_38
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_38
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_38
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_38
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_38
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_38
    FlagGet 1063, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_39
    VMJump .LRX_38
.LRX_39:
    ListMenuAdd 146, 65535, 6
.LRX_38:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_40
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_40
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_40
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_40
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_40
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_40
    FlagGet 1064, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_41
    VMJump .LRX_40
.LRX_41:
    ListMenuAdd 147, 65535, 7
.LRX_40:
    FlagGet 2400, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_42
    FlagGet 1056, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_42
    FlagGet 1057, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_42
    FlagGet 1058, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_42
    FlagGet 1059, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_42
    FlagGet 1060, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_42
    FlagGet 1065, 0x8057
    WorkCmpConst 0x8057, 0
    VMJumpIf CMP_EQ, .LRX_43
    VMJump .LRX_42
.LRX_43:
    ListMenuAdd 148, 65535, 8
.LRX_42:
    ListMenuAdd 135, 65535, 255
    ListMenuShow
    pl_CloseMessage
    WorkCmpConst 0x8050, 0
    VMJumpIf CMP_NE, .LRX_45
    WorkSetConst 0x8052, 120
    VMJump .LRX_44buy
.LRX_45:
    WorkCmpConst 0x8050, 1
    VMJumpIf CMP_NE, .LRX_46
    WorkSetConst 0x8052, 121
    VMJump .LRX_44buy
.LRX_46:
    WorkCmpConst 0x8050, 2
    VMJumpIf CMP_NE, .LRX_47
    WorkSetConst 0x8052, 122
    VMJump .LRX_44buy
.LRX_47:
    WorkCmpConst 0x8050, 3
    VMJumpIf CMP_NE, .LRX_48
    WorkSetConst 0x8052, 123
    VMJump .LRX_44buy
.LRX_48:
    WorkCmpConst 0x8050, 4
    VMJumpIf CMP_NE, .LRX_49
    WorkSetConst 0x8052, 124
    VMJump .LRX_44buy
.LRX_49:
    WorkCmpConst 0x8050, 5
    VMJumpIf CMP_NE, .LRX_50
    WorkSetConst 0x8052, 125
    VMJump .LRX_44buy
.LRX_50:
    WorkCmpConst 0x8050, 6
    VMJumpIf CMP_NE, .LRX_51
    WorkSetConst 0x8052, 126
    VMJump .LRX_44buy
.LRX_51:
    WorkCmpConst 0x8050, 7
    VMJumpIf CMP_NE, .LRX_52
    WorkSetConst 0x8052, 127
    VMJump .LRX_44buy
.LRX_52:
    WorkCmpConst 0x8050, 8
    VMJumpIf CMP_NE, .LRX_53
    WorkSetConst 0x8052, 128
    VMJump .LRX_44buy
.LRX_53:
    VMJump .LRX_2menu
.LRX_44buy:
    ItemCheckAmount 0x8052, 1, 0x8053
    WorkCmpConst 0x8053, 1
    VMJumpIf CMP_NE, .LRX_54none
    WordSetItemName 0, 0x8052
    pl_msg_talk 149
    pl_WaitButton
    pl_CloseMessage
    VMJump .LRX_2menu
.LRX_54none:
    ItemCheckAmount 129, 3, 0x8053
    ItemCheckAmount 130, 1, 0x8054
    WorkCmpConst 0x8053, 1
    VMJumpIf CMP_EQ, .LRX_58ask
    WorkCmpConst 0x8054, 1
    VMJumpIf CMP_EQ, .LRX_56paidL
    pl_msg_talk 150
    pl_WaitButton
    pl_CloseMessage
    VMJump .LRX_2menu
.LRX_58ask:
    WorkCmpConst 0x8054, 1
    VMJumpIf CMP_NE, .LRX_55paidS
    pl_msg_talk 151
    ListMenu_AnchorTopRight 31, 10, 0, 1, 0x8050
    ListMenuAdd 152, 65535, 0
    ListMenuAdd 153, 65535, 1
    ListMenuShow
    pl_CloseMessage
    WorkCmpConst 0x8050, 0
    VMJumpIf CMP_EQ, .LRX_55paidS
    WorkCmpConst 0x8050, 1
    VMJumpIf CMP_EQ, .LRX_56paidL
    VMJump .LRX_2menu
.LRX_55paidS:
    ItemSub 129, 3, 0x8053
    VMJump .LRX_57pay
.LRX_56paidL:
    ItemSub 130, 1, 0x8053
.LRX_57pay:
    pl_msg_talk 154
    pl_WaitButton
    pl_CloseMessage
    VMStackPush 0x8000
    VMStackPush 0x8001
    WorkSet 0x8000, 0x8052
    WorkSetConst 0x8001, 1
    RTCallGlobal 2801
    VMStackPop 0x8001
    VMStackPop 0x8000
    VMJump .LRX_2menu
.LRX_6enter:
    pl_msg_talk 155
    pl_WaitButton
    pl_CloseMessage
    ActorCmdExec PL_PLAYER, RamanasMov_toGap
    ActorCmdWait
    ActorCmdExec 7, RamanasMov_aside
    ActorCmdWait
    ActorCmdExec PL_PLAYER, RamanasMov_in
    ActorCmdWait
    WorkSetConst 0x40B1, 3
    FadeOutBlack
    FadeWait
    RTReserveScript 8
    MapChangeCore 366, 24, 0, 47, 0
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

RamanasExtra_return:              // the gate after a Ramanas visit (frame table: park state 3)
    pl_LockAll
    PlayerGetGPos 0x8050, 0x8051
    WorkSetConst 0x40B1, 0
    WorkCmpConst 0x8050, 7
    VMJumpIf CMP_NE, .LRX_notdoor
    WorkCmpConst 0x8051, 7
    VMJumpIf CMP_EQ, .LRX_59atdoor
.LRX_notdoor:
    ActorSetGPos 7, 7, 0, 11, 1
    pl_ReleaseAll
    VMHalt
.LRX_59atdoor:
    ActorCmdExec PL_PLAYER, RamanasMov_out
    ActorCmdWait
    ActorCmdExec 7, RamanasMov_back
    ActorCmdWait
    pl_ReleaseAll
    VMHalt
    .balign 4, 0
RamanasMov_toGap:
    Move 14, 3
    Move 0, 1
    MoveEnd
    .balign 4, 0
RamanasMov_aside:
    Move 36, 1
    Move 12, 2
    Move 15, 1
    Move 38, 1
    MoveEnd
    .balign 4, 0
RamanasMov_in:
    Move 12, 5
    Move 69, 1
    MoveEnd
    .balign 4, 0
RamanasMov_back:
    Move 14, 1
    Move 13, 2
    MoveEnd
    .balign 4, 0
RamanasMov_out:
    Move 13, 5
    MoveEnd

// ---- Pearl global script 205:10 (a subroutine here)
C205_10_S10:
C205_10_069C:
    pl_Call C205_10_06A6
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_10_06A6:
    pl_BufferPlayerName 0
// BufferPoketchAppName 1, PVAR_8004: the lines naming the app have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_POCKETCH
    MsgWinCloseAll  // another speaker: close the first window
    pl_CompareVarToValue PVAR_8004, 19
    pl_GoToIf 1, C205_10_06B2_App19
    pl_CompareVarToValue PVAR_8004, 20
    pl_GoToIf 1, C205_10_06B2_App20
    pl_CompareVarToValue PVAR_8004, 21
    pl_GoToIf 1, C205_10_06B2_App21
    pl_msg_sys 88  // Pearl bank 199 line 24: another one (no caller here sets it)
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App19:
    pl_msg_sys 89  // naming Trainer Counter
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App20:
    pl_msg_sys 90  // naming Kitchen Timer
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_App21:
    pl_msg_sys 91  // naming Color Changer
    pl_GoTo C205_10_06B2_AppDone
C205_10_06B2_AppDone:
    pl_WaitFanfare
    pl_msg_sys 92  // Pearl bank 199 line 26
    pl_RegisterPoketchApp PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, C205_10_0805
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, C205_10_080A
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, C205_10_080F
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, C205_10_0814
    pl_CompareVarToValue PVAR_8004, 4
    pl_CallIf 1, C205_10_0819
    pl_CompareVarToValue PVAR_8004, 5
    pl_CallIf 1, C205_10_081E
    pl_CompareVarToValue PVAR_8004, 6
    pl_CallIf 1, C205_10_0823
    pl_CompareVarToValue PVAR_8004, 7
    pl_CallIf 1, C205_10_0828
    pl_CompareVarToValue PVAR_8004, 8
    pl_CallIf 1, C205_10_082D
    pl_CompareVarToValue PVAR_8004, 9
    pl_CallIf 1, C205_10_0832
    pl_CompareVarToValue PVAR_8004, 10
    pl_CallIf 1, C205_10_0837
    pl_CompareVarToValue PVAR_8004, 11
    pl_CallIf 1, C205_10_083C
    pl_CompareVarToValue PVAR_8004, 12
    pl_CallIf 1, C205_10_0841
    pl_CompareVarToValue PVAR_8004, 13
    pl_CallIf 1, C205_10_0846
    pl_CompareVarToValue PVAR_8004, 14
    pl_CallIf 1, C205_10_084B
    pl_CompareVarToValue PVAR_8004, 15
    pl_CallIf 1, C205_10_0850
    pl_CompareVarToValue PVAR_8004, 16
    pl_CallIf 1, C205_10_0855
    pl_CompareVarToValue PVAR_8004, 17
    pl_CallIf 1, C205_10_085A
    pl_CompareVarToValue PVAR_8004, 18
    pl_CallIf 1, C205_10_085F
    pl_CompareVarToValue PVAR_8004, 19
    pl_CallIf 1, C205_10_0864
    pl_CompareVarToValue PVAR_8004, 20
    pl_CallIf 1, C205_10_0869
    pl_CompareVarToValue PVAR_8004, 21
    pl_CallIf 1, C205_10_086E
    pl_CompareVarToValue PVAR_8004, 22
    pl_CallIf 1, C205_10_0873
    pl_CompareVarToValue PVAR_8004, 23
    pl_CallIf 1, C205_10_0878
    pl_CompareVarToValue PVAR_8004, 24
    pl_CallIf 1, C205_10_087D
    pl_Return

C205_10_0805:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 93  // Pearl bank 199 line 83
    pl_Return

C205_10_080A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 94  // Pearl bank 199 line 84
    pl_Return

C205_10_080F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 95  // Pearl bank 199 line 85
    pl_Return

C205_10_0814:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 96  // Pearl bank 199 line 86
    pl_Return

C205_10_0819:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 97  // Pearl bank 199 line 87
    pl_Return

C205_10_081E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 98  // Pearl bank 199 line 88
    pl_Return

C205_10_0823:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 99  // Pearl bank 199 line 89
    pl_Return

C205_10_0828:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 100  // Pearl bank 199 line 90
    pl_Return

C205_10_082D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 101  // Pearl bank 199 line 91
    pl_Return

C205_10_0832:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 102  // Pearl bank 199 line 92
    pl_Return

C205_10_0837:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 103  // Pearl bank 199 line 93
    pl_Return

C205_10_083C:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 104  // Pearl bank 199 line 94
    pl_Return

C205_10_0841:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 105  // Pearl bank 199 line 95
    pl_Return

C205_10_0846:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 106  // Pearl bank 199 line 96
    pl_Return

C205_10_084B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 107  // Pearl bank 199 line 97
    pl_Return

C205_10_0850:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 108  // Pearl bank 199 line 98
    pl_Return

C205_10_0855:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 109  // Pearl bank 199 line 99
    pl_Return

C205_10_085A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 110  // Pearl bank 199 line 100
    pl_Return

C205_10_085F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 111  // Pearl bank 199 line 101
    pl_Return

C205_10_0864:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 112  // Pearl bank 199 line 102
    pl_Return

C205_10_0869:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 113  // Pearl bank 199 line 103
    pl_Return

C205_10_086E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 114  // Pearl bank 199 line 104
    pl_Return

C205_10_0873:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 115  // Pearl bank 199 line 105
    pl_Return

C205_10_0878:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 116  // Pearl bank 199 line 106
    pl_Return

C205_10_087D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 117  // Pearl bank 199 line 107
    pl_Return

// ---- Pearl global script 205:16 (a subroutine here)
C205_16_S16:
C205_16_0906:
    pl_Call C205_16_0922
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 118  // Pearl bank 199 line 31 (the Accessory from PVAR_8004: not known here)
    pl_WaitButton
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_16_0922:
    pl_PlayFanfare SEQ_ME_ACCE  // Pearl SEQ_ACCE
// AddAccessory 32772, 32773: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
// BufferAccessoryName 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 119  // Pearl bank 199 line 25 (the Accessory from PVAR_8004: not known here)
    pl_WaitFanfare
    pl_BufferPlayerName 0
// BufferAccessoryName 1, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    pl_Return

// ---- Pearl global script 205:37 (a subroutine here)
C205_37_S37:
C205_37_0940:
    pl_Call C205_37_095C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 118  // Pearl bank 199 line 31
    pl_WaitButton
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_37_095C:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
// AddContestBackdrop 32772: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
    pl_stub BufferContestBackdropName  // Pearl 0x273 BufferContestBackgroundName 0, 32772: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 119  // Pearl bank 199 line 25
    pl_WaitFanfare
    pl_BufferPlayerName 0
    pl_stub BufferContestBackdropName  // Pearl 0x273 BufferContestBackgroundName 1, 32772: not translated yet
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
    pl_msg_sys 120  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 121  // Pearl bank 199 line 28
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
    pl_msg_sys 119  // Pearl bank 199 line 25
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
    pl_msg_sys 122  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 123  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 124  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 125  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 126  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 127  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 128  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 129  // Pearl bank 199 line 117
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
