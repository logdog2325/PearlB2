// MAP_VALOR_LAKEFRONT_SEVEN_STARS_RESTAURANT: Pearl script file 382, text bank 355. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-21: Pearl's; no warp continuations; 22: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P382_S1
    ScriptEntry P382_S2
    ScriptEntry P382_S3
    ScriptEntry P382_S4
    ScriptEntry P382_S5
    ScriptEntry P382_S6
    ScriptEntry P382_S7
    ScriptEntry P382_S8
    ScriptEntry P382_S9
    ScriptEntry P382_S10
    ScriptEntry P382_S11
    ScriptEntry P382_S12
    ScriptEntry P382_S13
    ScriptEntry P382_S14
    ScriptEntry P382_S15
    ScriptEntry P382_S16
    ScriptEntry P382_S17
    ScriptEntry P382_S18
    ScriptEntry P382_S19
    ScriptEntry P382_S20
    ScriptEntry P382_S21
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P382_S2:
P382_0058:
    pl_SetFlag PFLAG_09EE
    RTCGetTime PVAR_4000, PL_TMP  // Pearl GetHour (the minute in PL_TMP)
    pl_CompareVarToValue PVAR_4000, 9
    pl_GoToIf 0, P382_0087
    pl_CompareVarToValue PVAR_4000, 23
    pl_GoToIf 4, P382_0087
    pl_CheckFlag PFLAG_0AAB
    pl_GoToIf 0, P382_00B3
    pl_End

P382_0087:
    pl_SetFlag PFLAG_0262
    pl_SetFlag PFLAG_0263
    pl_SetFlag PFLAG_0264
    pl_SetFlag PFLAG_0265
    pl_SetFlag PFLAG_0266
    pl_SetFlag PFLAG_0267
    pl_SetFlag PFLAG_0268
    pl_SetFlag PFLAG_0269
    pl_SetFlag PFLAG_026A
    pl_SetVarFromValue PVAR_4104, 1
    pl_End

P382_00B3:
    pl_SetFlag PFLAG_0262
    pl_SetFlag PFLAG_0263
    pl_SetFlag PFLAG_0264
    pl_SetFlag PFLAG_0265
    pl_SetFlag PFLAG_0266
    pl_SetFlag PFLAG_0267
    pl_SetFlag PFLAG_0268
    pl_SetFlag PFLAG_0269
    pl_SetFlag PFLAG_026A
    pl_ClearTrainerFlag PTRAINER_536
    pl_ClearTrainerFlag PTRAINER_551
    pl_ClearTrainerFlag PTRAINER_545
    pl_ClearTrainerFlag PTRAINER_546
    pl_ClearTrainerFlag PTRAINER_542
    pl_ClearTrainerFlag PTRAINER_543
    pl_ClearTrainerFlag PTRAINER_539
    pl_ClearTrainerFlag PTRAINER_535
    pl_ClearTrainerFlag PTRAINER_548
    pl_ClearTrainerFlag PTRAINER_540
    pl_ClearTrainerFlag PTRAINER_552
    pl_ClearTrainerFlag PTRAINER_544
    pl_ClearTrainerFlag PTRAINER_538
    pl_ClearTrainerFlag PTRAINER_547
    pl_ClearTrainerFlag PTRAINER_541
    pl_ClearTrainerFlag PTRAINER_550
    pl_ClearTrainerFlag PTRAINER_549
    pl_ClearTrainerFlag PTRAINER_537
    pl_SetVarFromValue PVAR_4104, 0
    pl_GetRandom PVAR_4001, 1
    pl_SetVarFromValue PVAR_4000, 5
    pl_SetVarFromValue PVAR_400A, 10000

P382_0137:
    pl_GetRandom PVAR_4001, 9
    pl_CompareVarToValue PVAR_4001, 0
    pl_CallIf 1, P382_01D8
    pl_CompareVarToValue PVAR_4001, 1
    pl_CallIf 1, P382_01F5
    pl_CompareVarToValue PVAR_4001, 2
    pl_CallIf 1, P382_0212
    pl_CompareVarToValue PVAR_4001, 3
    pl_CallIf 1, P382_022F
    pl_CompareVarToValue PVAR_4001, 4
    pl_CallIf 1, P382_024C
    pl_CompareVarToValue PVAR_4001, 5
    pl_CallIf 1, P382_0269
    pl_CompareVarToValue PVAR_4001, 6
    pl_CallIf 1, P382_0286
    pl_CompareVarToValue PVAR_4001, 7
    pl_CallIf 1, P382_02A3
    pl_CompareVarToValue PVAR_4001, 8
    pl_CallIf 1, P382_02C0
    pl_SubVar PVAR_400A, 1
    pl_CompareVarToValue PVAR_400A, 0
    pl_GoToIf 1, P382_01D2
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 5, P382_0137

P382_01D2:
    pl_SetFlag PFLAG_0AAB
    pl_End

