"""Pearl's doors as Black 2 doors that open (2026-10-20; user: "we need the doors to open like doors with a black space
behind it").

    python3 b2tools/pearl_doors.py check [--render] [--shots DIR] [--json OUT]

**Pearl** (pokediamond ov05_021F650C, the same 20 ids in pokeplatinum ov5_021D431C.c's door list): a door is its own
prop (build model), placed in the chunk in front of its building, never part of the building's model. Walking into a
door tile, Pearl finds the door prop by its model id next to the tile and plays the door's animations from
arc/bm_anime.narc, listed per model in arc/bm_anime_list.narc ({hasAnimations, flags, isBicycleSlope, -, 4 ids}):
entry 0 opens and entry 1 closes the door (4-entry hinged doors: 2 and 3 when coming out, the same swing in 6 frames
instead of 8). They are BCA0 joint animations (door_op / door_cl: the plate turns 90 degrees inwards about its hinge,
the prop's origin; pc_door_op: the Pokemon Center's glass slides and narrows; d_door_op: double doors) and one BTP0
(the elevator door, ele_door1: texture frames). Every Pearl building has its own recess behind the door (a box in the
building's model: dark in the houses, Marts, Gyms; Pearl's own colours), which the closed door covers.
**Black 2** (pokebw2 field_buildmodel.c, event_entrance_effect.c): a door is a prop whose info record has a door type
(1, 2, 3, 13, 14, 15; FieldPropResInfo_GetTypeConv -> 1) and its animations in the record's animation header
(controller 2 = dynamic, 1 per command, door_op = animation 0, door_cl = 1; BCA0 files stored right after the
header). Going in or coming out, the entrance event looks for the first door prop within 32 units (x) and 48 (z) of
the tile in front of the player (coming out: the player's tile), takes it out of the chunk's shared instance
(FieldPropSystem_CreateHandleAtPos) and plays 0 (open), then 1 (close), with the type's sounds (DOOR_SOUND_ID_LUT:
type 1 = 1669 open / 1670 close, Black 2's hinged house door; type 2 = 1671, its sliding automatic door). Black 2's
own buildings name their door in their record (door res + dx, dy, dz: the game adds a door prop there,
FieldPropSystem_CheckCreateDoorReq); a door placed as its own prop is found the same way (the search filters on the
prop's type only).
**So:** Pearl's door props stay where Pearl puts them, and each door model's info record in the area's building pack
becomes a Black 2 door record with Pearl's own animations (door_info, from pearl_buildings.build_pack): Pearl's door,
Pearl's movement, Pearl's recess behind it. Nothing to take out of the buildings: Pearl's buildings never held a
copy of their door.

`check` (offline, no ROM; HoennB2 exterior_check.py "doors" in spirit): every Pearl door warp of the installed zones
(tile 0x69) finds exactly one door prop in Black 2's search box, that prop's model gets a door record with two
animations in its area's pack, no other warp finds a door (a door would open where Pearl opens none). --render adds
offline renders (pearl_render, Black 2's camera 0 and Pearl's for comparison) per door set-up: how dark the open
doorway is, and how many dark pixels from behind the door's plane show round the CLOSED door (must be none).
"""
import json, math, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)

