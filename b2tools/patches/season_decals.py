"""Black 2's autumn leaves and winter snow patches on Sinnoh's overworld (user 2026-10-20: "blowing autumn leaves in
black 2 id love to implement and snow during the winter"; HoennB2's seasons2 port, its b2tools/terrain/seasons.py and
notes/SEASONS.md "Snow, autumn leaves and the grass"; here notes/MAP_LOOK.md "Seasons: grass, leaves and snow").
List it after sinnoh_world, sinnoh_reskin and sinnoh_rooms (it adds to the overworld chunks and texture sets they wrote).

What Black 2 does: in winter its routes get `kisetu_yuki` snow patches (A5I3 32x32 soft blob, clear in its spring,
summer and autumn sets): flat quads of 1 or 2 tiles square 2 units over the ground on about a tenth of the walkable
ground, mostly at the foot of trees, ledges and fences; in autumn its flower decals (kisetu_hana) show orange leaf
clusters, and Route 20's autumn chunks have falling leaves: long thin ribbons of `54_ha01` (four rows of yellow
leaves) 40-80 units up across the chunk, material `_ha01`, scrolled by Route 20's texture animation (a/0/6/8 file 47).
There is no falling-leaves weather (weathers 0-14).

Here, on every overworld chunk outside the north (Pearl area 14, snow all year), by HoennB2's rules: snow patches
(kisetu_yuki, 1 or 2 tiles square, chance by blocked neighbours P_SNOW), leaf clusters (`ochiba_h` = Black 2's
autumn kisetu_hana, one of its four clusters, on tiles next to a tree, P_LEAF), each on a level tile of plain grass,
lawn or sand path (Pearl's ngrass, lgreen, nsand) with nothing else over it (no tree, shadow, flower, ledge, sign) and
2.25 units over it (the world pass's 2-unit rule); Route 20's ribbons (data/season_ribbons.json, copied from
HoennB2: Black 2 chunks 290-293) over chunks with RIBBON_MIN_TREES tree tiles, 60-100 units over the highest ground and
6 over the highest tree top, cut at the chunk's edges. The decals are new materials and shapes in the chunk models
(add_shapes: the material, texture and palette dictionaries, the render commands and the shape list rebuilt; the
existing ones byte for byte). In the overworld areas' four texture sets: kisetu_yuki is Black 2's own of the season
(clear but in winter), `ochiba_h` and `_ha01` Black 2's autumn art in autumn and a clear 8x8 stand-in in the other
three (a missing name would draw white). The autumn area records name Route 20's texture animation (srt 47) for the
ribbons' `_ha01`; its other tracks name Black 2 materials, which Pearl's models do not have.
Seasons off (spring all year): every decal is clear, nothing else changes. Not copied: walk-through leaf piles and
snow footprints (tile classes 0x25 and 2 change the battle terrain all year). A chunk keeps its decals only while it
stays under CHUNK_MAX (Black 2's chunk buffer is 110,600 B with no length check): leaves go first, then ribbons, then
snow.
"""
import collections, hashlib, json, math, os, struct, sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, nsbtx, pearl_mesh  # noqa: E402
import pearl_model_fix as F  # noqa: E402
from b2files import gf_container, gf_container_build  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
NORTH_AREA = 14
DECAL_Y = F.GAP                       # over the ground (Black 2: 2; the world pass's rule: 2.25)
P_SNOW = (0.07, 0.30, 0.45)           # chance of a snow tile by its blocked neighbours (0, 1, 2+): Black 2's tenth
P_LEAF = 0.30                         # chance of a leaf tile next to a tree
RIBBON_MIN_TREES = 140                # tree tiles in a chunk (of 1024) for falling leaves (Route 20's: 180-420)
RIBBON_LOW, RIBBON_SPAN, RIBBON_TREE_CLEAR = 60, 40, 6
GROUND_OK = {'ngrass', 'lgreen', 'nsand'}
CHUNK_MAX = 104000                    # (the world pass keeps chunks under 100,000; the hard limit is 110,600)
UP = 511 << 10                        # GX packed normal (0, 1, 0)
SNOW = 'kisetu_yuki'
# name -> (season it shows in, Black 2 set, Black 2 texture, its palette, size, repeat): texture sets
SEASONAL = {'ochiba_h': (2, 4, 'kisetu_hana', 'kisetu_hana_pl', (32, 32), False),
            '_ha01': (2, 216, '54_ha01', '54_ha01_pl', (128, 64), True)}
