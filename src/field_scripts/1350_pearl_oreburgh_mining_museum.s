// MAP_OREBURGH_MINING_MUSEUM: Pearl script file 63, text bank 72. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-13: Pearl's; no warp continuations; 14: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P63_S1
    ScriptEntry P63_S2
    ScriptEntry P63_S3
    ScriptEntry P63_S4
    ScriptEntry P63_S5
    ScriptEntry P63_S6
    ScriptEntry P63_S7
    ScriptEntry P63_S8
    ScriptEntry P63_S9
    ScriptEntry P63_S10
    ScriptEntry P63_S11
    ScriptEntry P63_S12
    ScriptEntry P63_S13
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P63_S1:
P63_0036:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S2:
P63_0049:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0001
    pl_GoToIf 1, P63_03CC
    pl_msg_talk 1
    pl_CheckFlag PFLAG_0079
    pl_GoToIf 0, P63_0493
    pl_CompareVarToValue PVAR_40B4, 0
    pl_GoToIf 5, P63_03E6
    pl_stub GetFossilCount  // Pearl 0x1F1 CountFossils 32768: not translated yet
    pl_CompareVarToValue PVAR_8000, 0
    pl_GoToIf 1, P63_0488
    pl_msg_talk 2
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P63_03DB
    pl_CompareVarToValue PVAR_8000, 1
    pl_GoToIf 1, P63_03B0
    pl_SetVarFromValue PVAR_8001, 0
    pl_CheckItem 103, 1, PVAR_800C
    pl_AddVar PVAR_8001, PVAR_800C
    pl_CheckItem 101, 1, PVAR_800C
    pl_AddVar PVAR_8001, PVAR_800C
    pl_CheckItem 102, 1, PVAR_800C
    pl_AddVar PVAR_8001, PVAR_800C
    pl_CheckItem 99, 1, PVAR_800C
    pl_AddVar PVAR_8001, PVAR_800C
    pl_CheckItem 100, 1, PVAR_800C
    pl_AddVar PVAR_8001, PVAR_800C
    pl_CheckItem 104, 1, PVAR_800C
    pl_AddVar PVAR_8001, PVAR_800C
    pl_CheckItem 105, 1, PVAR_800C
    pl_AddVar PVAR_8001, PVAR_800C
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 1, P63_03B0
    pl_SetVarFromValue PVAR_8004, 0
    pl_SetVarFromValue PVAR_8005, 0
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8003  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_8003

P63_0132:
    pl_CompareVarToValue PVAR_8005, 0
    pl_CallIf 1, P63_02D0
    pl_CompareVarToValue PVAR_8005, 1
    pl_CallIf 1, P63_02E0
    pl_CompareVarToValue PVAR_8005, 2
    pl_CallIf 1, P63_02F0
    pl_CompareVarToValue PVAR_8005, 3
    pl_CallIf 1, P63_0300
    pl_CompareVarToValue PVAR_8005, 4
    pl_CallIf 1, P63_0310
    pl_CompareVarToValue PVAR_8005, 5
    pl_CallIf 1, P63_0320
    pl_CompareVarToValue PVAR_8005, 6
    pl_CallIf 1, P63_0330
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P63_020D
    pl_CompareVarToValue PVAR_8004, 0
    pl_CallIf 1, P63_0340
    pl_CompareVarToValue PVAR_8004, 1
    pl_CallIf 1, P63_0348
    pl_CompareVarToValue PVAR_8004, 2
    pl_CallIf 1, P63_0350
    pl_CompareVarToValue PVAR_8004, 3
    pl_CallIf 1, P63_0358
    pl_CompareVarToValue PVAR_8004, 4
    pl_CallIf 1, P63_0360
    pl_CompareVarToValue PVAR_8004, 5
    pl_CallIf 1, P63_0368
    pl_CompareVarToValue PVAR_8004, 6
    pl_CallIf 1, P63_0370
    pl_SetVarFromVar PVAR_8006, PVAR_8005
    pl_AddVar PVAR_8006, 156
    pl_stub AddMenuEntry  // line from PVAR_8006: Black 2 menus take a fixed line
    pl_GoTo P63_0219

P63_020D:
    pl_AddVar PVAR_8005, 1
    pl_GoTo P63_0132

