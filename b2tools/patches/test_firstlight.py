"""TEST ONLY (never in a release): can Black 2 draw a Pearl map model as it is?

Puts Pearl's Twinleaf model (land_data 0) into Aspertia City's two chunks (a/0/0/8 279 and 280, zone 427: the place a
new game loads first, where Mom's phone call plays) with Black 2's own collision kept and no buildings, and merges the
Pearl textures that model names (Pearl texture set 6) into Aspertia's four seasonal texture sets (a/1/4 210-213).
Look at the phone-call scene after the intro.
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, nsbtx  # noqa: E402
from b2files import gf_container, gf_container_build  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

PEARL_CHUNK, PEARL_TEXSET = 0, 6
B2_CHUNKS = (279, 280)
B2_TEXSETS = (210, 211, 212, 213)


def apply(files):
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    land = narc_members(rom.read('fielddata/land_data/land_data_release.narc'))[PEARL_CHUNK]
    ta, pr, mo, _ = struct.unpack_from('<4I', land, 0)
    model = land[16 + ta + pr:16 + ta + pr + mo]
    chunks = narcio.load(files, 8)
    for c in B2_CHUNKS:
        magic, sections = gf_container(chunks[c])
        assert magic == 'WB', (c, magic)
        chunks[c] = gf_container_build(magic, [model, sections[1], struct.pack('<I', 0)])
    narcio.save(files, 8, chunks)
    pearl_set = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))[PEARL_TEXSET]
    pairs = sorted(nsbtx.material_pairs(model))
    sets = narcio.load(files, 14)
    for t in B2_TEXSETS:
        sets[t] = nsbtx.merge(sets[t], [(pearl_set, tex, pal) for tex, pal in pairs])
    narcio.save(files, 14, sets)
    return f'test_firstlight: Pearl chunk {PEARL_CHUNK} in B2 chunks {B2_CHUNKS}; {len(pairs)} textures into sets {B2_TEXSETS}'
