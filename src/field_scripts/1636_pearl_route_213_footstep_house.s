// MAP_ROUTE_213_FOOTSTEP_HOUSE: Pearl script file 426, text bank 446. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P426_S1
    ScriptEntry P426_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P426_S1:
P426_000A:
    pl_SetFlag PFLAG_09ED
    pl_End

P426_S2:
P426_0010:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetFirstNonEggInParty PVAR_8002
    pl_BufferPartyMonSpecies 0, PVAR_8002
    pl_BufferPlayerName 1
    pl_BufferPartyMonNickname 2, PVAR_8002
    pl_stub GetPartyMonFootprintType  // Pearl 0x23A GetPokemonFootprint 32768, 32769, 32770: not translated yet
    pl_CheckFlag PFLAG_00F9
    pl_GoToIf 1, P426_004B
    pl_SetFlag PFLAG_00F9
    pl_msg_talk 0
    pl_CloseMessage
    pl_GoTo P426_0056

P426_004B:
    pl_msg_talk 1
    pl_CloseMessage
    pl_GoTo P426_0056

P426_0056:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_WaitTime 40, PVAR_800C
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_Call P426_0086
    pl_WaitTime 20, PVAR_800C
    pl_GoTo P426_014C

P426_0086:
    pl_GetPlayerMapPos PVAR_8005, PVAR_8006
    pl_CompareVarToValue PVAR_8005, 4
    pl_GoToIf 1, P426_00B9
    pl_CompareVarToValue PVAR_8005, 6
    pl_GoToIf 1, P426_00C5
    pl_CompareVarToValue PVAR_8006, 5
    pl_GoToIf 1, P426_00D1
    pl_GoTo P426_00DD

P426_00B9:
    pl_ApplyMovement 0, P426_0694
    pl_WaitMovement
    pl_Return

P426_00C5:
    pl_ApplyMovement 0, P426_06A4
    pl_WaitMovement
    pl_Return

P426_00D1:
    pl_ApplyMovement 0, P426_06B4
    pl_WaitMovement
    pl_Return

P426_00DD:
    pl_ApplyMovement 0, P426_06C4
    pl_WaitMovement
    pl_Return

P426_00E9:
    pl_GetPlayerMapPos PVAR_8005, PVAR_8006
    pl_CompareVarToValue PVAR_8005, 4
    pl_GoToIf 1, P426_011C
    pl_CompareVarToValue PVAR_8005, 6
    pl_GoToIf 1, P426_0128
    pl_CompareVarToValue PVAR_8006, 5
    pl_GoToIf 1, P426_0134
    pl_GoTo P426_0140

P426_011C:
    pl_ApplyMovement 0, P426_06D4
    pl_WaitMovement
    pl_Return

P426_0128:
    pl_ApplyMovement 0, P426_06DC
    pl_WaitMovement
    pl_Return

P426_0134:
    pl_ApplyMovement 0, P426_06E4
    pl_WaitMovement
    pl_Return

P426_0140:
    pl_ApplyMovement 0, P426_06EC
    pl_WaitMovement
    pl_Return

P426_014C:
    pl_CompareVarToValue PVAR_8001, 1
    pl_GoToIf 1, P426_0186
    pl_CompareVarToValue PVAR_8001, 2
    pl_GoToIf 1, P426_0199
    pl_CompareVarToValue PVAR_8001, 3
    pl_GoToIf 1, P426_01AC
    pl_CompareVarToValue PVAR_8001, 4
    pl_GoToIf 1, P426_01BF
    pl_GoTo P426_0570

P426_0186:
    pl_CompareVarToValue PVAR_8000, 1
    pl_GoToIf 1, P426_01D2
    pl_GoTo P426_0212

P426_0199:
    pl_CompareVarToValue PVAR_8000, 1
    pl_GoToIf 1, P426_0252
    pl_GoTo P426_0292

P426_01AC:
    pl_CompareVarToValue PVAR_8000, 1
    pl_GoToIf 1, P426_02D2
    pl_GoTo P426_0312

P426_01BF:
    pl_CompareVarToValue PVAR_8000, 1
    pl_GoToIf 1, P426_0352
    pl_GoTo P426_0392

P426_01D2:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_03F6
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_03ED
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_03E4
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_03DB
    pl_GoTo P426_03D2

P426_0212:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_0423
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_041A
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_0411
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_0408
    pl_GoTo P426_03FF

P426_0252:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_0450
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_0447
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_043E
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_0435
    pl_GoTo P426_042C

P426_0292:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_047D
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_0474
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_046B
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_0462
    pl_GoTo P426_0459

P426_02D2:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_04AA
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_04A1
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_0498
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_048F
    pl_GoTo P426_0486

P426_0312:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_04D7
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_04CE
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_04C5
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_04BC
    pl_GoTo P426_04B3

P426_0352:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_0504
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_04FB
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_04F2
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_04E9
    pl_GoTo P426_04E0

P426_0392:
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 4, P426_0531
    pl_CompareVarToValue PVAR_800C, 200
    pl_GoToIf 4, P426_0528
    pl_CompareVarToValue PVAR_800C, 150
    pl_GoToIf 4, P426_051F
    pl_CompareVarToValue PVAR_800C, 70
    pl_GoToIf 4, P426_0516
    pl_GoTo P426_050D

P426_03D2:
    pl_msg_talk 10
    pl_GoTo P426_05A1

P426_03DB:
    pl_msg_talk 11
    pl_GoTo P426_05A1

P426_03E4:
    pl_msg_talk 12
    pl_GoTo P426_05A1

