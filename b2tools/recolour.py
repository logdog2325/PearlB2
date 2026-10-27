"""Palette recolouring (the project's art rule: recolour palettes, never redraw): Pearl art drawn with Black 2's
colours, by brightness rank.

    ramp_recolour(pearl_palette_bytes, black2_colours) -> palette bytes

Each Pearl colour (BGR555, colour 0 kept: it is transparent in palettes with that flag) takes the Black 2 colour at
the same brightness quantile. black2_colours: the colours a Black 2 texture really uses (used_colours()).

    transfer_recolour(pearl_palette_bytes, anchor_pairs(pearl_counts, black2_counts)) -> palette bytes

The map-look version (patches/sinnoh_reskin.py, notes/MAP_LOOK.md): each Pearl colour takes the Black 2 colour of
the same kind (grass, sand/bark, water, grey: colour_class) at Pearl's relative brightness.
"""
import struct


def rgb(c):
    return (c & 31) * 255 // 31, (c >> 5 & 31) * 255 // 31, (c >> 10 & 31) * 255 // 31


def luma(c):
    r, g, b = rgb(c)
    return 0.299 * r + 0.587 * g + 0.114 * b


def used_colours(parsed, tex, pal):
    """BGR555 colours a texture of a parsed set (nsbtx._parse) really uses, sorted by brightness."""
    import nsbtx
    params = dict(parsed['texs'])[tex][0]
    fmt = (params >> 26) & 7
    raw, _ = nsbtx._tex_bytes(parsed, params)
    o = dict(parsed['pals'])[pal][0] << 3
    psize = nsbtx._pal_size(parsed, pal)
    palette = struct.unpack_from(f'<{psize // 2}H', parsed['pdata'], o)
    if fmt == 3:   idx = [b >> s & 15 for b in raw for s in (0, 4)]
    elif fmt == 2: idx = [b >> s & 3 for b in raw for s in (0, 2, 4, 6)]
    elif fmt == 4: idx = list(raw)
    elif fmt == 1: idx = [b & 31 for b in raw]           # A3I5
    elif fmt == 6: idx = [b & 7 for b in raw]            # A5I3
    else: return []
    first = 1 if (params >> 29) & 1 else 0               # colour 0 transparent
    cols = {palette[i] for i in idx if i >= first and i < len(palette)}
    return sorted(cols, key=luma)


def colour_counts(parsed, tex, pal):
    """{BGR555 colour: texels} a texture of a parsed set draws (colour 0 left out where it is transparent, invisible
    texels of the alpha formats left out)."""
    import nsbtx
    from collections import Counter
    params = dict(parsed['texs'])[tex][0]
    fmt = (params >> 26) & 7
    raw, _ = nsbtx._tex_bytes(parsed, params)
    o = dict(parsed['pals'])[pal][0] << 3
    palette = struct.unpack_from(f'<{nsbtx._pal_size(parsed, pal) // 2}H', parsed['pdata'], o)
    if fmt == 3:   idx = [b >> s & 15 for b in raw for s in (0, 4)]
    elif fmt == 2: idx = [b >> s & 3 for b in raw for s in (0, 2, 4, 6)]
    elif fmt == 4: idx = list(raw)
    elif fmt == 1: idx = [b & 31 for b in raw if b >> 5]       # A3I5: only texels with some alpha
    elif fmt == 6: idx = [b & 7 for b in raw if b >> 3]        # A5I3
    else: return Counter()
    first = 1 if (params >> 29) & 1 else 0
    return Counter(palette[i] for i in idx if first <= i < len(palette))


def colour_class(c):
    """What a BGR555 colour paints: 'grey' (outlines, shade, white), 'warm' (sand, bark, soil, cream), 'blue' (water)
    or 'green' (grass, leaves). transfer_recolour pairs a Pearl colour only with an anchor of the same kind."""
    r, g, b = c & 31, c >> 5 & 31, c >> 10 & 31
    if max(r, g, b) - min(r, g, b) <= 2: return 'grey'
    if r >= g and r - b >= 3: return 'warm'
    if b > g + 2: return 'blue'          # (Black 2's teal trees, b up to g + 2, are leaves, not water)
    return 'green'


def anchors(counts):
    """{class: the class's most used colour} of {colour: texels}."""
    best = {}
    for c, n in counts.items():
        k = colour_class(c)
        if n > best.get(k, (0, 0))[1]: best[k] = (c, n)
    return {k: c for k, (c, _) in best.items()}


