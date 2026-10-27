"""Pearl's intro instead of Black 2's (Professor Rowan): the text is data/text_overrides/pearl_intro.json (Rowan's
speech from pokediamond narc_0341, the rival's default name Barry, Rowan's questions; applied by
patches/sinnoh_names.py); this patch changes the code. Edits and addresses from HoennB2 b2tools/patches/hoenn_intro.py
(tested there), every site checked against Black 2's bytes:

- The Pokémon from the professor's Poké Ball: Juniper's Cinccino (573) -> Pearl's Munchlax (446; pokediamond
  arm9/overlays/59/src/ov59_Intro.c: sub_02068C00(..., SPECIES_MUNCHLAX, ...) and its cry): ov294 intro script
  ADD_SPRITE (0x2a6c) and POKEMON_APPEAR (0x2f60) arguments, and the cry ov162 loads first (literal 0x021a0170).
- No Aspertia flyover and no season card when a new game starts (EventGameOpening_Callback, ov035 0x0217c964: the
  season banner, the shared ChainNext and Event3DDemo_Create(5) become no-ops; Season_Set still runs).
- No season card when a save is continued (user 2026-10-18, question 2: "no season card on loading a save"):
  EventFieldContinue_Callback enters with transition 0 (the plain entrance), whose 5th argument must then be 1.
- Rowan's start-of-game questions (user 2026-10-18, question 4: Fairy type, music, and later CLASSIC/NEW sprites;
  2026-10-19: the Exp. Share and the seasons too, in the order Fairy, music, Exp. Share, seasons; 2026-10-26: the
  following Pokémon as the fourth, before the seasons: PFLAG_POKE_FOLLOWER, patches/followers.py), after the rival is
  named and before "All right, {player}, the time has come": QUESTIONS below. HoennB2 asks Birch's in its
  ASK_RIVAL_NAME script, free there because it dropped the rival naming; Pearl keeps the rival naming, and no intro
  script is unused, so the farewell script (sScripts[12], 11 entries in ov294) is rebuilt in ITCM with the questions
  inserted after its SAVE_WAIT (src/code/rowan_questions.c kRowanFarewell; sScripts[12] points there) and intro
  command 31 (Black 2's unused INTRO_CMD_SET_MSG_LANGUAGE) becomes HoennB2's Intro_SetConfigBit (bit, value): the
  options bits of HoennB2's layout (11 Fairy: patches/fairy.py; 13 home-region music: patches/music_choice.py; 15
  Black 2's seasons by the DS clock: patches/season_choice.py, HoennB2's seasons bit with the same meaning), or, for
  an argument >= 16, an event flag (HoennB2's Exp. Share question does the same): the Exp. Share's YES sets Pearl's
  own "received the Exp. Share" flag (PFLAG_010B, the Route 206 north gate's gift; patches/exp_share.py then puts it
  in the new game's Bag, switched on, and the gate's scientist acts as after his gift).
  The cursor starts on the first answer: mashing A gives Fairy on, Sinnoh's music, the Exp. Share, a following
  Pokémon (test builds ignore it unless TEST_FOLLOW=1: followers.py) and Black 2's seasons. The answers are fixed for the whole game (the Exp. Share itself is switched on and off in the Bag).
  Text: system file 54 (game_start), lines Black 2 leaves blank; the file stays under Black 2's own packed size
  (4,684 B: the intro holds the whole file; measure_text() below). List this patch after the patches that append to
  ITCM before it (sinnoh_encounters, sinnoh_music, pearl_rods) and before fairy (b2tools/itcm.py's order check); the
  Exp. Share and seasons answers need exp_share and season_choice in the same build.
Kept from Black 2: the rival naming (Pearl names Barry too) with Black 2's pictures (Juniper's model, Hugh's picture)
until Rowan's and Barry's pictures are converted (open item, notes/STORY.md).
"""
import json, os, re, struct, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import itcm  # noqa: E402

MUNCHLAX, CINCCINO = 'be010000', '3d020000'     # u32 446, 573

PATCHES = {
    'arm9_ov162.bin': [(0x021a0170 - 0x0219ce80, CINCCINO, MUNCHLAX)],     # PokeVoice_Load species (literal pool)
    'arm9_ov294.bin': [(0x2a6c, CINCCINO, MUNCHLAX),                        # ADD_SPRITE {POKEMON, species, ...}
                       (0x2f60, CINCCINO, MUNCHLAX)],                       # POKEMON_APPEAR {species}
    'arm9_ov035.bin': [(0x0217c9c8 - 0x0217c940, '02f0e2fa', 'c046c046'),   # bl EventSeasonBanner_CreateStandalone
                       (0x0217c9d0 - 0x0217c940, '9af6caf9', 'c046c046'),   # bl GameEvent_ChainNext (shared)
                       (0x0217c9e8 - 0x0217c940, 'e0f7aef8', 'c046c046'),   # bl Event3DDemo_Create (demo 5)
                       (0x0217cd52 - 0x0217c940, '0322', '0022'),           # Continue: transition 3 (season card) -> 0
                       (0x0217cd4a - 0x0217c940, '0020', '0120')],          # ... with its 5th argument 1
}

