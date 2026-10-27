"""Pearl's flags, vars and trainers -> Black 2 saved flags, event works and trainer ids (notes/STORY.md "Ids").

    python3 pearl_ids.py [--names PEARL_IDS.json]    (re)allocate data/pearl_story_ids.json, write src/include/pearl.h

Every flag and var any Pearl script, level script or map event uses (scanned from the dump, as pearl_story reads it)
gets a Black 2 id here, once: an id already in data/pearl_story_ids.json is kept (the file is the registry), new ones
take the next free id. --names: the research file with Platinum's names for Pearl's ids (checked by number), copied
into the registry as comments.

Rules (Black 2 side: pokebw2 + HoennB2's survey of every flag/work Black 2's code and scripts touch, rechecked
2026-10-18; Pearl side: pokediamond):
- Pearl map-local flags 1-0x3F (cleared on every map change) keep their number (Black 2 clears 0-0x63 on every zone
  init), except 1 (Black 2's global 2260 sets it) -> 0x50.
- Pearl saved flags 0x40-729 (story and hide flags), and the system flags with no Black 2 equivalent, take Black 2's
  free saved flags (FREE_FLAGS) in Pearl's order. Pearl's game-clear flag 0x964 is Black 2's 2400.
- Pearl hidden-item flags 730 + n -> Black 2's 2820 + n (its hidden-item flags; n >= 213 -> 3033 + n - 213, kept out of
  the free list for that), item-ball flags 986 + n -> 1100 + n (Black 2's item-ball flags 1100-1499), daily flags
  2720 + n -> Black 2's free midnight flags (2744-2793: Black 2 clears 2720-2819 at midnight).
- Pearl trainer flags 1360 + id: by the trainer's Black 2 id (Black 2: 1520 + id), through TrainerFlag commands.
- Vars: Pearl's map-local 0x4000-0x401F -> Black 2 0x4010-0x401E (cleared on map change; Black 2 itself writes
  0x4000-0x400F), dynamic sprites 0x4020-0x402F the same works (Black 2's object codes 162-177 read them), the others
  Black 2's free works (FREE_WORKS). Script vars 0x8000-0x800C -> 0x8020-0x802C (kept across Black 2's global calls),
  0x800D (the talked-to object) -> 0x8011 (Black 2's).
- Trainers: Pearl's battled and partner trainers (work/pearl/b2_trainers/index.json) in Pearl's id order -> Black 2
  ids 1-813 without the ones Black 2 resets or reads (TRAINER_NEVER).
- New ids Pearl keeps elsewhere: PVAR_STARTER (Pearl's save field for the starter species). New ids Pearl NDS needs
  for its own features: NEW_VARS (works), NEW_FLAGS (saved flags), NEW_DAILY_FLAGS (flags Black 2 clears at
  midnight) and NEW_ITEM_BALL_FLAGS (item balls' flags: Black 2's item-ball flags after Pearl's), the last three in
  the registry's "new_flags".
"""
import collections, json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
REGISTRY = os.path.join(ROOT, 'data', 'pearl_story_ids.json')
HEADER = os.path.join(ROOT, 'src', 'include', 'pearl.h')

