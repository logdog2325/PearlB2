"""Pal Park's migration from the GBA games, the offline half (notes/PAL_PARK_MIGRATION.md).

    python3 b2tools/gba_migrate.py tables            write the C tables (decomp include/pearlb2/palpark_tables.h)
    python3 b2tools/gba_migrate.py show SAVE.sav     the newest slot's PC boxes, as the game will read them
    python3 b2tools/gba_migrate.py testcart OUT_DIR [GAME]   a synthetic cart: OUT_DIR/test_GAME.gba (a header only:
                                                     no game code) and OUT_DIR/test_GAME.sav (a save with boxes made
                                                     here), for DeSmuME's slot-2 cartridge (no user dump needed)

What the game's C does (decomp src/pearlb2/palpark/), done here the same way so the two can be compared:
- the save (pokeemerald / pokefirered save.c, Platinum's ov97_02235D18.c): 128 KiB of flash, two slots of 14 sectors
  of 4 KiB (3,968 data bytes, the footer at 0xFF4: u16 section id, u16 checksum, u32 0x08012025, u32 save counter),
  the sections rotated; the newest complete slot by its counter; sections 5-13 the PC (u32 current box, 14 x 30 boxed
  Pokémon of 80 bytes, names, wallpapers; 33,744 bytes);
- a boxed Pokémon (pokeemerald pokemon.h BoxPokemon): its 48 secure bytes XORed with (OT id ^ PID), four substructs
  ordered by PID % 24, the checksum the u16 sum of the decrypted 48 bytes (a mismatch: a Bad Egg);
- the conversion to Black 2 follows Platinum's BoxMonGBAToBoxMon (gba_pokemon.c) for what Gen 4 kept, and Gen 5's
  own fields as Poké Transfer sets them (nature PID % 25, no hidden ability, region = the GBA language).
Tables: species (Platinum's gba_pokemon.c sGBAToDSSpecies, Gen 3's index -> the National Dex), items (Pearl's
itemtool.c sItemIndexMappings column 4: Gen 3's id -> Gen 4's, which Black 2 keeps), characters (Platinum's
gba_convert_string.c -> Gen 4 codes -> Pearl's charmap -> Unicode, Black 2's text).
"""
import os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
PLAT = os.path.join(ROOT, 'external', 'pokeplatinum')
DIAMOND = os.path.join(ROOT, 'external', 'pokediamond')
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')

SECTOR, DATA, SLOT_SECTORS = 0x1000, 3968, 14
SIGNATURE = 0x08012025
PC_FIRST, PC_LAST = 5, 13
PC_SIZE = 4 + 14 * 30 * 80 + 14 * 9 + 14             # 33,744
BOXMON = 80
# Gen 3 BoxPokemon substruct orders (pokeemerald GetSubstruct): for PID % 24, the position of G, A, E, M
ORDERS = ['GAEM', 'GAME', 'GEAM', 'GEMA', 'GMAE', 'GMEA', 'AGEM', 'AGME', 'AEGM', 'AEMG', 'AMGE', 'AMEG',
          'EGAM', 'EGMA', 'EAGM', 'EAMG', 'EMGA', 'EMAG', 'MGAE', 'MGEA', 'MAGE', 'MAEG', 'MEGA', 'MEAG']
# Platinum's sGBAPokemonCartInfo: game code -> (set, game, language); Black 2's version ids for the origin game
GAMES = {'AXV': ('rs', 'ruby', 2), 'AXP': ('rs', 'sapphire', 1), 'BPR': ('frlg', 'firered', 4),
         'BPG': ('frlg', 'leafgreen', 5), 'BPE': ('emerald', 'emerald', 3)}
LANGS = {'J': 1, 'E': 2, 'F': 3, 'I': 4, 'D': 5, 'S': 7}   # Gen 3/4/5 language ids (6 unused, 7 Spanish)
# the eight HMs (Platinum's GBA migration refuses a Pokémon that knows one): Cut, Fly, Surf, Strength, Flash,
# Rock Smash, Waterfall, Dive (Gen 3 move ids = the National move ids)
HM_MOVES = (15, 19, 57, 70, 148, 249, 127, 291)


