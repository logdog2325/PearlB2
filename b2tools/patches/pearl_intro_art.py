"""Pearl's people in Black 2's intro (user 2026-10-18: "use these pictures of lucas and dawn in the intro and swap
hugh for barrys sprite ... and juniper for rowan"). Black 2's intro graphics are a/1/6/8 (ARCID_INTRO, pokebw2
src/ov294/intro_cmd.c and intro_g3d.c); every file keeps its size, so the archive layout does not move.

- Boy / girl choice: the 8 bpp textures int_swan_m.1/.2 and int_swan_f.1/.2 (128 x 256, 256 colours; .2 bright =
  selected, .1 the same picture at 28 % brightness = not selected, measured on Black 2's own pair) of the models
  a/1/6/8 22 and 23 (both versions' copies) get Lucas and Dawn from the official artwork the user supplied
  (art_sources/intro/lucas.png, dawn.png: git-ignored, like the ROMs). Each is scaled into the box Nate / Rosa fill
  (feet on the same line, centred), cut to an alpha edge and reduced to 255 colours + transparent (index 0).
- The friend: the intro's rival picture (files 10 = 80 x 80 4 bpp OBJ tiles, 11 = palette 0 of 16 colours; one cell of
  six OBJs, file 9, IntroCmd_CreateObj) gets Barry's own Pearl battle picture (80 x 80, 16 colours) from the dump
  (pearl_trainer_pics.pearl_pictures: trfgra.narc).
- The professor: Juniper is an MCSS sprite (files 24 NANR, 25 parts texture 256 x 128, 26 quad table, 27 NCER,
  28 palette, 29 NMAR, 30 NMCR). Her cell 1 is one 64 x 128 rectangle at texture (0, 0) (NANR sequence 0 shows it
  still), the size of Pearl's Rowan picture (the dump's demo/intro/intro.narc file 18, palette 19: pokediamond's
  rowan_front). Rowan goes into that texture area (the rest cleared), his 16 colours into palette 28, and the three
  multi-cells (file 30) become one node each showing NANR sequence 0, placed so his feet stand where Juniper's do
  (her drawn box: x -30..28, y -65..48). The NMAR (file 29) is kept: its three sequences (116, 4 and 148 ticks) still
  end when the intro script waits for them (SET/WAIT_SPRITE_ANIMATION), Rowan just stands still. The talking flag
  (func_0201ac8c, MCSS flipV) has no part to move.
Without art_sources/intro/*.png the boy/girl pictures stay Black 2's (the build says so).
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, sprites  # noqa: E402

ARC_INTRO = 168
GENDER_MODELS = (22, 23)
ART = os.path.join(ROOT, 'art_sources', 'intro')
# (art file, texture prefix, box (x0, y0, x1, y1) Black 2's own picture fills)
GENDER = [('lucas.png', 'int_swan_m', (11, 7, 123, 247)), ('dawn.png', 'int_swan_f', (15, 10, 111, 246))]
DARK = 0.28
RIVAL_NCGR, RIVAL_NCLR = 10, 11
PROF = dict(nanr=24, parts=25, quads=26, ncer=27, nclr=28, nmar=29, nmcr=30)
PEARL_INTRO, ROWAN_NCGR, ROWAN_NCLR = 'demo/intro/intro.narc', 18, 19
JUNIPER_FEET_Y, JUNIPER_CENTRE_X = 48, -1
NODE_ATTR = 0x21                        # as Black 2's nodes: cell animation 0, visible
RIVAL_OBJS = [(0, 0, 64, 64), (64, 0, 16, 32), (64, 32, 16, 32), (0, 64, 32, 16), (32, 64, 32, 16), (64, 64, 16, 16)]


def gender_picture(path, box, size=(128, 256)):
    """(bright, dark) indexed 128 x 256 PIL images of the artwork, scaled into box (bottom-aligned, centred)."""
    from PIL import Image
    art = Image.open(path).convert('RGBA')
    art = art.crop(art.getbbox())
    bw, bh = box[2] - box[0], box[3] - box[1]
    k = min(bh / art.height, (size[0] - 4) / art.width)
    w, h = max(1, round(art.width * k)), max(1, round(art.height * k))
    small = art.resize((w, h), Image.LANCZOS)
    canvas = Image.new('RGBA', size, (0, 0, 0, 0))
    canvas.alpha_composite(small, ((size[0] - w) // 2, box[3] - h))
    alpha = canvas.getchannel('A').point(lambda a: 255 if a >= 128 else 0)
    rgb = canvas.convert('RGB')
    q = rgb.quantize(255, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = q.getpalette()[:255 * 3]
    idx = bytes((i + 1) if a else 0 for i, a in zip(q.tobytes(), alpha.tobytes()))
    def image(scale):
        im = Image.frombytes('P', size, idx)
        p = [0, 0, 0] + [min(255, round(c * scale)) for c in pal]
        im.putpalette(p + [0] * (768 - len(p)))
        return im
    return image(1.0), image(DARK)


def rival_order(w=80):
    order = []
    for ox, oy, ow, oh in RIVAL_OBJS:
        for t in range(ow * oh // 64):
            tx, ty = ox + t % (ow // 8) * 8, oy + t // (ow // 8) * 8
            order += [(ty + j // 8) * w + tx + j % 8 for j in range(64)]
    return order


def pearl_tiled(ncgr):
    """(w, h, indices row-major) of a Pearl intro NCGR (tiled 8 x 8, 4 bpp, not encrypted)."""
    th, tw, depth, _, scanned, size, off = struct.unpack_from('<HHIIIII', ncgr, 0x18)
    assert depth == 3 and scanned == 0
    w, h = tw * 8, th * 8
    t = sprites.unpack4(ncgr[0x18 + off:0x18 + off + size], size * 2)
    pix = bytearray(w * h)
    for k, v in enumerate(t):
        tile, j = divmod(k, 64)
        tx, ty = tile % (w // 8), tile // (w // 8)
        pix[(ty * 8 + j // 8) * w + tx * 8 + j % 8] = v
    return w, h, bytes(pix)


def rowan_picture():
    import version
    from gen4rom import Rom, narc_members
    m = narc_members(Rom(version.SOURCE_DUMP).read(PEARL_INTRO))
    w, h, pix = pearl_tiled(m[ROWAN_NCGR])
    assert (w, h) == (64, 128)
    _, pal = sprites.nclr_colors_any(m[ROWAN_NCLR])   # 256 colours; Rowan's are the first 16 (as pokediamond's .pal)
    return pix, pal[:16]


def professor_files(entries, pix, pal):
    """{file: bytes} of the professor sprite showing `pix` (64 x 128) still."""
    out = {}
    w, h, tex = sprites.tr_decode_image(entries[PROF['parts']], 'parts')
    new = bytearray(w * h)
    for y in range(128):
        new[y * w:y * w + 64] = pix[y * 64:y * 64 + 64]
    out[PROF['parts']] = sprites.tr_encode_image(entries[PROF['parts']], 'parts', bytes(new))
    nclr = bytearray(entries[PROF['nclr']])
    poff = 0x18 + struct.unpack_from('<I', nclr, 0x24)[0]
    struct.pack_into('<16H', nclr, poff, *pal)
    out[PROF['nclr']] = bytes(nclr)
    ys = [y for y in range(128) if any(pix[y * 64:y * 64 + 64])]
    xs = [x for x in range(64) if any(pix[y * 64 + x] for y in range(128))]
    node_x = JUNIPER_CENTRE_X + 32 - (xs[0] + xs[-1] + 1) // 2
    node_y = JUNIPER_FEET_Y + 64 - (ys[-1] + 1)
    d = entries[PROF['nmcr']]
    assert d[0x10:0x14] == b'KBCM'
    n, pad, pdata, phier = struct.unpack_from('<HHII', d, 0x18)
    body = bytearray(d[0x18:0x18 + pdata])                     # counts, offsets and what Black 2 has before the array
    struct.pack_into('<I', body, 8, pdata + 8 * n)             # node array right after the multi-cell array
    body += b''.join(struct.pack('<HHI', 1, 1, 8 * i) for i in range(n))
    body += b''.join(struct.pack('<HhhH', 0, node_x, node_y, NODE_ATTR) for _ in range(n))
    while len(body) % 4: body += b'\0'
    blk = b'KBCM' + struct.pack('<I', 8 + len(body)) + bytes(body)
    head = bytearray(d[:0x10]); struct.pack_into('<I', head, 8, 0x10 + len(blk))
    out[PROF['nmcr']] = bytes(head) + blk
    return out, (node_x, node_y)


def apply(files):
    import tempfile, json
    entries = narcio.load(files, ARC_INTRO)
    done = []
    # boy / girl
    if all(os.path.exists(os.path.join(ART, a)) for a, _, _ in GENDER):
        with tempfile.TemporaryDirectory() as t:
            for art, prefix, box in GENDER:
                bright, dark = gender_picture(os.path.join(ART, art), box)
                for model in GENDER_MODELS:
                    for suffix, im in (('.2', bright), ('.1', dark)):
                        name = prefix + suffix
                        d = os.path.join(t, f'{model}_{name}')
                        os.makedirs(d)
                        im.save(os.path.join(d, 'texture.png'))
                        json.dump({'kind': 'texture', 'archive': ARC_INTRO, 'file': model, 'texture': name,
                                   'palette': name + '_pl'}, open(os.path.join(d, 'sprite.json'), 'w'))
                        new = sprites.tex_import(d, entries[model])
                        assert len(new) == len(entries[model])
                        entries[model] = new
        done.append('Lucas and Dawn on the boy/girl choice')
    else:
        done.append('boy/girl choice kept (no art_sources/intro/lucas.png, dawn.png)')
    # the friend: Barry
    import pearl_trainer_pics
    still, pal = pearl_trainer_pics.pearl_pictures()['PKMN_TRAINER_BARRY']
    ncgr = bytearray(entries[RIVAL_NCGR])
    off, size, _ = sprites.ncgr_pixels(ncgr)
    assert size == 3200, size
    ncgr[off:off + size] = sprites.pack4(bytes(still[p] for p in rival_order()))
    entries[RIVAL_NCGR] = bytes(ncgr)
    nclr = bytearray(entries[RIVAL_NCLR])
    assert nclr[:4] == b'RLCN' and nclr[0x10:0x14] == b'TTLP'
    poff = 0x18 + struct.unpack_from('<I', nclr, 0x18 + 0x0C)[0]
    struct.pack_into('<16H', nclr, poff, *pal[:16])
    entries[RIVAL_NCLR] = bytes(nclr)
    done.append("Barry's Pearl picture as the friend")
    # the professor: Rowan
    pix, pal = rowan_picture()
    prof, at = professor_files(entries, pix, pal)
    for k, v in prof.items():
        entries[k] = v
    done.append(f'Rowan as the professor (node at {at})')
    narcio.save(files, ARC_INTRO, entries)
    return 'pearl_intro_art: ' + '; '.join(done)
