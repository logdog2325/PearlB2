// MAP_HEARTHOME_SOUTHEAST_HOUSE_1F: Pearl script file 100, text bank 106. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; 3: after a Warp; 4: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P100_S1
    ScriptEntry P100_S2
    ScriptEntry W102_0082_S
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P100_S1:
P100_000A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P100_S2:
P100_001D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

// ---- continuation 3: after the Warp at 102:0082 (MAP_HEARTHOME_SOUTHEAST_HOUSE_ELEVATOR)
W102_0082_S:
W102_0082_008E:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_End

PearlElevatorInit:                // zone init (after Pearl's): an elevator (ELEVATOR_FLOORS_ABOVE)
    WorkSetConst PVAR_40CE, 1  // this floor's floors above (an elevator reads it)
    VMHalt

PearlNoScript:
    VMHalt

PearlArrive:                      // arriving by a script warp with nothing after it: fade in, release
    FadeInBlack
    FadeWait
    FinishAllEvents
    ActorsUnpauseAll
    VMHalt

    .balign 4, 0
