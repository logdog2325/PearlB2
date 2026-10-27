"""Pal Park's migration and Catching Show, the generator's half (notes/PAL_PARK_MIGRATION.md): the gate's migration
question. b2tools/pearl_story.py translates Pearl's Catching Show commands (h_catching_show_*); in the gate, Pearl's
check for six stocked Pokémon (0x254) is followed by migrate_offer's code: with none stocked and a GBA game in slot 2,
the receptionist asks Pearl's own question (Pearl's text bank 403, lines 0-4: "Make Pokémon migrate from
<player>'s <game> Game Pak?", the GBA player's name in word 1) and, on YES, opens the migration screen
(pl_PalParkMigrate), which sets the var to 6 when six came; Pearl's script then goes on as with six stocked.
"""
import json, os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
MIGRATE_BANK = 403                      # Pearl's migration text (Platinum's TEXT_BANK_MIGRATE_FROM_GBA)
# Pearl's line for each GBA game (bank 403 lines 0-4: Ruby, Sapphire, Emerald, FireRed, LeafGreen) by the game's
# origin-game id (1 Sapphire, 2 Ruby, 3 Emerald, 4 FireRed, 5 LeafGreen)
QUESTION_LINE = {1: 1, 2: 0, 3: 2, 4: 3, 5: 4}
NAME_WORD = 1                           # {STRVAR_1 3, 1}: word 1


def gate_name():
    return json.load(open(os.path.join(ROOT, 'data', 'ramanas_park.json'), encoding='utf-8'))['gate']


def migrate_offer(job, a, var):
    """Lines after `pl_CheckHasEnoughMonForCatchingShow var` (Pearl script address a) in the gate."""
    if job.zone['name'] != gate_name():
        return []
    import gen4_text
    lines = gen4_text.bank(MIGRATE_BANK)
    L = f'.Lpp{a:x}'
    out = ['// Pal Park\'s migration (b2tools/palpark_offer.py): none stocked and a GBA game in slot 2 -> Pearl\'s question',
           f'pl_CompareVarToValue {var}, 1', f'pl_GoToIf 1, {L}_done',
           f'pl_GetGBACartridgeAndName PL_TMP, {NAME_WORD}', 'pl_CompareVarToValue PL_TMP, 0', f'pl_GoToIf 1, {L}_done']
    for version in sorted(QUESTION_LINE):
        out += [f'pl_CompareVarToValue PL_TMP, {version}', f'pl_GoToIf 1, {L}_v{version}']
    out += [f'pl_GoTo {L}_done']
    for version, k in sorted(QUESTION_LINE.items()):
        n = job.line_text(('palpark', 'migrate', k), lines[k])
        out += [f'{L}_v{version}:', f'pl_msg_talk {n}', f'pl_GoTo {L}_ask']
    out += [f'{L}_ask:', 'pl_ShowYesNoMenu PL_TMP', 'pl_CompareVarToValue PL_TMP, 0', f'pl_GoToIf 5, {L}_no',
            'pl_CloseMessage', f'pl_PalParkMigrate {var}', f'pl_GoTo {L}_done',
            f'{L}_no:', 'pl_CloseMessage',
            f'{L}_done:']
    return out
