// The Grand Underground (zones 633-651), one script file for all its zones. Written by
// b2tools/underground_scripts.py from data/underground.json: do not edit (notes/UNDERGROUND.md).
#include "asm/field_script.inc"
#include "pearl.h"
#include "pearl_story.inc"

    ScriptEntry UG_GoUp
    ScriptEntry UG_Name_0
    ScriptEntry UG_Name_1
    ScriptEntry UG_Name_2
    ScriptEntry UG_Name_3
    ScriptEntry UG_Name_4
    ScriptEntry UG_Name_5
    ScriptEntry UG_Name_6
    ScriptEntry UG_Name_7
    ScriptEntry UG_Name_8
    ScriptEntry UG_Name_9
    ScriptEntry UG_Name_10
    ScriptEntry UG_Name_11
    ScriptEntry UG_Name_12
    ScriptEntry UG_Name_13
    ScriptEntry UG_Name_14
    ScriptEntry UG_Name_15
    ScriptEntry UG_Name_16
    ScriptEntry UG_Name_17
    ScriptEntry UG_Item_0
    ScriptEntry UG_Item_1
    ScriptEntry UG_Item_2
    ScriptEntry UG_Item_3
    ScriptEntry UG_Item_4
    ScriptEntry UG_Item_5
    ScriptEntry UG_Item_6
    ScriptEntry UG_Item_7
    ScriptEntry UG_Item_8
    ScriptEntry UG_Item_9
    ScriptEntry UG_Item_10
    ScriptEntry UG_Item_11
    ScriptEntry UG_Item_12
    ScriptEntry UG_Item_13
    ScriptEntry UG_Item_14
    ScriptEntry UG_Item_15
    ScriptEntry UG_Item_16
    ScriptEntry UG_Item_17
    ScriptEntry UG_Item_18
    ScriptEntry UG_Item_19
    ScriptEntry UG_Item_20
    ScriptEntry UG_Item_21
    ScriptEntry UG_Item_22
    ScriptEntry UG_Item_23
    ScriptEntry UG_Item_24
    ScriptEntry UG_Item_25
    ScriptEntry UG_Item_26
    ScriptEntry UG_Item_27
    ScriptEntry UG_Item_28
    ScriptEntry UG_Item_29
    ScriptEntry UG_Item_30
    ScriptEntry UG_Item_31
    ScriptEntry UG_Item_32
    ScriptEntry UG_Item_33
    ScriptEntry UG_Item_34
    ScriptEntry UG_Item_35
    ScriptEntry UG_Item_36
    ScriptEntry UG_Shard_0
    ScriptEntry UG_Shard_1
    ScriptEntry UG_Shard_2
    ScriptEntry UG_Shard_3
    ScriptEntry UG_Fossil_0
    ScriptEntry UG_Fossil_1
    ScriptEntry UG_ShardInit
    ScriptEntriesEnd

// 1: the Explorer Kit in the Underground (src/pearlb2/underground_itcm.c reads the answer)
UG_GoUp:
    pl_LockAll
    WorkSetConst 0x4010, 0
    pl_msg_sys 0
    pl_ShowYesNoMenu PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 5, UG_GoUp_No
    WorkSetConst 0x4010, 1
UG_GoUp_No:
    pl_CloseMessage
    pl_ReleaseAll
    pl_End

UG_Name_0:                         // Spacious Cave (its hole in the tunnels)
    pl_sign 1, 2
    pl_End

UG_Name_1:                         // Grassland Cave (its hole in the tunnels)
    pl_sign 2, 2
    pl_End

UG_Name_2:                         // Fountainspring Cave (its hole in the tunnels)
    pl_sign 3, 2
    pl_End

UG_Name_3:                         // Rocky Cave (its hole in the tunnels)
    pl_sign 4, 2
    pl_End

UG_Name_4:                         // Volcanic Cave (its hole in the tunnels)
    pl_sign 5, 2
    pl_End

