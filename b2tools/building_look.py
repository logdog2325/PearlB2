"""Pearl's buildings as Pearl lights them, and as Black 2 draws them (2026-10-20; user: "the pokemon centers shouldnt
look like this have there colors match perals there shouldnt be black lines on top and the pokeball shouldnt be black
the gyms and pokemarts also look like this", a melonDS shot of Sandgem's Center).

    python3 b2tools/building_look.py check [FILES]      every overworld building pack of a build (default the
                                                       lead's work/rom_lead/files): materials the DS draws black, and
                                                       materials not on their own colours
    python3 b2tools/building_look.py render OUT.png MODEL [MODEL ...]   Pearl / before / now, side by side

The DS lighting (GBATEK "DS 3D Polygon Light Parameters"; melonDS does the same): at every NORMAL command a vertex's
colour becomes EMISSION + for each light the polygon enables: specular x light x shininess + diffuse x light x
max(0, -L.N) + ambient x light. With no light enabled that is the emission alone, whatever the material's diffuse
"vertex colour" says. So an unlit material whose shapes carry normals draws its emission: black when it is 0.
- Pearl: building props keep their own material colours (pokeplatinum map_prop.c, NNS_G3dRenderObjInit; only the land
  models lose theirs, pokediamond ov05_021DB5EC) under data/area00light.txt: light 0 the sun, light 2 a dim/night
  glow, light 3 a constant white (31,31,31). The Centers', Marts' and Gyms' signs and the Center's glass door are lit
  by light 3 only, at their own ambient (31 for the Center's sign: full colour).
- Black 2 before 2026-10-20 (maplook 'lamps' and 'material'): those light-3 materials unlit with emission 0 (black on
  melonDS and hardware: the user's black Poke Ball and roof bands; DeSmuME keeps the diffuse, see the in-game shots),
  every lit building material on the field light's colours (walls bluer: (24,25,24) instead of Pearl's (19,19,16)).
- Now: own colours; the light-3 materials unlit with their own ambient as emission (Black 2's own Center does this:
  pc_01's sign material has emission (31,31,31)).
"""
import json, math, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)

# Pearl data/area00light.txt at midday (27000) and Black 2's table 140 at midday: [(colour, direction)], material
# colours (diffuse, ambient, specular, emission) used when a material's flags are cleared
PEARL_NOON = dict(lights=[((24, 24, 20), (-2043, -3548, 110)), None, ((2, 2, 13), (0, 0, 4096)),
                          ((31, 31, 31), (0, 0, 4096))],
                  mats=((16, 16, 16), (10, 12, 12), (18, 18, 18), (14, 14, 14)))
B2_NOON = dict(lights=[((24, 22, 20), (-1914, -3584, -296)), ((6, 7, 8), (0, 0, 4096)), ((16, 24, 30), (0, 4096, 0)),
                       ((6, 5, 4), (0, 0, 4096))],
               mats=((16, 16, 16), (10, 12, 12), (18, 18, 18), (14, 14, 14)))
PEARL_CAM = dict(dist=667.0, pitch=59.0, half=8.09)
B2_CAM = dict(dist=237.0, pitch=53.2, half=20.0)
FLAGS = (0x0040, 0x0080, 0x0200, 0x0400)    # own DIFFUSE, AMBIENT, SPECULAR, EMISSION


def _c(x):
    import numpy as np
    return np.array([x & 31, (x >> 5) & 31, (x >> 10) & 31], float)


