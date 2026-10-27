// Global scripts 9600-9602 (a/0/5/6 entry 1242): Black 2's res/field/scripts/global_9600.s with 9601 (Script_2)
// rewritten for Sinnoh (2026-10-26, the ch8 agent; HoennB2's 1242_global_9600.s did the same for Hoenn). Script_1 (9600)
// and Script_3 (9602) are Black 2's, unchanged.
// 9601 = FieldScript_CallPlayerPostHOFSetup: Black 2's EventGameClear runs it (state 10) right after the Hall of Fame
// record and before the game-clear save. Black 2's: heal, respawn at Aspertia's Center, the place Continue loads = its
// player's house (FieldSetNextZone 428, a Unova zone here, + flag 2405), and on the first clear Unova's post-game flags,
// works and map replacements (L_06DD): none of that is Sinnoh's. Pearl's ClearGame (pokeplatinum clear_game.c): the
// game-clear flag (0x964 = Black 2's 2400), the party healed, the respawn = Twinleaf (Black 2's respawn entry 18 is the
// player's house here: patches/sinnoh_respawn.py), and Continue = Pearl's start: the player's room, (4, 6) facing up
// (pokeplatinum location.c sPlayerStartLocation; Pearl's MAP_TWINLEAF_RIVAL_HOUSE_2F = Black 2 zone 521:
// patches/game_clear.py checks that number in every build).
#include "asm/field_script.inc"

    ScriptEntry Script_1
    ScriptEntry Script_2
    ScriptEntry Script_3
    ScriptEntriesEnd

Script_1:
    VMCall L_0024
    VMCall L_0324
    FieldSetTeleportZone 18
    MoneyAdd 3000
    VMHalt

