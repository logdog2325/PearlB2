// MAP_SNOWPOINT_TEMPLE_B4F: Pearl script file 368, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive; 94: Pearl 10002
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P368_S1
    ScriptEntry PearlArrive
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10002
    ScriptEntriesEnd

P368_S1:
P368_0006:
    pl_End

PearlProxy_10002:                  // Pearl global script 10002 (run by this zone's events)
    VMCall T375_3_S3
    VMHalt

// ---- Pearl global script 375:3 (a subroutine here)
T375_3_S3:
T375_3_022A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    FlagGet 2404, PVAR_800C  // GetSetStrength 2: is Strength on (Black 2's flag 0x964)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T375_3_02D3
    PokePartyHasMoveAny PVAR_800C, 70  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_3_0288
    pl_CheckBadgeAcquired 5, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_3_0288
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 81  // Pearl bank 334 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_3_0297
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0288:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 82  // Pearl bank 334 line 8
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0297:
    FlagSet 2404  // GetSetStrength 1: Strength on (Black 2's flag 0x964, the push reads it)
    PokePartyHasMoveAny PVAR_800C, 70  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_talk 83  // Pearl bank 334 line 10
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
    pl_CloseMessage
    pl_msg_talk 84  // Pearl bank 334 line 11
    pl_WaitButton
    pl_CloseMessage
    RTGetZoneID PVAR_8004  // GetCurrentMapID: Black 2 zone -> Pearl map
    WorkCmpConst PVAR_8004, 32
    VMJumpIf CMP_NE, .Lmap2bb_22
    WorkSetConst PVAR_8004, 22
    VMJump .Lmap2bb_end
.Lmap2bb_22:
    WorkCmpConst PVAR_8004, 129
    VMJumpIf CMP_NE, .Lmap2bb_89
    WorkSetConst PVAR_8004, 89
    VMJump .Lmap2bb_end
.Lmap2bb_89:
    WorkCmpConst PVAR_8004, 130
    VMJumpIf CMP_NE, .Lmap2bb_90
    WorkSetConst PVAR_8004, 90
    VMJump .Lmap2bb_end
.Lmap2bb_90:
    WorkCmpConst PVAR_8004, 132
    VMJumpIf CMP_NE, .Lmap2bb_92
    WorkSetConst PVAR_8004, 92
    VMJump .Lmap2bb_end
.Lmap2bb_92:
    WorkCmpConst PVAR_8004, 134
    VMJumpIf CMP_NE, .Lmap2bb_94
    WorkSetConst PVAR_8004, 94
    VMJump .Lmap2bb_end
.Lmap2bb_94:
    WorkCmpConst PVAR_8004, 145
    VMJumpIf CMP_NE, .Lmap2bb_96
    WorkSetConst PVAR_8004, 96
    VMJump .Lmap2bb_end
.Lmap2bb_96:
    WorkCmpConst PVAR_8004, 146
    VMJumpIf CMP_NE, .Lmap2bb_97
    WorkSetConst PVAR_8004, 97
    VMJump .Lmap2bb_end
.Lmap2bb_97:
    WorkCmpConst PVAR_8004, 148
    VMJumpIf CMP_NE, .Lmap2bb_98
    WorkSetConst PVAR_8004, 98
    VMJump .Lmap2bb_end
.Lmap2bb_98:
    WorkCmpConst PVAR_8004, 149
    VMJumpIf CMP_NE, .Lmap2bb_99
    WorkSetConst PVAR_8004, 99
    VMJump .Lmap2bb_end
.Lmap2bb_99:
    WorkCmpConst PVAR_8004, 276
    VMJumpIf CMP_NE, .Lmap2bb_209
    WorkSetConst PVAR_8004, 209
    VMJump .Lmap2bb_end
.Lmap2bb_209:
    WorkCmpConst PVAR_8004, 277
    VMJumpIf CMP_NE, .Lmap2bb_210
    WorkSetConst PVAR_8004, 210
    VMJump .Lmap2bb_end
.Lmap2bb_210:
    WorkCmpConst PVAR_8004, 278
    VMJumpIf CMP_NE, .Lmap2bb_211
    WorkSetConst PVAR_8004, 211
    VMJump .Lmap2bb_end
.Lmap2bb_211:
    WorkCmpConst PVAR_8004, 318
    VMJumpIf CMP_NE, .Lmap2bb_212
    WorkSetConst PVAR_8004, 212
    VMJump .Lmap2bb_end
.Lmap2bb_212:
    WorkCmpConst PVAR_8004, 320
    VMJumpIf CMP_NE, .Lmap2bb_213
    WorkSetConst PVAR_8004, 213
    VMJump .Lmap2bb_end
.Lmap2bb_213:
    WorkCmpConst PVAR_8004, 322
    VMJumpIf CMP_NE, .Lmap2bb_214
    WorkSetConst PVAR_8004, 214
    VMJump .Lmap2bb_end
.Lmap2bb_214:
    WorkCmpConst PVAR_8004, 323
    VMJumpIf CMP_NE, .Lmap2bb_215
    WorkSetConst PVAR_8004, 215
    VMJump .Lmap2bb_end
