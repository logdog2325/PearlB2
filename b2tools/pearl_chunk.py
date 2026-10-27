"""Pearl map chunk -> Black 2 map chunk (`WB` container: model, terrain, buildings). Phase 2 converter, step 1.

    python3 pearl_chunk.py CHUNK [CHUNK ...]      report: tile types not mapped, heights not matched, per chunk

- Model: Pearl's BMD0 (Black 2 draws it: notes/WORLD.md "First light") with the cracks and flicker fixes of
  pearl_model_fix (fix_model: layers 2 units apart, an under-floor, T-junction splits, within CHUNK_BUDGET).
- Terrain: Pearl's tile attributes (collision bit 15, behaviour low byte; names from pokeplatinum
  include/constants/field/map_tile_behaviors.h, pokediamond has none) -> Black 2 cells (class, flags) by BEHAVIOURS
  below, flags as Black 2's own maps use them (notes/GEN5_MAPS.md section 3, measured over all Black 2 chunks).
- Heights: Pearl's BDHC layout is not decoded, so each tile's surface comes from the model's own triangles (apicula
  glTF export): at the tile centre, the highest upward-facing ground triangle (tree and shadow materials skipped).
  Its plane goes to the nearest of Black 2's slope normals (ov036 MAP_HEIGHT_SLOPE_TABLE) and height offsets
  (MAP_HEIGHT_OFFSET_TABLE); the tile is reported when the Black 2 plane misses Pearl's height at the centre by more
  than MAX_ERR units.
- Buildings: none yet (step 2).
"""
import functools, json, os, struct, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from b2files import gf_container_build  # noqa: E402

LAND = os.path.join(ROOT, 'work', 'pearl', 'land')
APICULA = os.path.join(ROOT, 'tools', 'apicula')
OV036 = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build', 'arm9_ov036.bin')
OV036_BASE, SLOPES_AT, SLOPES_N, OFFSETS_AT, OFFSETS_N = 0x0217F600, 0x021d2a04, 317, 0x021d3174, 1285
MAX_ERR = 1.0
SKIP_MATERIALS = ('tree', 'shadow', 'kage', 't3_fl')   # canopies, shadow decals and flower carpets are not ground
# Flower carpets (t3_fl_b/g/p/r/y: Floaroma 32/33, Floaroma Meadow 414-417, Flower Paradise 123, the Seabreak Path
# 119/124-131) are drawn 12 units over Pearl's ground (its BDHC), with no ground mesh under them: such a tile's ground
# is the carpet's surface lowered by FLOWER_LIFT (ground(); checked against Pearl's BDHC on every flower map,
# 2026-10-26: all flower-only tiles sit exactly 12 over it). Taken as ground before, they were 12-unit steps (Flower
# Paradise's stairs to Shaymin's bed: a 20-unit wall).
FLOWER_MATERIALS, FLOWER_LIFT = ('t3_fl',), 12

WALK, SOLID = (0x00, 0x80), (0x01, 0x81)
# Pearl behaviour -> Black 2 (class, flags); None = plain floor or wall by Pearl's collision bit
BEHAVIOURS = {
    0x00: None, 0x69: None,        # (DOOR: a wall here; the door is a warp entity)
    0x02: (0x04, 0x24),            # TALL_GRASS -> tall grass, single battles
    0x03: (0x08, 0x24),            # VERY_TALL_GRASS -> very tall (dark) grass
    # Gen 4 encounter tiles (pokeplatinum src/map_tile_behavior.c TILE_BEHAVIOR_FLAG_ENCOUNTER) -> Black 2's cave
    # encounter floor (class 0x0a, flags 0x84: Wellspring Cave, Relic Passage); MOUNTAIN_FLOOR has none
    0x08: (0x0a, 0x84), 0x0b: (0x0a, 0x84), 0x0c: None,   # CAVE_FLOOR, OLD_CHATEAU_FLOOR, MOUNTAIN_FLOOR
    0x10: (0x3d, 0x56), 0x15: (0x3d, 0x56),  # WATER_RIVER, WATER_SEA -> surfable water
    0x13: (0x40, 0x13),            # WATERFALL
    0x16: None, 0x17: None,        # PUDDLE, SHALLOW_WATER (walkable; splash effects later)
    0x20: (0x10, 0x40),            # ICE -> sliding ice
    0x21: (0x0b, 0x88),            # SAND
    0x38: (0x72, 0x01), 0x39: (0x73, 0x01), 0x3a: (0x74, 0x01), 0x3b: (0x75, 0x01),   # JUMP_EAST/WEST/NORTH/SOUTH
    0xa1: (0x0e, 0x08), 0xa8: (0x0e, 0x08),  # SNOW_DEEP, SNOW_SHALLOW -> snow
    0xa2: (0x0f, 0x08), 0xa3: (0x0f, 0x08),  # SNOW_DEEPER, SNOW_DEEPEST -> snow, no cycling
    0xa4: (0x1c, 0x40), 0xa5: (0x1c, 0x40),   # MUD, MUD_DEEP -> swamp, no encounters (as in Pearl)
    0xa6: (0x1c, 0x44), 0xa7: (0x1c, 0x44),   # MUD(_DEEP)_WITH_GRASS -> swamp with encounters
    0x70: None, 0x71: None, 0x73: None, 0x75: None,   # bridges: the deck's floor (what is under it: LOWER, below)
    0x72: (0x0a, 0x84),            # BRIDGE_OVER_CAVE: encounters (Gen 4)
    0x7b: (0x04, 0x24),            # BIKE_BRIDGE_E_W_OVER_ENCS: grass encounters (Gen 4)
    0x80: (0xd4, 0x01),            # TABLE -> counter (talk across)
    0x83: (0xd6, 0x01),            # PC
    0x86: (0xd8, 0x01),            # TV
    0xe0: (0xd9, 0x01), 0xe1: (0xd9, 0x01), 0xe2: (0xd9, 0x01),   # bookshelves
    0xe4: (0xdd, 0x01),            # TRASH_CAN -> bin
    0xe5: (0xdf, 0x01),            # MART_SHELF_1 -> shelf
}
# Kept as floor/wall by collision for now, listed for later work: doors and warps (entities), Rock Climb walls
# (events, TMS.md), bike bridges/ramps/slopes, slides, Pastoria Gym grounds, escalators, block-one-way tiles.


def tables():
    d = open(OV036, 'rb').read()
    s = struct.unpack_from(f'<{3 * SLOPES_N}h', d, SLOPES_AT - OV036_BASE)
    slopes = [s[3 * i:3 * i + 3] for i in range(SLOPES_N)]
    offsets = struct.unpack_from(f'<{OFFSETS_N}i', d, OFFSETS_AT - OV036_BASE)
    return slopes, offsets


@functools.lru_cache(maxsize=None)
def _primitives(chunk):
    """((material name, triangles), ...) of land/NNN.nsbmd's triangle primitives, triangles as (p0, p1, p2) in
    chunk-centred units, via apicula's glTF export."""
    with tempfile.TemporaryDirectory() as t:
        subprocess.run([APICULA, 'convert', os.path.join(LAND, f'{chunk:03d}.nsbmd'), '-o', t, '-f', 'gltf',
                        '--overwrite'], check=True, capture_output=True)
        name = next(f for f in os.listdir(t) if f.endswith('.gltf'))
        g = json.load(open(os.path.join(t, name)))
        buf = open(os.path.join(t, g['buffers'][0]['uri']), 'rb').read()
    def acc(i):
        a = g['accessors'][i]; v = g['bufferViews'][a['bufferView']]
        off = v.get('byteOffset', 0) + a.get('byteOffset', 0)
        comp = {5126: 'f', 5123: 'H', 5125: 'I', 5121: 'B'}[a['componentType']]
        n = {'SCALAR': 1, 'VEC2': 2, 'VEC3': 3}[a['type']]
        size = struct.calcsize(comp) * n
        stride = v.get('byteStride', size)
        return [struct.unpack_from(f'<{n}{comp}', buf, off + k * stride) for k in range(a['count'])]
    out = []
    for mesh in g['meshes']:
        for p in mesh['primitives']:
            if p.get('mode', 4) != 4: continue
            mat = g['materials'][p['material']]['name'].lower() if 'material' in p else ''
            pos = acc(p['attributes']['POSITION'])
            idx = [i[0] for i in acc(p['indices'])] if 'indices' in p else list(range(len(pos)))
            out.append((mat, tuple((pos[idx[k]], pos[idx[k + 1]], pos[idx[k + 2]]) for k in range(0, len(idx) - 2, 3))))
    return tuple(out)


