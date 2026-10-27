// MAP_POKEMON_LEAGUE_HALL_OF_FAME_CORRIDOR: Pearl script file 191, text bank 181. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; 3: after a Warp; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P191_S1
    ScriptEntry P191_S2
    ScriptEntry W190_00B5_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P191_S1:
P191_S2:
P191_000A:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P191_016C
    pl_WaitMovement
    pl_SetObjectEventPosLater 0, 0, 6, -1, 14, 0  // SetObjectEventPos 0 (the live actor; and where AddObject puts it)
    pl_ClearFlag PFLAG_0258
    pl_AddObjectAt 0, 0, 0  // at its SetObjectEventPos
// LockObject 0: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 0, P191_0138
    pl_ApplyMovement PL_PLAYER, P191_017C
    pl_WaitMovement
    pl_msg_sys 0
    pl_CloseMessage
    pl_SetObjectEventPosLater 1, 1, 4, -1, 14, 0  // SetObjectEventPos 1 (the live actor; and where AddObject puts it)
    pl_ClearFlag PFLAG_0259
    pl_AddObjectAt 1, 1, 0  // at its SetObjectEventPos
// LockObject 1: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 1, P191_0114
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P191_0190
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement 0, P191_0144
    pl_WaitMovement
    pl_msg_sys 2
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_ApplyMovement 0, P191_0150
    pl_WaitMovement
    pl_msg_sys 4
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P191_00B1
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P191_00BD
    pl_End

P191_00B1:
    pl_BufferPlayerName 0
    pl_msg_sys 5
    pl_GoTo P191_00C9

P191_00BD:
    pl_BufferPlayerName 0
    pl_msg_sys 6
    pl_GoTo P191_00C9

P191_00C9:
    pl_msg_sys 7
    pl_CloseMessage
    pl_ApplyMovement 0, P191_0158
    pl_ApplyMovement 1, P191_0120
    pl_ApplyMovement PL_PLAYER, P191_0198
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 2  // the rest of this Pearl script runs there (continuation 2)
    pl_Warp 261, 8, 15, 0  // Pearl map 187 (MAP_POKEMON_LEAGUE_HALL_OF_FAME)
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P191_0114:
    Move 12, 8  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P191_0120:
    Move 63, 3  // DELAY_8
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P191_0138:
    Move 12, 8  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P191_0144:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P191_0150:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P191_0158:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P191_016C:
    Move 12, 17  // WALK_NORMAL_NORTH
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P191_017C:
    Move 63, 6  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P191_0190:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P191_0198:
    Move 63, 1  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 6  // DELAY_8
    Move 12, 4  // WALK_NORMAL_NORTH
    MoveEnd

// ---- continuation 3: after the Warp at 190:00B5 (MAP_POKEMON_LEAGUE_CYNTHIA_ROOM)
W190_00B5_S:
W190_00B5_00C1:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
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
