"""Offline DS-style render of a Pearl map chunk with its placed props (the world pass, 2026-10-20): what a room or a
spot looks like with Pearl's own textures, vertex colours and lights, without an emulator.

    python3 pearl_render.py CHUNK TEXSET OUT.png [--at TX,TZ] [--light pearl_indoor|b2_room] [--scale N]
                            [--fixed 1] [--flicker 1] [--cracks PX] [--props 0]

The camera is Black 2's field camera 0 (distance 237, pitch 53.2 degrees, vertical half-angle 20) looking at tile
(TX, TZ) at its ground height, 256x192 (times --scale). Each polygon: nearest texel (repeat/flip from the material),
alpha-tested (colour 0 / A3I5 / A5I3 under half), modulated by the vertex colour ((t+1)(v+1)-1)/32 as the DS does;
lit materials take the light setup named by --light: pearl_indoor (Pearl's area01light: light 0 (23,23,25), light 2
(4,4,16), the global material colours diffuse 16, ambient 14, specular 20, emission 16, Pearl clearing the
materials' own colours), b2_room (Black 2's interior table 132 at midday on the materials' own colours: what the
build did before this pass). A lit corner whose last colour command was a COLOR (not a NORMAL) takes that colour,
as the GX does (pearl_mesh.colour_sources; the Eterna Gym's black grass, 2026-10-25). Scene(ortho=True): an
orthographic camera (Pearl's room camera 4; room_look_check.py draws Pearl's own look with Pearl's cameras).
Edge marking: a polygon-ID change draws the edge colour of the nearer pixel's ID group (--edges pearl_indoor |
b2_room). No translucency sorting beyond drawing translucent polygons last.

--fixed 1: the model as the build installs it (pearl_chunk.fix_model, with the chunk's neighbours in matrix 0 or its
room matrix). --flicker 1: the DS's depth precision with Black 2's camera 0 (Z-buffer, near 1, far 1024: z/w kept to
1/16384), drawn twice in opposite polygon orders; pixels whose colour depends on the order (two surfaces within one
depth step) are painted magenta: where the picture flickers as the camera moves. --cracks PX: every triangle shrunk
PX pixels toward its centre, a stand-in for the DS's 1-pixel cracks (melonDS and hardware): what shows through them
is what the player sees in a crack (sky colour (16,24,30) behind; ground with the under-floor).
"""
import json, math, os, struct, sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import pearl_mesh, nsbtx  # noqa: E402

LIGHTS = {
    'pearl_indoor': dict(lights=[((23, 23, 25), (-2043, -3548, 110)), None, ((4, 4, 16), (0, 0, 4096)), None],
                         mat=((16, 16, 16), (14, 14, 14), (20, 20, 20), (16, 16, 16)), own=False),
    'b2_room': dict(lights=[((22, 22, 20), (-1934, -3548, -296)), ((2, 2, 12), (0, 2048, 4028)),
                            ((17, 29, 31), (0, 4096, 0)), None],
                    mat=((15, 15, 15), (9, 11, 11), (16, 16, 16), (14, 14, 14)), own=True),
}
EDGES = {'pearl_indoor': [0x0000] + [0x1084] * 7,
         'b2_room': [0x0000, 0x1084, 0x2108, 0x318C, 0x4210, 0x5294, 0x6318, 0x4210]}


def _rgb(c):
    return np.array([c & 31, (c >> 5) & 31, (c >> 10) & 31], float)


class textures(dict):
    """{texture name: (H, W, 4) uint8 array} of a BTX0, each drawn with the palette its material names
    (tex.get((texture, palette))); nsbtx.decode's own pairing (<texture>_pl, else the first) is the fallback."""
    def __init__(self, texset_bytes):
        super().__init__({name: np.array(img) for name, img, _ in nsbtx.decode(texset_bytes)})
        self.src = texset_bytes
        self.cache = {}

    def get(self, key, default=None):
        if not isinstance(key, tuple): return dict.get(self, key, default)
        tname, pname = key
        if key not in self.cache:
            self.cache[key] = _decode_with(self.src, tname, pname) if pname else dict.get(self, tname)
        img = self.cache[key]
        return dict.get(self, tname, default) if img is None else img


