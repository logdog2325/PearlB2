// MAP_POKEMON_LEAGUE_HALL_OF_FAME: Pearl script file 192, text bank 182. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; 2: after a Warp; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P192_S1
    ScriptEntry W191_00F8_S
    ScriptEntry PearlArrive
    ScriptEntry PearlEndingBeforeCredits
    ScriptEntry PearlEndingAfterCredits
    ScriptEntriesEnd

P192_S1:
P192_0006:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P192_0128
    pl_WaitMovement
    pl_ApplyMovement 1, P192_0138
    pl_WaitMovement
    pl_GetLeagueVictories PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P192_0115
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 5, P192_011D
    pl_CloseMessage
    pl_ApplyMovement 1, P192_0148
    pl_ApplyMovement 0, P192_0160
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P192_0074
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P192_0080
    pl_End

P192_0074:
    pl_BufferPlayerName 0
    pl_msg_sys 4
    pl_GoTo P192_008C

P192_0080:
    pl_BufferPlayerName 0
    pl_msg_sys 5
    pl_GoTo P192_008C

P192_008C:
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P192_0130
    pl_ApplyMovement 1, P192_0150
    pl_ApplyMovement 0, P192_0168
    pl_WaitMovement
    pl_msg_sys 6
    pl_CloseMessage
    pl_SetFlag PFLAG_0982
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P192_010E
    pl_CompareVarToValue PVAR_40F4, 0
    pl_CallIf 1, P192_0106
    pl_GetPartyCount PVAR_800C
    pl_PlayHallOfFameHealingAnimation  // Pearl 0x25A PVAR_800C: the healing tune
    pl_fade_out_black  // FadeScreen 6, 3, 0, 0x0
    pl_WaitFadeScreen
// IncrementTrainerScore2 24: nothing in Black 2 (Pearl's trainer-card score (Black 2 keeps its own records))
// IncrementGameRecord 46: nothing in Black 2 (its own records)
    pl_Call P192_0178
    pl_ClearGame  // Pearl ShowEndGameScreen: Black 2's Hall of Fame record, save, credits (ends the script)
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P192_0106:
    pl_SetVarFromValue PVAR_40F4, 1
    pl_Return

P192_010E:
    pl_SetHiddenLocation 2  // SetHiddenLocation 2: Black 2's map replacement
    pl_Return

P192_0115:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_msg_sys 2
    pl_Return

P192_011D:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_msg_sys 3
    pl_Return

P192_0178:
    pl_ClearFlag PFLAG_01EF
    pl_ClearFlag PFLAG_098B
    pl_CheckFlag PFLAG_015F
    pl_CallIf 0, P192_01D2
    pl_CheckFlag PFLAG_0120
    pl_CallIf 0, P192_01E2
    pl_CheckFlag PFLAG_011B
    pl_CallIf 0, P192_01F9
    pl_CheckFlag PFLAG_0126
    pl_CallIf 0, P192_0211
    pl_CheckFlag PFLAG_0127
    pl_CallIf 0, P192_0217
    pl_CompareVarToValue PVAR_410F, 0
    pl_CallIf 1, P192_01CA
    pl_ClearFlag PFLAG_0195
    pl_Return

P192_01CA:
    pl_SetVarFromValue PVAR_410F, 1
    pl_Return

P192_01D2:
    pl_SetVarFromValue PVAR_4098, 5
// Dummy1F9 16536: nothing in Black 2 (a debug command)
    pl_ClearFlag PFLAG_01E2
    pl_Return

P192_01E2:
    pl_CheckFlag PFLAG_0125
    pl_GoToIf 0, P192_01F7
    pl_ClearFlag PFLAG_01FB
    pl_SetVarFromValue PVAR_409E, 1

P192_01F7:
    pl_Return

P192_01F9:
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P192_020F
    pl_ClearFlag PFLAG_0261

P192_020F:
    pl_Return

P192_0211:
    pl_ClearFlag PFLAG_01FE
    pl_Return

P192_0217:
    pl_ClearFlag PFLAG_01FF
    pl_Return

    .balign 4, 0
P192_0128:
    Move 12, 8  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P192_0130:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P192_0138:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 2  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P192_0148:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P192_0150:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P192_0160:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P192_0168:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

// ---- continuation 2: after the Warp at 191:00F8 (MAP_POKEMON_LEAGUE_HALL_OF_FAME_CORRIDOR)
W191_00F8_S:
W191_00F8_0104:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

PearlEndingBeforeCredits:          // Black 2's game clear, before the credits (GAME_CLEAR_ZONE): the screen stays black,
    BGMPlay SEQ_BGM_ENDING     // the ending song (Black 2's: Pearl's is not installed)
    VMHalt

PearlEndingAfterCredits:           // Black 2's game clear, after the credits: nothing (THE END follows)
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