# ------------------------------------------------------------------------------------------------------------ tables
def _consts(path, prefix):
    """{NAME: value} of a C enum or #define list."""
    out, cur = {}, -1
    text = open(path, encoding='utf-8').read()
    if 'enum' in text and '#define ' + prefix not in text:
        body = text[text.index('{', text.index('enum')) + 1:]
        for line in body.split('\n'):
            line = line.split('//')[0].strip().rstrip(',')
            if not line or line.startswith('}'):
                if line.startswith('}'): break
                continue
            if '=' in line:
                name, v = (s.strip() for s in line.split('=', 1))
                cur = int(v, 0)
            else:
                name, cur = line, cur + 1
            out[name] = cur
        return out
    for m in re.finditer(r'#define\s+(' + prefix + r'\w*)\s+(\S+)', text):
        try:
            out[m.group(1)] = int(m.group(2), 0)
        except ValueError:
            pass
    return out


def _decomp_consts(kind):
    out, cur = {}, -1
    for line in open(os.path.join(DECOMP, 'generated', f'{kind}.txt'), encoding='utf-8'):
        line = line.split('#')[0].strip()
        if not line:
            continue
        if '=' in line:
            name, v = (s.strip() for s in line.split('=', 1))
            cur = int(v, 0)
        else:
            name, cur = line, cur + 1
        out[name] = cur
    return out


def species_table():
    """[Gen 3 index] -> National Dex number (0: none; 252-276 are Gen 3's unused Unown slots)."""
    gba = _consts(os.path.join(PLAT, 'include', 'constants', 'gba', 'species.h'), 'GBA_SPECIES_')
    nat = _decomp_consts('species')
    src = open(os.path.join(PLAT, 'src', 'main_menu', 'gba_pokemon.c'), encoding='utf-8').read()
    out = [i if i <= 251 else 0 for i in range(440)]
    for g, n in re.findall(r'\{\s*(GBA_SPECIES_\w+),\s*(SPECIES_\w+)\s*\}', src):
        out[gba[g]] = nat[n]
    while out and out[-1] == 0:
        out.pop()
    return out


def item_table():
    """[Gen 3 item id] -> Gen 4 item id (Black 2 keeps Gen 4's ids), 0 for none."""
    src = open(os.path.join(DIAMOND, 'arm9', 'src', 'itemtool.c'), encoding='utf-8').read()
    body = src[src.index('sItemIndexMappings[][4]'):]
    body = body[body.index('{') + 1:body.index('};')]
    body = re.sub(r'/\*.*?\*/', '', body, flags=re.S)
    rows = re.findall(r'\{\s*([^}]*)\}', body)
    gen3 = {}
    for i, row in enumerate(rows):
        vals = [v.strip() for v in row.split(',') if v.strip()]
        g = int(vals[3], 0) if vals[3][0].isdigit() else None
        if g is None:
            raise SystemExit(f'item row {i}: {row!r} (not a number)')
        if i and g and g not in gen3:
            gen3[g] = i
    out = [0] * (max(gen3) + 1)
    for g, i in gen3.items():
        out[g] = i
    return out


def char_table():
    """[Gen 3 byte] -> (Japanese, international) Unicode code points, 0 where the byte has no character."""
    codes = _consts(os.path.join(PLAT, 'include', 'constants', 'charcode.h'), 'CHAR_')
    src = open(os.path.join(PLAT, 'src', 'main_menu', 'gba_convert_string.c'), encoding='utf-8').read()
    body = src[src.index('sGBACharToDSChars'):]
    body = body[body.index('{') + 1:body.index('};')]
    pairs = re.findall(r'\{\s*(CHAR_\w+),\s*(CHAR_\w+)\s*\}', body)
    sys.path.insert(0, HERE)
    import gen4_text
    chars = gen4_text.CHARS
    special = {'♂': 0x2642, '♀': 0x2640, '…': 0x2026}

    def uni(name):
        code = codes[name]
        t = chars.get(code)
        if not t or len(t) != 1:
            return special.get(t, 0) if t else 0
        return ord(t)
    return [(uni(a), uni(b)) for a, b in pairs]