P382_01D8:
    pl_CheckFlag PFLAG_0262
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0262
    pl_GetRandom PVAR_40FB, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_01F5:
    pl_CheckFlag PFLAG_0263
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0263
    pl_GetRandom PVAR_40FC, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_0212:
    pl_CheckFlag PFLAG_0264
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0264
    pl_GetRandom PVAR_40FD, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_022F:
    pl_CheckFlag PFLAG_0265
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0265
    pl_GetRandom PVAR_40FE, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_024C:
    pl_CheckFlag PFLAG_0266
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0266
    pl_GetRandom PVAR_40FF, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_0269:
    pl_CheckFlag PFLAG_0267
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0267
    pl_GetRandom PVAR_4100, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_0286:
    pl_CheckFlag PFLAG_0268
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0268
    pl_GetRandom PVAR_4101, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_02A3:
    pl_CheckFlag PFLAG_0269
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_0269
    pl_GetRandom PVAR_4102, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_02C0:
    pl_CheckFlag PFLAG_026A
    pl_GoToIf 0, P382_02DD
    pl_ClearFlag PFLAG_026A
    pl_GetRandom PVAR_4103, 3
    pl_SubVar PVAR_4000, 1
    pl_Return

P382_02DD:
    pl_Return

P382_S3:
P382_02DF:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P382_212C
    pl_WaitMovement
    pl_WaitTime 20, PVAR_800C
    pl_msg_sys 1
    pl_CloseMessage
    pl_ReleaseAll
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 11  // the rest of this Pearl script runs there (continuation 11)
    pl_Warp 461, 706, 791, 1  // Pearl map 336 (MAP_VALOR_LAKEFRONT)
    pl_ReleaseAll
    pl_End

P382_S1:
P382_031E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_S4:
P382_0331:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_536
    pl_CheckTrainerFlag PTRAINER_536
    pl_GoToIf 1, P382_046C
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_04BC
    pl_SetVarFromVar PVAR_8008, PVAR_40FB
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_038A
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_03A9
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_03C8
    pl_ReleaseAll
    pl_End

P382_038A:
    pl_msg_sys 4
    pl_FacePlayer
    pl_msg_sys 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_03E7
    pl_GoTo P382_0460

P382_03A9:
    pl_msg_sys 12
    pl_FacePlayer
    pl_msg_sys 13
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_03E7
    pl_GoTo P382_0460

P382_03C8:
    pl_msg_sys 20
    pl_FacePlayer
    pl_msg_sys 21
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_03E7
    pl_GoTo P382_0460

P382_03E7:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_536, PTRAINER_551
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_536
    pl_SetTrainerFlag PTRAINER_551
    pl_Call P382_04CF
    pl_SetVarFromVar PVAR_8008, PVAR_40FB
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_043F
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_044A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0455
    pl_ReleaseAll
    pl_End

P382_043F:
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_044A:
    pl_msg_sys 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0455:
    pl_msg_sys 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0460:
    pl_CloseMessage
    pl_Call P382_04CF
    pl_ReleaseAll
    pl_End

P382_046C:
    pl_SetVarFromVar PVAR_8008, PVAR_40FB
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_049B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_04A6
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_04B1
    pl_End

P382_049B:
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_04A6:
    pl_msg_sys 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_04B1:
    pl_msg_sys 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_04BC:
    pl_FacePlayer
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_04CF
    pl_ReleaseAll
    pl_End

P382_04CF:
    pl_ApplyMovement 6, P382_212C
    pl_WaitMovement
    pl_Return

P382_S5:
P382_04DB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_551
    pl_CheckTrainerFlag PTRAINER_551
    pl_GoToIf 1, P382_0616
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_0666
    pl_SetVarFromVar PVAR_8008, PVAR_40FB
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0534
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0553
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0572
    pl_ReleaseAll
    pl_End

P382_0534:
    pl_msg_sys 8
    pl_FacePlayer
    pl_msg_sys 9
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0591
    pl_GoTo P382_060A

P382_0553:
    pl_msg_sys 16
    pl_FacePlayer
    pl_msg_sys 17
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0591
    pl_GoTo P382_060A

P382_0572:
    pl_msg_sys 24
    pl_FacePlayer
    pl_msg_sys 25
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0591
    pl_GoTo P382_060A

P382_0591:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_536, PTRAINER_551
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_536
    pl_SetTrainerFlag PTRAINER_551
    pl_Call P382_0679
    pl_SetVarFromVar PVAR_8008, PVAR_40FB
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_05E9
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_05F4
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_05FF
    pl_ReleaseAll
    pl_End

P382_05E9:
    pl_msg_sys 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_05F4:
    pl_msg_sys 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_05FF:
    pl_msg_sys 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_060A:
    pl_CloseMessage
    pl_Call P382_0679
    pl_ReleaseAll
    pl_End

P382_0616:
    pl_SetVarFromVar PVAR_8008, PVAR_40FB
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0645
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0650
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_065B
    pl_End

P382_0645:
    pl_msg_sys 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0650:
    pl_msg_sys 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_065B:
    pl_msg_sys 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0666:
    pl_FacePlayer
    pl_msg_sys 3
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_0679
    pl_ReleaseAll
    pl_End

P382_0679:
    pl_ApplyMovement 9, P382_2134
    pl_WaitMovement
    pl_Return