def vertex_colour(mat, normal, setup, view):
    """The GX's vertex colour (0-31 per channel) at a NORMAL command (normal in world space; view: world->view)."""
    import numpy as np
    _, _, _, diffamb, specemi, poly, flags = mat
    own = [_c(diffamb & 0x7FFF), _c((diffamb >> 16) & 0x7FFF), _c(specemi & 0x7FFF), _c((specemi >> 16) & 0x7FFF)]
    dif, amb, spe, emi = [own[i] if flags & FLAGS[i] else np.array(setup['mats'][i], float) for i in range(4)]
    n = view @ np.asarray(normal, float)
    out = emi.copy()
    for i, L in enumerate(setup['lights']):
        if not (poly >> i) & 1 or L is None: continue
        col = np.array(L[0], float)
        d = view @ (np.array(L[1], float) / 4096); d /= max(np.linalg.norm(d), 1e-9)
        h = (d + np.array([0, 0, -1.0])) / 2
        out += spe * col / 31 * max(0.0, float(-h @ n)) ** 2 + dif * col / 31 * max(0.0, float(-d @ n)) \
            + amb * col / 31
    return np.clip(out, 0, 31)


def view_matrix(pitch):
    import numpy as np
    p = math.radians(pitch)
    f = np.array([0, -math.sin(p), -math.cos(p)])
    u = np.array([0, math.cos(p), -math.sin(p)])
    return np.array([[1, 0, 0], u, -f])


def draw(scene, model, tex, setup, view, offset=(0, 0, 0)):
    """pearl_render.draw_model with the GX's lighting (vertex_colour) for every vertex that has a normal."""
    import numpy as np, pearl_mesh, pearl_render as R
    info = R.bindings(model)
    ps = model.pos_scale / 4096
    order = sorted(range(len(model.shapes)), key=lambda k: ((info[model.shapes[k].material][5] >> 16) & 31) < 31)
    for k in order:
        s = model.shapes[k]
        if s.material is None: continue
        mat = info[s.material]
        tname, pname, teximg, diffamb, specemi, poly, flags = mat
        alpha = (poly >> 16) & 31
        if alpha == 0: continue
        img = tex.get((tname, pname)) if tname else None
        wrap = ((teximg >> 16) & 1, (teximg >> 17) & 1, (teximg >> 18) & 1, (teximg >> 19) & 1)
        for p in s.polys:
            P = np.array([v.pos for v in p], float) * ps + np.array(offset, float)
            UV = np.array([(v[3] / 16, v[4] / 16) for v in p])
            C = []
            for v in p:
                if v[5] is not None: C.append(vertex_colour(mat, pearl_mesh.normal_vec(v[5]), setup, view))
                elif v[6] is not None: C.append(R._rgb(v[6]))
                else: C.append(_c(diffamb & 0x7FFF))
            C = np.array(C)
            S = scene.project(P)
            for a, b, c in ((0, 1, 2), (0, 2, 3)) if len(p) == 4 else ((0, 1, 2),):
                scene.tri(S[[a, b, c]], UV[[a, b, c]], C[[a, b, c]], img, wrap, True, (poly >> 24) & 63, alpha / 31)


def render_model(bmd, tex, setup, cam, size=(256, 192)):
    """One building model (MDL0 BMD0) seen from the south as camera `cam` sees it, filling about half the screen."""
    import numpy as np, pearl_mesh, pearl_render as R
    m = pearl_mesh.Model(bmd)
    P = np.array([v.pos for s in m.shapes for p in s.polys for v in p], float) * m.pos_scale / 4096
    lo, hi = P.min(0), P.max(0)
    target = ((lo[0] + hi[0]) / 2, (lo[1] + hi[1]) / 3, (lo[2] + hi[2]) / 2)
    span = max(hi[0] - lo[0], hi[1] - lo[1]) * 1.5
    dist = span / 2 / math.tan(math.radians(cam['half'])) * 1.0
    p = math.radians(cam['pitch'])
    eye = (target[0], target[1] + dist * math.sin(p), target[2] + dist * math.cos(p))
    sc = R.Scene(size[0], size[1], eye, target, half=cam['half'])
    draw(sc, m, tex, setup, view_matrix(cam['pitch']))
    return sc.image(R.EDGES['pearl_indoor'][:1] * 8 if False else [0x1084] * 8, (16 * 8, 24 * 8, 30 * 8))


