// MAP_MOUNT_CORONET_4F_ROOM_1: Pearl script file 368, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive; 93: Pearl 10001, 106: Pearl 10003
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
    ScriptEntry PearlProxy_10001
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
    ScriptEntry PearlProxy_10003
    ScriptEntriesEnd

P368_S1:
P368_0006:
    pl_End

PearlProxy_10001:                  // Pearl global script 10001 (run by this zone's events)
    VMCall T375_2_S2
    VMHalt

PearlProxy_10003:                  // Pearl global script 10003 (run by this zone's events)
    VMCall C375_4_S4
    VMHalt

// ---- Pearl global script 375:2 (a subroutine here)
T375_2_S2:
T375_2_0139:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    PokePartyHasMoveAny PVAR_800C, 249  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_2_018B
    pl_CheckBadgeAcquired 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_018B
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 81  // Pearl bank 334 line 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_019A
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_018B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 82  // Pearl bank 334 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_019A:
    pl_BufferPartyMonNickname 0, PVAR_8004
    pl_msg_talk 83  // Pearl bank 334 line 5
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 1: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    RTGetZoneID PVAR_8004  // GetCurrentMapID: Black 2 zone -> Pearl map
    WorkCmpConst PVAR_8004, 32
    VMJumpIf CMP_NE, .Lmap1b8_22
    WorkSetConst PVAR_8004, 22
    VMJump .Lmap1b8_end
.Lmap1b8_22:
    WorkCmpConst PVAR_8004, 129
    VMJumpIf CMP_NE, .Lmap1b8_89
    WorkSetConst PVAR_8004, 89
    VMJump .Lmap1b8_end
.Lmap1b8_89:
    WorkCmpConst PVAR_8004, 130
    VMJumpIf CMP_NE, .Lmap1b8_90
    WorkSetConst PVAR_8004, 90
    VMJump .Lmap1b8_end
.Lmap1b8_90:
    WorkCmpConst PVAR_8004, 132
    VMJumpIf CMP_NE, .Lmap1b8_92
    WorkSetConst PVAR_8004, 92
    VMJump .Lmap1b8_end
.Lmap1b8_92:
    WorkCmpConst PVAR_8004, 134
    VMJumpIf CMP_NE, .Lmap1b8_94
    WorkSetConst PVAR_8004, 94
    VMJump .Lmap1b8_end
.Lmap1b8_94:
    WorkCmpConst PVAR_8004, 145
    VMJumpIf CMP_NE, .Lmap1b8_96
    WorkSetConst PVAR_8004, 96
    VMJump .Lmap1b8_end
.Lmap1b8_96:
    WorkCmpConst PVAR_8004, 146
    VMJumpIf CMP_NE, .Lmap1b8_97
    WorkSetConst PVAR_8004, 97
    VMJump .Lmap1b8_end
.Lmap1b8_97:
    WorkCmpConst PVAR_8004, 148
    VMJumpIf CMP_NE, .Lmap1b8_98
    WorkSetConst PVAR_8004, 98
    VMJump .Lmap1b8_end
.Lmap1b8_98:
    WorkCmpConst PVAR_8004, 149
    VMJumpIf CMP_NE, .Lmap1b8_99
    WorkSetConst PVAR_8004, 99
    VMJump .Lmap1b8_end
.Lmap1b8_99:
    WorkCmpConst PVAR_8004, 276
    VMJumpIf CMP_NE, .Lmap1b8_209
    WorkSetConst PVAR_8004, 209
    VMJump .Lmap1b8_end
.Lmap1b8_209:
    WorkCmpConst PVAR_8004, 277
    VMJumpIf CMP_NE, .Lmap1b8_210
    WorkSetConst PVAR_8004, 210
    VMJump .Lmap1b8_end
.Lmap1b8_210:
    WorkCmpConst PVAR_8004, 278
    VMJumpIf CMP_NE, .Lmap1b8_211
    WorkSetConst PVAR_8004, 211
    VMJump .Lmap1b8_end
.Lmap1b8_211:
    WorkCmpConst PVAR_8004, 318
    VMJumpIf CMP_NE, .Lmap1b8_212
    WorkSetConst PVAR_8004, 212
    VMJump .Lmap1b8_end
