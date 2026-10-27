// MAP_NEWMOON_ISLAND_INTERIOR: Pearl script file 354, text bank 280. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P354_S1
    ScriptEntry P354_S2
    ScriptEntry P354_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P354_S1:
P354_000E:
    pl_End

P354_S2:
P354_0010:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P354_001D
    pl_End

P354_001D:
    pl_SetFlag PFLAG_025E
    pl_RemoveObject 0, PFLAG_025E
    pl_ClearFlag PFLAG_008E
    pl_End

P354_S3:
P354_002B:
    pl_LockAll
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_msg_talk 0
    pl_CloseMessage
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 491, 40
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P354_00F2
    pl_CheckDidNotCapture PVAR_800C  // Pearl 0x2BC: 1 unless caught
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P354_0083
    pl_SetFlag PFLAG_0158

P354_006E:
    pl_SetFlag PFLAG_025F
    pl_CompareVarToValue PVAR_40F8, 2
    pl_GoToIf 1, P354_008E
    pl_ReleaseAll
    pl_End

P354_0083:
    pl_msg_talk 1
    pl_CloseMessage
    pl_GoTo P354_006E

P354_008E:
    pl_WaitTime 30, PVAR_800C
    pl_fade_out_black  // FadeScreen 6, 3, 0, 0x0
    pl_WaitFadeScreen
    pl_fade_in_black  // FadeScreen 6, 3, 1, 0x0
    pl_WaitFadeScreen
    pl_fade_out_black  // FadeScreen 6, 3, 0, 0x0
    pl_WaitFadeScreen
    pl_fade_in_black  // FadeScreen 6, 3, 1, 0x0
    pl_WaitFadeScreen
    pl_fade_out_black  // FadeScreen 6, 6, 0, 0x0
    pl_WaitFadeScreen
    pl_WaitTime 120, PVAR_800C
    RTReserveScript 4  // the rest of this Pearl script runs there (continuation 4)
    pl_Warp 56, 8, 6, 1  // Pearl map 43 (MAP_CANALAVE_HARBOR_INN)
    pl_ReleaseAll
    pl_End

P354_00F2:
    pl_BlackOutFromWildBattle
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
