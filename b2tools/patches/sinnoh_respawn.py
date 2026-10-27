"""Where you wake up after a black-out, and where Teleport / Escape Rope's town is: Sinnoh's Pokémon Centers and the
player's house instead of Unova's. Runs after sinnoh_world and sinnoh_rooms (it reads data/sinnoh_world.json).

Found in game 2026-10-18: a black-out sent the player to zone 435 at (7, 12), inside Lake Acuity's trees. Black 2's
RESPAWN_ZONE_INFO (ov012 0x0216c33c, pokebw2 src/ov012/respawn_zone.c; 82 x 20 bytes {discovery flag, bit 0 "can
return here" / bit 1 "discover on visit", respawn zone, x, z, town zone, fly x, fly z, escape zone, x, z}) still
named Unova's zone numbers, which now hold Sinnoh maps. Black 2's new game sets entry 18 (Aspertia's; global 9600
FieldSetTeleportZone 18), an invalid index falls back to entry 1 (GetLeaguePokeCenReturnLocationIdx), and arriving in
a zone that is some entry's respawn zone with "can return here" makes that entry the respawn
(event_mapchange.c ~1419: so entering a Pokémon Center sets it).

What this patch writes (apply_code):
- Entries 1 and 18: the player's house 1F (Pearl's MAP_TWINLEAF_RIVAL_HOUSE_1F: pokediamond's names of 412-415 are
  swapped, notes/STORY.md), tile (8, 8), town Twinleaf: Pearl's own black-out spot before any Center
  (pokeplatinum src/spawn_locations.c sSpawnLocations, the same towns and spots in Diamond/Pearl).
- Entries 2-17 and 19: Sinnoh's 17 Pokémon Centers 1F, tile (8, 6) (in front of the nurse), town = the Center's town.
- Every other entry: "can return here" and "discover on visit" off, so no Sinnoh room that took a Unova zone number
  sets a Unova respawn. Fly and escape coordinates 0 = the town's zone-header fly point (as Black 2's own
  B2-only towns). Discovery flags are left as Black 2's (Fly's town list is later work: HMs after the main work).
- After a black-out at home, Black 2 runs script 2 of the home zone's file (ov012 EventBattleLose_Callback 0x0215a126
  `movs r1, #2`), which in the translated house is Pearl's script 2 (Mom's opening scene: found in game 2026-10-19).
  The immediate becomes pearl_story.BLACKOUT_ENTRY, the house file's entry that runs Pearl's own common script 2020
  (Mom: rest, the morning jingle, heal). A Pokémon Center keeps Black 2's 2001 (the nurse).
"""
import json, os, struct

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
OV012, TABLE, COUNT, SIZE = 0x021503C0, 0x0216C33C, 82, 20
HOME = ('MAP_TWINLEAF_RIVAL_HOUSE_1F', 'MAP_TWINLEAF', 8, 8)
CENTERS = ['SANDGEM', 'FLOAROMA', 'SOLACEON', 'CELESTIC', 'JUBLIFE', 'CANALAVE', 'OREBURGH', 'ETERNA', 'HEARTHOME',
           'PASTORIA', 'VEILSTONE', 'SUNYSHORE', 'SNOWPOINT', 'POKEMON_LEAGUE', 'FIGHT_AREA', 'SURVIVAL_AREA',
           'RESORT_AREA']                    # pokeplatinum sSpawnLocations order (Twinleaf first)
HOME_ENTRIES = (1, 18)
BLACKOUT_CALL = 0x0215A126                  # EventBattleLose_Callback: movs r1, #2 (the home zone's script 2)
import sys; sys.path.insert(0, os.path.dirname(HERE))
from pearl_story import BLACKOUT_ENTRY      # noqa: E402
CENTER_ENTRIES = list(range(2, 18)) + [19]


def zones():
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    out = {v['name']: v['b2_zone'] for v in world['zones'].values()}
    out.update({v['name']: v['b2_zone'] for v in world['rooms']['zones'].values()})
    return out


def entries():
    """[(entry 1-based, respawn zone, x, z, town zone)]"""
    z = zones()
    out = [(i, z[HOME[0]], HOME[2], HOME[3], z[HOME[1]]) for i in HOME_ENTRIES]
    for i, town in zip(CENTER_ENTRIES, CENTERS):
        out.append((i, z[f'MAP_{town}_POKECENTER_1F'], 8, 6, z[f'MAP_{town}']))
    return out


def apply_code(code):
    p = os.path.join(code, 'arm9_ov012.bin')
    d = bytearray(open(p, 'rb').read())
    base = TABLE - OV012
    vanilla = open(os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build', 'arm9_ov012.bin'), 'rb').read()
    assert d[base:base + COUNT * SIZE] == vanilla[base:base + COUNT * SIZE], 'RESPAWN_ZONE_INFO already changed'
    assert struct.unpack_from('<HHHBBH', d, base + 17 * SIZE)[2:] == (435, 7, 12, 427), 'entry 18 is not Aspertia'
    for i in range(COUNT):                          # every entry off first
        o = base + i * SIZE
        flags = struct.unpack_from('<H', d, o + 2)[0]
        struct.pack_into('<H', d, o + 2, flags & ~3)
    for i, zone, x, z, town in entries():
        o = base + (i - 1) * SIZE
        flag = struct.unpack_from('<H', d, o)[0]
        struct.pack_into('<HHHBBH5H', d, o, flag, 1, zone, x, z, town, 0, 0, town, 0, 0)
    o = BLACKOUT_CALL - OV012
    assert d[o:o + 2] in (b'\x02\x21', bytes([BLACKOUT_ENTRY, 0x21])), d[o:o + 2].hex()
    d[o:o + 2] = bytes([BLACKOUT_ENTRY, 0x21])
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)
    return (f'sinnoh_respawn: entries {HOME_ENTRIES} = Twinleaf home, {len(CENTERS)} Pokémon Centers, '
            f'{COUNT - len(HOME_ENTRIES) - len(CENTERS)} Unova entries off; black-out at home runs entry {BLACKOUT_ENTRY}')


if __name__ == '__main__':
    for e in entries(): print(e)
