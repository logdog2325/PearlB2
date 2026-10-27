"""People in Pearl's rooms as Black 2's camera draws them (the furniture pass, 2026-10-20; HoennB2's rooms_view.py,
notes/INTERIORS.md "Indoor check", ported to the rooms sinnoh_rooms builds). notes/MAP_LOOK.md "People drawn into
furniture".

    python3 pearl_rooms_view.py [--model hw|exact|desmume] [--fixed 0|1] [--summary] [--kinds mn] [ZONE ...]
    python3 pearl_rooms_view.py --render OUT.png ZONE X,Z [DIR] [--model ...]   the room from the game camera with its
                                                           people and the player at zone tile X,Z facing DIR (0 up)

ZONE: a Pearl zone id or name part (MAP_TWINLEAF_RIVAL_HOUSE_1F, rival_house_1f, 414); none = every room zone.
--fixed 0: Pearl's room models before pearl_model_fix.people_fix (the "before" counts).

What it builds (as sinnoh_rooms does): each chunk of the zone's matrix through pearl_chunk.fix_model (with its first
matrix's neighbours) and its props from Pearl's build models through pearl_model_fix.fix_building, placed as Black 2
places them; the textures for the alpha test (Pearl's area texture set, the props' own); the tiles' heights from the
built work/world/heights_rooms.json (Black 2 stands a person at the collision height). People: the zone's Pearl
objects (data/pearl_sprite_map.json codes, frames from the built sheets in work/rom_lead/files or Black 2's), and the
player (Lucas 231, Dawn 240) on every walkable tile reachable from the zone's warps, facing north and south.

How Black 2 draws a person (HoennB2 indoor_check, measured in DeSmuME and RAM; pokebw2 billboard.c, fieldmap.c):
  - a camera-facing quad (BLACT_TYPE_FACE_CAMERA) 28 x 28 units per 32-px frame, anchored at the bottom centre
    1.58 units below the feet (fieldmap.c func_ov036_0218132c: cos(pitch) * 4 - 4), every pixel at its anchor's view
    depth; it leans back from the feet: at h units up it stands 1.307 h north (camera 0);
  - our rooms use field camera 0 (the templates' zone header weather word >> 9 = 0): eye 189.73 up and 142.05 south
    of the player, target 4 above the player (pitch 52.6 degrees), fov y 39.9, near 1, far 1024; the target stops
    at the zone's camera boundary (sinnoh_rooms: where the screen's bottom row reaches the map's south edge);
  - people are drawn with the projection's m[3][2] + m[2][2] * 0x136 / 4096 (0x1ee in zones of projection type 1:
    caves and outdoor maps; fieldmap.c GetObjectProjectionMatrixOffset): with near 1 / far 1024 the sprite passes the
    depth test against geometry up to 3.65 % nearer the camera (k 0.9635; type 1: 5.7 %, k 0.943).
Depth models (--model): 'exact' = that k; 'hw' (default) = k less one depth step: the DS keeps a vertex's z/w to
1/16384 (GBATEK: Z = (z * 0x4000 / w + 0x3fff) * 0x200), one step is d^2 / 32800 units at view distance d (1.7 at the
player), so geometry within one step of the sprite's tested depth may or may not cover it (melonDS, hardware: the
user's 2026-10-20 report, the counter top 9.1 units nearer than the head, k's margin 8.7); 'desmume' = HoennB2's
measured 0.959 (DeSmuME draws people over geometry up to ~9.7 units nearer: why its frames hid the report).

Kinds (one line per finding, "ZONE: (kind) detail"):
  m  a person (the zone's Pearl objects; the player on every reachable tile) with geometry drawn across the sprite:
     "cut by" = a surface more than 4 units north of the feet (behind them, yet nearer the camera than the sprite's
     plane: heads in counters), "stands inside" = within 6 units of the body in its own tile, "cut off by the side
     wall" = a room wall beside them; not counted: in front of them (the nurse behind her counter), floor-level
     pieces (under 3 units), furniture beside them at their depth. NPCs: every such pixel (6 or more), seen from the
     camera on them, at the camera box's ends and with the player on the reachable tiles 6 rows north .. 3 south.
     The player: the room's own model (walls, counters, blocks) drawn over them, standing inside furniture, and
     slices (a band through the sprite with sprite drawn above it); a prop behind them covering the top of the head
     from above is Black 2's own look (HoennB2 --b2 baseline: 4 % of Black 2's tiles) and is listed with --covers.
  n  a person whose feet are not on the drawn floor (the drawn surface under their tile's centre more than 3 units
     off the collision height).
  s  the stair walk (not in the default kinds; --kinds s checks only the zones with stairs): the player along Black
     2's stair warp, leaving (from the foot's centre onto the flight's centre, the feet on the flight's 45-degree
     plane, the camera catching up while the screen fades) and arriving (on the flight's centre, then walking off
     onto the foot), every stairs of the zone with a warp (stair_walks: measured in RAM); geometry of any owner (the
     stair models are props) drawn across the sprite in the bad classes of m.
"""
import argparse, json, math, os, struct, sys
from collections import Counter, defaultdict

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, 'patches'))
import pearl_mesh, pearl_render, pearl_buildings, pearl_chunk, pearl_model_fix  # noqa: E402

PEARL = os.path.join(ROOT, 'work', 'pearl')
VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
SPRITE_FILES = [os.path.join(ROOT, 'work', 'rom_lead', 'files'), VANILLA]

