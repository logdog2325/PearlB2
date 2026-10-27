"""The Sunyshore Gym's gears (Pearl's Volkner gym; chapter 8, 2026-10-26) as Black 2's gimmick 62 (the decomp's
src/pearlb2/sunyshore_gym_itcm.c, dispatched by src/pearlb2/gimmick_itcm.c). List it after sinnoh_rooms and
sinnoh_events (the rooms' zones) and zone_effects (the gimmick table), with the other ITCM users:

    build_rom.py ... pastoria_gym ... pearl_platforms snowpoint_gym sunyshore_gym

Pearl (pokediamond InitSunyshoreGym 0x02064D88, the map features of overlay 6; pokeplatinum overlay008/gym_features.c
SunyshoreGym_* and persisted_map_features_init.c): three rooms, each with gears placed by Pearl's code (build models
458-464: gear_dead_end, gear_L, gear_L_alt, gear_T, gear_T_alt, gear_vertical, gear_vertical_alt) on its gear tiles,
turned a quarter per rotation state; each of the four states makes some arm regions solid; the buttons on the gears'
centres (Pearl's step triggers) turn every gear of the room. The tables below are pokeplatinum's, and each one is
found byte for byte in the Pearl dump (checked by `pearl_tables`: Pearl's gear tables also give the model numbers);
the start states and the entrance z are pokediamond InitSunyshoreGym's immediates (2, 1, 0; 14, 21, 25).

- apply(files): the gimmick table (a/1/0/2) gives the three rooms gimmick 62; Pearl's seven gear models (BMD0 with
  their textures) are appended to a/2/9/5 (ARCID_GIMMICK_EXPOBJ_MARINETUBE: the Marine Tube's expanded objects, a
  Unova place no Sinnoh zone uses; nothing else of ours writes it), the gears' expanded-object scene; the buttons'
  step triggers (a/1/2/6) get the walkway's height (raise_buttons), the exit doorways the platform's (fix_doorways);
- apply_code(code): the rooms' table in ITCM, its address in gPearlB2SunyshoreGym (NULL: no gears; the rooms are then
  walkable as converted, with no gears drawn). With each arm region its gear (region_gears): the C gives every gear
  tile a walkway layer at Pearl's walkway height (the gear's tile height + 16, 2 units under as the converted floors:
  the converted rooms have no ground there, only the pits 14 or 62 units below: seen in game 2026-10-26, the player
  sank under the walkway).
The scripts (pearl_story PressSunyshoreGymButton -> pl_RotateSunyshoreGymGear) ask through PVAR_GIMMICK_REQUEST.
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, resident, narcio  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
SOUND_H = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'include', 'generated', 'constants', 'sound.h')
GIMMICK_TABLE_ARC, GIMMICK = 102, 62
MODEL_ARC = 295
ROOMS = ['MAP_SUNYSHORE_GYM_ROOM_1', 'MAP_SUNYSHORE_GYM_ROOM_2', 'MAP_SUNYSHORE_GYM_ROOM_3']
DEFAULT_STATE = (2, 1, 0)          # pokediamond InitSunyshoreGym: the state when not entered from the entrance
ENTRANCE_Z = (14, 21, 25)          # ... and the entrance warp's z (entered there: state 0)
SOUND = 'SEQ_SE_FLD_148'           # [guess] Pearl's SEQ_SE_DP_GAGAGA (the gears grinding): gimmick 59's moving sound
STATES = 4

# pokeplatinum's tables (gym_features.c): gears (x, y, z, initialRotation, turnsClockwise, isVertical) per room
GEARS = [
    [(3, 0, 8, 1, 0, 0), (8, 0, 8, 2, 1, 0), (13, 0, 8, 0, 0, 0)],
    [(6, 0, 8, 1, 0, 0), (11, 0, 8, 3, 1, 0), (15, 3, 8, 1, 1, 1), (2, 3, 13, 1, 0, 1), (6, 0, 13, 2, 1, 0),
     (11, 0, 13, 2, 0, 0)],
    [(6, 6, 8, 1, 0, 0), (11, 6, 8, 0, 1, 0), (16, 6, 8, 0, 0, 0), (2, 3, 13, 0, 1, 1), (6, 6, 13, 1, 1, 0),
     (11, 6, 13, 3, 0, 0), (16, 6, 13, 3, 1, 0), (20, 3, 13, 1, 0, 1), (2, 3, 18, 0, 0, 1), (6, 0, 18, 1, 1, 0),
     (11, 0, 18, 3, 0, 0), (16, 0, 18, 0, 1, 0), (20, 3, 18, 1, 1, 1)],
]
# arm regions (x, z, sizeX, sizeZ) per room
REGIONS = [
    [(1, 8, 2, 1), (3, 6, 1, 2), (4, 8, 2, 1), (3, 9, 1, 2), (6, 8, 2, 1), (8, 6, 1, 2), (9, 8, 2, 1), (8, 9, 1, 2),
     (11, 8, 2, 1), (13, 6, 1, 2), (14, 8, 2, 1), (13, 9, 1, 2)],
    [(4, 8, 2, 1), (6, 6, 1, 2), (7, 8, 2, 1), (6, 9, 1, 2), (9, 8, 2, 1), (11, 6, 1, 2), (12, 8, 2, 1), (11, 9, 1, 2),
     (15, 6, 1, 5), (2, 11, 1, 5), (4, 13, 2, 1), (6, 11, 1, 2), (7, 13, 2, 1), (6, 14, 1, 2), (9, 13, 2, 1),
     (11, 11, 1, 2), (12, 13, 2, 1), (11, 14, 1, 2)],
    [(4, 8, 2, 1), (6, 6, 1, 2), (7, 8, 2, 1), (6, 9, 1, 2), (9, 8, 2, 1), (11, 6, 1, 2), (12, 8, 2, 1), (11, 9, 1, 2),
     (14, 8, 2, 1), (16, 6, 1, 2), (17, 8, 2, 1), (16, 9, 1, 2), (2, 11, 1, 5), (4, 13, 2, 1), (6, 11, 1, 2),
     (7, 13, 2, 1), (6, 14, 1, 2), (9, 13, 2, 1), (11, 11, 1, 2), (12, 13, 2, 1), (11, 14, 1, 2), (14, 13, 2, 1),
     (16, 11, 1, 2), (17, 13, 2, 1), (16, 14, 1, 2), (20, 11, 1, 5), (2, 16, 1, 5), (4, 18, 2, 1), (6, 16, 1, 2),
     (7, 18, 2, 1), (6, 19, 1, 2), (9, 18, 2, 1), (11, 16, 1, 2), (12, 18, 2, 1), (11, 19, 1, 2), (14, 18, 2, 1),
     (16, 16, 1, 2), (17, 18, 2, 1), (16, 19, 1, 2), (20, 16, 1, 5)],
]
# the solid regions of each rotation state (Pearl's lists keep their length with repeats)
LISTS = [
    [(1, 2, 4, 5, 10, 11), (0, 1, 5, 6, 9, 10), (0, 3, 6, 7, 8, 9), (2, 3, 4, 7, 8, 11)],
    [(1, 2, 4, 5, 7, 8, 9, 10, 11, 12, 15), (0, 1, 4, 5, 6, 11, 12, 13, 14, 0, 0),
     (0, 3, 5, 6, 7, 8, 9, 10, 12, 13, 17), (2, 3, 4, 6, 7, 10, 11, 13, 16, 2, 2)],
    [(2, 6, 7, 11, 14, 15, 17, 21, 25, 28, 29, 31, 38, 39), (1, 4, 7, 10, 12, 15, 16, 20, 22, 26, 29, 30, 34, 35),
     (0, 4, 5, 9, 13, 16, 19, 23, 25, 27, 30, 33, 36, 39), (3, 5, 6, 8, 12, 13, 14, 18, 24, 26, 27, 28, 32, 37)],
]


def _dump():
    from gen4rom import Rom
    return Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))


def _find(data, pat, what):
    hits = [m.start() for m in re.finditer(re.escape(pat), data)]
    assert len(hits) == 1, f'{what}: {len(hits)} matches in the Pearl dump'
    return hits[0]


def pearl_tables():
    """[[gear model per gear] per room]: each room's gear table (u32 model, u8 x, y, z, bits: initialRotation:2,
    turnsClockwise:1, isVertical:1), its arm regions and its four state lists found in the Pearl dump, equal to
    pokeplatinum's (GEARS, REGIONS, LISTS)."""
    d = _dump().data
    models = []
    for r, gears in enumerate(GEARS):
        pat = b''.join(b'....' + bytes([x, y, z, rot | cw << 2 | v << 3]) for x, y, z, rot, cw, v in gears)
        hits = [m.start() for m in re.finditer(pat, d, re.S)]
        assert len(hits) == 1, f'Sunyshore Gym room {r + 1} gears: {len(hits)} matches in the Pearl dump'
        models.append([struct.unpack_from('<I', d, hits[0] + 8 * i)[0] for i in range(len(gears))])
        _find(d, bytes(v for reg in REGIONS[r] for v in reg), f'Sunyshore Gym room {r + 1} regions')
        for s, lst in enumerate(LISTS[r]):
            assert len(lst) == len(LISTS[r][0])
            _find(d, bytes(lst), f'Sunyshore Gym room {r + 1} state {s} list')
    assert sorted({m for ms in models for m in ms}) == list(range(458, 465)), models
    return models


