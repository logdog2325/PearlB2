"""Cracks and flicker fixes for Pearl's map models as Black 2 draws them (the world pass, 2026-10-20; HoennB2's fixes
ported to Pearl's own models: terrain/tjunction.py, world.py UNDERFLOOR, exterior_layers.py / clear_tree_layers).
pearl_chunk.fix_model runs them on every chunk the build installs; pearl_seams_check.py measures before and after.

Why (measured, pearl_seams_check.py; notes/MAP_LOOK.md "Cracks, flicker, stairs"):
- Flicker: Black 2's field camera 0 (a/0/5/9 record 0, 61 of the 66 overworld zones and the rooms' templates) draws
  with the Z-buffer (swapMode 0) and near plane 1: the DS keeps z/w to 1/16384, so one depth step is about 1.7 units
  at the player and 3.7 at the top of the screen. Pearl's camera (near 150, distance 667) resolved ~0.1 unit, so Pearl's
  models keep layers 0.5-0.9 apart: ledges (allpeak 0.5 over the grass), every tree's flat base 0.91 over its shadow,
  the end trees of a row 0.02 in front of the continuous-row cards, neighbouring trees' cards in one plane (0 apart,
  overlapping 8 units), shadow decals on cliffs, rugs. In Black 2 they fight: flashing trees, ledges flickering out.
- Cracks: the DS rasterizes each polygon from its own edges, so 1-pixel cracks open along edges inside a surface
  (T-junctions, and even shared edges; melonDS and hardware, DeSmuME hides most); Pearl's ground has nothing behind
  it, so they show the clear colour (sky blue outdoors, black indoors): the flashing lines.

The fixes (each keeps every texture and material; new polygons go into existing shapes):
- separate(): HoennB2's 2-unit rule. Overlapping pieces (one material, one plane, joined by shared corners) facing the
  same way closer than GAP along their normal: the front one moves toward the camera (along Black 2's view direction
  VIEW, so it stays where it was on screen; along its normal for faces the camera sees edge-on) until it is GAP clear.
  Level pairs: of two tree cards the one on an odd 32-unit column (world x) goes in front, else the smaller piece:
  rules that depend only on world positions, so a chunk and its neighbour decide a pair across their border alike.
  Corners of other faces that touch a moved piece move with it.
- split(): every ground polygon edge with another ground vertex inside it (this chunk's or a neighbour's across the
  border) is split there (fan from the far corner, or from the centre when several edges are split).
- underfloor(): a copy of the ground UNDER units lower, each piece in its own material, so a crack shows ground
  colour. Where the copy would be seen past the ground's edge (a free edge facing the camera: a bridge, a cliff top
  with nothing below, a room's open south side) it is cut back TRIM units.
"""
import collections, math, struct

import numpy as np

import pearl_mesh
from pearl_mesh import Vertex, lerp

GAP = 2.25             # HoennB2's 2-unit rule (exterior_layers MIN_GAP 2.0), plus a margin: pieces bent over
#                        curved cliffs move as one and their planes differ by a few degrees
MAX_PUSH = 6.5
TREE_GAP = 3.25        # tree cards (the polish pass, 2026-10-20; user, melonDS: "some trees still flicker slightly"): at
#                        the screen's top row (view depth ~325 at the ground) one depth step of camera 0 is ~3.2 units,
#                        so cards GAP apart along their normal are only 0.77 of a step apart along the ray and can round
#                        to one depth value; 3.25 gives >= 1.1 steps at every row (pearl_seams_check --depth). Levels:
#                        rows' cards 0, single trees 3.25 / 6.5 (= MAX_PUSH) by column
UNDER = 4.0            # under-floor drop (HoennB2 world.py UNDERFLOOR / water.py SEAM_DROP)
TRIM = 8.0             # under-floor cut back from an edge the camera can see past (at most)
FLAT = 0.95            # the under-floor goes under flat ground only (not the gentle bottoms and tops of cliffs)
EPS = 0.05             # a vertex this close to an edge lies on it (HoennB2 tjunction.EPS)
VIEW = np.array([0.0, math.sin(0x25D8 / 65536 * 2 * math.pi), math.cos(0x25D8 / 65536 * 2 * math.pi)])  # to the
#                                                                    camera: Black 2 camera 0, pitch 0x25D8 (53.2 deg)
TREES = ('tree', 'conttree', 'g1_tree', 'plant')
# rays toward the camera from a hidden layer's edge: pitches of the screen's bottom, middle and top rows, yaws of
# its left, middle and right columns (camera 0: half-angles 20 degrees vertical, 26.6 horizontal)
RAYS = [(math.cos(p) * math.sin(y), math.sin(p), math.cos(p) * math.cos(y))
        for p in map(math.radians, (33.2, 53.2, 73.2)) for y in map(math.radians, (-27, 0, 27))]


def is_tree(name):
    return any(t in name for t in TREES)


class Item:
    """One polygon of the model being fixed: where it sits, its corners in map units."""
    __slots__ = ('shape', 'g', 'k', 'mat', 'alpha', 'P', 'UV', 'n', 'd', 'piece', 'own', 'area')


def _cross(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def _normal(P):
    p0 = P[0]
    e1 = (P[1][0] - p0[0], P[1][1] - p0[1], P[1][2] - p0[2]); e2 = (P[2][0] - p0[0], P[2][1] - p0[1], P[2][2] - p0[2])
    n = _cross(e1, e2)
    if len(P) == 4:
        e3 = (P[3][0] - p0[0], P[3][1] - p0[1], P[3][2] - p0[2])
        m = _cross(e2, e3); n = (n[0] + m[0], n[1] + m[1], n[2] + m[2])
    L = math.sqrt(n[0] * n[0] + n[1] * n[1] + n[2] * n[2])
    return (np.array(n) / L, L / 2) if L > 1e-9 else (None, 0)


def items(model, shift=(0.0, 0.0), own=True):
    """[Item] of a pearl_mesh.Model (positions in map units, moved by shift = (dx, dz))."""
    out = []
    ps = model.pos_scale / 4096
    off = np.array([shift[0], 0.0, shift[1]])
    for si, s in enumerate(model.shapes):
        if s.material is None: continue
        pa = model.poly_attr(s.material)
        for gi, (_, polys) in enumerate(s.groups):
            for k, p in enumerate(polys):
                P = np.array([v.pos for v in p], float) * ps + off
                n, area = _normal(P)
                if n is None: continue
                it = Item()
                it.shape, it.g, it.k, it.mat, it.alpha = si, gi, k, model.materials[s.material], (pa >> 16) & 31
                it.P, it.n, it.d, it.piece, it.own, it.area = P, n, float(n @ P.mean(0)), None, own, area
                it.UV = np.array([(v[3] / 16, v[4] / 16) for v in p], float)
                out.append(it)
    return out


def is_ground(it):
    return it.alpha == 31 and it.n[1] > 0.7 and not is_tree(it.mat)


def _key(p):
    return (round(p[0], 2), round(p[1], 2), round(p[2], 2))


def pieces(its):
    """Union-find: items of one material in one plane that share a corner form a piece; sets it.piece."""
    parent = list(range(len(its)))
    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]; a = parent[a]
        return a
    at = collections.defaultdict(list)
    for i, it in enumerate(its):
        for p in it.P: at[(it.mat, it.own, _key(p))].append(i)
    for ks in at.values():
        for j in ks[1:]:
            a, b = its[ks[0]], its[j]
            if a.n @ b.n > 0.999 and abs(a.d - b.d) < 0.05: parent[find(j)] = find(ks[0])
    groups = collections.defaultdict(list)
    for i in range(len(its)): groups[find(i)].append(i)
    for pid, (root, ks) in enumerate(sorted(groups.items())):
        for i in ks: its[i].piece = pid
    return [[its[i] for i in ks] for _, ks in sorted(groups.items())]


# ---------------------------------------------------------------------------------------------------------- layers
def _basis(n):
    u = _cross(n, (0, 1, 0)) if abs(n[1]) < 0.9 else _cross(n, (1, 0, 0))
    L = math.sqrt(u[0] * u[0] + u[1] * u[1] + u[2] * u[2])
    u = (u[0] / L, u[1] / L, u[2] / L)
    return np.array(u), np.array(_cross(n, u))