# ---- Rowan's questions ------------------------------------------------------------------------------------------
OV294 = 0x021A1B20                                               # overlay base (pokebw2 config overlays.yaml)
INTRO_COMMANDS, INTRO_SCRIPTS = 0x021a4bbc, 0x021a4c9c           # sCommands[53], sScripts[14] (pokebw2 symbols)
SET_MSG_LANGUAGE = 0x021a2844                                    # IntroCmd_SetMsgLanguage, Black 2's sCommands[31]
FAREWELL, FAREWELL_SCRIPT = 0x021a435c, 12                       # sScriptFarewell, INTRO_SCRIPT_FAREWELL
CMD = dict(GOTO=1, YES_NO=3, SET_RESULT=6, SET_WORD=20, FADE_SPRITE=29, TALK=30, SET_CONFIG_BIT=31, SAVE_43=43,
           SAVE_WAIT=44, CLOSE_BAND=46, OBJ_FADE_OUT=50)          # pokebw2 include/demo/intro_script.h order
# Black 2's farewell script: SET_RESULT DONE, OBJ_FADE_OUT, CLOSE_BAND, FADE_SPRITE (Rowan in), SAVE_43, SAVE_WAIT,
# SET_WORD (player), TALK 32, TALK 33, FADE_SPRITE (out), GOTO FINISH. The questions go in after SAVE_WAIT ("Creating
# save data" is done, Rowan is on screen) and before SET_WORD + TALK 32 ("All right, {player}, the time has come").
FAREWELL_CMDS = [6, 50, 46, 29, 43, 44, 20, 30, 30, 29, 1]
INSERT_AT = 6
# Text: system file 54 (res/text/system/game_start.txt), lines Black 2 leaves blank (data/text_overrides/pearl_intro.json;
# 31, 34, 35 are kept for the sprite question)
MSG_YES, MSG_NO = 19, 20                                         # GameStart_Text_Yes / _No
MSG_FAIRY_Q, MSG_MUSIC_Q, MSG_SINNOH, MSG_UNOVA = 26, 27, 28, 30  # GameStart_Text_Empty_8, _9, _10, _11
MSG_EXP_SHARE_Q, MSG_SEASONS_Q = 36, 37                          # GameStart_Text_Empty_15, _16
MSG_FOLLOWER_Q = 38                                              # GameStart_Text_Empty_17
TEXT_LIMIT = 4684                                                # Black 2's own packed file 54 (bytes)
CFG_FAIRY_BIT, CFG_MUSIC_BIT, CFG_SEASONS_BIT = 11, 13, 15       # HoennB2's options bits (fairy.py, music_choice.py,
                                                                 # season_choice.py)


def pearl_flag(name):
    """A flag's Black 2 id from src/include/pearl.h (b2tools/pearl_ids.py)."""
    m = re.search(rf'^#define\s+{name}\s+(\d+)', open(os.path.join(ROOT, 'src', 'include', 'pearl.h')).read(), re.M)
    assert m and int(m.group(1)) >= 16, f'{name} missing from src/include/pearl.h'
    return int(m.group(1))


FLAG_EXP_SHARE = pearl_flag('PFLAG_010B')    # Pearl's FLAG_RECEIVED_ROUTE_206_CYCLING_ROAD_NORTH_GATE_EXP_SHARE
FLAG_FOLLOWER = pearl_flag('PFLAG_POKE_FOLLOWER')   # set = the first Pokémon walks behind the player (followers.py)
# (question, first answer, second answer, bit or flag, value of the first answer): the first answer is under the cursor
QUESTIONS = [
    (MSG_FAIRY_Q, MSG_YES, MSG_NO, CFG_FAIRY_BIT, 1),             # Fairy type: YES = on
    (MSG_MUSIC_Q, MSG_SINNOH, MSG_UNOVA, CFG_MUSIC_BIT, 1),       # music: SINNOH = 1 (home-region music), UNOVA = 0
    (MSG_EXP_SHARE_Q, MSG_YES, MSG_NO, FLAG_EXP_SHARE, 1),        # Exp. Share: YES = in the Bag from the start
    (MSG_FOLLOWER_Q, MSG_YES, MSG_NO, FLAG_FOLLOWER, 1),          # following Pokémon: YES = slot 1 walks behind
    (MSG_SEASONS_Q, MSG_YES, MSG_NO, CFG_SEASONS_BIT, 1),         # seasons: YES = Black 2's by the DS clock
]