# Pearl's door models (pokediamond arm9/overlays/05/asm/ov05_021DA5B8.s ov05_021F650C, in that order; pokeplatinum
# names): door01, brown_wooden_door (t1_door1, Twinleaf), green_wooden_door (t2_door1), iron_door (t2_door2),
# jubilife_city_building_door (c1_door1), pokecenter_door (p_door), pokecenter_inside_door (door_pc01),
# gts_inside_door (door_wi01), hearthome_gym_inside_door (gym_door01), blue_door (c3_door1), iron_door_2 (c3_door2),
# yellow_wooden_door (t3_door1), blue_wooden_door (c4_door1), mansion_door (d3_door1), veilstone_dpt_store_door
# (c5_door_s), gym_door (gym_door00), card_door (card_door01), pokecenter_inside_counter_door (counter_pc04),
# hotel_grand_lake_door (l2_door1), elevator_door (ele_door1)
DOOR_MODELS = (66, 67, 68, 69, 246, 70, 427, 456, 260, 312, 313, 438, 444, 441, 442, 298, 484, 128, 527, 75)
# DoorAnimation_GetSoundEffectType: sliding (SEQ_SE_DP_DOOR10, no closing sound) and the Veilstone store's chime; the
# rest are hinged (DOOR_OPEN / DOOR_CLOSE2). Black 2's nearest: type 2 (automatic door, 1671), type 1 (house door).
SLIDING = {70, 427, 456, 298, 484, 75, 442}
B2_TYPE = {'hinged': 1, 'sliding': 2}
# Info record word 0x0c: an id Black 2's tools give every animated prop (0xFFFF without animations); the game's code
# never reads it (pokebw2). Black 2's own values: door_normal01-03 21, door_auto01 98.
B2_ANIM_ID = {1: 21, 2: 98}
DYNAMIC = 2                       # FIELD_PROP_ANMCNT_VTABLES[2]: commands play / play back / loop / pause / stop
NO_DOOR = 0xFFFF
SEARCH_X, SEARCH_Z = 32.0, 48.0   # FieldPropSearchArea_Set: x +-2 << 16, z +-3 << 16 (fx32: 32 and 48 units)
DOOR_TILE = 0x69                  # Pearl's door tile behaviour

_PEARL = {}


def pearl():
    """Pearl's build models, animation list and animations (the dump, read once)."""
    if not _PEARL:
        from gen4rom import Rom, narc_members
        rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
        _PEARL['build'] = narc_members(rom.read('fielddata/build_model/build_model.narc'))
        _PEARL['list'] = narc_members(rom.read('arc/bm_anime_list.narc'))
        _PEARL['anime'] = narc_members(rom.read('arc/bm_anime.narc'))
        _PEARL['by_bytes'] = {_PEARL['build'][m]: m for m in DOOR_MODELS}
    return _PEARL


def kind(model):
    return 'sliding' if model in SLIDING else 'hinged'


def animations(model):
    """Pearl's (open, close) animation files of door model `model` when going in (bm_anime_list entries 0 and 1)."""
    p = pearl()
    ids = struct.unpack_from('<4i', p['list'][model], 4)
    assert ids[0] >= 0 and ids[1] >= 0, f'door model {model}: no open/close animations {ids}'
    return p['anime'][ids[0]], p['anime'][ids[1]]


def supported(model):
    """Black 2's prop records take joint (BCA0) and texture-frame (BTP0) animations (its own c09gate_main has a
    dynamic BTP0); the elevator door's frames need their textures in the pack's set (extra_textures)."""
    return all(a[:4] in (b'BCA0', b'BTP0') for a in animations(model))


def extra_textures(bmd):
    """pearl_buildings.build_pack's hook: [(BTX0, texture, palette)] a door model's texture-frame animation shows
    besides the textures its materials use (the elevator door's ele_door.2-4 and their palettes), else []."""
    import nsbtx, pearl_buildings
    model = pearl()['by_bytes'].get(bytes(bmd))
    if model is None or not supported(model) or os.environ.get('PEARL_DOORS') == '0': return []
    if all(a[:4] != b'BTP0' for a in animations(model)): return []
    src = pearl_buildings.btx0_of(bmd)
    t = nsbtx._parse(src)
    pals = {n for n, _ in t['pals']}
    used = {tx for tx, _ in nsbtx.material_pairs(bmd)}
    return [(src, n, n + '_pl' if n + '_pl' in pals else None) for n, _ in t['texs'] if n not in used]


def door_record(res_id, model):
    """Black 2 info record (FieldPropResInfo + its animations) for Pearl door model `model` as resource res_id."""
    a0, a1 = animations(model)
    typ = B2_TYPE[kind(model)]
    head = struct.pack('<HHHhhhHH', res_id, typ, NO_DOOR, 0, 0, 0, B2_ANIM_ID[typ], 0)
    anm = struct.pack('<BBBB4I', DYNAMIC, 0, 1, 2, 0x14, 0x14 + len(a0), 0xFFFFFFFF, 0xFFFFFFFF)
    rec = head + anm + a0 + a1
    assert len(head + anm) == 36 and len(rec) % 4 == 0
    return rec


