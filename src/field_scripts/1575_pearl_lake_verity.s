// MAP_LAKE_VERITY: Pearl script file 342, text bank 270. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-7: Pearl's; 8: after a Warp; 9: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P342_S1
    ScriptEntry P342_S2
    ScriptEntry P342_S3
    ScriptEntry P342_S4
    ScriptEntry P342_S5
    ScriptEntry P342_S6
    ScriptEntry P342_S7
    ScriptEntry W379_0108_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P342_S1:
P342_001E:
    pl_GetPlayerGender PVAR_4000
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 1, P342_003E
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P342_0046
    pl_End

P342_003E:
    pl_SetVarFromValue PVAR_4020, 240  // dynamic sprite: Pearl graphics 97 -> Black 2 code
    pl_End

P342_0046:
    pl_SetVarFromValue PVAR_4020, 231  // dynamic sprite: Pearl graphics 0 -> Black 2 code
    pl_End

P342_S2:
P342_004E:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P342_005B
    pl_End

P342_005B:
    pl_SetFlag PFLAG_01AD
    pl_RemoveObject 3, PFLAG_01AD
    pl_RemoveObject 2, PFLAG_01AD
    pl_ClearFlag PFLAG_008E
    pl_End

P342_S3:
P342_006F:
    pl_LockAll
    pl_follow_leave  // ClearHasPartner: the follower stays behind
    pl_ApplyMovement 5, P342_050C
    pl_ApplyMovement PL_PLAYER, P342_05C4
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 0
    pl_CloseMessage
    EvCameraInit  // AddFreeCamera 46, 53: Black 2's event camera on that tile
    EvCameraUnbind
    EvCameraMoveTo 9688, 0, 0xed000, 3047424, 65536, 3506176, 1
    EvCameraWait
    EvCameraMoveTo 9688, 0, 0xed000, 3047424, 65536, 2916352, 72  // ApplyMovement 0xF1 P342_0428: the free camera walks to (46, 44)
    EvCameraWait
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P342_00BC
    pl_GoTo P342_00C7

P342_00BC:
    pl_msg_sys 3
    pl_GoTo P342_00D2

P342_00C7:
    pl_msg_sys 4
    pl_GoTo P342_00D2

P342_00D2:
    pl_msg_sys 5
    pl_ApplyMovement 0, P342_043C
    pl_WaitMovement
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys_gendered 45, 46  // Pearl line 6, naming the counterpart: Dawn (boy) / Lucas (girl)
    pl_CloseMessage
    pl_ApplyMovement 0, P342_0444
    pl_ApplyMovement 1, P342_0470
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P342_0112
    pl_GoTo P342_0120

P342_0112:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 7
    pl_GoTo P342_012E

P342_0120:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 8
    pl_GoTo P342_012E

P342_012E:
    pl_msg_sys 9
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    pl_ClearFlag PFLAG_0194
    pl_AddObject 4
    pl_ApplyMovement 0, P342_0454
    pl_ApplyMovement 1, P342_0494
    pl_ApplyMovement 5, P342_0514
    pl_ApplyMovement PL_PLAYER, P342_05CC
    EvCameraMoveTo 9688, 0, 0xed000, 3047424, 65536, 3506176, 72  // ApplyMovement 0xF1 P342_0434: the free camera walks to (46, 53)
    EvCameraWait
    pl_WaitMovement
    EvCameraReturn 1  // RestoreCamera: the view cuts back to the player
    EvCameraWait
    EvCameraRebind
    EvCameraEnd
    pl_msg_sys 10
    pl_CloseMessage
    pl_ApplyMovement 0, P342_0464
    pl_WaitMovement
    pl_ApplyMovement 1, P342_04A8
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P342_019F
    pl_GoTo P342_01AD

P342_019F:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 11
    pl_GoTo P342_01BB

P342_01AD:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 12
    pl_GoTo P342_01BB

