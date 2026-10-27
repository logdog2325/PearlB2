"""Pearl's ice in the Snowpoint Gym (2026-10-26, the ch6b agent): the speed by the slope, the slow step back, the
snowballs that break and the one-way tiles, as Black 2's gimmick 61 (the decomp's src/pearlb2/snowpoint_gym_itcm.c,
dispatched by src/pearlb2/gimmick_itcm.c; the rules are written there, from pokediamond's code). List it after
sinnoh_rooms and sinnoh_story (the gym's people, the snowballs among them):

    build_rom.py ... sinnoh_rooms ... sinnoh_story ... snowpoint_gym

- apply(files): the gimmick table (a/1/0/2: zone, gimmick id, 8 bytes a row) gives the gym's zone gimmick 61;
- apply_code(code): the gym's table in ITCM (the snowballs' object code, their sound, Pearl's one-way tiles 0x49 /
  0x4A), its address in the decomp's gPearlB2Ice (NULL: Black 2's ice, no snowball breaks).
Checked offline: work/agents/ch6b/tools/icegym.py plays the gym on Pearl's rules (Candice reachable after the
snowballs of the middle column break) and on Black 2's (reachable around them).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, narcio  # noqa: E402

GIMMICK_ID = 61
GIMMICK_TABLE = 102             # a/1/0/2 (decomp ARCID_GIMMICK_TBL): {u32 zone, u32 gimmick} a row
GYMS = ['MAP_SNOWPOINT_GYM']    # Pearl's zones with the gimmick
SNOWBALL_GFX = 0x76             # Pearl's OBJ_EVENT_GFX_SNOWBALL (pokediamond ov05_021E6904's check)
# Pearl's SEQ_SE_DP_FW291 (its only use is the snowball) -> Black 2's snow step [guess, to audition]
BREAK_SE = 'SEQ_SE_FLD_11'
AXES = {0x49: 1, 0x4A: 2}       # Pearl's one-way tiles: 1 up and down, 2 left and right


def _world():
    w = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    b2 = {v['name']: v['b2_zone'] for v in list(w['zones'].values()) + list(w['rooms']['zones'].values())}
    return b2


def _sound(name):
    """A Black 2 sequence id by its name (pokebw2 generated/sound.txt: NAME = value, then one more per line)."""
    n = None
    for line in open(os.path.join(ROOT, 'external', 'pokebw2', 'generated', 'sound.txt')):
        m = re.match(r'\s*(SEQ_\w+)(?:\s*=\s*(\S+))?\s*(?:#.*)?$', line)
        if not m: continue
        if m.group(2): n = int(m.group(2), 0)
        elif n is None: continue
        if m.group(1) == name: return n
        n += 1
    raise KeyError(name)


def _snowball_code():
    sm = json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json')))
    return sm[str(SNOWBALL_GFX)]['code']


def zones():
    """[(Black 2 zone, [(x, z, axes)])] of gimmick 61, from Pearl's zones and their chunk's tile behaviours."""
    b2 = _world()
    pz = {z['name']: z for z in json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))}
    out = []
    for name in GYMS:
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f"{pz[name]['matrix']:03d}.json")))
        assert m['width'] == 1 and m['height'] == 1, f'{name}: one chunk expected'
        land = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f"{m['maps'][0][0]:03d}.json")))
        blocks = [(x, z, AXES[b]) for z, row in enumerate(land['behaviour']) for x, b in enumerate(row) if b in AXES]
        out.append((b2[name], blocks))
    return out


def apply(files):
    rows = narcio.load(files, GIMMICK_TABLE)
    data = rows[0]
    table = [struct.unpack_from('<II', data, o) for o in range(0, len(data), 8)]
    ours = {z for z, _ in zones()}
    clash = [(z, g) for z, g in table if z in ours]
    table = [(z, g) for z, g in table if z not in ours] + [(z, GIMMICK_ID) for z in sorted(ours)]
    rows[0] = b''.join(struct.pack('<II', z, g) for z, g in table)
    narcio.save(files, GIMMICK_TABLE, rows)
    return (f'snowpoint_gym: gimmick {GIMMICK_ID} for zones {sorted(ours)}'
            + (f' (replacing Black 2 rows {clash})' if clash else ''))


def blob(base):
    """The tables at ITCM address base: PearlB2Ice {u16 zoneCount, pad, zones}, its zones {u16 zoneId, snowballCode,
    breakSE, blockCount, blocks}, their blocks {u8 x, z, axes, pad}."""
    zs = zones()
    code, se = _snowball_code(), _sound(BREAK_SE)
    head = 8 + 12 * len(zs)
    body, recs = bytearray(), []
    for zone, blocks in zs:
        at = base + head + len(body)
        body += b''.join(struct.pack('<4B', x, z, a, 0) for x, z, a in blocks)
        recs.append(struct.pack('<4HI', zone, code, se, len(blocks), at))
    return struct.pack('<HHI', len(zs), 0, base + 8) + b''.join(recs) + bytes(body)


def apply_code(code):
    import decomp
    slot = decomp.symbol('gPearlB2Ice', code)
    if slot is None:
        return 'snowpoint_gym: the decomp has no gPearlB2Ice (Black 2\'s ice in the gym)'
    base, end, _ = itcm.install(code, lambda b: (blob(b), {}))
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2Ice at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return (f'snowpoint_gym: {len(zones())} zone(s), {end - base} B of ITCM at {base:#x} (gPearlB2Ice {slot:#x})')


if __name__ == '__main__':
    b = blob(itcm.ITCM_BASE)
    print(len(b), 'bytes;', [(z, len(bl)) for z, bl in zones()], 'snowball code', _snowball_code(),
          BREAK_SE, _sound(BREAK_SE))
