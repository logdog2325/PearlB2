// MAP_JUBLIFE_POKETCH_COMPANY_3F: Pearl script file 10, text bank 24. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; no warp continuations; 8: PearlArrive; 107: Pearl 2508
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P10_S1
    ScriptEntry P10_S2
    ScriptEntry P10_S3
    ScriptEntry P10_S4
    ScriptEntry P10_S5
    ScriptEntry P10_S6
    ScriptEntry P10_S7
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
    ScriptEntry PearlProxy_2508
    ScriptEntriesEnd

P10_S1:
P10_001E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P10_S2:
P10_0031:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P10_S3:
P10_0044:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P10_S4:
P10_0057:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 3

P10_0062:
    pl_msg_sys 4
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_8004
    pl_CheckPoketchEnabled PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_00A2
    pl_Call P10_00FE
    pl_Call P10_0122
    pl_Call P10_0146
    pl_Call P10_016A
    pl_Call P10_018E
    pl_Call P10_01B2

P10_00A2:
    ListMenuAdd 36, 65535, 0  // Pearl AddMenuEntry 258, 0
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P10_0119
    pl_CompareVarToValue PVAR_8004, 2
    pl_GoToIf 1, P10_013D
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P10_0161
    pl_CompareVarToValue PVAR_8004, 4
    pl_GoToIf 1, P10_0185
    pl_CompareVarToValue PVAR_8004, 5
    pl_GoToIf 1, P10_01A9
    pl_CompareVarToValue PVAR_8004, 6
    pl_GoToIf 1, P10_01CD
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P10_00FE:
    pl_CheckPoketchAppRegistered 0, PVAR_800C  // Digital Watch
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_01D6
    ListMenuAdd 37, 65535, 1  // Pearl AddMenuEntry 233, 1
    pl_Return

P10_0119:
    pl_msg_sys 11
    pl_GoTo P10_0062

P10_0122:
    pl_CheckPoketchAppRegistered 11, PVAR_800C  // Analog Watch
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_01D6
    ListMenuAdd 38, 65535, 2  // Pearl AddMenuEntry 237, 2
    pl_Return

P10_013D:
    pl_msg_sys 12
    pl_GoTo P10_0062

P10_0146:
    pl_CheckPoketchAppRegistered 23, PVAR_800C  // Stopwatch
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_01D6
    ListMenuAdd 39, 65535, 3  // Pearl AddMenuEntry 234, 3
    pl_Return

P10_0161:
    pl_msg_sys 14
    pl_GoTo P10_0062

P10_016A:
    pl_CheckPoketchAppRegistered 20, PVAR_800C  // Kitchen Timer
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_01D6
    ListMenuAdd 40, 65535, 4  // Pearl AddMenuEntry 250, 4
    pl_Return

P10_0185:
    pl_msg_sys 15
    pl_GoTo P10_0062

P10_018E:
    pl_CheckPoketchAppRegistered 24, PVAR_800C  // Alarm Clock
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_01D6
    ListMenuAdd 41, 65535, 5  // Pearl AddMenuEntry 249, 5
    pl_Return

P10_01A9:
    pl_msg_sys 13
    pl_GoTo P10_0062

P10_01B2:
    pl_CheckPoketchAppRegistered 16, PVAR_800C  // Calendar
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_01D6
    ListMenuAdd 42, 65535, 6  // Pearl AddMenuEntry 254, 6
    pl_Return

P10_01CD:
    pl_msg_sys 16
    pl_GoTo P10_0062

P10_01D6:
    pl_Return

P10_S5:
P10_01D8:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 5

P10_01E3:
    pl_msg_sys 6
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_8004
    pl_CheckPoketchEnabled PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_0229
    pl_Call P10_0292
    pl_Call P10_02B6
    pl_Call P10_02DA
    pl_Call P10_02FE
    pl_Call P10_0322
    pl_Call P10_0346
    pl_Call P10_036A

P10_0229:
    ListMenuAdd 36, 65535, 0  // Pearl AddMenuEntry 258, 0
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P10_02AD
    pl_CompareVarToValue PVAR_8004, 2
    pl_GoToIf 1, P10_02D1
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P10_02F5
    pl_CompareVarToValue PVAR_8004, 4
    pl_GoToIf 1, P10_0319
    pl_CompareVarToValue PVAR_8004, 5
    pl_GoToIf 1, P10_033D
    pl_CompareVarToValue PVAR_8004, 6
    pl_GoToIf 1, P10_0361
    pl_CompareVarToValue PVAR_8004, 7
    pl_GoToIf 1, P10_0385
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P10_0292:
    pl_CheckPoketchAppRegistered 1, PVAR_800C  // Calculator
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_038E
    ListMenuAdd 43, 65535, 1  // Pearl AddMenuEntry 235, 1
    pl_Return

