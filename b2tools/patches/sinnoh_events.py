"""Every Sinnoh zone's events (a/1/2/6, appended), from Pearl's events (work/pearl/events). Runs after sinnoh_world
and sinnoh_rooms (it reads their tile heights). For now: warps (doors, stairs, cave mouths, exit mats). NPCs, signs
and step triggers come with the story (they need Black 2 scripts).

Warp record (HoennB2 notes/GEN5_MAPS.md section 5): dest zone, dest warp index, dir, type, x/z = tile*16 + 8,
y = the tile's height (s16; warps fire within 2 units of it), 1 x 1 tiles. How Black 2 fires them
(GetWarpIDByPlayerPos, src/ov012/eventdata_system.c:124, tested 2026-10-18):
- type 1: the player STANDS on the warp tile and tries to move (Black 2's exit mats);
- other types: the player walks INTO the warp tile from the next tile, in the warp's direction
  (CheckWarpDirectionMatch :210: dir 2 = walking up, 1 = down, 4 = left, 3 = right).
So, from Pearl's tile at the warp:
- solid tile (doors, cave mouths in a wall): type 3 (DOOR 0x69) or 4, dir = towards it from its walkable neighbour,
  y = the neighbour's height;
- WARP_STAIRS_EAST/WEST 0x5e/0x5f (the stairs' foot, walkable): ONE type-2 warp on the flight tile beyond it (0x5e:
  x + 1, 0x5f: x - 1; solid, the converter's slope), entered from the foot walking east / west, at the foot's height;
  on arrival Black 2 steps the player back onto the foot, where Pearl puts them (2026-10-20). (Before: 2026-10-19 the
  warp on the foot made solid, the player arriving one tile beyond Pearl's; earlier one warp per open side of the
  foot, of which only the first fired, "walking up", so stairs worked like a door the player arrived standing on.)
- warp panels 0x67 (the Galactic HQ): type 5, dir 0, Black 2's step-on warp panel (PEARL_WARP_PANEL);
- Pearl's step-on tiles in rooms (WARP_ENTRANCE_NORTH 0x64, WARP_NORTH 0x6E: the ladders up and north mats; the
  escalators 0x6A / 0x6B: the Centers' stairs, Veilstone's store): type 0, Black 2's step-on warp (PEARL_STEP_ON);
- any other walkable warp tile (exit mats WARP_*/WARP_ENTRANCE_* 0x62, 0x63, 0x65, 0x6c, 0x6d, 0x6f): type 1,
  dir = the way Pearl's tile is left (..._SOUTH = pressing down -> 1, NORTH 2, EAST 3, WEST 4).
- Warps to rooms that are not installed keep their index (other zones' warps count by index) but move off the map
  (x = z = 0xFFF8), so they never fire.
- Shared rooms (data/sinnoh_world.json rooms "shared": one Pokémon Center 2F zone for all 17 Centers, notes/LINK.md):
  a warp to any of them goes to the installed one (same layout, same warp index); the installed room's own warps back
  down get destination warp 0x100 (Black 2's "next zone" spot, IsWarpDestId256), which patches/pearl_centers.py sets
  to the 1F the player came up from.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders, pearl_chunk  # noqa: E402
from zones import build_entities  # noqa: E402

PEARL = os.path.join(ROOT, 'work', 'pearl')
EMPTY = struct.pack('<I', 4) + bytes(4) + bytes(4)     # Black 2's empty entity file (a/1/2/6 entry 3)
DIRS = [(0, 1, 2), (0, -1, 1), (-1, 0, 3), (1, 0, 4)]  # (dx, dz, dir to walk in from that neighbour): S, N, W, E
# walkable Pearl warp tiles: the direction they are left in (Black 2 dir code)
LEAVE = {0x65: 1, 0x6f: 1, 0x64: 2, 0x6e: 2, 0x62: 3, 0x6c: 3, 0x63: 4, 0x6d: 4, 0x5e: 3, 0x5f: 4}
OFF_MAP = 0xFFF8
DEST_NEXT_ZONE = 0x100              # a warp to the game's saved "next zone" spot (ov035 EventMapChangeWarp_CreateFromEntity)
INERT = 0xFFFF                      # dest warp of a warp that never fires (ov012 IsWarpZoneOrWarpID0xFFFF)
# Pearl's dynamic warp (dest header 0xFFF, warp 0x100): the six elevator rooms' exits go back to the floor in Pearl's
# saved special location (pokeplatinum SetSpecialLocation). Black 2's own: destination warp 0x100 = its saved "next
# zone" spot (ov035 EventMapChangeWarp_CreateFromEntity), which Black 2 sets to the warp the player came in by
# (ov035 ZONE_SPAWN_CHANGE_TYPE_3: GetOutboundWarpRememberSpawnInfo) and pearl_story's SetSpecialLocation
# (FieldSetNextZone) to the floor the elevator stops at (2026-10-25, chapter 4b: these warps were dropped as "to a room
# not installed", so a player walking into any elevator landed off the room at (0, 0))
PEARL_DYNAMIC_WARP = 0xFFF
# Pearl's warp tile behaviours (pokeplatinum map_tile_behaviors.h: stairs 0x5E/0x5F, entrances 0x62-0x65, panel 0x67,
# door 0x69, escalators 0x6A/0x6B, mats 0x6C-0x6F): a warp anywhere else is only an arrival point in Pearl
PEARL_WARP_TILES = {0x5e, 0x5f, 0x62, 0x63, 0x64, 0x65, 0x67, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f}
# Stairs layout (the lead, 2026-10-20): the warp on the flight tile beyond Pearl's stairs tile, which stays walkable
# (the converter no longer makes pearl_chunk.STAIRS solid; the slope plane is on the flight). PEARL_STAIRS_ON_FLIGHT=0:
# the earlier layout (5ce7ab3: the warp on Pearl's stairs tile, made solid), for comparisons only
STAIRS_ON_FLIGHT = os.environ.get('PEARL_STAIRS_ON_FLIGHT', '1') == '1'
PEARL_STAIRS = {0x5e, 0x5f}                     # WARP_STAIRS_EAST / WEST (the foot of the stairs)
# Pearl's warp panel 0x67 (TILE_BEHAVIOR_WARP_PANEL: the Galactic HQ's 25, the Union Room's 1) warps the player as they
# step onto it (pokeplatinum field_control.c: TileBehavior_IsWarpPanel -> FieldSystem_StartMapChangeWarpTask) = Black
# 2's warp-panel warp, type 5 dir 0, as its Plasma Frigate's panels (ov036 fieldmap_event.c IsStepOnWarp: types 0, 5,
# 6 fire on the tile whatever the direction; arriving on one does not fire it: HoennB2 notes/INTERIORS.md). Before
# (2026-10-26, chapter 7) they were type-1 mats, which fire only when the player on them pushes into a wall.
PEARL_WARP_PANEL = 0x67
BUMP_STAIRS = set() if STAIRS_ON_FLIGHT else set(PEARL_STAIRS)    # stairs tiles solid in the converted maps


# Pearl's warp timing (pokeplatinum overlay005/field_control.c, the same in Diamond/Pearl): Field_CheckTransition
# fires as the player STEPS ONTO the tile for WARP_ENTRANCE_NORTH 0x64, WARP_NORTH 0x6E (the ladders up: Oreburgh Mine,
# Mt. Coronet, Stark Mountain, ..., and the north mats), the escalators 0x6A / 0x6B (the Pokemon Centers' stairs, the
# Veilstone Department Store) and the warp panel 0x67; Field_CheckMapTransition fires when the player PUSHES against
# collision: the door in front (0x69), standing on WARP_ENTRANCE_E/W/S 0x62/0x63/0x65, WARP_E/W/S 0x6C/0x6D/0x6F or
# the stairs' foot 0x5E/0x5F pushing that way. Black 2's step-on warps are types 0, 5 and 6 (ov036 IsStepOnWarp);
# type 0 arrives as type 1 does (EventWarpSequence_CreateIn: a plain fade), so the step-on mats of the rooms are type 0
# (2026-10-26; before: type 1, which fired only when the player on the tile pushed north, a second step).
PEARL_STEP_ON = {0x64, 0x6e, 0x6a, 0x6b}


def warp_kind(beh, solid, overworld):
    """(type, dir or None = from the walkable neighbour, bump). Bump warps sit on tiles the converter made solid
    (pearl_chunk.STAIRS everywhere, pearl_chunk.ENTRANCES on the overworld)."""
    if solid: return (3 if beh == 0x69 else 4), None, True
    if beh in PEARL_STAIRS: return 2, LEAVE[beh], True
    if overworld and beh in pearl_chunk.ENTRANCES: return 4, LEAVE.get(beh), True
    if beh == PEARL_WARP_PANEL: return 5, 0, False
    if beh in PEARL_STEP_ON: return 0, LEAVE.get(beh), False
    return 1, LEAVE.get(beh), False


class Planner:
    """Black 2's warp records of every installed Sinnoh zone, from Pearl's events (no ROM needed: apply() writes them,
    b2tools/warp_check.py and scene_check.py read the same records offline)."""

    def __init__(self):
        self.world = world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
        self.zones = json.load(open(os.path.join(PEARL, 'zones.json')))
        self.b2_of = {int(k): v['b2_zone'] for k, v in world['zones'].items()}
        self.b2_of.update({int(k): v['b2_zone'] for k, v in world['rooms']['zones'].items()})
        self.shared = {int(a): int(k) for k, aliases in world['rooms'].get('shared', {}).items() for a in aliases}
        self.shared_rooms = {int(k) for k in world['rooms'].get('shared', {})}
        self.heights = {}
        self.stairs_fallback = []                    # stairs whose approach side is closed (reported)
        for name in ('heights_overworld.json', 'heights_rooms.json'):
            for c, hs in json.load(open(os.path.join(ROOT, 'work', 'world', name))).items():
                self.heights[int(c)] = {tuple(map(int, k.split(','))): y for k, y in hs.items()}
        self.lands, self.mats = {}, {}
        self._arrivals = {}

    def land(self, c):
        if c not in self.lands: self.lands[c] = json.load(open(os.path.join(PEARL, 'land', f'{c:03d}.json')))
        return self.lands[c]

    def matrix(self, mid):
        if mid not in self.mats: self.mats[mid] = json.load(open(os.path.join(PEARL, 'matrices', f'{mid:03d}.json')))
        return self.mats[mid]

    def tile(self, m, x, z):
        """(behaviour, solid, height) of global tile (x, z) of matrix m, or None outside it."""
        cx, cz = x // 32, z // 32
        if not (0 <= cx < m['width'] and 0 <= cz < m['height']) or m['maps'][cz][cx] == 0xffff: return None
        c = m['maps'][cz][cx]
        L = self.land(c)
        solid = L['collision'][z % 32][x % 32] or int((x % 32, z % 32) in pearl_chunk.bed_solid(c))   # (beds)
        return L['behaviour'][z % 32][x % 32], solid, self.heights.get(c, {}).get((x % 32, z % 32))

    def entrance_arrivals(self, pid):
        """{Pearl warp index: Black 2 warp index of its arrival point} of an overworld zone's entrance mats. Pearl
        fires those mats as the player steps onto them and puts an arriving player ON the mat; Black 2's bump warp
        (warp_kind) steps an arriving player one tile out, onto Pearl's next tile, where a step trigger does not fire
        (2026-10-25: Hearthome's west gate lands on Barry's trigger column x 455; Pearl's player lands on the mat
        (454, 726) and fires it with the first step). So each such mat also gets an arrival point on its own tile,
        appended after Pearl's warps (no index moves): a type-1 warp with dest 0xFFFF, which never fires
        (ov012 GetWarpIDByPlayerPos: IsWarpZoneOrWarpID0xFFFF) and keeps the arriving player on the mat (type 1: no
        step out; facing away from the way in, as Black 2 does on its exit mats); every warp into the mat arrives
        there. Standing on the solid mat, the next step leaves it (as Lake Verity's script Warp onto its mat)."""
        if pid not in self._arrivals:
            out = {}
            z = self.zones[pid]
            if z['matrix'] == 0 and pid in self.b2_of:
                m = self.matrix(0)
                ev = json.load(open(os.path.join(PEARL, 'events', f"{z['events']:03d}.json")))
                n = len(ev['warp_events'])
                for i, w in enumerate(ev['warp_events']):
                    dest = self.b2_of.get(self.shared.get(w['dest_header_id'], w['dest_header_id']))
                    t = self.tile(m, w['x'], w['z'])
                    if dest is None or t is None:
                        continue
                    beh, solid, _ = t
                    if not solid and beh in pearl_chunk.ENTRANCES and beh not in PEARL_STAIRS:
                        out[i] = n + len(out)
            self._arrivals[pid] = out
        return self._arrivals[pid]

    def warps(self, pid):
        """(Black 2 warp records of Pearl zone pid, number dropped (rooms not installed, off the map))."""
        zones, tile, b2_of = self.zones, self.tile, self.b2_of
        b2 = b2_of[pid]
        m = self.matrix(zones[pid]['matrix'])
        ev = json.load(open(os.path.join(PEARL, 'events', f"{zones[pid]['events']:03d}.json")))
        warps, dropped = [], 0
        for w in ev['warp_events']:
            dest = b2_of.get(self.shared.get(w['dest_header_id'], w['dest_header_id']))
            dest_warp = w['dest_warp_id']
            if w['dest_header_id'] == PEARL_DYNAMIC_WARP and dest_warp == DEST_NEXT_ZONE:
                dest = b2                                     # (Black 2 reads the spot, not this zone)
            dpid = self.shared.get(w['dest_header_id'], w['dest_header_id'])
            if dest is not None and dpid < len(zones):
                dest_warp = self.entrance_arrivals(dpid).get(dest_warp, dest_warp)   # onto the mat, as Pearl
            if pid in self.shared_rooms and dest is not None and zones[w['dest_header_id']]['name'].endswith('_1F'):
                dest_warp = DEST_NEXT_ZONE                    # back down to the 1F the player came from
            t = tile(m, w['x'], w['z'])
            if dest is None or t is None:
                warps.append(dict(dest_zone=b2, dest_warp=0, dir=0, type=1, rail=0, x=OFF_MAP, y=0, z=OFF_MAP,
                                  w=1, h=1, unk=0)); dropped += 1
                continue
            beh, solid, y = t
            wtype, wdir, bump = warp_kind(beh, solid, zones[pid]['matrix'] == 0)
            facing, ny = 0, None
            for dx, dz, f in DIRS:
                n = tile(m, w['x'] + dx, w['z'] + dz)
                if n and not n[1]:
                    facing, ny = f, n[2]; break
            if y is None or bump: y = ny if ny is not None else (y or 0)     # bump: the walker's height
            wx = w['x']
            if wtype == 2 and STAIRS_ON_FLIGHT:              # the warp on the flight beyond Pearl's stairs tile
                # Pearl's 0x5E / 0x5F tile is the stairs' FOOT; the flight is the next tile (0x5E: east, 0x5F: west),
                # solid in all 168 installed stairs. Pearl puts an arriving player on the flight and walks them off
                # onto the foot (pokeplatinum unk_02056B30.c sub_02057368, sub_02057218): its scenes are made for the
                # player standing on the foot. Black 2 (HoennB2's stairs): a type-2 warp on the flight's first tile,
                # entered walking toward it; the arrival step lands on the foot = Pearl's tile (2026-10-20).
                wx = w['x'] + (1 if beh == 0x5e else -1)
                y = t[2] if t[2] is not None else y
            elif wtype == 2:                                 # stairs: ONE warp on Pearl's tile, entered the way Pearl's
                # stairs face (STAIRS_EAST: walking east, from the west tile; WEST: walking west). Several warps on one
                # tile fire only the first (HoennB2 lesson 2): the old one-per-open-side list fired "walking up" first,
                # so the stairs worked like a door and the player arrived standing on them (user 2026-10-19).
                ax, az = next((dx, dz) for dx, dz, f in DIRS if f == wdir)
                n = tile(m, w['x'] + ax, w['z'] + az)
                if n and not n[1]:
                    y = n[2] if n[2] is not None else y
                else:                                        # its approach side is closed: the first open side
                    sides = [(f, nn) for dx, dz, f in DIRS
                             for nn in [tile(m, w['x'] + dx, w['z'] + dz)] if nn and not nn[1]]
                    if sides: wdir, y = sides[0][0], (sides[0][1][2] if sides[0][1][2] is not None else y)
                    self.stairs_fallback.append((zones[pid]['name'], w['x'], w['z']))
            if wtype == 1 and beh not in PEARL_WARP_TILES:
                # a warp on a plain floor tile (an arrival point: the League rooms' entrances, Galactic HQ): Pearl
                # never fires it, Black 2 fires a type-1 warp whenever the player on it bumps into anything; dest warp
                # 0xFFFF keeps it an arrival point that never fires (ov012 GetWarpIDByPlayerPos, 2026-10-20)
                dest_warp = INERT
            warps.append(dict(dest_zone=dest, dest_warp=dest_warp, dir=facing if wdir is None else wdir, type=wtype, rail=0,
                              x=wx * 16 + 8, y=y & 0xFFFF, z=w['z'] * 16 + 8, w=1, h=1, unk=0))   # y: 16-bit, negative in caves
        for i, j in sorted(self.entrance_arrivals(pid).items(), key=lambda kv: kv[1]):
            assert len(warps) == j, (zones[pid]['name'], i, j, len(warps))
            warps.append(dict(warps[i], type=1, dest_zone=b2, dest_warp=INERT))   # the mat's arrival point
        import turnback                              # Turnback Cave's maze: a copy of each door per destination, after
        warps += turnback.extra_warps(pid, warps)    # all of the above (b2tools/turnback.py; none elsewhere)
        return warps, dropped


def apply(files):
    pl = Planner()
    ents = narcio.load(files, 126)
    headers, entries = zoneheaders.load(files)
    count = dropped = 0
    for pid, b2 in sorted(pl.b2_of.items()):
        warps, d = pl.warps(pid)
        count += len(warps) - d; dropped += d
        e = {'signs': [], 'npcs': [], 'warps': warps, 'triggers': []}
        headers[b2]['entities'] = len(ents)
        ents.append(build_entities(e, EMPTY))
    narcio.save(files, 126, ents)
    zoneheaders.save(files, headers, entries)
    return (f'sinnoh_events: {len(pl.b2_of)} zones, {count} warps ({dropped} to rooms not installed, off the map); '
            f'stairs entered from another side (approach closed): {pl.stairs_fallback}')
