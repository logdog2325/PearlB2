// MAP_TWINLEAF: Pearl script file 978, text bank 498. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-9: Pearl's; no warp continuations; 10: PearlArrive; 29-31: the new game
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P978_S1
    ScriptEntry P978_S2
    ScriptEntry P978_S3
    ScriptEntry P978_S4
    ScriptEntry P978_S5
    ScriptEntry P978_S6
    ScriptEntry P978_S7
    ScriptEntry P978_S8
    ScriptEntry P978_S9
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
    ScriptEntry PearlNewGame_29
    ScriptEntry PearlNewGame_30
    ScriptEntry PearlNewGame_31
    ScriptEntriesEnd

P978_S1:
P978_0026:
    pl_CompareVarToValue PVAR_40F4, 1
    pl_CallIf 1, P978_004F
    pl_CompareVarToValue PVAR_40A4, 4
    pl_CallIf 1, P978_005F
    pl_CompareVarToValue PVAR_40A4, 6
    pl_CallIf 1, P978_0057
    pl_End

P978_004F:
    pl_SetVarFromValue PVAR_40F4, 2
    pl_Return

P978_0057:
    pl_SetVarFromValue PVAR_40A4, 7
    pl_Return

P978_005F:
    pl_SetVarFromValue PVAR_40A4, 5
    pl_Return

P978_S3:
P978_0067:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0090
    pl_GoToIf 1, P978_00A3
    pl_CompareVarToValue PVAR_4095, 1
    pl_GoToIf 4, P978_00AE
    pl_CheckFlag PFLAG_00EA
    pl_GoToIf 1, P978_00BC
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_00A3:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_00AE:
    pl_BufferRivalName 0
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_00BC:
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_S4:
P978_00CD:
    pl_LockAll
    pl_ApplyMovement 3, P978_03B0
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 108
    pl_GoToIf 1, P978_0140
    pl_CompareVarToValue PVAR_8004, 109
    pl_GoToIf 1, P978_0158
    pl_CompareVarToValue PVAR_8004, 110
    pl_GoToIf 1, P978_0170
    pl_CompareVarToValue PVAR_8004, 111
    pl_GoToIf 1, P978_0188
    pl_CompareVarToValue PVAR_8004, 112
    pl_GoToIf 1, P978_01A0
    pl_CompareVarToValue PVAR_8004, 113
    pl_GoToIf 1, P978_01B8
    pl_CompareVarToValue PVAR_8004, 114
    pl_GoToIf 1, P978_01D0
    pl_GoTo P978_01E8

P978_0140:
    pl_ApplyMovement PL_PLAYER, P978_02F0
    pl_ApplyMovement 3, P978_03C4
    pl_WaitMovement
    pl_GoTo P978_0200

P978_0158:
    pl_ApplyMovement PL_PLAYER, P978_0308
    pl_ApplyMovement 3, P978_03E0
    pl_WaitMovement
    pl_GoTo P978_0200

P978_0170:
    pl_ApplyMovement PL_PLAYER, P978_0320
    pl_ApplyMovement 3, P978_03F4
    pl_WaitMovement
    pl_GoTo P978_0200

P978_0188:
    pl_ApplyMovement PL_PLAYER, P978_0338
    pl_ApplyMovement 3, P978_0408
    pl_WaitMovement
    pl_GoTo P978_0200

P978_01A0:
    pl_ApplyMovement PL_PLAYER, P978_0350
    pl_ApplyMovement 3, P978_041C
    pl_WaitMovement
    pl_GoTo P978_0200

P978_01B8:
    pl_ApplyMovement PL_PLAYER, P978_0368
    pl_ApplyMovement 3, P978_0430
    pl_WaitMovement
    pl_GoTo P978_0200

P978_01D0:
    pl_ApplyMovement PL_PLAYER, P978_0380
    pl_ApplyMovement 3, P978_0444
    pl_WaitMovement
    pl_GoTo P978_0200

P978_01E8:
    pl_ApplyMovement PL_PLAYER, P978_0398
    pl_ApplyMovement 3, P978_0458
    pl_WaitMovement
    pl_GoTo P978_0200

P978_0200:
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_sys 3
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8004, 108
    pl_GoToIf 1, P978_026C
    pl_CompareVarToValue PVAR_8004, 109
    pl_GoToIf 1, P978_027C
    pl_CompareVarToValue PVAR_8004, 110
    pl_GoToIf 1, P978_028C
    pl_CompareVarToValue PVAR_8004, 111
    pl_GoToIf 1, P978_029C
    pl_CompareVarToValue PVAR_8004, 112
    pl_GoToIf 1, P978_02AC
    pl_CompareVarToValue PVAR_8004, 113
    pl_GoToIf 1, P978_02BC
    pl_CompareVarToValue PVAR_8004, 114
    pl_GoToIf 1, P978_02CC
    pl_GoTo P978_02DC

