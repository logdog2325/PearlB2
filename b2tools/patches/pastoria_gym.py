"""The Pastoria Gym's water puzzle (Pearl's Crasher Wake gym; chapter 5a, 2026-10-25). List it after sinnoh_rooms
and sinnoh_events (the gym's zone and heights), after zone_effects (the gimmick table), and after season_weather
(another ITCM user).

Pearl (pokeplatinum overlay008/gym_features.c PastoriaGym_*, terrain_collision_manager.c; pokediamond's
CheckPastoriaGymButton is not decompiled): a plate of water covers the pool, tiles x 1-25, z 2-39, at 0, 32 or 64
(the model pastoria_gym_water_floor, build model 242, at (256, h, 256)); the floor buttons (build models 239 blue, 240
green, 241 orange, under Pearl's step triggers of scripts 2, 3 and 4) move it to the top, the middle and the bottom,
one unit a frame. A tile whose water is above its floor gets the water as a second height: solid over the pool's
tiles (behaviour 0x59) and walls, walkable over the rest (the gaps between the walkways, bridged at the water's
height). Without the water the gaps are 64-unit pits and Crasher Wake can't be reached.

Black 2: the decomp's src/pearlb2/pastoria_gym_itcm.c (on the pearlb2 branch) adds that layer through
PearlB2_AppendTerrainLayers and runs the water as gimmick 30 (an empty slot of GIMMICK_OVERLAY_INFO). This patch:
- a/1/0/2 (the zone -> gimmick table): the gym's zone gets gimmick 30;
- a/2/7/6 (Humilau Gym's resources, no Sinnoh zone uses that gimmick): Pearl's water model appended (BMD0 with its
  textures), the gimmick's expanded-object scene;
- ITCM: the table the C reads (PearlB2PastoriaGym: the plate's tiles, the buttons, the heights, the works), its
  address in gPearlB2PastoriaGym. Without the symbol (an older decomp) the patch does nothing to the code.
The heights: each level's collision height is the converted floor nearest to Pearl's level (work/world/
heights_rooms.json: -2, 30, 62: Pearl's floors are 2 units under its water levels), the model's heights Pearl's.
The scripts (pearl_story PressPastoriaGymButton -> pl_PressPastoriaGymButton) ask through PVAR_PASTORIA_GYM_PRESS.
"""
import json, os, struct, sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, resident, narcio  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
GYM = 'MAP_PASTORIA_GYM'
GIMMICK_TABLE_ARC, GIMMICK = 102, 30
MODEL_ARC, WATER_MODEL = 276, 242
BUTTONS = {239: 2, 240: 1, 241: 0}         # Pearl build model -> level (0 bottom, 1 middle, 2 top)
LEVELS = (0, 32, 64)                       # Pearl's water heights (PASTORIA_WATER_HEIGHT_*)
LEVEL_VARS = ('0x4003', '0x4002', '0x4001')    # Pearl's button works of the bottom, middle and top (scripts 4, 3, 2)
PLATE = (1, 2, 25, 38)                     # x0, z0, width, depth (DynamicTerrainHeightManager_SetPlate)
MODEL_POS = (256, 256)
POOL, WALKWAY_GAP = 1, 2
POOL_BEHAVIOUR = 0x59                      # TILE_BEHAVIOR_DYNAMIC_HEIGHT_COLLISION
FX = 4096


def gym():
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))['rooms']
    z = next(v for v in world['zones'].values() if v['name'] == GYM)
    mat = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f'{z["pearl_matrix"]:03d}.json')))
    return z['b2_zone'], [row[0] for row in mat['maps']]     # the zone, its chunks top to bottom (one column)