def door_info(res_id, bmd):
    """pearl_buildings.build_pack's hook: the door record when `bmd` is one of Pearl's door models (by its bytes),
    else None (a plain building record)."""
    if os.environ.get('PEARL_DOORS') == '0': return None          # (comparisons: the static doors of before)
    model = pearl()['by_bytes'].get(bytes(bmd))
    if model is None or not supported(model): return None
    return door_record(res_id, model)


def read_record(rec):
    """(type, door res, anim controller, per-command count, [animation files]) of an info record."""
    _, typ, door = struct.unpack_from('<HHH', rec, 0)
    ct, _, per, _ = rec[16:20]
    offs = struct.unpack_from('<4I', rec, 20)
    starts = sorted(o for o in offs if o != 0xFFFFFFFF)
    files = []
    for o in offs:
        if o == 0xFFFFFFFF: continue
        nxt = [s for s in starts if s > o]
        files.append(rec[16 + o:16 + (nxt[0] if nxt else len(rec) - 16)])
    return typ, door, ct, per, files


# ------------------------------------------------------------------------------------------------------ the check
def node_count(bmd):
    import pearl_mesh, pearl_buildings
    m = pearl_mesh.Model(pearl_buildings.mdl_only(bmd))
    return len(pearl_mesh._ndict(m.data, m.m + 0x40))


def anim_frames(f):
    """(frames, nodes driven or None) of an animation file's first animation (BCA0: NNSG3dResJntAnm numNode)."""
    j = struct.unpack_from('<I', f, 0x10)[0]                     # its block (JNT0, PAT0, ...)
    import pearl_mesh
    at = pearl_mesh._ndict(f, j + 8)[0][0]
    a = j + struct.unpack_from('<I', f, at)[0]
    assert f[a:a + 4] in (b'J\x00AC', b'M\x00PT'), f[a:a + 4]
    frames, nodes = struct.unpack_from('<HH', f, a + 4)
    return frames, (nodes if f[a] == ord('J') else None)


class World:
    """Installed zones, their warps (sinnoh_events.Planner: the records the build writes) and door props."""

    def __init__(self):
        from patches import sinnoh_events
        self.pl = pl = sinnoh_events.Planner()
        self.world = pl.world
        self.props = {}                      # matrix id -> [(global x, y, z, model, chunk, prop index)]

    def zone_list(self):
        w = self.world
        out = [(int(k), v, False) for k, v in w['zones'].items()] + [(int(k), v, True) for k, v in w['rooms']['zones'].items()]
        return sorted(out, key=lambda t: t[1]['b2_zone'])

    def door_props(self, mid):
        if mid not in self.props:
            m = self.pl.matrix(mid)
            out = []
            for cz in range(m['height']):
                for cx in range(m['width']):
                    c = m['maps'][cz][cx]
                    if c == 0xffff: continue
                    for i, p in enumerate(self.pl.land(c)['props']):
                        if p['model'] in DOOR_MODELS:
                            x, y, z = p['pos']
                            out.append((cx * 512 + 256 + x, y, cz * 512 + 256 + z, p['model'], c, i, cx, cz))
            self.props[mid] = out
        return self.props[mid]

    def area_models(self, zone, room):
        w = self.world
        a = (w['rooms']['areas'] if room else w['areas'])[str(zone['pearl_area'])]
        return a['models']


STEP = {1: (0, 1), 2: (0, -1), 3: (1, 0), 4: (-1, 0)}   # a type-1 mat's dir (the way out): the tile in front
# (zone name regex, door model, reason): a non-door warp that opens a door, on purpose
ACCEPT = [
    ('POKECENTER_2F|POKEMON_LEAGUE_LOBBY_2F', 427,
     "the Union Room mat at (8, 2) in front of the Center 2F's inner door: Pearl's desk scripts (script files 206/207, "
     "PrepareDoorAnimation) open this door when the player goes through; here the mat's warp opens it"),
]


def found(props, x, z):
    return [p for p in props if abs(p[0] - x) <= SEARCH_X and abs(p[2] - z) <= SEARCH_Z]


