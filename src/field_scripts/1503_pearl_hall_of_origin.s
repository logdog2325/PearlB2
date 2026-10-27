// MAP_HALL_OF_ORIGIN: Pearl script file 232, text bank 221. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; 5: after a Warp; 6: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P232_S1
    ScriptEntry P232_S2
    ScriptEntry P232_S3
    ScriptEntry P232_S4
    ScriptEntry W205_1493_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P232_S3:
P232_0012:
    pl_End

P232_S1:
P232_0014:
    pl_CheckFlag PFLAG_008E
    pl_GoToIf 1, P232_0021
    pl_End

P232_0021:
    pl_SetFlag PFLAG_026C
    pl_RemoveObject 0, PFLAG_026C
    pl_ClearFlag PFLAG_008E
    pl_End

P232_S2:
P232_S4:
P232_002F:
    pl_LockAll
    pl_SetVarFromValue PVAR_4118, 0
    pl_Call P232_00AD
    pl_Call P232_00C8
    pl_PlayCry 493
    pl_WaitCry
    pl_Call P232_0133
    pl_PlayCry 493
    pl_msg_sys 0
    pl_CloseMessage
    pl_SetFlag PFLAG_008E
    pl_StartWildBattle 493, 80
    pl_ClearFlag PFLAG_008E
    pl_CheckWonWildBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P232_00A3
    pl_CheckDidNotCapture PVAR_800C  // Pearl 0x2BC: 1 unless caught
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P232_0094
    pl_SetFlag PFLAG_011E
    pl_ReleaseAll
    pl_End

P232_0094:
    pl_msg_sys 1
    pl_WaitButton
    pl_CloseMessage
    pl_ClearFlag PFLAG_026C
    pl_ReleaseAll
    pl_End

P232_00A3:
    pl_ClearFlag PFLAG_026C
    pl_BlackOutFromWildBattle
    pl_ReleaseAll
    pl_End

P232_00AD:
    pl_ApplyMovement PL_PLAYER, P232_00BC
    pl_WaitMovement
    pl_Return

P232_00C8:
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_SetVarFromVar PVAR_8008, PVAR_8004
    pl_CompareVarToValue PVAR_8008, 30
    pl_GoToIf 1, P232_00FD
    pl_CompareVarToValue PVAR_8008, 31
    pl_GoToIf 1, P232_010F
    pl_CompareVarToValue PVAR_8008, 32
    pl_GoToIf 1, P232_0121

P232_00FB:
    pl_Return

P232_00FD:
    pl_ApplyMovement PL_PLAYER, P232_0140
    pl_WaitMovement
    pl_GoTo P232_00FB

P232_010F:
    pl_ApplyMovement PL_PLAYER, P232_0150
    pl_WaitMovement
    pl_GoTo P232_00FB

P232_0121:
    pl_ApplyMovement PL_PLAYER, P232_0158
    pl_WaitMovement
    pl_GoTo P232_00FB

P232_0133:
    pl_ApplyMovement PL_PLAYER, P232_0168
    pl_WaitMovement
    pl_Return

    .balign 4, 0
P232_00BC:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 65, 1  // DELAY_16
    MoveEnd

    .balign 4, 0
P232_0140:
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P232_0150:
    Move 12, 4  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P232_0158:
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 14, 1  // WALK_NORMAL_WEST
    Move 0, 1  // FACE_NORTH
    MoveEnd

    .balign 4, 0
P232_0168:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

// ---- continuation 5: after the Warp at 205:1493 (a common script)
W205_1493_S:
W205_1493_149F:
    pl_fade_in_white  // FadeScreen 6, 6, 1, 0x7fff
    pl_WaitFadeScreen
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2  // Pearl bank 199 line 124
    pl_WaitButton
    pl_CloseMessage
    pl_SetVarFromValue PVAR_4098, 4
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
