"""Sinnoh's overworld as Black 2's matrix 0 (notes/WORLD.md; numbers in data/sinnoh_world.json, allocate_sinnoh.py).

- a/0/0/8: Pearl's 175 overworld chunks appended (pearl_chunk.convert: model with the cracks and flicker fixes,
  tile types, heights; placements from pearl_buildings with the global building ids).
- a/0/0/9 entry 0: replaced by Sinnoh's 30 x 30 matrix (format 1: chunk + zone per cell). Matrix 0 because Black 2
  records the Escape Rope exit only when leaving matrix 0 (GetIsZoneMatrix0, src/system/zonedata.c:676).
- a/0/1/2: each Sinnoh zone's header: map type 0, its area group, matrix 0, fly point (a walkable tile near the middle
  of the zone), no preloaded people sprites (NO_PRELOAD below). For now: no events (entities file 3, Black 2's
  empty one), no scripts (files 6/7, empty), no wild Pokémon; Black 2's music and place name. Zone 427 (Twinleaf,
  where a new game starts) gets script file TWINLEAF_SCRIPTS (src/field_scripts/1289_twinleaf_newgame.s: Black 2's
  opening scene stripped). Every zone's fly point goes to work/world/fly.json for patches/scripts.py (run
  sinnoh_world first). Before that, the header file grows past Black 2's 615 to the end of allocate_sinnoh's
  reserved blocks (zoneheaders.extend: 615 stays the "no zone" dummy, then blank headers; notes/ZONE_TABLE.md).
- a/0/1/3 + a/0/1/4: each Pearl area -> a seasonal group of 4 Black 2 area records, all four with Pearl's own texture
  set for now (the Black 2 re-skin comes with data/texture_map.json) and the area's new building pack.
- a/2/2/5 + a/1/7/4: one building pack + building texture set per Pearl area (pearl_buildings.build_pack; the
  buildings' shadow decals and steps 2 units over the ground: pearl_model_fix.fix_pack).
- Pearl's signs (b2tools/pearl_signs.py): Black 2's sign models in every pack and chunk, their tiles solid.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders  # noqa: E402
import pearl_chunk, pearl_buildings, pearl_model_fix  # noqa: E402
import pearl_signs, b2_look  # noqa: E402
from b2files import gf_container, gf_container_build, arc_path  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

EMPTY_ENTITIES, EMPTY_SCRIPTS, EMPTY_INIT, NO_ENCOUNTERS = 3, 6, 7, 0x1FFF
OWN_SCRIPTS = {427: 1289}       # the new-game zone: its scripts 29/30 (src/field_scripts/1289_twinleaf_newgame.s)
# Zone header byte 1 (npc_cache): < 24 = a/0/5/7 list of Unova sprite codes loaded on entry and kept for the whole
# field (ov035 event_mapchange.c LoadMModelSystemInfoCache, ov036 FldActSys_LoadCachedBlact); each takes one of the
# field's 32 billboard material entries (ov036 FldActSys_InitBlAct(..., 0x20)). A sprite that finds the 32 full is
# never drawn, only its shadow (HoennB2 notes/NPC_LIMIT.md). The kept Unova lists took up to 26 entries (Jubilife:
# list 1, 26 codes + the player = 27 of 32; at the entrance scene the counterpart and 3 people had none, 2026-10-20).
# 24 = no list (FldActSys_ClearCache), as 562 of Black 2's 615 zones: each sprite loads when its first person appears.
NO_PRELOAD = 24


def apply(files):
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    matrix = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', '000.json')))
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    build = narc_members(rom.read('fielddata/build_model/build_model.narc'))
    texsets = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))
    res_of = {int(k): v for k, v in world['building_res'].items()}
    zone_of = {int(k): v['b2_zone'] for k, v in world['zones'].items()}
    w, h = matrix['width'], matrix['height']

    # chunks
    slopes, offsets = pearl_chunk.tables()
    first_cell = {}
    for z in range(h):
        for x in range(w):
            c = matrix['maps'][z][x]
            if c != 0xffff: first_cell.setdefault(c, (x, z))
    chunks = narcio.load(files, 8)
    first = min(world['chunks'].values())
    assert len(chunks) == first, f'a/0/0/8 has {len(chunks)} entries, expected {first} (run sinnoh_world once, first)'
    walk, problems, heights, low = {}, [], {}, {}
    for c, b2 in sorted(world['chunks'].items(), key=lambda kv: kv[1]):
        c = int(c); x, z = first_cell[c]
        data, rep = pearl_chunk.convert(c, slopes, offsets, pearl_chunk.neighbours(matrix, x, z),
                                        pearl_chunk.ENTRANCES)   # bump warps outdoors (stairs: their solid flight)
        magic, layers, part = pearl_chunk.terrains(data)    # ('GC': two layers, bridges with a way under them)
        props = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))['props']
        props = b2_look.placed_props(c, props)              # (lake water planes moved into the chunk model)
        place, bad = pearl_buildings.placements(props, res_of)
        problems += [f'chunk {c}: {b}' for b in bad]
        signed = [pearl_signs.chunk(c, t, place, rep) for t in layers]   # Pearl's signs: sign models, solid
        chunks.append(pearl_chunk.rebuild(magic, part['model'], [t for t, _ in signed], signed[0][1]))
        walk[c] = rep['walkable']
        heights[c] = {f'{x},{z}': y for (x, z), y in rep['heights'].items()}
        if rep['heights_low']: low[c] = {f'{x},{z}': y for (x, z), y in rep['heights_low'].items()}
    narcio.save(files, 8, chunks)
    os.makedirs(os.path.join(ROOT, 'work', 'world'), exist_ok=True)
    json.dump(heights, open(os.path.join(ROOT, 'work', 'world', 'heights_overworld.json'), 'w'))   # sinnoh_events
    json.dump(low, open(os.path.join(ROOT, 'work', 'world', 'heights_overworld_low.json'), 'w'))   # (under bridges)

    # matrix 0
    cells = [world['chunks'][str(matrix['maps'][z][x])] if matrix['maps'][z][x] != 0xffff else 0xFFFFFFFF
             for z in range(h) for x in range(w)]
    zones = [zone_of.get(matrix['headers'][z][x], 0xFFFFFFFF) for z in range(h) for x in range(w)]
    mats = narcio.load(files, 9)
    mats[0] = struct.pack('<HHHH', 1, 0, w, h) + struct.pack(f'<{w * h}I', *cells) + struct.pack(f'<{w * h}I', *zones)
    narcio.save(files, 9, mats)

    # building packs and their texture sets
    packs, btex = narcio.load(files, 225), narcio.load(files, 174)
    assert len(packs) == len(btex) == min(a['b2_pack'] for a in world['areas'].values())
    for a in sorted(world['areas'].values(), key=lambda a: a['b2_pack']):
        pack, tex = pearl_buildings.build_pack([(res_of[m], build[m]) for m in a['models']] + pearl_signs.models())
        if os.environ.get('MAP_FIXES') != 'none':
            pack, _ = pearl_model_fix.fix_pack(pack)   # (shadows and steps 2 units over the ground: flicker)
        packs.append(pack); btex.append(tex)
    narcio.save(files, 225, packs); narcio.save(files, 174, btex)

    # area records and map texture sets
    area_path = arc_path(files, 13)
    area_tab = bytearray(open(area_path, 'rb').read())
    sets = narcio.load(files, 14)
    group_of = {}
    for pa, a in world['areas'].items():
        g = a['b2_area_group']; group_of[int(pa)] = g
        for s in range(4):
            struct.pack_into('<HH', area_tab, 10 * (g + s), a['b2_pack'], g + s)
            area_tab[10 * (g + s) + 6] = 1                                    # isExterior
            sets[g + s] = texsets[a['pearl_texset']]
    open(area_path + '.tmp', 'wb').write(area_tab); os.replace(area_path + '.tmp', area_path)
    narcio.save(files, 14, sets)

    # zone headers; first the zones past Black 2's 615 (notes/ZONE_TABLE.md: 615 the dummy, then blank headers to the
    # end of allocate_sinnoh's last reserved block, or past it if sinnoh_world.json says so), which sinnoh_rooms and
    # the features' patches fill in, so that every later patch finds its zone
    from allocate_sinnoh import APPEND_END
    headers, entries = zoneheaders.load(files)
    appended = zoneheaders.extend(headers, zoneheaders.zones_needed(world, APPEND_END))
    fly = {}
    for pid, zinfo in world['zones'].items():
        pid = int(pid); b2 = zinfo['b2_zone']
        tiles = {(x * 32 + tx, z * 32 + tz): y for z in range(h) for x in range(w) if matrix['headers'][z][x] == pid
                 for (tx, tz), y in walk.get(matrix['maps'][z][x], {}).items()}
        assert tiles, f"{zinfo['name']}: no walkable tile"
        mx = sum(t[0] for t in tiles) / len(tiles); mz = sum(t[1] for t in tiles) / len(tiles)
        fx, fz = min(tiles, key=lambda t: (t[0] - mx) ** 2 + (t[1] - mz) ** 2)
        fly[b2] = (fx, tiles[(fx, fz)] // 16, fz)
        hd = headers[b2]
        hd.update(map_type=0, area=group_of[zinfo['pearl_area']], matrix=0, encounters=NO_ENCOUNTERS, enc_slot=0,
                  entities=EMPTY_ENTITIES, parent=b2, fly_x=fx, fly_y=0, fly_z=fz, npc_cache=NO_PRELOAD,
                  cam_bound=0xFFFF)   # no camera boundary, as in Pearl (and as sinnoh_rooms gives the rooms): a kept
                                      # Unova boundary (Route 203 had 431) held the camera on Unova coordinates, so
                                      # nothing was drawn at all (found in game 2026-10-19; Black 2 uses 0 as a real
                                      # boundary too, so 0 is not "none")
        hd['weather_word'] &= ~0x3F                                             # clear weather (0-5) for now
        hd.update(scripts=OWN_SCRIPTS.get(b2, EMPTY_SCRIPTS), init_scripts=EMPTY_INIT)
    zoneheaders.save(files, headers, entries)
    os.makedirs(os.path.join(ROOT, 'work', 'world'), exist_ok=True)
    json.dump(fly, open(os.path.join(ROOT, 'work', 'world', 'fly.json'), 'w'), indent=0)
    return (f'sinnoh_world: {len(world["chunks"])} chunks from {first}, matrix 0 {w}x{h}, {len(world["zones"])} zones, '
            f'{len(world["areas"])} areas/packs, {len(headers)} zone headers ({appended} appended); '
            f'problems: {problems[:5]}{" ..." if len(problems) > 5 else ""}')
