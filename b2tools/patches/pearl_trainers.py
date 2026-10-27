"""Pearl's trainers in Black 2 (notes/TRAINERS.md "Installed"): the battled and partner trainers of the installed story
zones, at their Black 2 ids (data/pearl_story_ids.json "trainers"), with their names, parties, classes and messages,
and the Sinnoh classes' pictures, names and battle music. Run after sinnoh_names (system text), sinnoh_story (which
places the trainer NPCs: evType 1, sight = Pearl's, script 3000 + Black 2 id) and pearl_trainer_pics (the pictures):

    build_rom.py ... sinnoh_names ... sinnoh_story ... pearl_trainer_pics pearl_trainers

Which trainers: every trainer an installed zone uses (src/field_scripts/NNNN_pearl_*.s: the zone's trainer NPCs and
the PTRAINER_n its scripts battle); PEARL_TRAINERS=all installs all 520.

How (pokebw2's own sources and packers, on a clone: b2tools/pokebw2_mod.py; an unchanged clone packs a/0/9/1, a/0/9/2,
a/0/8/9 and a/0/9/0 byte-identical to Black 2's, checked 2026-10-18):
- each trainer's res/trainers/data/<Black 2 constant>.json becomes Pearl's (work/pearl/b2_trainers/data/NNN.json,
  b2tools/sinnoh_trainers.py: party, items, AI, prize), with Pearl's class (below) and Pearl's messages;
- tools/data/trainer_data.py pack -> a/0/9/1 (records), a/0/9/2 (parties), a/0/8/9 + a/0/9/0 (message table);
- tools/text/text_data.py pack (system text) -> only files 381 (messages), 382 (names), 383 and 485 (class names) are
  copied into this build's a/0/0/2, so the other patches' system text (sinnoh_names) stays.
- Messages: Pearl's poketool/trmsg/trtbl.narc pairs (trainer, type) with message bank 558 (pokediamond
  trainer_data.c GetTrainerMessageByIdPair). Gen 4 and Black 2 number the types alike for 0-10 (0 intro, 1 defeat in
  battle, 2 after, 3/5/6 and 7/9/10 the two NPCs of a double trainer: HoennB2 notes/STORY_PORTING.md); Pearl's
  in-battle lines 13-16 (first damage, half HP, last Pokémon, last Pokémon at half HP: pokeplatinum
  trainer_message_types.txt) are Black 2's 17-20 (ov167 btl_client.c sTrainerHintMsgs: 0x11 not full HP, 0x12 half,
  0x13 last, 0x14 last at half). A double trainer's two defeat lines (4, 8) become one type 1 line (Black 2 shows type
  1; its 8 is TRMSG_WIN). Rematch lines (17-19) and 11/12 (unused) are left out.
- Classes: data/pearl_trainer_classes.json (the registry, fixed once given; `python3 pearl_trainers.py --classes`
  adds missing classes, never moves one). Pearl classes Black 2 also has keep Black 2's class (sinnoh_trainers.py
  CLASS_MAP 'same'/'near'); Gym Leaders take Black 2's Unova leader classes 112-119 (special: the leader battle
  music) with Black 2's own PWT pictures of the Sinnoh leaders; the Elite Four, Cynthia, Barry and Team Galactic take
  Black 2's special classes of the same role (Elite Four, Champion, the rival, Team Plasma) with Pearl's pictures; the
  other Sinnoh-only classes take spare Black 2 classes (no Black 2 trainer or facility uses them) with Pearl's
  pictures (patches/pearl_trainer_pics.py, sprites 188-233).
apply_code: TRAINER_CLASS_RESOURCES (arm9 0x02092394, 4 bytes per class: sprite, sex, u16 eye-contact BGM) of those
classes; the special classes' encounter effect (ov036 SPECIAL_TRAINER_ENCEFF 0x021d2900: Black 2's character cut-ins ->
5, its plain trainer effect, as HoennB2 found: the Elite Four cut-in hangs outside the League), music group (arm9
SPECIAL_TRAINER_CLASSES 0x020922bc) and group music (ov036 SPECIAL_TRAINER_BGM 0x021d28e4). As HoennB2's
patches/trainers.py does.
"""
import glob, json, os, re, shutil, struct, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio  # noqa: E402

DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
VANILLA = os.path.join(DECOMP, 'build', 'b2_us', 'files')
REGISTRY = os.path.join(ROOT, 'data', 'pearl_trainer_classes.json')
TRAINERS = os.path.join(ROOT, 'work', 'pearl', 'b2_trainers')
ARM9_BASE, CLASS_RESOURCES, SPECIAL_CLASSES = 0x02004000, 0x02092394, 0x020922bc
OV036_BASE, SPECIAL_BGM, SPECIAL_ENCEFF = 0x0217f600, 0x021d28e4, 0x021d2900
PLAIN_ENCEFF = 5
TEXT_FILES = (381, 382, 383, 485)        # trainer messages, names, class names, class names with an article
MSG_TYPE = {0: 0, 1: 1, 2: 2, 3: 3, 5: 5, 6: 6, 7: 7, 9: 9, 10: 10, 13: 17, 14: 18, 15: 19, 16: 20}
DOUBLE_DEFEAT = (4, 8)

# Black 2 classes no Black 2 trainer or facility uses (pokebw2 res/trainers/data and facilities, counted 2026-10-18):
# the NO_DATA classes, then the PKMN_TRAINER_M/F placeholders; HoennB2 used the same ones (converter/gen_trainers.py).
# Not 180-185 (2026-10-25): Black 2's battle view shows the player of a link battle as class 180/181 (and 182/183 as
# 184/185: ov168 BtlvEffect_SetTrainer), so the partners who had them (Riley, Marley, Buck, Mira, Lucas, Dawn) moved
# to 228-230 and Pokéstar Studios' classes 199, 200, 207 (only its movies use them; Pearl's map has no Studios), and
# patches/pearl_partner_backs.py gives 180/181 Pearl's Lucas and Dawn.
SPARE = [20, 21, 22, 23, 37, 39, 47, 55, 56, 77, 82, 93, 94, 95, 96, 98, 99, 103, 156, 166, 104, 105, 106, 107, 108,
         109, 110, 111, 198, 228, 229, 230, 199, 200, 207]
# Pearl class -> (Black 2 special class, sprite: None = Pearl's picture or a Black 2 sprite number, sex, special entry
# changes). Leaders: Black 2's PWT pictures of the Sinnoh leaders (the sprites of its classes ROARK..VOLKNER).
SPECIAL = {
    'LEADER_ROARK': (112, 129, 0), 'LEADER_GARDENIA': (113, 130, 1), 'LEADER_MAYLENE': (114, 132, 1),
    'LEADER_WAKE': (115, 133, 0), 'LEADER_FANTINA': (116, 131, 1), 'LEADER_BYRON': (117, 134, 0),
    'LEADER_CANDICE': (118, 135, 1), 'LEADER_VOLKNER': (119, 136, 0),
    'ELITE_FOUR_AARON': (79, None, 0), 'ELITE_FOUR_BERTHA': (81, None, 1), 'ELITE_FOUR_FLINT': (80, None, 0),
    'ELITE_FOUR_LUCIEN': (78, None, 0),
    'CHAMPION': (193, 91, 1),                       # Black 2's own picture of Cynthia (class 100's sprite)
    'PKMN_TRAINER_BARRY': (145, None, 0),           # the rival's class: Black 2 names him from the save's rival name
    'GALACTIC': (187, None, 0), 'GALACTIC_F': (188, None, 1),
    'COMMANDER_MARS': (191, None, 1), 'COMMANDER_JUPITER': (192, None, 1), 'COMMANDER_SATURN': (186, None, 0),
    'GALACTIC_BOSS': (189, None, 0),
}
GROUP = {'COMMANDER_JUPITER': 10, 'COMMANDER_SATURN': 10}   # the commanders share the Plasma sages' music group
GROUP_BGM = {0: 'SEQ_BGM_VS_DP_LEADER', 8: 'SEQ_BGM_VS_DP_CHAMP'}   # Black 2's own PWT versions of Pearl's themes
NAME = {'GALACTIC': 'Galactic', 'GALACTIC_F': 'Galactic', 'COMMANDER_MARS': 'Commander',
        'COMMANDER_JUPITER': 'Commander', 'COMMANDER_SATURN': 'Commander', 'GALACTIC_BOSS': 'Galactic Boss'}
SEX_FIX = {'COMMANDER_SATURN': 0}       # pokediamond's table says 1 (female) for Saturn


def b2_constants():
    classes = [l.split()[0] for l in open(os.path.join(DECOMP, 'generated', 'trainer_classes.txt'))
               if l.startswith('TRAINER_CLASS')]
    trainers = [l.split()[0] for l in open(os.path.join(DECOMP, 'generated', 'trainers.txt'))
                if l.startswith('TRAINER_')]
    return classes, trainers


