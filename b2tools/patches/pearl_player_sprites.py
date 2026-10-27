"""Lucas and Dawn, Pearl's own player sprites, instead of Nate and Rosa (user 2026-10-18: "use lucass and dawns
diamond and peral sprites too instead of nate and rosa's"). This file: the overworld sheets.

Black 2's player sheets (a/0/4/8, object codes 231-239 Nate, 240-248 Rosa; sprites.py ow_sheet_of) and Pearl's
(the dump's data/mmodel/mmodel.narc, textures named hero.N / heroine.N etc.; frames in numeric order), both 32 x 32
4 bpp frames with one 16-colour palette per sheet. Directions are back, front, left, right in both. Each Black 2
frame takes a Pearl frame (MAP); the sheet keeps Black 2's layout, so Black 2's animations play Pearl's frames:
- 231 walk + run (24): Pearl's hero has 4 frames per direction (stand, step, stand, step), Black 2 3 (stand, step,
  step): Pearl frames 0, 1, 3 of each direction; run = Pearl 16-31 the same way.
- 232 bike (16): the same for riding (Pearl cyclehero 0-15), then Black 2's four single frames (back, front, side,
  side) = Pearl 20-23.
- 233 surfing (4) = Pearl swimhero 0-3. 237 Poké Ball throw (4) = Pearl sphero 0-3. 235 (2, the save / PC pose) =
  Pearl savehero 0-1. 239 fishing (12) = Pearl fishinghero 0-11 (Black 2 mirrors the last side).
- 234 (2, the field-move pose: front, arm out) = Pearl's walk front stand + Pearl's front arm-out Pokétch pose (pokehero 3).
- 236 (5, the Pokémon Center pose) = Pearl banzaihero 0-4. 238 (16, Black 2-only arms-out poses) = Pearl's walk
  frames 0-15 (Pearl has no such pose).
Black 2's fishing frames are 64 x 64 (room for the rod): Pearl's 32 x 32 frame goes in the middle, at (16, 16),
where Black 2's body is (found by matching Nate's walking frame into his fishing frame).
Pearl's side casts (fishing frames 10, 11) run the line into the edge of their 32 x 32 box, which looks cut off in
Black 2's bigger frame: extend_line() continues it past the old edge along its own slope (the line's colour, the
slope of its last pixels) for up to 12 pixels, as long as Black 2's own lines are there.
Pearl's frames sit 1 pixel higher than Black 2's in the 32 x 32 box (feet on row 29, Black 2's on 30): moved down 1.
Colours: each sheet takes its main Pearl sheet's 16 colours; frames from another Pearl sheet are matched to them
by colour.
"""
import os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, sprites  # noqa: E402

MMODEL = 'data/mmodel/mmodel.narc'
# Pearl mmodel files: (Lucas, Dawn)
PEARL = {'walk': (90, 91), 'bike': (92, 93), 'swim': (159, 160), 'ball': (155, 156), 'fish': (166, 167),
         'save': (365, 366), 'poke': (363, 364), 'banzai': (367, 368)}
FIRST_CODE = (231, 240)
DIRS = range(4)


def frames_map():
    """{code offset 0-8: [(pearl sheet, frame)]} for Black 2's nine player sheets."""
    walk = [('walk', run * 16 + d * 4 + k) for run in (0, 1) for d in DIRS for k in (0, 1, 3)]
    bike = [('bike', d * 4 + k) for d in DIRS for k in (0, 1, 3)] + [('bike', 20 + d) for d in DIRS]
    return {0: walk, 1: bike, 2: [('swim', k) for k in range(4)], 3: [('walk', 4), ('poke', 3)],
            4: [('save', 0), ('save', 1)], 5: [('banzai', k) for k in range(5)], 6: [('ball', k) for k in range(4)],
            7: [('walk', k) for k in range(16)], 8: [('fish', k) for k in range(12)]}


MAIN = {0: 'walk', 1: 'bike', 2: 'swim', 3: 'walk', 4: 'save', 5: 'banzai', 6: 'ball', 7: 'walk', 8: 'fish'}
SHIFT_DOWN = 1


def pearl_sheets(gender):
    """{name: (frames [32x32 index bytes] in numeric order, 16 BGR555 colours)} of Lucas (0) or Dawn (1)."""
    import version
    from gen4rom import Rom, narc_members
    m = narc_members(Rom(version.SOURCE_DUMP).read(MMODEL))
    out = {}
    for name, ids in PEARL.items():
        fr, _, pal = sprites.btx_decode(m[ids[gender]])
        fr = sorted(fr, key=lambda f: int(f[0].split('.')[-1]))
        assert all((w, h) == (32, 32) for _, w, h, _ in fr), name
        out[name] = ([p for _, _, _, p in fr], pal)
    return out


def shift(pix, dy):
    if dy <= 0: return pix
    return bytes(dy * 32) + pix[:len(pix) - dy * 32]


