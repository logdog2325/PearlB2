"""Pokémon Pearl NDS's title screen (notes/TITLE.md; user's choices 2026-10-18: a Sapphire/Ruby/Emerald-style top
screen with logo draft 3, and Pearl's own bottom screen with Palkia's outline).

Top (a/0/2/6 files 0-3): data/title/logo.png + strip.png (title_art.py drafts / use 3), packed by title_art.pack_top
as HoennB2's patches/title.py does; the archive is padded to Black 2's size (layout unchanged). Black 2's PRESS START
and "Developed by GAME FREAK inc." stay (as in the Hoenn games).

Bottom: Black 2's title draws its 3D scene through a generic scene setup in overlay 162 (src/ov162/title.c sSceneSetup:
resources from a/1/5/8 = ARCID_DEMO3D_RESOURCE, actors = model + animations). Pearl's title draws Palkia's outline as
3D too: Pearl's demo/title/titledemo.narc file 5 (model `title_air`, its own textures: the pink aura) and file 18
(its texture animation). Both are appended to a/1/5/8; the scene's resource 0 (Kyurem's model, file 447) and
resource 1 (its animation, 446) point at them; the scene keeps 2 resources and 1 actor (actor 0 = model 0, textures
0, animation 1, as Black 2's), so Kyurem's other actors and resources are not loaded. Black 2's camera path (file 453)
still runs: framing Palkia is checked in game (notes/TITLE.md).

Code (ov162, base 0x0219CE80; HoennB2's edits, bytes checked): no 29 s layer swap, no motion blur, Palkia's cry
(species 484, form 0) on Start; arm9: Black 2's opening movie skipped.
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, title_art  # noqa: E402
from b2files import arc_path  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

ARC_DEMO3D = 158
OV162 = 0x0219CE80
SCENE_SETUP, RESOURCES = 0x021A14B0, 0x021A1620          # sSceneSetup {resources, u16 7, actors, u16 3}; sResources
PALKIA = 484
CAMERA_POS, CAMERA_TARGET = 0x021A148C, 0x021A1498         # sCameraPosition, sCameraTarget (ov162 rodata)
# Palkia from its side, head at the right, filling the screen's height (as Pearl's own title, compared with a
# DeSmuME shot of the user's dump); model units, overridable for tuning: PEARL_TITLE_CAM / PEARL_TITLE_LOOK="x y z"
_cam = lambda var, default: tuple(int(float(v) * 4096) for v in os.environ.get(var, default).split())
# 2026-10-20 (user: "you can't see Palkia's full face and outline"; picked the profile): from Palkia's right side,
# level with it, aimed at its middle: the whole outline, head facing left (hwtest/title_tune.sh D; was -105 -30 25 /
# 0 0 -10, from below: the head was cut off)
CAMERA_AT = _cam('PEARL_TITLE_CAM', '170 20 40')
CAMERA_LOOK = _cam('PEARL_TITLE_LOOK', '0 20 0')
PEARL_MODEL, PEARL_ANIM = 5, 18                           # titledemo.narc: title_air (Palkia) + its texture animation
NEW_FILES = 'pearl_title_files'                            # set by apply(): the two new a/1/5/8 ids, for apply_code

CODE = {
    'arm9_ov162.bin': [# the actor loops are hard-coded to 3 actors (bind, draw, step, set frame): 3 -> 1 (tested
                       # 2026-10-18: with the scene cut to 1 actor and the loops at 3 the game crashed into VRAM)
                       (0x0219d5b6 - OV162, '0328', '0128'),   # TitleG3D_Init: cmp r0, #3 -> #1
                       (0x0219d756 - OV162, '032d', '012d'),   # TitleG3D_Draw: cmp r5, #3 -> #1 (draw)
                       (0x0219d7a0 - OV162, '0328', '0128'),   # TitleG3D_Draw: cmp r0, #3 -> #1 (animations)
                       (0x0219d836 - OV162, '0328', '0128'),   # TitleG3D_SetFrame: cmp r0, #3 -> #1 (addresses found by bytes: the listing drifts 2 after a pool)
                       # a fixed camera on Palkia (Black 2's camera path, file 453, frames Kyurem: too close for
                       # Palkia's model, ~111 x 118 units): no per-frame curve camera, and the camera's start
                       # position/target (sCameraPosition / sCameraTarget, passed to GFL_G3DCameraCreate)
                       (0x0219d726 - OV162, '78f6bdfd', 'c046c046'),   # TitleG3D_Draw: bl GFL_G3DCurveApplyCamera -> nop nop
                       (CAMERA_POS - OV162, '00' * 12, struct.pack('<3i', *CAMERA_AT).hex()),
                       (CAMERA_TARGET - OV162, '00' * 12, struct.pack('<3i', *CAMERA_LOOK).hex()),
                       (0xB4, 'cc060000', 'ffffffff'),      # Title_UpdateTimer: HIDE_LAYERS_FRAMES 1740 -> never
                       (0x1B0, '86020000', struct.pack('<I', PALKIA).hex()),   # PokeVoice_Play species 646 -> 484
                       (0x12C, '0221', '0021'),             # ... form 2 (Black Kyurem) -> 0
                       (0x476, '0c20', '1020'),             # TitleSys_Init: captureEva 12 -> 16
                       (0x458, '0425', '0025'),             # ... captureEvb 4 -> 0
                       (0x172, '0821', '1021'),             # Title_HandleInput: SetCaptureBlend(8, 8) -> (16,
                       (0x174, '0822', '0022')],            # ... 0)
    'arm9.bin': [(0x02036332 - 0x02004000, '0220', '0320')],   # StartMenuEventTick: skip Black 2's opening movie
}


def pad_narc(data, size):
    data = bytearray(data)
    off = struct.unpack_from('<H', data, 0xC)[0]
    for _ in range(2):
        off += struct.unpack_from('<I', data, off + 4)[0]
    assert data[off:off + 4] == b'GMIF'
    extra = size - len(data)
    struct.pack_into('<I', data, off + 4, struct.unpack_from('<I', data, off + 4)[0] + extra)
    struct.pack_into('<I', data, 8, size)
    return bytes(data + bytes(extra))


def apply(files):
    # top screen
    art = title_art.DATA
    logo, pal, size = title_art.load_indexed(os.path.join(art, 'logo.png'))
    strip, pal2, size2 = title_art.load_indexed(os.path.join(art, 'strip.png'))
    assert size == size2 == (256, 192) and pal == pal2
    top, top_tiles = title_art.pack_top(logo, strip, pal)
    entries = list(title_art.title_entries())
    for k, v in top.items():
        entries[k] = v
    narcio.save(files, title_art.ARC_TITLE, entries)
    path = arc_path(files, title_art.ARC_TITLE)
    orig = os.path.getsize(arc_path(title_art.SRC_FILES, title_art.ARC_TITLE))
    data = open(path, 'rb').read()
    if len(data) > orig:
        raise SystemExit(f'a/0/2/6 is {len(data)} bytes, over Black 2\'s {orig}')
    open(path, 'wb').write(pad_narc(data, orig))
    # bottom screen: Pearl's Palkia outline into a/1/5/8
    title = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read('demo/title/titledemo.narc'))
    assert title[PEARL_MODEL][:4] == b'BMD0' and title[PEARL_ANIM][:4] == b'BTA0'
    demo = narcio.load(files, ARC_DEMO3D)
    ids = (len(demo), len(demo) + 1)
    demo += [title[PEARL_MODEL], title[PEARL_ANIM]]
    narcio.save(files, ARC_DEMO3D, demo)
    os.makedirs(os.path.join(ROOT, 'work', 'world'), exist_ok=True)
    open(os.path.join(ROOT, 'work', 'world', NEW_FILES), 'w').write(f'{ids[0]} {ids[1]}\n')
    return f'pearl_title: logo {top_tiles}/512 tiles; Palkia model + animation = a/1/5/8 {ids[0]}, {ids[1]}'


def apply_code(code):
    model, anim = map(int, open(os.path.join(ROOT, 'work', 'world', NEW_FILES)).read().split())
    done = []
    for name, edits in CODE.items():
        path = os.path.join(code, name)
        data = bytearray(open(path, 'rb').read())
        for at, old, new in edits:
            o, n = bytes.fromhex(old), bytes.fromhex(new)
            assert data[at:at + len(o)] in (o, n), f'{name} {at:#x}: unexpected {data[at:at + len(o)].hex()}'
            data[at:at + len(o)] = n
        if name == 'arm9_ov162.bin':
            r, s = RESOURCES - OV162, SCENE_SETUP - OV162
            assert struct.unpack_from('<IH', data, r) == (ARC_DEMO3D, 447)
            assert struct.unpack_from('<IH', data, r + 12) == (ARC_DEMO3D, 446)
            assert struct.unpack_from('<IHHIH', data, s) == (RESOURCES, 7, 0, 0x021A1578, 3)
            struct.pack_into('<H', data, r + 4, model)
            struct.pack_into('<H', data, r + 12 + 4, anim)
            struct.pack_into('<H', data, s + 4, 2)                 # resources: Palkia's model + animation
            struct.pack_into('<H', data, s + 12, 1)                # actors: Palkia only
        if os.path.islink(path): os.unlink(path)
        open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
        done.append(f'{name}: {len(edits)} edits')
    return '; '.join(done) + ' (Palkia outline, no Kyurem, no 29 s swap, no blur, Palkia\'s cry, no opening movie)'
