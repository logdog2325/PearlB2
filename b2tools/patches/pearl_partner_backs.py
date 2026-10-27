"""Pearl's battle partners seen from behind, with their own backs (user 2026-10-25: named Diamond/Pearl characters use
Pearl's own sprites where Black 2 has no official one; "partners (Cheryl, Mira, Riley, Buck, Marley) need back sprites
too"), and link battles that show Pearl's Lucas and Dawn. Run after pearl_trainers (the class registry) and
pearl_player_sprites (both write a/0/7/2):

    build_rom.py ... pearl_trainers ... pearl_player_sprites pearl_npc_sprites pearl_partner_backs ...

A multi battle shows the player's ally from behind: Black 2 takes the ally class's back from TRAINER_CLASS_BACK_SPRITES
(arm9 0x02092314, 32 class/back pairs, pokebw2 src/system/tr_tool.c GetTrSpriteBaseDatID); a class not in it gets
Nate's or Rosa's back, which are Lucas's and Dawn's in PearlB2 (patches/pearl_player_sprites). Until 2026-10-25
Cheryl (class 111) showed as the player that way, and Riley, Marley, Buck, Mira, Lucas and Dawn (classes 180-185)
showed Black 2's own backs 9-14 of those classes.

Pearl's backs (pokediamond sub_0206AA30: back 0 Lucas, 1 Dawn, 2 Barry, 3 Cheryl, 4 Riley, 5 Marley, 6 Buck, 7 Mira)
each throw with five OAM cells in battle/graphic/batt_obj.narc (NCGR 195 + back, NCLR 47 + back, NCER 203 + back, NANR
211 + back), the same timing for all eight, the Poke Ball in the hand at ov11_0225E8D0's offsets for that back
(BALL_IN_HAND below; backs 3, 4 and 7 hold it elsewhere). They are converted exactly as pearl_player_sprites converts
the player's (its _oam_cells and back_files: Pearl's cells pixel for pixel, Pearl's order and timing, the ball let go
when cell 3 shows), into new back sprites appended after Black 2's 31 (a/0/7/2, 8 files each; the sprite id is a u8):
31 Cheryl, 32 Riley, 33 Marley, 34 Buck, 35 Mira, then 36 Lucas and 37 Dawn as the counterpart, Pearl's own backs 0
and 1 (backs 0 and 1 stay the player's, which may take other art: DECISIONS 2026-10-25, the fan Lucas back).

Classes (data/pearl_trainer_classes.json): Black 2's battle view swaps the player of a link battle to class 180 or
181 (and 182/183 to 184/185; ov168 BtlvEffect_SetTrainer, every comm battle: BtlSetup unk97 is 1), so the partners
left 180-185 for classes nothing else shows: Riley 228, Marley 229, Mira 230 (Black 2's unused PKMN_TRAINER
placeholders), Buck 207, Lucas 199, Dawn 200 (Pokéstar Studios' Guy, Hero, Heroine: only its movies use them, and
Pearl's map has no Studios). Cheryl keeps 111.
apply_code, TRAINER_CLASS_BACK_SPRITES (same size, Black 2's pairs checked first):
- 180 -> back 0, 181 -> back 1: a link battle shows the player's own back, Lucas or Dawn (Black 2: its backs 9, 10);
- the partner classes -> their backs: Lucas 199 and Dawn 200 and Buck 207 on Pokéstar's own pairs for those classes,
  the others on Pokéstar's pairs of Ninja M/F and UDF Trooper M/F (classes no Pearl trainer has).
And TRAINER_CLASS_RESOURCES (arm9 0x02092394) of 180/181: the front picture and sex of Pearl's Lucas and Dawn (the
counterpart's, data/pearl_trainer_classes.json), so the other player of a link battle shows as Lucas or Dawn too
(it was Riley or Marley while they had 180/181; Black 2: its sprites 142/143).
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio  # noqa: E402
import pearl_player_sprites as pps  # noqa: E402

REGISTRY = os.path.join(ROOT, 'data', 'pearl_trainer_classes.json')
ARC_BACK = 72
B2_BACKS = 31                               # Black 2's back sprites (0-30), 8 files each
FILES_PER = 8
TEMPLATE = 9                                # files the new sprites start from: Black 2's back 9 (left as it is)
# (Pearl class in the registry, Pearl back, who): the new back sprites in this order, from B2_BACKS on
PARTNERS = [('PKMN_TRAINER_CHERYL', 3, 'Cheryl'), ('PKMN_TRAINER_RILEY', 4, 'Riley'),
            ('PKMN_TRAINER_MARLEY', 5, 'Marley'), ('PKMN_TRAINER_BUCK', 6, 'Buck'), ('PKMN_TRAINER_MIRA', 7, 'Mira'),
            ('PKMN_TRAINER_LUCAS', 0, 'Lucas (counterpart)'), ('PKMN_TRAINER_DAWN', 1, 'Dawn (counterpart)')]
# ov11_0225E8D0 (pokediamond ov11_0224D550.s): the ball's offset in cells 1 and 2 of each back's throw
BALL_IN_HAND = {0: {1: (-34, 4), 2: (-28, -11)}, 1: {1: (-34, 4), 2: (-28, -11)}, 2: {1: (-34, 4), 2: (-28, -11)},
                3: {1: (-33, -6), 2: (-28, -18)}, 4: {1: (-33, -2), 2: (-28, -18)}, 5: {1: (-34, 4), 2: (-28, -11)},
                6: {1: (-34, 4), 2: (-28, -11)}, 7: {1: (-34, 4), 2: (-23, -1)}}

ARM9_BASE, BACK_TABLE, BACK_ENTRIES, CLASS_RESOURCES = 0x02004000, 0x02092314, 32, 0x02092394
# Black 2's TRAINER_CLASS_BACK_SPRITES (class, back), as the dump has it
B2_BACK_TABLE = [(0, 0), (1, 1), (10, 2), (11, 3), (12, 4), (37, 5), (38, 6), (61, 7), (145, 8), (180, 9), (181, 10),
                 (182, 11), (183, 12), (184, 13), (185, 14), (193, 15), (197, 16), (198, 15), (199, 17), (200, 18),
                 (201, 19), (202, 20), (203, 21), (204, 22), (205, 23), (206, 24), (207, 25), (208, 26), (209, 27),
                 (210, 28), (225, 29), (226, 30)]
LINK = {180: ('PKMN_TRAINER_LUCAS', 0), 181: ('PKMN_TRAINER_DAWN', 1)}   # link class: (its picture's class, back)
FREE_PAIRS = [201, 202, 203, 204]           # Pokéstar's Ninja M/F, UDF Trooper M/F: pairs the partners may take


def pearl_throw(m, back):
    """(5 poses {(x, y): index} in Black 2 sprite coordinates, ticks at 60 fps, 16 colours) of Pearl's back `back`,
    from batt_obj.narc's members `m`, as pearl_player_sprites.pearl_throws makes the player's."""
    import mcss
    ball = pps._oam_cells(pps._lz10(m[pps.BALL_FILES[0]]), pps._lz10(m[pps.BALL_FILES[2]]))[0]
    bpal = pps._pal16(m[pps.BALL_FILES[1]])
    cells = pps._oam_cells(pps._lz10(m[pps.THROW_FILES[0] + back]), pps._lz10(m[pps.THROW_FILES[2] + back]))
    pal = pps._pal16(m[pps.THROW_FILES[1] + back])
    labs = [pps._lab(c) for c in pal]
    near = {v: min(range(1, 16), key=lambda j: sum((a - b) ** 2 for a, b in zip(pps._lab(bpal[v]), labs[j])))
            for v in set(ball.values())}
    for k, (bx, by) in BALL_IN_HAND[back].items():
        for (x, y), v in ball.items():
            cells[k][(bx + x, by + y)] = near[v]
    seq = list(mcss.parse_anim(pps._lz10(m[pps.THROW_FILES[3] + back])))[0]['frames']
    assert [r['idx'] for _, r in seq] == list(range(5)), (back, seq)
    ticks = [2 * d for d, _ in seq]
    ticks[0] += pps.RELEASE_TICK - sum(ticks[:pps.RELEASE_CELL])
    assert ticks[0] > 0, ticks
    return [{(x, y + pps.PEARL_DY): v for (x, y), v in c.items()} for c in cells], ticks, pal


def new_backs():
    """{Pearl class: new back sprite id}."""
    return {pc: B2_BACKS + i for i, (pc, _, _) in enumerate(PARTNERS)}


def apply(files):
    import version
    from gen4rom import Rom, narc_members
    m = narc_members(Rom(version.SOURCE_DUMP).read(pps.BATT_OBJ))
    entries = narcio.load(files, ARC_BACK)
    assert len(entries) == B2_BACKS * FILES_PER, \
        f'a/0/7/2 has {len(entries)} files, not Black 2\'s {B2_BACKS * FILES_PER}: list pearl_partner_backs once'
    done = []
    for pc, back, who in PARTNERS:
        s = len(entries) // FILES_PER
        entries += entries[TEMPLATE * FILES_PER:(TEMPLATE + 1) * FILES_PER]
        poses, ticks, pal = pearl_throw(m, back)
        for k, v in pps.back_files(entries, s, poses, ticks, pal).items():
            entries[k] = v
        done.append(f'{s} {who} (Pearl back {back})')
    assert len(entries) == (B2_BACKS + len(PARTNERS)) * FILES_PER
    narcio.save(files, ARC_BACK, entries)
    return 'pearl_partner_backs: battle backs ' + ', '.join(done)


def back_table(reg):
    """The new TRAINER_CLASS_BACK_SPRITES: [(class, back)] x 32."""
    table = [list(p) for p in B2_BACK_TABLE]
    at = {c: i for i, (c, _) in enumerate(B2_BACK_TABLE)}
    for c, (_, back) in LINK.items():
        table[at[c]][1] = back
    free = [at[c] for c in FREE_PAIRS]
    for pc, sprite in new_backs().items():
        c = reg['classes'][pc]['b2']
        assert c not in LINK and c not in (0, 1), (pc, c)
        i = at[c] if c in at else free.pop(0)
        table[i] = [c, sprite]
    assert len({c for c, _ in table}) == len(table), table
    return [tuple(p) for p in table]


def apply_code(code):
    reg = json.load(open(REGISTRY, encoding='utf-8'))
    path = os.path.join(code, 'arm9.bin')
    data = bytearray(open(path, 'rb').read())
    o = BACK_TABLE - ARM9_BASE
    cur = [struct.unpack_from('<HH', data, o + 4 * i) for i in range(BACK_ENTRIES)]
    assert cur == B2_BACK_TABLE, f'TRAINER_CLASS_BACK_SPRITES is not Black 2\'s: {cur}'
    table = back_table(reg)
    for i, (c, s) in enumerate(table):
        struct.pack_into('<HH', data, o + 4 * i, c, s)
    for c, (pc, _) in LINK.items():
        e = reg['classes'][pc]
        r = CLASS_RESOURCES - ARM9_BASE + 4 * c
        data[r], data[r + 1] = e['sprite'], e['sex']
    if os.path.islink(path):
        os.unlink(path)
    open(path, 'wb').write(data)
    changed = [f'{c}->{s}' for (c, s), b in zip(table, B2_BACK_TABLE) if (c, s) != b]
    return (f'pearl_partner_backs: TRAINER_CLASS_BACK_SPRITES {", ".join(changed)}; link classes 180/181 show '
            f'Lucas/Dawn (pictures {reg["classes"]["PKMN_TRAINER_LUCAS"]["sprite"]}/'
            f'{reg["classes"]["PKMN_TRAINER_DAWN"]["sprite"]})')
