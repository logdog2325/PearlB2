// MAP_IRON_ISLAND_B2F_ROOM_2: Pearl script file 321, text bank 258. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-9: Pearl's; no warp continuations; 10: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P321_S1
    ScriptEntry P321_S2
    ScriptEntry P321_S3
    ScriptEntry P321_S4
    ScriptEntry P321_S5
    ScriptEntry P321_S6
    ScriptEntry P321_S7
    ScriptEntry P321_S8
    ScriptEntry P321_S9
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P321_S1:
P321_0026:
// InitPersistedMapFeaturesForPlatformLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_CheckFlag PFLAG_00E5
    pl_GoToIf 0, P321_0035
    pl_End

P321_0035:
    pl_CompareVarToValue PVAR_4092, 2
    pl_GoToIf 1, P321_004A
    pl_SetVarFromValue PVAR_4092, 0
    pl_End

P321_004A:
    pl_SetObjectEventPos 0, 19, 41, 0, 9  // object 4
// SetObjectEventMovementType 4, 17: Black 2 has no command for it (the NPC keeps its own)
    pl_SetObjectEventPos 0, 19, 41, 3, 9  // SetObjectEventDir 4 (at the place SetObjectEventPos just gave)
    pl_End

P321_S2:
P321_0060:
// TriggerPlatformLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_End

P321_S3:
P321_0064:
    pl_LockAll
    pl_stub SetPlayerBike  // Pearl 0x0C8 RideBike 0: not translated yet
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 2
    pl_CallIf 1, P321_00D1
    pl_CompareVarToValue PVAR_8005, 3
    pl_CallIf 1, P321_00DD
    pl_BufferPlayerName 0
    pl_CheckFlag PFLAG_00E1
    pl_CallIf 0, P321_00E9
    pl_CheckFlag PFLAG_00E1
    pl_CallIf 1, P321_00EE
    pl_BufferPlayerName 0
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_GONIN
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 1
    pl_WaitFanfare
    pl_SetFlag PFLAG_00E1
    pl_SetVarFromValue PVAR_4092, 1
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_403F, 609
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start_ally 4, PTRAINER_609, 0  // Pearl SetMovementType 4, 0x30 with partner trainer 609 (var 0x403F): follows and battles with you (in this zone only)
    pl_ReleaseAll
    pl_End

P321_00D1:
    pl_ApplyMovementF 4, P321_0170  // (the follower once it follows)
    pl_WaitMovement
    pl_Return

P321_00DD:
    pl_ApplyMovementF 4, P321_0184  // (the follower once it follows)
    pl_WaitMovement
    pl_Return

P321_00E9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 0
    pl_Return

P321_00EE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 3
    pl_Return

P321_S4:
P321_00F3:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P321_0158
    pl_ApplyMovementF 4, P321_0160  // (the follower once it follows)
    pl_WaitMovement
    pl_msg_sys 4
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4092, 0
    pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)
    pl_follow_hold 4, 16  // Pearl SetMovementType 4, 16: the follower stops to be moved by the script
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 2
    pl_CallIf 1, P321_013E
    pl_CompareVarToValue PVAR_8005, 3
    pl_CallIf 1, P321_014A
    pl_ReleaseAll
    pl_End

P321_013E:
    pl_ApplyMovementF 4, P321_0190  // (the follower once it follows)
    pl_WaitMovement
    pl_Return

P321_014A:
    pl_ApplyMovementF 4, P321_01A0  // (the follower once it follows)
    pl_WaitMovement
    pl_Return

P321_S5:
P321_01A8:
    pl_End

P321_S9:
P321_01AA:
    pl_LockAll
    pl_follow_end  // ClearHasPartner: the partner stops following and stays here (its own NPC again)
    pl_follow_hold 4, 16  // Pearl SetMovementType 4, 16: the follower stops to be moved by the script
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 40
    pl_CallIf 1, P321_0291
    pl_CompareVarToValue PVAR_8005, 41
    pl_CallIf 1, P321_02A5
    pl_msg_sys 5
    pl_CloseMessage
    pl_ApplyMovement 5, P321_0380
    pl_WaitMovement
    pl_msg_sys 6
    pl_CloseMessage
    pl_ApplyMovement 6, P321_0388
    pl_WaitMovement
    pl_msg_sys 7
    pl_CloseMessage
    pl_ApplyMovementF 4, P321_0408  // (the follower once it follows)
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 8
    pl_CloseMessage
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_StartTagBattle PTRAINER_609, PTRAINER_835, PTRAINER_836  // StartTrainerBattle with the partner (SetHasPartner, var 0x403F)
    pl_follow_leave  // ClearHasPartner: the follower stays behind
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P321_0377
    pl_ApplyMovement 5, P321_0390
    pl_WaitMovement
    pl_msg_sys 9
    pl_CloseMessage
    pl_ApplyMovement 6, P321_0398
    pl_WaitMovement
    pl_msg_sys 10
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_RemoveObject 5, PFLAG_0205
    pl_RemoveObject 6, PFLAG_0205
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 40
    pl_CallIf 1, P321_02D1
    pl_CompareVarToValue PVAR_8005, 41
    pl_CallIf 1, P321_02E5
    pl_Call P321_02F9