P382_S6:
P382_0685:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_545
    pl_CheckTrainerFlag PTRAINER_545
    pl_GoToIf 1, P382_07C0
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_0810
    pl_SetVarFromVar PVAR_8008, PVAR_40FC
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_06DE
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_06FD
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_071C
    pl_ReleaseAll
    pl_End

P382_06DE:
    pl_msg_sys 30
    pl_FacePlayer
    pl_msg_sys 31
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_073B
    pl_GoTo P382_07B4

P382_06FD:
    pl_msg_sys 38
    pl_FacePlayer
    pl_msg_sys 39
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_073B
    pl_GoTo P382_07B4

P382_071C:
    pl_msg_sys 46
    pl_FacePlayer
    pl_msg_sys 47
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_073B
    pl_GoTo P382_07B4

P382_073B:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_545, PTRAINER_546
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_545
    pl_SetTrainerFlag PTRAINER_546
    pl_Call P382_0823
    pl_SetVarFromVar PVAR_8008, PVAR_40FC
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0793
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_079E
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_07A9
    pl_ReleaseAll
    pl_End

P382_0793:
    pl_msg_sys 33
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_079E:
    pl_msg_sys 41
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_07A9:
    pl_msg_sys 49
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_07B4:
    pl_CloseMessage
    pl_Call P382_0823
    pl_ReleaseAll
    pl_End

P382_07C0:
    pl_SetVarFromVar PVAR_8008, PVAR_40FC
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_07EF
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_07FA
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0805
    pl_End

P382_07EF:
    pl_msg_sys 33
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_07FA:
    pl_msg_sys 41
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0805:
    pl_msg_sys 49
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0810:
    pl_FacePlayer
    pl_msg_sys 28
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_0823
    pl_ReleaseAll
    pl_End

P382_0823:
    pl_ApplyMovement 2, P382_212C
    pl_WaitMovement
    pl_Return

P382_S7:
P382_082F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_546
    pl_CheckTrainerFlag PTRAINER_546
    pl_GoToIf 1, P382_096A
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_09BA
    pl_SetVarFromVar PVAR_8008, PVAR_40FC
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0888
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_08A7
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_08C6
    pl_ReleaseAll
    pl_End

P382_0888:
    pl_msg_sys 34
    pl_FacePlayer
    pl_msg_sys 35
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_08E5
    pl_GoTo P382_095E

P382_08A7:
    pl_msg_sys 42
    pl_FacePlayer
    pl_msg_sys 43
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_08E5
    pl_GoTo P382_095E

P382_08C6:
    pl_msg_sys 50
    pl_FacePlayer
    pl_msg_sys 51
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_08E5
    pl_GoTo P382_095E

P382_08E5:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_545, PTRAINER_546
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_545
    pl_SetTrainerFlag PTRAINER_546
    pl_Call P382_09CD
    pl_SetVarFromVar PVAR_8008, PVAR_40FC
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_093D
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0948
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0953
    pl_ReleaseAll
    pl_End

P382_093D:
    pl_msg_sys 37
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0948:
    pl_msg_sys 45
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0953:
    pl_msg_sys 53
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_095E:
    pl_CloseMessage
    pl_Call P382_09CD
    pl_ReleaseAll
    pl_End

P382_096A:
    pl_SetVarFromVar PVAR_8008, PVAR_40FC
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0999
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_09A4
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_09AF
    pl_End

P382_0999:
    pl_msg_sys 37
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_09A4:
    pl_msg_sys 45
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_09AF:
    pl_msg_sys 53
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_09BA:
    pl_FacePlayer
    pl_msg_sys 29
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_09CD
    pl_ReleaseAll
    pl_End

P382_09CD:
    pl_ApplyMovement 3, P382_2134
    pl_WaitMovement
    pl_Return

P382_S8:
P382_09D9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_542
    pl_CheckTrainerFlag PTRAINER_542
    pl_GoToIf 1, P382_0B14
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_0B64
    pl_SetVarFromVar PVAR_8008, PVAR_40FD
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0A32
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0A51
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0A70
    pl_ReleaseAll
    pl_End

P382_0A32:
    pl_msg_sys 56
    pl_FacePlayer
    pl_msg_sys 57
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0A8F
    pl_GoTo P382_0B08

P382_0A51:
    pl_msg_sys 64
    pl_FacePlayer
    pl_msg_sys 65
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0A8F
    pl_GoTo P382_0B08

P382_0A70:
    pl_msg_sys 72
    pl_FacePlayer
    pl_msg_sys 73
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0A8F
    pl_GoTo P382_0B08

P382_0A8F:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_542, PTRAINER_543
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_542
    pl_SetTrainerFlag PTRAINER_543
    pl_Call P382_0B77
    pl_SetVarFromVar PVAR_8008, PVAR_40FD
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0AE7
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0AF2
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0AFD
    pl_ReleaseAll
    pl_End

P382_0AE7:
    pl_msg_sys 59
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0AF2:
    pl_msg_sys 67
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0AFD:
    pl_msg_sys 75
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0B08:
    pl_CloseMessage
    pl_Call P382_0B77
    pl_ReleaseAll
    pl_End

