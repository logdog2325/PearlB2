// MAP_TWINLEAF_PLAYER_HOUSE_2F: Pearl script file 980, text bank 500. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; no warp continuations; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P980_S1
    ScriptEntry P980_S2
    ScriptEntry P980_S3
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P980_S1:
P980_000E:
    pl_LockAll
    pl_BufferRivalName 0
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 0, P980_0060
    pl_WaitMovement
    VMCall C205_43_S43  // CallCommonScript 2042 (Pearl file 205 script 43)
    pl_BufferPlayerName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement 0, P980_006C
    pl_ApplyMovement PL_PLAYER, P980_0084
    pl_WaitMovement
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_RemoveObject 0, PFLAG_0210
    VMCall C205_44_S44  // CallCommonScript 2043 (Pearl file 205 script 44)
    pl_SetFlag PFLAG_00EA
    pl_SetVarFromValue PVAR_40A3, 1
    pl_SetVarFromValue PVAR_4070, 2
    pl_ReleaseAll
    pl_End

P980_S2:
P980_0094:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P980_S3:
P980_00A5:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P980_0060:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    Move 75, 1  // EMOTE_EXCLAMATION_MARK
    MoveEnd

    .balign 4, 0
P980_006C:
    Move 18, 4  // WALK_FAST_WEST
    Move 16, 1  // WALK_FAST_NORTH
    Move 18, 2  // WALK_FAST_WEST
    Move 38, 1  // WALK_ON_SPOT_FAST_WEST
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P980_0084:
    Move 63, 2  // DELAY_8
    Move 13, 1  // WALK_NORMAL_SOUTH
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
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

// ---- Pearl global script 205:44 (a subroutine here)
C205_44_S44:
C205_44_1517:
    pl_FadeOutBGM 30  // FadeOutBGM to volume 0
    pl_FadeOutBGM 1  // StopMusic
    pl_PlayDefaultMusic
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