def region_gears(r):
    """The gear each arm region of room r belongs to (its walkway's height): a lying gear's four arms are the
    rectangles beside its centre, a standing gear's bridge the rectangle through its centre."""
    out = []
    for rx, rz, w, d in REGIONS[r]:
        own = [g for g, (x, y, z, rot, cw, v) in enumerate(GEARS[r])
               if (v and rx <= x < rx + w and rz <= z < rz + d) or
               (not v and ((rz == z and d == 1 and (rx + w == x or rx == x + 1)) or
                           (rx == x and w == 1 and (rz + d == z or rz == z + 1))))]
        assert len(own) == 1, (r, (rx, rz, w, d), own)
        out.append(own[0])
    return out


def zones():
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))['rooms']['zones']
    b2 = {v['name']: v['b2_zone'] for v in world.values()}
    return [b2[n] for n in ROOMS]


def check_triggers():
    """Pearl's buttons (the rooms' step triggers running RotateSunyshoreGymGear) lie on gear centres (the gimmick turns
    the gears of the room the player is in, whatever the button)."""
    zs = {z['name']: z for z in json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))}
    for r, name in enumerate(ROOMS):
        ev = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'events', f'{zs[name]["events"]:03d}.json')))
        centres = {(x, z) for x, _, z, *_ in GEARS[r]}
        for c in ev['coord_events']:
            assert (c['x'], c['z']) in centres, f'{name}: trigger {(c["x"], c["z"])} is no gear centre'


