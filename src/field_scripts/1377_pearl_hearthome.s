// MAP_HEARTHOME: Pearl script file 90, text bank 98. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-33: Pearl's; 34: after a Warp; 35: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P90_S1
    ScriptEntry P90_S2
    ScriptEntry P90_S3
    ScriptEntry P90_S4
    ScriptEntry P90_S5
    ScriptEntry P90_S6
    ScriptEntry P90_S7
    ScriptEntry P90_S8
    ScriptEntry P90_S9
    ScriptEntry P90_S10
    ScriptEntry P90_S11
    ScriptEntry P90_S12
    ScriptEntry P90_S13
    ScriptEntry P90_S14
    ScriptEntry P90_S15
    ScriptEntry P90_S16
    ScriptEntry P90_S17
    ScriptEntry P90_S18
    ScriptEntry P90_S19
    ScriptEntry P90_S20
    ScriptEntry P90_S21
    ScriptEntry P90_S22
    ScriptEntry P90_S23
    ScriptEntry P90_S24
    ScriptEntry P90_S25
    ScriptEntry P90_S26
    ScriptEntry P90_S27
    ScriptEntry P90_S28
    ScriptEntry P90_S29
    ScriptEntry P90_S30
    ScriptEntry P90_S31
    ScriptEntry P90_S32
    ScriptEntry P90_S33
    ScriptEntry W230_0421_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P90_S1:
P90_0086:
    pl_End

P90_S2:
P90_0088:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetObjectEventPosLater 0, 23, PVAR_8004, 7, 726, 0  // SetObjectEventPos 23 (the live actor; and where AddObject puts it)
    pl_ClearFlag PFLAG_0225
    pl_AddObjectAt 23, 0, 0  // at its SetObjectEventPos
// LockObject 23: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_ApplyMovement 23, P90_0150
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 4
    pl_CloseMessage
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P90_00EF
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P90_00FD
    pl_GoTo P90_00E1

P90_00E1:
    pl_StartTrainerBattle PTRAINER_470, 0
    pl_GoTo P90_010B

P90_00EF:
    pl_StartTrainerBattle PTRAINER_471, 0
    pl_GoTo P90_010B

P90_00FD:
    pl_StartTrainerBattle PTRAINER_472, 0
    pl_GoTo P90_010B

P90_010B:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0145
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 5
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 23, P90_0160
    pl_WaitMovement
    pl_RemoveObject 23, PFLAG_0225
    pl_SetVarFromValue PVAR_407B, 2
    pl_ReleaseAll
    pl_End

P90_0145:
    pl_SetFlag PFLAG_0225
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P90_S33:
P90_016C:
    pl_LockAll
    pl_SetObjectEventPosLater 0, 23, 463, 2, 726, 0  // SetObjectEventPos 23 (the live actor; and where AddObject puts it)
    pl_ClearFlag PFLAG_0225
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 724
    pl_CallIf 1, P90_02B1
    pl_CompareVarToValue PVAR_8005, 725
    pl_CallIf 1, P90_02D9
    pl_CompareVarToValue PVAR_8005, 726
    pl_CallIf 1, P90_0301
    pl_CompareVarToValue PVAR_8005, 727
    pl_CallIf 1, P90_0321
    pl_CompareVarToValue PVAR_8005, 728
    pl_CallIf 1, P90_0349
    pl_CompareVarToValue PVAR_8005, 729
    pl_CallIf 1, P90_0371
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 4
    pl_CloseMessage
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P90_0211
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P90_021F
    pl_GoTo P90_0203

P90_0203:
    pl_StartTrainerBattle PTRAINER_470, 0
    pl_GoTo P90_022D

P90_0211:
    pl_StartTrainerBattle PTRAINER_471, 0
    pl_GoTo P90_022D

P90_021F:
    pl_StartTrainerBattle PTRAINER_472, 0
    pl_GoTo P90_022D

