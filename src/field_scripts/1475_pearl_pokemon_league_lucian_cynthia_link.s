// MAP_POKEMON_LEAGUE_LUCIAN_CYNTHIA_LINK: Pearl script file 189, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P189_S1
    ScriptEntry P189_S2
    ScriptEntry P189_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P189_S1:
P189_000E:
    pl_SetVarFromValue PVAR_4000, 0
// InitPersistedMapFeaturesForPlatformLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    WorkSetConst PVAR_4001, 1  // Pearl CheckPlatformLiftNotUsedWhenEnteredMap: the lift waits at the player's floor (gimmick 59)
    pl_CompareVarToValue PVAR_4001, 0
    pl_GoToIf 1, P189_0029
    pl_End

P189_S2:
P189_0029:
    pl_SetVarFromValue PVAR_4000, 1
    pl_End

P189_S3:
P189_0031:
// TriggerPlatformLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_SetVarFromValue PVAR_4000, 1
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
