"""Pearl's catching tutorial on Route 202 (Pearl StartCatchingTutorial 0x126, translated as Black 2's CallCaptureDemo:
src/include/pearl_story.inc pl_StartCatchingTutorial). User 2026-10-20: "the catching tutorial pokemon should match how
it is in pearl no purloin and liipup". HoennB2's patches/capture_demo.py did Wally's tutorial the same way.

Pearl (pokediamond arm9 sub_02047814 = pokeplatinum FieldBattleDTO_NewCatchingTutorial; the battle: pokeplatinum
battle_subscreen.c GetCatchTutorialInput*, battle_display.c, trainer_ai/script.s CatchTutorial_Main):
- the battler is the counterpart: name = text bank 497 line (player's gender ^ 1) (Lucas / Dawn), that gender, so
  the counterpart's back picture;
- the counterpart's starter (SystemVars_GetPlayerCounterpartStarter, the one left in the briefcase: Turtwig -> Piplup,
  Chimchar -> Turtwig, Piplup -> Chimchar) Lv 5 against a wild Bidoof Lv 2, both CreateMon (random IVs, not shiny,
  their level-up moves: Turtwig Tackle/Withdraw, Chimchar Scratch/Leer, Piplup Pound/Growl, Bidoof Tackle);
- turn 1: the hint presses Fight and the first move; Bidoof Tackles back (its only move); turn 2: the counterpart's
  line (bank 324: 1226 Lucas "All right! I got its HP down!\\nTime to throw a Poké Ball!", 1227 Dawn "OK! Its HP is
  down!\\nIt’s ready for a Poké Ball!"), the Bag, the Ball: "<name> used\\na Poké Ball!" (1228), caught.
Black 2's demo (pokebw2 src/ov012/event_battle.c EventCaptureDemo_Create; src/ov167/btlv_core.c func_ov167_021cea24;
battle effect scripts a/0/6/6) is a fixed sequence: Lillipup Lv 5 / Purrloin Lv 2; effect 0x23C brings in the thrower
(trainer class 38: Bianca's back sprite 6); the player side uses Tackle (the wild HP bar drops to 1/6); the wild one
uses Growl ("Attack fell!"); system text 23 (btlv_core) line 0; the Bag; the Ball; line 1 "Bianca used a Poké Ball!";
"Gotcha!". This patch makes it Pearl's:
1. Pokémon (ov012): the party block 0x021689ac-0x02168a33 calls CaptureDemo_Parties (src/code/capture_demo.c, ITCM)
   with (pkm, party, enemy party, gameData): the counterpart's starter from PVAR_STARTER (pearl.h) Lv 5 and Bidoof
   Lv 2, PokeParty_CreateTempPkm with PKM_ID_NOT_SHINY (random IVs and PID; the level-up moves as Pearl's); it
   returns Bidoof for the encounter's music/effect (r4, EventBattleCall_DecideEnvWild).
2. Back picture (a/0/6/6 file 11 = effect 0x23C): CallDisplay(38, pos 8, ...) -> CallDisplay(-1 = the VM's value),
   after SetValue 1 (Dawn, battle back 1); IfVarConst(var 40 = the player's trainer type 0/1, == 0, skip 6);
   SetValue 0 (Lucas, back 0): a boy sees Dawn (Pearl's own back), a girl Lucas (the fan-made back;
   patches/pearl_player_sprites.py). Each back's ball leaves its own hand (the decomp's PearlB2_BallEmitter).
   Same file size (the ROM layout stays): the 30 new bytes replace the scale of enemy position 7 (triple battles
   only), the rest of its 44 bytes a no-op IfPokeExists(7, 0, +0).
3. Moves (ov167): the starter's own first move instead of Tackle (the touch screen shows its moves): the "used"
   message (CaptureDemo_UsedMove), the animation (CaptureDemo_MoveParam returns the param and, in r1, the move,
   kept in r7 for `movs r3, #33`); the damage blink takes only the category (all three are physical). Bidoof uses
   Tackle instead of Growl (its message and animation: immediates 45 -> 33), and it hits: CaptureDemo_WildHit (the
   starter's HP bar loses 1/8, the blink, the demo's hit sound) instead of the Attack-down effect, CaptureDemo_
   WildHitDone waits for it, and the "Attack fell!" message is skipped (b to the seq++ path).
4. Text (ov167 cases 12 and 15): GFL_MsgDataLoadStrbuf -> CaptureDemo_Line (line + 2 x the player's trainer type):
   system text 23 lines 0-1 = Dawn's line and "Dawn used\\na Poké Ball!", 2-3 = Lucas's (data/text_overrides/
   capture_demo.json, packed by sinnoh_names): Pearl's words; Black 2 prints them without word buffers, so the names
   are written in (Pearl's own: bank 497).
5. The Bag (ov286 BBagItem_MakeDemoList): 20 Poké Balls, as Pearl's battle Bag (Black 2: 30).
Not Pearl's (Black 2's fixed demo): its own touch hints and screens; the HP bars move by fixed amounts (Bidoof to 1/6,
the starter loses 1/8; Pearl: the real damage).
Tested 2026-10-20 (DeSmuME, TEST_START=321,181,827 + PFLAG_008F): as Lucas with PVAR_STARTER=387 (Dawn's Piplup,
Pound) and as Dawn with 393 (Lucas's Chimchar, Scratch): work/agents/capture/shots/.

ITCM: list after sinnoh_names (any place among the ITCM installers: itcm.install appends). Being an autoload, ITCM
is copied at boot: savestates made before need a cold boot.
"""
import os, re, struct, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build')
OV012, OV167, OV286 = 0x021503C0, 0x021998C0, 0x021F4440   # extract/b2_us/arm9_overlays/overlays.yaml
ARC_EFFECTS, EFFECT_FILE = 66, 0x23C - 0x231   # a/0/6/6: battle effect scripts from 0x231 (btlv_effvm.c)
NOP = 'c046'


