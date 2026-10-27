"""Pearl's 850 trainers as Black 2 trainer records (prepared for the story phase, NOT installed; notes/TRAINERS.md).

    python3 b2tools/sinnoh_trainers.py [--b2-moves]      writes work/pearl/b2_trainers/

Input: work/pearl/trainers.json (b2tools/gen4_trainers.py: Pearl's trdata/trpoke, pokediamond names), names from
pokediamond files/poketool/trainer/trdata.json, Pearl's level-up learnsets (poketool/personal/wotbl.narc) and class
prize table from the dump (roms/pearl.nds), Pearl's events and scripts (work/pearl/events, scripts) to sort trainers.

Black 2's format (pokebw2 tools/data/trainer_data.py, include/battle/trainer_data.h, src/system/tr_tool.c):
a/0/9/1 entry N = 20-byte record (party kind, class, battle style, count, 4 items, AI flags, heals, money, reward),
a/0/9/2 entry N = party (difficulty, sex|ability, level, species, form [, item] [, 4 moves]).

Conversion (Pearl -> Black 2):
- Party kind: Pearl's type is the same bit set (1 moves, 2 item). Pearl Pokémon without moves get **Pearl's own
  default moves** written out (the last four level-up moves at their level, pokediamond pokemon.c InitBoxMonMoveset,
  from Pearl's learnsets), so the movesets are Pearl's and not Black 2's Gen 5 learnsets (--b2-moves leaves them
  empty instead). Species, moves and items keep their numbers (the same in both games for everything Pearl has);
  names are Black 2's constants (pokebw2 build/include/generated/constants).
- Difficulty (0-255 = IVs 0-31) and level: Pearl's. Sex/ability: 0 = the game picks (Pearl has no such field).
- Battle style: Pearl's double flag -> BTL_STYLE_DOUBLE. Items: Pearl's (Full Restore, Hyper/Super Potion, Potion).
- AI: Pearl's bit 0 (basic, 846 trainers; 4 have none) -> AI_FLAG_BASIC (bit 0 in both games). No other Pearl flag
  is used. Black 2's own trainers mostly add EVAL_ATTACK + EXPERT: an open question, not done here.
- Money: Pearl pays class multiplier x 4 x last level, x2 in a double battle (pokeplatinum battle_script.c
  BattleScript_CalcPrizeMoney; table read from the Pearl dump); Black 2 pays money x 4 x last level per trainer
  (pokebw2 src/ov167/btl_calc.c), so money = Pearl's multiplier, x2 for double battles: the same prize.
- Class: CLASS_MAP below: Black 2's class for the same role where one exists; otherwise a stand-in Black 2 class
  with the nearest picture, marked "stand-in" (the class needs a spare Black 2 class with a new name and picture
  in the story phase, as HoennB2 did).
- Heals false, reward ITEM_NONE, messages empty (Pearl's trainer texts come with the story phase).

Writes work/pearl/b2_trainers/: data/NNN.json (pokebw2 res/trainers/data format, Pearl id NNN), trdata.narc and
trpoke.narc (a/0/9/1 and a/0/9/2 layouts, entry = Pearl id, packed with pokebw2's own trainer_bytes), index.json
(per trainer: name, category, classes, stand-in, money) and report.txt.
"""
import collections, glob, json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from gen4rom import Rom, narc_members  # noqa: E402
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
sys.path.insert(0, DECOMP)
from tools.data.trainer_data import trainer_bytes, NONE_TRAINER, NONE_PARTY  # noqa: E402
from tools.data.narc import write_narc  # noqa: E402

PEARL = os.path.join(ROOT, 'work', 'pearl')
OUT = os.path.join(PEARL, 'b2_trainers')
DIAMOND_INC = os.path.join(ROOT, 'external', 'pokediamond', 'include', 'constants')
B2_INC = os.path.join(DECOMP, 'build', 'include', 'generated', 'constants')

