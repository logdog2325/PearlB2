"""The Elite Four rooms' doors (chapter 8, 2026-10-26; the lead: "Pearl's 3D door objects come back, closed until the
member is beaten"). List it after pearl_npc_sprites and pearl_amity_sprites (which also edit a/0/4/7 and a/0/4/8).

Pearl (pokeplatinum overlay005/object_event_gfx_data.c: OBJ_EVENT_GFX_ELITE_FOUR_ROOM_DOOR, graphics 209, is a 3D
object, MODEL_TYPE_3D, drawn by the renderer of Pearl's 3D objects (ov5_021EC734 -> ov5_021F121C), whose table gives
graphics 0xD1 the field-effect model 0x6E: data/mmodel/fldeff.narc member 110, "door2", a BMD0 with its textures):
each Elite Four room has two door objects: the entrance door behind the player, hidden until the room's entry scene
shuts it (AddObject), and the exit door, there until the member is beaten (RemoveObject). Both stand on their doorway
tile, which they block as people do.

Black 2's 3D-model actor codes (OBJ_CODE_MODEL_*, 0x2000-0x200A; type "model", a Nitro model in a/0/4/8) do the same:
an actor drawn as a 3D model, solid on its tile. GetIndexOfObjID only knows the codes up to 0x200A, so no new code:
OBJ_CODE_MODEL_2 (0x2002), a copy of the boulder's model that no Black 2 zone, script or code places (checked in the
decomp: res/field/events, res/field/scripts, src), gets Pearl's door model:
- a/0/4/8: Pearl's door2 appended (its index is the record's model resource);
- a/0/4/7: code 0x2002's record: a 1 x 1 model drawn as a 3D object (Black 2's MODEL_7 record: type 2, scene node
  12, fldmmdl_g3dobj_draw.c; no shadow, footprint or reflection; no offset), its model resource the new file, no other
  resources. (MODEL_0/1/2/4's own records have scene node 0, which draws nothing: the first install, 2026-10-26, was
  a copy of MODEL_1's, and the doors blocked but were invisible.)
data/pearl_sprite_map.json gives graphics 209 that code, so pearl_events installs the eight doors and the rooms'
scripts add and remove them as Pearl's do.
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio, sprites  # noqa: E402

FLDEFF = 'data/mmodel/fldeff.narc'
DOOR_MODEL = 110                   # Pearl's fldeff member 110 "door2" (Platinum's table: graphics 0xD1 -> 0x6E)
DOOR_GFX = 209                     # Pearl's OBJ_EVENT_GFX_ELITE_FOUR_ROOM_DOOR
CODE = 0x2002                      # OBJ_CODE_MODEL_2
TEMPLATE = 0x2007                  # OBJ_CODE_MODEL_7: a 1 x 1 model record Black 2 draws (scene node 12)
NO_RESOURCE = 0xFFFF


def door_model():
    from gen4rom import Rom, narc_members
    m = narc_members(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read(FLDEFF))[DOOR_MODEL]
    assert m[:4] == b'BMD0' and b'door2' in m[:0x100], 'Pearl fldeff 110 is not the door2 model'
    n = struct.unpack_from('<H', m, 0xE)[0]
    blocks = [m[struct.unpack_from('<I', m, 0x10 + 4 * k)[0]:][:4] for k in range(n)]
    assert blocks == [b'MDL0', b'TEX0'], blocks
    return m


def apply(files):
    import json
    smap = json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json')))
    assert smap[str(DOOR_GFX)]['code'] == CODE, 'data/pearl_sprite_map.json: graphics 209 is not OBJ_CODE_MODEL_2'
    assert not any(isinstance(v, dict) and v.get('code') == CODE for k, v in smap.items() if k != str(DOOR_GFX))
    sheets = narcio.load(files, sprites.ARC_OW_SHEETS)
    index = len(sheets)
    sheets.append(door_model())
    rec = narcio.load(files, sprites.ARC_OW_TABLE)
    t = bytearray(rec[0])
    at, src = (4 + 28 * sprites.obj_record(c) for c in (CODE, TEMPLATE))
    assert struct.unpack_from('<HB', t, at) == (CODE, 2), 'code 0x2002 is no longer a model record'
    assert struct.unpack_from('<HBBBBBBBBBBBbbb', t, src) == (TEMPLATE, 2, 12, 0, 0, 0, 0, 0, 0, 2, 1, 1, 0, 0, 0), \
        'code 0x2007 is no longer a 1 x 1 drawn model record'
    t[at + 2:at + 28] = t[src + 2:src + 28]
    struct.pack_into('<5H', t, at + 16, index, *(NO_RESOURCE,) * 4)
    rec[0] = bytes(t)
    narcio.save(files, sprites.ARC_OW_TABLE, rec)
    narcio.save(files, sprites.ARC_OW_SHEETS, sheets)
    return f'pearl_e4_doors: Pearl\'s door2 (fldeff 110) = a/0/4/8 file {index}, the model of code {CODE:#x}'


if __name__ == '__main__':
    print(len(door_model()), 'B; vanilla records',
          [struct.unpack_from('<HBBBBBBBBBBBbbbHHHHHH', narcio.load(os.path.join(ROOT, 'external', 'pokebw2', 'build',
                                                                                  'b2_us', 'files'), 47)[0],
                              4 + 28 * sprites.obj_record(c)) for c in (TEMPLATE, CODE)])
