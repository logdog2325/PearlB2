"""Black 2's water and grass ground on Pearl's map shapes (2026-10-26; the user: "I want the game to look like gen 4
remade in gen 5's beautiful art style"; notes/MAP_LOOK.md "Black 2's water and grass").

Pearl's ponds, lakes, sea and cave water are flat or nearly flat colours (puddle/puddle_b one colour each, the caves'
water a plain plane under see-through texels), its grass a bright mint; the user chose Black 2's own after offline
before/after renders (work/agents/looks/shots/water_preview_sheet.png, grass_preview_sheet.png). Pearl's trees, tall
grass, rocks, shores and buildings stay Pearl's.

Water, as Black 2 builds it (measured on its own chunks): two layers that its area texture-SRT animation (a/0/6/8,
bound by MATERIAL NAME to every chunk model) scrolls against each other:
  sea   sea_mizu1 (opaque) under sea_mizu1_1 (the same texture at alpha 16, mirrored); SRT file 0 'area_ita_00'
  pond  mizu_sita2 (a sky and cloud reflection, opaque) under ike01 (light blue at alpha 12); SRT file 0
  cave  d0_miz (dark teal, unlit) under d0_miz2 (sparkles, cut-out, unlit); SRT file 3 'in00_dun_ita'
Pearl's water materials take Black 2's material records (Black 2's names, so the SRT finds them; its alpha, lights and
polygon ID) and world-aligned texture coordinates at Black 2's own density and offsets (the texture runs on across
chunk borders; Pearl's restart every polygon). Pearl's bases (sea, asasea, puddle_b, puddleb_x, dun_sea) become the
base layer, its see-through surfaces (puddle, puddle_x, lake, the lakes' l_lake prop) the surface; where Pearl has only
one of the two, the other is a copy GAP units above (a surface) or below (a base). puddle_b and puddle are a pond
outdoors and cave water in a cave (Verity, Valor and Acuity Caverns). The lakes' water is a prop in Pearl (build model
l_lake, one plane per chunk): it moves into the chunk model (placed_props leaves its placement out), so the area's SRT
animates it. Shores and edges (puddlep*, lakep.1, hamabe, beachp, seaside3, ...) stay Pearl's.

Grass: outdoors (the overworld and the outdoor rooms) Pearl's ground grass ngrass takes Black 2's grass01ax of the
season (64 x 64, one texel a unit, world-aligned; the record's texture size 64), its seasons Black 2's; Pearl's other
art with grass in it takes Black 2's grass colours (patches/sinnoh_reskin.py); indoor rooms (the Eterna Gym) keep
Pearl's.

MAPLOOK_FIXES names 'b2_water' and 'b2_grass' (b2tools/maplook.py; both in the default).
"""
import functools, json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import pearl_mesh  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
WATER_FIX, GRASS_FIX = 'b2_water', 'b2_grass'
GAP = 2.5                        # units between the two layers (the world pass's layer gap is 2.25)
MAX_MATERIALS = 50               # Black 2's SRT animation object per chunk holds 51 materials (0x80 bytes)
# Black 2 material -> (vanilla chunk holding its record, texture, palette, (s per unit, t per unit, s offset,
# t offset) of its texture coordinates in texels, as Black 2's own chunks map them)
B2_MATERIALS = {
    'sea_mizu1': (0, 'sea_mizu1', 'sea_mizu1_pl', (-0.5, -0.5, 0, 32)),
    'sea_mizu1_1': (0, 'sea_mizu1', 'sea_mizu1_pl', (0.5, 0.5, 0, 32)),
    'mizu_sita2': (11, 'mizu_sita2', 'mizu_sita2_pl', (0.5, 0.5, 0, 64)),
    'ike01': (11, 'ike01', 'ike01_pl', (1, 1, 0, 32)),
    'd0_miz': (486, 'd0_miz', 'd0_miz_pl', (1, 1, 0, 64)),
    'd0_miz2': (486, 'd0_miz2', 'd0_miz2_pl', (1, 1, 0, 16)),
}
KINDS = {'sea': ('sea_mizu1', 'sea_mizu1_1'), 'pond': ('mizu_sita2', 'ike01'), 'cave': ('d0_miz', 'd0_miz2')}
SRT = {'outdoor': 0, 'cave': 3}  # a/0/6/8: 'area_ita_00' (sea, ponds, rivers), 'in00_dun_ita' (cave water)
# Pearl texture -> (layer, kind; None: a pond outdoors, cave water in a cave)
PEARL_WATER = {'sea': ('base', 'sea'), 'asasea': ('base', 'sea'), 'puddle_b': ('base', None),
               'puddleb_x': ('base', 'pond'), 'dun_sea': ('base', 'cave'),
               'puddle': ('surface', None), 'puddle_x': ('surface', 'pond'), 'lake': ('surface', 'pond'),
               'l_lake': ('surface', 'pond')}
