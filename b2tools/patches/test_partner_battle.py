"""TEST ONLY (never in a release build): a multi battle with a partner as soon as a test game arrives, to see the
partner's back in battle (patches/pearl_partner_backs.py). TEST_PARTNER_BATTLE=partner,opponent1,opponent2 (Black 2
trainer ids, data/pearl_story_ids.json; e.g. 616,282,285 = Cheryl with Bug Catcher Jack and Lass Briana) puts
Black 2's CallTrainerMultiBattle (partner first, as its Castelia Sewers and Lacunosa scenes) after the fade-in of the
TEST_START zone's PearlArrive script, which the new game reserves (as test_trainer_pic's battle in the new game's
Script_31), then the battle end on a win (TrainerBattleIsVictory gives 1 for a win: ov012 s008D; a stack compare's
VMJumpIf CMP_STACK jumps when the compare is false, so test_trainer_pic's copy of this check ran CallTrainerLose
after a win: the error screen after its battle). The trainers must be installed (PEARL_TRAINERS=all, or used by an
installed zone). List it after test_story_start:

    TEST_START=272,28,84 TEST_TEAM=1 TEST_PARTNER_BATTLE=616,282,285 PEARL_TRAINERS=all build_rom.py ... \\
        test_story_start test_partner_battle
"""
import glob, os, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders  # noqa: E402
import scripts  # noqa: E402

HOOK = 'PearlArrive:'
AFTER = '    FadeWait\n'
BATTLE = """    // TEST ONLY (test_partner_battle): you and a partner against two trainers
    CallTrainerMultiBattle {p}, {o1}, {o2}, 0
    TrainerBattleIsVictory 0x8010
    WorkCmpConst 0x8010, 1
    VMJumpIf CMP_NE, TestPartner_Lost
    CallTrainerBattleEnd
    VMJump TestPartner_Done
TestPartner_Lost:
    CallTrainerLose
    VMHalt
TestPartner_Done:
"""


def apply(files):
    spec, start = os.environ.get('TEST_PARTNER_BATTLE'), os.environ.get('TEST_START')
    if not spec or not start:
        return 'test_partner_battle: TEST_PARTNER_BATTLE or TEST_START not set, nothing changed'
    p, o1, o2 = (int(v) for v in spec.split(','))
    zone = int(start.split(',')[0])
    headers, _ = zoneheaders.load(files)
    num = headers[zone]['scripts']
    path = glob.glob(os.path.join(scripts.SRC, f'{num:04d}_pearl_*.s'))
    assert path, f'zone {zone} has script file {num}, not a translated Pearl zone'
    src = open(path[0]).read()
    assert src.count(HOOK) == 1, f'{path[0]}: no single PearlArrive script'
    head, tail = src.split(HOOK)
    assert AFTER in tail, 'PearlArrive has no FadeWait'
    tail = tail.replace(AFTER, AFTER + BATTLE.format(p=p, o1=o1, o2=o2), 1)
    with tempfile.TemporaryDirectory() as t:
        out = os.path.join(t, f'{num:04d}_test_partner_battle.s')
        open(out, 'w').write(head + HOOK + tail)
        code = scripts.assemble(out)
    entries = narcio.load(files, 56)
    entries[num] = code
    narcio.save(files, 56, entries)
    return f'test_partner_battle: zone {zone} (script file {num}): trainer {p} at your side against {o1}, {o2}'