P382_0B14:
    pl_SetVarFromVar PVAR_8008, PVAR_40FD
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0B43
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0B4E
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0B59
    pl_End

P382_0B43:
    pl_msg_sys 59
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0B4E:
    pl_msg_sys 67
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0B59:
    pl_msg_sys 75
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0B64:
    pl_FacePlayer
    pl_msg_sys 54
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_0B77
    pl_ReleaseAll
    pl_End

P382_0B77:
    pl_ApplyMovement 0, P382_212C
    pl_WaitMovement
    pl_Return

P382_S9:
P382_0B83:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_543
    pl_CheckTrainerFlag PTRAINER_543
    pl_GoToIf 1, P382_0CBE
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_0D0E
    pl_SetVarFromVar PVAR_8008, PVAR_40FD
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0BDC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0BFB
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0C1A
    pl_ReleaseAll
    pl_End

P382_0BDC:
    pl_msg_sys 60
    pl_FacePlayer
    pl_msg_sys 61
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0C39
    pl_GoTo P382_0CB2

P382_0BFB:
    pl_msg_sys 68
    pl_FacePlayer
    pl_msg_sys 69
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0C39
    pl_GoTo P382_0CB2

P382_0C1A:
    pl_msg_sys 76
    pl_FacePlayer
    pl_msg_sys 77
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0C39
    pl_GoTo P382_0CB2

P382_0C39:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_542, PTRAINER_543
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_542
    pl_SetTrainerFlag PTRAINER_543
    pl_Call P382_0D21
    pl_SetVarFromVar PVAR_8008, PVAR_40FD
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0C91
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0C9C
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0CA7
    pl_ReleaseAll
    pl_End

P382_0C91:
    pl_msg_sys 63
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0C9C:
    pl_msg_sys 71
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0CA7:
    pl_msg_sys 79
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0CB2:
    pl_CloseMessage
    pl_Call P382_0D21
    pl_ReleaseAll
    pl_End

P382_0CBE:
    pl_SetVarFromVar PVAR_8008, PVAR_40FD
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0CED
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0CF8
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0D03
    pl_End

P382_0CED:
    pl_msg_sys 63
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0CF8:
    pl_msg_sys 71
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0D03:
    pl_msg_sys 79
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0D0E:
    pl_FacePlayer
    pl_msg_sys 55
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_0D21
    pl_ReleaseAll
    pl_End

P382_0D21:
    pl_ApplyMovement 1, P382_2134
    pl_WaitMovement
    pl_Return

P382_S10:
P382_0D2D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_539
    pl_CheckTrainerFlag PTRAINER_539
    pl_GoToIf 1, P382_0E68
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_0EB8
    pl_SetVarFromVar PVAR_8008, PVAR_40FE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0D86
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0DA5
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0DC4
    pl_ReleaseAll
    pl_End

P382_0D86:
    pl_msg_sys 82
    pl_FacePlayer
    pl_msg_sys 83
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0DE3
    pl_GoTo P382_0E5C

P382_0DA5:
    pl_msg_sys 90
    pl_FacePlayer
    pl_msg_sys 91
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0DE3
    pl_GoTo P382_0E5C

P382_0DC4:
    pl_msg_sys 98
    pl_FacePlayer
    pl_msg_sys 99
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0DE3
    pl_GoTo P382_0E5C

P382_0DE3:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_539, PTRAINER_535
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_539
    pl_SetTrainerFlag PTRAINER_535
    pl_Call P382_0ECB
    pl_SetVarFromVar PVAR_8008, PVAR_40FE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0E3B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0E46
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0E51
    pl_ReleaseAll
    pl_End

P382_0E3B:
    pl_msg_sys 85
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0E46:
    pl_msg_sys 93
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0E51:
    pl_msg_sys 101
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0E5C:
    pl_CloseMessage
    pl_Call P382_0ECB
    pl_ReleaseAll
    pl_End

P382_0E68:
    pl_SetVarFromVar PVAR_8008, PVAR_40FE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0E97
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0EA2
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0EAD
    pl_End

P382_0E97:
    pl_msg_sys 85
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0EA2:
    pl_msg_sys 93
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0EAD:
    pl_msg_sys 101
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0EB8:
    pl_FacePlayer
    pl_msg_sys 80
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_0ECB
    pl_ReleaseAll
    pl_End

P382_0ECB:
    pl_ApplyMovement 17, P382_212C
    pl_WaitMovement
    pl_Return

P382_S11:
P382_0ED7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_535
    pl_CheckTrainerFlag PTRAINER_535
    pl_GoToIf 1, P382_1012
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_1062
    pl_SetVarFromVar PVAR_8008, PVAR_40FE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0F30
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0F4F
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0F6E
    pl_ReleaseAll
    pl_End

P382_0F30:
    pl_msg_sys 86
    pl_FacePlayer
    pl_msg_sys 87
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0F8D
    pl_GoTo P382_1006

P382_0F4F:
    pl_msg_sys 94
    pl_FacePlayer
    pl_msg_sys 95
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0F8D
    pl_GoTo P382_1006

P382_0F6E:
    pl_msg_sys 102
    pl_FacePlayer
    pl_msg_sys 103
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_0F8D
    pl_GoTo P382_1006