def write_tables(path=None):
    """The C header the game's conversion reads (decomp include/pearlb2/palpark_tables.h)."""
    path = path or os.path.join(DECOMP, 'include', 'pearlb2', 'palpark_tables.h')
    sp, it, ch = species_table(), item_table(), char_table()

    def rows(vals, per=16, fmt='{}'):
        return '\n'.join('    ' + ', '.join(fmt.format(v) for v in vals[i:i + per]) + ',' for i in range(0, len(vals), per))
    text = ['// GENERATED by PearlB2 b2tools/gba_migrate.py tables: do not edit',
            '// Gen 3 -> Black 2 tables for Pal Park\'s migration (src/pearlb2/palpark/gba_mon.c)',
            '#ifndef PEARLB2_PALPARK_TABLES_H', '#define PEARLB2_PALPARK_TABLES_H', '',
            f'#define PALPARK_GBA_SPECIES_COUNT {len(sp)}',
            f'#define PALPARK_GBA_ITEM_COUNT {len(it)}',
            f'#define PALPARK_GBA_CHAR_COUNT {len(ch)}', '',
            '// Gen 3 species index -> National Dex (Platinum gba_pokemon.c sGBAToDSSpecies; 0: none)',
            'static const u16 sPalParkGbaSpecies[PALPARK_GBA_SPECIES_COUNT] = {', rows(sp), '};', '',
            '// Gen 3 item id -> Gen 4 / Black 2 item id (Pearl itemtool.c sItemIndexMappings; 0: none)',
            'static const u16 sPalParkGbaItems[PALPARK_GBA_ITEM_COUNT] = {', rows(it), '};', '',
            '// Gen 3 character -> Unicode, [Japanese, international] (Platinum gba_convert_string.c, Pearl charmap)',
            'static const u16 sPalParkGbaChars[PALPARK_GBA_CHAR_COUNT][2] = {',
            rows([f'{{0x{a:04X}, 0x{b:04X}}}' for a, b in ch], per=6), '};', '',
            '// Gen 3 items a Pokémon can\'t hold to come (Platinum gba_migrator.c sInvalidGBAItems)',
            f'#define PALPARK_GBA_REFUSED_ITEM_COUNT {len(REFUSED_ITEMS)}',
            'static const u16 sPalParkGbaRefusedItems[PALPARK_GBA_REFUSED_ITEM_COUNT] = {',
            rows(sorted(REFUSED_ITEMS)), '};', '',
            '#endif', '']
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, 'w', encoding='utf-8').write('\n'.join(text))
    return path, len(sp), len(it), len(ch)


# -------------------------------------------------------------------------------------------------------------- save
def checksum(data, size):
    s = sum(struct.unpack_from(f'<{size // 4}I', data)) & 0xFFFFFFFF
    return ((s >> 16) + s) & 0xFFFF


def section_size(sid, gameset):
    """Bytes a section's checksum covers (Platinum GetGBASectorSize; RS's sizes hardcoded, the others from the ROM's
    header at 0x08000100: saveBlock2Size / saveBlock1Size)."""
    sb2, sb1 = {'rs': (2192, 15040), 'frlg': (0xF24, 0x3D68), 'emerald': (0xF2C, 0x3D88)}[gameset]
    if sid == 0:
        return sb2
    if sid == 4:
        return sb1 - DATA * 3
    if sid == 13:
        return PC_SIZE - DATA * 8
    return DATA