def _clip2(poly, clipper):
    out = poly
    for i in range(len(clipper)):
        a, b = clipper[i], clipper[(i + 1) % len(clipper)]
        inp, out = out, []
        for j in range(len(inp)):
            p, q = inp[j], inp[(j + 1) % len(inp)]
            sp = (b[0] - a[0]) * (p[1] - a[1]) - (b[1] - a[1]) * (p[0] - a[0])
            sq = (b[0] - a[0]) * (q[1] - a[1]) - (b[1] - a[1]) * (q[0] - a[0])
            if sp >= 0: out.append(p)
            if (sp >= 0) != (sq >= 0):
                t = sp / (sp - sq); out.append((p[0] + t * (q[0] - p[0]), p[1] + t * (q[1] - p[1])))
        if not out: break
    return out


def _ccw(pts):
    a = sum(pts[i][0] * pts[i - 1][1] - pts[i - 1][0] * pts[i][1] for i in range(len(pts)))
    return pts if a <= 0 else pts[::-1]


def _area2(poly):
    return abs(sum(poly[i][0] * poly[i - 1][1] - poly[i - 1][0] * poly[i][1] for i in range(len(poly)))) / 2


def _uv_at(it, pt):
    P = it.P; e1, e2 = P[1] - P[0], P[2] - P[0]
    M = np.array([[e1 @ e1, e1 @ e2], [e1 @ e2, e2 @ e2]])
    r = pt - P[0]
    try: s, t = np.linalg.solve(M, [r @ e1, r @ e2])
    except np.linalg.LinAlgError: return it.UV[0]
    return it.UV[0] + s * (it.UV[1] - it.UV[0]) + t * (it.UV[2] - it.UV[0])


def same_texels(a, b, pts):
    """Items a and b draw the same texels at pts (one texture, coordinates equal or 16 texels apart): coplanar copies
    like that never show a fight."""
    if a.mat.split('_lm')[0] != b.mat.split('_lm')[0]: return False
    for p in pts:
        d = _uv_at(a, p) - _uv_at(b, p)
        if np.any(np.abs(d - 16 * np.round(d / 16)) > 0.6): return False
    return True


def overlaps(its, gap=GAP, same=same_texels):
    """[(i, j, g, area)]: items i, j (indexes) facing the same way whose overlap is at least 0.5 units^2, with j's plane
    g (>= 0) behind i's along i's normal, g < gap. Skips pairs same_texels(a, b, points) says draw the same texels."""
    buckets = collections.defaultdict(list)
    for i, it in enumerate(its):
        ax = int(np.argmax(np.abs(it.n)))
        o = [k for k in range(3) if k != ax]
        lo = np.floor(it.P[:, o].min(0) / 32).astype(int); hi = np.floor(it.P[:, o].max(0) / 32).astype(int)
        for g0 in range(lo[0], hi[0] + 1):
            for g1 in range(lo[1], hi[1] + 1):
                buckets[(ax, g0, g1)].append(i)
    seen, out = set(), []
    for idx in buckets.values():
        for x in range(len(idx)):
            for y in range(x + 1, len(idx)):
                i, j = idx[x], idx[y]
                if (i, j) in seen: continue
                seen.add((i, j))
                a, b = its[i], its[j]
                if not (a.own or b.own): continue
                nn = float(a.n @ b.n)
                if nn < 0.98 or abs(a.d - b.d) > gap + 64: continue
                u, v = _basis(a.n)
                pa = _ccw([(float(p @ u), float(p @ v)) for p in a.P])
                pb = _ccw([(float(p @ u), float(p @ v)) for p in b.P])
                ov = _clip2(pa, pb)
                if len(ov) < 3 or _area2(ov) < 0.5: continue
                pts3 = [a.d * a.n + s * u + t * v for s, t in ov]
                gaps = [(b.d - float(b.n @ q)) / nn for q in pts3]
                lo, hi = min(gaps), max(gaps)
                if lo >= -0.01: g = max(0.0, lo)             # b's plane in front of a's (touching at most)
                elif hi <= 0.01: g = min(0.0, hi)            # behind
                else: g = 0.0                                # (they cross: level)
                if abs(g) >= gap: continue
                if same and same(a, b, pts3): continue
                if g > 0 or (g == 0 and lo >= -0.01 and hi > 0.01):
                    out.append((j, i, g, _area2(ov)))        # (front, back): j is in front of i
                else: out.append((i, j, -g, _area2(ov)))
    return out


def _level_front(a, b):
    """Which of two level items (gap ~0) goes in front: world-position rules only (both chunks decide alike)."""
    ca, cb = a.P.mean(0), b.P.mean(0)
    if abs(a.area - b.area) > 1:
        return a if a.area < b.area else b
    return a if tuple(np.round(ca, 2)) > tuple(np.round(cb, 2)) else b


def coplanar(a, b):
    """Two items in (nearly) one plane: which one is in front is a choice (_level_front), not a fact."""
    return abs(a.d - float(a.n @ b.P.mean(0))) < 0.05


def tree_card(it):
    return is_tree(it.mat) and abs(it.n[1]) <= 0.9


def base_shift(it):
    """A tree card's own layer, from nothing but itself (Pearl reuses filler chunks at many places of a matrix, so a
    card's neighbours across a border differ from place to place): continuous-row cards (conttree*) stay; single trees
    go GAP forward, or 2 GAP on odd 32-unit columns (world x), so neighbouring trees of a row (one plane, overlapping)
    and a row's end tree (0.02 in front of the row's card) are GAP apart wherever the chunk lies (512 = 16 x 32)."""
    if not tree_card(it) or 'conttree' in it.mat: return 0.0
    return TREE_GAP * (1 + math.floor(it.P.mean(0)[0] / 32) % 2)


def separate(its, gap=GAP):
    """Shifts {piece: units along its normal (negative: back)} that put every overlapping same-facing pair `gap`
    apart: tree cards by base_shift, then every pair still closer: across a chunk border our own piece moves away
    from the neighbour's; a tree part moves (forward when it is in front, back when behind); a piece under a big
    ground piece (4 tiles or more) goes down; else the front piece moves forward."""
    pairs = overlaps(its, max(gap, TREE_GAP) + 2 * MAX_PUSH)   # (pairs clear now count too: a shift can bring them
    #                                                                close)
    shift = collections.defaultdict(float)
    piece_area = collections.defaultdict(float)
    for it in its:
        if it.piece not in shift: shift[it.piece] = base_shift(it)
        piece_area[it.piece] += it.area
    big_ground = lambda it: is_ground(it) and piece_area[it.piece] >= 1024
    rel = []                                           # (front item, back item, current gap)
    for i, j, g, ar in pairs:
        a, b = its[i], its[j]                          # a in front of b by g
        if g < 0.01 and coplanar(a, b) and not (tree_card(a) and tree_card(b)):
            f = _level_front(a, b) if is_tree(a.mat) == is_tree(b.mat) else (a if is_tree(a.mat) else b)
            a, b = (a, b) if f is a else (b, a)
        rel.append((a, b, g, ar))
    for _ in range(8):
        changed = False
        for a, b, g, ar in rel:
            fa, fb = shift[a.piece], shift[b.piece]
            if fb > fa + g:                            # (the shifts put b in front: b is the front one now)
                a, b, g, fa, fb = b, a, -g, fb, fa
            pg = TREE_GAP if gap == GAP and (tree_card(a) or tree_card(b)) else gap
            if fa - fb + g >= pg - 1e-6: continue
            need = pg - g
            on_a, on_b = ar >= 0.9 * a.area, ar >= 0.9 * b.area   # (lies wholly over / under the other: a decal)
            if on_a != on_b and a.own == b.own and not (is_tree(a.mat) or is_tree(b.mat)):
                back = on_b                            # (the decal moves: a ledge row on the grass, a rug)
                if back and fa - need >= -MAX_PUSH: shift[b.piece] = fa - need; changed = True
                elif not back and fb + need <= MAX_PUSH: shift[a.piece] = fb + need; changed = True
                continue
            if a.own != b.own: back = b.own                  # (across a border: our own piece moves away)
            elif is_tree(a.mat) != is_tree(b.mat):     # (the tree part moves; a flat one only up, off the ground:
                back = is_tree(b.mat)                  # under a decal, the decal goes up instead)
                if back and abs(b.n[1]) > 0.9:
                    if big_ground(a): continue
                    back = False
            else: back = big_ground(a) and not is_ground(b)  # (not the ground: what is under it goes down)
            mover, other = (b, a) if back else (a, b)
            if big_ground(mover):                      # a big ground piece (4 tiles or more) moves only against a
                if not other.own: continue             # bigger ground piece of this chunk; against a smaller one,
                if is_ground(other) and piece_area[other.piece] < piece_area[mover.piece]:
                    back = not back                    # that one moves; across a chunk border nothing (two grounds
                    #                                    overlapping there; a room's floor)
            if back and fa - need >= -MAX_PUSH:
                shift[b.piece] = fa - need; changed = True
            elif not back and fb + need <= MAX_PUSH:
                shift[a.piece] = fb + need; changed = True
            elif is_tree(a.mat) and is_tree(b.mat) and fb < fa + g + pg <= MAX_PUSH:
                shift[b.piece] = fa + g + pg; changed = True   # (the front one can't go far enough: the one behind
                #                                                comes forward past it instead; Pearl's canopy tops
                #                                                lie ~6.2 apart, so a 6.5 level met the next one)
        if not changed: break
    return {p: s for p, s in shift.items() if abs(s) > 1e-6}


