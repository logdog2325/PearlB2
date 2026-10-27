"""Pearl's moving platforms (2026-10-25, the ch6a agent): the Canalave Gym's floors and 24 platforms and Iron Island's
three platform lifts (and Fantina's Gym's four quiz-room lifts, the first waiting for a flag: 2026-10-26, the ch5b
agent), as Black 2's gimmick 59 (the decomp's src/pearlb2/pearl_platforms_itcm.c, dispatched by
src/pearlb2/gimmick_itcm.c; b2tools/pearl_gimmicks.py reads Pearl's tables from the dump). List it after sinnoh_rooms
(which places the floors and platforms as props of their chunks: pearl_gimmicks.extra_props) and sinnoh_story:

    build_rom.py ... sinnoh_rooms ... sinnoh_story ... pearl_platforms

- apply(files): the gimmick table (a/1/0/2: zone, gimmick id, 8 bytes a row) gives the zones gimmick 59;
- apply_code(code): the zones' platforms, floors and collision maps in ITCM, their address in the decomp's
  gPearlB2Platforms (NULL: no platforms; the zones then keep Pearl's maps without them), and the request work of a
  scripted lift (the Pokémon League's Cynthia room, 2026-10-26: PVAR_GIMMICK_REQUEST in the table's header).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, resident, narcio  # noqa: E402
import pearl_gimmicks  # noqa: E402

GIMMICK_TABLE = 102           # a/1/0/2 (decomp ARCID_GIMMICK_TBL): {u32 zone, u32 gimmick} a row
ROOM = 32                     # the gym's collision maps: 32 x 32 tiles a floor


def _world():
    w = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    b2 = {v['name']: v['b2_zone'] for v in list(w['zones'].values()) + list(w['rooms']['zones'].values())}
    chunks = {int(k): v for k, v in w['rooms']['chunks'].items()}
    chunks.update({int(k): v for k, v in w['chunks'].items()})
    return b2, chunks


def zones():
    """[(Black 2 zone, chunk dat id, config)] of gimmick 59."""
    b2, chunks = _world()
    return [(b2[c['name']], chunks[c['chunk']], c) for c in pearl_gimmicks.zone_configs()]


def check_prop_indices():
    """The C finds a prop by its index in the chunk (FieldChunkPropHolder propIndex). A prop whose building record
    names a door resource takes two indices (ov036 FieldPropSystem_InstantiateProps: FieldPropSystem_CheckCreateDoorReq
    is TRUE when the record's doorResId is not 0xFFFF); Pearl's door models are records without one (pearl_doors
    door_record: NO_DOOR), so a Pearl door before the platform props shifts nothing (2026-10-26, the ch5b agent:
    Fantina's Gym's lifts come after its three doors). Checked: every door model before them has such a record."""
    import pearl_doors
    from gen4rom import narc_members
    build = narc_members(pearl_gimmicks.rom_data().read('fielddata/build_model/build_model.narc'))
    known = pearl_doors.pearl()['by_bytes']
    for c in pearl_gimmicks.zone_configs():
        first = min([p['prop'] for p in c['platforms']] + ([c['floor_prop']] if c['floors'] else []))
        before = pearl_gimmicks.land_props(c['chunk'])[:first]
        doors = [known[bytes(build[p['model']])] for p in before if known.get(bytes(build[p['model']])) is not None
                 and pearl_doors.supported(known[bytes(build[p['model']])])]
        shifting = [m for m in doors if pearl_doors.read_record(pearl_doors.door_record(0, m))[1] != 0xFFFF]
        assert not shifting, f"{c['name']}: door models {shifting} with a door resource before the platform props: " \
                             f"their indices shift"


def flag_id(name):
    """A platform's flag (a src/include/pearl.h name, b2tools/pearl_ids.py) as Black 2's flag id; None: 0 (no flag)."""
    if name is None:
        return 0
    m = re.search(rf'^#define\s+{name}\s+(\d+)', open(os.path.join(ROOT, 'src', 'include', 'pearl.h')).read(), re.M)
    assert m, f'{name} missing from src/include/pearl.h (rerun b2tools/pearl_ids.py)'
    return int(m.group(1))


def apply(files):
    check_prop_indices()
    rows = narcio.load(files, GIMMICK_TABLE)
    data = rows[0]
    table = [struct.unpack_from('<II', data, o) for o in range(0, len(data), 8)]
    ours = {z for z, _, _ in zones()}
    clash = [(z, g) for z, g in table if z in ours]
    table = [(z, g) for z, g in table if z not in ours] + [(z, pearl_gimmicks.GIMMICK_ID) for z in sorted(ours)]
    rows[0] = b''.join(struct.pack('<II', z, g) for z, g in table)
    narcio.save(files, GIMMICK_TABLE, rows)
    return (f'pearl_platforms: gimmick {pearl_gimmicks.GIMMICK_ID} for zones {sorted(ours)}'
            + (f' (replacing Black 2 rows {clash})' if clash else ''))


def request_work():
    """PVAR_GIMMICK_REQUEST (data/pearl_story_ids.json "new"): the work a script asks a scripted lift's ride through
    (Cynthia's room: pl_TriggerPlatformLiftRide; the C's PearlB2Platforms.requestWork, 2026-10-26, chapter 8)."""
    reg = json.load(open(os.path.join(ROOT, 'data', 'pearl_story_ids.json')))
    return int(reg['new']['PVAR_GIMMICK_REQUEST']['b2'], 16)


def _bits(maps):
    out = bytearray((len(maps) * ROOM * ROOM + 7) // 8)
    for f, m in enumerate(maps):
        for i, v in enumerate(m):
            if v:
                bit = f * ROOM * ROOM + i
                out[bit >> 3] |= 1 << (bit & 7)
    return bytes(out)


def blob(base):
    """The tables at ITCM address base: PearlB2Platforms, its zones, their platforms and collision bits."""
    zs = zones()
    head = 8 + 28 * len(zs)
    body, recs = bytearray(), []
    for zone, chunk, c in zs:
        while (head + len(body)) % 4: body += b'\0'
        plats = base + head + len(body)
        for p in c['platforms']:
            px, pz = (round(v) for v in p['propA'])
            qx, qz = (round(v) for v in p['propB'])
            body += struct.pack('<8B2h2b2BH4hhHH', p['kind'], p['floorA'], p['floorB'], p['startB'], p['a'][0],
                                p['a'][1], p['b'][0], p['b'][1], p['ay'], p['by'], *p['plate'], p['prop'], px, pz,
                                qx, qz, p['propDY'], p['speed'], flag_id(p.get('flag')))
        coll = 0
        if c['collision'] is not None:
            while (head + len(body)) % 4: body += b'\0'
            coll = base + head + len(body)
            body += _bits(c['collision'])
        recs.append(struct.pack('<HHIHHhhHHII', zone, len(c['platforms']), chunk, c['floor_prop'], c['floors'],
                                pearl_gimmicks.FLOOR_STEP, pearl_gimmicks.FLOOR_BASE, ROOM, ROOM, coll, plats))
    return struct.pack('<HHI', len(zs), request_work(), base + 8) + b''.join(recs) + bytes(body)


def apply_code(code):
    import decomp
    slot = decomp.symbol('gPearlB2Platforms', code)
    if slot is None:
        return 'pearl_platforms: the decomp has no gPearlB2Platforms (no platforms)'
    # the table in PearlB2's resident section (b2tools/resident.py), not ITCM
    base, end, _ = resident.install(code, lambda b: (blob(b), {}))
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2Platforms at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return (f'pearl_platforms: {len(zones())} zones, their tables {end - base} B at {base:#x} '
            f'(gPearlB2Platforms {slot:#x})')


if __name__ == '__main__':
    b = blob(itcm.ITCM_BASE)
    print(len(b), 'bytes;', [(z, c, cfg['name'], len(cfg['platforms'])) for z, c, cfg in zones()])