P90_022D:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0145
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 5
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 724
    pl_CallIf 1, P90_0399
    pl_CompareVarToValue PVAR_8005, 725
    pl_CallIf 1, P90_03AD
    pl_CompareVarToValue PVAR_8005, 726
    pl_CallIf 1, P90_03C1
    pl_CompareVarToValue PVAR_8005, 727
    pl_CallIf 1, P90_03CD
    pl_CompareVarToValue PVAR_8005, 728
    pl_CallIf 1, P90_03E1
    pl_CompareVarToValue PVAR_8005, 729
    pl_CallIf 1, P90_03F5
    pl_RemoveObject 23, PFLAG_0225
    pl_SetVarFromValue PVAR_407B, 2
    pl_ReleaseAll
    pl_End

P90_02B1:
// SetObjectEventMovementType 23, 14: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_ApplyMovement 23, .Lface2b7  // SetObjectEventDir 23: the live actor turns
    pl_WaitMovement
    VMJump .Lface2b7_end
    .balign 4, 0
.Lface2b7:
        Move 0, 1
        MoveEnd
.Lface2b7_end:
    pl_AddObjectAt 23, 0, 0  // at its SetObjectEventPos
// LockObject 23: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 23, P90_0448
    pl_ApplyMovement PL_PLAYER, P90_040C
    pl_WaitMovement
    pl_Return

P90_02D9:
// SetObjectEventMovementType 23, 14: Black 2 has no command for it (the NPC keeps its own, the same)
    pl_ApplyMovement 23, .Lface2df  // SetObjectEventDir 23: the live actor turns
    pl_WaitMovement
    VMJump .Lface2df_end
    .balign 4, 0
.Lface2df:
        Move 0, 1
        MoveEnd
.Lface2df_end:
    pl_AddObjectAt 23, 0, 0  // at its SetObjectEventPos
// LockObject 23: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 23, P90_045C
    pl_ApplyMovement PL_PLAYER, P90_040C
    pl_WaitMovement
    pl_Return

P90_0301:
// SetObjectEventMovementType 23, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_ApplyMovement 23, .Lface307  // SetObjectEventDir 23: the live actor turns
    pl_WaitMovement
    VMJump .Lface307_end
    .balign 4, 0
.Lface307:
        Move 2, 1
        MoveEnd
.Lface307_end:
    pl_AddObjectAt 23, 0, 0  // at its SetObjectEventPos
// LockObject 23: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 23, P90_0470
    pl_WaitMovement
    pl_Return

P90_0321:
// SetObjectEventMovementType 23, 15: Black 2 has no command for it (the NPC keeps its own)
    pl_ApplyMovement 23, .Lface327  // SetObjectEventDir 23: the live actor turns
    pl_WaitMovement
    VMJump .Lface327_end
    .balign 4, 0
.Lface327:
        Move 1, 1
        MoveEnd
.Lface327_end:
    pl_AddObjectAt 23, 0, 0  // at its SetObjectEventPos
// LockObject 23: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 23, P90_0480
    pl_ApplyMovement PL_PLAYER, P90_0418
    pl_WaitMovement
    pl_Return

P90_0349:
// SetObjectEventMovementType 23, 15: Black 2 has no command for it (the NPC keeps its own)
    pl_ApplyMovement 23, .Lface34f  // SetObjectEventDir 23: the live actor turns
    pl_WaitMovement
    VMJump .Lface34f_end
    .balign 4, 0
.Lface34f:
        Move 1, 1
        MoveEnd
.Lface34f_end:
    pl_AddObjectAt 23, 0, 0  // at its SetObjectEventPos
// LockObject 23: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 23, P90_0494
    pl_ApplyMovement PL_PLAYER, P90_0418
    pl_WaitMovement
    pl_Return

P90_0371:
// SetObjectEventMovementType 23, 15: Black 2 has no command for it (the NPC keeps its own)
    pl_ApplyMovement 23, .Lface377  // SetObjectEventDir 23: the live actor turns
    pl_WaitMovement
    VMJump .Lface377_end
    .balign 4, 0
.Lface377:
        Move 1, 1
        MoveEnd
.Lface377_end:
    pl_AddObjectAt 23, 0, 0  // at its SetObjectEventPos
// LockObject 23: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    pl_ApplyMovement 23, P90_04A8
    pl_ApplyMovement PL_PLAYER, P90_0418
    pl_WaitMovement
    pl_Return

