"""The Fairy type (Gen 6 rules) and the physical/special split, HoennB2's fairy_core (2026-10-08) ported to Pearl NDS
(2026-10-18; design, data tables and tests: notes/FAIRY.md, research: notes/FAIRY_SCOPE.md, both HoennB2's). Code:
b2tools/patches/fairy.c, compiled with clang and linked into ITCM by b2tools/itcm.py after the code already there.
List it after every patch that appends to ITCM before it (sinnoh_encounters, sinnoh_music, pearl_rods, pearl_intro):
itcm.install checks the ITCM arena literal. fairy_ui (the screens) runs after it.

Everything that a Pokemon, a move or a link battle carries is HoennB2's, number for number, so Pearl NDS trades and
link-battles the Hoenn games (notes/LINK.md): type 17 = Fairy, 18 = "no type"; Fairy items 113 (Pixie Plate) and 114
(Fairy Gem); Fairy moves 560-565; the options u16 at the start of the trainer-data save block (SaveControl block 27):
bit 11 = Fairy on, bit 12 = classic (Gen 3) split; the link-battle rule sync (fairy.c gLinkRules: the battle's server
machine sends its bits 11-12 in the spare nibble of the pre-battle sync and both machines battle by them).
Pearl differs from HoennB2 in:
  - the questions: Rowan asks them in the intro's farewell script (patches/pearl_intro.py, which also installs intro
    command 31 = Intro_SetConfigBit, src/code/rowan_questions.c): Fairy (bit 11) and music (bit 13). Pearl is a Gen 4
    game, so it never asks about the split: bit 12 stays 0 (a Hoenn host's classic split still applies in a link
    battle, through the sync);
  - no seasons code here: Rowan's seasons question (bit 15, the same meaning as HoennB2's) is patches/season_choice.py;
  - the shop: HoennB2 sells the two items at Lilycove's Dept. Store; Pearl's shop is not chosen yet (SHOP_ID None: no
    shop hook, the items exist but are not sold; proposal: Veilstone Dept. Store's battle-items clerk, pokediamond
    arm9/src/scrcmd_mart.c's X-items list, once the specialty marts are ported);
  - the learnsets: HoennB2's additions as they are (one Fairy data set for both projects; Sinnoh-only additions are
    an open question for the user, notes/FAIRY.md).

Data (apply): a/0/1/6 the 22 Gen 6 retypes, a/0/2/1 Sweet Kiss / Charm / Moonlight -> Fairy and the new moves at
560+, a/0/1/8 level-up and a/1/2/4 egg moves, a/0/2/4 Pixie Plate / Fairy Gem at free item ids. Text (names,
descriptions, battle lines): data/text_overrides_pending/fairy.json (applied by sinnoh_names once it can append lines:
notes/FAIRY.md "Text").

Code (apply_code), every site checked against Black 2's bytes:
  ov167  14 "no type" sentinels 17 -> 18 (SENTINELS; b2tools/fairy_check.py proves the sweep), GetTypeEffectiveness
         and GetTypeWeaknesses -> ITCM (18x18 Gen 6 chart when on, Black 2's own table when off), the classic split
         in ServerEvent_GetMoveParam and the three category reads of the damage calculation, the new moves' animation
         (donor ids), Metronome's move count, ItemEvent_AddItemCore's item table (moved to ITCM, +2 items), the link
         battles' rule sync (func_ov167_0219ada0's send/receive, the battle proc's init/exit)
  arm9   PML_MoveGetParam (type and category of every move read: UI, AI, battle), PML_PersonalFetchBW2 /
         PML_PersonalLoadBW2 (species types; the one-record cache keyed by the toggle), item icons
Not changed, on purpose: arm9 func_0201f14c and ov055 (PWT) use 17 as "any type" in their own entry-rule data (a
Fairy rule never exists); ov055's simulated-match chart treats 17 as neutral; Hidden Power stays 1-16 (Gen 6: never
Fairy); Arceus keeps its Normal form with the Pixie Plate (no Fairy form art).

Test switch: PEARL_TEST_FAIRY_SELFTEST=1 adds a self-test to the ITCM code (fairy_check.py --emu runs it in a battle
and compares every chart entry, every move's type/category and every species' types in the four toggle states)."""
import os, sys, json, struct, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
VANILLA_FILES = os.path.join(DECOMP, 'build', 'b2_us', 'files')
VANILLA_CODE = os.path.join(DECOMP, 'build', 'b2_us', 'build')
sys.path.insert(0, os.path.dirname(HERE))
import narcio, itcm  # noqa: E402

ARM9 = itcm.ARM9
OV167, OV294 = 0x021998C0, 0x021A1B20       # overlay bases (decomp overlays.yaml)

