// MAP_TURNBACK_CAVE_RANDOM_ROOM_10: Pearl script file 292, text bank 18. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-1: Pearl's; no warp continuations; 2: PearlArrive; 93: Pearl 10001
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P292_S1
    ScriptEntry PearlArrive
    ScriptEntry TurnbackDoors
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlNoScript
    ScriptEntry PearlProxy_10001
    ScriptEntriesEnd

P292_S1:
P292_0006:
    pl_AddVar PVAR_410C, 1
// InitTurnbackCave PVAR_410B, PVAR_410C: the doors are set after the arrival (TurnbackDoors, Black 2 map script type 4: no PlayerGetGPos in a zone init; b2tools/turnback.py)
    Random PL_TMP, 2  // which of Pearl's two rooms: 0 TURNBACK_CAVE_RANDOM_ROOM_10, 1 TURNBACK_CAVE_RANDOM_ROOM_11 (Pearl draws one of 6 in the room before; here the zone there, 1 in 2 here)
    WorkCmpConst PL_TMP, 0
    VMJumpIf 1, .Ltb_rocks_done
    pl_SetObjectEventPos 0, 4, 18, 0, 3  // rock 0 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 0
    pl_SetObjectEventPos 1, 16, 2, 0, 3  // rock 1 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 1
    pl_SetObjectEventPos 2, 9, 5, 0, 3  // rock 2 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 2
    pl_SetObjectEventPos 3, 15, 3, 0, 3  // rock 3 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 3
    pl_SetObjectEventPos 4, 16, 6, 0, 3  // rock 4 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 4
    pl_SetObjectEventPos 5, 15, 7, 0, 3  // rock 5 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 5
    pl_SetObjectEventPos 6, 13, 5, 0, 3  // rock 6 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 6
    pl_SetObjectEventPos 7, 14, 4, 0, 3  // rock 7 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 7
    pl_SetObjectEventPos 8, 5, 17, 0, 3  // rock 8 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 8
    pl_SetObjectEventPos 9, 11, 11, 0, 1  // rock 9 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 9
    pl_SetObjectEventPos 10, 11, 17, 0, 3  // rock 10 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 10
    pl_SetObjectEventPos 11, 7, 7, 0, 3  // rock 11 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 11
    pl_SetObjectEventPos 12, 12, 5, 0, 3  // rock 12 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 12
    pl_SetObjectEventPos 13, 6, 16, 0, 3  // rock 13 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 13
    pl_SetObjectEventPos 14, 10, 5, 0, 3  // rock 14 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 14
    pl_SetObjectEventPos 15, 8, 6, 0, 3  // rock 15 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 15
    pl_SetObjectEventPos 16, 7, 19, 0, 3  // rock 16 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 16
    pl_SetObjectEventPos 17, 17, 5, 0, 3  // rock 17 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 17
    pl_SetObjectEventPos 18, 12, 17, 0, 3  // rock 18 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 18
    pl_SetObjectEventPos 19, 9, 17, 0, 3  // rock 19 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 19
    pl_SetObjectEventPos 20, 8, 18, 0, 3  // rock 20 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 20
    pl_SetObjectEventPos 21, 18, 4, 0, 3  // rock 21 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 21
    pl_SetObjectEventPos 22, 15, 15, 0, 3  // rock 22 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 22
    pl_SetObjectEventPos 23, 10, 17, 0, 3  // rock 23 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 23
    pl_SetObjectEventPos 24, 13, 17, 0, 3  // rock 24 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 24
    pl_SetObjectEventPos 25, 7, 15, 0, 3  // rock 25 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 25
    pl_SetObjectEventPos 26, 14, 16, 0, 3  // rock 26 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 26
    pl_SetObjectEventPos 27, 11, 5, 0, 3  // rock 27 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 27
    pl_SetObjectEventPos 28, 6, 20, 0, 3  // rock 28 -> TURNBACK_CAVE_RANDOM_ROOM_11's rock 28
.Ltb_rocks_done:
    pl_End

