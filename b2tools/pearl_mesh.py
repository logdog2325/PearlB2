"""Pearl's map models (BMD0 with one MDL0 model, no textures) as polygons, and back (the world pass, 2026-10-20).

    m = pearl_mesh.Model(bmd)                 # decode every shape's display list
    for s in m.shapes: s.material, s.polys    # polys: [[Vertex, ...] 3 or 4 corners, in drawing order], s.groups
    bmd2 = m.encode()                         # the same model with each shape's display list written from s.groups

Pearl's land models (work/pearl/land/*.nsbmd, 578 of them) have one model with one node; each shape is drawn after
its material by the render commands (SBC: MAT, SHP pairs) and uses only these display-list commands: COLOR, NORMAL,
TEXCOORD, VTX_16/10/XY/XZ/YZ/DIFF, BEGIN_VTXS (triangles, quads, triangle strips, quad strips), END_VTXS
(measured over all 578). A vertex keeps Pearl's raw numbers: position in model units * 4096 (before the model's
position scale, posScale 32, 64 or 128), texture coordinate in 1/16 texel, normal and colour as packed by the GX.

The DS draws a quad as one polygon (no diagonal edge), so polygons stay triangles and quads. A shape's groups are
(primitive type, [polygon]) runs; the writer emits a triangle/quad strip as a strip again when its polygons still
chain, else separate polygons, and every vertex command as short as the vertex before it allows (XY/XZ/YZ when one
coordinate repeats, DIFF within 511/4096, VTX_10 on 1/64 steps, else VTX_16). The first vertex of every shape is
absolute (the GX keeps the last vertex across shapes: b2tools/nsbmd_fix.py). A vertex takes the colour of the last
COLOR or NORMAL command before it (NORMAL: the lights' colour); in Pearl's models every vertex with a normal follows a
NORMAL (all 578 land models and the building models), so the writer sends the NORMAL again after every COLOR (Eterna
Gym 2026-10-25: a COLOR change with an unchanged normal left the grass on Pearl's unused black vertex colour, the
floor drew black). Re-encoding an unchanged model keeps
the same geometry (Model(encode()) == Model(bmd)); sizes come out within a few per cent of Pearl's.
"""
import struct

PARAMS = {0x00: 0, 0x20: 1, 0x21: 1, 0x22: 1, 0x23: 2, 0x24: 1, 0x25: 1, 0x26: 1, 0x27: 1, 0x28: 1, 0x40: 1, 0x41: 0}
TRIS, QUADS, TRI_STRIP, QUAD_STRIP = 0, 1, 2, 3


def _s(v, bits):
    v &= (1 << bits) - 1
    return v - (1 << bits) if v >> (bits - 1) else v


def _ndict(d, o):
    """NNSG3dResDict at o: [(data offset, name)]."""
    n = d[o + 1]
    e = o + struct.unpack_from('<H', d, o + 6)[0]
    unit = struct.unpack_from('<H', d, e)[0]
    names = e + 4 + unit * n
    return [(e + 4 + unit * i, bytes(d[names + 16 * i:names + 16 * i + 16]).rstrip(b'\0').decode('ascii', 'replace'))
            for i in range(n)]


class Vertex(tuple):
    """(x, y, z, s, t, normal, colour): raw GX values; normal/colour None when the shape never set them."""
    __slots__ = ()
    def __new__(cls, x, y, z, s, t, normal=None, colour=None):
        return tuple.__new__(cls, (x, y, z, s, t, normal, colour))
    pos = property(lambda v: (v[0], v[1], v[2]))
    def moved(self, x=None, y=None, z=None):
        return Vertex(self[0] if x is None else x, self[1] if y is None else y, self[2] if z is None else z, *self[3:])


def normal_vec(n):
    """Packed GX normal -> (x, y, z) floats."""
    return (_s(n, 10) / 512, _s(n >> 10, 10) / 512, _s(n >> 20, 10) / 512)


