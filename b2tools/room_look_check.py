"""Rooms' look check (2026-10-25; notes/MAP_LOOK.md "Rooms: black floors and black gaps"): what every room zone draws
from Black 2's camera, against Pearl's own look.

    python3 room_look_check.py [--files DIR] [--json OUT] [--summary] [--kinds K,..] [ZONE ...]   the checks below,
                every room zone (--kinds: tex,dark,floor,hole,sky,model,beyond, the default all)
    python3 room_look_check.py --render OUT.png ZONE X,Z [--cam b2|pearl] [--files DIR]
    python3 room_look_check.py --pair OUT.png ZONE X,Z [--files DIR] [--files2 DIR] [--people [--dir D]]   Pearl's
                look (Pearl's data and camera) over ours (Black 2's camera on what the build installs), 256x384;
                --people: the zone's objects where Pearl places them and the player on X,Z facing D (0 up)

ZONE: a Pearl room zone id or name part (as pearl_rooms_view). The models are what sinnoh_rooms installs
(pearl_chunk.fix_model, pearl_model_fix.fix_building, the props moved with a sunk counter), or with --files DIR the
room chunks and building packs of a built ROM's files (a/0/0/8, a/2/2/6 + a/2/2/5, their texture sets a/0/1/4,
a/1/7/5 + a/1/7/4): the real installed data, e.g. an older build for "before".

Checks (one line per finding, "ZONE: (kind) detail"; counts per kind at the end):
  tex    a material of the room's map model whose texture or palette is not in the texture set the room's area uses
         (Pearl's set; the seasonal sets of the outdoor rooms keep its names), or a prop material missing from its
         building pack's set: the DS draws it with whatever sits at that VRAM address ('tex_pearl': Pearl's own set
         lacks it too, Pearl's data).
  dark   lit polygons whose corners take a COLOR command's colour instead of the lights (the GX colours a corner by
         its last COLOR or NORMAL command; Pearl's own models never do: pearl_mesh): Pearl's unused vertex colours,
         black in the Eterna Gym's grass (2026-10-25).
  floor  a reachable tile (not a warp) whose floor Pearl's own look draws and ours does not: at 4 or more of 5
         points (the centre, +-5 units) no upward surface within 4.5 units of its collision height with an opaque texel
         of a texture the set holds and not dark ("black": one there but not drawn; "nothing").
  hole   a tile Pearl's own model (and props) covers from above (5 or more of 9 points) that the installed room
         leaves empty at 5 or more of them: geometry lost in the conversion (the clear colour, black indoors, shows
         through it). (The layers fix moves pieces along the view direction, up to ~1.5 units in x/z: single points
         on a piece's edge move out; on screen nothing changes.)
  The void past the room (2026-10-25, notes/MAP_LOOK.md "Rooms: the void past the edge"): Black 2's camera is wider
  than Pearl's and sees past the walls; from every reachable tile at the end of its row or column, one ray per
  --ray-step pixels (default 8) through ours (face culling, alpha test), in pixels:
  sky    nothing drawn and the room's light table clears to a colour that is not black (Black 2's day-cycle tables
         140-143: sky blue by day): Pearl's void is black (easy3d.c: black, transparent, over a black backdrop).
  model  ours draws a surface (ground, model, prop) on a line of sight where Pearl's look meets nothing: Pearl's own
         ray through the point (its camera on the nearest reachable tile that has the point on screen, else on the
         nearest reachable tile) hits no surface (nor 5 units to each side) and no triangle of Pearl's lies within 5
         units: geometry ours has and Pearl's room has not.
  beyond (a note) Pearl's own geometry that Pearl's camera never shows and ours does: off Pearl's screen from every
         reachable tile (Black 2's wider camera at the edges: cliffs past a lake's shore) or edge-on to it (the side
         walls' inner faces under Pearl's orthographic camera 4), Pearl's art.
Renders (--render, --pair): pearl_render's DS-style drawing (the GX's colour source per corner too), nothing drawn =
magenta; Pearl's camera from pokediamond's table (the room's zone camera: 4 = orthographic, 50 degrees, most rooms;
9 = the Oreburgh and Eterna Gyms), ours = Black 2's camera 0 held by the zone's camera boundary (pearl_rooms_view).
People only with --people (billboards; Pearl: 32 units a 32-px frame at the feet's depth).
"""
import argparse, json, math, os, struct, sys
from collections import Counter, defaultdict

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, 'patches'))
import nsbtx, pearl_mesh, pearl_render, pearl_buildings, pearl_chunk, pearl_model_fix  # noqa: E402
import pearl_rooms_view as RV  # noqa: E402

PEARL = os.path.join(ROOT, 'work', 'pearl')
VOID = (31, 0, 31)                       # (5-bit) background of the renders: nothing drawn
FLOOR_WINDOW = 4.5                       # (the layers fix moves floor pieces up to ~1.8 units up or down)

# Pearl's field cameras (pokediamond ov05_021F6608, 24-byte records; pokeplatinum field_camera.c sCameraTypes):
# distance, pitch (degrees down), orthographic, vertical half-angle (degrees)
PEARL_CAMERAS = {0: (666.92, 59.05, 0, 8.091), 1: (666.92, 68.37, 0, 8.091), 2: (515.46, 54.66, 0, 10.459),
                 3: (666.92, 59.05, 0, 8.091), 4: (1563.54, 50.09, 1, 3.521), 5: (316.5, 59.05, 0, 16.88),
                 6: (866.55, 73.11, 0, 6.334), 7: (666.92, 59.05, 0, 8.091), 8: (662.92, 70.47, 0, 9.849),
                 9: (357.6, 40.59, 0, 15.029), 10: (1202.36, 60.8, 0, 4.576), 11: (675.83, 57.82, 0, 8.091),
                 12: (574.58, 63.26, 0, 9.498), 13: (515.46, 47.8, 0, 10.459), 14: (169.46, 78.38, 0, 29.537),
                 15: (653.93, 54.66, 0, 8.35)}


