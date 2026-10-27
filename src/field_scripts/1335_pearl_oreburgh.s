// MAP_OREBURGH: Pearl script file 48, text bank 58. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-19: Pearl's; no warp continuations; 20: PearlArrive; 49: Pearl 2027
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P48_S1
    ScriptEntry P48_S2
    ScriptEntry P48_S3
    ScriptEntry P48_S4
    ScriptEntry P48_S5
    ScriptEntry P48_S6
    ScriptEntry P48_S7
    ScriptEntry P48_S8
    ScriptEntry P48_S9
    ScriptEntry P48_S10
    ScriptEntry P48_S11
    ScriptEntry P48_S12
    ScriptEntry P48_S13
    ScriptEntry P48_S14
    ScriptEntry P48_S15
    ScriptEntry P48_S16
    ScriptEntry P48_S17
    ScriptEntry P48_S18
    ScriptEntry P48_S19
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
    ScriptEntry PearlProxy_2027
    ScriptEntriesEnd

P48_S1:
P48_004E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_008A
    pl_GoToIf 1, P48_0076
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_talk 0
    pl_WaitButton
    pl_SetFlag PFLAG_008A
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_0076:
    pl_BufferRivalName 0
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S2:
P48_0084:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckBadgeAcquired 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P48_00B5
    pl_CheckFlag PFLAG_007A
    pl_GoToIf 1, P48_00C0
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_00B5:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_00C0:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S4:
P48_00CB:
    pl_LockAll
    pl_ClearFlag PFLAG_019A
// SetObjectEventMovementType 3, 16: Black 2 has no command for it (the NPC keeps its own)
    pl_ApplyMovement 3, .Lfaced7  // SetObjectEventDir 3: the live actor turns
    pl_WaitMovement
    VMJump .Lfaced7_end
    .balign 4, 0
.Lfaced7:
        Move 2, 1
        MoveEnd
.Lfaced7_end:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 748
    pl_GoToIf 1, P48_0112
    pl_CompareVarToValue PVAR_8005, 749
    pl_GoToIf 1, P48_0138
    pl_CompareVarToValue PVAR_8005, 750
    pl_GoToIf 1, P48_015E
    pl_GoTo P48_0184

P48_0112:
    pl_SetObjectEventPosLater 0, 3, 271, 2, 748, 1  // SetObjectEventPos 3 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 3, 0, 1  // at its SetObjectEventPos
    pl_ApplyMovement PL_PLAYER, P48_0294
    pl_ApplyMovement 3, P48_02AC
    pl_WaitMovement
    pl_GoTo P48_01AA

P48_0138:
    pl_SetObjectEventPosLater 0, 3, 271, 2, 749, 1  // SetObjectEventPos 3 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 3, 0, 1  // at its SetObjectEventPos
    pl_ApplyMovement PL_PLAYER, P48_0294
    pl_ApplyMovement 3, P48_02AC
    pl_WaitMovement
    pl_GoTo P48_01AA

P48_015E:
    pl_SetObjectEventPosLater 0, 3, 271, 2, 750, 1  // SetObjectEventPos 3 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 3, 0, 1  // at its SetObjectEventPos
    pl_ApplyMovement PL_PLAYER, P48_0294
    pl_ApplyMovement 3, P48_02AC
    pl_WaitMovement
    pl_GoTo P48_01AA

P48_0184:
    pl_SetObjectEventPosLater 0, 3, 271, 2, 751, 1  // SetObjectEventPos 3 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 3, 0, 1  // at its SetObjectEventPos
    pl_ApplyMovement PL_PLAYER, P48_0294
    pl_ApplyMovement 3, P48_02AC
    pl_WaitMovement
    pl_GoTo P48_01AA

P48_01AA:
    pl_PlaySE SEQ_SE_WALL_HIT  // Pearl SEQ_SE_DP_WALL_HIT2
    pl_msg_sys 2
    pl_CloseMessage
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 3
    pl_CloseMessage
    pl_ApplyMovement 3, P48_0334
    pl_WaitMovement
    pl_msg_sys 4
    pl_ApplyMovement 3, P48_033C
    pl_WaitMovement
    pl_msg_sys 5
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 748
    pl_GoToIf 1, P48_0213
    pl_CompareVarToValue PVAR_8005, 749
    pl_GoToIf 1, P48_022D
    pl_CompareVarToValue PVAR_8005, 750
    pl_GoToIf 1, P48_0247
    pl_GoTo P48_0261

P48_0213:
    pl_ApplyMovement PL_PLAYER, P48_0304
    pl_ApplyMovement 3, P48_02B4
    pl_WaitMovement
    pl_GoTo P48_027B

