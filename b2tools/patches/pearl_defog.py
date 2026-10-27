"""Pearl's fog and Defog (notes/TMS.md "Defog"; the user's choice 2026-10-18 question 9: Defog works as a field move).
List it after sinnoh_world / sinnoh_rooms (the zone headers) and season_weather:

    python3 pearl_defog.py --sources     write src/field_scripts/1243_global_10000.s and src/text/script/1236_field_moves.txt

Pearl: the zones whose weather is WEATHER_DEFOG (14: Route 210 North, Mt. Coronet B1F, Turnback Cave, Victory Road 1F
back 2) lie under a deep fog, which Defog used from the party menu clears until the player leaves (pokeplatinum
field_move_tasks.c FieldMoves_CheckDefog: the Relic Badge; scripts_field_moves.s FieldMoves_UseDefogFromMenu).
Black 2 has no such fog; its closest weather is the mist (9: a 3D fog with a light tint, Routes 14 and 15).

- apply: those zones' headers get weather 9 (PEARLB2_WEATHER_FOG). season_weather leaves them to their header
  (kind 1: neither north nor seasonal), so the field shows the mist there all year.
- The code is the decomp's (src/pearlb2/defog_itcm.c, include/pearlb2.h): the party menu lists Defog, it works under
  the mist with the Relic Badge, and its event runs global script 10016 (PEARLB2_SCRIPT_DEFOG).
- Sources (--sources, checked current by apply): src/field_scripts/1243_global_10000.s = Black 2's field-move scripts
  (a/0/5/6 1243, global 10000-10015: pokebw2 res/field/scripts/global_10000.s) with Script_17 (10016) added, Black 2's
  Flash script's steps with Pearl's line: "X used Defog!", Black 2's HM cut-in, then map-local flag 0x52 and
  FieldSetWeather 0, 0: the mist fades out, and stays away through battles (their return resets the weather:
  PearlB2_ZoneWeather answers none for a fog zone while the flag is set) until the player leaves the zone (Black 2
  clears map-local flags at every zone init), as in Pearl. src/text/script/1236_field_moves.txt = Black 2's global 10000 text (pokebw2 res/text/script/
  global_10000.txt) line for line, then Pearl's line (bank 334 line 16, Black 2's nickname code as its own field-move
  lines have it); the decomp points global 10000's text at file 1236 (script_sys.c, PEARLB2_TEXT_GLOBAL_10000).
- The same two files also carry the following Pokémon's talk (2026-10-26, patches/followers.py, notes/FOLLOWERS.md):
  Script_18 (10017, FOLLOWER_SCRIPT) and, after the Defog line, Pearl's 9 Amity Square lines (bank 236, 13-21) that
  Pearl shows when the walking Pokémon is talked to; the script names the Pokémon in the party slot the follower
  module keeps in PVAR_FOLLOWER_SLOT, plays its cry and shows one of the 9 at random, as Pearl's Amity Square does.
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import zoneheaders  # noqa: E402

DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
PEARL_DEFOG_WEATHER = 14            # pokediamond constants/weather.h WEATHER_DEFOG
B2_FOG = 9                          # Black 2's mist (include/pearlb2.h PEARLB2_WEATHER_FOG)
WEATHER_MASK = 0x3F
SCRIPT_SRC = os.path.join(ROOT, 'src', 'field_scripts', '1243_global_10000.s')
TEXT_SRC = os.path.join(ROOT, 'src', 'text', 'script', '1236_field_moves.txt')
DEFOG_LINE_BANK, DEFOG_LINE = 334, 16
LABEL = 'Global10000_Text_PearlUsedDefog'
DEFOG_FLAG = 0x52                   # map-local: Defog cleared this zone's fog (include/pearlb2.h PEARLB2_FLAG_DEFOG)
FOLLOWER_SCRIPT = 10017             # the following Pokémon's talk (patches/followers.py config scrId)
FOLLOWER_LINES_BANK, FOLLOWER_LINES = 236, range(13, 22)   # Pearl's Amity Square: "{name} is happily keeping up." ...


def pearl_var(name):
    """A work's Black 2 id from src/include/pearl.h (b2tools/pearl_ids.py)."""
    import re
    m = re.search(rf'^#define\s+{name}\s+(0x[0-9A-Fa-f]+|\d+)', open(os.path.join(ROOT, 'src', 'include', 'pearl.h')).read(),
                  re.M)
    assert m, f'{name} missing from src/include/pearl.h'
    return int(m.group(1), 0)


