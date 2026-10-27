// MAP_AMITY_SQUARE: Pearl script file 266, text bank 236. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-26: Pearl's; no warp continuations; 27: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P266_S1
    ScriptEntry P266_S2
    ScriptEntry P266_S3
    ScriptEntry P266_S4
    ScriptEntry P266_S5
    ScriptEntry P266_S6
    ScriptEntry P266_S7
    ScriptEntry P266_S8
    ScriptEntry P266_S9
    ScriptEntry P266_S10
    ScriptEntry P266_S11
    ScriptEntry P266_S12
    ScriptEntry P266_S13
    ScriptEntry P266_S14
    ScriptEntry P266_S15
    ScriptEntry P266_S16
    ScriptEntry P266_S17
    ScriptEntry P266_S18
    ScriptEntry P266_S19
    ScriptEntry P266_S20
    ScriptEntry P266_S21
    ScriptEntry P266_S22
    ScriptEntry P266_S23
    ScriptEntry P266_S24
    ScriptEntry P266_S25
    ScriptEntry P266_S26
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P266_S1:
P266_006A:
    pl_SetFlag PFLAG_09CC
    pl_SetFlag PFLAG_0200
    pl_SetFlag PFLAG_0201
    pl_SetFlag PFLAG_0249
    pl_SetFlag PFLAG_024A
    pl_SetFlag PFLAG_024B
    pl_SetFlag PFLAG_024C
    pl_SetFlag PFLAG_024D
    pl_SetFlag PFLAG_024E
    pl_SetFlag PFLAG_024F
    pl_SetFlag PFLAG_0250
    pl_SetFlag PFLAG_0251
    pl_End

P266_S2:
P266_009C:
    pl_LockAll
    pl_SetVarFromValue PVAR_8001, 1
    pl_ApplyMovement PL_PLAYER, P266_0794
    pl_WaitMovement
    pl_GoTo P266_00CC

P266_S4:
P266_00B4:
    pl_LockAll
    pl_SetVarFromValue PVAR_8001, 2
    pl_ApplyMovement PL_PLAYER, P266_079C
    pl_WaitMovement
    pl_GoTo P266_00CC

P266_00CC:
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_0182
    pl_GoTo P266_00E4

P266_00E4:
    pl_SetVarFromValue PVAR_4000, 0
    PokePartyFindBySpecies 25, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 35, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 54, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 417, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 425, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 427, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 440, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P266_07A4
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P266_0182:
    pl_SetVarFromValue PVAR_4000, 1
    PokePartyFindBySpecies 25, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 35, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 54, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 417, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 425, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 427, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 440, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 39, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 255, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 300, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    PokePartyFindBySpecies 285, PVAR_800C, PL_TMP  // CheckPartyHasSpecies (1 = yes)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_026C
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P266_07A4
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P266_026C:
    pl_SetVarFromValue PVAR_400A, 0
    pl_GetPartyCount PVAR_400B
    pl_SetVarFromValue PVAR_400C, 0

P266_027C:
    pl_GetPartyMonSpecies PVAR_400A, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_030E
    pl_CompareVarToValue PVAR_4000, 0
    pl_CallIf 1, P266_033A
    pl_CompareVarToValue PVAR_4000, 1
    pl_CallIf 1, P266_03AB
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_030E
    pl_BufferPartyMonNickname 0, PVAR_400A
    pl_CompareVarToValue PVAR_400C, 0
    pl_GoToIf 1, P266_02CE
    pl_GoTo P266_02EE

P266_02CE:
    pl_AddVar PVAR_400C, 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_0450
    pl_GoTo P266_030E

P266_02EE:
    pl_AddVar PVAR_400C, 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 4
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_0450
    pl_GoTo P266_030E

P266_030E:
    pl_AddVar PVAR_400A, 1
    pl_SubVar PVAR_400B, 1
    pl_CompareVarToValue PVAR_400B, 0
    pl_GoToIf 5, P266_027C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 5
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P266_07A4
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P266_033A:
    pl_GetPartyMonSpecies PVAR_400A, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 25
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 35
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 54
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 417
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 425
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 427
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 440
    pl_GoToIf 1, P266_03A3
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

P266_03A3:
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