def pearl_class_names():
    """{Pearl class constant: (name, name with article)} from pokediamond (text banks 560/561); PKMN -> Pokémon."""
    gmm = os.path.join(ROOT, 'external', 'pokediamond', 'files', 'msgdata', 'msg', 'narc_05{}.gmm')
    rows = []
    for n in ('60', '61'):
        xml = open(gmm.format(n), encoding='utf-8').read()
        rows.append([re.search(r'<language name="English">(.*?)</language>', r, re.S).group(1)
                     .replace('₧₦', 'Pokémon').replace('&amp;', '&')
                     for r in re.findall(r'<row[^>]*>(.*?)</row>', xml, re.S)])
    consts = re.findall(r'#define (TRAINER_CLASS_\w+)\s+(\d+)',
                        open(os.path.join(ROOT, 'external', 'pokediamond', 'include', 'constants',
                                          'trainer_classes.h')).read())
    sexes = re.findall(r'/\*(TRAINER_CLASS_\w+)\*/ (\d)', open(os.path.join(
        ROOT, 'external', 'pokediamond', 'arm9', 'src', 'trainer_data.c')).read())
    sex = {c[14:]: int(v) for c, v in sexes}
    return {c[14:]: (rows[0][int(n)], rows[1][int(n)], sex.get(c[14:], 0)) for c, n in consts}


def class_registry():
    """data/pearl_trainer_classes.json, with any Pearl class not in it added (existing entries never move)."""
    import sinnoh_trainers
    reg = json.load(open(REGISTRY)) if os.path.exists(REGISTRY) else {'classes': {}}
    reg['_doc'] = ('Pearl trainer class -> Black 2 class (registry: fixed once given; patches/pearl_trainers.py '
                   '--classes adds missing ones). Edits applied by patches/pearl_trainers.py: sprite/sex/eye_bgm in '
                   'arm9 TRAINER_CLASS_RESOURCES, name/name_with_article in system text 383/485, special = the class\'s '
                   'entry in SPECIAL_TRAINER_CLASSES (encounter effect, music group). Classes Black 2 also has are not '
                   'listed: they keep their Black 2 class (b2tools/sinnoh_trainers.py CLASS_MAP).')
    classes = reg['classes']
    names = pearl_class_names()
    b2_names, _ = b2_constants()
    res = open(os.path.join(DECOMP, 'build', 'b2_us', 'build', 'arm9.bin'), 'rb').read()
    eye = lambda c: struct.unpack_from('<H', res, CLASS_RESOURCES - ARM9_BASE + 4 * c + 2)[0]
    pics = json.load(open(os.path.join(ROOT, 'work', 'world', 'trainer_pics.json')))
    taken = {e['b2'] for e in classes.values()}
    spare = [c for c in SPARE if c not in taken]
    for pc, (b2c, how) in sinnoh_trainers.CLASS_MAP.items():
        if pc in classes or how in ('same', 'near') or (pc not in SPECIAL and pc not in pics):
            continue                    # (Pearl's player classes 0/1: no picture of their own, the stand-in stays)
        name, article, sex = names[pc]
        sex = SEX_FIX.get(pc, 0 if sex == 2 else sex)
        stand_in = b2_names.index('TRAINER_CLASS_' + b2c)
        if pc in SPECIAL:
            b2, sprite, sex = SPECIAL[pc]
            e = {'b2': b2, 'b2_name': b2_names[b2][14:], 'how': 'special', 'sprite': pics[pc] if sprite is None else sprite,
                 'sex': sex, 'special': {'enceff': PLAIN_ENCEFF}}
            if pc in GROUP:
                e['special']['bgm_group'] = GROUP[pc]
            if pc in NAME:
                e['name'], e['name_with_article'] = NAME[pc], ('an ' if NAME[pc][0] in 'AEIOU' else 'a ') + NAME[pc]
        else:
            b2 = spare.pop(0)
            e = {'b2': b2, 'b2_name': b2_names[b2][14:], 'how': 'spare', 'sprite': pics[pc], 'sex': sex,
                 'eye_bgm': eye(stand_in), 'name': name, 'name_with_article': article}
        classes[pc] = e
    reg['group_bgm'] = GROUP_BGM
    reg['classes'] = dict(sorted(classes.items(), key=lambda kv: kv[1]['b2']))
    return reg