P90_0399:
    pl_ApplyMovement 23, P90_04BC
    pl_ApplyMovement PL_PLAYER, P90_0424
    pl_WaitMovement
    pl_Return

P90_03AD:
    pl_ApplyMovement 23, P90_04C4
    pl_ApplyMovement PL_PLAYER, P90_0424
    pl_WaitMovement
    pl_Return

P90_03C1:
    pl_ApplyMovement 23, P90_04CC
    pl_WaitMovement
    pl_Return

P90_03CD:
    pl_ApplyMovement 23, P90_04D4
    pl_ApplyMovement PL_PLAYER, P90_0430
    pl_WaitMovement
    pl_Return

P90_03E1:
    pl_ApplyMovement 23, P90_04DC
    pl_ApplyMovement PL_PLAYER, P90_0430
    pl_WaitMovement
    pl_Return

P90_03F5:
    pl_ApplyMovement 23, P90_04E4
    pl_ApplyMovement PL_PLAYER, P90_0430
    pl_WaitMovement
    pl_Return

P90_S3:
P90_04F0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S4:
P90_0503:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S5:
P90_0516:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00FB
    pl_GoToIf 1, P90_0578
    pl_msg_talk 26
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_054C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P90_0583
    pl_End

P90_054C:
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, P90_058E
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_msg_talk 27
    pl_WaitFanfare
    PokePartyAddEgg PL_TMP, 440, 0  // GiveEgg 440, 9
    pl_SetFlag PFLAG_00FB
    pl_GoTo P90_0578

P90_0578:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 28
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0583:
    pl_msg_talk 30
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_058E:
    pl_msg_talk 29
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S6:
P90_0599:
    pl_LockAll
    pl_ApplyMovement 19, P90_05EC
    pl_WaitMovement
    pl_msg_sys 8
    pl_CloseMessage
    pl_ApplyMovement 19, P90_05FC
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_msg_sys 9
    pl_CloseMessage
    pl_ApplyMovement 19, P90_0604
    pl_WaitMovement
    pl_msg_sys 10
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 19, P90_060C
    pl_WaitMovement
    pl_RemoveObject 19, PFLAG_01C8
    pl_SetVarFromValue PVAR_40D1, 2
    pl_ReleaseAll
    pl_End

P90_S7:
P90_0614:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S8:
P90_0627:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S9:
P90_063A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S10:
P90_064D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S11:
P90_0660:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 24
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S12:
P90_0673:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 417
    pl_msg_talk 25
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S13:
P90_0692:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0001
    pl_GoToIf 1, P90_06FE
    pl_msg_talk 17
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P90_0709
    pl_msg_talk 18
    pl_CloseMessage
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerDir PVAR_8004
    pl_CompareVarToValue PVAR_8004, 0
    pl_GoToIf 1, P90_0714
    pl_CompareVarToValue PVAR_8004, 1
    pl_GoToIf 1, P90_072E
    pl_CompareVarToValue PVAR_8004, 2
    pl_GoToIf 1, P90_0748
    pl_CompareVarToValue PVAR_8004, 3
    pl_GoToIf 1, P90_0762
    pl_End

P90_06FE:
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0709:
    pl_msg_talk 21
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0714:
    pl_ApplyMovement 0, P90_0798
    pl_ApplyMovement PL_PLAYER, P90_07D4
    pl_WaitMovement
    pl_GoTo P90_077C

P90_072E:
    pl_ApplyMovement 0, P90_0798
    pl_ApplyMovement PL_PLAYER, P90_07EC
    pl_WaitMovement
    pl_GoTo P90_077C

P90_0748:
    pl_ApplyMovement 0, P90_0798
    pl_ApplyMovement PL_PLAYER, P90_0804
    pl_WaitMovement
    pl_GoTo P90_077C

P90_0762:
    pl_ApplyMovement 0, P90_07B0
    pl_ApplyMovement PL_PLAYER, P90_081C
    pl_WaitMovement
    pl_GoTo P90_077C

P90_077C:
    pl_SetFlag PFLAG_0001
    pl_msg_talk 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S14:
P90_083C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S15:
P90_084F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S16:
P90_0862:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S17:
P90_0873:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 31
    pl_msg_talk 32
    pl_CheckFlag PFLAG_014A
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_014B
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_014C
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_014D
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_014E
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_014F
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_0150
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_0151
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_0152
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_0153
    pl_GoToIf 0, P90_0904
    pl_CheckFlag PFLAG_0154
    pl_GoToIf 0, P90_0904
    pl_SetFlag PFLAG_015B
    pl_GoTo P90_0C40

P90_0904:
    pl_CheckFlag PFLAG_014A
    pl_GoToIf 1, P90_094C
    pl_CheckFlag PFLAG_098C
    pl_GoToIf 0, P90_094C
    pl_msg_talk 40
    pl_SetVarFromValue PVAR_8004, 46
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_014A
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_094C:
    pl_CheckFlag PFLAG_014B
    pl_GoToIf 1, P90_099A
    pl_CountBadgesAcquired PVAR_800C
    pl_CompareVarToValue PVAR_800C, 8
    pl_GoToIf 0, P90_099A
    pl_msg_talk 41
    pl_SetVarFromValue PVAR_8004, 47
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_014B
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_099A:
    pl_CheckFlag PFLAG_014C
    pl_GoToIf 1, P90_09E2
    pl_CheckFlag PFLAG_096A
    pl_GoToIf 0, P90_09E2
    pl_msg_talk 42
    pl_SetVarFromValue PVAR_8004, 72
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_014C
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_09E2:
    pl_CheckFlag PFLAG_014D
    pl_GoToIf 1, P90_0A2A
    pl_CheckFlag PFLAG_0968
    pl_GoToIf 0, P90_0A2A
    pl_msg_talk 43
    pl_SetVarFromValue PVAR_8004, 73
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_014D
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0A2A:
    pl_CheckFlag PFLAG_014E
    pl_GoToIf 1, P90_0A72
    pl_CheckFlag PFLAG_0969
    pl_GoToIf 0, P90_0A72
    pl_msg_talk 44
    pl_SetVarFromValue PVAR_8004, 74
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_014E
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0A72:
    pl_CheckFlag PFLAG_014F
    pl_GoToIf 1, P90_0ABA
    pl_CheckFlag PFLAG_096C
    pl_GoToIf 0, P90_0ABA
    pl_msg_talk 45
    pl_SetVarFromValue PVAR_8004, 75
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_014F
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0ABA:
    pl_CheckFlag PFLAG_0150
    pl_GoToIf 1, P90_0B02
    pl_CheckFlag PFLAG_096B
    pl_GoToIf 0, P90_0B02
    pl_msg_talk 46
    pl_SetVarFromValue PVAR_8004, 76
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_0150
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0B02:
    pl_CheckFlag PFLAG_0151
    pl_GoToIf 1, P90_0B50
    pl_stub GetUndergroundTalkCounter  // Pearl 0x293 Unk0293 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 100
    pl_GoToIf 0, P90_0B50
    pl_msg_talk 47
    pl_SetVarFromValue PVAR_8004, 77
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_0151
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0B50:
    pl_CheckFlag PFLAG_0152
    pl_GoToIf 1, P90_0B9E
    pl_stub GetUndergroundItemsGivenAway  // Pearl 0x286 Unk0286 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 100
    pl_GoToIf 0, P90_0B9E
    pl_msg_talk 48
    pl_SetVarFromValue PVAR_8004, 78
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_0152
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0B9E:
    pl_CheckFlag PFLAG_0153
    pl_GoToIf 1, P90_0BEC
    pl_stub GetUndergroundFossilsUnearthed  // Pearl 0x287 Unk0287 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 100
    pl_GoToIf 0, P90_0BEC
    pl_msg_talk 49
    pl_SetVarFromValue PVAR_8004, 79
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_0153
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0BEC:
    pl_CheckFlag PFLAG_0154
    pl_GoToIf 1, P90_0C3A
    pl_stub GetUndergroundTrapsSet  // Pearl 0x288 Unk0288 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 100
    pl_GoToIf 0, P90_0C3A
    pl_msg_talk 50
    pl_SetVarFromValue PVAR_8004, 80
    pl_SetVarFromValue PVAR_8005, 1
    pl_stub CheckHasRoomForGoodsInPC  // Pearl 0x085 HasSpaceForDecoration 32772, 32773, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0C4B
    VMCall C205_13_S13  // CallCommonScript 2012 (Pearl file 205 script 13)
    pl_SetFlag PFLAG_0154
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0C3A:
    pl_GoTo P90_0C56