def pearlb2_h():
    import re
    h = open(os.path.join(DECOMP, 'include', 'pearlb2.h')).read()
    return {k: int(v, 0) for k, v in re.findall(r'#define (PEARLB2_(?:TEXT_GLOBAL_10000|SCRIPT_DEFOG|WEATHER_FOG|FLAG_DEFOG)) '
                                                 r'(0x[0-9a-fA-F]+|\d+)', h)}


def sources():
    """(script source, text source) as --sources writes them."""
    import gen4_text
    h = pearlb2_h()
    assert h['PEARLB2_WEATHER_FOG'] == B2_FOG and h['PEARLB2_TEXT_GLOBAL_10000'] == 1236 and \
        h['PEARLB2_SCRIPT_DEFOG'] == 10016 and h['PEARLB2_FLAG_DEFOG'] == DEFOG_FLAG, f'include/pearlb2.h: {h}'
    pearl = gen4_text.bank(DEFOG_LINE_BANK)[DEFOG_LINE]
    assert pearl == '{STRVAR_1 0, 0} used Defog!\\r', pearl
    text = open(os.path.join(DECOMP, 'res', 'text', 'script', 'global_10000.txt'), encoding='utf-8').read().split('\n')
    assert text[-2].startswith('\\pad{') and text[-1] == '', text[-3:]
    lines = text[:-2]
    defog_id = len(lines)
    lines.append(f'{LABEL} = {{0102:0}} used Defog!{{be01}}')   # Pearl's words, Black 2's "X used Cut!" form
    follower_id = len(lines)
    amity = gen4_text.bank(FOLLOWER_LINES_BANK)
    for k, i in enumerate(FOLLOWER_LINES):
        lines.append(f'Global10000_Text_PearlFollower{k} = {gen4_text.b2_line(amity[i])}')
    slot = pearl_var('PVAR_FOLLOWER_SLOT')
    s = open(os.path.join(DECOMP, 'res', 'field', 'scripts', 'global_10000.s'), encoding='utf-8').read()
    assert s.count('    ScriptEntry Script_16\n    ScriptEntriesEnd\n') == 1 and s.endswith('    .balign 4, 0\n')
    s = s.replace('    ScriptEntry Script_16\n    ScriptEntriesEnd\n',
                  '    ScriptEntry Script_16\n    ScriptEntry Script_17\n    ScriptEntry Script_18\n    ScriptEntriesEnd\n')
    head = ('// Global scripts 10000-10017 (a/0/5/6 entry 1243): Black 2\'s field moves, pokebw2 res/field/scripts/\n'
            '// global_10000.s, with Script_17 (10016) added: Pearl\'s Defog from the party menu (b2tools/patches/\n'
            '// pearl_defog.py --sources writes this file; the decomp\'s src/pearlb2/defog_itcm.c runs it). Text: a/0/0/3\n'
            f'// file 1236 (src/text/script/1236_field_moves.txt: Black 2\'s lines, then line {defog_id}, Pearl\'s "used Defog!").\n'
            f'// Script_18 (10017): the following Pokémon talked to (patches/followers.py), lines {follower_id}-'
            f'{follower_id + len(FOLLOWER_LINES) - 1}.\n')
    script = ('\n// PearlB2: Pearl\'s Defog (pokeplatinum FieldMoves_UseDefogFromMenu): Black 2\'s Flash steps with Pearl\'s line,\n'
              '// then the mist fades out (FieldSetWeather 0, not at once) and stays away until the player leaves the zone\n'
              'Script_17:\n'
              '    ActorsPauseAll\n'
              '    WordSetPartyPokeName 0, 0x8000\n'
              f'    SystemMsg {defog_id}, 2                   // "X used Defog!"\n'
              '    InfoMsgClose\n'
              '    VMCall L_005C\n'
              '    PlayHMCutInEffect 0x8000\n'
              '    VMCall L_006C\n'
              f'    FlagSet {DEFOG_FLAG:#x}                    // (map-local: the clear sky stays through battles: '
              'PearlB2_ZoneWeather)\n'
              '    FieldSetWeather 0, 0\n'
              '    FinishAllEvents\n'
              '    ActorsUnpauseAll\n'
              '    VMHalt\n')
    script += ('\n// PearlB2: the following Pokémon talked to (include/follower.h; Pearl\'s Amity Square, script file 266): its cry\n'
               '// and one of Pearl\'s 9 lines at random, naming the Pokémon in the party slot PVAR_FOLLOWER_SLOT keeps\n'
               'Script_18:\n'
               '    SEPlay SEQ_SE_MESSAGE\n'
               '    ActorsPauseAll\n'
               '    ActorSetEyeToEye\n'
               f'    WordSetPartyPokeName 0, {slot:#x}       // PVAR_FOLLOWER_SLOT\n'
               f'    PokePartyGetSpecies 0x8020, {slot:#x}\n'
               f'    Random 0x8021, {len(FOLLOWER_LINES)}\n'
               f'    WorkAdd 0x8021, {follower_id}                // Global10000_Text_PearlFollower0 ...\n'
               '    PVPlay 0x8020, 0\n'
               '    ParentActorMsg MSGFILE_SCRIPT, 0x8021, 0, 0\n'
               '    PVWait\n'
               '    LastKeyWait\n'
               '    MsgWinCloseAll\n'
               '    FinishAllEvents\n'
               '    ActorsUnpauseAll\n'
               '    VMHalt\n')
    s = head + s[:-len('    .balign 4, 0\n')] + script + '    .balign 4, 0\n'
    return s, '\n'.join(lines) + '\n'


