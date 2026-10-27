// MAP_ROUTE_210_GRANDMA_WILMA_HOUSE: Pearl script file 415, text bank 435. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P415_S1
    ScriptEntry P415_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P415_S1:
P415_000A:
    pl_SetFlag PFLAG_09EA
    pl_End

P415_S2:
P415_0010:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0100
    pl_GoToIf 1, P415_0041
    pl_SetFlag PFLAG_0100
    pl_msg_talk 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P415_005B
    pl_GoTo P415_00A2

P415_0041:
    pl_msg_talk 1
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P415_005B
    pl_GoTo P415_00A2

P415_005B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P415_0066:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P415_0071:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P415_007C:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P415_0087:
    pl_BufferMoveName 0, 434
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P415_0097:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P415_00A2:
    pl_GetPartyCount PVAR_4000

P415_00A6:
    pl_SubVar PVAR_4000, 1
    pl_GetPartyMonSpecies PVAR_4000, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P415_00FC
    pl_GetPartyMonTypes PVAR_8004, PVAR_8005, PVAR_4000
    pl_CompareVarToValue PVAR_8004, 16
    pl_GoToIf 1, P415_00E7
    pl_CompareVarToValue PVAR_8005, 16
    pl_GoToIf 1, P415_00E7
    pl_GoTo P415_00FC

P415_00E7:
    PokePartyHasMove PVAR_800C, 434, PVAR_4000  // PartyMonHasMove
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P415_010F

P415_00FC:
    pl_CompareVarToValue PVAR_4000, 0
    pl_GoToIf 5, P415_00A6
    pl_GoTo P415_0066

P415_010F:
    pl_msg_talk 4
    pl_WaitABPress
    pl_CloseMessage
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2's party select (CallPokeSelect)
    pl_GetSelectedPartySlot PVAR_8000  // the slot, 255 when cancelled (as Pearl)
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_8000, 255
    pl_GoToIf 1, P415_005B
    pl_GetPartyMonSpecies PVAR_8000, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 0
    pl_GoToIf 1, P415_007C
    pl_Call P415_01D9
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P415_0071
    PokePartyHasMove PVAR_800C, 434, PVAR_8000  // PartyMonHasMove
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P415_0087
    PokePartyGetHappiness PVAR_800C, PVAR_8000
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 0, P415_0097
    pl_SetVarFromValue PVAR_8003, 434
    pl_GoTo P415_019D

P415_019D:
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_OpenMoveTutorMenu PVAR_8000, 434, 17, 18, 19, 20, 21, 22, 23, 24
    pl_CheckLearnedTutorMove PVAR_800C
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P415_005B
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P415_01D9:
    pl_GetPartyMonTypes PVAR_8004, PVAR_8005, PVAR_8000
    pl_CompareVarToValue PVAR_8004, 16
    pl_GoToIf 1, P415_0203
    pl_CompareVarToValue PVAR_8005, 16
    pl_GoToIf 1, P415_0203
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

P415_0203:
    pl_SetVarFromValue PVAR_800C, 1
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
