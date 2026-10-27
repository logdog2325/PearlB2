"""The Grand Underground's script and text files (one of each for all its zones: data/underground.json "files"):

    python3 underground_scripts.py          -> src/field_scripts/1900_underground.s, src/text/script/1300_underground.txt
    python3 underground_scripts.py --check  (patches/underground.py runs it: the files must be what the data gives)

Entries (ug_data.script_ids): 1 the Explorer Kit's "go up?" (src/pearlb2/underground_itcm.c runs it; Pearl's own
question, text bank 575 line 52, answered in work ug_data.ANSWER_WORK: 1 = yes); then each Hideaway's name at its
tunnel hole (a sign: BDSP's English names); each item ball (BDSP's Hideaway items) and each daily shard ball, with
Pearl's own item-ball routine (Pearl file 370 script 122 and common script 205:2 as pearl_story translates them:
the fanfare by pocket, "found", "put in the Pocket", "The Bag is full", Pearl's bank 325 lines); last the daily fossil
balls (a Kanto or Hoenn fossil at random); last the zone init that hides the daily balls until the player is
Champion (the game-clear flag; user 2026-10-26).
"""
import os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import ug_data  # noqa: E402

GAME_CLEAR = 'PFLAG_0964'          # Pearl's FLAG_GAME_COMPLETED = Black 2's game clear 2400

# Pearl's lines in Black 2's text format (pearl_story's conversion of the same Pearl lines: Veilstone's 66-69)
GO_UP = 'Would you like to return to the\\nsurface from where you entered?'     # Pearl bank 575 line 52
PUT = '{0100:0} put the {0109:1}\\nin the {ff00:2}{0112:2}{ff00:0} Pocket.'          # bank 325 line 9
FOUND_TM = '{0100:0} found\\n{0109:1} {0107:2}!'                                   # bank 325 line 6
FOUND = '{0100:0} found\\n{0109:1}!'                                               # bank 325 line 3
FULL = 'Obtained the {0109:0}!{be01}\\nToo bad!\\nThe Bag is full...'               # bank 325 line 4


def paths():
    f = ug_data.data()['files']
    return (os.path.join(ROOT, 'src', 'field_scripts', f"{f['script']}_underground.s"),
            os.path.join(ROOT, 'src', 'text', 'script', f"{f['text']}_underground.txt"))


def text_lines():
    hs = ug_data.hideaways()
    lines = [GO_UP] + [h['pokemon']['name'] for h in hs] + [PUT, FOUND_TM, FOUND, FULL]
    return lines


def msg(name):
    n = len(ug_data.hideaways())
    return {'go_up': 0, 'put': 1 + n, 'found_tm': 2 + n, 'found': 3 + n, 'full': 4 + n}[name]


def text_file():
    return ''.join(f'Underground_Text_{i:03d} = {t}\n' for i, t in enumerate(text_lines()))