@functools.lru_cache(maxsize=None)
def triangles(chunk):
    """Ground triangles of land/NNN.nsbmd as [(p0, p1, p2)] in chunk-centred units (all but SKIP_MATERIALS)."""
    return tuple(t for mat, tris in _primitives(chunk) if not any(s in mat for s in SKIP_MATERIALS) for t in tris)


@functools.lru_cache(maxsize=None)
def flower_triangles(chunk):
    """The flower carpets' triangles of land/NNN.nsbmd (FLOWER_MATERIALS), as triangles()."""
    return tuple(t for mat, tris in _primitives(chunk) if any(s in mat for s in FLOWER_MATERIALS) for t in tris)


def chunk_triangles(chunk, around=None, which=None):
    """triangles(chunk) (or which(chunk)) plus its neighbours' from `around` ({(dx, dz): chunk}, neighbours()), moved
    into this chunk's units: Pearl's models overhang their chunk."""
    which = which or triangles
    tris = list(which(chunk))
    for (dx, dz), other in (around or {}).items():
        tris += [tuple((p[0] + 512 * dx, p[1], p[2] + 512 * dz) for p in t) for t in which(other)]
    return tris


def ground(tris, flowers, x, z):
    """surface() of the ground triangles at (x, z), else of the flower carpets lowered by FLOWER_LIFT (the ground under
    a carpet; FLOWER_MATERIALS), or None."""
    s = surface(tris, x, z)
    if s is None and flowers:
        f = surface(flowers, x, z)
        if f is not None: s = (f[0] - FLOWER_LIFT, f[1])
    return s


def surface(tris, x, z):
    """(height, unit normal) of the highest upward-facing triangle over (x, z), or None."""
    best = None
    for a, b, c in tris:
        d = (b[0] - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (b[2] - a[2])
        if abs(d) < 1e-6: continue
        u = ((x - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (z - a[2])) / d
        v = ((b[0] - a[0]) * (z - a[2]) - (x - a[0]) * (b[2] - a[2])) / d
        if u < -1e-4 or v < -1e-4 or u + v > 1 + 1e-4: continue
        e1 = [b[i] - a[i] for i in range(3)]; e2 = [c[i] - a[i] for i in range(3)]
        n = [e1[1] * e2[2] - e1[2] * e2[1], e1[2] * e2[0] - e1[0] * e2[2], e1[0] * e2[1] - e1[1] * e2[0]]
        ln = sum(k * k for k in n) ** 0.5
        n = [k / ln for k in n]
        if n[1] < 0: n = [-k for k in n]
        if n[1] < 0.5: continue                          # walls and steep faces
        y = a[1] + u * e1[1] + v * e2[1]
        if best is None or y > best[0]: best = (y, n)
    return best


def plane_record(slopes, offsets, y, n, x, z):
    """Black 2 (a, b) for the plane through (x, y, z) with normal n: nearest slope normal, then nearest offset."""
    si = max(range(len(slopes)), key=lambda i: (slopes[i][0] * n[0] + slopes[i][1] * n[1] - slopes[i][2] * n[2])
             / max(1, (slopes[i][0] ** 2 + slopes[i][1] ** 2 + slopes[i][2] ** 2) ** 0.5))
    nx, ny, nz = slopes[si][0], slopes[si][1], -slopes[si][2]          # the game negates the third component
    want = -(nx * x + ny * y + nz * z)       # y = -(nx*x + nz*z + d) / ny: n raw fx16, x/z/y units, d raw (GEN5_MAPS.md)
    oi = min(range(len(offsets)), key=lambda i: abs(offsets[i] - want))
    got = -(nx * x + nz * z + offsets[oi]) / ny
    return si << 2, oi, got


def neighbours(matrix, x, z):
    """{(dx, dz): chunk} of the 8 cells around (x, z) in a matrix JSON (work/pearl/matrices)."""
    out = {}
    for dz in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dx or dz) and 0 <= x + dx < matrix['width'] and 0 <= z + dz < matrix['height']:
                c = matrix['maps'][z + dz][x + dx]
                if c != 0xffff: out[(dx, dz)] = c
    return out


# Warp tiles that Pearl fires as you step onto them; Black 2 checks walk-into warps only when the player bumps into
# something (tested 2026-10-18: walking up onto Twinleaf house's walkable stairs did nothing), so the overworld's
# ENTRANCES become walls where the caller asks (patches/sinnoh_events.py makes them bump warps; Black 2 steps the
# player off on arrival). STAIRS stay walkable (their flight is the solid tile: below).
STAIRS = {0x5e, 0x5f}
ENTRANCES = {0x62, 0x63, 0x64, 0x65, 0x6c, 0x6d, 0x6e, 0x6f}
# the tile a walkable warp mat is walked onto from (pokeplatinum map_tile_behaviors.h: 0x62/0x6C east, 0x63/0x6D west,
# 0x64/0x6E north, 0x65/0x6F south): convert() puts the mat on that tile's floor
MAT_FROM = {0x62: (-1, 0), 0x6c: (-1, 0), 0x63: (1, 0), 0x6d: (1, 0), 0x64: (0, 1), 0x6e: (0, 1), 0x65: (0, -1),
            0x6f: (0, -1)}
# Stairs (lead 2026-10-20, from pokeplatinum sub_02057368/sub_02057218): Pearl's 0x5e/0x5f tile is the FOOT of the
# stairs (walkable floor at its own height); the flight is the next tile (0x5e: x + 1, the player walks east; 0x5f:
# x - 1, west), solid in Pearl. The flight gets Black 2's 45-degree collision plane (HoennB2 terrain/heights.py SLOPES,
# ov036's slope table: 11 rises east, 16 west, 8 north, 14 south, 16 units a tile), 0 at the foot's edge, rising when
# the stairs go up and falling when they go down, so a player warping there visibly climbs or descends (the warp moves
# to the flight tile: sinnoh_events). Up or down: Pearl's stair model over the flight (build models stair_u*/stair_d*,
# rooms), else the map model's own steps past the foot's edge (caves: the surface 12-16 units on rises or falls).
STAIR_DX = {0x5e: 1, 0x5f: -1}
SLOPE_RISING = {1: 11, -1: 16}               # walking +x / -x: the plane that rises that way


@functools.lru_cache(maxsize=None)
def build_model_names():
    """Pearl build model id -> its model name (fielddata/build_model/build_model.narc)."""
    from gen4rom import Rom, narc_members
    import pearl_mesh
    out = {}
    for k, b in enumerate(narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read(
            'fielddata/build_model/build_model.narc'))):
        try:
            mdl = struct.unpack_from('<I', b, 0x10)[0]
            out[k] = pearl_mesh._ndict(b, mdl + 8)[0][1]
        except Exception:
            out[k] = ''
    return out