P978_026C:
    pl_ApplyMovement 3, P978_046C
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_027C:
    pl_ApplyMovement 3, P978_047C
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_028C:
    pl_ApplyMovement 3, P978_0488
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_029C:
    pl_ApplyMovement 3, P978_0494
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_02AC:
    pl_ApplyMovement 3, P978_04A0
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_02BC:
    pl_ApplyMovement 3, P978_04AC
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_02CC:
    pl_ApplyMovement 3, P978_04B8
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_02DC:
    pl_ApplyMovement 3, P978_04C4
    pl_WaitMovement
    pl_GoTo P978_02EC

P978_02EC:
    pl_ReleaseAll
    pl_End

P978_S2:
P978_04D0:
    pl_LockAll
    pl_LoadDoorAnimation 77, 105, 875  // the door at cell (3,27) tile (9,11)
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_ClearFlag PFLAG_0192
    pl_AddObject 2
    pl_ApplyMovement 2, P978_05A4
    pl_ApplyMovement PL_PLAYER, P978_0588
    pl_WaitMovement
    pl_PlaySE SEQ_SE_WALL_HIT  // Pearl SEQ_SE_DP_WALL_HIT2
    pl_msg_sys 0
    pl_WaitTime 30, PVAR_800C
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_ApplyMovement 2, P978_059C
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P978_0570
    pl_ApplyMovement 2, P978_05B0
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_BufferRivalName 0
    pl_msg_sys 2
    pl_CloseMessage
    pl_ApplyMovement 2, P978_05C8
    pl_WaitMovement
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_RemoveObject 2, PFLAG_0192
    VMCall C205_44_S44  // CallCommonScript 2043 (Pearl file 205 script 44)
    pl_SetVarFromValue PVAR_4070, 1
    pl_SetVarFromValue PVAR_40E6, 1
    pl_ReleaseAll
    pl_End

P978_S5:
P978_05D4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_S6:
P978_05E7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0090
    pl_GoToIf 1, P978_0612
    pl_CompareVarToValue PVAR_4095, 1
    pl_GoToIf 4, P978_061D
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_0612:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_061D:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P978_S7:
P978_0628:
    pl_sign 12, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P978_S8:
P978_063F:
    pl_BufferPlayerName 0
    pl_sign 13, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P978_S9:
P978_0659:
    pl_BufferRivalName 0
    pl_sign 14, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P978_02F0:
    Move 62, 6  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_0308:
    Move 62, 5  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_0320:
    Move 62, 6  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_0338:
    Move 62, 7  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_0350:
    Move 62, 8  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_0368:
    Move 62, 9  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_0380:
    Move 62, 10  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_0398:
    Move 62, 11  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_03B0:
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 63, 1  // DELAY_8
    Move 62, 1  // DELAY_4
    MoveEnd

    .balign 4, 0
P978_03C4:
    Move 16, 1  // WALK_FAST_NORTH
    Move 19, 1  // WALK_FAST_EAST
    Move 16, 2  // WALK_FAST_NORTH
    Move 18, 1  // WALK_FAST_WEST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_03E0:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 1  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_03F4:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 2  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_0408:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 3  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_041C:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 4  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_0430:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 5  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_0444:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 6  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_0458:
    Move 16, 3  // WALK_FAST_NORTH
    Move 19, 7  // WALK_FAST_EAST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_046C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P978_047C:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_0488:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_0494:
    Move 14, 3  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_04A0:
    Move 14, 4  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_04AC:
    Move 14, 5  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_04B8:
    Move 14, 6  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_04C4:
    Move 14, 7  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P978_0570:
    Move 63, 1  // DELAY_8
    Move 62, 1  // DELAY_4
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 63, 5  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P978_0588:
    Move 0, 1  // FACE_NORTH
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P978_059C:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P978_05A4:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P978_05B0:
    Move 19, 4  // WALK_FAST_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 63, 1  // DELAY_8
    Move 18, 4  // WALK_FAST_WEST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P978_05C8:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

// ---- Pearl global script 205:43 (a subroutine here)
C205_43_S43:
C205_43_14FF:
    pl_FadeOutBGM 1  // StopMusic
    #ifdef SEQ_PEARL_THE_RIV
        pl_PlayMusic SEQ_PEARL_THE_RIV  // Pearl SEQ_THE_RIV
    #else
        pl_PlayMusic SEQ_BGM_E_HUE  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:44 (a subroutine here)
