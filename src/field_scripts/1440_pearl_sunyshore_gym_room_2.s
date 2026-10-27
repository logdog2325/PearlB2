// MAP_SUNYSHORE_GYM_ROOM_2: Pearl script file 153, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P153_S1
    ScriptEntry P153_S2
    ScriptEntry P153_S3
    ScriptEntry P153_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P153_S1:
P153_0012:
    pl_SetVarFromValue PVAR_4000, 0
// InitSunyshoreGym 1: gimmick 62 sets the gears by the player's way in (sunyshore_gym_itcm.c)
    pl_End

P153_S2:
P153_001D:
    pl_RotateSunyshoreGymGear 0  // Pearl RotateSunyshoreGymGear 0: the gears turn (sunyshore_gym_itcm.c)
    pl_End

P153_S3:
P153_0022:
    pl_RotateSunyshoreGymGear 1  // Pearl RotateSunyshoreGymGear 1: the gears turn (sunyshore_gym_itcm.c)
    pl_End

P153_S4:
P153_0027:
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
