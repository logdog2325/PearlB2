// MAP_IRON_ISLAND_B1F_ROOM_2: Pearl script file 319, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P319_S1
    ScriptEntry P319_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P319_S1:
P319_000A:
// InitPersistedMapFeaturesForPlatformLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_End

P319_S2:
P319_000E:
// TriggerPlatformLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
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