P266_03AB:
    pl_GetPartyMonSpecies PVAR_400A, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 25
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 35
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 54
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 417
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 425
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 427
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 440
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 39
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 300
    pl_GoToIf 1, P266_03A3
    pl_CompareVarToValue PVAR_800C, 285
    pl_GoToIf 1, P266_03A3
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

P266_0450:
    pl_HealParty
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromVar PVAR_409D, PVAR_400A
    pl_GetPartyMonSpecies PVAR_400A, PVAR_409A
    pl_SetVarFromVar PVAR_8008, PVAR_409A
    pl_CompareVarToValue PVAR_8008, 25
    pl_GoToIf 1, P266_050D
    pl_CompareVarToValue PVAR_8008, 255
    pl_GoToIf 1, P266_051D
    pl_CompareVarToValue PVAR_8008, 35
    pl_GoToIf 1, P266_052D
    pl_CompareVarToValue PVAR_8008, 54
    pl_GoToIf 1, P266_053D
    pl_CompareVarToValue PVAR_8008, 417
    pl_GoToIf 1, P266_054D
    pl_CompareVarToValue PVAR_8008, 425
    pl_GoToIf 1, P266_055D
    pl_CompareVarToValue PVAR_8008, 427
    pl_GoToIf 1, P266_056D
    pl_CompareVarToValue PVAR_8008, 440
    pl_GoToIf 1, P266_057D
    pl_CompareVarToValue PVAR_8008, 39
    pl_GoToIf 1, P266_058D
    pl_CompareVarToValue PVAR_8008, 300
    pl_GoToIf 1, P266_059D
    pl_CompareVarToValue PVAR_8008, 285
    pl_GoToIf 1, P266_05AD
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

P266_050D:
    pl_SetVarFromValue PVAR_8002, 5
    pl_ClearFlag PFLAG_0200
    pl_GoTo P266_05BD

P266_051D:
    pl_SetVarFromValue PVAR_8002, 6
    pl_ClearFlag PFLAG_0201
    pl_GoTo P266_05BD

P266_052D:
    pl_SetVarFromValue PVAR_8002, 15
    pl_ClearFlag PFLAG_0249
    pl_GoTo P266_05BD

P266_053D:
    pl_SetVarFromValue PVAR_8002, 16
    pl_ClearFlag PFLAG_024A
    pl_GoTo P266_05BD

P266_054D:
    pl_SetVarFromValue PVAR_8002, 17
    pl_ClearFlag PFLAG_024B
    pl_GoTo P266_05BD

P266_055D:
    pl_SetVarFromValue PVAR_8002, 18
    pl_ClearFlag PFLAG_024C
    pl_GoTo P266_05BD

P266_056D:
    pl_SetVarFromValue PVAR_8002, 19
    pl_ClearFlag PFLAG_024D
    pl_GoTo P266_05BD

P266_057D:
    pl_SetVarFromValue PVAR_8002, 20
    pl_ClearFlag PFLAG_024E
    pl_GoTo P266_05BD

P266_058D:
    pl_SetVarFromValue PVAR_8002, 21
    pl_ClearFlag PFLAG_024F
    pl_GoTo P266_05BD

P266_059D:
    pl_SetVarFromValue PVAR_8002, 22
    pl_ClearFlag PFLAG_0250
    pl_GoTo P266_05BD

P266_05AD:
    pl_SetVarFromValue PVAR_8002, 23
    pl_ClearFlag PFLAG_0251
    pl_GoTo P266_05BD

P266_05BD:
    pl_AddObject PVAR_8002
    pl_CompareVarToValue PVAR_8001, 1
    pl_CallIf 1, P266_061E
    pl_CompareVarToValue PVAR_8001, 2
    pl_CallIf 1, P266_062C
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_4099, 1
    pl_ClearAmitySquareStepCount  // Pearl 0x215: Black 2's step counter from 0
    pl_Call P266_0858
// 27C 0, 16541: Pearl's TV record of the walk; nothing in Black 2 (no Sinnoh TV)
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P266_07AC
    pl_ApplyMovement PVAR_8002, P266_07AC
    pl_WaitMovement
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start PVAR_8002  // Pearl SetMovementType 32770, 0x30 (follow the player)
    pl_ReleaseAll
    pl_End

