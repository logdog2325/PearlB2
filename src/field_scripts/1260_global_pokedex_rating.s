// Global scripts 10380-10382 (a/0/5/6 entry 1260). Black 2's file (pokebw2 res/field/scripts/global_10380.s) is
// Professor Juniper's Pokédex rating: Script_1 in her lab, Script_2 her father, Script_3 her PC (the Pokémon Center
// PC's professor entry, global 10090 = src/field_scripts/1244_global_pc.s). Rewritten for Sinnoh (2026-10-20,
// b2tools/patches/sinnoh_pokedex.py; HoennB2's room_pc did the same for Birch): Script_3 is Pearl's PC rating, the
// user's Pearl dump's common script 376 script_2 (pokediamond: the PC's ROWAN'S PC / OAK'S PC entry):
//   - no National Pokédex: "Accessed Professor Rowan's PC.", then L_00E4: with Pearl's flag 0x9BA set and the Sinnoh
//     Pokédex complete, flag 0x110 (Rowan's National Pokédex scene in his lab); "Hmm... You've spotted N Pokémon in
//     Sinnoh..." and Rowan's line for the count (pearl_story.inc pl_LoadPokedexRatingLocal);
//   - National Pokédex: "Accessed Professor Oak's PC.", "Hmhm... You've caught N so far..." and Oak's line
//     (pl_LoadPokedexRatingNational).
// Text: a/0/0/3 file 1051 (src/text/script/1051_rowan_rating.txt) = Pearl's bank 335 line for line, so the line
// numbers below are Pearl's. Pearl plays no jingle here (Black 2's Juniper played SEQ_ME_HYOUKA*). Script_1 / Script_2
// (Juniper's lab, her father) end at once: no Sinnoh zone calls them (Rowan's lab rates through its own translated
// scripts). Black 2's Juniper gifts (Oval Charm, Shiny Charm) are not Pearl's.
#include "pearl.h"
#include "asm/field_script.inc"
#include "pearl_story.inc"

#define RT_LINE 0x8044                 // the rating line (0x8020-0x805E are the caller's, restored after RTCallGlobal)
#define RT_COUNT 0x8045

    ScriptEntry Script_1
    ScriptEntry Script_2
    ScriptEntry Script_3
    ScriptEntriesEnd

Script_1:                                        // 10380: Black 2's Juniper in her lab (not in Sinnoh)
    RTEndGlobal

Script_2:                                        // 10381: Black 2's Juniper's father (not in Sinnoh)
    RTEndGlobal

Script_3:                                        // 10382: Pearl's common script 376 script_2
    PokeDexHaveNational RT_LINE                  // NationalDex 2, var
    WorkCmpConst RT_LINE, 1
    VMJumpIf CMP_EQ, L_Oak
    SystemMsg 40, 2                              // Accessed Professor Rowan's PC.
    FlagGet PFLAG_09BA, PL_TMP                   // L_00E4
    WorkCmpConst PL_TMP, 1
    VMJumpIf CMP_NE, L_Seen
    pl_CheckLocalDexCompleted RT_LINE
    WorkCmpConst RT_LINE, 1
    VMJumpIf CMP_NE, L_Seen
    FlagSet PFLAG_0110
L_Seen:                                          // L_0100
    pl_GetLocalDexSeenCount RT_COUNT
    WordSetNumber 0, RT_COUNT, 0
    SystemMsg 1, 2                               // Hmm... You've spotted N Pokémon in Sinnoh...
    pl_LoadPokedexRatingLocal RT_LINE, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
    WordSetPlayerName 0
    SystemMsg RT_LINE, 2
    LastKeyWait
    RTEndGlobal

L_Oak:                                           // L_00DB, L_0122
    SystemMsg 41, 2                              // Accessed Professor Oak's PC.
    PokeDexGetCount 1, RT_COUNT                  // CountNationalDexOwned
    WordSetNumber 0, RT_COUNT, 0
    SystemMsg 17, 2                              // Hmhm... You've caught N so far...
    pl_LoadPokedexRatingNational RT_LINE, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
    WordSetPlayerName 0
    SystemMsg RT_LINE, 2
    LastKeyWait
    RTEndGlobal
    .balign 4, 0
