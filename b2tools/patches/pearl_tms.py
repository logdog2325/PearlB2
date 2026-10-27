"""Pearl's TMs: TM96-TM120 for the 25 TM/HM moves of Pearl that Black 2 has no TM for, and Pearl's learners (notes/
TMS.md, way 2: the user's choice, question 9b B 2026-10-18; ids, Unova learners and wording 2026-10-26).

    python3 pearl_tms.py --text      write data/text_overrides/pearl_tms.json (the new items' names and descriptions)

The game's code is the decomp's (branch pearlb2): include/pearlb2.h sets the items' block (PEARLB2_TM_FIRST_ITEM: the
Data Cards 01-25, items 505-529, which Black 2 never uses) and their machine bits (101-125); src/pearlb2/tms_itcm.c has
the TM functions pml_item.c jumps to (which item is a TM, its move, its bit), the Bag's "No. N" (3 digits from 100)
and sort, the shop's TM numbers; pml_item.c / myitem_savedata.c put the items in the TM pocket, give them the TM disc
icon in their move type's colour, and make them used, unholdable items. This patch does the data (b2tools/tm_audit.py
computes it; tm_audit.py check proves it):
  a/0/2/4  items 505-529 = Black 2 TM01's record (TM pocket, field use 6, can't be sold or tossed) with Pearl's price
           (pokediamond item_data.json / 10; Defog and Rock Climb, Pearl's HMs: 0) and sort index = its bit;
  a/0/1/6  machine bits (+0x28): species 1-493 and their forms learn each of Pearl's 100 TM/HM moves exactly as in
           Pearl (the dump's personal_pearl.narc), on the bit of the item that teaches it here (Black 2's TM02 Dragon
           Claw, TM94 Rock Smash, HM05 Waterfall, TM96-TM120 ...); Black 2's TMs Pearl lacks keep Black 2's bits;
           Unova species and forms learn a new TM where they learn its close Black 2 move (tm_audit.PROXY).
  text     data/text_overrides/pearl_tms.json (sinnoh_names packs it): names "TM96" ..., "a TM96", "TM96s", and
           each move's own Black 2 description (res/moves/<move>/data.json), as Black 2's TMs have their move's words
           (each fits the Bag's description window: 232 px, 3 lines).
The story's TM gifts and item balls give these items: pearl_story.py maps Pearl's item ids by move (tm_audit.pearl_item).
The save keeps its layout: the items existed (ids 505-529), the TM pocket holds 109 and Pearl gives 100 different
TM/HMs; PKHeX names them Data Cards.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402
import tm_audit  # noqa: E402

TEXT_JSON = os.path.join(ROOT, 'data', 'text_overrides', 'pearl_tms.json')
ITEM_TM01 = 328
PRICE, SORT_INDEX = 0, 0xF                       # a/0/2/4 record: u16 price (x10), u8 sort index


def item_files():
    """{item id: its res/items folder name} (the decomp's generated/items.txt order)."""
    names = [l.split('=')[0].strip() for l in open(os.path.join(tm_audit.DECOMP, 'generated', 'items.txt'))
             if l.strip() and not l.startswith('#')]
    assert names[0] == 'ITEM_NONE' and names[328] == 'ITEM_TM01', 'generated/items.txt: unexpected order'
    return {i: n[5:].lower() for i, n in enumerate(names)}


def pearl_prices():
    """{Pearl TM/HM label: price in Pokédollars} (pokediamond files/itemtool/itemdata/item_data.json)."""
    d = json.load(open(os.path.join(tm_audit.DIAMOND, 'files', 'itemtool', 'itemdata', 'item_data.json')))['item_data']
    return {e['name'][5:]: e['price'] for e in d if e['name'][5:7] in ('TM', 'HM')}


DESC_WIDTH, DESC_LINES = 232, 3                  # the Bag's description window (ov142 itemmenu_disp.c: 29 x 7 tiles,
                                                 # text from y 4: 3 lines of 16)


def wrap(text):
    """A move's description, written for the summary's window, kept as it is where it fits the Bag's (every move of
    TM96-TM120 does: widest line 231 px), else re-broken there (the same words)."""
    import b2font
    font = b2font.load(0)
    if len(text.split('\n')) <= DESC_LINES and all(font.width(l) <= DESC_WIDTH for l in text.split('\n')):
        return text
    lines = []
    for word in text.replace('\n', ' ').split():
        if lines and font.width(lines[-1] + ' ' + word) <= DESC_WIDTH:
            lines[-1] += ' ' + word
        else:
            lines.append(word)
    assert len(lines) <= DESC_LINES, f'{text!r}: {len(lines)} lines at {DESC_WIDTH} px'
    return '\n'.join(lines)


def text_lines():
    files = item_files()
    out = {'_doc': 'TM96-TM120 (b2tools/patches/pearl_tms.py writes this file: python3 pearl_tms.py --text): the names '
                   'of the items they replace (the Data Cards, Black 2\'s unused items) and Black 2\'s description of '
                   'each one\'s move, as Black 2\'s TMs have.'}
    for num, item, _, move, pearl in tm_audit.new_tms():
        desc = wrap(json.load(open(os.path.join(tm_audit.DECOMP, 'res', 'moves', move[5:].lower(), 'data.json'),
                                   encoding='utf-8'))['description'])
        out[f'res/items/{files[item]}/data.json'] = {'name': f'TM{num}', 'name_article': 'a',
                                                       'name_plural': f'TM{num}s', 'description': desc}
    return out


def check_text():
    want = json.dumps(text_lines(), ensure_ascii=False, indent=1) + '\n'
    assert os.path.exists(TEXT_JSON) and open(TEXT_JSON, encoding='utf-8').read() == want, \
        'data/text_overrides/pearl_tms.json is not current: python3 b2tools/patches/pearl_tms.py --text'


def apply(files):
    check_text()
    out = []
    # the items: Black 2 TM01's record, Pearl's price, sort index = bit
    items = narcio.load(files, tm_audit.ITEMS)
    vanilla = narcio.load(tm_audit.VANILLA_FILES, tm_audit.ITEMS)
    prices = pearl_prices()
    for num, item, bit, move, pearl in tm_audit.new_tms():
        r = bytearray(vanilla[ITEM_TM01])
        struct.pack_into('<H', r, PRICE, prices[pearl] // 10)
        r[SORT_INDEX] = bit
        assert items[item] in (vanilla[item], bytes(r)), f'item {item}: changed by another patch'
        items[item] = bytes(r)
    narcio.save(files, tm_audit.ITEMS, items)
    new = tm_audit.new_tms()
    out.append(f'items {new[0][1]}-{new[-1][1]} = TM{new[0][0]}-TM{new[-1][0]}')
    # the learners
    pers = narcio.load(files, tm_audit.PERSONAL)
    changed = 0
    for rec, bits in tm_audit.target_bits(pers):
        r = bytearray(pers[rec])
        words = list(struct.unpack_from('<4I', r, tm_audit.MACHINES))
        for b, on in bits.items():
            if on:
                words[b // 32] |= 1 << (b % 32)
            else:
                words[b // 32] &= ~(1 << (b % 32))
        struct.pack_into('<4I', r, tm_audit.MACHINES, *words)
        changed += bytes(r) != pers[rec]
        pers[rec] = bytes(r)
    narcio.save(files, tm_audit.PERSONAL, pers)
    out.append(f'machine bits of {changed} personal records (Pearl\'s for 1-493, the new TMs for Unova)')
    return 'pearl_tms: ' + '; '.join(out)


if __name__ == '__main__':
    if '--text' in sys.argv:
        open(TEXT_JSON, 'w', encoding='utf-8').write(json.dumps(text_lines(), ensure_ascii=False, indent=1) + '\n')
        print('wrote', os.path.relpath(TEXT_JSON, ROOT))
    else:
        print(__doc__)
