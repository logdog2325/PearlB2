"""Pearl map events -> Black 2 zone entities (notes/STORY.md "Events"): people, signs, step triggers, and the zone's
map-script table, for b2tools/patches/sinnoh_story.py.

Tables (researched 2026-10-18, sources in each file's _doc):
- data/pearl_sprite_map.json: Pearl graphics id -> Black 2 object code (stand-ins marked). Pearl's dynamic sprites
  101-116 (var 0x4020+n) are Black 2's 162-177 (work 0x4020+n): scripts store Black 2 codes in those works
  (pearl_story: SetVarFromValue on 0x4020-0x402F goes through sprite_code).
- data/pearl_movement_types.json: Pearl movement type -> Black 2 NPC move code (the same numbers, except berry soil 47
  and the snow/sand/rock disguises 51-53).
- data/pearl_npc_fields.json: the NPC record field by field (Black 2's is Pearl's with a rail flag added).

Rules:
- NPCs keep Pearl's order (a script's SetObjectEventPos index = the position in this list) and uid = Pearl's local id.
- Pearl's signposts, mailboxes and signboards are objects (graphics 91-96) that block the way and run the sign script
  when talked to (from any side). Black 2 has no sign actor: its signs are building models with a BG event. Each
  becomes Black 2's: a sign model on its tile and the tile solid (b2tools/pearl_signs.py, in every chunk), and here a
  sign event running the object's script, readable from any side (direction 4). They are not in the NPC list (until
  2026-10-20 each was an NPC with Black 2's notice-board sprite, code 200), so later people's indices shift
  (pearl_story object_index comes from kept_objects too).
- Objects Black 2 cannot show (berry soil, book, the cave painting, the Elite Four doors; the Galactic HQ door is a
  person since 2026-10-25, code 292 with Pearl's own picture: patches/pearl_npc_sprites) and
  Pearl's item balls (7000+) and hidden items (8000+: BG events), whose Black 2 systems are not set up yet, are left
  out and listed (skipped()), except the item balls data/pearl_item_balls.json installs (Pearl's HM and key-item
  balls since 2026-10-25: item_ball, item_ball_flag), people running Pearl's own item-ball script.
- Global scripts (Pearl 2000+, other than trainers, items, hidden items) run through a proxy entry of the zone's
  own script file (pearl_story proxies): the NPC's script is that entry.
- Heights: the converted map's tile height (work/world/heights_*.json, units: 16 a tile); NPC y = units * 0x1000.
"""
import json, os

import pearl_gimmicks
import pearl_hidden_paths

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
SIGN_GFX = {91, 92, 93, 94, 95, 96}   # Pearl's signposts, mailboxes, signboards: Black 2 sign events (pearl_signs)
# Pearl's player sprites, which scripts store in the dynamic-sprite vars for the counterpart (Pearl sets VAR_0 to 0x61
# Dawn or 0 Lucas): Black 2's players, Rosa 240 / Nate 231 (24-frame walk + run sheets; data/pearl_sprite_map.json 101)
# Pearl draws the counterpart with the player's own walk + run sheet (hero / heroine; pokeplatinum object_event_gfx_data
# PLAYER_M/F = player_m/f_nsbtx); 231/240 carry those sheets (patches/pearl_player_sprites), so this is Pearl's art.
PLAYER_SPRITES = {0: 231, 97: 240}
_SPR = _MOV = None


def sprite_table():
    global _SPR
    if _SPR is None:
        _SPR = {int(k): v for k, v in json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json'))).items()
                if k.isdigit()}
    return _SPR


def sprite_code(gfx, zone=None):
    """Black 2 object code for a Pearl graphics id (None: no Black 2 actor; signs: is_sign). zone: a zone name; an id
    can have a code of its own there (data/pearl_sprite_map.json "zone_codes": the Galactic HQ lab's lake trio, drawn
    lower than elsewhere so they stay inside their units, 2026-10-26)."""
    if gfx in PLAYER_SPRITES:
        return PLAYER_SPRITES[gfx]
    e = sprite_table().get(gfx)
    if not e:
        return None
    return e.get('zone_codes', {}).get(zone, e['code'])


