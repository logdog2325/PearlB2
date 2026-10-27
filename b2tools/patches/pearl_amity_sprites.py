"""Pearl's own overworld Pokémon (Amity Square, 2026-10-25; the user: "open Amity Square with the Pokémon following
like in Pearl", Pearl's own art pixel for pixel). Run after pearl_npc_sprites (both edit a/0/4/8).
2026-10-26 (the following Pokémon, patches/followers.py; user: convert Pearl's own walkers): also Pearl's other two
16-frame Pokémon walkers, Machop (SPRITE_WANRIKY, Oreburgh and its mine) and Shaymin's Land Forme (SPRITE_SPPOKE8,
Route 224 and Flower Paradise), on codes 337 and 338 (nothing in Black 2 names them:
work/agents/followers/free_codes.py). Pearl's other Pokémon sheets are not walkers (Starly 4 frames, Magikarp 2, the
legendaries 1-2) and keep Black 2's own walking sprites.

The 11 Pokémon that walk with the player in Amity Square, which also stand in Pearl's houses, gates and routes, had
Black 2's own overworld Pokémon (codes 0x1000 + species: Black 2's look, drawn with its Pokémon animation sets 13/14,
which loop a walk cycle in place). Pearl draws them as people (pokeplatinum object_event_gfx_data.c: the same draw
functions as its townspeople and the Elite Four) from 32 x 32 sheets of 16 frames: back, front, left, right, 4 per
direction (stand, step, stand, step), feet on row 29. Each now has a Black 2 person code of its own (12-frame walker,
scene node 2, controller 3, shadow on, as the Elite Four's codes in pearl_npc_sprites), repainted with Pearl's frames
0, 1, 3 of each direction (Black 2's stand, step, step), 1 pixel lower (Black 2's feet are on row 30), with Pearl's
16 colours. data/pearl_sprite_map.json gives each graphics id its code.

The codes: none of Black 2's own zones that this game keeps, none of its scripts' ActorNew, none of its tables (the
PWT's a/2/4/7, ov012 BtlInst_GetTrainerClassObjCode, union_view.c) and none of its C names them (pokebw2 res/field
events and scripts, src); 111 nothing at all, the others only Unova zones whose numbers Sinnoh's maps took (listed per
code in the sprite map's notes). Each sheet (res1 of the code's a/0/4/7 record) belongs to that code alone. Checked
here: each code is one Pearl graphics id's only, and outside the PWT's table.
"""
import json, os, struct, sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio, sprites  # noqa: E402
from pearl_player_sprites import MMODEL, shift, SHIFT_DOWN  # noqa: E402

# (Pokémon, Pearl graphics id, Pearl mmodel file, texture name)
POKEMON = [('Pikachu', 71, 69, 'pikachu'), ('Clefairy', 72, 70, 'pippi'), ('Jigglypuff', 73, 71, 'purin'),
           ('Psyduck', 74, 72, 'koduck'), ('Torchic', 78, 76, 'achamo'), ('Skitty', 79, 77, 'eneco'),
           ('Drifloon', 185, 163, 'balloon'), ('Pachirisu', 204, 371, 'patiritusu'),
           ('Shroomish', 205, 372, 'kinococo'), ('Buneary', 206, 373, 'mimituto'), ('Happiny', 207, 374, 'kolucky'),
           ('Machop', 208, 375, 'wanriky'), ('Shaymin', 158, 137, 'sppoke8')]   # 2026-10-26: the following Pokémon
ARC_PWT = 247                                        # a/2/4/7: the PWT's trainers, u16 x 8 records, object code at +2
WALK12 = [d * 4 + k for d in range(4) for k in (0, 1, 3)]


def apply(files):
    import version
    from gen4rom import Rom, narc_members
    smap = json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json'), encoding='utf-8'))
    mm = narc_members(Rom(version.SOURCE_DUMP).read(MMODEL))
    sheets = narcio.load(files, sprites.ARC_OW_SHEETS)
    table = sprites.ow_table(files)
    t = narcio.load(files, ARC_PWT)[0]
    pwt = {struct.unpack_from('<H', t, 16 * i + 2)[0] for i in range(len(t) // 16)}
    res1 = Counter(r['res1'] for r in table)
    done = []
    for who, gfx, mid, tex in POKEMON:
        code = smap[str(gfx)]['code']
        users = [k for k, v in smap.items() if isinstance(v, dict) and v.get('code') == code]
        assert users == [str(gfx)], (who, code, users)
        assert code < 377 and code not in pwt, f'{who}: code {code} is not a free person code'
        sheet, rec = sprites.ow_sheet_of(files, code, table)
        assert res1[sheet] == 1, f'{who}: sheet {sheet} of code {code} is shared'
        assert (rec['sceneNodeType'], rec['spriteControllerType'], rec['shadow']) == (2, 3, 1), (who, rec)
        lay, _, _ = sprites.btx_layout(sheets[sheet])
        assert len(lay) == 12 and all((w, h) == (32, 32) for _, w, h, _ in lay), who
        fr, _, pal = sprites.btx_decode(mm[mid])
        fr = sorted(fr, key=lambda f: int(f[0].split('.')[-1]))
        assert len(fr) == 16 and all(f[0].rsplit('.', 1)[0] == tex and (f[1], f[2]) == (32, 32) for f in fr), who
        sheets[sheet] = sprites.btx_encode(sheets[sheet], [shift(fr[i][3], SHIFT_DOWN) for i in WALK12], pal)
        done.append(f'{who} = code {code} (sheet {sheet})')
    narcio.save(files, sprites.ARC_OW_SHEETS, sheets)
    return 'pearl_amity_sprites: ' + '; '.join(done)