def lerp(a, b, f, pos=None):
    """The vertex at fraction f from a to b (texture coordinate and colour interpolated, normal the nearer one's),
    placed at pos (raw) when given."""
    if pos is None: pos = tuple(int(round(a[i] + f * (b[i] - a[i]))) for i in range(3))
    s = int(round(a[3] + f * (b[3] - a[3]))); t = int(round(a[4] + f * (b[4] - a[4])))
    n = a[5] if f < 0.5 else b[5]
    c = a[6]
    if a[6] is not None and b[6] is not None and a[6] != b[6]:
        c = 0
        for sh in (0, 5, 10):
            ca, cb = (a[6] >> sh) & 31, (b[6] >> sh) & 31
            c |= int(round(ca + f * (cb - ca))) << sh
    return Vertex(pos[0], pos[1], pos[2], s, t, n, c)


class Shape:
    def __init__(self, name, header_at, flags, groups, material):
        self.name, self.header_at, self.flags, self.groups, self.material = name, header_at, flags, groups, material

    @property
    def polys(self):
        return [p for _, ps in self.groups for p in ps]


def _group_polys(cur, verts):
    """The polygons of one BEGIN_VTXS run of vertices (or anything listed in the same order)."""
    if cur == TRIS: return [verts[k:k + 3] for k in range(0, len(verts) - 2, 3)]
    if cur == QUADS: return [verts[k:k + 4] for k in range(0, len(verts) - 3, 4)]
    if cur == TRI_STRIP:
        return [[verts[k], verts[k + 1], verts[k + 2]] if k % 2 == 0 else [verts[k + 1], verts[k], verts[k + 2]]
                for k in range(len(verts) - 2)]
    if cur == QUAD_STRIP:
        return [[verts[k], verts[k + 1], verts[k + 3], verts[k + 2]] for k in range(0, len(verts) - 3, 2)]
    return []


def _decode_dl(d, start, length, sources=None):
    """[(primitive type, [polygon])] of one display list. sources: a list that gets, per polygon, which command set
    each corner's colour last ('N' NORMAL: the lights, 'C' COLOR, None: neither)."""
    i, end = start, start + length
    pos = [0, 0, 0]; st = [0, 0]; nrm = None; col = None
    groups, cur, verts, srcs, last = [], None, [], [], None
    def close():
        if cur is None: return
        groups.append((cur, _group_polys(cur, verts)))
        if sources is not None: sources.extend(tuple(p) for p in _group_polys(cur, srcs))
    while i < end:
        cmds = d[i:i + 4]; i += 4
        for c in cmds:
            n = PARAMS.get(c)
            assert n is not None, f'display list command {c:#x} at {i:#x}'
            p = struct.unpack_from(f'<{n}I', d, i) if n else ()
            i += 4 * n
            if c == 0x20: col = p[0] & 0x7FFF; last = 'C'
            elif c == 0x21: nrm = p[0] & 0x3FFFFFFF; last = 'N'
            elif c == 0x22: st = [_s(p[0], 16), _s(p[0] >> 16, 16)]
            elif c in (0x23, 0x24, 0x25, 0x26, 0x27, 0x28):
                if c == 0x23: pos = [_s(p[0], 16), _s(p[0] >> 16, 16), _s(p[1], 16)]
                elif c == 0x24: pos = [_s(p[0], 10) << 6, _s(p[0] >> 10, 10) << 6, _s(p[0] >> 20, 10) << 6]
                elif c == 0x25: pos = [_s(p[0], 16), _s(p[0] >> 16, 16), pos[2]]
                elif c == 0x26: pos = [_s(p[0], 16), pos[1], _s(p[0] >> 16, 16)]
                elif c == 0x27: pos = [pos[0], _s(p[0], 16), _s(p[0] >> 16, 16)]
                else: pos = [_s(pos[k] + _s(p[0] >> (10 * k), 10), 16) for k in range(3)]
                verts.append(Vertex(pos[0], pos[1], pos[2], st[0], st[1], nrm, col)); srcs.append(last)
            elif c == 0x40:
                close(); cur = p[0] & 3; verts = []; srcs = []
            elif c == 0x41:
                close(); cur = None; verts = []; srcs = []
    close()
    return groups


