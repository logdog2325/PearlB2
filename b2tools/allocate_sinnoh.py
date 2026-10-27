"""Give Sinnoh's overworld its Black 2 numbers: zones, area groups, building packs, chunk ids.

    python3 allocate_sinnoh.py        -> ../data/sinnoh_world.json (review it; ids never change once released)

- Zones: every Pearl zone on Pearl's overworld matrix gets a Black 2 zone. Black 2's code special-cases some zone ids
  (HoennB2 converter/allocate_zones.py, read in arm9 0x02018a54-0x02018ee4): those are never used (DENY, AVOID).
  Towns take Unova's town zones, routes Unova's route zones (their fog/light/sound entries fit best), the rest
  Unova's other outdoor zones, then any free map-type-0 zone. **Twinleaf takes 427**, the zone a new game loads first
  (HoennB2 RESEARCH_STORY_SPRITES.md: LoadAspertiaCitySpawnInfo); 428 (Aspertia's house) stays free for Twinleaf's.
  Kept zones (notes/ZONES_KEPT.md, 2026-10-25): 165 zones stay Black 2's, no zone is free. Four came out of DENY/AVOID
  for the Great Marsh's areas 1-5 with 585 (GREAT_MARSH_ZONES below). **489 (ASPERTIA_CITY_GYM) is reserved for
  Pearl's Hall of Origin** (Pearl map 510: the user wants the event Pokémon, Arceus too; Chapter 9 allocates it).
  Spares if a place ever needs one (nothing in code, scripts or zone tables names them, cleanest first): 605
  (VILLAGE_BRIDGE_9, a Memory Link zone), 253 (DRIFTVEIL_DRAWBRIDGE), 263 / 250 (a fog-table entry only, which
  zone_effects clears), 609-613 (Underground Ruins and the Regi chambers: only their own Unova scripts name them).
- **Appended zones (2026-10-26, notes/ZONE_TABLE.md)**: new places take zones after Black 2's 615, by name in APPENDED
  below, allocated after everything else (no number above moves). 615 stays Black 2's "no zone" dummy; appended
  zones are 616-1023, never 0x7FF / 0xFFFF (zoneheaders.check_zone). Blocks (APPEND_BLOCKS; each feature's agent
  fills its block and asks the lead for the next one): **Battle Tower 616-622**, **Turnback Cave 623-632, 663-664**,
  **Underground 633-651**, **Ramanas Park 652-660** (661-662: the Diamond version's Johto and Rainbow Rooms).
  sinnoh_world grows the header file to the end of the last block. Areas the Underground reuses (388, 198-201) are
  never handed out (RESERVED_AREAS).
- **Released numbers never move**: the allocation is recomputed from Pearl's data each run; keep_released() puts back
  every number data/sinnoh_world.json already has (and says which ones a fresh run would have given differently), so
  a rerun only adds.
- Areas: one Black 2 seasonal area group (4 records: spring..winter, ids 2..281) per Pearl overworld area. Pearl
  already separates its areas by doors and gates, as Black 2 needs (one area per field: notes/WORLD.md).
- Packs: one new exterior building pack (+ its building texture set, same index) per Pearl area's building list,
  appended after Black 2's 70.
- Chunks: Pearl's overworld chunks appended to a/0/0/8 after Black 2's 1065, in Pearl chunk order.
- Building ids: one global id per Pearl model used outdoors (< 512, Black 2's lookup size), so a chunk's buildings
  are found whichever area's pack is loaded.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import narcio, zoneheaders  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

B2_FILES = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
PEARL = os.path.join(ROOT, 'work', 'pearl')

DENY = ({0, 52, 75, 76, 78, 150, 151, 191, 192, 193, 422, 424, 428, 518, 573} | set(range(81, 88))
        | set(range(241, 249)) | set(range(279, 317)) | set(range(478, 494)) | set(range(597, 608))) - {84, 85}
AVOID = {28, 136, 147, 235, 249, 250, 253, 254, 255, 263} | set(range(610, 614)) | {586, 609}
# Zones given to Pearl places by name (2026-10-25, chapter 5a): the Great Marsh's areas 1-5 share area 6's matrix
# (Pearl matrix 240: one zone per cell, sinnoh_rooms writes it per cell), so each needs a zone of its own for its own
# wild Pokémon, people and place. Black 2 had one free zone left (585); 550, 608, 84 and 85 came out of DENY/AVOID:
# nothing in Black 2's code or scripts names them, they have no zone-keyed table entry, and the reason they were kept
# does not hold here (550/608: HoennB2's fixed-weather copies, PearlB2's copy of that patch is not used; 84/85:
# HoennB2's "Nimbasa Stadium 81-87" block, of which the decomp names 81-83, 86 and 87 only): notes/ZONES_KEPT.md.
# They stay out of the general pools (NAMED), so no other zone moves.
GREAT_MARSH_ZONES = {'MAP_GREAT_MARSH_AREA_1': 585, 'MAP_GREAT_MARSH_AREA_2': 550, 'MAP_GREAT_MARSH_AREA_3': 608,
                     'MAP_GREAT_MARSH_AREA_4': 84, 'MAP_GREAT_MARSH_AREA_5': 85}
# Event-only rooms given a kept zone by name (2026-10-26, chapter 9a; user 2026-10-25: the event Pokémon in the game,
# "arceus too"): Arceus's Hall of Origin (Pearl map 510, its own 2 x 2 matrix 241, Spear Pillar's area 50) on 489
# (ASPERTIA_CITY_GYM: nothing in Black 2's code, scripts or zone tables names it; notes/ZONES_KEPT.md "Reserved").
# Allocated after everything else (appended: no other number moves), out of DENY and the pools (NAMED).
EVENT_ROOM_ZONES = {'MAP_HALL_OF_ORIGIN': 489}
NAMED = set(GREAT_MARSH_ZONES.values()) | set(EVENT_ROOM_ZONES.values())
UNOVA_TOWNS = [6, 16, 62, 96, 107, 113, 120, 406, 412, 439, 448, 458, 465]
UNOVA_ROUTES = [319, 321, 326, 329, 331, 337, 345, 348, 365, 368, 370, 374, 378, 383, 387, 423, 437, 446, 463, 474,
                475, 551]
UNOVA_OTHER_OUTDOOR = [154, 157, 194, 198, 205, 230, 238, 240, 444, 456, 461]
FIXED = {'MAP_TWINLEAF': 427}
# + every zone Black 2's decompiled code gives behaviour (b2_special_zones.py -> data/b2_special_zones.json)
_special = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data', 'b2_special_zones.json')
AVOID |= set(json.load(open(_special))['avoid']) - {427}
TOWNS = {'TWINLEAF', 'SANDGEM', 'FLOAROMA', 'SOLACEON', 'CELESTIC', 'SURVIVAL_AREA', 'RESORT_AREA', 'JUBLIFE',
         'CANALAVE', 'OREBURGH', 'ETERNA', 'HEARTHOME', 'PASTORIA', 'VEILSTONE', 'SUNYSHORE', 'SNOWPOINT',
         'POKEMON_LEAGUE', 'FIGHT_AREA'}
B2_CHUNKS, B2_PACKS = 1065, 70
B2_MATRICES, B2_INT_PACKS = 416, 93
# Rooms (every Pearl zone reached through warps from the overworld): Black 2 interior areas are the non-seasonal ids
# 282-408 (texture set index = area id); each Pearl room area takes one (never one a kept Black 2 zone uses), with
# the lights etc. of a Black 2 template area by Pearl's map type: 4 building -> 349 (Floccesy house), 3 cave/dungeon
# -> 332 (Relic Passage / Wellspring Cave), 2 separate outdoor map -> 3 (Nuvema, summer: exterior). Matrices of up
# to 4 cells load whole (Black 2 map type 16), bigger ones 2x2 around the player (map type 0), as Black 2's caves do.
TEMPLATE_AREA = {4: 349, 3: 332, 2: 3, 1: 349, 6: 332}
# Rooms left out of the normal allocation: the 17 Pokémon Center 2F floors hold only the Union Room, Colosseum and
# Wi-Fi Club counters. Black 2 has 386 safe zones for Pearl's 392 reachable rooms, so these share ONE zone (2026-10-18,
# user: trading must work; notes/LINK.md "The shared 2F"): SHARED_ROOMS gives the room that is installed and the name
# suffix of the rooms that use it. It is allocated after every other room (appended: no other number moves);
# rooms['shared'] = {installed Pearl id: [the other Pearl ids]} (sinnoh_events points their warps at it).
EXCLUDED_ROOMS = ('POKECENTER_2F',)
SHARED_ROOMS = {'MAP_JUBLIFE_POKECENTER_2F': 'POKECENTER_2F'}
# Rooms only a script Warp reaches (no warp event leads in: the elevators' upper floors; 2026-10-25, chapter 4a):
# every Pearl map a script's Warp goes to that has no zone yet gets one, after everything else (appended: no number
# above moves; rooms['script_warp'] lists them). Black 2 had 4 free zones left for them. Left out, with the reason:
SCRIPT_WARP_SKIP = {
    'MAP_HEARTHOME_SUPER_CONTEST_HALL_STAGE': 'the Contest stage: Super Contests are not built (DECISIONS 2026-10-18)',
    'MAP_BATTLE_TOWER_ELEVATOR': "Pearl's Battle Tower: the Battle Zone uses Black 2's tower (DECISIONS 2026-10-18)",
    'MAP_BATTLE_TOWER_CORRIDOR_MULTI': "Pearl's Battle Tower (the same)",
    'MAP_BATTLE_TOWER_CORRIDOR_WIFI': "Pearl's Battle Tower (the same)",
    'MAP_BATTLE_TOWER_ARENA_MULTI': "Pearl's Battle Tower (the same)",
    'MAP_BATTLE_TOWER_ARENA_WIFI': "Pearl's Battle Tower (the same)",
    'MAP_BATTLE_TOWER_PARTNER_ROOM': "Pearl's Battle Tower (the same)",
    'MAP_HALL_OF_ORIGIN': "Arceus's Hall of Origin: an event-only place, on its named zone (EVENT_ROOM_ZONES)",
}
# Zones after Black 2's 615 (notes/ZONE_TABLE.md): the blocks reserved per feature, and the Pearl maps given a zone
# there (Pearl map name -> zone, inside its feature's block). A new feature asks the lead for the next block.
# Ramanas Park: Shining Pearl's 9 rooms (652-660). 661-662 are reserved for the Diamond version's Johto and Rainbow
# Rooms (Brilliant Diamond's two extra slate rooms; the user plans a Diamond version of PearlB2): no Pearl map takes them.
# Turnback Cave (2026-10-26, the lead): 623-632, then 663-664 (Pearl's maze takes 12 zones: b2tools/turnback.py).
APPEND_BLOCKS = {'Battle Tower': range(616, 623), 'Turnback Cave': range(623, 633), 'Underground': range(633, 652),
                 'Ramanas Park': range(652, 661), 'Ramanas Park, Diamond only (Johto, Rainbow Rooms)': range(661, 663),
                 'Turnback Cave (2)': range(663, 665)}
DIAMOND_ONLY = APPEND_BLOCKS['Ramanas Park, Diamond only (Johto, Rainbow Rooms)']
# Features whose rooms are not Pearl maps (the Underground's Hideaways, Ramanas Park) write their zones' headers in
# their own patches: sinnoh_world grows the header file to the end of the last block (APPEND_END), so every reserved
# zone has a blank header to fill.
APPEND_END = max(r.stop for r in APPEND_BLOCKS.values())
# Black 2 area records never handed out to a Sinnoh place (rooms take interior areas 282-408, outdoor rooms and the
# overworld take seasonal groups of 4 from 2-281): the Underground (2026-10-26) reuses Black 2's own rooms with their
# areas: 388 (Reversal Mountain 8-13's interior area) and 198-201 (the Moor of Icirrus' seasonal group). Their zones
# are Sinnoh places now, so nothing else keeps these areas out of the free lists. sinnoh_rooms (free_season_groups)
# reads this too.
RESERVED_AREAS = {388} | set(range(198, 202))
# The Underground's tunnels (Pearl's map 2, notes/UNDERGROUND.md): the first zone of its block; its 18 Hideaways
# (634-651) are written by patches/underground.py
# Turnback Cave's Giratina room (the lead, 2026-10-26): installed first because Ramanas Park's Strange Space rooms
# borrow its map (data/ramanas_park.json "looks"). Turnback Cave's maze (2026-10-26, b2tools/turnback.py ZONES): the
# pillar room, and one zone per layout and wild tier of Pearl's 18 random rooms, each holding Pearl's two rooms of that
# layout and tier (the first named here; the zone init moves the rocks for the other), Rooms 17 and 14 alone (Room 14
# has no wild Pokémon in Pearl).
APPENDED = {'MAP_UNDERGROUND': 633, 'MAP_TURNBACK_CAVE_GIRATINA_ROOM': 624,
            'MAP_TURNBACK_CAVE_PILLAR_ROOM': 623, 'MAP_TURNBACK_CAVE_RANDOM_ROOM_3': 625,
            'MAP_TURNBACK_CAVE_RANDOM_ROOM_5': 626, 'MAP_TURNBACK_CAVE_RANDOM_ROOM_2': 627,
            'MAP_TURNBACK_CAVE_RANDOM_ROOM_12': 628, 'MAP_TURNBACK_CAVE_RANDOM_ROOM_10': 629,
            'MAP_TURNBACK_CAVE_RANDOM_ROOM_7': 630, 'MAP_TURNBACK_CAVE_RANDOM_ROOM_18': 631,
            'MAP_TURNBACK_CAVE_RANDOM_ROOM_16': 632, 'MAP_TURNBACK_CAVE_RANDOM_ROOM_17': 663,
            'MAP_TURNBACK_CAVE_RANDOM_ROOM_14': 664}
# Areas whose building pack is not Pearl's list (install below): Pearl's area 2 (the Underground) lists 138 Secret Base
# models (over a pack's 128); the tunnels place only Pearl's four Secret Base holes (build models 429-432, ug_hole_b/f/l/r:
# patches/underground.py puts one on each Hideaway's tunnel wall)
AREA_MODELS = {2: [429, 430, 431, 432]}
assert all(zoneheaders.is_appended(z) for r in APPEND_BLOCKS.values() for z in r)
assert len({z for r in APPEND_BLOCKS.values() for z in r}) == sum(len(r) for r in APPEND_BLOCKS.values())


def main():
    zones = json.load(open(os.path.join(PEARL, 'zones.json')))
    matrix = json.load(open(os.path.join(PEARL, 'matrices', '000.json')))
    ids = sorted({h for row in matrix['headers'] for h in row if h not in (0, 0xffff)})
    headers, _ = zoneheaders.load(B2_FILES)
    spare = [i for i, h in enumerate(headers) if h['map_type'] == 0 and i not in DENY | AVOID | NAMED]
    pools = {'town': list(UNOVA_TOWNS), 'route': list(UNOVA_ROUTES), 'other': list(UNOVA_OTHER_OUTDOOR)}
    used = set(FIXED.values())
    out_zones = {}
    def take(kind):
        for pool in (pools[kind], pools['other'], spare):
            while pool:
                z = pool.pop(0)
                if z not in used and z not in DENY | AVOID | NAMED:
                    used.add(z); return z
        raise SystemExit('out of Black 2 zones')
    for pid in ids:
        name = zones[pid]['name']
        short = name[4:]
        kind = 'route' if short.startswith('ROUTE_') else 'town' if short in TOWNS else 'other'
        b2 = FIXED.get(name) or take(kind)
        out_zones[str(pid)] = {'name': name, 'kind': kind, 'b2_zone': b2, 'pearl_area': zones[pid]['area']}
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    area_data = narc_members(rom.read('fielddata/areadata/area_data.narc'))
    area_build = narc_members(rom.read('fielddata/areadata/area_build_model/area_build.narc'))
    pearl_areas = sorted({z['pearl_area'] for z in out_zones.values()})
    areas, models = {}, set()
    for k, a in enumerate(pearl_areas):
        bset, tset = struct.unpack_from('<HH', area_data[a], 0)
        n = struct.unpack_from('<H', area_build[bset], 0)[0]
        lst = list(struct.unpack_from(f'<{n}H', area_build[bset], 2))
        models |= set(lst)
        assert not {2 + 4 * k + s for s in range(4)} & RESERVED_AREAS, f'area group {2 + 4 * k} is reserved'
        areas[str(a)] = {'b2_area_group': 2 + 4 * k, 'pearl_texset': tset, 'pearl_building_list': bset,
                         'models': lst, 'b2_pack': B2_PACKS + k}
    # a chunk may place models outside its area's Pearl list: each pack also gets every model placed in the area's
    # chunks and in the chunks next to them (visible from inside the area)
    props = {}
    def placed(c):
        if c not in props:
            props[c] = {p['model'] for p in json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))['props']}
        return props[c]
    for pa, a in areas.items():
        own = {int(k) for k, z in out_zones.items() if z['pearl_area'] == int(pa)}
        extra = set()
        for z in range(matrix['height']):
            for x in range(matrix['width']):
                if matrix['headers'][z][x] not in own: continue
                for dz in (-1, 0, 1):
                    for dx in (-1, 0, 1):
                        if 0 <= z + dz < matrix['height'] and 0 <= x + dx < matrix['width']:
                            c = matrix['maps'][z + dz][x + dx]
                            if c != 0xffff: extra |= placed(c)
        a['models'] = a['models'] + sorted(extra - set(a['models']))
        assert len(a['models']) <= 128, (pa, len(a['models']))
        models |= extra
    for c in {c for row in matrix['maps'] for c in row if c != 0xffff}:
        models |= placed(c)
    res = {str(m): i + 1 for i, m in enumerate(sorted(models))}      # 1.. (0x15 is Black 2's fallback model)
    assert len(res) < 512
    chunks = sorted({c for row in matrix['maps'] for c in row if c != 0xffff})
    chunk_ids = {str(c): B2_CHUNKS + i for i, c in enumerate(chunks)}
    rooms = allocate_rooms(zones, set(int(k) for k in out_zones), used, headers, chunk_ids, rom, len(areas))
    out = {'_doc': __doc__.strip().splitlines()[0], 'zones': out_zones, 'areas': areas, 'building_res': res,
           'chunks': chunk_ids, 'rooms': rooms}
    path = os.path.join(ROOT, 'data', 'sinnoh_world.json')
    differ = []
    if os.path.exists(path):
        old = json.load(open(path))
        out, differ = keep_released(out, old)
        renumber_new(out, old)
    check_unique(out)
    os.makedirs(os.path.join(ROOT, 'data'), exist_ok=True)
    json.dump(out, open(path, 'w'), indent=1)
    rooms = out['rooms']
    print(f'{len(out["zones"])} zones, {len(out["areas"])} areas, {len(out["building_res"])} building models, '
          f'{len(out["chunks"])} chunks; rooms: '
          f"{len(rooms['zones'])} zones, {len(rooms['matrices'])} matrices, {len(rooms['chunks'])} new chunks, "
          f"{len(rooms['areas'])} areas, {len(rooms['building_res'])} furniture models, "
          f"{len(rooms.get('appended', []))} on appended zones")
    if differ:
        print(f'kept {len(differ)} released numbers a fresh run gives differently: {differ[:8]}'
              f'{" ..." if len(differ) > 8 else ""}')


def keep_released(new, old):
    """`new` with every number `old` (the released sinnoh_world.json) has put back: old keys keep their values (and
    their order), lists keep old's items first; new keys and items are added. -> (merged, [paths that differed])."""
    differ = []
    def merge(n, o, p):
        if isinstance(o, dict) and isinstance(n, dict):
            m = {k: (merge(n[k], v, f'{p}/{k}') if k in n else v) for k, v in o.items()}
            m.update((k, v) for k, v in n.items() if k not in o)
            return m
        if isinstance(o, list) and isinstance(n, list):
            if n[:len(o)] != o:
                differ.append(p)
            return o + [x for x in n if x not in o]
        if n != o and not p.endswith('_doc'):
            differ.append(p)
        return o
    return merge(new, old, ''), differ