def b2_move(t):
    global _MOV
    if _MOV is None:
        _MOV = {int(k): v for k, v in json.load(open(os.path.join(ROOT, 'data', 'pearl_movement_types.json'))).items()
                if k.isdigit()}
    e = _MOV.get(t)
    return e['b2_move'] if e and e['b2_move'] is not None else 0


# A person whose sheet has no official back view (data/pearl_sprite_map.json "back": "generated": the PWT's Gym
# Leaders, whose back view and steps patches/pearl_pwt_frames fills with copies of the official front frame) and who stands still
# facing up in Pearl faces the nearest way the official frames show: LOOK_NORTH -> LOOK_SOUTH, a look list loses
# north for south (NW -> SW, NE -> SE, NSW -> SW, NSE -> SE, NWE -> SWE, NS -> S), looking around / turning on the
# spot -> SWE. Walks and scripts keep their ways (they use the made frames). b2tools/frame_check.py checks it.
NO_NORTH = {14: 15, 2: 13, 6: 8, 7: 9, 10: 8, 11: 9, 12: 13, 45: 15, 18: 13, 19: 13}


def fit_move(o, code):
    """(Black 2 move code, direction) of a Pearl object drawn with object code `code`."""
    move, d = b2_move(o['movement_type']), o['initial_dir']
    if (sprite_table().get(o['graphics_id']) or {}).get('back') == 'generated':
        move = NO_NORTH.get(move, move)
        if d == 0 and (move in (0, 15) or move in NO_NORTH.values()):
            d = 1                                  # (the way it first faces: down, which every look list here has)
    return move, d


def script_kind(s):
    if s == 0xFFFF or s == 0:
        return 'none'
    if s < 2000:
        return 'local'
    if 3000 <= s < 7000:
        return 'trainer'
    if 7000 <= s < 8000:
        return 'item'
    if 8000 <= s < 8800:
        return 'hidden'
    return 'global'


def level_scripts(pd, zone):
    """([(Pearl type, script id)], [[(var, value, script id)]]) of a zone's level-script file."""
    import struct
    data = pd.files[zone['level_scripts']]
    entries, tables, p = [], [], 0
    while p < len(data) and data[p]:
        t = data[p]
        v, = struct.unpack_from('<i', data, p + 1)
        if t == 1:
            q, rows = p + 5 + v, []
            while struct.unpack_from('<H', data, q)[0]:
                rows.append(struct.unpack_from('<HHH', data, q))
                q += 6
            tables.append(rows)
        else:
            entries.append((t, v & 0xFFFF))
        p += 5
    return entries, tables


def proxies(events, pd=None, zone=None):
    """Sorted Pearl global script ids that this zone's objects, signs, triggers (and map scripts, given pd and zone)
    run: they get proxy entries."""
    out = set()
    if pd is not None:
        entries, tables = level_scripts(pd, zone)
        out |= {s for t, s in entries if s >= 2000} | {s for rows in tables for v, val, s in rows if s >= 2000}
    for o in events['object_events']:
        if script_kind(o['script']) == 'global':
            out.add(o['script'])
    for b in events['bg_events']:
        if script_kind(b['script']) == 'global':
            out.add(b['script'])
    for c in events['coord_events']:
        if script_kind(c['script']) == 'global':
            out.add(c['script'])
    if zone is not None and rock_climb_ends(zone['name']):
        out.add(ROCKY_WALL)                       # (the Rock Climb walls' sign events: rock_climb_ends)
    if zone is not None and town_map_tiles(zone):
        out.add(TOWN_MAP)                         # (the wall maps' sign events: town_map_tiles)
    return sorted(out)