def embed(pix, w, h, at=(16, 16)):
    """A 32 x 32 frame placed into a w x h frame at `at`."""
    if (w, h) == (32, 32): return pix
    out = bytearray(w * h)
    for y in range(32):
        out[(at[1] + y) * w + at[0]:(at[1] + y) * w + at[0] + 32] = pix[y * 32:y * 32 + 32]
    return bytes(out)


def extend_line(pix, w, h, at=(16, 16), length=12):
    """A w x h frame (with a 32 x 32 Pearl frame at `at`) whose fishing line, where it meets the old box's left or
    right edge, goes on past it along the slope of its last pixels."""
    if (w, h) == (32, 32): return pix
    a = bytearray(pix)
    x0, y0 = at
    for edge, step in ((x0, -1), (x0 + 31, 1)):
        rows = [y for y in range(y0, y0 + 32) if a[y * w + edge]]
        for y in rows:
            col = a[y * w + edge]
            # the line's last pixels inside the box: same colour, walking inwards
            pts, cx, cy = [(edge, y)], edge, y
            for _ in range(8):
                nxt = [(cx - step, cy + d) for d in (0, -1, 1) if 0 <= cy + d < h and a[(cy + d) * w + cx - step] == col]
                if not nxt: break
                cx, cy = nxt[0]; pts.append((cx, cy))
            if len(pts) < 4: continue                       # not a line (a hand or the rod at the edge)
            slope = (pts[0][1] - pts[-1][1]) / (pts[0][0] - pts[-1][0])
            for k in range(1, length + 1):
                nx = edge + step * k
                ny = round(y + slope * (nx - edge))
                if not (0 <= nx < w and 0 <= ny < h): break
                if a[ny * w + nx] == 0: a[ny * w + nx] = col
    return bytes(a)


def remap(pix, src, dst):
    """Pixels of a frame drawn with colours src, in colours dst (nearest; 0 stays clear)."""
    rgb = lambda c: sprites.bgr555_to_rgb(c)
    near = [0] + [min(range(1, 16), key=lambda j: sum((a - b) ** 2 for a, b in zip(rgb(src[i]), rgb(dst[j]))))
                  for i in range(1, 16)]
    return bytes(near[v] for v in pix)


def sheets_for(gender, black2_sheets, files):
    """{a/0/4/8 sheet index: new bytes} for one gender."""
    src = pearl_sheets(gender)
    table = sprites.ow_table(files)
    out = {}
    for k, frames in frames_map().items():
        code = FIRST_CODE[gender] + k
        sheet, _ = sprites.ow_sheet_of(files, code, table)
        btx = black2_sheets[sheet]
        lay, _, _ = sprites.btx_layout(btx)
        assert len(lay) == len(frames), (code, len(lay), len(frames))
        pal = src[MAIN[k]][1]
        pix = []
        for (name, i), (_, w, h, _) in zip(frames, lay):
            p = src[name][0][i]
            if name != MAIN[k]:
                p = remap(p, src[name][1], pal)
            pix.append(extend_line(embed(shift(p, SHIFT_DOWN), w, h), w, h))
        out[sheet] = sprites.btx_encode(btx, pix, pal)
    return out


def apply(files):
    sheets = narcio.load(files, sprites.ARC_OW_SHEETS)
    n = 0
    for gender in (0, 1):
        for sheet, data in sheets_for(gender, sheets, files).items():
            sheets[sheet] = data; n += 1
    narcio.save(files, sprites.ARC_OW_SHEETS, sheets)
    backs = apply_backs(files)
    return (f'pearl_player_sprites: {n} player overworld sheets (Nate 231-239, Rosa 240-248) = Lucas and Dawn from '
            f'Pearl; {backs}')


