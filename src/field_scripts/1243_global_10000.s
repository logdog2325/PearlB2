// Global scripts 10000-10017 (a/0/5/6 entry 1243): Black 2's field moves, pokebw2 res/field/scripts/
// global_10000.s, with Script_17 (10016) added: Pearl's Defog from the party menu (b2tools/patches/
// pearl_defog.py --sources writes this file; the decomp's src/pearlb2/defog_itcm.c runs it). Text: a/0/0/3
// file 1236 (src/text/script/1236_field_moves.txt: Black 2's lines, then line 34, Pearl's "used Defog!").
// Script_18 (10017): the following Pokémon talked to (patches/followers.py), lines 35-43.
#include "asm/field_script.inc"
#include "text/script/global_10000.h"

    ScriptEntry Script_1
    ScriptEntry Script_2
    ScriptEntry Script_3
    ScriptEntry Script_4
    ScriptEntry Script_5
    ScriptEntry Script_6
    ScriptEntry Script_7
    ScriptEntry Script_8
    ScriptEntry Script_9
    ScriptEntry Script_10
    ScriptEntry Script_11
    ScriptEntry Script_12
    ScriptEntry Script_13
    ScriptEntry Script_14
    ScriptEntry Script_15
    ScriptEntry Script_16
    ScriptEntry Script_17
    ScriptEntry Script_18
    ScriptEntriesEnd
    WorkSetConst 0x8020, 0

L_0048:
    // "[f000]ć\u0001\u0000 can't be used if you have\nsomeone with you."
    SystemMsg Global10000_Text_CantUsedIfHave, 2
    LastKeyWait
    InfoMsgClose
    VMReturn

Movement_0054:
    Move 162, 1
    MoveEnd

L_005C:
    PlayerSetSpecialSequence 128
    ActorCmdExec 255, Movement_0054
    ActorCmdWait
    VMReturn

L_006C:
    PlayerSetSpecialSequence 8
    VMReturn

Script_1:
    ActorsPauseAll
    SEPlay SEQ_SE_MESSAGE
    FlagGet EVENT_FLAG_0x0964, 0x8010
    VMStackPush 0x8010
    VMStackPushConst 1
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_009D
    VMCall L_00ED
    VMJump L_00E7

L_009D:
    PokePartyHasMoveAny 0x8010, 70
    VMStackPush 0x8010
    VMStackPushConst 6
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_00C2
    VMCall L_00F9
    VMJump L_00E7

L_00C2:
    // "It's a big boulder, but a Pokémon\nmay be able to push it aside.[f000]븁\u0000\nWould you like to use Strength?"
    SystemMsg Global10000_Text_ItsBigBoulderBut, 2
    YesNoWin 0x8010
    InfoMsgClose
    VMStackPush 0x8010
    VMStackPushConst 0
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_00E7
    VMCall L_0105

L_00E7:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

L_00ED:
    // "Strength made it possible to move\nboulders around."
    SystemMsg Global10000_Text_StrengthMadePossibleMove, 2
    LastKeyWait
    InfoMsgClose
    VMReturn

L_00F9:
    // "It's a big boulder, but a Pokémon\nmay be able to push it aside."
    SystemMsg Global10000_Text_ItsBigBoulderBut_2, 2
    LastKeyWait
    InfoMsgClose
    VMReturn

L_0105:
    WorkSetConst 0x8021, 0
    FlagSet EVENT_FLAG_0x0964
    Cmd_01DD 1, 70, 0
    PokePartyHasMoveAny 0x8021, 70
    WordSetPartyPokeName 0, 0x8021
    // "[f000]Ă\u0001\u0000 used Strength![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedStrength, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8021
    VMCall L_006C
    // "[f000]Ă\u0001\u0000's Strength made it\npossible to move boulders around!"
    SystemMsg Global10000_Text_SStrengthMadePossible, 2
    LastKeyWait
    InfoMsgClose
    WorkSetConst 0x8021, 0
    VMReturn

Script_2:
    ActorsPauseAll
    FlagGet EVENT_FLAG_0x0964, 0x8010
    VMStackPush 0x8010
    VMStackPushConst 1
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0173
    VMCall L_00ED
    VMJump L_01A6

