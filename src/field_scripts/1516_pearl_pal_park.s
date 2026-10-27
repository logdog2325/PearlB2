// MAP_PAL_PARK: Pearl script file 265, text bank 235. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; 7: after a Warp; 8: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P265_S1
    ScriptEntry P265_S2
    ScriptEntry P265_S3
    ScriptEntry P265_S4
    ScriptEntry P265_S5
    ScriptEntry P265_S6
    ScriptEntry W444_027D_S
    ScriptEntry PearlArrive
    ScriptEntry RamanasExtra_attendant
    ScriptEntriesEnd

P265_S1:
P265_001A:
    pl_SetFlag PFLAG_09CB
    pl_End

P265_S2:
P265_0020:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 9
    pl_WaitTime 30, PVAR_800C
    pl_msg_sys 10
    pl_PlaySE SEQ_SE_DECIDE1  // Pearl SEQ_SE_DP_DECIDE
    pl_WaitTime 30, PVAR_800C
    pl_msg_sys 11
    pl_PlaySE SEQ_SE_DECIDE1  // Pearl SEQ_SE_DP_DECIDE
    pl_WaitTime 30, PVAR_800C
    pl_msg_sys 12
    pl_PlaySE SEQ_SE_DECIDE1  // Pearl SEQ_SE_DP_DECIDE
    pl_WaitTime 30, PVAR_800C
    pl_msg_sys 13
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_CON_016: no Black 2 sound chosen yet
    pl_WaitTime 30, PVAR_800C
    pl_SetClearInCatchingShowFlag 0
    pl_SetVarFromValue PVAR_40F3, 1
    pl_SetFlag PFLAG_0995
    #ifdef SEQ_PEARL_D_SAFARI
        pl_PlayMusic SEQ_PEARL_D_SAFARI  // Pearl SEQ_D_SAFARI
    #else
        pl_stub PlayMusic  // Pearl sound SEQ_D_SAFARI: no Black 2 stand-in
    #endif
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P265_S3:
P265_008D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_PlaySE SEQ_SE_DECIDE2  // Pearl SEQ_SE_DP_PINPON
    pl_BufferPlayerName 0
    pl_msg_sys 5
    #ifdef SEQ_PEARL_SILENCE_DUNGEON
        pl_PlayMusic SEQ_PEARL_SILENCE_DUNGEON  // Pearl SEQ_SILENCE_DUNGEON
    #else
        pl_stub PlayMusic  // Pearl sound SEQ_SILENCE_DUNGEON: no Black 2 stand-in
    #endif
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_CloseMessage
    pl_ReleaseAll
    pl_SetVarFromValue PVAR_40F3, 1
    pl_Call P265_01C0
    pl_End

P265_S4:
P265_00B9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 8
    pl_ShowYesNoMenu PVAR_800C
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P265_00D9
    pl_ReleaseAll
    pl_End

P265_00D9:
    pl_SetVarFromValue PVAR_40F3, 2
    pl_ReleaseAll
    pl_Call P265_01C0
    pl_End

P265_S5:
P265_00E9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_Call P265_0170
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P265_0114
    pl_SetVarFromValue PVAR_40F3, 2
    pl_ReleaseAll
    pl_Call P265_01C0
    pl_End

P265_0114:
    pl_ApplyMovement PL_PLAYER, P265_0124
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P265_S6:
P265_012C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_Call P265_0170
    pl_CloseMessage
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P265_0159
    pl_SetVarFromValue PVAR_40F3, 2
    pl_ReleaseAll
    pl_Call P265_01C0
    pl_End

P265_0159:
    pl_ApplyMovement 0, P265_0168
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P265_0170:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P265_01B5
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P265_01A5
    pl_BufferPlayerName 0
    pl_msg_sys 2
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

P265_01A5:
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_WaitButton
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

P265_01B5:
    pl_msg_sys 1
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

P265_01C0:
    pl_SetClearInCatchingShowFlag 1
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 14  // the rest of this Pearl script runs there (continuation 14)
    pl_Warp 509, 7, 7, 1  // Pearl map 393 (MAP_ROUTE_221_PAL_PARK_ENTRANCE)
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P265_0124:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P265_0168:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

// ---- continuation 7: after the Warp at 444:027D (MAP_ROUTE_221_PAL_PARK_ENTRANCE)
W444_027D_S:
W444_027D_0289:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

RamanasExtra_attendant:          // the park attendant during a Ramanas visit (data/ramanas_park.json)
    WorkCmpConst 0x40B1, 3
    VMJumpIf CMP_NE, P265_S6
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
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
