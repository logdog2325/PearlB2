// The new game in Twinleaf's script file (included by the generated Twinleaf file, b2tools/pearl_story.py
// NEWGAME_ZONE). Black 2's new-game event loads zone 427 (Twinleaf) at its fly point, hides the player, and runs
// scripts 29 and 30 of that zone's file (ov035 event_mapchange.c EventFieldFirst_Callback; HoennB2
// notes/RESEARCH_STORY_SPRITES.md). As src/field_scripts/1289_twinleaf_newgame.s does, script 30 ends with a map change
// and a reserved script that fades in; here it also sets Pearl's new-game flags (Pearl's script 9600, file 377 script 1,
// which Pearl's new-game event runs: translated as subroutine C377_1_S1 of this file) and starts where Pearl starts:
// the bedroom (PEARL_START_*, defined by the generator), whose PearlArrive script fades in. Barry's scene there is the
// bedroom's own map script (Pearl's frame table: var 0x40A3 = 0).

PearlNewGame_29:
    VMHalt

PearlNewGame_30:
    ActorsPauseAll
    VMCall C377_1_S1
    FadeOutBlack
    RTReserveScript PEARL_START_ARRIVE
    FadeWait
    MapChangeCore PEARL_START_ZONE, PEARL_START_X, 0, PEARL_START_Z, PEARL_START_DIR
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

PearlNewGame_31:                    // (kept for a build whose start is Twinleaf itself)
    ActorsPauseAll
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt
