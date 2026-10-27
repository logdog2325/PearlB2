"""Pearl's moving platforms, for Black 2's gimmick 59 (the decomp's src/pearlb2/pearl_platforms_itcm.c, filled in
by patches/pearl_platforms.py) and the world converters (sinnoh_rooms: the props; pearl_chunk: the lift plates).

    python3 b2tools/pearl_gimmicks.py        prints the zones, platforms and props

Two kinds, as Pearl has them (pokediamond arm9 InitCanalaveGym / Unk025B-025C; pokeplatinum names their code
overlay008/gym_features.c CanalaveGym_* and platform_lift.c):
- the Canalave Gym: floors 2-4 (Pearl build models 300-302 at 160, 320, 480 units) and 24 platforms (models 294 z-way,
  295 x-way, 296 up-down, 297 the red lifts) that move when the player steps on them, each between its positions A
  and B; a collision map a floor (32 x 32); Pearl resets the platforms on every entry (zone script 1);
- the platform lifts: a 3 x 2 plate that carries the player between a bottom and a top floor when they step on its
  trigger tile (Iron Island B1F room 2, B2F room 2, B3F; the League's six, one way up, Cynthia's started by her
  script: LEAGUE_LIFTS; Fantina's Gym's four question rooms, whose lift Pearl's Hearthome Gym code places:
  HEARTHOME_LIFTS). Pearl
  puts the lift at the floor the player came in on. A lift may wait for a flag (flag: up and still until it is set).
All numbers are read from the user's Pearl dump (they equal pokeplatinum's sCanalavePlatformPaths,
sCanalaveGymCollisionMaps and sPerMapPlatformLiftConfiguration): the tables are found by their contents.
"""
import functools, json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)

GIMMICK_ID = 59                  # Black 2's gimmick ids end at 58; PearlB2's own start here (decomp gimmick_itcm.c)
TILE = 16
FLOOR_STEP = 160                 # Pearl: MAP_OBJECT_TILE_SIZE * CANALAVE_DIST_BETWEEN_FLOORS
FLOOR_BASE = -2                  # the walking surface of floor 1 and of every platform model: 2 units under its origin
GYM_FLOOR_MODELS = (300, 301, 302)
LIFT_MODEL = 258                 # Iron Island's lift (lift_base01)
GYM_SPEED, LIFT_SPEED = 8, 1     # units a frame (pokeplatinum FX32_CONST(8) / FX32_ONE)
PLAT_VERTICAL, PLAT_X, PLAT_Z = 0, 1, 2
KIND_OF_MODEL = {294: PLAT_Z, 295: PLAT_X, 296: PLAT_VERTICAL, 297: PLAT_VERTICAL}

# Pearl zone -> (kind, index of the lift in Pearl's table, the zone's bottom-floor arrival z (Pearl's warp z)).
# Iron Island B2F room 2's lift is no map prop in Pearl (its code loads it at (19.5, 44.5) tiles): we add one.
LIFTS = {'MAP_IRON_ISLAND_B1F_ROOM_2': 0, 'MAP_IRON_ISLAND_B2F_ROOM_2': 1, 'MAP_IRON_ISLAND_B3F': 2}
LIFT_PROP_ADDED = {'MAP_IRON_ISLAND_B2F_ROOM_2': (16 * 19 + 8, 16 * (32 + 12) + 8)}   # zone units (x, z)
GYM_ZONE = 'MAP_CANALAVE_GYM'

