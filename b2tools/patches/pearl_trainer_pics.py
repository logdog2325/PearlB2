"""Pearl's own trainer pictures for the 46 Pearl classes Black 2 does not have (b2tools/pearl_trainer_pics.py; notes/
TRAINERS.md "Pearl's trainer pictures"): appended to a/0/7/1 as NEW front sprites 188-233. Black 2's own 188 sprites
(files 0-1503) are not changed.

apply(files):
  - makes the 46 folders work/trainer_pics/<CLASS>/ from the Pearl dump if any is missing (pearl_trainer_pics.build)
  - appends 8 files per class to a/0/7/1: Black 2 front sprite 20's files (one still 80x80 cell; from Black 2's own
    archive, so an earlier patch that repaints sprite 20 does not matter), with the folder's still (+0), texture (+1)
    and 16 colours (+7) written in (sprites.tr_import)
  - writes work/world/trainer_pics.json {Pearl class name: new front sprite id}
  a/0/7/1 grows by about 112 KB (files + FAT), inside build_rom.py's RESERVE[71] (1 MB), so the ROM layout does not
  move. Run it before any patch that appends front sprites (sprite_switch): it refuses an archive that does not have
  exactly Black 2's 188 sprites, so the ids can never shift.

No apply_code: no trainer class points at the new sprites yet. A class shows one when its byte in arm9
TRAINER_CLASS_RESOURCES (0x02092394 + 4 * class, byte 0 = front sprite, a u8) is set to the id in trainer_pics.json
(pokebw2 src/system/tr_tool.c GetTrSpriteBaseDatID -> src/system/pokegra.c GetTrSprite*DatID: file = sprite * 8 + k).
The story phase does that when it installs the Sinnoh classes (as HoennB2's patches/trainers.py "edits" do).
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
B2T = os.path.dirname(HERE)
ROOT = os.path.dirname(B2T)
sys.path.insert(0, B2T)
import narcio  # noqa: E402
import pearl_trainer_pics as P  # noqa: E402

IDS_JSON = os.path.join(ROOT, 'work', 'world', 'trainer_pics.json')


def apply(files):
    made = ''
    if P.folders_missing():
        made = f' (made {P.build()} folders from the dump)'
    entries = narcio.load(files, P.ARC_FRONT)
    black2 = narcio.load(P.B2_FILES, P.ARC_FRONT)
    new = P.install(entries, black2)
    assert new[:len(entries)] == entries
    narcio.save(files, P.ARC_FRONT, new)
    ids = P.sprite_ids()
    os.makedirs(os.path.dirname(IDS_JSON), exist_ok=True)
    with open(IDS_JSON, 'w') as f:
        json.dump(ids, f, indent=1)
        f.write('\n')
    grow = sum(len(x) for x in new[len(entries):])
    return (f'pearl_trainer_pics: {len(ids)} Pearl pictures as front sprites {min(ids.values())}-{max(ids.values())} '
            f'(a/0/7/1 {len(entries)} -> {len(new)} files, +{grow} B){made}; ids in work/world/trainer_pics.json')
