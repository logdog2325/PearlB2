"""The PWT's Sinnoh Gym Leaders and Jasmine: no white X. Each frame their Black 2 sheets hold as a placeholder becomes
a COPY of one of that sheet's own official frames: no new pixels (the user, 2026-10-25: "I think the gym leaders will
be fine with their current frames just don't use the white X frames").

Black 2 shows these people only in the PWT, standing facing the camera or sideways, so their sheets hold a white X
(a placeholder) for the back view and for the steps toward / away from the camera (b2tools/frame_check.py --sheets):
7-frame sheets (animation set 2: up, up step, down, down step, left + 2 steps; the game mirrors the step for the other
foot and left for right) frames 0, 1, 3; 12-frame sheets (set 3: up, down, left, right x stand + 2 steps) 0-2, 4, 5.
As Sinnoh people they walk away (Roark leaving Oreburgh Mine, Candice into her Gym), toward the camera (Fantina from
the Contest Hall, Gardenia in Eterna Forest, Wake on Route 227, Byron, Jasmine), turn up in scenes (Fantina's Gym)
and turn to a player who talks to them from behind: the X showed (Hearthome, 2026-10-25).

The copies (BACK below; the review sheet shows both choices):
- steps toward the camera -> the front stand frame: they glide toward the camera, legs still;
- the back view and the steps away -> the FRONT stand frame too: facing up or walking away they show their front.
  Not a side frame: Black 2's 7-frame walk away plays its step frame, the stand frame, the step frame MIRRORED and the
  stand frame again (fldmmdl_drawdata.c set 2, animation 4), so a side picture there turns left, right, left as they
  walk; the front picture is symmetric enough to mirror. The 12-frame sheet (Fantina) does not mirror, but uses the
  same front copy so all nine behave alike.
A person who STANDS facing up in Pearl faces down instead (pearl_events.fit_move, "back": "generated" in
data/pearl_sprite_map.json), so a copy shows only while walking or turned by a scene or a talk.
The front and side frames are not touched. Same frame count, size and palette (in place). The sheets are read from
Black 2's own files every time, so the patch can run again on a built tree (a quick non-clean build).

    python3 b2tools/patches/pearl_pwt_frames.py review   -> work/agents/sprites/shots/pwt_frames_review.png
"""
import os, sys
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, sprites  # noqa: E402

# frame roles per frame count
LAYOUT = {7: dict(back=0, back_steps=(1,), front=2, front_steps=(3,), side=4, side_steps=(5, 6)),
          12: dict(back=0, back_steps=(1, 2), front=3, front_steps=(4, 5), side=6, side_steps=(7, 8))}
SHEETS = {277: 'Roark', 278: 'Gardenia', 279: 'Fantina', 280: 'Maylene', 281: 'Crasher Wake', 282: 'Byron',
          283: 'Candice', 284: 'Volkner', 264: 'Jasmine'}
BACK = 'front'          # the back view and the steps away: a copy of the 'front' stand frame (or 'side': the left one)


def is_x(f):
    """A placeholder X (b2tools/frame_check.is_x on the frame's mask)."""
    import frame_check
    m = (f != 0).ravel()
    return 0 < m.sum() < 100 and frame_check.is_x(bytes(m), f.shape[1])


def copies(n, back=BACK):
    """{placeholder frame: the official frame it copies} for an n-frame sheet."""
    lay = LAYOUT[n]
    src = lay['front'] if back == 'front' else lay['side']
    steps = [lay['front'] if back == 'front' else s for s in lay['side_steps']]
    out = {lay['back']: src}
    out.update({i: s for i, s in zip(lay['back_steps'], steps)})
    out.update({i: lay['front'] for i in lay['front_steps']})
    return out


def fill(frames, back=BACK):
    """(frames with every placeholder replaced by a copy, {frame: source}) of one sheet (numpy arrays)."""
    cp = copies(len(frames), back)
    missing = [i for i, f in enumerate(frames) if is_x(f)]
    assert sorted(cp) == missing, (sorted(cp), missing)
    out = [f.copy() for f in frames]
    for i, s in cp.items():
        assert not is_x(frames[s])
        out[i] = frames[s].copy()
    return out, cp


def load(files, code, sheets=None, table=None):
    sheets = sheets or narcio.load(files, sprites.ARC_OW_SHEETS)
    s, _ = sprites.ow_sheet_of(files, code, table)
    fr, _, pal = sprites.btx_decode(sheets[s])
    return s, [np.array(p, np.uint8).reshape(h, w) for _, w, h, p in fr], pal