# ---- types and the chart --------------------------------------------------------------------------------------------
TYPES = ['Normal', 'Fighting', 'Flying', 'Poison', 'Ground', 'Rock', 'Bug', 'Ghost', 'Steel', 'Fire', 'Water', 'Grass',
         'Electric', 'Psychic', 'Ice', 'Dragon', 'Dark', 'Fairy']
T = {n.upper(): i for i, n in enumerate(TYPES)}
FAIRY, NONE = 17, 18
# Gen 6 on top of Black 2's chart (notes/FAIRY_SCOPE.md 3.4): x2 = 4, x0.5 = 2, x0 = 0 (GetTypeEffectiveness codes, 3 = x1)
GEN6_FAIRY_ATTACK = {'FIGHTING': 4, 'DRAGON': 4, 'DARK': 4, 'FIRE': 2, 'POISON': 2, 'STEEL': 2}
GEN6_FAIRY_DEFEND = {'FIGHTING': 2, 'BUG': 2, 'DARK': 2, 'DRAGON': 0, 'POISON': 4, 'STEEL': 4}
GEN6_STEEL_DEFEND = {'GHOST': 3, 'DARK': 3}                 # Gen 6: no longer resisted by Steel
CODE = {0: 0, 2: 2, 4: 3, 8: 4}                              # Black 2's halves -> GetTypeEffectiveness codes

def vanilla_chart():
    d = open(os.path.join(VANILLA_CODE, 'arm9_ov167.bin'), 'rb').read()
    raw = d[0x021d7500 - OV167:0x021d7500 - OV167 + 289]
    return [[CODE[raw[a * 17 + b]] for b in range(17)] for a in range(17)]

def gen6_chart():
    v = vanilla_chart()
    c = [[3] * 18 for _ in range(18)]
    for a in range(17):
        for b in range(17): c[a][b] = v[a][b]
    for n, e in GEN6_FAIRY_ATTACK.items(): c[FAIRY][T[n]] = e
    for n, e in GEN6_FAIRY_DEFEND.items(): c[T[n]][FAIRY] = e
    for n, e in GEN6_STEEL_DEFEND.items(): c[T[n]][T['STEEL']] = e
    return c

# Gen 3 rule (classic split): Fire Water Grass Electric Ice Psychic Dragon Dark special, the rest physical; Fairy
# special (notes/FAIRY.md: its damaging moves but Play Rough are special, as its Pokemon mostly are); "no type" physical
CLASSIC_SPECIAL = {'FIRE', 'WATER', 'GRASS', 'ELECTRIC', 'ICE', 'PSYCHIC', 'DRAGON', 'DARK', 'FAIRY'}
def classic_table():
    return [2 if (i < 18 and TYPES[i].upper() in CLASSIC_SPECIAL) else 1 for i in range(19)]

# ---- species (Gen 6 types; a/0/1/6 record +6 type 1, +7 type 2) -----------------------------------------------------
RETYPES = {   # species: (Gen 6 type 1, type 2)
    35: ('FAIRY', 'FAIRY'), 36: ('FAIRY', 'FAIRY'), 173: ('FAIRY', 'FAIRY'),                 # Clefairy line
    39: ('NORMAL', 'FAIRY'), 40: ('NORMAL', 'FAIRY'), 174: ('NORMAL', 'FAIRY'),              # Jigglypuff line
    122: ('PSYCHIC', 'FAIRY'), 439: ('PSYCHIC', 'FAIRY'),                                    # Mr. Mime, Mime Jr.
    175: ('FAIRY', 'FAIRY'), 176: ('FAIRY', 'FLYING'), 468: ('FAIRY', 'FLYING'),             # Togepi line
    183: ('WATER', 'FAIRY'), 184: ('WATER', 'FAIRY'), 298: ('NORMAL', 'FAIRY'),              # Marill line
    209: ('FAIRY', 'FAIRY'), 210: ('FAIRY', 'FAIRY'),                                        # Snubbull line
    280: ('PSYCHIC', 'FAIRY'), 281: ('PSYCHIC', 'FAIRY'), 282: ('PSYCHIC', 'FAIRY'),         # Ralts line
    303: ('STEEL', 'FAIRY'),                                                                 # Mawile
    546: ('GRASS', 'FAIRY'), 547: ('GRASS', 'FAIRY'),                                        # Cottonee line
}
assert len(RETYPES) == 22

