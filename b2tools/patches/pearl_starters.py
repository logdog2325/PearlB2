"""Pearl's starters on Black 2's starter screen (overlay 316, `callPoke3Select`), for Lake Verity's briefcase
(notes/STORY.md; src/include/pearl_story.inc pl_StartChooseStarterScene).

Code: the three species the screen shows (silhouette, name, cry) are pokebw2 src/ov316/psel.c sPselSpecies =
arm9_ov316.bin offset 0x2C14 (Snivy 495, Tepig 498, Oshawott 501; HoennB2 notes/RESEARCH_STORY_SPRITES.md) -> Turtwig
387, Chimchar 390, Piplup 393: left/middle/right = grass/fire/water, the same order as Pearl's briefcase index 0/1/2
(pokediamond overlay 64 ov64_021D9044: 0 Turtwig, 1 Chimchar, 2 Piplup), which the script maps to the species.
The captions (script text 169 lines 35-42: "The Grass-type Pokémon ...") name the type and the species from the table.

Files (a/2/0/2, b2tools/psel_art.py, from HoennB2): the coloured picture shown when a ball is picked is stored per
ball -> Turtwig/Chimchar/Piplup's Black 2 front stills at 2x with their palettes; Bianca, who holds the case, is taken
out of the 3D scene: what is left is a briefcase with three balls, as Pearl's. Same file sizes (the ROM layout stays).
"""
import os, sys

AT = 0x2C14
OLD = bytes.fromhex('ef01f201f501')
NEW = bytes.fromhex('830186018901')        # 387, 390, 393


def apply_code(code):
    path = os.path.join(code, 'arm9_ov316.bin')
    data = bytearray(open(path, 'rb').read())
    assert data[AT:AT + 6] in (OLD, NEW), data[AT:AT + 6].hex()
    data[AT:AT + 6] = NEW
    if os.path.islink(path):
        os.unlink(path)
    open(path, 'wb').write(data)
    return 'starter screen: Turtwig, Chimchar, Piplup'


def apply(files):
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    import narcio, psel_art
    psel = narcio.load(files, psel_art.ARC_PSEL)
    new = psel_art.hoenn_entries(psel, narcio.load(files, psel_art.ARC_POKEGRA))
    for k, v in new.items():
        psel[k] = v
    narcio.save(files, psel_art.ARC_PSEL, psel)
    return f'starter screen art: Turtwig/Chimchar/Piplup pictures, no Bianca (a/2/0/2 files {sorted(new)})'