# Fantina's Gym, Pearl's own (2026-10-26, the ch5b agent; pokediamond InitHearthomeGym 0x02064CC8, the lift's set-up
# ov06_0224186C and MoveHearthomeGymElevator 0x02241914; pokeplatinum keeps them as HearthomeGymDP_*): each of the four
# question rooms has Iron Island's lift (model 0x102 = 258), which Pearl's code adds at (152, 216) units over a 3 x 2
# terrain plate (tiles 8-10, 13-14); the step trigger (9, 13) carries the player between the entrance floor (Pearl 0)
# and the quiz floor (Pearl 160) a unit a frame. Pearl puts it at the entrance floor when the player came in there
# (z 22), else at the quiz floor; in the first room only while flag 0x98D is set (Celestic Ruins' mural: the Leader is
# back), else up and still (its trigger's var, the zone script). The converted floors are -2 and 158 (the walking
# surface 2 units under Pearl's): the lift takes those, its model Pearl's 0 and 160 (propDY 2). Rooms 2-4 share one
# chunk and its one added prop. The flag: a registry name (src/include/pearl.h), gimmick 59's per-lift flag.
HEARTHOME_LIFTS = {'MAP_HEARTHOME_GYM_FIRST_QUESTION_ROOM': 'PFLAG_098D',
                   'MAP_HEARTHOME_GYM_SECOND_QUESTION_ROOM': None,
                   'MAP_HEARTHOME_GYM_THIRD_QUESTION_ROOM': None,
                   'MAP_HEARTHOME_GYM_FOURTH_QUESTION_ROOM': None}
HEARTHOME_LIFT = dict(lo=-2, hi=158, sx=8, sz=13, at=(152, 216), dy=2)

# The Pokémon League's six lifts (2026-10-26, the ch8 agent): rows 3-8 of Pearl's lift table (pokeplatinum
# PLATFORM_LIFT_POKEMON_LEAGUE_ELEVATOR_TO_AARON_ROOM .. _CHAMPION_ROOM), each the room's own map prop of the League's
# lift model 502 (pokemon_league_platform_lift; the three Elite Four links share chunk 306 and its one prop). Pearl's
# League lifts only go up (preventGoingDown) at 2 units a frame (its League kind; Iron Island's 1 both ways). The
# converted floors: the entrance's and the links' are 2 units under Pearl's 0/160/80 (-2, 158, 78: the model at
# Pearl's height, propDY 2); Cynthia's room keeps Pearl's 0 and 240.
# Cynthia's lift has no step trigger in Pearl: her post-battle script runs TriggerPlatformLift with the player on it,
# then walks the player 6 tiles north at the top. So it is "scripted" (no ride on a step; the script asks through
# PVAR_GIMMICK_REQUEST: pl_TriggerPlatformLiftRide), and its plate reaches 6 tiles north of Pearl's 3 x 2 (z 2-9): the
# converted room has no ground up there (Pearl's room model has no surface; its BDHC has 240 at z 2-7), so the lift's
# own layer is that ground while it is up (and while it is down, 0 on floor that is 0 anyway).
# Gimmick 59 keeps these two rules in the platform's floorB byte, which a lift does not otherwise use (floorA/floorB
# are the Canalave Gym's floors): LIFT_ONE_WAY (no ride down) | LIFT_SCRIPTED (no ride on a step).
LIFT_ONE_WAY, LIFT_SCRIPTED = 1, 2
LEAGUE_LIFT_MODEL = 502
LEAGUE_SPEED = 2
# Pearl zone -> (Pearl's lift table row, the converted floor under Pearl's 0 (the bottom; the top 2 units under Pearl's
# top too), floorB bits, plate (dx, dz, w, d) from the trigger tile or None for Pearl's (-1, 0, 3, 2))
LEAGUE_LIFTS = {'MAP_POKEMON_LEAGUE_ENTRANCE': (3, -2, LIFT_ONE_WAY, None),
                'MAP_POKEMON_LEAGUE_AARON_BERTHA_LINK': (4, -2, LIFT_ONE_WAY, None),
                'MAP_POKEMON_LEAGUE_BERTHA_FLINT_LINK': (5, -2, LIFT_ONE_WAY, None),
                'MAP_POKEMON_LEAGUE_FLINT_LUCIAN_LINK': (6, -2, LIFT_ONE_WAY, None),
                'MAP_POKEMON_LEAGUE_LUCIAN_CYNTHIA_LINK': (7, -2, LIFT_ONE_WAY, None),
                'MAP_POKEMON_LEAGUE_CYNTHIA_ROOM': (8, 0, LIFT_ONE_WAY | LIFT_SCRIPTED, (-1, -6, 3, 8))}


