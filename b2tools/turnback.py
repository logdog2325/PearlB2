"""Turnback Cave's maze as Pearl has it (Pearl's InitTurnbackCave, script command 0x285: pokediamond ScrCmd_Unk0285,
pokeplatinum ScrCmd_InitTurnbackCave), with Black 2's warps and map scripts, no C.

    python3 b2tools/turnback.py            print the zones, the rooms each holds and the doors' warp table (a check)

Pearl's rule. Every room of the maze (the entrance, the pillar room, the 18 random rooms) has four doors, Pearl's warps
0-3 (north (11, 1), east (20, 11), south (11, 20), west (2, 11)), each leading to the entrance's opposite door. Arriving
in a room (ON_TRANSITION), Pearl counts the room (VAR_TURNBACK_CAVE_ROOMS_VISITED; the pillar room also
VAR_TURNBACK_CAVE_PILLARS_SEEN; the entrance resets both) and InitTurnbackCave points the three doors the player did not
come in by (the one under the player: Pearl's tile rule below) at ONE room: 3 pillars seen -> Giratina's room; else 30
rooms visited -> the entrance; else 25 % the pillar room; else Pearl's room table [rand % 6 + 6 x pillars seen] (6 rooms
per pillar count, ROOMS). The door the player came in by keeps the event file's way: back to the entrance. Giratina's
room has no InitTurnbackCave: its four doors go back to the entrance. Continuing a saved game runs no ON_TRANSITION in
Pearl, so every door then leads to the entrance.

Black 2 (no command changes a warp's destination; ObjInitWarpGPos moves one, at any level, but only to heights of 16
units, and Black 2 fires a warp within 2 units of the height on its record):
- Zones (allocate_sinnoh APPENDED, the lead 2026-10-26: 623-632, 663-664): the pillar room 623, Giratina's room 624,
  and one zone per layout (Pearl matrices 64-66) and wild tier (Pearl's encounter tables by pillars seen: Lv 45, 55,
  65, the same species) of the random rooms, each holding Pearl's two rooms of that layout and tier (ZONES: the first
  room's map, people and scripts; the second room is the same map with its own Rock Smash rocks). Rooms 17 and 14 have
  zones of their own (Room 14 has no wild Pokémon in Pearl). The entrance is zone 382 (chapter 9a's).
- Doors: each maze zone's event file has Pearl's four doors (to the entrance, as Pearl's file) and after Pearl's warps
  one copy of each door per other destination (CANDIDATES: the pillar room, Giratina's room, the 10 random-room zones),
  on the same tiles at the same heights (sinnoh_events.Planner.warps -> extra_warps). Black 2 fires only the first
  warp of a tile, so a door leads to a destination when every warp of its tile before that one is parked off the map
  (ObjInitWarpGPos to tile 4095: x = z = 0xFFF8, as sinnoh_events parks warps to rooms not installed); parking needs no
  height. Continuing a saved game reloads the event file: every door leads to the entrance, as in Pearl.
- InitTurnbackCave runs in Pearl's ON_TRANSITION = Black 2's zone init (level 2), where Black 2 refuses PlayerGetGPos.
  So the zone init does only what must happen before the people appear (the room's rocks, init_lines) and the doors
  are set by an extra map script of Black 2's type 4 (run once after each map change, when the field is made, level 1:
  pearl_events.map_script_table; doors_code): the player's tile -> the door they came in by, Pearl's draw, the parking.
  Black 2 runs no type-4 script after battles, menus or Continue (type 3 then), so the doors keep what was set.
- Which of the zone's two Pearl rooms the player is in: Pearl draws the room in the room before; here the room before
  draws the zone (the layout and tier: 2 of Pearl's 6 rooms each, or 1) and the zone init draws one of its two rooms,
  1 in 2: each room is still 1 in 6, as Pearl. The second room's rocks: the zone's rock people (the first room's, Pearl
  order) moved to the second room's tiles by ObjInitNPCGPos in the zone init (level 2, before they appear); a rock the
  second room lacks is hidden by its own map-local flag. The rocks' flags are map-local (cleared on every zone change),
  as Pearl's FLAG_MAP_LOCAL_HIDE_OBSTACLE_*.
- The doors' heights are Pearl's door records' (sinnoh_events, from the converted floors: pearl_chunk.floor_mats gives
  each mat its own floor's height since the warp-height fix e7822d6); every copy has its door's height.
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)

ENTRANCE, PILLAR, GIRATINA = 268, 269, 270                  # Pearl map ids
# Pearl's room table (pokediamond UNK_020F3538, pokeplatinum ScrCmd_InitTurnbackCave pillarRooms): rand % 6 + 6 x
# pillars seen. Pearl names: Random Rooms 3, 6, 5, 4, 2, 1 | 12, 9, 10, 11, 7, 8 | 18, 15, 16, 13, 17, 14.
ROOMS = [271, 272, 273, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532]
# Black 2 zone -> (the Pearl room installed on it, the second Pearl room it also holds or None): one zone per layout
# (Pearl matrix) and wild tier; the installed room is the one with more rocks (equal: the first in ROOMS). Must agree
# with allocate_sinnoh APPENDED.
ZONES = {625: (271, 272),    # matrix 64, tier 1 (Lv 45): Random Rooms 3, 6
         626: (273, 518),    # matrix 65, tier 1: Rooms 5, 4
         627: (519, 520),    # matrix 66, tier 1: Rooms 2, 1
         628: (521, 522),    # matrix 64, tier 2 (Lv 55): Rooms 12, 9
         629: (523, 524),    # matrix 65, tier 2: Rooms 10, 11
         630: (525, 526),    # matrix 66, tier 2: Rooms 7, 8
         631: (527, 528),    # matrix 64, tier 3 (Lv 65): Rooms 18, 15
         632: (529, 530),    # matrix 65, tier 3: Rooms 16, 13
         663: (531, None),   # matrix 66, tier 3: Room 17
         664: (532, None)}   # matrix 66: Room 14 (no wild Pokémon in Pearl)
PILLAR_ZONE, GIRATINA_ZONE, ENTRANCE_ZONE = 623, 624, 382
# The doors' destinations after Pearl's own (slot 0: the event file's warp, back to the entrance), in this order
CANDIDATES = [PILLAR_ZONE, GIRATINA_ZONE] + sorted(ZONES)
DOORS = [(11, 1), (20, 11), (11, 20), (2, 11)]              # Pearl's warps 0-3: north, east, south, west
ARRIVE_WARP = [2, 3, 0, 1]                                  # each door's destination warp (the opposite door)
PARK = 4095                                                 # tile of a parked warp: 4095 * 16 + 8 = 0xFFF8, off the map
# script-local works of the doors' map script (ov012 ScriptWork 0x8000-0x8061, cleared when a script starts;
# pearl_story's library uses 0x8020-0x805C)
W_X, W_Z, W_IN, W_DEST, W_RAND = 0x805D, 0x805E, 0x805F, 0x8060, 0x8061
PL_TMP = 'PL_TMP'
VAR_PILLARS, VAR_ROOMS = 'PVAR_410B', 'PVAR_410C'           # Pearl's 0x410B / 0x410C (pearl.h)
LT, EQ, LE, GE = 0, 1, 3, 4                                 # VMJumpIf conditions (Pearl's: pearl_story.inc)


def zone_of_room(pid):
    """Black 2 zone of a Pearl random room."""
    return next(z for z, rooms in ZONES.items() if pid in rooms)


def maze_rooms():
    """Pearl maps whose zone runs InitTurnbackCave (doors_code): the entrance, the pillar room, the installed random
    rooms (ZONES)."""
    return [ENTRANCE, PILLAR] + [r for r, _ in ZONES.values()]


def check_world(world=None):
    """allocate_sinnoh's zones agree with ZONES (data/sinnoh_world.json)."""
    world = world or json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    b2 = {int(k): v['b2_zone'] for k, v in world['zones'].items()}
    b2.update({int(k): v['b2_zone'] for k, v in world['rooms']['zones'].items()})
    want = {ENTRANCE: ENTRANCE_ZONE, PILLAR: PILLAR_ZONE, GIRATINA: GIRATINA_ZONE}
    want.update({r: z for z, (r, _) in ZONES.items()})
    bad = {p: (b2.get(p), z) for p, z in want.items() if b2.get(p) != z}
    assert not bad, f'turnback: Pearl map -> (sinnoh_world zone, ZONES zone) differ: {bad}'
    hosted = {r for rr in ZONES.values() for r in rr if r}
    assert hosted == set(ROOMS), sorted(set(ROOMS) ^ hosted)
    return b2