def renumber_new(out, old):
    """After keep_released: a place new since the released file takes its numbers after every number in use, so a
    feature merged later never lands on one released earlier (2026-10-26: the Hall of Origin, allocated before the
    Underground's appended rooms in a fresh run, got the Underground's matrix 622 and chunks 1561-1564)."""
    rooms, orooms = out['rooms'], old.get('rooms', {})
    def fix(entries, old_keys, get, put, taken):
        nxt = max(taken) + 1
        for k in [k for k in entries if k not in old_keys]:
            if get(entries[k]) in taken:
                put(entries, k, nxt); nxt += 1
            taken.add(get(entries[k])); nxt = max(nxt, get(entries[k]) + 1)
    def set_value(d, k, v): d[k] = v
    def set_field(field):
        def put(d, k, v): d[k][field] = v
        return put
    released = lambda vals: set(vals) or {0}
    fix(rooms['matrices'], orooms.get('matrices', {}), lambda m: m['b2_matrix'], set_field('b2_matrix'),
        released(m['b2_matrix'] for k, m in rooms['matrices'].items() if k in orooms.get('matrices', {})))
    chunks_taken = released([v for k, v in out['chunks'].items() if k in old.get('chunks', {})]
                            + [v for k, v in rooms['chunks'].items() if k in orooms.get('chunks', {})])
    fix(out['chunks'], old.get('chunks', {}), lambda v: v, set_value, chunks_taken)
    fix(rooms['chunks'], orooms.get('chunks', {}), lambda v: v, set_value, chunks_taken)
    fix(rooms['areas'], orooms.get('areas', {}), lambda a: a['b2_area'], set_field('b2_area'),
        released(a['b2_area'] for k, a in rooms['areas'].items() if k in orooms.get('areas', {})))
    fix(out['building_res'], old.get('building_res', {}), lambda v: v, set_value,
        released(v for k, v in out['building_res'].items() if k in old.get('building_res', {})))
    fix(rooms['building_res'], orooms.get('building_res', {}), lambda v: v, set_value,
        released(v for k, v in rooms['building_res'].items() if k in orooms.get('building_res', {})))


