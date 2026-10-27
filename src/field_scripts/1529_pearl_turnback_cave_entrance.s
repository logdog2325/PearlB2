// MAP_TURNBACK_CAVE_ENTRANCE: Pearl script file 281, text bank 248. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-2: Pearl's; no warp continuations; 3: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P281_S1
    ScriptEntry P281_S2
    ScriptEntry PearlArrive
    ScriptEntry TurnbackDoors
    ScriptEntriesEnd

P281_S1:
P281_000A:
    pl_SetFlag PFLAG_09D4
    pl_Call P281_001C
// InitTurnbackCave PVAR_410B, PVAR_410C: the doors are set after the arrival (TurnbackDoors, Black 2 map script type 4: no PlayerGetGPos in a zone init; b2tools/turnback.py)
    pl_End

P281_001C:
    pl_SetVarFromValue PVAR_410B, 0
    pl_SetVarFromValue PVAR_410C, 0
    pl_Return

P281_S2:
P281_002A:
    pl_CheckFlag PFLAG_0121
    pl_GoToIf 1, P281_0046
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P281_0046:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_msg_sys 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

TurnbackDoors:                    // after each arrival (Black 2 map script type 4, level 1): Pearl's InitTurnbackCave (b2tools/turnback.py)
    PlayerGetGPos 0x805d, 0x805e
    WorkSetConst 0x805f, 5  // the door the player came in by: 0 N, 1 E, 2 S, 3 W (Pearl's warps), 5 none
    WorkCmpConst 0x805e, 2
    VMJumpIf 3, .Ltb_in_n
    WorkCmpConst 0x805e, 19
    VMJumpIf 4, .Ltb_in_s
    WorkCmpConst 0x805d, 19
    VMJumpIf 4, .Ltb_in_e
    WorkCmpConst 0x805d, 3
    VMJumpIf 3, .Ltb_in_w
    VMJump .Ltb_dest
.Ltb_in_n:
    WorkSetConst 0x805f, 0
    VMJump .Ltb_dest
.Ltb_in_e:
    WorkSetConst 0x805f, 1
    VMJump .Ltb_dest
.Ltb_in_s:
    WorkSetConst 0x805f, 2
    VMJump .Ltb_dest
.Ltb_in_w:
    WorkSetConst 0x805f, 3
    VMJump .Ltb_dest