def check_sources():
    s, t = sources()
    for path, want in ((SCRIPT_SRC, s), (TEXT_SRC, t)):
        assert os.path.exists(path) and open(path, encoding='utf-8').read() == want, \
            f'{os.path.relpath(path, ROOT)} is not current: python3 b2tools/patches/pearl_defog.py --sources'


def fog_zones():
    """{Black 2 zone: Pearl zone name} of the installed zones under Pearl's deep fog."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    out = {}
    for z in zones:
        if z['weather'] != PEARL_DEFOG_WEATHER:
            continue
        r = world['zones'].get(str(z['id'])) or world['rooms']['zones'].get(str(z['id']))
        if r is not None:
            out[r['b2_zone']] = z['name']
    return out


def apply(files):
    check_sources()
    headers, entries = zoneheaders.load(files)
    zones = fog_zones()
    for b2 in zones:
        headers[b2]['weather_word'] = (headers[b2]['weather_word'] & ~WEATHER_MASK) | B2_FOG
    zoneheaders.save(files, headers, entries)
    return (f'pearl_defog: Black 2\'s mist (weather {B2_FOG}) in Pearl\'s deep-fog zones '
            + ', '.join(f'{n[4:]} ({b2})' for b2, n in sorted(zones.items())) + '; Defog: global 10016')


if __name__ == '__main__':
    if '--sources' in sys.argv:
        s, t = sources()
        open(SCRIPT_SRC, 'w', encoding='utf-8').write(s)
        open(TEXT_SRC, 'w', encoding='utf-8').write(t)
        print('wrote', os.path.relpath(SCRIPT_SRC, ROOT), os.path.relpath(TEXT_SRC, ROOT))
    else:
        print(__doc__)