def apply_shifts(model, its, shift):
    """Move own pieces by their shift (map units along the normal; toward the camera when it faces it) and the
    corners of other faces that touch them. Returns the number of pieces moved."""
    ps = model.pos_scale / 4096
    by_piece = collections.defaultdict(list)
    for it in its:
        if it.own: by_piece[it.piece].append(it)
    # pieces of one material that share corners (a decal bent over a curved cliff, in several planes) move as one,
    # by the largest move toward the camera any of them needs, so no seam opens between them; not the ground's
    # materials (a big ground piece never moves; one of its patches must not drag the rest)
    own = [it for it in its if it.own]
    area = collections.defaultdict(float)
    for it in own: area[it.piece] += it.area
    grounded = {it.mat for it in own if is_ground(it) and area[it.piece] >= 1024}
    parent = {}
    def find(a):
        while parent.setdefault(a, a) != a:
            parent[a] = parent[parent[a]]; a = parent[a]
        return a
    at = {}
    for it in own:
        if it.mat in grounded: continue
        for q in it.P:
            k = (it.mat, _key(q))
            if k in at: parent[find(it.piece)] = find(at[k])
            else: at[k] = it.piece
    members = collections.defaultdict(list)
    for p in by_piece: members[find(p)].append(p)
    moves = {}                                         # raw position -> (raw delta, normal of the moved piece)
    moved_items = set()
    done = set()
    for p, s in shift.items():
        if p not in by_piece or find(p) in done: continue
        done.add(find(p))
        ps_ = members[find(p)]
        along = []                                     # (units toward the camera, or None: along its normal)
        for q in ps_:
            sq = shift.get(q, 0.0)
            nq = by_piece[q][0].n
            nv = float(nq @ VIEW)
            along.append(sq / nv if nv >= 0.5 else None)
        if all(a is not None for a in along):
            t = max(along, key=abs)
            vecs = {q: VIEW * t for q in ps_}
        else:
            vecs = {q: by_piece[q][0].n * shift.get(q, 0.0) for q in ps_}
        for q in ps_:
            vec = vecs[q]
            if not np.any(vec): continue
            raw = tuple(int(round(c / ps)) for c in vec)
            n = by_piece[q][0].n
            for it in by_piece[q]:
                moved_items.add((it.shape, it.g, it.k))
                for v in model.shapes[it.shape].groups[it.g][1][it.k]:
                    moves.setdefault(v.pos, (raw, n))
    if not moves: return 0
    for si, s in enumerate(model.shapes):
        for gi, (gt, polys) in enumerate(s.groups):
            for k, p in enumerate(polys):
                mine = (si, gi, k) in moved_items
                if not mine and not any(v.pos in moves for v in p): continue
                if not mine:                           # (another face: follows only if it is not parallel)
                    P = np.array([v.pos for v in p], float)
                    n, _ = _normal(P)
                new = []
                for v in p:
                    m = moves.get(v.pos)
                    if m and (mine or (n is not None and abs(float(n @ m[1])) < 0.5)):
                        d = m[0]
                        new.append(v.moved(v[0] + d[0], v[1] + d[1], v[2] + d[2]))
                    else:
                        new.append(v)
                polys[k] = new
    return len(moved_items)


# ----------------------------------------------------------------------------------------------------- T-junctions
def split(model, its, extra_points=()):
    """Split the edges of own ground items at ground vertices lying inside them (own ones and extra_points, map units,
    e.g. the neighbours' across the border). Returns (edges split, polygons added)."""
    ps = model.pos_scale / 4096
    ground = [it for it in its if it.own and is_ground(it)]
    pts = {}
    for it in ground:
        for p in it.P: pts[_key(p)] = p
    for p in extra_points: pts[_key(p)] = np.asarray(p, float)
    P = np.array(list(pts.values())) if pts else np.zeros((0, 3))
    grid = collections.defaultdict(list)
    for i, p in enumerate(P): grid[(int(math.floor(p[0] / 16)), int(math.floor(p[2] / 16)))].append(i)
    nsplit = added = 0
    todo = collections.defaultdict(dict)
    for it in ground:
        poly = model.shapes[it.shape].groups[it.g][1][it.k]
        k = len(poly)
        extra = []
        for e in range(k):
            a, b = it.P[e], it.P[(e + 1) % k]
            d = b - a; L2 = float(d @ d)
            hits = []
            if L2 > 1e-6:
                x0, x1 = sorted((a[0], b[0])); z0, z1 = sorted((a[2], b[2]))
                cand = [i for gx in range(math.floor((x0 - EPS) / 16), math.floor((x1 + EPS) / 16) + 1)
                        for gz in range(math.floor((z0 - EPS) / 16), math.floor((z1 + EPS) / 16) + 1)
                        for i in grid.get((gx, gz), ())]
                if cand:
                    C = P[cand]
                    s = ((C - a) @ d) / L2
                    close = np.linalg.norm(a + s[:, None] * d[None] - C, axis=1) < EPS
                    ok = close & (s > 1e-4) & (s < 1 - 1e-4)
                    for j in np.nonzero(ok)[0]:
                        hits.append((float(s[j]), C[j]))
            hits.sort(key=lambda h: h[0])
            dedup = []
            for s, c in hits:
                if not dedup or (s - dedup[-1][0]) * math.sqrt(L2) > 1e-3: dedup.append((s, c))
            extra.append(dedup)
        if not any(extra): continue
        nsplit += sum(1 for x in extra if x)
        def vert(e, s, c):
            va, vb = poly[e], poly[(e + 1) % k]
            return lerp(va, vb, s, tuple(int(round(x / ps)) for x in c))
        edges = [e for e in range(k) if extra[e]]
        out = []
        if len(edges) == 1:
            e = edges[0]
            chain = [poly[e]] + [vert(e, s, c) for s, c in extra[e]] + [poly[(e + 1) % k]]
            rest = [poly[(e + 2 + i) % k] for i in range(k - 2)]        # the corners not on the split edge
            apex = rest[-1]                                              # fan from the corner after the rest
            for i in range(len(chain) - 1): out.append([chain[i], chain[i + 1], apex])
            if k == 4: out.append([chain[-1], rest[0], apex])
        else:
            ring = []
            for e in range(k):
                ring.append(poly[e])
                ring += [vert(e, s, c) for s, c in extra[e]]
            cx = sum(v[0] for v in poly) / k; cy = sum(v[1] for v in poly) / k; cz = sum(v[2] for v in poly) / k
            centre = Vertex(int(round(cx)), int(round(cy)), int(round(cz)),
                            int(round(sum(v[3] for v in poly) / k)), int(round(sum(v[4] for v in poly) / k)),
                            poly[0][5], poly[0][6])
            for i in range(len(ring)): out.append([ring[i], ring[(i + 1) % len(ring)], centre])
        added += len(out) - 1
        todo[(it.shape, it.g)][it.k] = out
    for (si, gi), repl in todo.items():
        gt, polys = model.shapes[si].groups[gi]
        keep = [p for k, p in enumerate(polys) if k not in repl]
        new = [q for k in sorted(repl) for q in repl[k]]
        model.shapes[si].groups[gi] = (gt, keep)
        model.shapes[si].groups.append((pearl_mesh.TRIS, new))
    return nsplit, added