P266_061E:
    pl_SetPosition PVAR_8002, 12, 1, 47, 2
    pl_Return

P266_062C:
    pl_SetPosition PVAR_8002, 51, 1, 47, 3
    pl_Return

P266_S3:
P266_S5:
P266_0659:
    pl_LockAll
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_follow_leave  // ClearHasPartner: the follower stays behind
    pl_SetVarFromVar PVAR_8008, PVAR_409A
    pl_CompareVarToValue PVAR_8008, 25
    pl_GoToIf 1, P266_0700
    pl_CompareVarToValue PVAR_8008, 255
    pl_GoToIf 1, P266_070A
    pl_CompareVarToValue PVAR_8008, 35
    pl_GoToIf 1, P266_0714
    pl_CompareVarToValue PVAR_8008, 54
    pl_GoToIf 1, P266_071E
    pl_CompareVarToValue PVAR_8008, 417
    pl_GoToIf 1, P266_0728
    pl_CompareVarToValue PVAR_8008, 425
    pl_GoToIf 1, P266_0732
    pl_CompareVarToValue PVAR_8008, 427
    pl_GoToIf 1, P266_073C
    pl_CompareVarToValue PVAR_8008, 440
    pl_GoToIf 1, P266_0746
    pl_CompareVarToValue PVAR_8008, 39
    pl_GoToIf 1, P266_0750
    pl_CompareVarToValue PVAR_8008, 300
    pl_GoToIf 1, P266_075A
    pl_CompareVarToValue PVAR_8008, 285
    pl_GoToIf 1, P266_0764
    pl_End

P266_0700:
    pl_RemoveObject 5, PFLAG_0200
    pl_GoTo P266_076E

P266_070A:
    pl_RemoveObject 6, PFLAG_0201
    pl_GoTo P266_076E

P266_0714:
    pl_RemoveObject 15, PFLAG_0249
    pl_GoTo P266_076E

P266_071E:
    pl_RemoveObject 16, PFLAG_024A
    pl_GoTo P266_076E

P266_0728:
    pl_RemoveObject 17, PFLAG_024B
    pl_GoTo P266_076E

P266_0732:
    pl_RemoveObject 18, PFLAG_024C
    pl_GoTo P266_076E

P266_073C:
    pl_RemoveObject 19, PFLAG_024D
    pl_GoTo P266_076E

P266_0746:
    pl_RemoveObject 20, PFLAG_024E
    pl_GoTo P266_076E

P266_0750:
    pl_RemoveObject 21, PFLAG_024F
    pl_GoTo P266_076E

P266_075A:
    pl_RemoveObject 22, PFLAG_0250
    pl_GoTo P266_076E

P266_0764:
    pl_RemoveObject 23, PFLAG_0251
    pl_GoTo P266_076E

P266_076E:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_4099, 0
    pl_msg_sys 6
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P266_07A4
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P266_S6:
P266_S7:
P266_S8:
P266_S9:
P266_S10:
P266_S11:
P266_S12:
P266_S13:
P266_S14:
P266_S15:
P266_S16:
P266_07C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_GetAmitySquareStepCount PVAR_800C  // Pearl 0x216
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P266_0950
    pl_GoTo P266_07E4

P266_07E4:
    pl_GetRandom PVAR_800C, 9
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_0A37
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P266_0A4F
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P266_0A67
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P266_0A7F
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P266_0A97
    pl_CompareVarToValue PVAR_800C, 5
    pl_GoToIf 1, P266_0AAF
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, P266_0AC7
    pl_CompareVarToValue PVAR_800C, 7
    pl_GoToIf 1, P266_0ADF
    pl_GoTo P266_0AF7

P266_0858:
    pl_GetRandom PVAR_800C, 5
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P266_0884
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 5, P266_088C
    pl_AmitySquareBerryOnly PVAR_409B, PVAR_409C  // Pearl 0x217 PVAR_409C, PVAR_409A: every find is a Berry
    pl_GoTo P266_0894

P266_0884:
    pl_SetVarFromValue PVAR_409B, 0
    pl_Return

P266_088C:
    pl_SetVarFromValue PVAR_409B, 1
    pl_Return