W, H = 256, 192
COT = 2.75390625                       # projMtx[1][1] (fov y 39.9 degrees); [0][0] = COT / (4/3)
FX, FY = W / 2 * 2.065673828125, H / 2 * COT
EYE = np.array([0.0, 185.7273, 142.0496])      # camera 0: eye - target (HoennB2, RAM)
TARGET_OFF = np.array([0.0, 4.0, 0.0])         # target - player
NEAR, FAR = 1.0, 1024.0
M22, M32 = -(FAR + NEAR) / (FAR - NEAR), -2 * FAR * NEAR / (FAR - NEAR)
OBJ_OFFSET = {0: 0x136 / 4096, 1: 0x1ee / 4096}   # fieldmap.c GetObjectProjectionMatrixOffset, by projection type
K_EXACT = {t: M32 / (M32 + M22 * d) for t, d in OBJ_OFFSET.items()}     # 0.9635, 0.9430
K_DESMUME = {0: 0.959, 1: 0.943 - 0.0045}       # HoennB2 measured camera 0 (DeSmuME draws ~1 unit more)
QUAD = 28.0
ANCHOR_Y = -1.583
FRONT, LOW = 4.0, 3.0
MIN_PX = 6
BAD = ('inside', 'cut', 'wall')
PLAYER_CODES = (231, 240)              # Lucas, Dawn (the player's sheets)
WATER = {0x10, 0x15, 0x13}


def step(d):
    """One z/w step of the DS's Z-buffer at view distance d, in units."""
    return d * d / (-M32 * 16384)


def tested_depth(d, proj, model):
    """The depth a sprite whose anchor is at view distance d is tested with (smaller = it wins against more)."""
    if model == 'desmume': return d * K_DESMUME.get(proj, K_DESMUME[0])
    k = K_EXACT.get(proj, K_EXACT[0])
    return d * k + (step(d) if model == 'hw' else 0.0)


# ------------------------------------------------------------------------------------------------ data
_cache = {}


def world():
    if 'w' not in _cache:
        _cache['w'] = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
        _cache['z'] = json.load(open(os.path.join(PEARL, 'zones.json')))
    return _cache['w'], _cache['z']


def pearl_rom():
    if 'rom' not in _cache:
        from gen4rom import Rom, narc_members
        rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
        _cache['rom'] = rom
        _cache['build'] = narc_members(rom.read('fielddata/build_model/build_model.narc'))
        _cache['sets'] = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))
    return _cache['build'], _cache['sets']


def matrix(mid):
    return json.load(open(os.path.join(PEARL, 'matrices', f'{mid:03d}.json')))


def first_cells():
    """{Pearl room chunk: (matrix, x, z)}: the first room matrix that holds it (sinnoh_rooms converts it there)."""
    if 'cells' not in _cache:
        w, _ = world()
        out = {}
        m0 = matrix(0)                          # (a room matrix can hold an overworld chunk: sinnoh_world's)
        for z in range(m0['height']):
            for x in range(m0['width']):
                c = m0['maps'][z][x]
                if c != 0xffff and str(c) in w['chunks']: out.setdefault(c, (m0, x, z))
        for mid in w['rooms']['matrices']:
            m = matrix(int(mid))
            for z in range(m['height']):
                for x in range(m['width']):
                    c = m['maps'][z][x]
                    if c != 0xffff and str(c) in w['rooms']['chunks']: out.setdefault(c, (m, x, z))
        _cache['cells'] = out
    return _cache['cells']


def heights():
    if 'h' not in _cache:
        p = os.path.join(ROOT, 'work', 'world', 'heights_rooms.json')
        _cache['h'] = json.load(open(p)) if os.path.exists(p) else {}
    return _cache['h']


def zone_ids(args):
    w, zones = world()
    rooms = w['rooms']['zones']
    if not args: return sorted(int(p) for p in rooms)
    out = []
    for a in args:
        if a.isdigit() and a in rooms: out.append(int(a)); continue
        key = a.upper()
        hit = [int(p) for p, r in rooms.items() if key in r['name'] or key == r['name'].replace('MAP_', '')]
        if not hit: raise SystemExit(f'no room zone matches {a}')
        out += sorted(hit)
    return out


