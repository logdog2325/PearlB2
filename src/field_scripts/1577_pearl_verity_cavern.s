// MAP_VERITY_CAVERN: Pearl script file 344, text bank 272. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P344_S1
    ScriptEntry P344_S2
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P344_S1:
P344_000A:
    pl_SetFlag PFLAG_09DF
    pl_End

P344_S2:
P344_0010:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_stub DrawPokemonPreview  // Pearl 0x208 ShowPokemonPic 481, 0: not translated yet
    pl_WaitABPress
    pl_stub RemovePokemonPreview  // Pearl 0x209 Unk0209 : not translated yet
    pl_PlayCry 481
    pl_msg_talk 0
    pl_CloseMessage
    pl_SetFlag PFLAG_01FD
    pl_RemoveObject 0, PFLAG_01FD
    pl_WaitTime 8, PVAR_800C
    pl_ClearFlag PFLAG_01FD
    pl_AddObject 0
    pl_WaitTime 8, PVAR_800C
    pl_SetFlag PFLAG_01FD
    pl_RemoveObject 0, PFLAG_01FD
    pl_WaitTime 8, PVAR_800C
    pl_ClearFlag PFLAG_01FD
    pl_AddObject 0
    pl_WaitTime 8, PVAR_800C
    pl_SetFlag PFLAG_01FD
    pl_RemoveObject 0, PFLAG_01FD
    pl_WaitTime 8, PVAR_800C
    pl_ClearFlag PFLAG_01FD
    pl_AddObject 0
    pl_WaitTime 8, PVAR_800C
    pl_SetFlag PFLAG_01FD
    pl_RemoveObject 0, PFLAG_01FD
    pl_stub ActivateRoamingPokemon  // Pearl 0x21C CreateRoamer 0: not translated yet
    pl_msg_talk 1
    pl_CloseMessage
    pl_WaitTime 30, PVAR_800C
    pl_GetPlayerDir PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P344_00D1
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P344_00E1
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, P344_00F1
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, P344_0101
    pl_End

P344_00D1:
    pl_SetObjectEventPosLater 0, 1, 12, 1, 22, 0  // SetObjectEventPos 1 (the live actor; and where AddObject puts it)
    pl_GoTo P344_0111

P344_00E1:
    pl_SetObjectEventPosLater 0, 1, 12, 1, 20, 0  // SetObjectEventPos 1 (the live actor; and where AddObject puts it)
    pl_GoTo P344_0111

P344_00F1:
    pl_SetObjectEventPosLater 0, 1, 13, 1, 21, 0  // SetObjectEventPos 1 (the live actor; and where AddObject puts it)
    pl_GoTo P344_0111

P344_0101:
    pl_SetObjectEventPosLater 0, 1, 11, 1, 21, 0  // SetObjectEventPos 1 (the live actor; and where AddObject puts it)
    pl_GoTo P344_0111

P344_0111:
    pl_ClearFlag PFLAG_02B4
    pl_AddObjectAt 1, 0, 0  // at its SetObjectEventPos
    pl_ApplyMovement 1, P344_0178
    pl_WaitMovement
    pl_ApplyMovement PL_PLAYER, P344_0198
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_talk 2
    pl_CloseMessage
    pl_ApplyMovement 1, P344_0180
    pl_WaitMovement
    pl_BufferPlayerName 0
    pl_msg_talk 3
    pl_CheckPoketchAppRegistered 12, PVAR_800C  // Marking Map
    pl_CompareVarToValue PVAR_800C, 0
    pl_CallIf 1, P344_0172
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5
    pl_CloseMessage
    pl_ApplyMovement 1, P344_0190
    pl_WaitMovement
    pl_RemoveObject 1, PFLAG_02B4
    pl_ReleaseAll
    pl_End

P344_0172:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4
    pl_Return

    .balign 4, 0
P344_0178:
    Move 12, 7  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P344_0180:
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 2  // DELAY_8
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P344_0190:
    Move 13, 9  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P344_0198:
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