def render(out, models):
    """Pearl / before / now for each Pearl build model id (rows)."""
    from PIL import Image
    from gen4rom import Rom, narc_members
    import pearl_buildings, pearl_render as R, maplook
    build = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read('fielddata/build_model/build_model.narc'))
    rows = []
    for mid in models:
        b = pearl_buildings.mdl_only(build[mid])
        tex = R.textures(pearl_buildings.btx0_of(build[mid]))
        old, _ = maplook.relight_model(b, True, True, props=False)
        old = _lamps_before(old, b)
        new, _ = maplook.relight_model(b, True, True, props=True)
        rows.append([render_model(b, tex, PEARL_NOON, PEARL_CAM), render_model(old, tex, B2_NOON, B2_CAM),
                     render_model(new, tex, B2_NOON, B2_CAM)])
    W, H = rows[0][0].size
    sheet = Image.new('RGB', (3 * W + 16, len(rows) * (H + 8) - 8), (255, 255, 255))
    for r, row in enumerate(rows):
        for c, im in enumerate(row):
            sheet.paste(im, (c * (W + 8), r * (H + 8)))
    sheet.save(out)
    return out


def _lamps_before(bmd, orig):
    """The 2026-10-19 'lamps' fix (unlit, diffuse 25, emission left at the model's own 0), for the 'before' column."""
    import maplook
    b = bytearray(bmd)
    for at, at0 in zip(maplook._materials(bytes(b)), maplook._materials(orig)):
        poly0 = struct.unpack_from('<I', orig, at0 + 12)[0]
        if poly0 & 15 == 8:
            struct.pack_into('<I', b, at + 8, struct.unpack_from('<I', orig, at0 + 8)[0])
            struct.pack_into('<H', b, at + 30, struct.unpack_from('<H', orig, at0 + 30)[0])
    return bytes(b)


def has_normals(bmd):
    """{material index: True} for materials whose shapes carry NORMAL commands."""
    import pearl_mesh
    m = pearl_mesh.Model(bmd)
    out = {}
    for s in m.shapes:
        if s.material is not None and any(v[5] is not None for p in s.polys for v in p): out[s.material] = True
    return out


def check(files):
    """Overworld building packs of a build: materials drawn black (no light, normals, emission darker than 8) and
    lit materials not on their own colours (flags cleared)."""
    import narcio, maplook, pearl_mesh
    from b2files import gf_container
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    packs = narcio.load(files, 225)
    black, global_, n = [], 0, 0
    for a in world['areas'].values():
        magic, secs = gf_container(packs[a['b2_pack']])
        k = len(secs) // 2
        for i, sec in enumerate(secs[k:]):
            if sec[:4] != b'BMD0': continue
            res = struct.unpack_from('<H', secs[i], 0)[0]
            try: nrm = has_normals(sec); m = pearl_mesh.Model(sec)
            except Exception: continue                          # (Black 2's own models, e.g. the signs)
            for j, at in enumerate(maplook._materials(sec)):
                n += 1
                diffamb, specemi, poly = struct.unpack_from('<III', sec, at + 4)
                flags = struct.unpack_from('<H', sec, at + 30)[0]
                emi = _c((specemi >> 16) & 0x7FFF) if flags & 0x400 else None
                if not poly & 15 and nrm.get(j) and emi is not None and emi.max() < 8:
                    black.append(f"pack {a['b2_pack']} res {res} {m.materials[j]}")
                if poly & 15 and (flags & 0x6C0) != 0x6C0: global_ += 1
    print(f'{n} building materials in {len(world["areas"])} overworld packs')
    print(f'drawn black on hardware (no light enabled, normals, emission < 8): {len(black)}')
    for x in black[:40]: print('  ', x)
    print(f'lit materials on the field\'s colours instead of their own (flags cleared): {global_}')
    return len(black) + global_


if __name__ == '__main__':
    a = sys.argv[1:]
    if a and a[0] == 'check':
        sys.exit(1 if check(a[1] if len(a) > 1 else os.path.join(ROOT, 'work', 'rom_lead', 'files')) else 0)
    elif a and a[0] == 'render':
        print(render(a[1], [int(x) for x in a[2:]]))
    else:
        print(__doc__)