def pvar_starter():
    m = re.search(r'^#define PVAR_STARTER (0x[0-9A-Fa-f]+)', open(os.path.join(ROOT, 'src', 'include', 'pearl.h')).read(),
                  re.M)
    return int(m.group(1), 16)


# ---- the intro effect: the counterpart's back picture ----------------------------------------------------------------
def _cmd(c, *args):
    return struct.pack('<H', c) + b''.join(struct.pack('<i', a) for a in args)


SET_VALUE, IF_VAR_CONST, IF_POKE_EXISTS, CALL_DISPLAY = 62, 59, 61, 32   # MOVE_SCRCMD indices (btlv_effvm.c)
VAR_TRAINER_TYPE_0 = 40                                                   # BtlvEffvm_GetVariable: trainer type, pos 0


def effect_23c(old):
    assert len(old) == 324 and old[0x76:0x7c] == _cmd(CALL_DISPLAY, 38), old[0x76:0x8c].hex()
    pos7 = old[0x110:0x13c]
    assert pos7[:14] == _cmd(IF_POKE_EXISTS, 7, 0, 30) and pos7[14:20] == struct.pack('<Hi', 21, 7), pos7.hex()
    pick = (_cmd(SET_VALUE, 1) + _cmd(IF_VAR_CONST, VAR_TRAINER_TYPE_0, 0, 0, 6) + _cmd(SET_VALUE, 0))
    new = (old[:0x76] + pick + _cmd(CALL_DISPLAY, -1) + old[0x7c:0x110]
           + _cmd(IF_POKE_EXISTS, 7, 0, 0) + old[0x13c:])
    assert len(new) == len(old)
    return new


def apply(files):
    import narcio
    e = narcio.load(files, ARC_EFFECTS)
    if e[EFFECT_FILE][0x76:0x7c] == _cmd(SET_VALUE, 1):
        return 'capture demo effect: already done'
    size = os.path.getsize(narcio.arc_path(files, ARC_EFFECTS))
    e[EFFECT_FILE] = effect_23c(e[EFFECT_FILE])
    narcio.save(files, ARC_EFFECTS, e)
    assert os.path.getsize(narcio.arc_path(files, ARC_EFFECTS)) == size
    return 'capture demo: effect 0x23C shows Dawn\'s back to a boy, Lucas\'s to a girl (a/0/6/6 file 11, same size)'


# ---- code --------------------------------------------------------------------------------------------------------------
def _patch(d, base, addr, old, new, what):
    old, new = bytes.fromhex(old) if isinstance(old, str) else old, bytes.fromhex(new) if isinstance(new, str) else new
    assert len(old) == len(new), what
    at = addr - base
    assert d[at:at + len(old)] == old, f'{what} at {addr:#x}: {d[at:at + len(old)].hex()} (expected {old.hex()})'
    d[at:at + len(new)] = new


def _load(code, name):
    p = os.path.join(code, name)
    return p, bytearray(open(p, 'rb').read())


def _save(p, d):
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)


