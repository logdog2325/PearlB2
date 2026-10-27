// MAP_VALLEY_WINDWORKS_EXTERIOR: Pearl script file 210, text bank 210. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; 8: after a Warp; 9: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P210_S1
    ScriptEntry P210_S2
    ScriptEntry P210_S3
    ScriptEntry P210_S4
    ScriptEntry P210_S5
    ScriptEntry P210_S6
    ScriptEntry P210_S7
    ScriptEntry W230_03EE_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P210_S7:
P210_001E:
    pl_End

P210_S1:
P210_0020:
    pl_CompareVarToValue PVAR_40CF, 2
    pl_CallIf 1, P210_007E
    pl_CheckFlag PFLAG_010F
    pl_CallIf 1, P210_00B7
    pl_CheckFlag PFLAG_010F
    pl_CallIf 0, P210_00C1
    pl_CompareVarToValue PVAR_4089, 2
    pl_GoToIf 0, P210_0078
    pl_CheckFlag PFLAG_0AA8
    pl_GoToIf 1, P210_0078
    RTCGetWeekDay PVAR_4000
    pl_CompareVarToValue PVAR_4000, 5
    pl_GoToIf 5, P210_0078
    pl_GoTo P210_0072

P210_0072:
    pl_ClearFlag PFLAG_0229
    pl_End

P210_0078:
    pl_SetFlag PFLAG_0229
    pl_End

P210_007E:
    pl_SetVarFromValue PVAR_40CF, 3
    pl_Return

P210_S2:
P210_0086:
    pl_CheckFlag PFLAG_010F
    pl_CallIf 1, P210_00B7
    pl_CheckFlag PFLAG_010F
    pl_CallIf 0, P210_00C1
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P210_00A9
    pl_End

P210_00A9:
    pl_SetFlag PFLAG_0229
    pl_RemoveObject 4, PFLAG_0229
    pl_ClearFlag PFLAG_008E
    pl_End

P210_00B7:
    pl_SetBgEventPos 1, 243, 650, 80  // SetBgEventPosition 1, 243, 650
    pl_Return

P210_00C1:
    pl_SetWarpEventPos 0, 243, 650, 5
    pl_Return

P210_S3:
P210_00CB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_CloseMessage
    pl_StartTrainerBattle PTRAINER_843, 0
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P210_012F
    pl_msg_talk 1
    pl_CloseMessage
    pl_ApplyMovement 0, P210_0138
    pl_WaitMovement
    pl_LoadDoorAnimation 77, 243, 654  // the door at cell (7,20) tile (19,14)
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_ApplyMovement 0, P210_0140
    pl_WaitMovement
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_msg_sys 2
    pl_RemoveObject 0, PFLAG_01AC
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P210_012F:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

P210_S4:
P210_014C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_CheckFlag PFLAG_009F
    pl_GoToIf 1, P210_0168
    pl_msg_sys 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P210_0168:
    pl_BufferItemName 0, 438
    pl_msg_sys 4
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P210_019E
    pl_SetFlag PFLAG_010F
    pl_Call P210_00B7
    pl_SetWarpEventPos 0, 243, 654, 5
    pl_msg_sys 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P210_019E:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P210_S5:
P210_01A4:
    pl_sign 7, 2  // Pearl sign type 2
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P210_S6:
P210_01BB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_PlayCry 425
    pl_msg_talk 6
    pl_CloseMessage
    pl_WaitCry
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 425, 22
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P210_01F7
    pl_SetFlag PFLAG_0AA8
    pl_ReleaseAll
    pl_End

P210_01F7:
    pl_BlackOutFromWildBattle
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P210_0138:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P210_0140:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

// ---- continuation 8: after the Warp at 230:03EE (MAP_MOUNT_CORONET_SPEAR_PILLAR)
W230_03EE_S:
// the music Pearl kept over the map change (SetBGMFixed, fixed_music):
#ifdef SEQ_PEARL_THE_EVENT03
    pl_PlayMusic SEQ_PEARL_THE_EVENT03  // Pearl SEQ_THE_EVENT03
#else
    pl_stub PlayMusic  // Pearl sound SEQ_THE_EVENT03: no Black 2 stand-in
#endif
W230_03EE_03FA:
    pl_HideObject PL_PLAYER  // Pearl HideObject 255
    pl_SpearPillarSequence 8, PVAR_800C  // Pearl SpearPillarSequence 8
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_WaitTime 90, PVAR_800C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 34  // the rest of this Pearl script runs there (continuation 34)
    pl_Warp 107, 479, 692, 2  // Pearl map 86 (MAP_HEARTHOME)
    pl_ReleaseAll
    pl_End

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