# Black 2's free saved flags and works (HoennB2 data/story_ids.json "free", rechecked against pokebw2 2026-10-18;
# 3033-3048 left out for Pearl's hidden items 213-228)
FREE_FLAGS = [(102, 104), (107, 122), (125, 130), (133, 135), (139, 140), (142, 145), (200, 213), (216, 224), (228, 232),
              (235, 245), (248, 248), (250, 250), (254, 256), (258, 264), (268, 271), (277, 300), (302, 302), (304, 324),
              (329, 329), (331, 331), (333, 347), (352, 352), (355, 355), (357, 357), (361, 368), (375, 378), (381, 395),
              (404, 416), (418, 419), (421, 443), (445, 457), (459, 459), (461, 474), (476, 479), (481, 483), (485, 490),
              (492, 603), (606, 606), (608, 612), (616, 620), (622, 626), (632, 643), (646, 653), (655, 659), (661, 666),
              (668, 678), (680, 682), (684, 685), (687, 690), (696, 696), (698, 700), (703, 709), (711, 711), (713, 715),
              (719, 720), (725, 726), (728, 729), (732, 732), (738, 738), (742, 742), (744, 745), (747, 748), (750, 750),
              (752, 752), (755, 755), (757, 757), (759, 760), (763, 766), (776, 781), (783, 783), (786, 791), (793, 793),
              (799, 799), (803, 804), (806, 807), (812, 813), (815, 820), (827, 827), (829, 831), (835, 838), (840, 841),
              (844, 847), (849, 849), (852, 852), (858, 858), (867, 870), (874, 877), (879, 879), (881, 881), (884, 885),
              (887, 887), (899, 899), (901, 903), (905, 911), (943, 943), (947, 949), (952, 952), (954, 954), (956, 956),
              (958, 959), (961, 962), (966, 967), (987, 988), (990, 990), (997, 1000), (1002, 1002), (1005, 1006),
              (1012, 1013), (1015, 1015), (1024, 1027), (1036, 1036), (1038, 1040), (1051, 1099), (1500, 1519),
              (2334, 2399), (2412, 2412), (2422, 2428), (2432, 2436), (2443, 2443), (2446, 2446), (2467, 2468),
              (2561, 2639), (2688, 2719), (3049, 3063)]
FREE_WORKS = [(0x403B, 0x4040), (0x4042, 0x4042), (0x404E, 0x4072), (0x4075, 0x4077), (0x4079, 0x4084), (0x4086, 0x4089),
              (0x408B, 0x408C), (0x408E, 0x4093), (0x4097, 0x4097), (0x4099, 0x409D), (0x409F, 0x409F), (0x40A1, 0x40A4),
              (0x40A6, 0x40A7), (0x40A9, 0x40AA), (0x40AC, 0x40B6), (0x40B8, 0x40C3), (0x40C5, 0x40C5), (0x40C7, 0x40CE),
              (0x40D2, 0x40E0), (0x40E2, 0x40E3), (0x40ED, 0x4109), (0x410D, 0x410F), (0x4112, 0x4115), (0x411A, 0x411A),
              (0x411D, 0x4122), (0x4124, 0x4125), (0x4136, 0x4139), (0x413B, 0x413B), (0x413D, 0x4143), (0x4145, 0x4148),
              (0x414F, 0x4161), (0x4163, 0x4164), (0x4166, 0x4173), (0x4175, 0x4175), (0x4177, 0x4177), (0x417B, 0x417E),
              (0x4180, 0x4180), (0x4182, 0x4187), (0x418A, 0x418F), (0x4193, 0x4194), (0x4196, 0x41AE)]
DAILY_FLAGS = [(2744, 2772), (2774, 2777), (2779, 2793)]
TRAINER_NEVER = ({95, 96, 183, 184, 185, 186, 296, 299, 302, 303, 333, 752} | set(range(381, 386))
                 | {i for a, b in ((1, 3), (7, 9), (13, 15), (17, 18), (20, 30), (48, 132), (227, 251))
                    for i in range(a, b + 1)})
# Partner trainers that work/pearl/b2_trainers/index.json files as 'variant' (same class and name as a battled one),
# so the rule below would skip them: Barry's three Spear Pillar teams (by the player's starter, set in a Call'd
# subroutine before Pearl's StartTagBattle 0x8004, Mars 528, Jupiter 407: file 230 P230_09B0) (2026-10-26, chapter 7)
PARTNER_VARIANTS = {607: "Barry's Spear Pillar partner (the player chose Piplup)",
                    619: "Barry's Spear Pillar partner (the player chose Turtwig)",
                    620: "Barry's Spear Pillar partner (the player chose Chimchar)"}
