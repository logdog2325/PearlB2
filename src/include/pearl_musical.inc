// The Pokémon Musical at Hearthome's Contest Hall counters (2026-10-25, DECISIONS "Contests -> Black 2's Pokémon
// Musical"). Pearl's Super Contests can't run on Black 2, so the three receptionists of the Contest Hall lobby send the
// player to Black 2's own Musical, as HoennB2 does at Hoenn's Contest Halls (its src/field_scripts/common/musical.inc
// and patches/musical.py, the model for this file).
//
// Black 2's flow is Nimbasa's solo reception, global script 10450 (the decomp's data/field_scripts/1268.s Script_1,
// text 442): Cmd_0167 0 (overlays 210 + 211 and the Musical's work), yes/no, MusicalCmd_0165 11 (how many party Pokémon
// can perform: anything but an Egg), Cmd_016A (the Musical's party screen), the show menu (MusicalCmd_0165 5 keeps the
// show in the Musical save), "Great! Please walk this way!", a walk through Nimbasa's door and a fade, then
// MusicalCmd_0163 slot, 0: the Musical event (ov012 musical_event.c), which ends this script. The event goes to zone 78
// (the backstage: Black 2's zone, kept by allocate_sinnoh; its scripts src/field_scripts/0156_musical_backstage.s), the
// dressing room, the stage, the photo, the audience's comments, and back. Here: the same commands, no walk (Nimbasa's
// movements need its room), and FieldSetNextZoneHere just before the show: the decomp's PearlB2_MusicalReturn
// (src/pearlb2/musical_itcm.c, b2tools/patches/musical.py) brings the player back to this spot, facing the counter
// (Black 2 goes to zone 77, Nimbasa's theatre lobby, which is Celestic's Pokémon Center B1F here), and the event's own
// heap is 64 KB, which a Sinnoh room's field leaves free (Black 2's 264 KB is for a downloaded fifth show; this counter
// offers Black 2's four).
//
// The Prop Case (Black 2's key item 578) is handed over on the first visit, as Nimbasa's theatre owner does (Black 2
// 0154.s: Std_ObtainItem, global 2805). The Props are the Musical save's: Black 2 gives 15 to every new game. More
// Props: after each show some of the audience become fans with a gift (the Musical save's 10 fan records); in Nimbasa
// they wait in the lobby, here the receptionist hands their Props over (Black 2's 10466 "Received the ...!" +
// MusicalCmd_0169, as 1268.s L_0CF1).
//
// Text (b2tools/pearl_story.py, data/pearl_musical.json): the greeting is the row's own line (Pearl's receptionist,
// data/pearl_closed_facilities.json "musical": true), the Musical's lines follow from line \first on, in the order of
// MUSL_* below (pearl_story checks the JSON's ids against these). Works 0x8058-0x805C: script-local, never a Pearl var,
// kept across RTCallGlobal (0x8020-0x805E).
#ifndef PEARL_MUSICAL_INC
#define PEARL_MUSICAL_INC

#define MUS_W 0x8058
#define MUS_OK 0x8059
#define MUS_SLOT 0x805A
#define MUS_SHOW 0x805B
#define MUS_FAN 0x805C

#define ITEM_PROP_CASE_B2 578

#define MUSL_ABOUT 0            // Black 2 442:61 "The Pokémon Musical is a show where..."
#define MUSL_CASE 1             // Black 2 87:1 (its last page) "...To get you started, here's a Prop Case!"
#define MUSL_CASE2 2            // Black 2 87:2 (its first page) "This Prop Case lets you store Props..."
#define MUSL_FANS 3             // the project's: "Oh! Fans from your last show left you some presents!"
#define MUSL_ASK 4              // Black 2 442:54 "Participate in the musical?"
#define MUSL_NONE 5             // Black 2 442:44 "I'm sorry, but you don't have an eligible Pokémon..."
#define MUSL_CHOOSE 6           // Black 2 442:4 "Please choose the Pokémon that will participate."
#define MUSL_WHICH 7            // Black 2 442:3 "Which show would you like to participate in?"
#define MUSL_SHOW1 8            // Black 2 442:29-32, the four shows
#define MUSL_SHOW2 9
#define MUSL_SHOW3 10
#define MUSL_SHOW4 11
#define MUSL_CANCEL 12          // Black 2 442:34
#define MUSL_GO 13              // Black 2 442:1 "Great! Please walk this way!"
#define MUSL_BYE 14             // Black 2 442:2 "Please visit us again."
#define MUSL_COUNT 15

// A receptionist's whole talk: greeting = the row's Pearl line, first = the zone's first Musical line
    .macro pl_musical_reception greeting, first
    pl_PlaySE SEQ_SE_MESSAGE
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk \greeting
    ItemCheckAmount ITEM_PROP_CASE_B2, 1, MUS_W
    WorkCmpConst MUS_W, 1
    VMJumpIf CMP_EQ, .Lmus_have\@
    pl_msg_talk (\first) + MUSL_ABOUT
    pl_msg_talk (\first) + MUSL_CASE
    pl_CloseMessage
    VMStackPush 0x8000                      // Black 2's Std_ObtainItem (global 2805): the key-item jingle,
    VMStackPush 0x8001                      // "<player> obtained a Prop Case!", the Key Items pocket
    WorkSetConst 0x8000, ITEM_PROP_CASE_B2
    WorkSetConst 0x8001, 1
    RTCallGlobal 2805
    VMStackPop 0x8001
    VMStackPop 0x8000
    pl_msg_talk (\first) + MUSL_CASE2
