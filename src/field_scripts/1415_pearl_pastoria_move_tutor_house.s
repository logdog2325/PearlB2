// MAP_PASTORIA_MOVE_TUTOR_HOUSE: Pearl script file 128, text bank 132. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P128_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P128_S1:
P128_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WordSetItemNameWithArticle 4, 93
    pl_CheckFlag PFLAG_00E9
    pl_GoToIf 0, P128_0039
    pl_CheckItem 93, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P128_005B
    pl_GoTo P128_0066

P128_0039:
    pl_SetFlag PFLAG_00E9
    pl_msg_talk 0
    pl_CheckItem 93, 1, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P128_005B
    pl_GoTo P128_0066

P128_005B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P128_0066:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 1
    pl_msg_talk 3
    pl_CloseMessage
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2's party select (CallPokeSelect)
    pl_GetSelectedPartySlot PVAR_8005  // the slot, 255 when cancelled (as Pearl)
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_8005, 255
    pl_GoToIf 1, P128_005B
    pl_GetPartyMonSpecies PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P128_0116
    pl_stub CheckHasLearnableReminderMoves  // Pearl 0x21F Unk021F 32780, 32773: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P128_010B
    pl_msg_talk 4
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub OpenMoveReminderMenu  // Pearl 0x221 Unk0221 32773: not translated yet
    pl_stub CheckLearnedReminderMove  // Pearl 0x223 Unk0223 32780: not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P128_005B
    pl_RemoveItem 93, 1, PVAR_800C
    pl_BufferPlayerName 3
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P128_010B:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P128_0116:
    pl_msg_talk 6
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
