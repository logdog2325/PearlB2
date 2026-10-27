/* The Pokédex's AREA page and HABITAT list on Sinnoh's town map (b2tools/patches/sinnoh_pokedex.py; HoennB2's
 * hoenn_pokedex.py ITCM functions, written in C). Black 2 functions are called by address (pokebw2 symbols); the
 * tables come from the generated dex_area.h (town_map's a/0/8/4 file 21 layout, the zone -> place table).
 *  - DexLoadRecords(heap): the town map's records (a/0/8/4 #21), for ov298 / ov303 / ov308's func_ov144_0219f718 calls.
 *  - DexFindRecord(records, zone): the zone's record through file 21's zone table (rooms and caves -> their place),
 *    0xffff none, for func_ov144_0219f73c; DexFindRecordSafe: the filler record instead of 0xffff (ov303 has no check).
 *  - HabitatVisited(eventWork, flag): the HABITAT list's "visited" test. Its table's flag field is 0xf000 + place;
 *    the bit of that place in the works PVAR_HABITAT_VISITED_0-3. Other flags: EventWork_FlagGet.
 *  - HabitatDiscover(gameData, zone): SetTeleportZoneDiscover (the town map's arrival flags), then the zone's place is
 *    visited; HM03 in the Bag sets Black 2's surfing flag 0x987 of the list, a rod its fishing flag 0x985. */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#include "dex_area.h"

#define GFL_ArcSysReadHeapNewLZ ((void *(*)(u32, u32, u32, u32))(0x0204B4E4 | 1))
#define EventWork_FlagGet ((u32(*)(void *, u32))(0x020191AC | 1))
#define EventWork_FlagSet ((void (*)(void *, u32))(0x020191D8 | 1))
#define EventWork_GetWkPtr ((u16 *(*)(void *, u32))(0x02019294 | 1))
#define GameData_GetEventWork ((void *(*)(void *))(0x02017394 | 1))
#define GameData_GetBag ((void *(*)(void *))(0x02017354 | 1))
#define BagSave_GetItemCountByID ((u32(*)(void *, u32, u32))(0x02008538 | 1))
#define SetTeleportZoneDiscover ((void (*)(void *, u32))(0x02154F30 | 1))

#define ARC_TOWNMAP_GRA 84
#define TOWNMAP_FILE 21
#define VISITED_BASE 0xF000
#define ITEM_HM03 422
#define FLAG_SURF_OK 0x987
#define FLAG_FISH_OK 0x985

void *DexLoadRecords(u32 heap) {
    return GFL_ArcSysReadHeapNewLZ(ARC_TOWNMAP_GRA, TOWNMAP_FILE, 0, heap);
}

u32 DexFindRecord(const u8 *records, u32 zone) {
    if (zone >= N_ZONES || records[ZT_OFF + zone] == 0xFF) {
        return 0xFFFF;
    }
    return records[ZT_OFF + zone];
}

u32 DexFindRecordSafe(const u8 *records, u32 zone) {
    u32 r = DexFindRecord(records, zone);
    return r == 0xFFFF ? FILLER_RECORD : r;
}

u32 HabitatVisited(void *eventWork, u32 flag) {
    if (flag < VISITED_BASE) {
        return EventWork_FlagGet(eventWork, flag);
    }
    flag -= VISITED_BASE;
    return *EventWork_GetWkPtr(eventWork, kVisitedWorks[flag >> 4]) >> (flag & 15) & 1;
}

void HabitatDiscover(void *gameData, u32 zone) {
    void *bag;
    u32 i;

    SetTeleportZoneDiscover(gameData, zone);
    if (zone < N_ZONES && kZonePlace[zone] != 0xFF) {
        u32 place = kZonePlace[zone];
        *EventWork_GetWkPtr(GameData_GetEventWork(gameData), kVisitedWorks[place >> 4]) |= 1 << (place & 15);
    }
    bag = GameData_GetBag(gameData);
    if (bag == 0) {
        return;
    }
    if (BagSave_GetItemCountByID(bag, ITEM_HM03, 0)) {
        EventWork_FlagSet(GameData_GetEventWork(gameData), FLAG_SURF_OK);
    }
    for (i = 0; i < N_RODS; i++) {
        if (BagSave_GetItemCountByID(bag, kRods[i], 0)) {
            EventWork_FlagSet(GameData_GetEventWork(gameData), FLAG_FISH_OK);
            break;
        }
    }
}