.Lmus_have\@:
    // the fans' Props (1268.s L_0CF1: record n is a fan when MusicalCmd_0166 n, 0 != 0; kind 3 = 1: holds a Prop,
    // kind 4 = which; 10466 shows "Received the <Prop>!" and adds it (0x8009 = 0: Black 2's fans' value); 0169 clears)
    WorkSetConst MUS_FAN, 0
    WorkSetConst MUS_OK, 0
.Lmus_fan\@:
    WorkSetConst MUS_W, 0
    MusicalCmd_0166 MUS_FAN, 0, MUS_W
    WorkCmpConst MUS_W, 0
    VMJumpIf CMP_EQ, .Lmus_fan_next\@
    WorkSetConst MUS_W, 0
    MusicalCmd_0166 MUS_FAN, 3, MUS_W
    WorkCmpConst MUS_W, 1
    VMJumpIf CMP_NE, .Lmus_fan_next\@
    WorkCmpConst MUS_OK, 0
    VMJumpIf CMP_NE, .Lmus_fan_give\@
    pl_msg_talk (\first) + MUSL_FANS
    WorkSetConst MUS_OK, 1
.Lmus_fan_give\@:
    pl_CloseMessage                         // no balloon open at 10466's info window
    MusicalCmd_0166 MUS_FAN, 4, MUS_W
    VMStackPush 0x8008
    VMStackPush 0x8009
    WorkSet 0x8008, MUS_W
    WorkSetConst 0x8009, 0
    RTCallGlobal 10466
    VMStackPop 0x8009
    VMStackPop 0x8008
    MusicalCmd_0169 MUS_FAN
.Lmus_fan_next\@:
    WorkAdd MUS_FAN, 1
    WorkCmpConst MUS_FAN, 10
    VMJumpIf CMP_LT, .Lmus_fan\@
    pl_msg_talk (\first) + MUSL_ASK
    YesNoWin MUS_W                          // 0 yes, 1 no
    WorkCmpConst MUS_W, 0
    VMJumpIf CMP_NE, .Lmus_bye\@
    Cmd_0167 0, 0, 0, 0                     // overlays 210 + 211 and the Musical's work (freed by Cmd_0167 1 or the show)
    WorkSetConst MUS_W, 0
    MusicalCmd_0165 11, 0, MUS_W
    WorkCmpConst MUS_W, 0
    VMJumpIf CMP_NE, .Lmus_some\@
    pl_msg_talk (\first) + MUSL_NONE
    VMJump .Lmus_unload\@
.Lmus_some\@:
    pl_msg_talk (\first) + MUSL_CHOOSE
    pl_CloseMessage
    WorkSetConst MUS_OK, 0
    WorkSetConst MUS_SLOT, 0
    Cmd_016A MUS_OK, MUS_SLOT               // MUS_OK != 0: chosen (party slot in MUS_SLOT); 0: backed out
    WorkCmpConst MUS_OK, 0
    VMJumpIf CMP_EQ, .Lmus_unload\@
    pl_msg_talk (\first) + MUSL_WHICH
    ListMenu_AnchorTopRight 31, 1, 0, 1, MUS_SHOW
    ListMenuAdd (\first) + MUSL_SHOW1, 65535, 0
    ListMenuAdd (\first) + MUSL_SHOW2, 65535, 1
    ListMenuAdd (\first) + MUSL_SHOW3, 65535, 2
    ListMenuAdd (\first) + MUSL_SHOW4, 65535, 3
    ListMenuAdd (\first) + MUSL_CANCEL, 65535, 4
    ListMenuShow
    pl_CloseMessage                         // (the menu's window erased the balloon's right part: the next line
                                            // gets a new balloon, as Black 2's own show menu, 1268.s Script_4)
    WorkCmpConst MUS_SHOW, 4                // Cancel
    VMJumpIf CMP_EQ, .Lmus_unload\@
    WorkCmpConst MUS_SHOW, 65534            // B
    VMJumpIf CMP_EQ, .Lmus_unload\@
    MusicalCmd_0165 5, MUS_SHOW, 0          // the show (0-3: Black 2's own four; never a downloaded fifth)
    pl_msg_talk (\first) + MUSL_GO
    pl_CloseMessage
    FieldSetNextZoneHere                    // PearlB2_MusicalReturn: the show ends on this spot, facing the counter
    SEPlay SEQ_SE_KAIDAN
    FadeOutBlackQ
    SEWait
    FadeWait
    MusicalCmd_0163 MUS_SLOT, 0             // Black 2's Musical (ends this script)
.Lmus_unload\@:
    Cmd_0167 1, 0, 0, 0
.Lmus_bye\@:
    pl_msg_talk (\first) + MUSL_BYE
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    .endm

#endif