# Pearl class -> (Black 2 class, how): 'same' = the same class in Black 2; 'leader' = Black 2's PWT class of that
# Sinnoh Gym Leader (Pearl's own picture, Black 2 names the class after the leader); 'near' = a Black 2 class of the
# same role whose picture differs from Pearl's; 'stand-in' = no Black 2 equivalent, nearest picture for now.
CLASS_MAP = {
    'PKMN_TRAINER_M': ('HERO', 'stand-in'), 'PKMN_TRAINER_F': ('HEROINE', 'stand-in'),
    'YOUNGSTER': ('YOUNGSTER', 'same'), 'LASS': ('LASS', 'same'),
    'CAMPER': ('BACKPACKER_M', 'stand-in'), 'PICNICKER': ('BACKPACKER_F', 'stand-in'),
    'BUG_CATCHER': ('SCHOOL_KID_M', 'stand-in'), 'AROMA_LADY': ('NURSERY_AIDE', 'stand-in'),
    'TWINS': ('TWINS', 'same'), 'HIKER': ('HIKER', 'same'), 'BATTLE_GIRL': ('BATTLE_GIRL', 'same'),
    'FISHERMAN': ('FISHERMAN', 'same'), 'CYCLIST_M': ('CYCLIST_M', 'same'), 'CYCLIST_F': ('CYCLIST_F', 'same'),
    'BLACK_BELT': ('BLACK_BELT', 'same'), 'ARTIST': ('ARTIST', 'same'),
    'PKMN_BREEDER_M': ('PKMN_BREEDER_M', 'same'), 'PKMN_BREEDER_F': ('PKMN_BREEDER_F', 'same'),
    'COWGIRL': ('PKMN_RANGER_F', 'stand-in'), 'JOGGER': ('STRIKER', 'stand-in'),
    'POKEFAN_M': ('POKEFAN_M', 'same'), 'POKEFAN_F': ('POKEFAN_F', 'same'),
    'POKE_KID': ('PRESCHOOLER_F', 'stand-in'), 'YOUNG_COUPLE': ('BACKERS_F', 'stand-in'),
    'ACE_TRAINER_M': ('ACE_TRAINER_M', 'same'), 'ACE_TRAINER_F': ('ACE_TRAINER_F', 'same'),
    'WAITRESS': ('WAITRESS', 'same'), 'VETERAN': ('VETERAN_M', 'same'),
    'NINJA_BOY': ('PRESCHOOLER_M', 'stand-in'), 'DRAGON_TAMER': ('ROUGHNECK', 'stand-in'),
    'BIRD_KEEPER': ('PKMN_RANGER_F', 'stand-in'), 'DOUBLE_TEAM': ('ACE_TRAINER_M', 'stand-in'),
    'RICH_BOY': ('RICH_BOY', 'same'), 'LADY': ('LADY', 'same'), 'GENTLEMAN': ('GENTLEMAN', 'same'),
    'SOCIALITE': ('SOCIALITE', 'same'), 'BEAUTY': ('BEAUTY', 'same'), 'COLLECTOR': ('POKEFAN_M', 'stand-in'),
    'POLICEMAN': ('POLICEMAN', 'same'), 'PKMN_RANGER_M': ('PKMN_RANGER_M', 'same'),
    'PKMN_RANGER_F': ('PKMN_RANGER_F', 'same'), 'SCIENTIST': ('SCIENTIST_M_52', 'same'),
    'SWIMMER_M': ('SWIMMER_M', 'same'), 'SWIMMER_F': ('SWIMMER_F', 'same'),
    'TUBER_M': ('PRESCHOOLER_M', 'stand-in'), 'TUBER_F': ('PRESCHOOLER_F', 'stand-in'),
    'SAILOR': ('FISHERMAN', 'stand-in'), 'SIS_AND_BRO': ('TWINS', 'stand-in'),
    'RUIN_MANIAC': ('HIKER', 'stand-in'), 'PSYCHIC_M': ('PSYCHIC_M', 'same'), 'PSYCHIC_F': ('PSYCHIC_F', 'same'),
    'PI': ('GENTLEMAN', 'stand-in'), 'GUITARIST': ('GUITARIST', 'near'),
    'ACE_TRAINER_SNOW_M': ('ACE_TRAINER_M', 'near'), 'ACE_TRAINER_SNOW_F': ('ACE_TRAINER_F', 'near'),
    'SKIER_M': ('BACKPACKER_M', 'stand-in'), 'SKIER_F': ('BACKPACKER_F', 'stand-in'),
    'ROUGHNECK': ('ROUGHNECK', 'same'), 'CLOWN': ('HARLEQUIN_32', 'near'), 'WORKER': ('WORKER_26', 'same'),
    'SCHOOL_KID_M': ('SCHOOL_KID_M', 'same'), 'SCHOOL_KID_F': ('SCHOOL_KID_F', 'same'),
    'LEADER_ROARK': ('ROARK', 'leader'), 'PKMN_TRAINER_BARRY': ('PKMN_TRAINER_RIVAL', 'stand-in'),
    'LEADER_BYRON': ('BYRON', 'leader'),
    'ELITE_FOUR_AARON': ('ELITE_FOUR_MARSHAL', 'stand-in'), 'ELITE_FOUR_BERTHA': ('ELITE_FOUR_CAITLIN', 'stand-in'),
    'ELITE_FOUR_FLINT': ('ELITE_FOUR_GRIMSLEY', 'stand-in'), 'ELITE_FOUR_LUCIEN': ('ELITE_FOUR_SHAUNTAL', 'stand-in'),
    'CHAMPION': ('PKMN_TRAINER_CYNTHIA', 'leader'), 'BELLE__PA': ('BACKERS_M', 'stand-in'),
    'RANCHER': ('PKMN_BREEDER_M', 'stand-in'), 'COMMANDER_MARS': ('TEAM_PLASMA_GRUNT_F', 'stand-in'),
    'GALACTIC': ('TEAM_PLASMA_GRUNT_M', 'stand-in'),
    'LEADER_GARDENIA': ('GARDENIA', 'leader'), 'LEADER_WAKE': ('WAKE', 'leader'),
    'LEADER_MAYLENE': ('MAYLENE', 'leader'), 'LEADER_FANTINA': ('FANTINA', 'leader'),
    'LEADER_CANDICE': ('CANDICE', 'leader'), 'LEADER_VOLKNER': ('VOLKNER', 'leader'),
    'PARASOL_LADY': ('PARASOL_LADY', 'same'), 'WAITER': ('WAITER', 'same'),
    'INTERVIEWERS': ('BACKERS_M', 'stand-in'), 'CAMERAMAN': ('WORKER_44', 'stand-in'),
    'REPORTER': ('CLERK_F', 'stand-in'), 'IDOL': ('SOCIALITE', 'stand-in'),
    'GALACTIC_BOSS': ('TEAM_PLASMA_GHETSIS', 'stand-in'), 'COMMANDER_JUPITER': ('TEAM_PLASMA_GRUNT_F', 'stand-in'),
    'COMMANDER_SATURN': ('TEAM_PLASMA_GRUNT_M', 'stand-in'), 'GALACTIC_F': ('TEAM_PLASMA_GRUNT_F', 'stand-in'),
    'PKMN_TRAINER_CHERYL': ('PKMN_BREEDER_F', 'stand-in'), 'PKMN_TRAINER_RILEY': ('ACE_TRAINER_M', 'stand-in'),
    'PKMN_TRAINER_MARLEY': ('LASS', 'stand-in'), 'PKMN_TRAINER_BUCK': ('ROUGHNECK', 'stand-in'),
    'PKMN_TRAINER_MIRA': ('PRESCHOOLER_F', 'stand-in'), 'PKMN_TRAINER_LUCAS': ('HERO', 'stand-in'),
    'PKMN_TRAINER_DAWN': ('HEROINE', 'stand-in'), 'TOWER_TYCOON': ('GENTLEMAN', 'stand-in'),
}
PLACEHOLDER_NAMES = {'Mickey', 'Angelica', 'Tara & Tim', '-', ''}