LAKE_PROPS = {311}               # Pearl build model l_lake (Lakes Verity, Valor, Acuity): moved into the chunk
GRASS = ('ngrass', 'grass01ax', 'grass01ax_pl', (1, 1, 0, 64), 64)
B2_SEASON_SETS = (2, 3, 4, 5)    # Black 2's spring..winter map texture sets (Aspertia's: its grass01ax per season)
B2_CAVE_SET = 296                # a cave set with d0_miz and d0_miz2
NORTH_AREA = 14                  # Pearl area 14 (the snowy north): winter all year (patches/sinnoh_reskin.py)


def fixes():
    import maplook
    return set(maplook.fixes())


def water_on():
    return WATER_FIX in fixes()


def grass_on():
    return GRASS_FIX in fixes()


@functools.lru_cache(maxsize=None)
def _world():
    return json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))


@functools.lru_cache(maxsize=None)
def outdoor_room_areas():
    """Pearl room areas lit by the outdoor day cycle (its area data u16 at 6 not 0) or exterior: the lakes, the
    moon islands, Pal Park, the Great Marsh, ... (sinnoh_rooms' day_light and seasonal groups)."""
    from gen4rom import Rom, narc_members
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    ad = narc_members(rom.read('fielddata/areadata/area_data.narc'))
    rooms = _world()['rooms']['areas']
    return frozenset(int(pa) for pa, a in rooms.items()
                     if struct.unpack_from('<H', ad[int(pa)], 6)[0] or a['exterior'])


@functools.lru_cache(maxsize=None)
def _room_chunk_areas():
    w = _world()
    out = {}
    for r in w['rooms']['zones'].values():
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f"{r['pearl_matrix']:03d}.json")))
        for row in m['maps']:
            for c in row:
                if c != 0xffff: out.setdefault(c, r['pearl_area'])
    return out


def place(chunk):
    """'outdoor' (the overworld's chunks and the outdoor rooms'), 'indoor' (caves and buildings) or None."""
    w = _world()
    if str(chunk) in w['chunks']: return 'outdoor'
    pa = _room_chunk_areas().get(chunk)
    if pa is None: return None
    return 'outdoor' if pa in outdoor_room_areas() else 'indoor'


def area_place(pearl_area, room=True):
    if not room: return 'outdoor'
    return 'outdoor' if pearl_area in outdoor_room_areas() else 'indoor'


@functools.lru_cache(maxsize=None)
def b2_records():
    """{Black 2 material: its material record bytes} from Black 2's own chunks."""
    import narcio
    from b2files import gf_container
    chunks = narcio.load(VANILLA, 8)
    out = {}
    for name, (ci, *_rest) in B2_MATERIALS.items():
        m = pearl_mesh.Model(gf_container(chunks[ci])[1][0])
        i = m.materials.index(name)
        at = m.mat_at[i]
        out[name] = m.data[at:at + struct.unpack_from('<H', m.data, at + 2)[0]]
    return out


def _uv(units, mapping):
    """(s, t) raw (1/16 texel) of a point in chunk units under (s per unit, t per unit, s offset, t offset)."""
    ks, kt, os_, ot = mapping
    return (int(round((units[0] * ks + os_) * 16)), int(round((units[2] * kt + ot) * 16)))


def _retexture(model, polys, mapping, dy_raw=0, unlit=False):
    """New vertices for polys [[Vertex]]: world-aligned texture coordinates (mapping), raised dy_raw, and for an
    unlit Black 2 material no NORMAL (the GX would colour the corner by the emission alone: black) but a white COLOR,
    as Black 2's own cave water. None if a raised position leaves the 16-bit range."""
    out = []
    for p in polys:
        q = []
        for v in p:
            y = v[1] + dy_raw
            if not -32768 <= y <= 32767: return None
            s, t = _uv(model.units(v), mapping)
            if not (-32768 <= s <= 32767 and -32768 <= t <= 32767): return None
            q.append(pearl_mesh.Vertex(v[0], y, v[2], s, t, None if unlit else v[5], 0x7FFF if unlit else v[6]))
        out.append(q)
    return out


