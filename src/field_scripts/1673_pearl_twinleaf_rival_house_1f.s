// MAP_TWINLEAF_RIVAL_HOUSE_1F: Pearl script file 981, text bank 501. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-11: Pearl's; 12: after a Warp; 13: PearlArrive; 40: after a black-out (Pearl 2020)
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P981_S1
    ScriptEntry P981_S2
    ScriptEntry P981_S3
    ScriptEntry P981_S4
    ScriptEntry P981_S5
    ScriptEntry P981_S6
    ScriptEntry P981_S7
    ScriptEntry P981_S8
    ScriptEntry P981_S9
    ScriptEntry P981_S10
    ScriptEntry P981_S11
    ScriptEntry W392_0508_S
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
    ScriptEntry PearlBlackoutHome
    ScriptEntriesEnd

P981_S1:
P981_002E:
    pl_CompareVarToValue PVAR_40A4, 3
    pl_CallIf 1, P981_0048
    pl_CheckFlag PFLAG_008F
    pl_CallIf 1, P981_005E
    pl_End

P981_0048:
    pl_SetObjectEventPos 0, 2, 4, 0, -1  // object 0
    pl_SetObjectEventPos 0, 2, 4, 0, -1  // SetObjectEventDir 0 (at the place SetObjectEventPos just gave)
// SetObjectEventMovementType 0, 14: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_Return

P981_005E:
    pl_SetFlag PFLAG_020F
    pl_Return

P981_S2:
P981_0064:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P981_00A4
    pl_ApplyMovement 0, P981_00B0
    pl_WaitMovement
    pl_SetFlag PFLAG_0087
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_sys 0
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 0, P981_00CC
    pl_WaitMovement
    pl_SetVarFromValue PVAR_40A4, 1
    pl_ReleaseAll
    pl_End

P981_S11:
P981_00E0:
    pl_LockAll
    pl_SetVarFromValue PVAR_410F, 2
    pl_CheckFlag PFLAG_015C
    pl_GoToIf 1, P981_014B
    pl_CheckFlag PFLAG_015D
    pl_GoToIf 0, P981_0110
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P981_014B

P981_0110:
    pl_ApplyMovement PL_PLAYER, P981_0164
    pl_ApplyMovement 0, P981_0170
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_GetNationalDex PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P981_014F
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P981_0158
    pl_WaitButton
    pl_CloseMessage

P981_014B:
    pl_ReleaseAll
    pl_End

P981_014F:
    pl_SetFlag PFLAG_015C
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 35
    pl_Return

P981_0158:
    pl_SetFlag PFLAG_015D
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36
    pl_Return

P981_S3:
P981_017C:
    pl_LockAll
    pl_WaitTime 30, PVAR_800C
    pl_ApplyMovement 0, P981_01D4
    pl_ApplyMovement PL_PLAYER, P981_01F8
    pl_WaitMovement
    pl_WaitTime 30, PVAR_800C
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 6
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    pl_BufferPlayerName 0
    pl_msg_sys 7
    pl_GiveRunningShoes
    pl_BufferPlayerName 0
    pl_msg_sys 8
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_msg_sys 9
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_40A4, 4
    pl_ReleaseAll
    pl_End

P981_S4:
P981_0214:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CompareVarToValue PVAR_40A4, 7
    pl_GoToIf 4, P981_06D4
    pl_CompareVarToValue PVAR_40A4, 6
    pl_GoToIf 1, P981_02A4
    pl_CheckFlag PFLAG_0090
    pl_GoToIf 1, P981_02B2
    pl_CompareVarToValue PVAR_40A4, 5
    pl_GoToIf 4, P981_06CA
    pl_CompareVarToValue PVAR_40A4, 4
    pl_GoToIf 4, P981_0653
    pl_CheckFlag PFLAG_00F8
    pl_GoToIf 1, P981_069C
    pl_CompareVarToValue PVAR_40A4, 2
    pl_GoToIf 4, P981_06AA
    pl_CheckFlag PFLAG_0087
    pl_GoToIf 1, P981_06BC
    pl_SetFlag PFLAG_0087
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_02A4:
    pl_BufferPlayerName 0
    pl_msg_talk 28
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_02B2:
    pl_Call P981_05CE
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 15
    pl_SetVarFromValue PVAR_8004, 433
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
// GiveJournal : nothing in Black 2 (Black 2 has no journal)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 16
    pl_GetPlayerDir PVAR_8007
    pl_CompareVarToValue PVAR_8007, 1
    pl_GoToIf 1, P981_02EC
    pl_GoTo P981_02FE

P981_02EC:
    pl_ApplyMovement 0, P981_06E0
    pl_WaitMovement
    pl_GoTo P981_0310