# ----------------------------------------------------------------------------------------------------- under-floor
class Rays:
    """Opaque triangles bucketed by x/z cells for 'does a ray from here toward the camera hit anything' tests."""
    def __init__(self, its, cell=16.0):
        T = []
        for it in its:
            if it.alpha != 31: continue
            P = it.P
            for a, b, c in ((0, 1, 2), (0, 2, 3)) if len(P) == 4 else ((0, 1, 2),):
                T.append((P[a], P[b], P[c]))
        self.T = np.array(T) if T else np.zeros((0, 3, 3))
        self.cell = cell
        self.b = collections.defaultdict(list)
        if len(self.T):
            lo = np.floor(self.T.min(1)[:, [0, 2]] / cell).astype(int)
            hi = np.floor(self.T.max(1)[:, [0, 2]] / cell).astype(int)
            for i in range(len(self.T)):
                for gx in range(lo[i, 0], hi[i, 0] + 1):
                    for gz in range(lo[i, 1], hi[i, 1] + 1):
                        self.b[(gx, gz)].append(i)

    def blocked(self, origins, dirs, length):
        """For rays origins[i] + t * dirs[j] (every pair), t in (0.05, length]: True where every ray of origin i hits
        an opaque triangle (the point is hidden from every camera direction)."""
        return self.hits(origins, dirs, length).all(1)

    def hits(self, origins, dirs, length):
        """(origins, dirs) bool: the ray hits an opaque triangle within length."""
        if not len(origins): return np.zeros((0, len(dirs)), bool)
        lo = origins.min(0) - length; hi = origins.max(0) + length
        cand = sorted({i for gx in range(math.floor(lo[0] / self.cell), math.floor(hi[0] / self.cell) + 1)
                       for gz in range(math.floor(lo[2] / self.cell), math.floor(hi[2] / self.cell) + 1)
                       for i in self.b.get((gx, gz), ())})
        if not cand: return np.zeros((len(origins), len(dirs)), bool)
        T = self.T[cand]
        v0, e1, e2 = T[:, 0], T[:, 1] - T[:, 0], T[:, 2] - T[:, 0]
        O = np.repeat(origins, len(dirs), axis=0)                 # (R,3)
        D = np.tile(dirs, (len(origins), 1))
        h = np.cross(D[:, None, :], e2[None, :, :])                # (R,T,3)
        a = np.einsum('rtk,tk->rt', h, e1)
        ok = np.abs(a) > 1e-9
        f = np.where(ok, 1 / np.where(ok, a, 1), 0)
        s = O[:, None, :] - v0[None]
        u = f * np.einsum('rtk,rtk->rt', s, h)
        q = np.cross(s, e1[None])
        v = f * np.einsum('rk,rtk->rt', D, q)
        t = f * np.einsum('tk,rtk->rt', e2, q)
        hit = ok & (u >= -1e-4) & (v >= -1e-4) & (u + v <= 1 + 1e-4) & (t > 0.05) & (t <= length)
        return hit.any(1).reshape(len(origins), len(dirs))


def _clip_poly(poly, keep):
    """Polygon (raw Vertex list) clipped to keep(vertex) >= 0 (a linear function); corners interpolated."""
    out = []
    for i in range(len(poly)):
        p, q = poly[i], poly[(i + 1) % len(poly)]
        sp, sq = keep(p), keep(q)
        if sp >= 0: out.append(p)
        if (sp >= 0) != (sq >= 0):
            out.append(lerp(p, q, sp / (sp - sq)))
    return out