L_0024:
    FlagSet EVENT_FLAG_0x03dd
    FlagSet EVENT_FLAG_0x025f
    FlagSet EVENT_FLAG_0x0265
    FlagSet EVENT_FLAG_0x025c
    FlagSet EVENT_FLAG_0x025d
    FlagSet EVENT_FLAG_0x0267
    FlagSet EVENT_FLAG_0x02ff
    FlagSet EVENT_FLAG_0x0300
    FlagSet EVENT_FLAG_0x0301
    FlagSet EVENT_FLAG_0x026d
    FlagSet EVENT_FLAG_0x0266
    FlagSet EVENT_FLAG_0x0294
    FlagSet EVENT_FLAG_0x029b
    FlagSet EVENT_FLAG_0x0285
    WorkSetConst EVENT_WORK_0x4165, 1
    FlagSet EVENT_FLAG_0x02e4
    FlagSet EVENT_FLAG_0x02e3
    FlagSet EVENT_FLAG_0x03c5
    FlagSet EVENT_FLAG_0x02be
    FlagSet EVENT_FLAG_0x0302
    FlagSet EVENT_FLAG_0x0303
    FlagSet EVENT_FLAG_0x03f6
    FlagSet EVENT_FLAG_0x02f9
    FlagSet EVENT_FLAG_0x02fa
    FlagSet EVENT_FLAG_0x02dd
    FlagSet EVENT_FLAG_0x02de
    FlagSet EVENT_FLAG_0x02df
    FlagSet EVENT_FLAG_0x02e0
    FlagSet EVENT_FLAG_0x02e1
    FlagSet EVENT_FLAG_0x02d7
    FlagSet EVENT_FLAG_0x02e7
    FlagSet EVENT_FLAG_0x02e5
    FlagSet EVENT_FLAG_0x097e
    FlagSet EVENT_FLAG_0x02da
    FlagSet EVENT_FLAG_0x03e4
    FlagSet EVENT_FLAG_0x02d4
    FlagSet EVENT_FLAG_0x02d3
    FlagSet EVENT_FLAG_0x02d2
    FlagSet EVENT_FLAG_0x02d1
    FlagSet EVENT_FLAG_0x02ea
    FlagSet EVENT_FLAG_0x02ef
    FlagSet EVENT_FLAG_0x0406
    FlagSet EVENT_FLAG_0x02f1
    FlagSet EVENT_FLAG_0x02f2
    FlagSet EVENT_FLAG_0x02f4
    FlagSet EVENT_FLAG_0x02f6
    FlagSet EVENT_FLAG_0x02cd
    FlagSet EVENT_FLAG_0x02cc
    FlagSet EVENT_FLAG_0x02b9
    FlagSet EVENT_FLAG_0x02c8
    FlagSet EVENT_FLAG_0x02c6
    FlagSet EVENT_FLAG_0x037e
    FlagSet EVENT_FLAG_0x037b
    FlagSet EVENT_FLAG_0x037a
    FlagSet EVENT_FLAG_0x0304
    FlagSet EVENT_FLAG_0x0305
    FlagSet EVENT_FLAG_0x0306
    FlagSet EVENT_FLAG_0x0307
    FlagSet EVENT_FLAG_0x030e
    FlagSet EVENT_FLAG_0x0310
    FlagSet EVENT_FLAG_0x0311
    FlagSet EVENT_FLAG_0x031a
    FlagSet EVENT_FLAG_0x031b
    FlagSet EVENT_FLAG_0x031c
    FlagSet EVENT_FLAG_0x031d
    FlagSet EVENT_FLAG_0x031e
    FlagSet EVENT_FLAG_0x0320
    FlagSet EVENT_FLAG_0x040a
    FlagSet EVENT_FLAG_0x03f2
    FlagSet EVENT_FLAG_0x0318
    FlagSet EVENT_FLAG_0x0325
    FlagSet EVENT_FLAG_0x0328
    FlagSet EVENT_FLAG_0x03d9
    FlagSet EVENT_FLAG_0x03f0
    FlagSet EVENT_FLAG_0x032b
    FlagSet EVENT_FLAG_0x032a
    FlagSet EVENT_FLAG_0x032e
    FlagSet EVENT_FLAG_0x0335
    FlagSet EVENT_FLAG_0x0336
    FlagSet EVENT_FLAG_0x0337
    FlagSet EVENT_FLAG_0x0338
    FlagSet EVENT_FLAG_0x0339
    FlagSet EVENT_FLAG_0x033a
    FlagSet EVENT_FLAG_0x033c
    FlagSet EVENT_FLAG_0x0355
    FlagSet EVENT_FLAG_0x0340
    FlagSet EVENT_FLAG_0x0341
    FlagSet EVENT_FLAG_0x0342
    FlagSet EVENT_FLAG_0x0347
    FlagSet EVENT_FLAG_0x0350
    FlagSet EVENT_FLAG_0x0356
    FlagSet EVENT_FLAG_0x034a
    FlagSet EVENT_FLAG_0x034b
    FlagSet EVENT_FLAG_0x03d1
    FlagSet EVENT_FLAG_0x0405
    FlagSet EVENT_FLAG_0x0a00
    FlagSet EVENT_FLAG_0x0357
    FlagSet EVENT_FLAG_0x0359
    FlagSet EVENT_FLAG_0x0358
    FlagSet EVENT_FLAG_0x035b
    FlagSet EVENT_FLAG_0x035c
    FlagSet EVENT_FLAG_0x035d
    FlagSet EVENT_FLAG_0x035e
    FlagSet EVENT_FLAG_0x035f
    FlagSet EVENT_FLAG_0x0360
    FlagSet EVENT_FLAG_0x0361
    FlagSet EVENT_FLAG_0x0362
    FlagSet EVENT_FLAG_0x037f
    FlagSet EVENT_FLAG_0x0380
    FlagSet EVENT_FLAG_0x036e
    FlagSet EVENT_FLAG_0x0370
    FlagSet EVENT_FLAG_0x0376
    FlagSet EVENT_FLAG_0x0378
    FlagSet EVENT_FLAG_0x0379
    FlagSet EVENT_FLAG_0x03c8
    FlagSet EVENT_FLAG_0x03c9
    FlagSet EVENT_FLAG_0x0407
    FlagSet EVENT_FLAG_0x0372
    FlagSet EVENT_FLAG_0x03ec
    FlagSet EVENT_FLAG_0x03eb
    FlagSet EVENT_FLAG_0x03f3
    FlagSet EVENT_FLAG_0x0384
    FlagSet EVENT_FLAG_0x0382
    FlagSet EVENT_FLAG_0x0381
    FlagSet EVENT_FLAG_0x0395
    FlagSet EVENT_FLAG_0x0394
    FlagSet EVENT_FLAG_0x0396
    FlagSet EVENT_FLAG_0x0397
    FlagSet EVENT_FLAG_0x0398
    FlagSet EVENT_FLAG_0x0390
    FlagSet EVENT_FLAG_0x03ad
    FlagSet EVENT_FLAG_0x0391
    FlagSet EVENT_FLAG_0x040b
    FlagSet EVENT_FLAG_0x039d
    FlagSet EVENT_FLAG_0x039e
    FlagSet EVENT_FLAG_0x039f
    FlagSet EVENT_FLAG_0x02b7
    FlagSet EVENT_FLAG_0x03b0
    FlagSet EVENT_FLAG_0x03ae
    FlagSet EVENT_FLAG_0x03b1
    FlagSet EVENT_FLAG_0x03c0
    FlagSet EVENT_FLAG_0x03b6
    FlagSet EVENT_FLAG_0x03b7
    FlagSet EVENT_FLAG_0x03b9
    FlagSet EVENT_FLAG_0x03bb
    FlagSet EVENT_FLAG_0x03bd
    FlagSet EVENT_FLAG_0x02ab
    FlagSet EVENT_FLAG_0x03ca
    FlagSet EVENT_FLAG_0x03cb
    FlagSet EVENT_FLAG_0x03cc
    FlagSet EVENT_FLAG_0x03cd
    FlagSet EVENT_FLAG_0x03ce
    FlagSet EVENT_FLAG_0x03d2
    FlagSet EVENT_FLAG_0x03d3
    FlagSet EVENT_FLAG_0x03da
    FlagSet EVENT_FLAG_0x0273
    FlagSet EVENT_FLAG_0x0274
    FlagSet EVENT_FLAG_0x0275
    FlagSet EVENT_FLAG_0x0276
    FlagSet EVENT_FLAG_0x0277
    FlagSet EVENT_FLAG_0x03df
    FlagSet EVENT_FLAG_0x03e0
    FlagSet EVENT_FLAG_0x03e2
    FlagSet EVENT_FLAG_0x03e3
    FlagSet EVENT_FLAG_0x02b3
    FlagSet EVENT_FLAG_0x02b4
    FlagSet EVENT_FLAG_0x02b5
    FlagSet EVENT_FLAG_0x02b6
    FlagSet EVENT_FLAG_0x03ef
    FlagSet EVENT_FLAG_0x03f8
    FlagSet EVENT_FLAG_0x03f9
    FlagSet EVENT_FLAG_0x03fa
    FlagSet EVENT_FLAG_0x03fb
    FlagSet EVENT_FLAG_0x03fc
    FlagSet EVENT_FLAG_0x03fd
    FlagSet EVENT_FLAG_0x03fe
    FlagSet EVENT_FLAG_0x03ff
    FlagSet EVENT_FLAG_0x0404
    FlagSet EVENT_FLAG_0x0408
    FlagSet EVENT_FLAG_0x0409
    FlagSet EVENT_FLAG_0x040d
    FlagSet EVENT_FLAG_0x0411
    FlagSet EVENT_FLAG_0x0412
    FlagSet EVENT_FLAG_0x0413
    FlagSet EVENT_FLAG_0x0414
    FlagSet EVENT_FLAG_0x0415
    FlagSet EVENT_FLAG_0x0416
    FlagSet EVENT_FLAG_0x0417
    FlagSet EVENT_FLAG_0x0418
    FlagSet EVENT_FLAG_0x0419
    FlagSet EVENT_FLAG_0x041a
    VMReturn