# ---------------------------------------------------------------------------------------------------- battle backs
# The player's back in battle (a/0/7/2 sprites 0 and 1, Black 2's Nate and Rosa; MCSS: cells cut from a 256 x 128
# texture, one quad each). Black 2 throws with NMAR sequence 1: pokebw2 effect 0x234 plays it (McssPlayAnim(8, 1)),
# waits 34 frames, then the throw sound and the ball (ParticleLoad + the ortho emitter: the ball shows at tick 41,
# once its particle resource is in); battles run at 60 frames a second. Filmed 2026-10-25 with the throw frame at tick
# 41: it showed one frame after the ball (both backs), so the throw frame is at tick 40 (RELEASE_TICK).
# - Back 1, Dawn (user 2026-10-20: "lucas's throwing animation looks a little awkward like hes flicking the pokeball
#   out"): Pearl's own throw. Pearl shows the player's back two ways (pokediamond): sliding in, a still picture
#   (poketool/trgra/trbgra.narc); sending out, an OAM sprite with its own five-cell throw in
#   battle/graphic/batt_obj.narc (ov11_02254308: NCGR 195 + back, NCLR 47 + back, NCER 203 + back, NANR 211 + back;
#   back 0 Lucas, 1 Dawn; each cell's characters by VRAM transfer). Its NANR: cell 0 (standing, the ball at the
#   chest) 1 frame, 1 (the arm back) 9, 2 (wound up) 4, 3 (the arm thrown forward) 4, 4 (the follow-through) 30, at
#   30 frames a second (two V-blanks per main loop). ov11_02250338 (pokeplatinum battle_display.c
#   Task_ThrowTrainerBall) ticks it once a frame, keeps the Poke Ball sprite in the hand at ov11_0225E8D0's offsets
#   and lets it go when cell 3 shows, at (+50, -12) from the sprite's origin (the same for both backs). Cells 3 and 4
#   sit 16 px further right (the throw steps forward). Here Pearl's five cells, pixel for pixel, each where Pearl puts
#   it (Pearl x, y -> Black 2 x, y - 40: the 80 x 80 canvas ends on the sprite's origin), in Pearl's order and timing
#   (x 2 for 60 fps): cell 0 2 ticks + 12 so that cell 3 shows with Black 2's ball, at tick 40 (Pearl: 28 ticks
#   in), 1 18, 2 8, 3 8, 4 60. Cells 1 and 2 carry the Poke Ball as Pearl shows it (batt_obj 221/55/220 cell 0 at
#   ov11_0225E8D0's offsets, in the nearest of the back's 16 colours; cell 0 has the ball in its own pixels).
# - Back 0, Lucas (user 2026-10-25): tebited15's fan-made Black 2-style Lucas back (art_sources/
#   fan_tebited15_lucas_back, "FREE USE"; credit in the release README), its top row: four frames, standing, the
#   ball raised, wound up with the ball high, thrown (the arm down and forward). The sheet's frames share the left
#   edge of the jeans on its last row (frames 0 and 1 have 2,611 pixels in common there): each frame is placed by
#   that pixel; the last row lands on the screen's row 200 (below the bottom edge, as Black 2's Nate) and frame 0
#   stands where Nate and Pearl's backs stand (its jeans' left edge at screen x 20). Its 46 colours go to the back's
#   15 (k-medoids in Lab, weighted by pixel count: the artist's own colours, mean error 2 dE). Timing as Nate's
#   throw: standing 7 ticks, the ball raised 25, wound up 8, thrown from tick 40 for 60: the ball shows the moment
#   the arm comes down, where the hand held it at the top (Black 2's convention: Nate's ball leaves his raised hand).
# Black 2's staging stays (no slide out; the back fades). Each cell's box (rounded up to 8) goes into the texture
# whole, or in bands of 8-row multiples where it does not fit, or split in two by columns (each part trimmed to its
# own pixels) when the poses still do not fit; files +1 to +6 are written new for that layout, +0 (the still picture,
# unused by Black 2: Nate's is blank) = the first pose when it fits the 80 x 80 canvas, else blank.
# The ball's start (decomp src/pearlb2/ball_start_itcm.c, table gPearlB2BallStarts): effect 0x234 starts every
# player's ball from one point of the battle scene, (-10240, 7782, 49152) = screen (51, 89), where Nate's raised hand
# is. The decomp's PearlB2_BallEmitter replaces it, for the trainer class shown at the player's place (class 0 Lucas,
# 1 Dawn; the catching demo shows the other one), by that back's release point: the point of the scene that the
# send-out camera shows there, at a depth that gives the ball an up-and-right arc (Dawn: depth 18; Lucas: 12, Black
# 2's own). The camera at the send-out: Black 2's default (6.7, 6.7, 17.3) -> (0, 2.6, 0) moved by effect 0x232's (and
# 0x23C's) relative CameraMove (+10, +1, +16) / (+6, +2, +16); perspective with a 13-degree half angle (sin 0x399,
# cos 0xf97), aspect 1.35; BtlvEffvm_ProjectToScreen's (x 4, y 3) and the ortho particle camera ([-4, 4] x [-3, 3]):
# 32 pixels a unit. Checked: Black 2's start projects to (51, 89), where the throw agent's film showed it.
# A ball thrown at a wild Pokémon (effect 0x23A, also the catching demo's; 0x23D, the ball a Trainer blocks) keeps
# Black 2's start: no thrower is on show there in Black 2 or in Pearl (pokeplatinum ov12_02237B14, throw types 15-17:
# from screen (-30, 160), off the left edge). Black 2's start, the scene point (0, -2, 10) + 2.4 up, is off the bottom
# left corner and its ball comes in from the lower left, as Pearl's does. Tried 2026-10-25: the scene point shown at
# Pearl's (-30, 160) (depth 4, keeping Black 2's arc) made the ball come in at the left edge above the foe's HP box
# (Black 2's arc is steeper than Pearl's): left as Black 2's (work/agents/fixes/shots/demo_catch_throw_sheet.png).
BATT_OBJ = 'battle/graphic/batt_obj.narc'
THROW_FILES = (195, 47, 203, 211)           # NCGR, NCLR, NCER, NANR of back 0 (+ 1 for back 1)
BALL_FILES = (221, 55, 220)                 # the Poke Ball's NCGR, NCLR, NCER (ov08_0222D398 row 4)
BALL_IN_HAND = {1: (-34, 4), 2: (-28, -11)}  # ov11_0225E8D0 (the same for backs 0 and 1)
PEARL_RELEASE = (50, -12)                    # ov11_0225E8D0 frame 3: the ball's start, from the sprite's origin
RELEASE_CELL, RELEASE_TICK = 3, 40           # the throw frame shows with Black 2's ball (filmed: the MCSS shows a tick late)
PEARL_DY = -40
BACK_ORIGIN = (45, 201)                      # the back's sprite origin on screen at the send-out (filmed 2026-10-20)
FAN_PNG = 'art_sources/fan_tebited15_lucas_back/trainer_lucas_back_bw_style.png'
FAN_ROWS = 124                               # the sheet's top row of frames: rows 0-123 (the second row from 125)
FAN_ANCHOR_SCREEN = (20, 200)                # frame 0's jeans' left edge, the last row: on screen
FAN_BALL = (181, 9)                          # the ball's middle in the sheet, frame 2 (wound up, the ball high)
FAN_RELEASE_FRAME, FAN_TICKS = 3, (None, 25, 8, 60)   # standing (the rest of RELEASE_TICK), raised, wound up, thrown
START_DEPTH = {0: 12.0, 1: 18.0}             # the ball's start depth in the scene by back (see above)