def _decode_with(data, tname, pname):
    """One texture of a BTX0 drawn with the named palette (nsbtx.decode's formats 1-4 and 6; others: None)."""
    t = nsbtx.tex0(data)
    texdict = struct.unpack_from('<H', t, 0xE)[0]
    texdata = struct.unpack_from('<I', t, 0x14)[0]
    pltdict = struct.unpack_from('<I', t, 0x34)[0]
    pltdata = struct.unpack_from('<I', t, 0x38)[0]
    pals = {n: pltdata + (struct.unpack_from('<H', e, 0)[0] << 3) for n, e in nsbtx._dict(t, pltdict)}
    ents = dict(nsbtx._dict(t, texdict))
    if tname not in ents or pname not in pals: return None
    p = struct.unpack_from('<I', ents[tname], 0)[0]
    fmt = (p >> 26) & 7; w = 8 << ((p >> 20) & 7); h = 8 << ((p >> 23) & 7); col0 = (p >> 29) & 1
    if fmt not in (1, 2, 3, 4, 6): return None
    raw = t[texdata + ((p & 0xFFFF) << 3):]
    po = pals[pname]
    pal = np.array([nsbtx._rgb(struct.unpack_from('<H', t, po + 2 * i)[0]) for i in range(256 if fmt == 4 else 32)
                    if po + 2 * i + 2 <= len(t)], np.uint8)
    n = w * h
    if fmt in (1, 6):
        v = np.frombuffer(raw[:n], np.uint8).astype(np.int32)    # (int: in uint8 (v >> 5) * 255 overflowed and
        idx, a = (v & 31, (v >> 5) * 255 // 7) if fmt == 1 else (v & 7, (v >> 3) * 255 // 31)
        img = pal[np.minimum(idx, len(pal) - 1)].copy(); img[:, 3] = a   # every texel came out ~36: 2026-10-26)
    else:
        bpp = {2: 2, 3: 4, 4: 8}[fmt]
        b = np.frombuffer(raw[:n * bpp // 8], np.uint8)
        idx = np.stack([(b >> s) & ((1 << bpp) - 1) for s in range(0, 8, bpp)], 1).reshape(-1)
        img = pal[np.minimum(idx, len(pal) - 1)].copy()
        if col0: img[idx == 0, 3] = 0
    return img.reshape(h, w, 4)


def bindings(model):
    """[(texture name, palette name, texImageParam, diffamb, specemi, polyattr, flags)] per material index."""
    d, m = model.data, model.m
    mats = m + model.omat
    tex_d, pal_d = struct.unpack_from('<HH', d, mats)
    def by_material(off):
        out = {}
        for name, e in nsbtx._dict(d, mats + off):
            o, n = struct.unpack_from('<HB', e, 0)
            for i in range(n): out[d[mats + o + i]] = name
        return out
    texs, pals = by_material(tex_d), by_material(pal_d)
    out = []
    for i, at in enumerate(model.mat_at):
        _, _, diffamb, specemi, poly, _, teximg = struct.unpack_from('<HHIIIII', d, at)
        flags = struct.unpack_from('<H', d, at + 30)[0]
        out.append((texs.get(i), pals.get(i), teximg, diffamb, specemi, poly, flags))
    return out


class Scene:
    def __init__(self, W, H, eye, target, half=20.0, quantize=False, shrink=0.0, ortho=False):
        self.W, self.H = W, H
        self.quantize, self.shrink = quantize, shrink
        self.col = np.zeros((H, W, 3)); self.z = np.full((H, W), np.inf); self.pid = np.full((H, W), -1, int)
        f = np.array(target, float) - np.array(eye, float); dist = np.linalg.norm(f); f /= dist
        r = np.cross(f, (0, 1, 0)); r /= np.linalg.norm(r)
        u = np.cross(r, f)
        self.eye, self.f, self.r, self.u = np.array(eye, float), f, r, u
        self.k = (H / 2) / math.tan(math.radians(half))
        self.ortho = ortho                   # (Pearl's room camera 4: top = distance * tan(half), pokeplatinum camera.c)
        if ortho: self.k /= dist

    def project(self, P):
        q = P - self.eye
        zc = q @ self.f
        w = 1.0 if self.ortho else zc
        x = self.W / 2 + self.k * (q @ self.r) / w
        y = self.H / 2 - self.k * (q @ self.u) / w
        return np.stack([x, y, zc], 1)

    def tri(self, S, UV, C, tex, wrap, alpha_mode, pid, xlu=1.0):
        """S (3,3) screen x, y, depth; UV (3,2) texels; C (3,3) vertex colour 0-31; tex (h, w, 4)."""
        if np.any(S[:, 2] < 1): return
        x0, x1 = int(max(0, math.floor(S[:, 0].min()))), int(min(self.W - 1, math.ceil(S[:, 0].max())))
        y0, y1 = int(max(0, math.floor(S[:, 1].min()))), int(min(self.H - 1, math.ceil(S[:, 1].max())))
        if x0 > x1 or y0 > y1: return
        ys, xs = np.mgrid[y0:y1 + 1, x0:x1 + 1]
        px, py = xs + 0.5, ys + 0.5
        (ax, ay), (bx, by), (cx, cy) = S[0, :2], S[1, :2], S[2, :2]
        den = (by - cy) * (ax - cx) + (cx - bx) * (ay - cy)
        if abs(den) < 1e-9: return
        l0 = ((by - cy) * (px - cx) + (cx - bx) * (py - cy)) / den
        l1 = ((cy - ay) * (px - cx) + (ax - cx) * (py - cy)) / den
        l2 = 1 - l0 - l1
        inside = (l0 >= 0) & (l1 >= 0) & (l2 >= 0)
        if not inside.any(): return
        w = np.ones(3) if self.ortho else 1 / S[:, 2]      # perspective-correct interpolation (ortho: linear)
        iw = l0 * w[0] + l1 * w[1] + l2 * w[2]
        b0, b1, b2 = l0 * w[0] / iw, l1 * w[1] / iw, l2 * w[2] / iw
        depth = (l0 * S[0, 2] + l1 * S[1, 2] + l2 * S[2, 2]) if self.ortho else 1 / iw
        if self.quantize:                                    # Black 2 camera 0: Z-buffer, near 1, far 1024, z/w to
            n_, f_ = 1.0, 1024.0                             # 1/16384 (GBATEK: (z * 0x4000 / w + 0x3fff) * 0x200)
            depth = np.floor(((f_ + n_) / (f_ - n_) - 2 * f_ * n_ / ((f_ - n_) * depth)) * 16384)
        zbuf = self.z[y0:y1 + 1, x0:x1 + 1]
        ok = inside & (depth < zbuf - (0 if self.quantize else 1e-4))
        if not ok.any(): return
        u = b0 * UV[0, 0] + b1 * UV[1, 0] + b2 * UV[2, 0]
        v = b0 * UV[0, 1] + b1 * UV[1, 1] + b2 * UV[2, 1]
        if tex is not None:
            th, tw = tex.shape[:2]
            def wrapc(c, n, rep, flip):
                i = np.floor(c).astype(int)
                if not rep: return np.clip(i, 0, n - 1)
                if flip:
                    k = np.floor_divide(i, n); i = np.mod(i, n)
                    return np.where(k % 2 == 1, n - 1 - i, i)
                return np.mod(i, n)
            iu = wrapc(u, tw, wrap[0], wrap[2]); iv = wrapc(v, th, wrap[1], wrap[3])
            t = tex[iv, iu].astype(float)
            ok &= t[..., 3] >= 128 if alpha_mode else ok
            tc = np.floor(t[..., :3] / 8)
        else:
            tc = np.full(u.shape + (3,), 31.0)
        vc = b0[..., None] * C[0] + b1[..., None] * C[1] + b2[..., None] * C[2]
        out = ((tc + 1) * (vc + 1) - 1) / 32
        region = self.col[y0:y1 + 1, x0:x1 + 1]
        if xlu < 1:
            region[ok] = region[ok] * (1 - xlu) + out[ok] * xlu
        else:
            region[ok] = out[ok]
            zbuf[ok] = depth[ok]
            self.pid[y0:y1 + 1, x0:x1 + 1][ok] = pid

    def image(self, edges=None, bg=(0, 0, 0)):
        from PIL import Image
        col = self.col.copy()
        empty = ~np.isfinite(self.z)
        col[empty] = np.array(bg, float)          # (5-bit colour)
        if edges is not None:                                # edge marking: ID changes against a farther pixel
            pid, z = self.pid, self.z
            mark = np.zeros(pid.shape, bool)
            for dy, dx in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                p2 = np.roll(np.roll(pid, dy, 0), dx, 1); z2 = np.roll(np.roll(z, dy, 0), dx, 1)
                mark |= (pid >= 0) & (p2 != pid) & ((z2 > z) | (p2 < 0))
            ec = np.array([_rgb(edges[max(0, p) >> 3]) for p in range(64)])
            col[mark] = ec[np.clip(pid[mark], 0, 63)]
        return Image.fromarray(np.clip(col * 255 / 31, 0, 255).astype(np.uint8))


def light_colour(mat_info, normal, setup):
    """Vertex colour of a lit vertex (0-31 per channel), DS formula without specular highlights."""
    _, _, _, diffamb, specemi, poly, flags = mat_info
    if setup['own'] or not flags & 0x40: dif = _rgb(diffamb & 0x7FFF)
    else: dif = np.array(setup['mat'][0], float)
    amb = _rgb((diffamb >> 16) & 0x7FFF) if setup['own'] or not flags & 0x80 else np.array(setup['mat'][1], float)
    emi = _rgb((specemi >> 16) & 0x7FFF) if setup['own'] or not flags & 0x400 else np.array(setup['mat'][3], float)
    out = emi.copy()
    for i, L in enumerate(setup['lights']):
        if not (poly >> i) & 1 or L is None: continue
        col, d = np.array(L[0], float), np.array(L[1], float)
        d = d / max(np.linalg.norm(d), 1)
        out += dif * col / 31 * max(0.0, float(-(d @ normal))) + amb * col / 31
    return np.clip(out, 0, 31)


def draw_model(scene, model, tex, offset=(0, 0, 0), setup=None, reverse=False):
    info = bindings(model)
    ps = model.pos_scale / 4096
    order = sorted(range(len(model.shapes)), key=lambda k: ((info[model.shapes[k].material][5] >> 16) & 31) < 31)
    if reverse:
        order = sorted(order[::-1], key=lambda k: ((info[model.shapes[k].material][5] >> 16) & 31) < 31)
    sources = pearl_mesh.colour_sources(model)      # (the GX colours a corner by its last COLOR or NORMAL command)
    shape_off = getattr(model, 'shape_offsets', None)   # (node translations, when a caller set them: room_look_check)
    for k in order:
        s = model.shapes[k]
        if s.material is None: continue
        off_k = np.array(offset, float) + (np.array(shape_off[k], float) if shape_off else 0)
        tname, pname, teximg, diffamb, specemi, poly, flags = info[s.material]
        alpha = (poly >> 16) & 31
        if alpha == 0: continue
        img = tex.get((tname, pname)) if tname else None
        wrap = ((teximg >> 16) & 1, (teximg >> 17) & 1, (teximg >> 18) & 1, (teximg >> 19) & 1)
        src = sources[k]
        for j, p in (reversed(list(enumerate(s.polys))) if reverse else enumerate(s.polys)):
            P = np.array([v.pos for v in p], float) * ps + off_k
            UV = np.array([(v[3] / 16, v[4] / 16) for v in p])
            if poly & 15 and p[0][5] is not None and 'C' in src[j] and p[0][6] is not None:
                C = np.array([_rgb(v[6]) if c == 'C' else light_colour(info[s.material],
                              np.array(pearl_mesh.normal_vec(v[5])), setup) for v, c in zip(p, src[j])])
            elif poly & 15 and p[0][5] is not None:
                C = np.array([light_colour(info[s.material], np.array(pearl_mesh.normal_vec(v[5])), setup) for v in p])
            elif p[0][6] is not None:
                C = np.array([_rgb(v[6]) for v in p])
            else:
                C = np.array([_rgb(diffamb & 0x7FFF)] * len(p)) if (setup is None or setup['own'] or not flags & 0x40) \
                    else np.array([setup['mat'][0]] * len(p), float)
            S = scene.project(P)
            if scene.shrink:                                 # (a stand-in for the DS's cracks: see --cracks; the DS
                ctr = S[:, :2].mean(0)                       # draws a quad as one polygon, so whole polygons shrink)
                d = S[:, :2] - ctr
                L = np.maximum(np.linalg.norm(d, axis=1, keepdims=True), 1e-6)
                S = S.copy(); S[:, :2] = ctr + d * np.maximum(0, 1 - scene.shrink / L)
            for a, b, c in ((0, 1, 2), (0, 2, 3)) if len(p) == 4 else ((0, 1, 2),):
                scene.tri(S[[a, b, c]], UV[[a, b, c]], C[[a, b, c]], img, wrap, True, (poly >> 24) & 63,
                          alpha / 31)


def chunk_model(chunk, fixed=False):
    land = os.path.join(ROOT, 'work', 'pearl', 'land')
    bmd = open(os.path.join(land, f'{chunk:03d}.nsbmd'), 'rb').read()
    if fixed:
        import pearl_chunk, pearl_seams_check
        world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
        m, x, z = pearl_seams_check.cells_of(world)[chunk]
        bmd = pearl_chunk.fix_model(chunk, bmd, pearl_chunk.neighbours(m, x, z))[0]
    return pearl_mesh.Model(bmd)


def render(chunk, texset, at=None, light='pearl_indoor', edges='pearl_indoor', scale=1, extra_props=True,
           fixed=False, flicker=False, cracks=0.0, bg=(0, 0, 0), texbytes=None):
    from gen4rom import Rom, narc_members
    import pearl_buildings
    land = os.path.join(ROOT, 'work', 'pearl', 'land')
    model = chunk_model(chunk, fixed)
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    sets = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))
    tex = textures(texbytes if texbytes is not None else sets[texset])     # (texbytes: a built set, a/0/1/4)
    tx, tz = at or (16, 16)
    x, z = tx * 16 - 248, tz * 16 - 248
    P = np.array([v.pos for s in model.shapes for p in s.polys for v in p], float) * model.pos_scale / 4096
    near = P[(np.abs(P[:, 0] - x) < 24) & (np.abs(P[:, 2] - z) < 24)]
    y = float(np.median(near[:, 1])) if len(near) else 0.0
    pitch = math.radians(53.2)
    eye = (x, y + 237 * math.sin(pitch), z + 237 * math.cos(pitch))
    setup = LIGHTS[light]
    build = narc_members(rom.read('fielddata/build_model/build_model.narc')) if extra_props else None
    props = json.load(open(os.path.join(land, f'{chunk:03d}.json')))['props'] if extra_props else []
    def scene(reverse):
        sc = Scene(256 * scale, 192 * scale, eye, (x, y, z), quantize=flicker, shrink=cracks * scale)
        draw_model(sc, model, tex, setup=setup, reverse=reverse)
        for pr in props:
            b = build[pr['model']]
            try:
                pm = pearl_mesh.Model(pearl_buildings.mdl_only(b))
                ptex = textures(pearl_buildings.btx0_of(b))
            except Exception:
                continue
            draw_model(sc, pm, ptex, offset=pr['pos'], setup=setup, reverse=reverse)
        return sc
    a = scene(False)
    im = a.image(EDGES.get(edges), bg)
    if flicker:
        b = scene(True)
        diff = np.any(np.abs(a.col - b.col) > 0.5, axis=2)
        arr = np.array(im)
        arr[diff] = (255, 0, 255)
        from PIL import Image
        im = Image.fromarray(arr)
        im.info['flicker_pixels'] = int(diff.sum())
    return im


if __name__ == '__main__':
    a = sys.argv[1:]
    opt = {a[i]: a[i + 1] for i in range(len(a)) if a[i].startswith('--') and i + 1 < len(a)}
    pos = [x for i, x in enumerate(a) if not x.startswith('--') and not (i and a[i - 1].startswith('--'))]
    at = tuple(map(int, opt['--at'].split(','))) if '--at' in opt else None
    im = render(int(pos[0]), int(pos[1]), at, opt.get('--light', 'pearl_indoor'), opt.get('--edges', 'pearl_indoor'),
                int(opt.get('--scale', 1)), opt.get('--props', '1') == '1', opt.get('--fixed') == '1',
                opt.get('--flicker') == '1', float(opt.get('--cracks', 0)),
                tuple(map(int, opt['--bg'].split(','))) if '--bg' in opt else (0, 0, 0))
    im.save(pos[2])
    print(pos[2], im.info.get('flicker_pixels', ''))