.Lmap1b8_212:
    WorkCmpConst PVAR_8004, 320
    VMJumpIf CMP_NE, .Lmap1b8_213
    WorkSetConst PVAR_8004, 213
    VMJump .Lmap1b8_end
.Lmap1b8_213:
    WorkCmpConst PVAR_8004, 322
    VMJumpIf CMP_NE, .Lmap1b8_214
    WorkSetConst PVAR_8004, 214
    VMJump .Lmap1b8_end
.Lmap1b8_214:
    WorkCmpConst PVAR_8004, 323
    VMJumpIf CMP_NE, .Lmap1b8_215
    WorkSetConst PVAR_8004, 215
    VMJump .Lmap1b8_end
.Lmap1b8_215:
    WorkCmpConst PVAR_8004, 325
    VMJumpIf CMP_NE, .Lmap1b8_217
    WorkSetConst PVAR_8004, 217
    VMJump .Lmap1b8_end
.Lmap1b8_217:
    WorkCmpConst PVAR_8004, 328
    VMJumpIf CMP_NE, .Lmap1b8_219
    WorkSetConst PVAR_8004, 219
    VMJump .Lmap1b8_end
.Lmap1b8_219:
    WorkCmpConst PVAR_8004, 334
    VMJumpIf CMP_NE, .Lmap1b8_227
    WorkSetConst PVAR_8004, 227
    VMJump .Lmap1b8_end
.Lmap1b8_227:
    WorkCmpConst PVAR_8004, 335
    VMJumpIf CMP_NE, .Lmap1b8_228
    WorkSetConst PVAR_8004, 228
    VMJump .Lmap1b8_end
.Lmap1b8_228:
    WorkCmpConst PVAR_8004, 342
    VMJumpIf CMP_NE, .Lmap1b8_230
    WorkSetConst PVAR_8004, 230
    VMJump .Lmap1b8_end
.Lmap1b8_230:
    WorkCmpConst PVAR_8004, 343
    VMJumpIf CMP_NE, .Lmap1b8_231
    WorkSetConst PVAR_8004, 231
    VMJump .Lmap1b8_end
.Lmap1b8_231:
    WorkCmpConst PVAR_8004, 344
    VMJumpIf CMP_NE, .Lmap1b8_232
    WorkSetConst PVAR_8004, 232
    VMJump .Lmap1b8_end
.Lmap1b8_232:
    WorkCmpConst PVAR_8004, 346
    VMJumpIf CMP_NE, .Lmap1b8_233
    WorkSetConst PVAR_8004, 233
    VMJump .Lmap1b8_end
.Lmap1b8_233:
    WorkCmpConst PVAR_8004, 347
    VMJumpIf CMP_NE, .Lmap1b8_234
    WorkSetConst PVAR_8004, 234
    VMJump .Lmap1b8_end
.Lmap1b8_234:
    WorkCmpConst PVAR_8004, 349
    VMJumpIf CMP_NE, .Lmap1b8_235
    WorkSetConst PVAR_8004, 235
    VMJump .Lmap1b8_end
.Lmap1b8_235:
    WorkCmpConst PVAR_8004, 350
    VMJumpIf CMP_NE, .Lmap1b8_236
    WorkSetConst PVAR_8004, 236
    VMJump .Lmap1b8_end
.Lmap1b8_236:
    WorkCmpConst PVAR_8004, 351
    VMJumpIf CMP_NE, .Lmap1b8_237
    WorkSetConst PVAR_8004, 237
    VMJump .Lmap1b8_end
.Lmap1b8_237:
    WorkCmpConst PVAR_8004, 352
    VMJumpIf CMP_NE, .Lmap1b8_238
    WorkSetConst PVAR_8004, 238
    VMJump .Lmap1b8_end
.Lmap1b8_238:
    WorkCmpConst PVAR_8004, 353
    VMJumpIf CMP_NE, .Lmap1b8_239
    WorkSetConst PVAR_8004, 239
    VMJump .Lmap1b8_end
.Lmap1b8_239:
    WorkCmpConst PVAR_8004, 357
    VMJumpIf CMP_NE, .Lmap1b8_241
    WorkSetConst PVAR_8004, 241
    VMJump .Lmap1b8_end