UG_Name_5:                         // Swampy Cave (its hole in the tunnels)
    pl_sign 6, 2
    pl_End

UG_Name_6:                         // Dazzling Cave (its hole in the tunnels)
    pl_sign 7, 2
    pl_End

UG_Name_7:                         // Whiteout Cave (its hole in the tunnels)
    pl_sign 8, 2
    pl_End

UG_Name_8:                         // Icy Cave (its hole in the tunnels)
    pl_sign 9, 2
    pl_End

UG_Name_9:                         // Riverbank Cave (its hole in the tunnels)
    pl_sign 10, 2
    pl_End

UG_Name_10:                         // Sandsear Cave (its hole in the tunnels)
    pl_sign 11, 2
    pl_End

UG_Name_11:                         // Still-Water Cavern (its hole in the tunnels)
    pl_sign 12, 2
    pl_End

UG_Name_12:                         // Sunlit Cavern (its hole in the tunnels)
    pl_sign 13, 2
    pl_End

UG_Name_13:                         // Big Bluff Cavern (its hole in the tunnels)
    pl_sign 14, 2
    pl_End

UG_Name_14:                         // Stargleam Cavern (its hole in the tunnels)
    pl_sign 15, 2
    pl_End

UG_Name_15:                         // Glacial Cavern (its hole in the tunnels)
    pl_sign 16, 2
    pl_End

UG_Name_16:                         // Bogsunk Cavern (its hole in the tunnels)
    pl_sign 17, 2
    pl_End

UG_Name_17:                         // Typhlo Cavern (its hole in the tunnels)
    pl_sign 18, 2
    pl_End