SYSTEM_SAME = {0x964: 2400,            # Pearl FLAG_GAME_COMPLETED -> Black 2's game clear
               0x9BA: 2480}            # Pearl's first arrival in Eterna (pokediamond UNK_020F2224: the fly entry of map
# 0x41 MAP_ETERNA sets 0x9B0 + 10 on arrival, in code) -> Black 2's arrival flag of the entry patches/sinnoh_respawn
# gives Eterna (entry 9, RESPAWN_ZONE_INFO[8] 0x9B0 = 2480, discover on visit): Rowan's National Pokédex scene and
# his PC rating's "come to my lab" check it; nothing set the free flag it had (902). 2026-10-26, chapter 9a.
LOCAL_FLAG_MOVE = {1: 0x50}
NEW_VARS = {                           # new saved works Pearl NDS needs: name -> why
    'PVAR_STARTER': 'Pearl keeps the starter species in its save (pokediamond GetStarter); written when the starter '
                    'is given',
    'PVAR_PC_TOWN': 'the Pokémon Center 1F the player came up from (its Black 2 zone), so the one shared 2F sends '
                    'the player back down there (patches/pearl_centers.py, notes/LINK.md)',
    'PVAR_FOLLOWER_SLOT': 'the party slot of the Pokémon that follows the player (written by the follower module, '
                          'include/follower.h; its talk script, global 10017, names that Pokémon and plays its cry)',
    **{f'PVAR_HABITAT_VISITED_{i}': f'the Pokédex HABITAT list\'s visited places {16 * i}-{16 * i + 15} (one bit each, set '
                                    f'on entering a zone of the place: patches/sinnoh_pokedex.py; HoennB2\'s '
                                    f'VAR_HABITAT_VISITED_{i})' for i in range(4)},    **{f'PVAR_UG_RETURN_{c}': f'the Grand Underground: where the player went down (the zone and the tile {c}; the '
                              f'Explorer Kit\'s "go up" returns there, as Pearl\'s saved location; '
                              f'src/pearlb2/underground_itcm.c, notes/UNDERGROUND.md)' for c in ('ZONE', 'X', 'Y', 'Z')},
    'PVAR_UG_HIDEAWAY_BATTLES': 'the Grand Underground: wild battles in the Hideaways (counted by src/pearlb2/'
                                'underground_itcm.c, to 0xFFFF): Pearl\'s Spiritomb counter (GetSpiritombTalkCounter, '
                                'the Hallowed Tower: 32), which counts people talked to in the multiplayer Underground '
                                '(the lead 2026-10-26: 32 Hideaway battles instead)',
    'PVAR_DELIVERY': 'the Pokémart deliveryman\'s gifts given, 0-4, in order: Member Card, Oak\'s Letter, Azure Flute, '
                     'Manaphy Egg (Pearl\'s Mystery Gift events built in, after the Hall of Fame: pearl_story '
                     '"The deliveryman"; chapter 9a, 2026-10-26)',
    # Pearl's save keeps the Trophy Garden's two daily Pokémon (pokeplatinum special_encounter.c trophyGarden.slot1/2:
    # indexes into encdata_ex 8); here the species themselves (chapter 9b, the lead 2026-10-26)
    **{f'PVAR_TROPHY_GARDEN_{i}': f'the Trophy Garden\'s daily Pokémon, slot {i} (a species, 0 = none): Mr. Backlot\'s '
                                  f'AddTrophyGardenMon writes {"it" if i == 1 else "the old slot 1 here"} (pearl_story.inc '
                                  f'pl_AddTrophyGardenMon); the wild code puts slots 1 and 2 on grass slots 6 and 7 '
                                  f'with the National Pokédex' for i in (1, 2)},
}
NEW_FLAGS = {                          # new saved flags Pearl NDS needs: name -> why (from FREE_FLAGS, after Pearl's)
    'PFLAG_EXP_SHARE_OFF': 'the Exp. Share switched off in the Bag (patches/exp_share.py): clear = on, so the Exp. '
                           'Share works as soon as it is received (PFLAG_010B), as Gen 6 gives it',
    # Ramanas Park in Pal Park (data/ramanas_park.json, b2tools/ramanas.py; the lead 2026-10-26): a flag per
    # Pokémon caught at a pedestal (the rooms' unlocks and the clerk's stock are computed from them), Shining Pearl's
    # 13, then the Distortion Room's Giratina beaten, the clerk's first talk, and Brilliant Diamond's 4 (reserved for
    # the Diamond version: Raikou, Entei, Suicune, Ho-Oh)
    **{f'PFLAG_RP_CAUGHT_{n}': f'Ramanas Park: {n.replace("_", "-").title()} caught at its pedestal'
       for n in ('REGIROCK', 'REGICE', 'REGISTEEL', 'ARTICUNO', 'ZAPDOS', 'MOLTRES', 'LATIAS', 'LATIOS', 'LUGIA',
                 'KYOGRE', 'GROUDON', 'RAYQUAZA', 'MEWTWO')},
    'PFLAG_RP_DISTORTION_WON': 'Ramanas Park: the Distortion Room\'s Origin Forme Giratina beaten (the Griseous Orb given)',
    'PFLAG_RP_CLERK_MET': 'Ramanas Park: the slate clerk\'s first talk heard',
    **{f'PFLAG_RP_CAUGHT_{n}': f'Ramanas Park (Diamond version, reserved): {n.replace("_", "-").title()} caught'
       for n in ('RAIKOU', 'ENTEI', 'SUICUNE', 'HO_OH')},
    'PFLAG_POKE_FOLLOWER': "Rowan's following-Pokémon question (patches/pearl_intro.py, followers.py): set = the first Pokémon in "
                           "the party walks behind the player everywhere; clear (old saves, NO) = no follower",
}
NEW_DAILY_FLAGS = {                    # new flags cleared at midnight (from DAILY_FLAGS, after Pearl's daily flags)
    'PFLAG_NEWS_PRESS_TODAY': 'the Solaceon News Press assignment was given today (pearl_story SetNewsPressDeadline / '
                              'GetNewsPressDeadline: Pearl counts its own deadline days in its save; "bring it today, '
                              'before the date rolls over"; chapter 4b, 2026-10-25)',    **{f'PFLAG_UG_SHARD_{i}': f'the Grand Underground: daily item ball {i} (a Mysterious Shard, from becoming Champion; '
                              f'data/underground.json "shards", patches/underground.py)' for i in range(4)},
    **{f'PFLAG_UG_FOSSIL_{i}': f'the Grand Underground: daily item ball {i} (a Kanto or Hoenn fossil, from becoming '
                               f'Champion; data/underground.json "fossil", patches/underground.py)' for i in range(2)},
}
UG_ITEM_BALLS = 38                     # the Grand Underground Hideaways' item balls (BDSP's, data/underground.json)
NEW_ITEM_BALL_FLAGS = {                # new item balls' flags: Black 2's item-ball flags (1100-1499), after Pearl's
    **{f'PFLAG_UG_ITEM_{i:02d}': f'the Grand Underground: item ball {i} (data/underground.json "items", '
                                 f'patches/underground.py)' for i in range(UG_ITEM_BALLS)},
}
ITEM_BALL_FLAGS = (1100, 1499)
RESERVED_WORKS = {}                   # works held for a tree not merged yet (empty: 9a's 0x40EF is merged)


