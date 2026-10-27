// MAP_CANALAVE_HARBOR_INN: Pearl script file 45, text bank 56. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-3: Pearl's; 4: after a Warp; 5: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P45_S1
    ScriptEntry P45_S2
    ScriptEntry P45_S3
    ScriptEntry W354_00D6_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P45_S1:
P45_000E:
    pl_SetFlag PFLAG_025F
    pl_CheckFlag PFLAG_0158
    pl_GoToIf 0, P45_001F
    pl_End

P45_001F:
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 1, P45_002C
    pl_End

P45_002C:
    pl_GetNationalDex PVAR_4000
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P45_0040
    pl_End

P45_0040:
    pl_CheckItem 454, 1, PVAR_4000
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P45_0057
    pl_End

P45_0057:
    pl_CheckDistributionEvent 0, PVAR_4000  // CheckDistributionEvent 0: its item came from the deliveryman
    pl_CompareVarToValue PVAR_4000, 1
    pl_GoToIf 1, P45_006B
    pl_End

P45_006B:
    pl_CheckFlag PFLAG_012C
    pl_GoToIf 1, P45_0078
    pl_End

P45_0078:
    pl_CompareVarToValue PVAR_40F8, 2
    pl_GoToIf 4, P45_0091
    pl_ClearFlag PFLAG_025F
    pl_SetVarFromValue PVAR_40F8, 1
    pl_End

P45_0091:
    pl_End

P45_S2:
P45_0093:
    pl_LockAll
    pl_WaitTime 30, PVAR_800C
    pl_msg_sys 0
    pl_CloseMessage
    pl_ApplyMovement 0, P45_0148
    pl_ApplyMovement PL_PLAYER, P45_0130
    pl_WaitMovement
    pl_WaitTime 15, PVAR_800C
    pl_BufferPlayerName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_stub PlaySE  // Pearl sound SEQ_SE_DP_MAZYO2: no Black 2 sound chosen yet
    pl_SetFlag PFLAG_013C
    pl_SetFlag PFLAG_025F
    pl_SetVarFromValue PVAR_40F8, 2
    pl_fade_out_black  // FadeScreen 6, 3, 0, 0x0
    pl_WaitFadeScreen
    pl_fade_in_black  // FadeScreen 6, 3, 1, 0x0
    pl_WaitFadeScreen
    pl_fade_out_black  // FadeScreen 6, 3, 0, 0x0
    pl_WaitFadeScreen
    pl_fade_in_black  // FadeScreen 6, 3, 1, 0x0
    pl_WaitFadeScreen
    pl_fade_out_black  // FadeScreen 6, 6, 0, 0x0
    pl_WaitFadeScreen
    pl_WaitTime 120, PVAR_800C
    RTReserveScript 3  // the rest of this Pearl script runs there (continuation 3)
    pl_Warp 444, 152, 277, 1  // Pearl map 320 (MAP_NEWMOON_ISLAND_EXTERIOR)
    pl_ReleaseAll
    pl_End

P45_S3:
P45_0160:
    pl_LockAll
    pl_Call P45_0184
    pl_stub 2B5  // Pearl 0x2B5 Unk02B5 33, 58, 714: not translated yet
    pl_PlayFanfare SEQ_ME_ASA  // Pearl SEQ_ASA
    pl_WaitFanfare
    pl_BufferPlayerName 0
    pl_msg_sys 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P45_0184:
    pl_CheckFlag PFLAG_0158
    pl_GoToIf 1, P45_0197
    pl_SetVarFromValue PVAR_40F8, 0
    pl_Return

P45_0197:
    pl_SetVarFromValue PVAR_40F8, 3
    pl_Return

    .balign 4, 0
P45_0130:
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 3  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P45_0148:
    Move 15, 3  // WALK_NORMAL_EAST
    Move 12, 2  // WALK_NORMAL_NORTH
    Move 33, 1  // WALK_ON_SPOT_NORMAL_SOUTH
    Move 63, 2  // DELAY_8
    Move 35, 1  // WALK_ON_SPOT_NORMAL_EAST
    MoveEnd

// ---- continuation 4: after the Warp at 354:00D6 (MAP_NEWMOON_ISLAND_INTERIOR)
W354_00D6_S:
W354_00D6_00E2:
    pl_fade_in_black  // FadeScreen 6, 6, 1, 0x0
    pl_WaitFadeScreen
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
