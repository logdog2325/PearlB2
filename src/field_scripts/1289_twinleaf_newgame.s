// Twinleaf Town (Black 2 zone 427, the zone a new game loads first). Replaces Black 2's opening scene there
// (Aspertia's scripts 29/30: Mom's phone call, then a warp into Aspertia's house), which would otherwise run on
// top of Sinnoh's overworld. The new-game event hides the player before script 29 (event_mapchange.c), so
// script 30 warps onto Twinleaf's start tile (the zone's fly point), which shows the player, as Black 2's own
// opening ends with a warp. Same order as Black 2's (aspertia_city.s Script_30): fade out, reserve the fade-in
// script (31, run after the map change, like aspertia_city_2.s Script_17), wait, MapChangeCore.
// Pearl's real opening (the player's room) replaces this in the story phase.
#include "asm/field_script.inc"
#include "constants/zones.h"

#ifndef FLY_427_X
#error "run patches/sinnoh_world.py before patches/scripts.py (work/world/fly.json)"
#endif

    .irp n, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28
    ScriptEntry Script_Nothing
    .endr
    ScriptEntry Script_29
    ScriptEntry Script_30
    ScriptEntry Script_31
    ScriptEntriesEnd

Script_Nothing:
    VMHalt

Script_29:
    VMHalt

Script_30:
    ActorsPauseAll
    FadeOutBlack
    RTReserveScript 31
    FadeWait
    MapChangeCore ZONE_ASPERTIA_CITY, FLY_427_X, FLY_427_Y, FLY_427_Z, 1
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_31:
    ActorsPauseAll
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt
    .balign 4, 0