# ------------------------------------------------------------------------------------------------ geometry
class Mesh:
    """Triangles with texture lookups: T (n,3,3) zone units, UV (n,3,2) texels, img index, wrap, owner."""
    def __init__(self):
        self.T, self.UV, self.img, self.wrap, self.own, self.xlu = [], [], [], [], [], []
        self.images, self.owners = [], []

    def add_model(self, model, tex, offset, owner, room):
        info = pearl_render.bindings(model)
        ps = model.pos_scale / 4096
        key = {}
        for s in model.shapes:
            if s.material is None: continue
            tname, pname, teximg, diffamb, specemi, poly, flags = info[s.material]
            label = f'{owner}:{model.materials[s.material]}' if room else owner     # (the room's parts by material)
            if label not in self.owners: self.owners.append(label)
            oi = self.owners.index(label)
            alpha = (poly >> 16) & 31
            if alpha == 0: continue
            img = tex.get((tname, pname)) if tname else None
            if (tname, pname) not in key:
                key[(tname, pname)] = len(self.images); self.images.append(None if img is None else img[..., 3])
            ii = key[(tname, pname)]
            wrap = ((teximg >> 16) & 1, (teximg >> 17) & 1, (teximg >> 18) & 1, (teximg >> 19) & 1)
            for p in s.polys:
                P = np.array([v.pos for v in p], float) * ps + offset
                UV = np.array([(v[3] / 16, v[4] / 16) for v in p])
                for a, b, c in ((0, 1, 2), (0, 2, 3)) if len(p) == 4 else ((0, 1, 2),):
                    self.T.append(P[[a, b, c]]); self.UV.append(UV[[a, b, c]]); self.img.append(ii)
                    self.wrap.append(wrap); self.own.append(oi); self.xlu.append(alpha < 31)

    def done(self):
        T = np.array(self.T, float).reshape(-1, 3, 3)
        n = np.cross(T[:, 1] - T[:, 0], T[:, 2] - T[:, 0])
        keep = np.linalg.norm(n, axis=1) > 1e-6
        self.T = T[keep]
        self.UV = np.array(self.UV, float).reshape(-1, 3, 2)[keep]
        self.img = np.array(self.img, int)[keep]
        self.wrap = np.array(self.wrap, int).reshape(-1, 4)[keep]
        self.own = np.array(self.own, int)[keep]
        self.lo, self.hi = self.T.min(axis=1), self.T.max(axis=1)
        self.is_room = np.array([o.startswith('room ') for o in self.owners] + [False])
        return self


def chunk_model(c, fixed=True):
    """The chunk's map model as sinnoh_rooms installs it (pearl_chunk.fix_model in its first matrix); fixed=False:
    without the people fix (PEOPLE_FIX=none), the before state."""
    key = ('chunk', c, fixed)
    if key not in _cache:
        m, x, z = first_cells()[c]
        env = os.environ.get('PEOPLE_FIX')
        if not fixed: os.environ['PEOPLE_FIX'] = 'none'
        try:
            bmd, _ = pearl_chunk.fix_model(c, around=pearl_chunk.neighbours(m, x, z))
        finally:
            if env is None: os.environ.pop('PEOPLE_FIX', None)
            else: os.environ['PEOPLE_FIX'] = env
        _cache[key] = pearl_mesh.Model(bmd)
    return _cache[key]


def prop_model(model_id, fixed=True):
    """A prop as the room's building pack holds it (pearl_model_fix.fix_building; fixed=False: without people_prop)."""
    key = ('prop', model_id, fixed)
    if key not in _cache:
        build, _ = pearl_rom()
        b = build[model_id]
        env = os.environ.get('PEOPLE_FIX')
        if not fixed: os.environ['PEOPLE_FIX'] = 'none'
        try:
            bmd, _ = pearl_model_fix.fix_building(pearl_buildings.mdl_only(b))
        finally:
            if env is None: os.environ.pop('PEOPLE_FIX', None)
            else: os.environ['PEOPLE_FIX'] = env
        _cache[key] = (pearl_mesh.Model(bmd), pearl_render.textures(pearl_buildings.btx0_of(b)))
    return _cache[key]


def room_props(c, land, fixed=True):
    """The chunk's props where the build places them (fixed: those riding a sunk counter or table moved with it,
    pearl_chunk.people_props_moved)."""
    return pearl_chunk.people_props_moved(c, land['props']) if fixed else land['props']


def prop_name(model_id):
    return pearl_chunk.build_model_names().get(model_id, str(model_id))


