"""TEST ONLY (never in a release build): a new game starts with a Pokémon, so wild battles can start in tests (a wild
battle with an empty party hangs: HoennB2 patches/test_cave_kit.py). Re-assembles the new-game script
(src/field_scripts/1289_twinleaf_newgame.s) with, in Script_31 (run after the warp into Twinleaf), a Lv TEST_LEVEL
Piplup and flag 2401 (the field menu's POKEMON entry, set by Black 2's starter script), plus TEST_ITEMS (comma-separated
item ids, one of each; e.g. TEST_ITEMS=445,446,447 for the three rods), and TEST_START=zone,x,z (Black 2 zone and
tile where the new game starts instead of Twinleaf's fly point). List it after `scripts`:

    PEARL_BUILD_DIR=... build_rom.py --clean antipiracy sinnoh_world scripts sinnoh_encounters test_wildmon
"""
import os, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402
import scripts  # noqa: E402  (patches/scripts.py: assemble())

SRC = os.path.join(scripts.SRC, '1289_twinleaf_newgame.s')
GIVE = """Script_31:
    // TEST ONLY (test_wildmon): a Pokémon for wild-battle tests
    PokePartyAdd 0x8001, SPECIES_PIPLUP, 0, {level}
    FlagSet 2401
"""


def apply(files):
    src = open(SRC).read()
    assert src.count('Script_31:\n') == 1, 'Script_31 not found once in the new-game script'
    level = int(os.environ.get('TEST_LEVEL', '10'))
    items = [int(i) for i in os.environ.get('TEST_ITEMS', '').split(',') if i.strip()]
    give = GIVE.format(level=level) + ''.join(f'    ItemAdd {i}, 1, 0x8010\n' for i in items)
    src = src.replace('Script_31:\n', give)
    start = os.environ.get('TEST_START')
    if start:
        zone, x, z = (int(v) for v in start.split(','))
        old = 'MapChangeCore ZONE_ASPERTIA_CITY, FLY_427_X, FLY_427_Y, FLY_427_Z, 1'
        assert src.count(old) == 1, 'the new-game map change not found once'
        src = src.replace(old, f'MapChangeCore {zone}, {x}, 0, {z}, 1')
    with tempfile.TemporaryDirectory() as t:
        path = os.path.join(t, '1289_test_wildmon.s')
        open(path, 'w').write(src)
        code = scripts.assemble(path)
    entries = narcio.load(files, 56)
    entries[1289] = code
    narcio.save(files, 56, entries)
    return (f'test_wildmon: new game gives a Lv {level} Piplup and items {items}, starts at '
            f'{start or "Twinleaf"} (script 1289, {len(code)} B)')