P90_0C40:
    pl_msg_talk 34
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0C4B:
    pl_msg_talk 37
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_0C56:
    pl_msg_talk 39
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S18:
P90_0C61:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 54
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S19:
P90_0C74:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_talk 55
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S20:
P90_0C85:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 56
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S21:
P90_0C98:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 57
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P90_S22:
P90_0CAB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 3
    pl_CloseMessage
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P90_0CDA
    pl_CheckFlag PFLAG_0001
    pl_GoToIf 1, P90_0CFA
    pl_GoTo P90_0CEA

P90_0CDA:
    pl_ApplyMovement 35, P90_0D14
    pl_WaitMovement
    pl_GoTo P90_0D0A

P90_0CEA:
    pl_ApplyMovement 35, P90_0D20
    pl_WaitMovement
    pl_GoTo P90_0D0A

P90_0CFA:
    pl_ApplyMovement 35, P90_0D28
    pl_WaitMovement
    pl_GoTo P90_0D0A

P90_0D0A:
    pl_RemoveObject 35, PFLAG_025C
    pl_ReleaseAll
    pl_End

P90_S23:
P90_0D38:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P90_0E60
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 725
    pl_GoToIf 1, P90_0D8D
    pl_CompareVarToValue PVAR_8005, 726
    pl_GoToIf 1, P90_0DA5
    pl_CompareVarToValue PVAR_8005, 727
    pl_GoToIf 1, P90_0DBD
    pl_CompareVarToValue PVAR_8005, 728
    pl_GoToIf 1, P90_0DD5
    pl_CompareVarToValue PVAR_8005, 729
    pl_GoToIf 1, P90_0DED
    pl_End

P90_0D8D:
    pl_SetObjectEventPosLater 1, 34, 471, 2, 725, 2  // SetObjectEventPos 34 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 2, 33, 471, 2, 725, 2  // SetObjectEventPos 33 (the live actor; and where AddObject puts it)
    pl_GoTo P90_0E05

P90_0DA5:
    pl_SetObjectEventPosLater 1, 34, 471, 2, 726, 2  // SetObjectEventPos 34 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 2, 33, 471, 2, 726, 2  // SetObjectEventPos 33 (the live actor; and where AddObject puts it)
    pl_GoTo P90_0E05

P90_0DBD:
    pl_SetObjectEventPosLater 1, 34, 471, 2, 727, 2  // SetObjectEventPos 34 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 2, 33, 471, 2, 727, 2  // SetObjectEventPos 33 (the live actor; and where AddObject puts it)
    pl_GoTo P90_0E05

P90_0DD5:
    pl_SetObjectEventPosLater 1, 34, 471, 5, 728, 2  // SetObjectEventPos 34 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 2, 33, 471, 5, 728, 2  // SetObjectEventPos 33 (the live actor; and where AddObject puts it)
    pl_GoTo P90_0E05

P90_0DED:
    pl_SetObjectEventPosLater 1, 34, 471, 2, 729, 2  // SetObjectEventPos 34 (the live actor; and where AddObject puts it)
    pl_SetObjectEventPosLater 2, 33, 471, 2, 729, 2  // SetObjectEventPos 33 (the live actor; and where AddObject puts it)
    pl_GoTo P90_0E05

