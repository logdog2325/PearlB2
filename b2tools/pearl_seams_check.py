"""Cracks and flicker in Sinnoh's converted map chunks (the world pass, 2026-10-20; HoennB2's tjunction.py,
water_seams_check.py, exterior_layers.py / exterior_check.py layer_pairs ported to Pearl's map models).

    python3 pearl_seams_check.py [--fixed] [--rooms|--world] [--json=OUT] [CHUNK ...]   per chunk, totals

The models are Pearl's own (work/pearl/land/NNN.nsbmd, b2tools/pearl_mesh.py), drawn by Black 2: with --fixed they
go through pearl_chunk.fix_model first (what the build installs). Measured, per chunk (Pearl chunk ids):
- tj      T-junctions in the ground (an opaque, upward-facing polygon's vertex inside another one's edge, within 0.05
          units), in the chunk and across its borders (the neighbours in the matrix, at their offsets). melonDS and the
          hardware open 1-pixel cracks there.
- open    length (units) of edges inside the flat ground (normal y >= 0.95; each edge counted from both sides, at
          2-unit samples), where the ground goes on at the same height on both sides,
          with nothing opaque 1-16 units under them: a crack along them shows the clear colour (sky blue by day,
          black in caves). The DS opens cracks even along shared edges (HoennB2 cracks 2026-10-18); the under-floor
          (pearl_chunk.underfloor) backs them.
- border  area (units^2) where this chunk's ground and a neighbour's overlap in one plane with different texels
          (Pearl's models overhang their chunk by 4 units: both are drawn there).
- fight   pairs of overlapping polygons facing the same way less than MIN_GAP apart along their normal, with
          different texels (Black 2's field camera 0: Z-buffer, near 1: one depth step is ~1.7 units at the player,
          ~3.7 at the top of the screen; HoennB2's rule: 2 units), by material pair.
- size    the chunk's bytes as sinnoh_world/sinnoh_rooms write it (model + 8,196 terrain + placements + 20), against
          Black 2's 110,600-byte chunk buffer.
"""
import json, math, os, sys, collections

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import pearl_mesh  # noqa: E402

LAND = os.path.join(ROOT, 'work', 'pearl', 'land')
MIN_GAP = 2.0
EPS = 0.05
CHUNK_LIMIT = 110600
TREES = ('tree', 'conttree', 'g1_tree', 'plant')


def base(name):
    return name.split('_lm')[0]


def is_tree(name):
    return any(t in name for t in TREES)


class Poly:
    __slots__ = ('mat', 'alpha', 'pid', 'P', 'UV', 'n', 'd', 'shape', 'index')


def load(model):
    """[Poly] of a pearl_mesh.Model in map units."""
    out = []
    ps = model.pos_scale / 4096
    for si, s in enumerate(model.shapes):
        if s.material is None: continue
        pa = model.poly_attr(s.material)
        name = model.materials[s.material]
        for k, p in enumerate(s.polys):
            P = np.array([v.pos for v in p], float) * ps
            n = np.cross(P[1] - P[0], P[2] - P[0])
            if len(P) == 4: n = n + np.cross(P[2] - P[0], P[3] - P[0])
            L = np.linalg.norm(n)
            if L < 1e-9: continue
            q = Poly()
            q.mat, q.alpha, q.pid = name, (pa >> 16) & 31, (pa >> 24) & 63
            q.P, q.UV, q.n = P, np.array([(v[3] / 16, v[4] / 16) for v in p], float), n / L
            q.d = float(q.n @ P.mean(0)); q.shape = si; q.index = k
            out.append(q)
    return out


def ground(polys):
    return [q for q in polys if q.alpha == 31 and q.n[1] > 0.7 and not is_tree(q.mat)]


