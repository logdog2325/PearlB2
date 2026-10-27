"""Pearl's Pokétch on the bottom screen in place of the C-Gear (notes/POKETCH.md; decisions 2026-10-26). The code is
the decomp's (src/pearlb2/resident/poketch.c, src/pearlb2/poketch/, tools/pearlb2/link_overlays.py; build_rom puts
its overlays into the ROM, b2tools/pearlb2_overlays.py); this patch puts in what the build makes from Pearl's dump.

apply (files):
- Pearl's graphic/poketch.narc (126 members, Pearl's own art) in place of Black 2's a/2/7/0 (ARC 270, the Funfest
  missions app's graphics: only the Entralink's mission app, overlay 309, reads it, and the Entralink is gone: decision
  2026-10-19). Black 2's C-Gear archive (ARC 287) can't be used: the Pokédex diplomas, the battle recorder and others
  read it too.
- The apps' text: Pearl's banks 405 (Move Tester, 7 lines), 407 (Pokémon History, 1), 408 (Berry Searcher, 1) and
  410 (Link Searcher, 11), converted from Pearl's dump (gen4_text.convert_bank) into one Black 2 text file (20 lines in
  that order: the decomp's POKETCH_TEXT_* in src/pearlb2/poketch/poketch_port.h), packed with pokebw2's own packer
  (tools/text/text_data.py pack_file) and added after Black 2's files of the system text a/0/0/2 (ARC 2), then read
  back line by line. List this patch after every patch that repacks a/0/0/2 from sources (sinnoh_names, text):
  apply_code checks the file is still there and the same.

apply_code (code):
- gPearlB2Poketch (the decomp's include/pearlb2/poketch.h PearlB2PoketchConfig) in the resident section's pool
  (b2tools/resident.py): the sounds' sequence ids, the event work Pearl's Pokétch scene sets (old saves), the art's
  archive, the text's file, the Calculator's dex limits.
- Pearl's Sinnoh dex (poketool/shinzukan, 152 entries) into the Calculator's overlay at gPearlB2SinnohDex. Without this
  patch the bottom screen is Black 2's C-Gear-off screen and the scripts' Pokétch commands only keep the save.

Not here yet: Pearl's 15 Pokétch sounds (imported like Pearl's music: their ids stay 0, silent, until then).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
from gen4rom import Rom  # noqa: E402

NARC_ARC = 270                          # a/2/7/0
NARC_PATH = os.path.join('a', '2', '7', '0')
PEARL_NARC = 'graphic/poketch.narc'
NARC_MEMBERS = 126
FIRST_OVERLAY = 344                     # the system; the 25 apps and the placeholder follow
SE_COUNT = 15
PEARL_GIVEN_VAR = '0x4077'              # Pearl's VAR_JUBILIFE_CITY_STATE: 2 right after GivePoketch (script 2)
PEARL_GIVEN_VALUE = 2
NATIONAL_DEX_MAX = 649                  # decision 2026-10-26: the Calculator's cries up to 649 with the National Dex
PEARL_SINNOH_DEX = 'poketool/shinzukan.narc'
SINNOH_DEX_COUNT, SINNOH_DEX_ENTRIES = 151, 152  # Pearl's Sinnoh numbers 1-151; its table has an entry 0 too
TEXT_ARC = 2                            # a/0/0/2, Black 2's system text (ARCID_SYSTEM_MESSAGE)
TEXT_BANKS = (405, 407, 408, 410)       # Pearl's Pokétch banks, in the decomp's POKETCH_TEXT_* order
TEXT_LINES = 20
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')


def apply(files):
    narc = Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read(PEARL_NARC)
    count = struct.unpack_from('<H', narc, 0x10 + 8)[0] if narc[0x10:0x14] == b'BTAF' else None
    assert narc[:4] == b'NARC' and count == NARC_MEMBERS, f'{PEARL_NARC}: {count} members, not {NARC_MEMBERS}'
    path = os.path.join(files, NARC_PATH)
    assert os.path.exists(path), f'{path}: Black 2\'s archive 270 is missing'
    if os.path.islink(path):
        os.unlink(path)
    open(path + '.tmp', 'wb').write(narc)
    os.replace(path + '.tmp', path)
    text = install_text(files)
    return f'poketch: Pearl\'s {PEARL_NARC} ({len(narc)} B, {count} members) in place of {NARC_PATH}; {text}'


# ---- the apps' text ---------------------------------------------------------------------------------------------------
def text_tools():
    sys.path.insert(0, DECOMP)
    from tools.text import text_data      # pokebw2's packer (read-only use of external/)
    return text_data


def text_source():
    """The Pokétch's 20 lines as a res/text file (`ID = text` lines), converted from Pearl's dump."""
    import gen4_text
    rows = []
    for bank in TEXT_BANKS:
        for i, line, error in gen4_text.convert_bank(bank, os.path.join(ROOT, 'roms', 'pearl.nds')):
            assert error is None and line is not None, f'Pearl bank {bank} line {i}: {error}'
            rows.append(f'PearlPoketch_{bank}_{i:02d} = {line}\n')
    assert len(rows) == TEXT_LINES, f'Pearl\'s Pokétch banks {TEXT_BANKS}: {len(rows)} lines, not {TEXT_LINES}'
    return ''.join(rows)


def text_file_number():
    """The text's file in a/0/0/2: the first after Black 2's own."""
    import narcio, pokebw2_mod
    return len(narcio.read_narc(pokebw2_mod.vanilla('a/0/0/2')))


def text_check(files, number, source):
    """Reads the file back and compares it with its source line by line (None: equal, else the difference)."""
    import narcio
    td = text_tools()
    entries = narcio.load(files, TEXT_ARC)
    if len(entries) <= number:
        return f'a/0/0/2 has {len(entries)} files: the Pokétch\'s text (file {number}) is not there'
    got = [l for l in td.unpack_file(entries[number]).split('\n')[:-1] if not l.startswith('\\pad{')]
    want = [td.split_message(l)[1] for l in source.split('\n')[:-1]]
    if got != want:
        bad = next(i for i in range(max(len(got), len(want))) if i >= len(got) or i >= len(want) or got[i] != want[i])
        return f'a/0/0/2 file {number} reads back differently at line {bad}: {(got + [None])[bad]!r} != ' \
               f'{(want + [None])[bad]!r}'
    return None


def install_text(files):
    import narcio
    td = text_tools()
    source = text_source()
    number = text_file_number()
    entries = narcio.load(files, TEXT_ARC)
    assert len(entries) == number, (f'a/0/0/2 has {len(entries)} files, not Black 2\'s {number}: another patch added '
                                    f'files there (the Pokétch\'s text goes at {number})')
    entries.append(td.pack_file(source))
    narcio.save(files, TEXT_ARC, entries)
    error = text_check(files, number, source)
    if error:
        raise SystemExit(f'poketch: {error}')
    return f'the apps\' text ({TEXT_LINES} lines of Pearl\'s banks {"/".join(map(str, TEXT_BANKS))}) as a/0/0/2 file ' \
           f'{number}, read back equal'


def narc_member(narc, index):
    """A member of a NARC (BTAF, BTNF, GMIF)."""
    assert narc[:4] == b'NARC' and narc[0x10:0x14] == b'BTAF', 'not a NARC'
    btaf_size, count = struct.unpack_from('<IH', narc, 0x14)
    start, end = struct.unpack_from('<II', narc, 0x1C + 8 * index)
    btnf = 0x10 + btaf_size
    gmif = btnf + struct.unpack_from('<I', narc, btnf + 4)[0]
    assert narc[gmif:gmif + 4] == b'GMIF' and index < count
    return narc[gmif + 8 + start:gmif + 8 + end]


def sinnoh_dex():
    """Pearl's Sinnoh dex: [n] = the species of Sinnoh number n (SinnohDexNoToSpecies), as Pearl has it."""
    data = narc_member(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read(PEARL_SINNOH_DEX), 0)
    assert len(data) == 2 * SINNOH_DEX_ENTRIES, f'{PEARL_SINNOH_DEX}: {len(data)} bytes'
    table = struct.unpack(f'<{SINNOH_DEX_ENTRIES}H', data)
    assert table[1] == 387 and all(0 < sp <= 493 for sp in table), f'{PEARL_SINNOH_DEX}: not Pearl\'s Sinnoh dex'
    return data