def defines(path, prefix):
    """{value: name} and {name: value} of '#define PREFIX_X n' lines (first name per value)."""
    by_value, by_name = {}, {}
    for m in re.finditer(rf'#define\s+({prefix}\w+)\s+(0x[0-9a-fA-F]+|\d+)', open(path, encoding='utf-8').read()):
        v = int(m.group(2), 0)
        by_name[m.group(1)] = v
        by_value.setdefault(v, m.group(1))
    return by_value, by_name


def pearl_learnsets(rom):
    """species -> [(level, move)] from Pearl's wotbl.narc (u16 move | level << 9, 0xFFFF ends)."""
    out = {}
    for sp, d in enumerate(narc_members(rom.read('poketool/personal/wotbl.narc'))):
        rows = []
        for (w,) in struct.iter_unpack('<H', d[:len(d) & ~1]):
            if w == 0xFFFF:
                break
            rows.append((w >> 9, w & 0x1FF))
        out[sp] = rows
    return out


def default_moves(learnset, level):
    """pokediamond InitBoxMonMoveset: each move learned at or below the level, in order; a known move is skipped;
    with four moves the first is dropped."""
    moves = []
    for lv, mv in learnset:
        if lv > level:
            break
        if mv in moves:
            continue
        if len(moves) == 4:
            moves.pop(0)
        moves.append(mv)
    return moves


