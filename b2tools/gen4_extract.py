"""Phase 1 reader: Pearl's zones, matrices, events and wild Pokémon, from the dump to JSON.

    python3 gen4_extract.py [ROM] [OUT_DIR]      defaults: roms/pearl.nds, work/pearl

Formats follow pokediamond's MapHeader (include/map_header.h) and pokeplatinum's packers
(tools/jsoncnv/map_matrix.py, event.py, encounter.py), read in reverse; the JSON keys are Platinum's, so the files can
be compared with external/pokeplatinum/res/field/*. Names (zones, species) come from pokediamond's constants.
Read-only: nothing is written to the ROM.
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from gen4rom import Rom, narc_members  # noqa: E402

DIAMOND = os.path.join(ROOT, 'external', 'pokediamond')
HEADER_SIZE = 24


def constants(path, prefix):
    """{value: name} for '#define PREFIX_NAME value' lines (first name wins)."""
    names = {}
    for m in re.finditer(rf'#define\s+({prefix}\w+)\s+(0x[0-9a-fA-F]+|\d+)', open(path, encoding='utf-8').read()):
        names.setdefault(int(m.group(2), 0), m.group(1))
    return names


def find_header_table(arm9, zone_count):
    """Offset of the map header table in arm9: entry 3 (Jubilife) uses matrix 0, scripts 2 and events 2, and every
    entry's matrix id is below 245 (pokediamond arm9/src/map_header.c)."""
    probe = struct.pack('<BBHH', 6, 0, 0, 2)
    start = 0
    while True:
        i = arm9.find(probe, start)
        if i < 0:
            raise SystemExit('map header table not found')
        base = i - 3 * HEADER_SIZE
        ok = base >= 0 and all(struct.unpack_from('<H', arm9, base + z * HEADER_SIZE + 2)[0] < 245
                               for z in range(zone_count))
        if ok and struct.unpack_from('<H', arm9, base + 3 * HEADER_SIZE + 16)[0] == 2:
            return base
        start = i + 1


def read_headers(rom, zone_names):
    arm9_off, _, _, arm9_size = struct.unpack_from('<4I', rom.data, 0x20)
    arm9 = rom.data[arm9_off:arm9_off + arm9_size]
    base = find_header_table(arm9, len(zone_names))
    zones = []
    for z in range(len(zone_names)):
        f = struct.unpack_from('<BBHHHHHHHHHBBBB', arm9, base + z * HEADER_SIZE)
        zones.append({
            'id': z, 'name': zone_names[z], 'area': f[0], 'move_models': f[1], 'matrix': f[2], 'scripts': f[3],
            'level_scripts': f[4], 'text_bank': f[5], 'music_day': f[6], 'music_night': f[7],
            'encounters': None if f[8] == 0xffff else f[8], 'events': f[9], 'mapsec': f[10], 'weather': f[11],
            'camera': f[12], 'map_type': f[13], 'battle_bg': f[14] & 15, 'bike': bool(f[14] & 16),
            'escape_rope': bool(f[14] & 64), 'fly': bool(f[14] & 128)})
    return arm9_off + base, zones


def read_matrix(m):
    w, h, has_hdr, has_alt, nl = m[:5]
    p = 5 + nl
    grid = lambda vals: [list(vals[r * w:(r + 1) * w]) for r in range(h)]
    out = {'name': m[5:p].decode('ascii'), 'width': w, 'height': h, 'headers': [], 'altitudes': []}
    if has_hdr:
        out['headers'] = grid(struct.unpack_from(f'<{w * h}H', m, p)); p += 2 * w * h
    if has_alt:
        out['altitudes'] = grid(m[p:p + w * h]); p += w * h
    out['maps'] = grid(struct.unpack_from(f'<{w * h}H', m, p))
    return out