P90_0E05:
    pl_ClearFlag PFLAG_025A
    pl_ClearFlag PFLAG_025B
    pl_AddObjectAt 34, 1, 2  // at its SetObjectEventPos
    pl_AddObjectAt 33, 2, 2  // at its SetObjectEventPos
    pl_ApplyMovement 33, P90_0E68
    pl_WaitMovement
    pl_PlayCry 427
    pl_WaitCry
    pl_ApplyMovement 34, P90_0E78
    pl_WaitMovement
    pl_msg_sys 0
    pl_msg_sys 1
    pl_PlayCry 427
    pl_WaitCry
    pl_RemoveObject 33, PFLAG_025B
    pl_msg_sys 2
    pl_CloseMessage
    pl_ApplyMovement 34, P90_0E80
    pl_WaitMovement
    pl_RemoveObject 34, PFLAG_025A
    pl_SetVarFromValue PVAR_40F6, 1
    pl_ReleaseAll
    pl_End

P90_S24:
P90_0E88:
    pl_sign 58, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S25:
P90_0E9F:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 59, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S26:
P90_0EB4:
    pl_sign 60, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S27:
P90_0ECB:
    pl_sign 61, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S28:
P90_0EE2:
    pl_sign 62, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S29:
P90_0EF9:
    pl_sign 63, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S30:
P90_0F10:
    pl_sign 64, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S31:
P90_0F27:
    pl_sign 65, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P90_S32:
P90_0F3E:
    pl_sign 66, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

    .balign 4, 0
P90_0150:
    Move 16, 4  // WALK_FAST_NORTH
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 16, 3  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P90_0160:
    Move 17, 7  // WALK_FAST_SOUTH
    Move 19, 8  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P90_040C:
    Move 62, 15  // DELAY_4
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_0418:
    Move 62, 15  // DELAY_4
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P90_0424:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P90_0430:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P90_0448:
    Move 18, 4  // WALK_FAST_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 4  // WALK_FAST_WEST
    Move 16, 1  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P90_045C:
    Move 18, 4  // WALK_FAST_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 4  // WALK_FAST_WEST
    Move 36, 1  // WALK_ON_SPOT_FAST_NORTH
    MoveEnd

    .balign 4, 0
P90_0470:
    Move 18, 4  // WALK_FAST_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 3  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P90_0480:
    Move 18, 4  // WALK_FAST_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 4  // WALK_FAST_WEST
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P90_0494:
    Move 18, 4  // WALK_FAST_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 4  // WALK_FAST_WEST
    Move 17, 1  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P90_04A8:
    Move 18, 4  // WALK_FAST_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 4  // WALK_FAST_WEST
    Move 17, 2  // WALK_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P90_04BC:
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P90_04C4:
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P90_04CC:
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P90_04D4:
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P90_04DC:
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P90_04E4:
    Move 16, 1  // WALK_FAST_NORTH
    Move 19, 9  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P90_05EC:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 15, 5  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P90_05FC:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_0604:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P90_060C:
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_0798:
    Move 14, 20  // WALK_NORMAL_WEST
    Move 12, 13  // WALK_NORMAL_NORTH
    Move 15, 12  // WALK_NORMAL_EAST
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_07B0:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 18  // WALK_NORMAL_WEST
    Move 12, 13  // WALK_NORMAL_NORTH
    Move 15, 12  // WALK_NORMAL_EAST
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_07D4:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 14, 20  // WALK_NORMAL_WEST
    Move 12, 13  // WALK_NORMAL_NORTH
    Move 15, 12  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P90_07EC:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 20  // WALK_NORMAL_WEST
    Move 12, 13  // WALK_NORMAL_NORTH
    Move 15, 12  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P90_0804:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 14, 20  // WALK_NORMAL_WEST
    Move 12, 13  // WALK_NORMAL_NORTH
    Move 15, 12  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P90_081C:
    Move 63, 2  // DELAY_8
    Move 62, 1  // DELAY_4
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 14, 19  // WALK_NORMAL_WEST
    Move 12, 13  // WALK_NORMAL_NORTH
    Move 15, 12  // WALK_NORMAL_EAST
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P90_0D14:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_0D20:
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_0D28:
    Move 13, 2  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 7  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P90_0E60:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P90_0E68:
    Move 18, 9  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P90_0E78:
    Move 18, 8  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P90_0E80:
    Move 15, 8  // WALK_NORMAL_EAST
    MoveEnd

