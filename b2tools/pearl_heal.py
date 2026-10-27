"""Pearl's Pokémon Center healing machine, as Black 2's heal finds it (2026-10-25: the heal at Sandgem's Center froze in
melonDS; Black 2's heal found no machine in Pearl's Centers).

**Black 2** (pokebw2 src/ov033/event_pokemon_center.c): PokecenPlayHealingSequence looks for the first prop of type 3
(FieldPropResInfo_GetTypeConv: info record type 6) within 5 tiles of the player and puts one ball prop (resource id
0x62, hard-coded) per Pokémon at that machine's position + POKECEN_HEAL_MONSBALL_POSITIONS, one every 15 frames. Then
it plays animation 0 of the machine and of the balls with the heal ME (1300), waits until the balls' animation has
ended and brings the BGM back (EventPushBGMFinish).
**Pearl** (pokeplatinum src/overlay006/healing_machine_animation/pokecenter.c; Diamond/Pearl's is the same): the
machine is machine_pc02 (build model 123), the balls pc_mb (517; BTP0 animation bm_anime 31: pc_mb.1-4, 68 frames) at
the machine + (+-4.5, 12, -4.5 / 0 / +4.5), the screen machine_pc03 (124) plays its own BTP0 (32) with them.
**Before this**, every Pearl model had a plain record (pearl_buildings.PLAIN_INFO): no machine was found, the "balls"
were the pack's model with id 0x62 (poster01, Pearl's poster) at the map's corner, static, so the heal popped the ME
5 frames after it started (DeSmuME RAM, work/agents/heal).
**Now**: machine_pc02's record is a heal machine (type 6; static: Pearl's machine has no animation of its own) and
pc_mb's is Black 2's ball record (dynamic, one BTP0, Black 2's tool id 0x27) with Pearl's animation, as resource 0x62
(data/sinnoh_world.json rooms building_res: 517 -> 98, swapped with poster01); its other frames (pc_mb.2-4 and
palettes) join the pack's texture set. The ball positions are Pearl's in the decomp (event_pokemon_center.c,
#if PEARLB2). Not ported: the screen's animation (Black 2 plays the one machine prop's).
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

MACHINE, BALL = 123, 517            # Pearl build models machine_pc02, pc_mb
BALL_RES = 0x62                     # EventPokeCenHeal_SpawnMonsBall's resource id
HEAL_MACHINE_TYPE = 6               # info record type -> GetTypeConv 3: what EventPokeCenHeal_Init looks for
B2_BALL_ANIM_ID = 0x27              # Black 2's own ball record's tool id (word 0x0c; the game never reads it)
DYNAMIC, NONE = 2, 0xFFFFFFFF

_P = {}


def _pearl():
    if not _P:
        import pearl_doors
        p = pearl_doors.pearl()
        _P['by_bytes'] = {bytes(p['build'][m]): m for m in (MACHINE, BALL)}
        ids = struct.unpack_from('<4i', p['list'][BALL], 4)
        _P['ball_anim'] = p['anime'][ids[0]]
        assert _P['ball_anim'][:4] == b'BTP0', _P['ball_anim'][:4]
    return _P


def info(res_id, bmd):
    """pearl_buildings.build_pack's hook: the machine's or the ball's record (by the model's bytes), else None."""
    if os.environ.get('PEARL_HEAL_MACHINE') == '0': return None
    model = _pearl()['by_bytes'].get(bytes(bmd))
    if model == MACHINE:
        head = struct.pack('<HHHhhhHH', res_id, HEAL_MACHINE_TYPE, 0xFFFF, 0, 0, 0, 0xFFFF, 0)
        return head + struct.pack('<BBBB4I', 0, 0, 0, 0, NONE, NONE, NONE, NONE)
    if model == BALL:
        assert res_id == BALL_RES, f'pc_mb has resource id {res_id:#x}: the heal puts {BALL_RES:#x} on the machine'
        anim = _pearl()['ball_anim']
        head = struct.pack('<HHHhhhHH', res_id, 0, 0xFFFF, 0, 0, 0, B2_BALL_ANIM_ID, 0)
        rec = head + struct.pack('<BBBB4I', DYNAMIC, 0, 1, 1, 0x14, NONE, NONE, NONE) + anim
        return rec + bytes(-len(rec) % 4)
    return None


def extra_textures(bmd):
    """[(BTX0, texture, palette)] the ball's animation shows besides its material's texture (pc_mb.2-4), else []."""
    if os.environ.get('PEARL_HEAL_MACHINE') == '0': return []
    if _pearl()['by_bytes'].get(bytes(bmd)) != BALL: return []
    import nsbtx, pearl_buildings
    src = pearl_buildings.btx0_of(bmd)
    t = nsbtx._parse(src)
    pals = {n for n, _ in t['pals']}
    used = {tx for tx, _ in nsbtx.material_pairs(bmd)}
    return [(src, n, n + '_pl' if n + '_pl' in pals else None) for n, _ in t['texs'] if n not in used]