def script_file():
    ids = ug_data.script_ids()
    hs = ug_data.hideaways()
    balls, shards, fossils = ug_data.item_balls(), ug_data.shard_balls(), ug_data.fossil_balls()
    fossil_items = [ug_data.item(n) for n in ug_data.data()['fossil_items']]
    out = ['// The Grand Underground (zones 633-651), one script file for all its zones. Written by',
           '// b2tools/underground_scripts.py from data/underground.json: do not edit (notes/UNDERGROUND.md).',
           '#include "asm/field_script.inc"', '#include "pearl.h"', '#include "pearl_story.inc"', '']
    entries = (['UG_GoUp'] + [f'UG_Name_{i}' for i in range(len(hs))] + [f'UG_Item_{k}' for k in range(len(balls))]
               + [f'UG_Shard_{k}' for k in range(len(shards))] + [f'UG_Fossil_{k}' for k in range(len(fossils))]
               + ['UG_ShardInit'])
    assert len(entries) == ids['shard_init']
    out += [f'    ScriptEntry {e}' for e in entries] + ['    ScriptEntriesEnd', '']
    out += ['// 1: the Explorer Kit in the Underground (src/pearlb2/underground_itcm.c reads the answer)',
            'UG_GoUp:',
            '    pl_LockAll',
            f'    WorkSetConst {ug_data.ANSWER_WORK:#06x}, 0',
            f'    pl_msg_sys {msg("go_up")}',
            '    pl_ShowYesNoMenu PVAR_800C',
            '    pl_CompareVarToValue PVAR_800C, 0',     # (0 = YES)
            '    pl_GoToIf 5, UG_GoUp_No',               # (Pearl's conditions: 0 <, 1 =, 2 >, 3 <=, 4 >=, 5 !=)
            f'    WorkSetConst {ug_data.ANSWER_WORK:#06x}, 1',
            'UG_GoUp_No:',
            '    pl_CloseMessage',
            '    pl_ReleaseAll',
            '    pl_End', '']
    for i, h in enumerate(hs):
        out += [f'UG_Name_{i}:                         // {h["pokemon"]["name"]} (its hole in the tunnels)',
                f'    pl_sign {1 + i}, 2', '    pl_End', '']
    for k, (i, it, x, z, flag) in enumerate(balls):
        out += [f'UG_Item_{k}:                          // {hs[i]["pokemon"]["name"]}: item {it} at ({x}, {z})',
                f'    pl_SetVarFromValue PVAR_8008, {it}', '    pl_SetVarFromValue PVAR_8009, 1',
                '    VMCall UG_ItemBall', '    pl_End', '']
    for k, (i, it, x, z, flag) in enumerate(shards):
        out += [f'UG_Shard_{k}:                         // {hs[i]["pokemon"]["name"]}: daily item {it} at ({x}, {z})',
                f'    pl_SetVarFromValue PVAR_8008, {it}', '    pl_SetVarFromValue PVAR_8009, 1',
                '    VMCall UG_ItemBall', '    pl_End', '']
    for k, (i, x, z, flag) in enumerate(fossils):
        out += [f'UG_Fossil_{k}:                        // {hs[i]["pokemon"]["name"]}: a daily fossil at ({x}, {z})',
                f'    pl_GetRandom PVAR_800C, {len(fossil_items)}']
        out += [f'    pl_SetVarFromValue PVAR_8008, {fossil_items[0]}']
        for n, it in enumerate(fossil_items[1:], 1):
            out += [f'    pl_CompareVarToValue PVAR_800C, {n}', f'    pl_GoToIf 5, UG_Fossil_{k}_{n}',
                    f'    pl_SetVarFromValue PVAR_8008, {it}', f'UG_Fossil_{k}_{n}:']
        out += ['    pl_SetVarFromValue PVAR_8009, 1', '    VMCall UG_ItemBall', '    pl_End', '']
    out += ['// the daily shard and fossil balls only after becoming Champion (zone init: hidden by their daily flags',
            '// until then)',
            'UG_ShardInit:',
            f'    pl_CheckFlag {GAME_CLEAR}',
            '    pl_GoToIf 1, UG_ShardInit_End']
    out += [f'    FlagSet PFLAG_UG_SHARD_{k}' for k in range(len(shards))]
    out += [f'    FlagSet PFLAG_UG_FOSSIL_{k}' for k in range(len(fossils))]
    out += ['UG_ShardInit_End:', '    pl_End', '']
    out += ['// Pearl\'s item-ball routine (Pearl file 370 script 122 as pearl_story translates it): PVAR_8008 the item,',
            '// PVAR_8009 the count; the talked-to ball goes and its flag is set',
            'UG_ItemBall:',
            '    pl_PlaySE SEQ_SE_MESSAGE',
            '    pl_LockAll',
            '    pl_FacePlayer',
            '    pl_WaitSE SEQ_SE_MESSAGE',
            '    pl_SetVarFromVar PVAR_8004, PVAR_8008',
            '    pl_SetVarFromVar PVAR_8005, PVAR_8009',
            '    pl_CanFitItem PVAR_8004, PVAR_8005, PVAR_800C',
            '    pl_CompareVarToValue PVAR_800C, 0',
            '    pl_GoToIf 1, UG_ItemBall_Full',
            '    VMCall UG_Fanfare',
            '    pl_RemoveTalkedObject',
            '    pl_AddItem PVAR_8004, PVAR_8005, PVAR_800C',
            '    ItemIsTMHM PVAR_8004, PVAR_800C',
            '    pl_CompareVarToValue PVAR_800C, 1',
            '    pl_GoToIf 1, UG_ItemBall_TM',
            '    pl_BufferPlayerName 0',
            '    WordSetItemNameWithArticle 1, PVAR_8004',
            '    MsgWinCloseAll',
            f'    pl_msg_sys {msg("found")}',
            '    pl_GoTo UG_ItemBall_Pocket',
            'UG_ItemBall_TM:',
            '    pl_BufferPlayerName 0',
            '    WordSetItemNameWithArticle 1, PVAR_8004',
            '    pl_BufferTMHMMoveName 2, PVAR_8004',
            '    MsgWinCloseAll',
            f'    pl_msg_sys {msg("found_tm")}',
            'UG_ItemBall_Pocket:',
            '    pl_WaitFanfare',
            '    pl_BufferPlayerName 0',
            '    pl_BufferItemName 1, PVAR_8004',
            '    pl_GetItemPocket PVAR_8004, PVAR_800C',
            '    pl_BufferPocketName 2, PVAR_800C',
            '    MsgWinCloseAll',
            f'    pl_msg_sys {msg("put")}',
            '    pl_WaitButton',
            '    pl_CloseMessage',
            '    pl_ReleaseAll',
            '    VMReturn',
            'UG_ItemBall_Full:',
            '    pl_BufferItemName 0, PVAR_8004',
            '    MsgWinCloseAll',
            f'    pl_msg_sys {msg("full")}',
            '    pl_WaitButton',
            '    pl_CloseMessage',
            '    pl_ReleaseAll',
            '    VMReturn',
            '',
            '// Pearl common script 205:2: the fanfare by pocket (key items, TMs, the others)',
            'UG_Fanfare:',
            '    pl_GetItemPocket PVAR_8004, PVAR_800C',
            '    pl_CompareVarToValue PVAR_800C, 7',
            '    pl_GoToIf 1, UG_Fanfare_Key',
            '    pl_CompareVarToValue PVAR_800C, 3',
            '    pl_GoToIf 1, UG_Fanfare_TM',
            '    pl_PlayFanfare SEQ_ME_ITEM',
            '    pl_Return',
            'UG_Fanfare_TM:',
            '    pl_PlayFanfare SEQ_ME_WAZA',
            '    pl_Return',
            'UG_Fanfare_Key:',
            '    pl_PlayFanfare SEQ_ME_KEYITEM',
            '    pl_Return', '']
    return '\n'.join(out)


def main():
    s, t = paths()
    want = {s: script_file(), t: text_file()}
    if '--check' in sys.argv:
        bad = [p for p, v in want.items() if not os.path.exists(p) or open(p, encoding='utf-8').read() != v]
        if bad:
            raise SystemExit(f'underground_scripts: out of date (run b2tools/underground_scripts.py): {bad}')
        print('underground_scripts: up to date')
        return
    for p, v in want.items():
        open(p, 'w', encoding='utf-8').write(v)
        print(p)


if __name__ == '__main__':
    main()