def check(render=False, shots=None):
    W = World()
    rep = dict(door_warps=0, one=0, none=[], several=[], stray=[], accepted=[], records={}, unsupported=[],
               missing_record=[], static=[], props=0, props_at_warp=0, doors_unused=[])
    used = set()
    for pid, zone, room in W.zone_list():
        pz = W.pl.zones[pid]
        mid = pz['matrix']
        props = W.door_props(mid)
        warps = W.pl.warps(pid)[0]
        ev = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'events', f"{pz['events']:03d}.json")))['warp_events']
        models = set(W.area_models(zone, room))
        for k, w in enumerate(warps):
            if w['x'] >= 0x7FF0: continue                                  # (to a room not installed: never fires)
            pw = ev[k]
            t = W.pl.tile(W.pl.matrix(mid), pw['x'], pw['z'])
            spots = [(w['x'], w['z'])]
            if w['type'] in (0, 1) and w['dir'] in STEP:
                dx, dz = STEP[w['dir']]
                spots.append((w['x'] + 16 * dx, w['z'] + 16 * dz))
            hit = {p[:6]: p for s in spots for p in found(props, *s)}
            where = f"{zone['name'][4:]} ({pw['x']},{pw['z']})"
            if t and t[0] == DOOR_TILE:
                rep['door_warps'] += 1
                if len(hit) == 1:
                    rep['one'] += 1
                    p = next(iter(hit.values()))
                    used.add((mid, p[4], p[5]))
                    if p[3] not in models: rep['missing_record'].append(f'{where}: door model {p[3]} not in the pack')
                    if not supported(p[3]): rep['static'].append(f'{where}: door model {p[3]}')
                elif not hit:
                    rep['none'].append(where)
                else:
                    rep['several'].append(f"{where}: {sorted((p[3], round(p[0] - w['x']), round(p[2] - w['z'])) for p in hit.values())}")
                    used |= {(mid, p[4], p[5]) for p in hit.values()}
            elif hit:
                import re
                why = [a[2] for a in ACCEPT if re.search(a[0], zone['name']) and {p[3] for p in hit.values()} == {a[1]}]
                (rep['accepted'] if why else rep['stray']).append(
                    f"{where} type {w['type']}: door {sorted(p[3] for p in hit.values())}" + (f' ({why[0]})' if why else ''))
                used |= {(mid, p[4], p[5]) for p in hit.values()}
        for p in props:
            if p[3] in models:
                rec = door_info(0, pearl()['build'][p[3]])
                if rec is None:
                    if (p[3], zone['name']) not in rep['unsupported']: rep['unsupported'].append((p[3], zone['name']))
                else:
                    rep['records'][p[3]] = rec
    allp = {(mid, p[4], p[5]): p for mid in W.props for p in W.props[mid]}
    rep['props'] = len(allp)
    rep['props_at_warp'] = len(used & set(allp))
    rep['doors_unused'] = sorted({(allp[k][3]) for k in set(allp) - used})
    # the records: two animations, each driving the model's nodes
    rep['record_lines'] = []
    for m, rec in sorted(rep['records'].items()):
        typ, door, ct, per, files = read_record(rec)
        n = node_count(pearl()['build'][m])
        frames = [anim_frames(f) for f in files]
        ok = typ in (1, 2) and door == NO_DOOR and ct == DYNAMIC and per == 1 and len(files) == 2 and \
            all(f[:4] in (b'BCA0', b'BTP0') and fr[1] in (None, n) for f, fr in zip(files, frames))
        rep['record_lines'].append((m, kind(m), typ, [fr[0] for fr in frames], n, len(rec), ok))
    if render:
        rep['render'] = render_doors(W, used, shots)
    return rep


# ---------------------------------------------------------------------------------------------- offline renders
DARK_MAX = 100                    # a rendered pixel this dark (largest channel, 0-255) counts as darkness (Pearl's
                                  # recesses render 60-90 under pearl_render's light; their walls 150-230)