P10_02AD:
    pl_msg_sys 17
    pl_GoTo P10_01E3

P10_02B6:
    pl_CheckPoketchAppRegistered 2, PVAR_800C  // Memo Pad
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_038E
    ListMenuAdd 44, 65535, 2  // Pearl AddMenuEntry 236, 2
    pl_Return

P10_02D1:
    pl_msg_sys 24
    pl_GoTo P10_01E3

P10_02DA:
    pl_CheckPoketchAppRegistered 5, PVAR_800C  // Friendship Checker
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_038E
    ListMenuAdd 45, 65535, 3  // Pearl AddMenuEntry 240, 3
    pl_Return

P10_02F5:
    pl_msg_sys 19
    pl_GoTo P10_01E3

P10_02FE:
    pl_CheckPoketchAppRegistered 8, PVAR_800C  // Day-Care Checker
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_038E
    ListMenuAdd 46, 65535, 4  // Pearl AddMenuEntry 244, 4
    pl_Return

P10_0319:
    pl_msg_sys 20
    pl_GoTo P10_01E3

P10_0322:
    pl_CheckPoketchAppRegistered 22, PVAR_800C  // Matchup Checker
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_038E
    ListMenuAdd 47, 65535, 5  // Pearl AddMenuEntry 248, 5
    pl_Return

P10_033D:
    pl_msg_sys 21
    pl_GoTo P10_01E3

P10_0346:
    pl_CheckPoketchAppRegistered 9, PVAR_800C  // Pokémon History
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_038E
    ListMenuAdd 48, 65535, 6  // Pearl AddMenuEntry 257, 6
    pl_Return

P10_0361:
    pl_msg_sys 22
    pl_GoTo P10_01E3

P10_036A:
    pl_CheckPoketchAppRegistered 7, PVAR_800C  // Berry Searcher
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_038E
    ListMenuAdd 49, 65535, 7  // Pearl AddMenuEntry 252, 7
    pl_Return

P10_0385:
    pl_msg_sys 23
    pl_GoTo P10_01E3

P10_038E:
    pl_Return

P10_S6:
P10_0390:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 7

P10_039B:
    pl_msg_sys 8
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_8004
    pl_CheckPoketchEnabled PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_03DB
    pl_Call P10_0437
    pl_Call P10_045B
    pl_Call P10_047F
    pl_Call P10_04A3
    pl_Call P10_04C7
    pl_Call P10_04EB

P10_03DB:
    ListMenuAdd 36, 65535, 0  // Pearl AddMenuEntry 258, 0
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P10_0452
    pl_CompareVarToValue PVAR_8004, 2
    pl_GoToIf 1, P10_0476
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P10_049A
    pl_CompareVarToValue PVAR_8004, 4
    pl_GoToIf 1, P10_04BE
    pl_CompareVarToValue PVAR_8004, 5
    pl_GoToIf 1, P10_04E2
    pl_CompareVarToValue PVAR_8004, 6
    pl_GoToIf 1, P10_0506
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P10_0437:
    pl_CheckPoketchAppRegistered 4, PVAR_800C  // Pokémon List
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_050F
    ListMenuAdd 50, 65535, 1  // Pearl AddMenuEntry 239, 1
    pl_Return

P10_0452:
    pl_msg_sys 18
    pl_GoTo P10_039B

P10_045B:
    pl_CheckPoketchAppRegistered 17, PVAR_800C  // Dot Artist
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_050F
    ListMenuAdd 51, 65535, 2  // Pearl AddMenuEntry 238, 2
    pl_Return

P10_0476:
    pl_msg_sys 25
    pl_GoTo P10_039B

P10_047F:
    pl_CheckPoketchAppRegistered 14, PVAR_800C  // Coin Toss
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_050F
    ListMenuAdd 52, 65535, 3  // Pearl AddMenuEntry 246, 3
    pl_Return

P10_049A:
    pl_msg_sys 29
    pl_GoTo P10_039B