def apply(files):
    check_triggers()
    rows = narcio.load(files, GIMMICK_TABLE_ARC)
    table = [struct.unpack_from('<II', rows[0], o) for o in range(0, len(rows[0]), 8)]
    ours = set(zones())
    clash = [(z, g) for z, g in table if z in ours]
    table = [(z, g) for z, g in table if z not in ours] + [(z, GIMMICK) for z in sorted(ours)]
    rows[0] = b''.join(struct.pack('<II', z, g) for z, g in table)
    narcio.save(files, GIMMICK_TABLE_ARC, rows)
    from gen4rom import narc_members
    build = narc_members(_dump().read('fielddata/build_model/build_model.narc'))
    m = narcio.load(files, MODEL_ARC)
    assert len(m) == len(narcio.load(VANILLA, MODEL_ARC)), f'a/2/9/5 has {len(m)} files: another patch appended'
    added = []
    for model in range(458, 465):
        assert build[model][:4] == b'BMD0', f'Pearl build model {model} is not a BMD0'
        added.append(build[model])
    narcio.save(files, MODEL_ARC, m + added)
    raised = raise_buttons(files)
    doors = fix_doorways(files)
    return (f'sunyshore_gym: zones {sorted(ours)} -> gimmick {GIMMICK}' + (f' (replacing {clash})' if clash else '') +
            f'; Pearl\'s gear models 458-464 = a/2/9/5 files {len(m)}-{len(m) + 6}; {raised} buttons at walkway height'
            f'; doorways {doors}')


EXITS = [(8, 2), (9, 2), None]     # the rooms' exits north (Pearl's warps to the next room; room 3 has none)


def fix_doorways(files):
    """The exit doorway tiles at the height of the platform in front of them: the converted rooms give the doorway
    (8, 2) / (9, 2) the pit's 0 (Pearl's BDHC: 16 / 64 as the platform; gym chunks keep the converter's model heights),
    so room 1's exit warp (y 14, within 2 units: CheckWarpPositionMatch) never fired and room 2's doorway was a 62-unit
    wall (seen 2026-10-26, build 2). The tile takes the height index of the tile in front (z + 1)."""
    import zoneheaders, pearl_chunk
    headers, _ = zoneheaders.load(files)
    mats, chunks = narcio.load(files, 9), narcio.load(files, 8)
    done = []
    for r, zone in enumerate(zones()):
        if EXITS[r] is None:
            continue
        x, z = EXITS[r]
        m = mats[headers[zone]['matrix']]
        assert struct.unpack_from('<HH', m, 4) == (1, 1), f'room {r + 1}: not a one-chunk room'
        c = struct.unpack_from('<I', m, 8)[0]
        magic, layers, other = pearl_chunk.terrains(chunks[c])
        assert magic == 'WB' and len(layers) == 1, (r, magic)
        t = bytearray(layers[0])
        a0, o0, typ0 = struct.unpack_from('<HHI', t, 4 + 8 * (z * 32 + x))
        a1, o1, typ1 = struct.unpack_from('<HHI', t, 4 + 8 * ((z + 1) * 32 + x))
        assert a0 == a1 == 0 and typ0 == typ1, (r, (a0, o0, typ0), (a1, o1, typ1))
        struct.pack_into('<HHI', t, 4 + 8 * (z * 32 + x), a1, o1, typ1)
        chunks[c] = pearl_chunk.rebuild(magic, other['model'], [bytes(t)], other['props'])
        done.append((zone, (x, z)))
    narcio.save(files, 8, chunks)
    return done