P981_02FE:
    pl_ApplyMovement 0, P981_06E8
    pl_WaitMovement
    pl_GoTo P981_0310

P981_0310:
    pl_msg_talk 17
    pl_FacePlayer
    pl_BufferPlayerName 0
    pl_msg_talk 18
    pl_CloseMessage
    pl_PlaySE SEQ_SE_OPEN1  // Pearl SEQ_SE_DP_DOOR_OPEN
    pl_ClearFlag PFLAG_020F
    pl_AddObject 1
    pl_WaitSE SEQ_SE_OPEN1  // Pearl SEQ_SE_DP_DOOR_OPEN
    pl_ApplyMovement 0, P981_06F8
    pl_ApplyMovement PL_PLAYER, P981_07A8
    pl_WaitMovement
    pl_ApplyMovement 1, P981_0740
    pl_WaitMovement
    pl_CompareVarToValue PVAR_8007, 0
    pl_CallIf 1, P981_03AB
    pl_BufferRivalName 1
    pl_msg_actor 19, 1
    pl_ApplyMovement 0, P981_0704
    pl_WaitMovement
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 20
    pl_BufferRivalName 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_actor 21, 1
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 22
    pl_CompareVarToValue PVAR_8007, 0
    pl_GoToIf 1, P981_03B7
    pl_CompareVarToValue PVAR_8007, 1
    pl_GoToIf 1, P981_03D1
    pl_CompareVarToValue PVAR_8007, 2
    pl_GoToIf 1, P981_03EB
    pl_CompareVarToValue PVAR_8007, 3
    pl_GoToIf 1, P981_0405
    pl_End

P981_03AB:
    pl_ApplyMovement PL_PLAYER, P981_07B0
    pl_WaitMovement
    pl_Return

P981_03B7:
    pl_ApplyMovement 0, P981_070C
    pl_ApplyMovement PL_PLAYER, P981_07B8
    pl_WaitMovement
    pl_GoTo P981_041F

P981_03D1:
    pl_ApplyMovement 0, P981_0714
    pl_ApplyMovement PL_PLAYER, P981_07C0
    pl_WaitMovement
    pl_GoTo P981_041F

P981_03EB:
    pl_ApplyMovement 0, P981_071C
    pl_ApplyMovement PL_PLAYER, P981_07C8
    pl_WaitMovement
    pl_GoTo P981_041F

P981_0405:
    pl_ApplyMovement 0, P981_0724
    pl_ApplyMovement PL_PLAYER, P981_07D0
    pl_WaitMovement
    pl_GoTo P981_041F

P981_041F:
    pl_msg_talk 23
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8007, 0
    pl_GoToIf 1, P981_045A
    pl_CompareVarToValue PVAR_8007, 1
    pl_GoToIf 1, P981_0474
    pl_CompareVarToValue PVAR_8007, 2
    pl_GoToIf 1, P981_048E
    pl_CompareVarToValue PVAR_8007, 3
    pl_GoToIf 1, P981_04A8
    pl_End

P981_045A:
    pl_ApplyMovement 1, P981_074C
    pl_ApplyMovement PL_PLAYER, P981_07D8
    pl_WaitMovement
    pl_GoTo P981_04C2

P981_0474:
    pl_ApplyMovement 1, P981_0754
    pl_ApplyMovement PL_PLAYER, P981_07E0
    pl_WaitMovement
    pl_GoTo P981_04C2

P981_048E:
    pl_ApplyMovement 1, P981_0760
    pl_ApplyMovement PL_PLAYER, P981_07EC
    pl_WaitMovement
    pl_GoTo P981_04C2

P981_04A8:
    pl_ApplyMovement 1, P981_076C
    pl_ApplyMovement PL_PLAYER, P981_07F8
    pl_WaitMovement
    pl_GoTo P981_04C2

P981_04C2:
    pl_BufferPlayerName 0
    pl_BufferRivalName 1
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P981_04E1
    pl_GoTo P981_04EC

P981_04E1:
    pl_msg_actor 24, 1
    pl_GoTo P981_04F7

P981_04EC:
    pl_msg_actor 25, 1
    pl_GoTo P981_04F7

P981_04F7:
    pl_SetVarFromValue PVAR_8004, 459
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_008F
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 27
    pl_BufferRivalName 1
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_actor 26, 1
    pl_CloseMessage
    pl_CompareVarToValue PVAR_8007, 0
    pl_GoToIf 1, P981_054C
    pl_CompareVarToValue PVAR_8007, 1
    pl_GoToIf 1, P981_0566
    pl_CompareVarToValue PVAR_8007, 2
    pl_GoToIf 1, P981_0588
    pl_CompareVarToValue PVAR_8007, 3
    pl_GoToIf 1, P981_05A2
    pl_End

