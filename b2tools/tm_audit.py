"""Pearl's TMs and HMs in Pearl NDS (notes/TMS.md): the data every TM tool shares, and the offline proof.

    python3 tm_audit.py               Pearl's TM/HMs by move against Black 2's (Markdown): Pearl's number, the move,
                                      the Black 2 item that teaches it here
    python3 tm_audit.py check [FILES] the proof (prints the table, exits 1 on any mismatch): every Pearl TM/HM -> its
                                      Black 2 item -> the move the game's TM functions give for it -> who can learn it,
                                      against Pearl's own data (the dump's personal_pearl.narc), for species 1-493 and
                                      Pearl's forms; the Unova species' new TM bits against their close Black 2 move
                                      (PROXY); Black 2's own TMs' bits unchanged; every TM/HM the installed story
                                      scripts and Pearl's item balls give; the shop lists. FILES: a built ROM's files/
                                      (PEARL_BUILD_DIR/files); default: pearl_tms applied to a copy of Black 2's files.

Way 2 (the user: question 9b B, 2026-10-18; item ids, Unova learners and wording 2026-10-26): Black 2's TM01-TM95 and
HM01-HM06 stay; Pearl's 25 TM/HM moves Black 2 has no TM for are TM96-TM120, items PEARLB2_TM_FIRST_ITEM.. (the
decomp's include/pearlb2.h is the one place the ids are set; src/pearlb2/tms_itcm.c has the game's TM functions and
lists the new TMs' moves, checked here against Pearl's order). Pearl's item ids 328-427 are Black 2's TM01-TM92 /
HM01-HM06 by number, so each Pearl TM/HM item a script gives is mapped BY MOVE (HoennB2's lesson: Gen 5 numbers teach
other moves): pearl_item().

Sources: pokediamond arm9/src/itemtool.c sTMHMMoves (Pearl's TM01-TM92, HM01-HM08), the decomp's src/system/pml_item.c
TM_MOVE_LIST (Black 2's TM01-TM92, HM01-HM06, TM93-TM95), the Pearl dump's poketool/personal_pearl/personal.narc
(equal to pokediamond's personal_pearl/personal.json: checked 2026-10-26, 501 records, 0 differences).
"""
import collections, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
DIAMOND = os.path.join(ROOT, 'external', 'pokediamond')
VANILLA_FILES = os.path.join(DECOMP, 'build', 'b2_us', 'files')

ITEM_TM01, ITEM_HM01, ITEM_TM93 = 328, 420, 618        # Black 2 (Pearl: TM01 328, HM01 420, HM08 427)
PEARL_TM01, PEARL_COUNT = 328, 100
PERSONAL, ITEMS = 16, 24                               # a/0/1/6, a/0/2/4
MACHINES, TUTORS_PAID = 0x28, 0x3C                     # personal record: 4 words of TM/HM bits, the paid tutors' words
RECORD = 0x4C
FORM_FILE, FORM_COUNT = 0x1C, 0x20