P266_0894:
    pl_GetRandom PVAR_800C, 100
    pl_CompareVarToValue PVAR_800C, 20
    pl_GoToIf 0, P266_0908
    pl_CompareVarToValue PVAR_800C, 35
    pl_GoToIf 0, P266_0910
    pl_CompareVarToValue PVAR_800C, 50
    pl_GoToIf 0, P266_0918
    pl_CompareVarToValue PVAR_800C, 65
    pl_GoToIf 0, P266_0920
    pl_CompareVarToValue PVAR_800C, 72
    pl_GoToIf 0, P266_0928
    pl_CompareVarToValue PVAR_800C, 79
    pl_GoToIf 0, P266_0930
    pl_CompareVarToValue PVAR_800C, 86
    pl_GoToIf 0, P266_0938
    pl_CompareVarToValue PVAR_800C, 93
    pl_GoToIf 0, P266_0940
    pl_GoTo P266_0948

P266_0908:
    pl_SetVarFromValue PVAR_409F, 176
    pl_Return

P266_0910:
    pl_SetVarFromValue PVAR_409F, 175
    pl_Return

P266_0918:
    pl_SetVarFromValue PVAR_409F, 177
    pl_Return

P266_0920:
    pl_SetVarFromValue PVAR_409F, 178
    pl_Return

P266_0928:
    pl_SetVarFromValue PVAR_409F, 179
    pl_Return

P266_0930:
    pl_SetVarFromValue PVAR_409F, 180
    pl_Return

P266_0938:
    pl_SetVarFromValue PVAR_409F, 181
    pl_Return

P266_0940:
    pl_SetVarFromValue PVAR_409F, 182
    pl_Return

P266_0948:
    pl_SetVarFromValue PVAR_409F, 183
    pl_Return

P266_0950:
    pl_SetVarFromVar PVAR_8000, PVAR_409B
    pl_ClearAmitySquareStepCount  // Pearl 0x215: Black 2's step counter from 0
    pl_Call P266_0858
    pl_CompareVarToValue PVAR_8000, 0
    pl_GoToIf 1, P266_0971
    pl_GoTo P266_09D4

P266_0971:
    pl_SetVarFromVar PVAR_8004, PVAR_409F
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_09AD

P266_0992:
    pl_PlayCry PVAR_409A
    pl_msg_talk 22
    pl_WaitCry
// 27C 1, 32772: Pearl's TV record of the walk; nothing in Black 2 (no Sinnoh TV)
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_09AD:
    pl_SetVarFromVar PVAR_8004, PVAR_409C
    pl_SetVarFromValue PVAR_8005, 1
    WorkSetConst PVAR_800C, 0  // CanFitAccessory PVAR_8004, PVAR_8005: no Accessories in Black 2 (the finds are Berries)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_07E4
    pl_GoTo P266_09F5

P266_09D4:
    pl_SetVarFromVar PVAR_8004, PVAR_409C
    pl_SetVarFromValue PVAR_8005, 1
    WorkSetConst PVAR_800C, 0  // CanFitAccessory PVAR_8004, PVAR_8005: no Accessories in Black 2 (the finds are Berries)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_0A10

P266_09F5:
    pl_PlayCry PVAR_409A
    pl_msg_talk 22
    pl_WaitCry
// 27C 2, 32772: Pearl's TV record of the walk; nothing in Black 2 (no Sinnoh TV)
    VMCall C205_16_S16  // CallCommonScript 2015 (Pearl file 205 script 16)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0A10:
    pl_SetVarFromVar PVAR_8004, PVAR_409F
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P266_07E4
    pl_GoTo P266_0992

P266_0A37:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 13
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0A4F:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 14
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0A67:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 15
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0A7F:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 16
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0A97:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 17
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0AAF:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 18
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0AC7:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 19
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0ADF:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 20
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_0AF7:
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_PlayCry PVAR_409A
    pl_msg_talk 21
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S17:
P266_0B0F:
    pl_SetVarFromValue PVAR_400A, 0
    pl_GoTo P266_0B27

P266_S18:
P266_0B1B:
    pl_SetVarFromValue PVAR_400A, 1
    pl_GoTo P266_0B27

