// MAP_VALOR_LAKEFRONT_GRAND_LAKE_WEST_ROOM: Pearl script file 384, text bank 357. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P384_S1
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P384_S1:
P384_0006:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_CheckFlag PFLAG_0001
    pl_GoToIf 1, P384_00D3
    pl_CheckLocalDexCompleted PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P384_004C
    pl_CheckFlag PFLAG_00AB
    pl_GoToIf 0, P384_0057
    PokeDexIsComplete PVAR_800C, 1  // CheckNationalDexCompleted (Black 2's National Dex)
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P384_0057
    pl_GoTo P384_0095

P384_004C:
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P384_0057:
    pl_CheckFlag PFLAG_00AB
    pl_CallIf 0, P384_00DE
    pl_SetFlag PFLAG_00AB
    pl_SetFlag PFLAG_0001
    pl_msg_talk 1
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDiplomaSinnoh  // Pearl 0x1EA RegisterSinnohPokedex : not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P384_0095:
    pl_CheckFlag PFLAG_00AC
    pl_CallIf 0, P384_00E4
    pl_SetFlag PFLAG_00AC
    pl_SetFlag PFLAG_0001
    pl_msg_talk 2
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_WaitFanfare
    pl_CloseMessage
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub ShowDiplomaNationalDex  // Pearl 0x1EB RegisterNationalPokedex : not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_ReleaseAll
    pl_End

P384_00D3:
    pl_msg_talk 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P384_00DE:
// IncrementTrainerScore2 26: nothing in Black 2 (Pearl's trainer-card score (Black 2 keeps its own records))
    pl_Return

P384_00E4:
// IncrementTrainerScore2 27: nothing in Black 2 (Pearl's trainer-card score (Black 2 keeps its own records))
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
