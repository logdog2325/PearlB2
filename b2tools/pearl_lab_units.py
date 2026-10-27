"""Pearl's containment units in the Galactic HQ lab (build model 496, d26_o02), as Black 2 props that open (2026-10-26,
chapter 7; the lead: "port Pearl's prop animation ... so the trio don't walk out of closed units").

**Pearl** (pokeplatinum src/overlay006/lake_guardian_containment_units.c; Diamond's ov06 is the same, bm_anime_list
entry of model 496: animations 48, 49): a unit is a capsule whose middle is a small chamber (floor 20 units up, back
wall, side walls) behind a curved orange glass (shape 3, d26_o02c, A3I5: alpha 72-255 of 255, on node 1). Animation
48 (BTA0) scrolls the glass's band, looping; 49 (BCA0, 3 frames) moves the glass 6.5 forward and shrinks it to
nothing (node 1: TZ 0 -> 6.5, SY and SZ 1 -> 0.3 -> 0). Every placement of the model shares the two animations.
InitLakeGuardianContainmentUnits (the lab's on-resume script): before the release, 48 loops and 49 waits on frame 0;
after it (FLAG_FREED_GALACTIC_HQ_POKEMON, Pearl 0x97D), 48 is paused and 49 shows its last frame (no glass).
DeactivateLakeGuardianContainmentUnits (the button): waits for 48's loop to end, pauses it, plays 49 once and waits.
The trio float in the chamber (their sprites 24 units up: patches/pearl_npc_sprites FLOAT_Y) and come out through
the opening.
**Black 2** (pokebw2 ov036 field_buildmodel.c, scrcmd_buildmodel.c): a prop's animations play by its info record's
controller; the dynamic one (2) plays an animation on a command: play once (0), backwards (1), loop (2), pause (3),
stop all (4); one command stops the others. Every placement of a resource draws one shared instance; a handle
(BMCreateHandleByGPos, level 0 only) takes one placement out with its own instance. Scripts find a prop by its
record's type (FieldPropResInfo_GetTypeConv) within 2 tiles (x) and 3 (z) of a tile.
**So:** model 496's record is a dynamic prop of type 12 (kind 9: no Black 2 code looks for it; doors 1, heal 3, PCs
2/4, Hall of Fame 8) with Pearl's animation 49 as its animation 0. The button (level 0): a handle per unit, each
plays 0 once, wait; then the shared instance is set to the last frame (BMAnmPlayInv: backwards from the end, paused)
and the handles go: the units stay open. On resume after the release (level 1 allows BMAnmPlayInv): the shared
instance on its last frame. Not ported: the band's scroll (48): Black 2's commands for a placement in the chunk reach
its animation 0 only (BMAnmPlayLoop / BMAnmPlayInv), and the opening must be that one.
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

UNIT = 496                      # Pearl build model d26_o02 (pokeplatinum lake_guardian_containment_unit)
PROP_TYPE = 12                  # info record type -> FieldPropResInfo_GetTypeConv 9
PROP_KIND = 9                   # what BMCreateHandleByGPos / BMAnmPlayInv filter on
OPEN = 1                        # bm_anime_list entry 1 of model 496 (bm_anime 49, BCA0); entry 0 is the band (48)
DYNAMIC, NONE = 2, 0xFFFFFFFF
HANDLE_TAGS = (13, 14, 15)      # pearl_story.inc PL_DOOR tags of the units' handles (works 0x8055-0x8057)

_P = {}


def _pearl():
    if not _P:
        import pearl_doors
        p = pearl_doors.pearl()
        _P['bytes'] = bytes(p['build'][UNIT])
        ids = struct.unpack_from('<4i', p['list'][UNIT], 4)
        _P['open'] = p['anime'][ids[OPEN]]
        assert _P['open'][:4] == b'BCA0', _P['open'][:4]
    return _P


def info(res_id, bmd):
    """pearl_buildings.build_pack's hook: the unit's record (by the model's bytes), else None."""
    if os.environ.get('PEARL_LAB_UNITS') == '0': return None
    if bytes(bmd) != _pearl()['bytes']: return None
    anim = _pearl()['open']
    head = struct.pack('<HHHhhhHH', res_id, PROP_TYPE, 0xFFFF, 0, 0, 0, 0, 0)
    rec = head + struct.pack('<BBBB4I', DYNAMIC, 0, 1, 1, 0x14, NONE, NONE, NONE) + anim
    return rec + bytes(-len(rec) % 4)


_TILES = {}


def tiles(matrix_id):
    """[(x, z)] tiles to find each unit of Pearl matrix matrix_id by (the tile its origin is on: the search box is
    2 tiles either side in x, 3 in z), in Pearl's prop order."""
    if matrix_id not in _TILES:
        from patches import sinnoh_events
        pl = sinnoh_events.Planner()
        m = pl.matrix(matrix_id)
        out = []
        for cz in range(m['height']):
            for cx in range(m['width']):
                c = m['maps'][cz][cx]
                if c == 0xffff: continue
                for p in pl.land(c)['props']:
                    if p['model'] == UNIT:
                        x, _, z = p['pos']
                        out.append((int((cx * 512 + 256 + x) // 16), int((cz * 512 + 256 + z) // 16)))
        _TILES[matrix_id] = out
    return _TILES[matrix_id]