UG_Item_0:                          // Spacious Cave: item 50 at (24, 13)
    pl_SetVarFromValue PVAR_8008, 50
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_1:                          // Spacious Cave: item 50 at (14, 27)
    pl_SetVarFromValue PVAR_8008, 50
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_2:                          // Spacious Cave: item 53 at (6, 24)
    pl_SetVarFromValue PVAR_8008, 53
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_3:                          // Spacious Cave: item 107 at (15, 19)
    pl_SetVarFromValue PVAR_8008, 107
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_4:                          // Grassland Cave: item 520 at (33, 48)
    pl_SetVarFromValue PVAR_8008, 520
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_5:                          // Fountainspring Cave: item 339 at (34, 18)
    pl_SetVarFromValue PVAR_8008, 339
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_6:                          // Fountainspring Cave: item 226 at (58, 16)
    pl_SetVarFromValue PVAR_8008, 226
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_7:                          // Rocky Cave: item 92 at (13, 19)
    pl_SetVarFromValue PVAR_8008, 92
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_8:                          // Rocky Cave: item 51 at (17, 12)
    pl_SetVarFromValue PVAR_8008, 51
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_9:                          // Rocky Cave: item 364 at (7, 12)
    pl_SetVarFromValue PVAR_8008, 364
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_10:                          // Rocky Cave: item 331 at (5, 7)
    pl_SetVarFromValue PVAR_8008, 331
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_11:                          // Rocky Cave: item 366 at (19, 7)
    pl_SetVarFromValue PVAR_8008, 366
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_12:                          // Volcanic Cave: item 382 at (17, 4)
    pl_SetVarFromValue PVAR_8008, 382
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_13:                          // Swampy Cave: item 505 at (7, 38)
    pl_SetVarFromValue PVAR_8008, 505
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_14:                          // Swampy Cave: item 333 at (27, 43)
    pl_SetVarFromValue PVAR_8008, 333
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_15:                          // Dazzling Cave: item 372 at (51, 5)
    pl_SetVarFromValue PVAR_8008, 372
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_16:                          // Dazzling Cave: item 248 at (60, 35)
    pl_SetVarFromValue PVAR_8008, 248
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_17:                          // Whiteout Cave: item 109 at (3, 3)
    pl_SetVarFromValue PVAR_8008, 109
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_18:                          // Whiteout Cave: item 244 at (13, 6)
    pl_SetVarFromValue PVAR_8008, 244
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_19:                          // Icy Cave: item 231 at (14, 5)
    pl_SetVarFromValue PVAR_8008, 231
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_20:                          // Icy Cave: item 227 at (9, 8)
    pl_SetVarFromValue PVAR_8008, 227
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_21:                          // Riverbank Cave: item 87 at (6, 11)
    pl_SetVarFromValue PVAR_8008, 87
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_22:                          // Sandsear Cave: item 249 at (26, 28)
    pl_SetVarFromValue PVAR_8008, 249
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_23:                          // Sandsear Cave: item 250 at (8, 16)
    pl_SetVarFromValue PVAR_8008, 250
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_24:                          // Still-Water Cavern: item 507 at (19, 13)
    pl_SetVarFromValue PVAR_8008, 507
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_25:                          // Still-Water Cavern: item 87 at (3, 4)
    pl_SetVarFromValue PVAR_8008, 87
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_26:                          // Sunlit Cavern: item 408 at (69, 15)
    pl_SetVarFromValue PVAR_8008, 408
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_27:                          // Sunlit Cavern: item 51 at (86, 65)
    pl_SetVarFromValue PVAR_8008, 51
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_28:                          // Big Bluff Cavern: item 510 at (14, 77)
    pl_SetVarFromValue PVAR_8008, 510
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_29:                          // Stargleam Cavern: item 518 at (54, 50)
    pl_SetVarFromValue PVAR_8008, 518
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_30:                          // Stargleam Cavern: item 92 at (75, 7)
    pl_SetVarFromValue PVAR_8008, 92
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_31:                          // Glacial Cavern: item 234 at (14, 5)
    pl_SetVarFromValue PVAR_8008, 234
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_32:                          // Glacial Cavern: item 407 at (10, 18)
    pl_SetVarFromValue PVAR_8008, 407
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_33:                          // Bogsunk Cavern: item 508 at (48, 13)
    pl_SetVarFromValue PVAR_8008, 508
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_34:                          // Bogsunk Cavern: item 108 at (8, 7)
    pl_SetVarFromValue PVAR_8008, 108
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_35:                          // Typhlo Cavern: item 377 at (39, 14)
    pl_SetVarFromValue PVAR_8008, 377
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Item_36:                          // Typhlo Cavern: item 398 at (85, 57)
    pl_SetVarFromValue PVAR_8008, 398
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Shard_0:                         // Rocky Cave: daily item 129 at (11, 14)
    pl_SetVarFromValue PVAR_8008, 129
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Shard_1:                         // Dazzling Cave: daily item 129 at (36, 21)
    pl_SetVarFromValue PVAR_8008, 129
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Shard_2:                         // Big Bluff Cavern: daily item 129 at (38, 4)
    pl_SetVarFromValue PVAR_8008, 129
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Shard_3:                         // Stargleam Cavern: daily item 130 at (28, 24)
    pl_SetVarFromValue PVAR_8008, 130
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Fossil_0:                        // Rocky Cave: a daily fossil at (13, 10)
    pl_GetRandom PVAR_800C, 5
    pl_SetVarFromValue PVAR_8008, 99
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 5, UG_Fossil_0_1
    pl_SetVarFromValue PVAR_8008, 100
UG_Fossil_0_1:
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 5, UG_Fossil_0_2
    pl_SetVarFromValue PVAR_8008, 101
UG_Fossil_0_2:
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 5, UG_Fossil_0_3
    pl_SetVarFromValue PVAR_8008, 102
UG_Fossil_0_3:
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 5, UG_Fossil_0_4
    pl_SetVarFromValue PVAR_8008, 103
UG_Fossil_0_4:
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