def _groups(polys):
    return [(pearl_mesh.QUADS, [p for p in polys if len(p) == 4]), (pearl_mesh.TRIS, [p for p in polys if len(p) == 3])]


def _regroup(model, groups, mapping, dy_raw=0, unlit=False):
    """_retexture over a shape's groups, keeping each run's primitive type (strips stay strips where they still
    chain: a vertex's new coordinates depend on its position only), or None."""
    out = []
    for gtype, polys in groups:
        new = _retexture(model, polys, mapping, dy_raw, unlit)
        if new is None: return None
        out.append((gtype, new))
    return out


def _lake_polys(model, props):
    """[(primitive type, [[Vertex]])] of the chunk's lake props (LAKE_PROPS) in the chunk model's raw units, and the
    props moved in (placed_props leaves them out); ([], []) when one cannot be (rotated, scaled, out of range)."""
    import pearl_rooms_view as RV, pearl_buildings
    build, _ = RV.pearl_rom()
    groups, moved = [], []
    for k, p in enumerate(props or ()):
        if p['model'] not in LAKE_PROPS: continue
        if any(r % 0x10000 for r in p['rot']) or any(abs(s - 1) > 1e-3 for s in p['scale']): continue
        pm = pearl_mesh.Model(pearl_buildings.mdl_only(build[p['model']]))
        f = pm.pos_scale / model.pos_scale
        mine = []
        for s in pm.shapes:
            for gtype, polys in s.groups:
                run = []
                for q in polys:
                    vs = []
                    for v in q:
                        pos = [int(round(v[i] * f + p['pos'][i] * 4096 / model.pos_scale)) for i in range(3)]
                        if not all(-32768 <= x <= 32767 for x in pos): return [], []
                        vs.append(pearl_mesh.Vertex(pos[0], pos[1], pos[2], 0, 0, v[5], v[6]))
                    run.append(vs)
                mine.append((gtype, run))
        groups += mine; moved.append(k)
    return groups, moved


def _pearl_groups(chunk, names):
    """Pearl's own primitive runs [(type, [polygon])] of the materials named (the chunk's land model as Pearl has it)."""
    import pearl_chunk
    try:
        raw = pearl_chunk.pearl_model(chunk)
    except (OSError, AssertionError):
        return []
    return [g for sh in raw.shapes if sh.material is not None and raw.materials[sh.material] in names
            for g in sh.groups]