# Unova species (494-649 and their forms) have no Pearl data: a new TM is learnable where they learn a close Black 2
# move (the user, 2026-10-26: as HoennB2's new_tms.py PROXY did). ('tm', n) / ('hm', n) = Black 2's TMn / HMn bit;
# ('tutor', move) = that move's bit in Black 2's paid tutors (src/ov036/scrcmd_shop.c MOVE_TUTOR_ITEMS_*: the word of
# the tutor in MOVE_TUTOR_SHOP_ITEMS order, the bit = the move's place in its list). Eleven are Black 2 tutor moves
# themselves.
PROXY = {'MOVE_FOCUS_PUNCH': ('tm', 52, 'Focus Blast'), 'MOVE_WATER_PULSE': ('tm', 55, 'Scald'),
         'MOVE_BULLET_SEED': ('tutor', 'MOVE_SEED_BOMB', 'Seed Bomb'), 'MOVE_GIGA_DRAIN': ('tutor', 'MOVE_GIGA_DRAIN', 'itself'),
         'MOVE_IRON_TAIL': ('tutor', 'MOVE_IRON_TAIL', 'itself'), 'MOVE_SHOCK_WAVE': ('tm', 57, 'Charge Beam'),
         'MOVE_SECRET_POWER': ('tm', 27, 'Return'), 'MOVE_STEEL_WING': ('hm', 2, 'Fly'),
         'MOVE_SKILL_SWAP': ('tutor', 'MOVE_SKILL_SWAP', 'itself'), 'MOVE_SNATCH': ('tutor', 'MOVE_SNATCH', 'itself'),
         'MOVE_ROOST': ('tutor', 'MOVE_ROOST', 'itself'), 'MOVE_BRINE': ('tm', 55, 'Scald'),
         'MOVE_ENDURE': ('tm', 17, 'Protect'), 'MOVE_DRAGON_PULSE': ('tutor', 'MOVE_DRAGON_PULSE', 'itself'),
         'MOVE_DRAIN_PUNCH': ('tutor', 'MOVE_DRAIN_PUNCH', 'itself'), 'MOVE_SILVER_WIND': ('tm', 76, 'Struggle Bug'),
         'MOVE_RECYCLE': ('tutor', 'MOVE_RECYCLE', 'itself'), 'MOVE_AVALANCHE': ('tm', 79, 'Frost Breath'),
         'MOVE_STEALTH_ROCK': ('tutor', 'MOVE_STEALTH_ROCK', 'itself'), 'MOVE_CAPTIVATE': ('tm', 45, 'Attract'),
         'MOVE_DARK_PULSE': ('tutor', 'MOVE_DARK_PULSE', 'itself'), 'MOVE_SLEEP_TALK': ('tutor', 'MOVE_SLEEP_TALK', 'itself'),
         'MOVE_NATURAL_GIFT': ('tm', 27, 'Return'), 'MOVE_DEFOG': ('hm', 2, 'Fly'),
         'MOVE_ROCK_CLIMB': ('hm', 4, 'Strength')}
BADGE_MART_LISTS = range(0, 6)                       # ov036 scrcmd_shop.c BADGE_SHOP_DAT_IDS: 0-5
TUTOR_ORDER = ('DRIFTVEIL_CITY', 'LENTIMAS_TOWN', 'HUMILAU_CITY', 'NACRENE_CITY')   # MOVE_TUTOR_SHOP_ITEMS


# ---- the data ------------------------------------------------------------------------------------------------------
def _moves_in(path, start):
    src = open(path, encoding='utf-8').read()
    i = src.index(start)
    body = src[src.index('{', i) + 1:src.index('};', i)]
    body = re.sub(r'//[^\n]*', '', body)
    return [m for m in re.findall(r'\bMOVE_\w+', body) if m != 'MOVE_NONE']


def pearl_moves():
    """Pearl's TM01-TM92, HM01-HM08 moves (index 0-99 = Pearl items 328-427)."""
    m = _moves_in(os.path.join(DIAMOND, 'arm9', 'src', 'itemtool.c'), 'sTMHMMoves[]')
    assert len(m) == PEARL_COUNT, len(m)
    return m


def pearl_label(n):
    return f'TM{n + 1:02d}' if n < 92 else f'HM{n - 91:02d}'


def b2_moves():
    """Black 2's TM_MOVE_LIST: TM01-TM92, HM01-HM06, TM93-TM95."""
    m = _moves_in(os.path.join(DECOMP, 'src', 'system', 'pml_item.c'), 'TM_MOVE_LIST[]')
    assert len(m) == 101, len(m)
    return m


def header():
    """The new TMs' numbers from the decomp's include/pearlb2.h (the one place the item ids are set)."""
    h = open(os.path.join(DECOMP, 'include', 'pearlb2.h')).read()
    get = lambda n: int(re.search(rf'#define {n} (\d+)', h).group(1))
    return {k: get(f'PEARLB2_TM_{k}') for k in ('FIRST_ITEM', 'COUNT', 'FIRST_NUMBER', 'FIRST_BIT')}


def itcm_moves():
    """The new TMs' moves as src/pearlb2/tms_itcm.c lists them (sPearlTMMoves)."""
    return _moves_in(os.path.join(DECOMP, 'src', 'pearlb2', 'tms_itcm.c'), 'sPearlTMMoves[PEARLB2_TM_COUNT]')