def stairs_way(land, tris, tx, tz, dx, foot_y):
    """+1 (up), -1 (down) or 0 (unknown) for the stairs whose foot is tile (tx, tz), flight at tx + dx."""
    fx, z = (tx + dx) * 16 - 256 + 8, tz * 16 - 256 + 8
    names = build_model_names()
    for p in land['props']:
        n = names.get(p['model'], '')
        if n.startswith('stair_') and abs(p['pos'][0] - fx) <= 24 and abs(p['pos'][2] - z) <= 16:
            return 1 if n.startswith('stair_u') else -1 if n.startswith('stair_d') else 0
    ys = [surface(tris, fx + dx * k, z) for k in (4, 8)]           # 12 and 16 units past the foot's edge
    if any(s is not None and s[0] > foot_y + 4 for s in ys): return 1
    if any(s is None or s[0] < foot_y - 4 for s in ys): return -1
    return 0


def stair_planes(land, tris, heights, slopes, offsets):
    """[{foot: (tx, tz), dx, way (+1 up, -1 down, 0 flat, None: flight in the next chunk), foot_y (the foot's rounded
    collision height), slope, offset (the flight's Black 2 plane: ov036's tables)}] for every stairs foot of a chunk
    (STAIRS above); heights = {(tx, tz): rounded collision height} of its tiles (convert)."""
    out = []
    for tz in range(32):
        for tx in range(32):
            dx = STAIR_DX.get(land['behaviour'][tz][tx])
            if dx is None or (tx, tz) not in heights: continue
            st = dict(foot=(tx, tz), dx=dx, way=None, foot_y=heights[(tx, tz)], slope=None, offset=None)
            out.append(st)
            if not 0 <= tx + dx < 32: continue
            st['way'] = way = stairs_way(land, tris, tx, tz, dx, st['foot_y'])
            if not way: continue
            si = SLOPE_RISING[dx * way]
            nx, ny, nz = slopes[si][0], slopes[si][1], -slopes[si][2]
            ex, ez = tx * 16 - 256 + 8 + dx * 8, tz * 16 - 256 + 8           # the foot's edge
            want = -(nx * ex + ny * st['foot_y'] + nz * ez)
            st['slope'], st['offset'] = si, min(range(len(offsets)), key=lambda i: abs(offsets[i] - want))
    return out


def plane_height(slopes, offsets, si, oi, x, z):
    """Height of Black 2's collision plane (slope si, offset oi) at chunk-centred (x, z) (GEN5_MAPS.md)."""
    nx, ny, nz = slopes[si][0], slopes[si][1], -slopes[si][2]
    return -(nx * x + nz * z + offsets[oi]) / ny


def stairs_of(chunk, around=None):
    """stair_planes of a chunk as convert writes them, each with 'foot_h' (the foot's exact collision height, the
    plane at its centre) and the flight's height at chunk-centred (x, z): 'flight_y'(x, z). For the stair-walk check
    (pearl_rooms_view kind s)."""
    slopes, offsets = tables()
    land = json.load(open(os.path.join(LAND, f'{chunk:03d}.json')))
    tris = chunk_triangles(chunk, around)
    flowers = chunk_triangles(chunk, around, flower_triangles)
    heights, exact = {}, {}
    for tz in range(32):
        for tx in range(32):
            if land['behaviour'][tz][tx] not in STAIR_DX: continue
            x, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
            s = ground(tris, flowers, x, z)
            if s is None: continue
            a, b, got = plane_record(slopes, offsets, s[0], s[1], x, z)
            heights[(tx, tz)], exact[(tx, tz)] = round(got), got
    out = stair_planes(land, tris, heights, slopes, offsets)
    for st in out:
        st['foot_h'] = exact[st['foot']]
        if st['slope'] is not None:
            st['flight_y'] = (lambda si, oi: lambda x, z: plane_height(slopes, offsets, si, oi, x, z))(
                st['slope'], st['offset'])
    return out


# Black 2's stair warp (measured in RAM, story_play REC log, the player's house 2F -> 1F, 2026-10-20): leaving, the
# player walks from the foot's centre onto the flight's centre, 1 unit a frame, the feet on the collision height (the
# foot's, then the flight's plane from its edge), the camera's target on the player in x/z and at the foot's height
# + 4 until they stop, then sinking or rising 1 unit a frame toward the player's while the screen fades (~18
# frames); arriving, the player stands on the flight's centre at its plane's height (the camera's target there + 4)
# while the screen fades in (~20 frames), then walks off onto the foot.
def stair_walk(st):
    """{'leaving': [...], 'arriving': [...]}: the player's positions (x, feet y, z, camera target y - 4, facing:
    2 left / 3 right) in chunk-centred units along Black 2's stair warp for one stairs of stairs_of (with a plane)."""
    tx, tz = st['foot']; dx = st['dx']
    fx, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
    def y_at(x):
        return st['foot_h'] if (x - fx) * dx < 8 else st['flight_y'](x, z)
    end = fx + dx * 16
    go = [(fx + dx * k, y_at(fx + dx * k), z, st['foot_h'], 3 if dx > 0 else 2) for k in range(0, 17, 2)]
    import numpy as np
    go += [(end, y_at(end), z, float(cy), 3 if dx > 0 else 2)            # (the camera catching up while it fades)
           for cy in np.linspace(st['foot_h'], y_at(end), 4)[1:]]
    back = [(fx + dx * k, y_at(fx + dx * k), z, y_at(end), 2 if dx > 0 else 3) for k in range(16, -1, -2)]
    return {'leaving': go, 'arriving': back}


CHUNK_LIMIT = 110600        # Black 2's map chunk buffer (ov036 MAP_CONFIGS[0]; build_rom.py stops above it)
CHUNK_BUDGET = 100000       # what the model fixes may fill a chunk to (headroom for later additions)


@functools.lru_cache(maxsize=None)
def pearl_model(chunk):
    import pearl_mesh
    return pearl_mesh.Model(open(os.path.join(LAND, f'{chunk:03d}.nsbmd'), 'rb').read())


def fix_model(chunk, bmd=None, around=None, budget=CHUNK_BUDGET):
    """(model bytes, report): Pearl's model of `chunk` with the cracks and flicker fixes (pearl_model_fix: layers 2
    units apart, the ground's under-floor, T-junction splits; neighbours `around` = {(dx, dz): chunk}), sized so the
    chunk stays within `budget` bytes (20 + model + 8,196 terrain + placements). MAP_FIXES=none (environment): Pearl's
    model as it is. A room chunk first gets pearl_model_fix.people_fix (people drawn into its counters and tables).
    Last, b2_look.swap: Black 2's water and grass (MAPLOOK_FIXES b2_water, b2_grass; the lakes' l_lake props move into
    the model: b2_look.placed_props leaves their placements out)."""
    import pearl_model_fix, b2_look
    if bmd is None: bmd = open(os.path.join(LAND, f'{chunk:03d}.nsbmd'), 'rb').read()
    props = json.load(open(os.path.join(LAND, f'{chunk:03d}.json')))['props']
    if os.environ.get('MAP_FIXES') == 'none':
        out, look = b2_look.swap(bmd, chunk, props)
        return out, {'steps': [], 'b2_look': look}
    people = chunk in room_chunks() and not pearl_model_fix.people_off() and bmd == pearl_model(chunk).data
    key = (chunk, tuple(sorted((around or {}).items())), budget)
    if people and key in _FIXED: return _FIXED[key]
    rest = 20 + 8196 + 4 + 16 * len(props)
    # (a 'GC' chunk's second terrain layer, two_levels: 8,200 B more, taken from the headroom over CHUNK_BUDGET, so
    # the model and its fixes stay as they were; counting it in `rest` dropped the T-junction splits of Routes 206,
    # 208, 225, 227: cracks. Such a chunk ends under 108,200 B + its signs, below CHUNK_LIMIT.)
    second = 4 + 8196 if two_levels(chunk) else 0
    near = [(pearl_model(c), dx, dz) for (dx, dz), c in sorted((around or {}).items())]
    out, rep = pearl_model_fix.fix(bmd, near, lambda n: rest + n <= budget)
    if people:                                       # (on the model as the other fixes leave it)
        out2, blocks = pearl_model_fix.people_fix(out, people_tiles(chunk), bmd)
        rep['people'] = blocks
        if any(b['sink'] or b['pull'] for b in blocks) and rest + second + len(out2) <= CHUNK_LIMIT - 4096:
            out = out2
    out, rep['b2_look'] = b2_look.swap(out, chunk, props)   # last: Black 2's water and grass (byte for byte the rest)
    if people: _FIXED[key] = (out, rep)
    return out, rep