class Heights:
    def __init__(self):
        self.h, self.low = {}, {}
        for name, into in (('heights_overworld.json', self.h), ('heights_rooms.json', self.h),
                           ('heights_overworld_low.json', self.low), ('heights_rooms_low.json', self.low)):
            p = os.path.join(ROOT, 'work', 'world', name)    # (*_low: the level under a bridge, pearl_chunk two_levels)
            if os.path.exists(p):
                for c, hs in json.load(open(p)).items():
                    into[int(c)] = {tuple(map(int, k.split(','))): y for k, y in hs.items()}
        self.mats, self.lands = {}, {}

    def chunk(self, zone, x, z):
        mid = zone['matrix']
        if mid not in self.mats:
            self.mats[mid] = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f'{mid:03d}.json')))
        m = self.mats[mid]
        cx, cz = x // 32, z // 32
        if not (0 <= cx < m['width'] and 0 <= cz < m['height']) or m['maps'][cz][cx] == 0xffff:
            return None
        return m['maps'][cz][cx]

    def at(self, zone, x, z, near=None):
        """Height in units of Pearl tile (x, z) of a zone's matrix, or None. A tile with two levels (a bridge over a
        road: pearl_chunk.two_levels) gives the deck's, or with `near` (Pearl's own height of a person, units) the
        level nearest it, as Pearl places its people (pokeplatinum bdhc.c: the plate nearest the object's height)."""
        c = self.chunk(zone, x, z)
        if c is None: return None
        y = self.h.get(c, {}).get((x % 32, z % 32))
        low = self.low.get(c, {}).get((x % 32, z % 32))
        if y is not None and low is not None and near is not None and abs(low - near) < abs(y - near):
            return low
        return y

    def solid(self, zone, x, z):
        c = self.chunk(zone, x, z)
        if c is None:
            return True
        if c not in self.lands:
            self.lands[c] = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))
        return bool(self.lands[c]['collision'][z % 32][x % 32])

    def sign_y(self, zone, x, z, facing, blocked=False):
        """y of a sign (BG event): Black 2 reads one when the player faces its tile from within 2 units of its y
        (ov012 CheckBGPositionMatchGrid). A sign on a solid tile (a counter, a TV; blocked: a tile the build makes
        solid, Pearl's sign objects) takes the height of the tiles it is read from (the most common: as HoennB2's
        story.py sign_y); facing 0 = read from the south only."""
        own = self.at(zone, x, z)
        if not blocked and not self.solid(zone, x, z):
            return own
        sides = [(0, 1)] if facing == 0 else [(0, 1), (0, -1), (1, 0), (-1, 0)]
        hs = [self.at(zone, x + dx, z + dz) for dx, dz in sides if not self.solid(zone, x + dx, z + dz)]
        hs = [h for h in hs if h is not None]
        if not hs:
            return own
        return max(set(hs), key=hs.count)


def is_sign(o):
    """A Pearl signpost, mailbox or signboard: a Black 2 sign model + sign event, not a person."""
    return o['graphics_id'] in SIGN_GFX


ROCK_CLIMB = os.path.join(ROOT, 'data', 'pearl_rock_climb.json')
SIGN_DIR = {0: 0, 1: 3, 2: 2, 3: 1}   # the player's facing (0 up, 1 down, 2 left, 3 right) -> a sign event's direction
ROCKY_WALL = 10003          # Pearl's global script facing a Rock Climb wall (scr_seq 375 entry 4): "The wall is very
                            # rocky... Would you like to use Rock Climb?" (party move, Icicle Badge, no partner)
_CLIMB = None
TOWN_MAP = 2508             # Pearl's wall map: tile behaviour 0x85 (TOWN_MAP) runs BG_EVENTS 8 = scr_seq 1 entry 9 (fade,
TOWN_MAP_BEHAVIOUR = 0x85   # OpenRegionMap, fade back: pokeplatinum Field_TileBehaviorToScript), not a BG event
# global scripts the project's own events add (pearl_story PearlData.proxy_ids numbers them after Pearl's, in this order)
ADDED_PROXIES = [ROCKY_WALL, TOWN_MAP]
_TOWN_MAPS = {}