SNOW_ART = (SNOW, 'kisetu_yuki_pl', (32, 32), False)   # Black 2's own in each season's set (2 + season)
AUTUMN_SRT = 47


def _rnd(*k):
    return int.from_bytes(hashlib.md5(repr(k).encode()).digest()[:4], 'little') / 2 ** 32


# ------------------------------------------------------------------------------------------- model: add shapes
def _base(name):
    return name.rsplit('_lm', 1)[0] if '_lm' in name else name


def add_shapes(bmd, adds):
    """BMD0 with new materials and shapes: adds = [(material name, texture, palette, 44-byte material record,
    groups)] (groups: pearl_mesh (primitive, [polygon]) runs). The model's material, texture and palette
    dictionaries, render commands and shape list are rebuilt around the existing ones (kept byte for byte; existing
    indices unchanged); each new material is drawn after the existing shapes, before the render commands end."""
    if not adds: return bmd
    M = pearl_mesh.Model(bmd)
    d, m = M.data, M.m
    mat0, shp0 = m + M.omat, m + M.oshp
    # render commands: MAT/SHP pairs go before the closing inverse scale (0x2b) and RET
    sbc = bytearray(d[m + M.osbc:mat0])
    i, ret = 0, None
    lens = {0: 1, 1: 1, 2: 3, 3: 2, 4: 2, 5: 2, 6: 4, 7: 2, 8: 2, 9: 0, 0xb: 1, 0xc: 3, 0xd: 3}
    cmds = []
    while i < len(sbc):
        c = sbc[i]; op = c & 0x1F
        if op == 1: ret = i; break
        n = 4 + ((c >> 5) & 1) + ((c >> 6) & 1) if op == 6 else (3 + 2 * sbc[i + 2] if op == 9 else lens.get(op, 1))
        cmds.append(i); i += n
    assert ret is not None, 'no RET in the render commands'
    at = cmds[-1] if cmds and sbc[cmds[-1]] & 0x1F == 0xb and cmds[-1] + 1 == ret else ret
    nm, ns = len(M.materials), len(M.shapes)
    assert nm + len(adds) < 256 and ns + len(adds) < 256
    ins = b''.join(bytes((0x04, nm + k, 0x05, ns + k)) for k in range(len(adds)))
    sbc = sbc[:at] + ins + sbc[at:ret + 1]
    while len(sbc) % 4: sbc.append(0)
    # materials: header, material dict, texture and palette dicts, index lists, records
    tex_d, pal_d = struct.unpack_from('<HH', d, mat0)
    def by_name(off):
        out = collections.OrderedDict()
        for at_, name in pearl_mesh._ndict(d, mat0 + off):
            o, n = struct.unpack_from('<HB', d, at_)
            out[name] = [d[mat0 + o + j] for j in range(n)]
        return out
    texs, pals = by_name(tex_d), by_name(pal_d)
    recs = []
    for k, a in enumerate(M.mat_at):
        size = struct.unpack_from('<H', d, a + 2)[0]
        recs.append(bytes(d[a:a + size]))
    names = list(M.materials)
    for k, (mname, tname, pname, rec, _) in enumerate(adds):
        assert len(mname) <= 16 and mname not in names, mname
        names.append(mname); recs.append(bytes(rec))
        texs.setdefault(tname, []).append(nm + k)
        if pname: pals.setdefault(pname, []).append(nm + k)
    zero = lambda n: [(nm_, bytes(4)) for nm_ in n]
    dm, dt, dp = (len(nsbtx.dict_build(zero(x), 4)) for x in (names, list(texs), list(pals)))
    o_dt = 4 + dm; o_dp = o_dt + dt; o_lists = o_dp + dp
    lists, list_at = bytearray(), {}
    for which, table in (('t', texs), ('p', pals)):
        for name, idx in table.items():
            list_at[(which, name)] = o_lists + len(lists); lists += bytes(idx)
    while (o_lists + len(lists)) % 4: lists.append(0)
    o_recs = o_lists + len(lists)
    rec_at, pos = [], o_recs
    for r in recs: rec_at.append(pos); pos += len(r)
    mat = bytearray(struct.pack('<HH', o_dt, o_dp))
    mat += nsbtx.dict_build([(n_, struct.pack('<I', rec_at[k])) for k, n_ in enumerate(names)], 4)
    mat += nsbtx.dict_build([(n_, struct.pack('<HBB', list_at[('t', n_)], len(ix), 0)) for n_, ix in texs.items()], 4)
    mat += nsbtx.dict_build([(n_, struct.pack('<HBB', list_at[('p', n_)], len(ix), 0)) for n_, ix in pals.items()], 4)
    assert len(mat) == o_lists, (len(mat), o_lists)
    mat += lists + b''.join(recs)
    while len(mat) % 4: mat.append(0)
    # shapes: dict, 16-byte records, display lists (each record's offset is from the record)
    old = [bytes(d[s.header_at:s.header_at + 16]) for s in M.shapes]
    old_dl = [bytes(d[s.header_at + struct.unpack_from('<I', d, s.header_at + 8)[0]:
                      s.header_at + struct.unpack_from('<I', d, s.header_at + 8)[0]
                      + struct.unpack_from('<I', d, s.header_at + 12)[0]]) for s in M.shapes]
    snames = [s.name for s in M.shapes] + [f'season{k}' for k in range(len(adds))]
    new_dl = [pearl_mesh.encode_groups(g) for *_, g in adds]
    flags = struct.unpack_from('<I', old[0], 4)[0] if old else 5
    recs_s = old + [struct.pack('<HHIII', 0, 16, flags, 0, 0) for _ in adds]
    dls = old_dl + new_dl
    ds = len(nsbtx.dict_build(zero(snames), 4))
    o_rec = ds
    shp = bytearray(nsbtx.dict_build([(n_, struct.pack('<I', o_rec + 16 * k)) for k, n_ in enumerate(snames)], 4))
    body = bytearray(b''.join(recs_s))
    dl_blob, o_dl = bytearray(), o_rec + len(body)
    for k, dl in enumerate(dls):
        here = o_dl + len(dl_blob)
        struct.pack_into('<II', body, 16 * k + 8, here - (o_rec + 16 * k), len(dl))
        dl_blob += dl
        while len(dl_blob) % 4: dl_blob.append(0)
    shp += body + dl_blob
    # the model: header and info and nodes as they were, then the new parts
    head = bytearray(d[m:m + M.osbc])
    o_sbc = len(head); o_mat = o_sbc + len(sbc); o_shp = o_mat + len(mat); size = o_shp + len(shp)
    struct.pack_into('<5I', head, 0, size, o_sbc, o_mat, o_shp, size)
    head[20 + 4] = nm + len(adds); head[20 + 5] = ns + len(adds)
    out = bytearray(d[:m]) + head + sbc + mat + shp
    struct.pack_into('<I', out, M.mdl + 4, len(out) - M.mdl)
    struct.pack_into('<I', out, 8, len(out))
    return pearl_mesh.Model(bytes(out)).encode()      # (re-read; the bounding box grows over the new shapes)