_FIXED = {}      # room chunks' fixed models (people_land and sinnoh_rooms ask for the same chunk)


# ------------------------------------------------------------------------------------------------ beds
# (user 2026-10-20: "Make those bed tiles solid so you can't walk into beds"; notes/MAP_LOOK.md "People drawn into
# furniture") Pearl's collision leaves the middle row and the sides of its beds walkable (bed_h01: 31 x 40 units,
# placed half a tile off the grid; Pearl marks only 2 of the tiles it covers), so people stood in the beds. Every tile
# a bed model's raised parts (more than PEOPLE_LOW over its base) reach into by more than 2 units (the person's own
# body, pearl_rooms_view's "stands inside") is solid in the converted collision, except a tile holding a warp, an
# object (people, items), a trigger or a sign / hidden item of a zone that uses the chunk, or one whose wall would
# cut off any tile that was reachable from the zone's warps: those stay walkable and are listed (bed_tiles).
BED_MODELS = ('bed',)            # build model names (Pearl's rooms use bed_h01 only: 23 placements, 13 chunks)


@functools.lru_cache(maxsize=None)
def _raised_box(model_id):
    """(x0, x1, z0, z1) of a build model's parts more than 3 units over its base (not its shade), or None."""
    import numpy as np, pearl_mesh, pearl_buildings, pearl_model_fix
    _prop_box(model_id)
    try:
        m = pearl_mesh.Model(pearl_buildings.mdl_only(_prop_box.build[model_id]))
    except Exception:
        return None
    its = pearl_model_fix.items(m)
    if not its: return None
    P = np.concatenate([it.P for it in its])
    P = P[P[:, 1] > P[:, 1].min() + pearl_model_fix.PEOPLE_LOW]
    if not len(P): return None
    return float(P[:, 0].min()), float(P[:, 0].max()), float(P[:, 2].min()), float(P[:, 2].max())


@functools.lru_cache(maxsize=None)
def _chunk_zones(chunk):
    """[(Pearl zone, matrix, [(cx, cz) cells holding the chunk], events)] of the room zones that use the chunk."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    out = []
    for pid, r in sorted(world['rooms']['zones'].items(), key=lambda kv: int(kv[0])):
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f"{r['pearl_matrix']:03d}.json")))
        cells = [(cx, cz) for cz, row in enumerate(m['maps']) for cx, c in enumerate(row) if c == chunk]
        if cells:
            ev = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'events', f"{zones[int(pid)]['events']:03d}.json")))
            out.append((int(pid), m, cells, ev))
    return out


def _reach(m, ev, extra):
    """Walkable tiles of a zone's matrix reachable from its warps (their neighbours too; its objects when it has no
    warps), Pearl's collision plus the solid tiles extra = {chunk: {(tx, tz)}}."""
    lands = {}
    def walk(x, z):
        cx, cz = x // 32, z // 32
        if not (0 <= cz < m['height'] and 0 <= cx < m['width']) or m['maps'][cz][cx] == 0xffff: return False
        c = m['maps'][cz][cx]
        if c not in lands: lands[c] = json.load(open(os.path.join(LAND, f'{c:03d}.json')))
        L = lands[c]
        return (not L['collision'][z % 32][x % 32] and L['behaviour'][z % 32][x % 32] not in WATER_BEHAVIOURS
                and (x % 32, z % 32) not in extra.get(c, ()))
    seeds = [(w['x'], w['z']) for w in ev['warp_events']] or [(o['x'], o['z']) for o in ev['object_events']]
    todo = [(x + dx, z + dz) for x, z in seeds for dx, dz in ((0, 0), (0, 1), (0, -1), (1, 0), (-1, 0))]
    seen = {t for t in todo if walk(*t)}
    todo = list(seen)
    while todo:
        x, z = todo.pop()
        for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            t = (x + dx, z + dz)
            if t not in seen and walk(*t):
                seen.add(t); todo.append(t)
    return seen


