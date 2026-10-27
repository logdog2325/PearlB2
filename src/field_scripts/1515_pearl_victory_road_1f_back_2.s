// MAP_VICTORY_ROAD_1F_BACK_2: Pearl script file 262, text bank 234. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive; 83: Pearl 9705, 94: Pearl 10002
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P262_S1
    ScriptEntry P262_S2
    ScriptEntry P262_S3
    ScriptEntry P262_S4
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
    ScriptEntry PearlProxy_9705
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

P262_S4:
P262_0012:
    pl_CheckFlag PFLAG_00E6
    pl_GoToIf 0, P262_001F
    pl_End

P262_001F:
    pl_SetVarFromValue PVAR_4090, 0
    pl_End

P262_S1:
P262_0027:
    pl_LockAll
    pl_stub SetPlayerBike  // Pearl 0x0C8 RideBike 0: not translated yet
    pl_ApplyMovementF 28, P262_0140  // (the follower once it follows)
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 55
    pl_GoToIf 1, P262_008C
    pl_CompareVarToValue PVAR_8005, 56
    pl_GoToIf 1, P262_009C
    pl_CompareVarToValue PVAR_8005, 57
    pl_GoToIf 1, P262_00AC
    pl_CompareVarToValue PVAR_8005, 58
    pl_GoToIf 1, P262_00BC
    pl_CompareVarToValue PVAR_8005, 59
    pl_GoToIf 1, P262_00CC
    pl_CompareVarToValue PVAR_8005, 60
    pl_GoToIf 1, P262_00DC
    pl_End

P262_008C:
    pl_ApplyMovementF 28, P262_014C  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_00EC

P262_009C:
    pl_ApplyMovementF 28, P262_0158  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_00EC

P262_00AC:
    pl_ApplyMovementF 28, P262_0164  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_00EC

P262_00BC:
    pl_ApplyMovementF 28, P262_0170  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_00EC

P262_00CC:
    pl_ApplyMovementF 28, P262_0178  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_00EC

P262_00DC:
    pl_ApplyMovementF 28, P262_0184  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_00EC

P262_00EC:
    pl_BufferPlayerName 0
    pl_CheckFlag PFLAG_00DF
    pl_CallIf 0, P262_0134
    pl_CheckFlag PFLAG_00DF
    pl_CallIf 1, P262_0139
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_GONIN
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_WaitFanfare
    pl_SetFlag PFLAG_00DF
    pl_SetVarFromValue PVAR_4090, 1
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_403F, 610
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start_ally 28, PTRAINER_610, 0  // Pearl SetMovementType 28, 0x30 with partner trainer 610 (var 0x403F): follows and battles with you (in this zone only)
    pl_ReleaseAll
    pl_End

P262_0134:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_Return

P262_0139:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3
    pl_Return

P262_S2:
P262_0190:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P262_0274
    pl_ApplyMovementF 28, P262_02DC  // (the follower once it follows)
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4090, 0
    pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)
    pl_follow_hold 28, 14  // Pearl SetMovementType 28, 14: the follower stops to be moved by the script
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 55
    pl_GoToIf 1, P262_020D
    pl_CompareVarToValue PVAR_8005, 56
    pl_GoToIf 1, P262_021D
    pl_CompareVarToValue PVAR_8005, 57
    pl_GoToIf 1, P262_022D
    pl_CompareVarToValue PVAR_8005, 58
    pl_GoToIf 1, P262_023D
    pl_CompareVarToValue PVAR_8005, 59
    pl_GoToIf 1, P262_024D
    pl_CompareVarToValue PVAR_8005, 60
    pl_GoToIf 1, P262_025D
    pl_End

P262_020D:
    pl_ApplyMovementF 28, P262_0284  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_026D

P262_021D:
    pl_ApplyMovementF 28, P262_0294  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_026D

P262_022D:
    pl_ApplyMovementF 28, P262_02A4  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_026D

P262_023D:
    pl_ApplyMovementF 28, P262_02B4  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_026D

