// MAP_ROUTE_201: Pearl script file 392, text bank 415. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-12: Pearl's; no warp continuations; 13: PearlArrive; 79: Pearl 9700
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P392_S1
    ScriptEntry P392_S2
    ScriptEntry P392_S3
    ScriptEntry P392_S4
    ScriptEntry P392_S5
    ScriptEntry P392_S6
    ScriptEntry P392_S7
    ScriptEntry P392_S8
    ScriptEntry P392_S9
    ScriptEntry P392_S10
    ScriptEntry P392_S11
    ScriptEntry P392_S12
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
    ScriptEntry PearlProxy_9700
    ScriptEntriesEnd

P392_S1:
P392_0032:
    pl_CompareVarToValue PVAR_4086, 2
    pl_CallIf 1, P392_006F
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P392_005F
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P392_0067
    pl_End

P392_005F:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P392_0067:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P392_006F:
    pl_SetFlag PFLAG_01B3
    pl_Return

P392_S2:
P392_0075:
    pl_LockAll
    pl_ApplyMovementF 2, P392_0140  // (the follower once it follows)
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 110
    pl_GoToIf 1, P392_00D7
    pl_CompareVarToValue PVAR_8004, 111
    pl_GoToIf 1, P392_00E7
    pl_CompareVarToValue PVAR_8004, 112
    pl_GoToIf 1, P392_00F7
    pl_CompareVarToValue PVAR_8004, 113
    pl_GoToIf 1, P392_0107
    pl_CompareVarToValue PVAR_8004, 114
    pl_GoToIf 1, P392_0107
    pl_CompareVarToValue PVAR_8004, 115
    pl_GoToIf 1, P392_0107
    pl_End

P392_00D7:
    pl_ApplyMovementF 2, P392_014C  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P392_0117

P392_00E7:
    pl_ApplyMovementF 2, P392_015C  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P392_0117

P392_00F7:
    pl_ApplyMovementF 2, P392_016C  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P392_0117

P392_0107:
    pl_ApplyMovementF 2, P392_0174  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P392_0117

P392_0117:
    pl_BufferRivalName 0
    pl_msg_sys 0
    pl_WaitButton
    pl_CloseMessage
    FlagSet PL_STEP_FLAG  // SetStepFlag (Pearl sys flag 0x965)
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start 2  // Pearl SetMovementType 2, 0x30 (follow the player)
// SetObjectFlagIsPersistent 2, 1: not needed in Black 2
    pl_SetFlag PFLAG_0190
    pl_SetVarFromValue PVAR_4086, 1
    pl_ReleaseAll
    pl_End

P392_S3:
P392_0184:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P392_0240
    pl_ApplyMovementF 2, P392_0230  // (the follower once it follows)
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 110
    pl_GoToIf 1, P392_01F6
    pl_CompareVarToValue PVAR_8004, 111
    pl_GoToIf 1, P392_01F6
    pl_CompareVarToValue PVAR_8004, 112
    pl_GoToIf 1, P392_01F6
    pl_CompareVarToValue PVAR_8004, 113
    pl_GoToIf 1, P392_01F6
    pl_CompareVarToValue PVAR_8004, 114
    pl_GoToIf 1, P392_01F6
    pl_CompareVarToValue PVAR_8004, 115
    pl_GoToIf 1, P392_01F6
    pl_End

P392_01F6:
    pl_follow_hold_any  // ClearHasPartner: the follower stops while the scene moves it
    pl_follow_hold 2, 15  // Pearl SetMovementType 2, 15: the follower stops to be moved by the script
    pl_ApplyMovement PL_PLAYER, P392_0238
    pl_ApplyMovementF 2, P392_0224  // (the follower once it follows)
    pl_WaitMovement
    pl_GoTo P392_0216

P392_0216:
// SetHasPartner : nothing in Black 2 (Pearl's "partner walks along" flag 0x961: Black 2 pairs at SetMovementType 0x30)
    pl_follow_start 2  // Pearl SetMovementType 2, 0x30 (follow the player)
    pl_ReleaseAll
    pl_End

P392_S4:
P392_0248:
    pl_LockAll
    pl_BufferPlayerName 0
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P392_S5:
P392_02B4:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 853
    pl_GoToIf 1, P392_02E5
    pl_CompareVarToValue PVAR_8005, 854
    pl_GoToIf 1, P392_0319
    pl_CompareVarToValue PVAR_8005, 855
    pl_GoToIf 1, P392_034B
    pl_End

P392_02E5:
    pl_ApplyMovement PL_FOLLOWER, P392_0598
    pl_ApplyMovement 5, P392_0524
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement 5, P392_052C
    pl_ApplyMovement 6, P392_055C
    pl_WaitMovement
    pl_GoTo P392_0385