# -------------------------------------------------------------------------------------------- where decals go
def _inside(P, x, z):
    """Point (x, z) inside polygon P (its x/z), edges included."""
    xs, zs = P[:, 0], P[:, 2]
    s = None
    for i in range(len(P)):
        j = (i + 1) % len(P)
        c = (xs[j] - xs[i]) * (z - zs[i]) - (zs[j] - zs[i]) * (x - xs[i])
        if abs(c) < 1e-6: continue
        if s is None: s = c > 0
        elif (c > 0) != s: return False
    return True


def _y_at(it, x, z):
    n = it.n
    if abs(n[1]) < 1e-6: return float(it.P[:, 1].max())
    return float((it.d - n[0] * x - n[2] * z) / n[1])


class Tiles:
    """What covers each of a chunk's 32 x 32 tiles (model units: tile (tx, tz) spans x tx*16-256 .. tx*16-240)."""
    def __init__(self, model):
        self.its = [it for it in F.items(model) if it.alpha > 0]
        self.grid = collections.defaultdict(list)
        for k, it in enumerate(self.its):
            x0, x1 = it.P[:, 0].min(), it.P[:, 0].max(); z0, z1 = it.P[:, 2].min(), it.P[:, 2].max()
            for tz in range(max(0, int((z0 + 256) // 16)), min(32, int((z1 + 256) // 16) + 1)):
                for tx in range(max(0, int((x0 + 256) // 16)), min(32, int((x1 + 256) // 16) + 1)):
                    self.grid[(tx, tz)].append(k)

    def hits(self, tx, tz, x, z):
        out = []
        for k in self.grid.get((tx, tz), ()):
            it = self.its[k]
            if _inside(it.P, x, z): out.append((_y_at(it, x, z), it))
        return out

    def ground(self, tx, tz):
        """(y, base material) of a level tile whose every sample shows the same flat ground with nothing above it,
        else None."""
        y0 = mat = None
        for fx in (0.15, 0.5, 0.85):
            for fz in (0.15, 0.5, 0.85):
                x, z = tx * 16 - 256 + 16 * fx, tz * 16 - 256 + 16 * fz
                h = self.hits(tx, tz, x, z)
                if not h: return None
                y, it = max(h, key=lambda t: t[0])
                if F.is_tree(it.mat) or not F.is_ground(it) or it.n[1] < F.FLAT: return None
                if any(F.is_tree(o.mat) for _, o in h): return None          # (tree tops over it)
                b = _base(it.mat)
                if y0 is None: y0, mat = y, b
                elif b != mat or abs(y - y0) > 0.1: return None
        return (y0, mat) if mat in GROUND_OK else None

    def tree(self, tx, tz):
        if not (0 <= tx < 32 and 0 <= tz < 32): return False
        x, z = tx * 16 - 248, tz * 16 - 248
        return any(F.is_tree(it.mat) for _, it in self.hits(tx, tz, x, z))


def plan(model, land, cx, cz, ribbons_tpl):
    """(snow quads, leaf quads, ribbon triangles) of one overworld chunk (model units, ground-level y + DECAL_Y)."""
    T = Tiles(model)
    col = land['collision']
    ok = {}
    for tz in range(32):
        for tx in range(32):
            if col[tz][tx] == 0 and land['behaviour'][tz][tx] == 0:
                g = T.ground(tx, tz)
                if g: ok[(tx, tz)] = g[0]
    trees = {(tx, tz) for tz in range(32) for tx in range(32) if T.tree(tx, tz)}
    near = lambda tx, tz: any((tx + a, tz + b) in trees for a in (-1, 0, 1) for b in (-1, 0, 1) if a or b)
    def blocked(tx, tz):
        return sum(1 for a in (-1, 0, 1) for b in (-1, 0, 1) if (a or b) and not (0 <= tx + a < 32 and 0 <= tz + b < 32
                                                                              and col[tz + b][tx + a] == 0))
    X, Z = cx * 32, cz * 32
    used, leaf, snow = set(), [], []
    for (tx, tz), y in sorted(ok.items()):
        if near(tx, tz) and _rnd('leaf', X + tx, Z + tz) < P_LEAF:
            q = int(_rnd('leafq', X + tx, Z + tz) * 4)
            leaf.append((tx, tz, 1, y, q)); used.add((tx, tz))
    for (tx, tz), y in sorted(ok.items()):
        if (tx, tz) in used or _rnd('snow', X + tx, Z + tz) >= P_SNOW[min(blocked(tx, tz), 2)]: continue
        sq = [(tx + a, tz + b) for a in (0, 1) for b in (0, 1)]
        big = (_rnd('snow2', X + tx, Z + tz) < 0.45 and all(t in ok and t not in used and abs(ok[t] - y) < 0.1
                                                             for t in sq))
        for t in (sq if big else [(tx, tz)]): used.add(t)
        snow.append((tx, tz, 2 if big else 1, y, 0))
    ribbons = []
    if len(trees) >= RIBBON_MIN_TREES and ribbons_tpl:
        walk = [y for y in ok.values()] or [0.0]
        ground_top = max(walk)
        tree_top = max((float(it.P[:, 1].max()) for it in T.its if F.is_tree(it.mat)), default=ground_top)
        low = max(ground_top + RIBBON_LOW, tree_top + RIBBON_TREE_CLEAR)
        t = ribbons_tpl[(cx * 3 + cz * 5) % len(ribbons_tpl)]
        n = len(t['tris']) // 2
        for i, tri in enumerate(t['tris']):
            y = low + (i // 2) * RIBBON_SPAN / max(1, n - 1)
            poly = [(x, y, z, u, v) for x, _, z, u, v in tri]
            for k in (0, 2):
                poly = _clip(poly, k, 256, True)
                poly = _clip(poly, k, -256, False) if poly else poly
            for j in range(1, len(poly) - 1):
                ribbons.append([poly[0], poly[j], poly[j + 1]])
    return snow, leaf, ribbons


def _clip(poly, k, lim, keep_below):
    """Sutherland-Hodgman (HoennB2 terrain/seasons.py): the part of convex poly (x, y, z, u, v) with coordinate k
    <= lim (or >=)."""
    inside = (lambda p: p[k] <= lim) if keep_below else (lambda p: p[k] >= lim)
    out = []
    for i, cur in enumerate(poly):
        prev = poly[i - 1]
        if inside(cur):
            if not inside(prev):
                f = (lim - prev[k]) / (cur[k] - prev[k]); out.append(tuple(a + (b - a) * f for a, b in zip(prev, cur)))
            out.append(cur)
        elif inside(prev):
            f = (lim - prev[k]) / (cur[k] - prev[k]); out.append(tuple(a + (b - a) * f for a, b in zip(prev, cur)))
    return out


def _vertex(model, x, y, z, s, t):
    r = model.raw
    return pearl_mesh.Vertex(r(x), r(y), r(z), int(round(s * 16)), int(round(t * 16)), UP, None)


def decal_groups(model, snow, leaf, ribbons):
    """{material: groups} for the planned decals (texture coordinates in texels: kisetu_yuki whole, a quarter of
    kisetu_hana per leaf tile, the ribbons' u/v over 128 x 64)."""
    out = {}
    def quads(items, size, quarter):
        qs = []
        for tx, tz, w, y, q in items:
            x0, z0 = tx * 16 - 256, tz * 16 - 256
            x1, z1 = x0 + 16 * w, z0 + 16 * w
            yy = y + DECAL_Y
            if quarter:
                s0, t0 = (q & 1) * 16, (q >> 1) * 16; s1, t1 = s0 + 16, t0 + 16
            else:
                s0, t0, s1, t1 = 0, 0, size, size
            qs.append([_vertex(model, x0, yy, z1, s0, t1), _vertex(model, x1, yy, z1, s1, t1),
                       _vertex(model, x1, yy, z0, s1, t0), _vertex(model, x0, yy, z0, s0, t0)])
        return [(pearl_mesh.QUADS, qs)] if qs else []
    if snow: out[SNOW] = quads(snow, 32, False)
    if leaf: out['ochiba_h'] = quads(leaf, 32, True)
    if ribbons:
        out['_ha01'] = [(pearl_mesh.TRIS, [[_vertex(model, x, y, z, u * 128, v * 64) for x, y, z, u, v in tri]
                                           for tri in ribbons])]
    return out


def material_record(model, tex, size, repeat):
    """A decal's material: the chunk's own grass material (its lighting set-up, so the decal is lit as the ground
    under it) with the decal texture's size, clamp or repeat."""
    k = next((i for i, n in enumerate(model.materials) if _base(n) == 'ngrass'), None)
    if k is None:
        k = next(i for i, n in enumerate(model.materials) if not F.is_tree(n))
    a = model.mat_at[k]
    rec = bytearray(model.data[a:a + 44])
    struct.pack_into('<I', rec, 20, 0x00030000 if repeat else 0)              # texImageParam: repeat s and t
    struct.pack_into('<HH', rec, 32, *size)                                   # original width, height
    struct.pack_into('<ii', rec, 36, 0x1000, 0x1000)                          # magnification 1
    return bytes(rec)


def decorate(bmd, land, cx, cz, ribbons_tpl, budget=CHUNK_MAX):
    """(new BMD0, (snow, leaf, ribbon) counts kept) for one overworld chunk; leaves, then ribbons, then snow are
    dropped when the chunk container would pass budget (checked by the caller with the whole container)."""
    M = pearl_mesh.Model(bmd)
    snow, leaf, ribbons = plan(M, land, cx, cz, ribbons_tpl)
    arts = {SNOW: SNOW_ART[2:], 'ochiba_h': SEASONAL['ochiba_h'][4:], '_ha01': SEASONAL['_ha01'][4:]}
    pal = {SNOW: SNOW_ART[1], 'ochiba_h': 'ochiba_h_pl', '_ha01': '_ha01_pl'}
    def build(keep):
        groups = decal_groups(M, *(x if k in keep else [] for k, x in zip(('snow', 'leaf', 'ribbon'),
                                                                         (snow, leaf, ribbons))))
        adds = [(name, name, pal[name], material_record(M, name, *arts[name]), g) for name, g in groups.items()]
        return add_shapes(bmd, adds)
    for keep in (('snow', 'leaf', 'ribbon'), ('snow', 'ribbon'), ('snow',), ()):
        new = build(keep)
        if len(new) - len(bmd) <= budget:
            return new, tuple(len(x) if k in keep else 0 for k, x in zip(('snow', 'leaf', 'ribbon'), (snow, leaf, ribbons)))
    return bmd, (0, 0, 0)


# ------------------------------------------------------------------------------------------------ texture sets
def clear_source(name, w=8, h=8):
    """A one-texture BTX0 (16 colours, colour 0 transparent, every texel 0: the DS draws nothing for it) named name
    with palette name_pl (HoennB2 hoenn_textures.clear_source, as a BTX0 for nsbtx.merge)."""
    params = (((w // 8).bit_length() - 1) << 20) | (((h // 8).bit_length() - 1) << 23) | (3 << 26) | (1 << 29)
    texdata, pdata = bytes(w * h // 2), bytes(32)
    tdict = nsbtx.dict_build([(name, struct.pack('<II', params, 0x80000000 | w | (h << 11)))], 8)
    pdict = nsbtx.dict_build([(name + '_pl', struct.pack('<HH', 0, 0))], 4)
    o_tdict = 0x3C; o_pdict = o_tdict + len(tdict); o_tex = o_pdict + len(pdict)
    o_c = o_tex + len(texdata); o_p = o_c
    hdr = bytearray(0x3C)
    hdr[0:4] = b'TEX0'
    struct.pack_into('<I', hdr, 4, o_p + len(pdata))
    struct.pack_into('<HH', hdr, 0xC, len(texdata) >> 3, o_tdict); struct.pack_into('<I', hdr, 0x14, o_tex)
    struct.pack_into('<HH', hdr, 0x1C, 0, o_tdict); struct.pack_into('<II', hdr, 0x24, o_c, o_c)
    struct.pack_into('<HH', hdr, 0x30, len(pdata) >> 3, 0); struct.pack_into('<H', hdr, 0x34, o_pdict)
    struct.pack_into('<I', hdr, 0x38, o_p)
    block = bytes(hdr) + tdict + pdict + texdata + pdata
    head = bytearray(b'BTX0' + struct.pack('<HHIHH', 0xFEFF, 1, 0x14 + len(block), 0x10, 1) + struct.pack('<I', 0x14))
    return bytes(head) + block


def add_textures(sets, group):
    """The decal textures in an overworld area group's four sets (group + season)."""
    b2 = narcio.load(VANILLA, 14)
    for s in range(4):
        adds = [(b2[2 + s], SNOW, SNOW_ART[1])]
        for name, (shown, ts, src, spal, size, _) in sorted(SEASONAL.items()):
            if s == shown: adds.append((b2[ts], src, spal, name, name + '_pl'))
            else: adds.append((clear_source(name), name, name + '_pl'))
        have = {n for n, _ in nsbtx._parse(sets[group + s])['texs']}
        adds = [a for a in adds if (a[3] if len(a) > 3 else a[1]) not in have]
        if adds: sets[group + s] = nsbtx.merge(sets[group + s], adds)


# ------------------------------------------------------------------------------------------------------ apply
def apply(files):
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    tpl = json.load(open(os.path.join(ROOT, 'data', 'season_ribbons.json')))['chunks']
    m0 = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    zones = {int(k): v for k, v in world['zones'].items()}
    chunk_ids = {int(k): v for k, v in world['chunks'].items()}
    cells = {}                                    # Pearl chunk -> (cx, cz, Pearl area) of its first cell
    for cz in range(m0['height']):
        for cx in range(m0['width']):
            c, h = m0['maps'][cz][cx], m0['headers'][cz][cx]
            if c != 0xffff and h in zones and c in chunk_ids: cells.setdefault(c, (cx, cz, zones[h]['pearl_area']))
    chunks = narcio.load(files, 8)
    tot = [0, 0, 0]; n_chunks = 0; over = []
    for c, (cx, cz, pa) in sorted(cells.items()):
        if pa == NORTH_AREA: continue
        b2 = chunk_ids[c]
        magic, secs = gf_container(chunks[b2])
        land = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))
        room = CHUNK_MAX - len(chunks[b2])
        new, kept = decorate(secs[0], land, cx, cz, tpl, budget=room)
        if new is not secs[0] and new != secs[0]:
            chunks[b2] = gf_container_build(magic, [new] + secs[1:])
            n_chunks += 1
        if room < 0: over.append(c)
        for k in range(3): tot[k] += kept[k]
    narcio.save(files, 8, chunks)
    sets = narcio.load(files, 14)
    groups = sorted(a['b2_area_group'] for pa, a in world['areas'].items() if int(pa) != NORTH_AREA)
    for g in groups: add_textures(sets, g)
    narcio.save(files, 14, sets)
    path = os.path.join(files, 'a', '0', '1', '3')
    raw = bytearray(open(path, 'rb').read())
    for g in groups:
        raw[(g + 2) * 10 + 4] = AUTUMN_SRT          # autumn: Route 20's texture animation (the ribbons' _ha01)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(raw); os.replace(path + '.tmp', path)
    return (f'season_decals: {tot[0]} snow patches, {tot[1]} leaf clusters, {tot[2]} falling-leaf ribbon triangles in '
            f'{n_chunks} overworld chunks (not the north); textures in {len(groups)} area groups\' sets; autumn srt '
            f'{AUTUMN_SRT}; chunks already over {CHUNK_MAX} B (no decals): {over}')
