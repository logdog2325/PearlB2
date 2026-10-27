"""Phase 1 reader: Pearl's trainers from the dump, named with pokediamond's constants, checked against pokediamond.

    python3 gen4_trainers.py [ROM] [OUT]        defaults: roms/pearl.nds, work/pearl/trainers.json

Layouts from pokediamond (files/poketool/trainer/trdata.json.txt, trpoke.json.txt, include/trainer_data.h):
trdata.narc: u8 type, u8 class, u8 unk2, u8 party count, u16 items[4], u32 unkC (AI flags), u32 doubleBattle;
trpoke.narc: per Pokémon u16 difficulty, u16 level, u16 species [, u16 item] [, u16 moves[4]].
Names: poketool/trainer/trname (msg bank) is not read here; pokediamond's trdata.json carries them.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from gen4rom import Rom, narc_members  # noqa: E402
from gen4_extract import constants, DIAMOND  # noqa: E402

TYPES = ['TRTYPE_MON', 'TRTYPE_MON_MOVES', 'TRTYPE_MON_ITEM', 'TRTYPE_MON_ITEM_MOVES']


def main():
    rom = Rom(sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'roms', 'pearl.nds'))
    out = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, 'work', 'pearl', 'trainers.json')
    inc = os.path.join(DIAMOND, 'include', 'constants')
    species = constants(os.path.join(inc, 'species.h'), 'SPECIES_')
    items = constants(os.path.join(inc, 'items.h'), 'ITEM_')
    moves = constants(os.path.join(inc, 'moves.h'), 'MOVE_')
    classes = constants(os.path.join(inc, 'trainer_classes.h'), 'TRAINER_CLASS_')
    data = narc_members(rom.read('poketool/trainer/trdata.narc'))
    pokes = narc_members(rom.read('poketool/trainer/trpoke.narc'))
    trainers = []
    for i, (d, p) in enumerate(zip(data, pokes)):
        t, cls, unk2, n = d[:4]
        its = struct.unpack_from('<4H', d, 4)
        ai, double = struct.unpack_from('<2I', d, 12)
        has_item, has_moves = t in (2, 3), t in (1, 3)
        size = 6 + 2 * has_item + 8 * has_moves
        party = []
        for k in range(n):
            f = struct.unpack_from(f'<{size // 2}H', p, k * size)
            mon = {'difficulty': f[0], 'level': f[1], 'species': species.get(f[2] & 0x3ff, f[2]), 'form': f[2] >> 10}
            j = 3
            if has_item:
                mon['item'] = items.get(f[j], f[j]); j += 1
            if has_moves:
                mon['moves'] = [moves.get(m, m) for m in f[j:j + 4]]
            party.append(mon)
        trainers.append({'index': i, 'type': TYPES[t], 'class': classes.get(cls, cls), 'unk2': unk2,
                         'items': [items.get(x, x) for x in its if x], 'ai': ai, 'double': double, 'party': party})
    json.dump(trainers, open(out, 'w'), indent=1)
    # compare with pokediamond's JSON (Diamond and Pearl share one trainer file there)
    ref = {t['index']: t for t in json.load(open(os.path.join(DIAMOND, 'files', 'poketool', 'trainer',
                                                                'trdata.json')))['trdata']}
    diff = []
    for t in trainers:
        r = ref.get(t['index'])
        if r is None:
            diff.append((t['index'], 'missing in pokediamond'))
            continue
        a = [(m['species'], m['level']) for m in t['party']]
        b = [(m['species'], m['level']) for m in r['party']]
        if a != b or t['class'] != r['class']:
            diff.append((t['index'], r['name'], a, b))
    print(f'{len(trainers)} trainers -> {out}; differences from pokediamond trdata.json: {len(diff)}')
    for x in diff[:10]:
        print('  ', x)


if __name__ == '__main__':
    main()