# ---- moves (a/0/2/1, 36-byte records: include/asm/move_data.inc) ----------------------------------------------------
RETYPED_MOVES = {186: 'Sweet Kiss', 204: 'Charm', 236: 'Moonlight'}       # Normal -> Fairy (status moves)
FIRST_NEW_MOVE = 560
F_CONTACT, F_PROTECT, F_MIRROR, F_SOUND, F_HEAL = 1 << 0, 1 << 3, 1 << 6, 1 << 8, 1 << 12
# id: (name, upper name, template move, changes, off-type, animation donor). Gen 6 values (XY), typed in from memory and
# listed in notes/FAIRY.md for the user to check. Templates: the Black 2 move with the same effect machinery.
NEW_MOVES = [
    (560, 'Fairy Wind', 55, dict(power=40, acc=100, pp=30), 'NORMAL', 318),           # Water Gun's plain hit; Silver Wind's animation
    (561, 'Disarming Voice', 304, dict(power=40, acc=101, pp=15), 'NORMAL', 497),     # Hyper Voice (adjacent foes, sound); Echoed Voice
    (562, 'Draining Kiss', 202, dict(power=50, acc=100, pp=10, drain=75, flags_add=F_CONTACT), 'NORMAL', 186),  # Giga Drain; Sweet Kiss
    (563, 'Dazzling Gleam', 304, dict(power=80, acc=100, pp=10, flags_del=F_SOUND), 'NORMAL', 148),   # Hyper Voice minus sound; Flash
    (564, 'Play Rough', 62, dict(power=90, acc=90, pp=10, cat=1, flags_add=F_CONTACT), 'NORMAL', 458),  # Aurora Beam (Atk -1 10%); Double Hit
    (565, 'Moonblast', 296, dict(power=95, acc=100, pp=15, chance1=30), 'NORMAL', 296),   # Mist Ball (Sp. Atk -1), chance 30; Mist Ball
]
N_NEW_MOVES = len(NEW_MOVES)

def move_record(template, ch):
    r = bytearray(template)
    r[0] = FAIRY
    if 'cat' in ch: r[2] = ch['cat']
    r[3], r[4], r[5] = ch['power'], ch['acc'], ch['pp']
    if 'drain' in ch: r[0x12] = ch['drain']
    if 'chance1' in ch: r[0x15 + 6] = ch['chance1']
    flags, = struct.unpack_from('<I', r, 0x20)
    flags = (flags | ch.get('flags_add', 0)) & ~ch.get('flags_del', 0)
    struct.pack_into('<I', r, 0x20, flags)
    return bytes(r)

# ---- learnsets (Gen 6 levels, typed in from memory: notes/FAIRY.md lists them with how sure each one is) -------------
LEVEL_UP = {    # species: [(level, move)]; Hoenn species only (Sapphire's dex and wild/trainer Pokemon)
    280: [(19, 562)], 281: [(19, 562)], 282: [(19, 562), (1, 565)],     # Ralts line: Draining Kiss; Gardevoir Moonblast
    183: [(47, 564)], 184: [(55, 564)],                                  # Marill, Azumarill: Play Rough
    39: [(11, 561)], 40: [(1, 564)],                                     # Jigglypuff Disarming Voice; Wigglytuff Play Rough
    303: [(1, 564), (5, 560)],                                           # Mawile: Play Rough, Fairy Wind
    333: [(11, 561), (46, 565)], 334: [(11, 561), (52, 565)],            # Swablu, Altaria (ORAS): Disarming Voice, Moonblast
    370: [(9, 562)],                                                     # Luvdisc: Draining Kiss
}
EGG_MOVES = {280: [561], 359: [564]}       # Ralts: Disarming Voice; Absol: Play Rough

# ---- items (free ids 113/114: "???", zero data, "?" icon; notes/FAIRY_SCOPE.md 3.3) ----------------------------------
ITEM_PIXIE_PLATE, ITEM_FAIRY_GEM = 113, 114
ITEM_TEMPLATE = {ITEM_PIXIE_PLATE: 307, ITEM_FAIRY_GEM: 557}     # Mind Plate, Psychic Gem (price, Fling, pocket ...)
HOLD_EFFECT_BY_ID = 147     # Black 2's Gen 5 items (gems, Eviolite ...): the effect comes from the item id table
# icons {char, palette} into a/0/2/5: the plate and gem graphics with the Mind Plate / Psychic Gem pinks
ITEM_ICONS = {ITEM_PIXIE_PLATE: (619, 629), ITEM_FAIRY_GEM: (934, 944)}
ITEM_ICON_TABLE = 0x02090d50
# Where they are sold (with the toggle on only). HoennB2: Lilycove Dept. Store 3F's right clerk (shop id 15); that shop's
# list file (SHOP_ID + 6) + the two items go to the empty list file 79 of a/2/8/2 (count byte 79 of a/2/8/3 file 0),
# and Fairy_ShopShim reads that file instead while Fairy is on. Pearl NDS: no shop yet (None = no list, no ov036 hook;
# Black 2's shop 15 is an herb seller here). Set it to the shop id of the clerk that should sell them.
SHOP_ID, SHOP_FILE = None, 79
OV036, SHOP_LIST_READ = 0x0217F600, 0x021ac77c
ITEM_EVENTS, ITEM_EVENTS_COUNT = 0x021d8f28, 172

