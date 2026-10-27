"""Pearl's signposts, signboards and mailboxes as Black 2's own sign models in the maps (user 2026-10-19,
notes/DECISIONS.md: "Black 2's signboard models in the maps with plain sign events"; 2026-10-20: the notice-board
person that stood in for them looked awkward).

    python3 b2tools/pearl_signs.py            the census: signs per kind, per chunk, anything that can't be placed

Pearl's signs are objects (graphics 91-96: a 3D board, pokeplatinum object_event_gfx_data.c MODEL_TYPE_3D, drawn 2
units north of the tile) that block their tile and run their script when talked to from any side (field_control.c:
any object in front, sub_0203CA40; walking into one facing north reads it too, sub_0203CBE0). Black 2 has no sign
actor: its signs are a building model in the chunk, a sign event (BG event) on the model's tile and a solid tile.
Here, for every sign object of every Pearl map (copies of a neighbour's sign, script 0xFFFF, stand on the
original's tile and give no second model):
- model: the Black 2 sign Black 2 pairs with the window Pearl's sign opens (measured over Black 2's own maps, pack 0
  models at the BG event's tile: town window 1 = sign02, route window 3 = sign04, Trainer Tips window 0 = sign01,
  landmark window 2 = sign03; Black 2's Gym and house signs have no model of their own, Opelucid's house signs use
  sign03):
      91 map signpost (town sign)  -> sign02, the metal town board          (Pearl sign type 0 -> window 1)
      94 arrow signpost (route)    -> sign04, the wooden route board        (type 1 -> window 3)
      96 Trainer Tips              -> sign01, the notice board              (type 3 -> window 0)
      95 Gym signpost              -> sign01, the notice board              (type 3 -> window 0, as Trainer Tips)
      93 signboard (landmark)      -> sign03, the white plaque              (type 2 -> window 2)
      92 mailbox ("X's house")     -> sign03, Black 2's house-sign plaque   (type 2 -> window 2)
  Black 2's boards are 26 units wide (x -13..13, 30 high) and stand over 3 tiles (its maps block the 3); Pearl's
  signs fill one tile (17-24 wide, 23-40 high) and block one. So the boards are fitted to Pearl's tile: 0.65 as wide
  and deep (17 units) and 0.85 as high (27.5); the plaque (16 wide, 16 high) is Black 2's size, on one tile as in
  Black 2. Heights scale from the shadow decal, which stays 2 units over the ground (notes/MAP_LOOK.md: layers 2
  apart; the shadow reaches 4 units east of the body, lit from the west). Each stands at its tile's centre on the
  tile's height (the converted chunk's), turned 0 (facing south, the camera), as Black 2 places its own.
- textures: the models' own (Black 2 exterior pack 0's texture set), renamed b2s_* so they stand beside Pearl's
  same-named ones in a pack's set (Pearl's h_kage is 16x16 opaque, Black 2's 8x8 A3I5).
- each pack (overworld: all 13, one area per field stays loaded wherever you walk; rooms: the packs of room areas
  whose matrix has a sign) gets the 4 models with resIds RES (above every Pearl id; Black 2 looks resIds up in 512).
- the chunk: the sign's tile SOLID (Black 2's wall class), and a placement.
- the sign event (pearl_events.entities): the object's script, direction 4 (any side, as Pearl's objects), y from
  the tile (pearl_events.Heights.sign_y), in the zone whose story is installed (sinnoh_story).
Hooks: patches/sinnoh_world.py and patches/sinnoh_rooms.py call chunk() for every chunk and models() for every pack.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
PEARL = os.path.join(ROOT, 'work', 'pearl')
VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')

SIGN_GFX = {91, 92, 93, 94, 95, 96}
COPY_SCRIPT = 0xFFFF
KIND = {91: 'sign02', 92: 'sign03', 93: 'sign03', 94: 'sign04', 95: 'sign01', 96: 'sign01'}
B2_PACK = 0                                                       # Black 2 exterior pack holding the four (all do)
B2_RES = {'sign01': 151, 'sign02': 152, 'sign03': 153, 'sign04': 154}
RES = {'sign01': 500, 'sign02': 501, 'sign03': 502, 'sign04': 503}   # their resIds in our packs
SCALE = {'sign01': (0.65, 0.85, 0.65), 'sign02': (0.65, 0.85, 0.65), 'sign04': (0.65, 0.85, 0.65),
         'sign03': (1.0, 1.0, 1.0)}                               # (x, y, z): see above
BASE_Y = 2.0                                                      # their shadow decal's height (kept)
PREFIX = 'b2s_'
SOLID = 0x01 | 0x81 << 16                                         # pearl_chunk.SOLID (class, flags)

_census = _models = None


def _json(*p):
    return json.load(open(os.path.join(*p)))


def census():
    """{'chunks': {Pearl chunk: {(tx, tz): (kind, gfx)}}, 'room_areas': {(b2_pack, exterior)}, 'problems': [...],
    'signs': [(zone name, matrix, x, z, gfx, chunk)]}: every Pearl sign object's tile, once per tile."""
    global _census
    if _census is not None:
        return _census
    zones = _json(PEARL, 'zones.json')
    world = _json(ROOT, 'data', 'sinnoh_world.json')
    rooms = world['rooms']
    ow = {int(k) for k in world['zones']}
    installed_mats = {0} | {r['pearl_matrix'] for r in rooms['zones'].values()}
    mats, tiles, problems, signs = {}, {}, [], []
    for z in zones:
        mid = 0 if z['id'] in ow else z['matrix']
        for o in _json(PEARL, 'events', f'{z["events"]:03d}.json')['object_events']:
            # (copies only draw their original before you cross: two of them stand a tile off it, Jublife's copy
            # of Route 203's sign at (198, 756) for (200, 756), Survival Area's of Route 226's (679, 340 / 341))
            if o['graphics_id'] not in SIGN_GFX or o['script'] == COPY_SCRIPT:
                continue
            key = (mid, o['x'], o['z'])
            if key in tiles:                             # (Route 204 North and South both have (170, 706))
                if tiles[key][0] != o['graphics_id']:
                    problems.append(f'{z["name"]} object {o["id"]} at {key[1:]}: graphics {o["graphics_id"]}, '
                                    f'another sign there is {tiles[key][0]}')
                continue
            tiles[key] = (o['graphics_id'], o['script'], z['name'])
    for mid in installed_mats | {mid for mid, _, _ in tiles}:
        mats[mid] = _json(PEARL, 'matrices', f'{mid:03d}.json')
    chunks, cells = {}, {}
    for (mid, x, z), (gfx, script, name) in sorted(tiles.items()):
        m = mats[mid]
        if not (0 <= x // 32 < m['width'] and 0 <= z // 32 < m['height']) or m['maps'][z // 32][x // 32] == 0xFFFF:
            problems.append(f'{name}: sign at {(x, z)} off matrix {mid}')
            continue
        c = m['maps'][z // 32][x // 32]
        if mid not in installed_mats:
            continue                                     # (a map not built: no chunk of it is installed)
        chunks.setdefault(c, {})[(x % 32, z % 32)] = (KIND[gfx], gfx)
        cells.setdefault(c, set()).add((mid, x // 32, z // 32))
        signs.append((name, mid, x, z, gfx, c))
    # a chunk is converted once: a sign in a chunk Pearl uses at several matrix cells would stand in all of them
    for c in cells:
        uses = {(mid, cx, cz) for mid in installed_mats for cz, row in enumerate(mats[mid]['maps'])
                for cx, cc in enumerate(row) if cc == c}
        if len(uses) > 1:
            problems.append(f'chunk {c} (signs at {sorted(chunks[c])}) is used at {sorted(uses)}: each gets its signs')
    room_areas = set()
    for r in rooms['zones'].values():
        if any(c in chunks for row in mats[r['pearl_matrix']]['maps'] for c in row):
            a = rooms['areas'][str(r['pearl_area'])]
            room_areas.add((a['b2_pack'], a['exterior']))
    _census = dict(chunks=chunks, room_areas=room_areas, problems=problems, signs=signs)
    return _census


# ------------------------------------------------------------------------------------------------ models

def _rename_dict(buf, off, names):
    """Rename the entries of the NNS resource dictionary at buf[off] (in order) and rebuild its Patricia tree."""
    import nsbtx
    cnt = buf[off + 1]
    assert len(names) == cnt
    ent = off + 8 + 4 * (cnt + 1)
    unit = struct.unpack_from('<H', buf, ent)[0]
    names_at = ent + 4 + unit * cnt
    for j, n in enumerate(names):
        assert len(n) <= 16, n
        buf[names_at + 16 * j:names_at + 16 * j + 16] = n.encode('ascii').ljust(16, b'\0')
    tree = b''.join(bytes(node) for node in nsbtx.dict_tree(names))
    assert len(tree) == 4 * (cnt + 1)
    buf[off + 8:off + 8 + len(tree)] = tree


def _dict_names(buf, off):
    import nsbtx
    return [n for n, _ in nsbtx._dict(buf, off)]


def model(kind):
    """BMD0 (MDL0 + TEX0) of a Black 2 sign fitted to one Pearl tile, its textures renamed b2s_*."""
    import b2files, nsbtx, pearl_mesh
    b = {x['res_id']: x for x in b2files.building_pack(VANILLA, B2_PACK)}[B2_RES[kind]]
    m = pearl_mesh.Model(b['bmd'])
    ps = m.pos_scale
    sx, sy, sz = SCALE[kind]
    by = BASE_Y * 4096 / ps
    for s in m.shapes:
        s.groups = [(t, [[v.moved(int(round(v[0] * sx)), int(round(by + (v[1] - by) * sy)),
                                  int(round(v[2] * sz))) for v in p] for p in polys]) for t, polys in s.groups]
    mdl = bytearray(m.encode())
    mats = m.m + m.omat
    tex_d, pal_d = struct.unpack_from('<HH', mdl, mats)
    texs, pals = _dict_names(mdl, mats + tex_d), _dict_names(mdl, mats + pal_d)
    _rename_dict(mdl, mats + tex_d, [PREFIX + n[:16 - len(PREFIX)] for n in texs])
    _rename_dict(mdl, mats + pal_d, [PREFIX + n[:16 - len(PREFIX)] for n in pals])
    src = b2files.building_textures(VANILLA, B2_PACK)
    pairs = sorted(nsbtx.material_pairs(b['bmd']))
    btx = nsbtx.merge(src, [(src, t, p, PREFIX + t[:16 - len(PREFIX)], p and PREFIX + p[:16 - len(PREFIX)])
                            for t, p in pairs], keep_base=False)
    tex0 = nsbtx.tex0(btx)
    import pearl_buildings
    mdl0 = pearl_buildings.blocks(bytes(mdl))[b'MDL0']
    head = bytearray(mdl[:0x10])
    struct.pack_into('<IHH', head, 8, 0x18 + len(mdl0) + len(tex0), 0x10, 2)
    return bytes(head) + struct.pack('<II', 0x18, 0x18 + len(mdl0)) + mdl0 + tex0


def models(area=None):
    """[(resId, BMD0)] to add to a building pack: every overworld pack (area None); a room area's pack (its record
    from data/sinnoh_world.json rooms.areas) only when its matrix has a sign."""
    global _models
    if area is not None and (area['b2_pack'], area['exterior']) not in census()['room_areas']:
        return []
    if _models is None:
        _models = [(RES[k], model(k)) for k in sorted(RES)]
    return list(_models)


# ------------------------------------------------------------------------------------------------ chunks

def chunk(c, terrain, place, rep):
    """A converted chunk's (terrain, placements) with Pearl chunk c's signs: their tiles solid, their models placed.
    rep: pearl_chunk.convert's report (tile heights; the sign tiles leave its walkable list: fly points)."""
    here = census()['chunks'].get(c)
    if not here:
        return terrain, place
    t = bytearray(terrain)
    n = struct.unpack_from('<I', place, 0)[0]
    out = [place[4:]]
    for (tx, tz), (kind, gfx) in sorted(here.items()):
        struct.pack_into('<I', t, 4 + 8 * (tz * 32 + tx) + 4, SOLID)
        rep.get('walkable', {}).pop((tx, tz), None)
        y = rep['heights'].get((tx, tz), 0)
        x, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
        out.append(struct.pack('<iiiH', x * 4096, round(y * 4096), -z * 4096, 0) + struct.pack('>H', RES[kind]))
        n += 1
    return bytes(t), struct.pack('<I', n) + b''.join(out)


if __name__ == '__main__':
    import collections
    cs = census()
    by = collections.Counter((g, KIND[g]) for _, _, _, _, g, _ in cs['signs'])
    print(f'{len(cs["signs"])} sign tiles in installed maps, {len(cs["chunks"])} chunks; by Pearl graphics -> model:')
    for (g, k), v in sorted(by.items()):
        print(f'  {g} -> {k} (res {RES[k]}): {v}')
    print('room packs with signs:', sorted(cs['room_areas']))
    for k in sorted(RES):
        bmd = model(k)
        print(f'  {k}: {len(bmd)} bytes')
    print('problems:', cs['problems'] or 'none')
