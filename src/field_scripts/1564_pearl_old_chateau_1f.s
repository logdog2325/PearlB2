// MAP_OLD_CHATEAU_1F: Pearl script file 325, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P325_S1
    ScriptEntry P325_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P325_S1:
P325_000A:
    pl_stub CheckShouldShowGhost  // Pearl 0x292 Unk0292 10, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P325_0022
    pl_SetFlag PFLAG_0299
    pl_End

P325_0022:
    pl_ClearFlag PFLAG_0299
    pl_SetVarFromValue PVAR_4110, 1
    pl_End

P325_S2:
P325_002E:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P325_0054
    pl_ApplyMovement 0, P325_0064
    pl_WaitMovement
    pl_SetFlag PFLAG_0299
    pl_RemoveObject 0, PFLAG_0299
    pl_SetVarFromValue PVAR_4110, 0
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P325_0054:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 66, 1  // DELAY_32
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P325_0064:
    Move 63, 1  // DELAY_8
    Move 2, 1  // FACE_WEST
    Move 65, 1  // DELAY_16
    Move 73, 1  // PAUSE_ANIMATION
    Move 14, 10  // WALK_NORMAL_WEST
    Move 74, 1  // RESUME_ANIMATION
    Move 69, 1  // SET_INVISIBLE
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
