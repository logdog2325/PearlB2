// MAP_VEILSTONE_MASSAGE_GIRL_HOUSE: Pearl script file 148, text bank 151. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P148_S1
    ScriptEntry P148_S2
    ScriptEntry P148_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P148_S1:
P148_000E:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0AAC
    pl_GoToIf 1, P148_00D5
    pl_msg_talk 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P148_00EB
    pl_msg_talk 1
    pl_CloseMessage
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2's party select (CallPokeSelect)
    pl_GetSelectedPartySlot PVAR_4000  // the slot, 255 when cancelled (as Pearl)
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_4000, 255
    pl_GoToIf 1, P148_00EB
    pl_GetPartyMonSpecies PVAR_4000, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P148_00E0
    pl_msg_talk 3
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_FW367: no Black 2 sound chosen yet
    pl_stub WaitSE  // Pearl sound SEQ_SE_DP_FW367: no Black 2 sound chosen yet
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_BufferPartyMonNickname 0, PVAR_4000
    pl_msg_talk 4
    pl_SetFlag PFLAG_0AAC
    PokePartyAdjustHappiness PVAR_4000, 3, 1  // AddPartyMonFriendship
    WorkSetConst PVAR_8004, 65535  // Unk026C: no Accessory (no Super Contests)
    pl_CompareVarToValue PVAR_8004, 65535
    pl_GoToIf 1, P148_00F6
    pl_msg_talk 7
    pl_SetVarFromValue PVAR_8005, 1
    VMCall C205_48_S48  // CallCommonScript 2047 (Pearl file 205 script 48)
    pl_GoTo P148_00F6

P148_00D5:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P148_00E0:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P148_00EB:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P148_00F6:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P148_S2:
P148_0101:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P148_S3:
P148_0114:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 417
    pl_msg_talk 10
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

// ---- Pearl global script 205:48 (a subroutine here)
C205_48_S48:
C205_48_0915:
    pl_Call C205_48_0922
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 11  // Pearl bank 199 line 127 (the Accessory from PVAR_8004: not known here)
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_48_0922:
    pl_PlayFanfare SEQ_ME_ACCE  // Pearl SEQ_ACCE
// AddAccessory 32772, 32773: nothing in Black 2 (no Super Contests (closed at first: DECISIONS.md))
// BufferAccessoryName 0, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 12  // Pearl bank 199 line 25 (the Accessory from PVAR_8004: not known here)
    pl_WaitFanfare
    pl_BufferPlayerName 0
// BufferAccessoryName 1, PVAR_8004: the lines naming the Accessory have its name written in (Black 2 has no word for it: NAME_SOURCES)
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