UG_Fossil_1:                        // Sandsear Cave: a daily fossil at (23, 16)
    pl_GetRandom PVAR_800C, 5
    pl_SetVarFromValue PVAR_8008, 99
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 5, UG_Fossil_1_1
    pl_SetVarFromValue PVAR_8008, 100
UG_Fossil_1_1:
    pl_CompareVarToValue PVAR_800C, 2
    pl_GoToIf 5, UG_Fossil_1_2
    pl_SetVarFromValue PVAR_8008, 101
UG_Fossil_1_2:
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 5, UG_Fossil_1_3
    pl_SetVarFromValue PVAR_8008, 102
UG_Fossil_1_3:
    pl_CompareVarToValue PVAR_800C, 4
    pl_GoToIf 5, UG_Fossil_1_4
    pl_SetVarFromValue PVAR_8008, 103
UG_Fossil_1_4:
    pl_SetVarFromValue PVAR_8009, 1
    VMCall UG_ItemBall
    pl_End

// the daily shard and fossil balls only after becoming Champion (zone init: hidden by their daily flags
// until then)
UG_ShardInit:
    pl_CheckFlag PFLAG_0964
    pl_GoToIf 1, UG_ShardInit_End
    FlagSet PFLAG_UG_SHARD_0
    FlagSet PFLAG_UG_SHARD_1
    FlagSet PFLAG_UG_SHARD_2
    FlagSet PFLAG_UG_SHARD_3
    FlagSet PFLAG_UG_FOSSIL_0
    FlagSet PFLAG_UG_FOSSIL_1
UG_ShardInit_End:
    pl_End

// Pearl's item-ball routine (Pearl file 370 script 122 as pearl_story translates it): PVAR_8008 the item,
// PVAR_8009 the count; the talked-to ball goes and its flag is set
UG_ItemBall:
    pl_PlaySE SEQ_SE_MESSAGE
    pl_LockAll
    pl_FacePlayer
    pl_WaitSE SEQ_SE_MESSAGE
    pl_SetVarFromVar PVAR_8004, PVAR_8008
    pl_SetVarFromVar PVAR_8005, PVAR_8009
    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 0
    pl_GoToIf 1, UG_ItemBall_Full
    VMCall UG_Fanfare
    pl_RemoveTalkedObject
    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C
    ItemIsTMHM PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 1
    pl_GoToIf 1, UG_ItemBall_TM
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    MsgWinCloseAll
    pl_msg_sys 21
    pl_GoTo UG_ItemBall_Pocket
UG_ItemBall_TM:
    pl_BufferPlayerName 0
    WordSetItemNameWithArticle 1, PVAR_8004
    pl_BufferTMHMMoveName 2, PVAR_8004
    MsgWinCloseAll
    pl_msg_sys 20
UG_ItemBall_Pocket:
    pl_WaitFanfare
    pl_BufferPlayerName 0
    pl_BufferItemName 1, PVAR_8004
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_BufferPocketName 2, PVAR_800C
    MsgWinCloseAll
    pl_msg_sys 19
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn
UG_ItemBall_Full:
    pl_BufferItemName 0, PVAR_8004
    MsgWinCloseAll
    pl_msg_sys 22
    pl_WaitButton
    pl_CloseMessage
    pl_ReleaseAll
    VMReturn

// Pearl common script 205:2: the fanfare by pocket (key items, TMs, the others)
UG_Fanfare:
    pl_GetItemPocket PVAR_8004, PVAR_800C
    pl_CompareVarToValue PVAR_800C, 7
    pl_GoToIf 1, UG_Fanfare_Key
    pl_CompareVarToValue PVAR_800C, 3
    pl_GoToIf 1, UG_Fanfare_TM
    pl_PlayFanfare SEQ_ME_ITEM
    pl_Return
UG_Fanfare_TM:
    pl_PlayFanfare SEQ_ME_WAZA
    pl_Return
UG_Fanfare_Key:
    pl_PlayFanfare SEQ_ME_KEYITEM
    pl_Return