def expand(ranges):
    return [i for a, b in ranges for i in range(a, b + 1)]


def scan():
    """(flags {id: [kinds]}, vars {id: [kinds]}) over every Pearl script, level script and event file."""
    import gen4_script
    from gen4rom import Rom, narc_members
    files = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read('fielddata/script/scr_seq_release.narc'))
    table = gen4_script.load_table()
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    level = {z['level_scripts'] for z in zones}
    scripts = {z['scripts'] for z in zones}
    flags, vars_ = collections.defaultdict(set), collections.defaultdict(set)
    for i, data in enumerate(files):
        if not data:
            continue
        if i in level or (i not in scripts and not gen4_script.level_script(data)[1]):
            p = 0
            while p < len(data) and data[p]:
                t, v = data[p], struct.unpack_from('<i', data, p + 1)[0]
                if t == 1:
                    q = p + 5 + v
                    while struct.unpack_from('<H', data, q)[0]:
                        vars_[struct.unpack_from('<H', data, q)[0]].add('level script')
                        q += 6
                p += 5
            continue
        d = gen4_script.Disasm(data, table)
        for a, (end, op, args) in d.insns.items():
            name = table[op]['name']
            if name in ('SetFlag', 'ClearFlag', 'CheckFlag'):
                flags[args[0][1]].add('script')
            for ty, v in args:
                if ty == 'var' and v >= 0x4000:
                    vars_[v].add('script')
    for p in sorted(os.listdir(os.path.join(ROOT, 'work', 'pearl', 'events'))):
        e = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'events', p)))
        for o in e['object_events']:
            if o['hidden_flag']:
                flags[o['hidden_flag']].add('object')
            if 101 <= o['graphics_id'] <= 116:
                vars_[0x4020 + o['graphics_id'] - 101].add('object sprite')
        for b in e['bg_events']:
            if 8000 <= b['script'] < 8800:
                flags[730 + b['script'] - 8000].add('hidden item')
        for c in e['coord_events']:
            vars_[c['var']].add('trigger')
    return flags, vars_