# ------------------------------------------------------------------------------------------------ installed data
class Installed:
    """The room chunks' models and the room areas' building packs as a built ROM holds them (--files)."""
    def __init__(self, files):
        import narcio
        from b2files import gf_container, arc_path
        self.files = files
        w, _ = RV.world()
        self.chunks = narcio.load(files, 8)
        self.sets = narcio.load(files, 14)
        self.packs = {False: narcio.load(files, 226), True: narcio.load(files, 225)}
        self.ptex = {False: narcio.load(files, 175), True: narcio.load(files, 174)}
        self.area_tab = open(arc_path(files, 13), 'rb').read()
        self.gf = gf_container
        self.w = w
        self._models = {}
        self._areas = {}

    def chunk(self, c):
        if c not in self._models:
            b2 = self.w['rooms']['chunks'].get(str(c), self.w['chunks'].get(str(c)))   # (or sinnoh_world's)
            _, secs = self.gf(self.chunks[b2])
            self._models[c] = pearl_mesh.Model(secs[0])
        return self._models[c]

    def area_set(self, pearl_area):
        a = self.w['rooms']['areas'][str(pearl_area)]
        tex_id = struct.unpack_from('<H', self.area_tab, 10 * a['b2_area'] + 2)[0]
        return self.sets[tex_id]

    def area(self, pearl_area):
        """(map textures, {resId: prop model bytes}, prop textures) of a room area, decoded once."""
        if pearl_area not in self._areas:
            pack, ptex = self.pack(pearl_area)
            self._areas[pearl_area] = (pearl_render.textures(self.area_set(pearl_area)), pack,
                                       pearl_render.textures(ptex))
        return self._areas[pearl_area]

    def pack(self, pearl_area):
        """{resId: (model, texture set bytes)} of the area's building pack."""
        a = self.w['rooms']['areas'][str(pearl_area)]
        ext = bool(a['exterior'])
        _, secs = self.gf(self.packs[ext][a['b2_pack']])
        n = len(secs) // 2
        out = {}
        for k in range(n):
            res = struct.unpack_from('<H', secs[k], 0)[0]
            out[res] = secs[n + k]
        return out, self.ptex[ext][a['b2_pack']]


_CACHE = {}


def pearl_prop(model_id):
    """(model, textures) of a Pearl build model as Pearl draws it."""
    if ('prop', model_id) not in _CACHE:
        build, _ = RV.pearl_rom()
        b = build[model_id]
        _CACHE[('prop', model_id)] = (pearl_mesh.Model(pearl_buildings.mdl_only(b)),
                                      pearl_render.textures(pearl_buildings.btx0_of(b)))
    return _CACHE[('prop', model_id)]


def pearl_set(i):
    if ('set', i) not in _CACHE:
        _CACHE[('set', i)] = pearl_render.textures(RV.pearl_rom()[1][i])
    return _CACHE[('set', i)]


def texset_names(data):
    t = nsbtx.tex0(data)
    texdict = struct.unpack_from('<H', t, 0xE)[0]
    pltdict = struct.unpack_from('<I', t, 0x34)[0]
    return {n for n, _ in nsbtx._dict(t, texdict)}, {n for n, _ in nsbtx._dict(t, pltdict)}


# ------------------------------------------------------------------------------------------------ the scene
class Room(RV.Room):
    """pearl_rooms_view.Room without its people mesh: cells, tiles, heights, warps and the camera (zmax from the south
    extent of the models the look draws, as sinnoh_rooms sets the zone's camera boundary)."""
    def __init__(self, pid):
        w, zones = RV.world()
        self.pid, self.fixed = pid, True
        self.r = w['rooms']['zones'][str(pid)]
        self.name = self.r['name'].replace('MAP_', '')
        self.zone = zones[pid]
        self.m = RV.matrix(self.r['pearl_matrix'])
        self.proj = 0 if self.zone['map_type'] in (4, 1) else 1
        self.cam = 0
        self.cells, self.coll, self.beh, self.hts = {}, {}, {}, {}
        for cz, row in enumerate(self.m['maps']):
            for cx, c in enumerate(row):
                if c == 0xffff: continue
                self.cells[(cx, cz)] = c
                land = json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))
                ht = RV.heights().get(str(c), {})
                beds = pearl_chunk.bed_solid(c)
                for tz in range(32):
                    for tx in range(32):
                        X, Z = cx * 32 + tx, cz * 32 + tz
                        self.coll[(X, Z)] = land['collision'][tz][tx] or int((tx, tz) in beds)
                        self.beh[(X, Z)] = land['behaviour'][tz][tx]
                        if f'{tx},{tz}' in ht: self.hts[(X, Z)] = ht[f'{tx},{tz}']
        self.zmax = 1e9
        self.ev = json.load(open(os.path.join(PEARL, 'events', f"{self.zone['events']:03d}.json")))

    def set_south(self, chunk_models):
        """The camera boundary from the map models' south extent ({(cx, cz): model})."""
        south = []
        for (cx, cz), mm in chunk_models.items():
            P = [mm.units(v) for sh in mm.shapes for poly in sh.polys for v in poly]
            if P: south.append(cz * 512 + 256 + max(p[2] for p in P))
        self.zmax = (max(south) - RV.camera_below()) if south else 1e9


def with_nodes(m):
    """A chunk model with its shapes' node translations for Top and pearl_render (chunks 410 and 417 draw shapes on
    translated nodes, which pearl_mesh's units() leave out; the DS applies them)."""
    st = m.shape_translations()
    m.shape_offsets = st if any(t != (0, 0, 0) for t in st) else None
    return m


