"""Offline look checks for Sinnoh's overworld textures (notes/MAP_LOOK.md). No emulator, no ROM build.

    python3 maplook_check.py render CHUNK [OUT.png]   four rows (spring, summer, autumn, winter) of three renders:
                                                     Pearl's own textures | before (the 2026-10-18 re-skin with Black
                                                     2's textures) | now (the build's default, or MAPLOOK_FIXES)
    python3 maplook_check.py specks                  texels still in Pearl's colour 0 on recoloured opaque textures
                                                     (before vs now, all four seasons)

CHUNK: a Pearl land chunk (Twinleaf 0, Route 201 5/6, Sandgem 7, Route 202 14, Jubilife 15-18, the plaza in 15).
Work files go to work/maplook/ (overwritten on each run; move the folder to the Trash when done).
The render is textured with no lighting model beyond a slight shade on slopes: at midday Black 2's light saturates
to white on Pearl's materials, so the game shows the texture colours as they are (checked against an in-game shot).
"""
import json, os, sys, subprocess, glob

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, 'patches'))
WORK = os.path.join(ROOT, 'work', 'maplook')
APICULA = os.path.join(ROOT, 'tools', 'apicula')


def _fixes():
    import maplook
    return maplook.texture_fixes()


def _area_of_chunk(chunk):
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    zones = {int(k): v for k, v in world['zones'].items()}
    for z in range(m['height']):
        for x in range(m['width']):
            if m['maps'][z][x] == chunk and m['headers'][z][x] in zones:
                pa = zones[m['headers'][z][x]]['pearl_area']
                return world['areas'][str(pa)]
    raise SystemExit(f'chunk {chunk} is not in an installed overworld zone')


def render(chunk, out=None):
    import sinnoh_reskin, exterior_check
    from gen4rom import Rom, narc_members
    from PIL import Image, ImageDraw
    area = _area_of_chunk(chunk)
    pearl = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read(
        'fielddata/areadata/area_map_tex/map_tex_set.narc'))[area['pearl_texset']]
    before, _ = sinnoh_reskin.reskin_sets()
    now, msg = sinnoh_reskin.reskin_sets(_fixes())
    os.makedirs(WORK, exist_ok=True)
    rows = []
    for season in range(4):
        idx = area['b2_area_group'] + season
        panels = []
        for tag, btx in (('pearl', pearl), ('before', before[idx]), ('now', now[idx])):
            tex = os.path.join(WORK, f'{tag}.nsbtx')
            open(tex, 'wb').write(btx)
            d = os.path.join(WORK, f'c{chunk}_{tag}')
            subprocess.run([APICULA, 'convert', os.path.join(ROOT, 'work', 'pearl', 'land', f'{chunk:03d}.nsbmd'),
                            tex, '-o', d, '-f', 'dae', '--overwrite'], check=True, capture_output=True)
            dae = glob.glob(os.path.join(d, '*.dae'))[0]
            exterior_check._TEX.clear()
            parts = [(n, tp, P, UV, A, tag) for n, tp, P, UV, A in exterior_check.load_dae(dae)]
            panels.append(exterior_check.render(parts, (-256, -256, 256, 256), 1.0))
        rows.append(panels)
    w, h = rows[0][0].size
    sheet = Image.new('RGB', (3 * w + 8, 4 * (h + 14)), (0, 0, 0))
    draw = ImageDraw.Draw(sheet)
    for r, panels in enumerate(rows):
        for k, im in enumerate(panels):
            sheet.paste(im, (k * (w + 4), r * (h + 14) + 14))
            draw.text((k * (w + 4) + 4, r * (h + 14) + 1), ('spring', 'summer', 'autumn', 'winter')[r] + ': '
                      + ('Pearl', 'before', 'now')[k], fill=(255, 255, 255))
    out = out or os.path.join(WORK, f'chunk{chunk}_seasons.png')
    sheet.save(out)
    return f'{out}: Pearl | before | now, spring to winter ({msg})'


def specks():
    """Texels still drawn in Pearl's colour 0 on an opaque texture whose other colours were recoloured (the bright
    Pearl-green lines along path, lawn and tall-grass edges, the Pearl-blue specks on shores)."""
    import struct, sinnoh_reskin, nsbtx, recolour
    from gen4rom import Rom, narc_members
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    pairs = sinnoh_reskin.pearl_pairs(int(c) for c in world['chunks'])
    psets = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read(
        'fielddata/areadata/area_map_tex/map_tex_set.narc'))
    def pal(Pp, name):
        o = dict(Pp['pals'])[name][0] << 3
        return struct.unpack_from(f'<{nsbtx._pal_size(Pp, name) // 2}H', Pp['pdata'], o)
    def count(sets):
        total, names = {}, {}
        for pa, a in world['areas'].items():
            PS = nsbtx._parse(psets[a['pearl_texset']])
            n = 0
            seasons = [nsbtx._parse(sets[a['b2_area_group'] + season]) for season in range(4)]
            for B, (name, (params, _)) in [(B, t) for B in seasons for t in B['texs']]:
                pn = pairs.get(name)
                if (params >> 29) & 1 or not pn or pn not in dict(B['pals']) or pn not in dict(PS['pals']) \
                        or name not in dict(PS['texs']):
                    continue
                bp, pp = pal(B, pn), pal(PS, pn)
                if bp == pp or bp[0] != pp[0]: continue          # kept as Pearl's art on purpose, or recoloured
                k = recolour.colour_counts(B, name, pn).get(pp[0], 0)
                if k: n += k; names.setdefault(pa, []).append(name)
            total[pa] = n
        return total, names
    cur, _ = sinnoh_reskin.reskin_sets()
    fix, _ = sinnoh_reskin.reskin_sets(_fixes())
    (a, an), (b, _) = count(cur), count(fix)
    return '\n'.join(f'Pearl area {pa:>2}: {a[pa]:5d} colour-0 specks before '
                      f'({", ".join(sorted(set(an.get(pa, [])))[:6])}), {b[pa]} now' for pa in a)


if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else ''
    if cmd == 'render':
        print(render(int(sys.argv[2]), sys.argv[3] if len(sys.argv) > 3 else None))
    elif cmd == 'specks':
        print(specks())
    else:
        print(__doc__)