def new_tms():
    """[(number, item, bit, move, Pearl label)] of TM96-TM120: Pearl's TM/HM moves Black 2 has no TM for, in Pearl's
    order (checked against tms_itcm.c)."""
    h, b2 = header(), set(b2_moves())
    missing = [(pearl_label(n), m) for n, m in enumerate(pearl_moves()) if m not in b2]
    assert len(missing) == h['COUNT'], (len(missing), h['COUNT'])
    assert [m for _, m in missing] == itcm_moves(), 'src/pearlb2/tms_itcm.c sPearlTMMoves is not Pearl\'s missing moves'
    return [(h['FIRST_NUMBER'] + k, h['FIRST_ITEM'] + k, h['FIRST_BIT'] + k, m, p) for k, (p, m) in enumerate(missing)]


def machines():
    """{Black 2 item: (label, move, bit)} of every TM/HM item: Black 2's 101 and the new ones (the game's
    PML_ItemGetTMWazaID / PML_ItemGetTMBitMask, src/pearlb2/tms_itcm.c)."""
    out = {}
    for n, m in enumerate(b2_moves()):
        if n < 92:
            out[ITEM_TM01 + n] = (f'TM{n + 1:02d}', m, n)
        elif n < 98:
            out[ITEM_HM01 + n - 92] = (f'HM{n - 91:02d}', m, 95 + n - 92)
        else:
            out[ITEM_TM93 + n - 98] = (f'TM{n - 5:02d}', m, 92 + n - 98)
    for num, item, bit, m, _ in new_tms():
        out[item] = (f'TM{num}', m, bit)
    return out


def pearl_item_map():
    """{Pearl item id: Black 2 item id} for Pearl's 100 TM/HM items: the item that teaches the same move."""
    by_move = {m: it for it, (_, m, _) in machines().items()}
    return {PEARL_TM01 + n: by_move[m] for n, m in enumerate(pearl_moves())}


_MAP = None


def pearl_item(value):
    """A Pearl item id as Black 2's (the story generator: scripts give and check items by Pearl's ids, which are Black
    2's below 468 except for the TM/HMs, mapped by move)."""
    global _MAP
    if _MAP is None:
        _MAP = pearl_item_map()
    return _MAP.get(value, value)


def item_name(item):
    m = machines().get(item)
    return f'{m[0]} {title(m[1])}' if m else str(item)


def title(move):
    return move[5:].replace('_', ' ').title()


def move_ids():
    path = os.path.join(DECOMP, 'build', 'include', 'generated', 'constants', 'moves.h')
    return {k: int(v) for k, v in re.findall(r'#define (MOVE_\w+)\s+(\d+)', open(path).read())}


def tutor_bits():
    """{move: (tutor, bit)} of Black 2's paid tutors."""
    src = open(os.path.join(DECOMP, 'src', 'ov036', 'scrcmd_shop.c')).read()
    out = {}
    for t, name in enumerate(TUTOR_ORDER):
        for k, m in enumerate(_moves_in_tutor(src, f'MOVE_TUTOR_ITEMS_{name}[]')):
            out[m] = (t, k)
    return out


def _moves_in_tutor(src, start):
    i = src.index(start)
    body = src[src.index('{', i) + 1:src.index('};', i)]
    return re.findall(r'\{ \{ (MOVE_\w+), \d+ \}, \d+ \}', body)


# ---- who learns what -----------------------------------------------------------------------------------------------
def pearl_personal():
    """The dump's personal_pearl.narc: [record] (0-493 the species, 494-495 eggs, 496-498 Deoxys's forms, 499-500
    Wormadam's)."""
    from gen4rom import Rom, narc_members
    return narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read('poketool/personal_pearl/personal.narc'))


def pearl_learns(rec):
    """The moves of Pearl's TM/HM bits of one record (+0x1C, 100 bits)."""
    bits = int.from_bytes(rec[0x1C:0x2C], 'little')
    return {m for n, m in enumerate(pearl_moves()) if bits >> n & 1}


PEARL_FORMS = {386: [496, 497, 498], 413: [499, 500]}     # Deoxys Attack/Defense/Speed, Wormadam Sandy/Trash


def b2_species_of(pers):
    """{Black 2 personal record: (species, form)} for every species record (1-649) and form record."""
    out = {s: (s, 0) for s in range(1, 650)}
    for s in range(1, 650):
        first, count = struct.unpack_from('<H', pers[s], FORM_FILE)[0], pers[s][FORM_COUNT]
        if first:
            for f in range(1, count):
                out[first + f - 1] = (s, f)
    return out