def town_map_tiles(zone):
    """Pearl's wall maps in a zone (a zones.json dict): its tiles of behaviour 0x85, which Pearl reads by the tile in
    front of the player (no BG event). Black 2 has no such behaviour, so each becomes a sign event running TOWN_MAP
    (entities). Every one sits on a north wall, read from the walkable tile south of it; one with no walkable tile
    there (the Pokémon League lobby's, behind its counter) cannot be faced in Pearl either and is left out.
    -> [(x, z)] in the zone's tile coordinates (2026-10-26: 17 Pokémon Centers, the Pokétch Company 2F/3F, Jubilife
    TV 4F, 8 gatehouses, the Battle Tower lobby)."""
    mid = zone['matrix']
    if mid not in _TOWN_MAPS:
        m = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'matrices', f'{mid:03d}.json')))
        out = []
        for cz, row in enumerate(m['maps']):
            for cx, c in enumerate(row):
                if c == 0xffff:
                    continue
                land = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.json')))
                b, col = land['behaviour'], land['collision']
                for z in range(31):
                    for x in range(32):
                        if b[z][x] == TOWN_MAP_BEHAVIOUR and not col[z + 1][x]:
                            out.append((32 * cx + x, 32 * cz + z))
        _TOWN_MAPS[mid] = out
    return _TOWN_MAPS[mid]


def rock_climb_ends(zone_name):
    """The places a Rock Climb starts in a Pearl zone (data/pearl_rock_climb.json, b2tools/rock_climb.py --write): Pearl
    finds its climb walls by tile behaviour (0x4B / 0x4C), which Black 2 has not, so each start is a sign event on the
    first climb tile, read facing the wall, running ROCKY_WALL; its UseRockClimb moves the player (pearl_story)."""
    global _CLIMB
    if _CLIMB is None:
        _CLIMB = json.load(open(ROCK_CLIMB)) if os.path.exists(ROCK_CLIMB) else {}
    return _CLIMB.get(zone_name, [])


ITEM_BALLS = os.path.join(ROOT, 'data', 'pearl_item_balls.json')
ITEM_BALL_GFX = 87          # Pearl's item ball (data/pearl_sprite_map.json: Black 2's item-ball sprite, code 110)
_BALLS = None


def installed_item_balls():
    """{(Pearl map name, object id): row} of the item balls installed as people (data/pearl_item_balls.json)."""
    global _BALLS
    if _BALLS is None:
        _BALLS = {(r['zone'], r['obj']): r for r in json.load(open(ITEM_BALLS))['installed']} \
            if os.path.exists(ITEM_BALLS) else {}
    return _BALLS


def item_ball(zone, o):
    """The row of data/pearl_item_balls.json that installs object o of the zone (a zone dict or None), or None."""
    if zone is None or script_kind(o['script']) != 'item':
        return None
    return installed_item_balls().get((zone['name'], o['id']))


def item_ball_flag(ids, o):
    """The Black 2 flag of an installed item ball, the one rule for them (data/pearl_item_balls.json _doc): its Pearl
    flag (Pearl's item-ball flags 986+n, the object's hidden_flag) through the id registry. The person hides by it, and
    Pearl's RemoveEvent of the talked-to ball sets it (pearl_story h_remove: pl_RemoveTalkedObject)."""
    return ids.flag_value(o['hidden_flag']) if o['hidden_flag'] else 0


def object_skipped(o, zone=None):
    """Why a Pearl object is not installed (None: it is, as a Black 2 person, or as a sign: is_sign). zone: the Pearl
    zone dict, for the item balls data/pearl_item_balls.json installs (item_ball)."""
    if script_kind(o['script']) in ('item', 'hidden'):
        if item_ball(zone, o):
            return None
        return f'object {o["id"]}: item ball (script {o["script"]}): Black 2 item balls not set up yet'
    if is_sign(o):
        return None
    if sprite_code(o['graphics_id']) is None:
        return (f'object {o["id"]}: graphics {o["graphics_id"]} ({sprite_table().get(o["graphics_id"], {}).get("pearl_name")}) '
                f'has no Black 2 actor')
    if o['movement_type'] == 47:
        return f'object {o["id"]}: berry soil'
    return None