def measure_text():
    """Packed size of system text 54 with data/text_overrides/pearl_intro.json (pokebw2's own packer, as sinnoh_names
    packs it); asserts it fits Black 2's own size (TEXT_LIMIT)."""
    sys.path.insert(0, os.path.join(ROOT, 'external', 'pokebw2', 'tools', 'text'))
    import text_data
    text = open(os.path.join(ROOT, 'external', 'pokebw2', 'res', 'text', 'system', 'game_start.txt'),
                encoding='utf-8').read().split('\n')
    lines = json.load(open(os.path.join(ROOT, 'data', 'text_overrides', 'pearl_intro.json'), encoding='utf-8'))
    for label, value in lines['game_start'].items():
        at = [i for i, l in enumerate(text) if l.split('=', 1)[0].strip() == label]
        assert len(at) == 1, label
        text[at[0]] = f'{label} = {value}'
    size = len(text_data.pack_file('\n'.join(text)))
    assert size <= TEXT_LIMIT, f'system text 54 is {size} B, over Black 2\'s {TEXT_LIMIT} B: shorten the questions'
    return size


def entry(cmd, *args, run=0):
    a = list(args) + [0] * (4 - len(args))
    return (CMD[cmd], *a, run)


def farewell(ov294):
    """The farewell script with the questions: a list of (cmd, a0, a1, a2, a3, run)."""
    o = FAREWELL - OV294
    old = [struct.unpack_from('<I4iI', ov294, o + 24 * i) for i in range(len(FAREWELL_CMDS))]
    assert [e[0] for e in old] == FAREWELL_CMDS, f'sScriptFarewell is not Black 2\'s: {[e[0] for e in old]}'
    assert struct.unpack_from('<I', ov294, INTRO_SCRIPTS - OV294 + 4 * FAREWELL_SCRIPT)[0] == FAREWELL, 'sScripts[12]'
    asked = []
    for q, first, second, bit, value in QUESTIONS:
        # TALK (Rowan, sprite 0, the talking animation), the two-answer menu, then the entry for the first answer and
        # the one for the second (IntroCmd_YesNo runs one of the two and goes on past both; B = the second)
        asked += [entry('TALK', q, 0, 1), entry('YES_NO', first, second, 1),
                  entry('SET_CONFIG_BIT', bit, value), entry('SET_CONFIG_BIT', bit, 1 - value)]
    return old[:INSERT_AT] + asked + old[INSERT_AT:]


def questions_code(code):
    """Rowan's questions: Intro_SetConfigBit + kRowanFarewell into ITCM; sCommands[31] and sScripts[12] point there."""
    path = os.path.join(code, 'arm9_ov294.bin')
    ov294 = bytearray(open(path, 'rb').read())
    script = farewell(ov294)
    src = os.path.join(ROOT, 'src', 'code', 'rowan_questions.c')
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        with open(os.path.join(tmp, 'rowan_questions.h'), 'w') as f:
            f.write('/* generated by b2tools/patches/pearl_intro.py: Black 2\'s farewell script + Rowan\'s questions */\n'
                    f'#define N_FAREWELL {len(script)}\n'
                    '__attribute__((used)) const s32 kRowanFarewell[N_FAREWELL][6] = {\n    '
                    + ',\n    '.join('{%d, %d, %d, %d, %d, %d}' % e for e in script) + '\n};\n')
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp, includes=[tmp]))
    o = INTRO_COMMANDS - OV294 + 4 * CMD['SET_CONFIG_BIT']
    assert struct.unpack_from('<I', ov294, o)[0] == SET_MSG_LANGUAGE | 1, 'sCommands[31] is not IntroCmd_SetMsgLanguage'
    struct.pack_into('<I', ov294, o, sym['Intro_SetConfigBit'] | 1)
    o = INTRO_SCRIPTS - OV294 + 4 * FAREWELL_SCRIPT
    struct.pack_into('<I', ov294, o, sym['kRowanFarewell'])
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(ov294); os.replace(path + '.tmp', path)
    return (f'Rowan\'s questions: {len(QUESTIONS)} (bits/flags {", ".join(str(q[3]) for q in QUESTIONS)}; text 54 '
            f'{measure_text()} of {TEXT_LIMIT} B), farewell script '
            f'{len(script)} entries at {sym["kRowanFarewell"]:#x}, Intro_SetConfigBit {sym["Intro_SetConfigBit"] | 1:#x} '
            f'({end - base} B of ITCM)')


def apply_code(code):
    done = []
    for name, edits in PATCHES.items():
        path = os.path.join(code, name)
        data = bytearray(open(path, 'rb').read())
        for at, old, new in edits:
            o, n = bytes.fromhex(old), bytes.fromhex(new)
            assert data[at:at + len(o)] in (o, n), f'{name} {at:#x}: unexpected {data[at:at + len(o)].hex()}'
            data[at:at + len(o)] = n
        if os.path.islink(path): os.unlink(path)
        open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
        done.append(f'{name}: {len(edits)} edits')
    done.append(questions_code(code))
    return 'pearl_intro: ' + '; '.join(done) + ' (Munchlax, no flyover, no season card on new game or Continue)'


if __name__ == '__main__':      # python3 pearl_intro.py: the farewell script with the questions (from Black 2's ov294)
    ov = open(os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build', 'arm9_ov294.bin'), 'rb').read()
    names = {v: k for k, v in CMD.items()}
    for e in farewell(ov):
        print(f'{names.get(e[0], e[0]):15s}', e[1:])