B2_CAM = dict(dist=237.0, pitch=53.2, half=20.0)      # Black 2's camera 0 (a/0/5/9 record 0)
PEARL_CAM = dict(dist=667.0, pitch=59.0, half=8.09)   # Pearl's field camera (notes/MAP_LOOK.md 1d)
VIEWS = [(sx, sz) for sz in (1, 2, 3, 4) for sx in (-6, -4, -2, 0, 2, 4, 6)]   # player tile - door tile
SCALE = 3


def node_mats(model):
    """{shape index: (R 3x3, T 3)} from the model's nodes (rest pose) and render commands (pearl_mesh ignores them;
    the double doors' halves stand 12 units either side of their root)."""
    import numpy as np, pearl_mesh
    d, m = model.data, model.m
    base = m + 0x40
    local = []
    for at, _ in pearl_mesh._ndict(d, base):
        p = base + struct.unpack_from('<I', d, at)[0]
        flag, r00 = struct.unpack_from('<Hh', d, p)
        q = p + 4
        T = np.zeros(3); R = np.eye(3); S = np.ones(3)
        if not flag & 1:
            T = np.array(struct.unpack_from('<3i', d, q)) / 4096; q += 12
        if not flag & 2:
            if flag & 8:                                   # pivot-compressed rotation: not used by these props
                raise ValueError('pivot rotation')
            v = (r00,) + struct.unpack_from('<8h', d, q); q += 16
            R = np.array(v, float).reshape(3, 3) / 4096
        if not flag & 4:
            S = np.array(struct.unpack_from('<3i', d, q)) / 4096; q += 24
        local.append((R * S[None, :], T))
    world, stack, cur, shape_node = {}, {}, 0, {}
    i, end = m + model.osbc, m + model.omat
    while i < end:
        c = d[i]; op = c & 0x1F
        if op == 1: break
        if op == 6:
            node, parent = d[i + 1], d[i + 2]
            n = 4 + ((c >> 5) & 1) + ((c >> 6) & 1)
            R, T = local[node]
            if parent != node and parent in world:
                PR, PT = world[parent]
                world[node] = (PR @ R, PR @ T + PT)
            else:
                world[node] = (R, T)
            cur = node
            if c & 0x20: stack[d[i + 4]] = node
        elif op == 3:
            cur = stack.get(d[i + 1], cur); n = 2
        elif op == 5:
            shape_node[d[i + 1]] = cur; n = 2
        elif op == 9:
            n = 3 + 2 * d[i + 2]
        else:
            n = {0: 1, 2: 3, 4: 2, 7: 2, 8: 2, 0xb: 1, 0xc: 3, 0xd: 3}.get(op, 1)
        i += n
    return {k: world.get(v, (np.eye(3), np.zeros(3))) for k, v in shape_node.items()}


_MODELS = {}


def placed_model(model_id):
    """(pearl_mesh.Model with its nodes' rest transforms applied to the vertices, textures) of a Pearl build model."""
    if model_id not in _MODELS:
        import numpy as np, pearl_mesh, pearl_buildings, pearl_render as R
        b = pearl()['build'][model_id]
        m = pearl_mesh.Model(pearl_buildings.mdl_only(b))
        mats = node_mats(m)
        ps = m.pos_scale / 4096
        for k, s in enumerate(m.shapes):
            Rm, T = mats.get(k, (np.eye(3), np.zeros(3)))
            if np.allclose(Rm, np.eye(3)) and not T.any(): continue
            s.groups = [(g, [[v.moved(*[int(round(c)) for c in (Rm @ (np.array(v.pos) * ps) + T) / ps])
                               for v in p] for p in ps_]) for g, ps_ in s.groups]
        _MODELS[model_id] = (m, R.textures(pearl_buildings.btx0_of(b)))
    return _MODELS[model_id]


def scene_props(W, mid, door):
    """The props round door prop `door` (global coordinates, same matrix): the door, the rest within 64 units."""
    gx, gy, gz = door[0], door[1], door[2]
    m = W.pl.matrix(mid)
    out = []
    for cz in range(max(0, door[7] - 1), min(m['height'], door[7] + 2)):
        for cx in range(max(0, door[6] - 1), min(m['width'], door[6] + 2)):
            c = m['maps'][cz][cx]
            if c == 0xffff: continue
            for i, p in enumerate(W.pl.land(c)['props']):
                x, y, z = cx * 512 + 256 + p['pos'][0], p['pos'][1], cz * 512 + 256 + p['pos'][2]
                if abs(x - gx) < 80 and abs(z - gz) < 80:
                    out.append((p['model'], (x - gx, y - gy, z - gz), (c, i) == (door[4], door[5])))
    return out