def kept_objects(pd, zone):
    """Pearl objects installed as Black 2 people, in the order of the zone's NPC list (entities()); copies included
    (they take places in the list; no script addresses them); signs are sign events, not in the list."""
    return [o for o in pd.events(zone)['object_events'] if not object_skipped(o, zone) and not is_sign(o)]


COPY_SCRIPT = 0xFFFF


def copy_original(pd, o):
    """The object a copy stands for, or None. Pearl's objects with script 0xFFFF copy a neighbouring zone's object
    near the border (drawn before you cross); their hidden-flag field holds THAT zone's map header id, not a flag:
    Pearl adds a copy without a flag check and keeps the live original when you cross (pokeplatinum map_object.c
    sub_020620C4, sub_02062714, sub_0206244C), and scripts never address copies (MapObjectMan finds local ids among
    objects with a script, :2312). In Black 2 a copy is an NPC of its own (sinnoh_story CLONE_UID), so it takes its
    original's hide flag: hidden exactly when the original is (2026-10-20: copies took the header id as a flag, e.g.
    Route 201's copy of a Sandgem sign hid by Pearl flag 0x1A2)."""
    if o['script'] != COPY_SCRIPT or not 0 <= o['hidden_flag'] < len(pd.zones):
        return None
    return next((x for x in pd.events(pd.zones[o['hidden_flag']])['object_events']
                 if x['id'] == o['id'] and x['script'] != COPY_SCRIPT), None)


def hide_flag(pd, o):
    """The Pearl flag that hides object o in Black 2 (a copy: its original's), 0 = none."""
    if o['script'] == COPY_SCRIPT:
        orig = copy_original(pd, o)
        return orig['hidden_flag'] if orig else 0
    return o['hidden_flag']