P10_04A3:
    pl_CheckPoketchAppRegistered 18, PVAR_800C  // Roulette
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_050F
    ListMenuAdd 53, 65535, 4  // Pearl AddMenuEntry 245, 4
    pl_Return

P10_04BE:
    pl_msg_sys 28
    pl_GoTo P10_039B

P10_04C7:
    pl_CheckPoketchAppRegistered 21, PVAR_800C  // Color Changer
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_050F
    ListMenuAdd 54, 65535, 5  // Pearl AddMenuEntry 253, 5
    pl_Return

P10_04E2:
    pl_msg_sys 26
    pl_GoTo P10_039B

P10_04EB:
    pl_CheckPoketchAppRegistered 12, PVAR_800C  // Marking Map
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_050F
    ListMenuAdd 55, 65535, 6  // Pearl AddMenuEntry 251, 6
    pl_Return

P10_0506:
    pl_msg_sys 27
    pl_GoTo P10_039B

P10_050F:
    pl_Return

P10_S7:
P10_0511:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_sys 9

P10_051C:
    pl_msg_sys 10
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_8004  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_8004
    pl_CheckPoketchEnabled PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_055C
    pl_Call P10_05B8
    pl_Call P10_05DC
    pl_Call P10_0600
    pl_Call P10_0624
    pl_Call P10_0648
    pl_Call P10_066C

P10_055C:
    ListMenuAdd 36, 65535, 0  // Pearl AddMenuEntry 258, 0
    ListMenuShow
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P10_05D3
    pl_CompareVarToValue PVAR_8004, 2
    pl_GoToIf 1, P10_05F7
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P10_061B
    pl_CompareVarToValue PVAR_8004, 4
    pl_GoToIf 1, P10_063F
    pl_CompareVarToValue PVAR_8004, 5
    pl_GoToIf 1, P10_0663
    pl_CompareVarToValue PVAR_8004, 6
    pl_GoToIf 1, P10_0687
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P10_05B8:
    pl_CheckPoketchAppRegistered 3, PVAR_800C  // Pedometer
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_0690
    ListMenuAdd 56, 65535, 1  // Pearl AddMenuEntry 243, 1
    pl_Return

P10_05D3:
    pl_msg_sys 30
    pl_GoTo P10_051C

P10_05DC:
    pl_CheckPoketchAppRegistered 10, PVAR_800C  // Counter
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_0690
    ListMenuAdd 57, 65535, 2  // Pearl AddMenuEntry 242, 2
    pl_Return

P10_05F7:
    pl_msg_sys 32
    pl_GoTo P10_051C

P10_0600:
    pl_CheckPoketchAppRegistered 19, PVAR_800C  // Trainer Counter
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_0690
    ListMenuAdd 58, 65535, 3  // Pearl AddMenuEntry 256, 3
    pl_Return

P10_061B:
    pl_msg_sys 33
    pl_GoTo P10_051C

P10_0624:
    pl_CheckPoketchAppRegistered 13, PVAR_800C  // Link Searcher
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_0690
    ListMenuAdd 59, 65535, 4  // Pearl AddMenuEntry 255, 4
    pl_Return

P10_063F:
    pl_msg_sys 34
    pl_GoTo P10_051C

P10_0648:
    pl_CheckPoketchAppRegistered 15, PVAR_800C  // Move Tester
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_0690
    ListMenuAdd 60, 65535, 5  // Pearl AddMenuEntry 247, 5
    pl_Return

P10_0663:
    pl_msg_sys 35
    pl_GoTo P10_051C

P10_066C:
    pl_CheckPoketchAppRegistered 6, PVAR_800C  // Dowsing Machine
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P10_0690
    ListMenuAdd 61, 65535, 6  // Pearl AddMenuEntry 241, 6
    pl_Return

P10_0687:
    pl_msg_sys 31
    pl_GoTo P10_051C

P10_0690:
    pl_Return

PearlProxy_2508:                  // Pearl global script 2508 (run by this zone's events)
    VMCall C1_9_S9
    VMHalt

// ---- Pearl global script 1:9 (a subroutine here)
C1_9_S9:
C1_9_00AE:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    CallPlaceSelect PL_TMP, PL_TMP2  // OpenRegionMap: the Sinnoh town map, view-only here (patches/town_map.py)
// RestoreOverworld: Black 2's CallPlaceSelect reopened the field itself
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