L_0173:
    FlagSet EVENT_FLAG_0x0964
    Cmd_01DD 1, 70, 0
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Strength![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedStrength, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C
    // "[f000]Ă\u0001\u0000's Strength made it\npossible to move boulders around!"
    SystemMsg Global10000_Text_SStrengthMadePossible, 2
    LastKeyWait
    InfoMsgClose

L_01A6:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_3:
    ActorsPauseAll
    SEPlay SEQ_SE_MESSAGE
    PokePartyHasMoveAny 0x8010, 57
    VMStackPush 0x8010
    VMStackPushConst 6
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_01D7
    VMCall L_0226
    VMJump L_0220

L_01D7:
    VMStackPushFlag EVENT_FLAG_0x0966
    VMStackPushConst 1
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_01FB
    WordSetMoveName 0, MOVE_SURF
    VMCall L_0048
    VMJump L_0220

L_01FB:
    // "The water is a deep blue...\nWould you like to surf on it?"
    SystemMsg Global10000_Text_WaterDeepBlueWould, 2
    YesNoWin 0x8010
    InfoMsgClose
    VMStackPush 0x8010
    VMStackPushConst 0
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0220
    VMCall L_0232

L_0220:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

L_0226:
    // "Surf can't be used if you have\nsomeone with you."
    SystemMsg Global10000_Text_SurfCantUsedIf, 2
    LastKeyWait
    InfoMsgClose
    VMReturn

L_0232:
    PokePartyHasMoveAny 0x8010, 57
    WorkGet 0x8008, 0x8010
    WordSetPartyPokeName 0, 0x8010
    // "[f000]Ă\u0001\u0000 used Surf![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedSurf, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8008
    PlayerSetSpecialSequence 1
    CallSurf
    Cmd_01DD 1, 57, 0
    VMReturn

Script_4:
    ActorsPauseAll
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Surf![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedSurf, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C
    CallSurf
    Cmd_01DD 1, 57, 0
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_5:
    ActorsPauseAll
    SEPlay SEQ_SE_MESSAGE
    PokePartyHasMoveAny 0x8010, 15
    VMStackPush 0x8010
    VMStackPushConst 6
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_02BF
    VMCall L_02F0
    VMJump L_02EA

L_02BF:
    // "This tree looks like it can be\ncut down! Would you like to cut it?"
    SystemMsg Global10000_Text_TreeLooksLikeCan, 2
    YesNoWin 0x8010
    VMStackPush 0x8010
    VMStackPushConst 0
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_02E8
    VMCall L_02FC
    VMJump L_02EA

L_02E8:
    InfoMsgClose

L_02EA:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

L_02F0:
    // "This tree looks like it can be\ncut down!"
    SystemMsg Global10000_Text_TreeLooksLikeCan_2, 2
    LastKeyWait
    InfoMsgClose
    VMReturn

L_02FC:
    PokePartyHasMoveAny 0x8010, 15
    WorkGet 0x8008, 0x8010
    WordSetPartyPokeName 0, 0x8010
    // "[f000]Ă\u0001\u0000 used Cut![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedCut, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8008
    VMCall L_006C
    CallCut
    Cmd_01DD 1, 15, 0
    VMSleep 3
    ActorDelete 0x8011
    SEPlay SEQ_SE_FLD_02
    VMSleep 1
    VMReturn

Script_6:
    ActorsPauseAll
    SEPlay SEQ_SE_MESSAGE
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Cut![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedCut, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C
    CallCut
    Cmd_01DD 1, 15, 0
    VMSleep 3
    WorkSetConst 0x8022, 0
    WorkSetConst 0x8023, 0
    PlayerGetActorInFront 0x8022, 0x8023
    VMStackPush 0x8023
    VMStackPushConst 1
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_039B
    ActorDelete 0x8022

L_039B:
    WorkSetConst 0x8023, 0
    WorkSetConst 0x8022, 0
    SEPlay SEQ_SE_FLD_02
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_7:
    ActorsPauseAll
    SEPlay SEQ_SE_MESSAGE
    PokePartyHasMoveAny 0x8010, 127
    VMStackPush 0x8010
    VMStackPushConst 6
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_03DC
    VMCall L_042B
    VMJump L_0425

L_03DC:
    VMStackPushFlag EVENT_FLAG_0x0966
    VMStackPushConst 1
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0400
    WordSetMoveName 0, MOVE_WATERFALL
    VMCall L_0048
    VMJump L_0425

L_0400:
    // "It's a large waterfall.\nWould you like to use Waterfall?"
    SystemMsg Global10000_Text_ItsLargeWaterfallWould, 2
    YesNoWin 0x8010
    InfoMsgClose
    VMStackPush 0x8010
    VMStackPushConst 0
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0425
    VMCall L_0437

L_0425:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

L_042B:
    // "A wall of water is crashing down with\na mighty roar."
    SystemMsg Global10000_Text_WallWaterCrashingDown, 2
    LastKeyWait
    InfoMsgClose
    VMReturn

L_0437:
    WorkSetConst 0x8024, 0
    PokePartyHasMoveAny 0x8024, 127
    WordSetPartyPokeName 0, 0x8024
    // "[f000]Ă\u0001\u0000 used Waterfall![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedWaterfall, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8024
    VMCall L_006C
    CallWaterfall 0x8024
    Cmd_01DD 1, 127, 0
    WorkSetConst 0x8024, 0
    VMReturn

Script_8:
    ActorsPauseAll
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Waterfall![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedWaterfall, 2
    InfoMsgClose
    PlayHMCutInEffect 0x8000
    CallWaterfall 0x8000
    Cmd_01DD 1, 127, 0
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_16:
    ActorsPauseAll
    CallWaterfall 0
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_9:
    ActorsPauseAll
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Flash![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedFlash, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_10:
    ActorsPauseAll
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Teleport![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedTeleport, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_11:
    ActorsPauseAll
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Dig![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedDig, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_12:
    ActorsPauseAll
    PokePartyHasMoveAny 0x8010, 291
    VMStackPush 0x8010
    VMStackPushConst 6
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_053F
    // "It's a deep part of the sea, but a\nPokémon may be able to dive down."
    SystemMsg Global10000_Text_ItsDeepPartSea, 2
    LastKeyWait
    InfoMsgClose
    VMJump L_0599

L_053F:
    VMStackPushFlag EVENT_FLAG_0x0966
    VMStackPushConst 1
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0563
    WordSetMoveName 0, MOVE_DIVE
    VMCall L_0048
    VMJump L_0599

L_0563:
    // "It's a deep part of the sea.\nWould you like to use Dive?"
    SystemMsg Global10000_Text_ItsDeepPartSea_2, 2
    YesNoWin 0x8010
    InfoMsgClose
    VMStackPush 0x8010
    VMStackPushConst 0
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0599
    PokePartyHasMoveAny 0x8010, 291
    WorkGet 0x8008, 0x8010
    WordSetPartyPokeName 0, 0x8010
    VMCall L_059F

L_0599:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

L_059F:
    // "[f000]Ă\u0001\u0000 used Dive![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedDive, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8008
    VMCall L_006C
    CallDiving 0
    Cmd_01DD 1, 291, 0
    VMReturn

Script_13:
    ActorsPauseAll
    WordSetPartyPokeName 0, 0x8000
    WorkGet 0x8008, 0x8000
    VMCall L_059F
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_14:
    ActorsPauseAll
    FlagGet EVENT_FLAG_0x00d7, 0x8010
    VMStackPush 0x8010
    VMStackPushConst 0
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0616
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Flash![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedFlash, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C

L_0616:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

Script_15:
    ActorsPauseAll
    FlagGet EVENT_FLAG_0x00d6, 0x8010
    VMStackPush 0x8010
    VMStackPushConst 0
    VMStackCmp CMP_EQ
    VMJumpIf CMP_STACK, L_0654
    WordSetPartyPokeName 0, 0x8000
    // "[f000]Ă\u0001\u0000 used Strength![f000]븁\u0000"
    SystemMsg Global10000_Text_UsedStrength, 2
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C

L_0654:
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

// PearlB2: Pearl's Defog (pokeplatinum FieldMoves_UseDefogFromMenu): Black 2's Flash steps with Pearl's line,
// then the mist fades out (FieldSetWeather 0, not at once) and stays away until the player leaves the zone
Script_17:
    ActorsPauseAll
    WordSetPartyPokeName 0, 0x8000
    SystemMsg 34, 2                   // "X used Defog!"
    InfoMsgClose
    VMCall L_005C
    PlayHMCutInEffect 0x8000
    VMCall L_006C
    FlagSet 0x52                    // (map-local: the clear sky stays through battles: PearlB2_ZoneWeather)
    FieldSetWeather 0, 0
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

// PearlB2: the following Pokémon talked to (include/follower.h; Pearl's Amity Square, script file 266): its cry
// and one of Pearl's 9 lines at random, naming the Pokémon in the party slot PVAR_FOLLOWER_SLOT keeps
Script_18:
    SEPlay SEQ_SE_MESSAGE
    ActorsPauseAll
    ActorSetEyeToEye
    WordSetPartyPokeName 0, 0x40f7       // PVAR_FOLLOWER_SLOT
    PokePartyGetSpecies 0x8020, 0x40f7
    Random 0x8021, 9
    WorkAdd 0x8021, 35                // Global10000_Text_PearlFollower0 ...
    PVPlay 0x8020, 0
    ParentActorMsg MSGFILE_SCRIPT, 0x8021, 0, 0
    PVWait
    LastKeyWait
    MsgWinCloseAll
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt
    .balign 4, 0