C205_44_S44:
C205_44_1517:
    pl_FadeOutBGM 30  // FadeOutBGM to volume 0
    pl_FadeOutBGM 1  // StopMusic
    pl_PlayDefaultMusic
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 377:1 (a subroutine here)
C377_1_S1:
C377_1_0006:
    pl_SetFlag PFLAG_0197
    pl_SetFlag PFLAG_0196
    pl_SetFlag PFLAG_01AD
    pl_SetFlag PFLAG_0194
    pl_SetFlag PFLAG_01B3
    pl_SetFlag PFLAG_01FD
    pl_SetFlag PFLAG_01FE
    pl_SetFlag PFLAG_01FF
    pl_SetFlag PFLAG_02B4
    pl_SetFlag PFLAG_02B1
    pl_SetFlag PFLAG_01D8
    pl_SetFlag PFLAG_0192
    pl_SetFlag PFLAG_020F
    pl_SetVarFromValue PVAR_4070, 1
    pl_SetFlag PFLAG_01B5
    pl_SetFlag PFLAG_0248
    pl_SetFlag PFLAG_01C1
    pl_SetVarFromValue PVAR_4072, 1
    pl_SetFlag PFLAG_0217
    pl_SetFlag PFLAG_021A
    pl_SetFlag PFLAG_01DB
    pl_SetFlag PFLAG_0247
    pl_SetFlag PFLAG_01E1
    pl_SetFlag PFLAG_0198
    pl_SetFlag PFLAG_01BB
    pl_SetFlag PFLAG_01BA
    pl_SetFlag PFLAG_0214
    pl_SetFlag PFLAG_0215
    pl_SetFlag PFLAG_0213
    pl_SetFlag PFLAG_01A9
    pl_SetFlag PFLAG_01D3
    pl_SetFlag PFLAG_01D1
    pl_SetFlag PFLAG_01D0
    pl_SetFlag PFLAG_01D2
    pl_SetFlag PFLAG_01D4
    pl_SetFlag PFLAG_01D5
    pl_SetFlag PFLAG_01D6
    pl_SetFlag PFLAG_01B8
    pl_SetVarFromValue PVAR_4093, 1
    pl_SetFlag PFLAG_019E
    pl_SetFlag PFLAG_021C
    pl_SetFlag PFLAG_021E
    pl_SetFlag PFLAG_01B0
    pl_SetFlag PFLAG_0260
    pl_SetFlag PFLAG_025B
    pl_SetFlag PFLAG_025A
    pl_SetFlag PFLAG_01C8
    pl_SetFlag PFLAG_0225
    pl_SetFlag PFLAG_01C7
    pl_SetFlag PFLAG_0238
    pl_SetFlag PFLAG_02B0
    pl_SetFlag PFLAG_0241
    pl_SetFlag PFLAG_04C8
    pl_SetFlag PFLAG_01EA
    pl_SetFlag PFLAG_023B
    pl_SetFlag PFLAG_01BC
    pl_SetFlag PFLAG_01E9
    pl_SetFlag PFLAG_0207
    pl_SetFlag PFLAG_0294
    pl_SetFlag PFLAG_0295
    pl_SetFlag PFLAG_01F4
    pl_SetFlag PFLAG_01FA
    pl_SetFlag PFLAG_01FB
    pl_SetFlag PFLAG_01EF
    pl_SetFlag PFLAG_023C
    pl_SetFlag PFLAG_0211
    pl_SetFlag PFLAG_01CB
    pl_SetFlag PFLAG_0239
    pl_SetFlag PFLAG_0252
    pl_SetFlag PFLAG_01CF
    pl_SetFlag PFLAG_027C
    pl_stub InitSizeContestRecord  // Pearl 0x1C5 InitPokemonRecordSize : not translated yet
    pl_stub RandomizeJubilifeLottery  // Pearl 0x250 Unk0250 : not translated yet
    pl_stub InitDailyRandomLevel  // Pearl 0x27B Unk027B : not translated yet
    pl_SetFlag PFLAG_026B
    pl_SetFlag PFLAG_0279
    pl_SetFlag PFLAG_0270
    pl_SetFlag PFLAG_0436
    pl_SetVarFromValue PVAR_4040, 9
    pl_SetFlag PFLAG_0296
    pl_SetFlag PFLAG_0235
    pl_SetFlag PFLAG_02B3
    VMReturn  // End: the sub-script ends

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

#define PEARL_START_ZONE 521   // MAP_TWINLEAF_RIVAL_HOUSE_2F
#define PEARL_START_X 4
#define PEARL_START_Z 6
#define PEARL_START_DIR 0
#define PEARL_START_ARRIVE 7   // its PearlArrive
#include "pearl/newgame.inc"

    .balign 4, 0