def apply_code(code):
    import itcm
    bl = itcm.bl
    src = os.path.join(ROOT, 'src', 'code', 'capture_demo.c')
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp, defines=[f'-DPVAR_STARTER={pvar_starter()}']))
    f = {k: v & ~1 for k, v in sym.items()}

    # 1. ov012 EventCaptureDemo_Create: the parties
    p, d = _load(code, 'arm9_ov012.bin')
    at, stop = 0x021689AC, 0x02168A34
    old = open(os.path.join(VANILLA, 'arm9_ov012.bin'), 'rb').read()[at - OV012:stop - OV012]
    assert old.startswith(bytes.fromhex('0021a73c0091051c')) and old.endswith(bytes.fromhex('0798291cb7f69cf9')), old.hex()
    new = (bytes.fromhex('051c' '391c' '079a' '059b')   # adds r5, r0, #0 (pkm); r1 = party; r2 = enemy; r3 = gameData
           + bl(at + 8, f['CaptureDemo_Parties'])
           + bytes.fromhex('041c')                     # adds r4, r0, #0: the wild species (DecideEnvWild)
           + struct.pack('<H', 0xE000 | ((stop - (at + 14 + 4)) >> 1) & 0x7FF))   # b 0x02168a34
    new += bytes.fromhex(NOP) * ((len(old) - len(new)) // 2)
    _patch(d, OV012, at, old, new, 'EventCaptureDemo_Create parties')
    _save(p, d)

    # 2. ov167 func_ov167_021cea24, the demo's sequence
    p, d = _load(code, 'arm9_ov167.bin')
    edits = [
        # case 5: "<starter> used <its first move>!"   movs r2, #33; bl func_ov167_021d02cc
        (0x021CEB9A, '2122' + bl(0x021CEB9C, 0x021D02CC).hex(), bl(0x021CEB9A, f['CaptureDemo_UsedMove']).hex() + NOP),
        # case 6: its animation   movs r0, #33; movs r1, #27; bl PML_MoveGetParam -> adds r0, r4, #0; bl; adds r7, r1, #0
        (0x021CEBBA, '2120' '1b21' + bl(0x021CEBBE, 0x02021280).hex(),
         '201c' + bl(0x021CEBBC, f['CaptureDemo_MoveParam']).hex() + '0f1c'),
        (0x021CEBD0, '2123', '3b1c'),                                       # movs r3, #33 -> adds r3, r7, #0
        # cases 8, 9: Bidoof's Tackle (45 Growl -> 33): its message, the move param, the animation
        (0x021CEC30, '2d22', '2122'), (0x021CEC40, '2d20', '2120'), (0x021CEC58, '2d23', '2123'),
        # case 10: it hits (adds r0, r4, #0; movs r1, #0; bl func_ov167_021d03a0 = the Attack-down effect)
        (0x021CEC6E, '201c' '0021' + bl(0x021CEC72, 0x021D03A0).hex(), '201c' + bl(0x021CEC70, f['CaptureDemo_WildHit']).hex() + NOP),
        # case 11: wait for the hit and the HP bar; no "Attack fell!" (b to case 10's seq++ path at 0x021ceac8)
        (0x021CEC7C, bl(0x021CEC7C, 0x021D03C0).hex(), bl(0x021CEC7C, f['CaptureDemo_WildHitDone']).hex()),
        (0x021CEC84, '201c', struct.pack('<H', 0xE000 | ((0x021CEAC8 - (0x021CEC84 + 4)) >> 1) & 0x7FF).hex()),
        # cases 12, 15: the counterpart's two lines by the player's gender
        (0x021CECD6, bl(0x021CECD6, 0x02048838).hex(), bl(0x021CECD6, f['CaptureDemo_Line']).hex()),
        (0x021CED4C, bl(0x021CED4C, 0x02048838).hex(), bl(0x021CED4C, f['CaptureDemo_Line']).hex()),
    ]
    for addr, old, new in edits:
        _patch(d, OV167, addr, old, new, f'capture demo ov167 {addr:#x}')
    _save(p, d)

    # 3. ov286 BBagItem_MakeDemoList: the demo's Bag holds 20 Poké Balls, as Pearl's (Black 2: 30)
    p, d = _load(code, 'arm9_ov286.bin')
    _patch(d, OV286, 0x021F4EA0, '1e22', '1422', 'demo bag: movs r2, #30 -> #20')
    _save(p, d)
    return (f'capture demo: the counterpart\'s starter Lv 5 (its first move) vs Bidoof Lv 2 (Tackle), Pearl\'s lines by '
            f'gender, 20 Poké Balls; ITCM {base:#x}-{end:#x}, ov012 1 block, ov167 {len(edits)} edits, ov286 1')