P266_0B27:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_BufferPartyMonNickname 0, PVAR_409D
    pl_GetRandom PVAR_800C, 6
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P266_0B9B
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P266_0BA0
    pl_CompareVarToValue PVAR_800C, 2
    pl_CallIf 1, P266_0BA5
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, P266_0BAA
    pl_CompareVarToValue PVAR_800C, 4
    pl_CallIf 1, P266_0BAF
    pl_CompareVarToValue PVAR_800C, 5
    pl_CallIf 1, P266_0BB4
    pl_CompareVarToValue PVAR_400A, 0
    pl_GoToIf 1, P266_0BB9
    pl_GoTo P266_0BCB

P266_0B9B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7
    pl_Return

P266_0BA0:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 8
    pl_Return

P266_0BA5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 9
    pl_Return

P266_0BAA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 10
    pl_Return

P266_0BAF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 11
    pl_Return

P266_0BB4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12
    pl_Return

P266_0BB9:
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 0, P266_0BE0
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P266_0BCB:
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 1, P266_0BE8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P266_S19:
P266_0BF0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S20:
P266_0C03:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 425
    pl_msg_talk 24
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S21:
P266_0C22:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 25
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S22:
P266_0C35:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S23:
P266_0C48:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S24:
P266_0C5B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 25
    pl_msg_talk 28
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S25:
P266_0C7A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P266_S26:
P266_0C8D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 35
    pl_msg_talk 30
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P266_0794:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P266_079C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P266_07A4:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P266_07AC:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P266_0BE0:
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P266_0BE8:
    Move 2, 1  // FACE_WEST
    MoveEnd

// ---- Pearl global script 205:17 (a subroutine here)
C205_17_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_17_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_17_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_17_03B2
    VMReturn  // End: the sub-script ends

C205_17_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_17_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_17_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_17_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

C205_17_S17:
C205_17_0978:
    pl_Call C205_17_0982
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_17_0982:
    pl_Call C205_17_0336
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, C205_17_09F4
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 5, C205_17_0A05
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 30
    pl_WaitButton
    pl_Return

C205_17_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 28
    pl_GoTo C205_17_0A2B

C205_17_0A05:
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_17_0A1D
    pl_BufferItemName 0, PVAR_8004
    pl_GoTo C205_17_0A22

C205_17_0A1D:
    pl_BufferItemName 0, PVAR_8004  // GetItemNamePlural

C205_17_0A22:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 25
    pl_GoTo C205_17_0A2B

C205_17_0A2B:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_17_1330
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_17_0A5B
    pl_BufferItemName 1, PVAR_8004
    pl_GoTo C205_17_0A60

C205_17_0A5B:
    pl_BufferItemName 1, PVAR_8004  // GetItemNamePlural

C205_17_0A60:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_17_0AE7
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_17_0AD6
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_17_0B2B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_17_0B1A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_17_0B3C
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_17_0AF8
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_17_0B09
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_17_0B4D
    VMReturn  // End: the sub-script ends

C205_17_0AD6:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0AE7:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0AF8:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B09:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B1A:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B2B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B3C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B4D:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B5E:
    pl_Return

C205_17_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_17_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_17_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_17_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_17_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_17_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_17_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_17_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_17_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_17_13D8
    pl_Return

C205_17_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_17_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 110
    pl_Return

C205_17_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 111
    pl_Return

C205_17_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 199 line 112
    pl_Return

C205_17_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 199 line 113
    pl_Return

C205_17_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 199 line 114
    pl_Return

C205_17_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 115
    pl_Return

C205_17_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 40  // Pearl bank 199 line 116
    pl_Return

C205_17_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:16 (a subroutine here)
C205_16_S16:
C205_16_0906:
    pl_Call C205_16_0922
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 42  // Pearl bank 199 line 31 (the Accessory from PVAR_8004: not known here)
    pl_WaitButton
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_16_0922:
    pl_PlayFanfare SEQ_ME_ACCE  // Pearl SEQ_ACCE
// AddAccessory 32772, 32773: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
// BufferAccessoryName 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 25 (the Accessory from PVAR_8004: not known here)
    pl_WaitFanfare
    pl_BufferPlayerName 0
// BufferAccessoryName 1, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
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
