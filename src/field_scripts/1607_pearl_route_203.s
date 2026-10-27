// MAP_ROUTE_203: Pearl script file 394, text bank 417. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-6: Pearl's; no warp continuations; 7: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P394_S1
    ScriptEntry P394_S2
    ScriptEntry P394_S3
    ScriptEntry P394_S4
    ScriptEntry P394_S5
    ScriptEntry P394_S6
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P394_S1:
P394_001A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P394_S2:
P394_002D:
    pl_sign 3, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P394_S3:
P394_0044:
    pl_sign 4, 3  // Pearl sign type 1
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    WorkSetConst PVAR_800C, 0  // GetSignpostInput: Black 2's sign closes on A/B
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P394_S4:
P394_005B:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 5, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P394_S5:
P394_0070:
// DrawSignpostTextBox type 3 (the window opens with the next sign message)
// SetSignpostCommand: done by pl_sign
// WaitForSignpostDone: done by pl_sign
    pl_sign 6, 0  // Pearl sign type 3
// CallCommonScript 2000 (Pearl closes the sign; X opens the menu): done by pl_sign
    pl_End

P394_S6:
P394_0085:
    pl_LockAll
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 757
    pl_GoToIf 1, P394_00C7
    pl_CompareVarToValue PVAR_8005, 758
    pl_GoToIf 1, P394_00D7
    pl_CompareVarToValue PVAR_8005, 759
    pl_GoToIf 1, P394_00E7
    pl_CompareVarToValue PVAR_8005, 760
    pl_GoToIf 1, P394_00F7
    pl_End

P394_00C7:
    pl_ApplyMovement 5, P394_0224
    pl_WaitMovement
    pl_GoTo P394_0107

P394_00D7:
    pl_ApplyMovement 5, P394_0230
    pl_WaitMovement
    pl_GoTo P394_0107

P394_00E7:
    pl_ApplyMovement 5, P394_0244
    pl_WaitMovement
    pl_GoTo P394_0107

P394_00F7:
    pl_ApplyMovement 5, P394_0258
    pl_WaitMovement
    pl_GoTo P394_0107

P394_0107:
    pl_BufferRivalName 0
    pl_BufferPlayerName 1
    pl_msg_sys 0
    pl_CloseMessage
    pl_GetPlayerStarterSpecies PVAR_800C
    pl_CompareVarToValue PVAR_800C, 387
    pl_GoToIf 1, P394_0142
    pl_CompareVarToValue PVAR_800C, 390
    pl_GoToIf 1, P394_014E
    pl_GoTo P394_0136

P394_0136:
    pl_StartTrainerBattle PTRAINER_247, 0
    pl_GoTo P394_015A

P394_0142:
    pl_StartTrainerBattle PTRAINER_248, 0
    pl_GoTo P394_015A

P394_014E:
    pl_StartTrainerBattle PTRAINER_249, 0
    pl_GoTo P394_015A

P394_015A:
    pl_CheckWonBattle PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P394_01FD
    pl_BufferRivalName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8005, 757
    pl_GoToIf 1, P394_01AF
    pl_CompareVarToValue PVAR_8005, 758
    pl_GoToIf 1, P394_01BF
    pl_CompareVarToValue PVAR_8005, 759
    pl_GoToIf 1, P394_01CF
    pl_CompareVarToValue PVAR_8005, 760
    pl_GoToIf 1, P394_01DF
    pl_End

P394_01AF:
    pl_ApplyMovement 5, P394_0204
    pl_WaitMovement
    pl_GoTo P394_01EF

P394_01BF:
    pl_ApplyMovement 5, P394_020C
    pl_WaitMovement
    pl_GoTo P394_01EF

P394_01CF:
    pl_ApplyMovement 5, P394_0214
    pl_WaitMovement
    pl_GoTo P394_01EF

P394_01DF:
    pl_ApplyMovement 5, P394_021C
    pl_WaitMovement
    pl_GoTo P394_01EF

P394_01EF:
    pl_RemoveObject 5, PFLAG_0199
    pl_SetVarFromValue PVAR_4088, 1
    pl_ReleaseAll
    pl_End

P394_01FD:
    pl_BlackOutFromBattle
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P394_0204:
    Move 19, 10  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P394_020C:
    Move 19, 10  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P394_0214:
    Move 19, 10  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P394_021C:
    Move 19, 10  // WALK_FAST_EAST
    MoveEnd

    .balign 4, 0
P394_0224:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 4  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P394_0230:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 2  // WALK_FAST_WEST
    Move 17, 1  // WALK_FAST_SOUTH
    Move 18, 2  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P394_0244:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 2  // WALK_FAST_WEST
    Move 17, 2  // WALK_FAST_SOUTH
    Move 18, 2  // WALK_FAST_WEST
    MoveEnd

    .balign 4, 0
P394_0258:
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    Move 18, 2  // WALK_FAST_WEST
    Move 17, 3  // WALK_FAST_SOUTH
    Move 18, 2  // WALK_FAST_WEST
    MoveEnd

// ---- Pearl global script 205:43 (a subroutine here)
C205_43_S43:
C205_43_14FF:
    pl_FadeOutBGM 1  // StopMusic
    #ifdef SEQ_PEARL_THE_RIV
        pl_PlayMusic SEQ_PEARL_THE_RIV  // Pearl SEQ_THE_RIV
    #else
        pl_PlayMusic SEQ_BGM_E_HUE  // Black 2 stand-in (a build without sinnoh_music)
    #endif
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
