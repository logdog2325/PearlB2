// MAP_HEARTHOME_GYM_FOURTH_QUESTION_ROOM: Pearl script file 95, text bank 103. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P95_S1
    ScriptEntry P95_S2
    ScriptEntry P95_S3
    ScriptEntry P95_S4
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P95_S1:
P95_0012:
// InitPersistedMapFeaturesForHearthomeGym: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_End

P95_S2:
P95_0016:
// MoveHearthomeGymDPLift: gimmick 59 does it (decomp src/pearlb2/pearl_platforms_itcm.c)
    pl_End

P95_S3:
P95_001A:
    pl_LockAll
    pl_PlaySE SEQ_SE_DECIDE2  // Pearl SEQ_SE_DP_UG_020
    pl_msg_sys 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P95_S4:
P95_002B:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 0
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_MAZYO4: no Black 2 sound chosen yet
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
