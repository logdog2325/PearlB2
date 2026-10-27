"""Pearl's hidden paths (the Spring Path, the Seabreak Path) as Black 2 map replacements: b2tools/pearl_hidden_paths.py
says what and why (2026-10-26, chapter 9a). List it right after sinnoh_rooms (its chunks go after every room's).

- a/0/0/8: one new chunk per cell of each path, converted as sinnoh_world converts the overworld's (pearl_chunk.convert
  with the cell's neighbours, the props through pearl_buildings, Pearl's signs, and maplook's relight of the map-look
  fixes sinnoh_reskin applies to the overworld's chunks), appended after the last chunk.
- a/0/0/9 entry 0 (Sinnoh's matrix 0, format 1): a 'hide' path's cells show their new chunk.
- a/0/1/0 file 0: one entry per cell (matrix 0, kind 0, the path's event condition: values[0] -> values[1]).
- work/world/heights_hidden.json: the revealed maps' heights, for the people standing on them (pearl_hidden_paths
  OBJECTS; sinnoh_events reads it through pearl_events).
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402
import pearl_chunk, pearl_buildings, pearl_signs, maplook, pearl_hidden_paths  # noqa: E402
from b2files import gf_container, gf_container_build  # noqa: E402

MAP_REPLACE_ARC, CHUNK_ARC, MATRIX_ARC = 10, 8, 9


def convert(c, x, z, matrix, res_of, slopes, offsets, chosen):
    """(chunk bytes, report) of Pearl map c at matrix 0's cell (x, z), as sinnoh_world (+ maplook's relight)."""
    data, rep = pearl_chunk.convert(c, slopes, offsets, pearl_chunk.neighbours(matrix, x, z), pearl_chunk.ENTRANCES)
    magic, layers, part = pearl_chunk.terrains(data)
    props = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))['props']
    place, bad = pearl_buildings.placements(props, res_of)
    assert not bad, (c, bad)
    signed = [pearl_signs.chunk(c, t, place, rep) for t in layers]
    blob = pearl_chunk.rebuild(magic, part['model'], [t for t, _ in signed], signed[0][1])
    if 'lamps' in chosen or 'material' in chosen:
        magic, secs = gf_container(blob)
        model, _ = maplook.relight_model(secs[0], 'lamps' in chosen, 'material' in chosen)
        blob = gf_container_build(magic, [model] + secs[1:])
    return blob, rep


def apply(files):
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    matrix = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    res_of = {int(k): v for k, v in world['building_res'].items()}
    rooms_last = max(world['rooms']['chunks'].values())
    chunks = narcio.load(files, CHUNK_ARC)
    assert len(chunks) == rooms_last + 1, (f'a/0/0/8 has {len(chunks)} entries, expected {rooms_last + 1}: list '
                                           f'pearl_paths right after sinnoh_rooms, once')
    mats = narcio.load(files, MATRIX_ARC)
    fmt, _, w, h = struct.unpack_from('<HHHH', mats[0], 0)
    assert fmt == 1 and (w, h) == (matrix['width'], matrix['height']), 'matrix 0 is not Sinnoh\'s (sinnoh_world first)'
    cells = list(struct.unpack_from(f'<{w * h}I', mats[0], 8))
    replace = bytearray(narcio.load(files, MAP_REPLACE_ARC)[0])
    slopes, offsets = pearl_chunk.tables()
    chosen = maplook.fixes()
    heights, report = {}, []
    for path in pearl_hidden_paths.PATHS:
        for (x, z), c in sorted(path['cells'].items(), key=lambda kv: (kv[0][1], kv[0][0])):
            own = world['chunks'][str(matrix['maps'][z][x])]
            assert cells[z * w + x] == own, (path['name'], x, z, cells[z * w + x], own)
            blob, rep = convert(c, x, z, matrix, res_of, slopes, offsets, chosen)
            new = len(chunks)
            chunks.append(blob)
            if path['mode'] == 'reveal':
                old, shown = own, new
                heights.setdefault(path['name'], {}).update(
                    {f'{x * 32 + tx},{z * 32 + tz}': y for (tx, tz), y in rep['heights'].items()})
            else:
                cells[z * w + x] = new                  # hidden until the event: the hiding map there
                old, shown = new, own
            replace += struct.pack('<HBB6H', 0, 0, path['condition'], old, shown, 0, 0, 0, 0xFFFF)
            report.append(f'{path["name"]} ({x},{z}) Pearl map {c} -> chunk {new}')
    narcio.save(files, CHUNK_ARC, chunks)
    mats[0] = mats[0][:8] + struct.pack(f'<{w * h}I', *cells) + mats[0][8 + 4 * w * h:]
    narcio.save(files, MATRIX_ARC, mats)
    entries = narcio.load(files, MAP_REPLACE_ARC)
    entries[0] = bytes(replace)
    narcio.save(files, MAP_REPLACE_ARC, entries)
    os.makedirs(os.path.dirname(pearl_hidden_paths.HEIGHTS), exist_ok=True)
    tmp = pearl_hidden_paths.HEIGHTS + '.tmp'
    json.dump(heights, open(tmp, 'w'))
    os.replace(tmp, pearl_hidden_paths.HEIGHTS)
    return f'pearl_paths: {len(report)} chunks and map replacements ({"; ".join(report)})'