L_0324:
    GameGetVersion 0x8010
    WorkCmpConst 0x8010, 23
    VMJumpIf CMP_EQ, L_033B
    VMJump L_0347

L_033B:
    Cmd_0209 0, 1
    VMJump L_0366

L_0347:
    WorkCmpConst 0x8010, 22
    VMJumpIf CMP_EQ, L_035A
    VMJump L_0366

L_035A:
    Cmd_0209 0, 2
    VMJump L_0366

L_0366:
    TrainerCardGetSex 0x8010
    WorkCmpConst 0x8010, 0
    VMJumpIf CMP_EQ, L_037D
    VMJump L_0389

L_037D:
    Cmd_0209 1, 1
    VMJump L_03A8

L_0389:
    WorkCmpConst 0x8010, 1
    VMJumpIf CMP_EQ, L_039C
    VMJump L_03A8

L_039C:
    Cmd_0209 1, 2
    VMJump L_03A8

L_03A8:
    Cmd_0209 29, 1
    VMReturn

Script_3:
    VMCall L_0024
    FieldSetTeleportZone 3
    FlagSet EVENT_FLAG_0x006a
    FlagSet EVENT_FLAG_0x0961
    FlagSet EVENT_FLAG_0x0962
    GiveRunningShoes
    VMHalt


Script_2:
    FlagSet 2400                                  // Pearl's game clear (0x964); the Hall of Fame's pl_ClearGame set it too
    PokePartyRecoverAll                           // Pearl's ClearGame heals the party before its save
    FieldSetTeleportZone 18                       // the black-out spot and Escape Rope town: the player's house (Twinleaf)
    FieldSetNextZone 521, 1, 4, 0, 6              // Continue: the player's room (4, 6), facing up (WARP_DIR_UP)
    FlagSet 2405                                  // EVENT_FLAG_CONTINUE_SCRIPT: Continue loads that place (ov035 EventFieldContinue)
    VMHalt
    .balign 4, 0