# ------------------------------------------------------------------------------------------------- the warps

def extra_warps(pid, warps):
    """The door copies after Pearl's warps of a maze zone (sinnoh_events.Planner.warps): for each destination of
    CANDIDATES, the four doors in Pearl's order, each Pearl's door record with that destination (the same tile,
    height, type and direction; the destination warp is Pearl's, the opposite door). [] for any other zone."""
    if pid not in maze_rooms():
        return []
    for d, (x, z) in enumerate(DOORS):
        w = warps[d]
        assert (w['x'], w['z']) == (x * 16 + 8, z * 16 + 8) and w['dest_warp'] == ARRIVE_WARP[d], \
            f'turnback: Pearl map {pid} warp {d} is not the {"NESW"[d]} door: {w}'
    return [dict(warps[d], dest_zone=zone) for zone in CANDIDATES for d in range(4)]


def candidate_index(pid, n_pearl, slot, door):
    """Warp index of a door's copy for CANDIDATES slot `slot` (1..), after the zone's n_pearl warps of Pearl's."""
    return n_pearl + (slot - 1) * 4 + door


def pearl_warp_count(pid):
    """Number of the zone's own warps (Pearl's event file; sinnoh_events keeps one record each, in order; the maze has
    no overworld entrance arrivals)."""
    pd = _pd()
    return len(pd.events(pd.zones[pid])['warp_events'])