class Look:
    """A room zone as one of three things draws it: 'pearl' (Pearl's own models and props, Pearl's camera),
    'ours' (the models sinnoh_rooms installs, or --files, under Black 2's camera with the zone's boundary)."""
    def __init__(self, pid, which='ours', inst=None, room=None):
        self.pid, self.which, self.inst = pid, which, inst
        self.room = room or Room(pid)
        w, zones = RV.world()
        self.area = w['rooms']['areas'][str(self.room.r['pearl_area'])]
        build, sets = RV.pearl_rom()
        if which == 'ours' and inst is not None:
            self.tex, self.pack, self.pack_tex = inst.area(self.room.r['pearl_area'])
            self.res_of = {int(k): v for k, v in w['rooms']['building_res'].items()}
        else:
            self.tex = pearl_set(self.area['pearl_texset'])
        self.models = []        # (model, textures, offset)
        maps = {}
        for (cx, cz), c in self.room.cells.items():
            off = np.array([cx * 512 + 256.0, 0.0, cz * 512 + 256.0])
            land = json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))
            if which == 'pearl':
                self.models.append((with_nodes(pearl_chunk.pearl_model(c)), self.tex, off))
                for pr in land['props']:
                    pm, ptex = pearl_prop(pr['model'])
                    self.models.append((pm, ptex, off + np.array(pr['pos'])))
            elif inst is not None:
                maps[(cx, cz)] = with_nodes(inst.chunk(c))
                self.models.append((maps[(cx, cz)], self.tex, off))
                for pr in RV.room_props(c, land, True):
                    key = ('inst', id(inst), self.room.r['pearl_area'], pr['model'])
                    if key not in _CACHE: _CACHE[key] = pearl_mesh.Model(self.pack[self.res_of[pr['model']]])
                    self.models.append((_CACHE[key], self.pack_tex, off + np.array(pr['pos'])))
            else:
                maps[(cx, cz)] = with_nodes(RV.chunk_model(c, True))
                self.models.append((maps[(cx, cz)], self.tex, off))
                for pr in RV.room_props(c, land, True):
                    pm, ptex = RV.prop_model(pr['model'], True)
                    self.models.append((pm, ptex, off + np.array(pr['pos'])))
        if maps: self.room.set_south(maps)

    def camera(self, tile):
        """(eye, target, half-angle, ortho) with the player on zone tile `tile`."""
        r = self.room
        px, py, pz = tile[0] * 16 + 8, r.feet_y(tile), tile[1] * 16 + 8
        if self.which == 'pearl':
            dist, pitch, ortho, half = PEARL_CAMERAS[r.zone['camera']]
            a = math.radians(pitch)
            tgt = np.array([px, py, pz], float)
            return tgt + dist * np.array([0, math.sin(a), math.cos(a)]), tgt, half, bool(ortho)
        eye, tgt = r.camera_at(px, py, pz, True)
        return eye, tgt, math.degrees(math.atan(1 / RV.COT)), False

    def scene(self, tile, scale=1):
        eye, tgt, half, ortho = self.camera(tile)
        sc = pearl_render.Scene(256 * scale, 192 * scale, eye, tgt, half=half, ortho=ortho)
        setup = pearl_render.LIGHTS['pearl_indoor']
        for m, tex, off in self.models:
            pearl_render.draw_model(sc, m, tex, offset=off, setup=setup)
        return sc

    def image(self, tile, scale=1, people=None, pdir=0):
        """The view with the player on `tile`. people: a pearl_rooms_view.Sprites to draw the zone's Pearl objects
        (where Pearl places them) and the player (facing pdir) as camera-facing quads at their feet: Pearl's 32 units
        a 32-px frame, tested at the feet's depth; ours as pearl_rooms_view.render (28 units, Black 2's margin)."""
        sc = self.scene(tile, scale)
        img = sc.image(pearl_render.EDGES['pearl_indoor'], VOID)
        if people is None: return img
        from PIL import Image
        arr = np.array(img)
        ppl = [(t, code, d) for _, t, code, d in self.room.people(people)] + [(tuple(tile), RV.PLAYER_CODES[0], pdir)]
        eye, tgt, half, ortho = self.camera(tile)
        unit = (sc.H / 2) / math.tan(math.radians(half)) / (np.linalg.norm(np.array(tgt) - eye) if ortho else 1)
        quad = 32.0 if self.which == 'pearl' else RV.QUAD
        drawn = []
        for t, code, d in ppl:
            fr = people.frame(code, d)
            if fr is None: continue
            feet = np.array([t[0] * 16 + 8, self.room.feet_y(t), t[1] * 16 + 8], float)
            if self.which == 'ours': feet[1] += RV.ANCHOR_Y
            sx, sy, depth = sc.project(feet[None])[0]
            drawn.append((depth, sx, sy, fr))
        for depth, sx, sy, (mask, rgb) in sorted(drawn, key=lambda q: -q[0]):
            fh, fw = mask.shape
            k = unit / (1 if ortho else depth)
            w_, h_ = quad * fw / 32 * k, quad * fh / 32 * k
            X0, X1 = int(round(sx - w_ / 2)), int(round(sx + w_ / 2)); Y0, Y1 = int(round(sy - h_)), int(round(sy))
            if self.which == 'ours': zt = depth * RV.K_EXACT[0] + RV.step(depth)
            else: zt = depth
            for Y in range(max(0, Y0), min(sc.H, Y1)):
                for X in range(max(0, X0), min(sc.W, X1)):
                    u = min(fw - 1, int((X + 0.5 - X0) / max(X1 - X0, 1) * fw))
                    v = min(fh - 1, int((Y + 0.5 - Y0) / max(Y1 - Y0, 1) * fh))
                    if mask[v, u] and zt < sc.z[Y, X]:
                        arr[Y, X] = rgb[v, u]
        return Image.fromarray(arr)


def pair(pid, tile, inst=None, inst2=None, people=False, pdir=0):
    """256x384: Pearl's look on top, ours below (and a third row for inst2); people: the zone's objects and the player."""
    from PIL import Image
    spr = RV.Sprites() if people else None
    ours = Look(pid, 'ours', inst)
    rows = [Look(pid, 'pearl', room=ours.room).image(tile, people=spr, pdir=pdir), ours.image(tile, people=spr, pdir=pdir)]
    if inst2 is not None: rows.append(Look(pid, 'ours', inst2).image(tile, people=spr, pdir=pdir))
    out = Image.new('RGB', (256, 192 * len(rows)))
    for k, im in enumerate(rows): out.paste(im, (0, 192 * k))
    return out


# ------------------------------------------------------------------------------------------------ checks
def check_tex(look, say):
    """(lost, Pearl's own): materials whose texture or palette the set lacks; 'pearl' when Pearl's own set (or the
    prop's own BTX0) lacks it too (Pearl's data: the DS binds nothing there in Pearl as well)."""
    n = own = 0
    tn, pn = texset_names(look.tex.src)
    ptn, ppn = texset_names(pearl_set(look.area['pearl_texset']).src)
    for m, tex, off in look.models:
        names = (tn, pn) if tex is look.tex else texset_names(tex.src)
        for tname, pname, *_ in pearl_render.bindings(m):
            miss = [x for x, have in ((tname, names[0]), (pname, names[1])) if x and x not in have]
            if not miss: continue
            pearls = tex is look.tex and all(x not in ptn and x not in ppn for x in miss)
            say('tex' if not pearls else 'tex_pearl', f"{'map' if tex is look.tex else 'prop'} material "
                f"{tname}/{pname}: {', '.join(miss)} not in the set" + (" (nor in Pearl's)" if pearls else ''))
            if pearls: own += 1
            else: n += 1
    return n, own


def check_dark(look, say):
    n = 0
    for m, tex, off in look.models:
        info = pearl_render.bindings(m)
        for s, src in zip(m.shapes, pearl_mesh.colour_sources(m)):
            if s.material is None or not info[s.material][5] & 15: continue
            bad = sum(1 for p, sp in zip(s.polys, src) if p[0][5] is not None and 'C' in sp)
            if bad:
                say('dark', f'{info[s.material][0]}: {bad} lit polygons coloured by COLOR commands'); n += bad
    return n