def read_slot(flash, slot, gameset):
    """(complete, counter, {section id: (sector index, data)}) of slot 0 or 1 (Platinum ov97_02235F4C)."""
    got, counter, valid = {}, 0, 0
    for i in range(SLOT_SECTORS):
        sec = flash[(slot * SLOT_SECTORS + i) * SECTOR:][:SECTOR]
        sid, ck, sig, cnt = struct.unpack_from('<HHII', sec, 0xFF4)
        if sig != SIGNATURE or sid >= SLOT_SECTORS:
            continue
        if ck == checksum(sec, section_size(sid, gameset)):
            counter = cnt
            valid |= 1 << sid
            got[sid] = (i, sec[:DATA])
    return valid == (1 << SLOT_SECTORS) - 1, counter, got


def newest_slot(flash, gameset):
    """(slot, counter, sections) of the newest complete slot, or None (Platinum ov97_02235FFC: by the counter, with
    0xFFFFFFFF -> 0 as the wrap)."""
    a, b = read_slot(flash, 0, gameset), read_slot(flash, 1, gameset)
    if a[0] and b[0]:
        ca, cb = a[1], b[1]
        if {ca, cb} == {0xFFFFFFFF, 0}:
            newer = 1 if (ca + 1) & 0xFFFFFFFF < (cb + 1) & 0xFFFFFFFF else 0
        else:
            newer = 1 if ca < cb else 0
        return (newer, *(b if newer else a)[1:])
    if a[0]:
        return (0, *a[1:])
    if b[0]:
        return (1, *b[1:])
    return None


def pc_bytes(sections):
    return b''.join(sections[s][1][:section_size(s, 'rs') if s == 13 else DATA] for s in range(PC_FIRST, PC_LAST + 1))


