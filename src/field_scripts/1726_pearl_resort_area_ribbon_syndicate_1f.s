// MAP_RESORT_AREA_RIBBON_SYNDICATE_1F: Pearl script file 1035, text bank 543. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-8: Pearl's; no warp continuations; 9: PearlArrive
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1035_S1
    ScriptEntry P1035_S2
    ScriptEntry P1035_S3
    ScriptEntry P1035_S4
    ScriptEntry P1035_S5
    ScriptEntry P1035_S6
    ScriptEntry P1035_S7
    ScriptEntry P1035_S8
    ScriptEntry PearlArrive
    ScriptEntry PearlElevatorInit
    ScriptEntriesEnd

P1035_S8:
P1035_0022:
    pl_CheckFlag PFLAG_00FA
    pl_GoToIf 1, P1035_002F
    pl_End

P1035_002F:
    pl_SetObjectEventPos 0, 16, 14, 1, 0  // object 0
    pl_SetObjectEventPos 0, 16, 14, 1, 0  // SetObjectEventDir 0 (at the place SetObjectEventPos just gave)
    pl_End

P1035_S7:
P1035_003F:
    pl_LockAll
    pl_WaitTime 20, PVAR_800C
    pl_stub CountPartyRibbons  // Pearl 0x22F CountTotalPartyRibbons 32772: not translated yet
    pl_CompareVarToValue PVAR_8004, 10
    pl_GoToIf 0, P1035_0078
    pl_SetVarFromValue PVAR_40A7, 1
    pl_SetFlag PFLAG_00FA
    pl_BufferPlayerName 0
    pl_msg_sys 1
    pl_CloseMessage
    pl_ApplyMovement 0, P1035_00AC
    pl_WaitMovement
    pl_ReleaseAll
    pl_End

P1035_0078:
    pl_msg_sys 0
    pl_CloseMessage
    pl_WaitTime 20, PVAR_800C
    pl_fade_out_black  // FadeScreen 6, 1, 0, 0x0
    pl_WaitFadeScreen
    RTReserveScript 8  // the rest of this Pearl script runs there (continuation 8)
    pl_Warp 397, 826, 454, 1  // Pearl map 457 (MAP_RESORT_AREA)
    pl_ReleaseAll
    pl_End

P1035_S1:
P1035_00C0:
    pl_BufferPlayerName 0
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 2
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1035_S2:
P1035_00D6:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetFirstNonEggInParty PVAR_8000
    pl_BufferPlayerName 0
    pl_BufferPartyMonSpecies 2, PVAR_8000
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32768, 68: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1035_022E
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32768, 67: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1035_01D9
    pl_stub GetPartyMonRibbon  // Pearl 0x230 PartyMonHasRibbon 32780, 32768, 66: not translated yet
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1035_0184
    pl_GoTo P1035_012F

P1035_012F:
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
    pl_msg_talk 3
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1035_0246
    MoneyCheck PVAR_800C, 10000
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1035_0239
    pl_RemoveMoney 10000
    MoneyWinUpdate
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_msg_talk 7
    pl_msg_talk 8
    pl_WaitButton
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32768, 66: not translated yet
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P1035_0184:
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
    pl_msg_talk 4
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1035_0246
    MoneyCheck PVAR_800C, 65535
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1035_0239
    pl_RemoveMoney 65535
    pl_RemoveMoney 34465
    MoneyWinUpdate
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_msg_talk 9
    pl_msg_talk 10
    pl_WaitButton
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32768, 67: not translated yet
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P1035_01D9:
    MoneyWinDisp 31, 1  // Pearl ShowMoney 20, 2 (Black 2's place)
    pl_msg_talk 5
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1035_0246
    MoneyCheck PVAR_800C, 65535
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1035_0239
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 65535
    pl_RemoveMoney 16974
    MoneyWinUpdate
    pl_PlaySE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_WaitSE SEQ_SE_SYS_22  // Pearl SEQ_SE_DP_REGI
    pl_msg_talk 11
    pl_msg_talk 12
    pl_WaitButton
    pl_stub SetPartyMonRibbon  // Pearl 0x231 GivePartyMonRibbon 32768, 68: not translated yet
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P1035_022E:
    pl_msg_talk 6
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1035_0239:
    pl_msg_talk 13
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P1035_0246:
    pl_msg_talk 14
    pl_WaitButton
    pl_CloseMessage
    MoneyWinClose
    pl_ReleaseAll
    pl_End

P1035_S3:
P1035_0253:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 15
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1035_S4:
P1035_0266:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_GetPlayerGender PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, P1035_028E
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, P1035_0299
    pl_End

P1035_028E:
    pl_msg_talk 16
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1035_0299:
    pl_msg_talk 17
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1035_S5:
P1035_02A4:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 300
    pl_msg_talk 18
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1035_S6:
P1035_02C3:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_PlayCry 54
    pl_msg_talk 19
    pl_WaitCry
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

    .balign 4, 0
P1035_00AC:
    Move 2, 1  // FACE_WEST
    Move 71, 1  // LOCK_DIR
    Move 15, 1  // WALK_NORMAL_EAST
    Move 72, 1  // UNLOCK_DIR
    MoveEnd

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