PearlProxy_10001:                  // Pearl global script 10001 (run by this zone's events)
    VMCall T375_2_S2
    VMHalt

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
    ObjInitWarpGPos 4, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 8, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 12, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 16, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 20, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 24, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 28, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 32, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 36, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 40, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_n
    ObjInitWarpGPos 44, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_n:
    WorkCmpConst 0x805f, 1
    VMJumpIf 1, .Ltb_done_e
    WorkCmpConst 0x8060, 0
    VMJumpIf 1, .Ltb_done_e
    ObjInitWarpGPos 1, 4095, 0, 4095  // the E door's own warp (to the entrance)
    WorkCmpConst 0x8060, 1
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 5, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 9, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 13, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 17, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 21, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 25, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 29, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 33, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 37, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 41, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_e
    ObjInitWarpGPos 45, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_e:
    WorkCmpConst 0x805f, 2
    VMJumpIf 1, .Ltb_done_s
    WorkCmpConst 0x8060, 0
    VMJumpIf 1, .Ltb_done_s
    ObjInitWarpGPos 2, 4095, 0, 4095  // the S door's own warp (to the entrance)
    WorkCmpConst 0x8060, 1
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 6, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 10, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 14, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 18, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 22, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 26, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 30, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 34, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 38, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 42, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_s
    ObjInitWarpGPos 46, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_s:
    WorkCmpConst 0x805f, 3
    VMJumpIf 1, .Ltb_done_w
    WorkCmpConst 0x8060, 0
    VMJumpIf 1, .Ltb_done_w
    ObjInitWarpGPos 3, 4095, 0, 4095  // the W door's own warp (to the entrance)
    WorkCmpConst 0x8060, 1
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 7, 4095, 0, 4095  // its copy to zone 623
    WorkCmpConst 0x8060, 2
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 11, 4095, 0, 4095  // its copy to zone 624
    WorkCmpConst 0x8060, 3
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 15, 4095, 0, 4095  // its copy to zone 625
    WorkCmpConst 0x8060, 4
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 19, 4095, 0, 4095  // its copy to zone 626
    WorkCmpConst 0x8060, 5
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 23, 4095, 0, 4095  // its copy to zone 627
    WorkCmpConst 0x8060, 6
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 27, 4095, 0, 4095  // its copy to zone 628
    WorkCmpConst 0x8060, 7
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 31, 4095, 0, 4095  // its copy to zone 629
    WorkCmpConst 0x8060, 8
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 35, 4095, 0, 4095  // its copy to zone 630
    WorkCmpConst 0x8060, 9
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 39, 4095, 0, 4095  // its copy to zone 631
    WorkCmpConst 0x8060, 10
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 43, 4095, 0, 4095  // its copy to zone 632
    WorkCmpConst 0x8060, 11
    VMJumpIf 3, .Ltb_done_w
    ObjInitWarpGPos 47, 4095, 0, 4095  // its copy to zone 663
.Ltb_done_w:
    VMHalt

// ---- Pearl global script 375:2 (a subroutine here)
T375_2_S2:
T375_2_0139:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    PokePartyHasMoveAny PVAR_800C, 249  // FindPartySlotWithMove: the slot, 6 = none (the same in both games)
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, T375_2_018B
    pl_CheckBadgeAcquired 0, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_018B
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 81  // Pearl bank 334 line 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T375_2_019A
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_018B:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 82  // Pearl bank 334 line 4
    pl_WaitButton
    pl_CloseMessage
    pl_GoTo T375_2_055B

T375_2_019A:
    pl_BufferPartyMonNickname 0, PVAR_8004
    pl_msg_talk 83  // Pearl bank 334 line 5
    pl_CloseMessage
// PlayHMCutIn 32772: nothing in Black 2 (the field-move cut-in (with the HM work: Black 2's PlayHMCutInEffect needs its player sequence))
// StartDestroyObstacleAnimation 1: no animation in Black 2
    pl_SetVarFromValue PVAR_8005, 1  // the animation is "over" at once (the script waits for it)
    pl_WaitTime 10, PVAR_800C
    pl_RemoveObject PVAR_800D, 0
    WorkSetConst PVAR_8004, 523  // GetCurrentMapID: Pearl map 523
// CreateJournalEvent 24, 32772, 0, 0, 0: nothing in Black 2 (Black 2 has no journal)

T375_2_01C8:
    pl_WaitTime 1, PVAR_800C
    pl_CompareVarToValue PVAR_8005, 0
    pl_GoToIf 1, T375_2_01C8
    pl_GoTo T375_2_055B

T375_2_055B:
    pl_ReleaseAll
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
