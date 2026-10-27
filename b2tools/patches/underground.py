"""The Grand Underground (notes/UNDERGROUND.md; DECISIONS 2026-10-19, the lead's answers 2026-10-26): Pearl's
Underground tunnels (zone 633, installed as a room by sinnoh_rooms: allocate_sinnoh APPENDED 'MAP_UNDERGROUND'), 18
Hideaways (zones 634-651) on Pearl's and Black 2's own cave rooms, their holes in the tunnel walls, BDSP's Hideaway
items, Black 2's Hidden Grottos 0-17 in them, the Explorer Kit's "Use", and the C's table. Runs after sinnoh_rooms,
sinnoh_events, sinnoh_names, sinnoh_encounters, sinnoh_music and sinnoh_story (it changes headers they write), with
scripts and pearl_text (src/field_scripts/1900_underground.s, src/text/script/1300_underground.txt):

    build_rom.py ... sinnoh_story ... underground

Data: data/underground.json (b2tools/ug_data.py), data/underground_pokemon.json (b2tools/underground_lists.py).

apply(files)
- The tunnels: their header (the shared script and text files, the Grand Underground's place line, no wild Pokémon,
  no bike / Escape Rope / Fly as Pearl's), their entities (18 hole warps, one bump warp each into a wall, and the
  Hideaway's name as a sign on the same tile), and a copy of each hole's chunk with Pearl's Secret Base hole model
  (build model 430, ug_hole_f: a hole in a north wall) placed on that wall tile; the matrix cell points at the copy.
- Each Hideaway: a header copied from its room's (a Pearl room: as sinnoh_rooms and the other patches built it this
  build; a Unova room: Black 2's own, vanilla), with its own entities: the room's warps by index, the 'exits' to its
  tunnel hole and the others off the map; the item balls; the daily shard and fossil balls (hidden until Champion:
  the zone init); the grotto's "narrow path" (Black 2's global 10795 + its id, read facing north). Its wild encounters: its
  room's Pearl table (for the rate; the C picks the species), or for a Unova room a Pearl cave table; a Hideaway with
  BDSP's water spawns gets a table with Surf slots.
- The Hidden Grottos 0-17 (a/2/7/3): Pokémon slots 15 / 4 / 1 %: the past-generation starters (data) or the
  Hideaway's rare spawns, then its rare spawns, levels data "grotto_levels"; item slots: Pearl's Underground
  treasures (data "grotto_items"); both halves of the file the same.
- The Explorer Kit (item 428) gets the Xtransceiver's field-use id (the Bag shows "Use") and Pearl's "important"
  (Black 2's could be tossed or given).
- The visible Pokémon (data "visible", part 2: the decomp's src/pearlb2/resident/hideaway.c): the Hideaways' zones get
  PearlB2's gimmick 63 in the gimmick table (a/1/0/2, zone -> id, a row each, as the gyms' patches add theirs); with it
  their Pokémon walk about and random battles are off. "visible": false leaves part 1's random battles.
- work/world/underground.json: what apply_code needs (the tunnels' floor height, the grottos' return spots).

apply_code(code)
- gPearlB2Underground (the decomp's src/pearlb2/underground_itcm.c): the table (ug_data.table_blob) in ITCM.
- HIDDEN_HOLLOW_ENTRANCES (ov012): grottos 0-17 return to their Hideaway's narrow path (Black 2's bytes asserted).
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio, zoneheaders, b2files, pearl_chunk, pearl_buildings, itcm, resident  # noqa: E402
import ug_data  # noqa: E402
from zones import parse_entities, build_entities  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
PEARL = os.path.join(ROOT, 'work', 'pearl')
STATE = os.path.join(ROOT, 'work', 'world', 'underground.json')
EMPTY = struct.pack('<I', 4) + bytes(4) + bytes(4)        # Black 2's empty entity file (sinnoh_events.EMPTY)
OFF_MAP, INERT = 0xFFF8, 0xFFFF
EMPTY_INIT = 7                                            # the empty init-script file (sinnoh_rooms EMPTY_INIT)
TUNNELS_PEARL_ZONE = 2                                    # MAP_UNDERGROUND
HOLE_MODEL = 430                                          # ug_hole_f: Pearl's Secret Base hole in a north wall
ITEM_BALL_CODE = 110                                      # Black 2's item-ball sprite
GROTTO_SCRIPT = 10795                                     # global 10795: script n+1 = grotto n's "narrow path"
GIMMICK_TABLE = 102                                       # a/1/0/2: {u32 zone, u32 gimmick} a row
GIMMICK_HIDEAWAY = 63                                     # the decomp's PEARLB2_GIMMICK_HIDEAWAY
GROTTO_ARC, GROTTO_COUNT = 273, 20                        # a/2/7/3, Black 2's 20 grottos
ITEM_DATA_ARC, FIELD_FUNC = 24, 10                        # a/0/2/4: ItemData.fieldFunc (pml/item.h)
IMPORTANT = 1 << 5                                        # ItemData's u16 at 8: naturalGiftType 5 bits, important
ITEM_EXPLORER_KIT, ITEM_XTRANSCEIVER = 428, 621
PLACE_LINE = 265                                          # system text 109: "Grand Underground" (notes/LINK.md)
FLAG_CYCLING, FLAG_ESCAPE_ROPE, FLAG_FLY, FLAG_ENTRALINK = 1 << 10, 1 << 12, 1 << 13, 1 << 15
WARP_UP = 2                                               # a bump warp entered walking up (sinnoh_events DIRS)
OV012, HOLLOW_TABLE = 0x021503C0, 0x0216DE58              # HIDDEN_HOLLOW_ENTRANCES: {u16 zone, u32 x, y, z} x 20
VANILLA_HOLLOWS = [(0x1bd, 59, 2, 12), (0x149, 373, 0, 425), (0x181, 22, 0, 10), (0x14b, 133, 0, 392),
                   (0x14b, 153, 0, 360), (0x151, 106, 0, 258), (0x172, 677, 0, 202), (0x172, 699, 0, 174),
                   (0x15c, 344, 0, 168), (0xe8, 28, 0, 59), (0x1da, 747, 0, 132), (0x1db, 645, 5, 136),
                   (0x178, 47, 3, 30), (0x178, 35, 5, 10), (0x9b, 58, 0, 52), (0x9a, 628, 5, 619),
                   (0x141, 728, 0, 582), (0x141, 703, 0, 576), (0x13f, 751, 0, 634), (0x183, 620, 0, 741)]


class Room:
    """A Hideaway's room: its header fields, warps and tile heights (a Pearl room as built, or a vanilla Unova one)."""

    def __init__(self, spec, world, headers, planner):
        self.pearl = spec.get('pearl')
        if self.pearl:
            pz = next(z for z in planner.zones if z['name'] == self.pearl)
            self.pid = pz['id']
            self.src_zone = world['rooms']['zones'][str(self.pid)]['b2_zone']
            self.header = dict(headers[self.src_zone])
            self.warps = [dict(w) for w in planner.warps(self.pid)[0]]
            self.m = planner.matrix(pz['matrix'])
            self.planner = planner
        else:
            self.src_zone = spec['unova']
            vh, _ = zoneheaders.load(VANILLA)
            self.header = dict(vh[self.src_zone])
            ents = narcio.load(VANILLA, 126)
            e, _ = parse_entities(ents[self.header['entities']])
            self.warps = e['warps']
            d = narcio.load(VANILLA, 9)[self.header['matrix']]
            fmt, _, w, h = struct.unpack_from('<HHHH', d, 0)
            assert fmt == 0, f'Unova room {self.src_zone}: matrix format {fmt} (a zone per cell): not usable'
            self.w, self.cells = w, struct.unpack_from(f'<{w * h}I', d, 8)
            self.chunks = narcio.load(VANILLA, 8)
            self.tables = pearl_chunk.tables()

    def height(self, x, z):
        """The floor height (units) of tile (x, z)."""
        if self.pearl:
            t = self.planner.tile(self.m, x, z)
            return t[2] if t and t[2] is not None else 0
        c = self.cells[(z // 32) * self.w + x // 32]
        _, secs = b2files.gf_container(self.chunks[c])
        a, b = struct.unpack_from('<HH', secs[1], 4 + 8 * ((z % 32) * 32 + x % 32))
        return round(pearl_chunk.plane_height(*self.tables, a >> 2, b, (x % 32) * 16 + 8 - 256, (z % 32) * 16 + 8 - 256))


def place_hole(chunk, x, z, y, res):
    """The chunk container with Pearl's hole model on tile (x, z) of it (a building placement, as sinnoh_rooms
    places a room's props)."""
    magic, layers, part = pearl_chunk.terrains(chunk)
    count = struct.unpack_from('<I', part['props'], 0)[0]
    prop = {'model': HOLE_MODEL, 'pos': [x * 16 - 248, y, z * 16 - 248], 'rot': [0, 0, 0], 'scale': [1, 1, 1]}
    one, problems = pearl_buildings.placements([prop], {HOLE_MODEL: res})
    assert not problems, problems
    props = struct.pack('<I', count + 1) + part['props'][4:] + one[4:]
    return pearl_chunk.rebuild(magic, part['model'], layers, props)


def grotto_file(h, index, data):
    """A grotto's a/2/7/3 file (scrcmd_hidden_hollow.c HollowFile): Pokémon slots 0-2 (1, 4, 15 % of the refills) x
    4 groups, both versions the same; items A (slots 3-6) and B (7-9) x 4 groups."""
    ids = ug_data.species_ids()
    lo, hi = data['grotto_levels']
    version = data['version']
    rares = [r['species'] for r in sorted(h['pokemon']['rare'], key=lambda r: -r[version]) if r[version]]
    starters = [ids[s] for s in h['grotto']['starters']]
    slot15 = starters or rares
    slot4 = rares
    slot1 = rares[::-1]
    import narcio as _n
    personal = _n.load(VANILLA, 16)

    def female_below(sp):
        ratio = personal[sp][18]                 # the gender ratio (255 genderless, 254 all female, 0 all male)
        return 0 if ratio == 255 else round(ratio * 100 / 254)

    def slot(species):
        sp = [species[g % len(species)] for g in range(4)]
        return (struct.pack('<4H', *sp) + bytes([hi + 1] * 4) + bytes([lo] * 4)
                + bytes(female_below(s) for s in sp) + bytes(4) + bytes(2))
    slots = slot(slot1) + slot(slot4) + slot(slot15)        # slot 0 (1 %), 1 (4 %), 2 (15 %)
    gi = data['grotto_items']

    def items(rows, slate):
        out = []
        for row in rows:
            for g in range(4):
                if row == ['PLATE']:
                    out.append(ug_data.item(gi['plates'][(4 * index + g) % len(gi['plates'])]))
                elif row == ['slate']:
                    out.append(ug_data.item(slate))
                else:
                    out.append(ug_data.item(row[(index + g) % len(row)]))
        return out
    a = items(gi['a'], 'HEART_SCALE')
    b = items(gi['b'], 'HEART_SCALE') + [0] * 4           # (B has three slots; the file keeps four)
    return slots + slots + struct.pack('<16H', *a) + struct.pack('<16H', *b)


def apply(files):
    import subprocess
    subprocess.run([sys.executable, os.path.join(os.path.dirname(HERE), 'underground_scripts.py'), '--check'],
                   check=True)
    from sinnoh_events import Planner
    data = ug_data.data()
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    rooms = world['rooms']
    tz = data['zones']['tunnels']
    tun = rooms['zones'].get(str(TUNNELS_PEARL_ZONE))
    if tun is None or tun['b2_zone'] != tz:
        raise SystemExit(f'underground: Pearl\'s Underground is not installed on zone {tz} (allocate_sinnoh APPENDED '
                         f'MAP_UNDERGROUND after the zone-table merge): {tun}')
    hs = ug_data.hideaways()
    headers, entries = zoneheaders.load(files)
    last = max(h['zone'] for h in hs)
    if len(headers) <= last:
        assert hasattr(zoneheaders, 'extend'), 'underground: zone headers past 615 need the zone-table merge'
        zoneheaders.extend(headers, last + 1)
    planner = Planner()
    ids = ug_data.script_ids()
    ents = narcio.load(files, 126)
    chunks = narcio.load(files, 8)
    mats = narcio.load(files, 9)
    th = headers[tz]

    # the tunnels: holes (chunk copies), their warps and name signs
    m2 = json.load(open(os.path.join(PEARL, 'matrices', '002.json')))
    mid = rooms['matrices']['2']['b2_matrix']
    mat = bytearray(mats[mid])
    fmt, _, mw, mh = struct.unpack_from('<HHHH', mat, 0)
    assert fmt == 0 and (mw, mh) == (m2['width'], m2['height']), (fmt, mw, mh)
    res = rooms['building_res'][str(HOLE_MODEL)]
    heights = {int(c): {tuple(map(int, k.split(','))): y for k, y in hs_.items()}
               for c, hs_ in json.load(open(os.path.join(ROOT, 'work', 'world', 'heights_rooms.json'))).items()}
    floor = max(set(y for c in range(562, 577) for y in heights.get(c, {}).values()),
                key=lambda y: sum(1 for c in range(562, 577) for v in heights.get(c, {}).values() if v == y))
    warps, signs, copies = [], [], {}
    for i, h in enumerate(hs):
        x, z = h['hole']
        cx, cz = x // 32, z // 32
        pc = m2['maps'][cz][cx]
        assert planner.tile(m2, x, z)[1] and not planner.tile(m2, x, z + 1)[1], f'{h["key"]}: hole not on a north wall'
        below = m2['maps'][(z + 1) // 32][cx]                 # (the floor tile in front of the hole)
        y = heights.get(below, {}).get((x % 32, (z + 1) % 32), floor)
        key = (cx, cz)
        base = copies.get(key, chunks[rooms['chunks'][str(pc)]])
        copies[key] = place_hole(base, x % 32, z % 32, y, res)
        warps.append(dict(dest_zone=h['zone'], dest_warp=h['exits'][0], dir=WARP_UP, type=4, rail=0,
                          x=x * 16 + 8, y=y & 0xFFFF, z=z * 16 + 8, w=1, h=1, unk=0))
        signs.append(dict(script=ids['name'][i], cond=0, dir=0, rail=0, x=x, z=z, y=y))
    for (cx, cz), c in sorted(copies.items()):
        struct.pack_into('<I', mat, 8 + 4 * (cz * mw + cx), len(chunks))
        chunks.append(c)
    mats[mid] = bytes(mat)
    th.update(scripts=data['files']['script'], text=data['files']['text'], entities=len(ents), encounters=0x1FFF,
              enc_slot=0, place=PLACE_LINE)
    th['flags'] &= ~(FLAG_CYCLING | FLAG_ESCAPE_ROPE | FLAG_FLY | FLAG_ENTRALINK)
    ents.append(build_entities({'signs': signs, 'npcs': [], 'warps': warps, 'triggers': []}, EMPTY))

    # the Hideaways
    zones_json = json.load(open(os.path.join(PEARL, 'zones.json')))
    balls, shards, fossils = ug_data.item_balls(), ug_data.shard_balls(), ug_data.fossil_balls()
    vh, _ = zoneheaders.load(VANILLA)
    tables = narcio.load(files, 127)
    grotto_returns, report = {}, []
    for i, h in enumerate(hs):
        room = Room(h['room'], world, headers, planner)
        hd = dict(room.header)
        hd.update(scripts=data['files']['script'], init_scripts=EMPTY_INIT, text=data['files']['text'],
                  entities=len(ents), parent=tz, place=PLACE_LINE, place_display=th['place_display'], fly_x=0, fly_y=0, fly_z=0,
                  npc_cache=th['npc_cache'], bgm0=th['bgm0'], bgm1=th['bgm1'], bgm2=th['bgm2'], bgm3=th['bgm3'])
        hd['flags'] &= ~(FLAG_CYCLING | FLAG_ESCAPE_ROPE | FLAG_FLY | FLAG_ENTRALINK)
        # wild encounters: the room's Pearl table, else a Pearl cave table; with Surf slots where BDSP has water
        table = hd['encounters'] if room.pearl else 0x1FFF
        need_surf = h['pokemon']['water_spawns'] > 0
        def usable(t):
            return t != 0x1FFF and t < len(tables) and tables[t][0] and (not need_surf or tables[t][3])
        if not usable(table):
            table = next(t for t in range(135, len(tables)) if usable(t))
        hd.update(encounters=table, enc_slot=0)
        warps = []
        for k, w in enumerate(room.warps):
            if k in h['exits']:
                warps.append(dict(w, dest_zone=tz, dest_warp=i))
            else:
                warps.append(dict(w, dest_zone=h['zone'], dest_warp=INERT, x=OFF_MAP, z=OFF_MAP))
        npcs = []
        for k, (hi, it, x, z, flag) in enumerate(balls):
            if hi == i:
                npcs.append(dict(uid=len(npcs) + 1, model=ITEM_BALL_CODE, move=0, evtype=0, flag=flag,
                                 script=ids['item'][k], dir=1, p0=0, p1=0, p2=0, areaw=0, areah=0, rail=0,
                                 x=x, z=z, y=room.height(x, z) * 0x1000))
        init = None
        for k, (hi, it, x, z, flag) in enumerate(shards):
            if hi == i:
                npcs.append(dict(uid=len(npcs) + 1, model=ITEM_BALL_CODE, move=0, evtype=0, flag=flag,
                                 script=ids['shard'][k], dir=1, p0=0, p1=0, p2=0, areaw=0, areah=0, rail=0,
                                 x=x, z=z, y=room.height(x, z) * 0x1000))
                init = struct.pack('<HI', 2, ids['shard_init']) + struct.pack('<H', 0) + bytes(2)   # zone init
        for k, (hi, x, z, flag) in enumerate(fossils):
            if hi == i:
                npcs.append(dict(uid=len(npcs) + 1, model=ITEM_BALL_CODE, move=0, evtype=0, flag=flag,
                                 script=ids['fossil'][k], dir=1, p0=0, p1=0, p2=0, areaw=0, areah=0, rail=0,
                                 x=x, z=z, y=room.height(x, z) * 0x1000))
                init = struct.pack('<HI', 2, ids['shard_init']) + struct.pack('<H', 0) + bytes(2)
        g = h['grotto']
        gy = room.height(g['x'], g['z'] + 1)
        signs = [dict(script=GROTTO_SCRIPT + g['hollow'], cond=0, dir=0, rail=0, x=g['x'], z=g['z'], y=gy)]
        # (HIDDEN_HOLLOW_ENTRANCES y: the arrival is at y * 16 + 8 units, as Black 2's own grottos' entries)
        grotto_returns[g['hollow']] = (h['zone'], g['x'], max(0, round((gy - 8) / 16)), g['z'] + 1)
        headers[h['zone']] = hd
        ents.append(build_entities({'signs': signs, 'npcs': npcs, 'warps': warps, 'triggers': []}, EMPTY, init))
        report.append(f"{h['zone']} {h['pokemon']['name']}: {h['room']} table {table}, {len(npcs)} balls")
    narcio.save(files, 126, ents)
    narcio.save(files, 8, chunks)
    narcio.save(files, 9, mats)
    zoneheaders.save(files, headers, entries)

    # the grottos
    grottos = narcio.load(files, GROTTO_ARC)
    assert len(grottos) == GROTTO_COUNT
    for h in hs:
        grottos[h['grotto']['hollow']] = grotto_file(h, h['grotto']['hollow'], data)
    narcio.save(files, GROTTO_ARC, grottos)

    # the Explorer Kit: "Use" in the Bag (the Xtransceiver's field function)
    items = narcio.load(files, ITEM_DATA_ARC)
    kit = bytearray(items[ITEM_EXPLORER_KIT])
    kit[FIELD_FUNC] = items[ITEM_XTRANSCEIVER][FIELD_FUNC]
    assert kit[FIELD_FUNC], 'the Xtransceiver has no field function'
    bits = struct.unpack_from('<H', kit, 8)[0] | IMPORTANT          # (Black 2's Explorer Kit could be tossed)
    struct.pack_into('<H', kit, 8, bits)
    items[ITEM_EXPLORER_KIT] = bytes(kit)
    narcio.save(files, ITEM_DATA_ARC, items)

    # the visible Pokémon: the Hideaways' gimmick
    hzones = [h['zone'] for h in hs]
    rows = narcio.load(files, GIMMICK_TABLE)
    table = [struct.unpack_from('<II', rows[0], o) for o in range(0, len(rows[0]), 8)]
    clash = [(z, g) for z, g in table if z in hzones]
    table = [(z, g) for z, g in table if z not in hzones]
    if data.get('visible'):
        table += [(z, GIMMICK_HIDEAWAY) for z in hzones]
    rows[0] = b''.join(struct.pack('<II', z, g) for z, g in table)
    narcio.save(files, GIMMICK_TABLE, rows)
    visible = (f'visible Pokémon: gimmick {GIMMICK_HIDEAWAY} for zones {hzones[0]}-{hzones[-1]}' if data.get('visible')
               else 'random battles (no gimmick)') + (f' (replacing rows {clash})' if clash else '')

    os.makedirs(os.path.dirname(STATE), exist_ok=True)
    json.dump({'tunnel_floor_y': floor, 'grottos': {str(k): v for k, v in grotto_returns.items()}},
              open(STATE + '.tmp', 'w'))
    os.replace(STATE + '.tmp', STATE)
    return (f'underground: tunnels zone {tz} (matrix {mid}, {len(copies)} hole chunks, floor {floor}); '
            f'Hideaways {report}; grottos {sorted(grotto_returns)}; Explorer Kit field use {kit[FIELD_FUNC]}; {visible}')


def apply_code(code):
    import decomp
    state = json.load(open(STATE))
    slot = decomp.symbol('gPearlB2Underground', code)
    if slot is None:
        raise SystemExit('underground: the decomp has no gPearlB2Underground (src/pearlb2/underground_itcm.c)')
    # the table in PearlB2's resident section (b2tools/resident.py), not ITCM
    base, end, _ = resident.install(code, lambda b: (ug_data.table_blob(b, state['tunnel_floor_y']), {}))
    path = os.path.join(code, 'itcm.bin')
    blob = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert blob[at:at + 4] == bytes(4), f'gPearlB2Underground at {slot:#x}: not NULL'
    blob[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(blob); os.replace(path + '.tmp', path)

    path = os.path.join(code, 'arm9_ov012.bin')
    ov = bytearray(open(path, 'rb').read())
    for n, (zone, x, y, z) in enumerate(VANILLA_HOLLOWS):
        o = HOLLOW_TABLE - OV012 + 16 * n
        assert bytes(ov[o:o + 16]) == struct.pack('<HHIII', zone, 0, x, y, z) or \
            str(n) in state['grottos'], f'HIDDEN_HOLLOW_ENTRANCES[{n}]: not Black 2\'s'
        if str(n) in state['grottos']:
            zone, x, y, z = state['grottos'][str(n)]
            ov[o:o + 16] = struct.pack('<HHIII', zone, 0, x, y, z)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(ov); os.replace(path + '.tmp', path)
    return (f'underground: the table {end - base} B at {base:#x} (gPearlB2Underground {slot:#x}); '
            f'grottos {sorted(state["grottos"], key=int)} return to their Hideaways')
