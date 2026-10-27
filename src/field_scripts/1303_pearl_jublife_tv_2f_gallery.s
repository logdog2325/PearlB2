// MAP_JUBLIFE_TV_2F_GALLERY: Pearl script file 15, text bank 29. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-14: Pearl's; no warp continuations; 15: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P15_S1
    ScriptEntry P15_S2
    ScriptEntry P15_S3
    ScriptEntry P15_S4
    ScriptEntry P15_S5
    ScriptEntry P15_S6
    ScriptEntry P15_S7
    ScriptEntry P15_S8
    ScriptEntry P15_S9
    ScriptEntry P15_S10
    ScriptEntry P15_S11
    ScriptEntry P15_S12
    ScriptEntry P15_S13
    ScriptEntry P15_S14
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P15_S1:
P15_003A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_SetVarFromValue PVAR_8007, 0
    pl_CheckFlag PFLAG_0088
    pl_CallIf 0, P15_006F
    pl_CompareVarToValue PVAR_4001, 0
    pl_GoToIf 1, P15_0077
    pl_CompareVarToValue PVAR_4001, 1
    pl_GoToIf 1, P15_0080
    pl_End

P15_006F:
    pl_SetVarFromValue PVAR_8007, 1
    pl_Return

P15_0077:
    pl_msg_talk 1
    pl_GoTo P15_00B5

P15_0080:
    pl_msg_talk 11
    pl_GoTo P15_00B5

P15_0089:
    pl_msg_talk 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_00AC
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P15_00F5
    pl_End

P15_00AC:
    pl_msg_talk 6
    pl_GoTo P15_00D5

P15_00B5:
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_0089
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P15_02B5
    pl_End

P15_00D5:
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_00F5
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P15_02B5
    pl_End

P15_00F5:
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P15_0115
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 5, P15_0121
    pl_End

P15_0115:
    pl_SetVarFromValue PVAR_4002, 0
    pl_GoTo P15_016E

P15_0121:
    pl_msg_talk 4
    pl_WaitButton
    pl_CloseMessage
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2's party select (CallPokeSelect)
    pl_GetSelectedPartySlot PVAR_4002  // the slot, 255 when cancelled (as Pearl)
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_4002, 255
    pl_GoToIf 1, P15_02B5
    pl_GetPartyMonSpecies PVAR_4002, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_02C0
    pl_GoTo P15_016E

P15_016E:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_CloseMessage
    pl_GetPlayerDir PVAR_8006
    pl_CompareVarToValue PVAR_8006, 0
    pl_GoToIf 1, P15_01A0
    pl_CompareVarToValue PVAR_8006, 2
    pl_GoToIf 1, P15_01BA
    pl_CompareVarToValue PVAR_8006, 3
    pl_GoToIf 1, P15_01D4
    pl_End

P15_01A0:
    pl_ApplyMovement 0, P15_0374
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P15_0340
    pl_WaitMovement
    pl_GoTo P15_01EE

P15_01BA:
    pl_ApplyMovement 0, P15_0380
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P15_0348
    pl_WaitMovement
    pl_GoTo P15_01EE

P15_01D4:
    pl_ApplyMovement 0, P15_038C
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P15_0354
    pl_WaitMovement
    pl_GoTo P15_01EE

P15_01EE:
    pl_SetFlag PFLAG_0088
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 0A6  // Pearl 0x0A6 DressupPokemon 16386, 32773, 32775: not translated yet
    pl_ReturnToField
    pl_ApplyMovement PL_PLAYER, P15_0360
    pl_WaitMovement
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_8006, 0
    pl_GoToIf 1, P15_0247
    pl_CompareVarToValue PVAR_8006, 2
    pl_GoToIf 1, P15_0261
    pl_CompareVarToValue PVAR_8006, 3
    pl_GoToIf 1, P15_027B
    pl_End

P15_0247:
    pl_ApplyMovement PL_PLAYER, P15_0368
    pl_WaitMovement
    pl_ApplyMovement 0, P15_0398
    pl_WaitMovement
    pl_GoTo P15_0295

P15_0261:
    pl_ApplyMovement PL_PLAYER, P15_0368
    pl_WaitMovement
    pl_ApplyMovement 0, P15_03A4
    pl_WaitMovement
    pl_GoTo P15_0295

P15_027B:
    pl_ApplyMovement PL_PLAYER, P15_0368
    pl_WaitMovement
    pl_ApplyMovement 0, P15_03B0
    pl_WaitMovement
    pl_GoTo P15_0295

P15_0295:
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, P15_0333
    pl_SetVarFromValue PVAR_4001, 1
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo P15_02C9

P15_02B5:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P15_02C0:
    pl_msg_talk 13
    pl_GoTo P15_0121

P15_02C9:
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ChooseCustomMessageWord  // Pearl 0x243 Unk0243 0, 32780, 32772: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_0326
    pl_stub SetDressUpPhotoTitle  // Pearl 0x130 Unk0130 32772: not translated yet
    pl_stub BufferCustomMessageWord  // Pearl 0x245 Unk0245 0, 32772: not translated yet
    pl_msg_talk 8
    pl_WaitButton
    pl_ApplyMovement 0, P15_03BC
    pl_WaitMovement
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ApplyMovement 0, P15_03C4
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P15_0326:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo P15_02C9

P15_0333:
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P15_S2:
P15_03CC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 0, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 0, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S3:
P15_0409:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 1, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 1, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S4:
P15_0446:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 2, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 2, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S5:
P15_0483:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 3, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 3, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S6:
P15_04C0:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 4, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 4, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S7:
P15_04FD:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 5, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 5, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S8:
P15_053A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 6, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 6, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S9:
P15_0577:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 7, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 7, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S10:
P15_05B4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 8, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 8, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S11:
P15_05F1:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 9, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 9, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_S12:
P15_062E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_stub DressUpPhotoHasData  // Pearl 0x12E CheckPortraitSlot 10, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P15_066B
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDressUpPhoto  // Pearl 0x0A7 ShowDressedPokemon 10, 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P15_066B:
    pl_msg_sys 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P15_S13:
P15_0676:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P15_S14:
P15_0689:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P15_0340:
    Move 8, 2  // WALK_SLOW_NORTH
    MoveEnd

    .balign 4, 0
P15_0348:
    Move 10, 1  // WALK_SLOW_WEST
    Move 8, 1  // WALK_SLOW_NORTH
    MoveEnd

    .balign 4, 0
P15_0354:
    Move 11, 1  // WALK_SLOW_EAST
    Move 8, 1  // WALK_SLOW_NORTH
    MoveEnd

    .balign 4, 0
P15_0360:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P15_0368:
    Move 9, 2  // WALK_SLOW_SOUTH
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P15_0374:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P15_0380:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P15_038C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 2, 1  // FACE_WEST
    MoveEnd

    .balign 4, 0
P15_0398:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P15_03A4:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P15_03B0:
    Move 14, 1  // WALK_NORMAL_WEST
    Move 1, 1  // FACE_SOUTH
    MoveEnd

    .balign 4, 0
P15_03BC:
    Move 3, 1  // FACE_EAST
    MoveEnd

    .balign 4, 0
P15_03C4:
    Move 1, 1  // FACE_SOUTH
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