def render_view(parts, cam, player, scale, which, window):
    """Render the props `parts` [(model, offset, is_door)] (door at the origin) for the camera `cam` looking at the
    player's position; which: 'shut' (all), 'open' (no door), 'door' (the door alone). window: (x0, y0, x1, y1) of the
    256x192 screen to draw (times scale). Returns the pearl_render.Scene."""
    import numpy as np, pearl_render as R
    px, py, pz = player
    p = math.radians(cam['pitch'])
    eye = (px, py + cam['dist'] * math.sin(p), pz + cam['dist'] * math.cos(p))
    x0, y0, x1, y1 = window
    sc = R.Scene((x1 - x0) * scale, (y1 - y0) * scale, eye, (px, py, pz), half=cam['half'])
    k = (192 * scale / 2) / math.tan(math.radians(cam['half']))
    cx, cy = (128 - x0) * scale, (96 - y0) * scale

    def project(P, sc=sc):
        q = P - sc.eye
        zc = q @ sc.f
        return np.stack([cx + k * (q @ sc.r) / zc, cy - k * (q @ sc.u) / zc, zc], 1)
    sc.project = project
    if which == 'door':                    # (the door alone, drawn opaque: its glass, too, makes its silhouette)
        tri = sc.tri
        sc.tri = lambda S, UV, C, tex, wrap, am, pid, xlu=1.0: tri(S, UV, C, tex, wrap, am, pid, 1.0)  # noqa: E731
    for model, off, is_door in parts:
        if (which == 'open' and is_door) or (which == 'door' and not is_door): continue
        m, tex = placed_model(model)
        R.draw_model(sc, m, tex, offset=off, setup=R.LIGHTS['pearl_indoor'])
    return sc


def door_box(model):
    """(x0, x1, y0, y1, z front) of a door model's closed geometry (model units)."""
    import numpy as np
    m, _ = placed_model(model)
    P = np.array([v.pos for s in m.shapes for p in s.polys for v in p], float) * m.pos_scale / 4096
    return P[:, 0].min(), P[:, 0].max(), P[:, 1].min(), P[:, 1].max(), P[:, 2].max()