P262_024D:
    pl_ApplyMovementF 28, P262_02BC  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_026D

P262_025D:
    pl_ApplyMovementF 28, P262_02CC  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_026D

P262_026D:
    pl_ReleaseAll
    pl_End

P262_S3:
P262_02E4:
    pl_LockAll
    pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)
    pl_follow_hold 28, 14  // Pearl SetMovementType 28, 14: the follower stops to be moved by the script
    pl_ApplyMovement PL_PLAYER, P262_03B4
    pl_ApplyMovementF 28, P262_03E0  // (the follower once it follows)
    pl_WaitMovement
    pl_msg_sys 5
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 51
    pl_GoToIf 1, P262_0341
    pl_CompareVarToValue PVAR_8004, 52
    pl_GoToIf 1, P262_0359
    pl_CompareVarToValue PVAR_8004, 53
    pl_GoToIf 1, P262_0371
    pl_CompareVarToValue PVAR_8004, 54
    pl_GoToIf 1, P262_0389
    pl_End

P262_0341:
    pl_ApplyMovement PL_PLAYER, P262_03C0
    pl_ApplyMovementF 28, P262_03EC  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_03A1

P262_0359:
    pl_ApplyMovement PL_PLAYER, P262_03C0
    pl_ApplyMovementF 28, P262_0400  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_03A1

P262_0371:
    pl_ApplyMovement PL_PLAYER, P262_03C0
    pl_ApplyMovementF 28, P262_0414  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_03A1

P262_0389:
    pl_ApplyMovement PL_PLAYER, P262_03D0
    pl_ApplyMovementF 28, P262_0428  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P262_03A1

P262_03A1:
    pl_follow_leave
    pl_RemoveObject 28, PFLAG_0204
    pl_SetFlag PFLAG_00E6
    pl_SetVarFromValue PVAR_4090, 2
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P262_0140:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P262_014C:
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P262_0158:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P262_0164:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P262_0170:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P262_0178:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P262_0184:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P262_0274:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_0284:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_0294:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_02A4:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_02B4:
    Move 15, 2  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_02BC:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_02CC:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_02DC:
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P262_03B4:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P262_03C0:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P262_03D0:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P262_03E0:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P262_03EC:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 7  // WALK_NORMAL_NORTH
    Move 15, 4  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_0400:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 7  // WALK_NORMAL_NORTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_0414:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 7  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P262_0428:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 12, 7  // WALK_NORMAL_NORTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

PearlProxy_9705:                  // Pearl global script 9705 (run by this zone's events)
    VMCall T387_6_S6
    VMHalt

PearlProxy_10002:                  // Pearl global script 10002 (run by this zone's events)
    VMCall T375_3_S3
    VMHalt

// ---- Pearl global script 387:6 (a subroutine here)
T387_6_S6:
T387_6_0262:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40E4, 1
    pl_GoToIf 4, T387_6_0285
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12  // Pearl bank 378 line 40
    pl_GoTo T387_6_0290

T387_6_0285:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13  // Pearl bank 378 line 41
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T387_6_0290:
    pl_AddVar PVAR_40E4, 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

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
    pl_msg_talk 14  // Pearl bank 334 line 6
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_3_0297
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0288:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15  // Pearl bank 334 line 8
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_3_055B

T375_3_0297:
    FlagSet 2404  // GetSetStrength 1: Strength on (Black 2's flag 0x964, the push reads it)
    PokePartyHasMoveAny PVAR_800C, 70  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_BufferPartyMonNickname 0, PVAR_800C
    pl_msg_talk 16  // Pearl bank 334 line 10
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
    pl_CloseMessage
    pl_msg_talk 17  // Pearl bank 334 line 11
    pl_WaitButton
    pl_CloseMessage
    WorkSetConst PVAR_8004, 247  // GetCurrentMapID: Pearl map 247
// CreateJournalEvent 22, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)
    pl_GoTo T375_3_055B

T375_3_02D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 18  // Pearl bank 334 line 9
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