class Room:
    """One Pearl room zone as built: its geometry, tiles, people and camera."""
    def __init__(self, pid, fixed=True):
        w, zones = world()
        self.pid, self.fixed = pid, fixed
        self.r = w['rooms']['zones'][str(pid)]
        self.name = self.r['name'].replace('MAP_', '')
        self.zone = zones[pid]
        self.m = matrix(self.r['pearl_matrix'])
        area = w['rooms']['areas'][str(self.r['pearl_area'])]
        build, sets = pearl_rom()
        tex = pearl_render.textures(sets[area['pearl_texset']])
        self.proj = 0 if self.zone['map_type'] in (4, 1) else 1       # sinnoh_rooms TEMPLATE_ZONE: 441 (0x0), 324/437 (0x40)
        self.cam = 0
        self.mesh = Mesh()
        self.cells, self.coll, self.beh, self.hts = {}, {}, {}, {}
        room_owners, south = set(), []
        for cz, row in enumerate(self.m['maps']):
            for cx, c in enumerate(row):
                if c == 0xffff: continue
                self.cells[(cx, cz)] = c
                off = np.array([cx * 512 + 256.0, 0.0, cz * 512 + 256.0])
                mm = chunk_model(c, fixed)
                own = f'room {c}'
                room_owners.add(own)
                self.mesh.add_model(mm, tex, off, own, True)
                P = [mm.units(v) for s in mm.shapes for poly in s.polys for v in poly]
                if P: south.append(cz * 512 + 256 + max(p[2] for p in P))
                land = json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))
                for k, pr in enumerate(room_props(c, land, fixed)):
                    pm, ptex = prop_model(pr['model'], fixed)
                    self.mesh.add_model(pm, ptex, off + np.array(pr['pos'], float),
                                        f"{prop_name(pr['model'])}#{c}.{k}", False)
                ht = heights().get(str(c), {})
                for tz in range(32):
                    for tx in range(32):
                        X, Z = cx * 32 + tx, cz * 32 + tz
                        self.coll[(X, Z)] = land['collision'][tz][tx] or int((tx, tz) in pearl_chunk.bed_solid(c))
                        self.beh[(X, Z)] = land['behaviour'][tz][tx]
                        if f'{tx},{tz}' in ht: self.hts[(X, Z)] = ht[f'{tx},{tz}']
        self.mesh.done()
        self.zmax = (max(south) - camera_below()) if south else 1e9
        self.ev = json.load(open(os.path.join(PEARL, 'events', f"{self.zone['events']:03d}.json")))

    def feet_y(self, t):
        return float(self.hts.get(tuple(t), 0))

    def walkable(self, t):
        return (t in self.coll and not self.coll[t] and self.beh.get(t) not in WATER)

    def reachable(self):
        if hasattr(self, '_reach'): return self._reach
        todo = [(w['x'], w['z']) for w in self.ev['warp_events']]
        if not todo:                                     # (a room entered by script warps only: its people's tiles)
            todo = [(o['x'], o['z']) for o in self.ev['object_events']]
        seen = set()
        starts = list(todo)
        for s in starts:                                 # a warp on a solid tile (door, stairs flight): its neighbours
            for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                todo.append((s[0] + dx, s[1] + dz))
        todo = [t for t in todo if self.walkable(t)]
        seen.update(todo)
        while todo:
            x, z = todo.pop()
            for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                t = (x + dx, z + dz)
                if t not in seen and self.walkable(t):
                    seen.add(t); todo.append(t)
        self._reach = seen
        return seen

    def people(self, sprites):
        smap = sprite_map()
        out = []
        for o in self.ev['object_events']:
            code = smap.get(o['graphics_id'])
            if code is None: continue
            fr = sprites.frame(code, o['initial_dir'] & 3)
            if fr is None or fr[0].shape[0] > 32: continue          # 3D objects, Pokemon / 64-px objects
            out.append((f"obj {o['id']} (gfx {o['graphics_id']}, code {code})", (o['x'], o['z']), code,
                        o['initial_dir'] & 3))
        return out

    def camera_at(self, px, py, pz, bound=True):
        """(eye, target) with the player at (px, py, pz); bound: the target kept inside the zone's camera boundary
        (sinnoh_rooms; a frame of the opening's DeSmuME run matched the unbounded camera, so both are checked)."""
        t = np.array([px, py, min(pz, self.zmax) if bound else pz]) + TARGET_OFF
        return t + EYE, t


def camera_below():
    if 'below' not in _cache:
        import sinnoh_rooms
        _cache['below'] = sinnoh_rooms.camera_below(VANILLA, 0)
    return _cache['below']


def sprite_map():
    if 'smap' not in _cache:
        d = json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json')))
        _cache['smap'] = {int(k): v['code'] for k, v in d.items()
                          if k.isdigit() and isinstance(v, dict) and v.get('code') is not None}
    return _cache['smap']


class Sprites:
    """Standing frames of Black 2 object codes from the built sheets (work/rom_lead/files), else Black 2's."""
    def __init__(self):
        import sprites as sp
        from b2files import arc_path, narc_entries
        self.sp = sp
        files = next(f for f in SPRITE_FILES if os.path.exists(arc_path(f, 48)))
        self.table = sp.ow_table(files)
        self.sheets = narc_entries(arc_path(files, 48))
        self.cache = {}

    def frame(self, code, d):
        k = (code, d)
        if k in self.cache: return self.cache[k]
        out = None
        try:
            rec = self.table[self.sp.obj_record(code)]
            if rec['entityType'] == 1:
                frames, _, pal = self.sp.btx_decode(self.sheets[rec['res1']])
                ct, n = rec['spriteControllerType'], len(frames)
                flip = False
                if ct in (1, 3) and n >= 12: i = 3 * d
                elif n >= 7 and ct in (2, 15): i, flip = (0, 2, 4, 4)[d], d == 3
                elif n >= 4: i = min(d, n - 1)
                else: i = 0
                _, w, h, pix = frames[i]
                a = np.array(pix, np.uint8).reshape(h, w)
                rgb = np.array([self.sp.bgr555_to_rgb(c) for c in pal], np.uint8)[a]
                if flip: a, rgb = a[:, ::-1], rgb[:, ::-1]
                out = (a > 0, rgb)
        except Exception:
            out = None
        self.cache[k] = out
        return out


# ------------------------------------------------------------------------------------------------ the view
def view_matrix(eye, target):
    f = np.array(target, float) - np.array(eye, float); f /= np.linalg.norm(f)
    r = np.cross(f, [0, 1.0, 0]); r /= np.linalg.norm(r)
    u = np.cross(r, f)
    return np.stack([r, u, -f])


def _texel_ok(mesh, t, uu, vv):
    A = mesh.images[mesh.img[t]]
    if A is None: return None
    th, tw = A.shape
    rs, rt, fs, ft = mesh.wrap[t]
    def wr(c, n, rep, flip):
        i = np.floor(c).astype(int)
        if not rep: return np.clip(i, 0, n - 1)
        if flip:
            k = np.floor_divide(i, n); i = np.mod(i, n)
            return np.where(k % 2 == 1, n - 1 - i, i)
        return np.mod(i, n)
    return A[wr(vv, th, rt, ft), wr(uu, tw, rs, fs)] >= 128


