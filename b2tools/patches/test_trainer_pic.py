"""TEST ONLY (never in a release build): one converted Pearl trainer picture in a real battle (notes/TRAINERS.md
"Pearl's trainer pictures"). A new game's first script (Script_31 of src/field_scripts/1289_twinleaf_newgame.s, run
after the warp into Twinleaf) gives a Lv TEST_LEVEL Piplup and flag 2401 (as test_wildmon) and starts a battle with
Black 2's Youngster Terrell (one Lv 4 Patrat). apply_code points Black 2's Youngster class (2) at the new front sprite
of TEST_TRAINER_PIC (a Pearl class name from work/world/trainer_pics.json, default PKMN_TRAINER_BARRY) through its
byte in arm9 TRAINER_CLASS_RESOURCES. After the battle: the battle end on a win, CallTrainerLose otherwise (until
2026-10-25 a stack compare ran CallTrainerLose after a win, as VMJumpIf CMP_STACK jumps when the compare is false:
the error screen after the battle; patches/test_partner_battle.py). Use it instead of test_wildmon (both rewrite
script 1289), after `scripts` and `pearl_trainer_pics`:

    PEARL_BUILD_DIR=... build_rom.py --clean antipiracy sinnoh_world scripts pearl_trainer_pics test_trainer_pic
"""
import os, struct, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402
import scripts  # noqa: E402  (patches/scripts.py: assemble())
import pearl_trainer_pics as P  # noqa: E402

SRC = os.path.join(scripts.SRC, '1289_twinleaf_newgame.s')
ARM9_BASE, CLASS_RESOURCES = 0x02004000, 0x02092394     # pokebw2 config/b2_us/arm9/symbols.txt
YOUNGSTER_CLASS, YOUNGSTER_SPRITE = 2, 2                # TRAINER_CLASS_YOUNGSTER, TRAINER_SPRITE_YOUNGSTER
HOOK = 'Script_31:\n    ActorsPauseAll\n    FadeInBlack\n    FadeWait\n'
BATTLE = """    // TEST ONLY (test_trainer_pic): a Pokémon, then a trainer battle (Youngster class -> a Pearl picture)
    PokePartyAdd 0x8001, SPECIES_PIPLUP, 0, {level}
    FlagSet 2401
    CallTrainerBattle TRAINER_YOUNGSTER_TERRELL, 0, 0
    TrainerBattleIsVictory 0x8010
    WorkCmpConst 0x8010, 1
    VMJumpIf CMP_NE, TestPic_Lost
    CallTrainerBattleEnd
    VMJump TestPic_Done

TestPic_Lost:
    CallTrainerLose
    VMHalt

TestPic_Done:
"""


def pic():
    name = os.environ.get('TEST_TRAINER_PIC', 'PKMN_TRAINER_BARRY')
    if name not in P.CLASSES:
        raise SystemExit(f'TEST_TRAINER_PIC={name}: not one of the 46 ({", ".join(P.CLASSES)})')
    return name, P.sprite_id(name)


def apply(files):
    src = open(SRC).read()
    assert src.count(HOOK) == 1, 'Script_31 start not found once in the new-game script'
    level = int(os.environ.get('TEST_LEVEL', '10'))
    with tempfile.TemporaryDirectory() as t:
        path = os.path.join(t, '1289_test_trainer_pic.s')
        open(path, 'w').write(src.replace(HOOK, HOOK + BATTLE.format(level=level)))
        code = scripts.assemble(path)
    entries = narcio.load(files, 56)
    entries[1289] = code
    narcio.save(files, 56, entries)
    return f'test_trainer_pic: new game gives a Lv {level} Piplup, then battles Youngster Terrell (script 1289)'


def apply_code(code):
    if os.environ.get('TEST_TRAINER_PIC') == 'NONE':      # control run: Black 2's own Youngster picture
        return 'test_trainer_pic: Youngster class keeps Black 2\'s sprite (control)'
    name, sprite = pic()
    path = os.path.join(code, 'arm9.bin')
    data = bytearray(open(path, 'rb').read())
    o = CLASS_RESOURCES - ARM9_BASE + 4 * YOUNGSTER_CLASS
    assert data[o] == YOUNGSTER_SPRITE, f'class {YOUNGSTER_CLASS} sprite byte is {data[o]}, not Black 2\'s'
    data[o] = sprite
    if os.path.islink(path):
        os.unlink(path)
    open(path, 'wb').write(data)
    return f'test_trainer_pic: Youngster class {YOUNGSTER_CLASS} shows front sprite {sprite} ({name})'