def flag_kind(f):
    if f < 0x40:
        return 'map-local'
    if f < 730:
        return 'saved'
    if f < 986:
        return 'hidden item'
    if f < 1360:
        return 'item ball'
    if f < 2400:
        return 'trainer'
    if f < 2720:
        return 'system'
    if f < 2800:
        return 'daily'
    return 'other'


def var_kind(v):
    if v >= 0x8000:
        return 'script'
    if v < 0x4020:
        return 'map-local'
    if v < 0x4030:
        return 'dynamic sprite'
    return 'saved'


def allocate(names=None):
    reg = json.load(open(REGISTRY)) if os.path.exists(REGISTRY) else {}
    flags, vars_ = scan()
    rf, rv, rt, rn, rnf = (reg.get(k, {}) for k in ('flags', 'vars', 'trainers', 'new', 'new_flags'))
    used_f = {e['b2'] for e in rf.values()} | {e['b2'] for e in rnf.values()}
    used_w = {int(e['b2'], 16) for e in rv.values()} | {int(e['b2'], 16) for e in rn.values()}
    free_f = [f for f in expand(FREE_FLAGS) if f not in used_f]
    free_w = [w for w in expand(FREE_WORKS) if w not in used_w and w not in RESERVED_WORKS]
    free_d = [f for f in expand(DAILY_FLAGS) if f not in used_f]
    pnames = (names or {}).get('flags', {}), (names or {}).get('vars', {})

    def pname(table, k):
        e = table.get(k) or {}
        n = (e.get('names') or {}).get('platinum') or []
        return n[0]['name'] if n and n[0].get('rank', 9) <= 3 else None
    for f, b2 in SYSTEM_SAME.items():           # a system flag given its Black 2 equivalent after it had a free one
        k = f'0x{f:04X}'
        if k in rf and rf[k]['b2'] != b2:
            rf[k]['b2'] = b2
    used_f = {e['b2'] for e in rf.values()} | {e['b2'] for e in rnf.values()}
    free_f = [f for f in expand(FREE_FLAGS) if f not in used_f]
    for f in sorted(flags):
        k = f'0x{f:04X}'
        if k in rf:
            continue
        kind = flag_kind(f)
        if kind == 'map-local':
            b2 = LOCAL_FLAG_MOVE.get(f, f)
        elif kind == 'hidden item':
            n = f - 730
            b2 = 2820 + n if n < 213 else 3033 + n - 213
        elif kind == 'item ball':
            b2 = 1100 + f - 986
        elif kind == 'daily':
            b2 = free_d.pop(0)
        elif f in SYSTEM_SAME:
            b2 = SYSTEM_SAME[f]
        elif kind == 'trainer':
            continue                                    # through the trainer's id (TrainerFlag commands)
        else:
            b2 = free_f.pop(0)
        rf[k] = dict(b2=b2, kind=kind, uses=sorted(flags[f]))
        if pname(pnames[0], k):
            rf[k]['name'] = pname(pnames[0], k)
    local_vars = sorted(v for v in vars_ if v < 0x4020)
    for v in sorted(vars_):
        k = f'0x{v:04X}'
        if k in rv or v >= 0x8000:
            continue
        kind = var_kind(v)
        if kind == 'map-local':
            b2 = 0x4010 + local_vars.index(v)
            assert b2 <= 0x401E, 'more Pearl map-local vars than Black 2 0x4010-0x401E'
        elif kind == 'dynamic sprite':
            b2 = v
        else:
            b2 = free_w.pop(0)
        rv[k] = dict(b2=f'0x{b2:04X}', kind=kind, uses=sorted(vars_[v]))
        if pname(pnames[1], k):
            rv[k]['name'] = pname(pnames[1], k)
    for n, why in NEW_VARS.items():
        if n not in rn:
            rn[n] = dict(b2=f'0x{free_w.pop(0):04X}', why=why)
    for n, why in NEW_FLAGS.items():
        if n not in rnf:
            rnf[n] = dict(b2=free_f.pop(0), why=why)
    for n, why in NEW_DAILY_FLAGS.items():
        if n not in rnf:
            rnf[n] = dict(b2=free_d.pop(0), why=why)
    free_i = [f for f in range(ITEM_BALL_FLAGS[0], ITEM_BALL_FLAGS[1] + 1)
              if f > max([e['b2'] for e in rf.values() if e['kind'] == 'item ball'] + [ITEM_BALL_FLAGS[0] - 1])
              and f not in used_f and f not in {e['b2'] for e in rnf.values()}]
    for n, why in NEW_ITEM_BALL_FLAGS.items():
        if n not in rnf:
            rnf[n] = dict(b2=free_i.pop(0), why=why)
    # trainers
    index = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'b2_trainers', 'index.json')))
    pool = [i for i in range(1, 814) if i not in TRAINER_NEVER and i not in {e['b2'] for e in rt.values()}]
    for tid in sorted(index, key=int):
        e = index[tid]
        if tid in rt or (e['category'] not in ('battled', 'other') and int(tid) not in PARTNER_VARIANTS):
            continue
        rt[tid] = dict(b2=pool.pop(0), name=e['name'], pearl_class=e['pearl_class'], b2_class=e['b2_class'])
    reg = {'_doc': 'Pearl flag/var/trainer -> Black 2 id registry, written by b2tools/pearl_ids.py (rules in its '
                   'docstring; notes/STORY.md "Ids"). An id once given is kept: edit only by rerunning the tool.',
           'flags': dict(sorted(rf.items())), 'vars': dict(sorted(rv.items())), 'new': rn, 'new_flags': rnf,
           'trainers': dict(sorted(rt.items(), key=lambda kv: int(kv[0]))),
           'free_left': {'flags': len(free_f), 'works': len(free_w), 'daily_flags': len(free_d),
                         'trainer_ids': len(pool)}}
    json.dump(reg, open(REGISTRY, 'w'), indent=1)
    write_header(reg)
    return reg


