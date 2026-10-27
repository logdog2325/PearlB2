"""Pearl's hidden paths as Black 2 map replacements (2026-10-26, chapter 9a; notes/STORY.md "Chapter 9a").

Pearl (pokediamond arm9/src/map_matrix.c, called by the map loader, unk_02048904.s):
- sub_02034678: while hidden location 2 (the Spring Path) is NOT set, matrix 0's cells (23, 21) (24, 21) (23, 22)
  (24, 22) show map 176 (the mountain) at altitude 2: the Spring Path stays closed until Rowan's National Pokédex scene
  (Sandgem lab, or the Hall of Fame after it) runs SetHiddenLocation 2.
- sub_020346CC: once hidden location 3 (the Seabreak Path) is set, Route 224's cells (28, 15) (27, 16) (28, 16) (27, 17)
  show maps 119-122 instead of 115-118: the path north of the stone tablet opens, with its flowers (Oak's Letter's scene,
  SetHiddenLocation 3). The Seabreak Path itself (Pearl zone 472, "Route 231") and Flower Paradise are in the world.
Black 2 (pokebw2 src/ov012/map_replace.c, map_matrix.c MapMatrix_Patch, run on every map change and by the script
command MapReplaceSetEvent uid, set, reload): a/0/1/0 file 0 holds 16-byte entries (u16 matrix id, u8 kind 0 = swap a
chunk id, u8 condition, u16 values[6]); for an event condition the matrix's cells holding values[0] show values[1]
while that event is set. Events are works with a magic value (EVENT_MAP_REPLACE_TABLE: uid 7 = work 0x4038 == 0x408,
condition 10; uid 9 = work 0x403A == 0x1028, condition 12, the same magic number as Pearl's own Seabreak flag);
nothing in Sinnoh uses those works (pearl_ids FREE_WORKS leaves 0x4031-0x403A out), and Black 2's own entries with
event conditions name Unova chunks only.
So: 'reveal' paths (Seabreak) get the revealed maps as new chunks and an entry old -> new each; 'hide' paths (Spring)
get the hiding map converted at each cell as a new chunk, matrix 0's cell set to it, and an entry new -> the cell's own
chunk. patches/pearl_paths.py builds them (after sinnoh_rooms: the new chunks go after every room's); the
script side is pearl_story.inc pl_SetHiddenLocation.
"""
import json, os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))

PATHS = [
    dict(name='seabreak', place=3, event=9, condition=12, mode='reveal',
         cells={(28, 15): 119, (27, 16): 120, (28, 16): 121, (27, 17): 122}),
    dict(name='spring', place=2, event=7, condition=10, mode='hide',
         cells={(23, 21): 176, (24, 21): 176, (23, 22): 176, (24, 22): 176}),
]
# People who stand where only the revealed map has ground take its height (the converted map under them is the
# closed one): Route 224's Shaymin (object 16 at (911, 480)) walks down the opened path in Oak's Letter's scene. On the
# closed map its tile is 8 units (the sea's level), on the open one 44: two levels apart, Black 2 would not draw it.
OBJECTS = {('MAP_ROUTE_224', 16): 'seabreak'}
HEIGHTS = os.path.join(ROOT, 'work', 'world', 'heights_hidden.json')   # {path name: {"x,z" (world tile): y}}


def object_y(zone_name, obj, y):
    """A person's height in units: on a revealed path's tile (OBJECTS) the revealed map's (written by the patch), else
    y. Without the patch's heights (not in the build) y."""
    path = OBJECTS.get((zone_name, obj['id']))
    if path is None or not os.path.exists(HEIGHTS):
        return y
    return json.load(open(HEIGHTS)).get(path, {}).get(f"{obj['x']},{obj['z']}", y)
