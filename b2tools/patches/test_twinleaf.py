"""TEST ONLY (never in a release): Twinleaf and the Route 201 chunk north of it, converted the real way, shown in
Aspertia's two chunks (a/0/0/8 279 = south cell, 280 = north cell; zone 427, where a new game starts).

- pearl_chunk.convert: Pearl's model, tile types and heights (from the models).
- pearl_buildings: Pearl's props of both chunks in a new exterior building pack (appended to a/2/2/5) with its
  texture set (appended to a/1/7/4, same index); Aspertia's four seasonal areas (a/0/1/3 210-213) use it.
- Pearl's terrain textures (Pearl texture set 6) merged into Aspertia's texture sets (a/0/1/4 210-213).
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, nsbtx  # noqa: E402
import pearl_chunk, pearl_buildings  # noqa: E402
from b2files import gf_container, gf_container_build, arc_path  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

PEARL_TEXSET = 6
CELLS = {279: (3, 27), 280: (3, 26)}          # Black 2 chunk -> Pearl matrix 0 cell (Twinleaf, Route 201 south)
AREAS = (210, 211, 212, 213)


def apply(files):
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    matrix = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    build = narc_members(rom.read('fielddata/build_model/build_model.narc'))
    slopes, offsets = pearl_chunk.tables()
    pearl_ids = {}
    for x, z in CELLS.values():
        for p in json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f"{matrix['maps'][z][x]:03d}.json")))['props']:
            pearl_ids.setdefault(p['model'], len(pearl_ids) + 1)          # resId 1.. (0x15 is Black 2's default)
    pack, texset = pearl_buildings.build_pack([(r, build[m]) for m, r in pearl_ids.items()])
    packs, btex = narcio.load(files, 225), narcio.load(files, 174)
    assert len(packs) == len(btex)
    pack_id = len(packs)
    packs.append(pack); btex.append(texset)
    narcio.save(files, 225, packs); narcio.save(files, 174, btex)
    areas = bytearray(open(arc_path(files, 13), 'rb').read())
    for a in AREAS:
        struct.pack_into('<H', areas, 10 * a, pack_id)
    open(arc_path(files, 13) + '.tmp', 'wb').write(areas); os.replace(arc_path(files, 13) + '.tmp', arc_path(files, 13))
    chunks = narcio.load(files, 8)
    report, models = [], []
    for b2, (x, z) in CELLS.items():
        c = matrix['maps'][z][x]
        data, rep = pearl_chunk.convert(c, slopes, offsets, pearl_chunk.neighbours(matrix, x, z))
        magic, secs = gf_container(data)
        props = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))['props']
        place, problems = pearl_buildings.placements(props, pearl_ids)
        chunks[b2] = gf_container_build(magic, [secs[0], secs[1], place])
        models.append(secs[0])
        report.append(f'{b2}<-Pearl {c}: {len(props)} buildings, misses {len(rep["height_misses"])}, problems {problems}')
    narcio.save(files, 8, chunks)
    pearl_set = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))[PEARL_TEXSET]
    pairs = sorted(set().union(*(nsbtx.material_pairs(m) for m in models)))
    sets = narcio.load(files, 14)
    for a in AREAS:
        sets[a] = nsbtx.merge(sets[a], [(pearl_set, t, p) for t, p in pairs])
    narcio.save(files, 14, sets)
    return f'test_twinleaf: pack {pack_id} ({len(pearl_ids)} models), {len(pairs)} terrain textures; ' + '; '.join(report)
