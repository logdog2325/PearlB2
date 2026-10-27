// MAP_JUBLIFE_GLOBAL_TRADE_STATION: Pearl script file 28, text bank 41. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-11: Pearl's; no warp continuations; 12: PearlArrive; 48: Pearl 2025
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P28_S1
    ScriptEntry P28_S2
    ScriptEntry P28_S3
    ScriptEntry P28_S4
    ScriptEntry P28_S5
    ScriptEntry P28_S6
    ScriptEntry P28_S7
    ScriptEntry P28_S8
    ScriptEntry P28_S9
    ScriptEntry P28_S10
    ScriptEntry P28_S11
    ScriptEntry PearlArrive
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
    ScriptEntry PearlProxy_2025
    ScriptEntriesEnd

P28_S11:
P28_002E:
    pl_CompareVarToValue PVAR_40D5, 6
    pl_CallIf 1, P28_003D
    pl_End

P28_003D:
// Pearl HideObject 255 in a map script: Black 2 moves no actor there (left out)
    pl_Return

P28_S10:
P28_0043:
    pl_LockAll
    pl_Call P28_004F
    pl_ReleaseAll
    pl_End

P28_004F:
    pl_LoadDoorAnimation 77, 12, 2  // the door at cell (0,0) tile (12,2)
    pl_Call P28_009D
    pl_ShowObject PL_PLAYER  // Pearl ShowObject 255
    pl_ApplyMovement PL_PLAYER, P28_00B0
    pl_WaitMovement
    pl_Call P28_00A5
    pl_LoadDoorAnimation 77, 12, 4  // the door at cell (0,0) tile (12,4)
    pl_Call P28_009D
    pl_ApplyMovement PL_PLAYER, P28_00C0
    pl_WaitMovement
    pl_Call P28_00A5
    pl_SetVarFromValue PVAR_40D5, 0
    pl_Return

P28_009D:
    pl_PlayDoorOpenAnimation 77
    pl_WaitForAnimation 77
    pl_Return

P28_00A5:
    pl_PlayDoorCloseAnimation 77
    pl_WaitForAnimation 77
    pl_UnloadAnimation 77
    pl_Return

P28_S1:
P28_00C8:
    pl_End

P28_S2:
P28_00CA:
    pl_End

P28_S3:
P28_00CC:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    WorkSetConst PVAR_800C, 0  // CheckPartyHasBadEgg: never
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P28_0340
    pl_CheckFlag PFLAG_00C3
    pl_GoToIf 1, P28_02D3
    pl_SetFlag PFLAG_00C3
    pl_msg_talk 0
    pl_GoTo P28_00FF

P28_00FF:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 16, 65535, 0  // Pearl AddMenuEntryImm 129, 0
    ListMenuAdd 17, 65535, 1  // Pearl AddMenuEntryImm 128, 1
    ListMenuAdd 18, 65535, 2  // Pearl AddMenuEntryImm 130, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P28_01C1
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P28_014A
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P28_02C2
    pl_GoTo P28_02C2

P28_014A:
    pl_msg_talk 2
    pl_GoTo P28_0155

P28_0155:
    ListMenu_AnchorTopRight 31, 1, 0, 0, PVAR_800C  // Pearl InitGlobalTextMenu 1, 1, 0, 1, PVAR_800C
    ListMenuAdd 19, 65535, 0  // Pearl AddMenuEntryImm 131, 0
    ListMenuAdd 20, 65535, 1  // Pearl AddMenuEntryImm 132, 1
    ListMenuAdd 21, 65535, 2  // Pearl AddMenuEntryImm 133, 2
    ListMenuShow
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, P28_01A0
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, P28_01AB
    pl_CompareVarToValue PVAR_8008, 2
    pl_GoToIf 1, P28_01B6
    pl_GoTo P28_01B6

P28_01A0:
    pl_msg_talk 3
    pl_GoTo P28_0155

P28_01AB:
    pl_msg_talk 4
    pl_GoTo P28_0155

P28_01B6:
    pl_msg_talk 5
    pl_GoTo P28_00FF

P28_01C1:
    pl_CountPartyNonEggs PVAR_800C
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 0, P28_01DA
    pl_GoTo P28_02DE

P28_01DA:
    pl_msg_talk 9
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_01E5:
    VMCall C205_7_S7  // CallCommonScript 2006 (Pearl file 205 script 7)
    pl_SetVarFromVar PVAR_800C, PVAR_4000
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P28_02C2
    pl_HealParty
    pl_SetVarFromValue PVAR_40D5, 6
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 7
    pl_CloseMessage
    pl_ApplyMovement PL_PLAYER, P28_031C
    pl_WaitMovement
    pl_LoadDoorAnimation 77, 12, 4  // the door at cell (0,0) tile (12,4)
    pl_Call P28_009D
    pl_ApplyMovement PL_PLAYER, P28_0330
    pl_WaitMovement
    pl_Call P28_00A5
    pl_LoadDoorAnimation 77, 12, 2  // the door at cell (0,0) tile (12,2)
    pl_Call P28_009D
    pl_ApplyMovement PL_PLAYER, P28_0328
    pl_WaitMovement
    pl_HideObject PL_PLAYER  // Pearl HideObject 255
    pl_ApplyMovement PL_PLAYER, P28_0338
    pl_WaitMovement
    pl_Call P28_00A5
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 2B2  // Pearl 0x2B2 Unk02B2 : not translated yet
    pl_stub 0B3  // Pearl 0x0B3 Unk00B3 32780: not translated yet
    pl_SetVarFromVar PVAR_8004, PVAR_800C
    pl_stub TryStartGTSApp  // Pearl 0x0B2 Unk00B2 32772, 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P28_02A6
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_Call P28_004F
    pl_ReleaseAll
    pl_End