def pearl_record_for(species, form, pearl):
    """Pearl's record for a Black 2 species/form, or None (Unova species): Pearl's own form record where it has one,
    else the species' (Castform's, Rotom's, Giratina's, Shaymin's forms: Pearl has none of their own)."""
    if species > 493:
        return None
    if form and species in PEARL_FORMS and form <= len(PEARL_FORMS[species]):
        return pearl[PEARL_FORMS[species][form - 1]]
    return pearl[species]


def _bit(rec, b):
    return struct.unpack_from('<I', rec, MACHINES + 4 * (b // 32))[0] >> (b % 32) & 1


def proxy_learns(rec, move, tutors):
    how = PROXY[move]
    if how[0] == 'tutor':
        t, k = tutors[how[1]]
        return bool(struct.unpack_from('<I', rec, TUTORS_PAID + 4 * t)[0] >> k & 1)
    b = how[1] - 1 if how[0] == 'tm' else 95 + how[1] - 1
    return bool(_bit(rec, b))


def target_bits(pers):
    """[(record, {bit: bool})]: the machine bits pearl_tms sets. Species 1-493 and their forms: for each of Pearl's 100
    TM/HM moves, the bit of the Black 2 item that teaches it, from Pearl's own data. Unova species and forms: the new
    TMs' bits from PROXY (Black 2's own bits stay). Black 2's TMs Pearl doesn't have (Scald, ...) keep Black 2's bits."""
    pearl, mach, tutors = pearl_personal(), machines(), tutor_bits()
    bit_of = {m: b for _, m, b in mach.values()}
    new = [m for _, _, _, m, _ in new_tms()]
    out = []
    for rec, (species, form) in sorted(b2_species_of(pers).items()):
        if len(pers[rec]) != RECORD:
            continue
        p = pearl_record_for(species, form, pearl)
        if p is not None:
            learns = pearl_learns(p)
            out.append((rec, {bit_of[m]: m in learns for m in pearl_moves()}))
        else:
            out.append((rec, {bit_of[m]: proxy_learns(pers[rec], m, tutors) for m in new}))
    return out


# ---- the proof -----------------------------------------------------------------------------------------------------
def _offline_files(tmp):
    """A files/ tree with Black 2's a/0/1/6 and a/0/2/4 (clones) and pearl_tms applied."""
    import shutil, subprocess
    for arc in (PERSONAL, ITEMS):
        rel = os.path.join('a', str(arc // 100), str(arc // 10 % 10), str(arc % 10))
        os.makedirs(os.path.dirname(os.path.join(tmp, rel)), exist_ok=True)
        subprocess.run(['cp', '-c', os.path.join(VANILLA_FILES, rel), os.path.join(tmp, rel)], check=True)
    sys.path.insert(0, os.path.join(HERE, 'patches'))
    import pearl_tms
    return pearl_tms.apply(tmp)


def script_items():
    """[(file, line, Black 2 item, Pearl item)] of every TM/HM item the installed story scripts give or check: the
    generator writes `// Pearl item N` on each such line (pearl_story.py)."""
    out = []
    d = os.path.join(ROOT, 'src', 'field_scripts')
    pat = re.compile(r'\b(?:PVAR_8004|PVAR_8008|pl_CheckItem|pl_AddItem|pl_RemoveItem|pl_CanFitItem|pl_BufferItemName'
                     r'|pl_BufferTMHMMoveName)\b.*\b(\d+)\s*// Pearl item (\d+)')   # (the item: the last argument)
    for f in sorted(os.listdir(d)):
        if '_pearl_' not in f:
            continue
        for k, line in enumerate(open(os.path.join(d, f)), 1):
            m = pat.search(line)
            if m:
                out.append((f, k, int(m.group(1)), int(m.group(2))))
    return out


def pearl_script_items():
    """Counter of Pearl's TM/HM items given or checked in Pearl's scripts (scr_seq), by item id: the gifts (var 0x8004),
    the item balls (0x8008, file 370), CheckItem."""
    import pearl_story
    pd = pearl_story.PearlData()
    out = collections.Counter()
    for f in range(len(pd.files)):
        try:
            d = pd.disasm(f)
        except Exception:
            continue
        for a in sorted(d.insns):
            _, op, args = d.insns[a]
            name, vals = pd.cmd_name(op), [v for _, v in args]
            if name == 'SetVarFromValue' and vals[0] in (0x8004, 0x8008) and PEARL_TM01 <= vals[1] < PEARL_TM01 + 100:
                out[vals[1]] += 1
    return out


def pearl_shop_tms():
    """{place: [TMnn]} of the TMs Pearl sells (pokediamond scrcmd_mart.c's lists: the Veilstone Department Store's
    TM floor) and gives as Game Corner prizes (scrcmd_prizes.c)."""
    out = {}
    for f, what in (('scrcmd_mart.c', 'Veilstone Department Store list'), ('scrcmd_prizes.c', 'Game Corner prizes')):
        src = open(os.path.join(DIAMOND, 'arm9', 'src', f)).read()
        for k, body in enumerate(re.findall(r'\[\d*\](?:\[\d+\])? = \{(.*?)\n\};', src, re.S)):
            tms = re.findall(r'ITEM_(TM\d\d)', body)
            if tms:
                out[f'{what} {k}' if f == 'scrcmd_mart.c' else what] = tms
    return out


def check(files=None):
    import narcio, tempfile
    bad = []
    mach, pmoves, new = machines(), pearl_moves(), new_tms()
    pearl, tutors = pearl_personal(), tutor_bits()
    vanilla = narcio.load(VANILLA_FILES, PERSONAL)
    shop_files = files or VANILLA_FILES                # (pearl_tms changes no shop list)
    with tempfile.TemporaryDirectory() as tmp:
        if files is None:
            print('(offline: pearl_tms applied to a copy of Black 2\'s personal and item data)', _offline_files(tmp))
            files = tmp
        pers, items = narcio.load(files, PERSONAL), narcio.load(files, ITEMS)
    recs = b2_species_of(pers)
    pmap = pearl_item_map()
    print('| Pearl | Move | Item here | No. | Bit | Learners here (1-493 + forms) | = Pearl | Unova learners |')
    print('|---|---|---|---|---|---|---|---|')
    for n, m in enumerate(pmoves):
        item = pmap[PEARL_TM01 + n]
        label, move, bit = mach[item]
        if move != m:
            bad.append(f'{pearl_label(n)}: item {item} teaches {move}, not {m}')
        here = gen4 = unova = 0
        for rec, (species, form) in recs.items():
            if len(pers[rec]) != RECORD:
                continue
            got = _bit(pers[rec], bit)
            p = pearl_record_for(species, form, pearl)
            if p is None:
                unova += got
                if m in PROXY and got != proxy_learns(vanilla[rec], m, tutors):
                    bad.append(f'{pearl_label(n)}: Unova record {rec} bit {bit} = {got}, its close move says otherwise')
                elif m not in PROXY and got != _bit(vanilla[rec], bit):
                    bad.append(f'{pearl_label(n)}: Unova record {rec} bit {bit} changed from Black 2\'s')
                continue
            want = m in pearl_learns(p)
            here += got
            gen4 += want
            if got != want:
                bad.append(f'{pearl_label(n)} {title(m)}: record {rec} (species {species} form {form}) learns {got}, '
                           f'Pearl {int(want)}')
        print(f'| {pearl_label(n)} | {title(m)} | {item} {label} | {label[2:]} | {bit} | {here} | '
              f'{"yes" if here == gen4 else "NO"} | {unova} |')
    # the built code: the new TMs' move table the game reads (the decomp's itcm.bin, which build_rom copies)
    try:
        import decomp
        itcm = open(os.path.join(decomp.CODE, 'itcm.bin'), 'rb').read()
        at = decomp.symbol('sPearlTMMoves') - decomp.ITCM
        built = struct.unpack_from(f'<{len(new)}H', itcm, at)
        mid = move_ids()
        if list(built) != [mid[m] for _, _, _, m, _ in new]:
            bad.append(f'the built sPearlTMMoves is {built}')
        else:
            print(f'(built code: sPearlTMMoves at {decomp.symbol("sPearlTMMoves"):#x} = the {len(new)} moves)')
    except (ImportError, KeyError, OSError, ValueError, TypeError) as e:
        print(f'(built code not checked: {e})')
    # Black 2's own TMs that Pearl lacks keep Black 2's bits
    pearl_set = set(pmoves)
    for item, (label, move, bit) in mach.items():
        if move in pearl_set:
            continue
        diff = [r for r in recs if len(pers[r]) == RECORD and _bit(pers[r], bit) != _bit(vanilla[r], bit)]
        if diff:
            bad.append(f'Black 2\'s {label} {title(move)}: {len(diff)} records changed')
    # the new items' data: Black 2 TM01's record, own price and sort index
    tm01 = items[ITEM_TM01]
    for num, item, bit, move, _ in new:
        r = items[item]
        if r[2:0xF] != tm01[2:0xF] or r[0xF] != bit:
            bad.append(f'item {item} (TM{num}): its data is not TM01\'s with sort index {bit}: {r.hex()}')
    # the scripts
    given = script_items()
    for f, k, item, pitem in given:
        want = pmap.get(pitem)
        if want != item:
            bad.append(f'{f}:{k}: gives/checks item {item} for Pearl item {pitem} ({want} expected)')
    print(f'\nInstalled story scripts: {len(given)} TM/HM item lines, ' +
          ', '.join(f'{item_name(i)} x{c}' for i, c in sorted(collections.Counter(i for _, _, i, _ in given).items())))
    pearl_given = pearl_script_items()
    print(f'Pearl\'s scripts (all zones, item balls included): {sum(pearl_given.values())} TM/HM gifts of '
          f'{len(pearl_given)} kinds; mapped: ' + ', '.join(
              f'{pearl_label(p - PEARL_TM01)}->{mach[pmap[p]][0]}' for p in sorted(pearl_given) if pmap[p] != p))
    # Pearl's own shops and prizes (not ported yet: Pearl's specialty clerks open Black 2's normal Mart, the Game
    # Corner is closed): what each TM would be here, for when they are
    for what, tms in pearl_shop_tms().items():
        print(f'Pearl\'s {what}: ' + ', '.join(f'{t}->{mach[pmap[PEARL_TM01 + int(t[2:]) - 1]][0]}' for t in tms))
    # shops: every shop list file and what TM/HM items it sells
    lists = narcio.load(shop_files, 282)
    sold = {i: [it for it in struct.unpack(f'<{len(d) // 2}H', d) if it in mach] for i, d in enumerate(lists)}
    sold = {i: s for i, s in sold.items() if s}
    print('Black 2\'s shop lists (a/2/8/2) with TM/HM items: ' + ('; '.join(
        f'file {i}: ' + ', '.join(mach[it][0] for it in s) for i, s in sold.items()) or 'none') +
        '. Pearl NDS\'s Marts are Black 2\'s badge Mart (pl_PokeMartCommon: shop 255, lists '
        f'{BADGE_MART_LISTS[0]}-{BADGE_MART_LISTS[-1]}): ' +
        (', '.join(mach[it][0] for i in BADGE_MART_LISTS for it in sold.get(i, [])) or 'no TMs'))
    for i in BADGE_MART_LISTS:
        if sold.get(i):
            bad.append(f'badge Mart list {i} sells {sold[i]}: check them against Pearl')
    print('\n' + ('OK: every Pearl TM/HM teaches Pearl\'s move to the Pokemon Pearl allows' if not bad else
                  f'{len(bad)} PROBLEMS:\n' + '\n'.join(bad[:60])))
    return not bad


def table():
    pmap, mach = pearl_item_map(), machines()
    rows = [(pearl_label(n), m, pmap[PEARL_TM01 + n]) for n, m in enumerate(pearl_moves())]
    new = {it for _, it, _, _, _ in new_tms()}
    same = sum(1 for p, _, it in rows if mach[it][0] == p)
    other = sum(1 for p, _, it in rows if mach[it][0] != p and it not in new)
    print(f'Pearl TM/HMs: {len(rows)}; the same number here: {same}; Black 2\'s under another number: {other}; '
          f'new TM96-TM120: {len(new)}\n')
    print('| Pearl | Move | Here | Item |\n|---|---|---|---|')
    for p, m, it in rows:
        print(f'| {p} | {title(m)} | {mach[it][0]} | {it} |')


if __name__ == '__main__':
    if sys.argv[1:2] == ['check']:
        sys.exit(0 if check(sys.argv[2] if len(sys.argv) > 2 else None) else 1)
    table()
