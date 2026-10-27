// MAP_PASTORIA_GREAT_MARSH_ENTRANCE_1F: Pearl script file 124, text bank 128. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-5: Pearl's; 6: after a Warp, 7: after a Warp, 8: after a Warp, 9: after a Warp; 10: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P124_S1
    ScriptEntry P124_S2
    ScriptEntry P124_S3
    ScriptEntry P124_S4
    ScriptEntry P124_S5
    ScriptEntry W462_007B_S
    ScriptEntry W462_00C8_S
    ScriptEntry W462_0106_S
    ScriptEntry W462_014F_S
    ScriptEntry PearlArrive
    ScriptEntriesEnd

P124_S1:
P124_0016:
    pl_End

P124_S2:
P124_0018:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P124_0188
    pl_WaitMovement
    pl_GetPlayerMapPos PVAR_4000, PVAR_4001
    pl_CompareVarToValue PVAR_4000, 5
    pl_CallIf 1, P124_0173
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
    pl_msg_sys 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P124_0060
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P124_014C
    pl_End

P124_0060:
    BoxGetCount PVAR_800C, 5  // Pearl CountPCFreeSpace: free PC box slots
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, P124_0082
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, P124_015E

P124_0082:
    pl_msg_sys 1
    MoneyCheck PVAR_800C, 500
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P124_0137
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_RemoveMoney 500
    MoneyWinUpdate
    pl_msg_sys 2
    pl_BufferPlayerName 0
    pl_msg_sys 3
    pl_msg_sys 4
    pl_CloseMessage
    MoneyWinClose
    pl_GetPlayerMapPos PVAR_8004, PVAR_8005
    pl_CompareVarToValue PVAR_8004, 4
    pl_GoToIf 1, P124_00D8
    pl_CompareVarToValue PVAR_8004, 5
    pl_GoToIf 1, P124_00E8
    pl_End

P124_00D8:
    pl_ApplyMovement PL_PLAYER, P124_0190
    pl_WaitMovement
    pl_GoTo P124_00F8

P124_00E8:
    pl_ApplyMovement PL_PLAYER, P124_01A8
    pl_WaitMovement
    pl_GoTo P124_00F8

P124_00F8:
    pl_SetVarFromValue PVAR_40DA, 1
    pl_SafariStart  // Pearl EnableDisableSafariZone 0: 30 Safari Balls into the Bag
    FieldSetNextZone 176, 2, 5, 2, 2  // SetDynamicWarp: the exit (dest 0x100) goes to Pearl map 125 (MAP_PASTORIA_GREAT_MARSH_ENTRANCE_1F) warp 2
    WorkSetConst PL_ELEVATOR_FROM, 1  // and that is now where the player came from
    pl_PlaySE SEQ_SE_KAIDAN  // Pearl SEQ_SE_DP_KAIDAN2
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 3  // the rest of this Pearl script runs there (continuation 3)
    pl_Warp 536, 68, 116, 0  // Pearl map 509 (MAP_GREAT_MARSH_AREA_6)
    pl_ReleaseAll
    pl_End

P124_0137:
    pl_msg_sys 6
    pl_CloseMessage
    MoneyWinClose
    pl_ApplyMovement PL_PLAYER, P124_01B8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P124_014C:
    pl_CloseMessage
    MoneyWinClose
    pl_ApplyMovement PL_PLAYER, P124_01B8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P124_015E:
    MoneyWinClose
    pl_msg_sys 7
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P124_01B8
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P124_0173:
    pl_ApplyMovement PL_PLAYER, P124_0180
    pl_WaitMovement
    pl_Return

P124_S3:
P124_01C0:
    pl_LockAll
    pl_msg_sys 9
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P124_01E5
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P124_0201
    pl_End

P124_01E5:
    pl_msg_sys 10
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P124_0234
    pl_WaitMovement
    pl_SetVarFromValue PVAR_40DA, 0
    pl_SafariEnd  // Pearl EnableDisableSafariZone 1: the Safari Balls left are taken back
    pl_ReleaseAll
    pl_End

P124_0201:
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P124_023C
    pl_WaitMovement
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 4  // the rest of this Pearl script runs there (continuation 4)
    pl_Warp 536, 68, 116, 0  // Pearl map 509 (MAP_GREAT_MARSH_AREA_6)
    pl_ReleaseAll
    pl_End

P124_S4:
P124_024C:
    pl_LockAll
    pl_ApplyMovement PL_PLAYER, P124_0234
    pl_WaitMovement
    pl_SetVarFromValue PVAR_40DA, 0
    pl_ReleaseAll
    pl_End

P124_S5:
P124_0262:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 12
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P124_028D
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P124_0298
    pl_End

P124_028D:
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P124_0298:
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P124_0180:
    Move 14, 1  // WALK_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P124_0188:
    Move 34, 1  // WALK_ON_SPOT_NORMAL_WEST
    MoveEnd

    .balign 4, 0
P124_0190:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 12, 3  // WALK_NORMAL_NORTH
    Move 15, 1  // WALK_NORMAL_EAST
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P124_01A8:
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    Move 12, 4  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

    .balign 4, 0
P124_01B8:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P124_0234:
    Move 13, 5  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P124_023C:
    Move 0, 1  // FACE_NORTH
    Move 12, 1  // WALK_NORMAL_NORTH
    Move 69, 1  // SET_INVISIBLE
    MoveEnd

// ---- continuation 6: after the Warp at 462:007B (a common script)
W462_007B_S:
W462_007B_0087:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_40DA, 2
    pl_SafariEnd  // Pearl EnableDisableSafariZone 1: the Safari Balls left are taken back
    pl_ReleaseAll
    pl_End

// ---- continuation 7: after the Warp at 462:00C8 (a common script)
W462_00C8_S:
W462_00C8_00D4:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_40DA, 2
    pl_SafariEnd  // Pearl EnableDisableSafariZone 1: the Safari Balls left are taken back
    pl_ReleaseAll
    pl_End

// ---- continuation 8: after the Warp at 462:0106 (a common script)
W462_0106_S:
W462_0106_0112:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_40DA, 2
    pl_SafariEnd  // Pearl EnableDisableSafariZone 1: the Safari Balls left are taken back
    pl_ReleaseAll
    pl_End

// ---- continuation 9: after the Warp at 462:014F (a common script)
W462_014F_S:
W462_014F_015B:
    pl_fade_in_black  // FadeScreen 6, 1, 1, 0x0
    pl_WaitFadeScreen
    pl_SetVarFromValue PVAR_40DA, 2
    pl_SafariEnd  // Pearl EnableDisableSafariZone 1: the Safari Balls left are taken back
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