def fill_sinnoh_dex(code):
    """Pearl's Sinnoh dex at the Calculator's gPearlB2SinnohDex, in its overlay's file (the apps share one address, so
    by the Calculator's own overlay)."""
    import decomp
    n = FIRST_OVERLAY + 1 + 1                       # the Calculator: app 1
    addr, start = decomp.symbol('gPearlB2SinnohDex', code), decomp.symbol(f'OV{n}_TEXT_START', code)
    assert addr is not None and start is not None, 'the decomp has no gPearlB2SinnohDex or no Calculator overlay'
    path = os.path.join(code, f'arm9_ov{n:03d}.bin')
    blob = bytearray(open(path, 'rb').read())
    data, at = sinnoh_dex(), addr - start
    assert struct.unpack_from('<H', blob, at)[0] == 0xFFFF, f'gPearlB2SinnohDex in overlay {n}: not the empty table'
    blob[at:at + len(data)] = data
    if os.path.islink(path):
        os.unlink(path)
    open(path + '.tmp', 'wb').write(blob)
    os.replace(path + '.tmp', path)
    return f'gPearlB2SinnohDex in overlay {n}'


def config_blob(base, text_file):
    ids = json.load(open(os.path.join(ROOT, 'data', 'pearl_story_ids.json')))
    given_work = int(ids['vars'][PEARL_GIVEN_VAR]['b2'], 16)
    se = [0] * SE_COUNT                             # Pearl's sounds: not imported yet (silent)
    blob = struct.pack(f'<{SE_COUNT}H7H', *se, given_work, PEARL_GIVEN_VALUE, NARC_ARC, TEXT_ARC, text_file,
                       SINNOH_DEX_COUNT, NATIONAL_DEX_MAX)
    assert len(blob) == 44                          # PearlB2PoketchConfig
    return blob, given_work


def apply_code(code):
    import decomp, resident
    slot = decomp.symbol('gPearlB2Poketch', code)
    assert slot is not None, 'the decomp has no gPearlB2Poketch (its src/pearlb2/resident/poketch.c)'
    assert decomp.symbol(f'OV{FIRST_OVERLAY}_TEXT_START', code) is not None, 'the decomp has no Pokétch overlays'
    msg = fill_sinnoh_dex(code)
    info = {}
    # The text apply() added: still there and the same (a patch after this one that repacks a/0/0/2 would drop it)
    text_file = text_file_number()
    error = text_check(os.path.join(os.path.dirname(os.path.abspath(code)), 'files'), text_file, text_source())
    assert error is None, f'poketch: {error}'

    def build(base):
        blob, info['given'] = config_blob(base, text_file)
        return blob, {}
    base, end, _ = resident.install(code, build)
    assert resident.read(code, slot, 4) == bytes(4), f'gPearlB2Poketch at {slot:#x}: not NULL'
    resident.write(code, slot, struct.pack('<I', base))
    return (f'poketch: {msg}; its data {end - base} B at {base:#x} (old saves: work {info["given"]:#x} >= '
            f'{PEARL_GIVEN_VALUE}; the text a/0/0/2 file {text_file}); sounds not imported yet')