# ---------------------------------------------------------------- messages

def pearl_messages():
    """{Pearl trainer id: [(Gen 4 type, Black 2 script-text line)]} from the dump."""
    import gen4_text
    from gen4rom import Rom, narc_members
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    tbl = narc_members(rom.read('poketool/trmsg/trtbl.narc'))[0]
    bank = gen4_text.bank(558)
    out = {}
    for i in range(len(tbl) // 4):
        t, ty = struct.unpack_from('<HH', tbl, 4 * i)
        line = gen4_text.b2_line(bank[i])
        while line.endswith('\\n'):
            line = line[:-2]
        out.setdefault(t, []).append((ty, line))
    return out


def b2_messages(msgs):
    """Black 2 [{type, text}] from Pearl's [(type, line)] (see the top)."""
    sys.path.insert(0, DECOMP)
    from tools.text.text_sources import to_json
    out, defeat = [], [line for ty, line in msgs if ty in DOUBLE_DEFEAT]
    have = {ty for ty, _ in msgs}
    for ty, line in msgs:
        if ty in MSG_TYPE:
            out.append({'type': MSG_TYPE[ty], 'text': to_json(line)})
    if defeat and 1 not in have:          # one page per speaker ({be01} + a new line: a page break, as Pearl's \r)
        out.append({'type': 1, 'text': to_json('{be01}\\n'.join(defeat))})
    return out


# ---------------------------------------------------------------- which trainers

def wanted(ids):
    """Pearl trainer ids the installed story zones use."""
    if os.environ.get('PEARL_TRAINERS') == 'all':
        return sorted(int(k) for k in ids['trainers'])
    import pearl_story, pearl_events
    pd = pearl_story.PearlData()
    by_num = pd.zones_of_script_file()
    out = set()
    for path in glob.glob(os.path.join(ROOT, 'src', 'field_scripts', '*_pearl_*.s')):
        num = int(os.path.basename(path)[:4])
        if num not in by_num:
            continue
        out |= {int(n) for n in re.findall(r'\bPTRAINER_(\d+)\b', open(path).read())}
        for z in (z for z in by_num[num] if pd.b2_zone.get(z['id']) is not None):
            for o in pd.events(z)['object_events']:
                if pearl_events.script_kind(o['script']) == 'trainer':
                    out.add(o['script'] - 2999 if o['script'] < 5000 else o['script'] - 4999)
    return sorted(t for t in out if str(t) in ids['trainers'])


# ---------------------------------------------------------------- the patch

def _run(tree, args):
    r = subprocess.run([sys.executable, *args], cwd=tree, capture_output=True, text=True)
    if r.returncode:
        raise SystemExit(f'pearl_trainers: {" ".join(args)} failed:\n{r.stdout[-2000:]}{r.stderr[-3000:]}')


def apply(files):
    import pokebw2_mod
    ids = json.load(open(os.path.join(ROOT, 'data', 'pearl_story_ids.json')))
    index = json.load(open(os.path.join(TRAINERS, 'index.json')))
    reg = class_registry()
    b2_classes, b2_trainers = b2_constants()
    todo = wanted(ids)
    msgs = pearl_messages()
    tree = pokebw2_mod.make_tree('pearl_trainers')
    data_dir = os.path.join(tree, 'res', 'trainers', 'data')
    done, used_classes = [], set()
    for t in todo:
        b2 = ids['trainers'][str(t)]['b2']
        pc = index[str(t)]['pearl_class']
        d = json.load(open(os.path.join(TRAINERS, 'data', f'{t:03d}.json')))
        cls = reg['classes'][pc]['b2'] if pc in reg['classes'] else b2_classes.index('TRAINER_CLASS_' + index[str(t)]['b2_class'])
        used_classes.add(pc)
        d['class'] = b2_classes[cls]
        if pc == 'PKMN_TRAINER_BARRY':
            d['name'] = 'Barry'           # (Black 2 shows the save's rival name for this class)
        d['messages'] = b2_messages(msgs.get(t, []))
        const = b2_trainers[b2]
        json.dump(d, open(os.path.join(data_dir, const[8:].lower() + '.json'), 'w', encoding='utf-8'),
                  ensure_ascii=False, indent=4)
        done.append(f'{t}->{b2}')
    # the message order lists Black 2 trainers with messages: keep only those that still have some
    order_path = os.path.join(data_dir, 'message_order.json')
    order = json.load(open(order_path))
    keep = [n for n in order
            if json.load(open(os.path.join(data_dir, n[8:].lower() + '.json'))).get('messages')]
    json.dump(keep, open(order_path, 'w'), indent=4)
    # class names
    cdir = os.path.join(tree, 'res', 'trainers', 'classes')
    for pc, e in reg['classes'].items():
        if 'name' in e:
            p = os.path.join(cdir, b2_classes[e['b2']][14:].lower() + '.json')
            c = json.load(open(p, encoding='utf-8'))
            c['name'], c['name_with_article'] = e['name'], e['name_with_article']
            json.dump(c, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=4)
    with tempfile.TemporaryDirectory(dir=tree) as out:
        outs = [os.path.join(out, n) for n in ('91', '92', '89', '90')]
        _run(tree, ['tools/data/trainer_data.py', 'pack', 'res/trainers/data', *outs])
        for n, o in zip((91, 92, 89, 90), outs):
            path = os.path.join(files, 'a', '0', str(n // 10), str(n % 10))
            if os.path.islink(path):
                os.unlink(path)
            shutil.copyfile(o, path + '.tmp'); os.replace(path + '.tmp', path)
    text = pokebw2_mod.pack_text(tree, 'system')['a/0/0/2']
    sys.path.insert(0, DECOMP)
    from tools.data.narc import read_narc, write_narc
    mine = read_narc(text)
    cur = read_narc(open(os.path.join(files, 'a', '0', '0', '2'), 'rb').read())
    vanilla = read_narc(pokebw2_mod.vanilla('a/0/0/2'))
    for n in TEXT_FILES:
        assert cur[n] == vanilla[n], f'a/0/0/2 file {n} was changed by another patch'
        cur[n] = mine[n]
    path = os.path.join(files, 'a', '0', '0', '2')
    if os.path.islink(path):
        os.unlink(path)
    open(path + '.tmp', 'wb').write(write_narc(cur)); os.replace(path + '.tmp', path)
    json.dump(reg, open(REGISTRY, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    return (f'pearl_trainers: {len(done)} trainers ({", ".join(done)}); classes {sorted(used_classes)}; '
            f'{len(keep)} trainers with messages; system text {TEXT_FILES}')


def apply_code(code):
    reg = class_registry()
    path = os.path.join(code, 'arm9.bin')
    data = bytearray(open(path, 'rb').read())
    n = 0
    entries = {data[SPECIAL_CLASSES - ARM9_BASE + 3 * e]: e for e in range(29)}
    special = {}
    for pc, e in reg['classes'].items():
        o = CLASS_RESOURCES - ARM9_BASE + 4 * e['b2']
        data[o], data[o + 1] = e['sprite'], e['sex']
        if 'eye_bgm' in e:
            struct.pack_into('<H', data, o + 2, e['eye_bgm'])
        n += 1
        if 'special' in e:
            entry = entries[e['b2']]
            special[entry] = e['special']
            if 'bgm_group' in e['special']:
                data[SPECIAL_CLASSES - ARM9_BASE + 3 * entry + 1] = e['special']['bgm_group']
    if os.path.islink(path):
        os.unlink(path)
    open(path, 'wb').write(data)
    path = os.path.join(code, 'arm9_ov036.bin')
    ov = bytearray(open(path, 'rb').read())
    for entry, s in special.items():
        ov[SPECIAL_ENCEFF - OV036_BASE + entry] = s['enceff']
    seq = sound_ids()
    for g, name in reg['group_bgm'].items():
        struct.pack_into('<H', ov, SPECIAL_BGM - OV036_BASE + 2 * int(g), seq[name])
    if os.path.islink(path):
        os.unlink(path)
    open(path, 'wb').write(ov)
    return (f'pearl_trainers: {n} classes (sprite, sex, eye music), {len(special)} special classes (encounter effect '
            f'{PLAIN_ENCEFF}), group music {reg["group_bgm"]}')


def sound_ids():
    h = os.path.join(DECOMP, 'build', 'include', 'generated', 'constants', 'sound.h')
    return {m.group(1): int(m.group(2), 0) for m in re.finditer(r'#define (SEQ_\w+) (0x[0-9a-f]+|\d+)', open(h).read())}


if __name__ == '__main__' and sys.argv[1:] == ['--classes']:
    reg = class_registry()
    json.dump(reg, open(REGISTRY, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f'{len(reg["classes"])} classes -> {REGISTRY}')