def entities(pd, zone, ids, heights, script_ids):
    """(npcs, signs, triggers, skipped) for a Pearl zone, as Black 2 entity dicts (b2tools/zones.py).
    script_ids(sid) -> the Black 2 script id for a Pearl one (proxies, trainers)."""
    ev = pd.events(zone)
    npcs, signs, trigs, skipped = [], [], [], []
    # closed places (pearl_story CLOSED, data/pearl_closed_facilities.json): a step trigger, or a person / sign whose
    # script becomes the closed-place entry
    closed = list(zip(pd.closed_ids(zone['id']), pd.closed(zone)))
    talk_obj = {r['obj']: k for k, r in closed if r.get('talk') and 'obj' in r}
    talk_bg = {r['bg']: k for k, r in closed if r.get('talk') and 'bg' in r}
    balls = pd.item_ball_ids(zone['id']) if hasattr(pd, 'item_ball_ids') else {}   # installed item balls: their entry
    # Ramanas Park in Pal Park (b2tools/ramanas.py): a person whose talk script an extra entry runs first, and new
    # people after Pearl's (no index of Pearl's moves): the slate clerk
    rids = pd.ramanas_ids(zone['id']) if hasattr(pd, 'ramanas_ids') else {}
    added = []
    if rids:
        import ramanas
        talk_obj.update(ramanas.talk_override(zone['name'], rids))
        added = ramanas.extra_people(zone['name'], rids)
    for o in ev['object_events'] + added:
        why = object_skipped(o, zone)
        if why:
            skipped.append(why)
            continue
        if is_sign(o):
            continue                               # (a sign event, below)
        code = sprite_code(o['graphics_id'], zone['name'])
        y = heights.at(zone, o['x'], o['z'], near=o['y'] * 16)   # (under or on a bridge: Pearl's y says)
        y = pearl_gimmicks.object_y(zone['name'], o, y)   # (on a floor Pearl's code builds: the Canalave Gym's)
        y = pearl_hidden_paths.object_y(zone['name'], o, y)   # (on a path Pearl reveals: Route 224's Shaymin)
        move, facing = fit_move(o, code)
        npcs.append(dict(uid=o['id'], model=code, move=move,
                         evtype=0 if o['trainer_type'] == 3 else o['trainer_type'],
                         flag=item_ball_flag(ids, o) if o['id'] in balls else
                         ids.flag_value(hide_flag(pd, o)) if hide_flag(pd, o) else 0,
                         script=o['script'] if any(o is a for a in added) else
                         talk_obj.get(o['id']) or balls.get(o['id']) or script_ids(o['script']), dir=facing,
                         p0=o['data'][0], p1=o['data'][1], p2=o['data'][2],
                         areaw=o['movement_range_x'] & 0xFFFF, areah=o['movement_range_z'] & 0xFFFF, rail=0,
                         x=o['x'], z=o['z'], y=(y * 0x1000) if y is not None else (o['y'] << 16),
                         clone=o['script'] == 0xFFFF))      # (a copy of a neighbouring zone's object)
    for bi, b in enumerate(ev['bg_events']):
        kind = script_kind(b['script'])
        if (kind == 'hidden' or b['type'] == 2) and bi not in talk_bg:
            skipped.append(f'hidden item at ({b["x"]},{b["z"]}) (script {b["script"]}): Black 2 hidden items not set up yet')
            continue
        y = heights.sign_y(zone, b['x'], b['z'], b['player_facing_dir'])
        signs.append(dict(script=talk_bg.get(bi) or script_ids(b['script']), cond=0 if bi in talk_bg else b['type'],
                          dir=b['player_facing_dir'], rail=0,
                          x=b['x'], z=b['z'], y=y if y is not None else b['y']))
    for o in ev['object_events']:
        # Pearl's sign objects (after Pearl's own BG events, whose indices stay): read from any side, as Pearl's
        # objects (direction 4); copies (script 0xFFFF) and script 0 (Route 204 North's twin of Route 204 South's
        # sign) run nothing; the model and the solid tile come with the map (pearl_signs)
        if not is_sign(o) or script_kind(o['script']) == 'none':
            continue
        y = heights.sign_y(zone, o['x'], o['z'], 4, blocked=True)
        signs.append(dict(script=script_ids(o['script']), cond=0, dir=4, rail=0,
                          x=o['x'], z=o['z'], y=y if y is not None else o['y'] * 16))
    for r in rock_climb_ends(zone['name']):
        # a Rock Climb start: read facing the wall (its dir) from the tile before it, at that tile's height (Black 2
        # reads a sign within 2 units of the player's y). A sign's direction is coded as Pearl's and Black 2's sign
        # events code it, not as the player's facing: 0 north, 1 east, 2 west, 3 south (pokebw2 eventdata_system.c
        # GetZoneProxiesAndCount, pokeplatinum bg_event_dirs: the same); found 2026-10-26, a climb down did not start
        y = heights.at(zone, *r['stand'])
        signs.append(dict(script=script_ids(ROCKY_WALL), cond=0, dir=SIGN_DIR[r['dir']], rail=0,
                          x=r['bg'][0], z=r['bg'][1], y=y if y is not None else 0))
    for x, z in town_map_tiles(zone):
        # a wall map (town_map_tiles): read facing it from the south, at that tile's height; the map opens view-only
        # (patches/town_map.py: CallPlaceSelect in a zone without Fly)
        y = heights.sign_y(zone, x, z, 0)
        signs.append(dict(script=script_ids(TOWN_MAP), cond=0, dir=SIGN_DIR[0], rail=0,
                          x=x, z=z, y=y if y is not None else 0))
    for c in ev['coord_events']:
        # Black 2 fires a trigger only within 2 units of its y (ov012 CheckTriggerPositionMatchXYZ): the height of most
        # of its walkable tiles, not of its corner (Sandgem's corner tile is a raised edge: tested 2026-10-18)
        hs = [heights.at(zone, x, z) for x in range(c['x'], c['x'] + c['width'])
              for z in range(c['z'], c['z'] + c['length']) if not heights.solid(zone, x, z)]
        hs = [v for v in hs if v is not None]
        y = max(set(hs), key=hs.count) if hs else heights.at(zone, c['x'], c['z'])
        trigs.append(dict(script=script_ids(c['script']), value=c['value'], work=ids.var_value(c['var']), type=0,
                          rail=0, x=c['x'], z=c['z'], w=c['width'], h=c['length'],
                          y=(y if y is not None else c['y']) & 0xFFFF if (y if y is not None else c['y']) >= 0
                          else (y if y is not None else c['y']), unk=0))
    for k, r in closed:
        if r.get('talk'):
            continue
        hs = [heights.at(zone, x, z) for x in range(r['x'], r['x'] + r['w']) for z in range(r['z'], r['z'] + r['h'])
              if not heights.solid(zone, x, z)]
        hs = [v for v in hs if v is not None] or [0]
        y = max(set(hs), key=hs.count)
        trigs.append(dict(script=k, value=0, work=0, type=0, rail=0, x=r['x'], z=r['z'], w=r['w'], h=r['h'],
                          y=y & 0xFFFF if y >= 0 else y, unk=0))      # work 0: Black 2 fires it always (eventdata_system.c)
    return npcs, signs, trigs, skipped