def check_unique(out):
    """No two places share a zone, matrix, chunk, area or building id (after keep_released)."""
    rooms = out['rooms']
    def unique(what, values):
        values = list(values)
        dup = sorted({v for v in values if values.count(v) > 1})
        assert not dup, f'sinnoh_world.json: {what} used twice: {dup[:10]}'
    unique('zone', [z['b2_zone'] for z in out['zones'].values()] + [r['b2_zone'] for r in rooms['zones'].values()])
    for z in [z['b2_zone'] for z in out['zones'].values()] + [r['b2_zone'] for r in rooms['zones'].values()]:
        zoneheaders.check_zone(z)
    unique('matrix', [m['b2_matrix'] for m in rooms['matrices'].values()])
    unique('chunk', list(out['chunks'].values()) + list(rooms['chunks'].values()))
    unique('area', [a['b2_area'] for a in rooms['areas'].values()])
    unique('building id', out['building_res'].values())
    unique('furniture id', rooms['building_res'].values())


def allocate_rooms(zones, overworld, used, headers, chunk_ids, rom, n_overworld_areas):
    """Every Pearl zone reached by warps from the overworld (breadth first, in Pearl id order) -> Black 2 numbers."""
    seen, order, todo = set(overworld), [], sorted(overworld)
    while todo:
        pid = todo.pop(0)
        ev = json.load(open(os.path.join(PEARL, 'events', f"{zones[pid]['events']:03d}.json")))
        for w in ev['warp_events']:
            d = w['dest_header_id']
            if d < len(zones) and d not in seen and not zones[d]['name'].endswith(EXCLUDED_ROOMS):
                seen.add(d); order.append(d); todo.append(d)
    order.sort()
    pool = [i for i, h in enumerate(headers) if h['map_type'] == 16 and i not in DENY | AVOID | NAMED | used] + \
           [i for i, h in enumerate(headers) if h['map_type'] != 16 and i not in DENY | AVOID | NAMED | used]
    assert len(pool) >= len(order), f'{len(order)} rooms, {len(pool)} free Black 2 zones'
    keep_areas = {headers[i]['area'] for i in DENY | AVOID | NAMED if i < len(headers)}
    free_areas = [a for a in range(282, 409) if a not in keep_areas and a not in RESERVED_AREAS]
    area_data = narc_members(rom.read('fielddata/areadata/area_data.narc'))
    area_build = narc_members(rom.read('fielddata/areadata/area_build_model/area_build.narc'))
    out = {'zones': {}, 'matrices': {}, 'chunks': {}, 'areas': {}, 'building_res': {}}
    next_chunk = B2_CHUNKS + len(chunk_ids)
    models = set()
    for k, pid in enumerate(order):
        z = zones[pid]
        mid = z['matrix']
        if str(mid) not in out['matrices']:
            m = json.load(open(os.path.join(PEARL, 'matrices', f'{mid:03d}.json')))
            out['matrices'][str(mid)] = {'b2_matrix': B2_MATRICES + len(out['matrices']), 'width': m['width'],
                                         'height': m['height']}
            for row in m['maps']:
                for c in row:
                    if c != 0xffff and str(c) not in chunk_ids and str(c) not in out['chunks']:
                        out['chunks'][str(c)] = next_chunk; next_chunk += 1
        a = z['area']
        if str(a) not in out['areas']:
            assert free_areas, 'out of Black 2 interior areas'
            bset, tset = struct.unpack_from('<HH', area_data[a], 0)
            n = struct.unpack_from('<H', area_build[bset], 0)[0]
            lst = list(struct.unpack_from(f'<{n}H', area_build[bset], 2))
            out['areas'][str(a)] = {'b2_area': free_areas.pop(0), 'pearl_texset': tset, 'pearl_building_list': bset,
                                    'models': lst, 'template': TEMPLATE_AREA.get(z['map_type'], 349),
                                    'exterior': z['map_type'] == 2, 'b2_pack': None}
        cells = out['matrices'][str(mid)]['width'] * out['matrices'][str(mid)]['height']
        out['zones'][str(pid)] = {'name': z['name'], 'b2_zone': pool[k], 'pearl_area': a, 'pearl_matrix': mid,
                                  'b2_map_type': 16 if cells <= 4 else 0}
    # models placed in each area's rooms join its list; packs numbered per side (exterior / interior)
    for pid, r in out['zones'].items():
        m = json.load(open(os.path.join(PEARL, 'matrices', f"{r['pearl_matrix']:03d}.json")))
        a = out['areas'][str(r['pearl_area'])]
        for row in m['maps']:
            for c in row:
                if c != 0xffff:
                    placed = {p['model'] for p in json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))['props']}
                    a['models'] = a['models'] + sorted(placed - set(a['models']))
    n_ext = n_int = 0
    for a in out['areas'].values():
        assert len(a['models']) <= 128, len(a['models'])
        models |= set(a['models'])
        if a['exterior']:                     # exterior packs (a/2/2/5) after the overworld areas' 13
            a['b2_pack'] = B2_PACKS + n_overworld_areas + n_ext; n_ext += 1
        else:
            a['b2_pack'] = B2_INT_PACKS + n_int; n_int += 1
    out['building_res'] = {str(m): i + 1 for i, m in enumerate(sorted(models))}
    assert len(out['building_res']) < 512
    # shared rooms, after everything else so that no number above moves
    out['shared'] = {}
    k = len(order)
    for name, suffix in SHARED_ROOMS.items():
        pid = next(i for i, z in enumerate(zones) if z['name'] == name)
        z, mid, a = zones[pid], zones[pid]['matrix'], zones[pid]['area']
        assert str(a) in out['areas'], (name, a)
        assert len(pool) > k, 'no Black 2 zone left for a shared room'
        m = json.load(open(os.path.join(PEARL, 'matrices', f'{mid:03d}.json')))
        if str(mid) not in out['matrices']:        # (the Center 2F matrix is already there: the League lobby 2F)
            out['matrices'][str(mid)] = {'b2_matrix': B2_MATRICES + len(out['matrices']), 'width': m['width'],
                                         'height': m['height']}
        area = out['areas'][str(a)]
        for row in m['maps']:
            for c in row:
                if c == 0xffff: continue
                if str(c) not in chunk_ids and str(c) not in out['chunks']:
                    out['chunks'][str(c)] = next_chunk; next_chunk += 1
                placed = [p['model'] for p in json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))['props']]
                for mm in placed:
                    if mm not in area['models']: area['models'].append(mm)
                    if str(mm) not in out['building_res']:
                        out['building_res'][str(mm)] = max(out['building_res'].values()) + 1
        assert len(area['models']) <= 128 and max(out['building_res'].values()) < 512
        cells = m['width'] * m['height']
        out['zones'][str(pid)] = {'name': z['name'], 'b2_zone': pool[k], 'pearl_area': a, 'pearl_matrix': mid,
                                  'b2_map_type': 16 if cells <= 4 else 0}
        k += 1
        out['shared'][str(pid)] = sorted(i for i, x in enumerate(zones) if x['name'].endswith(suffix) and i != pid)
    # rooms only a script Warp reaches (SCRIPT_WARP_SKIP), after the shared rooms
    have = set(overworld) | {int(p) for p in out['zones']} | {i for v in out['shared'].values() for i in v}
    todo = sorted(d for d in script_warp_destinations(rom) if d < len(zones) and d not in have
                  and zones[d]['name'] not in SCRIPT_WARP_SKIP)
    out['script_warp'] = []

    def install(pid, b2):
        """Pearl map `pid` on Black 2 zone `b2`: its matrix, area, chunks and furniture (a script-Warp room or an
        appended one)."""
        nonlocal next_chunk, n_ext, n_int
        z, mid, a = zones[pid], zones[pid]['matrix'], zones[pid]['area']
        m = json.load(open(os.path.join(PEARL, 'matrices', f'{mid:03d}.json')))
        if str(mid) not in out['matrices']:
            out['matrices'][str(mid)] = {'b2_matrix': B2_MATRICES + len(out['matrices']), 'width': m['width'],
                                         'height': m['height']}
        if str(a) not in out['areas']:
            assert free_areas, 'out of Black 2 interior areas'
            bset, tset = struct.unpack_from('<HH', area_data[a], 0)
            n = struct.unpack_from('<H', area_build[bset], 0)[0]
            ext = z['map_type'] == 2
            out['areas'][str(a)] = {'b2_area': free_areas.pop(0), 'pearl_texset': tset, 'pearl_building_list': bset,
                                    'models': list(AREA_MODELS.get(a) or
                                                   struct.unpack_from(f'<{n}H', area_build[bset], 2)),
                                    'template': TEMPLATE_AREA.get(z['map_type'], 349), 'exterior': ext,
                                    'b2_pack': (B2_PACKS + n_overworld_areas + n_ext) if ext else B2_INT_PACKS + n_int}
            n_ext, n_int = n_ext + ext, n_int + (not ext)
            for mm in out['areas'][str(a)]['models']:     # (the pack holds every listed model: each needs an id)
                if str(mm) not in out['building_res']:
                    out['building_res'][str(mm)] = max(out['building_res'].values()) + 1
        area = out['areas'][str(a)]
        for row in m['maps']:
            for c in row:
                if c == 0xffff: continue
                if str(c) not in chunk_ids and str(c) not in out['chunks']:
                    out['chunks'][str(c)] = next_chunk; next_chunk += 1
                placed = [p['model'] for p in json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))['props']]
                for mm in placed:
                    if mm not in area['models']: area['models'].append(mm)
                    if str(mm) not in out['building_res']:
                        out['building_res'][str(mm)] = max(out['building_res'].values()) + 1
        assert len(area['models']) <= 128 and max(out['building_res'].values()) < 512
        cells = m['width'] * m['height']
        out['zones'][str(pid)] = {'name': z['name'], 'b2_zone': b2, 'pearl_area': a, 'pearl_matrix': mid,
                                  'b2_map_type': 16 if cells <= 4 else 0}
        return z

    while todo:
        pid = todo.pop(0)
        if pid in have:
            continue
        have.add(pid)
        assert len(pool) > k, f'no Black 2 zone left for {zones[pid]["name"]}'
        z = install(pid, pool[k])
        out['script_warp'].append(pid)
        k += 1
        ev = json.load(open(os.path.join(PEARL, 'events', f"{z['events']:03d}.json")))
        todo += sorted(w['dest_header_id'] for w in ev['warp_events'] if w['dest_header_id'] < len(zones)
                       and w['dest_header_id'] not in have and zones[w['dest_header_id']]['name'] not in SCRIPT_WARP_SKIP
                       and not zones[w['dest_header_id']]['name'].endswith(EXCLUDED_ROOMS))
    # zones that share a room matrix with an allocated room, one per cell (GREAT_MARSH_ZONES), after everything else:
    # their matrix, chunks and area are the allocated room's; rooms['cell_zones'] lists the matrices sinnoh_rooms
    # writes with a zone per cell (format 1)
    out['cell_zones'] = []
    by_name = {z['name']: i for i, z in enumerate(zones)}
    for name, b2 in GREAT_MARSH_ZONES.items():
        pid = by_name[name]
        z, mid = zones[pid], zones[pid]['matrix']
        assert str(mid) in out['matrices'] and str(z['area']) in out['areas'], (name, mid, z['area'])
        assert b2 not in DENY | AVOID and b2 not in {r['b2_zone'] for r in out['zones'].values()}, (name, b2)
        out['zones'][str(pid)] = {'name': name, 'b2_zone': b2, 'pearl_area': z['area'], 'pearl_matrix': mid,
                                  'b2_map_type': out['zones'][str(next(int(p) for p, r in out['zones'].items()
                                                                        if r['pearl_matrix'] == mid))]['b2_map_type']}
        if mid not in out['cell_zones']:
            out['cell_zones'].append(mid)
    # event-only rooms on their named zones (EVENT_ROOM_ZONES), last: their matrix, chunks, area (or its new models)
    # and building ids come after every number above
    out['event_rooms'] = []
    for name, b2 in EVENT_ROOM_ZONES.items():
        pid = by_name[name]
        z, mid, a = zones[pid], zones[pid]['matrix'], zones[pid]['area']
        assert b2 not in AVOID and b2 not in {r['b2_zone'] for r in out['zones'].values()}, (name, b2)
        m = json.load(open(os.path.join(PEARL, 'matrices', f'{mid:03d}.json')))
        if str(mid) not in out['matrices']:
            out['matrices'][str(mid)] = {'b2_matrix': B2_MATRICES + len(out['matrices']), 'width': m['width'],
                                         'height': m['height']}
        assert str(a) in out['areas'], (name, a)            # (Spear Pillar's area: no new area or pack)
        area = out['areas'][str(a)]
        for row in m['maps']:
            for c in row:
                if c == 0xffff: continue
                if str(c) not in chunk_ids and str(c) not in out['chunks']:
                    out['chunks'][str(c)] = next_chunk; next_chunk += 1
                placed = {p['model'] for p in json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))['props']}
                for mm in sorted(placed - set(area['models'])):
                    area['models'].append(mm)
                for mm in sorted(placed):
                    if str(mm) not in out['building_res']:
                        out['building_res'][str(mm)] = max(out['building_res'].values()) + 1
        assert len(area['models']) <= 128 and max(out['building_res'].values()) < 512
        cells = m['width'] * m['height']
        out['zones'][str(pid)] = {'name': name, 'b2_zone': b2, 'pearl_area': a, 'pearl_matrix': mid,
                                  'b2_map_type': 16 if cells <= 4 else 0}
        out['event_rooms'].append(pid)
    # rooms on appended zones (616+, notes/ZONE_TABLE.md), last of all, so that no number above moves: each Pearl map
    # of APPENDED gets its zone and, as a script-Warp room, its matrix, area, chunks and furniture. rooms['appended']
    # lists them. Their warps lead where Pearl's do; a destination with no zone yet is not followed (list it too).
    out['appended'] = []
    taken = {r['b2_zone'] for r in out['zones'].values()}
    for name, b2 in sorted(APPENDED.items(), key=lambda kv: kv[1]):
        pid = by_name[name]
        zoneheaders.check_zone(b2)
        assert zoneheaders.is_appended(b2), f'{name}: zone {b2} is not an appended zone (616-1023)'
        assert any(b2 in r for r in APPEND_BLOCKS.values()), f'{name}: zone {b2} is in no APPEND_BLOCKS block'
        assert b2 not in DIAMOND_ONLY or __import__('version').DIAMOND, f'{name}: zone {b2} is for the Diamond version'
        assert b2 not in taken and str(pid) not in out['zones'], f'{name} (zone {b2}): already allocated'
        install(pid, b2)
        taken.add(b2)
        out['appended'].append(pid)
    return out


def script_warp_destinations(rom):
    """Pearl map ids every script's Warp (0xBE) goes to, over all of Pearl's script files."""
    import gen4_script
    table = gen4_script.load_table()
    out = set()
    for data in narc_members(rom.read('fielddata/script/scr_seq_release.narc')):
        if not data:
            continue
        try:
            d = gen4_script.Disasm(data, table)
        except Exception:
            continue                                   # (the level-script files, which are not code)
        for a, (e, op, args) in d.insns.items():
            if op == 0xBE and args and args[0][0] in ('u16', 'var') and args[0][1] < 0x4000:
                out.add(args[0][1])
    return out


if __name__ == '__main__':
    main()
