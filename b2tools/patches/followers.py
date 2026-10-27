"""The following Pokémon (user 2026-10-26: "make it a Rowan question to have them follow you all game"; plan:
work/agents/followers/FOLLOWERS_PLAN.md). List it after pearl_intro (the question) and pearl_amity_sprites (Pearl's
walkers): with YES to Rowan's fourth question (flag PFLAG_POKE_FOLLOWER), the first Pokémon of the party walks behind the
player, as in HeartGold/SoulSilver.

The code is the decomp's src/pearlb2/resident/follower.c (its three hooks: Field_InitActorSystem, CheckPerStepEvents and
the follow move code 0x30). This patch puts its config in ITCM and the config's address in gFollowerConfig (without
it: NULL, the game's behaviour, no follower):
- the flag, the talk script (global 10017: pearl_defog.py --sources writes it into global 10000 with Pearl's 9 Amity
  Square lines), whether rooms and caves have a follower (yes; the 64 x 64 sheets stay on the overworld), and the
  work that gets the following Pokémon's party slot (PVAR_FOLLOWER_SLOT, which the talk script reads);
- Pearl's own walkers by species (pearl_amity_sprites.POKEMON and their codes in data/pearl_sprite_map.json: the 11
  Amity Square species, Machop and Shaymin), shown for form 0; every other species uses Black 2's walking Pokémon
  (ARCID_TPOKE), read by the C;
- the zones with no follower: the Battle Tower block (616-622: notes/ZONE_TABLE.md) and the League's Hall of Fame
  (the Union Room, colosseums, Battle Subway and Entralink are Black 2's IsZoneNormal);
- the 64 x 64 walking sheets (billboard size 2 in a/0/4/7), shown outdoors only;
- the walking-Pokémon codes PearlB2 painted over (data/pearl_sprite_map.json: Giratina's Origin Forme is Pearl's wall
  painting), never shown.
Test builds (TEST_START set: patches/test_story_start.py) leave it out unless TEST_FOLLOW=1: the test drivers answer
YES to every Rowan question, and no other test should get a follower.
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, resident, sprites  # noqa: E402

DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
ROOMS = 1                                   # every zone but the off list (step 2; step 1 had the overworld only)
BATTLE_TOWER = range(616, 623)              # notes/ZONE_TABLE.md: the Battle Tower block
OFF_MAPS = ['MAP_POKEMON_LEAGUE_HALL_OF_FAME']
TPOKE = range(0x1000, 0x126C)               # Black 2's walking Pokémon codes (sprites.obj_record)


def pearl_flag(name):
    m = re.search(rf'^#define\s+{name}\s+(\d+)', open(os.path.join(ROOT, 'src', 'include', 'pearl.h')).read(), re.M)
    assert m, f'{name} missing from src/include/pearl.h (b2tools/pearl_ids.py)'
    return int(m.group(1))


def species_ids():
    out, n = {}, 0
    for line in open(os.path.join(DECOMP, 'generated', 'species.txt'), encoding='utf-8'):
        line = line.strip()
        if not line.startswith('SPECIES_'):
            continue
        name = line.split('=')[0].strip()
        if '=' in line:
            n = int(line.split('=')[1], 0)
        out.setdefault(name, n)
        n += 1
    return out


def pearl_var(name):
    m = re.search(rf'^#define\s+{name}\s+(0x[0-9A-Fa-f]+|\d+)', open(os.path.join(ROOT, 'src', 'include', 'pearl.h')).read(),
                  re.M)
    assert m, f'{name} missing from src/include/pearl.h (b2tools/pearl_ids.py)'
    return int(m.group(1), 0)


def config():
    """(fields, pearl pairs, off zones, huge codes, never codes)."""
    import pearl_amity_sprites
    smap = json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json'), encoding='utf-8'))
    species = species_ids()
    pearl = []
    for who, gfx, _, _ in pearl_amity_sprites.POKEMON:
        sid = species['SPECIES_' + who.upper()]
        code = smap[str(gfx)]['code']
        assert code < 377, f'{who}: code {code} is not a person code'
        pearl.append((sid, code))
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json'), encoding='utf-8'))
    by_name = {z['name']: z['b2_zone'] for z in world['rooms']['zones'].values()}
    off = list(BATTLE_TOWER) + [by_name[m] for m in OFF_MAPS]
    table = sprites.ow_table(os.path.join(DECOMP, 'extract', 'b2_us', 'files'))
    huge = [c for c in TPOKE if table[sprites.obj_record(c)]['billboardSize'] == 2]
    never = sorted({v['code'] for v in smap.values() if isinstance(v, dict) and v.get('code') in TPOKE
                    and 'repainted' in v.get('b2', '')})
    return pearl, off, huge, never


def blob(base, flag):
    import pearl_defog
    pearl, off, huge, never = config()
    head = struct.pack('<8H', flag, pearl_defog.FOLLOWER_SCRIPT, ROOMS, len(pearl), len(off), len(huge), len(never),
                       pearl_var('PVAR_FOLLOWER_SLOT'))
    data = b''.join(struct.pack('<HH', s, c) for s, c in pearl) + struct.pack(f'<{len(off) + len(huge) + len(never)}H',
                                                                            *off, *huge, *never)
    return head + data, (pearl, off, huge, never)


def apply_code(code):
    if os.environ.get('TEST_START') and os.environ.get('TEST_FOLLOW') != '1':
        return 'followers: test build without TEST_FOLLOW=1: no follower (gFollowerConfig stays NULL)'
    import decomp
    slot = decomp.symbol('gFollowerConfig', code)
    if slot is None:
        raise SystemExit('followers: the decomp has no gFollowerConfig (src/pearlb2/resident/follower.c)')
    flag = pearl_flag('PFLAG_POKE_FOLLOWER')
    made = {}

    def build(base):
        b, made['cfg'] = blob(base, flag)
        return b, {}

    base, end, _ = resident.install(code, build)  # its table in the resident section (b2tools/resident.py)
    # the pointer: in whichever binary holds the core (the resident section since 2026-10-26; ITCM before)
    assert resident.read(code, slot, 4) == bytes(4), f'gFollowerConfig at {slot:#x}: not NULL'
    resident.write(code, slot, struct.pack('<I', base))
    pearl, off, huge, never = made['cfg']
    return (f'followers: config {end - base} B at {base:#x} (gFollowerConfig {slot:#x}): flag {flag}, Pearl walkers {pearl}, no follower in zones {off}, '
            f'{len(huge)} 64x64 codes outdoors only, never {never}, rooms {"on" if ROOMS else "off (overworld only)"}')


if __name__ == '__main__':      # python3 followers.py: the config it would install
    print(config())