def colour_sources(model):
    """[per shape: [per polygon: (source per corner)]] in s.polys order: 'N' when the corner's colour comes from a
    NORMAL command (the lights; emission alone in an unlit material), 'C' from a COLOR command, None neither."""
    out = []
    for s in model.shapes:
        _, _, _, off, ln = struct.unpack_from('<HHIII', model.data, s.header_at)
        src = []
        _decode_dl(model.data, s.header_at + off, ln, src)
        out.append(src)
    return out


class Model:
    def __init__(self, bmd):
        d = self.data = bytes(bmd)
        assert d[:4] == b'BMD0' and struct.unpack_from('<H', d, 0xE)[0] == 1, 'one MDL0 block expected'
        self.mdl = struct.unpack_from('<I', d, 0x10)[0]
        assert d[self.mdl:self.mdl + 4] == b'MDL0'
        ents = _ndict(d, self.mdl + 8)
        assert len(ents) == 1, 'one model expected'
        self.m = m = self.mdl + struct.unpack_from('<I', d, ents[0][0])[0]
        self.size, self.osbc, self.omat, self.oshp, self.oevp = struct.unpack_from('<5I', d, m)
        assert self.size == self.oevp, 'nothing expected after the display lists'
        self.pos_scale = struct.unpack_from('<i', d, m + 28)[0] / 4096
        mats = _ndict(d, m + self.omat + 4)
        self.materials = [name for _, name in mats]
        self.mat_at = [m + self.omat + struct.unpack_from('<I', d, at)[0] for at, _ in mats]
        shape_mat = self._sbc()
        self.shapes = []
        for k, (at, name) in enumerate(_ndict(d, m + self.oshp)):
            p = m + self.oshp + struct.unpack_from('<I', d, at)[0]
            _, _, flags, off, ln = struct.unpack_from('<HHIII', d, p)
            self.shapes.append(Shape(name, p, flags, _decode_dl(d, p + off, ln), shape_mat.get(k)))

    def _sbc(self):
        """{shape index: material index} from the render commands."""
        d, i, end = self.data, self.m + self.osbc, self.m + self.omat
        lens = {0: 1, 1: 1, 2: 3, 3: 2, 4: 2, 5: 2, 6: 4, 7: 2, 8: 2, 9: 0, 0xb: 1, 0xc: 3, 0xd: 3}
        mat, out = None, {}
        while i < end:
            c = d[i]; op = c & 0x1F
            if op == 1: break
            if op == 4: mat = d[i + 1]
            elif op == 5: out.setdefault(d[i + 1], mat)
            if op == 6:
                n = 4 + ((c >> 5) & 1) + ((c >> 6) & 1)
            elif op == 9:
                n = 3 + 2 * d[i + 2]
            else:
                n = lens.get(op, 1)
            i += n
        return out

    def shape_translations(self):
        """[(x, y, z) map units] per shape: the translation of the node it is drawn with (the render commands'
        NODEDESC / MTX before its SHP; a node's own translation plus its parents'). units() leaves it out: Pearl's
        land models draw on an untranslated root node, but for chunks 410 (Amity Square, the whole model 576 units
        north) and 417 (Floaroma Meadow, six shapes on nodes 528-632 east, 904-936 north) (2026-10-25). Rotation
        and scale of a node (none in Pearl's land models) are not applied."""
        d, base = self.data, self.m + 0x40              # (NNSG3dResNodeInfo, after the 20-byte header and MdlInfo)
        trans = []
        for at, _ in _ndict(d, base):
            p = base + struct.unpack_from('<I', d, at)[0]
            flag = struct.unpack_from('<H', d, p)[0]
            trans.append(tuple(v / 4096 for v in struct.unpack_from('<3i', d, p + 4)) if not flag & 1 else (0, 0, 0))
        world, stack, cur = {}, {}, None
        out = [None] * len(self.shapes)
        i, end = self.m + self.osbc, self.m + self.omat
        lens = {0: 1, 1: 1, 2: 3, 3: 2, 4: 2, 5: 2, 7: 2, 8: 2, 0xb: 1, 0xc: 3, 0xd: 3}
        while i < end:
            c = d[i]; op = c & 0x1F
            if op == 1: break
            if op == 6:                                    # NODEDESC node parent flags [dest] [src]
                node, parent = d[i + 1], d[i + 2]
                t, pt = trans[node] if node < len(trans) else (0, 0, 0), world.get(parent, (0, 0, 0))
                world[node] = t if node == parent else tuple(a + b for a, b in zip(t, pt))
                cur = node
                if c & 0x20: stack[d[i + 4]] = node
                i += 4 + ((c >> 5) & 1) + ((c >> 6) & 1)
                continue
            if op == 3: cur = stack.get(d[i + 1], cur)      # MTX: a stored node matrix back
            if op == 5 and d[i + 1] < len(out) and out[d[i + 1]] is None:
                out[d[i + 1]] = world.get(cur, (0, 0, 0)) if cur is not None else (0, 0, 0)
            i += (3 + 2 * d[i + 2]) if op == 9 else lens.get(op, 1)
        return [o or (0, 0, 0) for o in out]

    def poly_attr(self, mat_index):
        return struct.unpack_from('<I', self.data, self.mat_at[mat_index] + 12)[0]

    def units(self, v):
        """A vertex's position in map units (a tile is 16)."""
        return (v[0] * self.pos_scale / 4096, v[1] * self.pos_scale / 4096, v[2] * self.pos_scale / 4096)

    def raw(self, units):
        """Map units -> raw position step (inverse of units, per axis)."""
        return int(round(units * 4096 / self.pos_scale))

    def encode(self):
        """BMD0 bytes with every shape's display list written from its groups."""
        d, m = self.data, self.m
        shp = m + self.oshp
        first_dl = min(s.header_at + struct.unpack_from('<I', d, s.header_at + 8)[0] for s in self.shapes) \
            if self.shapes else m + self.oevp
        head = bytearray(d[:first_dl])
        dls = bytearray()
        lo = [32767] * 3; hi = [-32768] * 3
        for s in self.shapes:
            dl = encode_groups(s.groups)
            at = first_dl + len(dls)
            struct.pack_into('<II', head, s.header_at + 8, at - s.header_at, len(dl))
            dls += dl
            for p in s.polys:
                for v in p:
                    for k in range(3): lo[k] = min(lo[k], v[k]); hi[k] = max(hi[k], v[k])
        out = head + dls
        new_size = len(out) - m
        struct.pack_into('<II', out, m, new_size, struct.unpack_from('<I', out, m + 4)[0])
        struct.pack_into('<I', out, m + 16, new_size)                       # ofsEvpMtx: the model's end
        struct.pack_into('<I', out, self.mdl + 4, len(out) - self.mdl)        # MDL0 block size
        struct.pack_into('<I', out, 8, len(out))                              # file size
        self._grow_box(out, lo, hi)          # (the bounding box holds every vertex)
        return bytes(out)

    def _grow_box(self, out, lo, hi):
        """NNSG3dResMdlInfo box (x, y, z, w, h, d fx16 * boxPosScale) grown to cover [lo, hi] (raw positions)."""
        info = self.m + 20
        bx = list(struct.unpack_from('<6h', out, info + 24))
        bscale = struct.unpack_from('<i', out, info + 36)[0] / 4096
        ps = self.pos_scale
        def to_units(r): return r * ps / 4096
        x0, y0, z0 = (bx[k] * bscale / 4096 for k in range(3))
        x1, y1, z1 = x0 + bx[3] * bscale / 4096, y0 + bx[4] * bscale / 4096, z0 + bx[5] * bscale / 4096
        L = [to_units(v) for v in lo]; H = [to_units(v) for v in hi]
        nx0, ny0, nz0 = min(x0, L[0]), min(y0, L[1]), min(z0, L[2])
        nx1, ny1, nz1 = max(x1, H[0]), max(y1, H[1]), max(z1, H[2])
        if (nx0, ny0, nz0, nx1, ny1, nz1) == (x0, y0, z0, x1, y1, z1): return
        f = 4096 / bscale
        vals = [int(nx0 * f) - 1, int(ny0 * f) - 1, int(nz0 * f) - 1,
                int((nx1 - nx0) * f) + 2, int((ny1 - ny0) * f) + 2, int((nz1 - nz0) * f) + 2]
        if all(-32768 <= v <= 32767 for v in vals):
            struct.pack_into('<6h', out, info + 24, *vals)