P382_0F8D:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_539, PTRAINER_535
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_539
    pl_SetTrainerFlag PTRAINER_535
    pl_Call P382_1075
    pl_SetVarFromVar PVAR_8008, PVAR_40FE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_0FE5
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_0FF0
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_0FFB
    pl_ReleaseAll
    pl_End

P382_0FE5:
    pl_msg_sys 89
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0FF0:
    pl_msg_sys 97
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_0FFB:
    pl_msg_sys 105
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1006:
    pl_CloseMessage
    pl_Call P382_1075
    pl_ReleaseAll
    pl_End

P382_1012:
    pl_SetVarFromVar PVAR_8008, PVAR_40FE
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1041
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_104C
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1057
    pl_End

P382_1041:
    pl_msg_sys 89
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_104C:
    pl_msg_sys 97
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1057:
    pl_msg_sys 105
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1062:
    pl_FacePlayer
    pl_msg_sys 81
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_1075
    pl_ReleaseAll
    pl_End

P382_1075:
    pl_ApplyMovement 10, P382_2134
    pl_WaitMovement
    pl_Return

P382_S12:
P382_1081:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_548
    pl_CheckTrainerFlag PTRAINER_548
    pl_GoToIf 1, P382_11BC
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_120C
    pl_SetVarFromVar PVAR_8008, PVAR_40FF
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_10DA
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_10F9
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1118
    pl_ReleaseAll
    pl_End

P382_10DA:
    pl_msg_sys 108
    pl_FacePlayer
    pl_msg_sys 109
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1137
    pl_GoTo P382_11B0

P382_10F9:
    pl_msg_sys 116
    pl_FacePlayer
    pl_msg_sys 117
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1137
    pl_GoTo P382_11B0

P382_1118:
    pl_msg_sys 124
    pl_FacePlayer
    pl_msg_sys 125
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1137
    pl_GoTo P382_11B0

P382_1137:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_548, PTRAINER_540
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_548
    pl_SetTrainerFlag PTRAINER_540
    pl_Call P382_121F
    pl_SetVarFromVar PVAR_8008, PVAR_40FF
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_118F
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_119A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_11A5
    pl_ReleaseAll
    pl_End

P382_118F:
    pl_msg_sys 111
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_119A:
    pl_msg_sys 119
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_11A5:
    pl_msg_sys 127
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_11B0:
    pl_CloseMessage
    pl_Call P382_121F
    pl_ReleaseAll
    pl_End

P382_11BC:
    pl_SetVarFromVar PVAR_8008, PVAR_40FF
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_11EB
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_11F6
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1201
    pl_End

P382_11EB:
    pl_msg_sys 111
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_11F6:
    pl_msg_sys 119
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1201:
    pl_msg_sys 127
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_120C:
    pl_FacePlayer
    pl_msg_sys 106
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_121F
    pl_ReleaseAll
    pl_End

P382_121F:
    pl_ApplyMovement 15, P382_212C
    pl_WaitMovement
    pl_Return

P382_S13:
P382_122B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_540
    pl_CheckTrainerFlag PTRAINER_540
    pl_GoToIf 1, P382_1366
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_13B6
    pl_SetVarFromVar PVAR_8008, PVAR_40FF
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1284
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_12A3
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_12C2
    pl_ReleaseAll
    pl_End

P382_1284:
    pl_msg_sys 112
    pl_FacePlayer
    pl_msg_sys 113
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_12E1
    pl_GoTo P382_135A

P382_12A3:
    pl_msg_sys 120
    pl_FacePlayer
    pl_msg_sys 121
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_12E1
    pl_GoTo P382_135A

P382_12C2:
    pl_msg_sys 128
    pl_FacePlayer
    pl_msg_sys 129
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_12E1
    pl_GoTo P382_135A

P382_12E1:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_548, PTRAINER_540
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_548
    pl_SetTrainerFlag PTRAINER_540
    pl_Call P382_13C9
    pl_SetVarFromVar PVAR_8008, PVAR_40FF
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1339
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1344
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_134F
    pl_ReleaseAll
    pl_End

P382_1339:
    pl_msg_sys 115
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1344:
    pl_msg_sys 123
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_134F:
    pl_msg_sys 131
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_135A:
    pl_CloseMessage
    pl_Call P382_13C9
    pl_ReleaseAll
    pl_End

P382_1366:
    pl_SetVarFromVar PVAR_8008, PVAR_40FF
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1395
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_13A0
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_13AB
    pl_End

P382_1395:
    pl_msg_sys 115
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_13A0:
    pl_msg_sys 123
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_13AB:
    pl_msg_sys 131
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_13B6:
    pl_FacePlayer
    pl_msg_sys 107
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_13C9
    pl_ReleaseAll
    pl_End

P382_13C9:
    pl_ApplyMovement 13, P382_2134
    pl_WaitMovement
    pl_Return

P382_S14:
P382_13D5:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_552
    pl_CheckTrainerFlag PTRAINER_552
    pl_GoToIf 1, P382_1510
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_1560
    pl_SetVarFromVar PVAR_8008, PVAR_4100
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_142E
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_144D
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_146C
    pl_ReleaseAll
    pl_End

