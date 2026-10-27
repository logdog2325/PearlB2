"""Pal Park's migration from the GBA games and Catching Show (notes/PAL_PARK_MIGRATION.md): the data the decomp's C reads.

apply(files):
- Pokéstar Studios' archive 271 (a/2/7/1, read only by Pokéstar's overlays 321, 323 and 324: notes/DATA.md) becomes
  Pearl's graphic/mystery.narc, its LZ members stored unpacked (Black 2's cell loaders take no compressed flag) and
  one member more, 42: the migration screen's text, Pearl's bank 403 word for word (46 lines) then PearlB2's YES and
  NO (Black 2's own words for its yes/no menus), packed with pokebw2's packer and read back.
apply_code(code):
- PalParkConfig (include/pearlb2/palpark.h) into the resident pool, gPearlB2PalPark pointing at it: Pal Park's zone,
  the archive and text member, Pearl's arc/ppark.narc for National Dex 1-386 (land area, water area, catching points,
  rarity: Platinum's SpeciesPalPark).
List after sinnoh_story (the zones) and after the Pokétch's patch (the resident section and its pool).
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
from gen4rom import Rom, narc_members  # noqa: E402

ART_ARC = 271
PEARL_ART = 'graphic/mystery.narc'
ART_MEMBERS = 42
TEXT_MEMBER = 42
TEXT_BANK = 403
TEXT_LINES = 46
EXTRA_LINES = ['YES', 'NO']               # lines 46, 47 (migrate_app.c TEXT_YES, TEXT_NO)
PPARK = 'arc/ppark.narc'
PPARK_SPECIES = 386
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')


def pearl():
    return Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))


def text_tools():
    sys.path.insert(0, DECOMP)
    from tools.text import text_data      # pokebw2's packer (read-only use of external/)
    return text_data


def text_source():
    import gen4_text
    rows = []
    for i, line, error in gen4_text.convert_bank(TEXT_BANK, os.path.join(ROOT, 'roms', 'pearl.nds')):
        assert error is None and line is not None, f'Pearl bank {TEXT_BANK} line {i}: {error}'
        rows.append(f'PearlMigrate_{i:02d} = {line}\n')
    assert len(rows) == TEXT_LINES, f'Pearl\'s bank {TEXT_BANK}: {len(rows)} lines, not {TEXT_LINES}'
    rows += [f'PalParkMigrate_{k} = {t}\n' for k, t in enumerate(EXTRA_LINES)]
    return ''.join(rows)


def art_members():
    import title_art
    members = narc_members(pearl().read(PEARL_ART))
    assert len(members) == ART_MEMBERS, f'{PEARL_ART}: {len(members)} members, not {ART_MEMBERS}'
    return [title_art.lz10_decompress(m) if m[:1] == b'\x10' else m for m in members]


def apply(files):
    import narcio
    td = text_tools()
    source = text_source()
    entries = art_members() + [td.pack_file(source)]
    narcio.save(files, ART_ARC, entries)
    got = narcio.load(files, ART_ARC)
    lines = [l for l in td.unpack_file(got[TEXT_MEMBER]).split('\n')[:-1] if not l.startswith('\\pad{')]
    want = [td.split_message(l)[1] for l in source.split('\n')[:-1]]
    assert lines == want, 'pal_park: the migration text reads back differently'
    return (f'pal_park: archive {ART_ARC} = Pearl\'s {PEARL_ART} ({ART_MEMBERS} members, unpacked) + the migration text '
            f'(member {TEXT_MEMBER}: Pearl\'s bank {TEXT_BANK}, {len(EXTRA_LINES)} lines of our own), read back equal')


def ppark_table():
    data = narc_members(pearl().read(PPARK))[0]
    out = b''
    for sp in range(1, PPARK_SPECIES + 1):
        land, water, points, rarity = data[(sp - 1) * 6:(sp - 1) * 6 + 4]
        assert land or water, f'{PPARK}: species {sp} has no area'
        out += bytes([land, water, points, rarity])
    return out


def park_zone():
    sys.path.insert(0, os.path.dirname(HERE))
    import pearl_story
    pd = pearl_story.PearlData()
    return pd.b2_zone[pd.by_name['MAP_PAL_PARK']['id']]


def apply_code(code):
    import decomp, resident
    slot = decomp.symbol('gPearlB2PalPark', code)
    assert slot is not None, 'the decomp has no gPearlB2PalPark (its src/pearlb2/resident/palpark.c)'
    zone = park_zone()

    def build(base):
        return struct.pack('<HHHH', zone, ART_ARC, TEXT_MEMBER, 0) + ppark_table(), {}
    base, end, _ = resident.install(code, build)
    assert resident.read(code, slot, 4) in (bytes(4), struct.pack('<I', base)), f'gPearlB2PalPark at {slot:#x}: set'
    resident.write(code, slot, struct.pack('<I', base))
    return f'pal_park: PalParkConfig {end - base} B at {base:#x} (Pal Park zone {zone}, archive {ART_ARC})'
