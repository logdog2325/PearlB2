"""TEST ONLY (never in a release build): a Level 100 legendary team from the start of a new game, so story tests win
every battle (user 2026-10-19: "give yourself a team level 100 palkia dialga giratina arceus heatran and darkrai ...
and make it obey you", as HoennB2's HOENN_TEST_CHGROUDON Groudon). List it after sinnoh_story in a STORY build:

    build_rom.py --clean ... scripts pearl_text sinnoh_story ... test_team

Black 2's new game runs scripts 29-31 of zone 427's file, in a story build Twinleaf's
(src/field_scripts/1670_pearl_twinleaf.s with src/field_scripts/pearl/newgame.inc); this re-assembles that file with
the team added after Pearl's new-game flags (C377_1_S1): Palkia (the lead), Dialga, Giratina, Heatran and Darkrai in
the party and Arceus in the PC, so the story's own starter still joins at Lake Verity as the 6th. Pokémon a script
gives carry the player as their trainer, so Black 2 has them obey without badges (its disobedience is for Pokémon of
another trainer). Palkia's first move becomes Dark Pulse: the test driver always uses the first move, and Lv 100
Palkia's is Earth Power, which a Flying type ignores (the lake's Starly battle then never ended, 2026-10-19); no type
is immune to Dark, Fairy included. Nothing else changes: the story runs as in the release build.

A script or text change needs no full rebuild (HoennB2 lesson 28): `build_rom.py test_team` (no --clean) on the
existing PEARL_BUILD_DIR re-applies only this patch and repacks the ROM.
"""
import glob, os, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402
import scripts  # noqa: E402

TWINLEAF = 1670
PARTY = [(484, 'Palkia'), (483, 'Dialga'), (487, 'Giratina'), (485, 'Heatran'), (491, 'Darkrai')]
BOX = [(493, 'Arceus')]
LEVEL = 100
LEAD_MOVE = 399                 # Dark Pulse


def apply(files):
    src = open(glob.glob(os.path.join(scripts.SRC, f'{TWINLEAF}_pearl_*.s'))[0]).read()
    inc = open(os.path.join(scripts.SRC, 'pearl', 'newgame.inc')).read()
    give = ('    // TEST ONLY (patches/test_team.py)\n'
            + ''.join(f'    PokePartyAdd 0x8001, {s}, 0, {LEVEL}  // {n}\n' for s, n in PARTY)
            + f'    PokePartyLearnMove 0, 0, {LEAD_MOVE}  // the lead\'s first move: Dark Pulse\n'
            + ''.join(f'    BoxAdd 0x8001, {s}, 0, {LEVEL}  // {n}\n' for s, n in BOX))
    assert inc.count('    VMCall C377_1_S1\n') == 1
    inc = inc.replace('    VMCall C377_1_S1\n', '    VMCall C377_1_S1\n' + give)
    assert src.count('#include "pearl/newgame.inc"') == 1
    src = src.replace('#include "pearl/newgame.inc"', inc)
    with tempfile.TemporaryDirectory() as t:
        path = os.path.join(t, f'{TWINLEAF}_test_team.s')
        open(path, 'w').write(src)
        code = scripts.assemble(path)
    entries = narcio.load(files, 56)
    entries[TWINLEAF] = code
    narcio.save(files, 56, entries)
    return (f'test_team: new game gives Lv {LEVEL} {", ".join(n for _, n in PARTY)} (party) and '
            f'{", ".join(n for _, n in BOX)} (PC)')