P426_03ED:
    pl_msg_talk 13
    pl_GoTo P426_05A1

P426_03F6:
    pl_msg_talk 14
    pl_GoTo P426_053A

P426_03FF:
    pl_msg_talk 15
    pl_GoTo P426_05C0

P426_0408:
    pl_msg_talk 16
    pl_GoTo P426_05C0

P426_0411:
    pl_msg_talk 17
    pl_GoTo P426_05C0

P426_041A:
    pl_msg_talk 18
    pl_GoTo P426_05C0

P426_0423:
    pl_msg_talk 19
    pl_GoTo P426_0555

P426_042C:
    pl_msg_talk 20
    pl_GoTo P426_05A1

P426_0435:
    pl_msg_talk 21
    pl_GoTo P426_05A1

P426_043E:
    pl_msg_talk 22
    pl_GoTo P426_05A1

P426_0447:
    pl_msg_talk 23
    pl_GoTo P426_05A1

P426_0450:
    pl_msg_talk 24
    pl_GoTo P426_053A

P426_0459:
    pl_msg_talk 25
    pl_GoTo P426_05C0

P426_0462:
    pl_msg_talk 26
    pl_GoTo P426_05C0

P426_046B:
    pl_msg_talk 27
    pl_GoTo P426_05C0

P426_0474:
    pl_msg_talk 28
    pl_GoTo P426_05C0

P426_047D:
    pl_msg_talk 29
    pl_GoTo P426_0555

P426_0486:
    pl_msg_talk 30
    pl_GoTo P426_05A1

P426_048F:
    pl_msg_talk 31
    pl_GoTo P426_05A1

P426_0498:
    pl_msg_talk 32
    pl_GoTo P426_05A1

P426_04A1:
    pl_msg_talk 33
    pl_GoTo P426_05A1

P426_04AA:
    pl_msg_talk 34
    pl_GoTo P426_053A

P426_04B3:
    pl_msg_talk 35
    pl_GoTo P426_05C0

P426_04BC:
    pl_msg_talk 36
    pl_GoTo P426_05C0

P426_04C5:
    pl_msg_talk 37
    pl_GoTo P426_05C0

P426_04CE:
    pl_msg_talk 38
    pl_GoTo P426_05C0

P426_04D7:
    pl_msg_talk 39
    pl_GoTo P426_0555

P426_04E0:
    pl_msg_talk 40
    pl_GoTo P426_05A1

P426_04E9:
    pl_msg_talk 41
    pl_GoTo P426_05A1

P426_04F2:
    pl_msg_talk 42
    pl_GoTo P426_05A1

P426_04FB:
    pl_msg_talk 43
    pl_GoTo P426_05A1

P426_0504:
    pl_msg_talk 44
    pl_GoTo P426_053A

P426_050D:
    pl_msg_talk 45
    pl_GoTo P426_05C0

P426_0516:
    pl_msg_talk 46
    pl_GoTo P426_05C0

P426_051F:
    pl_msg_talk 47
    pl_GoTo P426_05C0

P426_0528:
    pl_msg_talk 48
    pl_GoTo P426_05C0

P426_0531:
    pl_msg_talk 49
    pl_GoTo P426_0555

P426_053A:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 69: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P426_05FE
    pl_GoTo P426_05A1

P426_0555:
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 69: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P426_062F
    pl_GoTo P426_05C0

P426_0570:
    pl_msg_talk 50
    PokePartyGetHappiness PVAR_800C, PVAR_8002
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 0, P426_05DF
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32770, 69: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P426_0660
    pl_GoTo P426_05DF

P426_05A1:
    pl_CloseMessage
    pl_WaitTime 20, PVAR_800C
    pl_Call P426_00E9
    pl_WaitTime 10, PVAR_800C
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P426_05C0:
    pl_CloseMessage
    pl_WaitTime 20, PVAR_800C
    pl_Call P426_00E9
    pl_WaitTime 10, PVAR_800C
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P426_05DF:
    pl_CloseMessage
    pl_WaitTime 20, PVAR_800C
    pl_Call P426_00E9
    pl_WaitTime 10, PVAR_800C
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P426_05FE:
    pl_CloseMessage
    pl_WaitTime 20, PVAR_800C
    pl_Call P426_00E9
    pl_WaitTime 10, PVAR_800C
    pl_msg_talk 5
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_msg_talk 8
    pl_WaitFanfare
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 69: not translated yet
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P426_062F:
    pl_CloseMessage
    pl_WaitTime 20, PVAR_800C
    pl_Call P426_00E9
    pl_WaitTime 10, PVAR_800C
    pl_msg_talk 6
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_msg_talk 8
    pl_WaitFanfare
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 69: not translated yet
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P426_0660:
    pl_CloseMessage
    pl_WaitTime 20, PVAR_800C
    pl_Call P426_00E9
    pl_WaitTime 10, PVAR_800C
    pl_msg_talk 7
    pl_PlayFanfare SEQ_ME_POKEGET  // Pearl SEQ_FANFA1
    pl_msg_talk 8
    pl_WaitFanfare
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32770, 69: not translated yet
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P426_0694:
    Move 71, 1  // LOCK_DIR
    Move 15, 1  // WALK_NORMAL_EAST
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P426_06A4:
    Move 71, 1  // LOCK_DIR
    Move 14, 1  // WALK_NORMAL_WEST
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P426_06B4:
    Move 71, 1  // LOCK_DIR
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P426_06C4:
    Move 71, 1  // LOCK_DIR
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

    .balign 4, 0
P426_06D4:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P426_06DC:
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P426_06E4:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P426_06EC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