# ---- code sites -----------------------------------------------------------------------------------------------------
# The "no type" value 17 in ov167, as a Thumb `mov/cmp rX, #17` (the immediate is the low byte). fairy_check.py lists
# every #0x11 in ov167 and shows that each one is here or not a type.
SENTINELS = {
    0x021a5a52: 'ServerEvent_CalcDamage: no STAB for a typeless move (cmp r2)',
    0x021aa066: 'ServerEvent_GetMoveParam: a typeless move (var 0x4b) gets type 17 (mov r0)',
    0x021aa966: 'func_ov167_021aa954 (move effectiveness): typeless -> neutral (cmp r0)',
    0x021ba6a8: 'BattleMon_Create: last-hit move type = none (mov r2)',
    0x021bab8e: 'ClearUsedMoveFlag: last-hit move type = none (mov r2)',
    0x021bc522: 'TransformSet: last-hit move type = none (mov r1)',
    0x021bafc4: 'splitTypeCore (Roost): Flying type 1 -> none (mov r1)',
    0x021bafd6: 'splitTypeCore (Roost): Flying type 2 -> none (mov r0)',
    0x021bafe2: 'splitTypeCore: type 1 none? (cmp r1)',
    0x021bafe6: 'splitTypeCore: both none -> Normal (cmp r0)',
    0x021baff4: 'splitTypeCore: type 2 none -> type 1 (cmp r0)',
    0x021bb01a: 'DoesMonHaveType: asking for "none" -> FALSE (cmp r4)',
    0x021bf822: 'HandlerColorChange: typeless move -> no change (cmp r6)',
    0x021c9e30: 'HandlerConversion2: no last-hit move type -> fail (cmp r4)',
}
REPLACED = {   # whole functions now in ITCM (their 17s go with them)
    0x021bd160: ('GetTypeEffectiveness', 'Fairy_TypeEff', 0x50),
    0x021bd2b0: ('GetTypeWeaknesses', 'Fairy_TypeWeaknesses', 0x38),
}
REPLACED_ARM9 = {
    0x02020234: ('PML_PersonalFetchBW2', 'Fairy_PersonalFetch', 0x2c),
    0x0201eee0: ('PML_PersonalLoadBW2', 'Fairy_PersonalLoad', 0x28),
}
CALLS = [   # (module, site, old target, new symbol, what)
    ('arm9', 0x020212fe, 0x0202130c, 'Fairy_MoveParamShim', 'PML_MoveGetParam: type / category hook'),
    ('ov167', 0x021aa06c, 0x021bcd54, 'Split_MoveParamEndShim', 'ServerEvent_GetMoveParam: category from the final type'),
    ('ov167', 0x021a5928, 0x02021740, 'Split_CatShimR4', 'ServerEvent_CalcDamage: category (burn halving, event var)'),
    ('ov167', 0x021aae98, 0x02021740, 'Split_CatShimR5', 'ServerEvent_GetAttackPower: Attack or Sp. Atk'),
    ('ov167', 0x021aaf9a, 0x02021740, 'Split_CatShimR6', 'ServerEvent_GetTargetDefenses: Defense or Sp. Def'),
    ('ov167', 0x021cfc9c, 0x021d3094, 'Fairy_AnimShim', 'func_ov167_021cfc60: new moves play a donor animation'),
    # link battles: one rule set for both machines (fairy.c "Link battles"; link, 2026-10-18, notes/LINK.md)
    ('ov167', 0x0219aeac, 0x021b9bb8, 'Link_SyncSend', 'func_ov167_0219ada0: the server sends the sync (+ its rules)'),
    ('ov167', 0x0219aeba, 0x021b9c0c, 'Link_SyncRecv', 'func_ov167_0219ada0: every machine receives it (the rules)'),
    ('ov167', 0x02199920, 0x021ce10c, 'Link_BattleInit', 'battle proc init: no link rules'),
    ('ov167', 0x02199ea8, 0x021ce138, 'Link_BattleExit', 'battle proc end: no link rules'),
]

SHOP_CALL = ('ov036', 0x021ac77c, 0x0204a934, 'Fairy_ShopShim', 'ShopUI_LoadPokeMartItems: the Fairy items\' list while Fairy is on')