def underfloor(model, its, rays, skip=()):
    """Add a copy of every own ground item UNDER units lower to its own shape, cut back where the camera could see
    it past a free edge, none where another surface lies within GAP of the copy. skip: (shape, group, index) of
    items left out (moved decals). Returns (added, trimmed, left out as crowded)."""
    from pearl_seams_check import Grid, tris_xz
    ps = model.pos_scale / 4096
    drop = int(round(UNDER / ps))
    dirs = np.array(RAYS)
    added = trimmed = crowded = 0
    new = collections.defaultdict(list)
    flat = Grid(*tris_xz([it for it in its if it.alpha == 31 and abs(it.n[1]) > 0.7]))
    for it in its:
        if not (it.own and is_ground(it)) or it.n[1] < FLAT or (it.shape, it.g, it.k) in skip: continue
        poly = [v.moved(y=v[1] - drop) for v in model.shapes[it.shape].groups[it.g][1][it.k]]
        P = it.P - np.array([0, UNDER, 0])
        k = len(P)
        # no copy where another surface lies within GAP of it (a lamp post's base 2.6 over the plaza: its copy would
        # be 1.4 under the plaza floor and show through it)
        ctr = P.mean(0)
        S = np.array([ctr] + [ctr + 0.9 * (p - ctr) for p in P])
        hs = flat.heights(S[:, [0, 2]])
        if any(np.any(np.abs(h - y) < GAP) for h, y in zip(hs, S[:, 1])):
            crowded += 1; continue
        # clip at each edge the camera could see past (its outward side not toward the north)
        cuts = []
        for e in range(k):
            a, b = P[e], P[(e + 1) % k]
            ex, ez = b[0] - a[0], b[2] - a[2]
            L = math.hypot(ex, ez)
            if L < 1e-3: continue
            nx, nz = ez / L, -ex / L                       # a perpendicular in x/z, made to point outward
            if nx * (ctr[0] - a[0]) + nz * (ctr[2] - a[2]) > 0: nx, nz = -nx, -nz
            if nz < -0.5: continue                         # facing north: the camera looks at it over the ground
            m = max(2, int(L // 4) + 1)
            S = np.array([a + (b - a) * (i + 0.5) / m - np.array([nx, 0, nz]) * 0.5 for i in range(m)])
            free = ~rays.hits(S, dirs, UNDER * 2.5 / 0.55)
            if free.any():                                 # cut as far in as an escaping ray reaches while it rises
                reach = max(UNDER * (d[0] * nx + d[2] * nz) / d[1] for d, f in zip(dirs, free.any(0)) if f)
                cuts.append((a, nx, nz, min(TRIM, max(1.0, reach + 1.0))))
        for a, nx, nz, cut in cuts:                        # keep what lies `cut` or more inside the edge
            def keep(v, a=a, nx=nx, nz=nz, cut=cut):
                x, z = v[0] * ps, v[2] * ps
                return -((x - a[0]) * nx + (z - a[2]) * nz) - cut
            poly = _clip_poly(poly, keep)
            if len(poly) < 3: break
        if cuts: trimmed += 1
        if len(poly) < 3: continue
        if len(poly) <= 4: new[it.shape].append(poly)
        else: new[it.shape] += [[poly[0], poly[i], poly[i + 1]] for i in range(1, len(poly) - 1)]
        added += 1
    for si, polys in new.items():
        tris = [p for p in polys if len(p) == 3]; quads = [p for p in polys if len(p) == 4]
        if quads: model.shapes[si].groups.append((pearl_mesh.QUADS, quads))
        if tris: model.shapes[si].groups.append((pearl_mesh.TRIS, tris))
    return added, trimmed, crowded


# --------------------------------------------------------------------------------------------------------- the lot
STEPS = ('layers', 'underfloor', 'split')


def near_items(near):
    """Items of neighbour models [(pearl_mesh.Model, dx, dz)] within 32 units of this chunk's square."""
    out = []
    for nm, dx, dz in near:
        for it in items(nm, (512 * dx, 512 * dz), own=False):
            if np.all(np.abs(it.P[:, 0]) > 288) or np.all(np.abs(it.P[:, 2]) > 288): continue
            out.append(it)
    return out


def fix(bmd, near=(), fits=None, steps=STEPS):
    """(new BMD0 bytes, report) for a Pearl map model with its neighbours near = [(pearl_mesh.Model, dx, dz)].
    fits(n_bytes) -> bool: when the model comes out too big, the T-junction splits are given back, then the
    under-floor (HoennB2 world.py chunk_fit's order: the under-floor goes last)."""
    rep = {}
    others = near_items(near)
    tries = [steps] + [tuple(s for s in steps if s not in drop) for drop in (('split',), ('split', 'underfloor'))]
    for want in tries:
        model = pearl_mesh.Model(bmd)
        its = items(model) + others
        pieces(its)
        moved = set()
        if 'layers' in want:
            shift = separate(its)
            rep['moved'] = apply_shifts(model, its, shift)
            moved = {(it.shape, it.g, it.k) for it in its if it.own and it.piece in shift}
            its = items(model) + others
            pieces(its)
        if 'underfloor' in want:
            rep['underfloor'], rep['trimmed'], rep['crowded'] = underfloor(model, its, Rays(its), skip=moved)
        if 'split' in want:
            pts = [p for it in others if is_ground(it) for p in it.P
                   if max(abs(p[0]), abs(p[2])) >= 248 and min(abs(p[0]), abs(p[2])) <= 264]
            rep['split_edges'], rep['split_added'] = split(model, [it for it in its if it.own], pts)
        out = model.encode()
        rep['steps'] = list(want)
        if fits is None or fits(len(out)): return out, rep
    rep['over'] = True
    return out, rep


# ------------------------------------------------------------------------------------------- placed buildings/props
def fix_building(bmd, people=True):
    """(new BMD0 bytes, pieces moved) for a placed building or prop model (pearl_buildings): its flat parts lying
    less than GAP above its base (y 0, where the ground under it is) move toward the camera until GAP clear: the
    buildings' shadow decals h_kage (1.0 over the base, alpha 9), the furniture's shade (0.5), door steps and plates
    (0-1.8), which fought the ground they stand on. The model unchanged when it is not a plain one-model BMD0.
    Then room furniture sinks and pulls back as its placements need (people_prop: people drawn into furniture)."""
    try:
        model = pearl_mesh.Model(bmd)
    except (AssertionError, IndexError, KeyError, struct.error):
        return bmd, 0
    its = items(model)
    if not its: return bmd, 0
    bmd, n = _separate_building(model, its, bmd)
    if people:
        bmd, k = people_prop(bmd)
        n += k
        bmd, k = stair_prop(bmd)
        n += k
    return bmd, n


def _separate_building(model, its, bmd):
    P = np.concatenate([it.P for it in its])
    lo, hi = P.min(0) - 8, P.max(0) + 8
    ground = Item()
    ground.shape = ground.g = ground.k = -1
    ground.mat, ground.alpha, ground.own, ground.area = '_ground', 31, False, 1e9
    ground.P = np.array([[lo[0], 0.0, hi[2]], [hi[0], 0.0, hi[2]], [hi[0], 0.0, lo[2]], [lo[0], 0.0, lo[2]]])
    ground.UV = np.zeros((4, 2)); ground.n = np.array([0.0, 1.0, 0.0]); ground.d = 0.0
    its.append(ground)
    pieces(its)
    shift = {p: s for p, s in separate(its).items() if s > 0}
    if not shift: return bmd, 0
    n = apply_shifts(model, its, shift)
    return model.encode(), n


def fix_pack(pack):
    """A building pack ('AB' container: info records, then BMD0 models) with fix_building on every model."""
    from b2files import gf_container, gf_container_build
    magic, secs = gf_container(pack)
    out, n = [], 0
    for sec in secs:
        if sec[:4] == b'BMD0':
            sec, k = fix_building(sec); n += k
        out.append(sec)
    return gf_container_build(magic, out), n


# ------------------------------------------------------------------------------------ people drawn into furniture
# (the furniture pass, 2026-10-20; HoennB2 notes/INTERIORS.md "Indoor check"; b2tools/pearl_rooms_view.py measures it;
# notes/MAP_LOOK.md "People drawn into furniture")
# Black 2 draws a person as a camera-facing quad that leans back from the feet with the camera (camera 0, pitch 52.6:
# at h units up it stands 1.307 h north) and passes the depth test against geometry up to ~3.65 % of the view
# distance nearer the camera (fieldmap.c: the objects' projection offset 0x136); the DS keeps z/w to 1/16384, so on
# hardware and melonDS that margin is ~1.7 units (one depth step) less sure. A block top whose front edge is less than
# ~15 units north of someone's feet and high enough stands in front of the quad by more than that and is drawn across
# the sprite: the head in the kitchen counter (Pearl's camera, far and with near plane 150, never showed it). The fix
# sinks the block and pulls its front back (toward its north side) by equal amounts, in PEOPLE_STEP steps, until no
# part of it stands more than PEOPLE_MARGIN in front of any person's quad where it overlaps the sprite on screen.
# Rooms only: the room chunks' own blocks (pearl_chunk.fix_model, the people tiles from Pearl's collision and objects)
# and the furniture props of the room packs (fix_building, one amount per model from all its room placements).
# PEOPLE_FIX=none (environment): off (the checker's "before").
PEOPLE_SIN, PEOPLE_COS = 0.79430, 0.60752   # camera 0's pitch (eye 185.73 up, 142.05 south of the target: RAM)
PEOPLE_ANCHOR = 1.583       # the quad's bottom below the feet (fieldmap.c: cos(pitch) * 4 - 4)
PEOPLE_MARGIN = 5.5         # units a surface may stand in front of the quad: k 0.9635 less one depth step at a view
#                             distance of ~186 (people near the screen's bottom); 6.96 at the screen's centre
PEOPLE_MARGIN_CAVE = 9.5    # the same in zones of projection type 1 (caves and outdoor rooms: offset 0x1ee, k 0.943)
PEOPLE_TOP = 28.0           # the quad's height (units along the camera's up)
PEOPLE_SIDE = 10.0          # half the sprite's opaque width
PEOPLE_BEHIND = 4.0         # nearer than this north of the feet is the person's own tile, not behind them
PEOPLE_LOW = 3.0            # floor-level pieces (rugs, mats, shades) never cover anyone
PEOPLE_REACH = 19.0         # nothing farther north than this can be in front of the quad and on it
PEOPLE_WALL = 30.0          # polygons taller than this are walls, not furniture: never moved
PEOPLE_TALL = 24.0          # blocks taller than this (shelves, fridges, TVs, plants) are left: their front covers the
#                             top of the head of someone right in front from above, Black 2's own look (HoennB2
#                             rooms_view --b2: 4 % of Black 2's room tiles); lowering them would change Pearl's look
PEOPLE_MAX_SINK, PEOPLE_MAX_PULL = 0.35, 0.45   # at most these fractions of a block's height / depth
PEOPLE_MAX_UNITS = 4.0      # and at most this many units each (a quarter tile: Pearl's look kept); a block that needs
#                             more is left as Pearl's (listed by pearl_rooms_view)
PEOPLE_STEP = 0.25
PEOPLE_JOIN = 2.25          # parts this close are one block (a counter's top over its recessed cabinet)
PEOPLE_BAND = 4.0           # the top / front band of a block that moves rigidly (keeps the layers' GAP)


def people_off():
    import os
    return os.environ.get('PEOPLE_FIX') == 'none'


PEOPLE_PROFILE = (0, 0, 3, 6, 7, 7, 8, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 9, 9, 9, 9, 8, 6,
                  6, 5, 0)     # opaque half-width (px) of a 32-px frame per row, top first: the player's sheets
#                              (Lucas, Dawn) and 90 % of the rooms' people's (pearl_rooms_view.Sprites)
PEOPLE_EYE = np.array([0.0, 4.0 + 185.7273, 142.0496])   # the eye from the feet (camera 0 on the person)
PEOPLE_SAMPLE = 1.0         # units between the points a polygon is tested at
PEOPLE_EDGE = 1.5           # px of the silhouette's sides left out (slivers at an arm beside a counter's end)


def _samples(P, step=PEOPLE_SAMPLE):
    """Points covering polygon P (3 or 4 corners, map units), a grid of spacing ~step on each fan triangle."""
    P = np.asarray(P, float)
    out = []
    for a, b, c in ((P[0], P[1], P[2]),) + (((P[0], P[2], P[3]),) if len(P) == 4 else ()):
        n = max(1, int(math.ceil(max(np.linalg.norm(b - a), np.linalg.norm(c - a), np.linalg.norm(c - b)) / step)))
        i, j = np.meshgrid(np.arange(n + 1), np.arange(n + 1), indexing='ij')
        keep = i + j <= n
        i, j = i[keep] / n, j[keep] / n
        out.append(a + np.outer(i, b - a) + np.outer(j, c - a))
    return np.concatenate(out)


def people_cover(S, tile):
    """For sample points S (n, 3): units each stands in front of the sprite of a person at tile = (x, z, feet y[,
    margin]) beyond the margin (default PEOPLE_MARGIN) where it lands on the sprite's opaque silhouette (PEOPLE_PROFILE less PEOPLE_EDGE), behind the
    feet (PEOPLE_BEHIND) and above the floor-level pieces; 0 elsewhere. The camera centred on them (the depth
    difference does not depend on where the camera is: its direction is fixed)."""
    x, z, y = tile[:3]
    margin = tile[3] if len(tile) > 3 else PEOPLE_MARGIN
    S = np.asarray(S, float)
    A = np.array([x, y - PEOPLE_ANCHOR, z]); eye = np.array([x, y, z]) + PEOPLE_EYE
    f = np.array([0.0, -PEOPLE_SIN, -PEOPLE_COS]); u = np.array([0.0, PEOPLE_COS, -PEOPLE_SIN])
    d = S - eye
    D = d @ f
    Ds = float(f @ (A - eye))
    q = eye + d * (Ds / np.maximum(D, 1e-3))[:, None]
    row = np.floor(32 - ((q - A) @ u) / 28.0 * 32).astype(int)
    col = np.abs(q[:, 0] - x) / 28.0 * 32
    ok = (row >= 0) & (row < 32) & (S[:, 2] < z - PEOPLE_BEHIND) & (S[:, 1] > y + PEOPLE_LOW) & (D > 1)
    prof = np.array(PEOPLE_PROFILE, float)
    ok &= col < prof[np.clip(row, 0, 31)] - PEOPLE_EDGE
    return np.where(ok, np.maximum(Ds - D - margin, 0.0), 0.0)


def people_gain(P, tile):
    """Units by which polygon P (corners in map units) stands in front of the sprite of a person at tile beyond
    PEOPLE_MARGIN where it covers it (people_cover; 0: never)."""
    return float(people_cover(_samples(P), tile).max(initial=0.0))


def _band(v, lo, hi, d):
    """Values in [lo, hi] moved toward lo: the band PEOPLE_BAND below hi rigidly by d (a top and the decal lying on
    it, a front face and its sign keep their GAP), the rest by d * (v - lo) / (hi - BAND - lo); plain scaling when
    the block is thinner than the band and d."""
    if hi <= lo or not d: return v
    band = min(PEOPLE_BAND, (hi - lo) / 2)
    if hi - band - lo <= d:
        return lo + (v - lo) * (hi - lo - d) / (hi - lo)
    return np.where(v >= hi - band, v - d, v - d * np.clip(v - lo, 0, None) / (hi - band - lo))


def _people_moved(P, box, s, b):
    """Points P moved by a block's sink s (top toward y0) and pull-back b (south side toward zn); box = (y0, y1, zn,
    zs). Monotonic (nothing folds), the top and front bands move rigidly (_band)."""
    y0, y1, zn, zs = box
    Q = np.array(P, float)
    Q[:, 1] = _band(Q[:, 1], y0, y1, s)
    Q[:, 2] = _band(Q[:, 2], zn, zs, b)
    return Q


def _people_near(box_xz, tiles, top=None, zs_high=None):
    """The tiles whose person a box (x0, x1, zn, zs; top: its highest y; zs_high: the south side of its parts above
    the floor-level ones) can stand in front of; not those it reaches within 4.5 units of (someone standing in a bed,
    under a table or against a piece set half a tile into their tile, where Pearl's collision lets them: sinking the
    piece would not mend it; pearl_rooms_view lists them)."""
    x0, x1, zn, zs = box_xz
    out = []
    for t in tiles:
        if not (t[0] + PEOPLE_SIDE >= x0 and t[0] - PEOPLE_SIDE <= x1 and t[1] - PEOPLE_REACH <= zs
                and t[1] - PEOPLE_BEHIND >= zn): continue
        if x0 < t[0] + 6 and x1 > t[0] - 6 and (zs if zs_high is None else zs_high) > t[1] - 4.5:
            continue                         # (its parts above the floor-level ones reach within 4.5 of the feet)
        if top is not None:                  # the most any point of the box can stand in front of the quad
            m = t[3] if len(t) > 3 else PEOPLE_MARGIN
            if PEOPLE_SIN * (top - t[2] + PEOPLE_ANCHOR) - PEOPLE_COS * max(0.0, t[1] - zs) - m <= 0: continue
        out.append(t)
    return out


def people_amount(polys, box, tiles, lift=(0.0, 0.0)):
    """(sink, pull, gain left) for a block (polygons, box = (y0, y1, zn, zs)): the smallest equal sink (of its top,
    squashing it toward y0) and pull-back (of its south side, toward zn) in PEOPLE_STEP steps, within the caps,
    after which no polygon covers a person on `tiles`; gain left > 0 when the caps were reached first. lift: how far
    the layers fix raised its top and pushed its south side out (the caps count from Pearl's own shape)."""
    y0, y1, zn, zs = box
    hs = min(PEOPLE_MAX_SINK * (y1 - y0), PEOPLE_MAX_UNITS + lift[0])
    hb = min(PEOPLE_MAX_PULL * (zs - zn), PEOPLE_MAX_UNITS + lift[1])
    S0 = np.concatenate([_samples(P) for P in polys]) if polys else np.zeros((0, 3))
    def gain(k):
        a = k * PEOPLE_STEP
        S = _people_moved(S0, box, min(a, hs), min(a, hb))
        return max([float(people_cover(S, t).max(initial=0.0)) for t in tiles] or [0.0])
    if gain(0) <= 0: return 0.0, 0.0, 0.0
    top = int(math.ceil(max(hs, hb) / PEOPLE_STEP))
    g_top = gain(top)
    if g_top > 0: return hs, hb, g_top
    lo, hi = 0, top                          # (bisection: more sink and pull-back never covers more)
    while hi - lo > 1:
        mid = (lo + hi) // 2
        if gain(mid) > 0: lo = mid
        else: hi = mid
    a = hi * PEOPLE_STEP
    return min(a, hs), min(a, hb), 0.0


def _people_apply(model, members, box, s, b):
    """Move the vertices of the polygons members [(shape, group, k)] by the block transform (raw positions)."""
    ps = model.pos_scale / 4096
    for si, gi, k in members:
        poly = model.shapes[si].groups[gi][1][k]
        P = np.array([v.pos for v in poly], float) * ps
        Q = _people_moved(P, box, s, b)
        model.shapes[si].groups[gi][1][k] = [v.moved(int(round(q[0] / ps)), int(round(q[1] / ps)), int(round(q[2] / ps)))
                                             for v, q in zip(poly, Q)]


def people_fix(bmd, tiles, raw=None):
    """(new BMD0 bytes, report) for a room's map model: its blocks (furniture-like parts: polygons not taller than
    PEOPLE_WALL in materials that have none taller (walls), not at the floor, joined by shared corners or boxes
    PEOPLE_JOIN apart) that cover a person on one of tiles [(x, z, feet y[, margin])] (map units) sink and pull back (people_amount). report: one dict per block that
    covers someone: mats, box (y0, y1, zn, zs), x (x0, x1), sink, pull, left (gain left; 'tall': not moved).
    Runs on the model as the other fixes leave it (the layers fix lifts decals and whole tops GAP or more toward the
    camera: they stand in front of people too). raw: Pearl's own model, so those lifts do not count against the
    caps (the top of the same footprint in Pearl's model)."""
    if people_off() or not tiles: return bmd, []
    model = pearl_mesh.Model(bmd)
    its = [it for it in items(model) if it.alpha > 0]
    if not its: return bmd, []
    raw_its = [it for it in items(pearl_mesh.Model(raw)) if it.alpha > 0] if raw is not None else None
    floor = min(t[2] for t in tiles)
    feet = sorted({round(t[2], 1) for t in tiles})
    lo = np.array([it.P.min(0) for it in its]); hi = np.array([it.P.max(0) for it in its])
    def walked(i):                                  # a floor people walk on (raised ones too)
        return its[i].n[1] > 0.9 and any(abs(hi[i][1] - f) < 1.0 for f in feet)
    walls = {it.mat for i, it in enumerate(its) if hi[i][1] - lo[i][1] > PEOPLE_WALL}   # (a wall's skirting too)
    cand = [i for i, it in enumerate(its)
            if hi[i][1] - lo[i][1] <= PEOPLE_WALL and hi[i][1] > floor + 1.0 and not walked(i) and it.mat not in walls
            and hi[i][0] - lo[i][0] <= 160 and hi[i][2] - lo[i][2] <= 160]
    bad = []
    for i in cand:
        near = _people_near((lo[i][0], hi[i][0], lo[i][2], hi[i][2]), tiles, hi[i][1])
        if not near: continue
        S0 = _samples(its[i].P)
        if any(people_cover(S0, t).max(initial=0.0) > 0 for t in near): bad.append(i)
    if not bad: return bmd, []
    # blocks: candidates joined by a shared corner or boxes within PEOPLE_JOIN, grown from the bad polygons
    parent = {i: i for i in cand}
    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]; a = parent[a]
        return a
    at = {}
    for i in cand:
        for p in its[i].P:
            k = _key(p)
            if k in at: parent[find(i)] = find(at[k])
            else: at[k] = i
    C = np.array(cand)
    for j, i in enumerate(cand):
        touch = np.all((lo[C] <= hi[i] + PEOPLE_JOIN) & (hi[C] >= lo[i] - PEOPLE_JOIN), axis=1)
        for q in C[touch]: parent[find(int(q))] = find(i)
    blocks = collections.defaultdict(list)
    for i in cand: blocks[find(i)].append(i)
    for root in sorted({find(i) for i in bad}):      # parts lying inside a block's box move with it (a top the
        mem = blocks.get(root)                       # layers fix lifted away from the one it covered)
        if not mem: continue
        L, Hh = lo[mem].min(0) - 0.5, hi[mem].max(0) + 0.5
        for r2 in list(blocks):
            if r2 == root: continue
            m2 = blocks[r2]
            if np.all(lo[m2].min(0) >= L) and np.all(hi[m2].max(0) <= Hh):
                for q in m2: parent[q] = root
                mem += blocks.pop(r2)
    report = []
    for root in sorted({find(i) for i in bad}):
        mem = blocks[root]
        L, Hh = lo[mem].min(0), hi[mem].max(0)
        box = (float(L[1]), float(Hh[1]), float(L[2]), float(Hh[2]))
        if Hh[1] - L[1] > PEOPLE_TALL:
            report.append(dict(mats=sorted({its[i].mat for i in mem}), box=box, x=(float(L[0]), float(Hh[0])),
                               sink=0.0, pull=0.0, left='tall'))
            continue
        high = [hi[i][2] for i in mem if hi[i][1] > L[1] + PEOPLE_LOW]
        near = _people_near((L[0], Hh[0], L[2], Hh[2]), tiles, Hh[1], max(high) if high else None)
        lift = (0.0, 0.0)
        if raw_its is not None:                       # Pearl's own parts in the same box (less 1 unit at the sides)
            R = [it.P for it in raw_its if it.mat not in walls
                 and np.all(it.P.min(0)[[0, 2]] >= L[[0, 2]] - 1) and np.all(it.P.max(0)[[0, 2]] <= Hh[[0, 2]] + 1)
                 and it.P.max(0)[1] > L[1] + PEOPLE_LOW]
            if R:
                R = np.concatenate(R)
                lift = (max(0.0, float(Hh[1] - R[:, 1].max())), max(0.0, float(Hh[2] - R[:, 2].max())))
        s, b, left = people_amount([its[i].P for i in mem], box, near, lift)
        if left > 0: s, b = 0.0, 0.0                          # (not mendable within the caps: left as Pearl's)
        if s or b:
            _people_apply(model, [(its[i].shape, its[i].g, its[i].k) for i in mem], box, s, b)
        report.append(dict(mats=sorted({its[i].mat for i in mem}), box=box, x=(float(L[0]), float(Hh[0])),
                           sink=s, pull=b, left=round(left, 2)))
    return model.encode(), report


def _model_name(bmd):
    try:
        mdl = struct.unpack_from('<I', bmd, 0x10)[0]
        return pearl_mesh._ndict(bmd, mdl + 8)[0][1]
    except Exception:
        return None


def people_prop(bmd):
    """(new BMD0 bytes, 1 if changed) for a prop: the sink and pull-back its room placements need (people_props)."""
    if people_off(): return bmd, 0
    amt = people_props().get(_model_name(bmd))
    if not amt or not (amt[0] or amt[1]): return bmd, 0
    s, b, box = amt[0], amt[1], amt[2]
    model = pearl_mesh.Model(bmd)
    _people_apply(model, [(it.shape, it.g, it.k) for it in items(model)], box, s, b)
    return model.encode(), 1


_PEOPLE_PROPS = None


def people_props():
    """{prop model name: (sink, pull, box, gain left)} for the furniture props of Pearl's rooms: one amount per model
    covering all its room placements (the same model looks the same everywhere)."""
    global _PEOPLE_PROPS
    if _PEOPLE_PROPS is not None: return _PEOPLE_PROPS
    import json, os
    import pearl_chunk, pearl_buildings
    from gen4rom import Rom, narc_members
    root = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    world = json.load(open(os.path.join(root, 'data', 'sinnoh_world.json')))
    build = narc_members(Rom(os.path.join(root, 'roms', 'pearl.nds')).read('fielddata/build_model/build_model.narc'))
    uses = collections.defaultdict(list)          # model id -> [(people tiles in the prop's frame)]
    for c in sorted(int(k) for k in world['rooms']['chunks']):
        land = json.load(open(os.path.join(pearl_chunk.LAND, f'{c:03d}.json')))
        if not land['props']: continue
        tiles = pearl_chunk.people_tiles(c)
        for pr in pearl_chunk.people_props_moved(c, land['props'], props_too=False):   # (riding a sunk counter)
            px, py, pz = pr['pos']
            uses[pr['model']].append([(t[0] - px, t[1] - pz, t[2] - py) + tuple(t[3:]) for t in tiles])
    out = {}
    for mid, places in sorted(uses.items()):
        try:                                                  # (as fix_building leaves it before people_prop)
            model = pearl_mesh.Model(fix_building(pearl_buildings.mdl_only(build[mid]), people=False)[0])
        except (AssertionError, IndexError, KeyError, struct.error):
            continue
        its = [it for it in items(model) if it.alpha > 0]
        if not its: continue
        P = np.concatenate([it.P for it in its])
        L, Hh = P.min(0), P.max(0)
        if Hh[1] - L[1] > PEOPLE_TALL: continue               # tall pieces (shelves, fridges): left
        if (Hh[1] - L[1] < PEOPLE_LOW or Hh[1] < PEOPLE_LOW or Hh[2] - L[2] < 2 or Hh[2] - L[2] > 64
                or Hh[0] - L[0] > 64): continue                # mats, lifts under the floor, pictures and windows
        #                                                        on a wall (they go with the wall), whole lakes
        polys = [it.P for it in its]
        high = P[P[:, 1] > L[1] + PEOPLE_LOW]
        zs_high = float(high[:, 2].max()) if len(high) else None
        near = [t for tiles in places for t in _people_near((L[0], Hh[0], L[2], Hh[2]), tiles, Hh[1], zs_high)]
        S0 = np.concatenate([_samples(p) for p in polys])
        if not near or not any(people_cover(S0, t).max(initial=0.0) > 0 for t in near): continue
        box = (float(L[1]), float(Hh[1]), float(L[2]), float(Hh[2]))
        s, b, left = people_amount(polys, box, near)
        if left > 0: s, b = 0.0, 0.0                          # (not mendable within the caps: left as Pearl's)
        out[_model_name(build[mid])] = (s, b, box, round(left, 2))
    _PEOPLE_PROPS = out
    return out


# ------------------------------------------------------------------------------------- the player drawn into stairs
# (the polish pass, 2026-10-20; pearl_rooms_view.py kind s measures it; notes/MAP_LOOK.md "The stair walk")
# User (melonDS): "when you go downstairs your head kinda briefly clips into it". Black 2's stair warp walks the player
# onto the flight's centre (sinking 8 units on a down flight's 45-degree plane, pearl_chunk.stair_walk) and an arriving
# player stands there while the screen fades in. Pearl's stair models were made for Pearl's far camera: the raised rim
# round a down flight's opening (stair_d01/02: 9 units over the floor, 8-12 north of the walker's feet) and the railing
# of an up flight (stair_u01/02: its top 14 units over the walker's feet 8-12 north of them) stand up to 10-14 units in
# front of the person's quad, which leans back from the feet with the camera (see the people fix above): the rim cuts
# off the top of the head as they sink (DeSmuME too), the railing the head's upper side on arrival. The rim and the
# railing are BEHIND the walker in the world; only the sprite's depth test puts them in front. The fix leaves Pearl's
# look exactly as it is: the parts that stand in front of the walker's quad move AWAY from the camera, along its view
# direction (so each point stays where it is on screen, less than a pixel of perspective), until the sprite's depth
# test passes in front of them at every position of the walk (leaving and arriving, the camera catching up), in
# PEOPLE_STEP steps; every corner at a moved point moves with it (no polygon tears). One amount per corner per stair
# model from all its room placements. Moving away from the camera never hides anything that was in front of the
# moved part; the build's check (stair_check) confirms nothing that was behind it comes forward (on screen: no pixel
# changes) and nobody standing behind it shows through it. PEOPLE_FIX=none or STAIR_FIX=none: off.
STAIR_DIR = np.array([0.0, -PEOPLE_SIN, -PEOPLE_COS])   # the camera's view direction (away from the camera)
STAIR_K = 0.9635            # people's depth offset 0x136 / 4096 with near 1, far 1024 (pearl_rooms_view K_EXACT[0])
STAIR_MAX = 8.0             # at most this far (units); a part that needs more is pushed this far and reported
STAIR_MODELS = ('stair_',)  # Pearl's build models stair_u01/02, stair_d01/02 (the escalators stair_pc_* never stand
#                             at a stairs warp: none of the 133 feet)


def stair_off():
    import os
    return people_off() or os.environ.get('STAIR_FIX') == 'none'


def stair_excess(S, pos):
    """For sample points S (n, 3): units each stands in front of the sprite of a person at pos = (x, feet y, z,
    camera y: the camera's target less 4) beyond the depth the DS tests the sprite with (k STAIR_K less one depth
    step: melonDS and hardware, pearl_rooms_view 'hw'), where it lands on the sprite's silhouette, behind the feet or
    inside their own tile (within 6 units across) and above the floor-level pieces; 0 elsewhere."""
    x, fy, z, cy = pos[:4]
    S = np.asarray(S, float)
    A = np.array([x, fy - PEOPLE_ANCHOR, z]); eye = np.array([x, cy, z]) + PEOPLE_EYE
    f = STAIR_DIR; u = np.array([0.0, PEOPLE_COS, -PEOPLE_SIN])
    d = S - eye
    D = d @ f
    Ds = float(f @ (A - eye))
    q = eye + d * (Ds / np.maximum(D, 1e-3))[:, None]
    row = np.floor(32 - ((q - A) @ u) / 28.0 * 32).astype(int)
    col = np.abs(q[:, 0] - x) / 28.0 * 32
    margin = Ds * (1 - STAIR_K) - Ds * Ds / 32800.0
    near = (S[:, 2] < z - PEOPLE_BEHIND) | ((np.abs(S[:, 2] - z) <= PEOPLE_BEHIND) & (np.abs(S[:, 0] - x) < 6))
    ok = (row >= 0) & (row < 32) & near & (S[:, 1] > fy + PEOPLE_LOW) & (D > 1)
    ok &= col < np.array(PEOPLE_PROFILE, float)[np.clip(row, 0, 31)] - PEOPLE_EDGE
    return np.where(ok, np.maximum(Ds - D - margin, 0.0), 0.0)


def stair_pushes(model, positions):
    """({raw corner position: units to move away from the camera}, units left uncovered) for a stair model (a
    pearl_mesh.Model) and the walkers' positions in its frame [(x, feet y, z, camera y)]: each polygon that stands in
    front of a walker's sprite needs its largest excess (rounded up to PEOPLE_STEP, one more, at most STAIR_MAX), each corner the
    most any polygon at it needs."""
    ps = model.pos_scale / 4096
    need, left = {}, 0.0
    for it in items(model):
        if it.alpha == 0: continue
        S = _samples(it.P)
        e = max(float(stair_excess(S, p).max(initial=0.0)) for p in positions)
        if e <= 0: continue
        t = min(STAIR_MAX, math.ceil(e / PEOPLE_STEP) * PEOPLE_STEP + PEOPLE_STEP)   # (+ a step: the walking frames'
        #                                                     silhouette is not PEOPLE_PROFILE's to the pixel)
        left = max(left, e - t)
        for v in model.shapes[it.shape].groups[it.g][1][it.k]:
            need[v.pos] = max(need.get(v.pos, 0.0), t)
    return need, left


def _stair_apply(model, need):
    """Move every corner at a position of need = {raw position: units} away from the camera (STAIR_DIR)."""
    ps = model.pos_scale / 4096
    for s in model.shapes:
        for gi, (gt, polys) in enumerate(s.groups):
            for k, p in enumerate(polys):
                if not any(v.pos in need for v in p): continue
                polys[k] = [v.moved(*(int(round(v[i] + need[v.pos] * STAIR_DIR[i] / ps)) for i in range(3)))
                            if v.pos in need else v for v in p]


def stair_prop(bmd):
    """(new BMD0 bytes, 1 if changed) for a stair model: its parts in front of a stair walker moved away from the
    camera (stair_props)."""
    if stair_off(): return bmd, 0
    name = _model_name(bmd)
    if not name or not name.startswith(STAIR_MODELS): return bmd, 0
    need = stair_props().get(name, {}).get('need')
    if not need: return bmd, 0
    model = pearl_mesh.Model(bmd)
    _stair_apply(model, need)
    return model.encode(), 1


_STAIR_PROPS = None


def stair_placements():
    """{build model id: [(room chunk, prop index, the stairs (pearl_chunk.stairs_of entry) it stands on)]}: Pearl's
    stair models placed over a flight with a plane (the flight's centre within 24 units across, 16 along: as
    pearl_chunk.stairs_way finds them)."""
    import json, os
    import pearl_chunk
    root = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    world = json.load(open(os.path.join(root, 'data', 'sinnoh_world.json')))
    names = pearl_chunk.build_model_names()
    out = collections.defaultdict(list)
    for c in sorted(int(k) for k in world['rooms']['chunks']):
        land = json.load(open(os.path.join(pearl_chunk.LAND, f'{c:03d}.json')))
        idx = [k for k, pr in enumerate(land['props']) if names.get(pr['model'], '').startswith(STAIR_MODELS)]
        if not idx: continue
        stairs = [st for st in pearl_chunk.stairs_of(c, pearl_chunk._room_around(c)) if 'flight_y' in st]
        for k in idx:
            pr = land['props'][k]
            for st in stairs:
                fx = (st['foot'][0] + st['dx']) * 16 - 256 + 8
                fz = st['foot'][1] * 16 - 256 + 8
                if abs(pr['pos'][0] - fx) <= 24 and abs(pr['pos'][2] - fz) <= 16:
                    out[pr['model']].append((c, k, st))
    return out


def stair_props():
    """{stair model name: {need: {raw corner: units}, left: units, positions: n}}: the push each of Pearl's stair
    models needs for all its placements' stair walks (pearl_chunk.stair_walk, leaving and arriving), on the model as
    fix_building leaves it before stair_prop."""
    global _STAIR_PROPS
    if _STAIR_PROPS is not None: return _STAIR_PROPS
    import json, os
    import pearl_chunk, pearl_buildings
    from gen4rom import Rom, narc_members
    root = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    build = narc_members(Rom(os.path.join(root, 'roms', 'pearl.nds')).read('fielddata/build_model/build_model.narc'))
    out = {}
    for mid, places in sorted(stair_placements().items()):
        pos = []
        for c, k, st in places:
            land = json.load(open(os.path.join(pearl_chunk.LAND, f'{c:03d}.json')))
            px, py, pz = land['props'][k]['pos']
            walk = pearl_chunk.stair_walk(st)
            pos += [(x - px, y - py, z - pz, cy - py) for x, y, z, cy, d in walk['leaving'] + walk['arriving']]
        pos = sorted(set((round(a, 3), round(b, 3), round(c, 3), round(d, 3)) for a, b, c, d in pos))
        try:
            model = pearl_mesh.Model(fix_building(pearl_buildings.mdl_only(build[mid]), people=False)[0])
        except (AssertionError, IndexError, KeyError, struct.error):
            continue
        need, left = stair_pushes(model, pos)
        out[_model_name(build[mid])] = dict(need=need, left=round(left, 2), positions=len(pos),
                                            most=max(need.values(), default=0.0))
    _STAIR_PROPS = out
    return out
