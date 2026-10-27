"""Sinnoh's Pokémon Centers: ONE shared 2F for all 17 (the trading floor) and the way back down to the right town
(user 2026-10-18: trading must work with the Hoenn games; notes/LINK.md "The shared 2F"). Runs after sinnoh_events
and sinnoh_story (it adds to the entity files they write), with `scripts` (src/field_scripts/1231_global_2100.s).

- data/sinnoh_world.json rooms "shared": Pearl's Jubilife Center 2F is installed (Black 2 zone 567); every 1F's stairs
  lead there (sinnoh_events), and its stairs down are a warp to destination 0x100: Black 2's saved "next zone" spot.
- Each Center 1F gets two map scripts (Black 2 types 3 "new load" and 4 "reload", which run every entry of their
  type: ov012 FieldScript_CallZoneInitCore) that run global 2111 (1231_global_2100.s Script_12): PVAR_PC_TOWN = this
  zone (RTGetZoneID).
- The shared 2F gets its own script file (a/0/5/6 SCRIPT_FILE: the number pearl_story gives Pearl's Jubilife 2F
  script file, which is never translated) with:
  - Script 1-3: Pearl's three counter attendants (OBJ_CODE_79, Black 2's Union Room receptionist, at Pearl's spots):
    Colosseum (left) and Union Room (middle) -> Black 2's Union Room counter (global 2101: trades and battles over
    local wireless), Wi-Fi Club (right) -> Black 2's Wi-Fi Club counter (global 10100), each after flag 106 (Black 2:
    "the Center's link counters are open", set as HoennB2's attendants do; Black 2 sets it with the C-Gear, which
    Sinnoh does not have). The counters talk with Black 2's own words.
  - Script 4, map script types 3 and 4 (every time the 2F loads, also back from the Union Room, whose own warp
    overwrites the spot): FieldSetNextZone PVAR_PC_TOWN, down, (2, 0, 10) = the 1F's stairs (all 17 Pearl 1F rooms
    share one layout, matrix 116). If PVAR_PC_TOWN was never set (a save from before this patch): Jubilife's 1F.
"""
import json, os, struct, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio, zoneheaders  # noqa: E402
from zones import parse_entities, build_entities  # noqa: E402
import scripts  # noqa: E402

GLOBAL_PC_TOWN = 2111
UNION_ROOM, WIFI_CLUB, FLAG_LINK_OPEN = 2101, 10100, 106
STAIRS_1F = (2, 0, 10)                 # Pearl Center 1F (matrix 116): the stairs up, where the way down arrives
WARP_DIR_DOWN = 2                      # pokebw2 include/field/zone.h
ATTENDANT_MODEL = 79                   # OBJ_CODE_79, Black 2's Union Room receptionist (data/pearl_sprite_map.json 27)
COUNTERS = {9011: UNION_ROOM, 9003: UNION_ROOM, 9001: WIFI_CLUB}   # Pearl 2F attendant script -> Black 2 counter
FALLBACK_1F = 'MAP_JUBLIFE_POKECENTER_1F'


def map_scripts(script_id):
    """A map-script table running script_id on new load (3) and reload (4) (FieldScript_GetInitSCRID layout)."""
    body = struct.pack('<HI', 3, script_id) + struct.pack('<HI', 4, script_id) + struct.pack('<H', 0)
    return body + bytes(-len(body) % 4)


def with_map_scripts(entity, script_id):
    """The entity file with script_id's load entries put before its own map scripts (both run)."""
    init_off = struct.unpack_from('<I', entity, 0)[0]
    tail = entity[init_off + 4:]
    ours = struct.pack('<HI', 3, script_id) + struct.pack('<HI', 4, script_id)
    if not tail or struct.unpack_from('<H', tail, 0)[0] == 0 and len(tail) <= 4:
        new = map_scripts(script_id)
    else:
        new = ours + tail                  # (a conditions entry's offset is relative to itself: unchanged)
    return entity[:init_off + 4] + new