def tiles_and_buttons(chunks):
    """({(x, z): (collision, behaviour)}, [(x, z, level)]) over the gym's chunks (32 x 32 each, one column)."""
    tiles, buttons = {}, []
    for i, c in enumerate(chunks):
        land = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))
        for z in range(32):
            for x in range(32):
                tiles[x, 32 * i + z] = (land['collision'][z][x], land['behaviour'][z][x])
        for p in land['props']:
            if p['model'] in BUTTONS:
                x, _, z = p['pos']
                buttons.append((int((x + 256) // 16), 32 * i + int((z + 256) // 16), BUTTONS[p['model']]))
    return tiles, sorted(buttons)


def check_buttons(buttons):
    """Pearl's step triggers of the gym's scripts 2-4 lie on its buttons, group for group (the press reads the
    button under the player)."""
    pz = next(z for z in json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json'))) if z['name'] == GYM)
    events = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'events', f'{pz["events"]:03d}.json')))
    level_of_script = {2: 2, 3: 1, 4: 0}
    trig = sorted((c['x'], c['z'], level_of_script[c['script']]) for c in events['coord_events'])
    assert trig == buttons, f'Pastoria Gym buttons {buttons} != triggers {trig}'


def floor_heights(chunks):
    """The converted floors nearest to Pearl's three water heights (work/world/heights_rooms.json, whole units)."""
    hs = json.load(open(os.path.join(ROOT, 'work', 'world', 'heights_rooms.json')))
    seen = Counter()
    for i, c in enumerate(chunks):
        for k, y in hs.get(str(c), {}).items():
            x, z = map(int, k.split(','))
            if PLATE[0] <= x < PLATE[0] + PLATE[2] and PLATE[1] <= 32 * i + z < PLATE[1] + PLATE[3]:
                seen[round(y)] += 1
    out = []
    for lv in LEVELS:
        near = [(n, y) for y, n in seen.items() if abs(y - lv) <= 6]
        assert near, f'no floor near Pearl level {lv}: {seen.most_common(8)}'
        out.append(max(near)[1])
    return out


def apply(files):
    zone, _ = gym()
    # the zone -> gimmick table: u32 zone, u32 gimmick
    t = narcio.load(files, GIMMICK_TABLE_ARC)
    rows = [struct.unpack_from('<II', t[0], i) for i in range(0, len(t[0]), 8)]
    others = [g for z, g in rows if z == zone and g != GIMMICK]
    assert not others, f'zone {zone} already has gimmick {others}'
    assert all(g != GIMMICK for z, g in rows if z != zone), f'gimmick {GIMMICK} given to another zone'
    if (zone, GIMMICK) not in rows:
        rows.append((zone, GIMMICK))
    t[0] = b''.join(struct.pack('<II', z, g) for z, g in rows)
    narcio.save(files, GIMMICK_TABLE_ARC, t)
    # Pearl's water model after Humilau Gym's resources
    from gen4rom import Rom, narc_members
    model = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read('fielddata/build_model/build_model.narc'))[WATER_MODEL]
    assert model[:4] == b'BMD0', 'Pearl build model 242 is not a BMD0'
    m = narcio.load(files, MODEL_ARC)
    assert len(m) == len(narcio.load(VANILLA, MODEL_ARC)), f'a/2/7/6 has {len(m)} files: another patch appended'
    narcio.save(files, MODEL_ARC, m + [model])
    return f'pastoria_gym: zone {zone} -> gimmick {GIMMICK}; Pearl\'s water model (build model {WATER_MODEL}, {len(model)} B) = a/2/7/6 file {len(m)}'


def table_blob(base):
    import decomp
    zone, chunks = gym()
    tiles, buttons = tiles_and_buttons(chunks)
    check_buttons(buttons)
    reg = json.load(open(os.path.join(ROOT, 'data', 'pearl_story_ids.json')))
    works = [int(reg['vars'][v]['b2'], 16) for v in LEVEL_VARS]
    press = int(reg['new']['PVAR_PASTORIA_GYM_PRESS']['b2'], 16)
    floors = floor_heights(chunks)
    x0, z0, w, d = PLATE
    grid = bytearray()
    for z in range(z0, z0 + d):
        for x in range(x0, x0 + w):
            coll, beh = tiles[x, z]
            grid.append(POOL if coll or beh == POOL_BEHAVIOUR else WALKWAY_GAP)
    file_id = len(narcio.load(VANILLA, MODEL_ARC))
    head = 68
    tiles_at = base + head
    buttons_at = tiles_at + len(grid)
    blob = struct.pack('<7H5B5x', zone, press, *works, MODEL_ARC, file_id, x0, z0, w, d, len(buttons))
    blob += struct.pack('<3i3i3i', *(f * FX for f in floors), *(lv * FX for lv in LEVELS),
                        MODEL_POS[0] * FX, MODEL_POS[1] * FX, FX)
    blob += struct.pack('<II', tiles_at, buttons_at)
    assert len(blob) == head
    blob += bytes(grid) + bytes(v for b in buttons for v in b)
    return blob, dict(floors=floors, buttons=len(buttons), pool=grid.count(POOL), gaps=grid.count(WALKWAY_GAP))


def apply_code(code):
    import decomp
    slot = decomp.symbol('gPearlB2PastoriaGym', code)
    if slot is None:
        return 'pastoria_gym: no gPearlB2PastoriaGym in this decomp (no water code): nothing'
    info = {}

    def build(base):
        blob, i = table_blob(base)
        info.update(i)
        return blob, {}
    base, end, _ = resident.install(code, build)  # its table in the resident section (b2tools/resident.py)
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2PastoriaGym at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return (f'pastoria_gym: table {end - base} B at {base:#x} (gPearlB2PastoriaGym {slot:#x}); floors '
            f'{info["floors"]}, {info["buttons"]} buttons, {info["pool"]} pool tiles, {info["gaps"]} gap tiles')