# ---- data (apply) ---------------------------------------------------------------------------------------------------
def _vanilla(arc):
    return narcio.load(VANILLA_FILES, arc)

def old_types():
    pers = _vanilla(16)
    return {s: (pers[s][6], pers[s][7]) for s in RETYPES}

# Archives this patch grows get a fixed size of their own (vanilla + reserve, as build_rom.py's RESERVE does), so later
# edits of the Fairy data keep the ROM layout and its savestates
FAIRY_RESERVE = {21: 4 << 10, 18: 4 << 10, 124: 2 << 10}     # a/0/2/1 moves, a/0/1/8 level-up, a/1/2/4 egg moves

def _pad(files, arc, reserve):
    from b2files import arc_path
    orig = os.path.getsize(arc_path(VANILLA_FILES, arc))
    target = (orig + reserve + 0x1FF) & ~0x1FF
    path = arc_path(files, arc)
    data = bytearray(open(path, 'rb').read())
    assert len(data) <= target, f'a/{arc:03d}: {len(data)} B is over its fixed size {target}: raise FAIRY_RESERVE[{arc}]'
    hdr = struct.unpack_from('<H', data, 0xC)[0]
    off = hdr
    for _ in range(2): off += struct.unpack_from('<I', data, off + 4)[0]     # BTAF, BTNF
    assert data[off:off + 4] == b'GMIF'
    extra = target - len(data)
    struct.pack_into('<I', data, off + 4, struct.unpack_from('<I', data, off + 4)[0] + extra)
    struct.pack_into('<I', data, 8, target)
    data += bytes(extra)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return target - orig

