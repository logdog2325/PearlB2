/* Pearl's three fishing rods (user 2026-10-18: "three real rods"), from HoennB2's b2tools/patches/rods.c (rods_fix):
 * the Old Rod and the Good Rod work like Black 2's Super Rod (Bag "Use", Register on Y), and each rod fishes its own
 * Pearl table with Pearl's odds (Gen 4, pokeplatinum src/overlay006/wild_encounters.c: Old Rod 60/30/5/4/1, Good and
 * Super Rod 40/40/15/4/1 = Black 2's own fishing odds). Installed by b2tools/patches/pearl_rods.py.
 *
 * Tables (patches/sinnoh_encounters.py, ROD_LAYOUT 'pearl3'): each Pearl zone's file holds 4 tables; tables 0-2 (the
 * time of day) have the Super Rod's slots in their fishing group; table 3 (never picked by the time of day) holds the
 * Old Rod's slots in its fishing group and the Good Rod's in its rippling-fishing group. The Super Rod = Black 2's own
 * path, unchanged. The rod being used: ROD_ITEM, a u16 just before this code in ITCM (0 at boot, not saved). */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#ifndef ROD_VAR
#error "ROD_VAR (the address of the rod variable) comes from pearl_rods.py"
#endif
#define ROD_ITEM (*(volatile u16 *)ROD_VAR)

#define ITEM_OLD_ROD   445
#define ITEM_GOOD_ROD  446
#define ITEM_SUPER_ROD 447
#define SC_SUPER_ROD 4
#define SC_OLD_ROD   7      /* the Y shortcut ids of Black 2's DNA Splicers (not in Sinnoh) */
#define SC_GOOD_ROD  8

#define FN(type, addr) ((type)((addr) | 1))
#define GFL_RandomLC                      FN(u32 (*)(u32), 0x02005748)
#define ShortcutMenu_SetKeyItemID         FN(u32 (*)(void *, u32), 0x0215b010)
#define ShortcutMenu_GetActionFromKeyItem FN(u32 (*)(u32, u32 *, u32 *), 0x0215b1ec)
#define EncData_Load                      FN(u32 (*)(void *, void *, u16, u8), 0x021590ec)   /* ov012 */
#define FieldEncount_GenWildsCore         FN(u32 (*)(void *, void *, void *), 0x021a0bf4)
#define FieldEncount_GenWilds             FN(u32 (*)(const u8 *, void *, u32, void *), 0x021a0c38)
#define FieldEncount_PrepareActiveSlots   FN(u32 (*)(const u8 *, void *, u32, void *), 0x021a1238)
#define BagUseSuperRod                    FN(u32 (*)(void *), 0x0219a404)

#define BAG_SELECTED_ITEM 0x8a0
#define ENC_SIZE 0xe8
#define ENC_FISHING 0xc0            /* EncData: 8 rate bytes, 12+12+12 grass, 5 surf, 5 rippling surf, then fishing */
#define ENC_RIPPLING_FISHING 0xd4
#define EVENTDATA_ENCARC 8          /* EncountSystem's encData is &EventData->encData (offset 56): event_data.h */
#define EVENTDATA_ENCDATA 56
#define ROD_TABLE 3
#define RATE_FISHING 5              /* EncData userData[ENCTYPE_FISHING], [ENCTYPE_FISHING_RARE] */
#define RATE_RIPPLING_FISHING 6

typedef struct { u16 species; u8 minLevel; u8 maxLevel; } Slot;

u32 Rod_BagUse(u8 *work) {
    ROD_ITEM = (u16)*(u32 *)(work + BAG_SELECTED_ITEM);
    return BagUseSuperRod(work);
}

u32 Rod_SetKeyItemID(void *input, u32 sc) {
    if (sc == SC_OLD_ROD) ROD_ITEM = ITEM_OLD_ROD;
    else if (sc == SC_GOOD_ROD) ROD_ITEM = ITEM_GOOD_ROD;
    else if (sc == SC_SUPER_ROD) ROD_ITEM = ITEM_SUPER_ROD;
    if (sc == SC_OLD_ROD || sc == SC_GOOD_ROD) sc = SC_SUPER_ROD;
    return ShortcutMenu_SetKeyItemID(input, sc);
}

u32 Rod_GetAction(u32 sc, u32 *action, u32 *invalid) {
    if (sc == SC_OLD_ROD || sc == SC_GOOD_ROD) sc = SC_SUPER_ROD;
    return ShortcutMenu_GetActionFromKeyItem(sc, action, invalid);
}

/* BtlSetup_CreateFishing's FieldEncount_GenWilds (after the bite roll). Old / Good Rod: the zone's table 3, the rod's
 * group, Pearl's odds; the picked Pokémon fills every active slot, then Black 2's own steps (levels, Repel, abilities).
 * Black 2 rolled the bite with the Super Rod's rate byte (enc's fishing rate); a second roll makes the Old / Good Rod
 * bite at their own Pearl rate: (rod byte + 1) / (Super Rod byte + 1). Returns 0 (Black 2: "Not even a nibble") when
 * that roll fails or the zone has no such slot. */
u32 Rod_GenWilds(const u8 *enc, void *manager, u32 zone, void *out) {
    u32 rod = ROD_ITEM, r, i, k;
    u8 table[ENC_SIZE];
    const Slot *own;
    Slot slots[12];

    if (rod != ITEM_OLD_ROD && rod != ITEM_GOOD_ROD) return FieldEncount_GenWilds(enc, manager, zone, out);
    if (!EncData_Load(table, *(void **)(enc - EVENTDATA_ENCDATA + EVENTDATA_ENCARC), (u16)zone, ROD_TABLE)) return 0;
    if (GFL_RandomLC(enc[RATE_FISHING] + 1) > table[rod == ITEM_OLD_ROD ? RATE_FISHING : RATE_RIPPLING_FISHING]) return 0;
    r = GFL_RandomLC(100);
    if (rod == ITEM_OLD_ROD) i = r < 60 ? 0 : r < 90 ? 1 : r < 95 ? 2 : r < 99 ? 3 : 4;
    else i = r < 40 ? 0 : r < 80 ? 1 : r < 95 ? 2 : r < 99 ? 3 : 4;
    own = (const Slot *)(table + (rod == ITEM_OLD_ROD ? ENC_FISHING : ENC_RIPPLING_FISHING)) + i;
    if (own->species == 0) return 0;
    FieldEncount_PrepareActiveSlots(enc, manager, zone, slots);
    for (k = 0; k < 12; k++) slots[k] = *own;
    return FieldEncount_GenWildsCore(manager, slots, out);
}