P48_022D:
    pl_ApplyMovement PL_PLAYER, P48_0310
    pl_ApplyMovement 3, P48_02C4
    pl_WaitMovement
    pl_GoTo P48_027B

P48_0247:
    pl_ApplyMovement PL_PLAYER, P48_031C
    pl_ApplyMovement 3, P48_02DC
    pl_WaitMovement
    pl_GoTo P48_027B

P48_0261:
    pl_ApplyMovement PL_PLAYER, P48_0328
    pl_ApplyMovement 3, P48_02EC
    pl_WaitMovement
    pl_GoTo P48_027B

P48_027B:
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 3, PFLAG_019A
    VMCall C205_44_S44  // CallCommonScript 2043 (Pearl file 205 script 44)
    pl_SetVarFromValue PVAR_4079, 3
    pl_ReleaseAll
    pl_End

P48_S5:
P48_0344:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S6:
P48_0357:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 20
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S7:
P48_036A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0109
    pl_GoToIf 1, P48_03B1
    pl_msg_talk 21
    pl_SetVarFromValue PVAR_8004, 26
    pl_SetVarFromValue PVAR_8005, 1
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P48_03BC
    VMCall C205_45_S45  // CallCommonScript 2044 (Pearl file 205 script 45)
    pl_SetFlag PFLAG_0109
    pl_GoTo P48_03B1

P48_03B1:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_03BC:
    VMCall C205_18_S18  // CallCommonScript 2017 (Pearl file 205 script 18)
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S8:
P48_03C6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 23
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S9:
P48_03D9:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 24
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S3:
P48_03EC:
    pl_LockAll
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 748
    pl_GoToIf 1, P48_0423
    pl_CompareVarToValue PVAR_8005, 749
    pl_GoToIf 1, P48_043D
    pl_CompareVarToValue PVAR_8005, 750
    pl_GoToIf 1, P48_0457
    pl_GoTo P48_0471

P48_0423:
    pl_ApplyMovement PL_PLAYER, P48_0550
    pl_ApplyMovement 4, P48_05F8
    pl_WaitMovement
    pl_GoTo P48_048B

P48_043D:
    pl_ApplyMovement PL_PLAYER, P48_0550
    pl_ApplyMovement 4, P48_0600
    pl_WaitMovement
    pl_GoTo P48_048B

P48_0457:
    pl_ApplyMovement PL_PLAYER, P48_0550
    pl_ApplyMovement 4, P48_0608
    pl_WaitMovement
    pl_GoTo P48_048B

P48_0471:
    pl_ApplyMovement PL_PLAYER, P48_0550
    pl_ApplyMovement 4, P48_0610
    pl_WaitMovement
    pl_GoTo P48_048B

P48_048B:
    pl_msg_sys 6
    pl_CloseMessage
    VMCall C205_49_S49  // CallCommonScript 2048 (Pearl file 205 script 49)
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 748
    pl_GoToIf 1, P48_04D0
    pl_CompareVarToValue PVAR_8005, 749
    pl_GoToIf 1, P48_04EA
    pl_CompareVarToValue PVAR_8005, 750
    pl_GoToIf 1, P48_0504
    pl_CompareVarToValue PVAR_8005, 751
    pl_GoToIf 1, P48_051E
    pl_End

P48_04D0:
    pl_ApplyMovement PL_PLAYER, P48_0558
    pl_ApplyMovement 4, P48_05A8
    pl_WaitMovement
    pl_GoTo P48_0538

P48_04EA:
    pl_ApplyMovement PL_PLAYER, P48_056C
    pl_ApplyMovement 4, P48_05BC
    pl_WaitMovement
    pl_GoTo P48_0538

P48_0504:
    pl_ApplyMovement PL_PLAYER, P48_0580
    pl_ApplyMovement 4, P48_05D0
    pl_WaitMovement
    pl_GoTo P48_0538

P48_051E:
    pl_ApplyMovement PL_PLAYER, P48_0594
    pl_ApplyMovement 4, P48_05E4
    pl_WaitMovement
    pl_GoTo P48_0538

P48_0538:
    pl_msg_sys 7
    pl_WaitButton
    pl_CloseMessage
    VMCall C205_50_S50  // CallCommonScript 2049 (Pearl file 205 script 50)
    pl_SetVarFromValue PVAR_4079, 1
    pl_ReleaseAll
    pl_End