def boxmons(pc):
    """[(box, slot, 80 raw bytes)] of every non-empty box slot."""
    out = []
    for k in range(14 * 30):
        raw = pc[4 + k * BOXMON:4 + (k + 1) * BOXMON]
        if any(raw):
            out.append((k // 30, k % 30, raw))
    return out


def decode(raw):
    """A Gen 3 boxed Pokémon as a dict (pokeemerald pokemon.h), decrypted; 'bad' when its checksum doesn't match."""
    pid, otid = struct.unpack_from('<II', raw, 0)
    m = dict(pid=pid, otid=otid, nickname=raw[8:18], language=raw[18], flags=raw[19], otname=raw[20:27],
             markings=raw[27], checksum=struct.unpack_from('<H', raw, 28)[0])
    key = otid ^ pid
    sec = struct.pack('<12I', *(w ^ key for w in struct.unpack_from('<12I', raw, 32)))
    m['bad'] = bool(m['flags'] & 1) or sum(struct.unpack('<24H', sec)) & 0xFFFF != m['checksum']
    order = ORDERS[pid % 24]
    sub = {c: sec[order.index(c) * 12:order.index(c) * 12 + 12] for c in 'GAEM'}
    m['species'], m['item'], m['exp'], m['ppups'], m['friendship'] = struct.unpack_from('<HHIBB', sub['G'])
    m['moves'] = list(struct.unpack_from('<4H', sub['A'])); m['pp'] = list(sub['A'][8:12])
    m['evs'] = list(sub['E'][0:6]); m['contest'] = list(sub['E'][6:12])
    pkrs, loc, origins, ivs, rib = struct.unpack_from('<BBHII', sub['M'])
    m.update(pokerus=pkrs, metloc=loc, metlevel=origins & 0x7F, metgame=(origins >> 7) & 0xF,
             ball=(origins >> 11) & 0xF, otgender=origins >> 15,
             ivs=[(ivs >> (5 * i)) & 31 for i in range(6)], egg=(ivs >> 30) & 1, abilitybit=ivs >> 31,
             ribbons=rib)
    return m


def encode(m):
    """The 80 bytes of a Gen 3 boxed Pokémon from decode()'s dict (for the synthetic saves)."""
    order = ORDERS[m['pid'] % 24]
    sub = {
        'G': struct.pack('<HHIBBH', m['species'], m['item'], m['exp'], m['ppups'], m['friendship'], 0),
        'A': struct.pack('<4H4B', *m['moves'], *m['pp']),
        'E': bytes(m['evs'] + m['contest']),
        'M': struct.pack('<BBHII', m['pokerus'], m['metloc'],
                         m['metlevel'] | m['metgame'] << 7 | m['ball'] << 11 | m['otgender'] << 15,
                         sum(v << (5 * i) for i, v in enumerate(m['ivs'])) | m['egg'] << 30 | m['abilitybit'] << 31,
                         m['ribbons'])}
    sec = b''.join(sub[c] for c in order)
    ck = sum(struct.unpack('<24H', sec)) & 0xFFFF
    key = m['otid'] ^ m['pid']
    enc = struct.pack('<12I', *(w ^ key for w in struct.unpack('<12I', sec)))
    flags = (2 if m['species'] else 0) | (4 if m['egg'] else 0)
    return (struct.pack('<II', m['pid'], m['otid']) + bytes(m['nickname']).ljust(10, b'\xff') +
            bytes([m['language'], flags]) + bytes(m['otname']).ljust(7, b'\xff') + bytes([m['markings']]) +
            struct.pack('<HH', ck, 0) + enc)


def gen3_text(raw, lang):
    """A Gen 3 string as Unicode (Platinum's GBA_ConvertStringToDS, then Pearl's charmap)."""
    table, out = char_table(), ''
    for b in raw:
        if b == 0xFF:
            break
        if b >= len(table):
            return '?' * min(len(raw), 10)
        c = table[b][0 if lang == 1 else 1]
        out += chr(c) if c else '?'
    return out


# --------------------------------------------------------------------------------------------- the rules and output
def refusal(m):
    """Why Pearl won't take this one (Platinum gba_migrator.c), or None."""
    if m['bad']:
        return 'bad egg'
    if m['egg']:
        return 'egg'
    if any(mv in HM_MOVES for mv in m['moves']):
        return 'knows an HM'
    if m['item'] and m['item'] in REFUSED_ITEMS:
        return 'holds an item that can\'t go'
    return None


# Platinum gba_migrator.c sInvalidGBAItems (Gen 3 ids): the mail and the items Gen 4 has no use for
REFUSED_ITEMS = set()


def _load_refused():
    src = open(os.path.join(PLAT, 'src', 'main_menu', 'gba_migrator.c'), encoding='utf-8').read()
    if 'sInvalidGBAItems' not in src:
        return
    body = src[src.index('sInvalidGBAItems'):]
    body = body[body.index('{') + 1:body.index('};')]
    gba = _consts(os.path.join(PLAT, 'include', 'constants', 'gba', 'items.h'), 'GBA_ITEM_')
    for name in re.findall(r'(GBA_ITEM_\w+|\d+)', body):
        REFUSED_ITEMS.add(int(name) if name.isdigit() else gba[name])


_load_refused()


# ---------------------------------------------------------------------------------------------------- synthetic cart
def nintendo_logo():
    """The 156-byte logo the GBA BIOS and Platinum check, from our own Black 2 dump's header (the DS header carries the
    same bitmap at 0xC0): the game's C compares against the DS header in RAM (0x027FFEC0), never a copy of its own."""
    return open(os.path.join(ROOT, 'roms', 'black2_original.nds'), 'rb').read()[0xC0:0xC0 + 156]


def test_rom(code='BPEE', title='POKEMON EMER'):
    """A GBA ROM header good enough for Platinum's checks (logo, game code, header checksum) and DeSmuME's save-type
    scan ('FLASH1M_V' in the image). No game code: a test cart only for the slot-2 reader."""
    h = bytearray(0x200)
    h[0:4] = struct.pack('<I', 0xEA00002E)                   # b 0xC0 (the usual entry)
    h[4:4 + 156] = nintendo_logo()
    h[0xA0:0xAC] = title.encode().ljust(12, b'\0')
    h[0xAC:0xB0] = code.encode()
    h[0xB0:0xB2] = b'01'
    h[0xB2] = 0x96
    h[0xBD] = (-(sum(h[0xA0:0xBD]) + 0x19)) & 0xFF
    img = bytes(h) + b'FLASH1M_V103\0\0\0\0'
    return img.ljust(0x100000, b'\xff')


def blank_flash():
    return bytearray(b'\xff' * 0x20000)


def write_slot(flash, slot, sections, counter, first=0, gameset='emerald'):
    """Writes the 14 sections into slot `slot`, section s at sector (s + first) % 14 (Gen 3's rotation)."""
    for sid in range(SLOT_SECTORS):
        data = sections[sid].ljust(DATA, b'\0')[:DATA]
        sec = bytearray(SECTOR)
        sec[:DATA] = data
        struct.pack_into('<HHII', sec, 0xFF4, sid, checksum(sec, section_size(sid, gameset)), SIGNATURE, counter)
        i = (sid + first) % SLOT_SECTORS
        flash[(slot * SLOT_SECTORS + i) * SECTOR:(slot * SLOT_SECTORS + i + 1) * SECTOR] = sec
    return flash


def test_save(mons, gameset='emerald', player='TEST', counter=5):
    """A save whose newest slot (slot 1, counter `counter`; slot 0 an older copy with an empty PC) holds `mons`
    [(box, slot, dict)] in its PC. The other sections are zeros but the player's name: enough for the migration."""
    sb2 = bytearray(section_size(0, gameset))
    name = encode_text(player)
    sb2[0:len(name)] = name
    sb2[0xA:0xE] = struct.pack('<I', 0x12345678)
    pc = bytearray(PC_SIZE)
    for box, slot, m in mons:
        at = 4 + (box * 30 + slot) * BOXMON
        pc[at:at + BOXMON] = encode(m)
    secs = {0: bytes(sb2)}
    for s in range(1, 5):
        secs[s] = bytes(section_size(s, gameset))
    for k, s in enumerate(range(PC_FIRST, PC_LAST + 1)):
        secs[s] = bytes(pc[k * DATA:(k + 1) * DATA])
    flash = blank_flash()
    old = dict(secs)
    for k, s in enumerate(range(PC_FIRST, PC_LAST + 1)):
        old[s] = bytes(DATA if s != 13 else section_size(13, gameset))
    write_slot(flash, 0, old, counter - 1, first=3, gameset=gameset)
    write_slot(flash, 1, secs, counter, first=9, gameset=gameset)
    return flash


def encode_text(s, length=None):
    table = char_table()
    rev = {}
    for b, (jp, intl) in enumerate(table):
        if intl and chr(intl) not in rev:
            rev[chr(intl)] = b
    out = bytes(rev[c] for c in s) + b'\xff'
    return out if length is None else out[:length].ljust(length, b'\xff')


def sample_mon(species, level_exp, pid, moves, item=0, nickname=None, otname='TEST', otid=0x12345678, egg=0,
               metgame=3, lang=2):
    """A Gen 3 boxed Pokémon for the synthetic saves: `species` is Gen 3's index."""
    names = {v: k for k, v in enumerate(species_table())}
    return dict(pid=pid, otid=otid, nickname=encode_text(nickname or 'MON' + str(species), 10), language=lang,
                flags=0, otname=encode_text(otname, 7), markings=0, checksum=0, species=species, item=item,
                exp=level_exp, ppups=0b01000000, friendship=70, moves=list(moves) + [0] * (4 - len(moves)),
                pp=[5, 10, 15, 20], evs=[4, 0, 0, 252, 0, 0], contest=[1, 2, 3, 4, 5, 6], pokerus=0, metloc=16,
                metlevel=5, metgame=metgame, ball=4, otgender=0, ivs=[31, 30, 29, 28, 27, 26], egg=egg,
                abilitybit=pid & 1, ribbons=(1 << 15) | 2)


def test_cart(out_dir, code='BPEE'):
    """OUT_DIR/test_CODE.gba + .sav: Emerald-like, 8 Pokémon in box 1 and 2 more in box 3: one egg, one knowing Surf,
    one holding mail, a Bad Egg (checksum broken) and six good ones (a Hoenn species, a Kanto one, Unown, held items)."""
    gameset = GAMES[code[:3]][0]
    good = [sample_mon(280, 1000, 0x00000001, [33, 45]),          # Torchic (Gen 3 index 280): Tackle, Growl
            sample_mon(25, 8000, 0x0A0B0C0D, [84, 45, 86], item=13),   # Pikachu, a Potion (Gen 3 13)
            sample_mon(201, 1200, 0x12345678, [237]),             # Unown: its letter from the PID
            sample_mon(374, 9000, 0xDEADBEEF, [36, 93]),          # Huntail (Gen 3 index 374)
            sample_mon(304, 5000, 0x00C0FFEE, [33, 52], item=69),  # (an item from Gen 3's list)
            sample_mon(150, 1250000, 0x55555555, [94, 105, 129, 133], nickname='MEWTWOX')]
    egg = sample_mon(280, 0, 0x22222222, [33], egg=1)
    hm = sample_mon(129, 2000, 0x33333333, [57, 33])               # Surf
    mail = sample_mon(19, 2000, 0x44444444, [33], item=121)        # Gen 3 121 = Orange Mail
    bad = encode(sample_mon(19, 2000, 0x66666666, [33]))
    bad = bad[:40] + bytes([bad[40] ^ 0xFF]) + bad[41:]            # one secure byte off: the checksum fails
    mons = [(0, k, m) for k, m in enumerate(good)] + [(0, 10, egg), (0, 11, hm), (2, 0, mail)]
    flash = test_save(mons, gameset)
    raw = newest_slot(flash, gameset)
    i, sec = raw[2][PC_FIRST]
    flash = bytearray(flash)
    # the Bad Egg goes in directly (its checksum must stay wrong): box 3 slot 1, then the PC sections re-signed
    pc = bytearray(pc_bytes(raw[2]))
    at = 4 + (2 * 30 + 1) * BOXMON
    pc[at:at + BOXMON] = bad
    secs = {s: raw[2][s][1] for s in range(SLOT_SECTORS)}
    for k, s in enumerate(range(PC_FIRST, PC_LAST + 1)):
        secs[s] = bytes(pc[k * DATA:(k + 1) * DATA])
    first = (raw[2][0][0]) % SLOT_SECTORS
    write_slot(flash, raw[0], secs, raw[1], first=first, gameset=gameset)
    os.makedirs(out_dir, exist_ok=True)
    rom, sav = os.path.join(out_dir, f'test_{code}.gba'), os.path.join(out_dir, f'test_{code}.sav')
    open(rom, 'wb').write(test_rom(code, {'rs': 'POKEMON RUBY', 'frlg': 'POKEMON FIRE'}.get(gameset, 'POKEMON EMER')))
    open(sav, 'wb').write(bytes(flash))
    return rom, sav


def show(path, gameset='emerald'):
    flash = open(path, 'rb').read()
    got = newest_slot(flash, gameset)
    if not got:
        print('no complete slot'); return
    slot, counter, secs = got
    print(f'slot {slot}, counter {counter}')
    sp = species_table()
    for box, k, raw in boxmons(pc_bytes(secs)):
        m = decode(raw)
        nat = sp[m['species']] if m['species'] < len(sp) else 0
        print(f'  box {box + 1} slot {k + 1:2}: Gen 3 #{m["species"]:3} -> {nat:3} '
              f'{gen3_text(m["nickname"], m["language"]):10} item {m["item"]:3} moves {m["moves"]} '
              f'{"refused: " + refusal(m) if refusal(m) else "ok"}')


if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else ''
    if cmd == 'tables':
        print('%s: %d species, %d items, %d characters' % write_tables(*sys.argv[2:3]))
    elif cmd == 'show':
        show(sys.argv[2], *sys.argv[3:4])
    elif cmd == 'testcart':
        print(*test_cart(sys.argv[2], *sys.argv[3:4]))
    else:
        print(__doc__)