@functools.lru_cache(maxsize=None)
def bed_tiles(chunk):
    """(frozenset of (tx, tz) made solid, (report lines, ...)) for a room chunk's beds (see BED_MODELS above).
    BED_FIX=none (environment): Pearl's collision as it is."""
    if chunk not in room_chunks() or os.environ.get('BED_FIX') == 'none': return frozenset(), ()
    land = json.load(open(os.path.join(LAND, f'{chunk:03d}.json')))
    names = build_model_names()
    cand = {}
    for k, pr in enumerate(land['props']):
        if not any(b in names.get(pr['model'], '') for b in BED_MODELS): continue
        box = _raised_box(pr['model'])
        if box is None: continue
        x0, x1 = pr['pos'][0] + box[0], pr['pos'][0] + box[1]
        z0, z1 = pr['pos'][2] + box[2], pr['pos'][2] + box[3]
        for tz in range(32):
            for tx in range(32):
                cx, cz = tx * 16 - 248, tz * 16 - 248                # the tile's centre (chunk units)
                if min(x1, cx + 6) - max(x0, cx - 6) > 1 and min(z1, cz + 6) - max(z0, cz - 6) > 1:
                    cand.setdefault((tx, tz), f"{names[pr['model']]}#{k}")
    if not cand: return frozenset(), ()
    zs = _chunk_zones(chunk)
    keep, notes = set(), []
    for pid, m, cells, ev in zs:                     # warps, objects, triggers, signs / hidden items stay walkable
        spots = {(w['x'], w['z']) for w in ev['warp_events']} | {(o['x'], o['z']) for o in ev['object_events']}
        spots |= {(b['x'], b['z']) for b in ev['bg_events']}
        spots |= {(c['x'] + i, c['z'] + j) for c in ev['coord_events'] for i in range(max(1, c['width']))
                  for j in range(max(1, c['length']))}
        for x, z in spots:
            if (x // 32, z // 32) in cells and (x % 32, z % 32) in cand:
                keep.add((x % 32, z % 32)); notes.append(f'zone {pid} ({x}, {z}): an event on the bed tile, left walkable')
    base = {pid: _reach(m, ev, {}) for pid, m, cells, ev in zs}
    done = set()
    walled = set(cand) - keep                        # (the bed's own tiles may be cut off: they become solid too)
    for t in sorted(cand):
        if t in keep: continue
        trial = done | {t}
        lost = []
        for pid, m, cells, ev in zs:
            g = lambda qs: {(cx * 32 + q[0], cz * 32 + q[1]) for cx, cz in cells for q in qs}
            r = _reach(m, ev, {chunk: trial})
            lost += [(pid, q) for q in base[pid] - g(walled) - r]
        if lost:
            notes.append(f'tile {t}: solid would cut off {len(lost)} tiles (zone {lost[0][0]} {lost[0][1]} ...), '
                         f'left walkable')
        else:
            done.add(t)
    return frozenset(done), tuple(notes)


def bed_solid(chunk):
    """The tiles of a room chunk made solid under its beds (bed_tiles), as local (tx, tz)."""
    return bed_tiles(chunk)[0]


@functools.lru_cache(maxsize=None)
def _lift_plates():
    """{chunk: {(tx, tz): height}}: every tile of a Pearl platform-lift plate (Iron Island's three, the League's six;
    b2tools/pearl_gimmicks.py lift_plates) at its bottom floor's height (2026-10-25, the ch6a agent). Pearl's plate is
    a moving prop with a terrain plate of its own (pokeplatinum DynamicTerrainHeightManager), so its tiles have no
    ground in the room model and converted to height 0: 16 units under the bottom floor (Iron Island), where a player
    stepping on from that floor sank. The lift's own height while it is up comes from gimmick 59's terrain layers."""
    import pearl_gimmicks
    zones = {z['name']: z for z in pearl_gimmicks.pearl_zones()}
    out = {}
    for name, (y, tiles) in pearl_gimmicks.lift_plates().items():
        cells = pearl_gimmicks.zone_chunks(zones[name])
        for x, z in tiles:
            out.setdefault(cells[(x // 32, z // 32)], {})[(x % 32, z % 32)] = y
    return out


def lift_plate(chunk):
    """{(tx, tz): height} of the platform-lift plate tiles in a chunk (_lift_plates)."""
    return _lift_plates().get(chunk, {})


WATER_BEHAVIOURS = {0x10, 0x13, 0x15}


@functools.lru_cache(maxsize=None)
def _room_around(chunk):
    """Neighbours ({(dx, dz): chunk}) of a room chunk in the first room matrix that holds it (where sinnoh_rooms
    converts it)."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    for mid in world['rooms']['matrices']:
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f'{int(mid):03d}.json')))
        for z in range(m['height']):
            for x in range(m['width']):
                if m['maps'][z][x] == chunk: return neighbours(m, x, z)
    return {}


def people_land(chunk):
    """(model bytes, the people fix's blocks) of a room chunk as fix_model installs it (in the first room matrix that
    holds it): its counters and tables that people are drawn into sink and pull back (pearl_model_fix.people_fix)."""
    out, rep = fix_model(chunk, around=_room_around(chunk))
    return out, rep.get('people', [])


@functools.lru_cache(maxsize=None)
def _prop_box(model_id):
    """(lowest corner, highest corner) of a Pearl build model in its own units (None if it does not decode)."""
    import numpy as np, pearl_mesh, pearl_buildings, pearl_model_fix
    from gen4rom import Rom, narc_members
    if not hasattr(_prop_box, 'build'):
        _prop_box.build = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read(
            'fielddata/build_model/build_model.narc'))
    try:
        m = pearl_mesh.Model(pearl_buildings.mdl_only(_prop_box.build[model_id]))
    except Exception:
        return None
    its = pearl_model_fix.items(m)
    if not its: return None
    P = np.concatenate([it.P for it in its])
    return P.min(0), P.max(0)


def _ride(props, i, box, x, s, b, base, footprint):
    """Move props[i] (resting at height base, footprint (x0, x1, z0, z1)) along with a block box = (y0, y1, zn, zs),
    x = (x0, x1) that sinks s and pulls back b; True when it rests on that block."""
    import numpy as np, pearl_model_fix
    y0, y1, zn, zs = box
    fx0, fx1, fz0, fz1 = footprint
    if abs(base - y1) > 2.5 or fx1 <= x[0] or fx0 >= x[1] or fz1 <= zn or fz0 >= zs: return False
    zc = min(max((fz0 + fz1) / 2, zn), zs)
    q = pearl_model_fix._people_moved(np.array([[0.0, min(base, y1), zc]]), box, s, b)[0]
    p = dict(props[i]); pos = list(p['pos'])
    pos[1] += float(q[1] - min(base, y1))
    pos[2] += float(q[2] - zc)
    p['pos'] = pos
    props[i] = p
    return True


def people_props_moved(chunk, props, props_too=True):
    """The chunk's props (Pearl's land json list) with those resting on a block the people fix sinks moved along
    with it (props on a counter of the room model: people_land; props_too: also props on a prop whose model sinks,
    pearl_model_fix.people_props), so nothing floats over a lowered top. Other props unchanged (same dicts)."""
    import pearl_model_fix
    if chunk not in room_chunks() or pearl_model_fix.people_off(): return props
    out = list(props)
    boxes = {}
    for i, pr in enumerate(out):
        bb = _prop_box(pr['model'])
        if bb is None: continue
        lo, hi = bb
        boxes[i] = (pr['pos'][1] + lo[1], (pr['pos'][0] + lo[0], pr['pos'][0] + hi[0], pr['pos'][2] + lo[2],
                                           pr['pos'][2] + hi[2]))
    _, rep = people_land(chunk)
    for blk in rep:
        if not (blk['sink'] or blk['pull']): continue
        for i, (base, fp) in boxes.items():
            _ride(out, i, blk['box'], blk['x'], blk['sink'], blk['pull'], base, fp)
    if props_too:
        table = pearl_model_fix.people_props()
        names = build_model_names()
        for j, pr in enumerate(props):                     # props on a sunk prop (a vase on a table)
            amt = table.get(names.get(pr['model']))
            if not amt or not (amt[0] or amt[1]) or j not in boxes: continue
            px, py, pz = out[j]['pos']
            y0, y1, zn, zs = amt[2]
            lo, hi = _prop_box(pr['model'])
            for i, (base, fp) in boxes.items():
                if i != j: _ride(out, i, (py + y0, py + y1, pz + zn, pz + zs), (px + lo[0], px + hi[0]),
                                 amt[0], amt[1], base, fp)
    return out


@functools.lru_cache(maxsize=None)
def room_chunks():
    """Pearl chunks installed as rooms (data/sinnoh_world.json "rooms")."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    return frozenset(int(c) for c in world['rooms']['chunks'])


@functools.lru_cache(maxsize=None)
def _room_people():
    """{chunk: {(tx, tz)}}: where people stand in the room zones, per chunk of their matrix: the walkable tiles
    (Pearl's collision, not water) reachable from the zone's warps (from its objects' tiles when it has none) and its
    objects' tiles (Pearl's object events: the nurse behind her counter)."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    lands = {}
    def land(c):
        if c not in lands: lands[c] = json.load(open(os.path.join(LAND, f'{c:03d}.json')))
        return lands[c]
    out = {}
    for pid, r in world['rooms']['zones'].items():
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f"{r['pearl_matrix']:03d}.json")))
        ev = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'events', f"{zones[int(pid)]['events']:03d}.json")))
        def chunk_at(x, z):
            cx, cz = x // 32, z // 32
            if 0 <= cz < m['height'] and 0 <= cx < m['width'] and m['maps'][cz][cx] != 0xffff:
                return m['maps'][cz][cx]
            return None
        def walk(x, z):
            c = chunk_at(x, z)
            if c is None: return False
            L = land(c)
            return (not L['collision'][z % 32][x % 32] and L['behaviour'][z % 32][x % 32] not in WATER_BEHAVIOURS
                    and (x % 32, z % 32) not in bed_solid(c))
        objs = [(o['x'], o['z']) for o in ev['object_events']]
        seeds = [(w['x'], w['z']) for w in ev['warp_events']] or objs
        todo = [(x + dx, z + dz) for x, z in seeds for dx, dz in ((0, 0), (0, 1), (0, -1), (1, 0), (-1, 0))]
        seen = {t for t in todo if walk(*t)}
        todo = list(seen)
        while todo:
            x, z = todo.pop()
            for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                t = (x + dx, z + dz)
                if t not in seen and walk(*t):
                    seen.add(t); todo.append(t)
        for x, z in seen | set(objs):
            c = chunk_at(x, z)
            if c is not None: out.setdefault(c, set()).add((x % 32, z % 32))
    return out


@functools.lru_cache(maxsize=None)
def _room_margins():
    """{chunk: the people fix's depth margin}: pearl_model_fix.PEOPLE_MARGIN where a building zone (map type 4 or 1:
    projection type 0) uses the chunk, PEOPLE_MARGIN_CAVE where only caves and outdoor rooms do (type 1)."""
    import pearl_model_fix
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    out = {}
    for pid, r in world['rooms']['zones'].items():
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f"{r['pearl_matrix']:03d}.json")))
        margin = (pearl_model_fix.PEOPLE_MARGIN if zones[int(pid)]['map_type'] in (4, 1)
                  else pearl_model_fix.PEOPLE_MARGIN_CAVE)
        for row in m['maps']:
            for c in row:
                if c != 0xffff: out[c] = min(out.get(c, margin), margin)
    return out


@functools.lru_cache(maxsize=None)
def people_tiles(chunk):
    """((x, z, feet y, margin), ...) in chunk-centred map units where people stand in a room chunk (_room_people) with
    a floor; feet at the tile's surface (as convert); the depth margin of its zones' projection (_room_margins)."""
    import numpy as np, pearl_model_fix
    margin = _room_margins().get(chunk, pearl_model_fix.PEOPLE_MARGIN)
    spots = _room_people().get(chunk, set())
    tris = triangles(chunk)
    if not tris: return ()
    T = np.array(tris, float)
    lo, hi = T.min(axis=1), T.max(axis=1)
    out = []
    for tx, tz in sorted(spots):
        x, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
        k = np.nonzero((lo[:, 0] <= x) & (hi[:, 0] >= x) & (lo[:, 2] <= z) & (hi[:, 2] >= z))[0]
        s = surface([tris[i] for i in k], x, z)
        if s is not None: out.append((float(x), float(z), float(s[0]), margin))
    return tuple(out)


def plane_y(slopes, offsets, a, b, x, z):
    """The height (units) of Black 2's plane record (a, b) at chunk point (x, z) (plane_record's inverse)."""
    nx, ny, nz = slopes[a >> 2][0], slopes[a >> 2][1], -slopes[a >> 2][2]
    return -(nx * x + nz * z + offsets[b]) / ny


def floor_mats(land, cells, heights, solid_behaviours=(), slopes=None, offsets=None):
    """Walkable warp mats (ENTRANCES not made solid: the rooms') put on the floor of the tile they are walked onto
    from (MAT_FROM): that tile's Black 2 plane and height, when theirs is more than 2 units off. Pearl fires these as
    the player steps on, but a back-wall door mat's highest surface (surface()) is the door frame: the Eterna Gym
    entrance's mat to the Gym (8, 2) sat 30 units over the -2 floor, and Black 2 would not let the player step up onto
    it (2026-10-25, chapter 3; 55 such mats in Sinnoh's rooms: Grand Lake reception, Route 214 gate, League lobby 2F,
    Pokemon Mansion, Old Chateau, Galactic HQ, Mt. Coronet, ...). The overworld's mats are solid bump warps
    (sinnoh_world passes ENTRANCES as solid_behaviours): unchanged. Changes cells and heights in place; returns
    [(tx, tz, old height, new height)]. The height recorded for the mat (its warp's: sinnoh_events) is the copied
    plane's at the mat's own centre, not the neighbour's: on a sloping neighbour the two differ, and Black 2 fires a
    warp only within 2 units of the player's height (2026-10-26: Pal Park's rooms; warp_check heights)."""
    mats = []
    for tz in range(32):
        for tx in range(32):
            beh = land['behaviour'][tz][tx]
            if beh not in MAT_FROM or beh in solid_behaviours or land['collision'][tz][tx]:
                continue
            fx, fz = tx + MAT_FROM[beh][0], tz + MAT_FROM[beh][1]
            if not (0 <= fx < 32 and 0 <= fz < 32) or land['collision'][fz][fx]:
                continue
            # (also a mat with no floor drawn under it, no height: the Sunyshore Gym rooms' exits sat on the
            # default plane at 0 under walkways at 14 and 62, 2026-10-26)
            if (fx, fz) in heights and ((tx, tz) not in heights or abs(heights[(tx, tz)] - heights[(fx, fz)]) > 2):
                a, b = struct.unpack_from('<HH', cells[fz * 32 + fx])
                cells[tz * 32 + tx] = struct.pack('<HH', a, b) + cells[tz * 32 + tx][4:]
                y = heights[(fx, fz)]
                if slopes is not None:              # the copied plane at the mat's centre
                    y = round(plane_y(slopes, offsets, a, b, tx * 16 - 256 + 8, tz * 16 - 256 + 8))
                mats.append((tx, tz, heights.get((tx, tz)), y))
                heights[(tx, tz)] = y
    return mats


# ------------------------------------------------------------------------------------------------ two levels
# (2026-10-25, Chapter 4b: Route 215's road runs east-west under wooden bridges; converted, the road was a wall under
# the first one.) Pearl keeps both levels in its BDHC (gen4_land.read_bdhc_dp): over a bridge tile two plates, the
# deck and what is under it (a road, water, sand, snow, a cave floor); a walker takes the plate nearest its own
# height and a step of 20 units or more is a wall (pokeplatinum bdhc.c CalculateObjectHeight, terrain_collision_
# manager.c). Pearl's tile attribute is one for both levels: its collision bit, and the bridge behaviours 0x70-0x7d
# naming what is under the deck (LOWER). The player's "on a bridge" state (set on 0x70 BRIDGE_START, cleared off
# the bridge's tiles: pokeplatinum map_object_move.c MapObject_DetermineElevatedBridgeStatus) only switches splashes,
# footprints, fishing and Surf off on the deck; it doesn't choose the level. Black 2 does the same with a 'GC'
# chunk (ov036 field_map_chunk_gc.c): two terrain layers, and its walkers too take the valid layer nearest their
# height (FieldG3DMapper_GetTerrain), 20 units being a wall (ov012 ActorRouteCollCheckCore). Its own 60 GC chunks
# keep layer 0 = the ground and layer 1 = a copy with the decks. So convert() writes a GC chunk wherever a tile
# Pearl lets you walk on has two BDHC levels LEVEL_GAP or more apart and the lower one can be walked or surfed onto
# (two_levels): layer 0 the lower level (lower_layer), layer 1 the upper (the model's surface as before). Where the
# model's surface is not Pearl's (deck_planes) BDHC's level is taken: decks the model doesn't draw (Canalave's
# bridge is a placed model: it stood at the canal's 8, not 16), and overhangs 20+ units over a tile Pearl walks next
# to a bridge (the Cycling Road's edges over Route 206's path under it, Sunyshore's walkway railings).
# The Gyms' moving floors (Pastoria's water, Canalave's lifts, Veilstone, Sunyshore) are left to their gimmicks.
# BRIDGE_LEVELS=none (environment): one layer from the model, as before. Check: b2tools/bridge_check.py.
LEVEL_GAP = 8               # BDHC plates nearer than this are one level (seams of slopes)
DECK_MATCH = 4              # the model's surface within this of BDHC's level: keep the model's plane (as before)
BRIDGES = set(range(0x70, 0x7e))
WATER_CELL, SAND_CELL, SNOW_CELL = BEHAVIOURS[0x10], BEHAVIOURS[0x21], BEHAVIOURS[0xa8]
LOWER = {   # what is under a bridge's deck (pokeplatinum map_tile_behavior.c: their surfable / encounter flags)
    0x72: BEHAVIOURS[0x08],                                   # BRIDGE_OVER_CAVE: the cave floor (encounters)
    0x73: WATER_CELL, 0x78: WATER_CELL, 0x7c: WATER_CELL,     # (BIKE_BRIDGE_x_)OVER_WATER: surfable water
    0x74: SAND_CELL, 0x79: SAND_CELL, 0x7d: SAND_CELL,        # (BIKE_BRIDGE_x_)OVER_SAND
    0x75: SNOW_CELL,                                          # BRIDGE_OVER_SNOW
    0x77: BEHAVIOURS[0x02], 0x7b: BEHAVIOURS[0x02],           # BIKE_BRIDGE_x_OVER_ENCS: tall grass
}   # the rest (0x70, 0x71, 0x76, 0x7a, plain tiles): the deck's own class under it too (a road: floor)
WATER_UNDER = {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x19, 0x22, 0x2a, 0x50, 0x51, 0x52, 0x53}   # Pearl's surfable
# behaviours that are not bridges (pokeplatinum map_tile_behavior.c TILE_BEHAVIOR_FLAG_SURFABLE)


@functools.lru_cache(maxsize=None)
def bdhc(chunk):
    """Pearl's BDHC of a chunk (gen4_land.read_bdhc_dp), or None."""
    from gen4_land import read_bdhc_dp
    path = os.path.join(LAND, f'{chunk:03d}.bdhc')
    return read_bdhc_dp(open(path, 'rb').read()) if os.path.exists(path) else None


def bdhc_levels(chunk, tx, tz):
    """[(height, unit normal with y > 0)] of Pearl's BDHC levels at tile (tx, tz)'s centre, highest first; plates
    within LEVEL_GAP of a higher one are the same level."""
    from gen4_land import bdhc_dp_heights
    b = bdhc(chunk)
    if b is None: return []
    out = []
    for y, n in bdhc_dp_heights(b, tx * 16 - 256 + 8, tz * 16 - 256 + 8):
        if n[1] < 0: n = tuple(-k for k in n)
        if not out or out[-1][0] - y >= LEVEL_GAP: out.append((y, n))
    return out


@functools.lru_cache(maxsize=None)
def gym_chunks():
    """Chunks of Pearl's Gym rooms: their floors that move (water, lifts, panels) are their gimmicks' (C), not here."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    out = set()
    for r in world['rooms']['zones'].values():
        if '_GYM' in r['name']:
            m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f"{r['pearl_matrix']:03d}.json")))
            out |= {c for row in m['maps'] for c in row if c != 0xffff}
    return frozenset(out)


@functools.lru_cache(maxsize=None)
def two_levels(chunk):
    """{(tx, tz): [(height, normal) upper, (height, normal) lower]} of the tiles of a chunk that Pearl lets you walk on
    (collision bit clear) with two BDHC levels (bdhc_levels; of three or more, the top two) whose lower level can be
    walked or surfed onto (Pearl's rule: from a neighbour's level the step takes the nearest level, under 20 units);
    {} for the Gyms'. A lower level nobody reaches is left out (Canalave's canal bed under its bridge, a seam of the
    Contest Hall's seats): no second layer for it."""
    if chunk in gym_chunks() or os.environ.get('BRIDGE_LEVELS') == 'none': return {}
    land = json.load(open(os.path.join(LAND, f'{chunk:03d}.json')))
    lv = {(tx, tz): bdhc_levels(chunk, tx, tz) for tz in range(32) for tx in range(32)
          if not land['collision'][tz][tx]}
    cand = {t: v[:2] for t, v in lv.items() if len(v) >= 2}

    def enters(t, y):            # a step onto candidate t from height y takes its lower level?
        ys = [h for h, _ in lv[t]]
        near = min(range(len(ys)), key=lambda i: abs(ys[i] - y))
        return near == 1 and abs(ys[1] - y) < 20
    reached, todo = set(), []
    for (tx, tz) in cand:
        for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            n = (tx + dx, tz + dz)
            if not (0 <= n[0] < 32 and 0 <= n[1] < 32):
                ok = True                                # (from the next chunk: kept, to be safe)
            else:
                ok = n in lv and n not in cand and any(enters((tx, tz), h) for h, _ in lv[n])
                ok = ok or (n in cand and enters((tx, tz), cand[n][0][0]))   # (from a neighbour's deck)
            if ok:
                reached.add((tx, tz)); todo.append((tx, tz)); break
    while todo:
        tx, tz = todo.pop()
        for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            n = (tx + dx, tz + dz)
            if n in cand and n not in reached and enters(n, cand[(tx, tz)][1][0]):
                reached.add(n); todo.append(n)
    return {t: cand[t] for t in sorted(reached)}


@functools.lru_cache(maxsize=None)
def filler_chunks():
    """Overworld chunks in no zone (every matrix-0 cell holding them has header 0: the mountains between routes)."""
    m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    zoned, seen = set(), set()
    for cz, row in enumerate(m['maps']):
        for cx, c in enumerate(row):
            if c == 0xffff: continue
            seen.add(c)
            if m['headers'][cz][cx]: zoned.add(c)
    return frozenset(seen - zoned)


def deck_planes(chunk, land, surf, cells, heights, slopes, offsets):
    """The heights BDHC knows better than the model, on tiles Pearl walks: two_levels' upper level and other bridge
    tiles' top where the model's surface misses BDHC's by more than DECK_MATCH (or has none; Canalave's deck is a
    placed model), and overhangs beside a bridge: the model's surface 20+ units over BDHC's top. Those cells
    take BDHC's plane (class and flags kept; water under a deck's plate: a wall, below). Changes cells and heights in
    place; returns [(tx, tz, old height or None, new height)]."""
    out, two = [], two_levels(chunk)
    if chunk in gym_chunks() or os.environ.get('BRIDGE_LEVELS') == 'none': return out
    for tz in range(32):
        for tx in range(32):
            if land['collision'][tz][tx]: continue
            if (tx, tz) in two and land['behaviour'][tz][tx] in WATER_UNDER:
                # water whose BDHC has a deck's plate over it too (Route 208: the bridge's plate reaches half a
                # tile past its south edge): Pearl's walker on the deck finds water there, a wall on foot, and no
                # Surf from a bridge (pokeplatinum PlayerAvatar_CanUseSurf); Black 2 would offer Surf from the deck
                # onto water at the deck's height, so the upper layer is a wall (the water stays in layer 0)
                y, n = two[(tx, tz)][0]
                x, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
                a, b, got = plane_record(slopes, offsets, y, n, x, z)
                cells[tz * 32 + tx] = struct.pack('<HHI', a, b, SOLID[0] | SOLID[1] << 16)
                out.append((tx, tz, heights.get((tx, tz)), round(got)))
                heights[(tx, tz)] = round(got)
                continue
            beh = land['behaviour'][tz][tx]
            x, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
            if (tx, tz) in two: y, n = two[(tx, tz)][0]
            elif beh in BRIDGES:
                lv = bdhc_levels(chunk, tx, tz)          # (a deck with one level, or no way under it)
                if not lv: continue
                y, n = lv[0]
            elif beh in STAIRS or beh in MAT_FROM:
                continue                                 # (stairs and warp mats: stair_planes, floor_mats)
            else:
                # an overhang next to a bridge: the model's highest surface (the Cycling Road's edge beside Route
                # 206's path under it, Sunyshore's walkway railings) 20 or more units over Pearl's top level on a tile
                # Pearl walks: Pearl's walker is on its BDHC level there, under it. Only beside a bridge or a
                # two-level tile: elsewhere (Pal Park, Route 224, caves, Galactic HQ) Pearl's BDHC is sometimes a
                # flat stand-in under raised ground, so the model stays the better guess there (bridge_check lists)
                if chunk in filler_chunks(): continue  # (Mt. Coronet's mass in no zone: nobody walks there)
                if not any((tx + i, tz + j) in two or (0 <= tx + i < 32 and 0 <= tz + j < 32 and
                                                       land['behaviour'][tz + j][tx + i] in BRIDGES)
                           for i in (-1, 0, 1) for j in (-1, 0, 1)):
                    continue
                lv = bdhc_levels(chunk, tx, tz)
                s = surf.get((tx, tz))
                if not lv or s is None or s[0] < lv[0][0] + 20: continue
                y, n = lv[0]
            s = surf.get((tx, tz))
            if s is not None and abs(s[0] - y) <= DECK_MATCH: continue
            a, b, got = plane_record(slopes, offsets, y, n, x, z)
            k = tz * 32 + tx
            cells[k] = struct.pack('<HH', a, b) + cells[k][4:]
            out.append((tx, tz, heights.get((tx, tz)), round(got)))
            heights[(tx, tz)] = round(got)
    return out


def lower_layer(chunk, land, cells, slopes, offsets):
    """(layer-0 cells, {(tx, tz): lower height}) for a chunk with two_levels, else (None, {}): a copy of `cells`
    (layer 1, the decks) with each two-level tile's lower BDHC level: its plane, and what is under the deck (LOWER;
    else the deck's own class and flags, Pearl's single attribute)."""
    two = two_levels(chunk)
    if not two: return None, {}
    low, heights = list(cells), {}
    for (tx, tz), (_, (y, n)) in sorted(two.items()):
        x, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
        a, b, got = plane_record(slopes, offsets, y, n, x, z)
        k = tz * 32 + tx
        top = struct.unpack_from('<I', cells[k], 4)[0]
        under = LOWER.get(land['behaviour'][tz][tx])
        if under and not (top >> 16) & 1:                        # (a solid deck stays solid under: bump warps)
            top = under[0] | under[1] << 16
        low[k] = struct.pack('<HHI', a, b, top)
        heights[(tx, tz)] = round(got)
    return low, heights


def convert(chunk, slopes=None, offsets=None, around=None, solid_behaviours=()):
    """(WB container bytes, report dict) for Pearl land chunk `chunk`. `around` ({(dx, dz): chunk}, neighbours())
    lets a tile take its ground from a neighbour's model: Pearl's models overhang their chunk (Twinleaf: x to 324)."""
    if slopes is None: slopes, offsets = tables()
    land = json.load(open(os.path.join(LAND, f'{chunk:03d}.json')))
    model, fixes = fix_model(chunk, around=around)
    beds = bed_solid(chunk)
    plates = lift_plate(chunk)                        # (platform-lift plates: their bottom floor, _lift_plates)
    tris = chunk_triangles(chunk, around)
    flowers = chunk_triangles(chunk, around, flower_triangles)   # (the ground under flower carpets: ground())
    cells, unmapped, misses, nohit, walkable, heights, surf = [], {}, [], 0, {}, {}, {}
    for tz in range(32):
        for tx in range(32):
            beh, solid = land['behaviour'][tz][tx], land['collision'][tz][tx]
            if (tx, tz) in beds: solid = 1                # (under a bed model: bed_tiles)
            if beh in BEHAVIOURS and BEHAVIOURS[beh] is not None:
                cls, flags = BEHAVIOURS[beh]
            else:
                if beh not in BEHAVIOURS: unmapped[beh] = unmapped.get(beh, 0) + 1
                cls, flags = SOLID if solid else WALK
            if beh in solid_behaviours:
                cls, flags = SOLID                           # a bump warp (see ENTRANCES); its height stays the floor's
            if solid and not flags & 1: flags |= 1
            x, z = tx * 16 - 256 + 8, tz * 16 - 256 + 8
            s = ground(tris, flowers, x, z)
            if (tx, tz) in plates:
                s = (float(plates[(tx, tz)]), [0.0, 1.0, 0.0])
            surf[(tx, tz)] = s
            if s is None:
                nohit += not solid; a, b = 0, min(range(len(offsets)), key=lambda i: abs(offsets[i]))
            else:
                a, b, got = plane_record(slopes, offsets, s[0], s[1], x, z)
                if abs(got - s[0]) > MAX_ERR and not solid: misses.append((tx, tz, round(s[0], 1), round(got, 1)))
                if not solid and cls in (0x00, 0x0b): walkable[(tx, tz)] = round(got)   # plain ground (fly points)
                heights[(tx, tz)] = round(got)                                            # every tile (warps)
            cells.append(struct.pack('<HHI', a, b, cls | flags << 16))
    mats = floor_mats(land, cells, heights, solid_behaviours, slopes, offsets)   # (rooms: warp mats on their floor)
    stairs = []
    for st in stair_planes(land, tris, heights, slopes, offsets):   # the flights' 45-degree planes (STAIRS above)
        tx, tz, dx = st['foot'][0], st['foot'][1], st['dx']
        if st['way'] is None:
            stairs.append((tx, tz, 'flight in the next chunk')); continue
        if not st['way']:
            stairs.append((tx, tz, 'flat')); continue
        fx = tx + dx
        cls_flags = struct.unpack_from('<I', cells[tz * 32 + fx], 4)[0]
        cells[tz * 32 + fx] = struct.pack('<HHI', st['slope'] << 2, st['offset'], cls_flags)
        heights[(fx, tz)] = st['foot_y']                    # (a warp on the flight fires at the walker's height)
        stairs.append((tx, tz, 'up' if st['way'] > 0 else 'down'))
    low, low_heights = lower_layer(chunk, land, cells, slopes, offsets)       # (bridges: what is under the deck)
    decks = deck_planes(chunk, land, surf, cells, heights, slopes, offsets)   # (and BDHC's deck where it knows better)
    if low is not None:                              # one-level tiles: both layers the same (a one-level deck too)
        two = two_levels(chunk)
        low = [c if (k % 32, k // 32) in two else cells[k] for k, c in enumerate(low)]
    terrain = struct.pack('<HH', 32, 32) + b''.join(cells)
    if low is None:
        data = gf_container_build('WB', [model, terrain, struct.pack('<I', 0)])
    else:              # Black 2's two-level chunk: layer 0 the ground under the bridges, layer 1 with their decks
        data = gf_container_build('GC', [model, struct.pack('<HH', 32, 32) + b''.join(low), terrain,
                                         struct.pack('<I', 0)])
    return data, {'chunk': chunk, 'unmapped': unmapped, 'height_misses': misses, 'walkable_without_surface': nohit,
                  'walkable': walkable, 'heights': heights, 'fixes': fixes, 'stairs': stairs, 'mats': mats,
                  'decks': decks, 'heights_low': low_heights}


def terrains(container):
    """(magic, [terrain sections], the other sections by name) of a converted chunk: 'WB' [layer] or 'GC' [layer 0,
    layer 1] (convert), so callers that change a chunk's terrain change every layer."""
    from b2files import gf_container
    magic, secs = gf_container(container)
    return magic, (secs[1:3] if magic == 'GC' else secs[1:2]), {'model': secs[0], 'props': secs[-1]}


def rebuild(magic, model, layers, props):
    """The chunk container from its parts (terrains' inverse)."""
    return gf_container_build(magic, [model] + list(layers) + [props])


if __name__ == '__main__':
    sl, of = tables()
    for c in map(int, sys.argv[1:]):
        _, rep = convert(c, sl, of)
        print(json.dumps(rep))
