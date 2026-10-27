// MAP_SURVIVAL_AREA_POKEMART: Pearl script file 1023, text bank 535. Written by b2tools/pearl_story.py:
// do not edit; rerun `python3 b2tools/pearl_story.py zones ...` (notes/STORY.md).
// Scripts 1-4: Pearl's; no warp continuations; 5: PearlArrive; 103: Pearl 10200, 104: Pearl 10201
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry P1023_S1
    ScriptEntry P1023_S2
    ScriptEntry P1023_S3
    ScriptEntry P1023_S4
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
    ScriptEntry PearlProxy_10200
    ScriptEntry PearlProxy_10201
    ScriptEntriesEnd

P1023_S1:
P1023_0012:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    VMCall C205_20_S20  // CallCommonScript 2019 (Pearl file 205 script 20)
    pl_CloseMessageWithoutErasing
    pl_PokeMartCommon 1
    pl_ReleaseAll
    pl_End

P1023_S2:
P1023_0028:
    pl_End

P1023_S3:
P1023_002A:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 0
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

P1023_S4:
P1023_003D:
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_msg_talk 1
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

PearlProxy_10200:                  // Pearl global script 10200 (run by this zone's events)
    VMCall C373_1_S1
    VMHalt

PearlProxy_10201:                  // Pearl global script 10201 (run by this zone's events)
    VMCall T373_2_S2
    VMHalt

// ---- Pearl global script 205:20 (a subroutine here)
C205_20_S20:
C205_20_0F28:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_sys 2  // Pearl bank 199 line 37
    pl_ReturnCommonScript
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 373:1 (a subroutine here)
C373_1_S1:
C373_1_000A:
// MysteryGiftGive 0: nothing to load or unload (the gifts are built in)
    pl_DeliveryWaiting PVAR_40ED  // MysteryGiftGive 1: a gift waiting?
    pl_CompareVarToValue PVAR_40ED, 0
    pl_GoToIf 1, C373_1_002B
    pl_ClearFlag PFLAG_0228
// MysteryGiftGive 7: nothing to load or unload (the gifts are built in)
    VMReturn  // End: the sub-script ends

C373_1_002B:
    pl_SetFlag PFLAG_0228
// MysteryGiftGive 7: nothing to load or unload (the gifts are built in)
    VMReturn  // End: the sub-script ends

// ---- Pearl global script 373:2 (a subroutine here)
T373_2_S2:
T373_2_0035:
// MysteryGiftGive 0: nothing to load or unload (the gifts are built in)
    pl_PlaySE SEQ_SE_MESSAGE  // Pearl SEQ_SE_DP_SELECT
    pl_LockAll
    pl_FacePlayer
    pl_DeliveryWaiting PVAR_800C  // MysteryGiftGive 1: a gift waiting?
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T373_2_00EE
    pl_GetTimeOfDay PVAR_800C
    pl_SetVarFromVar PVAR_8008, PVAR_800C
    pl_CompareVarToValue PVAR_8008, 0
    pl_GoToIf 1, T373_2_007E
    pl_CompareVarToValue PVAR_8008, 1
    pl_GoToIf 1, T373_2_008A
    pl_GoTo T373_2_0096

T373_2_007E:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 3  // Pearl bank 332 line 0
    pl_GoTo T373_2_00A2

T373_2_008A:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 4  // Pearl bank 332 line 1
    pl_GoTo T373_2_00A2

T373_2_0096:
    pl_BufferPlayerName 0
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 5  // Pearl bank 332 line 2
    pl_GoTo T373_2_00A2

T373_2_00A2:
    pl_DeliveryCanReceive PVAR_800C  // MysteryGiftGive 3: can it be received?
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, T373_2_00D8
    pl_PlayFanfare SEQ_ME_ITEM  // Pearl SEQ_FANFA4
    pl_BufferPlayerName 0  // MysteryGiftGive 5: the received line (MessageFromBank shows it)
    WorkCmpConst PVAR_DELIVERY, 0
    VMJumpIf CMP_NE, .Ldmc1_0
    pl_msg_talk 6  // Pearl bank 332 line 14
    VMJump .Ldmc1_end
.Ldmc1_0:
    WorkCmpConst PVAR_DELIVERY, 1
    VMJumpIf CMP_NE, .Ldmc1_1
    pl_msg_talk 7  // Pearl bank 332 line 15
    VMJump .Ldmc1_end
.Ldmc1_1:
    WorkCmpConst PVAR_DELIVERY, 2
    VMJumpIf CMP_NE, .Ldmc1_2
    pl_msg_talk 8  // Pearl bank 332 line 16
    VMJump .Ldmc1_end
.Ldmc1_2:
    pl_msg_talk 9  // Pearl bank 332 line 13
.Ldmc1_end:
    pl_WaitFanfare
    pl_msg_talk 10  // Pearl bank 332 line 17
    pl_WaitButton
    pl_DeliveryGive  // MysteryGiftGive 4: the next gift
    pl_GoTo T373_2_0103

T373_2_00D8:
// MysteryGiftGive 6: the can't-receive line (MessageFromBank shows it)
    pl_msg_talk 11  // Pearl bank 332 line 4 (only the Egg can be refused: the key items always fit)
    pl_WaitButton
    pl_GoTo T373_2_00F9

T373_2_00EE:
    MsgWinCloseAll  // another speaker: close the first window
    pl_msg_talk 12  // Pearl bank 332 line 3
    pl_WaitButton
    pl_GoTo T373_2_00F9

T373_2_00F9:
    pl_CloseMessage
    pl_ReleaseAll
// MysteryGiftGive 7: nothing to load or unload (the gifts are built in)
    VMReturn  // End: the sub-script ends

T373_2_0103:
    pl_CloseMessage
    pl_ReleaseAll
// MysteryGiftGive 8: nothing to load or unload (the gifts are built in)
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