def measure(parts, door_model, tile_off, cam, view, scale=SCALE, indoor=False):
    """Dark share of the open doorway and dark pixels from behind the door's plane round the closed door, one view.
    tile_off: (x, z) of the door warp tile's centre from the door prop's origin. indoor: what nothing covers shows
    Black 2's clear colour, black in rooms, the sky outdoors."""
    import numpy as np
    bx0, bx1, by0, by1, bzf = door_box(door_model)
    player = (tile_off[0] + 16 * view[0], 0.0, tile_off[1] + 16 * view[1])
    # the screen window round the door (its box, 8 units of margin)
    import pearl_render as R
    probe = render_view([], cam, player, 1, 'shut', (0, 0, 256, 192))
    corners = np.array([(x, y, z) for x in (bx0 - 8, bx1 + 8) for y in (by0 - 4, by1 + 8) for z in (bzf - 24, bzf + 8)], float)
    S = probe.project(corners)
    x0, y0 = int(max(0, math.floor(S[:, 0].min()))), int(max(0, math.floor(S[:, 1].min())))
    x1, y1 = int(min(256, math.ceil(S[:, 0].max()))), int(min(192, math.ceil(S[:, 1].max())))
    if x1 - x0 < 4 or y1 - y0 < 4: return None                       # (off screen)
    win = (x0, y0, x1, y1)
    shut = render_view(parts, cam, player, scale, 'shut', win)
    opened = render_view(parts, cam, player, scale, 'open', win)
    alone = render_view(parts, cam, player, scale, 'door', win)
    # the visible door: its pixels where the door is what the shut picture shows
    door = np.isfinite(alone.z) & ~(shut.z < alone.z - 1e-3)      # (nothing opaque in front of it; glass doors too)
    if door.sum() < 4: return None
    # world z (relative to the door's origin) of what each pixel shows: depth along the view ray
    H, Wd = shut.z.shape
    ys, xs = np.mgrid[0:H, 0:Wd]
    k = (192 * scale / 2) / math.tan(math.radians(cam['half']))
    cx, cy = (128 - x0) * scale, (96 - y0) * scale
    dirs = (shut.f[None, None, :] + ((xs + 0.5 - cx) / k)[..., None] * shut.r[None, None, :]
            - ((ys + 0.5 - cy) / k)[..., None] * shut.u[None, None, :])
    def world(sc):
        P = sc.eye[None, None, :] + dirs * np.where(np.isfinite(sc.z), sc.z, 0)[..., None]
        return P
    Ps = world(shut)
    behind = np.isfinite(shut.z) & (Ps[..., 2] < bzf - 0.3) & (Ps[..., 0] > bx0 - 4) & (Ps[..., 0] < bx1 + 4) \
        & (Ps[..., 1] > by0 - 2) & (Ps[..., 1] < by1 + 4)
    dark = lambda sc: np.where(np.isfinite(sc.z), sc.col.max(2) * 255 / 31 <= DARK_MAX, indoor)   # noqa: E731
    near = np.zeros_like(door)
    rr = 4 * scale
    for dy in range(-rr, rr + 1, scale):
        for dx in range(-rr, rr + 1, scale):
            near |= np.roll(np.roll(door, dy, 0), dx, 1)
    rim = near & ~door & behind & dark(shut)
    see = near & ~door & behind
    op = dark(opened)[door]
    lum = np.where(np.isfinite(opened.z), opened.col.max(2) * 255 / 31, 0 if indoor else 30 * 255 / 31)
    return dict(open_dark=float(op.mean()), open_lum=float(lum[door].mean()),
                rim_px=int(rim.sum()), rim_1x=float(rim.sum()) / scale / scale, see_px=int(see.sum()),
                pics=(shut, opened, door, rim, see))


def render_doors(W, used, shots=None):
    """Per door set-up (door model + what stands round it), the worst closed-door rim over VIEWS and the open
    doorway's darkness with the player in front of the door (Black 2's camera), and Pearl's camera head-on."""
    import numpy as np
    setups = {}
    for mid, props in W.props.items():
        for p in props:
            if (mid, p[4], p[5]) not in used or not supported(p[3]): continue
            parts = scene_props(W, mid, p)
            tile = (math.floor(p[0] / 16) * 16 + 8, math.floor(p[2] / 16) * 16 + 8)
            key = (p[3], tuple(sorted((m, tuple(round(c, 1) for c in o), d) for m, o, d in parts)))
            setups.setdefault(key, dict(parts=parts, model=p[3], where=[], props=[], indoor=mid != 0))
            setups[key]['where'].append((mid, p[4], p[5]))
            setups[key]['props'].append(p)
    out = []
    for n, (key, s) in enumerate(sorted(setups.items(), key=lambda kv: (kv[0][0], -len(kv[1]['where'])))):
        p = s['props'][0]
        # the door warp tile in front: the tile the door prop's box centre covers, its centre (door coordinates)
        bx0, bx1, by0, by1, bzf = door_box(s['model'])
        gx, gz = p[0] + (bx0 + bx1) / 2, p[2] + bzf
        tx, tz = math.floor(gx / 16) * 16 + 8 - p[0], math.floor(gz / 16) * 16 + 8 - p[2]
        worst, head, ahead = None, None, None
        for v in VIEWS:
            r = measure(s['parts'], s['model'], (tx, tz), B2_CAM, v, indoor=s['indoor'])
            if r is None: continue
            if v == (0, 1): head = r
            if v == (0, 2): ahead = r
            if worst is None or r['rim_px'] > worst[1]['rim_px']: worst = (v, r)
        pr = measure(s['parts'], s['model'], (tx, tz), PEARL_CAM, (0, 1), indoor=s['indoor'])
        line = dict(model=s['model'], count=len(s['where']), sample=p[:3],
                    open_dark=head and head['open_dark'], open_lum=head and head['open_lum'],
                    rim_1x=worst and worst[1]['rim_1x'], worst_view=worst and worst[0],
                    ahead_rim_1x=ahead and ahead['rim_1x'], pearl_rim_1x=pr and pr['rim_1x'],
                    pearl_open_dark=pr and pr['open_dark'], pearl_open_lum=pr and pr['open_lum'])
        out.append(line)
        if shots and head:
            from PIL import Image
            os.makedirs(shots, exist_ok=True)
            ims = []
            for sc in head['pics'][:2] + (worst[1]['pics'][0],):
                ims.append(sc.image(None, (255, 0, 255)))
            w = sum(i.width for i in ims) + 8 * (len(ims) - 1)
            im = Image.new('RGB', (w, max(i.height for i in ims)), (255, 0, 255))
            x = 0
            for i in ims: im.paste(i, (x, 0)); x += i.width + 8
            im.save(os.path.join(shots, f'door_{n:02d}_m{s["model"]}.png'))
    return out