_PD = None


def _pd():
    global _PD
    if _PD is None:
        import pearl_story
        _PD = pearl_story.PearlData()
    return _PD


# ------------------------------------------------------------------------------------------------- the scripts

def init_lines(tr, vals):
    """Pearl's InitTurnbackCave in the zone init (level 2): for a zone holding two of Pearl's rooms, which one the
    player is in (1 in 2) and, for the second, its rocks (the zone's rock people moved to its tiles; one it lacks
    hidden). The doors come after the arrival (doors_code)."""
    import pearl_story, pearl_events
    pid = tr.job.zone['id']
    assert [tr.var(v) for v in vals] == [VAR_PILLARS, VAR_ROOMS], f'turnback: InitTurnbackCave {vals} in map {pid}'
    out = [f'// InitTurnbackCave {tr.var(vals[0])}, {tr.var(vals[1])}: the doors are set after the arrival '
           f'(TurnbackDoors, Black 2 map script type 4: no PlayerGetGPos in a zone init; b2tools/turnback.py)']
    second = next((s for z, (r, s) in ZONES.items() if r == pid), None)
    if second is None:
        return out
    pd = tr.job.pd
    mine = [o for o in pearl_events.kept_objects(pd, tr.job.zone)]
    other = pd.events(pd.zones[second])['object_events']
    assert all(o['graphics_id'] == mine[0]['graphics_id'] for o in mine + other), 'turnback: not only rocks'
    assert len(other) <= len(mine), (pid, second)
    out += [f'Random {PL_TMP}, 2  // which of Pearl\'s two rooms: 0 {pd.zones[pid]["name"][4:]}, 1 '
            f'{pd.zones[second]["name"][4:]} (Pearl draws one of 6 in the room before; here the zone there, 1 in 2 here)',
            f'WorkCmpConst {PL_TMP}, 0', f'VMJumpIf {EQ}, .Ltb_rocks_done']
    for i, o in enumerate(mine):
        if i < len(other):
            q = other[i]
            y = pearl_story.grid_y(tr, q['x'], q['z'], q['y'])
            out.append(f'pl_SetObjectEventPos {i}, {q["x"]}, {q["z"]}, {q["initial_dir"]}, {y}  // rock {i} -> '
                       f'{pd.zones[second]["name"][4:]}\'s rock {q["id"]}')
        else:
            out.append(f'FlagSet {tr.flag(pearl_events.hide_flag(pd, o))}  // rock {i}: '
                       f'{pd.zones[second]["name"][4:]} has {len(other)} (a map-local flag)')
    out.append('.Ltb_rocks_done:')
    return out


