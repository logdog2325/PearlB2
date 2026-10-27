"""Pearl's placed buildings (props) -> a Black 2 building pack, its texture set, and each chunk's placement list.
Phase 2 converter, step 2 (notes/WORLD.md).

Pearl: a chunk's props name a model of fielddata/build_model/build_model.narc (BMD0 with its own TEX0) at a position
(fx32, chunk-centred, +z south), rotation (x, y, z angles, 0x10000 = 360 degrees) and scale. Doors are separate
props (for example model 67, Twinleaf's door, in front of each house).
Black 2 (HoennB2 notes/GEN5_MAPS.md "Building placements", "Building packs"): a pack (`AB` container, a/2/2/5
exterior) holds n info records then n MDL0-only BMD0 models, its textures are the same-numbered BTX0 of a/1/7/4;
placements are {fx32 x, y, z (z negated), u16 y-rotation, u16 big-endian resId}.

Rotation other than about y and scale other than 1 have no Black 2 equivalent: reported, not converted.
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import nsbtx  # noqa: E402
from b2files import gf_container_build  # noqa: E402

# Black 2's info record of a plain building (pack 52, resId 0x15): resId, type 0, no door, no animation
PLAIN_INFO = bytes.fromhex('15000000ffff00000000' '0000ffff0000000000' '00' 'ffffffffffffffffffffffffffffffff')
assert len(PLAIN_INFO) == 36


def blocks(bmd):
    n = struct.unpack_from('<H', bmd, 0xE)[0]
    offs = [struct.unpack_from('<I', bmd, 0x10 + 4 * k)[0] for k in range(n)] + [len(bmd)]
    return {bmd[offs[k]:offs[k] + 4]: bmd[offs[k]:offs[k + 1]] for k in range(n)}


def mdl_only(bmd):
    """The BMD0 with only its MDL0 block (Black 2's building models carry no textures)."""
    mdl = blocks(bmd)[b'MDL0']
    head = bytearray(bmd[:0x10]) + struct.pack('<I', 0x14)
    struct.pack_into('<I', head, 8, 0x14 + len(mdl))
    struct.pack_into('<H', head, 0xE, 1)
    return bytes(head) + mdl


def btx0_of(bmd):
    """A BTX0 holding the TEX0 block of a BMD0."""
    t = blocks(bmd)[b'TEX0']
    return b'BTX0' + bmd[4:8] + struct.pack('<IHHI', 0x14 + len(t), 0x10, 1, 0x14) + t


def _placeholder():
    """A small texture set for packs whose models bring none: Twinleaf's door model's (Pearl build model 67)."""
    from gen4rom import Rom, narc_members
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    return btx0_of(narc_members(rom.read('fielddata/build_model/build_model.narc'))[67])


PLACEHOLDER_SET = None


def info(res_id):
    return struct.pack('<H', res_id) + PLAIN_INFO[2:]


def build_pack(models):
    """models: [(resId, Pearl BMD0)] -> (pack bytes, texture set bytes)."""
    global PLACEHOLDER_SET
    import pearl_doors          # (Pearl's door models: Black 2 door records with Pearl's own animations)
    import pearl_heal           # (the Pokémon Center's healing machine and its balls: Black 2's heal finds them)
    import pearl_lab_units      # (the Galactic HQ lab's containment units: they open when the trio are freed)
    assert len(models) <= 128, f'{len(models)} models: a pack holds at most 128'
    if PLACEHOLDER_SET is None: PLACEHOLDER_SET = _placeholder()
    texset = None
    for _, bmd in models:
        if b'TEX0' not in blocks(bmd):
            continue
        src = btx0_of(bmd)
        if texset is None:
            texset = src
        else:
            texset = nsbtx.merge(texset, [(src, t, p) for t, p in sorted(nsbtx.material_pairs(bmd))]
                                 + pearl_doors.extra_textures(bmd)      # (+ the elevator door's frames
                                 + pearl_heal.extra_textures(bmd))      #  and the heal balls)
    pack = gf_container_build('AB', [pearl_doors.door_info(r, b) or pearl_heal.info(r, b) or pearl_lab_units.info(r, b) or info(r) for r, b in models]
                              + [mdl_only(b) for _, b in models])
    if texset is None:          # no model brings textures: a placeholder set (every pack needs its texture set entry)
        texset = PLACEHOLDER_SET
    return pack, texset


def placements(props, res_of):
    """Chunk building section from Pearl props ({model, pos, rot, scale}); res_of: Pearl model id -> resId.
    Returns (bytes, problems)."""
    out, problems = [], []
    for p in props:
        x, y, z = p['pos']
        rx, ry, rz = p['rot']
        if rx % 0x10000 or rz % 0x10000 or any(abs(s - 1) > 1e-3 for s in p['scale']):
            problems.append(f"model {p['model']} rot {p['rot']} scale {p['scale']}")
        r = res_of[p['model']]
        out.append(struct.pack('<iiiH', round(x * 4096), round(y * 4096), round(-z * 4096), ry & 0xFFFF)
                   + struct.pack('>H', r))
    return struct.pack('<I', len(out)) + b''.join(out), problems
