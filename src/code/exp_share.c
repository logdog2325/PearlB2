/* The Gen 6 Exp. Share in Pearl NDS (patches/exp_share.py, which has the hook sites): two small helpers in ITCM, linked
 * by b2tools/itcm.py. Black 2 functions are called by address.
 *
 * The Exp. Share works while the player has received it and has not switched it off in the Bag:
 *   FLAG_RECEIVED = Pearl's PFLAG_010B (FLAG_RECEIVED_ROUTE_206_CYCLING_ROAD_NORTH_GATE_EXP_SHARE): Pearl's gate script
 *     sets it as the scientist gives the item; Rowan's Exp. Share question sets it in the intro (YES).
 *   FLAG_OFF = PFLAG_EXP_SHARE_OFF (b2tools/pearl_ids.py NEW_FLAGS): the Bag's Use flips it. Clear = on, so the item
 *     works the moment it is received, as Gen 6 gives it, without any change to Pearl's gift script.
 * Both are -D defines from exp_share.py (src/include/pearl.h).
 *
 * ExpShare_IsOn: called by the battle's exp code (ov167 AddExpAndEVs, the old held-Exp.-Share block).
 * NewGame_InitBag: ov035 EventFieldFirst_Create's `bl InitItemBag` (a new game's Bag, made after the intro: ov279
 *   InitItemBag clears it and adds Black 2's starting key items) calls this instead: Black 2's InitItemBag, then the
 *   Exp. Share when Rowan's question was answered YES (it can't be given in the intro: the Bag is rebuilt here). */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#define FN(type, addr) ((type)((addr) | 1))
#define SaveControl_GetInstance FN(void *(*)(void), 0x020072fc)
#define getConstDataBlock       FN(void *(*)(void *), 0x02017a5c)      /* the save's EventWork (block 0x2d) */
#define EventWork_FlagGet       FN(u32 (*)(void *, u32), 0x020191ac)
#define GameData_GetEventWork   FN(void *(*)(void *), 0x02017394)
#define GameData_GetBag         FN(void *(*)(void *), 0x02017354)
#define BagSave_AddItem         FN(u32 (*)(void *, u32, u32, u32), 0x02008268)
#define InitItemBag             FN(void (*)(void *, u32), 0x021e8c64)  /* ov279, loaded around the call */
#define ITEM_EXP_SHARE          216

u32 ExpShare_IsOn(void) {
    void *ew = getConstDataBlock(SaveControl_GetInstance());
    return EventWork_FlagGet(ew, FLAG_RECEIVED) && !EventWork_FlagGet(ew, FLAG_OFF);
}

void NewGame_InitBag(void *gameData, u32 heapId) {
    InitItemBag(gameData, heapId);
    if (EventWork_FlagGet(GameData_GetEventWork(gameData), FLAG_RECEIVED))
        BagSave_AddItem(GameData_GetBag(gameData), ITEM_EXP_SHARE, 1, heapId);
}