.Lmap2bb_215:
    WorkCmpConst PVAR_8004, 325
    VMJumpIf CMP_NE, .Lmap2bb_217
    WorkSetConst PVAR_8004, 217
    VMJump .Lmap2bb_end
.Lmap2bb_217:
    WorkCmpConst PVAR_8004, 328
    VMJumpIf CMP_NE, .Lmap2bb_219
    WorkSetConst PVAR_8004, 219
    VMJump .Lmap2bb_end
.Lmap2bb_219:
    WorkCmpConst PVAR_8004, 334
    VMJumpIf CMP_NE, .Lmap2bb_227
    WorkSetConst PVAR_8004, 227
    VMJump .Lmap2bb_end
.Lmap2bb_227:
    WorkCmpConst PVAR_8004, 335
    VMJumpIf CMP_NE, .Lmap2bb_228
    WorkSetConst PVAR_8004, 228
    VMJump .Lmap2bb_end
.Lmap2bb_228:
    WorkCmpConst PVAR_8004, 342
    VMJumpIf CMP_NE, .Lmap2bb_230
    WorkSetConst PVAR_8004, 230
    VMJump .Lmap2bb_end
.Lmap2bb_230:
    WorkCmpConst PVAR_8004, 343
    VMJumpIf CMP_NE, .Lmap2bb_231
    WorkSetConst PVAR_8004, 231
    VMJump .Lmap2bb_end
.Lmap2bb_231:
    WorkCmpConst PVAR_8004, 344
    VMJumpIf CMP_NE, .Lmap2bb_232
    WorkSetConst PVAR_8004, 232
    VMJump .Lmap2bb_end
.Lmap2bb_232:
    WorkCmpConst PVAR_8004, 346
    VMJumpIf CMP_NE, .Lmap2bb_233
    WorkSetConst PVAR_8004, 233
    VMJump .Lmap2bb_end
.Lmap2bb_233:
    WorkCmpConst PVAR_8004, 347
    VMJumpIf CMP_NE, .Lmap2bb_234
    WorkSetConst PVAR_8004, 234
    VMJump .Lmap2bb_end
.Lmap2bb_234:
    WorkCmpConst PVAR_8004, 349
    VMJumpIf CMP_NE, .Lmap2bb_235
    WorkSetConst PVAR_8004, 235
    VMJump .Lmap2bb_end
.Lmap2bb_235:
    WorkCmpConst PVAR_8004, 350
    VMJumpIf CMP_NE, .Lmap2bb_236
    WorkSetConst PVAR_8004, 236
    VMJump .Lmap2bb_end
.Lmap2bb_236:
    WorkCmpConst PVAR_8004, 351
    VMJumpIf CMP_NE, .Lmap2bb_237
    WorkSetConst PVAR_8004, 237
    VMJump .Lmap2bb_end
.Lmap2bb_237:
    WorkCmpConst PVAR_8004, 352
    VMJumpIf CMP_NE, .Lmap2bb_238
    WorkSetConst PVAR_8004, 238
    VMJump .Lmap2bb_end
.Lmap2bb_238:
    WorkCmpConst PVAR_8004, 353
    VMJumpIf CMP_NE, .Lmap2bb_239
    WorkSetConst PVAR_8004, 239
    VMJump .Lmap2bb_end
.Lmap2bb_239:
    WorkCmpConst PVAR_8004, 357
    VMJumpIf CMP_NE, .Lmap2bb_241
    WorkSetConst PVAR_8004, 241
    VMJump .Lmap2bb_end
.Lmap2bb_241:
    WorkCmpConst PVAR_8004, 358
    VMJumpIf CMP_NE, .Lmap2bb_242
    WorkSetConst PVAR_8004, 242
    VMJump .Lmap2bb_end
.Lmap2bb_242:
    WorkCmpConst PVAR_8004, 360
    VMJumpIf CMP_NE, .Lmap2bb_245
    WorkSetConst PVAR_8004, 245
    VMJump .Lmap2bb_end
.Lmap2bb_245:
    WorkCmpConst PVAR_8004, 361
    VMJumpIf CMP_NE, .Lmap2bb_246
    WorkSetConst PVAR_8004, 246
    VMJump .Lmap2bb_end
.Lmap2bb_246:
    WorkCmpConst PVAR_8004, 363
    VMJumpIf CMP_NE, .Lmap2bb_248
    WorkSetConst PVAR_8004, 248
    VMJump .Lmap2bb_end
.Lmap2bb_248:
    WorkCmpConst PVAR_8004, 364
    VMJumpIf CMP_NE, .Lmap2bb_249
    WorkSetConst PVAR_8004, 249
    VMJump .Lmap2bb_end
.Lmap2bb_249:
    WorkCmpConst PVAR_8004, 381
    VMJumpIf CMP_NE, .Lmap2bb_267
    WorkSetConst PVAR_8004, 267
    VMJump .Lmap2bb_end