def top_ground(g, drop=4.0):
    """(ground, under-floor): ground polygons with ground `drop` units above their centre are the under-floor
    (pearl_model_fix.underfloor), counted as backing only."""
    T, C = tris_xz(g); G = Grid(T, C)
    ctr = np.array([q.P.mean(0) for q in g]) if g else np.zeros((0, 3))
    hs = G.heights(ctr[:, [0, 2]]) if len(ctr) else []
    top, under = [], []
    for q, c, h in zip(g, ctr, hs):
        (under if np.any(np.abs(h - (c[1] + drop)) < 0.3) else top).append(q)
    return top, under


def tris_xz(polys):
    """(T (K,3,2) x/z corners, plane (K,3): y = a x + b z + c) of polys' triangles."""
    T, Y = [], []
    for q in polys:
        for a, b, c in ((0, 1, 2), (0, 2, 3)) if len(q.P) == 4 else ((0, 1, 2),):
            T.append(q.P[[a, b, c]][:, [0, 2]]); Y.append(q.P[[a, b, c]])
    if not T: return np.zeros((0, 3, 2)), np.zeros((0, 3))
    T = np.array(T); Y = np.array(Y)
    # plane through the three corners
    A = np.concatenate([T, np.ones((len(T), 3, 1))], axis=2)
    det = np.linalg.det(A)
    ok = np.abs(det) > 1e-9
    coef = np.zeros((len(T), 3))
    coef[ok] = np.linalg.solve(A[ok], Y[ok][:, :, 1][..., None])[..., 0]
    return T[ok], coef[ok]


class Grid:
    """Triangles bucketed by 16-unit x/z cells, for point queries."""
    def __init__(self, T, coef, cell=16.0):
        self.T, self.coef, self.cell = T, coef, cell
        self.b = collections.defaultdict(list)
        if not len(T): return
        lo = np.floor(T.min(1) / cell).astype(int); hi = np.floor(T.max(1) / cell).astype(int)
        for i in range(len(T)):
            for gx in range(lo[i, 0], hi[i, 0] + 1):
                for gz in range(lo[i, 1], hi[i, 1] + 1):
                    self.b[(gx, gz)].append(i)

    def heights(self, pts, margin=1e-3):
        """For points (M,2): list of arrays of the heights of the triangles that hold each point."""
        out = [None] * len(pts)
        keys = np.floor(pts / self.cell).astype(int)
        groups = collections.defaultdict(list)
        for i, k in enumerate(map(tuple, keys)): groups[k].append(i)
        for k, idx in groups.items():
            cand = self.b.get(k)
            if not cand:
                for i in idx: out[i] = np.zeros(0)
                continue
            T = self.T[cand]; C = self.coef[cand]
            Q = pts[idx]
            inside = np.ones((len(idx), len(cand)), bool)
            area = (T[:, 1, 0] - T[:, 0, 0]) * (T[:, 2, 1] - T[:, 0, 1]) - (T[:, 1, 1] - T[:, 0, 1]) * (T[:, 2, 0] - T[:, 0, 0])
            sgn = np.sign(area)
            for e in range(3):
                a, b = T[:, e], T[:, (e + 1) % 3]
                L = np.maximum(np.hypot(b[:, 0] - a[:, 0], b[:, 1] - a[:, 1]), 1e-9)
                cr = ((b[:, 0] - a[:, 0])[None] * (Q[:, None, 1] - a[None, :, 1])
                      - (b[:, 1] - a[:, 1])[None] * (Q[:, None, 0] - a[None, :, 0])) * sgn[None] / L[None]
                inside &= cr >= -margin
            Y = C[:, 0][None] * Q[:, None, 0] + C[:, 1][None] * Q[:, None, 1] + C[:, 2][None]
            for r, i in enumerate(idx):
                out[i] = Y[r][inside[r]]
        return out


