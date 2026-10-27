// MAP_POKEMON_LEAGUE_CYNTHIA_ROOM: Pearl script file 190, text bank 180. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P190_S1
    ScriptEntry P190_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P190_S1:
P190_000A:
// InitPersistedMapFeaturesForPlatformLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_End

P190_S2:
P190_000E:
    pl_ApplyMovement PL_PLAYER, P190_00E8
    pl_WaitMovement
    pl_PlayTrainerEncounterBGM PTRAINER_267
    pl_CheckFlag PFLAG_0964
    pl_CallIf 0, P190_00D1
    pl_CheckFlag PFLAG_0964
    pl_CallIf 1, P190_00D6
    pl_CloseMessage
    pl_SetFlag PFLAG_098B
    pl_StartTrainerBattle PTRAINER_267, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P190_00DB
    pl_msg_talk 1
    pl_SetFlag PFLAG_00B4
// CreateJournalEvent 12, 267, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_msg_talk 2
    pl_CloseMessage
    pl_ApplyMovement 0, P190_0100
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P190_00F0
    pl_WaitMovement
    pl_ApplyMovement 0, P190_010C
    pl_WaitMovement
    pl_WaitTime 30, PVAR_800C
    pl_TriggerPlatformLiftRide  // Pearl TriggerPlatformLift: gimmick 59 rides the lift with the player
    pl_WaitTime 30, PVAR_800C
    pl_SetFlag PFLAG_0258
    pl_SetFlag PFLAG_0259
    pl_ApplyMovement PL_PLAYER, P190_00F8
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 3  // the rest of this Pearl script runs there (continuation 3)
    pl_Warp 260, 5, 23, 0  // Pearl map 186 (MAP_POKEMON_LEAGUE_HALL_OF_FAME_CORRIDOR)
    pl_ReleaseAll
    pl_End

P190_00D1:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 0
    pl_Return

P190_00D6:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 9
    pl_Return

P190_00DB:
    pl_ClearFlag PFLAG_098B
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P190_00E8:
    Move 12, 4  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P190_00F0:
    Move 12, 6  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P190_00F8:
    Move 12, 6  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P190_0100:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P190_010C:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
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
