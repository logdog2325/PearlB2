"""The credits' photos for Sinnoh (chapter 8, 2026-10-26; the lead: "12 greyscale Sinnoh scenes with no player + the
colour final picture"), from emulator shots of our own maps, HoennB2's way (its work/agents/halloffame/tools/
credits_pics.py, read only) without the player in colour: Black 2's photos (a/2/1/5, patches/game_clear.py) are
greyscale scenes in a white frame, 224x160 at (16, 16) on a 256x192 screen (a 1 px grey 165 line, 3 px of white, the
photo 216x152 at (20, 20)), colour 0 transparent; here every place is shot without the player (the test tool hides
the player's actor for the shot; the place's own people stay), so one set serves Lucas and Dawn. The grey is darkened to Black 2's tone
(gamma 1.35, the DS's 5-bit levels). The final picture (Black 2's N and Zekrom: 256x160 at y 16, rows 0-15 and
176-191 colour 0) is a colour shot.

    python3 b2tools/credits_photos.py SPEC.json      SPEC: {"photos": [[shot.png, place, dy], ... 12], "final": [shot.png, place]}

Writes data/credits/NN_<slug>.png, final_<slug>.png and data/credits/credits.json (both gender entries the same file).
"""
import json, os, re, sys
import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
OUT = os.path.join(ROOT, 'data', 'credits')
GREY_OUT, WHITE = 165, 255
GAMMA = 1.35


def ds(c):
    return (c * 31 + 127) // 255 * 255 // 31


def indexed(rgb, transparent, band=False):
    h, w, _ = rgb.shape
    mask0 = np.all(rgb == transparent, axis=2)
    if band:
        mask0 = np.zeros((h, w), bool)
        mask0[:16] = True
        mask0[176:] = True
    cols = {tuple(c) for c in rgb[~mask0].reshape(-1, 3)}
    if len(cols) > 255:
        im = Image.fromarray(rgb.astype(np.uint8)).quantize(255, method=Image.Quantize.MEDIANCUT,
                                                            dither=Image.Dither.NONE)
        pal = im.getpalette()[:255 * 3]
        idx = np.asarray(im, dtype=np.int32) + 1
        idx[mask0] = 0
        palette = list(transparent) + pal
    else:
        order = sorted(cols)
        lut = {c: i + 1 for i, c in enumerate(order)}
        idx = np.zeros((h, w), np.int32)
        for y in range(h):
            for x in range(w):
                if not mask0[y, x]:
                    idx[y, x] = lut[tuple(rgb[y, x])]
        palette = list(transparent) + [v for c in order for v in c]
    palette += [0] * (768 - len(palette))
    im = Image.fromarray(idx.astype(np.uint8), 'P')
    im.putpalette(palette)
    return im


def photo(shot, dy=0):
    a = np.asarray(Image.open(shot).convert('RGB').crop((0, 0, 256, 192)), dtype=np.int32)
    lum = 0.299 * a[..., 0] + 0.587 * a[..., 1] + 0.114 * a[..., 2]
    lum = 255.0 * (lum / 255.0) ** GAMMA
    grey = np.vectorize(ds)(np.clip(lum, 0, 255).astype(np.int32))
    src = np.zeros((192, 256), np.int32)
    src[max(0, -dy):192 - max(0, dy)] = grey[max(0, dy):192 - max(0, -dy)]
    out = np.zeros((192, 256, 3), np.int32)
    out[:] = (255, 0, 255)
    out[20:172, 20:236] = np.stack([src] * 3, axis=2)[20:172, 20:236]
    for (x0, y0, x1, y1), c in (((16, 16, 239, 175), GREY_OUT), ((17, 17, 238, 174), WHITE)):
        for x in range(x0, x1 + 1):
            for y in (y0, y1):
                out[y, x] = (c, c, c)
        for y in range(y0, y1 + 1):
            for x in (x0, x1):
                out[y, x] = (c, c, c)
    for d in range(1, 3):
        out[17 + d, 17:239] = WHITE
        out[174 - d, 17:239] = WHITE
        out[17:175, 17 + d] = WHITE
        out[17:175, 238 - d] = WHITE
    return indexed(out, transparent=(255, 0, 255))


def final(shot):
    a = np.asarray(Image.open(shot).convert('RGB').crop((0, 0, 256, 192)), dtype=np.int32)
    out = np.zeros((192, 256, 3), np.int32)
    out[:] = (255, 255, 255)
    out[16:176] = a[16:176]
    out = np.vectorize(ds)(out)
    out[:16] = (255, 255, 255)
    out[176:] = (255, 255, 255)
    return indexed(out, transparent=(255, 255, 255), band=True)


def slug(place):
    return re.sub(r'[^a-z0-9]+', '_', place.lower()).strip('_')


def main(spec_path):
    spec = json.load(open(spec_path))
    os.makedirs(OUT, exist_ok=True)
    assert len(spec['photos']) == 12, 'twelve photos'
    cfg = {'_doc': 'The credits photos (b2tools/patches/game_clear.py: a/2/1/5 photos 0-11, the colour picture "final"): '
                   'indexed 256x192 PNGs made by b2tools/credits_photos.py from emulator shots of our own Sinnoh maps '
                   'without the player, so Lucas and Dawn (m, f) share each file. Order = the credits order.',
           'photos': [], 'final': None}
    for k, (shot, place, dy) in enumerate(spec['photos']):
        name = f'{k:02d}_{slug(place)}.png'
        photo(shot, dy).save(os.path.join(OUT, name))
        cfg['photos'].append({'place': place, 'm': name, 'f': name})
    shot, place = spec['final']
    name = f'final_{slug(place)}.png'
    final(shot).save(os.path.join(OUT, name))
    cfg['final'] = {'place': place, 'file': name}
    json.dump(cfg, open(os.path.join(OUT, 'credits.json'), 'w'), indent=1, ensure_ascii=False)
    print('wrote', len(cfg['photos']), 'photos and', name)


if __name__ == '__main__':
    main(sys.argv[1])