def write_header(reg):
    out = ['// Pearl flags, vars and trainers as Black 2 ids. Generated by b2tools/pearl_ids.py from',
           '// data/pearl_story_ids.json: do not edit. PFLAG_xxxx / PVAR_xxxx = Pearl flag/var 0xxxxx,',
           '// PTRAINER_n = Pearl trainer n (its Black 2 trainer id).', '#ifndef PEARL_H', '#define PEARL_H', '']
    for k, e in reg['flags'].items():
        out.append(f'#define PFLAG_{k[2:]} {e["b2"]}'.ljust(32) + f'// {e["kind"]}' + (f': {e["name"]}' if e.get('name') else ''))
    out.append('')
    for k, e in reg['vars'].items():
        out.append(f'#define PVAR_{k[2:]} {e["b2"]}'.ljust(32) + f'// {e["kind"]}' + (f': {e["name"]}' if e.get('name') else ''))
    out.append('// script vars (Pearl 0x8000-0x800C -> 0x8020-0x802C; 0x800D the talked-to object -> Black 2 0x8011)')
    for v in range(0x8000, 0x800D):
        out.append(f'#define PVAR_{v:04X} 0x{v + 0x20:04X}')
    out.append('#define PVAR_800D 0x8011')
    for n, e in reg['new'].items():
        out.append(f'#define {n} {e["b2"]}'.ljust(32) + f'// {e["why"][:90]}')
    for n, e in reg.get('new_flags', {}).items():
        out.append(f'#define {n} {e["b2"]}'.ljust(31) + f' // {e["why"][:90]}')
    out.append('')
    for k, e in reg['trainers'].items():
        out.append(f'#define PTRAINER_{k} {e["b2"]}'.ljust(32) + f'// {e["pearl_class"]} {e["name"]}')
    out += ['', '#endif', '']
    open(HEADER, 'w').write('\n'.join(out))