class View:
    def __init__(self, room, sprites, model='hw'):
        self.room, self.mesh, self.spr, self.model = room, room.mesh, sprites, model

    def look(self, tile, code, d, eye, target, at=None):
        """Hidden opaque pixels of the sprite at zone tile `tile` from (eye, target): {class: {owner: n}}, rows hit,
        the slice count (bad pixels with sprite drawn above them in their column). at = (x, feet y, z): the person
        there instead of standing on the tile (the stair walk)."""
        fr = self.spr.frame(code, d)
        if fr is None: return None
        mask, _ = fr
        fh, fw = mask.shape
        R = view_matrix(eye, target); eye = np.asarray(eye, float)
        if at is None:
            fy = self.room.feet_y(tile)
            px, pz = tile[0] * 16 + 8, tile[1] * 16 + 8
        else:
            px, fy, pz = at
        c = R @ (np.array([px, fy + ANCHOR_Y, pz]) - eye)
        zq = -c[2]
        if zq < 2: return None
        zt = tested_depth(zq, self.room.proj, self.model)
        qw, qh = QUAD * fw / 32, QUAD * fh / 32
        sx0, sx1 = W / 2 + FX * (c[0] - qw / 2) / zq, W / 2 + FX * (c[0] + qw / 2) / zq
        sy0, sy1 = H / 2 - FY * (c[1] + qh) / zq, H / 2 - FY * c[1] / zq
        X0, X1 = int(math.floor(sx0)), int(math.ceil(sx1)); Y0, Y1 = int(math.floor(sy0)), int(math.ceil(sy1))
        gx, gy = np.meshgrid(np.arange(X0, X1) + 0.5, np.arange(Y0, Y1) + 0.5)
        u = ((gx - sx0) / (sx1 - sx0) * fw).astype(int); v = ((gy - sy0) / (sy1 - sy0) * fh).astype(int)
        inside = (u >= 0) & (u < fw) & (v >= 0) & (v < fh) & (gx >= 0) & (gx < W) & (gy >= 0) & (gy < H)
        opaque = np.zeros(gx.shape, bool)
        opaque[inside] = mask[v[inside], u[inside]]
        if not opaque.any(): return None
        M = self.mesh
        near = ((M.hi[:, 0] >= px - 40) & (M.lo[:, 0] <= px + 40) & (M.hi[:, 2] >= pz - 64) &
                (M.lo[:, 2] <= pz + 64) & (M.hi[:, 1] >= fy + LOW))
        idx = np.nonzero(near)[0]
        V = (M.T[idx] - eye) @ R.T
        z = -V[..., 2]
        ok = (z > 1).all(axis=1) & (z.min(axis=1) < zt)
        empty = dict(hidden={}, opaque=int(opaque.sum()), rows={}, slice=0, rect=(X0, Y0, X1, Y1))
        if not ok.any(): return empty
        idx = idx[ok]
        Vk, zk = V[ok], z[ok]
        sx = W / 2 + FX * Vk[..., 0] / zk; sy = H / 2 - FY * Vk[..., 1] / zk
        over = (sx.max(1) >= X0) & (sx.min(1) <= X1) & (sy.max(1) >= Y0) & (sy.min(1) <= Y1)
        zb = np.full(gx.shape, np.inf); tb = np.full(gx.shape, -1, int)
        for t in np.nonzero(over)[0]:
            (ax, bx, cx), (ay, by, cy) = sx[t], sy[t]
            den = (by - cy) * (ax - cx) + (cx - bx) * (ay - cy)
            if abs(den) < 1e-9: continue
            w0 = ((by - cy) * (gx - cx) + (cx - bx) * (gy - cy)) / den
            w1 = ((cy - ay) * (gx - cx) + (ax - cx) * (gy - cy)) / den
            w2 = 1 - w0 - w1
            m = (w0 >= -1e-4) & (w1 >= -1e-4) & (w2 >= -1e-4)
            if not m.any(): continue
            iz = 1 / zk[t]
            q = w0 * iz[0] + w1 * iz[1] + w2 * iz[2]
            dep = 1 / q
            m &= dep < zb
            if not m.any(): continue
            ti = idx[t]
            UV = M.UV[ti]
            uu = (w0 * UV[0, 0] * iz[0] + w1 * UV[1, 0] * iz[1] + w2 * UV[2, 0] * iz[2]) / q
            vv = (w0 * UV[0, 1] * iz[0] + w1 * UV[1, 1] * iz[1] + w2 * UV[2, 1] * iz[2]) / q
            okt = _texel_ok(M, ti, uu, vv)
            if okt is not None: m &= okt
            zb[m] = dep[m]; tb[m] = ti
        hid = opaque & (zb < zt)
        out = defaultdict(Counter); rows = defaultdict(set)
        slice_px = 0
        if hid.any():
            hy, hx = np.nonzero(hid)
            dz = zb[hy, hx]
            vx = (gx[hy, hx] - W / 2) * dz / FX; vy = -(gy[hy, hx] - H / 2) * dz / FY
            Q = np.stack([vx, vy, -dz], 1) @ R + eye
            tri_px, vrow = tb[hy, hx], v[hy, hx]
            own_px = M.own[tri_px]
            Tp = M.T[tri_px]
            nrm = np.cross(Tp[:, 1] - Tp[:, 0], Tp[:, 2] - Tp[:, 0])
            nrm = nrm / np.maximum(np.linalg.norm(nrm, axis=1), 1e-9)[:, None]
            room = M.is_room[own_px]
            qx, qy, qz = Q[:, 0], Q[:, 1], Q[:, 2]
            cls = np.select(
                [qy < fy + LOW,
                 qz < pz - FRONT,
                 qz >= pz + FRONT,
                 np.abs(qx - px) < 6,
                 room & (np.abs(nrm[:, 0]) > 0.7)],
                ['low', 'cut', 'front', 'inside', 'wall'], 'side')
            for c_, o_, r_ in zip(cls, own_px, vrow):
                out[c_][int(o_)] += 1; rows[c_].add(int(r_))
            badm = np.isin(cls, BAD)
            bad = np.zeros(gx.shape, bool); bad[hy[badm], hx[badm]] = True
            vis = opaque & ~hid
            above = np.maximum.accumulate(vis, axis=0)
            above = np.vstack([np.zeros((1, gx.shape[1]), bool), above[:-1]])
            slice_px = int((bad & above).sum())
        return dict(hidden=out, opaque=int(opaque.sum()), rows=rows, slice=slice_px, rect=(X0, Y0, X1, Y1))

    def cameras(self, tile, player=False):
        px, pz = tile[0] * 16 + 8, tile[1] * 16 + 8
        y = self.room.feet_y(tile)
        out = [self.room.camera_at(px, y, pz, False)]
        if pz > self.room.zmax: out.append(self.room.camera_at(px, y, pz))
        if player: return out
        if not hasattr(self, '_rows'):
            rows = defaultdict(list)
            for t in self.room.reachable(): rows[t[1]].append(t[0])
            self._rows = rows
        seen = {(round(t[0], 2), round(t[2], 2)) for _, t in out}
        for dz in range(-6, 4):
            xs = self._rows.get(tile[1] + dz)
            if not dz or not xs: continue
            for tx in {min(xs), max(xs), min(xs, key=lambda q: abs(q - tile[0]))}:
                t2 = (tx, tile[1] + dz)
                for bound in (False, True):
                    e, t = self.room.camera_at(tx * 16 + 8, self.room.feet_y(t2), t2[1] * 16 + 8, bound)
                    k = (round(t[0], 2), round(t[2], 2))
                    if k not in seen: seen.add(k); out.append((e, t))
        return out

    def score(self, r, player=False):
        if not player: return sum(sum(c.values()) for k, c in r['hidden'].items() if k in BAD)
        n = sum(v for k, c in r['hidden'].items() if k in BAD for o, v in c.items()
                if self.mesh.is_room[o] or k == 'inside')
        return n + (r['slice'] if r['slice'] >= MIN_PX else 0)

    def cover(self, r):
        """Pixels of the top of the sprite covered by props behind (not counted for the player: Black 2's look)."""
        return sum(v for k, c in r['hidden'].items() if k == 'cut' for o, v in c.items() if not self.mesh.is_room[o])

    def worst(self, tile, codes, dirs, player=False):
        best = None
        for code in codes:
            for d in dirs:
                for eye, tgt in self.cameras(tile, player):
                    r = self.look(tile, code, d, eye, tgt)
                    if r is None: continue
                    n = self.score(r, player)
                    if best is None or n > best[0]: best = (n, r, d, code)
        return best

    def describe(self, r):
        parts = []
        for cls in BAD:
            c = r['hidden'].get(cls)
            if not c or sum(c.values()) < MIN_PX: continue
            rows = sorted(r['rows'][cls])
            where = 'head' if rows[-1] < 14 else ('feet' if rows[0] > 26 else 'body')
            who = ', '.join(f'{self.mesh.owners[o]} ({n} px)' for o, n in c.most_common(3))
            verb = {'inside': 'stands inside', 'cut': 'cut by', 'wall': 'cut off by the side wall'}[cls]
            parts.append(f'{verb} {who} across sprite rows {rows[0]}-{rows[-1]} ({where})')
        if r['slice'] >= MIN_PX: parts.append(f"slice {r['slice']} px")
        if not parts:                                    # (several small pieces adding up)
            parts = [f"{cls} {', '.join(f'{self.mesh.owners[o]} ({n} px)' for o, n in c.most_common(3))}"
                     for cls, c in r['hidden'].items() if cls in BAD and c]
        return '; '.join(parts)