P342_01BB:
    pl_CloseMessage
    pl_ApplyMovement 1, P342_04D0
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 0, PFLAG_0193
    pl_RemoveObject 1, PFLAG_01B2
    pl_WaitTime 50, PVAR_800C
    pl_ApplyMovement 5, P342_0524
    pl_WaitMovement
    pl_BufferRivalName 0
    pl_msg_sys 13
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    pl_ApplyMovement 5, P342_0530
    pl_WaitMovement
    pl_WaitTime 30, PVAR_800C
    pl_BufferPlayerName 0
    pl_msg_sys 14
    pl_CloseMessage
    pl_ApplyMovement 5, P342_0538
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_msg_sys 15
    pl_CloseMessage
    pl_ApplyMovement 5, P342_0540
    pl_ApplyMovement PL_PLAYER, P342_05D8
    pl_WaitMovement
    pl_msg_sys 16
    pl_CloseMessage
    pl_FadeOutBGM 1  // StopMusic
    #ifdef SEQ_PEARL_THE_EVENT01
        pl_PlayMusic SEQ_PEARL_THE_EVENT01  // Pearl SEQ_THE_EVENT01
    #else
        pl_PlayMusic SEQ_BGM_E_DOCTOR  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_ClearFlag PFLAG_01AD
    pl_AddObject 3
    pl_AddObject 2
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_FW019: no Black 2 sound chosen yet
    pl_ApplyMovement 3, P342_0650
    pl_ApplyMovement 2, P342_0658
    pl_WaitMovement
    pl_PlayCry 396
    pl_ApplyMovement 5, P342_0564
    pl_ApplyMovement PL_PLAYER, P342_060C
    pl_WaitMovement
    pl_msg_sys 17
    pl_ApplyMovement 5, P342_056C
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 18
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_StartChooseStarterScene
    pl_SaveChosenStarter
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_GetPlayerStarterSpecies PVAR_8000
    pl_GivePokemon PVAR_8000, 5, 0, PVAR_800C
    pl_SetFlag PFLAG_008E
    pl_StartFirstBattle 396, 2
    pl_ClearFlag PFLAG_008E
    pl_GoTo P342_02CE

P342_02CE:
    pl_ApplyMovement 5, P342_05A0
    pl_ApplyMovement PL_PLAYER, P342_062C
    pl_WaitMovement
    pl_HealParty
    pl_BufferRivalName 0
    pl_BufferPlayerStarterSpeciesName 1
    pl_BufferRivalStarterSpeciesName 2
    pl_msg_sys 19
    pl_CloseMessage
    pl_ClearFlag PFLAG_01B2
    pl_SetObjectEventPosLater 0, 1, 47, 1, 51, 0  // SetObjectEventPos 1 (the live actor; and where AddObject puts it)
    pl_AddObjectAt 1, 0, 0  // at its SetObjectEventPos
// LockObject 1: nothing in Black 2 (Black 2 pauses all actors (LockAll) only)
    VMCall C205_41_S41  // CallCommonScript 2040 (Pearl file 205 script 41)
    pl_ApplyMovement 1, P342_04DC
    pl_ApplyMovement 5, P342_0574
    pl_ApplyMovement PL_PLAYER, P342_05F4
    pl_WaitMovement
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P342_0339
    pl_GoTo P342_0354

P342_0339:
// BufferCounterpartName 0: the lines naming Dawn/Lucas come as a boy and a girl copy
    pl_msg_sys 20
    pl_CloseMessage
    pl_ApplyMovement 1, P342_04F0
    pl_WaitMovement
    pl_msg_sys 21
    pl_GoTo P342_036C

P342_0354:
    pl_msg_sys 22
    pl_CloseMessage
    pl_ApplyMovement 1, P342_04F0
    pl_WaitMovement
    pl_msg_sys 23
    pl_GoTo P342_036C

P342_036C:
    pl_CloseMessage
    pl_ApplyMovement 1, P342_047C
    pl_WaitMovement
    pl_RemoveObject 4, PFLAG_0194
    pl_WaitTime 15, PVAR_800C
    pl_ApplyMovement 1, P342_0484
    pl_ApplyMovement 5, P342_0584
    pl_ApplyMovement PL_PLAYER, P342_0614
    pl_WaitMovement
    pl_RemoveObject 1, PFLAG_01B2
    VMCall C205_42_S42  // CallCommonScript 2041 (Pearl file 205 script 42)
    pl_BufferRivalName 0
    pl_msg_sys 24
    pl_CloseMessage
    pl_ApplyMovement 5, P342_0590
    pl_ApplyMovement PL_PLAYER, P342_0620
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_sys 25
    pl_CloseMessage
    pl_ClearFlag PFLAG_0196
    pl_ClearFlag PFLAG_0197
    pl_SetVarFromValue PVAR_4095, 1
    pl_SetVarFromValue PVAR_4082, 2
    pl_ClearFlag PFLAG_01B3
    pl_SetVarFromValue PVAR_4086, 2
    pl_SetVarFromValue PVAR_40A4, 3
    pl_ApplyMovement 5, P342_05A8
    pl_ApplyMovement PL_PLAYER, P342_0634
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 7  // the rest of this Pearl script runs there (continuation 7)
    pl_Warp 456, 81, 842, 1  // Pearl map 334 (MAP_VERITY_LAKEFRONT)
    pl_ReleaseAll
    pl_End