def anchor_pairs(pearl_counts, black2_counts, black2_more=None):
    """[(Pearl colour, Black 2 colour)] for transfer_recolour: per kind of colour (colour_class) each side's most used
    one; Black 2's from its main texture first (black2_counts: the trees' bodies, the tall grass's leaves), from the
    composite's other textures (black2_more) for kinds the main one lacks. If Black 2 has none of Pearl's main kind
    (Pearl's green leaves, Black 2's all-orange autumn trees), that kind pairs with Black 2's main kind; Pearl's other
    kinds Black 2 lacks get no pair (transfer_recolour takes the nearest anchor for them)."""
    from collections import Counter
    union = Counter(black2_counts) + Counter(black2_more or {})
    p, b = anchors(pearl_counts), anchors(black2_counts)
    for k, c in anchors(union).items(): b.setdefault(k, c)
    if not p or not b: return []
    def texels(counts, k): return sum(n for c, n in counts.items() if colour_class(c) == k)
    p_main = max(p, key=lambda k: texels(pearl_counts, k))
    b_main = max(b, key=lambda k: texels(union, k))
    return [(p[k], b[k] if k in b else b[b_main]) for k in p if k in b or k == p_main]


def _luma5(c):
    return 0.299 * (c & 31) + 0.587 * (c >> 5 & 31) + 0.114 * (c >> 10 & 31)


def _dist(a, b):
    return sum(((a >> s & 31) - (b >> s & 31)) ** 2 for s in (0, 5, 10))


def transfer_recolour(pal_bytes, pairs, keep_first=True, only_matching=False):
    """pairs: [(Pearl anchor colour, Black 2 anchor colour)] (anchor_pairs(), plus the ground's and an edge's own
    interior). Each Pearl colour takes the nearest Pearl anchor of the same kind (colour_class; the nearest of all if
    none is of its kind) and becomes that anchor's Black 2 colour, made as much lighter or darker as the Pearl colour
    is than the Pearl anchor: Black 2's hue with Pearl's shading. Shadows, highlights, outlines and trunks keep their
    contrast, and a Pearl colour that IS an anchor turns into exactly its Black 2 colour (a path edge's grass meets
    the ground's grass without a seam). keep_first: palette entry 0 is transparent (left as it is). only_matching:
    a colour with no anchor of its kind stays Pearl's (flower petals on a recoloured grass tile)."""
    if not pairs: return pal_bytes
    n = len(pal_bytes) // 2
    cols = list(struct.unpack(f'<{n}H', pal_bytes))
    out = list(cols)
    for i in range(1 if keep_first else 0, n):
        c = cols[i]
        same = [q for q in pairs if colour_class(q[0]) == colour_class(c)]
        if not same and only_matching: continue
        same = same or pairs
        p, b = min(same, key=lambda q: _dist(c, q[0]))
        ratio = min(3.0, max(0.2, _luma5(c) / max(0.5, _luma5(p))))
        r, g, bl = (min(31, round((b >> s & 31) * ratio)) for s in (0, 5, 10))
        out[i] = r | g << 5 | bl << 10
    return struct.pack(f'<{n}H', *out)


def ramp_recolour(pal_bytes, black2_colours, keep_first=True):
    if not black2_colours: return pal_bytes
    n = len(pal_bytes) // 2
    cols = list(struct.unpack(f'<{n}H', pal_bytes))
    start = 1 if keep_first else 0
    order = sorted(range(start, n), key=lambda i: luma(cols[i]))
    out = list(cols)
    for rank, i in enumerate(order):
        q = rank / max(1, len(order) - 1)
        out[i] = black2_colours[round(q * (len(black2_colours) - 1))]
    return struct.pack(f'<{n}H', *out)


def is_grass(c):
    """A BGR555 colour that paints grass or leaves: clearly green, its green 4 or more above both red and blue
    (colour_class's 'green' also takes greyish mauves and teals)."""
    r, g, b = c & 31, c >> 5 & 31, c >> 10 & 31
    return g - max(r, b) >= 4


def grass_recolour(pal_bytes, pairs, keep_first=True):
    """transfer_recolour for the grass colours alone (is_grass): each takes the Black 2 colour of the nearest Pearl
    grass anchor of pairs at its own relative brightness; every other colour (stone, brick, mud, water, outlines)
    stays Pearl's. For Pearl art that keeps its own colours all year but has grass in it (path, plaza, brick and
    marsh edges, gravel fringes: patches/sinnoh_reskin.py), so its grass meets the season's ground."""
    if not pairs: return pal_bytes
    grass = [q for q in pairs if is_grass(q[0])] or list(pairs)
    n = len(pal_bytes) // 2
    cols = list(struct.unpack(f'<{n}H', pal_bytes))
    out = list(cols)
    for i in range(1 if keep_first else 0, n):
        c = cols[i]
        if not is_grass(c): continue
        p, b = min(grass, key=lambda q: _dist(c, q[0]))
        ratio = min(3.0, max(0.2, _luma5(c) / max(0.5, _luma5(p))))
        r, g, bl = (min(31, round((b >> s & 31) * ratio)) for s in (0, 5, 10))
        out[i] = r | g << 5 | bl << 10
    return struct.pack(f'<{n}H', *out)