def surface_at(mesh, x, z, y0):
    """Heights of the upward faces under (x, z) within 40 units of y0."""
    near = (mesh.lo[:, 0] <= x) & (mesh.hi[:, 0] >= x) & (mesh.lo[:, 2] <= z) & (mesh.hi[:, 2] >= z)
    out = []
    for t in np.nonzero(near)[0]:
        a, b, c = mesh.T[t]
        n = np.cross(b - a, c - a)
        if abs(n[1]) < 0.5 * np.linalg.norm(n): continue
        d = (b[0] - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (b[2] - a[2])
        if abs(d) < 1e-9: continue
        u = ((x - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (z - a[2])) / d
        v = ((b[0] - a[0]) * (z - a[2]) - (x - a[0]) * (b[2] - a[2])) / d
        if u < -1e-4 or v < -1e-4 or u + v > 1 + 1e-4: continue
        y = a[1] + u * (b[1] - a[1]) + v * (c[1] - a[1])
        if abs(y - y0) < 40: out.append(y)
    return out


# ------------------------------------------------------------------------------------------------ the stair walk (s)
# Black 2's stair warp (measured in RAM, story_play REC log, the player's house 2F -> 1F, 2026-10-20): leaving, the
# player walks from the foot's centre onto the flight's centre, 1 unit a frame, the feet on the collision height (the
# foot's, then the flight's 45-degree plane from its edge: pearl_chunk.stair_planes), the camera's target on the
# player in x/z and at the foot's height + 4 until they stop, then sinking or rising 1 unit a frame toward the
# player's while the screen fades (~18 frames); arriving, the player stands on the flight's centre at its plane's
# height (the camera's target there + 4) while the screen fades in (~20 frames), then walks off onto the foot.
def stair_walks(room):
    """[(label, [(x, feet y, z, camera y, dir)])]: the player's positions (zone units) along the departure and the
    arrival of every stairs of the zone with a warp (Pearl's warp on the foot: sinnoh_events puts it on the flight)."""
    if not hasattr(stair_walks, 'cache'): stair_walks.cache = {}
    feet = {(w['x'], w['z']) for w in room.ev['warp_events']}
    out = []
    for (cx, cz), c in sorted(room.cells.items()):
        if c not in stair_walks.cache:
            m, x, z = first_cells()[c]
            stair_walks.cache[c] = pearl_chunk.stairs_of(c, pearl_chunk.neighbours(m, x, z))
        for st in stair_walks.cache[c]:
            tx, tz = st['foot']
            X, Z = cx * 32 + tx, cz * 32 + tz
            if (X, Z) not in feet or 'flight_y' not in st: continue
            ox, oz = cx * 512 + 256, cz * 512 + 256              # chunk-centred -> zone
            walk = pearl_chunk.stair_walk(st)
            way = 'up' if st['way'] > 0 else 'down'
            for phase, where in (('leaving', f'from the foot ({X},{Z})'), ('arriving', f"on the flight ({X + st['dx']},{Z})")):
                out.append((f'{phase} {way} {where}', [(x + ox, y, z + oz, cy, d) for x, y, z, cy, d in walk[phase]]))
    return out


def zone_has_stairs(pid):
    """A room zone with a warp on a stairs foot (Pearl's 0x5e / 0x5f tiles), from Pearl's data alone."""
    w, zones = world()
    m = matrix(w['rooms']['zones'][str(pid)]['pearl_matrix'])
    ev = json.load(open(os.path.join(PEARL, 'events', f"{zones[pid]['events']:03d}.json")))
    for wp in ev['warp_events']:
        cx, cz = wp['x'] // 32, wp['z'] // 32
        if not (0 <= cz < m['height'] and 0 <= cx < m['width']) or m['maps'][cz][cx] == 0xffff: continue
        land = json.load(open(os.path.join(PEARL, 'land', f"{m['maps'][cz][cx]:03d}.json")))
        if land['behaviour'][wp['z'] % 32][wp['x'] % 32] in pearl_chunk.STAIR_DX: return True
    return False


def stair_score(r):
    """Hidden sprite pixels in the bad classes, from any owner (the stair models are props)."""
    return sum(sum(c.values()) for k, c in r['hidden'].items() if k in BAD)


def check_stairs(room, view, say):
    found = Counter()
    for label, path in stair_walks(room):
        worst = None
        for i, (x, fy, z, cy, d) in enumerate(path):
            for bound in (False, True):
                eye, tgt = room.camera_at(x, cy, z, bound)
                for code in PLAYER_CODES:
                    r = view.look((int(x // 16), int(z // 16)), code, d, eye, tgt, at=(x, fy, z))
                    if r is None: continue
                    n = stair_score(r)
                    if worst is None or n > worst[0]: worst = (n, r, i, (x, fy, z), code)
        found['stairs'] += 1
        if worst and worst[0] >= MIN_PX:
            n, r, i, (x, fy, z), code = worst
            say('s', f'the player {label} (step {i} of {len(path)}, at x {x:.0f} feet {fy:.1f}, code {code}): '
                     f'{view.describe(r)}')
            found['stairs_bad'] += 1
    return found


def check_room(room, view, kinds, say, covers=False):
    found = Counter()
    if 's' in kinds:
        found.update(check_stairs(room, view, say))
    if 'm' in kinds:
        for who, t, code, d in room.people(view.spr):
            w = view.worst(t, [code], [d])
            if w and w[0] >= MIN_PX:
                say('m', f'{who} at {t} facing {"NSWE"[d] if d < 2 else "WE"[d - 2]}: {view.describe(w[1])}')
                found['npc'] += 1
        for t in sorted(room.reachable()):
            w = view.worst(t, PLAYER_CODES, [0, 1], player=True)
            if w and w[0] >= MIN_PX:
                say('m', f'the player at {t} facing {"north" if w[2] == 0 else "south"} (code {w[3]}): '
                         f'{view.describe(w[1])}')
                found['player'] += 1
            if covers:
                cv = max((view.cover(view.look(t, code, d, *view.cameras(t, True)[0]) or
                                     dict(hidden={})) for code in PLAYER_CODES for d in (0, 1)), default=0)
                if cv >= MIN_PX:
                    say('c', f'the player at {t}: the top of the head covered by a prop behind ({cv} px)')
                    found['cover'] += 1
    if 'n' in kinds:
        for who, t, code, d in room.people(view.spr):
            gy = room.feet_y(t)
            ys = surface_at(room.mesh, t[0] * 16 + 8, t[1] * 16 + 8, gy)
            if not ys: continue
            near = min(ys, key=lambda y: abs(y - gy))
            if abs(near - gy) > 3:
                say('n', f'{who} at {t}: feet at {gy:.0f} (collision), drawn surface at {near:.0f}')
                found['feet'] += 1
    return found


# ------------------------------------------------------------------------------------------------ render
def render(room, sprites, player=None, pdir=0, model='hw', scale=1, extra=(), bound=False):
    """The room from the game camera (on the player at zone tile `player`, else the first warp): PIL image with the
    people drawn as Black 2 draws them (billboards with the object depth margin of `model`)."""
    from PIL import Image
    build, sets = pearl_rom()
    w, _ = world()
    area = w['rooms']['areas'][str(room.r['pearl_area'])]
    tex = pearl_render.textures(sets[area['pearl_texset']])
    t0 = player or (room.ev['warp_events'][0]['x'], room.ev['warp_events'][0]['z'])
    eye, tgt = room.camera_at(t0[0] * 16 + 8, room.feet_y(t0), t0[1] * 16 + 8, bound)
    sc = pearl_render.Scene(W * scale, H * scale, eye, tgt, half=math.degrees(math.atan(1 / COT)))
    setup = pearl_render.LIGHTS['pearl_indoor']
    for (cx, cz), c in room.cells.items():
        off = np.array([cx * 512 + 256.0, 0.0, cz * 512 + 256.0])
        pearl_render.draw_model(sc, chunk_model(c, room.fixed), tex, offset=off, setup=setup)
        land = json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))
        for pr in room_props(c, land, room.fixed):
            pm, ptex = prop_model(pr['model'], room.fixed)
            pearl_render.draw_model(sc, pm, ptex, offset=off + np.array(pr['pos'], float), setup=setup)
    img = sc.image(pearl_render.EDGES['pearl_indoor'])
    arr = np.array(img).astype(float)
    zb = sc.z
    R = view_matrix(eye, tgt); E = np.asarray(eye, float)
    people = [(t, code, d) for _, t, code, d in room.people(sprites)] + list(extra)
    if player: people.append((player, PLAYER_CODES[0], pdir))
    bl = []
    for t, code, d in people:
        fr = sprites.frame(code, d)
        if fr is None: continue
        c = R @ (np.array([t[0] * 16 + 8, room.feet_y(t) + ANCHOR_Y, t[1] * 16 + 8]) - E)
        bl.append((-c[2], c, fr))
    Ws, Hs = W * scale, H * scale
    for zq, c, (mask, rgb) in sorted(bl, key=lambda q: -q[0]):
        fh, fw = mask.shape; qw, qh = QUAD * fw / 32, QUAD * fh / 32
        sx0, sx1 = Ws / 2 + FX * scale * (c[0] - qw / 2) / zq, Ws / 2 + FX * scale * (c[0] + qw / 2) / zq
        sy0, sy1 = Hs / 2 - FY * scale * (c[1] + qh) / zq, Hs / 2 - FY * scale * c[1] / zq
        X0, X1 = max(0, int(math.floor(sx0))), min(Ws, int(math.ceil(sx1)))
        Y0, Y1 = max(0, int(math.floor(sy0))), min(Hs, int(math.ceil(sy1)))
        if X1 <= X0 or Y1 <= Y0: continue
        gx, gy = np.meshgrid(np.arange(X0, X1) + 0.5, np.arange(Y0, Y1) + 0.5)
        u = ((gx - sx0) / (sx1 - sx0) * fw).astype(int).clip(0, fw - 1)
        vv = ((gy - sy0) / (sy1 - sy0) * fh).astype(int).clip(0, fh - 1)
        zt = tested_depth(zq, room.proj, model)
        m = mask[vv, u] & (zt < zb[Y0:Y1, X0:X1])
        reg = arr[Y0:Y1, X0:X1]; reg[m] = rgb[vv, u][m]
        zb[Y0:Y1, X0:X1][m] = zt
    return Image.fromarray(np.clip(arr, 0, 255).astype(np.uint8))


# ------------------------------------------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--model', default='hw', choices=('hw', 'exact', 'desmume'))
    ap.add_argument('--fixed', default='1')
    ap.add_argument('--kinds', default='mn')
    ap.add_argument('--summary', action='store_true')
    ap.add_argument('--covers', action='store_true')
    ap.add_argument('--render')
    ap.add_argument('--scale', type=int, default=1)
    ap.add_argument('--json')
    ap.add_argument('zones', nargs='*')
    a = ap.parse_args()
    fixed = a.fixed == '1'
    spr = Sprites()
    if a.render:
        pid = zone_ids(a.zones[:1])[0]
        room = Room(pid, fixed)
        player = tuple(map(int, a.zones[1].split(','))) if len(a.zones) > 1 else None
        pdir = int(a.zones[2]) if len(a.zones) > 2 else 0
        render(room, spr, player, pdir, a.model, a.scale).save(a.render)
        print(a.render)
        return
    total, lines, per = Counter(), [], {}
    for pid in zone_ids(a.zones):
        if a.kinds == 's' and not zone_has_stairs(pid): continue
        room = Room(pid, fixed)
        view = View(room, spr, a.model)
        out = []
        f = check_room(room, view, a.kinds, lambda k, s: out.append((k, s)), a.covers)
        total.update(f)
        per[room.name] = dict(f)
        for k, s in out:
            ln = f'{room.name} ({pid}): ({k}) {s}'
            lines.append(ln)
            if not a.summary: print(ln, flush=True)
    print(f"total ({a.model}, {'fixed' if fixed else 'before'}): " + ', '.join(f'{k} {v}' for k, v in sorted(total.items())))
    if a.json:
        json.dump(dict(total=total, per=per, lines=lines), open(a.json, 'w'), indent=1)


if __name__ == '__main__':
    main()