def apply(files):
    out = []
    # species
    pers = narcio.load(files, 16)
    for s, (t1, t2) in RETYPES.items():
        r = bytearray(pers[s])
        r[6], r[7] = T[t1], T[t2]
        pers[s] = bytes(r)
    narcio.save(files, 16, pers)
    out.append(f'{len(RETYPES)} species retyped')
    # moves
    moves = narcio.load(files, 21)
    assert len(moves) == FIRST_NEW_MOVE, f'a/0/2/1 has {len(moves)} moves (expected 560: rerun on a clean tree)'
    for m in RETYPED_MOVES:
        r = bytearray(moves[m]); assert r[0] == T['NORMAL'], m
        r[0] = FAIRY; moves[m] = bytes(r)
    for mid, name, tmpl, ch, _, _ in NEW_MOVES:
        assert len(moves) == mid
        moves.append(move_record(moves[tmpl], ch))
    narcio.save(files, 21, moves)
    out.append(f'moves: 3 retyped, {N_NEW_MOVES} new at {FIRST_NEW_MOVE}-{FIRST_NEW_MOVE + N_NEW_MOVES - 1}')
    # level-up moves: (u16 move, u16 level) pairs, 0xFFFF 0xFFFF at the end (include/asm/levelup_moves.inc)
    lu = narcio.load(files, 18)
    n = 0
    for s, adds in LEVEL_UP.items():
        pairs = [struct.unpack_from('<HH', lu[s], 4 * i) for i in range(len(lu[s]) // 4)]
        end = pairs.index((0xFFFF, 0xFFFF))
        body = pairs[:end]
        for lvl, mv in adds:
            if any(m == mv for m, _ in body): continue
            k = next((i for i, (m, l) in enumerate(body) if l > lvl), len(body))
            body.insert(k, (mv, lvl)); n += 1
        data = b''.join(struct.pack('<HH', m, l) for m, l in body) + struct.pack('<HH', 0xFFFF, 0xFFFF)
        lu[s] = data + bytes((-len(data)) % 4)
    narcio.save(files, 18, lu)
    out.append(f'{n} level-up moves')
    # egg moves: u16 count, u16 moves[] (a/1/2/4, one file per species)
    eggs = narcio.load(files, 124)
    n = 0
    for s, adds in EGG_MOVES.items():
        e = eggs[s]
        cnt = struct.unpack_from('<H', e, 0)[0] if len(e) >= 2 else 0
        mv = list(struct.unpack_from(f'<{cnt}H', e, 2)) if cnt else []
        for m in adds:
            if m not in mv: mv.append(m); n += 1
        eggs[s] = struct.pack(f'<H{len(mv)}H', len(mv), *mv)
    narcio.save(files, 124, eggs)
    out.append(f'{n} egg moves')
    # items
    items = narcio.load(files, 24)
    for it, tmpl in ITEM_TEMPLATE.items():
        assert not any(items[it]), f'item {it} is not free'
        r = bytearray(items[tmpl])
        r[2] = HOLD_EFFECT_BY_ID
        items[it] = bytes(r)
    narcio.save(files, 24, items)
    out.append(f'items Pixie Plate {ITEM_PIXIE_PLATE}, Fairy Gem {ITEM_FAIRY_GEM}')
    # the shop list sold with the toggle on (a copy of that shop's list + the two items; none while SHOP_ID is None)
    if SHOP_ID is not None:
        lists, counts = narcio.load(files, 282), narcio.load(files, 283)
        base = lists[SHOP_ID + 6]
        n = counts[0][SHOP_ID + 6]
        assert len(base) == 2 * n and not lists[SHOP_FILE] and counts[0][SHOP_FILE] == 0, 'shop list files changed'
        lists[SHOP_FILE] = base + struct.pack('<HH', ITEM_PIXIE_PLATE, ITEM_FAIRY_GEM)
        c = bytearray(counts[0]); c[SHOP_FILE] = n + 2; counts[0] = bytes(c)
        narcio.save(files, 282, lists); narcio.save(files, 283, counts)
        out.append(f'shop {SHOP_ID} with Fairy on: list file {SHOP_FILE} ({n} + 2 items)')
    else:
        out.append('no shop sells them yet (SHOP_ID None)')
    grown = {arc: _pad(files, arc, r) for arc, r in FAIRY_RESERVE.items()}
    out.append('fixed sizes ' + ', '.join(f'a/{a // 100}/{a // 10 % 10}/{a % 10} +{g} B' for a, g in grown.items()))
    return 'fairy: ' + ', '.join(out)

# ---- code (apply_code) ----------------------------------------------------------------------------------------------
def data_header():
    c6 = gen6_chart()
    ot = old_types()
    L = ['/* generated by b2tools/patches/fairy.py */',
         f'#define FIRST_NEW_MOVE {FIRST_NEW_MOVE}', f'#define N_NEW_MOVES {N_NEW_MOVES}',
         f'#define N_RETYPES {len(RETYPES)}',
         'static const u8 kChart6[18 * 18] = {' + ', '.join(str(c6[a][b]) for a in range(18) for b in range(18)) + '};',
         'static const u8 kClassic[19] = {' + ', '.join(map(str, classic_table())) + '};',
         'static const u16 kRetypeId[N_RETYPES] = {' + ', '.join(map(str, RETYPES)) + '};',
         'static const u8 kRetypeOld[N_RETYPES][2] = {' + ', '.join('{%d, %d}' % ot[s] for s in RETYPES) + '};',
         'static const u8 kNewMoveFallback[N_NEW_MOVES] = {' + ', '.join(str(T[m[4]]) for m in NEW_MOVES) + '};',
         '__attribute__((used)) const u16 kAnimDonor[N_NEW_MOVES] = {' + ', '.join(str(m[5]) for m in NEW_MOVES) + '};',
         *([f'#define SHOP_ID {SHOP_ID}', f'#define SHOP_FILE {SHOP_FILE}'] if SHOP_ID is not None else [])]
    return '\n'.join(L) + '\n'

def items_header(ov167):
    rows = []
    for i in range(ITEM_EVENTS_COUNT):
        it, fn = struct.unpack_from('<II', ov167, ITEM_EVENTS - OV167 + 8 * i)
        if i == ITEM_EVENTS_COUNT - 1:
            assert (it, fn) == (0, 0), 'the last item-event slot is no longer free'
            continue
        rows.append(f'{{{it}, (void *){fn:#x}}}')
    rows += [f'{{{ITEM_PIXIE_PLATE}, (void *)EventAddPixiePlate}}', f'{{{ITEM_FAIRY_GEM}, (void *)EventAddFairyGem}}']
    return ('/* generated by b2tools/patches/fairy.py: ov167 data_ov167_021d8f28 + the new items */\n'
            f'#define N_ITEM_EVENTS {len(rows)}\n'
            'typedef struct { u32 item; void *eventAdd; } ItemEvent;\n'
            '__attribute__((used)) const ItemEvent kItemEvents[N_ITEM_EVENTS] = {\n    ' + ',\n    '.join(rows) + '\n};\n')

SELFTEST_STATES = 4

def selftest_header(st_addr):
    return f'''/* test builds only (PEARL_TEST_FAIRY_SELFTEST=1): fairy_check.py --emu writes 'FAIR' at ST_ADDR in a battle;
 * the next type lookup fills the buffer from the real entry points and writes 'DONE' */
#define ST_ADDR {st_addr:#x}
#define GetTypeEffectiveness_   FN(u32 (*)(u32, u32), 0x021bd160)
#define GetTypeWeaknesses_      FN(u32 (*)(u32, u8 *), 0x021bd2b0)
#define PML_MoveGetParam_       FN(u32 (*)(u32, u32), 0x02021280)
#define PML_PersonalGetParamSingle_ FN(u32 (*)(u32, u32, u32), 0x0201ef1c)
static void SelfTest_Hook(void) {{
    volatile u32 *hdr = (volatile u32 *)ST_ADDR;
    u8 *out = (u8 *)(ST_ADDR + 16), w[24];
    u16 *save;
    u16 keep;
    u32 s, a, d, i, n;
    if (hdr[0] != 0x52494146 || !g_SaveControlWork) return;      /* 'FAIR' */
    hdr[0] = 0;
    save = (u16 *)SaveControl_GetBlockPtr(g_SaveControlWork, 27);
    keep = *save;
    for (s = 0; s < {SELFTEST_STATES}; s++) {{
        *save = (keep & ~(CFG_FAIRY | CFG_CLASSIC)) | ((s & 1) ? CFG_FAIRY : 0) | ((s & 2) ? CFG_CLASSIC : 0);
        for (a = 0; a < 19; a++) for (d = 0; d < 19; d++) *out++ = (u8)GetTypeEffectiveness_(a, d);
        for (a = 0; a < 19; a++) {{
            for (i = 0; i < 24; i++) w[i] = 0xff;
            n = GetTypeWeaknesses_(a, w);
            *out++ = (u8)n;
            for (i = 0; i < 18; i++) *out++ = w[i];
        }}
        for (i = 0; i < {FIRST_NEW_MOVE + N_NEW_MOVES}; i++) {{
            *out++ = (u8)PML_MoveGetParam_(i, 0);
            *out++ = (u8)PML_MoveGetParam_(i, 2);
        }}
        for (i = 0; i < 650; i++) {{
            *out++ = (u8)PML_PersonalGetParamSingle_(i, 0, 6);
            *out++ = (u8)PML_PersonalGetParamSingle_(i, 0, 7);
        }}
    }}
    *save = keep;
    hdr[1] = (u32)(out - (u8 *)(ST_ADDR + 16));
    hdr[0] = 0x454e4f44;                                         /* 'DONE' */
}}
'''

def selftest_size():
    return 16 + SELFTEST_STATES * (19 * 19 + 19 * 19 + 2 * (FIRST_NEW_MOVE + N_NEW_MOVES) + 2 * 650)

def build(base, workdir, ov167, selftest_at=None):
    """fairy.c + its generated headers, linked at base (itcm.build): (blob, symbols)."""
    with open(os.path.join(workdir, 'fairy_data.h'), 'w') as f: f.write(data_header())
    with open(os.path.join(workdir, 'fairy_items.h'), 'w') as f: f.write(items_header(ov167))
    defs = []
    if selftest_at is not None:
        with open(os.path.join(workdir, 'fairy_selftest.h'), 'w') as f: f.write(selftest_header(selftest_at))
        defs.append('-DFAIRY_SELFTEST')
    return itcm.build(os.path.join(HERE, 'fairy.c'), base, workdir, defines=defs, includes=[workdir])

CFG_FAIRY_BIT, CFG_CLASSIC_BIT, CFG_MUSIC_BIT, CFG_SPRITES_BIT = 11, 12, 13, 14   # HoennB2's layout (bit 15: seasons, season_choice.py)

def _load(code, name):
    p = os.path.join(code, name); return p, bytearray(open(p, 'rb').read())

def _save(p, d):
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)

def _put(d, base, addr, old, new, what):
    o = addr - base
    cur = bytes(d[o:o + len(old)])
    assert cur == old, f'{what} at {addr:#x}: {cur.hex()} (expected {old.hex()})'
    d[o:o + len(new)] = new

def apply_code(code):
    p167, ov167 = _load(code, 'arm9_ov167.bin')
    p036, ov036 = _load(code, 'arm9_ov036.bin')
    selftest = os.environ.get('PEARL_TEST_FAIRY_SELFTEST') == '1'
    st = {}
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        def build_at(base):
            blob, sym = build(base, tmp, ov167)
            if selftest:   # the buffer goes after the code: link once to learn the size, then again with its address
                st['addr'] = (base + len(blob) + 0x400 + 31) & ~31
                blob, sym = build(base, tmp, ov167, st['addr'])
                assert base + len(blob) < st['addr'] and st['addr'] + selftest_size() <= itcm.ITCM_END
            return blob, sym
        base, end, sym = itcm.install(code, build_at)      # arm9.bin (the arena literal), itcm.bin, itcm.yaml
    p9, arm9 = _load(code, 'arm9.bin')
    vanilla167 = open(os.path.join(VANILLA_CODE, 'arm9_ov167.bin'), 'rb').read()
    vanilla9 = open(os.path.join(VANILLA_CODE, 'arm9.bin'), 'rb').read()
    # ov167: sentinels
    for at, what in SENTINELS.items():
        o = at - OV167
        assert ov167[o] == 0x11 and (ov167[o + 1] & 0xF0) == 0x20, f'sentinel {at:#x} ({what}): {ov167[o:o+2].hex()}'
        ov167[o] = 0x12
    # ov167 / arm9: whole functions -> ITCM (8 bytes at a 4-aligned start: ldr r3, [pc, #0]; bx r3; .word)
    for at, (name, new, fsize) in REPLACED.items():
        o = at - OV167
        assert at % 4 == 0 and ov167[o:o + fsize] == vanilla167[o:o + fsize], f'{name} was changed by another patch'
        ov167[o:o + 8] = itcm.long_jump(at, sym[new] & ~1)
    for at, (name, new, fsize) in REPLACED_ARM9.items():
        o = at - ARM9
        assert at % 4 == 0 and arm9[o:o + fsize] == vanilla9[o:o + fsize], f'{name} was changed by another patch'
        arm9[o:o + 8] = itcm.long_jump(at, sym[new] & ~1)
    # calls
    calls = CALLS + ([SHOP_CALL] if SHOP_ID is not None else [])
    for mod, at, old, new, what in calls:
        d, b = {'arm9': (arm9, ARM9), 'ov167': (ov167, OV167), 'ov036': (ov036, OV036)}[mod]
        _put(d, b, at, itcm.bl(at, old), itcm.bl(at, sym[new] & ~1), what)
    # Metronome: the move buffer (0x230 u16 -> 0x238) and the loop's bound (0x230 -> Fairy_MoveCount())
    _put(ov167, OV167, 0x021bd060, bytes.fromhex('4621'), bytes.fromhex('4721'), 'Metronome buffer: mov r1, #0x46')
    _put(ov167, OV167, 0x021bd686, bytes.fromhex('23200001'), itcm.bl(0x021bd686, sym['Fairy_MoveCount'] & ~1),
         'Metronome loop bound: mov r0, #0x23; lsl r0, r0, #4')
    # held items: ItemEvent_AddItemCore's table and count
    n_items = ITEM_EVENTS_COUNT - 1 + 2
    _put(ov167, OV167, 0x021c273a, bytes([ITEM_EVENTS_COUNT, 0x2a]), bytes([n_items, 0x2a]), 'item events: cmp r2, #0xac')
    _put(ov167, OV167, 0x021c2744, struct.pack('<II', ITEM_EVENTS, ITEM_EVENTS + 4),
         struct.pack('<II', sym['kItemEvents'], sym['kItemEvents'] + 4), 'item events: table literals')
    # item icons
    for it, (ch, pal) in ITEM_ICONS.items():
        _put(arm9, ARM9, ITEM_ICON_TABLE + 4 * it, struct.pack('<HH', 1021, 1022), struct.pack('<HH', ch, pal), f'icon of item {it}')
    for p, d in ((p9, arm9), (p167, ov167), (p036, ov036)): _save(p, d)
    exports = {k: sym[k] | 1 for k in ('Fairy_IsOn', 'Split_IsClassic')}
    exports.update({'itcm_start': base, 'itcm_end': end, 'selftest': st.get('addr'), 'gLinkRules': sym['gLinkRules']})
    open(os.path.join(code, 'fairy_symbols.json'), 'w').write(json.dumps(exports, indent=1))
    return (f'fairy: {end - base} B of ITCM at {base:#x} (arena from {end:#x}); Fairy_IsOn {sym["Fairy_IsOn"] | 1:#x}, '
            f'Split_IsClassic {sym["Split_IsClassic"] | 1:#x}, gLinkRules {sym["gLinkRules"]:#x}; {len(SENTINELS)} '
            f'sentinels, {len(calls)} calls' + (f'; SELFTEST buffer {st["addr"]:#x}' if selftest else ''))

if __name__ == '__main__':      # python3 fairy.py: compile and link at a dummy base, show the symbols
    with tempfile.TemporaryDirectory() as tmp:
        ov = open(os.path.join(VANILLA_CODE, 'arm9_ov167.bin'), 'rb').read()
        blob, sym = build(0x01FFA000, tmp, ov, 0x01FFC000 if '--selftest' in sys.argv else None)
        print(len(blob), {k: hex(v) for k, v in sym.items() if not k.startswith(('$', '.'))})
