"""The trainer card with Pearl's player and Sinnoh's Gym Leaders (user 2026-10-20: "we need to update the trainer card
to have dawn and lucas's sprites and the sinnoh gym leaders should be a simple enough fix"). Ported from HoennB2's
b2tools/patches/trainer_card.py (its badge page) and its sprites.py / patches/sprites.py (the card picture), with
Pearl's own art from the dump (graphic/trainer_case.narc; layout: pokeplatinum res/graphics/trainer_case/, the same
art in Diamond and Pearl), pixel for pixel. Black 2's badge N stays the Nth Sinnoh badge (pl_GiveBadge N, Roark's 0).

The card's front picture (ov186 trainer_card.c TrainerCard_LoadGraphics; HoennB2 sprites.py "Trainer card pictures"):
  The player's own card shows Black 2's built-in Nate / Rosa (a/0/3/9 NCGR 36 + NSCR 50 / 51), another player's card
  the Union Room avatar v (a/0/4/0 NCGR 16 + v, 80x80 8 bpp, NCLR v's first 16 colours loaded at BG colours 64-79;
  v = random 0-7 + 8 x gender at the new game). apply_code: the test of "another player's card" (`bne` at 0x021a7ee0)
  becomes `b`, so every card shows the avatar picture (as HoennB2). apply: every boy avatar (NCGR 16-23, NCLR 0-7)
  shows Lucas, every girl avatar (24-31, 8-15) Dawn: Pearl's own trainer-card picture (trainer_case.narc NCGR 27, the
  8 bpp tiles, with NSCR 35 Lucas / 36 Dawn, colours 65-79 / 81-95 of the card palette NCLR 0; pokeplatinum
  player_dp_tiles.png + lucas_dp / dawn_dp.NSCR). Its 80 rows (tile rows 6-15) are copied 1:1, the figure centred
  across the avatar; colours 1-15 (and 65-79, as Black 2's avatars hold them) = Pearl's 15.

The badge page (ov186 badge_view.c) reads a/0/3/9:
  - NCGR 28 + NSCR 38 rows 1-10: the eight leader pennants (31 x 75 banners, one BG palette each: NCLR 0 palettes 0-7
    colour, NCLR 1 grey = no badge yet). Now Sinnoh's leaders in Pearl's badge order. PEARL_PENNANTS picks the art
    (the user's choice is open, see notes): 'pearl' (default) = Pearl's own battle picture (poketool/trgra/trfgra.narc,
    pearl_trainer_pics.dp_decode_ncgr) 1:1, a 31 x 75 crop from the top of the head down, centred on the head;
    'pwt' = HoennB2's way: Black 2's own PWT sprite of the same leader (a/0/7/1 129-136, the sprites the leaders'
    classes use, data/pearl_trainer_classes.json), a 15 x 35 head-and-shoulders crop at 2x. Each in <= 14 colours plus
    the banner's own dark; grey palettes by Black 2's own rule (luminance x 0.31, HoennB2 grey_of).
  - NSCR 38 rows 11-20 (palette 8): the badge case. Pearl's badges are 36-40 pixels across (trainer_case NCGR 28, 64x64
    OBJs 0-7), Black 2's slots 32: eight in one row do not fit 1:1. They sit staggered, as Pearl's case has them in two
    rows: badges 0, 2, 4, 6 in the upper row, 1, 3, 5, 7 in the lower, each in its own 32-pixel column (centres
    BADGE_X), so a badge stays under its leader's pennant and Black 2's touch columns (88-168 x 32k..32k+32) still
    pick it; no two badges' pixels overlap (checked). The Unova silhouettes are erased, Pearl's badges' silhouettes
    drawn in the case's own slot colours.
  - NCGR 31 tiles 32k..32k+24, NCER 52 cells 0-7: badge k as a 40x40 OBJ group (32x32 + 8x32 + 32x8 + 8x8 = 25 tiles,
    in its old 32-tile block, so NCGR 31 keeps its size), NCLR 4 palette BADGE_PALS[k] = Pearl's badge palette row 0
    (trainer_case NCLR 13 + k; rows 1-3 are Pearl's dirtier states).
  - BMD0 56-63: the badge on the top screen when one is touched = src/trainer_card/badge3d_N.nsbmd, Pearl's badge 1:1
    as the texture of a thin two-sided plate (b2tools/trainer_card_models.py).
  - ov186 (apply_code): sBadgeViewLeaderClasses 0x021ad19c = the Sinnoh leaders' classes 112-119 (their battle
    sprites stand on the top screen); sBadgeViewActorDefs 0x021ad478: the badges' (actors 4-11) and their polish
    sparkles' (12-35) positions for the staggered case.
  - text: data/text_overrides/trainer_card.json (system text btl_server_flow_4 lines 65-110, installed by
    sinnoh_names): Pearl's names, the mottos from Pearl's Gym signs, a line each leader says in Pearl, the badge names.
a/0/3/9 and a/0/4/0 have no build_rom.py RESERVE: both are rebuilt at their old sizes (zero padding inside GMIF), so
the ROM's file layout stays. Both are read from Black 2's own files, so the patch can run again on a built tree.
"""
import json, os, struct, sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, sprites as S, title_art as T, version                          # noqa: E402

ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
SRC = os.path.join(ROOT, 'src', 'trainer_card')
ARC, ARC_UNION = 39, 40
TRAINER_CASE = 'graphic/trainer_case.narc'
OV186, OV186_BASE = 'arm9_ov186.bin', 0x021A75A0
CARD_PICTURE = (0x021a7ee0, bytes.fromhex('1fd1'), bytes.fromhex('1fe0'))   # bne -> b (same target 0x021a7f22)
CLASS_TABLE = 0x021AD19C                                         # s16[8]: trainer class per badge (top-screen sprite)
CLASS_OLD = [115, 116, 113, 112, 117, 114, 118, 119]             # Black 2: Cheren, Roxie, Burgh, Elesa, Clay, Skyla, Drayden, Marlon
ACTOR_DEFS, ACTOR_SIZE = 0x021AD478, 32                          # BadgeViewActorDef[44]: x, y, sequence, ... (8 ints)
# Pearl's badge order: (name, Pearl class) - the class's Black 2 class and PWT sprite: data/pearl_trainer_classes.json
LEADERS = [('Roark', 'LEADER_ROARK'), ('Gardenia', 'LEADER_GARDENIA'), ('Maylene', 'LEADER_MAYLENE'),
           ('Crasher Wake', 'LEADER_WAKE'), ('Fantina', 'LEADER_FANTINA'), ('Byron', 'LEADER_BYRON'),
           ('Candice', 'LEADER_CANDICE'), ('Volkner', 'LEADER_VOLKNER')]