def map_script_table(pd, zone, ids):
    """Black 2 map-script table bytes (MapScript entries, ov012 FieldScript_GetInitSCRID) from Pearl's level script
    file, and {script id: feature level} for the checker. Pearl 2 (on transition) -> Black 2 2 (zone init, level 2);
    Pearl 4 (layout loaded) and 3 (resume: drawn, also after battles and menus) -> Black 2 3 (field created) and 4
    (created by continuing a save), level 1, in Pearl's order (4 before 3); Pearl's frame table (type 1: var == value
    -> script, checked before each frame) -> Black 2 1 (FieldScript_GetSceneChangeSCRID, the same check)."""
    import struct
    entries, tables = level_scripts(pd, zone)
    local = lambda s: pd.proxy_ids()[s] if s >= 2000 else s      # a global script: its proxy entry
    entries = [(t, local(s)) for t, s in entries]
    elev = pd.elevator_init(zone['id']) if hasattr(pd, 'elevator_init') else None
    if elev:                                       # an elevator's floor or room (pearl_story ELEVATOR_FLOORS_ABOVE):
        entries.append((2, elev[0]))               # one more zone init, after Pearl's (Black 2 runs every one)
    tables = [[(v, val, local(s)) for v, val, s in rows] for rows in tables]
    levels = {}
    out = []
    for t, s in [e for e in entries if e[0] == 2] + [e for e in entries if e[0] == 4] + [e for e in entries if e[0] == 3]:
        for b2t in ((2,) if t == 2 else (3, 4)):
            out.append(struct.pack('<HI', b2t, s))
        levels[s] = 2 if t == 2 else max(levels.get(s, 1), 1)
    tb = pd.turnback_doors(zone['id']) if hasattr(pd, 'turnback_doors') else None
    if tb:                                         # Turnback Cave's maze (b2tools/turnback.py): the doors, once
        out.append(struct.pack('<HI', 4, tb))      # after each map change (Black 2 type 4 only, level 1)
        levels[tb] = 1
    cond = b''
    for rows in tables:
        for var, val, s in rows:
            cond += struct.pack('<HHH', ids.var_value(var), val, s)
    rids = pd.ramanas_ids(zone['id']) if hasattr(pd, 'ramanas_ids') else {}
    if rids:                                       # Ramanas Park (b2tools/ramanas.py): rows after Pearl's, on
        import ramanas                             # Black 2 works (the gate's walk-out after a visit)
        for work, val, s in ramanas.frame_rows(zone['name'], rids):
            cond += struct.pack('<HHH', work, val, s)
    if cond:
        cond += struct.pack('<H', 0)
    # layout: entries (6 bytes each), the conditions entry (type 1, offset from after itself), end (u16 0), table
    body = b''.join(out)
    if cond:
        body += struct.pack('<HI', 1, 2)          # the table starts 2 bytes after this entry: after the end marker
    body += struct.pack('<H', 0) + cond
    while len(body) % 4:
        body += b'\0'
    return body, levels
