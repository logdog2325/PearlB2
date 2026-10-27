"""The trainer card's 3D badges (top screen, when a badge is touched) for Sinnoh: src/trainer_card/badge3d_N.nsbmd, N = 0..7
in Pearl's badge order (installed by b2tools/patches/trainer_card.py as a/0/3/9 files 56-63). Ported from HoennB2's
b2tools/trainer_card_models.py.

    python3 b2tools/trainer_card_models.py          (needs Java: b2tools/java/ToNsbmd.java --vcol --tex, with
                                                     CTRMap.jar + CTRMapV-1.4.1.jar from PEARL_CTRMAP_DIR, default
                                                     HoennB2's tools/ folder, read only)

Black 2's are Unova-shaped models (gym01-gym08: one mesh in the XZ plane, 16-40 units wide, 55-66 long, ~3 thick, two
32x64 textures, vertex colours). Each Sinnoh one is Pearl's own badge-case badge (trainer_case.narc, polished: palette
row 0; patches/trainer_card.pearl_badges), 1:1 in a 64x64 texture (the 40x40 box centred, the rest clear), on a plate:
the face on both sides (the back mirrored, so it reads the right way round when the badge turns) and four inner layers
in a darker shade, which show as the badge's edge when it turns side-on. The badge's 40 texels span 55 units, Black
2's badges' length. No new drawing: the picture is Pearl's, the plate only carries it.
"""
import importlib.util, os, subprocess, sys
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from dae import Model                                                    # noqa: E402

OUT = os.path.join(ROOT, 'src', 'trainer_card')
WORK = os.environ.get('PEARL_TRAINER_CARD_WORK') or os.path.join(ROOT, 'work', 'trainer_card')
CTRMAP = os.environ.get('PEARL_CTRMAP_DIR') or os.path.expanduser('~/Documents/GitHub/HoennB2/tools')
TEX = 64                 # texture side (texels)
HALF = 44.0              # half the plate's side, units: the 40-texel badge spans 55 units
THICK = 1.5              # half its thickness
EDGE = (0.55, 0.55, 0.6)


def card_patch():
    spec = importlib.util.spec_from_file_location('trainer_card_patch', os.path.join(HERE, 'patches', 'trainer_card.py'))
    m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    return m


def badge_png(badge, path, box_of):
    crop, rgb = badge
    box = box_of(crop)
    o = (TEX - len(box)) // 2
    out = Image.new('RGBA', (TEX, TEX))
    for y in range(len(box)):
        for x in range(len(box)):
            v = box[y][x]
            if v: out.putpixel((o + x, o + y), (*rgb[v], 255))
    out.save(path)


def plate(name):
    m = Model(name)
    h, t = HALF, THICK
    # (z grows toward the bottom of the picture: v = 0 at z = -h)
    def layer(y, up, col, mirror=False):
        u0, u1 = (1, 0) if mirror else (0, 1)
        a = (-h, y, -h, u0, 0); b = (h, y, -h, u1, 0); c = (h, y, h, u1, 1); d = (-h, y, h, u0, 1)
        m.quad(name, [a, d, c, b] if up else [a, b, c, d], col)
    layer(t, True, (1.0, 1.0, 1.0))                      # face (+y)
    layer(-t, False, (1.0, 1.0, 1.0), mirror=True)       # back (-y), mirrored
    for i in range(1, 5):                                # the edge: inner layers, both ways
        y = -t + 2 * t * i / 5
        layer(y, True, EDGE); layer(y, False, EDGE, mirror=True)
    return m


def main():
    os.makedirs(WORK, exist_ok=True); os.makedirs(OUT, exist_ok=True)
    tc = card_patch()
    badges = tc.pearl_badges()
    J = os.path.join(WORK, 'java')
    CP = f"{J}:{CTRMAP}/CTRMap.jar:{CTRMAP}/ctrmap-plugins/CTRMapV-1.4.1.jar"
    os.makedirs(J, exist_ok=True)
    subprocess.run(['javac', '-cp', CP, '-d', J, os.path.join(HERE, 'java', 'ToNsbmd.java')], check=True)
    for k in range(8):
        name = f'sbadge{k}'
        badge_png(badges[k], os.path.join(WORK, name + '.png'), tc.badge_box)
        plate(name).write(os.path.join(WORK, name + '.dae'), wrap={name: ('CLAMP', 'CLAMP')})
        open(os.path.join(WORK, 'palettes.txt'), 'a' if k else 'w').write(f'{name} {name}_pl\n')
    for k in range(8):
        name = f'sbadge{k}'
        r = subprocess.run(['java', '-Djava.awt.headless=true', '-cp', CP, 'ToNsbmd', '--vcol', '--tex',
                            os.path.join(WORK, name + '.dae'), os.path.join(OUT, f'badge3d_{k}.nsbmd'),
                            os.path.join(WORK, 'palettes.txt')], capture_output=True, text=True)
        print(r.stdout.strip(), r.stderr.strip()[:300])


if __name__ == '__main__':
    main()