.Ltb_dest:                         // Pearl's draw: the slot of CANDIDATES (0 = the doors as the file has them: the entrance)
    WorkSetConst 0x8060, 2  // 3 pillars seen: Giratina's room
    WorkCmpConst PVAR_410B, 3
    VMJumpIf 4, .Ltb_go
    WorkSetConst 0x8060, 0  // 30 rooms visited: the entrance
    WorkCmpConst PVAR_410C, 30
    VMJumpIf 4, .Ltb_go
    WorkSetConst 0x8060, 1  // 25 %: the pillar room
    Random 0x8061, 100
    WorkCmpConst 0x8061, 25
    VMJumpIf 0, .Ltb_go
    Random 0x8061, 6  // else Pearl's room table [rand % 6 + 6 x pillars seen]
    WorkSet PL_TMP, PVAR_410B
    WorkMul PL_TMP, 6
    WorkAdd 0x8061, PL_TMP
    WorkSetConst 0x8060, 3  // 0: TURNBACK_CAVE_RANDOM_ROOM_3, zone 625
    WorkCmpConst 0x8061, 0
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 3  // 1: TURNBACK_CAVE_RANDOM_ROOM_6, zone 625
    WorkCmpConst 0x8061, 1
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 4  // 2: TURNBACK_CAVE_RANDOM_ROOM_5, zone 626
    WorkCmpConst 0x8061, 2
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 4  // 3: TURNBACK_CAVE_RANDOM_ROOM_4, zone 626
    WorkCmpConst 0x8061, 3
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 5  // 4: TURNBACK_CAVE_RANDOM_ROOM_2, zone 627
    WorkCmpConst 0x8061, 4
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 5  // 5: TURNBACK_CAVE_RANDOM_ROOM_1, zone 627
    WorkCmpConst 0x8061, 5
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 6  // 6: TURNBACK_CAVE_RANDOM_ROOM_12, zone 628
    WorkCmpConst 0x8061, 6
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 6  // 7: TURNBACK_CAVE_RANDOM_ROOM_9, zone 628
    WorkCmpConst 0x8061, 7
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 7  // 8: TURNBACK_CAVE_RANDOM_ROOM_10, zone 629
    WorkCmpConst 0x8061, 8
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 7  // 9: TURNBACK_CAVE_RANDOM_ROOM_11, zone 629
    WorkCmpConst 0x8061, 9
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 8  // 10: TURNBACK_CAVE_RANDOM_ROOM_7, zone 630
    WorkCmpConst 0x8061, 10
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 8  // 11: TURNBACK_CAVE_RANDOM_ROOM_8, zone 630
    WorkCmpConst 0x8061, 11
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 9  // 12: TURNBACK_CAVE_RANDOM_ROOM_18, zone 631
    WorkCmpConst 0x8061, 12
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 9  // 13: TURNBACK_CAVE_RANDOM_ROOM_15, zone 631
    WorkCmpConst 0x8061, 13
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 10  // 14: TURNBACK_CAVE_RANDOM_ROOM_16, zone 632
    WorkCmpConst 0x8061, 14
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 10  // 15: TURNBACK_CAVE_RANDOM_ROOM_13, zone 632
    WorkCmpConst 0x8061, 15
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 11  // 16: TURNBACK_CAVE_RANDOM_ROOM_17, zone 663
    WorkCmpConst 0x8061, 16
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 12  // 17: TURNBACK_CAVE_RANDOM_ROOM_14, zone 664
    WorkCmpConst 0x8061, 17
    VMJumpIf 1, .Ltb_go
    WorkSetConst 0x8060, 0  // (past Pearl's table: the entrance)
.Ltb_go:                           // each door but the way in: park the warps before the chosen one
    WorkCmpConst 0x805f, 0
    VMJumpIf 1, .Ltb_done_n
    WorkCmpConst 0x8060, 0
    VMJumpIf 1, .Ltb_done_n
    ObjInitWarpGPos 0, 4095, 0, 4095  // the N door's own warp (to the entrance)
    WorkCmpConst 0x8060, 1
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 5, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 9, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 13, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 17, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 21, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 25, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 29, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 33, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 37, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 41, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 45, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_n:
    WorkCmpConst 0x805f, 1
    VMJumpIf 1, .Ltb_done_e
    WorkCmpConst 0x8060, 0
    VMJumpIf 1, .Ltb_done_e
    ObjInitWarpGPos 1, 4095, 0, 4095  // the E door's own warp (to the entrance)
    WorkCmpConst 0x8060, 1
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 6, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 10, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 14, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 18, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 22, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 26, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 30, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 34, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 38, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 42, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 46, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_e:
    WorkCmpConst 0x805f, 2
    VMJumpIf 1, .Ltb_done_s
    WorkCmpConst 0x8060, 0
    VMJumpIf 1, .Ltb_done_s
    ObjInitWarpGPos 2, 4095, 0, 4095  // the S door's own warp (to the entrance)
    WorkCmpConst 0x8060, 1
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 7, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 11, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 15, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 19, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 23, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 27, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 31, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 35, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 39, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 43, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 47, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_s:
    WorkCmpConst 0x805f, 3
    VMJumpIf 1, .Ltb_done_w
    WorkCmpConst 0x8060, 0
    VMJumpIf 1, .Ltb_done_w
    ObjInitWarpGPos 3, 4095, 0, 4095  // the W door's own warp (to the entrance)
    WorkCmpConst 0x8060, 1
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 8, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 12, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 16, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 20, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 24, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 28, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 32, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 36, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 40, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 44, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 48, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_w:
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
