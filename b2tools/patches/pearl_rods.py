"""Pearl's three fishing rods (user 2026-10-18: "Three real rods": Old, Good and Super Rod as in Pearl, reusing
HoennB2's rods code). Adapted from HoennB2 b2tools/patches/rods.py (its findings, addresses and tests, 2026-10-12);
the code is src/code/rods.c, the tables come from patches/sinnoh_encounters.py (ROD_LAYOUT 'pearl3').

What Black 2 has (HoennB2's notes, rechecked in pokebw2's C here):
  - Only the Super Rod (447) fishes. Items 445/446 are Gen 4 leftovers: a/0/2/4 +8 bits 5/6 clear (Give, no
    Register), +0xA = 0 (no Use); the Good Rod's +0x10 = 1 sends its Bag "Use" down the use-on-a-Pokémon path.
  - Bag Use: ov142 key-item table 0x021A0980 entry 4 {447, 1, func_ov142_0219a404} -> fishing (common event 4).
  - Register: arm9 data_020929f8 (13 x u16 {item, Y shortcut id << 10}); the Y menu names shortcut ids by system
    text 365 (pokebw2 res/text/system/ability_handlers_4.txt, line = id) and runs them through ov012
    ShortcutMenu_SetKeyItemID / ShortcutMenu_GetActionFromKeyItem.
  - Fishing: BtlSetup_CreateFishing (ov036 src/ov036/field_encount.c): no fish when the table's fishing rate is 0,
    bite roll (rate byte + abilities), then FieldEncount_GenWilds (enc = &EventData->encData).
What this patch does:
  1. a/0/2/4 items 445, 446: Use + Register, no Give (the Super Rod's flags and field use); Good Rod +0x10 -> 0.
  2. ov142 key-item table entry 4 -> {445, 3, Rod_BagUse}: remembers the rod, then Black 2's Super Rod handler.
  3. arm9 shortcut table entries 10/11 (DNA Splicers 628 -> 7, 629 -> 8; not in Sinnoh) -> Old Rod 7, Good Rod 8;
     their Y-menu names: data/text_overrides/rods.json (applied by patches/sinnoh_names.py).
  4. ov012 Y-menu calls -> Rod_GetAction / Rod_SetKeyItemID (shortcuts 7/8 remember the rod, act as 4).
  5. ov036 0x021A1A82: bl FieldEncount_GenWilds -> Rod_GenWilds (Old/Good Rod: table 3's slots with Pearl's odds and
     bite rate; Super Rod: Black 2's own call on the time-of-day table).
The rod variable is a u16 in ITCM just before the code (0 at boot, not saved: 0 = the Super Rod).
"""
import os, struct, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, itcm  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
OV012, OV036, OV142 = 0x021503C0, 0x0217F600, 0x021998C0      # pokebw2 config/b2_us/arm9/overlays.yaml
ITEM_OLD_ROD, ITEM_GOOD_ROD, ITEM_SUPER_ROD = 445, 446, 447
FIELD_USE_ROD = 18                       # a/0/2/4 +0xA of the Super Rod
KEY_FLAGS = 0x60                         # a/0/2/4 +8 bit 5 (no Give/Toss), bit 6 (Register)
KEY_ITEM_USE_ENTRY = 0x021A0980 + 4 * 8  # ov142: entry 4 of the Bag's key-item Use table
SUPER_ROD_HANDLER = 0x0219A404           # func_ov142_0219a404
SHORTCUT_TABLE = 0x020929F8              # arm9 data_020929f8
SHORTCUTS = {10: (628, 7, ITEM_OLD_ROD), 11: (629, 8, ITEM_GOOD_ROD)}   # entry: (Black 2's item, id, rod)
SET_KEY_ITEM_ID, GET_ACTION = 0x0215B010, 0x0215B1EC
OV012_CALLS = [(0x0215AC4A, GET_ACTION, 'Rod_GetAction'), (0x0215AC54, SET_KEY_ITEM_ID, 'Rod_SetKeyItemID'),
               (0x0215AE80, SET_KEY_ITEM_ID, 'Rod_SetKeyItemID'), (0x0215AE8C, GET_ACTION, 'Rod_GetAction')]
