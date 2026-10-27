"""TEST ONLY (never in a release build): in a STORY build (sinnoh_story), start a new game somewhere else with a
Pokémon. Black 2's new game runs scripts 29-31 of zone 427's file, which in a story build is Twinleaf's
(src/field_scripts/1670_pearl_twinleaf.s, including src/field_scripts/pearl/newgame.inc). This re-assembles that
file with: the start zone/tile from TEST_START=zone,x,z (a translated zone: its PearlArrive script fades in), a
Lv TEST_LEVEL (10) Piplup (TEST_TEAM=1: test_team's Lv 100 legendaries instead; TEST_PARTY=SPECIES_X[:level],...: that
party in order, EGG = an Egg), flag 2401 (the menu's POKEMON entry), and TEST_ITEMS (item ids). List it after
sinnoh_story:

    TEST_START=525,8,6 build_rom.py --clean ... scripts pearl_text sinnoh_story ... test_story_start

TEST_SET="PVAR_4077=2,PFLAG_008F" sets the earlier story's works and flags (names from src/include/pearl.h, or
numbers); TEST_LINES="pl_xxx ...;..." adds any other script lines (badges, items with counts).
"""
import glob, os, re, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders  # noqa: E402
import scripts  # noqa: E402

TWINLEAF = 1670


def arrive_index(path):
    entries = re.findall(r'^\s*ScriptEntry (\w+)', open(path).read(), re.M)
    return entries.index('PearlArrive') + 1


def apply(files):
    start = os.environ.get('TEST_START')
    if not start:
        return 'test_story_start: TEST_START not set, nothing changed'
    zone, x, z = (int(v) for v in start.split(','))
    headers, _ = zoneheaders.load(files)
    if headers[zone]['matrix'] == 0:      # overworld: the tile's matrix cell decides the zone the game loads, and only
        # that zone's arrival script fades the screen in (2026-10-20: zone 321 at (173, 799), a Jubilife tile -> black)
        import struct
        m = narcio.load(files, 9)[0]
        w, h = struct.unpack_from('<HH', m, 4)
        cell = struct.unpack_from('<I', m, 8 + 4 * w * h + 4 * ((z // 32) * w + x // 32))[0]
        if cell != zone:
            raise SystemExit(f'TEST_START: tile ({x}, {z}) is in zone {cell}, not {zone}: use TEST_START={cell},{x},{z}')
    num = headers[zone]['scripts']
    dest = glob.glob(os.path.join(scripts.SRC, f'{num:04d}_pearl_*.s'))
    assert dest, f'zone {zone} has script file {num}, not a translated Pearl zone'
    arrive = arrive_index(dest[0])
    src = open(glob.glob(os.path.join(scripts.SRC, f'{TWINLEAF}_pearl_*.s'))[0]).read()
    inc = open(os.path.join(scripts.SRC, 'pearl', 'newgame.inc')).read()
    level = int(os.environ.get('TEST_LEVEL', '10'))
    items = [int(i) for i in os.environ.get('TEST_ITEMS', '').split(',') if i.strip()]
    if os.environ.get('TEST_TEAM') == '1':        # test_team's Lv 100 legendaries instead of the Piplup
        import test_team
        team = (''.join(f'    PokePartyAdd 0x8001, {s}, 0, {test_team.LEVEL}\n' for s, _ in test_team.PARTY)
                + f'    PokePartyLearnMove 0, 0, {test_team.LEAD_MOVE}\n'
                + ''.join(f'    BoxAdd 0x8001, {s}, 0, {test_team.LEVEL}\n' for s, _ in test_team.BOX))
    elif os.environ.get('TEST_PARTY'):           # TEST_PARTY=SPECIES_A[:level],...,EGG: this party, in order
        team = ''.join(f'    PokePartyAddEgg 0x8001, 490, 0\n' if p.strip() == 'EGG' else
                       f'    PokePartyAdd 0x8001, {p.split(":")[0].strip()}, 0, '
                       f'{p.split(":")[1] if ":" in p else level}\n'
                       for p in os.environ['TEST_PARTY'].split(',') if p.strip())
    else:
        team = f'    PokePartyAdd 0x8001, SPECIES_PIPLUP, 0, {level}\n'
    # TEST_SET: the earlier story's end state, comma separated: NAME=value sets a work (PVAR_xxxx from pearl.h or a
    # number), a bare NAME sets a flag (PFLAG_xxxx or a number); TEST_LINES: any other script lines, ';' separated
    # (e.g. badges, items with counts), as in a chapter's test switch (HoennB2 HOENN_TEST_CH<n>)
    sets = ''
    for s in [s.strip() for s in os.environ.get('TEST_SET', '').split(',') if s.strip()]:
        sets += (f'    WorkSetConst {s.split("=")[0]}, {s.split("=")[1]}\n' if '=' in s else f'    FlagSet {s}\n')
    sets += ''.join(f'    {l.strip()}\n' for l in os.environ.get('TEST_LINES', '').split(';') if l.strip())
    give = (f'    // TEST ONLY (test_story_start)\n{team}    FlagSet 2401\n'
            + ''.join(f'    ItemAdd {i}, 1, 0x8010\n' for i in items) + sets)
    assert inc.count('    VMCall C377_1_S1\n') == 1
    inc = inc.replace('    VMCall C377_1_S1\n', '    VMCall C377_1_S1\n' + give)
    for name, value in (('ZONE', zone), ('X', x), ('Z', z), ('ARRIVE', arrive)):
        src, n = re.subn(rf'^#define PEARL_START_{name} .*$', f'#define PEARL_START_{name} {value}', src, flags=re.M)
        assert n == 1, name
    src = src.replace('#include "pearl/newgame.inc"', inc)
    with tempfile.TemporaryDirectory() as t:
        path = os.path.join(t, f'{TWINLEAF}_test_story_start.s')
        open(path, 'w').write(src)
        code = scripts.assemble(path)
    entries = narcio.load(files, 56)
    entries[TWINLEAF] = code
    narcio.save(files, 56, entries)
    return (f'test_story_start: new game starts in zone {zone} at ({x}, {z}) (arrive script {arrive}), '
            f'{"the Lv 100 test team" if os.environ.get("TEST_TEAM") == "1" else os.environ.get("TEST_PARTY") or f"Lv {level} Piplup"}, '
            f'items {items}')