def main(argv):
    if not argv or argv[0] != 'check':
        print(__doc__); return 1
    render = '--render' in argv
    shots = next((a.split('=', 1)[1] for a in argv if a.startswith('--shots=')), None)
    out = next((a.split('=', 1)[1] for a in argv if a.startswith('--json=')), None)
    rep = check(render, shots)
    print(f"door warps (Pearl door tiles in installed zones): {rep['door_warps']}; one door prop in Black 2's search "
          f"box: {rep['one']}; none: {len(rep['none'])}; several: {len(rep['several'])}")
    for x in rep['none']: print('  no door:', x)
    for x in rep['several']: print('  several:', x)
    print(f"  of these, the door stays static (a texture-frame door, not converted): {len(rep['static'])}")
    for x in rep['static']: print('    static:', x)
    print(f"other warps that would open a door: {len(rep['stray'])} (+{len(rep['accepted'])} accepted)")
    for x in rep['stray']: print('  stray:', x)
    for x in rep['accepted']: print('  accepted:', x)
    print(f"door props: {rep['props']} placed, {rep['props_at_warp']} at a warp (models of the others: "
          f"{rep['doors_unused']}: scripted doors, decorations)")
    for x in rep['missing_record']: print('  no record:', x)
    for m, z in rep['unsupported']: print(f'  static (texture-frame door, not converted): model {m} in {z}')
    print('door records (model, kind, Black 2 type, frames open/close, nodes, record bytes, ok):')
    for line in rep['record_lines']: print('  ', line)
    bad = len(rep['none']) + len(rep['several']) + len(rep['stray']) + len(rep['missing_record']) + \
        sum(not l[-1] for l in rep['record_lines'])
    if 'render' in rep:
        print('renders (pearl_render, Pearl\'s light; Black 2 camera 0, the player 1 tile in front for the open doorway; '
              f'the dark gap round the CLOSED door in screen pixels from 2 tiles south and the worst of {len(VIEWS)} '
              'views; Pearl\'s camera head-on):')
        for r in rep['render']:
            f = lambda v, fmt: '-' if v is None else format(v, fmt)   # noqa: E731
            print(f"  model {r['model']:3d} x{r['count']:2d} at {tuple(round(c) for c in r['sample'])}: open "
                  f"{f(r['open_dark'], '.0%')} dark (mean {f(r['open_lum'], '.0f')}/255); closed: dark gap round "
                  f"the door {f(r['ahead_rim_1x'], '.1f')} px from 2 tiles south, {f(r['rim_1x'], '.1f')} px at worst "
                  f"{r['worst_view']}; Pearl's camera: {f(r['pearl_rim_1x'], '.1f')} px, open "
                  f"{f(r['pearl_open_dark'], '.0%')} dark (mean {f(r['pearl_open_lum'], '.0f')})")
    if out:
        json.dump({k: v for k, v in rep.items() if k != 'records'}, open(out, 'w'), indent=1, default=str)
    print('OK' if not bad else f'{bad} problems')
    return 0 if not bad else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