GEN_WILDS_CALL, GEN_WILDS = 0x021A1A82, 0x021A0C38


def _put(d, base, addr, old, new, what):
    o = addr - base
    cur = bytes(d[o:o + len(new)])
    assert cur in (old, new), f'{what} at {addr:#x}: {cur.hex()} (expected {old.hex()})'
    d[o:o + len(new)] = new


def _edit(code, name, fn):
    p = os.path.join(code, name)
    d = bytearray(open(p, 'rb').read())
    fn(d)
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)


def apply(files):
    entries, vanilla = narcio.load(files, 24), narcio.load(VANILLA, 24)
    for item in (ITEM_OLD_ROD, ITEM_GOOD_ROD):
        d = bytearray(entries[item])
        assert bytes(d) == vanilla[item] or d[10] == FIELD_USE_ROD, f'item {item}: unexpected data {bytes(d).hex()}'
        struct.pack_into('<H', d, 8, struct.unpack_from('<H', d, 8)[0] | KEY_FLAGS)
        d[10] = FIELD_USE_ROD
        assert d[0x10] in (0, 1), f'item {item}: +0x10 = {d[0x10]}'
        d[0x10] = 0
        entries[item] = bytes(d)
    narcio.save(files, 24, entries)
    return f'pearl_rods: items {ITEM_OLD_ROD}, {ITEM_GOOD_ROD}: Use + Register, no Give'


def apply_code(code):
    src = os.path.join(ROOT, 'src', 'code', 'rods.c')
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        def build(base):                  # the rod variable (u16, padded to 4) at base, the code after it
            blob, sym = itcm.build(src, base + 4, tmp, defines=[f'-DROD_VAR={base:#x}'])
            return bytes(4) + blob, sym
        base, end, sym = itcm.install(code, build)

    def arm9(d):
        for i, (old_item, sc, rod) in SHORTCUTS.items():
            _put(d, itcm.ARM9, SHORTCUT_TABLE + 2 * i, struct.pack('<H', old_item | sc << 10),
                 struct.pack('<H', rod | sc << 10), 'shortcut table')
    _edit(code, 'arm9.bin', arm9)
    _edit(code, 'arm9_ov142.bin', lambda d: _put(
        d, OV142, KEY_ITEM_USE_ENTRY, struct.pack('<HHI', ITEM_SUPER_ROD, 1, SUPER_ROD_HANDLER | 1),
        struct.pack('<HHI', ITEM_OLD_ROD, 3, sym['Rod_BagUse'] | 1), 'key-item Use table'))

    def ov012(d):
        for at, old, new in OV012_CALLS:
            _put(d, OV012, at, itcm.bl(at, old), itcm.bl(at, sym[new] & ~1), f'bl {old:#x}')
    _edit(code, 'arm9_ov012.bin', ov012)
    _edit(code, 'arm9_ov036.bin', lambda d: _put(
        d, OV036, GEN_WILDS_CALL, itcm.bl(GEN_WILDS_CALL, GEN_WILDS), itcm.bl(GEN_WILDS_CALL, sym['Rod_GenWilds'] & ~1),
        'BtlSetup_CreateFishing: bl FieldEncount_GenWilds'))
    return (f'pearl_rods: {end - base} B of ITCM at {base:#x} (rod variable {base:#x}); Bag Use 445-447, '
            f'Y shortcuts 7/8, Old/Good Rod from table 3')


if __name__ == '__main__':                      # compile and link at a dummy base (a syntax and size check)
    with tempfile.TemporaryDirectory() as tmp:
        blob, sym = itcm.build(os.path.join(ROOT, 'src', 'code', 'rods.c'), 0x01FFDE04, tmp,
                               defines=['-DROD_VAR=0x01FFDE00'])
        print(len(blob), {k: hex(v) for k, v in sym.items() if k.startswith('Rod_')})
