// MAP_CANALAVE_MOVE_DELETER_HOUSE: Pearl script file 44, text bank 55. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P44_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P44_S1:
P44_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0001
    pl_GoToIf 1, P44_0026
    pl_msg_talk 0
    pl_SetFlag PFLAG_0001
    pl_GoTo P44_0026

P44_0026:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P44_0049
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P44_0130
    pl_End

P44_0049:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_CloseMessage
    pl_GoTo P44_0054

P44_0054:
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2's party select (CallPokeSelect)
    pl_GetSelectedPartySlot PVAR_8002  // the slot, 255 when cancelled (as Pearl)
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_8002, 255
    pl_GoToIf 1, P44_0130
    pl_GetPartyMonSpecies PVAR_8002, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 0
    pl_GoToIf 1, P44_011A
    pl_stub GetPartyMonMoveCount  // Pearl 0x1C8 CountPartyMonMoves 32780, 32770: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P44_0125
    pl_msg_talk 6
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub SelectPartyMonMove  // Pearl 0x1C6 Unk01C6 32770: not translated yet
    pl_stub GetSelectedPartyMonMove  // Pearl 0x1C7 Unk01C7 32769: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_8001, 255
    pl_GoToIf 1, P44_0049
    pl_stub BufferPartyMoveName  // Pearl 0x1CB GetPokemonMoveName 0, 32770, 32769: not translated yet
    pl_msg_talk 7
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P44_0105
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P44_0049
    pl_End

P44_0105:
    pl_stub ClearPartyMonMoveSlot  // Pearl 0x1C9 ForgetPartyMonMove 32770, 32769: not translated yet
    pl_msg_talk 8
    pl_PlayFanfare SEQ_ME_WASURE  // Pearl SEQ_WASURE
    pl_WaitFanfare
    pl_WaitButton
    pl_CloseMessage
    pl_End

P44_011A:
    pl_msg_talk 5
    pl_CloseMessage
    pl_GoTo P44_0054

P44_0125:
    pl_msg_talk 4
    pl_CloseMessage
    pl_GoTo P44_0054

P44_0130:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
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