P382_142E:
    pl_msg_sys 134
    pl_FacePlayer
    pl_msg_sys 135
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_148B
    pl_GoTo P382_1504

P382_144D:
    pl_msg_sys 142
    pl_FacePlayer
    pl_msg_sys 143
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_148B
    pl_GoTo P382_1504

P382_146C:
    pl_msg_sys 150
    pl_FacePlayer
    pl_msg_sys 151
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_148B
    pl_GoTo P382_1504

P382_148B:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_552, PTRAINER_544
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_552
    pl_SetTrainerFlag PTRAINER_544
    pl_Call P382_1573
    pl_SetVarFromVar PVAR_8008, PVAR_4100
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_14E3
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_14EE
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_14F9
    pl_ReleaseAll
    pl_End

P382_14E3:
    pl_msg_sys 137
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_14EE:
    pl_msg_sys 145
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_14F9:
    pl_msg_sys 153
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1504:
    pl_CloseMessage
    pl_Call P382_1573
    pl_ReleaseAll
    pl_End

P382_1510:
    pl_SetVarFromVar PVAR_8008, PVAR_4100
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_153F
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_154A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1555
    pl_End

P382_153F:
    pl_msg_sys 137
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_154A:
    pl_msg_sys 145
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1555:
    pl_msg_sys 153
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1560:
    pl_FacePlayer
    pl_msg_sys 132
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_1573
    pl_ReleaseAll
    pl_End

P382_1573:
    pl_ApplyMovement 11, P382_212C
    pl_WaitMovement
    pl_Return

P382_S15:
P382_157F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_544
    pl_CheckTrainerFlag PTRAINER_544
    pl_GoToIf 1, P382_16BA
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_170A
    pl_SetVarFromVar PVAR_8008, PVAR_4100
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_15D8
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_15F7
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1616
    pl_ReleaseAll
    pl_End

P382_15D8:
    pl_msg_sys 138
    pl_FacePlayer
    pl_msg_sys 139
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1635
    pl_GoTo P382_16AE

P382_15F7:
    pl_msg_sys 146
    pl_FacePlayer
    pl_msg_sys 147
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1635
    pl_GoTo P382_16AE

P382_1616:
    pl_msg_sys 154
    pl_FacePlayer
    pl_msg_sys 155
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1635
    pl_GoTo P382_16AE

P382_1635:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_552, PTRAINER_544
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_552
    pl_SetTrainerFlag PTRAINER_544
    pl_Call P382_171D
    pl_SetVarFromVar PVAR_8008, PVAR_4100
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_168D
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1698
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_16A3
    pl_ReleaseAll
    pl_End

P382_168D:
    pl_msg_sys 141
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1698:
    pl_msg_sys 149
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_16A3:
    pl_msg_sys 157
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_16AE:
    pl_CloseMessage
    pl_Call P382_171D
    pl_ReleaseAll
    pl_End

P382_16BA:
    pl_SetVarFromVar PVAR_8008, PVAR_4100
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_16E9
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_16F4
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_16FF
    pl_End

P382_16E9:
    pl_msg_sys 141
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_16F4:
    pl_msg_sys 149
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_16FF:
    pl_msg_sys 157
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_170A:
    pl_FacePlayer
    pl_msg_sys 133
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_171D
    pl_ReleaseAll
    pl_End

P382_171D:
    pl_ApplyMovement 12, P382_2134
    pl_WaitMovement
    pl_Return

P382_S16:
P382_1729:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_538
    pl_CheckTrainerFlag PTRAINER_538
    pl_GoToIf 1, P382_1864
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_18B4
    pl_SetVarFromVar PVAR_8008, PVAR_4101
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1782
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_17A1
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_17C0
    pl_ReleaseAll
    pl_End

P382_1782:
    pl_msg_sys 160
    pl_FacePlayer
    pl_msg_sys 161
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_17DF
    pl_GoTo P382_1858

P382_17A1:
    pl_msg_sys 168
    pl_FacePlayer
    pl_msg_sys 169
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_17DF
    pl_GoTo P382_1858

P382_17C0:
    pl_msg_sys 176
    pl_FacePlayer
    pl_msg_sys 177
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_17DF
    pl_GoTo P382_1858

P382_17DF:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_538, PTRAINER_547
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_538
    pl_SetTrainerFlag PTRAINER_547
    pl_Call P382_18C7
    pl_SetVarFromVar PVAR_8008, PVAR_4101
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1837
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1842
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_184D
    pl_ReleaseAll
    pl_End

P382_1837:
    pl_msg_sys 163
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1842:
    pl_msg_sys 171
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_184D:
    pl_msg_sys 179
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1858:
    pl_CloseMessage
    pl_Call P382_18C7
    pl_ReleaseAll
    pl_End

P382_1864:
    pl_SetVarFromVar PVAR_8008, PVAR_4101
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1893
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_189E
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_18A9
    pl_End

P382_1893:
    pl_msg_sys 163
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_189E:
    pl_msg_sys 171
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_18A9:
    pl_msg_sys 179
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_18B4:
    pl_FacePlayer
    pl_msg_sys 158
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_18C7
    pl_ReleaseAll
    pl_End