def raise_buttons(files):
    """The buttons' step triggers at the walkway's height: Black 2 runs a trigger only within 2 units of its y
    (ov012 CheckTriggerPositionMatchXYZ), and sinnoh_events gives it the converted floor's height, the pit under the
    gear; on the gear the player walks at the walkway layer, 16 * the gear's y + 14 (sunyshore_gym_itcm.c WalkHeight).
    Seen 2026-10-26 (build 2): with the walkway layers no button turned the gears."""
    import zoneheaders
    from zones import parse_entities, build_entities
    headers, _ = zoneheaders.load(files)
    ents = narcio.load(files, 126)
    n = 0
    for r, zone in enumerate(zones()):
        k = headers[zone]['entities']
        e, _ = parse_entities(ents[k])
        heights = {(x, z): 16 * y + 14 for x, y, z, *_ in GEARS[r]}
        for t in e['triggers']:
            assert (t['x'], t['z']) in heights and t['w'] == t['h'] == 1, (zone, t)
            t['y'] = heights[(t['x'], t['z'])]
            n += 1
        ents[k] = build_entities(e, ents[k])
    narcio.save(files, 126, ents)
    return n


def sound_id(name):
    m = re.search(rf'^#define {name} (0x[0-9a-fA-F]+|\d+)', open(SOUND_H).read(), re.M)
    assert m, f'{name} not in {SOUND_H}'
    return int(m.group(1), 0)


def blob(base):
    models = pearl_tables()
    reg = json.load(open(os.path.join(ROOT, 'data', 'pearl_story_ids.json')))
    request = int(reg['new']['PVAR_GIMMICK_REQUEST']['b2'], 16)
    first_file = len(narcio.load(VANILLA, MODEL_ARC))
    zs = zones()
    head = 12 + 28 * len(ROOMS)
    body, recs = bytearray(), []

    def here(align=4):
        while (head + len(body)) % align:
            body.append(0)
        return base + head + len(body)
    for r in range(len(ROOMS)):
        res = list(dict.fromkeys(models[r]))                  # the room's models, first use first
        at_res = here()
        body.extend(struct.pack(f'<{len(res)}H', *(first_file + m - 458 for m in res)))
        at_gears = here()
        for (x, y, z, rot, cw, v), m in zip(GEARS[r], models[r]):
            body.extend(struct.pack('<8B', res.index(m), x, y, z, rot, cw, v, 0))
        at_regions = here()
        body.extend(bytes(v for reg_ in REGIONS[r] for v in reg_))
        at_lists = here()
        body.extend(bytes(i for lst in LISTS[r] for i in lst))
        at_owner = here()
        body.extend(bytes(region_gears(r)))
        recs.append(struct.pack('<H6B5I', zs[r], len(GEARS[r]), len(res), len(REGIONS[r]), len(LISTS[r][0]),
                                DEFAULT_STATE[r], ENTRANCE_Z[r], at_res, at_gears, at_regions, at_lists, at_owner))
    out = struct.pack('<4HI', len(ROOMS), request, MODEL_ARC, sound_id(SOUND), base + 12) + b''.join(recs)
    assert len(out) == head
    return out + bytes(body)


def apply_code(code):
    import decomp
    slot = decomp.symbol('gPearlB2SunyshoreGym', code)
    if slot is None:
        return 'sunyshore_gym: no gPearlB2SunyshoreGym in this decomp (no gear code): nothing'
    # the table in PearlB2's resident section (b2tools/resident.py), not ITCM
    base, end, _ = resident.install(code, lambda b: (blob(b), {}))
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2SunyshoreGym at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return f'sunyshore_gym: table {end - base} B at {base:#x} (gPearlB2SunyshoreGym {slot:#x})'


if __name__ == '__main__':
    check_triggers()
    print('models per room', pearl_tables())
    b = blob(itcm.ITCM_BASE)
    print(len(b), 'bytes; zones', zones())