def prize_table(rom):
    """Pearl's class prize multipliers (the table pokeplatinum names sTrainerClassPrizeMul; found in the dump)."""
    probe = bytes([0, 0, 4, 4, 4, 4, 4, 8, 4, 8, 4, 8, 8, 8, 6, 12, 12, 12])
    at = rom.data.find(probe)
    assert at >= 0 and rom.data.find(probe, at + 1) < 0, 'prize table not found once in the dump'
    return list(rom.data[at:at + 98]), at


def categories(trainers, names):
    """Pearl id -> 'battled' (a trainer NPC: script 3000/5000 + id - 1, or a script's battle command with the id),
    'variant' (same class and name as a battled one: Vs. Seeker tiers, the rival's starter variants),
    'placeholder' (Pearl's unused Mickey/Angelica/Tara & Tim entries), 'other' (partners, Palmer, ...)."""
    ref = set()
    for f in glob.glob(os.path.join(PEARL, 'events', '*.json')):
        for o in json.load(open(f))['object_events']:
            s = o['script']
            if 3000 <= s < 5000: ref.add(s - 2999)
            elif 5000 <= s < 7000: ref.add(s - 4999)
    for f in glob.glob(os.path.join(PEARL, 'scripts', '*.txt')):
        for line in open(f):
            m = re.match(r'\s*(Unk00E5|Unk02A0)\s+(.*?)\s+@', line)
            if m:
                for a in m.group(2).split(','):
                    a = a.strip()
                    if not a.startswith('VAR') and int(a, 0):
                        ref.add(int(a, 0))
    key = lambda i: (trainers[i]['class'], names[i])
    battled_keys = {key(i) for i in ref}
    out = {0: 'none'}
    for i in range(1, len(trainers)):
        out[i] = ('battled' if i in ref else 'placeholder' if names[i] in PLACEHOLDER_NAMES
                  else 'variant' if key(i) in battled_keys else 'other')
    return out