.Lmap1b8_241:
    WorkCmpConst PVAR_8004, 358
    VMJumpIf CMP_NE, .Lmap1b8_242
    WorkSetConst PVAR_8004, 242
    VMJump .Lmap1b8_end
.Lmap1b8_242:
    WorkCmpConst PVAR_8004, 360
    VMJumpIf CMP_NE, .Lmap1b8_245
    WorkSetConst PVAR_8004, 245
    VMJump .Lmap1b8_end
.Lmap1b8_245:
    WorkCmpConst PVAR_8004, 361
    VMJumpIf CMP_NE, .Lmap1b8_246
    WorkSetConst PVAR_8004, 246
    VMJump .Lmap1b8_end
.Lmap1b8_246:
    WorkCmpConst PVAR_8004, 363
    VMJumpIf CMP_NE, .Lmap1b8_248
    WorkSetConst PVAR_8004, 248
    VMJump .Lmap1b8_end
.Lmap1b8_248:
    WorkCmpConst PVAR_8004, 364
    VMJumpIf CMP_NE, .Lmap1b8_249
    WorkSetConst PVAR_8004, 249
    VMJump .Lmap1b8_end
.Lmap1b8_249:
    WorkCmpConst PVAR_8004, 381
    VMJumpIf CMP_NE, .Lmap1b8_267
    WorkSetConst PVAR_8004, 267
    VMJump .Lmap1b8_end
.Lmap1b8_267:
    WorkCmpConst PVAR_8004, 385
    VMJumpIf CMP_NE, .Lmap1b8_279
    WorkSetConst PVAR_8004, 279
    VMJump .Lmap1b8_end
.Lmap1b8_279:
    WorkCmpConst PVAR_8004, 386
    VMJumpIf CMP_NE, .Lmap1b8_280
    WorkSetConst PVAR_8004, 280
    VMJump .Lmap1b8_end
.Lmap1b8_280:
    WorkCmpConst PVAR_8004, 388
    VMJumpIf CMP_NE, .Lmap1b8_281
    WorkSetConst PVAR_8004, 281
    VMJump .Lmap1b8_end
.Lmap1b8_281:
    WorkCmpConst PVAR_8004, 390
    VMJumpIf CMP_NE, .Lmap1b8_282
    WorkSetConst PVAR_8004, 282
    VMJump .Lmap1b8_end
.Lmap1b8_282:
    WorkCmpConst PVAR_8004, 393
    VMJumpIf CMP_NE, .Lmap1b8_285
    WorkSetConst PVAR_8004, 285
    VMJump .Lmap1b8_end
.Lmap1b8_285:
    WorkCmpConst PVAR_8004, 395
    VMJumpIf CMP_NE, .Lmap1b8_287
    WorkSetConst PVAR_8004, 287
    VMJump .Lmap1b8_end
.Lmap1b8_287:
    WorkCmpConst PVAR_8004, 398
    VMJumpIf CMP_NE, .Lmap1b8_290
    WorkSetConst PVAR_8004, 290
    VMJump .Lmap1b8_end
.Lmap1b8_290:
    WorkCmpConst PVAR_8004, 400
    VMJumpIf CMP_NE, .Lmap1b8_292
    WorkSetConst PVAR_8004, 292
    VMJump .Lmap1b8_end
.Lmap1b8_292:
    WorkCmpConst PVAR_8004, 405
    VMJumpIf CMP_NE, .Lmap1b8_297
    WorkSetConst PVAR_8004, 297
    VMJump .Lmap1b8_end
.Lmap1b8_297:
    WorkCmpConst PVAR_8004, 407
    VMJumpIf CMP_NE, .Lmap1b8_298
    WorkSetConst PVAR_8004, 298
    VMJump .Lmap1b8_end
.Lmap1b8_298:
    WorkCmpConst PVAR_8004, 408
    VMJumpIf CMP_NE, .Lmap1b8_299
    WorkSetConst PVAR_8004, 299
    VMJump .Lmap1b8_end
.Lmap1b8_299:
    WorkCmpConst PVAR_8004, 410
    VMJumpIf CMP_NE, .Lmap1b8_301
    WorkSetConst PVAR_8004, 301
    VMJump .Lmap1b8_end
.Lmap1b8_301:
    WorkCmpConst PVAR_8004, 413
    VMJumpIf CMP_NE, .Lmap1b8_303
    WorkSetConst PVAR_8004, 303
    VMJump .Lmap1b8_end