PENNANTS = os.environ.get('PEARL_PENNANTS', 'pearl')            # 'pearl' (Pearl's sprites 1:1) or 'pwt' (Black 2's, 2x)
BADGE_PALS = [1, 6, 2, 3, 4, 5, 7, 0]                           # NCLR 4 palette of 2D badge cell k (NCER 52)
CASE_Y0, CASE_Y1 = 88, 168                                       # NSCR 38 rows 11-20: the badge case
PEN_Y0, PEN_Y1 = 8, 88                                           # rows 1-10: the pennants
FILL, RING, RING_R, LOW, BG = 15, 14, 13, 11, 12                 # case colours (palette 8 indices): silhouette, its edge,
                                                                 # its right edge, the light line under it, the case
# The staggered case: badge k's centre (its 40x40 box); x in its own 32-pixel touch column, inside its half of the case
BADGE_X = [22, 50, 78, 106, 150, 178, 206, 234]
BADGE_Y = [110, 140] * 4
BOX = 40
# Badge k's polish sparkles (actors 12 + 3k ..): Black 2's offsets from its 32x64 badge's centre were (0, -16),
# (16, 8), (8, 24); on the 40x40 badges they keep their places on the badge
SPARKLE_OFFSETS = [(0, -12), (12, 4), (6, 13)]
# Pearl's trainer-card picture of the player (trainer_case.narc): tiles, screens, palette, colour block per gender
CARD_TILES, CARD_SCREENS, CARD_PAL, CARD_BASE = 27, (35, 36), 0, (64, 80)
CARD_ROWS = range(6, 16)                                         # the picture's tile rows (80 pixels)


# ---------------------------------------------------------------------------------------------------- Pearl's art

def pearl_case():
    import gen4rom
    if not hasattr(pearl_case, 'm'):
        pearl_case.m = gen4rom.narc_members(gen4rom.Rom(version.SOURCE_DUMP).read(TRAINER_CASE))
    return pearl_case.m