// Pearl 0x2B6 4, 1: Pearl's map-object flag 18, nothing in Black 2
    pl_ReleaseAll
    pl_End

P321_0291:
    pl_ApplyMovementF 4, P321_03D0  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P321_0430
    pl_WaitMovement
    pl_Return

P321_02A5:
    pl_ApplyMovementF 4, P321_03E0  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P321_0448
    pl_WaitMovement
    pl_Return

P321_02D1:
    pl_ApplyMovementF 4, P321_0410  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P321_0420
    pl_WaitMovement
    pl_Return

P321_02E5:
    pl_ApplyMovementF 4, P321_0418  // (the follower once it follows)
    pl_ApplyMovement PL_PLAYER, P321_0428
    pl_WaitMovement
    pl_Return

P321_02F9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P321_031C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P321_0360
    pl_End

P321_031C:
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, P321_034D
    pl_msg_sys 12
    PokePartyAddEgg PL_TMP, 447, 0  // GiveEgg 447, 10
    pl_SetFlag PFLAG_0203
    pl_ClearFlag PFLAG_00E2
    pl_Call P321_036B
    pl_msg_sys 15
    pl_WaitButton
    pl_CloseMessage
    pl_Return

P321_034D:
    pl_SetFlag PFLAG_00E2
    pl_SetVarFromValue PVAR_4092, 2
    pl_msg_sys 13
    pl_WaitButton
    pl_CloseMessage
    pl_Return

P321_0360:
    pl_msg_sys 14
    pl_GoTo P321_02F9

P321_036B:
    pl_SetFlag PFLAG_00E5
    pl_SetVarFromValue PVAR_4092, 2
    pl_Return

P321_0377:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P321_S6:
P321_0460:
    pl_End

P321_S7:
P321_0462:
    pl_End

P321_S8:
P321_0464:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00E2
    pl_GoToIf 1, P321_0500
    pl_CompareVarToValue PVAR_4092, 2
    pl_GoToIf 1, P321_050F
    pl_CompareVarToValue PVAR_40E3, 4
    pl_GoToIf 4, P321_04E7
    pl_CompareVarToValue PVAR_40E3, 3
    pl_GoToIf 1, P321_04DC
    pl_CompareVarToValue PVAR_40E3, 2
    pl_GoToIf 1, P321_04D1
    pl_CompareVarToValue PVAR_40E3, 1
    pl_GoToIf 1, P321_04C6
    pl_BufferPlayerName 0
    pl_msg_talk 18
    pl_GoTo P321_04F2

P321_04C6:
    pl_msg_talk 19
    pl_GoTo P321_04F2

P321_04D1:
    pl_msg_talk 20
    pl_GoTo P321_04F2

P321_04DC:
    pl_msg_talk 21
    pl_GoTo P321_04F2

P321_04E7:
    pl_msg_talk 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P321_04F2:
    pl_AddVar PVAR_40E3, 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P321_0500:
    pl_Call P321_02F9
// Pearl 0x2B6 4, 1: Pearl's map-object flag 18, nothing in Black 2
    pl_ReleaseAll
    pl_End

P321_050F:
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P321_0158:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P321_0160:
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P321_0170:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P321_0184:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P321_0190:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P321_01A0:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P321_0380:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P321_0388:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P321_0390:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P321_0398:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P321_03D0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P321_03E0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P321_0408:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P321_0410:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P321_0418:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P321_0420:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P321_0428:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P321_0430:
    Move 63, 2  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    Move 61, 1  // DELAY_2
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P321_0448:
    Move 63, 2  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 63, 1  // DELAY_8
    Move 61, 1  // DELAY_2
    Move 14, 1  // WALK_NORMAL_WEST
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