P981_054C:
    pl_ApplyMovement 1, P981_0774
    pl_ApplyMovement PL_PLAYER, P981_0800
    pl_WaitMovement
    pl_GoTo P981_05BC

P981_0566:
    pl_ApplyMovement 1, P981_0780
    pl_ApplyMovement PL_PLAYER, P981_0808
    pl_ApplyMovement 0, P981_072C
    pl_WaitMovement
    pl_GoTo P981_05BC

P981_0588:
    pl_ApplyMovement 1, P981_078C
    pl_ApplyMovement 0, P981_0738
    pl_WaitMovement
    pl_GoTo P981_05BC

P981_05A2:
    pl_ApplyMovement 1, P981_079C
    pl_ApplyMovement PL_PLAYER, P981_081C
    pl_WaitMovement
    pl_GoTo P981_05BC

P981_05BC:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 1, PFLAG_020F
    pl_SetVarFromValue PVAR_40A4, 6
    pl_ReleaseAll
    pl_End

P981_05CE:
    pl_BufferPlayerName 0
    pl_GetTimeOfDay PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P981_063A
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, P981_063F
    pl_CompareVarToValue PVAR_800C, 2
    pl_CallIf 1, P981_0644
    pl_CompareVarToValue PVAR_800C, 3
    pl_CallIf 1, P981_0649
    pl_CompareVarToValue PVAR_800C, 4
    pl_CallIf 1, P981_064E
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_PlayFanfare SEQ_ME_ASA  // Pearl SEQ_ASA
    pl_WaitFanfare
    pl_HealParty
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_Return

P981_063A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 11
    pl_Return

P981_063F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12
    pl_Return

P981_0644:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12
    pl_Return

P981_0649:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 13
    pl_Return

P981_064E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 14
    pl_Return

P981_0653:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_069C:
    pl_BufferRivalName 0
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_06AA:
    pl_SetFlag PFLAG_00F8
    pl_BufferPlayerName 0
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_06BC:
    pl_BufferRivalName 0
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_06CA:
    pl_Call P981_05CE
    pl_ReleaseAll
    pl_End

P981_06D4:
    pl_Call P981_05CE
    pl_ReleaseAll
    pl_End

P981_S5:
P981_0824:
    pl_LockAll
    pl_GoTo P981_082E

P981_082E:
    pl_ApplyMovement PL_PLAYER, P981_085C
    pl_ApplyMovement 0, P981_0874
    pl_WaitMovement
    pl_GoTo P981_0848

P981_0848:
    pl_SetVarFromValue PVAR_40A4, 2
    pl_BufferPlayerName 0
    pl_msg_sys 4
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_S6:
P981_088C:
    pl_BufferRivalName 1
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_actor 26, 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_S7:
P981_08A2:
    pl_GetTimeOfDay PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P981_08E9
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P981_08FA
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P981_08FA
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P981_090B
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 1, P981_090B
    pl_End

P981_08E9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_08FA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 30
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_090B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 31
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_S8:
P981_091C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 32
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_S9:
P981_092D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 33
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P981_S10:
P981_093E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 34
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P981_00A4:
    Move 62, 1  // DELAY_4
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_00B0:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 63, 1  // DELAY_8
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_00CC:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 3  // WALK_NORMAL_WEST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_0164:
    Move 62, 1  // DELAY_4
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_0170:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P981_01D4:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 0, 1  // FACE_NORTH
    Move 63, 2  // DELAY_8
    Move 15, 3  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P981_01F8:
    Move 63, 4  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 63, 4  // DELAY_8
    Move 15, 3  // WALK_NORMAL_EAST
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P981_06E0:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_06E8:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_06F8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P981_0704:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_070C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_0714:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_071C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P981_0724:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P981_072C:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_0738:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_0740:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P981_074C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P981_0754:
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P981_0760:
    Move 15, 2  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_076C:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_0774:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_0780:
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_078C:
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_079C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_07A8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_07B0:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P981_07B8:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_07C0:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_07C8:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P981_07D0:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P981_07D8:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P981_07E0:
    Move 63, 2  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P981_07EC:
    Move 63, 2  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_07F8:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_0800:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_0808:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_081C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P981_085C:
    Move 63, 2  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P981_0874:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

// ---- continuation 12: after the Warp at 392:0508 (MAP_ROUTE_201)
W392_0508_S:
W392_0508_0514:
    pl_fade_in_black  // FadeScreen 6, 3, 1, 0x0
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

// ---- Pearl global script 205:45 (a subroutine here)
C205_45_0336:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_03B8
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_03AC
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_03BE
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_03B2
    VMReturn  // End: the sub-script ends

C205_45_03AC:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_Return