P382_18C7:
    pl_ApplyMovement 5, P382_212C
    pl_WaitMovement
    pl_Return

P382_S17:
P382_18D3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_547
    pl_CheckTrainerFlag PTRAINER_547
    pl_GoToIf 1, P382_1A0E
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_1A5E
    pl_SetVarFromVar PVAR_8008, PVAR_4101
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_192C
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_194B
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_196A
    pl_ReleaseAll
    pl_End

P382_192C:
    pl_msg_sys 164
    pl_FacePlayer
    pl_msg_sys 165
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1989
    pl_GoTo P382_1A02

P382_194B:
    pl_msg_sys 172
    pl_FacePlayer
    pl_msg_sys 173
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1989
    pl_GoTo P382_1A02

P382_196A:
    pl_msg_sys 180
    pl_FacePlayer
    pl_msg_sys 181
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1989
    pl_GoTo P382_1A02

P382_1989:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_538, PTRAINER_547
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_538
    pl_SetTrainerFlag PTRAINER_547
    pl_Call P382_1A71
    pl_SetVarFromVar PVAR_8008, PVAR_4101
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_19E1
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_19EC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_19F7
    pl_ReleaseAll
    pl_End

P382_19E1:
    pl_msg_sys 167
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_19EC:
    pl_msg_sys 175
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_19F7:
    pl_msg_sys 183
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1A02:
    pl_CloseMessage
    pl_Call P382_1A71
    pl_ReleaseAll
    pl_End

P382_1A0E:
    pl_SetVarFromVar PVAR_8008, PVAR_4101
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1A3D
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1A48
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1A53
    pl_End

P382_1A3D:
    pl_msg_sys 167
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1A48:
    pl_msg_sys 175
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1A53:
    pl_msg_sys 183
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1A5E:
    pl_FacePlayer
    pl_msg_sys 159
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_1A71
    pl_ReleaseAll
    pl_End

P382_1A71:
    pl_ApplyMovement 4, P382_2134
    pl_WaitMovement
    pl_Return

P382_S18:
P382_1A7D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_541
    pl_CheckTrainerFlag PTRAINER_541
    pl_GoToIf 1, P382_1BB8
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_1C08
    pl_SetVarFromVar PVAR_8008, PVAR_4102
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1AD6
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1AF5
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1B14
    pl_ReleaseAll
    pl_End

P382_1AD6:
    pl_msg_sys 186
    pl_FacePlayer
    pl_msg_sys 187
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1B33
    pl_GoTo P382_1BAC

P382_1AF5:
    pl_msg_sys 194
    pl_FacePlayer
    pl_msg_sys 195
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1B33
    pl_GoTo P382_1BAC

P382_1B14:
    pl_msg_sys 202
    pl_FacePlayer
    pl_msg_sys 203
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1B33
    pl_GoTo P382_1BAC

P382_1B33:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_541, PTRAINER_550
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_541
    pl_SetTrainerFlag PTRAINER_550
    pl_Call P382_1C1B
    pl_SetVarFromVar PVAR_8008, PVAR_4102
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1B8B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1B96
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1BA1
    pl_ReleaseAll
    pl_End

P382_1B8B:
    pl_msg_sys 189
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1B96:
    pl_msg_sys 197
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1BA1:
    pl_msg_sys 205
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1BAC:
    pl_CloseMessage
    pl_Call P382_1C1B
    pl_ReleaseAll
    pl_End

P382_1BB8:
    pl_SetVarFromVar PVAR_8008, PVAR_4102
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1BE7
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1BF2
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1BFD
    pl_End

P382_1BE7:
    pl_msg_sys 189
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1BF2:
    pl_msg_sys 197
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1BFD:
    pl_msg_sys 205
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1C08:
    pl_FacePlayer
    pl_msg_sys 184
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_1C1B
    pl_ReleaseAll
    pl_End

P382_1C1B:
    pl_ApplyMovement 7, P382_212C
    pl_WaitMovement
    pl_Return

P382_S19:
P382_1C27:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_550
    pl_CheckTrainerFlag PTRAINER_550
    pl_GoToIf 1, P382_1D62
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_1DB2
    pl_SetVarFromVar PVAR_8008, PVAR_4102
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1C80
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1C9F
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1CBE
    pl_ReleaseAll
    pl_End

P382_1C80:
    pl_msg_sys 190
    pl_FacePlayer
    pl_msg_sys 191
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1CDD
    pl_GoTo P382_1D56

P382_1C9F:
    pl_msg_sys 198
    pl_FacePlayer
    pl_msg_sys 199
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1CDD
    pl_GoTo P382_1D56

P382_1CBE:
    pl_msg_sys 206
    pl_FacePlayer
    pl_msg_sys 207
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1CDD
    pl_GoTo P382_1D56

P382_1CDD:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_541, PTRAINER_550
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_541
    pl_SetTrainerFlag PTRAINER_550
    pl_Call P382_1DC5
    pl_SetVarFromVar PVAR_8008, PVAR_4102
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1D35
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1D40
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1D4B
    pl_ReleaseAll
    pl_End