def read_events(e):
    p = 0
    def count():
        nonlocal p
        n, = struct.unpack_from('<I', e, p); p += 4
        return n
    bg = []
    for _ in range(count()):
        s, t, x, z, y, d = struct.unpack_from('<HHiiiH', e, p); p += 20
        bg.append({'script': s, 'type': t, 'x': x, 'z': z, 'y': y, 'player_facing_dir': d})
    obj = []
    for _ in range(count()):
        f = struct.unpack_from('<14Hi', e, p); p += 32
        obj.append({'id': f[0], 'graphics_id': f[1], 'movement_type': f[2], 'trainer_type': f[3], 'hidden_flag': f[4],
                    'script': f[5], 'initial_dir': f[6], 'data': list(f[7:10]), 'movement_range_x': f[10],
                    'movement_range_z': f[11], 'x': f[12], 'z': f[13], 'y': f[14] // 0x10000})
    warps = []
    for _ in range(count()):
        x, z, dest, dest_warp = struct.unpack_from('<4H', e, p); p += 12
        warps.append({'x': x, 'z': z, 'dest_header_id': dest, 'dest_warp_id': dest_warp})
    coords = []
    for _ in range(count()):
        f = struct.unpack_from('<8H', e, p); p += 16
        coords.append(dict(zip(['script', 'x', 'z', 'width', 'length', 'y', 'value', 'var'], f)))
    assert p == len(e), f'event file: {len(e) - p} bytes left'
    return {'bg_events': bg, 'object_events': obj, 'warp_events': warps, 'coord_events': coords}


def read_encounters(d, species):
    sp = lambda v: species.get(v, v)
    u32 = lambda o: struct.unpack_from('<I', d, o)[0]
    out = {'land_rate': u32(0), 'land_encounters': [{'level': u32(4 + 8 * i), 'species': sp(u32(8 + 8 * i))}
                                                    for i in range(12)]}
    p = 100
    for key in ['swarms', 'day', 'night']:
        out[key] = [sp(u32(p)), sp(u32(p + 4))]; p += 8
    out['radar'] = [sp(u32(p + 4 * i)) for i in range(4)]; p += 16
    for key in ['rate_form0', 'rate_form1', 'rate_form2', 'rate_form3', 'rate_form4', 'unown_table']:
        out[key] = u32(p); p += 4
    for key in ['ruby', 'sapphire', 'emerald', 'firered', 'leafgreen']:
        out[key] = [sp(u32(p)), sp(u32(p + 4))]; p += 8
    def water():
        nonlocal p
        rows = []
        for _ in range(5):
            hi, lo, _, s = struct.unpack_from('<BBHI', d, p); p += 8
            rows.append({'level_max': hi, 'level_min': lo, 'species': sp(s)})
        return rows
    out['surf_rate'] = u32(p); p += 4
    out['surf_encounters'] = water()
    p += 44
    for rod in ['old', 'good', 'super']:
        out[f'{rod}_rod_rate'] = u32(p); p += 4
        out[f'{rod}_rod_encounters'] = water()
    assert p == len(d), f'encounter file: {len(d) - p} bytes left'
    return out


def main():
    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'roms', 'pearl.nds')
    out_dir = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, 'work', 'pearl')
    rom = Rom(rom_path)
    assert rom.code == 'APAE', f'expected Pearl (APAE), got {rom.code}'
    zone_names = constants(os.path.join(DIAMOND, 'include', 'constants', 'maps.h'), 'MAP_')
    zone_names = [zone_names[i] for i in range(len(zone_names))]
    species = constants(os.path.join(DIAMOND, 'include', 'constants', 'species.h'), 'SPECIES_')
    table_off, zones = read_headers(rom, zone_names)
    os.makedirs(os.path.join(out_dir, 'matrices'), exist_ok=True)
    os.makedirs(os.path.join(out_dir, 'events'), exist_ok=True)
    os.makedirs(os.path.join(out_dir, 'encounters'), exist_ok=True)
    dump = lambda path, obj: json.dump(obj, open(os.path.join(out_dir, path), 'w'), indent=1)
    dump('zones.json', zones)
    mats = narc_members(rom.read('fielddata/mapmatrix/map_matrix.narc'))
    for i, m in enumerate(mats):
        dump(f'matrices/{i:03d}.json', read_matrix(m))
    events = narc_members(rom.read('fielddata/eventdata/zone_event_release.narc'))
    for i, e in enumerate(events):
        dump(f'events/{i:03d}.json', read_events(e))
    encs = narc_members(rom.read('fielddata/encountdata/p_enc_data.narc'))
    for i, d in enumerate(encs):
        dump(f'encounters/{i:03d}.json', read_encounters(d, species))
    print(f'{rom.title} {rom.code} rev {rom.revision}: header table at ROM 0x{table_off:x}; {len(zones)} zones, '
          f'{len(mats)} matrices, {len(events)} event files, {len(encs)} encounter files -> {out_dir}')


if __name__ == '__main__':
    main()