P63_0219:
    pl_AddVar PVAR_8004, 1
    pl_AddVar PVAR_8005, 1
    pl_CompareVarToVar PVAR_8004, PVAR_8001
    pl_GoToIf 5, P63_0132
    ListMenuAdd 24, 65535, PVAR_8004  // Pearl AddMenuEntry 44, PVAR_8004
    ListMenuShow
    pl_CompareVarToValue PVAR_8003, 255
    pl_GoToIf 1, P63_03DB
    pl_CompareVarToVar PVAR_8003, PVAR_4000
    pl_GoToIf 1, P63_03DB
    pl_CompareVarToValue PVAR_8003, 0
    pl_CallIf 1, P63_0378
    pl_CompareVarToValue PVAR_8003, 1
    pl_CallIf 1, P63_0380
    pl_CompareVarToValue PVAR_8003, 2
    pl_CallIf 1, P63_0388
    pl_CompareVarToValue PVAR_8003, 3
    pl_CallIf 1, P63_0390
    pl_CompareVarToValue PVAR_8003, 4
    pl_CallIf 1, P63_0398
    pl_CompareVarToValue PVAR_8003, 5
    pl_CallIf 1, P63_03A0
    pl_CompareVarToValue PVAR_8003, 6
    pl_CallIf 1, P63_03A8
    pl_stub GetSpeciesFromFossil  // Pearl 0x1F4 GetFossilPokemon 16564, 32770: not translated yet
    pl_CompareVarToValue PVAR_40B4, 0
    pl_GoToIf 1, P63_03DB
    pl_RemoveItem PVAR_8002, 1, PVAR_800C
    pl_GoTo P63_03CC

P63_02D0:
    pl_SetVarFromValue PVAR_4000, 103
    pl_CheckItem PVAR_4000, 1, PVAR_800C
    pl_Return

P63_02E0:
    pl_SetVarFromValue PVAR_4000, 101
    pl_CheckItem PVAR_4000, 1, PVAR_800C
    pl_Return

P63_02F0:
    pl_SetVarFromValue PVAR_4000, 102
    pl_CheckItem PVAR_4000, 1, PVAR_800C
    pl_Return

P63_0300:
    pl_SetVarFromValue PVAR_4000, 99
    pl_CheckItem PVAR_4000, 1, PVAR_800C
    pl_Return

P63_0310:
    pl_SetVarFromValue PVAR_4000, 100
    pl_CheckItem PVAR_4000, 1, PVAR_800C
    pl_Return

P63_0320:
    pl_SetVarFromValue PVAR_4000, 104
    pl_CheckItem PVAR_4000, 1, PVAR_800C
    pl_Return

P63_0330:
    pl_SetVarFromValue PVAR_4000, 105
    pl_CheckItem PVAR_4000, 1, PVAR_800C
    pl_Return

P63_0340:
    pl_SetVarFromVar PVAR_4001, PVAR_4000
    pl_Return

P63_0348:
    pl_SetVarFromVar PVAR_4002, PVAR_4000
    pl_Return

P63_0350:
    pl_SetVarFromVar PVAR_4003, PVAR_4000
    pl_Return

P63_0358:
    pl_SetVarFromVar PVAR_4004, PVAR_4000
    pl_Return

P63_0360:
    pl_SetVarFromVar PVAR_4005, PVAR_4000
    pl_Return

P63_0368:
    pl_SetVarFromVar PVAR_4006, PVAR_4000
    pl_Return

P63_0370:
    pl_SetVarFromVar PVAR_4007, PVAR_4000
    pl_Return

P63_0378:
    pl_SetVarFromVar PVAR_8002, PVAR_4001
    pl_Return

P63_0380:
    pl_SetVarFromVar PVAR_8002, PVAR_4002
    pl_Return

P63_0388:
    pl_SetVarFromVar PVAR_8002, PVAR_4003
    pl_Return

P63_0390:
    pl_SetVarFromVar PVAR_8002, PVAR_4004
    pl_Return

P63_0398:
    pl_SetVarFromVar PVAR_8002, PVAR_4005
    pl_Return

P63_03A0:
    pl_SetVarFromVar PVAR_8002, PVAR_4006
    pl_Return

P63_03A8:
    pl_SetVarFromVar PVAR_8002, PVAR_4007
    pl_Return

P63_03B0:
    pl_stub FindFossilAtThreshold  // Pearl 0x1F5 GetFossilMinimumAmount 32770, 32772, 1: not translated yet
    pl_stub GetSpeciesFromFossil  // Pearl 0x1F4 GetFossilPokemon 16564, 32770: not translated yet
    pl_RemoveItem PVAR_8002, 1, PVAR_800C
    pl_GoTo P63_03CC

P63_03CC:
    pl_SetFlag PFLAG_0001
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_03DB:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_03E6:
    pl_BufferSpeciesName 0, PVAR_40B4
    pl_msg_talk 7
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, P63_047D
    pl_BufferSpeciesName 1, PVAR_40B4
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_msg_talk 8
    pl_WaitFanfare
    pl_GivePokemon PVAR_40B4, 20, 0, PVAR_800C
    pl_SetVarFromValue PVAR_40B4, 0
    pl_msg_talk 9
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P63_0449
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P63_0477
    pl_End

P63_0449:
    pl_CloseMessage
    pl_GetPartyCount PVAR_4000
    pl_SubVar PVAR_4000, 1
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_OpenPokemonNamingScreen PVAR_4000, PVAR_800C
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P63_0477:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_047D:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_0488:
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_0493:
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S3:
P63_049E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S4:
P63_04B1:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S5:
P63_04C4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S6:
P63_04D7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S7:
P63_04E8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S8:
P63_04F9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S9:
P63_050A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S10:
P63_051B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S11:
P63_052C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 21
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S12:
P63_053D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P63_S13:
P63_054E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 23
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