def t_junctions(gpolys, others=()):
    """[(polygon, edge, point)]: vertices of gpolys + others lying strictly inside an edge of a gpolys polygon."""
    pts = {}
    for q in list(gpolys) + list(others):
        for p in q.P: pts[tuple(np.round(p, 3))] = p
    P = np.array(list(pts.values())) if pts else np.zeros((0, 3))
    grid = collections.defaultdict(list)
    for i, p in enumerate(P): grid[(int(p[0] // 16), int(p[2] // 16))].append(i)
    out = []
    for q in gpolys:
        k = len(q.P)
        for e in range(k):
            a, b = q.P[e], q.P[(e + 1) % k]
            d = b - a; L2 = float(d @ d)
            if L2 < 1e-6: continue
            x0, x1 = sorted((a[0], b[0])); z0, z1 = sorted((a[2], b[2]))
            cand = [i for gx in range(int((x0 - EPS) // 16), int((x1 + EPS) // 16) + 1)
                    for gz in range(int((z0 - EPS) // 16), int((z1 + EPS) // 16) + 1) for i in grid.get((gx, gz), ())]
            if not cand: continue
            C = P[cand]
            s = ((C - a) @ d) / L2
            close = np.linalg.norm(a + s[:, None] * d[None] - C, axis=1) < EPS
            hit = close & (s > 1e-4) & (s < 1 - 1e-4)
            for j in np.nonzero(hit)[0]: out.append((q, e, C[j]))
    return out


def open_edges(gpolys, backing, step=2.0):
    """(length of edges inside the ground, length of those with nothing opaque 1-16 units under them)."""
    T, C = tris_xz(gpolys); G = Grid(T, C)
    bT, bC = tris_xz(backing); B = Grid(bT, bC)
    samples, ys = [], []
    for q in gpolys:
        k = len(q.P)
        for e in range(k):
            a, b = q.P[e], q.P[(e + 1) % k]
            L = math.hypot(b[0] - a[0], b[2] - a[2])
            if L < 1e-3: continue
            n = max(1, int(L // step))
            for j in range(n):
                f = (j + 0.5) / n
                p = a + f * (b - a)
                dx, dz = (b[2] - a[2]) / L * 0.3, -(b[0] - a[0]) / L * 0.3
                samples.append((p[0], p[2], dx, dz, L / n)); ys.append(p[1])
    if not samples: return 0.0, 0.0
    S = np.array(samples); Y = np.array(ys)
    left = G.heights(S[:, :2] + S[:, 2:4]); right = G.heights(S[:, :2] - S[:, 2:4])
    under = B.heights(S[:, :2])
    inner = unbacked = 0.0
    for i in range(len(S)):
        if not (np.any(np.abs(left[i] - Y[i]) < 0.5) and np.any(np.abs(right[i] - Y[i]) < 0.5)): continue
        inner += S[i, 4]
        h = under[i]
        if not np.any((h < Y[i] - 1.0) & (h > Y[i] - 16)): unbacked += S[i, 4]
    return inner, unbacked


def _basis(n):
    u = np.cross(n, (0, 1, 0)) if abs(n[1]) < 0.9 else np.cross(n, (1, 0, 0))
    u = u / np.linalg.norm(u)
    return u, np.cross(n, u)


def _clip(poly, clipper):
    """Convex 2D polygon poly clipped by convex polygon clipper (both counter-clockwise)."""
    out = poly
    for i in range(len(clipper)):
        a, b = clipper[i], clipper[(i + 1) % len(clipper)]
        inp, out = out, []
        if not inp: break
        for j in range(len(inp)):
            p, q = inp[j], inp[(j + 1) % len(inp)]
            sp = (b[0] - a[0]) * (p[1] - a[1]) - (b[1] - a[1]) * (p[0] - a[0])
            sq = (b[0] - a[0]) * (q[1] - a[1]) - (b[1] - a[1]) * (q[0] - a[0])
            if sp >= 0: out.append(p)
            if (sp >= 0) != (sq >= 0):
                t = sp / (sp - sq); out.append((p[0] + t * (q[0] - p[0]), p[1] + t * (q[1] - p[1])))
    return out


def _ccw(pts):
    a = sum(pts[i][0] * pts[i - 1][1] - pts[i - 1][0] * pts[i][1] for i in range(len(pts)))
    return pts if a <= 0 else pts[::-1]


def _area(poly):
    return abs(sum(poly[i][0] * poly[i - 1][1] - poly[i - 1][0] * poly[i][1] for i in range(len(poly)))) / 2


def _uv_at(q, pt):
    """Texture coordinate of polygon q at 3D point pt (affine over its first triangle; quads are planar here)."""
    P = q.P; e1, e2 = P[1] - P[0], P[2] - P[0]
    M = np.array([[e1 @ e1, e1 @ e2], [e1 @ e2, e2 @ e2]])
    r = pt - P[0]
    try: s, t = np.linalg.solve(M, [r @ e1, r @ e2])
    except np.linalg.LinAlgError: return q.UV[0]
    return q.UV[0] + s * (q.UV[1] - q.UV[0]) + t * (q.UV[2] - q.UV[0])


def same_texels(a, b, pts):
    """Polygons a and b draw the same texels at pts (same material, texture coordinates equal or 16 texels apart)."""
    if base(a.mat) != base(b.mat): return False
    for p in pts:
        d = _uv_at(a, p) - _uv_at(b, p)
        if np.any(np.abs(d - 16 * np.round(d / 16)) > 0.6): return False
    return True


def layer_pairs(polys, others=(), min_gap=MIN_GAP, max_gap=None, points=False):
    """[(a, b, gap, area)]: overlapping polygons facing the same way, b behind a by gap < min_gap along a's normal
    (others: polygons that only count as the other member, e.g. a neighbour's). Same texels never fight. points: each
    pair also carries its overlap's corners [(point on a's plane, b's gap there)]."""
    allp = list(polys) + list(others)
    own = len(polys)
    buckets = collections.defaultdict(list)
    for i, q in enumerate(allp):
        ax = int(np.argmax(np.abs(q.n)))
        o = [k for k in range(3) if k != ax]
        lo = np.floor(q.P[:, o].min(0) / 32).astype(int); hi = np.floor(q.P[:, o].max(0) / 32).astype(int)
        for g0 in range(lo[0], hi[0] + 1):
            for g1 in range(lo[1], hi[1] + 1):
                buckets[(ax, g0, g1)].append(i)
    seen, out = set(), []
    for idx in buckets.values():
        for x in range(len(idx)):
            i = idx[x]
            for y in range(x + 1, len(idx)):
                j = idx[y]
                if (i, j) in seen or (i >= own and j >= own): continue
                seen.add((i, j))
                a, b = allp[i], allp[j]
                nn = float(a.n @ b.n)
                if nn < 0.98: continue
                if abs(a.d - b.d) > min_gap + 64: continue
                u, v = _basis(a.n)
                pa = _ccw([(float(p @ u), float(p @ v)) for p in a.P])
                pb = _ccw([(float(p @ u), float(p @ v)) for p in b.P])
                ov = _clip(pa, pb)
                if len(ov) < 3 or _area(ov) < 0.5: continue
                pts3 = [a.d * a.n + s * u + t * v for s, t in ov]
                gaps = [(b.d - float(b.n @ q)) / nn for q in pts3]     # from a's plane to b's, along a's normal
                g = min(gaps, key=abs) if max(gaps) * min(gaps) > 0 else 0.0
                if abs(g) >= min_gap: continue
                if same_texels(a, b, pts3): continue
                if g > 0: a, b = b, a                                    # b behind a
                out.append((a, b, abs(g), _area(ov)) + ((list(zip(pts3, gaps)),) if points else ()))
    return out


# ---------------------------------------------------------------------------------------- depth precision (--depth)
# (the polish pass, 2026-10-20; user, melonDS: "some trees still flicker slightly") Two layers fight when the DS
# stores them in one depth step: camera 0's Z-buffer keeps z/w to 1/16384 (near 1, far 1024: one step is w^2 / 32800
# units of view depth w), and a layer pair g units apart along its normal is g (r.f) / |r.n| apart in w along a pixel's
# ray r (f: the view axis). Every place can come to every screen row as the camera follows the player, so a pair is
# measured at the rows of the screen's top, middle and bottom (rays 33.2, 43.2, 53.2, 63.2, 73.2 degrees down; the
# eye 189.73 over the ground the camera's target stands on, here the highest ground under the point): ratio = that w
# gap / one step, the smallest over the rows and the overlap's corners. Under 1 the two can round to one depth value
# and the picture depends on the draw order (flicker as the camera moves); DESIRED 1.25 leaves room for the DS's
# per-vertex depth rounding.
EYE_H, PITCH = 189.73, 53.2
ROWS = (33.2, 43.2, 53.2, 63.2, 73.2)
DEPTH_RATIO = 1.0


def depth_ratio(p, n, g, y0):
    """Smallest (w gap / depth step) over the screen rows for a layer pair g apart along unit normal n at point p
    (y0: the ground under the camera's target)."""
    f = np.array([0.0, -math.sin(math.radians(PITCH)), -math.cos(math.radians(PITCH))])
    best = math.inf
    for phi in ROWS:
        r = np.array([0.0, -math.sin(math.radians(phi)), -math.cos(math.radians(phi))])
        L = (EYE_H - (p[1] - y0)) / math.sin(math.radians(phi))
        if L <= 1: continue
        w = L * float(r @ f)
        rn = abs(float(r @ n))
        if rn < 1e-3: continue
        best = min(best, abs(g) * float(r @ f) / rn / (w * w / 32800.0))
    return best


def depth_pairs(chunk, cell, fixed=True, cache=None):
    """Layer pairs of a chunk (with its neighbours) under 8 units apart, each with its depth ratio (depth_ratio):
    [(a, b, gap, area, ratio, tree)]."""
    import pearl_chunk
    cache = {} if cache is None else cache
    m, x, z = cell
    cells = cache.setdefault('cells', {})
    cells.setdefault(chunk, cell)
    def model_of(c):
        if (c, fixed) not in cache:
            bmd = open(os.path.join(LAND, f'{c:03d}.nsbmd'), 'rb').read()
            if fixed:
                mm, xx, zz = cells.get(c, cell)
                bmd, _ = pearl_chunk.fix_model(c, bmd, pearl_chunk.neighbours(mm, xx, zz))
            cache[(c, fixed)] = (len(bmd), load(pearl_mesh.Model(bmd)), {})
        return cache[(c, fixed)]
    for dz in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if 0 <= x + dx < m['width'] and 0 <= z + dz < m['height'] and m['maps'][z + dz][x + dx] != 0xffff:
                cells.setdefault(m['maps'][z + dz][x + dx], (m, x + dx, z + dz))
    polys = model_of(chunk)[1]
    near = neighbour_polys((x, z), m, lambda c: model_of(c)[1])
    gT, gC = tris_xz(ground(polys + near)); G = Grid(gT, gC)
    out = []
    for a, b, gap, area, pts in layer_pairs(polys, near, min_gap=8.0, points=True):
        P = np.array([q for q, _ in pts])
        hs = G.heights(P[:, [0, 2]])
        r = math.inf
        for (q, g), h in zip(pts, hs):
            under = h[h <= q[1] + 1.0] if len(h) else h
            y0 = float(under.max()) if len(under) else float(min(a.P[:, 1].min(), b.P[:, 1].min()))
            r = min(r, depth_ratio(q, a.n, g, y0))
        out.append((a, b, gap, area, r, is_tree(a.mat) or is_tree(b.mat)))
    return out


def neighbour_polys(chunk_matrix_cell, matrix, models):
    """Polygons of the 8 cells around (x, z) of matrix, moved to their offset (only those within 32 of the border)."""
    x, z = chunk_matrix_cell
    out = []
    for dz in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if not (dx or dz): continue
            if not (0 <= x + dx < matrix['width'] and 0 <= z + dz < matrix['height']): continue
            c = matrix['maps'][z + dz][x + dx]
            if c == 0xffff: continue
            for q in models(c):
                P = q.P + np.array([512 * dx, 0, 512 * dz])
                if np.all(np.abs(P[:, 0]) > 288) or np.all(np.abs(P[:, 2]) > 288): continue
                r = Poly()
                for f in Poly.__slots__: setattr(r, f, getattr(q, f))
                r.P = P; r.d = float(r.n @ P.mean(0))
                out.append(r)
    return out


def cells_of(world):
    """{Pearl chunk: (matrix dict, x, z)}: the overworld chunks in matrix 0, the rooms' in their first matrix."""
    out = {}
    m0 = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    for z in range(m0['height']):
        for x in range(m0['width']):
            c = m0['maps'][z][x]
            if c != 0xffff and str(c) in world['chunks']: out.setdefault(c, (m0, x, z))
    for mid in world['rooms']['matrices']:
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f'{int(mid):03d}.json')))
        for z in range(m['height']):
            for x in range(m['width']):
                c = m['maps'][z][x]
                if c != 0xffff and str(c) in world['rooms']['chunks']: out.setdefault(c, (m, x, z))
    return out


def check(chunk, cell, fixed=False, cache=None):
    import pearl_chunk
    cache = {} if cache is None else cache
    m, x, z = cell
    def model_of(c, where=None):
        if (c, fixed) not in cache:
            bmd = open(os.path.join(LAND, f'{c:03d}.nsbmd'), 'rb').read()
            rep = {}
            if fixed:
                mm, xx, zz = where or cells_of_cache[c]
                bmd, rep = pearl_chunk.fix_model(c, bmd, pearl_chunk.neighbours(mm, xx, zz))
            cache[(c, fixed)] = (len(bmd), load(pearl_mesh.Model(bmd)), rep)
        return cache[(c, fixed)]
    cells_of_cache = cache.setdefault('cells', {})
    cells_of_cache.setdefault(chunk, cell)
    # (a neighbour is fixed within its own first cell when it has one, else within this matrix)
    for dz in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if 0 <= x + dx < m['width'] and 0 <= z + dz < m['height'] and m['maps'][z + dz][x + dx] != 0xffff:
                cells_of_cache.setdefault(m['maps'][z + dz][x + dx], (m, x + dx, z + dz))
    size, polys, fixrep = model_of(chunk, cell)
    near = neighbour_polys((x, z), m, lambda c: model_of(c)[1])
    g = ground(polys); gn = ground(near)
    g, under = top_ground(g)
    inside = lambda q: np.all(np.abs(q.P[:, [0, 2]]) <= 256 + 1e-3)
    tj = t_junctions(g, [q for q in gn])
    tj_border = sum(1 for q, e, p in tj if max(abs(p[0]), abs(p[2])) >= 252)
    opaque = [q for q in polys + near if q.alpha == 31]
    flat = [q for q in g if q.n[1] >= 0.95]                 # (the walkable ground: cliff bottoms and tops left out)
    inner, unbacked = open_edges([q for q in flat if inside(q)] or flat, opaque)
    pairs = layer_pairs(polys, near)
    nearset = {id(q) for q in near}
    border, border_pairs = 0.0, collections.Counter()
    fights = collections.Counter()
    for a, b, gap, ar in pairs:
        if gap < 0.01 and (id(a) in nearset or id(b) in nearset):
            border += ar; border_pairs[(base(a.mat), base(b.mat))] += round(ar)
            continue
        fights[(base(a.mat), base(b.mat))] += 1
    props = json.load(open(os.path.join(LAND, f'{chunk:03d}.json')))['props']
    total = 20 + size + 8196 + 4 + 16 * len(props)
    return dict(chunk=chunk, tj=len(tj), tj_border=tj_border, open=round(inner), unbacked=round(unbacked),
                border=round(border), border_pairs=border_pairs.most_common(4), fights=sum(fights.values()),
                fight_pairs=fights.most_common(6), size=total, fixes=fixrep)


def main_depth(args):
    """--depth [CHUNK ...]: per chunk the layer pairs under DEPTH_RATIO (trees / others, their overlap area)."""
    fixed = '--fixed' in args
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    cells = cells_of(world)
    chunks = [int(a) for a in args if a.isdigit()] or (sorted(int(c) for c in world['chunks'])
                                                       + sorted(int(c) for c in world['rooms']['chunks']))
    cache, tot = {'cells': dict(cells)}, collections.Counter()
    worst = collections.Counter()
    for c in chunks:
        ps = depth_pairs(c, cells[c], fixed, cache)
        bad = [p for p in ps if p[4] < DEPTH_RATIO]
        t = [p for p in bad if p[5]]
        tot['pairs'] += len(bad); tot['tree_pairs'] += len(t)
        tot['area'] += sum(p[3] for p in bad); tot['tree_area'] += sum(p[3] for p in t)
        for p in t: worst[(base(p[0].mat), base(p[1].mat), round(p[2], 2))] += 1
        if bad:
            print(json.dumps(dict(chunk=c, pairs=len(bad), trees=len(t), tree_area=round(sum(p[3] for p in t)),
                                  area=round(sum(p[3] for p in bad)),
                                  min_ratio=round(min(p[4] for p in bad), 2))), flush=True)
    print(f"{len(chunks)} chunks{' (fixed)' if fixed else ''}: layer pairs under depth ratio {DEPTH_RATIO}: "
          f"{tot['pairs']} ({round(tot['area'])} units^2), trees {tot['tree_pairs']} ({round(tot['tree_area'])} units^2)")
    print('tree pairs (materials, gap):', worst.most_common(15))


def main(args):
    if '--depth' in args: return main_depth(args)
    fixed = '--fixed' in args
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    cells = cells_of(world)
    chunks = [int(a) for a in args if a.isdigit()]
    if not chunks:
        ow = sorted(int(c) for c in world['chunks']); rooms = sorted(int(c) for c in world['rooms']['chunks'])
        chunks = rooms if '--rooms' in args else ow if '--world' in args else ow + rooms
    cache, tot = {}, collections.Counter()
    pairs, bpairs, rows = collections.Counter(), collections.Counter(), []
    worst = []
    for c in chunks:
        cache.setdefault('cells', {}).update(cells)
        r = check(c, cells[c], fixed, cache)
        for k in ('tj', 'tj_border', 'open', 'unbacked', 'border', 'fights'): tot[k] += r[k]
        for k, v in r['fight_pairs']: pairs[k] += v
        for k, v in r['border_pairs']: bpairs[k] += v
        rows.append(r)
        worst.append((r['size'], c))
        if len(chunks) <= 20 or r['size'] > CHUNK_LIMIT:
            print(json.dumps(r))
    worst.sort(reverse=True)
    print(f"{len(chunks)} chunks{' (fixed)' if fixed else ''}: T-junctions {tot['tj']} ({tot['tj_border']} at borders), "
          f"edges inside the ground {tot['open']} units, unbacked {tot['unbacked']}, border overlaps with other texels "
          f"{tot['border']} units^2, fighting pairs {tot['fights']}; largest chunks {worst[:4]} (limit {CHUNK_LIMIT})")
    print('fighting materials:', pairs.most_common(25))
    print('border overlaps:', bpairs.most_common(12))
    out = next((a.split('=', 1)[1] for a in args if a.startswith('--json=')), None)
    if out: json.dump(rows, open(out, 'w'), default=str)


if __name__ == '__main__':
    main(sys.argv[1:])