.Lmap2bb_267:
    WorkCmpConst PVAR_8004, 385
    VMJumpIf CMP_NE, .Lmap2bb_279
    WorkSetConst PVAR_8004, 279
    VMJump .Lmap2bb_end
.Lmap2bb_279:
    WorkCmpConst PVAR_8004, 386
    VMJumpIf CMP_NE, .Lmap2bb_280
    WorkSetConst PVAR_8004, 280
    VMJump .Lmap2bb_end
.Lmap2bb_280:
    WorkCmpConst PVAR_8004, 388
    VMJumpIf CMP_NE, .Lmap2bb_281
    WorkSetConst PVAR_8004, 281
    VMJump .Lmap2bb_end
.Lmap2bb_281:
    WorkCmpConst PVAR_8004, 390
    VMJumpIf CMP_NE, .Lmap2bb_282
    WorkSetConst PVAR_8004, 282
    VMJump .Lmap2bb_end
.Lmap2bb_282:
    WorkCmpConst PVAR_8004, 393
    VMJumpIf CMP_NE, .Lmap2bb_285
    WorkSetConst PVAR_8004, 285
    VMJump .Lmap2bb_end
.Lmap2bb_285:
    WorkCmpConst PVAR_8004, 395
    VMJumpIf CMP_NE, .Lmap2bb_287
    WorkSetConst PVAR_8004, 287
    VMJump .Lmap2bb_end
.Lmap2bb_287:
    WorkCmpConst PVAR_8004, 398
    VMJumpIf CMP_NE, .Lmap2bb_290
    WorkSetConst PVAR_8004, 290
    VMJump .Lmap2bb_end
.Lmap2bb_290:
    WorkCmpConst PVAR_8004, 400
    VMJumpIf CMP_NE, .Lmap2bb_292
    WorkSetConst PVAR_8004, 292
    VMJump .Lmap2bb_end
.Lmap2bb_292:
    WorkCmpConst PVAR_8004, 405
    VMJumpIf CMP_NE, .Lmap2bb_297
    WorkSetConst PVAR_8004, 297
    VMJump .Lmap2bb_end
.Lmap2bb_297:
    WorkCmpConst PVAR_8004, 407
    VMJumpIf CMP_NE, .Lmap2bb_298
    WorkSetConst PVAR_8004, 298
    VMJump .Lmap2bb_end
.Lmap2bb_298:
    WorkCmpConst PVAR_8004, 408
    VMJumpIf CMP_NE, .Lmap2bb_299
    WorkSetConst PVAR_8004, 299
    VMJump .Lmap2bb_end
.Lmap2bb_299:
    WorkCmpConst PVAR_8004, 410
    VMJumpIf CMP_NE, .Lmap2bb_301
    WorkSetConst PVAR_8004, 301
    VMJump .Lmap2bb_end
.Lmap2bb_301:
    WorkCmpConst PVAR_8004, 413
    VMJumpIf CMP_NE, .Lmap2bb_303
    WorkSetConst PVAR_8004, 303
    VMJump .Lmap2bb_end
.Lmap2bb_303:
    WorkCmpConst PVAR_8004, 17
    VMJumpIf CMP_NE, .Lmap2bb_341
    WorkSetConst PVAR_8004, 341
    VMJump .Lmap2bb_end
.Lmap2bb_341:
    WorkCmpConst PVAR_8004, 459
    VMJumpIf CMP_NE, .Lmap2bb_358
    WorkSetConst PVAR_8004, 358
    VMJump .Lmap2bb_end
.Lmap2bb_358:
    WorkCmpConst PVAR_8004, 460
    VMJumpIf CMP_NE, .Lmap2bb_359
    WorkSetConst PVAR_8004, 359
    VMJump .Lmap2bb_end
.Lmap2bb_359:
    WorkCmpConst PVAR_8004, 462
    VMJumpIf CMP_NE, .Lmap2bb_360
    WorkSetConst PVAR_8004, 360
    VMJump .Lmap2bb_end
.Lmap2bb_360:
    WorkCmpConst PVAR_8004, 436
    VMJumpIf CMP_NE, .Lmap2bb_467
    WorkSetConst PVAR_8004, 467
    VMJump .Lmap2bb_end
.Lmap2bb_467:
    WorkCmpConst PVAR_8004, 445
    VMJumpIf CMP_NE, .Lmap2bb_468
    WorkSetConst PVAR_8004, 468
    VMJump .Lmap2bb_end
.Lmap2bb_468:
    WorkCmpConst PVAR_8004, 504
    VMJumpIf CMP_NE, .Lmap2bb_472
    WorkSetConst PVAR_8004, 472
    VMJump .Lmap2bb_end
.Lmap2bb_472:
    WorkCmpConst PVAR_8004, 540
    VMJumpIf CMP_NE, .Lmap2bb_515
    WorkSetConst PVAR_8004, 515
    VMJump .Lmap2bb_end
.Lmap2bb_515:
.Lmap2bb_end:
// CreateJournalEvent 22, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo T375_3_055B

T375_3_02D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 85  // Pearl bank 334 line 9
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_055B:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