P382_1D35:
    pl_msg_sys 193
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1D40:
    pl_msg_sys 201
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1D4B:
    pl_msg_sys 209
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1D56:
    pl_CloseMessage
    pl_Call P382_1DC5
    pl_ReleaseAll
    pl_End

P382_1D62:
    pl_SetVarFromVar PVAR_8008, PVAR_4102
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1D91
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1D9C
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1DA7
    pl_End

P382_1D91:
    pl_msg_sys 193
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1D9C:
    pl_msg_sys 201
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1DA7:
    pl_msg_sys 209
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1DB2:
    pl_FacePlayer
    pl_msg_sys 185
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_1DC5
    pl_ReleaseAll
    pl_End

P382_1DC5:
    pl_ApplyMovement 8, P382_2134
    pl_WaitMovement
    pl_Return

P382_S20:
P382_1DD1:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_549
    pl_CheckTrainerFlag PTRAINER_549
    pl_GoToIf 1, P382_1F0C
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_1F5C
    pl_SetVarFromVar PVAR_8008, PVAR_4103
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1E2A
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1E49
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1E68
    pl_ReleaseAll
    pl_End

P382_1E2A:
    pl_msg_sys 212
    pl_FacePlayer
    pl_msg_sys 213
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1E87
    pl_GoTo P382_1F00

P382_1E49:
    pl_msg_sys 220
    pl_FacePlayer
    pl_msg_sys 221
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1E87
    pl_GoTo P382_1F00

P382_1E68:
    pl_msg_sys 228
    pl_FacePlayer
    pl_msg_sys 229
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_1E87
    pl_GoTo P382_1F00

P382_1E87:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_549, PTRAINER_537
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_549
    pl_SetTrainerFlag PTRAINER_537
    pl_Call P382_1F6F
    pl_SetVarFromVar PVAR_8008, PVAR_4103
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1EDF
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1EEA
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1EF5
    pl_ReleaseAll
    pl_End

P382_1EDF:
    pl_msg_sys 215
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1EEA:
    pl_msg_sys 223
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1EF5:
    pl_msg_sys 231
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1F00:
    pl_CloseMessage
    pl_Call P382_1F6F
    pl_ReleaseAll
    pl_End

P382_1F0C:
    pl_SetVarFromVar PVAR_8008, PVAR_4103
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1F3B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1F46
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_1F51
    pl_End

P382_1F3B:
    pl_msg_sys 215
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1F46:
    pl_msg_sys 223
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1F51:
    pl_msg_sys 231
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_1F5C:
    pl_FacePlayer
    pl_msg_sys 210
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_1F6F
    pl_ReleaseAll
    pl_End

P382_1F6F:
    pl_ApplyMovement 14, P382_212C
    pl_WaitMovement
    pl_Return

P382_S21:
P382_1F7B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckTrainerFlag PTRAINER_537
    pl_CheckTrainerFlag PTRAINER_537
    pl_GoToIf 1, P382_20B6
    PokePartyGetCount PVAR_800C, 2  // Pearl CountAliveMonsExcept 32780, 6: no slot left out
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P382_2106
    pl_SetVarFromVar PVAR_8008, PVAR_4103
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_1FD4
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_1FF3
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_2012
    pl_ReleaseAll
    pl_End

P382_1FD4:
    pl_msg_sys 216
    pl_FacePlayer
    pl_msg_sys 217
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2031
    pl_GoTo P382_20AA

P382_1FF3:
    pl_msg_sys 224
    pl_FacePlayer
    pl_msg_sys 225
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2031
    pl_GoTo P382_20AA

P382_2012:
    pl_msg_sys 232
    pl_FacePlayer
    pl_msg_sys 233
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2031
    pl_GoTo P382_20AA

P382_2031:
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_549, PTRAINER_537
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P382_2125
    pl_SetTrainerFlag PTRAINER_549
    pl_SetTrainerFlag PTRAINER_537
    pl_Call P382_2119
    pl_SetVarFromVar PVAR_8008, PVAR_4103
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_2089
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_2094
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_209F
    pl_ReleaseAll
    pl_End

P382_2089:
    pl_msg_sys 219
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_2094:
    pl_msg_sys 227
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_209F:
    pl_msg_sys 235
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_20AA:
    pl_CloseMessage
    pl_Call P382_2119
    pl_ReleaseAll
    pl_End

P382_20B6:
    pl_SetVarFromVar PVAR_8008, PVAR_4103
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P382_20E5
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P382_20F0
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P382_20FB
    pl_End

P382_20E5:
    pl_msg_sys 219
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_20F0:
    pl_msg_sys 227
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_20FB:
    pl_msg_sys 235
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P382_2106:
    pl_FacePlayer
    pl_msg_sys 211
    pl_WaitButton
    pl_CloseMessage
    pl_Call P382_2119
    pl_ReleaseAll
    pl_End

P382_2119:
    pl_ApplyMovement 16, P382_2134
    pl_WaitMovement
    pl_Return

P382_2125:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P382_212C:
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P382_2134:
    Move 2, 1  // FACE_WEST
    MoveEnd

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
