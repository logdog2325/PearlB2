// MAP_OLD_CHATEAU_2F_ROOM_4: Pearl script file 331, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P331_S1
    ScriptEntry P331_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P331_S1:
P331_000A:
    pl_stub CheckShouldShowGhost  // Pearl 0x292 Unk0292 25, 16384: not translated yet
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P331_0022
    pl_SetFlag PFLAG_029A
    pl_End

P331_0022:
    pl_ClearFlag PFLAG_029A
    pl_SetVarFromValue PVAR_4111, 1
    pl_End

P331_S2:
P331_002E:
    pl_LockAll
    pl_ApplyMovement 1, P331_004C
    pl_WaitMovement
    pl_SetFlag PFLAG_029A
    pl_RemoveObject 1, PFLAG_029A
    pl_SetVarFromValue PVAR_4111, 0
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P331_004C:
    Move 65, 1  // DELAY_16
    Move 1, 1  // FACE_SOUTH
    Move 65, 1  // DELAY_16
    Move 73, 1  // PAUSE_ANIMATION
    Move 13, 2  // WALK_NORMAL_SOUTH
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