def pearl_badges():
    """8 x (w x h opaque crop as rows of palette indices, 16 RGB colours) of Pearl's badge-case badges (polished)."""
    m = pearl_case()
    _, tiles = T.ncgr_tiles(m[28])
    out = []
    for k in range(8):
        pix = [[0] * 64 for _ in range(64)]
        for t in range(64):                                      # OBJ k: 64x64, 1D, 8x8 tiles row-major
            for j in range(64):
                pix[t // 8 * 8 + j // 8][t % 8 * 8 + j % 8] = tiles[64 * k + t][j]
        pts = [(x, y) for y in range(64) for x in range(64) if pix[y][x]]
        x0, x1 = min(p[0] for p in pts), max(p[0] for p in pts)
        y0, y1 = min(p[1] for p in pts), max(p[1] for p in pts)
        crop = [pix[y][x0:x1 + 1] for y in range(y0, y1 + 1)]
        assert len(crop) <= BOX and len(crop[0]) <= BOX, (k, len(crop[0]), len(crop))
        out.append((crop, T.nclr_colours(m[13 + k])[:16]))
    return out


def badge_box(crop):
    """The badge's 40x40 box (rows of indices): the crop centred."""
    h, w = len(crop), len(crop[0])
    ox, oy = (BOX - w) // 2, (BOX - h) // 2
    box = [[0] * BOX for _ in range(BOX)]
    for y in range(h):
        box[oy + y][ox:ox + w] = crop[y]
    return box


def pearl_player(gender):
    """(80x80 indices 0-15, 16 RGB colours) of Pearl's trainer-card picture of Lucas (0) or Dawn (1)."""
    m = pearl_case()
    bpp, tiles = T.ncgr_tiles(m[CARD_TILES])
    w, h, _, ents = T.nscr_entries(m[CARD_SCREENS[gender]])
    pix = T.render_screen(tiles + [bytes(64)] * 1024, ents, w, h, bpp)
    base = CARD_BASE[gender]
    rows = [[pix[y * w + x] for x in range(w)] for y in range(CARD_ROWS[0] * 8, (CARD_ROWS[-1] + 1) * 8)]
    vals = {v for r in rows for v in r} - {0}
    assert vals <= set(range(base + 1, base + 16)), (gender, sorted(vals))
    xs = [x for r in rows for x, v in enumerate(r) if v]
    x0, x1 = min(xs), max(xs)
    assert x1 - x0 < 80
    off = x0 - (80 - (x1 - x0 + 1)) // 2                        # screen x of the avatar's column 0
    out = bytes((rows[y][off + x] - base if 0 <= off + x < w and rows[y][off + x] else 0)
                for y in range(80) for x in range(80))
    return out, T.nclr_colours(m[CARD_PAL])[base:base + 16]


def leader_classes():
    return json.load(open(os.path.join(ROOT, 'data', 'pearl_trainer_classes.json')))['classes']


def pearl_leader(cls):
    """(80x80 indices, 16 RGB) of Pearl's battle picture of a class (poketool/trgra/trfgra.narc)."""
    import pearl_trainer_pics as P, gen4rom
    if not hasattr(pearl_leader, 'm'):
        pearl_leader.m = gen4rom.narc_members(gen4rom.Rom(version.SOURCE_DUMP).read(P.TRFGRA))
        pearl_leader.n = P.pearl_class_numbers()
    c = pearl_leader.n[cls]
    w, h, pix = P.dp_decode_ncgr(pearl_leader.m[2 * c])
    still = bytes(pix[y * w + x] for y in range(80) for x in range(80))
    _, pal = S.nclr_colors(pearl_leader.m[2 * c + 1])
    return still, [S.bgr555_to_rgb(v) for v in pal]


def pwt_leader(sprite):
    """(80x80 indices, 16 RGB) of Black 2's own front sprite (its still picture)."""
    if not hasattr(pwt_leader, 'ents'):
        pwt_leader.ents = narcio.load(VANILLA, 71)
    f = S.tr_files(sprite)
    _, _, pix = S.tr_decode_image(pwt_leader.ents[f['static']], 'static')
    _, pal = S.nclr_colors(pwt_leader.ents[f['palette']])
    return pix, [S.bgr555_to_rgb(v) for v in pal]


# ---------------------------------------------------------------------------------------------------- pennants

def head_crop(pix, w, h):
    """(x0, y0) of a w x h box from the head's top row, centred on the opaque pixels of the 12 rows below it."""
    rows = [y for y in range(80) if any(pix[y * 80 + x] for x in range(80))]
    top = rows[0]
    xs = [x for y in range(top, top + 12) for x in range(80) if pix[y * 80 + x]]
    cx = round(sum(xs) / len(xs))
    return max(0, min(80 - w, cx - w // 2)), max(0, min(80 - h, top - 1))


def portrait(cls, bw, bh):
    """{(x, y): rgb} of the pennant portrait for a bw x bh banner."""
    out = {}
    if PENNANTS == 'pwt':                                        # HoennB2's way: 15 x 35 at 2x, Black 2's PWT sprite
        pix, rgb = pwt_leader(leader_classes()[cls]['sprite'])
        cw, ch = bw // 2, 35
        x0, y0 = head_crop(pix, cw, ch)
        for y in range(ch):
            for x in range(cw):
                v = pix[(y0 + y) * 80 + x0 + x]
                if v:
                    for a in (0, 1):
                        for b in (0, 1): out[(2 * x + a, 2 * y + b)] = rgb[v]
        return out
    assert PENNANTS == 'pearl', f'PEARL_PENNANTS={PENNANTS}: pearl or pwt'
    pix, rgb = pearl_leader(cls)                                 # Pearl's picture 1:1
    x0, y0 = head_crop(pix, bw, min(bh, 80))
    for y in range(min(bh, 80 - y0)):
        for x in range(bw):
            v = pix[(y0 + y) * 80 + x0 + x]
            if v: out[(x, y)] = rgb[v]
    return out


def merge_colours(cols, n):
    """At most n colours: the closest pairs (RGB distance) merged into the more used one."""
    c = Counter(cols)
    keep = list(c)
    while len(keep) > n:
        best = None
        for i in range(len(keep)):
            for j in range(i + 1, len(keep)):
                d = sum((p - q) ** 2 for p, q in zip(keep[i], keep[j]))
                if best is None or d < best[0]: best = (d, i, j)
        _, i, j = best
        a, b = keep[i], keep[j]
        lose, win = (a, b) if c[a] < c[b] else (b, a)
        c[win] += c.pop(lose); keep.remove(lose)
        cols = [win if q == lose else q for q in cols]
    return cols


def grey_of(rgb):
    """Black 2's grey for a pennant colour (fitted on its own NCLR 0 -> NCLR 1 pairs: luminance x 0.31, a trace of tint)."""
    lum = 0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2]
    return T.to555(tuple(max(0, min(255, round(0.31 * lum + 0.08 * (c - lum)))) for c in rgb))


class Screen:
    """NSCR 38 over NCGR 28 as a 256x256 grid of (palette, colour index) pixels; written back into new tiles."""
    def __init__(self, ncgr, nscr):
        self.bpp, self.tiles = T.ncgr_tiles(ncgr)
        self.w, self.h, self.mode, self.ents = T.nscr_entries(nscr)
        self.pal = [[0] * 256 for _ in range(256)]; self.idx = [[0] * 256 for _ in range(256)]
        for i, e in enumerate(self.ents[:1024]):
            t = T.flip_tile(self.tiles[e & 0x3ff], e >> 10 & 1, e >> 11 & 1)
            for y in range(8):
                for x in range(8):
                    self.pal[i // 32 * 8 + y][i % 32 * 8 + x] = e >> 12
                    self.idx[i // 32 * 8 + y][i % 32 * 8 + x] = t[y * 8 + x]
        self.used = {e & 0x3ff for e in self.ents}

    def rewrite(self, cells):
        """New tiles for the given (cx, cy) cells, in tile slots the page's VRAM holds: the slots only these cells used,
        then the free ones below the last slot Black 2 uses (tiles past it are not loaded: HoennB2 saw garbage);
        identical tiles (flips too) shared."""
        cells = set(cells)
        limit = max(self.used)
        users = {}
        for i, e in enumerate(self.ents[:1024]): users.setdefault(e & 0x3ff, set()).add((i % 32, i // 32))
        pool = sorted({t for t, u in users.items() if u <= cells} | {t for t in range(1, limit + 1) if t not in users})
        pool = [t for t in pool if t != 0]
        made = {}
        for cx, cy in sorted(cells):
            pal = self.pal[cy * 8][cx * 8]
            t = bytes(self.idx[cy * 8 + y][cx * 8 + x] for y in range(8) for x in range(8))
            assert all(self.pal[cy * 8 + y][cx * 8 + x] == pal for y in range(8) for x in range(8)), (cx, cy)
            if not any(t): self.ents[cy * 32 + cx] = pal << 12; continue
            if t not in made:
                assert pool, 'badge page: no free tile slot left'
                k = pool.pop(0); self.tiles[k] = t
                for hf in (0, 1):
                    for vf in (0, 1): made.setdefault(T.flip_tile(t, hf, vf), (k, hf, vf))
            k, hf, vf = made[t]
            self.ents[cy * 32 + cx] = k | hf << 10 | vf << 11 | pal << 12
        return len(pool)

    def ncgr(self, old):
        u = bytearray(old)
        th, tw, depth, mapping, tiled, size, off = struct.unpack_from('<HHIIIII', u, 0x18)
        raw = bytes((t[i] & 15) | (t[i + 1] & 15) << 4 for t in self.tiles for i in range(0, 64, 2))
        assert len(raw) == size
        u[0x18 + off:0x18 + off + size] = raw
        return bytes(u)

    def nscr(self, old):
        u = bytearray(old)
        struct.pack_into(f'<{len(self.ents)}H', u, 0x24, *self.ents)
        return bytes(u)


def pennants(arc, scr, log):
    """Leader pennants: NSCR 38 rows 1-10, NCLR 0/1 palettes 0-7."""
    col = T.nclr_colours(arc[0]); grey = T.nclr_colours(arc[1])
    cells = []
    for k, (name, cls) in enumerate(LEADERS):
        x0 = 32 * k
        region = [(x, y) for y in range(PEN_Y0, PEN_Y1) for x in range(x0, x0 + 32)]
        banner = [(x, y) for x, y in region if scr.pal[y][x] == k and scr.idx[y][x]]
        dark = min({scr.idx[y][x] for x, y in banner}, key=lambda i: sum(col[16 * k + i]))   # the banner's darkest colour
        dark_rgb = col[16 * k + dark]
        bx0 = min(x for x, _ in banner); by0 = min(y for _, y in banner)
        bw = max(x for x, _ in banner) + 1 - bx0; bh = max(y for _, y in banner) + 1 - by0
        art = portrait(cls, bw, bh)
        new = {p: art.get((p[0] - bx0, p[1] - by0), dark_rgb) for p in banner}
        # palette: index 0 kept (transparent / the backdrop), the banner's dark colour, the portrait's colours (<= 14)
        rgbs = merge_colours([new[p] for p in banner], 15)
        uniq = [dark_rgb] + sorted({c for c in rgbs if c != dark_rgb}, key=lambda c: sum(c))
        assert len(uniq) <= 15, (name, len(uniq))
        slot = {c: 1 + i for i, c in enumerate(uniq)}
        for (x, y), c in zip(banner, rgbs):
            scr.idx[y][x] = slot[c]
        for i in range(1, 16):
            c = uniq[i - 1] if i - 1 < len(uniq) else (0, 0, 0)
            col[16 * k + i] = T.to555(c); grey[16 * k + i] = grey_of(c)
        cells += sorted({(x // 8, y // 8) for x, y in banner})
        log.append(f'{name} {len(uniq)}')
    arc[0] = T.nclr_build(arc[0], col); arc[1] = T.nclr_build(arc[1], grey)
    return cells


# ---------------------------------------------------------------------------------------------------- the case

def badge_masks(badges):
    """{k: set of screen (x, y)} of each badge's pixels where it sits in the case; checked: no two overlap, all inside."""
    masks, seen = {}, {}
    for k, (crop, _) in enumerate(badges):
        box = badge_box(crop)
        x0, y0 = BADGE_X[k] - BOX // 2, BADGE_Y[k] - BOX // 2
        masks[k] = {(x0 + x, y0 + y) for y in range(BOX) for x in range(BOX) if box[y][x]}
        for p in masks[k]:
            assert p not in seen, f'badges {seen.get(p)} and {k} overlap at {p}'
            assert 0 <= p[0] < 256 and CASE_Y0 < p[1] < CASE_Y1, (k, p)
            seen[p] = k
    return masks


def silhouettes(arc, scr, masks, log):
    """Badge case: the Unova silhouettes out (their own shapes, from the old 2D badges), Pearl's badges' in."""
    _, otiles = T.ncgr_tiles(arc[31])
    old_masks = [[[bool(otiles[32 * k + (y // 8) * 4 + x // 8][(y % 8) * 8 + x % 8]) for x in range(32)]
                  for y in range(64)] for k in range(8)]
    cells = set()
    for k in range(8):                            # Black 2's 2D badge k: a 32x64 OBJ at (16 + 32k - 16, 128 - 32)
        ox, oy = 32 * k, 96
        old = {(ox + x, oy + y) for y in range(64) for x in range(32) if old_masks[k][y][x]}
        near = {(x + dx, y + dy) for x, y in old for dx in range(-3, 4) for dy in range(-3, 5)}
        for x, y in near:
            if CASE_Y0 <= y < CASE_Y1 and 0 <= x < 256 and scr.pal[y][x] == 8 and scr.idx[y][x] in (FILL, RING, RING_R, LOW):
                scr.idx[y][x] = BG; cells.add((x // 8, y // 8))
    # no old silhouette left (they were found by their own 2D badges' shapes): no silhouette-sized FILL patch stays
    # (FILL is also the case frame's colour along its bottom: long, thin, not counted)
    seen = set()
    for y in range(CASE_Y0, CASE_Y1):
        for x in range(256):
            if (x, y) in seen or not (scr.pal[y][x] == 8 and scr.idx[y][x] == FILL): continue
            comp, todo = [], [(x, y)]; seen.add((x, y))
            while todo:
                p = todo.pop(); comp.append(p)
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    q = (p[0] + dx, p[1] + dy)
                    if q not in seen and CASE_Y0 <= q[1] < CASE_Y1 and 0 <= q[0] < 256 and scr.pal[q[1]][q[0]] == 8 \
                            and scr.idx[q[1]][q[0]] == FILL:
                        seen.add(q); todo.append(q)
            assert not (len(comp) > 40 and len({p[0] for p in comp}) < 40), f'badge case: old silhouette left at {comp[0]}'
    allm = set().union(*masks.values())
    rings = {}
    for k, m in masks.items():
        ring = {(x + dx, y + dy) for x, y in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))} - allm
        low = {(x, y + 1) for x, y in ring if (x, y + 1) not in allm and (x, y + 1) not in ring}
        rings[k] = (ring, low, m)
    for ring, low, m in rings.values():
        for x, y in low:
            if scr.idx[y][x] == BG: scr.idx[y][x] = LOW
    for ring, low, m in rings.values():
        for x, y in ring: scr.idx[y][x] = RING_R if (x - 1, y) in m and (x + 1, y) not in m else RING
    for x, y in allm: scr.idx[y][x] = FILL
    for ring, low, m in rings.values():
        cells |= {(x // 8, y // 8) for x, y in m | ring | low}
    # specks left of the old edges (a lone edge pixel in the case colour's surroundings)
    for y in range(CASE_Y0 + 1, CASE_Y1 - 1):
        for x in range(1, 255):
            if scr.pal[y][x] == 8 and scr.idx[y][x] in (RING, RING_R, LOW) and \
                    all(scr.idx[y + dy][x + dx] == BG for dx in (-1, 0, 1) for dy in (-1, 0, 1) if dx or dy):
                scr.idx[y][x] = BG; cells.add((x // 8, y // 8))
    log.append('8 silhouettes')
    return sorted(c for c in cells if CASE_Y0 // 8 <= c[1] < CASE_Y1 // 8)


# the 40x40 group: (OBJ x, y from the box's top-left, w, h, shape, size, first tile from the badge's 32-tile block)
PARTS = [(0, 0, 32, 32, 0, 2, 0), (32, 0, 8, 32, 2, 1, 16), (0, 32, 32, 8, 1, 1, 20), (32, 32, 8, 8, 0, 0, 24)]


def badges2d(arc, badges):
    """NCGR 31 tiles 32k..32k+24: badge k's 40x40 box as the four OBJs of PARTS; NCLR 4: its colours."""
    u = bytearray(arc[31])
    th, tw, depth, mapping, tiled, size, off = struct.unpack_from('<HHIIIII', u, 0x18)
    _, tiles = T.ncgr_tiles(arc[31])
    for k, (crop, _) in enumerate(badges):
        box = badge_box(crop)
        for t in range(32): tiles[32 * k + t] = bytes(64)
        for px, py, w, h, _, _, first in PARTS:
            for t in range(w * h // 64):                          # 1D: the OBJ's tiles row-major
                tx, ty = t % (w // 8), t // (w // 8)
                tiles[32 * k + first + t] = bytes(box[py + ty * 8 + y][px + tx * 8 + x] for y in range(8) for x in range(8))
    raw = bytes((t[i] & 15) | (t[i + 1] & 15) << 4 for t in tiles for i in range(0, 64, 2))
    u[0x18 + off:0x18 + off + size] = raw[:size]
    arc[31] = bytes(u)
    cols = T.nclr_colours(arc[4])
    for k, (_, rgb) in enumerate(badges):
        for i in range(1, 16): cols[16 * BADGE_PALS[k] + i] = T.to555(rgb[i])
    arc[4] = T.nclr_build(arc[4], cols)


def cells2d(arc):
    """NCER 52: cells 0-7 = the four OBJs of PARTS around the actor's position (the 40x40 box centred on it); the other
    cells (sparkles, buttons) as they were."""
    d = arc[52]
    assert d[:4] == b'RECN' and d[0x10:0x14] == b'KBEC'
    kbec, n, attr, celloff = struct.unpack_from('<IHHI', d, 0x14)
    assert attr == 0 and celloff == 0x18 and n == 14, (attr, celloff, n)
    assert struct.unpack_from('<IIII', d, 0x20) == (0, 0, 0, 0)    # mapping 1D 32K, no VRAM transfer / extended data
    base, oam = 0x30, 0x30 + 8 * n
    cells = []
    for i in range(n):
        no, cattr, oo = struct.unpack_from('<HHI', d, base + 8 * i)
        cells.append((cattr, [struct.unpack_from('<HHH', d, oam + oo + 6 * j) for j in range(no)]))
    for k in range(8):
        cattr, objs = cells[k]
        assert len(objs) == 1 and objs[0][2] & 0x3ff == 32 * k and objs[0][2] >> 12 == BADGE_PALS[k], (k, objs)
        new = []
        for px, py, w, h, shape, size, first in PARTS:
            x, y = px - BOX // 2, py - BOX // 2
            new.append(((y & 0xff) | shape << 14, (x & 0x1ff) | size << 14, (32 * k + first) | BADGE_PALS[k] << 12))
        cells[k] = (cattr, new)
    table, data = b'', b''
    for cattr, objs in cells:
        table += struct.pack('<HHI', len(objs), cattr, len(data))
        data += b''.join(struct.pack('<HHH', *o) for o in objs)
    body = table + data
    while len(body) % 4: body += b'\0'
    rest = d[0x10 + kbec:]                                         # LBAL, TXEU
    kb = b'KBEC' + struct.pack('<IHHIIIII', 0x20 + len(body), n, attr, celloff, 0, 0, 0, 0) + body
    out = bytearray(d[:0x10]) + kb + rest
    struct.pack_into('<I', out, 8, len(out))
    arc[52] = bytes(out)


def models(arc, log):
    n = 0
    for k in range(8):
        p = os.path.join(SRC, f'badge3d_{k}.nsbmd')
        if os.path.exists(p): arc[56 + k] = open(p, 'rb').read(); n += 1
    log.append(f'{n} 3D badges' + ('' if n == 8 else ' (missing: run b2tools/trainer_card_models.py)'))


# ---------------------------------------------------------------------------------------------------- card picture

def card_pictures(ents):
    """a/0/4/0: every boy avatar Lucas, every girl avatar Dawn (Pearl's trainer-card picture)."""
    for g in (0, 1):
        pix, rgb = pearl_player(g)
        pix = bytes(0 if v == 0 else 64 + v for v in pix)       # the card loads NCLR colours 0-15 at BG colours 64-79
        for v in range(8 * g, 8 * g + 8):
            ents[16 + v] = S.card_encode(ents[16 + v], pix)
            nclr = bytearray(ents[v])
            at, _ = S.nclr_colors_any(nclr)
            for b in (0, 64):                                    # Black 2's avatar palettes hold the 16 colours at both
                struct.pack_into('<15H', nclr, at + 2 * (b + 1), *[S.rgb_to_bgr555(c) for c in rgb[1:16]])
            ents[v] = bytes(nclr)


def save_same_size(files, arc_id, ents):
    """Write an archive that has no RESERVE at its Black 2 size (zero padding inside GMIF)."""
    from b2files import arc_path
    path = arc_path(files, arc_id)
    old = os.path.getsize(arc_path(VANILLA, arc_id))
    narcio.save(files, arc_id, ents)
    new = os.path.getsize(path)
    assert new <= old, f'a/{arc_id:03d} grew {old} -> {new} B (no RESERVE: the ROM layout would move)'
    if new < old:
        d = bytearray(open(path, 'rb').read())
        o = struct.unpack_from('<H', d, 0xC)[0]
        for _ in range(2): o += struct.unpack_from('<I', d, o + 4)[0]
        assert d[o:o + 4] == b'GMIF'
        struct.pack_into('<I', d, o + 4, struct.unpack_from('<I', d, o + 4)[0] + old - new)
        struct.pack_into('<I', d, 8, old)
        open(path + '.tmp', 'wb').write(bytes(d) + bytes(old - new)); os.replace(path + '.tmp', path)
    return old


def apply(files):
    arc = narcio.load(VANILLA, ARC)                              # Black 2's own (the patch can run again)
    log = []
    scr = Screen(arc[28], arc[38])
    cells = pennants(arc, scr, log)
    badges = pearl_badges()
    masks = badge_masks(badges)
    cells += silhouettes(arc, scr, masks, log)
    free = scr.rewrite(sorted(set(cells)))
    arc[28] = scr.ncgr(arc[28]); arc[38] = scr.nscr(arc[38])
    badges2d(arc, badges)
    cells2d(arc)
    models(arc, log)
    size = save_same_size(files, ARC, arc)
    union = narcio.load(VANILLA, ARC_UNION)
    card_pictures(union)
    save_same_size(files, ARC_UNION, union)
    return (f'a/0/3/9: pennants ({PENNANTS}: {", ".join(log[:8])} colours), staggered badge case, Pearl\'s badges '
            f'({"; ".join(log[8:])}; {free} tile slots spare; {size} B kept); a/0/4/0: Lucas / Dawn card pictures')


# ---------------------------------------------------------------------------------------------------- ov186

def actor_positions():
    """{actor: (x, y)} of the badges (4-11) and their sparkles (12-35) in the staggered case."""
    out = {}
    for k in range(8):
        out[4 + k] = (BADGE_X[k], BADGE_Y[k])
        for i, (dx, dy) in enumerate(SPARKLE_OFFSETS):
            out[12 + 3 * k + i] = (BADGE_X[k] + dx, BADGE_Y[k] + dy)
    return out


def apply_code(code):
    path = os.path.join(code, OV186)
    d = bytearray(open(path, 'rb').read())
    vanilla = open(os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build', OV186), 'rb').read()
    # the card picture: every card shows the avatar picture
    at, old, new = CARD_PICTURE
    at -= OV186_BASE
    assert d[at:at + 2] in (old, new), f'{OV186} {CARD_PICTURE[0]:#x}: unexpected {d[at:at + 2].hex()}'
    d[at:at + 2] = new
    # the leaders' classes
    classes = leader_classes()
    want = [classes[c]['b2'] for _, c in LEADERS]
    at = CLASS_TABLE - OV186_BASE
    now = list(struct.unpack_from('<8h', d, at))
    assert now in (CLASS_OLD, want), f'{OV186} {CLASS_TABLE:#x}: unexpected {now}'
    struct.pack_into('<8h', d, at, *want)
    # the badges' and sparkles' positions (checked against Black 2's table: only x, y change)
    for actor, (x, y) in actor_positions().items():
        at = ACTOR_DEFS - OV186_BASE + ACTOR_SIZE * actor
        b2 = struct.unpack_from('<8i', vanilla, at)
        now = struct.unpack_from('<8i', d, at)
        assert now[2:] == b2[2:] and now[:2] in (b2[:2], (x, y)), f'{OV186} actor {actor}: unexpected {now}'
        if actor < 12:
            assert b2[:2] == (16 + 32 * (actor - 4), 128), b2
        struct.pack_into('<2i', d, at, x, y)
    if os.path.islink(path): os.unlink(path)
    open(path, 'wb').write(bytes(d))
    return (f'{OV186}: the card shows the avatar picture (Lucas / Dawn); badge-page leader classes {want}; '
            f'badges staggered (actors 4-35)')