def apply(files):
    sheets = narcio.load(files, sprites.ARC_OW_SHEETS)
    table = sprites.ow_table(files)
    base = narcio.load(sprites.SRC_FILES, sprites.ARC_OW_SHEETS)       # Black 2's own sheets (no earlier fill)
    done = []
    for code, who in SHEETS.items():
        s, frames, pal = load(sprites.SRC_FILES, code, base, sprites.ow_table(sprites.SRC_FILES))
        assert s == sprites.ow_sheet_of(files, code, table)[0], who
        new, cp = fill(frames)
        sheets[s] = sprites.btx_encode(base[s], [bytes(f.ravel()) for f in new], pal)
        done.append(f'{who} {code} frames {sorted(cp)} = copies of {sorted(set(cp.values()))}')
    narcio.save(files, sprites.ARC_OW_SHEETS, sheets)
    return 'pearl_pwt_frames: ' + '; '.join(done)


def walk_up(frames, n):
    """The pictures Black 2 shows walking up (set 2: step, stand, step mirrored, stand; set 3: step 1, stand, step 2,
    stand), as (frame, mirrored)."""
    return [(1, False), (0, False), (1, True), (0, False)] if n == 7 else [(1, False), (0, False), (2, False), (0, False)]


def review(path=None, codes=None, scale=3):
    """Contact sheet: each leader's Black 2 sheet, the filled one (copies framed), and walking up with each choice."""
    from PIL import Image, ImageDraw, ImageOps
    files = sprites.SRC_FILES
    sheets = narcio.load(files, sprites.ARC_OW_SHEETS)
    table = sprites.ow_table(files)
    rows = []

    def pic(f, rgb, mirror=False):
        im = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
        im.putdata([(0, 0, 0, 0) if v == 0 else rgb[v] for v in f.ravel()])
        im = ImageOps.mirror(im) if mirror else im
        return im.resize((32 * scale, 32 * scale), Image.NEAREST)

    def strip(ims, mark=()):
        im = Image.new('RGBA', (len(ims) * (32 * scale + 6), 32 * scale + 6), (0, 0, 0, 0))
        for k, p in enumerate(ims):
            im.alpha_composite(p, (k * (32 * scale + 6) + 3, 3))
            if k in mark:
                ImageDraw.Draw(im).rectangle([k * (32 * scale + 6), 0, k * (32 * scale + 6) + 32 * scale + 5,
                                              32 * scale + 5], outline=(255, 220, 90, 255), width=2)
        return im
    for code in codes or SHEETS:
        _, before, pal = load(files, code, sheets, table)
        rgb = [sprites.bgr555_to_rgb(c) + (255,) for c in pal]
        after, cp = fill(before, BACK)
        side, _ = fill(before, 'side')
        rows.append((f'{SHEETS[code]} (code {code}, {len(before)} frames): Black 2 PWT sheet',
                     strip([pic(f, rgb) for f in before])))
        rows.append((f'filled: frames {sorted(cp)} = copies of official frames (framed); back = {BACK} frame',
                     strip([pic(f, rgb) for f in after], cp)))
        seq = walk_up(after, len(before))
        rows.append(('walking up, as Black 2 plays it: back = front copy (chosen) | back = side copy (rejected)',
                     strip([pic(after[i], rgb, m) for i, m in seq] + [Image.new('RGBA', (8, 8))]
                           + [pic(side[i], rgb, m) for i, m in seq])))
    W = max(im.width for _, im in rows) + 20
    H = sum(im.height + 18 for _, im in rows) + 10
    out = Image.new('RGBA', (W, H), (88, 112, 128, 255))
    d = ImageDraw.Draw(out)
    y = 6
    for label, im in rows:
        d.text((10, y), label, fill=(255, 255, 255, 255))
        y += 14
        out.alpha_composite(im, (10, y))
        y += im.height + 4
    main = ROOT.split(os.sep + os.path.join('work', 'wt') + os.sep)[0]       # (an agent's tree: the main repo's work/)
    path = path or os.path.join(main, 'work', 'agents', 'sprites', 'shots', 'pwt_frames_review.png')
    os.makedirs(os.path.dirname(path), exist_ok=True)
    out.save(path)
    return path


if __name__ == '__main__':
    a = sys.argv[1:]
    if a[:1] == ['review']:
        codes = [int(x) for x in a[1:] if x.isdigit()]
        print('review ->', review(codes=codes or None))
