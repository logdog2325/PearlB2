"""The regional Pokédex is Pearl's Sinnoh Pokédex (2026-10-20; HoennB2's patches/hoenn_dex.py, its v15.3 hotfix, ported).
Data only: two archive files are rewritten at their original sizes, so the ROM layout (and every savestate) stays the
same, and saves need no repair (a save keeps seen and caught flags by national number, never a regional one).

Why (HoennB2 found it as a crash): Black 2 builds the regional list (ov302 func_ov302_021ae210) from a/0/9/7 file 4
(every species, the regional ones last in regional order), keeping the species whose number in a/0/1/6 file 709
(PML_PersonalLoadRegionalDexTable: one u16 per species, 999 = not in the dex) isn't 999; the count is the index of the
last seen or caught entry + 1. With Victini (Unova's hidden #000) unseen the list starts at entry 1 and passes count - 1
on (func_ov302_021ad0e8). A Pearl player has seen no Unova Pokémon (the starters are Turtwig, Chimchar, Piplup), so
that is 0 - 1 = 0xffff: ov299 tries to allocate 65535 entries and the game shows "An error has occurred" on opening
the Pokédex.

The fix: Pearl's 151 Sinnoh species numbered 1-151 in Pearl's order (the user's Pearl dump, poketool/shinzukan.narc
member 0: u16 national number per Sinnoh number, index 0 unused; pokediamond SinnohDexNoToSpecies, SINNOH_DEX_COUNT
151: Turtwig #1 .. Palkia #150, Manaphy #151). Victini stays the hidden #000 (the engine still skips entry 0 until it
is seen); every other species 999. The start menu's seen count and the summary screen's number follow the same table.

Code (apply_code, 2026-10-20, the pokedex agent): Black 2's "regional Pokédex complete" is Unova's number.
PokeDex_IsCompleteUnova / PokeDex_IsSeenAllUnova (arm9 0x0200da44 / 0x0200da5c, pokebw2 src/system/pokedex.c) compare
the regional count without UNOVA_DEX_COMPLETION_EXCLUSIONS (0x0208f80c: Keldeo, Meloetta, Genesect, Victini) with
UNOVA_DEX_COMPLETE 297 (a literal in each). With Sinnoh's 151 that was never reached, so Pearl's National Pokédex
upgrade (Rowan's CheckLocalDexCompleted = script PokeDexIsComplete 2) could never happen. Pearl's rule (pokediamond
arm9/src/pokedex.c Pokedex_SinnohDexIsComplete): Sinnoh seen without Manaphy >= 150. So: the exclusion list's Keldeo
(not in the Sinnoh list anyway) -> Manaphy, and both literals 297 -> 150. Black 2's own Juniper rating tables
(PokeDex_GetEvaluationParams) are not used in Sinnoh (Rowan's rating: src/field_scripts/1260_global_pokedex_rating.s).
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, version  # noqa: E402
from b2files import arc_path  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

ARC_PERSONAL, FILE_REGIONAL = 16, 709      # a/0/1/6 file 709: u16 regional number per species (999 = not in it)
ARC_SORT, FILE_REGIONAL_ORDER = 97, 4      # a/0/9/7 file 4: species 1-649, the regional ones last in regional order
NONE = 999
VICTINI = 494
SINNOH_COUNT = 151


def sinnoh_order():
    """National numbers of Sinnoh #1..#151 (Pearl's order, from the user's dump)."""
    d = narc_members(Rom(version.SOURCE_DUMP).read('poketool/shinzukan.narc'))[0]
    order = list(struct.unpack_from(f'<{SINNOH_COUNT}H', d, 2))       # index 0 is unused
    assert len(set(order)) == SINNOH_COUNT and order[0] == 387 and order[-2:] == [484, 490], order[:3]
    return order


def apply(files):
    order = sinnoh_order()
    size = {a: os.path.getsize(arc_path(files, a)) for a in (ARC_PERSONAL, ARC_SORT)}

    personal = narcio.load(files, ARC_PERSONAL)
    old = personal[FILE_REGIONAL]
    table = [NONE] * (len(old) // 2)
    table[VICTINI] = 0
    for n, species in enumerate(order, 1):
        table[species] = n
    personal[FILE_REGIONAL] = struct.pack(f'<{len(table)}H', *table)
    assert len(personal[FILE_REGIONAL]) == len(old)
    narcio.save(files, ARC_PERSONAL, personal)

    sort = narcio.load(files, ARC_SORT)
    old = sort[FILE_REGIONAL_ORDER]
    n_species = len(old) // 2
    regional = [VICTINI] + order
    rest = [s for s in range(1, n_species + 1) if s not in set(regional)]
    sort[FILE_REGIONAL_ORDER] = struct.pack(f'<{n_species}H', *(rest + regional))
    assert len(sort[FILE_REGIONAL_ORDER]) == len(old)
    narcio.save(files, ARC_SORT, sort)

    for a, n in size.items():
        assert os.path.getsize(arc_path(files, a)) == n, f'a/{a:03d} changed size: the ROM layout must stay the same'
    return f'sinnoh_dex: regional Pokédex = Sinnoh #1-#{SINNOH_COUNT} (Victini kept as the hidden #000), sizes unchanged'


ARM9 = 0x02004000
COMPLETE_LITERALS = (0x0200DA58, 0x0200DA70)     # the 297 of PokeDex_IsCompleteUnova / PokeDex_IsSeenAllUnova
EXCLUSIONS = 0x0208F80C                          # UNOVA_DEX_COMPLETION_EXCLUSIONS: 4 u16
UNOVA_COMPLETE, SINNOH_COMPLETE = 297, 150       # pokediamond Pokedex_SinnohDexIsComplete: seen (no Manaphy) >= 150
KELDEO, MANAPHY = 647, 490


def apply_code(code):
    """Sinnoh's completion rule (module docstring "Code")."""
    p = os.path.join(code, 'arm9.bin')
    d = bytearray(open(p, 'rb').read())
    for at in COMPLETE_LITERALS:
        o = at - ARM9
        assert struct.unpack_from('<I', d, o)[0] in (UNOVA_COMPLETE, SINNOH_COMPLETE), f'{at:#x}: not the 297 literal'
        struct.pack_into('<I', d, o, SINNOH_COMPLETE)
    o = EXCLUSIONS - ARM9
    ex = list(struct.unpack_from('<4H', d, o))
    assert ex in ([KELDEO, 648, 649, VICTINI], [MANAPHY, 648, 649, VICTINI]), ex
    struct.pack_into('<4H', d, o, MANAPHY, 648, 649, VICTINI)
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)
    return f'sinnoh_dex: regional Pokédex complete = {SINNOH_COMPLETE} seen/caught without Manaphy (was Unova\'s 297)'