C205_45_03B2:
    pl_PlayFanfare SEQ_ME_WAZA  // Pearl SEQ_WAZA
    pl_Return

C205_45_03B8:
    pl_PlayFanfare SEQ_ME_KEYITEM  // Pearl SEQ_FANFA3
    pl_Return

C205_45_03BE:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA2
    pl_Return

C205_45_S45:
C205_45_09B7:
    pl_Call C205_45_09C1
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_45_09C1:
    pl_Call C205_45_0336
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 1, C205_45_09F4
    pl_CompareVarToValue PVAR_800C, 7
    pl_CallIf 5, C205_45_0A05
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 199 line 28
    pl_GoTo C205_45_0A2B

C205_45_0A05:
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A1D
    pl_BufferItemName 0, PVAR_8004
    pl_GoTo C205_45_0A22

C205_45_0A1D:
    pl_BufferItemName 0, PVAR_8004  // GetItemNamePlural

C205_45_0A22:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 25
    pl_GoTo C205_45_0A2B

C205_45_0A2B:
    pl_WaitFanfare
    WorkSetConst PVAR_800C, 0  // CheckItemIsPlate PVAR_8004
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_45_1330
    pl_BufferPlayerName 0
    pl_CompareVarToValue PVAR_8005, 1
    pl_GoToIf 2, C205_45_0A5B
    pl_BufferItemName 1, PVAR_8004
    pl_GoTo C205_45_0A60

C205_45_0A5B:
    pl_BufferItemName 1, PVAR_8004  // GetItemNamePlural

C205_45_0A60:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 7
    pl_GoToIf 1, C205_45_0AE7
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, C205_45_0AD6
    pl_CompareVarToValue PVAR_8008, 4
    pl_GoToIf 1, C205_45_0B2B
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, C205_45_0B1A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, C205_45_0B3C
    pl_CompareVarToValue PVAR_8008, 6
    pl_GoToIf 1, C205_45_0AF8
    pl_CompareVarToValue PVAR_8008, 5
    pl_GoToIf 1, C205_45_0B09
    pl_CompareVarToValue PVAR_8008, 3
    pl_GoToIf 1, C205_45_0B4D
    VMReturn  // End: the sub-script ends

C205_45_0AD6:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AE7:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0AF8:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B09:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B1A:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B2B:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B3C:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B4D:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    pl_GoTo C205_45_0B5E

C205_45_0B5E:
    pl_Return

C205_45_1330:
    pl_AddVar PVAR_4115, 1
    pl_CompareVarToValue PVAR_4115, 9
    pl_CallIf 4, C205_45_13AD
    pl_CompareVarToValue PVAR_4115, 1
    pl_CallIf 1, C205_45_13B5
    pl_CompareVarToValue PVAR_4115, 2
    pl_CallIf 1, C205_45_13BA
    pl_CompareVarToValue PVAR_4115, 3
    pl_CallIf 1, C205_45_13BF
    pl_CompareVarToValue PVAR_4115, 4
    pl_CallIf 1, C205_45_13C4
    pl_CompareVarToValue PVAR_4115, 5
    pl_CallIf 1, C205_45_13C9
    pl_CompareVarToValue PVAR_4115, 6
    pl_CallIf 1, C205_45_13CE
    pl_CompareVarToValue PVAR_4115, 7
    pl_CallIf 1, C205_45_13D3
    pl_CompareVarToValue PVAR_4115, 8
    pl_CallIf 1, C205_45_13D8
    pl_Return

C205_45_13AD:
    pl_SetVarFromValue PVAR_4115, 1
    pl_Return

C205_45_13B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 40  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 42  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 43  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 44  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 45  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 46  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 47  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:21 (a subroutine here)
C205_21_S21:
C205_21_0F2F:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, C205_21_11B4
    pl_ApplyMovement 0, C205_21_11BC
    pl_WaitMovement
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 48  // Pearl bank 199 line 40
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_CloseMessage
    pl_PlayFanfare SEQ_ME_ASA  // Pearl SEQ_ASA
    pl_WaitFanfare
    pl_HealParty
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_CheckFlag PFLAG_0090
    pl_CallIf 1, C205_21_0F95
    pl_CheckFlag PFLAG_0090
    pl_CallIf 0, C205_21_0F9A
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn  // End: the sub-script ends

C205_21_0F95:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 49  // Pearl bank 199 line 41
    pl_Return

C205_21_0F9A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 50  // Pearl bank 199 line 42
    pl_Return

    .balign 4, 0
C205_21_11B4:
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
C205_21_11BC:
    Move 3, 1  // FACE_EAST
    MoveEnd

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

PearlBlackoutHome:                // after a black-out at home: Pearl's common script 2020
    VMCall C205_21_S21
    VMHalt

    .balign 4, 0