// ---- continuation 34: after the Warp at 230:0421 (MAP_MOUNT_CORONET_SPEAR_PILLAR)
W230_0421_S:
// the music Pearl kept over the map change (SetBGMFixed, fixed_music):
#ifdef SEQ_PEARL_THE_EVENT03
    pl_PlayMusic SEQ_PEARL_THE_EVENT03  // Pearl SEQ_THE_EVENT03
#else
    pl_stub PlayMusic  // Pearl sound SEQ_THE_EVENT03: no Black 2 stand-in
#endif
W230_0421_042D:
    pl_HideObject PL_PLAYER  // Pearl HideObject 255
    pl_SpearPillarSequence 9, PVAR_800C  // Pearl SpearPillarSequence 9
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_WaitTime 90, PVAR_800C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_SetFlag PFLAG_00BE
    WorkCmpConst PVAR_8000, 29
    VMJumpIf CMP_NE, .Lwarp458_1
    WorkCmpConst PVAR_8001, 35
    VMJumpIf CMP_NE, .Lwarp458_1
    RTReserveScript 16  // the rest of this Pearl script runs there (continuation 16)
    pl_Warp 330, 29, 35, 0  // Pearl map 220 (MAP_MOUNT_CORONET_SPEAR_PILLAR) at (PVAR_8000, PVAR_8001) = (29, 35)
    pl_ReleaseAll
    pl_End
.Lwarp458_1:
    WorkCmpConst PVAR_8000, 30
    VMJumpIf CMP_NE, .Lwarp458_2
    WorkCmpConst PVAR_8001, 35
    VMJumpIf CMP_NE, .Lwarp458_2
    RTReserveScript 16  // the rest of this Pearl script runs there (continuation 16)
    pl_Warp 330, 30, 35, 0  // Pearl map 220 (MAP_MOUNT_CORONET_SPEAR_PILLAR) at (PVAR_8000, PVAR_8001) = (30, 35)
    pl_ReleaseAll
    pl_End
.Lwarp458_2:
    WorkCmpConst PVAR_8000, 32
    VMJumpIf CMP_NE, .Lwarp458_3
    WorkCmpConst PVAR_8001, 35
    VMJumpIf CMP_NE, .Lwarp458_3
    RTReserveScript 16  // the rest of this Pearl script runs there (continuation 16)
    pl_Warp 330, 32, 35, 0  // Pearl map 220 (MAP_MOUNT_CORONET_SPEAR_PILLAR) at (PVAR_8000, PVAR_8001) = (32, 35)
    pl_ReleaseAll
    pl_End
.Lwarp458_3:
    WorkCmpConst PVAR_8000, 33
    VMJumpIf CMP_NE, .Lwarp458_4
    WorkCmpConst PVAR_8001, 35
    VMJumpIf CMP_NE, .Lwarp458_4
    RTReserveScript 16  // the rest of this Pearl script runs there (continuation 16)
    pl_Warp 330, 33, 35, 0  // Pearl map 220 (MAP_MOUNT_CORONET_SPEAR_PILLAR) at (PVAR_8000, PVAR_8001) = (33, 35)
    pl_ReleaseAll
    pl_End
.Lwarp458_4:
    RTReserveScript 16  // the rest of this Pearl script runs there (continuation 16)
    pl_Warp 330, 31, 35, 0  // Pearl map 220 (MAP_MOUNT_CORONET_SPEAR_PILLAR) at (PVAR_8000, PVAR_8001) = (31, 35)
    pl_ReleaseAll
    pl_End

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

// ---- Pearl global script 205:13 (a subroutine here)
C205_13_S13:
C205_13_0884:
    pl_Call C205_13_08A0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 67  // Pearl bank 199 line 109
    pl_WaitButton
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_13_08A0:
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_stub SendGoodToPC  // Pearl 0x083 GiveSecretBaseDecoration 32772, 32773, 32780: not translated yet
    pl_stub GetDecorationNameWithArticle  // Pearl 0x2C6 GetDecorationNameWithArticle 0, 32772: not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 68  // Pearl bank 199 line 108
    pl_stub BufferUndergroundGoodsName  // Pearl 0x0DF GetDecorationName 0, 32772: not translated yet
    pl_WaitFanfare
    pl_Return

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