def main():
    keep_b2_moves = '--b2-moves' in sys.argv
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    trainers = json.load(open(os.path.join(PEARL, 'trainers.json')))
    ref = {t['index']: t for t in json.load(open(os.path.join(
        ROOT, 'external', 'pokediamond', 'files', 'poketool', 'trainer', 'trdata.json')))['trdata']}
    names = {i: ref[i]['name'].replace('{TRNAME}', '') for i in ref}
    _, p_species = defines(os.path.join(DIAMOND_INC, 'species.h'), 'SPECIES_')
    _, p_moves = defines(os.path.join(DIAMOND_INC, 'moves.h'), 'MOVE_')
    _, p_items = defines(os.path.join(DIAMOND_INC, 'items.h'), 'ITEM_')
    _, p_classes = defines(os.path.join(DIAMOND_INC, 'trainer_classes.h'), 'TRAINER_CLASS_')
    b_species, _ = defines(os.path.join(B2_INC, 'species.h'), 'SPECIES_')
    b_moves, _ = defines(os.path.join(B2_INC, 'moves.h'), 'MOVE_')
    b_items, _ = defines(os.path.join(B2_INC, 'items.h'), 'ITEM_')
    _, b_classes = defines(os.path.join(B2_INC, 'trainer_classes.h'), 'TRAINER_CLASS_')
    learn = pearl_learnsets(rom)
    prize, prize_at = prize_table(rom)
    cat = categories(trainers, names)
    renamed = collections.Counter()

    def b2_name(kind, pearl_name, p_table, b_table):
        if isinstance(pearl_name, int):
            num = pearl_name
        else:
            num = p_table[pearl_name]
        b = b_table.get(num)
        if b is None:
            raise SystemExit(f'{pearl_name} ({num}) has no Black 2 {kind}')
        if isinstance(pearl_name, str) and b != pearl_name:
            renamed[(pearl_name, b)] += 1
        return b

    os.makedirs(os.path.join(OUT, 'data'), exist_ok=True)
    records, parties, index = [NONE_TRAINER], [NONE_PARTY], {}
    for t in trainers[1:]:
        i = t['index']
        pclass = t['class'].replace('TRAINER_CLASS_', '')
        b2class, how = CLASS_MAP[pclass]
        b2class = 'TRAINER_CLASS_' + b2class
        assert b2class in b_classes, b2class
        double = bool(t['double'])
        party = []
        for m in t['party']:
            mon = {'species': b2_name('species', m['species'], p_species, b_species), 'form': m['form'],
                   'level': m['level'], 'difficulty': m['difficulty'], 'gender': 0, 'ability': 0}
            if 'item' in m:
                mon['item'] = b2_name('item', m['item'], p_items, b_items)
            if 'moves' in m:
                mon['moves'] = [b2_name('move', mv, p_moves, b_moves) for mv in m['moves'] if mv != 'MOVE_NONE']
            elif not keep_b2_moves:
                mon['moves'] = [b_moves[mv] for mv in default_moves(learn[p_species[m['species']]], m['level'])]
            party.append(mon)
        data = {'$schema': 'trainer.schema.json', 'name': names[i], 'class': b2class,
                'battle_style': 'BTL_STYLE_DOUBLE' if double else 'BTL_STYLE_SINGLE',
                'items': [b2_name('item', it, p_items, b_items) for it in t['items']],
                'ai_flags': ['AI_FLAG_BASIC'] if t['ai'] & 1 else [],
                'heals': False, 'money': prize[p_classes[t['class']]] * (2 if double else 1),
                'reward': 'ITEM_NONE', 'party': party, 'messages': []}
        assert not t['ai'] & ~1, f'trainer {i}: AI flags {t["ai"]:#x}'
        rec, par = trainer_bytes(data, f'Pearl trainer {i}')
        records.append(rec); parties.append(par)
        json.dump(data, open(os.path.join(OUT, 'data', f'{i:03d}.json'), 'w'), indent=1, ensure_ascii=False)
        index[i] = {'name': names[i], 'pearl_class': pclass, 'b2_class': b2class[14:], 'class_match': how,
                    'category': cat[i], 'double': double, 'money': data['money'], 'pokemon': len(party),
                    'moves': 'pearl' if any('moves' in m for m in t['party']) else
                             ('pearl default' if not keep_b2_moves else 'black 2 default')}
    open(os.path.join(OUT, 'trdata.narc'), 'wb').write(write_narc(records))
    open(os.path.join(OUT, 'trpoke.narc'), 'wb').write(write_narc(parties))
    json.dump(index, open(os.path.join(OUT, 'index.json'), 'w'), indent=1, ensure_ascii=False)

    # report
    by_cat = collections.Counter(v['category'] for v in index.values())
    lines = [f'{len(index)} Pearl trainers converted (ids 1-{len(index)}; id 0 is the empty record of both games)',
             'categories: ' + ', '.join(f'{k} {v}' for k, v in by_cat.most_common()),
             f'Pearl prize table at ROM 0x{prize_at:x}; party data {sum(len(p) for p in parties)} bytes '
             f'(Black 2\'s a/0/9/2: {os.path.getsize(os.path.join(DECOMP, "build", "b2_us", "files", "a", "0", "9", "2"))} bytes)',
             '', 'class map (Pearl class: trainers [battled] -> Black 2 class, how):']
    cls = collections.defaultdict(lambda: [0, 0])
    for v in index.values():
        cls[(v['pearl_class'], v['b2_class'], v['class_match'])][0] += 1
        cls[(v['pearl_class'], v['b2_class'], v['class_match'])][1] += v['category'] == 'battled'
    for (pc, bc, how), (n, b) in sorted(cls.items(), key=lambda kv: (kv[0][2], kv[0][0])):
        lines.append(f'  {pc}: {n} [{b}] -> {bc} ({how})')
    lines += ['', 'names that differ between pokediamond and Black 2 (same number):']
    lines += [f'  {a} -> {b} ({n})' for (a, b), n in sorted(renamed.items())]
    open(os.path.join(OUT, 'report.txt'), 'w').write('\n'.join(lines) + '\n')
    print('\n'.join(lines[:3]))
    print(f'-> {OUT}')


if __name__ == '__main__':
    main()
