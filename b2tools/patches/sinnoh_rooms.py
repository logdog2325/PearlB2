"""Sinnoh's rooms, caves and separate outdoor maps (every Pearl zone reached through warps from the overworld;
numbers in data/sinnoh_world.json "rooms", allocate_sinnoh.py). Runs after sinnoh_world.

- a/0/0/8: the rooms' Pearl chunks appended after the overworld's (pearl_chunk.convert within their own matrix;
  placements numbered with the rooms' building ids).
- a/0/0/9: one Black 2 matrix per Pearl room matrix, appended after Black 2's 416 (format 0: chunk ids only, every
  cell takes the zone that loaded it); a matrix holding several Pearl zones (rooms['cell_zones']: the Great Marsh's six
  areas, 2026-10-25) is format 1 with a zone per cell, as the overworld's.
- a/2/2/6 + a/1/7/5 (interior) and a/2/2/5 + a/1/7/4 (exterior: Mt. Coronet's mountainsides, Great Marsh, ...):
  one building pack + texture set per Pearl room area.
- a/0/1/3 + a/0/1/4: each Pearl room area -> a Black 2 area record: a copy of the template area's record by Pearl
  map type, its own pack, texture set = Pearl's (area id = set id), no texture animations (the template's name Black
  2 textures). Lights and outlines as Pearl's (maplook 'light', 2026-10-20): Pearl's area data u16 at 6 picks them
  (pokediamond ov05_021F4CBC): 0 = Pearl's constant indoor light (area01light, a light table appended to a/0/6/0)
  and indoor outlines (black for ID group 0, (4,4,4) for the rest, a table appended to a/0/1/5); else the day cycle
  (Black 2's tables 140-143, Pearl's own values, copied with the clear colour black: Pearl's void past a map's edge
  is black, Black 2's tables clear to the sky colour; 2026-10-25) and Pearl's outdoor outlines. The rooms' models
  take their material colours from the light table as Pearl's do ('material'), polygon IDs 56-63 move to group 6
  (Black 2 draws group 7's outlines (16,16,16) whatever the table says).
  Outdoor room areas (that day-cycle light, or exterior: Lake Verity and the lakes, Eterna Forest, Floaroma Meadow,
  Mt. Coronet's mountainsides, the Great Marsh, Amity Square, Pal Park, Trophy Garden, Spear Pillar, ...) also get
  four seasonal records (user 2026-10-19): a free group of Black 2's seasonal area ids (2-281, area id + season), its
  texture sets from sinnoh_reskin.reskin_sets (Pearl's art in spring/summer, Black 2's autumn/winter colours on it,
  the north winter all year); the zones point at the group (work/world/room_season_groups.json).
- a/0/1/2: each room zone's header: map type 16 (up to 4 cells) or 0, its area and matrix, empty scripts and events
  (sinnoh_events fills the events), no wild Pokémon, no preloaded people sprites (NO_PRELOAD); weather, flags and
  camera words from a Black 2 template zone of the same kind (building: Floccesy house 441, cave: Wellspring Cave
  324, outdoor: Route 19 437; patches/zone_flags then sets the flags word from Pearl's own header); parent = the
  overworld zone whose door leads in first. Camera: a boundary (a/1/0/9,
  appended) stops the camera's target where the bottom row of the screen reaches the map's south edge (the black
  lower half at Oreburgh Gym's door and in Oreburgh Mine B2F; Black 2's own rooms keep their camera inside the same
  way).
- The chunks get pearl_chunk's cracks and flicker fixes, the building packs pearl_model_fix.fix_pack (decals 2 units
  over the floor). MAP_FIXES=none: Pearl's models as they are.
Tile heights of every room chunk -> work/world/heights_rooms.json (sinnoh_events).
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders  # noqa: E402
import pearl_chunk, pearl_buildings, pearl_mesh, pearl_model_fix, maplook  # noqa: E402
import pearl_signs, pearl_gimmicks, ramanas, b2_look  # noqa: E402
from b2files import gf_container, gf_container_build, arc_path  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
PEARL = os.path.join(ROOT, 'work', 'pearl')
EMPTY_ENTITIES, EMPTY_SCRIPTS, EMPTY_INIT, NO_ENCOUNTERS = 3, 6, 7, 0x1FFF
TEMPLATE_ZONE = {4: 441, 3: 324, 2: 437, 1: 441, 6: 324}
COPY_FIELDS = ('weather_word', 'flags', 'icon_word', 'bgm0', 'bgm1', 'bgm2', 'bgm3')
NO_PRELOAD = 24     # npc_cache: no Unova sprite list (Route 19's list 18 took 23 of the 32 entries; sinnoh_world)
CAMERA_BOUNDS_ARC, CAMERA_ARC = 109, 59     # a/1/0/9 camera boundaries (u32 count, 24-byte records), a/0/5/9 cameras
SEASONAL_AREAS = range(2, 0x11A)            # Black 2 reads area id + season for these (AreaData_HasSeasons)


def pearl_light_field(rom):
    """{Pearl area: its area data's u16 at 6}: 0 = Pearl's indoor light (area01light) and indoor outlines, else the
    outdoor day cycle (area00light) and outlines (pokediamond ov05_021F4CBC, ov05_021F4968)."""
    ad = narc_members(rom.read('fielddata/areadata/area_data.narc'))
    return {i: struct.unpack_from('<H', d, 6)[0] for i, d in enumerate(ad)}


def free_season_groups(headers, world, n):
    """n groups of 4 free seasonal area records (Black 2 picks area id + season in SEASONAL_AREAS): records no zone
    outside Sinnoh's uses and no overworld group holds, aligned as Black 2's own groups (2 + 4k)."""
    sinnoh = {z['b2_zone'] for z in world['zones'].values()} | {z['b2_zone'] for z in world['rooms']['zones'].values()}
    used = {h['area'] for i, h in enumerate(headers) if i not in sinnoh}
    used |= {a['b2_area_group'] + s for a in world['areas'].values() for s in range(4)}
    from allocate_sinnoh import RESERVED_AREAS          # (Black 2 areas the Underground reuses: 198-201, 388)
    used |= RESERVED_AREAS
    out = [g for g in range(2, SEASONAL_AREAS.stop - 3, 4) if not any(g + s in used for s in range(4))]
    assert len(out) >= n, f'only {len(out)} free seasonal area groups, {n} needed'
    return out[:n]


def camera_below(files, camera_index):
    """Units of floor a Black 2 field camera shows below its target (the bottom row of the screen)."""
    import math
    rec = narcio.load(files, CAMERA_ARC)[0][44 * camera_index:44 * camera_index + 44]
    zoom, pitch = struct.unpack_from('<iI', rec, 0)
    fov = struct.unpack_from('<H', rec, 18)[0]
    d = zoom / 4096 if zoom > 4096 * 64 else zoom
    a, f = pitch / 65536 * 2 * math.pi, fov / 65536 * 2 * math.pi
    return d * math.cos(a) - d * math.sin(a) / math.tan(a + f)


def load_matrix(mid):
    return json.load(open(os.path.join(PEARL, 'matrices', f'{mid:03d}.json')))


def apply(files):
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    rooms = world['rooms']
    zones = json.load(open(os.path.join(PEARL, 'zones.json')))
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    build = narc_members(rom.read('fielddata/build_model/build_model.narc'))
    texsets = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))
    res_of = {int(k): v for k, v in rooms['building_res'].items()}
    chunk_id = {int(k): v for k, v in world['chunks'].items()}
    chunk_id.update({int(k): v for k, v in rooms['chunks'].items()})

    # chunks (converted inside the first room matrix that holds them)
    where = {}
    for mid in rooms['matrices']:
        m = load_matrix(int(mid))
        for z in range(m['height']):
            for x in range(m['width']):
                c = m['maps'][z][x]
                if c != 0xffff and str(c) in rooms['chunks']: where.setdefault(c, (m, x, z))
    slopes, offsets = pearl_chunk.tables()
    chunks = narcio.load(files, 8)
    first = min(rooms['chunks'].values())
    assert len(chunks) == first, f'a/0/0/8 has {len(chunks)} entries, expected {first} (sinnoh_world first, once)'
    fixes = maplook.fixes()
    field = pearl_light_field(rom)
    outdoor = {int(pa) for pa, a in rooms['areas'].items() if field.get(int(pa)) or a['exterior']}   # seasonal
    day_light = {int(pa) for pa in rooms['areas'] if field.get(int(pa))}       # Pearl's outdoor day cycle
    area_of_chunk = {}
    for r in rooms['zones'].values():
        for row in load_matrix(r['pearl_matrix'])['maps']:
            for c in row:
                if c != 0xffff: area_of_chunk.setdefault(c, r['pearl_area'])
    heights, problems, extent, fixed, floor_fixed, low = {}, [], {}, {}, [], {}
    for c, b2 in sorted(rooms['chunks'].items(), key=lambda kv: kv[1]):
        c = int(c); m, x, z = where[c]
        data, rep = pearl_chunk.convert(c, slopes, offsets, pearl_chunk.neighbours(m, x, z))
        # (exit mats and the stairs' feet stay walkable; each flight is solid with its 45-degree plane: pearl_chunk)
        magic, layers, part = pearl_chunk.terrains(data)    # ('GC': two layers, bridges with a way under them)
        secs = [room_model(part['model'], area_of_chunk.get(c) in day_light, fixes)]
        mm = pearl_mesh.Model(secs[0])
        P = [mm.units(v) for sh in mm.shapes for poly in sh.polys for v in poly]
        if P: extent[c] = (min(p[0] for p in P), max(p[0] for p in P), min(p[2] for p in P), max(p[2] for p in P))
        fixed[c] = rep.get('fixes', {})
        props = json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))['props']
        props = b2_look.placed_props(c, props)              # (the lakes' water planes are in the chunk model now)
        props = pearl_chunk.people_props_moved(c, props)   # (on a counter or table the people fix sinks)
        props = props + pearl_gimmicks.extra_props(c)      # (props Pearl's code adds: the Canalave Gym's floors and
        # platforms, a lift; after the chunk's own, so their indices are fixed: patches/pearl_platforms.py moves them)
        place, bad = pearl_buildings.placements(props, res_of)
        problems += [f'chunk {c}: {b}' for b in bad]
        signed = [pearl_signs.chunk(c, t, place, rep) for t in layers]   # Pearl's signs: sign models, solid
        if c in ramanas.park_chunks():                     # (Pal Park: the Ramanas rooms' doorways, b2tools/ramanas.py)
            signed = [ramanas.chunk(c, t, p, rep) for t, p in signed]
        chunks.append(pearl_chunk.rebuild(magic, secs[0], [t for t, _ in signed], signed[0][1]))
        heights[c] = {f'{tx},{tz}': y for (tx, tz), y in rep['heights'].items()}
        if rep['heights_low']: low[c] = {f'{tx},{tz}': y for (tx, tz), y in rep['heights_low'].items()}
        floor_fixed += [(c,) + t for t in rep.get('mats', [])]   # warp mats put on their floor (pearl_chunk.floor_mats)
    narcio.save(files, 8, chunks)
    os.makedirs(os.path.join(ROOT, 'work', 'world'), exist_ok=True)
    json.dump(heights, open(os.path.join(ROOT, 'work', 'world', 'heights_rooms.json'), 'w'))
    json.dump(low, open(os.path.join(ROOT, 'work', 'world', 'heights_rooms_low.json'), 'w'))   # (under bridges)

    # matrices
    mats = narcio.load(files, 9)
    first_m = min(r['b2_matrix'] for r in rooms['matrices'].values())
    assert len(mats) == first_m, (len(mats), first_m)
    b2_of_room = {int(p): r['b2_zone'] for p, r in rooms['zones'].items()}
    for mid, r in sorted(rooms['matrices'].items(), key=lambda kv: kv[1]['b2_matrix']):
        m = load_matrix(int(mid))
        cells = [chunk_id[c] if c != 0xffff else 0xFFFFFFFF for row in m['maps'] for c in row]
        if int(mid) in rooms.get('cell_zones', []):
            # several zones in one matrix (the Great Marsh's six areas, 2026-10-25): format 1, a zone per cell as
            # Pearl's matrix headers give them (the overworld's layout, sinnoh_world); a border cell with no zone
            # takes the nearest area's
            inner = [(cz, cx, b2_of_room[h]) for cz, row in enumerate(m['headers']) for cx, h in enumerate(row) if h]
            zid = [min(inner, key=lambda t: (max(abs(t[0] - cz), abs(t[1] - cx)), t[0], t[1]))[2]
                   for cz in range(m['height']) for cx in range(m['width'])]
            mats.append(struct.pack('<HHHH', 1, 0, m['width'], m['height']) + struct.pack(f'<{len(cells)}I', *cells)
                        + struct.pack(f'<{len(zid)}I', *zid))
            continue
        mats.append(struct.pack('<HHHH', 0, 0, m['width'], m['height']) + struct.pack(f'<{len(cells)}I', *cells))
    narcio.save(files, 9, mats)

    # building packs: interior after Black 2's 93, exterior after the overworld's
    for exterior, (parc, tarc) in ((False, (226, 175)), (True, (225, 174))):
        packs, btex = narcio.load(files, parc), narcio.load(files, tarc)
        assert len(packs) == len(btex)
        for a in sorted((a for a in rooms['areas'].values() if a['exterior'] == exterior), key=lambda a: a['b2_pack']):
            assert len(packs) == a['b2_pack'], (exterior, len(packs), a['b2_pack'])
            pack, tex = pearl_buildings.build_pack([(res_of[mm], build[mm]) for mm in a['models']]
                                                   + pearl_signs.models(a)    # (Pearl's signs, if the area has any)
                                                   + ramanas.models(a))       # (Pal Park's doorways)
            if os.environ.get('MAP_FIXES') != 'none':
                pack, _ = pearl_model_fix.fix_pack(pack)   # (shadows, rugs, mats 2 units over the floor: flicker)
            pa = next(int(k) for k, v in rooms['areas'].items() if v is a)
            magic, secs = gf_container(pack)
            pack = gf_container_build(magic, [room_model(sec, pa in day_light, fixes) if sec[:4] == b'BMD0' else sec
                                              for sec in secs])
            packs.append(pack); btex.append(tex)
        narcio.save(files, parc, packs); narcio.save(files, tarc, btex)

    # areas and their texture sets
    area_path = arc_path(files, 13)
    area_tab = bytearray(open(area_path, 'rb').read())
    vanilla_areas = open(arc_path(VANILLA, 13), 'rb').read()
    sets = narcio.load(files, 14)
    light_on = 'light' in fixes
    if light_on:
        indoor_lights = maplook.pearl_indoor_lights(files, rom)
        outdoor_lights = maplook.outdoor_room_lights(files)     # (140-143 clearing to black, as Pearl: 2026-10-25)
        edges = {True: maplook.pearl_edges(files, False), False: maplook.pearl_edges(files, True)}
    headers0, _ = zoneheaders.load(files)
    groups = dict(zip(sorted(outdoor), free_season_groups(headers0, world, len(outdoor))))
    season_sets = {}
    if groups:                     # outdoor rooms (lakes, Eterna Forest, Mt. Coronet's sides, ...): the overworld's
        sys.path.insert(0, HERE)   # seasons (sinnoh_reskin: Pearl's art in spring/summer, recoloured in autumn/winter,
        import sinnoh_reskin
        room_chunks = sorted(c for c, pa in area_of_chunk.items() if pa in groups)   # the north winter all year)
        season_sets, _ = sinnoh_reskin.reskin_sets(
            maplook.texture_fixes(fixes), {str(pa): dict(rooms['areas'][str(pa)], b2_area_group=g)
                                           for pa, g in groups.items()}, room_chunks)
    for pa, a in rooms['areas'].items():
        pa = int(pa)
        b2, t = a['b2_area'], a['template']
        rec = bytearray(vanilla_areas[10 * t:10 * t + 10])
        struct.pack_into('<HH', rec, 0, a['b2_pack'], b2)
        rec[4] = rec[5] = 0xFF                                  # no SRT / pattern animation
        srt = b2_look.room_srt(pa)                              # (but Black 2's water's own SRT: b2_look)
        if srt is not None: rec[4] = srt
        rec[6] = 1 if a['exterior'] else 0
        if light_on:                                            # Pearl's light and outlines (maplook)
            rec[7] = outdoor_lights[0] if pa in day_light else indoor_lights
            rec[8] = edges[pa in day_light]
            if pa in day_light: rec[9] = maplook.ACTOR_COLOURS_OUTDOOR
        area_tab[10 * b2:10 * b2 + 10] = rec
        sets[b2] = b2_look.room_set(texsets[a['pearl_texset']], pa)   # (+ Black 2's water and grass textures)
        if pa in groups:                                        # its four seasons
            g = groups[pa]
            for s in range(4):
                r4 = bytearray(rec)
                struct.pack_into('<H', r4, 2, g + s)
                if light_on and pa in day_light: r4[7] = outdoor_lights[s]
                area_tab[10 * (g + s):10 * (g + s) + 10] = r4
                sets[g + s] = season_sets.get(g + s, texsets[a['pearl_texset']])
    open(area_path + '.tmp', 'wb').write(area_tab); os.replace(area_path + '.tmp', area_path)
    narcio.save(files, 14, sets)
    json.dump({str(pa): g for pa, g in groups.items()},
              open(os.path.join(ROOT, 'work', 'world', 'room_season_groups.json'), 'w'))

    # zone headers
    vanilla_headers, _ = zoneheaders.load(VANILLA)
    headers, entries = zoneheaders.load(files)
    parent = parents(world, zones)
    bounds = narcio.load(files, CAMERA_BOUNDS_ARC)
    nvanilla_bounds = len(narcio.load(VANILLA, CAMERA_BOUNDS_ARC))
    bound_files = {}
    for pid, r in rooms['zones'].items():
        b2 = r['b2_zone']
        hd = headers[b2]
        tmpl = vanilla_headers[TEMPLATE_ZONE.get(zones[int(pid)]['map_type'], 441)]
        for f in COPY_FIELDS: hd[f] = tmpl[f]
        area = groups.get(r['pearl_area'], rooms['areas'][str(r['pearl_area'])]['b2_area'])
        hd.update(map_type=r['b2_map_type'], area=area,
                  matrix=rooms['matrices'][str(r['pearl_matrix'])]['b2_matrix'], scripts=EMPTY_SCRIPTS,
                  init_scripts=EMPTY_INIT, encounters=NO_ENCOUNTERS, enc_slot=0, entities=EMPTY_ENTITIES,
                  parent=parent.get(int(pid), b2), cam_bound=0xFFFF, fly_x=0, fly_y=0, fly_z=0, npc_cache=NO_PRELOAD)
        hd['weather_word'] &= ~0x3F
        cam = maplook.room_camera(files, zones[int(pid)]['camera'], fixes)   # (maplook's experimental 'camera'
        if cam is not None:                                                # or 'tilt': from the room's Pearl camera)
            hd['weather_word'] = (hd['weather_word'] & ~(0x7F << 9)) | (cam << 9)
        # the camera stops where its bottom row reaches the map's south edge (Black 2's rooms keep their camera
        # inside with a boundary; ours showed black past the last row: Oreburgh Gym's door, Oreburgh Mine B2F)
        m = load_matrix(r['pearl_matrix'])
        south = [cz * 512 + 256 + extent[c][3] for cz, row in enumerate(m['maps']) for c in row if c in extent]
        if south:
            below = camera_below(files, (hd['weather_word'] >> 9) & 0x7F)
            rect = struct.pack('<I', 1) + struct.pack('<6i', 1, 0, -100000, 100000, -100000,
                                                      int(max(south) - below))
            if rect not in bound_files:
                i = next((k for k in range(nvanilla_bounds, len(bounds)) if bounds[k] == rect), None)
                if i is None: bounds.append(rect); i = len(bounds) - 1
                bound_files[rect] = i
            hd['cam_bound'] = bound_files[rect]
    narcio.save(files, CAMERA_BOUNDS_ARC, bounds)
    zoneheaders.save(files, headers, entries)
    over = [c for c, f in fixed.items() if f.get('over') or 'underfloor' not in f.get('steps', ['underfloor'])]
    return (f"sinnoh_rooms: {len(rooms['zones'])} zones, {len(rooms['matrices'])} matrices from {first_m}, "
            f"{len(rooms['chunks'])} chunks from {first}, {len(rooms['areas'])} areas ({len(groups)} outdoor ones "
            f"seasonal: groups {sorted(groups.values())}), {len(bound_files)} camera boundaries; chunks without "
            f"the full cracks fix: {over}; {len(floor_fixed)} warp mats put on their floor; problems {problems[:5]}")


def room_model(bmd, day_light, fixes):
    """A room's map or building model as Pearl lights and outlines it (maplook): material colours from the light
    table ('material'), Black 2's outdoor lamp set-up for areas on the day cycle ('lamps'), polygon IDs 56-63 moved
    to group 6 ('light': Pearl's outlines)."""
    if 'material' in fixes or ('lamps' in fixes and day_light):
        bmd, _ = maplook.relight_model(bmd, 'lamps' in fixes and day_light, 'material' in fixes)
    if 'light' in fixes:
        bmd, _ = maplook.remap_ids(bmd)
    return bmd


def parents(world, zones):
    """Pearl room -> the Black 2 zone of the overworld zone whose warps reach it first (breadth first)."""
    b2 = {int(k): v['b2_zone'] for k, v in world['zones'].items()}
    out, todo = {}, sorted(b2)
    top = {z: z for z in b2}
    while todo:
        pid = todo.pop(0)
        ev = json.load(open(os.path.join(PEARL, 'events', f"{zones[pid]['events']:03d}.json")))
        for w in ev['warp_events']:
            d = w['dest_header_id']
            if str(d) in world['rooms']['zones'] and d not in out:
                out[d] = b2[top[pid]]; top[d] = top[pid]; todo.append(d)
    return out