def source(fallback):
    lines = ['// The shared Pokémon Center 2F (b2tools/patches/pearl_centers.py writes this file at build time)',
             '#include "asm/field_script.inc"', '#include "pearl.h"', '',
             '    ScriptEntry Counter_UnionLeft', '    ScriptEntry Counter_UnionRoom', '    ScriptEntry Counter_WiFi',
             '    ScriptEntry Load_NextZone', '    ScriptEntriesEnd', '']
    for label, glob in (('Counter_UnionLeft', UNION_ROOM), ('Counter_UnionRoom', UNION_ROOM), ('Counter_WiFi', WIFI_CLUB)):
        lines += [f'{label}:', f'    FlagSet {FLAG_LINK_OPEN}', f'    RTCallGlobal {glob}                // it talks and ends the events itself',
                  '    VMHalt', '']
    x, y, z = STAIRS_1F
    lines += ['Load_NextZone:',
              '    WorkCmpConst PVAR_PC_TOWN, 0', '    VMJumpIf 5, L_Set            // 5: not equal (as pearl_story.inc)',
              f'    WorkSetConst PVAR_PC_TOWN, {fallback}',
              'L_Set:',
              f'    FieldSetNextZone PVAR_PC_TOWN, {WARP_DIR_DOWN}, {x}, {y}, {z}',
              '    VMHalt', '']
    return '\n'.join(lines)


def script_file_number(pearl_zone):
    import pearl_story
    return pearl_story.PearlData().script_file(pearl_zone)


def apply(files):
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    rooms = world['rooms']
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    b2 = {int(k): v['b2_zone'] for k, v in rooms['zones'].items()}
    (shared_pid, aliases), = [(int(k), v) for k, v in rooms['shared'].items()]
    shared = b2[shared_pid]
    centers_1f = sorted(b2[i] for i, z in enumerate(zones) if z['name'].endswith('_POKECENTER_1F') and i in b2)
    headers, hentries = zoneheaders.load(files)
    ents = narcio.load(files, 126)
    # every 1F: remember the town
    for zone in centers_1f:
        e = headers[zone]['entities']
        ents[e] = with_map_scripts(ents[e], GLOBAL_PC_TOWN)
    # the shared 2F: attendants + the way down
    ev = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'events', f"{zones[shared_pid]['events']:03d}.json")))
    e = headers[shared]['entities']
    ent, _ = parse_entities(ents[e])
    order = ['Counter_UnionLeft', 'Counter_UnionRoom', 'Counter_WiFi']
    by_script = {9011: 1, 9003: 2, 9001: 3}
    ent['npcs'] = [dict(uid=o['id'], model=ATTENDANT_MODEL, move=0, evtype=0, flag=0, script=by_script[o['script']],
                        dir=o['initial_dir'], p0=0, p1=0, p2=0, areaw=0, areah=0, rail=0, x=o['x'], z=o['z'],
                        y=o['y'] << 16)
                   for o in ev['object_events'] if o['script'] in by_script]
    assert len(ent['npcs']) == 3, ent['npcs']
    ents[e] = build_entities(ent, ents[e], init=map_scripts(4))
    # its script file
    num = script_file_number(zones[shared_pid])
    fallback = b2[next(i for i, z in enumerate(zones) if z['name'] == FALLBACK_1F)]
    with tempfile.TemporaryDirectory() as t:
        path = os.path.join(t, f'{num}_shared_pokecenter_2f.s')
        open(path, 'w').write(source(fallback))
        code = scripts.assemble(path)
    sc = narcio.load(files, 56)
    while len(sc) <= num: sc.append(b'')
    assert not sc[num], f'a/0/5/6 {num} is already used'
    sc[num] = code
    narcio.save(files, 56, sc)
    headers[shared]['scripts'] = num
    narcio.save(files, 126, ents)
    zoneheaders.save(files, headers, hentries)
    return (f'pearl_centers: {len(centers_1f)} Center 1F rooms remember their zone (global {GLOBAL_PC_TOWN}); shared 2F '
            f'zone {shared} for {len(aliases) + 1} Centers: 3 counters (2101, 2101, 10100), script file {num}, '
            f'way down = next-zone spot')