class Ids:
    """The registry as names for the translator (pearl_story) and numbers for the events (pearl_events)."""

    def __init__(self):
        self.reg = json.load(open(REGISTRY))

    def flag(self, f):
        k = f'0x{f:04X}'
        if k in self.reg['flags']:
            return f'PFLAG_{k[2:]}'
        if 1360 < f < 2400:                             # a trainer's defeat flag by number
            return f'(1520 + {self.trainer(f - 1360)})'
        raise KeyError(f'Pearl flag {k} has no Black 2 id (rerun b2tools/pearl_ids.py)')

    def flag_value(self, f):
        k = f'0x{f:04X}'
        if k in self.reg['flags']:
            return self.reg['flags'][k]['b2']
        raise KeyError(f'Pearl flag {k} has no Black 2 id')

    def var(self, v):
        k = f'0x{v:04X}'
        if k in self.reg['vars']:
            return f'PVAR_{k[2:]}'
        raise KeyError(f'Pearl var {k} has no Black 2 work (rerun b2tools/pearl_ids.py)')

    def var_value(self, v):
        if v >= 0x8000:
            return 0x8011 if v == 0x800D else v + 0x20
        return int(self.reg['vars'][f'0x{v:04X}']['b2'], 16)

    def local(self, v):
        if v > 0x800D:
            raise KeyError(f'Pearl script var 0x{v:04X} is outside 0x8000-0x800D')
        return f'PVAR_{v:04X}'

    def trainer(self, t):
        if str(t) not in self.reg['trainers']:
            raise KeyError(f'Pearl trainer {t} has no Black 2 id (not a battled trainer in work/pearl/b2_trainers)')
        return f'PTRAINER_{t}'

    def trainer_value(self, t):
        return self.reg['trainers'][str(t)]['b2']


if __name__ == '__main__':
    names = None
    if '--names' in sys.argv:
        names = json.load(open(sys.argv[sys.argv.index('--names') + 1]))
    reg = allocate(names)
    print(f'data/pearl_story_ids.json: {len(reg["flags"])} flags, {len(reg["vars"])} vars, {len(reg["trainers"])} '
          f'trainers; free left: {reg["free_left"]}; wrote src/include/pearl.h')