P342_S4:
P342_0660:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_00B8
    pl_GoToIf 1, P342_0685
    pl_SetFlag PFLAG_00B8
    pl_BufferPlayerName 0
    pl_msg_talk 26
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P342_0685:
    pl_BufferPlayerName 0
    pl_msg_talk 27
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P342_S5:
P342_0693:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P342_06B2
    pl_GoTo P342_06BE

P342_06B2:
    pl_BufferPlayerName 0
    pl_msg_talk 28
    pl_GoTo P342_06CA

P342_06BE:
    pl_BufferPlayerName 0
    pl_msg_talk 29
    pl_GoTo P342_06CA

P342_06CA:
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P342_S6:
P342_06D2:
    pl_End

P342_S7:
P342_06D4:
    pl_End

    .balign 4, 0
P342_0428:
    Move 63, 1  // DELAY_8
    Move 12, 9  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P342_0434:
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_043C:
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P342_0444:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 2  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P342_0454:
    Move 13, 5  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 4  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_0464:
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P342_0470:
    Move 63, 1  // DELAY_8
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_047C:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_0484:
    Move 13, 4  // WALK_NORMAL_SOUTH
    Move 14, 2  // WALK_NORMAL_WEST
    Move 13, 5  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_0494:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 5  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 3  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_04A8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 62, 1  // DELAY_4
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 62, 1  // DELAY_4
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    MoveEnd

    .balign 4, 0
P342_04D0:
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P342_04DC:
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 15, 2  // WALK_NORMAL_EAST
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_04F0:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 1  // DELAY_8
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 62, 1  // DELAY_4
    MoveEnd

    .balign 4, 0
P342_050C:
    Move 16, 1  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P342_0514:
    Move 63, 10  // DELAY_8
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_0524:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_0530:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P342_0538:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_0540:
    Move 12, 5  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_0564:
    Move 39, 1  // WALK_ON_SPOT_FAST_EAST
    MoveEnd

    .balign 4, 0
P342_056C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_0574:
    Move 63, 7  // DELAY_8
    Move 15, 1  // WALK_NORMAL_EAST
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_0584:
    Move 62, 1  // DELAY_4
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_0590:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P342_05A0:
    Move 37, 1  // WALK_ON_SPOT_FAST_SOUTH
    MoveEnd

    .balign 4, 0
P342_05A8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 3  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P342_05C4:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P342_05CC:
    Move 63, 10  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P342_05D8:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 5  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 4  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P342_05F4:
    Move 63, 5  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 2  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P342_060C:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_0614:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P342_0620:
    Move 63, 1  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

    .balign 4, 0
P342_062C:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P342_0634:
    Move 63, 1  // DELAY_8
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 13, 4  // WALK_NORMAL_SOUTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 13, 6  // WALK_NORMAL_SOUTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P342_0650:
    Move 16, 6  // WALK_FAST_NORTH
    MoveEnd

    .balign 4, 0
P342_0658:
    Move 18, 7  // WALK_FAST_WEST
    MoveEnd

// ---- continuation 8: after the Warp at 379:0108 (MAP_VERITY_LAKEFRONT)
W379_0108_S:
W379_0108_0114:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

// ---- Pearl global script 205:41 (a subroutine here)
C205_41_S41:
C205_41_14CD:
    pl_FadeOutBGM 1  // StopMusic
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, C205_41_14F3
    pl_CompareVarToValue PVAR_800C, 1
    pl_CallIf 1, C205_41_14F9
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_41_14F3:
    #ifdef SEQ_PEARL_THE_GIRL
        pl_PlayMusic SEQ_PEARL_THE_GIRL  // Pearl SEQ_THE_GIRL
    #else
        pl_PlayMusic SEQ_BGM_E_BERU  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_Return

C205_41_14F9:
    #ifdef SEQ_PEARL_THE_BOY
        pl_PlayMusic SEQ_PEARL_THE_BOY  // Pearl SEQ_THE_BOY
    #else
        pl_PlayMusic SEQ_BGM_E_BERU  // Black 2 stand-in (a build without sinnoh_music)
    #endif
    pl_Return

// ---- Pearl global script 205:42 (a subroutine here)
C205_42_S42:
C205_42_1517:
    pl_FadeOutBGM 30  // FadeOutBGM to volume 0
    pl_FadeOutBGM 1  // StopMusic
    pl_PlayDefaultMusic
    pl_ReturnCommonScript
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