def scripted_lift(zone_name):
    """Whether the zone's lift rides only when its script asks (Cynthia's room: pl_TriggerPlatformLiftRide)."""
    row = LEAGUE_LIFTS.get(zone_name)
    return row is not None and bool(row[2] & LIFT_SCRIPTED)

_ROM = None


def rom_data():
    global _ROM
    if _ROM is None:
        from gen4rom import Rom
        _ROM = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    return _ROM


def _find(data, pat, what):
    hits = [m.start() for m in re.finditer(re.escape(pat), data)]
    assert len(hits) == 1, f'{what}: {len(hits)} matches in the Pearl dump'
    return hits[0]


def gym_tables():
    """(platforms, collision maps): platforms as dicts (model, a, b, floorA, floorB, startB); 4 maps of 1024 bytes."""
    d = rom_data().data
    o = _find(d, bytes([16, 0, 9, 16, 30, 9, 0, 3]), 'Canalave Gym platform table') - 4
    plats = []
    for i in range(24):
        m, ax, ay, az, bx, by, bz, fa, fb, st, _ = struct.unpack_from('<I3B3B2BHH', d, o + 16 * i)
        plats.append(dict(model=m, a=(ax, ay, az), b=(bx, by, bz), floorA=fa, floorB=fb, startB=st))
    maps = [d[o + 384 + 1024 * k: o + 384 + 1024 * (k + 1)] for k in range(4)]
    assert all(set(mp) <= {0, 1} for mp in maps), 'Canalave Gym collision maps: not where expected'
    # Pearl's own start states (pokediamond UNK_020F7E54, InitCanalaveGym) equal the table's startB
    assert [p['startB'] for p in plats] == [0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1]
    return plats, maps


def lift_table():
    """Pearl's 9 platform-lift configurations: (bottom height, top height, start tile x, z, no going down, b2f flag)."""
    d = rom_data().data
    o = _find(d, struct.pack('<4i', 16 << 12, 144 << 12, 10, 23), 'platform lift table')
    return [tuple(v >> 12 if k < 2 else v for k, v in enumerate(struct.unpack_from('<6i', d, o + 24 * i)))
            for i in range(9)]


def pearl_zones():
    return json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))


def zone_chunks(zone):
    """{(cx, cz): chunk} of a Pearl zone's matrix."""
    m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f"{zone['matrix']:03d}.json")))
    return {(x, z): c for z, row in enumerate(m['maps']) for x, c in enumerate(row) if c != 0xffff}


def land_props(chunk):
    return json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{chunk:03d}.json')))['props']


def _at_chunk(zone, ux, uz):
    """(chunk, x, z units from its centre) of a zone position in units."""
    cx, cz = int(ux) // 512, int(uz) // 512
    return zone_chunks(zone)[(cx, cz)], ux - 512 * cx - 256, uz - 512 * cz - 256