.Lmap1b8_303:
    WorkCmpConst PVAR_8004, 17
    VMJumpIf CMP_NE, .Lmap1b8_341
    WorkSetConst PVAR_8004, 341
    VMJump .Lmap1b8_end
.Lmap1b8_341:
    WorkCmpConst PVAR_8004, 459
    VMJumpIf CMP_NE, .Lmap1b8_358
    WorkSetConst PVAR_8004, 358
    VMJump .Lmap1b8_end
.Lmap1b8_358:
    WorkCmpConst PVAR_8004, 460
    VMJumpIf CMP_NE, .Lmap1b8_359
    WorkSetConst PVAR_8004, 359
    VMJump .Lmap1b8_end
.Lmap1b8_359:
    WorkCmpConst PVAR_8004, 462
    VMJumpIf CMP_NE, .Lmap1b8_360
    WorkSetConst PVAR_8004, 360
    VMJump .Lmap1b8_end
.Lmap1b8_360:
    WorkCmpConst PVAR_8004, 436
    VMJumpIf CMP_NE, .Lmap1b8_467
    WorkSetConst PVAR_8004, 467
    VMJump .Lmap1b8_end
.Lmap1b8_467:
    WorkCmpConst PVAR_8004, 445
    VMJumpIf CMP_NE, .Lmap1b8_468
    WorkSetConst PVAR_8004, 468
    VMJump .Lmap1b8_end
.Lmap1b8_468:
    WorkCmpConst PVAR_8004, 504
    VMJumpIf CMP_NE, .Lmap1b8_472
    WorkSetConst PVAR_8004, 472
    VMJump .Lmap1b8_end
.Lmap1b8_472:
    WorkCmpConst PVAR_8004, 540
    VMJumpIf CMP_NE, .Lmap1b8_515
    WorkSetConst PVAR_8004, 515
    VMJump .Lmap1b8_end
.Lmap1b8_515:
.Lmap1b8_end:
// CreateJournalEvent 24, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)

T375_2_01C8:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, T375_2_01C8
    pl_GoTo T375_2_055B

T375_2_055B:
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 375:4 (a subroutine here)
C375_4_S4:
C375_4_0324:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, C375_4_037F
    pl_CheckBadgeAcquired 6, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_037F
    FlagGet PL_FOLLOW_FLAG, PVAR_800C  // CheckHasPartner: 1 while a partner follows
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C375_4_038E
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 84  // Pearl bank 334 line 18
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C375_4_039D
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_037F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 85  // Pearl bank 334 line 20
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_038E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 86  // Pearl bank 334 line 21
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo C375_4_055F

C375_4_039D:
    PokePartyHasMoveAny PVAR_800C, 431  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_sys 87  // Pearl bank 334 line 19
    pl_CloseMessage
// UseRockClimb PVAR_8004: 2 climb starts in this zone
    pl_GetPlayerMapPos PL_TMP, PL_TMP2
    pl_GetPlayerDir PL_TMP3
    WorkCmpConst PL_TMP, 7
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP2, 12
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    WorkCmpConst PL_TMP3, 1
    VMJumpIf CMP_NE, C375_4_03B3_rc0_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc0  // from (7, 12) to (7, 17)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc0_next:
    WorkCmpConst PL_TMP, 7
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP2, 17
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    WorkCmpConst PL_TMP3, 0
    VMJumpIf CMP_NE, C375_4_03B3_rc1_next
    pl_ApplyMovement PL_PLAYER, C375_4_03B3_rc1  // from (7, 17) to (7, 12)
    pl_WaitMovement
    VMJump C375_4_03B3_rc_end
C375_4_03B3_rc1_next:
    VMJump C375_4_03B3_rc_end
    .balign 4, 0
C375_4_03B3_rc0:
        Move 53, 1
        Move 17, 3
        Move 53, 1
        MoveEnd
    .balign 4, 0
C375_4_03B3_rc1:
        Move 52, 1
        Move 16, 3
        Move 52, 1
        MoveEnd
C375_4_03B3_rc_end:
    WorkSetConst PVAR_8004, 212  // GetCurrentMapID: Pearl map 212
// CreateJournalEvent 26, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo C375_4_055F

C375_4_055F:
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