def swap(bmd, chunk, props=None):
    """(model bytes, report) with Black 2's water and (outdoors) grass. report: {'water': {kind: [Pearl material
    names]}, 'grass': [names], 'added': [new material names], 'lake_props': n, 'skipped': why}."""
    rep = {'water': {}, 'grass': [], 'added': [], 'lake_props': 0}
    w_on, g_on = water_on(), grass_on()
    if not (w_on or g_on): return bmd, rep
    where = place(chunk)
    if where is None: return bmd, rep
    import pearl_render
    model = pearl_mesh.Model(bmd)
    info = pearl_render.bindings(model)
    mats, shapes, _ = pearl_mesh.unchanged_parts(model)
    remap, extra, changed = {}, [], False
    names_taken = {mt['name'] for mt in mats}
    shape_names = {s['name'] for s in shapes}
    def new_shape_name():
        k = 0
        while f'b2look{k}' in shape_names: k += 1
        shape_names.add(f'b2look{k}'); return f'b2look{k}'
    # grass
    if g_on and where == 'outdoor':
        for i, t in enumerate(info):
            if t[0] != GRASS[0]: continue
            rec = bytearray(mats[i]['rec'])
            struct.pack_into('<HH', rec, 32, GRASS[4], GRASS[4])          # origWidth, origHeight
            mats[i] = dict(mats[i], rec=bytes(rec), tex=GRASS[1], pal=GRASS[2])
            for k, s in enumerate(model.shapes):
                if s.material == i:
                    shapes[k] = dict(shapes[k], dl=pearl_mesh.encode_groups(_regroup(model, s.groups, GRASS[3])))
            rep['grass'].append(model.materials[i]); changed = True
    # water
    if w_on:
        layers = {}                      # kind -> {'base': [material], 'surface': [material]}
        for i, t in enumerate(info):
            if t[0] not in PEARL_WATER: continue
            layer, kind = PEARL_WATER[t[0]]
            kind = kind or ('cave' if where == 'indoor' else 'pond')
            layers.setdefault(kind, {'base': [], 'surface': []})[layer].append(i)
            rep['water'].setdefault(kind, []).append(model.materials[i])
        lake, moved = _lake_polys(model, props) if where == 'outdoor' else ([], [])
        if lake:
            layers.setdefault('pond', {'base': [], 'surface': []})
            rep['lake_props'] = len(moved)
        records = b2_records()
        dy = int(round(GAP * 4096 / model.pos_scale))
        index_of = {}                    # Black 2 material -> its material index in this model

        def unlit(b2name):
            return not struct.unpack_from('<I', records[b2name], 12)[0] & 15

        def add_shape(b2name, groups, lift):
            """A new shape of groups [(type, [polygon])] (raised lift raw) in b2name's material (made if the model has
            none)."""
            _, tex, pal, mapping = B2_MATERIALS[b2name]
            new = _regroup(model, groups, mapping, lift, unlit(b2name))
            if new is None:
                rep['skipped'] = f'{b2name}: out of range'; return False
            if b2name not in index_of:
                if len(mats) >= MAX_MATERIALS:
                    rep['skipped'] = f'{len(mats)} materials: no {b2name}'; return False
                assert b2name not in names_taken
                mats.append({'name': b2name, 'rec': records[b2name], 'tex': tex, 'pal': pal})
                names_taken.add(b2name); index_of[b2name] = len(mats) - 1
                rep['added'].append(b2name)
            shapes.append({'name': new_shape_name(), 'flag': 6 if unlit(b2name) else 5,
                           'dl': pearl_mesh.encode_groups(new)})
            extra.append((index_of[b2name], len(shapes) - 1))
            return True

        for kind, ls in layers.items():
            names = dict(zip(('base', 'surface'), KINDS[kind]))
            src = {'base': [], 'surface': []}
            for layer in ('base', 'surface'):          # Pearl's own layers take Black 2's records and coordinates
                own = ls[layer]
                if not own: continue
                b2name = names[layer]
                _, tex, pal, mapping = B2_MATERIALS[b2name]
                mats[own[0]] = dict(mats[own[0]], name=b2name, rec=records[b2name], tex=tex, pal=pal)
                index_of[b2name] = own[0]
                for i in own[1:]: remap[i] = own[0]
                top = None
                for k, sh in enumerate(model.shapes):
                    if sh.material in own:
                        shapes[k] = dict(shapes[k], dl=pearl_mesh.encode_groups(
                            _regroup(model, sh.groups, mapping, 0, unlit(b2name))))
                        top = max([top] + [v[1] for p in sh.polys for v in p] if top is not None else
                                  [v[1] for p in sh.polys for v in p])
                # a copy is made from Pearl's own polygons of these materials (not the fixed model's: its T-junction
                # splits and under-floor would double the copy's size, Route 222's shallows 34 KB), raised as much
                # as the fixes raised the material's top (the layers fix moves pieces up to 2.25 units)
                pearl = _pearl_groups(chunk, {model.materials[i] for i in own})
                if pearl:
                    ptop = max(v[1] for _, ps in pearl for p in ps for v in p)
                    shift = max(0, top - ptop) if top is not None else 0
                    src[layer].extend((g, [[v.moved(y=v[1] + shift) for v in p] for p in ps]) for g, ps in pearl)
                else:
                    src[layer].extend(g for sh in model.shapes if sh.material in own for g in sh.groups)
                changed = True
            if kind == 'pond' and lake:                # the lakes' planes: surface polygons of this chunk now
                changed |= add_shape(names['surface'], lake, 0)
                src['surface'].extend(lake)
            if not ls['surface'] and not (kind == 'pond' and lake) and src['base']:
                changed |= add_shape(names['surface'], src['base'], dy)
            if not ls['base'] and src['surface']:
                changed |= add_shape(names['base'], src['surface'], -dy)
        rep['moved_props'] = moved
    if not changed: return bmd, rep
    return pearl_mesh.write_model(model, mats, shapes, pearl_mesh.sbc_with(model, remap, extra)), rep


def placed_props(chunk, props):
    """The chunk's props without the lake planes swap() moved into its model."""
    if not water_on() or place(chunk) != 'outdoor': return props
    out = []
    for p in props:
        if p['model'] in LAKE_PROPS and not any(r % 0x10000 for r in p['rot']) \
                and not any(abs(s - 1) > 1e-3 for s in p['scale']):
            continue
        out.append(p)
    return out


