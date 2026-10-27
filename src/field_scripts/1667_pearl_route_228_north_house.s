// MAP_ROUTE_228_NORTH_HOUSE: Pearl script file 458, text bank 478. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P458_S1
    ScriptEntry P458_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P458_S1:
P458_000A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0108
    pl_GoToIf 1, P458_003B
    pl_SetFlag PFLAG_0108
    pl_msg_talk 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P458_0055
    pl_GoTo P458_028F

P458_003B:
    pl_msg_talk 1
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P458_0055
    pl_GoTo P458_028F

P458_0055:
    pl_msg_talk 2
    pl_CloseMessage
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_ChoosePokemonMenu  // ChoosePokemonMenu: Black 2's party select (CallPokeSelect)
    pl_GetSelectedPartySlot PVAR_8000  // the slot, 255 when cancelled (as Pearl)
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_8000, 255
    pl_GoToIf 1, P458_028F
    pl_GetPartyMonSpecies PVAR_8000, PVAR_8001
    pl_CompareVarToValue PVAR_8001, 0
    pl_GoToIf 1, P458_02A5
    pl_Call P458_0195
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P458_029A
    pl_SetVarFromVar PVAR_8002, PVAR_800C
    pl_Call P458_0251
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P458_02BB
    PokePartyGetHappiness PVAR_800C, PVAR_8000
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 0, P458_02B0
    pl_BufferPartyMonSpecies 0, PVAR_8000
    pl_CompareVarToValue PVAR_8002, 1
    pl_GoToIf 1, P458_00FE
    pl_CompareVarToValue PVAR_8002, 2
    pl_GoToIf 1, P458_011E
    pl_GoTo P458_013E

P458_00FE:
    pl_msg_talk 9
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P458_028F
    pl_SetVarFromValue PVAR_8003, 307
    pl_GoTo P458_015E

P458_011E:
    pl_msg_talk 10
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P458_028F
    pl_SetVarFromValue PVAR_8003, 308
    pl_GoTo P458_015E

P458_013E:
    pl_msg_talk 11
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P458_028F
    pl_SetVarFromValue PVAR_8003, 338
    pl_GoTo P458_015E

P458_015E:
    pl_CloseMessage
// FadeScreen 6, 1, 0, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_OpenMoveTutorMenu PVAR_8000, PVAR_8003, 19, 20, 21, 22, 23, 24, 25, 26
    pl_CheckLearnedTutorMove PVAR_800C
// RestoreOverworld: Black 2's party select reopened the field itself
// FadeScreen 6, 1, 1, 0x0: Black 2's party select fades itself
    pl_WaitFadeScreen
    pl_CompareVarToValue PVAR_800C, 255
    pl_GoToIf 1, P458_028F
    pl_ReleaseAll
    pl_End

P458_0195:
    pl_CompareVarToValue PVAR_8001, 6
    pl_GoToIf 1, P458_0239
    pl_CompareVarToValue PVAR_8001, 157
    pl_GoToIf 1, P458_0239
    pl_CompareVarToValue PVAR_8001, 257
    pl_GoToIf 1, P458_0239
    pl_CompareVarToValue PVAR_8001, 392
    pl_GoToIf 1, P458_0239
    pl_CompareVarToValue PVAR_8001, 9
    pl_GoToIf 1, P458_0241
    pl_CompareVarToValue PVAR_8001, 160
    pl_GoToIf 1, P458_0241
    pl_CompareVarToValue PVAR_8001, 260
    pl_GoToIf 1, P458_0241
    pl_CompareVarToValue PVAR_8001, 395
    pl_GoToIf 1, P458_0241
    pl_CompareVarToValue PVAR_8001, 3
    pl_GoToIf 1, P458_0249
    pl_CompareVarToValue PVAR_8001, 154
    pl_GoToIf 1, P458_0249
    pl_CompareVarToValue PVAR_8001, 254
    pl_GoToIf 1, P458_0249
    pl_CompareVarToValue PVAR_8001, 389
    pl_GoToIf 1, P458_0249
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

P458_0239:
    pl_SetVarFromValue PVAR_800C, 1
    pl_Return

P458_0241:
    pl_SetVarFromValue PVAR_800C, 2
    pl_Return

P458_0249:
    pl_SetVarFromValue PVAR_800C, 3
    pl_Return

P458_0251:
    pl_CompareVarToValue PVAR_8002, 1
    pl_GoToIf 1, P458_0271
    pl_CompareVarToValue PVAR_8002, 2
    pl_GoToIf 1, P458_027B
    pl_GoTo P458_0285

P458_0271:
    PokePartyHasMove PVAR_800C, 307, PVAR_8000  // PartyMonHasMove
    pl_Return

P458_027B:
    PokePartyHasMove PVAR_800C, 308, PVAR_8000  // PartyMonHasMove
    pl_Return

P458_0285:
    PokePartyHasMove PVAR_800C, 338, PVAR_8000  // PartyMonHasMove
    pl_Return

P458_028F:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P458_029A:
    pl_msg_talk 5
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P458_02A5:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P458_02B0:
    pl_msg_talk 7
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P458_02BB:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P458_S2:
P458_02C6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 18
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
