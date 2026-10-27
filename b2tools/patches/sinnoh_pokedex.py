"""Black 2's Pokédex as Pearl's Sinnoh Pokédex (2026-10-20; HoennB2's patches/hoenn_pokedex.py ported).
Runs after town_map (it reads town_map's a/0/8/4 file 21: the Sinnoh records and the zone table) and after
sinnoh_encounters (it reads the built wild tables). The regional list itself is patches/sinnoh_dex.py.

Text (data/text_overrides/pokedex.json, packed by patches/sinnoh_names.py; made by `python3 sinnoh_pokedex.py --text`
from the user's Pearl dump through b2tools/gen4_text.py): "SINNOH POKÉDEX" over the list, the search's "Sinnoh
Pokédex: Search Mode", the Habitat list's SINNOH tab and stamp line, and Pearl's own Pokédex entries for species 1-493
in Black 2's entry field (Pearl bank 616; Diamond 615), its categories (621), heights (620) and weights (619) where
they differ from Black 2's. Pearl's entries are one page of three lines, as Black 2's field, so there is no page flip
(HoennB2 needed one for Gen 3's two pages).

The professor's rating (sources made by `--sources`; the field scripts and texts are ordinary src/ files):
- src/field_scripts/1260_global_pokedex_rating.s: global 10382 (the Pokémon Center PC's professor entry) = Pearl's PC
  rating (common script 376 script_2): "Accessed Professor Rowan's PC." and Rowan's line for the Sinnoh seen count,
  after the National Pokédex "Accessed Professor Oak's PC." and Oak's line for the National caught count. Text file
  1051 = Pearl's rating bank 335 line for line. Black 2's Juniper rating counted the regional list with Unova's tiers.
- src/field_scripts/1244_global_pc.s: Black 2's PC (global 10090, pokebw2 res/field/scripts/global_10090.s) with two
  changes: the professor's entry is "Rowan’s PC" / "Oak’s PC" (Pearl's PC menu, bank 321 lines 63 / 62: Oak's once
  the National Pokédex is on), and it no longer prints Juniper's "Accessed Professor Juniper's PC." (the rating
  prints Pearl's line). Text file 1052 = Black 2's global_10090 text with those lines.
- apply_code: ov012 GLOBAL_SCRIPT_TABLE (0x0216af98, 10-byte entries: start, end, script file, text archive, text
  file): global 10380-10389 -> text file 1051, 10090-10099 -> 1052 (Black 2's own a/0/0/3 files 0-675 stay as they
  are, patches/pearl_text.py's rule).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')

RATING_TEXT, PC_TEXT = 1051, 1052                 # a/0/0/3 files (after Pearl's zone banks 676-1050)
RATING_BANK = 335                                 # Pearl: Rowan's / Oak's rating, "Accessed Professor ...'s PC."
PC_MENU_BANK, PC_ROWAN, PC_OAK = 321, 63, 62      # Pearl's PC menu: ROWAN'S PC, OAK'S PC
OV012, GLOBAL_TABLE, GLOBAL_ENTRIES = 0x021503C0, 0x0216AF98, 60
GLOBAL_TEXT = {10380: RATING_TEXT, 10090: PC_TEXT}
SRC_SCRIPTS = os.path.join(ROOT, 'src', 'field_scripts')
SRC_TEXT = os.path.join(ROOT, 'src', 'text', 'script')


def _save(path, data):
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)


# ------------------------------------------------------------------------------------------------- the rating sources

def menu_label(text):
    """Pearl's all-caps menu word in Black 2's case (ROWAN’S PC -> Rowan’s PC)."""
    return ' '.join(w if w == 'PC' else w[:1] + w[1:].lower() for w in text.split(' '))


def write_sources():
    """src/text/script/1051_rowan_rating.txt, 1052_pc.txt and src/field_scripts/1244_global_pc.s (module docstring)."""
    import gen4_text
    rating = gen4_text.bank(RATING_BANK)
    lines = [f'PearlRating_Text_{i:03d} = {gen4_text.b2_line(t)}' for i, t in enumerate(rating)]
    open(os.path.join(SRC_TEXT, f'{RATING_TEXT}_rowan_rating.txt'), 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
    menu = gen4_text.bank(PC_MENU_BANK)
    rowan, oak = menu_label(menu[PC_ROWAN]), menu_label(menu[PC_OAK])
    assert (rowan, oak) == ('Rowan’s PC', 'Oak’s PC'), (rowan, oak)
    b2 = open(os.path.join(DECOMP, 'res', 'text', 'script', 'global_10090.txt'), encoding='utf-8').read().split('\n')
    assert b2[5] == "Global10090_Text_ProfessorsPc = Professor's PC" and b2[-2:] == ['\\pad{4c}', ''], b2[-3:]
    pc = b2[:-2]
    pc[5] = f'Global10090_Text_ProfessorsPc = {rowan}'
    oak_line = len(pc)
    pc.append(f'Global10090_Text_PearlOaksPc = {oak}')
    open(os.path.join(SRC_TEXT, f'{PC_TEXT}_pc.txt'), 'w', encoding='utf-8').write('\n'.join(pc) + '\n')
    s = open(os.path.join(DECOMP, 'res', 'field', 'scripts', 'global_10090.s'), encoding='utf-8').read()
    def sub(old, new):
        nonlocal s
        assert s.count(old) == 1, old
        s = s.replace(old, new)
    sub('    ListMenuAdd 5, 65535, 5\n',
        '    PokeDexHaveNational 0x8031                 // Pearl: OAK’S PC once the National Pokédex is on\n'
        '    WorkCmpConst 0x8031, 1\n'
        '    VMJumpIf CMP_EQ, L_PearlOaksPc\n'
        '    ListMenuAdd 5, 65535, 5                    // Rowan’s PC\n'
        '    VMJump L_00D0\n\n'
        'L_PearlOaksPc:\n'
        f'    ListMenuAdd {oak_line}, 65535, 5                   // Oak’s PC (text file {PC_TEXT}, new line)\n')
    sub('    // "Accessed Professor Juniper\'s PC.[f000]븁\\u0000"\n'
        '    SystemMsg Global10090_Text_AccessedProfessorJunipersPc, 2\n',
        '    // (Black 2\'s "Accessed Professor Juniper\'s PC.": the rating, global 10382, prints Pearl\'s line)\n')
    head = ('// Global script 10090 (a/0/5/6 entry 1244): Black 2\'s Pokémon Center PC, pokebw2 res/field/scripts/\n'
            '// global_10090.s, with two Sinnoh changes (b2tools/patches/sinnoh_pokedex.py, 2026-10-20; made by its --sources):\n'
            '// the professor\'s entry reads Rowan\'s PC, or Oak\'s PC once the National Pokédex is on (Pearl\'s PC menu), and\n'
            '// Juniper\'s "Accessed Professor Juniper\'s PC." is gone (global 10382 prints Pearl\'s "Accessed Professor\n'
            f'// Rowan\'s PC." / Oak\'s). Text: a/0/0/3 file {PC_TEXT} (src/text/script/{PC_TEXT}_pc.txt: Black 2\'s lines, the\n'
            f'// entry\'s label changed, line {oak_line} added); sinnoh_pokedex points global 10090\'s text at it.\n')
    open(os.path.join(SRC_SCRIPTS, '1244_global_pc.s'), 'w', encoding='utf-8').write(head + s)
    return f'{RATING_TEXT}_rowan_rating.txt ({len(lines)} lines), {PC_TEXT}_pc.txt ({len(pc)} lines), 1244_global_pc.s'


def global_text_code(code):
    """GLOBAL_SCRIPT_TABLE: the rating's and the PC's text files (module docstring)."""
    p = os.path.join(code, 'arm9_ov012.bin')
    d = bytearray(open(p, 'rb').read())
    o0 = GLOBAL_TABLE - OV012
    done = {}
    for i in range(GLOBAL_ENTRIES):
        start, end, scripts, arc, text = struct.unpack_from('<5H', d, o0 + 10 * i)
        if start in GLOBAL_TEXT:
            struct.pack_into('<H', d, o0 + 10 * i + 8, GLOBAL_TEXT[start])
            done[start] = (text, GLOBAL_TEXT[start])
    assert set(done) == set(GLOBAL_TEXT), done
    _save(p, d)
    return 'global script text: ' + ', '.join(f'{s} {a} -> {b}' for s, (a, b) in sorted(done.items()))


# ------------------------------------------------------------------------------------------------- the text

ENTRY_BANK = 615 if __import__('version').DIAMOND else 616     # Pearl's Pokédex entries (Diamond's in bank 615)
PEARL_FORMS = ('unown', 'castform', 'deoxys', 'burmy', 'wormadam', 'shellos', 'gastrodon', 'cherrim')   # one Pearl entry each
SHARED = {
    'game_start_3': {'GameStart3_Text_UnovaPokedex': 'SINNOH POKÉDEX', 'GameStart3_Text_Unova': 'SINNOH'},
    'zknsearch_main': {'ZknsearchMain_Text_UnovaPokedexSearchMode': 'Sinnoh Pokédex: Search Mode'},
    'zukan_habitat': {'ZukanHabitat_Text_Unova': 'SINNOH',
                      'ZukanHabitat_Text_WhenAllPokemonHabitat': "When all the Pokémon in that Habitat\\nhave been "
                      "encountered,\\nyou'll receive a stamp.\\nExplore all of the Sinnoh region!{be01}"},
}


def species_dirs():
    """{national number: pokebw2 res/pokemon directory} (the first SPECIES_ name of each number)."""
    out = {}
    for line in open(os.path.join(DECOMP, 'build', 'include', 'generated', 'constants', 'species.h')):
        m = re.match(r'#define SPECIES_(\w+)\s+(\d+)\s*$', line)
        if m: out.setdefault(int(m.group(2)), m.group(1).lower())
    return out


def write_text():
    """data/text_overrides/pokedex.json (module docstring "Text"): Pearl's entries where they differ from Black 2's
    (categories, heights and weights are all equal: checked here, so they keep Black 2's lines)."""
    import gen4_text, b2font
    font = b2font.load(0)
    entries, cats, heights, weights = (gen4_text.bank(n) for n in (ENTRY_BANK, 621, 620, 619))
    dirs = species_dirs()
    def norm(t): return t.strip().replace('’', "'").replace('”', '"').replace('\\n', ' ')
    out, changed, same = {}, 0, 0
    for n in range(1, 494):
        path = f'res/pokemon/{dirs[n]}/data.json'
        dex = json.load(open(os.path.join(DECOMP, path), encoding='utf-8'))['pokedex']
        for pearl, field in ((cats, 'category'), (heights, 'height'), (weights, 'weight')):
            assert norm(pearl[n]) == norm(dex[field]), (n, field, pearl[n], dex[field])
        line = gen4_text.b2_line(entries[n])
        lines = line.split('\\n')
        assert len(lines) <= 3 and '{' not in line and max(font.width(l) for l in lines) <= 222, (n, line)
        text = '\n'.join(lines)
        if text == dex['entry']:
            same += 1; continue
        new = {'entry': text}
        if dirs[n] in PEARL_FORMS and dex.get('forms'):
            new['forms'] = [{'entry': text} for _ in dex['forms']]
        out[path] = {'pokedex': new}
        changed += 1
    doc = ('Pearl\'s Pokédex text (b2tools/patches/sinnoh_pokedex.py --text, from the user\'s dump through '
           'b2tools/gen4_text.py): the list header SINNOH POKÉDEX, the search and HABITAT list lines, and Pearl\'s '
           f'entries (bank {ENTRY_BANK}) for species 1-493 where Black 2\'s differ ({changed}; {same} equal), the '
           'alternate forms Pearl has (Unown, Castform, Deoxys, Burmy, Wormadam, Shellos, Gastrodon, Cherrim) the same '
           'entry. Categories, heights and weights equal Pearl\'s for all 493 (checked), so Black 2\'s lines stay.')
    data = {'_doc': doc, **SHARED, **out}
    path = os.path.join(ROOT, 'data', 'text_overrides', 'pokedex.json')
    json.dump(data, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    return f'{changed} entries ({same} already equal) -> {path}'


# ------------------------------------------------------------------------------------------------- the AREA page

ARC_HABITAT, ARC_DEX_GFX, ARC_ENC, ARC_HLIST = 176, 157, 127, 296
GFX_NCGR, GFX_NCER, GFX_NANR = 15, 29, 46       # a/1/5/7: the area page's highlight sprites (ov298, ov303)
ENC_TABLE = 8 + 56 * 4                          # a/1/2/7: rates (8 B) + 56 slots (u16 species | form << 11, 2 levels)
GROUPS = [0] * 12 + [1] * 12 + [2] * 12 + [3] * 5 + [4] * 5 + [5] * 5 + [6] * 5
KIND_BIT = {0: 0x01, 1: 0x01, 2: 0x01, 3: 0x08, 4: 0x08, 5: 0x20, 6: 0x20}   # walking, surfing, fishing (the icons)
SINNOH_TABLES = range(135, 135 + 183)           # patches/sinnoh_encounters.py: table 135 + Pearl file N
HABITAT_SIZE, SEASON_SIZE, N_FILES, NREC = 345, 86, 684, 85
HIGHLIGHT = 6                                   # colour index of NCLR 5 palette 0: Black 2's own highlight red
AREA = {}                                       # apply() -> apply_code()
OV = {298: 0x0219FBC0, 303: 0x0219FBC0, 308: 0x0219F960, 302: 0x021ACEE0, 36: 0x0217F600, 35: 0x0217C940}
F718, F73C, PARENT_ZONE = 0x0219F718, 0x0219F73C, 0x02160EB4   # ov144 records load / find by zone; ov012 a zone's parent
ZONE_LIST = 0x021AC544                          # ov298 data_ov298_021ac544: 85 u16 zones (habitat index = position)


def _tm():
    import importlib.util
    spec = importlib.util.spec_from_file_location('town_map_dex', os.path.join(HERE, 'town_map.py'))
    m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    return m


def zone_bits(files, ztab):
    """{zone: {species: bits}} of every zone with a Sinnoh wild table (sinnoh_encounters' a/1/2/7 135-317, all four
    of its tables: morning, day, night and the Old/Good Rod table) and a place on the map. Bits: walking, surfing,
    fishing (Black 2's groups grass / surf / fishing and their dark-grass, rippling copies)."""
    import narcio, zoneheaders
    headers, _ = zoneheaders.load(files)
    enc = narcio.load(files, ARC_ENC)
    out = {}
    for z, h in enumerate(headers):
        f = h['encounters']
        if f not in SINNOH_TABLES or z >= len(ztab) or ztab[z] == 0xFF: continue
        data = enc[f]
        assert len(data) % ENC_TABLE == 0, (z, f, len(data))
        bits = {}
        for t0 in range(0, len(data), ENC_TABLE):
            t = data[t0:t0 + ENC_TABLE]
            for k in range(56):
                sp = struct.unpack_from('<H', t, 8 + 4 * k)[0] & 0x7FF
                if sp and t[GROUPS[k]]: bits[sp] = bits.get(sp, 0) | KIND_BIT[GROUPS[k]]
        out[z] = bits
    return out


def habitat(files):
    """a/1/7/6 from the game's Sinnoh wild tables, a/1/5/7's highlight art, the HABITAT list, and AREA for apply_code."""
    import narcio
    from b2files import arc_path
    tm = _tm()
    f21 = tm.read_file21(files)
    recs, ztab = f21['records'], f21['zone_table']
    assert len(recs) == NREC, len(recs)
    rzones = [r[0] for r in recs]
    slot_of = [rzones.index(z) for z in rzones]                # a place's habitat index: its zone's first record
    hab = {}
    zb = zone_bits(files, ztab)
    for z, bits in zb.items():
        k = slot_of[ztab[z]]
        for spc, b in bits.items():
            hab.setdefault(spc, [0] * NREC)[k] |= b
    path = arc_path(files, ARC_HABITAT); size = os.path.getsize(path)
    entries = narcio.load(files, ARC_HABITAT)
    assert len(entries) == N_FILES and all(len(e) == HABITAT_SIZE for e in entries)
    new = []
    for i in range(N_FILES):
        places = hab.get(i + 1) if i < 649 else None
        d = bytearray(HABITAT_SIZE)
        d[0] = 1                                                # one table all year (Sinnoh's wild Pokémon are)
        for s in range(4):
            d[1 + SEASON_SIZE * s] = 0 if places else 1         # 1 = "Area Unknown"
            if places: d[2 + SEASON_SIZE * s:2 + SEASON_SIZE * s + NREC] = bytes(places)
        new.append(bytes(d))
    narcio.save(files, ARC_HABITAT, new)
    assert os.path.getsize(path) == size, 'a/1/7/6 changed size'
    locs = tm.locations(); locs = locs + [tm.dummy_record(locs)] * (NREC - len(locs))
    art = highlight_art(files, tm, locs, recs)
    AREA.update(zones=rzones, filler=NREC - 1, nzones=len(ztab), zt_off=_zt_off(files, tm))
    hl = habitat_list(files, tm, locs, hab, slot_of, rzones, ztab)
    found = sum(1 for i in range(1, 494) if i in hab)
    return (f'habitat: {found} species of 1-493 on the Sinnoh map ({len(zb)} zones with wild tables); {art}; {hl}')


def _zt_off(files, tm):
    import narcio
    d = narcio.load(files, tm.ARC_GFX)[tm.NEW_FILE]
    i = d.rfind(b'TMAP')
    return struct.unpack_from('<6H', d, i + 4)[1]


# DS OBJ sizes (shape, size) by (width, height)
OBJ_SIZES = {(8, 8): (0, 0), (16, 16): (0, 1), (32, 32): (0, 2), (64, 64): (0, 3), (16, 8): (1, 0), (32, 8): (1, 1),
             (32, 16): (1, 2), (64, 32): (1, 3), (8, 16): (2, 0), (8, 32): (2, 1), (16, 32): (2, 2), (32, 64): (2, 3)}


def _objs(pix, w, h):
    """Cover a w x h pixel mask (pix[y][x] true = drawn) with OBJs of at most 32 x 32: [(x, y, ow, oh)]."""
    out = []
    for by in range(0, h, 32):
        for bx in range(0, w, 32):
            pts = [(x, y) for y in range(by, min(h, by + 32)) for x in range(bx, min(w, bx + 32)) if pix[y][x]]
            if not pts: continue
            x0, y0 = min(p[0] for p in pts), min(p[1] for p in pts)
            x1, y1 = max(p[0] for p in pts), max(p[1] for p in pts)
            ow, oh = min(((a, b) for a, b in OBJ_SIZES if a >= x1 - x0 + 1 and b >= y1 - y0 + 1 and a <= 32 and b <= 32),
                         key=lambda s: s[0] * s[1])
            out.append((x0, y0, ow, oh))
    return out


def highlight_art(files, tm, locs, recs):
    """a/1/5/7 NCGR 15 / NCER 29 / NANR 46: one cell + anim per town_map.dex_highlights shape: its grid cells (7 x 7
    pixels each) filled with Black 2's highlight colour, semi-transparent OBJs like Black 2's (its pulse is the glow).
    The NARC keeps its size (padded)."""
    import narcio
    from b2files import arc_path
    hls, shapes = tm.dex_highlights(locs)
    assert [r[24] for r in recs] == [h[0] for h in hls], 'file 21 and town_map.dex_highlights disagree'
    path = arc_path(files, ARC_DEX_GFX); size = os.path.getsize(path)
    e = narcio.load(files, ARC_DEX_GFX)
    G = tm.GRID
    raw, cells = bytearray(), []
    for shape in shapes:
        w = G * (max(c[0] for c in shape) + 1); h = G * (max(c[1] for c in shape) + 1)
        pix = [[False] * w for _ in range(h)]
        for cx, cz in shape:
            for y in range(G):
                for x in range(G): pix[cz * G + y][cx * G + x] = True
        objs = []
        for x0, y0, ow, oh in _objs(pix, w, h):
            unit = len(raw) // 128
            for ty in range(oh // 8):                             # tiles in 1D order, the OBJ from a 128-byte unit
                for tx in range(ow // 8):
                    t = [HIGHLIGHT if 0 <= y0 + ty * 8 + y < h and 0 <= x0 + tx * 8 + x < w
                         and pix[y0 + ty * 8 + y][x0 + tx * 8 + x] else 0 for y in range(8) for x in range(8)]
                    raw += bytes(t[i] | t[i + 1] << 4 for i in range(0, 64, 2))
            while len(raw) % 128: raw += b'\0'
            objs.append((x0, y0, ow, oh, unit))
        cells.append(objs)
    old = e[GFX_NCGR]
    th, tw, depth, mapping, tiled, dsize, doff = struct.unpack_from('<HHIIIII', old, 0x18)
    assert depth == 3 and doff == 0x18 and (th, tw) == (0xFFFF, 0xFFFF)
    rahc = bytearray(old[0x10:0x10 + 0x20]) + raw
    struct.pack_into('<I', rahc, 4, len(rahc)); struct.pack_into('<I', rahc, 0x18, len(raw))
    ncgr = tm._nitro(old, [bytes(rahc)])
    ncer0 = e[GFX_NCER]
    secs = tm._sections_of(ncer0)
    mg, ko, ksz = secs[0]; assert mg == b'KBEC'
    kb = ncer0[ko:ko + ksz]
    n0, attr, co = struct.unpack_from('<HHI', kb, 8)
    assert attr & 1 and co == 0x18
    table, oams = bytearray(), bytearray()
    for objs in cells:
        xs = [o[0] for o in objs] + [o[0] + o[2] for o in objs]; ys = [o[1] for o in objs] + [o[1] + o[3] for o in objs]
        rad = min(63, int((max(xs) ** 2 + max(ys) ** 2) ** 0.5 / 4) + 2)
        table += struct.pack('<HHIhhhh', len(objs), 0x800 | rad, len(oams), max(xs) - 1, max(ys) - 1, min(xs), min(ys))
        for x, y, ow, oh, unit in objs:
            shape, sz = OBJ_SIZES[(ow, oh)]
            oams += struct.pack('<HHH', shape << 14 | 1 << 10 | (y & 0xFF), sz << 14 | (x & 0x1FF), unit)
    while len(oams) % 4: oams += b'\0'
    head = bytearray(kb[8:8 + co]); struct.pack_into('<H', head, 0, len(cells))
    kb_new = struct.pack('<4sI', b'KBEC', 8 + len(head) + len(table) + len(oams)) + bytes(head + table + oams)
    ncer = tm._nitro(ncer0, [kb_new] + [ncer0[o:o + sz] for _, o, sz in secs[1:]])
    nanr0 = e[GFX_NANR]
    secs = tm._sections_of(nanr0)
    mg, ao, asz = secs[0]; assert mg == b'KNBA'
    ab = nanr0[ao:ao + asz]
    nA, nF, aoff, foff, poff = struct.unpack_from('<HHIII', ab, 8)
    proto = ab[8 + aoff:8 + aoff + 16]
    anims, frames, pos = bytearray(), bytearray(), bytearray()
    for k in range(len(cells)):
        a = bytearray(proto); struct.pack_into('<I', a, 12, len(frames)); anims += a
        frames += struct.pack('<IHH', len(pos), 4, 0xBEEF)
        pos += struct.pack('<HH', k, 0xCCCC)
    head = bytearray(ab[8:8 + aoff])
    struct.pack_into('<HHIII', head, 0, len(cells), len(cells), aoff, aoff + len(anims), aoff + len(anims) + len(frames))
    ab_new = struct.pack('<4sI', b'KNBA', 8 + len(head) + len(anims) + len(frames) + len(pos)) + bytes(head + anims + frames + pos)
    nanr = tm._nitro(nanr0, [ab_new] + [nanr0[o:o + sz] for _, o, sz in secs[1:]])
    e[GFX_NCGR], e[GFX_NCER], e[GFX_NANR] = ncgr, ncer, nanr
    narcio.save(files, ARC_DEX_GFX, e)
    d = open(path, 'rb').read()
    open(path + '.tmp', 'wb').write(tm._pad_narc(d, size)); os.replace(path + '.tmp', path)
    return f'a/1/5/7: {len(cells)} highlight shapes ({len(raw)} B of tiles), {len(d)} -> {size} B'


# ------------------------------------------------------------------------------------------------- the HABITAT list
# Black 2's HABITAT list (the Pokédex's HABITAT button, after the National Pokédex; HoennB2 hoenn_pokedex.py "Habitat
# list" has the format): 57 places in one table copied in four overlays (ov302 data_ov302_021ae41c, ov303
# data_ov303_021a3414, ov298 data_ov298_021ac5f0, ov036 0x021d49b8): u16 visited flag, u16 zone, u8 page, u8 0; pages
# a/2/9/6 (58 files): 8 bytes (kinds present, picture), u16 count (<= 30), 28-byte entries (species, [4 seasons]
# [walking, surfing, fishing], 14 bytes 0). Surfing / fishing kinds show once flags 0x987 / 0x985 are set.
# Sinnoh: the places with wild Pokémon in Pearl's map-section order (towns, Routes 201-230, then the landmarks), a
# route's two halves (204, 205, 210, 211, 212) one place; Black 2's list holds 57, so places whose every Pokémon and
# kind another listed place has too are left out (HLIST_LEFT_OUT, checked by habitat_list). Visited: bits in
# PVAR_HABITAT_VISITED_0-3 (src/include/pearl.h), set by HabitatDiscover on every zone entry (both callers of
# SetTeleportZoneDiscover: ov035 0x0217e57e map changes, ov036 0x02180cd8 walking into a zone) for the zone's place
# (town_map's zone table: rooms and caves count for their town or cave); the table's flag field is 0xf000 + place and
# the five reads of it (ov302 0x021ad95e, 0x021adb3e, 0x021adb98, 0x021ade32, ov298 0x021a62e6) call HabitatVisited.
ARC_HLIST, HLIST_PLACES, HLIST_FILES, HLIST_MAX = 296, 57, 58, 30
VISITED_BASE = 0xF000
TABLES = {302: 0x021AE41C, 303: 0x021A3414, 298: 0x021AC5F0, 36: 0x021D49B8}
ITEM_RODS = (445, 446, 447)                     # Old, Good, Super Rod (patches/pearl_rods.py)
PICTURE = {'cave': 3, 'tower': 5, 'mountain': 5, 'marsh': 2, 'desert': 1, 'bridge': 4, 'water': 6, 'field': 0}
PICTURE_OF = {'ROUTE_209_LOST_TOWER_1F': 'tower', 'STARK_MOUNTAIN_EXTERIOR': 'mountain', 'GREAT_MARSH_AREA_1': 'marsh',
              'ROUTE_228': 'desert', 'ROUTE_206': 'bridge', 'TROPHY_GARDEN': 'field', 'FLOAROMA_MEADOW': 'field'}


def _visited_works():
    t = open(os.path.join(ROOT, 'src', 'include', 'pearl.h')).read()
    return [int(re.search(rf'#define\s+PVAR_HABITAT_VISITED_{i}\s+(0x[0-9A-Fa-f]+)', t).group(1), 16) for i in range(4)]


def habitat_list(files, tm, locs, hab, slot_of, rzones, ztab):
    """a/2/9/6 = one page per Sinnoh place (+ the empty filler), and AREA['hlist'] for apply_code."""
    import narcio
    from b2files import arc_path
    import importlib.util
    spec = importlib.util.spec_from_file_location('sinnoh_dex_hl', os.path.join(HERE, 'sinnoh_dex.py'))
    sd = importlib.util.module_from_spec(spec); spec.loader.exec_module(sd)
    sinnoh = {s: i for i, s in enumerate(sd.sinnoh_order(), 1)}
    pz = json.load(open(os.path.join(tm.PEARL, 'zones.json')))
    slots = sorted({slot_of[k] for k in range(NREC) if any(hab[s][k] for s in hab)})
    # places: a route's halves together (the place is the first half's record)
    def route_of(k):
        m = re.match(r'(ROUTE_\d+)_(NORTH|SOUTH|EAST|WEST)$', locs[k]['key'])
        return m.group(1) if m else locs[k]['key']
    groups = {}
    for k in slots:
        groups.setdefault(route_of(k), []).append(k)
    def order(g):
        k = groups[g][0]
        return (pz[locs[k]['pearl']]['mapsec'], g)
    names = sorted(groups, key=order)
    def page_entries(ks):
        out = {}
        for spc in hab:
            b = 0
            for k in ks: b |= hab[spc][k]
            if b: out[spc] = b
        return out
    # Black 2's list holds 57: leave out the places whose every (species, kind) a listed place has too, last first
    left_out = []
    while len(names) > HLIST_PLACES:
        for g in reversed(names):
            others = set()
            for o in names:
                if o != g and o not in left_out:
                    others |= {(s, b) for s, bb in page_entries(groups[o]).items() for b in (1, 8, 32) if bb & b}
            mine = {(s, b) for s, bb in page_entries(groups[g]).items() for b in (1, 8, 32) if bb & b}
            if mine <= others:
                names.remove(g); left_out.append(g); break
        else:
            raise SystemExit(f'HABITAT list: {len(names)} places, none can go: {names}')
    pages, places = [], []
    for g in names:
        ents = []
        for spc, b in sorted(page_entries(groups[g]).items(), key=lambda kv: (sinnoh.get(kv[0], 999), kv[0])):
            kinds = bytes([int(bool(b & 0x07)), int(bool(b & 0x18)), int(bool(b & 0x60))])
            ents.append(struct.pack('<H', spc) + kinds * 4 + bytes(14))
        assert 0 < len(ents) <= HLIST_MAX, (g, len(ents))
        have = [any(e[2 + j] for e in ents) for j in range(3)]
        key = locs[groups[g][0]]['key']
        kind = PICTURE_OF.get(key) or ('cave' if locs[groups[g][0]]['kind'] == 'dungeon' else
                                       'field' if have[0] else 'water')
        pages.append(bytes([0, 0, 0, *map(int, have), PICTURE[kind], 0]) + struct.pack('<H', len(ents)) + b''.join(ents))
        places.append(g)
    pages += [bytes(8) + struct.pack('<H', 0)] * (HLIST_FILES - len(pages))
    path = arc_path(files, ARC_HLIST); size = os.path.getsize(path)
    assert len(narcio.load(files, ARC_HLIST)) == HLIST_FILES
    narcio.save(files, ARC_HLIST, pages)
    d = open(path, 'rb').read()
    open(path + '.tmp', 'wb').write(tm._pad_narc(d, size)); os.replace(path + '.tmp', path)
    place_of_slot = {k: i for i, g in enumerate(places) for k in groups[g]}
    zone_place = bytes(place_of_slot.get(slot_of[ztab[z]], 0xFF) if ztab[z] != 0xFF else 0xFF for z in range(len(ztab)))
    AREA['hlist'] = dict(places=[rzones[groups[g][0]] for g in places], zone_place=zone_place, names=places,
                         works=_visited_works(), left_out=left_out)
    return (f'HABITAT list: {len(places)} places ({", ".join(places[:4])} ...; left out, all their Pokémon listed '
            f'elsewhere: {left_out}), {sum(struct.unpack_from("<H", p, 8)[0] for p in pages)} entries; a/2/9/6 '
            f'{len(d)} -> {size} B')


# ------------------------------------------------------------------------------------------------- the code

def bl(src, dst):
    off = (dst & ~1) - (src + 4)
    assert -(1 << 22) <= off < (1 << 22) and not off & 1, (hex(src), hex(dst))
    return struct.pack('<HH', 0xF000 | (off >> 12) & 0x7FF, 0xF800 | (off >> 1) & 0x7FF)


def edit(code, n, addr, old, new):
    """Overlay n: the bytes at addr must be `old`; write `new` (same size)."""
    p = os.path.join(code, f'arm9_ov{n:03d}.bin'); d = bytearray(open(p, 'rb').read())
    o = addr - OV[n]
    assert bytes(d[o:o + len(old)]) == old, f'ov{n:03d} {addr:#x}: {d[o:o + len(old)].hex()} != {old.hex()}'
    assert len(new) == len(old)
    d[o:o + len(new)] = new
    _save(p, d)


def area_code(code):
    """ITCM: src/code/dex_area.c; the area page's, HABITAT list's and zone entry's calls to it (HoennB2's sites)."""
    import tempfile, itcm
    h = AREA['hlist']
    src = os.path.join(ROOT, 'src', 'code', 'dex_area.c')
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        with open(os.path.join(tmp, 'dex_area.h'), 'w') as f:
            f.write('/* generated by b2tools/patches/sinnoh_pokedex.py */\n'
                    f'#define N_ZONES {AREA["nzones"]}\n#define ZT_OFF {AREA["zt_off"]}\n'
                    f'#define FILLER_RECORD {AREA["filler"]}\n#define N_RODS {len(ITEM_RODS)}\n'
                    f'static const u16 kVisitedWorks[4] = {{{", ".join(hex(w) for w in h["works"])}}};\n'
                    f'static const u16 kRods[N_RODS] = {{{", ".join(map(str, ITEM_RODS))}}};\n'
                    f'static const u8 kZonePlace[N_ZONES] = {{{", ".join(map(str, h["zone_place"]))}}};\n')
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp, includes=[tmp]))
    for n, at in ((298, 0x021A3332), (303, 0x021A1AC6), (308, 0x0219FC92)):
        edit(code, n, at, bl(at, F718), bl(at, sym['DexLoadRecords']))
    for n, at in ((298, 0x021A47FA), (303, 0x021A2D42), (303, 0x021A3008)):   # r1 = the zone: no Unova parent
        edit(code, n, at, bl(at, PARENT_ZONE), bytes.fromhex('081cc046'))      # adds r0, r1, #0; nop
    for n, at, fn in ((298, 0x021A4804, 'DexFindRecord'), (303, 0x021A2D4C, 'DexFindRecordSafe'),
                      (303, 0x021A3012, 'DexFindRecord'), (308, 0x021A10CE, 'DexFindRecord')):
        edit(code, n, at, bl(at, F73C), bl(at, sym[fn]))
    p = os.path.join(code, 'arm9_ov298.bin'); d = bytearray(open(p, 'rb').read())
    o = ZONE_LIST - OV[298]
    assert struct.unpack_from('<3H', d, o) == (389, 397, 6), 'ov298 zone list'
    struct.pack_into('<85H', d, o, *AREA['zones'])
    _save(p, d)
    rows = [(VISITED_BASE + i, z, i, 0) for i, z in enumerate(h['places'])]
    rows += [(VISITED_BASE + i, 0xFFFF, HLIST_FILES - 1, 0) for i in range(len(rows), HLIST_PLACES)]
    for n, at in TABLES.items():
        p = os.path.join(code, f'arm9_ov{n:03d}.bin'); d = bytearray(open(p, 'rb').read())
        o = at - OV[n]
        assert d[o:o + 6] == bytes.fromhex('b809ab011800'), f'ov{n:03d} HABITAT list table at {at:#x}'
        d[o:o + 6 * HLIST_PLACES] = b''.join(struct.pack('<HHBB', *r) for r in rows)
        _save(p, d)
    EventWork_FlagGet, SetTeleportZoneDiscover = 0x020191AC, 0x02154F30
    for n, at in ((302, 0x021AD95E), (302, 0x021ADB3E), (302, 0x021ADB98), (302, 0x021ADE32), (298, 0x021A62E6)):
        edit(code, n, at, bl(at, EventWork_FlagGet), bl(at, sym['HabitatVisited']))
    for n, at in ((35, 0x0217E57E), (36, 0x02180CD8)):
        edit(code, n, at, bl(at, SetTeleportZoneDiscover), bl(at, sym['HabitatDiscover']))
    edit(code, 302, 0x021ADD96, bytes.fromhex('1820'), bytes([HLIST_FILES - 1, 0x20]))   # movs r0, #0x18 -> the filler
    return (f'area page: Sinnoh records, zone table, habitat zones; HABITAT list: {len(h["places"])} places; '
            f'ITCM {base:#x}-{end:#x}')


def apply(files):
    return habitat(files)


def apply_code(code):
    out = [global_text_code(code)]
    if AREA:
        out.append(area_code(code))
    return '; '.join(out)


if __name__ == '__main__':
    if sys.argv[1:] == ['--sources']:
        print(write_sources())
    elif sys.argv[1:] == ['--text']:
        print(write_text())