@functools.lru_cache(maxsize=None)
def zone_configs():
    """[{name, chunk, extra (props to add to that chunk), platforms, floors, collision}] for every zone of gimmick 59."""
    zones = {z['name']: z for z in pearl_zones()}
    out = []
    plats, maps = gym_tables()
    gz = zones[GYM_ZONE]
    (chunk,) = set(zone_chunks(gz).values())
    base = len(land_props(chunk))
    extra = [dict(model=m, pos=[0.0, float(FLOOR_STEP * (k + 1)), 0.0], rot=[0, 0, 0], scale=[1.0, 1.0, 1.0])
             for k, m in enumerate(GYM_FLOOR_MODELS)]
    ps = []
    for i, p in enumerate(plats):
        at = p['b'] if p['startB'] else p['a']
        extra.append(dict(model=p['model'], pos=[float(at[0] * TILE + 8 - 256), float(at[1] * TILE),
                                                  float(at[2] * TILE + 8 - 256)], rot=[0, 0, 0], scale=[1.0, 1.0, 1.0]))
        ps.append(dict(kind=KIND_OF_MODEL[p['model']], floorA=p['floorA'], floorB=p['floorB'], startB=p['startB'],
                       a=(p['a'][0], p['a'][2]), b=(p['b'][0], p['b'][2]),
                       ay=p['a'][1] * TILE + FLOOR_BASE, by=p['b'][1] * TILE + FLOOR_BASE, plate=(0, 0, 1, 1),
                       prop=base + 3 + i,
                       propA=(p['a'][0] * TILE + 8 - 256, p['a'][2] * TILE + 8 - 256),
                       propB=(p['b'][0] * TILE + 8 - 256, p['b'][2] * TILE + 8 - 256),
                       propDY=-FLOOR_BASE, speed=GYM_SPEED))
    out.append(dict(name=GYM_ZONE, chunk=chunk, extra=extra, platforms=ps, floor_prop=base, floors=3,
                    collision=maps))
    lifts = lift_table()
    for name, li in LIFTS.items():
        z = zones[name]
        lo, hi, sx, sz, _, _ = lifts[li]
        if name in LIFT_PROP_ADDED:
            ux, uz = LIFT_PROP_ADDED[name]
            chunk, px, pz = _at_chunk(z, ux, uz)
            prop = len(land_props(chunk))
            extra = [dict(model=LIFT_MODEL, pos=[float(px), float(hi), float(pz)], rot=[0, 0, 0],
                          scale=[1.0, 1.0, 1.0])]
        else:                                         # the map's own lift prop (Pearl places it at the bottom)
            hits = [(c, k, p) for c in sorted(set(zone_chunks(z).values())) for k, p in enumerate(land_props(c))
                    if p['model'] == LIFT_MODEL]
            assert len(hits) == 1, (name, hits)
            chunk, prop, p = hits[0]
            px, pz = p['pos'][0], p['pos'][2]
            extra = []
        ps = [dict(kind=PLAT_VERTICAL, floorA=0, floorB=0, startB=1, a=(sx + 1, sz), b=(sx + 1, sz), ay=lo, by=hi,
                   plate=(-1, 0, 3, 2), prop=prop, propA=(px, pz), propB=(px, pz), propDY=0, speed=LIFT_SPEED)]
        out.append(dict(name=name, chunk=chunk, extra=extra, platforms=ps, floor_prop=0xFFFF, floors=0,
                        collision=None))
    h = HEARTHOME_LIFT
    added = set()
    for name, flag in HEARTHOME_LIFTS.items():
        (chunk,) = set(zone_chunks(zones[name]).values())
        own = land_props(chunk)
        px, pz = h['at'][0] - 256, h['at'][1] - 256           # (a one-chunk room: units from the chunk's centre)
        extra = []
        if chunk not in added:                                # (rooms 2-4: one chunk, one prop)
            added.add(chunk)
            extra = [dict(model=LIFT_MODEL, pos=[float(px), float(h['lo'] + h['dy']), float(pz)], rot=[0, 0, 0],
                          scale=[1.0, 1.0, 1.0])]
        ps = [dict(kind=PLAT_VERTICAL, floorA=0, floorB=0, startB=1, a=(h['sx'] + 1, h['sz']),
                   b=(h['sx'] + 1, h['sz']), ay=h['lo'], by=h['hi'], plate=(-1, 0, 3, 2), prop=len(own),
                   propA=(px, pz), propB=(px, pz), propDY=h['dy'], speed=LIFT_SPEED, flag=flag)]
        out.append(dict(name=name, chunk=chunk, extra=extra, platforms=ps, floor_prop=0xFFFF, floors=0,
                        collision=None))
    for name, (li, base, bits, plate) in LEAGUE_LIFTS.items():
        lo, hi, sx, sz, no_down, _ = lifts[li]
        assert no_down, f'{name}: Pearl\'s lift row {li} goes down'
        z = zones[name]
        hits = [(c, k, p) for c in sorted(set(zone_chunks(z).values())) for k, p in enumerate(land_props(c))
                if p['model'] == LEAGUE_LIFT_MODEL]
        assert len(hits) == 1, (name, hits)
        chunk, prop, p = hits[0]
        assert p['pos'][1] == lo, (name, p['pos'])                     # (Pearl places it at the bottom)
        px, pz = p['pos'][0], p['pos'][2]
        ps = [dict(kind=PLAT_VERTICAL, floorA=0, floorB=bits, startB=0, a=(sx + 1, sz), b=(sx + 1, sz),
                   ay=lo + base, by=hi + base, plate=plate or (-1, 0, 3, 2), prop=prop, propA=(px, pz),
                   propB=(px, pz), propDY=lo - base, speed=LEAGUE_SPEED)]
        out.append(dict(name=name, chunk=chunk, extra=[], platforms=ps, floor_prop=0xFFFF, floors=0, collision=None))
    return out