class Top:
    """The look's triangles seen from above: which surfaces cover a point, at what height, and whether the DS draws
    them there (an opaque texel of a texture the set holds, not a dark lit polygon)."""
    def __init__(self, look):
        T, UV, img, wrap, ok, faces = [], [], [], [], [], []
        self.images = []
        key = {}
        tn, pn = texset_names(look.tex.src)
        for m, tex, off in look.models:
            info = pearl_render.bindings(m)
            names = (tn, pn) if tex is look.tex else texset_names(tex.src)
            ps = m.pos_scale / 4096
            shape_off = getattr(m, 'shape_offsets', None) or [(0, 0, 0)] * len(m.shapes)
            for s, src, so in zip(m.shapes, pearl_mesh.colour_sources(m), shape_off):
                if s.material is None: continue
                tname, pname, teximg, diffamb, specemi, poly, flags = info[s.material]
                if (poly >> 16) & 31 == 0 or not (poly >> 6) & 3: continue      # (wireframe / no face drawn)
                have = (not tname or tname in names[0]) and (not pname or pname in names[1])
                k = (id(tex), tname, pname)
                if k not in key:
                    im = tex.get((tname, pname)) if tname and have else None
                    key[k] = len(self.images); self.images.append(None if im is None else im[..., 3])
                w4 = ((teximg >> 16) & 1, (teximg >> 17) & 1, (teximg >> 18) & 1, (teximg >> 19) & 1)
                lit = bool(poly & 15)
                for p, sp in zip(s.polys, src):
                    P = np.array([v.pos for v in p], float) * ps + off + np.array(so, float)
                    Q = np.array([(v[3] / 16, v[4] / 16) for v in p])
                    good = have and not (lit and p[0][5] is not None and 'C' in sp and p[0][6] is not None
                                         and all(v[6] == 0 for v in p))
                    for a, b, c in ((0, 1, 2), (0, 2, 3)) if len(p) == 4 else ((0, 1, 2),):
                        T.append(P[[a, b, c]]); UV.append(Q[[a, b, c]]); img.append(key[k]); wrap.append(w4)
                        ok.append(good); faces.append((poly >> 6) & 3)
        self.T = np.array(T, float).reshape(-1, 3, 3); self.UV = np.array(UV, float).reshape(-1, 3, 2)
        self.img = np.array(img, int); self.wrap = np.array(wrap, int).reshape(-1, 4); self.ok = np.array(ok, bool)
        self.faces = np.array(faces, int)     # (the material's faces: 1 back, 2 front, 3 both)
        self.names = {i: n for n, i in key.items()}
        n = np.cross(self.T[:, 1] - self.T[:, 0], self.T[:, 2] - self.T[:, 0])
        self.up = n[:, 1] > 0.5 * np.linalg.norm(n, axis=1) + 1e-9
        self.lo, self.hi = self.T.min(axis=1), self.T.max(axis=1)

    def at(self, x, z):
        """[(height, drawn)] of the upward surfaces over (x, z)."""
        out = []
        for t in np.nonzero(self.up & (self.lo[:, 0] <= x) & (self.hi[:, 0] >= x) & (self.lo[:, 2] <= z)
                            & (self.hi[:, 2] >= z))[0]:
            a, b, c = self.T[t]
            d = (b[0] - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (b[2] - a[2])
            if abs(d) < 1e-9: continue
            u = ((x - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (z - a[2])) / d
            v = ((b[0] - a[0]) * (z - a[2]) - (x - a[0]) * (b[2] - a[2])) / d
            if u < -1e-4 or v < -1e-4 or u + v > 1 + 1e-4: continue
            y = a[1] + u * (b[1] - a[1]) + v * (c[1] - a[1])
            drawn = bool(self.ok[t])
            A = self.images[self.img[t]]
            if drawn and A is not None:
                s_, t_ = self.UV[t][0] + u * (self.UV[t][1] - self.UV[t][0]) + v * (self.UV[t][2] - self.UV[t][0])
                th, tw = A.shape
                rs, rt, fs, ft = self.wrap[t]
                def wr(cc, nn, rep, flip):
                    i = int(math.floor(cc))
                    if not rep: return min(max(i, 0), nn - 1)
                    if flip and (i // nn) % 2: return nn - 1 - i % nn
                    return i % nn
                drawn = A[wr(t_, th, rt, ft), wr(s_, tw, rs, fs)] >= 128
            out.append((y, drawn))
        return out


def bad_floors(look, top):
    """{reachable tile: 'black' | 'nothing'} whose floor (an upward surface within 3 units of the collision height)
    is not drawn; warp tiles (doorways in a wall, stairs) are left out."""
    warps = {(w['x'], w['z']) for w in look.room.ev['warp_events']}
    out = {}
    for t in sorted(look.room.reachable() - warps):
        gy = look.room.feet_y(t)
        miss = []
        for ox, oz in ((0, 0), (-5, -5), (5, -5), (-5, 5), (5, 5)):      # (a tile edge through one point is no gap)
            hits = [d for y, d in top.at(t[0] * 16 + 8 + ox, t[1] * 16 + 8 + oz) if abs(y - gy) <= FLOOR_WINDOW]
            if not any(hits): miss.append('black' if hits else 'nothing')
        if len(miss) >= 4: out[t] = Counter(miss).most_common(1)[0][0]
    return out


def check_floor(look, top, pearl_top, say):
    """Reachable tiles whose floor ours does not draw where Pearl's own look does (Pearl's own gaps, e.g. floors
    drawn by a lift or a bridge at another height, are Pearl's)."""
    ours = bad_floors(look, top)
    if not ours: return 0
    pearl = bad_floors(look, pearl_top)
    bad = {t: k for t, k in ours.items() if t not in pearl}
    if bad:
        kinds = Counter(bad.values())
        say('floor', f"{len(bad)} reachable tiles whose floor Pearl draws and ours not "
            f"({', '.join(f'{v} {k}' for k, v in kinds.items())}): "
            + ' '.join(f'{t[0]},{t[1]}' for t in sorted(bad)[:12]) + (' ...' if len(bad) > 12 else ''))
    return len(bad)


def covered(top, room):
    """{zone tile: n}: how many of 9 points of the tile (its centre and +-5 units) have an upward surface over them
    (the room's top-view outline)."""
    tiles = sorted(room.coll)
    W = max(x for x, _ in tiles) + 1; H = max(z for _, z in tiles) + 1
    cov = np.zeros((3, 3, H, W), bool)
    for t in np.nonzero(top.up)[0]:
        a, b, c = top.T[t]
        d = (b[0] - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (b[2] - a[2])
        if abs(d) < 1e-9: continue
        for i, oz in enumerate((-5, 0, 5)):
            for j, ox in enumerate((-5, 0, 5)):
                x0 = max(0, int(math.floor((top.lo[t, 0] - 8 - ox) / 16)))
                x1 = min(W - 1, int(math.ceil((top.hi[t, 0] - 8 - ox) / 16)))
                z0 = max(0, int(math.floor((top.lo[t, 2] - 8 - oz) / 16)))
                z1 = min(H - 1, int(math.ceil((top.hi[t, 2] - 8 - oz) / 16)))
                if x0 > x1 or z0 > z1: continue
                zz, xx = np.mgrid[z0:z1 + 1, x0:x1 + 1]
                x, z = xx * 16 + 8.0 + ox, zz * 16 + 8.0 + oz
                u = ((x - a[0]) * (c[2] - a[2]) - (c[0] - a[0]) * (z - a[2])) / d
                v = ((b[0] - a[0]) * (z - a[2]) - (x - a[0]) * (b[2] - a[2])) / d
                cov[i, j, z0:z1 + 1, x0:x1 + 1] |= (u >= -1e-4) & (v >= -1e-4) & (u + v <= 1 + 1e-4)
    n = cov.sum(axis=(0, 1))
    return {(X, Z): int(n[Z, X]) for X, Z in tiles}


def check_holes(look, top, pearl_cov, say):
    """Tiles Pearl's own model (and props) covers from above at 5 or more of 9 points of which the installed room
    leaves 5 or more empty: geometry lost in the conversion (a hole shows the clear colour, black indoors)."""
    cov = covered(top, look.room)
    lost = sorted(t for t, n in cov.items() if pearl_cov.get(t, 0) >= 5 and pearl_cov[t] - n >= 5)
    if lost:
        say('hole', f'{len(lost)} tiles Pearl covers left empty: ' + ' '.join(f'{x},{z}' for x, z in lost[:12])
            + (' ...' if len(lost) > 12 else ''))
    return len(lost)


# ------------------------------------------------------------------------------------------------ void
RAY_STEP = 8                             # one ray per 8 x 8 pixels of the 256 x 192 screen (--ray-step)
NEAR_MISS = 5.0                          # (units: the layers fix moves pieces 2.25 along the view direction, the
                                         # furniture fix (people_prop) pulls props toward the camera, ~3.5 wider)


def cast(top, O, D, box=None, cell=48.0):
    """The surface the DS draws first along each ray O + t D (O, D: (R, 3); t > 0): (t, triangle index) per ray,
    (inf, -1) where nothing is drawn (the clear colour shows). Faces culled by the material's front/back bits (front:
    n = (B - A) x (C - A) toward the camera, as Pearl's floors, which draw their front only, face up); a hit on a
    transparent texel (the alpha test) lets the ray go on. box (x0, x1, z0, z1): only the triangles over it. The rays
    go in bundles by where they cross the scene's height range (cells of `cell` units), each against the triangles
    over its stretch."""
    R = len(D)
    best_t, best_i = np.full(R, np.inf), np.full(R, -1)
    if not len(top.T) or not R: return best_t, best_i
    if not hasattr(top, 'E1'):
        top.A, top.E1, top.E2 = top.T[:, 0], top.T[:, 1] - top.T[:, 0], top.T[:, 2] - top.T[:, 0]
        top.ylo, top.yhi = float(top.lo[:, 1].min()) - 1, float(top.hi[:, 1].max()) + 1
    O = np.asarray(O, np.float64); D = np.asarray(D, np.float64)
    idx = np.arange(len(top.T))
    if box is not None:
        x0, x1, z0, z1 = box
        idx = idx[(top.hi[:, 0] >= x0) & (top.lo[:, 0] <= x1) & (top.hi[:, 2] >= z0) & (top.lo[:, 2] <= z1)]
    if not len(idx): return best_t, best_i
    down = D[:, 1] < -1e-3
    dy = np.where(down, D[:, 1], -1.0)
    ta = np.where(down, np.maximum(0, (top.yhi - O[:, 1]) / dy), 0)
    tb = np.where(down, np.maximum(ta, (top.ylo - O[:, 1]) / dy), 1e5)
    Pa, Pb = O + ta[:, None] * D, O + tb[:, None] * D
    seg_lo, seg_hi = np.minimum(Pa, Pb), np.maximum(Pa, Pb)
    mid = (seg_lo + seg_hi) / 2
    key = np.floor(mid[:, [0, 2]] / cell).astype(np.int64)
    key = np.where(down[:, None], key, 1 << 30)          # (rays not going down: one bundle, every triangle)
    _, group = np.unique(key, axis=0, return_inverse=True)
    group = group.ravel()
    lo_t, hi_t = top.lo[idx], top.hi[idx]
    for g in range(group.max() + 1):
        rays = np.nonzero(group == g)[0]
        bl, bh = seg_lo[rays].min(0), seg_hi[rays].max(0)
        ids = idx[(hi_t[:, 0] >= bl[0]) & (lo_t[:, 0] <= bh[0]) & (hi_t[:, 2] >= bl[2]) & (lo_t[:, 2] <= bh[2])]
        if not len(ids): continue
        t, tri = _cast(top, O[rays], D[rays], ids)
        best_t[rays], best_i[rays] = t, tri
    return best_t, best_i


def _cast(top, O, D, ids, chunk=512):
    R = len(D)
    best_t, best_i = np.full(R, np.inf), np.full(R, -1)
    for c0 in range(0, len(ids), chunk):
        tid = ids[c0:c0 + chunk]
        A, E1, E2 = top.A[tid], top.E1[tid], top.E2[tid]
        # Moller-Trumbore, written out per component
        px = D[:, None, 1] * E2[None, :, 2] - D[:, None, 2] * E2[None, :, 1]
        py = D[:, None, 2] * E2[None, :, 0] - D[:, None, 0] * E2[None, :, 2]
        pz = D[:, None, 0] * E2[None, :, 1] - D[:, None, 1] * E2[None, :, 0]
        det = px * E1[None, :, 0] + py * E1[None, :, 1] + pz * E1[None, :, 2]
        faces = top.faces[tid][None]
        seen = np.where(det > 1e-9, faces & 2, np.where(det < -1e-9, faces & 1, 0)) > 0
        if not seen.any(): continue
        inv = np.where(seen, 1 / np.where(seen, det, 1), 0)
        sx = O[:, None, 0] - A[None, :, 0]; sy = O[:, None, 1] - A[None, :, 1]; sz = O[:, None, 2] - A[None, :, 2]
        u = (sx * px + sy * py + sz * pz) * inv
        qx = sy * E1[None, :, 2] - sz * E1[None, :, 1]
        qy = sz * E1[None, :, 0] - sx * E1[None, :, 2]
        qz = sx * E1[None, :, 1] - sy * E1[None, :, 0]
        v = (qx * D[:, None, 0] + qy * D[:, None, 1] + qz * D[:, None, 2]) * inv
        t = (qx * E2[None, :, 0] + qy * E2[None, :, 1] + qz * E2[None, :, 2]) * inv
        hit = seen & (u >= -1e-6) & (v >= -1e-6) & (u + v <= 1 + 1e-6) & (t > 1e-3)
        rr, tt = np.nonzero(hit)
        if not len(rr): continue
        keep = opaque(top, tid[tt], u[rr, tt], v[rr, tt])
        rr, tt, th = rr[keep], tt[keep], t[rr, tt][keep]
        cand_t = np.full(R, np.inf); np.minimum.at(cand_t, rr, th)
        win = th == cand_t[rr]
        cand_i = np.full(R, -1); cand_i[rr[win]] = tid[tt[win]]
        better = cand_t < best_t
        best_t[better], best_i[better] = cand_t[better], cand_i[better]
    return best_t, best_i


def opaque(top, tri, u, v):
    """The alpha test at barycentric (u, v) of triangles tri (no texture or one the set lacks: drawn)."""
    out = np.ones(len(tri), bool)
    for k in np.unique(top.img[tri]):
        A = top.images[k]
        if A is None: continue
        sel = np.nonzero(top.img[tri] == k)[0]
        t = tri[sel]
        UV = top.UV[t]
        st = UV[:, 0] + u[sel, None] * (UV[:, 1] - UV[:, 0]) + v[sel, None] * (UV[:, 2] - UV[:, 0])
        th, tw = A.shape
        idx = []
        for c, n, rep, flip in ((st[:, 0], tw, top.wrap[t, 0], top.wrap[t, 2]),
                                (st[:, 1], th, top.wrap[t, 1], top.wrap[t, 3])):
            i = np.floor(c).astype(int)
            m = np.mod(i, n)
            m = np.where(flip.astype(bool) & (np.floor_divide(i, n) % 2 == 1), n - 1 - m, m)
            idx.append(np.where(rep.astype(bool), m, np.clip(i, 0, n - 1)))
        out[sel] = A[idx[1], idx[0]] >= 128
    return out


def near_surface(top, P, dmax, cell=32.0):
    """(N,) bool: point P[n] within dmax units of one of the triangles (any face, drawn or not)."""
    out = np.zeros(len(P), bool)
    key = np.floor(P[:, [0, 2]] / cell).astype(np.int64)
    _, group = np.unique(key, axis=0, return_inverse=True)
    group = group.ravel()
    for g in range(group.max() + 1 if len(P) else 0):
        pts = np.nonzero(group == g)[0]
        lo, hi = P[pts].min(0) - dmax, P[pts].max(0) + dmax
        ids = np.nonzero(np.all(top.hi >= lo, axis=1) & np.all(top.lo <= hi, axis=1))[0]
        if not len(ids): continue
        out[pts] = point_triangle_distance(P[pts], top.T[ids]).min(axis=1) < dmax
    return out


def point_triangle_distance(P, T):
    """(N, M) distances from points P (N, 3) to triangles T (M, 3, 3)."""
    A, B, C = T[:, 0][None], T[:, 1][None], T[:, 2][None]
    X = P[:, None, :]
    n = np.cross(B - A, C - A)
    nn = np.linalg.norm(n, axis=2, keepdims=True)
    n = n / np.where(nn > 1e-12, nn, 1)
    d = np.sum((X - A) * n, axis=2)
    Q = X - d[..., None] * n
    def side(U, V):
        return np.sum(np.cross(V - U, Q - U) * n, axis=2)
    inside = (side(A, B) >= 0) & (side(B, C) >= 0) & (side(C, A) >= 0) & (nn[..., 0] > 1e-12)
    def seg(U, V):
        e = V - U
        t = np.clip(np.sum((X - U) * e, axis=2) / np.maximum(np.sum(e * e, axis=2), 1e-12), 0, 1)
        return np.linalg.norm(X - (U + t[..., None] * e), axis=2)
    edge = np.minimum(np.minimum(seg(A, B), seg(B, C)), seg(C, A))
    return np.where(inside, np.abs(d), edge)


def view_basis(eye, tgt):
    f = np.array(tgt, float) - np.array(eye, float); dist = np.linalg.norm(f); f /= dist
    r = np.cross(f, (0, 1, 0)); r /= np.linalg.norm(r)
    return f, r, np.cross(r, f), dist


def view_rays(look, tile, step=RAY_STEP):
    """(O, D, pixel x, pixel y) of one ray per step x step pixels: the look's camera with the player on `tile`
    (pearl_render.Scene's projection: square pixels, 256 x 192, the vertical half-angle)."""
    eye, tgt, half, ortho = look.camera(tile)
    f, r, u, dist = view_basis(eye, tgt)
    k = 96 / math.tan(math.radians(half))
    ys, xs = np.mgrid[step / 2:192:step, step / 2:256:step]
    xs, ys = xs.ravel(), ys.ravel()
    a, b = (xs - 128) / k, (96 - ys) / k
    if ortho:                                            # (Pearl's room camera 4: parallel rays)
        O = eye + (a * dist)[:, None] * r + (b * dist)[:, None] * u
        D = np.repeat(f[None], len(xs), 0)
    else:
        O = np.repeat(np.array(eye, float)[None], len(xs), 0)
        D = f + a[:, None] * r + b[:, None] * u
        D /= np.linalg.norm(D, axis=1, keepdims=True)
    return O, D, xs, ys


def on_screen(look, tiles, P):
    """(N, M) bool: point P[n] on the look's screen with the player on tiles[m]."""
    cams = [look.camera(t) for t in tiles]
    f, r, u, dist = view_basis(cams[0][0], cams[0][1])
    half, ortho = cams[0][2], cams[0][3]
    E = np.array([c[0] for c in cams], float)
    k = 96 / math.tan(math.radians(half))
    qr = (P @ r)[:, None] - (E @ r)[None]
    qu = (P @ u)[:, None] - (E @ u)[None]
    qf = (P @ f)[:, None] - (E @ f)[None]
    if ortho:
        x, y, ok = 128 + k / dist * qr, 96 - k / dist * qu, qf > 0
    else:
        w = np.where(qf > 1, qf, 1)
        x, y, ok = 128 + k * qr / w, 96 - k * qu / w, qf > 1
    return ok & (x >= 0) & (x < 256) & (y >= 0) & (y < 192)


def view_box(tile):
    """(x0, x1, z0, z1) around the player's tile holding everything either game's camera draws (Black 2's sees ~10
    tiles to each side and ~9 north at the top of the screen, Pearl's ~8 and ~8; tall things from further south)."""
    x, z = tile[0] * 16 + 8, tile[1] * 16 + 8
    return x - 272, x + 272, z - 272, z + 224


def camera_tiles(reach):
    """The reachable tiles whose camera looks farthest out: each row's west and east end, each column's north and
    south end (the camera only moves with the player, so every other tile's screen lies between theirs)."""
    rows, cols = defaultdict(list), defaultdict(list)
    for x, z in reach:
        rows[z].append(x); cols[x].append(z)
    out = {(min(xs), z) for z, xs in rows.items()} | {(max(xs), z) for z, xs in rows.items()}
    out |= {(x, min(zs)) for x, zs in cols.items()} | {(x, max(zs)) for x, zs in cols.items()}
    return sorted(out)


def clear_colours(look, inst=None):
    """{(r, g, b)} the clear colour of the room's light table takes over the day (Black 2: G3X_SetClearColor with the
    table's 6th colour, opaque, field_light.c; Pearl: black, transparent over the black backdrop, easy3d.c)."""
    import maplook
    pa = look.room.r['pearl_area']
    if inst is not None:
        import narcio, zoneheaders
        if 'lights' not in _CACHE:
            _CACHE['lights'] = narcio.load(inst.files, maplook.LIGHT_ARC)
            _CACHE['headers'] = zoneheaders.load(inst.files)[0]
        area = _CACHE['headers'][look.room.r['b2_zone']]['area']
        recs = range(area, area + 4) if area in range(2, 0x11A) else (area,)
        tables = [_CACHE['lights'][inst.area_tab[10 * a + 7]] for a in recs]
    else:                                                # (what sinnoh_rooms installs)
        import sinnoh_rooms
        rom = _pearl_rom()
        tables = maplook.room_light_tables(rom, bool(sinnoh_rooms.pearl_light_field(rom).get(pa)))
    out = set()
    for d in tables:
        for k in range(len(d) // 52):
            c = struct.unpack_from('<H', d, 52 * k + 50)[0]
            out.add((c & 31, (c >> 5) & 31, (c >> 10) & 31))
    return out


def _pearl_rom():
    RV.pearl_rom()
    return RV._cache['rom']


def check_void(look, top, pearl_look, pearl_top, clear, say, step=RAY_STEP, geometry=True):
    """What ours draws where Pearl's room is void (2026-10-25), from every reachable tile at the ends of its row and
    column (camera_tiles), one ray per step x step pixels:
      sky     nothing drawn and the room's clear colour is not black (the day-cycle light tables clear to the sky
              colour: (16,24,30) by day, orange in the evening, purple at night); Pearl's void is black;
      model   ours draws a surface (ground, model, prop) on a line of sight where Pearl's own look meets nothing,
              and the surface is not Pearl's: Pearl's ray through the point (its camera on the nearest reachable tile
              that has the point on screen, else on the nearest reachable tile) hits no surface, nor do its rays 5
              units to each side within 10 units of the point (pieces the layers and furniture fixes moved show past
              Pearl's silhouette), and no triangle of Pearl's lies within 5 units of it;
      beyond  (a note, not an error) Pearl's own geometry that Pearl's camera never shows and ours does: off Pearl's
              screen from every reachable tile (Black 2's camera is wider: cliffs past a lake's shore), or edge-on
              to it (the side walls' inner faces under Pearl's orthographic room camera 4).
    Returns (sky px, model px, beyond px)."""
    room = look.room
    reach = sorted(room.reachable())
    if not reach: return 0, 0, 0
    cams = camera_tiles(reach)
    bright = sorted(c for c in clear if c != (0, 0, 0))
    sky, sky_at = 0, []
    hits_P, hits_tri, hits_cam = [], [], []
    for tile in cams:
        O, D, xs, ys = view_rays(look, tile, step)
        t, tri = cast(top, O, D, box=view_box(tile))
        none = ~np.isfinite(t)
        if bright and none.any():
            sky += int(none.sum()) * step * step; sky_at.append((int(none.sum()), tile))
        h = np.nonzero(~none)[0]
        hits_P.append(O[h] + t[h, None] * D[h]); hits_tri.append(tri[h]); hits_cam.append(np.full(len(h), len(hits_cam)))
    if sky:
        sky_at.sort(reverse=True)
        say('sky', f"the clear colour {'/'.join(map(str, bright))} (light table) shows where nothing is drawn: "
            f"{sky} px over {len(sky_at)} of {len(cams)} edge tiles' screens (most: "
            + ' '.join(f'{x},{z}' for _, (x, z) in sky_at[:6]) + "); Pearl's void is black")
    P = np.concatenate(hits_P) if hits_P else np.zeros((0, 3))
    tri = np.concatenate(hits_tri) if hits_tri else np.zeros(0, int)
    cam = np.concatenate(hits_cam) if hits_cam else np.zeros(0, int)
    if not len(P) or not geometry: return sky, 0, 0
    # Pearl's screens: is the point ever on one, and from which tile (the nearest)?
    see = np.zeros((len(P), len(reach)), bool)
    for c0 in range(0, len(P), 4096):
        see[c0:c0 + 4096] = on_screen(pearl_look, reach, P[c0:c0 + 4096])
    never = ~see.any(axis=1)
    R = np.array(reach, float) * 16 + 8
    pick = np.zeros(len(P), int)
    for c0 in range(0, len(P), 4096):
        sl = slice(c0, c0 + 4096)
        d2 = (P[sl, None, 0] - R[None, :, 0]) ** 2 + (P[sl, None, 2] - R[None, :, 1]) ** 2
        pick[sl] = np.where(never[sl], np.argmin(d2, axis=1), np.argmin(np.where(see[sl], d2, np.inf), axis=1))
    void = np.zeros(len(P), bool)
    for m in np.unique(pick):
        sel = np.nonzero(pick == m)[0]
        eye, tgt, half, ortho = pearl_look.camera(reach[m])
        f = view_basis(eye, tgt)[0]
        if ortho:
            Dp = np.repeat(f[None], len(sel), 0); Op = P[sel] - 4000 * Dp
        else:
            Op = np.repeat(np.array(eye, float)[None], len(sel), 0)
            Dp = P[sel] - Op; Dp /= np.linalg.norm(Dp, axis=1, keepdims=True)
        x0, x1, z0, z1 = view_box(reach[m])
        x0 = min(x0, P[sel, 0].min() - 64); x1 = max(x1, P[sel, 0].max() + 64)
        z0 = min(z0, P[sel, 2].min() - 64); z1 = max(z1, P[sel, 2].max() + 64)
        tp, _ = cast(pearl_top, Op, Dp, box=(x0, x1, z0, z1))
        miss = sel[~np.isfinite(tp)]
        if len(miss):                   # (a piece the layers fix moved 2.25 units shows past Pearl's silhouette: a
            _, r_, u_, _ = view_basis(eye, tgt)              # surface of Pearl's within NEAR_MISS of the point is no void)
            near = np.zeros(len(miss), bool)
            for off in (r_, -r_, u_, -u_):
                Q = P[miss] + NEAR_MISS * off
                if ortho:
                    Dq = np.repeat(f[None], len(miss), 0); Oq = Q - 4000 * Dq
                else:
                    Oq = np.repeat(np.array(eye, float)[None], len(miss), 0)
                    Dq = Q - Oq; Dq /= np.linalg.norm(Dq, axis=1, keepdims=True)
                tq, _ = cast(pearl_top, Oq, Dq, box=(x0, x1, z0, z1))
                hit = Oq + np.where(np.isfinite(tq), tq, 0)[:, None] * Dq
                near |= np.isfinite(tq) & (np.linalg.norm(hit - P[miss], axis=1) < 2 * NEAR_MISS)
            miss = miss[~near]
        void[miss] = True
    # a point on Pearl's own geometry that Pearl's ray grazes (side walls' inner faces, edge-on to Pearl's
    # orthographic camera 4) is Pearl's art, not void
    if void.any():
        own = near_surface(pearl_top, P[void], NEAR_MISS)
        k = np.nonzero(void)[0]
        void[k[own]] = False
        never[k[own]] = True
    beyond = never & ~void
    for kind, bad in (('model', void), ('beyond', beyond)):
        if not bad.any(): continue
        names = Counter(top.names[top.img[i]][1] or 'untextured' for i in tri[bad])
        T = np.floor(P[bad][:, [0, 2]] / 16).astype(int)
        tiles = Counter(map(tuple, T))
        what = ("of ours where Pearl's own look meets nothing" if kind == 'model' else
                "of Pearl's own geometry Pearl's camera never shows (off its screen or edge-on)")
        say(kind, f"{int(bad.sum()) * step * step} px {what}: "
            + ', '.join(f'{n} {k}' for k, n in names.most_common(4))
            + f"; at tiles x {T[:, 0].min()}..{T[:, 0].max()} z {T[:, 1].min()}..{T[:, 1].max()} (most: "
            + ' '.join(f'{x},{z}' for (x, z), _ in tiles.most_common(5)) + '), seen from '
            + ' '.join(f'{cams[c][0]},{cams[c][1]}' for c, _ in Counter(cam[bad]).most_common(4)))
    return sky, int(void.sum()) * step * step, int(beyond.sum()) * step * step


# ------------------------------------------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--files'); ap.add_argument('--files2')
    ap.add_argument('--render'); ap.add_argument('--pair'); ap.add_argument('--cam', default='b2')
    ap.add_argument('--json'); ap.add_argument('--summary', action='store_true')
    ap.add_argument('--people', action='store_true'); ap.add_argument('--dir', type=int, default=0)
    ap.add_argument('--kinds', default='tex,dark,floor,hole,sky,model,beyond')
    ap.add_argument('--ray-step', type=int, default=RAY_STEP)
    ap.add_argument('zones', nargs='*')
    a = ap.parse_args()
    inst = Installed(a.files) if a.files else None
    inst2 = Installed(a.files2) if a.files2 else None
    if a.render or a.pair:
        pid = RV.zone_ids(a.zones[:1])[0]
        tile = tuple(map(int, a.zones[1].split(',')))
        if a.pair:
            pair(pid, tile, inst, inst2, a.people, a.dir).save(a.pair); print(a.pair)
        else:
            Look(pid, 'pearl' if a.cam == 'pearl' else 'ours', inst).image(tile).save(a.render); print(a.render)
        return
    total, lines, per = Counter(), [], {}
    for pid in RV.zone_ids(a.zones):
        look = Look(pid, 'ours', inst)
        out = []
        say = lambda k, s: out.append((k, s))
        f = Counter()
        kinds = set(a.kinds.split(','))
        if 'tex' in kinds:
            lost, own = check_tex(look, say)
            f['tex'] += lost; f['tex_pearl'] += own
        if 'dark' in kinds: f['dark'] += check_dark(look, say)
        pearl = Look(pid, 'pearl', room=look.room)
        top, pearl_top = Top(look), Top(pearl)
        if 'floor' in kinds: f['floor'] += check_floor(look, top, pearl_top, say)
        if 'hole' in kinds: f['hole'] += check_holes(look, top, covered(pearl_top, look.room), say)
        if kinds & {'sky', 'model', 'beyond'}:
            sky, px, far = check_void(look, top, pearl, pearl_top,
                                      clear_colours(look, inst) if 'sky' in kinds else set(), say, a.ray_step,
                                      geometry=bool(kinds & {'model', 'beyond'}))
            f['sky'] += sky; f['model'] += px; f['beyond'] += far
            out[:] = [o for o in out if o[0] in kinds or o[0] == 'tex_pearl']
            for k in ('model', 'beyond'):
                if k not in kinds: f.pop(k, None)
        f = +f
        total.update(f); per[look.room.name] = dict(f)
        for k, s in out:
            ln = f'{look.room.name} ({pid}): ({k}) {s}'
            lines.append(ln)
            if not a.summary: print(ln, flush=True)
    print('total: ' + (', '.join(f'{k} {v}' for k, v in sorted(total.items())) or 'nothing found'))
    if a.json: json.dump(dict(total=total, per=per, lines=lines), open(a.json, 'w'), indent=1)


if __name__ == '__main__':
    main()