def doors_code(pid):
    """The doors' map script (Black 2 type 4, level 1; label TurnbackDoors): Pearl's InitTurnbackCave after the
    arrival. Pearl reads the door the player came in by from the tile: x 11 -> z 1 north, z 20 south, else none;
    x 20 east; else west. Here the arrival tile with a margin (z <= 2 north, z >= 19 south, x >= 19 east, x <= 3 west,
    else none: the entrance's way in from Sendoff Spring (11, 16), a test start), so a step Black 2 adds on arrival
    changes nothing."""
    n = pearl_warp_count(pid)
    slot_of_zone = {z: k + 1 for k, z in enumerate(CANDIDATES)}
    o = ['', f'TurnbackDoors:                    // after each arrival (Black 2 map script type 4, level 1): Pearl\'s '
             f'InitTurnbackCave (b2tools/turnback.py)',
         f'    PlayerGetGPos {W_X:#x}, {W_Z:#x}',
         f'    WorkSetConst {W_IN:#x}, 5  // the door the player came in by: 0 N, 1 E, 2 S, 3 W (Pearl\'s warps), 5 none',
         f'    WorkCmpConst {W_Z:#x}, 2', f'    VMJumpIf {LE}, .Ltb_in_n',
         f'    WorkCmpConst {W_Z:#x}, 19', f'    VMJumpIf {GE}, .Ltb_in_s',
         f'    WorkCmpConst {W_X:#x}, 19', f'    VMJumpIf {GE}, .Ltb_in_e',
         f'    WorkCmpConst {W_X:#x}, 3', f'    VMJumpIf {LE}, .Ltb_in_w',
         '    VMJump .Ltb_dest']
    for d, c in enumerate('nesw'):
        o += [f'.Ltb_in_{c}:', f'    WorkSetConst {W_IN:#x}, {d}', '    VMJump .Ltb_dest']
    o += ['.Ltb_dest:                         // Pearl\'s draw: the slot of CANDIDATES (0 = the doors as the file has '
          'them: the entrance)',
          f'    WorkSetConst {W_DEST:#x}, {slot_of_zone[GIRATINA_ZONE]}  // 3 pillars seen: Giratina\'s room',
          f'    WorkCmpConst {VAR_PILLARS}, 3', f'    VMJumpIf {GE}, .Ltb_go',
          f'    WorkSetConst {W_DEST:#x}, 0  // 30 rooms visited: the entrance',
          f'    WorkCmpConst {VAR_ROOMS}, 30', f'    VMJumpIf {GE}, .Ltb_go',
          f'    WorkSetConst {W_DEST:#x}, {slot_of_zone[PILLAR_ZONE]}  // 25 %: the pillar room',
          f'    Random {W_RAND:#x}, 100', f'    WorkCmpConst {W_RAND:#x}, 25', f'    VMJumpIf {LT}, .Ltb_go',
          f'    Random {W_RAND:#x}, 6  // else Pearl\'s room table [rand % 6 + 6 x pillars seen]',
          f'    WorkSet {PL_TMP}, {VAR_PILLARS}', f'    WorkMul {PL_TMP}, 6', f'    WorkAdd {W_RAND:#x}, {PL_TMP}']
    pd = _pd()
    for i, r in enumerate(ROOMS):
        z = zone_of_room(r)
        o += [f'    WorkSetConst {W_DEST:#x}, {slot_of_zone[z]}  // {i}: {pd.zones[r]["name"][4:]}, zone {z}',
              f'    WorkCmpConst {W_RAND:#x}, {i}', f'    VMJumpIf {EQ}, .Ltb_go']
    o += [f'    WorkSetConst {W_DEST:#x}, 0  // (past Pearl\'s table: the entrance)',
          '.Ltb_go:                           // each door but the way in: park the warps before the chosen one']
    for d, c in enumerate('nesw'):
        o += [f'    WorkCmpConst {W_IN:#x}, {d}', f'    VMJumpIf {EQ}, .Ltb_done_{c}',
              f'    WorkCmpConst {W_DEST:#x}, 0', f'    VMJumpIf {EQ}, .Ltb_done_{c}',
              f'    ObjInitWarpGPos {d}, {PARK}, 0, {PARK}  // the {"NESW"[d]} door\'s own warp (to the entrance)']
        for s in range(1, len(CANDIDATES)):
            o += [f'    WorkCmpConst {W_DEST:#x}, {s}', f'    VMJumpIf {LE}, .Ltb_done_{c}',
                  f'    ObjInitWarpGPos {candidate_index(pid, n, s, d)}, {PARK}, 0, {PARK}  // its copy to zone '
                  f'{CANDIDATES[s - 1]}']
        o.append(f'.Ltb_done_{c}:')
    o.append('    VMHalt')
    return o


if __name__ == '__main__':
    from patches import sinnoh_events
    b2 = check_world()
    pl = sinnoh_events.Planner()
    pd = _pd()
    for pid in [ENTRANCE, PILLAR, GIRATINA] + [r for r, _ in ZONES.values()]:
        ws, _ = pl.warps(pid)
        n = pearl_warp_count(pid)
        extra = ws[n:]
        rooms = next((rr for z, rr in ZONES.items() if rr[0] == pid), (pid,))
        print(f'zone {b2[pid]}: {", ".join(pd.zones[r]["name"][4:] for r in rooms if r)}; {n} Pearl warps + '
              f'{len(extra)} door copies; doors y {[w["y"] for w in ws[:4]]}')
