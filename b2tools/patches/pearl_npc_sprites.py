"""Pearl's own overworld sprites for people who had Black 2 stand-ins (user 2026-10-19: "give rowan his sprite and the
moms there actual sprites from diamond and peral"). Run after pearl_player_sprites (both edit a/0/4/8).

Each Pearl sprite (the dump's data/mmodel/mmodel.narc, textures named <name>.N, 16 frames of 32 x 32: back, front,
left, right, 4 per direction: stand, step, stand, step) replaces the sheet of the Black 2 object code that
data/pearl_sprite_map.json gives its graphics id. Each of these codes is used by that one Pearl sprite only (checked
here), so nothing else changes look:
- Rowan (SPRITE_DOCTOR, mmodel 94) -> code 180, Black 2's unused white-bearded old man: 12 frames, 3 per direction
  (stand, step, step) = Pearl 0, 1, 3 of each direction (as pearl_player_sprites' walk sheet).
- Mom (SPRITE_MAMA, mmodel 119) -> code 251, Black 2's Mom: 7 frames = back stand, back step, front stand, front step,
  side stand, side step, side step (Black 2 mirrors the other side and the other step) = Pearl 0, 1, 4, 5, 8, 9, 11.
- Barry (SPRITE_RIVEL, mmodel 127) -> code 291, Black 2's Hugh (user 2026-10-19: "hughs sprite needs to be changed
  to barrys asap"): 17 frames, the 12 walking frames as Rowan's, then 5 poses only Black 2's own story plays (Pearl's
  scripts never ask for them) -> Pearl's standing frames (left, right, front x3).
- Barry's mom has no sprite of her own in Pearl: she is SPRITE_MIDDLEWOMAN1 (mmodel 15), as are Pearl's other 24
  middle-aged women, which Black 2 showed as its Pokéfan (code 26, 7 frames): all 25 now look as in Pearl.
- Rowan's briefcase at Lake Verity (SPRITE_BAG, mmodel 153 'bag', one frame) -> code 208, Black 2's gift box (user
  2026-10-20: "make the suitcase in the opening actually look like a suitcase instead of a present"): a one-frame
  32 x 32 object no Black 2 zone or script uses (HoennB2 put Birch's bag on the same sheet); Pearl's lowest row 29
  moves to 30, the box's.
- Team Galactic (user 2026-10-25: "why are the team galactic folks using team plasma sprites lets switch those over
  to their actual sprites please"), 12 frames each as Rowan's:
  - Grunts (SPRITE_GINGAM / GINGAW, mmodel 103 'gingam' / 104 'gingaw') -> codes 293 / 294, Black 2's Team Plasma
    grunts: only Unova's story places them (Plasma zones, the PWT's opening scene with Cheren); no Sinnoh zone.
  - Cyrus (SPRITE_GINGABOSS, mmodel 99 'gingaboss') -> code 94, Black 2's Grimsley (the Unova League rooms only).
  - Mars (SPRITE_GKANBU1, mmodel 100 'gkanbu1') -> code 90, Skyla's Black 1 sheet (no Black 2 zone, script or table).
  - Jupiter (SPRITE_GKANBU3, mmodel 102 'gkanbu3') -> code 102, a placeholder sheet (a cross; nothing uses it).
  - Saturn (SPRITE_GKANBU2, mmodel 101 'gkanbu2') -> code 92, Iris's Black 1 sheet (nothing uses it). His old
    stand-in 178 (Cress) stays Cress: the PWT's Unova Leaders tournament shows it (a/2/4/7 record 10), and the PWT
    goes into Sinnoh's Battle Frontier (DECISIONS 2026-10-25).
  None of these codes is in the PWT's table (a/2/4/7, checked here), Black 2's battle-facility class table
  (ov012 BtlInst_GetTrainerClassObjCode), its Union Room looks (union_view.c) or named in its C (pokebw2_latest).
- The Elite Four, the battle partners and Palmer (2026-10-25, DECISIONS: named Diamond/Pearl characters without an
  official Black 2 sprite use Pearl's own), 12 frames each as Rowan's. Their stand-ins (Cilan 85 and Chili 179, which
  the PWT's table shows; Shauntal 93; Black 2 people on shared codes 29, 32, 35, 53; Benga 304, 299, 358) gave way to
  codes of their own that no kept Black 2 zone uses: no Black 2 zone, script, table or C at all for 87, 88, 106
  (Black 1 leader sheets and an unused man), 122 and 373 (unused walking Keldeo); 289 (a Nimbasa script's only), 99,
  300 (Driftveil's), 107 (Nimbasa's) and 207 (two Unova zones'), all now Sinnoh zones:
  Aaron (SPRITE_BIGFOUR1, mmodel 113) -> 87, Bertha (BIGFOUR2, 114) -> 88, Flint (BIGFOUR3, 115) -> 106, Lucian
  (BIGFOUR4, 116) -> 122, Cheryl (SEVEN1, 120) -> 373, Riley (SEVEN2, 121) -> 289, Marley (SEVEN3, 122) -> 99, Buck
  (SEVEN4, 123) -> 107, Mira (SEVEN5, 124) -> 300, Palmer (TOWERBOSS, 148) -> 207. Each is a 12-frame walker (scene
  node 2, controller 3, 32 x 32, as the Galactic codes). Checked here as Team Galactic's: one Pearl sprite per code,
  none in the PWT's table.
- Professor Oak (SPRITE_OOKIDO 166, mmodel 145 'ookido'; Sandgem lab, Eterna, Pal Park, Route 224 after the League;
  2026-10-25, the world sprite pass) had Cedric Juniper (104) -> code 89, Black 1's Clay sheet (12 frames): no Black
  2 zone, script (res/field events and scripts), table (PWT a/2/4/7, ov012 BtlInst_GetTrainerClassObjCode,
  union_view.c) or C names it.
- The Galactic HQ door (SPRITE_GINGA_DOOR 202: one half of a sliding door, two per doorway, which Pearl's scripts slide
  aside with WalkFast and remove; mmodel 369 'ginga_door', a 16 x 32 texture with its own billboard model) -> code
  292, a one-frame 32 x 32 ball no Black 2 zone, script or table uses (Black 2's billboards are 32 x 32, 16 x 16 or
  64 x 64: fldmmdl_drawdata.c): Pearl's 16 x 32 picture in the middle columns 8-23, the width of the door's own tile,
  rows 0-31 as Pearl's. The door's colour 0 is opaque in Pearl (22 pixels: its top edge) and transparent in a Black 2
  sheet, so those pixels take a spare colour slot with the same colour. As Pearl's door (pokeplatinum
  object_event_gfx_data.c: no shadow, no reflection), code 292's record (a/0/4/7) gets shadow and reflections off.
- Pearl's field objects (lead 2026-10-25, the user's art rule; they had Black 2 stand-ins), one picture each
  (OBJECTS), on every frame of their sheet: the Rock Smash rock (SPRITE_BREAKROCK 85, mmodel 83 'breakrock') ->
  code 186, the Moss Rock (190, mmodel 168 'moss') -> 371, the Ice Rock (191, mmodel 169 'freezes') -> 188, the
  bollard (SPRITE_POLE 192, mmodel 170 'pole') -> 189: codes no Black 2 zone, script (res/field events and ActorNew),
  table (PWT, battle facilities, Union Room) or C names (186: a one-frame object; 371: a numbered test sheet; 188, 189:
  two of Black 1's Sages); and the Cut tree (SPRITE_TREE 86, mmodel 84 'tree') -> code 108, Black 2's own Cut tree,
  because the party menu's Cut needs that code in front of the player (ov012 hiden_event.c: objCode ==
  OBJ_CODE_108); its Black 2 users are Unova routes whose zones Sinnoh's maps took (route 2, 13, 16, 23, Dreamyard,
  Victory Road 18, Virbank Complex 2) and White Treehollow. Pearl's 16 x 16 rocks sit in the 32 x 32 frame where
  Black 2 draws its own one-tile rock (code 206: columns 9-22, rows 17-30, centred, standing on row 30); the 32 x 32
  tree and bollard keep their place, 1 pixel lower as the people. Pearl's palettes have 8 or 16 colours (the rest 0).
- Pearl's Strength boulder (SPRITE_ROCK 84, mmodel 82 'rock', 16 x 16, one tile; lead 2026-10-26, DECISIONS) ->
  code 109, Black 2's own 1 x 1 Strength rock (OBJ_CODE_STRENGTH_ROCK): Black 2's Strength code already takes it as a
  boulder (ov012 fldmmdl.c IsNPCStrengthRock) and reads the footprint from its record (collWidth/Height 1: ov036
  StrengthRockSpaceCheck, ov012 field_actor_tool.c CheckBlockedCollPathToPosition / CheckAreaOverActor), so no C
  change. In Black 2 its record is type "none" (invisible, no sheet) and no zone or script places it. It gets the
  record of code 101 (a Black 1 Sage, 7 frames, scene node 2, controller 2, shadow and reflection on as Pearl's
  boulder; no Black 2 zone, script, work value, table or C names 101) with uid 109, no gender, 1 x 1, and 101's sheet
  gets Pearl's boulder on every frame, placed as the Rock Smash rock. 101 itself stays unused. Black 2's own 2 x 2
  boulders (3D 8195 / 8197) are untouched.
Pearl's frames sit 1 pixel higher in the box than Black 2's (feet on row 29 / 30): moved down 1, as the player's.
Each sheet takes the Pearl sprite's 16 colours.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio, sprites  # noqa: E402
from pearl_player_sprites import MMODEL, shift, SHIFT_DOWN  # noqa: E402

# (who, Pearl graphics id, Pearl mmodel file, texture name)
PEOPLE = [('Rowan', 99, 94, 'doctor'), ('Mom', 140, 119, 'mama'), ("Barry's mom (and Pearl's middle-aged women)",
                                                                   16, 15, 'middlewoman1'),
          ('Barry', 148, 127, 'rivel'), ("Rowan's briefcase", 174, 153, 'bag'),
          ('Cyrus', 120, 99, 'gingaboss'), ('Mars', 121, 100, 'gkanbu1'), ('Saturn', 122, 101, 'gkanbu2'),
          ('Jupiter', 123, 102, 'gkanbu3'), ('Galactic grunt (M)', 124, 103, 'gingam'),
          ('Galactic grunt (F)', 125, 104, 'gingaw'),
          ('Aaron', 134, 113, 'bigfour1'), ('Bertha', 135, 114, 'bigfour2'), ('Flint', 136, 115, 'bigfour3'),
          ('Lucian', 137, 116, 'bigfour4'), ('Cheryl', 141, 120, 'seven1'), ('Riley', 142, 121, 'seven2'),
          ('Marley', 143, 122, 'seven3'), ('Buck', 144, 123, 'seven4'), ('Mira', 145, 124, 'seven5'),
          ('Palmer', 169, 148, 'towerboss'), ('Professor Oak', 166, 145, 'ookido')]
GALACTIC = {120, 121, 122, 123, 124, 125, 202}       # graphics ids whose codes must stay out of the PWT's table
NAMED = {134, 135, 136, 137, 141, 142, 143, 144, 145, 169, 166}   # the Elite Four, the partners, Palmer, Oak: the same check
# Pearl's Galactic HQ door: (who, graphics id, mmodel file, texture name), its 16 x 32 picture at (DOOR_X, 0)
DOOR = ('Galactic HQ door', 202, 369, 'ginga_door')
# Pearl's field objects: (what, graphics id, mmodel file, texture name), one picture on every frame of their code's sheet
OBJECTS = [('Rock Smash rock', 85, 83, 'breakrock'), ('Moss Rock', 190, 168, 'moss'), ('Ice Rock', 191, 169, 'freezes'),
           ('bollard', 192, 170, 'pole'), ('Cut tree', 86, 84, 'tree')]
# Pearl's Strength boulder: (what, graphics id, mmodel file, texture name), its code (Black 2's 1 x 1 Strength rock)
# and the code whose record and sheet it takes
BOULDER = ('Strength boulder', 84, 82, 'rock')
STRENGTH_ROCK, BOULDER_SHEET = 109, 101
ROCK_BOX = (9, 22, 30)                               # code 206's rock: columns 9-22, bottom row 30 (a one-tile object)
# Pearl's legendary Pokémon of the story (2026-10-26, chapter 7; the user's art rule): (who, graphics id, mmodel file,
# texture name): Pearl's two frames (a flutter, facing the player) on each frame pair of Black 2's own sheet for the
# species (6 frames: 0-1, 2-3 and 4-5 are its three ways; the same size as Pearl's), Pearl's colours, pixel for pixel
# (their lowest rows match Black 2's: Palkia's both 62). Turned up or sideways they show their front, as Pearl's do.
POKEMON = [('Palkia', 155, 134, 'sppoke5'), ('Uxie', 151, 130, 'sppoke1'), ('Mesprit', 152, 131, 'sppoke2'),
           ('Azelf', 153, 132, 'sppoke3')]
# Pearl draws the lake trio 24 units above their tile, wherever they are (pokediamond ov05_021F0514.s: graphics ids
# 0x97-0x99 take the draw table ov05_021F8D1C, whose init ov05_021F1BD0 sets the sprite offset (0, 24, 0);
# pokeplatinum ov5_021ECB34, MapObject_SetSpritePosOffset): in the Galactic HQ lab they float in the containment
# units' chamber (its floor 20 units up, behind the orange glass), in the caverns over the ground. Black 2's record
# offset (FieldActorConfig.wPosOffsetY, whole units: CopyActorPosAllAdd) does the same for the billboard; its shadow
# would go up with it (fldeff_shadow.c adds the offset), Pearl's stays on the ground (its shadow takes the object's
# position): no shadow for them (2026-10-26).
FLOAT_Y = {'Uxie': 24, 'Mesprit': 24, 'Azelf': 24}
# In the Galactic HQ lab, 16 instead (user 2026-10-26: "tune the lab only so Uxie, Mesprit and Azelf's heads stay inside
# the units"): Black 2's camera is lower than Pearl's and its sprite passes geometry up to ~9 units nearer, so at 24
# their heads (Pearl's art fills rows 1-30 of 32: 25 units) show over the domes, which Pearl's look hides (offline,
# room_look_check from four tiles: heads inside from 16 down, bodies still behind the glass; work/agents/labtrio).
# The lab's objects take codes of their own (data/pearl_sprite_map.json "zone_codes": 156-158, Black 2 codes no zone,
# script, table or C names), each a copy of the species' record (its sheet, no shadow) with this offset.
ZONE_FLOAT_Y = {'MAP_VEILSTONE_GALACTIC_HEADQUARTERS_4F_BACK': 16}
# Mt. Coronet 2F's wall with the cave painting (SPRITE_T5_O01_C 203, mmodel 370, 2026-10-26, chapter 7): it stands on
# the mat to the upper mountain until the lake trio are freed (flag 0x253); Pearl's two 64 x 32 textures, the bricks
# and the painting of the three over them, as one 64 x 32 picture at the bottom of a 64 x 64 frame. Code 4637 (Black
# 2's Giratina Origin Forme walker, 6 frames of 64 x 64: no Black 2 zone, script or Pearl place shows it; Pearl's
# Giratina is the Altered Forme, 4636), every frame the same picture, no shadow or reflection (a wall).
WALL = ('cave-painting wall', 203, 370, ('t5_o01_c', 't5_o01_c_'))
DOOR_X = 8
ARC_PWT = 247                                        # a/2/4/7: the PWT's trainers, u16 x 8 records, object code at +2
LAYOUT = {1: [0], 12: [d * 4 + k for d in range(4) for k in (0, 1, 3)],
          7: [0, 1, 4, 5, 8, 9, 11],
          # Hugh's sheet: the 12 walking frames, then 5 poses only Black 2's own story uses -> Pearl's standing frames
          17: [d * 4 + k for d in range(4) for k in (0, 1, 3)] + [8, 12, 4, 4, 4]}


def pearl_object(btx):
    """A Pearl one-picture object as a Black 2 32 x 32 frame: (indices, 16 BGR555 colours). Pearl's object palettes
    can hold fewer than 16 colours (sprites.btx_decode reads 16)."""
    import struct
    (name, w, h, off), = sprites.btx_layout(btx)[0]
    poff = sprites.btx_layout(btx)[2]
    n = min(16, (len(btx) - poff) // 2)
    pal = list(struct.unpack_from(f'<{n}H', btx, poff)) + [0] * (16 - n)
    pix = sprites.unpack4(btx[off:off + w * h // 2], w * h)
    assert max(pix) < n, name
    ys = [i // w for i, v in enumerate(pix) if v]
    xs = [i % w for i, v in enumerate(pix) if v]
    if (w, h) == (16, 16):                           # a one-tile object: where Black 2 draws its own rock (206)
        x0, x1, bottom = ROCK_BOX
        dx = round((x0 + x1) / 2 - (min(xs) + max(xs)) / 2)
        dy = bottom - max(ys)
    else:
        assert (w, h) == (32, 32), name
        dx, dy = 0, SHIFT_DOWN
    out = bytearray(32 * 32)
    for i, v in enumerate(pix):
        if v:
            x, y = i % w + dx, i // w + dy
            assert 0 <= x < 32 and 0 <= y < 32, name
            out[y * 32 + x] = v
    return bytes(out), pal


def btx_textures(btx):
    """{texture name: (w, h, 4 bpp indices, 16 BGR555 colours)} of a Pearl BTX0 whose textures each have a palette of
    their own, named texture + '_pl' (mmodel 370)."""
    t0 = btx.find(b'TEX0')
    t = btx[t0:]
    paldict, paldata = struct.unpack_from('<II', t, 0x34)
    pals = dict(sprites._dict(t, paldict))
    out = {}
    for name, ent in sprites._dict(t, struct.unpack_from('<H', t, 0xE)[0]):
        p = struct.unpack_from('<I', ent, 0)[0]
        fmt, w, h = p >> 26 & 7, 8 << (p >> 20 & 7), 8 << (p >> 23 & 7)
        assert fmt == 3, (name, fmt)
        off = t0 + struct.unpack_from('<I', t, 0x14)[0] + ((p & 0xffff) << 3)
        po = t0 + paldata + (struct.unpack_from('<H', pals[name + '_pl'], 0)[0] << 3)
        n = min(16, (len(btx) - po) // 2)
        out[name] = (w, h, sprites.unpack4(btx[off:off + w * h // 2], w * h),
                     list(struct.unpack_from(f'<{n}H', btx, po)) + [0] * (16 - n))
    return out


def pearl_wall(mm):
    """Pearl's cave-painting wall as a 64 x 64 frame: (indices, 16 BGR555 colours): the bricks (all opaque), the
    painting's opaque pixels over them (its colours after the bricks' in the palette), at the bottom of the frame."""
    _, _, mid, (bricks, painting) = WALL
    tex = btx_textures(mm[mid])
    w, h, bp, pal = tex[bricks]
    w2, h2, pp, ppal = tex[painting]
    assert (w, h, w2, h2) == (64, 32, 64, 32), (w, h, w2, h2)
    pal = list(pal)
    used = sorted(set(bp) - {0})
    nxt = max(used) + 1
    remap = {}
    for v in sorted(set(pp) - {0}):
        remap[v] = nxt
        pal[nxt] = ppal[v]
        nxt += 1
    opaque0 = nxt                                   # the bricks' colour 0 is opaque in Pearl (its texture's
    pal[opaque0] = pal[0]                           # "colour 0 transparent" bit is off; the painting's is on), as
    nxt += 1                                        # the HQ door's: its pixels take a slot of their own
    assert nxt <= 16, nxt
    out = bytearray(64 * 64)
    for i in range(w * h):
        out[(64 - h) * 64 + i] = remap[pp[i]] if pp[i] else (bp[i] or opaque0)
    return bytes(out), pal


def pwt_codes(files):
    """Object codes the PWT's trainer table (a/2/4/7) shows."""
    t = narcio.load(files, ARC_PWT)[0]
    return {struct.unpack_from('<H', t, 16 * i + 2)[0] for i in range(len(t) // 16)}


def pearl_door(mm):
    """Pearl's HQ door half as a Black 2 frame: (32 x 32 indices, 16 BGR555 colours). Its texture is 4 bpp 16 x 32
    with colour 0 opaque (sprites.btx_decode takes only sheets whose colour 0 is clear): colour 0's pixels move to the
    first slot the door does not use, given colour 0's colour."""
    who, _, mid, tex = DOOR
    btx = mm[mid]
    t0 = struct.unpack_from('<I', btx, 0x10)[0]
    t = btx[t0:]
    assert t[:4] == b'TEX0', who
    (name, ent), = sprites._dict(t, struct.unpack_from('<H', t, 0xE)[0])
    p = struct.unpack_from('<I', ent, 0)[0]
    fmt, w, h = p >> 26 & 7, 8 << (p >> 20 & 7), 8 << (p >> 23 & 7)
    assert (name, fmt, w, h) == (tex, 3, 16, 32), (who, name, fmt, w, h)
    off = t0 + struct.unpack_from('<I', t, 0x14)[0] + ((p & 0xffff) << 3)
    pix = sprites.unpack4(btx[off:off + w * h // 2], w * h)
    paldict, paldata = struct.unpack_from('<II', t, 0x34)
    (_, pent), = sprites._dict(t, paldict)
    pal = list(struct.unpack_from('<16H', btx, t0 + paldata + (struct.unpack_from('<H', pent, 0)[0] << 3)))
    spare = min(set(range(1, 16)) - set(pix))
    pal[spare] = pal[0]
    out = bytearray(32 * 32)
    for y in range(h):
        out[y * 32 + DOOR_X:y * 32 + DOOR_X + w] = bytes(spare if v == 0 else v for v in pix[y * w:(y + 1) * w])
    return bytes(out), pal


def apply(files):
    import version
    from gen4rom import Rom, narc_members
    smap = json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json')))
    mm = narc_members(Rom(version.SOURCE_DUMP).read(MMODEL))
    sheets = narcio.load(files, sprites.ARC_OW_SHEETS)
    table = sprites.ow_table(files)
    pwt = pwt_codes(files)
    done = []

    def own_code(who, gfx):
        """The code of a Pearl graphics id, checked to be that id's alone (and, for Team Galactic, not the PWT's)."""
        code = smap[str(gfx)]['code']
        users = [k for k, v in smap.items() if isinstance(v, dict) and v.get('code') == code]
        assert users == [str(gfx)], (who, code, users)
        assert gfx not in GALACTIC | NAMED or code not in pwt, f'{who}: code {code} is in the PWT\'s table (a/2/4/7)'
        return code

    for who, gfx, mid, tex in PEOPLE:
        code = own_code(who, gfx)
        fr, _, pal = sprites.btx_decode(mm[mid])
        fr = sorted(fr, key=lambda f: int(f[0].split('.')[-1]) if '.' in f[0] else 0)   # (the bag: one, 'bag')
        assert len(fr) in (1, 16) and all(f[0].rsplit('.', 1)[0] == tex and (f[1], f[2]) == (32, 32) for f in fr), who
        sheet, _ = sprites.ow_sheet_of(files, code, table)
        lay, _, _ = sprites.btx_layout(sheets[sheet])
        order = LAYOUT[len(lay)]
        assert all((w, h) == (32, 32) for _, w, h, _ in lay), who
        pix = [shift(fr[i][3], SHIFT_DOWN) for i in order]
        sheets[sheet] = sprites.btx_encode(sheets[sheet], pix, pal)
        done.append(f'{who} = code {code} (sheet {sheet}, {len(lay)} frames)')
    who, gfx, _, _ = DOOR
    code = own_code(who, gfx)
    sheet, _ = sprites.ow_sheet_of(files, code, table)
    lay, _, _ = sprites.btx_layout(sheets[sheet])
    assert [(w, h) for _, w, h, _ in lay] == [(32, 32)], who
    pix, pal = pearl_door(mm)
    sheets[sheet] = sprites.btx_encode(sheets[sheet], [pix], pal)
    rec = narcio.load(files, sprites.ARC_OW_TABLE)
    t = bytearray(rec[0])
    at = 4 + 28 * sprites.obj_record(code)
    assert struct.unpack_from('<H', t, at)[0] == code, who
    t[at + 4] = t[at + 6] = 0                       # shadow, reflections (sprites.ow_table's record fields)
    rec[0] = bytes(t)
    narcio.save(files, sprites.ARC_OW_TABLE, rec)
    done.append(f'{who} = code {code} (sheet {sheet}, 1 frame; no shadow or reflection)')
    for who, gfx, mid, tex in OBJECTS:
        code = own_code(who, gfx)
        assert code not in pwt, f'{who}: code {code} is in the PWT\'s table (a/2/4/7)'
        sheet, _ = sprites.ow_sheet_of(files, code, table)
        lay, _, _ = sprites.btx_layout(sheets[sheet])
        assert all((w, h) == (32, 32) for _, w, h, _ in lay), who
        assert sprites.btx_layout(mm[mid])[0][0][0] == tex, who
        pix, pal = pearl_object(mm[mid])
        sheets[sheet] = sprites.btx_encode(sheets[sheet], [pix] * len(lay), pal)
        done.append(f'{who} = code {code} (sheet {sheet}, {len(lay)} frames)')
    who, gfx, mid, tex = BOULDER
    code = own_code(who, gfx)
    assert code == STRENGTH_ROCK, f'{who}: code {code}, not Black 2\'s 1 x 1 Strength rock {STRENGTH_ROCK}'
    assert not any(isinstance(v, dict) and v.get('code') == BOULDER_SHEET for v in smap.values()), BOULDER_SHEET
    assert code not in pwt and BOULDER_SHEET not in pwt, who
    rec = narcio.load(files, sprites.ARC_OW_TABLE)
    t = bytearray(rec[0])
    at, src = (4 + 28 * sprites.obj_record(c) for c in (code, BOULDER_SHEET))
    # record bytes: uid 0, type 2, scene node 3, shadow 4, footprint 5, reflections 6, billboard 7, atlas 8,
    # controller 9, gender 10, collision width 11 / height 12, offsets 13-15, sheet (res1) 16
    assert struct.unpack_from('<HB', t, at) == (code, 0), f'{who}: code {code} is no longer an invisible record'
    assert struct.unpack_from('<HBBB', t, src)[:2] == (BOULDER_SHEET, 1), who
    sheet = struct.unpack_from('<H', t, src + 16)[0]
    assert [r['res1'] for r in table if r['entityType'] == 1].count(sheet) == 1, f'{who}: sheet {sheet} is shared'
    lay, _, _ = sprites.btx_layout(sheets[sheet])
    assert all((w, h) == (32, 32) for _, w, h, _ in lay), who
    assert sprites.btx_layout(mm[mid])[0][0][0] == tex, who
    pix, pal = pearl_object(mm[mid])
    sheets[sheet] = sprites.btx_encode(sheets[sheet], [pix] * len(lay), pal)
    t[at + 2:at + 28] = t[src + 2:src + 28]
    t[at + 10] = 2                                  # no gender (an object)
    assert t[at + 11] == t[at + 12] == 1 and t[at + 13:at + 16] == b'\0\0\0', f'{who}: not 1 x 1'
    rec[0] = bytes(t)
    narcio.save(files, sprites.ARC_OW_TABLE, rec)
    done.append(f'{who} = code {code} (1 x 1, the record and sheet {sheet} of code {BOULDER_SHEET}, {len(lay)} frames)')
    for who, gfx, mid, tex in POKEMON:
        code = own_code(who, gfx)
        fr, _, pal = sprites.btx_decode(mm[mid])
        fr = sorted(fr, key=lambda f: int(f[0].split('.')[-1]))
        assert [f[0] for f in fr] == [f'{tex}.1', f'{tex}.2'], who
        sheet, _ = sprites.ow_sheet_of(files, code, table)
        lay, _, _ = sprites.btx_layout(sheets[sheet])
        assert len(lay) == 6 and all((w, h) == (fr[0][1], fr[0][2]) for _, w, h, _ in lay), who
        sheets[sheet] = sprites.btx_encode(sheets[sheet], [fr[0][3], fr[1][3]] * 3, pal)
        done.append(f'{who} = code {code} (sheet {sheet}, 6 frames from Pearl\'s 2)')
        if who in FLOAT_Y:
            rec = narcio.load(files, sprites.ARC_OW_TABLE)
            t = bytearray(rec[0])
            at = 4 + 28 * sprites.obj_record(code)
            assert struct.unpack_from('<H', t, at)[0] == code and t[at + 13:at + 16] in (bytes(3), bytes((0, FLOAT_Y[who], 0))), who
            t[at + 14] = FLOAT_Y[who]               # wPosOffsetY (s8, units)
            t[at + 4] = 0                           # shadow
            rec[0] = bytes(t)
            narcio.save(files, sprites.ARC_OW_TABLE, rec)
            done[-1] = done[-1][:-1] + f'; drawn {FLOAT_Y[who]} units up as Pearl\'s, no shadow)'
            for zone, zcode in smap[str(gfx)].get('zone_codes', {}).items():   # (a zone's own copy: the lab's)
                users = [k for k, v in smap.items() if isinstance(v, dict)
                         and (v.get('code') == zcode or zcode in v.get('zone_codes', {}).values())]
                assert users == [str(gfx)] and zcode not in pwt, (who, zone, zcode, users)
                zat = 4 + 28 * sprites.obj_record(zcode)
                assert struct.unpack_from('<H', t, zat)[0] == zcode, (who, zcode)
                t[zat + 2:zat + 28] = t[at + 2:at + 28]  # the species' record: its sheet, no shadow
                t[zat + 14] = ZONE_FLOAT_Y[zone]
                rec[0] = bytes(t)
                narcio.save(files, sprites.ARC_OW_TABLE, rec)
                done.append(f'{who} in {zone[4:]} = code {zcode} (the record of {code}, drawn {ZONE_FLOAT_Y[zone]} '
                            f'units up)')
    who, gfx, _, _ = WALL
    code = own_code(who, gfx)
    sheet, _ = sprites.ow_sheet_of(files, code, table)
    lay, _, _ = sprites.btx_layout(sheets[sheet])
    assert all((w, h) == (64, 64) for _, w, h, _ in lay), who
    pix, pal = pearl_wall(mm)
    sheets[sheet] = sprites.btx_encode(sheets[sheet], [pix] * len(lay), pal)
    rec = narcio.load(files, sprites.ARC_OW_TABLE)
    t = bytearray(rec[0])
    at = 4 + 28 * sprites.obj_record(code)
    assert struct.unpack_from('<H', t, at)[0] == code, who
    t[at + 4] = t[at + 6] = 0                       # shadow, reflections (a wall)
    rec[0] = bytes(t)
    narcio.save(files, sprites.ARC_OW_TABLE, rec)
    done.append(f'{who} = code {code} (sheet {sheet}, {len(lay)} frames; no shadow or reflection)')
    narcio.save(files, sprites.ARC_OW_SHEETS, sheets)
    return 'pearl_npc_sprites: ' + '; '.join(done)