P28_02A6:
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
    pl_Call P28_004F
    pl_GoTo P28_02C2

P28_02C2:
    pl_SetVarFromValue PVAR_40D5, 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_02D3:
    pl_msg_talk 1
    pl_GoTo P28_00FF

P28_02DE:
    pl_GetPartyCount PVAR_800C
    pl_CompareVarToValue PVAR_800C, 6
    pl_GoToIf 1, P28_02F7
    pl_GoTo P28_01E5

P28_02F7:
    BoxGetCount PVAR_800C, 5  // Pearl CountPCFreeSpace: free PC box slots
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P28_0310
    pl_GoTo P28_01E5

P28_0310:
    pl_msg_talk 8
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_0340:
    VMCall C207_17_S17  // CallCommonScript 9016 (Pearl file 207 script 17)
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_S4:
P28_034C:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 10
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_S5:
P28_035F:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 11
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_S6:
P28_0372:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 12
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_S7:
P28_0385:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_S8:
P28_0398:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P28_S9:
P28_03AB:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P28_00B0:
    Move 13, 1  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P28_00C0:
    Move 13, 2  // WALK_NORMAL_SOUTH
    MoveEnd

    .balign 4, 0
P28_031C:
    Move 15, 1  // WALK_NORMAL_EAST
    Move 32, 1  // WALK_ON_SPOT_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P28_0328:
    Move 12, 1  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P28_0330:
    Move 12, 2  // WALK_NORMAL_NORTH
    MoveEnd

    .balign 4, 0
P28_0338:
    Move 1, 1  // FACE_SOUTH
    MoveEnd

PearlProxy_2025:                  // Pearl global script 2025 (run by this zone's events)
    VMCall C205_26_S26
    VMHalt

// ---- Pearl global script 205:7 (a subroutine here)
C205_7_S7:
C205_7_0470:
    pl_Call C205_7_0480
    pl_SetVarFromVar PVAR_4000, PVAR_800C
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C205_7_0480:
    pl_stub CheckSaveType  // Pearl 0x12C CheckSaveStatus 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_7_04D4
    pl_stub OpenSaveInfo  // Pearl 0x2C1 ShowSaveStats : not translated yet
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 22  // Pearl bank 199 line 13
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_stub CheckSaveType  // Pearl 0x12C CheckSaveStatus 32780: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_04F5
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 1, C205_7_04E1
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, C205_7_04FE
    VMReturn  // End: the sub-script ends

C205_7_04D4:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 23  // Pearl bank 199 line 20
    pl_WaitABPress
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_04E1:
    pl_msg_sys 24  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E

C205_7_04F5:
    pl_msg_sys 25  // Pearl bank 199 line 21
    pl_GoTo C205_7_051B

C205_7_04FE:
    pl_msg_sys 24  // Pearl bank 199 line 14
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, C205_7_055E
    pl_msg_sys 26  // Pearl bank 199 line 15
    pl_GoTo C205_7_051B

C205_7_051B:
    pl_stub 258  // Pearl 0x258 Unk0258 : not translated yet
    pl_WaitTime 2, PVAR_800C
    pl_Call C205_7_0531
    pl_stub 259  // Pearl 0x259 Unk0259 : not translated yet
    pl_GoTo C205_7_053B

C205_7_0531:
// ShowSavingIcon: nothing in Black 2
    SaveDataWrite PVAR_800C
// HideSavingIcon: nothing in Black 2
    pl_Return

C205_7_053B:
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, C205_7_0568
    pl_BufferPlayerName 0
    pl_msg_sys 27  // Pearl bank 199 line 16
    pl_PlaySE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    pl_WaitSE SEQ_SE_SAVE  // Pearl SEQ_SE_DP_SAVE
    VMSleep 30  // WaitABPressTime
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_Return

C205_7_055E:
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_SetVarFromValue PVAR_800C, 0
    pl_Return

C205_7_0568:
    pl_msg_sys 28  // Pearl bank 199 line 18
    pl_WaitABPress
    pl_stub CloseSaveInfo  // Pearl 0x2C2 HideSaveStats : not translated yet
    pl_Return

// ---- Pearl global script 207:17 (a subroutine here)
C207_17_S17:
C207_17_074C:
    pl_Call C207_17_0756
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

C207_17_0756:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 29  // Pearl bank 207 line 127
    pl_Return

// ---- Pearl global script 205:26 (a subroutine here)
C205_26_S26:
C205_26_11EA:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    pl_stub 205  // Pearl 0x205 ShowGeonetScreen : not translated yet
    pl_ReturnToField
    pl_fade_in_after_starter  // FadeScreen 6, 1, 1, 0x0 (the starter screen ends white in Black 2)
    pl_WaitFadeScreen
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