# ------------------------------------------------------------------------------------------------ texture sets
@functools.lru_cache(maxsize=None)
def _b2_set(i):
    import narcio
    return narcio.load(VANILLA, 14)[i]


def texture_adds(where, season=1, north=False):
    """[(Black 2 set bytes, texture, palette)] for nsbtx.merge: the Black 2 textures an outdoor or indoor map's
    models now name (season 0-3; the north: winter all year)."""
    out = []
    if where == 'outdoor':
        s = B2_SEASON_SETS[3 if north else season]
        if grass_on(): out.append((_b2_set(s), GRASS[1], GRASS[2]))
        if water_on():
            for b2name in ('sea_mizu1', 'mizu_sita2', 'ike01'):
                _, tex, pal, _ = B2_MATERIALS[b2name]
                out.append((_b2_set(s), tex, pal))
    elif where == 'indoor' and water_on():
        for b2name in ('d0_miz', 'd0_miz2'):
            _, tex, pal, _ = B2_MATERIALS[b2name]
            out.append((_b2_set(B2_CAVE_SET), tex, pal))
    return out


def grass_pairs(pearl_parsed, season, north=False):
    """[(Pearl ground grass colour, Black 2 grass01ax colour)]: the most used colour of each (recolour.transfer's
    ground anchor), for Pearl's art with grass in it beside the new ground."""
    import nsbtx, recolour
    b2 = nsbtx._parse(_b2_set(B2_SEASON_SETS[3 if north else season]))
    pc = recolour.colour_counts(pearl_parsed, 'ngrass', 'grass').most_common(1)
    bc = recolour.colour_counts(b2, GRASS[1], GRASS[2]).most_common(1)
    return [(pc[0][0], bc[0][0])] if pc and bc else []


# Pearl art kept in spring and summer though it has grass in it: the trees and the tall grass (the user: Pearl's own)
KEEP_GRASS_COLOURS = ('tree', 'nectgr', 'enccliff', 'l_grass_')


def keeps_own_grass(texture):
    return any(k in texture for k in KEEP_GRASS_COLOURS)


def add_textures(btx, where, season=1, north=False):
    """A texture set with texture_adds merged in (nothing changed when none)."""
    import nsbtx
    adds = texture_adds(where, season, north)
    return nsbtx.merge(btx, adds, keep_base=True) if adds else btx


@functools.lru_cache(maxsize=None)
def room_water_areas():
    """Pearl room areas whose chunks (as sinnoh_rooms assigns them) have water swap() changes."""
    import pearl_chunk, pearl_render
    out = set()
    for c, pa in _room_chunk_areas().items():
        if str(c) not in _world()['rooms']['chunks']: continue
        texs = {t[0] for t in pearl_render.bindings(pearl_chunk.pearl_model(c))}
        props = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))['props']
        if texs & set(PEARL_WATER) or any(p['model'] in LAKE_PROPS for p in props): out.add(pa)
    return frozenset(out)


def room_srt(pearl_area):
    """The SRT animation file (a/0/6/8) a room area's record names: Black 2's outdoor one or its cave one where the
    area has water, else None (none)."""
    if not water_on() or pearl_area not in room_water_areas(): return None
    return SRT['outdoor'] if area_place(pearl_area) == 'outdoor' else SRT['cave']


def room_set(btx, pearl_area):
    """A room area's own (non-seasonal) texture set with the Black 2 textures its models name."""
    where = area_place(pearl_area)
    if where == 'indoor' and pearl_area not in room_water_areas(): return btx
    return add_textures(btx, where, 1, pearl_area == NORTH_AREA)


def recolour_palettes(btx, changes):
    """A texture set with palettes rewritten in place ({palette name: function(BGR555 bytes) -> bytes of the same
    size})."""
    import nsbtx
    P = nsbtx._parse(btx)
    t0 = nsbtx.tex0(btx)
    base = len(btx) - len(t0)                       # (TEX0 block's offset in the file)
    pdata = struct.unpack_from('<I', t0, 0x38)[0]
    out = bytearray(btx)
    for name, (o, _flag) in P['pals']:
        if name not in changes: continue
        size = nsbtx._pal_size(P, name)
        at = base + pdata + (o << 3)
        new = changes[name](bytes(out[at:at + size]))
        assert len(new) == size
        out[at:at + size] = new
    return bytes(out)