def _chain(group_type, polys):
    """Vertex runs for polys as one strip of group_type, or None when they no longer chain."""
    if group_type == TRI_STRIP:
        if not polys or any(len(p) != 3 for p in polys): return None
        v = [polys[0][0], polys[0][1], polys[0][2]]
        for k, p in enumerate(polys[1:], 1):
            want = [v[k + 1], v[k], p[2]] if k % 2 else [v[k], v[k + 1], p[2]]
            if list(p) != want: return None
            v.append(p[2])
        return v
    if group_type == QUAD_STRIP:
        if not polys or any(len(p) != 4 for p in polys): return None
        v = [polys[0][0], polys[0][1], polys[0][3], polys[0][2]]
        for p in polys[1:]:
            if p[0] != v[-2] or p[1] != v[-1]: return None
            v += [p[3], p[2]]
        return v
    return None


def encode_groups(groups):
    """Display list bytes for [(primitive type, [polygon])] (strips kept where they still chain)."""
    words = []          # (command, [params])
    state = {'pos': None, 'st': None, 'n': None, 'c': None}
    def vertex(v):
        if v[6] is not None and v[6] != state['c']:
            words.append((0x20, [v[6]])); state['c'] = v[6]
            state['n'] = None   # (the GX colours a vertex by its last COLOR or NORMAL: the normal must follow again)
        if v[5] is not None and v[5] != state['n']:
            words.append((0x21, [v[5]])); state['n'] = v[5]
        if (v[3], v[4]) != state['st']:
            words.append((0x22, [(v[3] & 0xFFFF) | (v[4] & 0xFFFF) << 16])); state['st'] = (v[3], v[4])
        x, y, z = v[0], v[1], v[2]
        p = state['pos']
        if p is not None and z == p[2]:
            words.append((0x25, [(x & 0xFFFF) | (y & 0xFFFF) << 16]))
        elif p is not None and y == p[1]:
            words.append((0x26, [(x & 0xFFFF) | (z & 0xFFFF) << 16]))
        elif p is not None and x == p[0]:
            words.append((0x27, [(y & 0xFFFF) | (z & 0xFFFF) << 16]))
        elif p is not None and all(-512 <= (q - r) <= 511 for q, r in zip((x, y, z), p)):
            words.append((0x28, [((x - p[0]) & 0x3FF) | ((y - p[1]) & 0x3FF) << 10 | ((z - p[2]) & 0x3FF) << 20]))
        elif all(q % 64 == 0 and -512 <= q // 64 <= 511 for q in (x, y, z)):
            words.append((0x24, [((x // 64) & 0x3FF) | ((y // 64) & 0x3FF) << 10 | ((z // 64) & 0x3FF) << 20]))
        else:
            words.append((0x23, [(x & 0xFFFF) | (y & 0xFFFF) << 16, z & 0xFFFF]))
        state['pos'] = (x, y, z)
    for gtype, polys in groups:
        if not polys: continue
        run = _chain(gtype, polys)
        if run is not None:
            words.append((0x40, [gtype]))
            for v in run: vertex(v)
            words.append((0x41, []))
            continue
        for kind, size in ((TRIS, 3), (QUADS, 4)):
            ps = [p for p in polys if len(p) == size]
            if not ps: continue
            words.append((0x40, [kind]))
            for p in ps:
                for v in p: vertex(v)
            words.append((0x41, []))
    out = bytearray()
    for k in range(0, len(words), 4):
        pack = words[k:k + 4]
        cmds = [c for c, _ in pack] + [0] * (4 - len(pack))
        out += bytes(cmds)
        for _, ps in pack:
            out += struct.pack(f'<{len(ps)}I', *ps)
    return bytes(out)


# ------------------------------------------------------------------------------------------------ whole-model writer
# (2026-10-26, Black 2's water and grass on Pearl's maps, b2tools/b2_look.py) A model with materials and shapes added,
# renamed or re-bound: the render commands' MAT/SHP pairs, the material block (name dictionary, texture -> material
# and palette -> material dictionaries, their index lists, the records) and the shape block (dictionary, headers,
# display lists) written anew; everything before the render commands (file and MDL0 headers, model info, nodes) is
# kept but the counts, offsets and sizes. An unchanged model comes out byte for byte as it went in (checked over the
# 516 installed land models).
_SBC_LEN = {0: 1, 1: 1, 2: 3, 3: 2, 4: 2, 5: 2, 7: 2, 8: 2, 0xb: 1, 0xc: 3, 0xd: 3}




def sbc_commands(model):
    """[(opcode, command bytes)] of the model's render commands, up to and with RET."""
    d, i, end = model.data, model.m + model.osbc, model.m + model.omat
    cmds = []
    while i < end:
        c = d[i]; op = c & 0x1F
        n = (4 + ((c >> 5) & 1) + ((c >> 6) & 1)) if op == 6 else (3 + 2 * d[i + 2]) if op == 9 else _SBC_LEN.get(op, 1)
        cmds.append((op, d[i:i + n]))
        i += n
        if op == 1: break
    return cmds


def sbc_with(model, remap=None, extra=()):
    """The model's render commands with MAT parameters remapped ({old material: new}) and MAT/SHP pairs `extra`
    [(material, shape)] drawn after the last SHP (under the node state of the last shape: the land models' one node)."""
    cmds = sbc_commands(model)
    last = max(k for k, (op, _) in enumerate(cmds) if op == 5)
    out = bytearray()
    for k, (op, b) in enumerate(cmds):
        if op == 4 and remap and b[1] in remap: b = bytes((b[0], remap[b[1]])) + b[2:]
        out += b
        if k == last: out += b''.join(bytes((0x04, mi, 0x05, si)) for mi, si in extra)
    while len(out) % 4: out.append(0)
    return bytes(out)


def shape_names(model):
    return [name for _, name in _ndict(model.data, model.m + model.oshp)]


def raw_dl(model, k):
    """The display-list bytes of shape k as the file has them."""
    s = model.shapes[k]
    off, ln = struct.unpack_from('<II', model.data, s.header_at + 8)
    return model.data[s.header_at + off:s.header_at + off + ln]


def write_model(model, mats, shapes, sbc):
    """BMD0 bytes: model's headers and nodes with mats [{'name', 'rec' (material record bytes), 'tex', 'pal'}],
    shapes [{'name', 'flag', 'dl'}] and the render commands sbc (sbc_with)."""
    import nsbtx
    d, m = model.data, model.m
    # materials
    def by_name(key):
        order, users = [], {}
        for i, mt in enumerate(mats):
            n = mt.get(key)
            if n is None: continue
            if n not in users: order.append(n); users[n] = []
            users[n].append(i)
        return sorted(order, key=lambda n: n.encode('ascii')), users     # (the files' own order: by name)
    tex_order, tex_users = by_name('tex')
    pal_order, pal_users = by_name('pal')
    dummy = lambda names: nsbtx.dict_build([(n, bytes(4)) for n in names], 4)
    mat_dict_len = len(dummy([mt['name'] for mt in mats]))
    tex_dict_len, pal_dict_len = len(dummy(tex_order)), len(dummy(pal_order))
    o_tex = 4 + mat_dict_len; o_pal = o_tex + tex_dict_len; o_lists = o_pal + pal_dict_len
    lists, tex_ents, pal_ents = bytearray(), [], []
    for order, users, ents in ((tex_order, tex_users, tex_ents), (pal_order, pal_users, pal_ents)):
        for n in order:
            ents.append((n, struct.pack('<HBB', o_lists + len(lists), len(users[n]), 0)))
            lists += bytes(users[n])
    o_recs = o_lists + len(lists)
    o_recs += (-o_recs) % 4
    rec_at, recs = [], bytearray()
    for mt in mats:
        rec_at.append(o_recs + len(recs)); recs += mt['rec']
        while len(recs) % 4: recs.append(0)
    mat_dict = nsbtx.dict_build([(mt['name'], struct.pack('<I', a)) for mt, a in zip(mats, rec_at)], 4)
    matblock = bytearray(struct.pack('<HH', o_tex, o_pal) + mat_dict + nsbtx.dict_build(tex_ents, 4)
                         + nsbtx.dict_build(pal_ents, 4) + lists)
    while len(matblock) < o_recs: matblock.append(0)
    matblock += recs
    # shapes
    shp_dict_len = len(dummy([s['name'] for s in shapes]))
    heads_at = shp_dict_len
    dl_at = heads_at + 16 * len(shapes)
    heads, dls, ents = bytearray(), bytearray(), []
    for k, s in enumerate(shapes):
        h = heads_at + 16 * k
        ents.append((s['name'], struct.pack('<I', h)))
        heads += struct.pack('<HHIII', 0, 16, s['flag'], dl_at + len(dls) - h, len(s['dl']))
        dls += s['dl']
    shpblock = nsbtx.dict_build(ents, 4) + heads + dls
    # the model
    head = bytearray(d[:m + model.osbc])
    osbc = model.osbc
    omat = osbc + len(sbc); oshp = omat + len(matblock); oevp = oshp + len(shpblock)
    struct.pack_into('<5I', head, m, oevp, osbc, omat, oshp, oevp)
    head[m + 24] = len(mats); head[m + 25] = len(shapes)
    out = bytearray(head + sbc + matblock + shpblock)
    struct.pack_into('<I', out, model.mdl + 4, len(out) - model.mdl)
    struct.pack_into('<I', out, 8, len(out))
    def bounds(mo):
        lo, hi = [32767] * 3, [-32768] * 3
        for s in mo.shapes:
            for p in s.polys:
                for v in p:
                    for k in range(3): lo[k] = min(lo[k], v[k]); hi[k] = max(hi[k], v[k])
        return lo, hi
    new = Model(bytes(out))
    lo, hi = bounds(new)
    lo0, hi0 = bounds(model)
    if any(a < b for a, b in zip(lo, lo0)) or any(a > b for a, b in zip(hi, hi0)):
        new._grow_box(out, lo, hi)               # (only past the old vertices: an unchanged model keeps its box)
    return bytes(out)


def unchanged_parts(model):
    """(mats, shapes, pairs) of a model as write_model takes them, nothing changed."""
    import pearl_render
    info = pearl_render.bindings(model)
    mats = [{'name': n, 'rec': model.data[at:at + struct.unpack_from('<H', model.data, at + 2)[0]],
             'tex': info[i][0], 'pal': info[i][1]} for i, (n, at) in enumerate(zip(model.materials, model.mat_at))]
    names = shape_names(model)
    shapes = [{'name': names[k], 'flag': model.shapes[k].flags, 'dl': raw_dl(model, k)}
              for k in range(len(model.shapes))]
    return mats, shapes, sbc_with(model)