def _lz10(d):
    import title_art
    return title_art.lz10_decompress(d) if d[:1] == b'\x10' else d


def _pal16(nclr):
    import struct
    return list(struct.unpack_from('<16H', nclr, 0x18 + struct.unpack_from('<I', nclr, 0x24)[0]))


def _oam_cells(ncgr, ncer):
    """[{(x, y): colour index}] per cell of a DP OAM sprite (1D mapping, VRAM transfer or shared characters)."""
    import struct
    size, off = struct.unpack_from('<II', ncgr, 0x28)
    pix = sprites.unpack4(ncgr[0x18 + off:0x18 + off + size], size * 2)
    n, attr, celloff, cmap, vt = struct.unpack_from('<HHIII', ncer, 0x18)
    unit = 64 << cmap                       # pixels per tile number (1D 32K / 64K / 128K / 256K)
    src = [0] * n
    if vt:
        b = 0x18 + vt
        src = [2 * struct.unpack_from('<I', ncer, b + struct.unpack_from('<I', ncer, b + 4)[0] + 8 * k)[0]
               for k in range(n)]
    cb = 0x18 + celloff; csz = 16 if attr & 1 else 8; ob = cb + n * csz
    out = []
    for k in range(n):
        no, _, oo = struct.unpack_from('<HHI', ncer, cb + csz * k)
        d = {}
        for j in range(no):
            a0, a1, a2 = struct.unpack_from('<HHH', ncer, ob + oo + 6 * j)
            y = (a0 & 0xff) - (256 if a0 & 0x80 else 0); x = (a1 & 0x1ff) - (512 if a1 & 0x100 else 0)
            w, h = sprites.OBJ_SIZES[(a0 >> 14, a1 >> 14)]
            t = src[k] + (a2 & 0x3ff) * unit
            for i in range(w * h):
                tx, ty, p = i // 64 % (w // 8), i // 64 // (w // 8), i % 64
                v = pix[t + i]
                if v: d[(x + tx * 8 + p % 8, y + ty * 8 + p // 8)] = v
        out.append(d)
    return out


def _lab(c):
    def f(t): return t ** (1 / 3) if t > 0.008856 else 7.787 * t + 16 / 116
    r, g, b = [((v / 255 + 0.055) / 1.055) ** 2.4 if v > 10 else v / 255 / 12.92 for v in sprites.bgr555_to_rgb(c)]
    x, y, z = (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.9505, 0.2126 * r + 0.7152 * g + 0.0722 * b, \
        (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.089
    return 116 * f(y) - 16, 500 * (f(x) - f(y)), 200 * (f(y) - f(z))


def pearl_throws():
    """{0 Lucas, 1 Dawn: ([5 poses {(x, y): index} in Black 2 sprite coordinates], [ticks at 60 fps], 16 colours)}:
    Pearl's own throws (the game uses Dawn's; Lucas's stays for comparisons)."""
    import version
    from gen4rom import Rom, narc_members
    m = narc_members(Rom(version.SOURCE_DUMP).read(BATT_OBJ))
    ball = _oam_cells(_lz10(m[BALL_FILES[0]]), _lz10(m[BALL_FILES[2]]))[0]
    bpal = _pal16(m[BALL_FILES[1]])
    out = {}
    for g in (0, 1):
        cells = _oam_cells(_lz10(m[THROW_FILES[0] + g]), _lz10(m[THROW_FILES[2] + g]))
        pal = _pal16(m[THROW_FILES[1] + g])
        labs = [_lab(c) for c in pal]
        near = {v: min(range(1, 16), key=lambda j: sum((a - b) ** 2 for a, b in zip(_lab(bpal[v]), labs[j])))
                for v in set(ball.values())}
        for k, (bx, by) in BALL_IN_HAND.items():
            for (x, y), v in ball.items(): cells[k][(bx + x, by + y)] = near[v]
        seq = [s for s in __import__('mcss').parse_anim(_lz10(m[THROW_FILES[3] + g]))][0]['frames']
        assert [r['idx'] for _, r in seq] == list(range(5)), seq
        ticks = [2 * d for d, _ in seq]
        ticks[0] += RELEASE_TICK - sum(ticks[:RELEASE_CELL])
        assert ticks[0] > 0, ticks
        out[g] = ([{(x, y + PEARL_DY): v for (x, y), v in c.items()} for c in cells], ticks, pal)
    return out


def _medoids(counts, k=15, iters=50):
    """k of the colours {rgb: pixels} (k-medoids in Lab, weighted by pixels) and {rgb: chosen rgb}."""
    import numpy as np
    cols = sorted(counts, key=lambda c: (-counts[c], c))
    w = np.array([counts[c] for c in cols], float)
    lab = np.array([_lab_rgb(c) for c in cols])
    d = np.sqrt(((lab[:, None] - lab[None]) ** 2).sum(-1))
    med = list(range(min(k, len(cols))))
    for _ in range(iters):
        near = np.argmin(d[:, med], 1)
        new = []
        for j in range(len(med)):
            members = np.nonzero(near == j)[0]
            new.append(int(members[np.argmin((d[np.ix_(members, members)] * w[members][:, None]).sum(0))]))
        if sorted(new) == sorted(med):
            break
        med = new
    near = np.argmin(d[:, med], 1)
    return [cols[m] for m in med], {cols[i]: cols[med[near[i]]] for i in range(len(cols))}


def _lab_rgb(rgb):
    def f(t): return t ** (1 / 3) if t > 0.008856 else 7.787 * t + 16 / 116
    r, g, b = [((v / 255 + 0.055) / 1.055) ** 2.4 if v > 10 else v / 255 / 12.92 for v in rgb]
    x, y, z = (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.9505, 0.2126 * r + 0.7152 * g + 0.0722 * b, \
        (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.089
    return 116 * f(y) - 16, 500 * (f(x) - f(y)), 200 * (f(y) - f(z))


def fan_throw():
    """The fan-made Lucas back: ([4 poses {(x, y): index} in Black 2 sprite coordinates], [ticks], 16 colours,
    the ball's start in sprite coordinates)."""
    from PIL import Image
    from collections import Counter
    im = Image.open(os.path.join(ROOT, FAN_PNG)).convert('RGB')
    w = im.width
    px = im.load()
    bg = px[0, 0]
    solid = lambda x, y: px[x, y] != bg
    cols = [x for x in range(w) if any(solid(x, y) for y in range(FAN_ROWS))]
    spans, s0 = [], cols[0]
    for a, b in zip(cols, cols[1:] + [None]):
        if b != a + 1:
            spans.append((s0, a)); s0 = b
    assert len(spans) == 4, f'{FAN_PNG}: {len(spans)} frames in the top row, not 4'
    last = max(y for y in range(FAN_ROWS) if any(solid(x, y) for x in range(w)))
    anchors = [min(x for x in range(x0, x1 + 1) if solid(x, last)) for x0, x1 in spans]
    counts = Counter(px[x, y] for x0, x1 in spans for x in range(x0, x1 + 1) for y in range(FAN_ROWS) if solid(x, y))
    chosen, to = _medoids(counts)
    index = {c: i + 1 for i, c in enumerate(chosen)}
    pal = [0] + [sprites.rgb_to_bgr555(c) for c in chosen]
    pal += [0] * (16 - len(pal))
    dx = FAN_ANCHOR_SCREEN[0] - BACK_ORIGIN[0]
    dy = FAN_ANCHOR_SCREEN[1] - BACK_ORIGIN[1] - last
    poses = []
    for (x0, x1), a in zip(spans, anchors):
        poses.append({(x - a + dx, y + dy): index[to[px[x, y]]]
                      for x in range(x0, x1 + 1) for y in range(FAN_ROWS) if solid(x, y)})
    k = next(i for i, (x0, x1) in enumerate(spans) if x0 <= FAN_BALL[0] <= x1)
    assert k == FAN_RELEASE_FRAME - 1, (k, FAN_BALL)
    ball = (FAN_BALL[0] - anchors[k] + dx, FAN_BALL[1] + dy)
    ticks = list(FAN_TICKS)
    ticks[0] = RELEASE_TICK - sum(ticks[1:FAN_RELEASE_FRAME])
    assert ticks[0] > 0, ticks
    return poses, ticks, pal, ball


# ---- the ball's start: screen points of the backs' hands -> points of the battle scene (see above)
SENDOUT_CAMERA = ((16.7, 7.7, 33.3), (6.0, 4.6, 16.0))      # default + effect 0x232's relative move
FOV_SIN, FOV_COS, ASPECT = 0x399 / 4096, 0xF97 / 4096, 1.35
SENDOUT_UP = 2.0                                            # 0x234's emitter offset y (8192), added to the start
EMIT_Z = 0x500 / 4096                                       # BtlvEffvm_InitEmitter adds it to both ends
BALL_HAND = (-10240, 7782, 49152)                           # 0x234's start of the player's balls


def scene_to_screen(p, camera):
    """Screen (x, y) of a scene point through Black 2's battle camera, as the ortho emitters place their start."""
    (cx, cy, cz), (tx, ty, tz) = camera
    f = (tx - cx, ty - cy, tz - cz); n = sum(v * v for v in f) ** 0.5; f = tuple(v / n for v in f)
    s = (f[1] * 0 - f[2] * 1, f[2] * 0 - f[0] * 0, f[0] * 1 - f[1] * 0); n = sum(v * v for v in s) ** 0.5
    s = tuple(v / n for v in s)
    u = (s[1] * f[2] - s[2] * f[1], s[2] * f[0] - s[0] * f[2], s[0] * f[1] - s[1] * f[0])
    d = (p[0] - cx, p[1] - cy, p[2] - cz)
    xv, yv, zv = (sum(a * b for a, b in zip(d, e)) for e in (s, u, f))
    cot = FOV_COS / FOV_SIN
    return 128 + xv * cot / ASPECT / zv * 4 * 32, 96 - yv * cot / zv * 3 * 32


def screen_to_scene(screen, depth, camera, up):
    """The script's start (fx32 x, y, z) whose emitter shows at screen (x, y): z = depth, the emitter adds `up` to y
    and EMIT_Z to z (Newton's method on x, y)."""
    x = y = 0.0
    for _ in range(40):
        f = lambda a, b: scene_to_screen((a, b + up, depth + EMIT_Z), camera)
        e = 1e-4
        sx, sy = f(x, y); ax, ay = f(x + e, y); bx, by = f(x, y + e)
        j = ((ax - sx) / e, (bx - sx) / e, (ay - sy) / e, (by - sy) / e)
        rx, ry = screen[0] - sx, screen[1] - sy
        det = j[0] * j[3] - j[1] * j[2]
        x += (rx * j[3] - ry * j[1]) / det; y += (ry * j[0] - rx * j[2]) / det
    assert all(abs(a - b) < 0.01 for a, b in zip(f(x, y), screen)), (screen, f(x, y))
    return round(x * 4096), round(y * 4096), round(depth * 4096)


def ball_starts(release):
    """{trainer class: (x, y, z) fx32}: each back's release point (sprite coordinates) as 0x234's start."""
    old = scene_to_screen((BALL_HAND[0] / 4096, BALL_HAND[1] / 4096 + SENDOUT_UP, BALL_HAND[2] / 4096 + EMIT_Z),
                          SENDOUT_CAMERA)
    assert abs(old[0] - 51) < 2 and abs(old[1] - 89) < 2, f'Black 2\'s start projects to {old}, filmed at (51, 89)'
    return {g: screen_to_scene((BACK_ORIGIN[0] + x, BACK_ORIGIN[1] + y), START_DEPTH[g], SENDOUT_CAMERA, SENDOUT_UP)
            for g, (x, y) in release.items()}


def backs():
    """{0 Lucas (the fan back), 1 Dawn (Pearl's)}: (poses, ticks, colours, the ball's start in sprite coordinates)."""
    poses, ticks, pal, ball = fan_throw()
    out = {0: (poses, ticks, pal, ball)}
    dawn = pearl_throws()[1]
    out[1] = dawn + ((PEARL_RELEASE[0], PEARL_RELEASE[1] + PEARL_DY),)
    return out


def _pack(boxes, W=256, H=128):
    """boxes [(w, h)] (multiples of 8) -> the fewest-pieces greedy packing over all orders: [(box, row, h, u, v)]."""
    import itertools
    best = None
    for order in itertools.permutations(range(len(boxes))):
        free, out = [(0, 0, W, H)], []
        for k in order:
            w, h = boxes[k]; y = 0
            while y < h:
                fits = [f for f in free if f[2] >= w and f[3] >= h - y]
                if fits:
                    f = min(fits, key=lambda f: (f[3] - h + y, f[2] - w)); take = h - y
                else:
                    fits = [f for f in free if f[2] >= w and f[3] >= 8]
                    if not fits: break
                    f = max(fits, key=lambda f: f[3]); take = f[3] // 8 * 8
                free.remove(f)
                if f[2] > w: free.append((f[0] + w, f[1], f[2] - w, take))
                if f[3] > take: free.append((f[0], f[1] + take, f[2], f[3] - take))
                out.append((k, y, take, f[0], f[1])); y += take
            if y < h: break
        else:
            if best is None or len(out) < len(best): best = out
    assert best, 'the poses do not fit the 256 x 128 texture'
    return best


def _objs(w, h):
    """A w x h rectangle (multiples of 8) as legal OBJ blocks [(x, y, w, h)]."""
    legal = set(sprites.OBJ_SIZES.values())
    def split(x, y, w, h):
        if (w, h) in legal: return [(x, y, w, h)]
        if w >= h: return split(x, y, w // 2, h) + split(x + w // 2, y, w - w // 2, h)
        return split(x, y, w, h // 2) + split(x, y + h // 2, w, h - h // 2)
    out, y = [], 0
    for bh in [s for s in (64, 32, 16, 8) for _ in range(h)]:
        if y + bh > h: continue
        x = 0
        for bw in [s for s in (64, 32, 16, 8) for _ in range(w)]:
            if x + bw > w: continue
            out += split(x, y, bw, bh); x += bw
        y += bh
    return out


def _layout(poses):
    """[(pose, x0, y0, w, h, {pixel: index})]: each pose's box (rounded up to 8), split in two by columns, widest
    first, each part trimmed to its own pixels, until _pack fits them in the texture."""
    def rect(k, pix):
        xs = [x for x, _ in pix]; ys = [y for _, y in pix]
        return (k, min(xs), min(ys), (max(xs) + 8 - min(xs)) // 8 * 8, (max(ys) + 8 - min(ys)) // 8 * 8, pix)
    rects = [rect(k, p) for k, p in enumerate(poses)]
    while True:
        try:
            _pack([(w, h) for _, _, _, w, h, _ in rects])
            return rects
        except AssertionError:
            pass
        i = max(range(len(rects)), key=lambda i: (rects[i][3] * rects[i][4], -i))
        k, x0, _, w, _, pix = rects[i]
        assert w > 8, 'the poses do not fit the 256 x 128 texture'
        cut = x0 + w // 16 * 8
        parts = [{p: c for p, c in pix.items() if (p[0] < cut) == left} for left in (True, False)]
        rects[i:i + 1] = [rect(k, q) for q in parts if q]


def back_files(entries, s, poses, ticks, pal):
    """{a/0/7/2 file: bytes} for back sprite s throwing with these poses."""
    import math, struct
    first = 8 * s
    rects = _layout(poses)                              # (pose, x0, y0, w, h, pixels) whose boxes fit the texture
    pieces = sorted(_pack([(w, h) for _, _, _, w, h, _ in rects]), key=lambda q: (rects[q[0]][0], q[0], q[1]))
    tex = bytearray(256 * 128)
    cells = []                                          # (pose, x, y, w, h, u, v) in sprite coordinates
    for r, row, h, u, v in pieces:
        k, x0, y0, w, _, pix = rects[r]
        y0 += row
        for (x, y), c in pix.items():
            if y0 <= y < y0 + h: tex[(v + y - y0) * 256 + u + x - x0] = c
        cells.append((k, x0, y0, w, h, u, v))

    def g2d(magic, sections):
        body = b''.join(sections)
        return magic + struct.pack('<HHIHH', 0xFEFF, 0x0100, 16 + len(body), 16, len(sections)) + body

    def sect(magic, data):
        data += bytes(-len(data) % 4)
        return magic + struct.pack('<I', 8 + len(data)) + data

    def others(d):                                      # a file's sections after its first (labels, user data)
        d = mcss._unlz(d); n, off, out = struct.unpack_from('<H', d, 14)[0], 16, []
        for i in range(n):
            size = struct.unpack_from('<I', d, off + 4)[0]
            if i: out.append(d[off:off + size])
            off += size
        return out

    def anim(seqs, etype, atype):                       # NANR / NMAR 'KNBA': seqs [(mode, [(ticks, index)])]
        nfr = sum(len(f) for _, f in seqs)
        head = struct.pack('<HHIIIII', len(seqs), nfr, 0x18, 0x18 + 16 * len(seqs), 0x18 + 16 * len(seqs) + 8 * nfr,
                           0, 0)
        sq, fr, res, i = b'', b'', b'', 0
        for mode, frames in seqs:
            sq += struct.pack('<HHHHII', len(frames), 0, etype, atype, mode, 8 * i)
            for t, idx in frames:
                fr += struct.pack('<IHH', len(res), t, 0xBEEF); res += struct.pack('<H', idx); i += 1
        return sect(b'KNBA', head + sq + fr + res)

    import mcss
    # +2 cells (2D mapping: tile = row * 32 + column of the 256-wide texture)
    cell_tab, oam = b'', b''
    for k, x, y, w, h, u, v in cells:
        objs = _objs(w, h)
        r = max(math.hypot(x + dx, y + dy) for dx in (0, w) for dy in (0, h))
        cell_tab += struct.pack('<HHI', len(objs), min(63, math.ceil(r / 2)), len(oam))
        for ox, oy, ow, oh in objs:
            shape, size = next(sz for sz, wh in sprites.OBJ_SIZES.items() if wh == (ow, oh))
            oam += struct.pack('<HHH', (y + oy) & 0xff | shape << 14, (x + ox) & 0x1ff | size << 14,
                               (v + oy) // 8 * 32 + (u + ox) // 8)
    ncer = g2d(b'RECN', [sect(b'KBEC', struct.pack('<HHIIIII', len(cells), 0, 0x18, 4, 0, 0, 0) + cell_tab + oam)]
               + others(entries[first + 2]))
    # +3 one still sequence per cell; +4 one multi-cell per pose (its bands as nodes); +5 standing, then the throw
    nanr = g2d(b'RNAN', [anim([(2, [(4, c)]) for c in range(len(cells))], 0, 1)] + others(entries[first + 3]))
    mc, hier = b'', b''
    for k in range(len(poses)):
        mine = [c for c in range(len(cells)) if cells[c][0] == k]
        mc += struct.pack('<HHI', len(mine), len(mine), len(hier))
        for j, c in enumerate(mine): hier += struct.pack('<HhhH', c, 0, 0, j << 8 | 0x21)
    nmcr = g2d(b'RCMN', [sect(b'KBCM', struct.pack('<HHIIII', len(poses), 0xBEEF, 0x14, 0x14 + len(mc), 0, 0)
                                       + mc + hier)])
    nmar = g2d(b'RAMN', [anim([(1, [(4, 0)]), (2, list(zip(ticks, range(len(poses)))))], 0, 2)]
               + others(entries[first + 5]))
    # +6 the quads: x * 256, -y * 256, w, h, u, v * 4096, and an unused second quad
    quads = struct.pack('<IHHhh', len(cells), 0, 0, 0, 0) + b''.join(
        struct.pack('<6i', x * 256, -y * 256, w << 12, h << 12, u << 12, v << 12) + bytes(24)
        for _, x, y, w, h, u, v in cells)
    fits = all(-40 <= x < 40 and -80 <= y < 0 for x, y in poses[0])
    still = bytes(poses[0].get((x - 40, y - 80), 0) if fits else 0 for y in range(80) for x in range(80))
    nclr = bytearray(entries[first + 7])
    struct.pack_into('<16H', nclr, 0x18 + struct.unpack_from('<I', nclr, 0x24)[0], *pal)
    return {first: sprites.tr_encode_image(entries[first], 'static', still),
            first + 1: sprites.tr_encode_image(entries[first + 1], 'parts', bytes(tex)),
            first + 2: ncer, first + 3: sprites.lz11_compress(nanr), first + 4: nmcr, first + 5: nmar,
            first + 6: quads, first + 7: bytes(nclr)}


def apply_backs(files):
    entries = narcio.load(files, 72)
    for g, (poses, ticks, pal, _) in backs().items():
        for k, v in back_files(entries, g, poses, ticks, pal).items():
            entries[k] = v
    narcio.save(files, 72, entries)
    return ('battle backs 0 = the fan-made Lucas (4 frames), 1 = Pearl\'s Dawn (5 cells), the throw frame at tick '
            f'{RELEASE_TICK}')


def ball_table(base, starts):
    """The decomp's PearlB2BallStarts (src/pearlb2/ball_start_itcm.c) at base."""
    import struct
    out = struct.pack('<I', len(starts))
    for cls, (x, y, z) in sorted(starts.items()):
        out += struct.pack('<HH3i', cls, 0, x, y, z)
    return out


def apply_code(code):
    """The ball's start at each back's hand: the table in ITCM, its address in gPearlB2BallStarts."""
    import struct, itcm, decomp
    slot = decomp.symbol('gPearlB2BallStarts', code)
    if slot is None:
        return 'ball start: no gPearlB2BallStarts in this decomp (Black 2\'s start for every back)'
    starts = ball_starts({g: b[3] for g, b in backs().items()})
    base, end, _ = itcm.install(code, lambda b: (ball_table(b, starts), {}))
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2BallStarts at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return (f'ball start by the back on show ({end - base} B of ITCM at {base:#x}): '
            + ', '.join(f'class {c} {v}' for c, v in sorted(starts.items())))