P48_S10:
P48_0618:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 25
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S11:
P48_062B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_007A
    pl_GoToIf 1, P48_0649
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_0649:
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S12:
P48_0654:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 18
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S13:
P48_0667:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S14:
P48_067A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P48_S15:
P48_068D:
    pl_sign 28, 1  // Pearl sign type 0
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P48_S16:
P48_06A4:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 29, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P48_S17:
P48_06B9:
    pl_sign 30, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P48_S18:
P48_06D0:
    pl_sign 31, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P48_S19:
P48_06E7:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 66
    pl_msg_talk 27
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P48_0294:
    Move 62, 8  // DELAY_4
    Move 71, 1  // LOCK_DIR
    Move 18, 1  // WALK_FAST_WEST
    Move 72, 1  // UNLOCK_DIR
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P48_02AC:
    Move 18, 9  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P48_02B4:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 18, 4  // WALK_FAST_WEST
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    MoveEnd

    .balign 4, 0
P48_02C4:
    Move 17, 1  // WALK_FAST_SOUTH
    Move 18, 3  // WALK_FAST_WEST
    Move 16, 1  // WALK_FAST_NORTH
    Move 18, 1  // WALK_FAST_WEST
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    MoveEnd

    .balign 4, 0
P48_02DC:
    Move 16, 1  // WALK_FAST_NORTH
    Move 18, 4  // WALK_FAST_WEST
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    MoveEnd

    .balign 4, 0
P48_02EC:
    Move 16, 1  // WALK_FAST_NORTH
    Move 18, 3  // WALK_FAST_WEST
    Move 16, 1  // WALK_FAST_NORTH
    Move 18, 1  // WALK_FAST_WEST
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    MoveEnd

    .balign 4, 0
P48_0304:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_0310:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_031C:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_0328:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_0334:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P48_033C:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_0550:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P48_0558:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 10  // WALK_NORMAL_SOUTH
    Move 15, 12  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P48_056C:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 9  // WALK_NORMAL_SOUTH
    Move 15, 12  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P48_0580:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 8  // WALK_NORMAL_SOUTH
    Move 15, 12  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P48_0594:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 7  // WALK_NORMAL_SOUTH
    Move 15, 12  // WALK_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P48_05A8:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 10  // WALK_NORMAL_SOUTH
    Move 15, 13  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_05BC:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 9  // WALK_NORMAL_SOUTH
    Move 15, 13  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_05D0:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 8  // WALK_NORMAL_SOUTH
    Move 15, 13  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_05E4:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 13, 7  // WALK_NORMAL_SOUTH
    Move 15, 13  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P48_05F8:
    Move 12, 3  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P48_0600:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P48_0608:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P48_0610:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

PearlProxy_2027:                  // Pearl global script 2027 (run by this zone's events)
    VMCall T205_28_S28
    VMHalt

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
    pl_msg_sys 32  // Pearl bank 199 line 126
    pl_Return

C205_45_09F4:
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 33  // Pearl bank 199 line 28
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
    pl_msg_sys 34  // Pearl bank 199 line 25
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
    pl_msg_sys 35  // Pearl bank 199 line 110
    pl_Return

C205_45_13BA:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 36  // Pearl bank 199 line 111
    pl_Return

C205_45_13BF:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 37  // Pearl bank 199 line 112
    pl_Return

C205_45_13C4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 38  // Pearl bank 199 line 113
    pl_Return

C205_45_13C9:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 39  // Pearl bank 199 line 114
    pl_Return

C205_45_13CE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 40  // Pearl bank 199 line 115
    pl_Return

C205_45_13D3:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 41  // Pearl bank 199 line 116
    pl_Return

C205_45_13D8:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 42  // Pearl bank 199 line 117
    pl_Return

// ---- Pearl global script 205:18 (a subroutine here)
C205_18_S18:
C205_18_0B60:
    pl_Call C205_18_0B6A
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_18_0B6A:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 43  // Pearl bank 199 line 27
    pl_WaitButton
    pl_Return

// ---- Pearl global script 205:49 (a subroutine here)
C205_49_S49:
C205_49_150B:
    pl_FadeOutBGM 1  // StopMusic
    #ifdef SEQ_PEARL_TSURETEKE
        pl_PlayMusic SEQ_PEARL_TSURETEKE  // Pearl SEQ_TSURETEKE
    #else
        pl_PlayMusic SEQ_BGM_E_TSURETEKE2  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:50 (a subroutine here)
C205_50_S50:
C205_50_1517:
    pl_FadeOutBGM 30  // FadeOutBGM to volume 0
    pl_FadeOutBGM 1  // StopMusic
    pl_PlayDefaultMusic
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 205:28 (a subroutine here)
T205_28_S28:
T205_28_1222:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 44  // Pearl bank 199 line 67
    pl_WaitButton
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