def object_y(zone_name, obj, y):
    """A person's height in units: on the Canalave Gym's floors 2-4 Pearl's own (its y counts tiles: 10, 20, 30), as
    the converted room has only floor 1 (the floors are props); else y (the converted map's)."""
    if zone_name == GYM_ZONE and obj['y'] >= FLOOR_STEP // TILE:
        return obj['y'] * TILE + FLOOR_BASE
    return y


def extra_props(chunk):
    """Pearl-style props ({model, pos, rot, scale}) that Pearl's code adds to a chunk (sinnoh_rooms appends them after
    the chunk's own props, so their indices are fixed: len(the land's props) + k)."""
    return [p for c in zone_configs() if c['chunk'] == chunk for p in c['extra']]


@functools.lru_cache(maxsize=None)
def lift_plates():
    """{Pearl zone name: [(x, z) tiles of a platform-lift plate]} for every lift in Pearl's table (the League's too):
    the world converter gives those tiles their bottom floor's height (Pearl's plate sits there when the lift is down;
    the converted map has no ground there, height 0)."""
    # Pearl's table order (pokeplatinum PlatformLiftID), with pokediamond's zone names: the zones whose scripts run
    # TriggerPlatformLift (0x25C) on the table's start tiles
    names = ['MAP_IRON_ISLAND_B1F_ROOM_2', 'MAP_IRON_ISLAND_B2F_ROOM_2', 'MAP_IRON_ISLAND_B3F',
             'MAP_POKEMON_LEAGUE_ENTRANCE', 'MAP_POKEMON_LEAGUE_AARON_BERTHA_LINK',
             'MAP_POKEMON_LEAGUE_BERTHA_FLINT_LINK', 'MAP_POKEMON_LEAGUE_FLINT_LUCIAN_LINK',
             'MAP_POKEMON_LEAGUE_LUCIAN_CYNTHIA_LINK', 'MAP_POKEMON_LEAGUE_CYNTHIA_ROOM']
    out = {}
    for name, (lo, hi, sx, sz, _, _) in zip(names, lift_table()):
        out[name] = (lo, [(sx + dx, sz + dz) for dz in range(2) for dx in range(3)])
    h = HEARTHOME_LIFT                                # (Fantina's Gym: the plate over the shaft's floor, at -18)
    for name in HEARTHOME_LIFTS:
        out[name] = (h['lo'], [(h['sx'] + dx, h['sz'] + dz) for dz in range(2) for dx in range(3)])
    return out


if __name__ == '__main__':
    for c in zone_configs():
        print(c['name'], 'chunk', c['chunk'], 'extra props', [(p['model'], p['pos']) for p in c['extra']][:6],
              f"({len(c['extra'])})")
        for p in c['platforms'][:3]:
            print('  ', p)
    print(lift_plates())