P392_0319:
    pl_ApplyMovement PL_FOLLOWER, P392_0598
    pl_ApplyMovement 5, P392_0524
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement 5, P392_0538
    pl_ApplyMovement 6, P392_055C
    pl_WaitMovement
    pl_GoTo P392_0385

P392_034B:
    pl_ApplyMovement PL_PLAYER, P392_05B8
    pl_ApplyMovement PL_FOLLOWER, P392_05A8
    pl_ApplyMovement 5, P392_0524
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement 5, P392_0538
    pl_ApplyMovement 6, P392_055C
    pl_WaitMovement
    pl_GoTo P392_0385

P392_0385:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_BufferPlayerStarterSpeciesName 1
    pl_BufferRivalStarterSpeciesName 2
    pl_msg_sys_gendered 20, 21  // Pearl line 4, naming the counterpart: Dawn (boy) / Lucas (girl)
    pl_CloseMessage
    pl_ApplyMovement 5, P392_054C
    pl_WaitMovement
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys_gendered 22, 23  // Pearl line 5, naming the counterpart: Dawn (boy) / Lucas (girl)
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8005, 853
    pl_GoToIf 1, P392_03DB
    pl_CompareVarToValue PVAR_8005, 854
    pl_GoToIf 1, P392_03F3
    pl_CompareVarToValue PVAR_8005, 855
    pl_GoToIf 1, P392_040B
    pl_CompareVarToValue PVAR_8005, 856
    pl_GoToIf 1, P392_040B
    pl_End

P392_03DB:
    pl_ApplyMovement 5, P392_0554
    pl_ApplyMovement 6, P392_0570
    pl_WaitMovement
    pl_GoTo P392_0423

P392_03F3:
    pl_ApplyMovement 5, P392_0554
    pl_ApplyMovement 6, P392_057C
    pl_WaitMovement
    pl_GoTo P392_0423

P392_040B:
    pl_ApplyMovement 5, P392_0554
    pl_ApplyMovement 6, P392_057C
    pl_WaitMovement
    pl_GoTo P392_0423

P392_0423:
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P392_043A
    pl_GoTo P392_045B

P392_043A:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 6
    pl_CloseMessage
    pl_ApplyMovement 6, P392_0568
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_msg_sys 7
    pl_GoTo P392_047C

P392_045B:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 8
    pl_CloseMessage
    pl_ApplyMovement 6, P392_0568
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_msg_sys 9
    pl_GoTo P392_047C

P392_047C:
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8005, 853
    pl_GoToIf 1, P392_04B4
    pl_CompareVarToValue PVAR_8005, 854
    pl_GoToIf 1, P392_04B4
    pl_CompareVarToValue PVAR_8005, 855
    pl_GoToIf 1, P392_04B4
    pl_CompareVarToValue PVAR_8005, 856
    pl_GoToIf 1, P392_04B4
    pl_End

P392_04B4:
    pl_ApplyMovement 6, P392_0590
    pl_WaitMovement
    pl_GoTo P392_04C4

P392_04C4:
    pl_RemoveObject 6, PFLAG_0197
    pl_RemoveObject 5, PFLAG_0196
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 10
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4086, 3
    pl_follow_end  // SetObjectFlagIsPersistent 254, 0: the follower stops following
    pl_follow_leave  // ClearHasPartner: the follower stays behind
    pl_SetFlag PFLAG_0190
    pl_SetFlag PFLAG_01B3
    pl_SetVarFromValue PVAR_4082, 4
    pl_SetFlag PFLAG_01B4
    pl_WaitTime 30, PVAR_800C
    pl_fade_out_black  // FadeScreen 6, 3, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 12  // the rest of this Pearl script runs there (continuation 12)
    pl_Warp 520, 2, 6, 0  // Pearl map 414 (MAP_TWINLEAF_RIVAL_HOUSE_1F)
    pl_ReleaseAll
    pl_End

P392_S9:
P392_05D0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P392_S11:
P392_05E3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P392_S12:
P392_05F6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0090
    pl_GoToIf 1, P392_061A
    pl_msg_talk 15
    pl_GoTo P392_0612

P392_0612:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P392_061A:
    pl_msg_talk 16
    pl_GoTo P392_0612

P392_S10:
P392_0623:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_006C
    pl_GoToIf 1, P392_0668
    pl_msg_talk 12
    pl_SetVarFromValue PVAR_8004, 17
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P392_0673
    pl_SetFlag PFLAG_006C
    VMCall C205_17_S17  // CallCommonScript 2016 (Pearl file 205 script 17)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P392_0668:
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P392_0673:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P392_S6:
P392_067D:
    pl_sign 17, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P392_S7:
P392_0694:
    pl_sign 18, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P392_S8:
P392_06AB:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 19, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P392_0140:
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P392_014C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P392_015C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P392_016C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P392_0174:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P392_0224:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P392_0230:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P392_0238:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P392_0240:
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P392_0524:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P392_052C:
    Move 63, 4  // DELAY_8
    Move 14, 2  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P392_0538:
    Move 63, 4  // DELAY_8
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P392_054C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P392_0554:
    Move 15, 8  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P392_055C:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P392_0568:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P392_0570:
    Move 63, 3  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P392_057C:
    Move 62, 1  // DELAY_4
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P392_0590:
    Move 19, 8  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P392_0598:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
P392_05A8:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P392_05B8:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 63, 1  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

PearlProxy_9700:                  // Pearl global script 9700 (run by this zone's events)
    VMCall T387_1_S1
    VMHalt

// ---- Pearl global script 205:17 (a subroutine here)
C205_17_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_17_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_17_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_17_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_17_03B2
    VMReturn  // End: the sub-script ends

C205_17_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_17_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_17_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_17_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

C205_17_S17:
C205_17_0978:
    pl_Call C205_17_0982
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_17_0982:
    pl_Call C205_17_0336
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, C205_17_09F4
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 5, C205_17_0A05
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 24  // Pearl bank 199 line 30
    pl_WaitButton
    pl_Return

C205_17_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 25  // Pearl bank 199 line 28
    pl_GoTo C205_17_0A2B

C205_17_0A05:
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_17_0A1D
    pl_BufferItemName 0, PVAR_8004
    pl_GoTo C205_17_0A22

C205_17_0A1D:
    pl_BufferItemName 0, PVAR_8004  // GetItemNamePlural

C205_17_0A22:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 26  // Pearl bank 199 line 25
    pl_GoTo C205_17_0A2B

C205_17_0A2B:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_17_1330
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_17_0A5B
    pl_BufferItemName 1, PVAR_8004
    pl_GoTo C205_17_0A60

C205_17_0A5B:
    pl_BufferItemName 1, PVAR_8004  // GetItemNamePlural

C205_17_0A60:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_17_0AE7
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_17_0AD6
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_17_0B2B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_17_0B1A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_17_0B3C
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_17_0AF8
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_17_0B09
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_17_0B4D
    VMReturn  // End: the sub-script ends

C205_17_0AD6:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0AE7:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0AF8:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B09:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B1A:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B2B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B3C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B4D:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_17_0B5E

C205_17_0B5E:
    pl_Return

C205_17_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_17_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_17_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_17_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_17_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_17_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_17_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_17_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_17_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_17_13D8
    pl_Return

C205_17_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_17_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 27  // Pearl bank 199 line 110
    pl_Return

C205_17_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 28  // Pearl bank 199 line 111
    pl_Return

C205_17_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 199 line 112
    pl_Return

C205_17_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 30  // Pearl bank 199 line 113
    pl_Return

C205_17_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 31  // Pearl bank 199 line 114
    pl_Return

C205_17_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 32  // Pearl bank 199 line 115
    pl_Return

C205_17_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 116
    pl_Return

C205_17_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 34  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:18 (a subroutine here)
C205_18_S18:
C205_18_0B60:
    pl_Call C205_18_0B6A
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_18_0B6A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35  // Pearl bank 199 line 27
    pl_WaitButton
    pl_Return

// ---- Pearl global script 387:1 (a subroutine here)
T387_1_S1:
T387_1_001A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    FlagGet PL_STEP_FLAG, PVAR_800C  // CheckStepFlag (Pearl sys flag 0x965)
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, T387_1_0084
    pl_CompareVarToValue PVAR_40CA, 5
    pl_GoToIf 4, T387_1_0092
    pl_CompareVarToValue PVAR_40CA, 4
    pl_GoToIf 1, T387_1_00A0
    pl_CompareVarToValue PVAR_40CA, 3
    pl_GoToIf 1, T387_1_00B0
    pl_CompareVarToValue PVAR_40CA, 2
    pl_GoToIf 1, T387_1_00C0
    pl_CompareVarToValue PVAR_40CA, 1
    pl_GoToIf 1, T387_1_00D0
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 36  // Pearl bank 378 line 1
    pl_WaitButton
    pl_GoTo T387_1_00E0

T387_1_0084:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 37  // Pearl bank 378 line 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T387_1_0092:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 38  // Pearl bank 378 line 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

T387_1_00A0:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 39  // Pearl bank 378 line 5
    pl_WaitButton
    pl_GoTo T387_1_00E0

T387_1_00B0:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 40  // Pearl bank 378 line 4
    pl_WaitButton
    pl_GoTo T387_1_00E0

T387_1_00C0:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 41  // Pearl bank 378 line 3
    pl_WaitButton
    pl_GoTo T387_1_00E0

T387_1_00D0:
    pl_BufferRivalName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 42  // Pearl bank 378 line 2
    pl_WaitButton
    pl_GoTo T387_1_00E0

T387_1_00E0:
    pl_AddVar PVAR_40CA, 1
    pl_CloseMessage
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
