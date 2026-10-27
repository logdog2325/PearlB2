"""Sinnoh's map look (notes/MAP_LOOK.md; decisions 2026-10-19): the fixes that patches/sinnoh_reskin.py applies by
default after it writes the texture sets, on the files sinnoh_world wrote (run sinnoh_reskin after sinnoh_world, as
the usual patch list does).

MAPLOOK_FIXES (environment, comma-separated) picks the fixes. Unset: DEFAULT. 'default' stands for DEFAULT, so
`MAPLOOK_FIXES=default,camera` is the default with Pearl's own camera in place of the tilt (the default since
2026-10-26: Black 2's camera tilted to Pearl's 59 degrees, the user's choice from the three-way comparison); 'none' turns everything off (the
re-skin of 2026-10-18 with Black 2's textures, for comparisons).
  pearl_art  textures (sinnoh_reskin.reskin_sets): Pearl's own textures and colours in spring and summer; in autumn
             and winter Pearl's own art recoloured with Black 2's seasonal colours (recolour.transfer_recolour), never
             Black 2's textures; the snowy north winter all year (Black 2's winter colours on Pearl's art)
  c0, refs, transfer, mismatch   the re-skin fixes for the older Black 2-texture style (implied by pearl_art)
  fog       the Sinnoh zones lose the zone fog Black 2 gave their Unova zone ids (a/0/8/0 file 29: Sandgem, Solaceon,
            Veilstone, Valor Lakefront, Route 224, ... were hazed 35-50 % towards sky blue in clear weather)
  light     every overworld area record uses Black 2's usual outdoor light tables, 140-143 by season (made from
            Pearl's data/area00light.txt), Pearl's outdoor outlines (all (4,4,4); was Black 2's table 0 until
            2026-10-20) and actor colours 1; building materials on IDs 56-63 move to group 6 (remap_ids). Hearthome/Route 208 had 148-151 (an
            evening light from below), edge marking off and actor colours 0; Routes 209-211E, 215, Solaceon, Celestic
            had 144-147 (other lights 1-3)
  lamps     Pearl's light 3 is a constant white light and its light 2 the windows' night glow; Black 2's light 3 is a
            dim (6,5,4) and its light 2 the sky colour. Materials lit only by light 3 (Jubilife's c1_o02b, Canalave's
            c2_light_a, Hearthome's c5_light on the map; lamps, signs, the fountain in the building models) were
            drawn at ~19 % brightness: now unlit at 25/31 (Pearl draws them at about 80 % by day), the building
            models' at their own ambient colour (Pearl: own ambient x its white light 3; the Centers' and Marts'
            signs, full colour). Unlit, their colour is the EMISSION (the GX starts each vertex at the emission at
            every NORMAL command and adds the enabled lights: with emission 0 they drew black on melonDS, 2026-10-20).
            Building materials lit by light 2 (windows, h_mado, Light) move to Black 2's light 1, its warm night-glow
            light.
  material  the overworld chunk models take their material colours from the field light, as Pearl's do
            (pokediamond ov05_021DB5EC clears the DIFFUSE/AMBIENT/SPECULAR/EMISSION flags of every map model; Black
            2's light tables 140-143 carry Pearl's own diffuse/ambient/specular/emission per time of day): Pearl's
            morning, evening and night shading (midday looks the same either way: the light saturates to white).
            Building models keep their own colours (2026-10-20): Pearl draws its props with them (map_prop.c), and
            the field's colours made the walls bluer (south walls (24,25,24) instead of Pearl's warm (19,19,16))
  camera    EXPERIMENTAL, only when named: a new camera record with Pearl's field camera (distance 667, 59 degrees
            down, vertical half-angle 8.09 degrees: Pearl's 1 texel = 1 pixel) for the overworld zones; Black 2's
            camera (237, 53.2, 20 degrees) magnifies the middle of the screen ~1.1x and the bottom ~1.35x, which makes
            Pearl's pixel art blocky and the top of the screen grainy. The rooms too (sinnoh_rooms): each room zone
            gets the camera of its own Pearl zone (PEARL_CAMERAS: Pearl's 16 field cameras; its orthographic room
            camera 4 as a perspective camera at Pearl's distance, angle and half-angle), and its camera boundary is
            sized for that camera. Near planes: PEOPLE_NEAR (not Pearl's 150: Black 2's people sank into the
            ground). Filmed in game 2026-10-25 against Black 2's camera (MAP_LOOK 1d; patches/camera_switch.py).
  tilt      EXPERIMENTAL, only when named (not with 'camera'; user 2026-10-25: "test Black 2's camera tilted to
            Pearl's angle"): Black 2's camera 0 exactly (237 away, half-angle 20, near 1, far 1024: its people, its
            3D look) with Pearl's pitch: 59 degrees on the overworld, each room its own Pearl camera's pitch
            (sinnoh_rooms; the boundary sized for it).
  b2_water  Black 2's water (sea, ponds, lakes, cave water) on Pearl's shapes, animated by Black 2's area SRT files
            (b2tools/b2_look.py: the chunk models in pearl_chunk.fix_model, the texture sets in sinnoh_reskin and
            sinnoh_rooms, the areas' SRT ids here and in sinnoh_rooms; user 2026-10-26)
  b2_grass  Black 2's grass01ax as the outdoor ground grass, by season, and Black 2's grass colours on Pearl's art with
            grass in it in spring and summer too (b2_look; sinnoh_reskin)
Every fix can run twice on the same files without changing anything more (a build without --clean).
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import narcio, zoneheaders  # noqa: E402
from b2files import gf_container, gf_container_build, arc_path  # noqa: E402

VANILLA = os.path.join(os.path.dirname(HERE), 'external', 'pokebw2', 'build', 'b2_us', 'files')

TEXTURE_FIXES = ('pearl_art', 'c0', 'refs', 'transfer', 'mismatch')
DEFAULT = ('pearl_art', 'fog', 'light', 'lamps', 'material', 'tilt',   # tilt: the user's camera (2026-10-26)
           'b2_water', 'b2_grass')                                      # the user's choice (2026-10-26, b2_look)
ALL = TEXTURE_FIXES + ('fog', 'light', 'lamps', 'material', 'camera', 'tilt', 'b2_water', 'b2_grass')
LIGHTS_OUTDOOR = 140                     # + season: Black 2's usual outdoor tables (spring 140 ... winter 143)
EDGE_OUTDOOR, ACTOR_COLOURS_OUTDOOR = 0, 1  # as on every other Sinnoh outdoor area record
ZONE_FOG_TABLE = (80, 29)                       # (archive, file): u16 zone, u16 fog file (src/system/zonedata.c)
CAMERA_ARC = 59                                 # ARCID_FIELD_CAMERA_DEFAULT, file 0: 44-byte FieldCameraDefaults
PEARL_CAMERA = dict(zoom=667, pitch=0x29FE, fov=0x05C1, near=8, far=1024)   # pokeplatinum field_camera.c default (near: PEOPLE_NEAR)
MATFLAG_GLOBAL = 0x0040 | 0x0080 | 0x0200 | 0x0400   # DIFFUSE, AMBIENT, SPECULAR, EMISSION: the material's own values
LAMP_GREY = 25 | 25 << 5 | 25 << 10                   # 'lamps': Pearl's light-3 materials, unlit at 25/31


def fixes():
    """The chosen fixes (MAPLOOK_FIXES, see above)."""
    names = os.environ.get('MAPLOOK_FIXES')
    if names is None: return DEFAULT
    chosen = []
    for n in (n.strip() for n in names.split(',')):
        if n == 'default': chosen += DEFAULT
        elif n and n != 'none': chosen.append(n)
    if 'camera' in chosen and 'tilt' in chosen:          # (default,camera: Pearl's camera in place of the tilt)
        chosen.remove('tilt')
    bad = set(chosen) - set(ALL)
    assert not bad, f'MAPLOOK_FIXES: unknown {sorted(bad)} (known: default, none, {", ".join(ALL)})'
    return tuple(dict.fromkeys(chosen))


def texture_fixes(chosen=None):
    return tuple(f for f in (fixes() if chosen is None else chosen) if f in TEXTURE_FIXES)


def apply_world_fixes(files, world, chosen=None):
    """The fixes that are not textures, on the files sinnoh_world wrote. Returns a report."""
    chosen = fixes() if chosen is None else chosen
    done = []
    if 'fog' in chosen:
        done.append(strip_zone_fog(files, world))
    if 'light' in chosen:
        done.append(outdoor_light(files, world))
    if 'lamps' in chosen or 'material' in chosen:
        done.append(relight(files, world, 'lamps' in chosen, 'material' in chosen))
    assert not ('camera' in chosen and 'tilt' in chosen), "MAPLOOK_FIXES: 'camera' or 'tilt', not both"
    if 'camera' in chosen:
        done.append(pearl_camera(files, world))
    if 'tilt' in chosen:
        done.append(tilt_camera(files, world))
    if 'b2_water' in chosen:
        done.append(water_srt(files, world))
    return '; '.join(done) or 'no map-look fixes'


def water_srt(files, world):
    """'b2_water': every overworld area record (four seasons) names Black 2's outdoor SRT animation file 0
    ('area_ita_00': its sea, pond and river materials scroll; b2_look gives Pearl's water those names). Areas 9, 12
    and 17 had Unova's 36, 37, 38 (not all of the water)."""
    import b2_look
    path = arc_path(files, 13)
    tab = bytearray(open(path, 'rb').read())
    changed = 0
    for a in world['areas'].values():
        for s in range(4):
            at = 10 * (a['b2_area_group'] + s) + 4
            changed += tab[at] != b2_look.SRT['outdoor']
            tab[at] = b2_look.SRT['outdoor']
    open(path + '.tmp', 'wb').write(tab); os.replace(path + '.tmp', path)
    return f'water SRT animation {b2_look.SRT["outdoor"]} on every overworld area ({changed} records changed)'


def sinnoh_zones(world):
    zones = {z['b2_zone'] for z in world['zones'].values()}
    zones |= {z['b2_zone'] for z in world.get('rooms', {}).get('zones', {}).values()}
    return zones


def strip_zone_fog(files, world):
    arc, member = ZONE_FOG_TABLE
    entries = narcio.load(files, arc)
    data = entries[member]
    ours = sinnoh_zones(world)
    keep = [data[k:k + 4] for k in range(0, len(data) - len(data) % 4, 4)
            if struct.unpack_from('<H', data, k)[0] not in ours]
    removed = len(data) // 4 - len(keep)
    entries[member] = b''.join(keep)
    narcio.save(files, arc, entries)
    return f'zone fog removed from {removed} Sinnoh zones'


def outdoor_light(files, world):
    edges = pearl_edges(files, False)      # Pearl's outdoor outlines, all (4,4,4) (2026-10-20: Black 2's table 0
    path = arc_path(files, 13)             # drew building outlines up to (24,24,24) by polygon ID group)
    tab = bytearray(open(path, 'rb').read())
    changed = 0
    for a in world['areas'].values():
        for s in range(4):
            at = 10 * (a['b2_area_group'] + s)
            want = (LIGHTS_OUTDOOR + s, edges, ACTOR_COLOURS_OUTDOOR)          # lightsId, edgeColorTableId,
            changed += tuple(tab[at + 7:at + 10]) != want                       # actorMatColorId
            tab[at + 7:at + 10] = bytes(want)
    open(path + '.tmp', 'wb').write(tab); os.replace(path + '.tmp', path)
    packs = narcio.load(files, 225)        # Black 2 draws IDs 56-63 (group 7) outlined in (16,16,16) whatever the
    nid = 0                                # table says: the buildings' move to group 6 (as the rooms', remap_ids)
    for a in world['areas'].values():
        magic, secs = gf_container(packs[a['b2_pack']])
        out = []
        for sec in secs:
            if sec[:4] == b'BMD0':
                sec, k = remap_ids(sec); nid += k
            out.append(sec)
        packs[a['b2_pack']] = gf_container_build(magic, out)
    narcio.save(files, 225, packs)
    return (f'light tables {LIGHTS_OUTDOOR}-{LIGHTS_OUTDOOR + 3} by season and Pearl\'s outdoor outlines (edge table '
            f'{edges}) on every overworld area ({changed} records changed; {nid} building materials off IDs 56-63)')


def _materials(bmd):
    """Offsets of every material record of every model in a BMD0."""
    nb = struct.unpack_from('<H', bmd, 0xE)[0]
    mdl = next(o for o in (struct.unpack_from('<I', bmd, 0x10 + 4 * k)[0] for k in range(nb))
               if bmd[o:o + 4] == b'MDL0')
    def dict_offsets(off):
        cnt = bmd[off + 1]
        tree = off + 4 + 8 + 4 * cnt
        unit = struct.unpack_from('<H', bmd, tree)[0]
        return [struct.unpack_from('<I', bmd, tree + 4 + unit * j)[0] for j in range(cnt)]
    out = []
    for mo in dict_offsets(mdl + 8):
        m = mdl + mo
        mat = m + struct.unpack_from('<I', bmd, m + 8)[0]
        out += [mat + o for o in dict_offsets(mat + 4)]
    return out


def relight_model(bmd, lamps=True, material=True, props=False):
    """(new BMD0 bytes, materials changed): Pearl's lighting set-up in Black 2 (same size; see 'lamps', 'material').
    props: a building pack's model. Pearl draws its props with their own material colours (pokeplatinum map_prop.c:
    NNS_G3dRenderObjInit, no material flags changed; ov05_021DB5EC clears them for the map's land models only), as
    Black 2 draws its own buildings: 'material' leaves them alone, and a lamp (light 3 only, Pearl's constant white
    light (31,31,31)) shows its own ambient colour (ambient x 31/31 on the faces that face the camera)."""
    b = bytearray(bmd)
    n = 0
    for at in _materials(bmd):
        flag = struct.unpack_from('<H', b, at + 30)[0]
        poly = struct.unpack_from('<I', b, at + 12)[0]
        if lamps and poly & 15 == 8:        # light 3 only: Pearl's constant white light (with Pearl's material
            diffamb = struct.unpack_from('<I', b, at + 4)[0]          # colours about 80 % by day) -> unlit at 25/31
            lamp = (diffamb >> 16) & 0x7FFF if props else LAMP_GREY   # (a prop: its own ambient, Pearl's colour)
            if not props:
                struct.pack_into('<I', b, at + 4, (diffamb & ~0x7FFF) | LAMP_GREY | 0x8000)
            struct.pack_into('<I', b, at + 12, poly & ~15)
            # The GX computes a vertex's colour at every NORMAL command: emission + each ENABLED light's terms
            # (GBATEK "DS 3D Polygon Light Parameters"; melonDS likewise). With no light enabled that is the emission
            # alone, and these shapes all carry normals: the emission must be the lamp's colour too (it was 0: Pearl's
            # Pokemon Center / Mart / Gym signs, the Center's door, ... drew black on melonDS, 2026-10-20). The own
            # diffuse (shapes without normals) and emission flags on.
            specemi = struct.unpack_from('<I', b, at + 8)[0]
            struct.pack_into('<I', b, at + 8, (specemi & ~(0x7FFF << 16)) | lamp << 16)
            struct.pack_into('<H', b, at + 30, flag | 0x0040 | 0x0400)
            n += 1
            continue                        # (keeps its own diffuse: the global one would halve it)
        if lamps and poly & 4:              # Pearl's light 2 (night glow) -> Black 2's light 1
            struct.pack_into('<I', b, at + 12, (poly & ~4) | 2)
        if material and poly & 15 and not props:   # (unlit materials keep their own colour: their only colour)
            struct.pack_into('<H', b, at + 30, flag & ~MATFLAG_GLOBAL)
        n += b[at:at + 32] != bmd[at:at + 32]
    return bytes(b), n


def relight(files, world, lamps, material):
    chunks = narcio.load(files, 8)
    n = 0
    for b2 in world['chunks'].values():
        magic, secs = gf_container(chunks[b2])
        model, k = relight_model(secs[0], lamps, material)
        chunks[b2] = gf_container_build(magic, [model] + secs[1:])
        n += k
    narcio.save(files, 8, chunks)
    packs = narcio.load(files, 225)
    nb = 0
    for a in world['areas'].values():
        magic, secs = gf_container(packs[a['b2_pack']])
        out = []
        for sec in secs:
            if sec[:4] == b'BMD0':
                sec, k = relight_model(sec, lamps, material, props=True); nb += k
            out.append(sec)
        packs[a['b2_pack']] = gf_container_build(magic, out)
    narcio.save(files, 225, packs)
    return (f'{"lamps " if lamps else ""}{"material " if material else ""}on {n} overworld map materials and '
            f'{nb} building materials')


# Pearl's 16 field cameras (pokediamond ov05_021F6608, 24-byte records: fx32 distance, u16 angle x (minus the pitch),
# projection, u16 vertical half-angle, fx32 near, fx32 far; pokeplatinum field_camera.c sCameraTypes has the same):
# {type: (distance, pitch idx, half-angle idx, near, far)}. Type 4 (most rooms) is orthographic in Pearl; Black 2's
# field camera is always perspective (fieldmap.c creates its G3D camera so; the records have no projection field), so
# it becomes a perspective camera at Pearl's distance, angle and half-angle: the same scale at the player, +-5 % from
# the bottom of the screen to the top (Pearl: none). Type 0 keeps PEARL_CAMERA's far plane (1024, the overworld).
# Near planes are NOT Pearl's (150): Black 2 draws people with a depth margin (fieldmap.c
# GetObjectProjectionMatrixOffset: m[3][2] + m[2][2] * 0x136) that scales with 1/near: 3.65 % of the distance at near
# 1 (camera 0: ~9 units at the player), ~0.2 units at near 150, where the people's lower part sank into the ground
# (legs cut in Jubilife, the player cut at the waist on the Cycling Road; in game 2026-10-25). near = 8 (d / 667)^2
# keeps camera 0's depth precision at the player (what the world pass's 2.25-unit layer gaps were made for) and
# gives people a margin of 3.2 units at 667 (whole again in game at near 8).
PEOPLE_NEAR = 8
PEARL_CAMERAS = {0: (666.922, 0x29FE, 0x05C1, 150, 1024), 1: (666.922, 0x309E, 0x05C1, 150, 900),
                 2: (515.456, 0x26DE, 0x0770, 150, 900), 3: (666.922, 0x29FE, 0x05C1, 150, 900),
                 4: (1563.538, 0x239E, 0x0281, 150, 1735), 5: (316.501, 0x29FD, 0x0C01, 10, 1008),
                 6: (866.554, 0x33FD, 0x0481, 115, 1221), 7: (666.922, 0x29FD, 0x05C1, 153, 1031),
                 8: (662.922, 0x321D, 0x0701, 150, 1034), 9: (357.604, 0x1CDD, 0x0AB0, 150, 900),
                 10: (1202.356, 0x2B3D, 0x0341, 150, 1746), 11: (675.833, 0x291D, 0x05C1, 230, 1127),
                 12: (574.578, 0x2CFD, 0x06C1, 150, 900), 13: (515.456, 0x21FD, 0x0770, 150, 900),
                 14: (169.462, 0x37BC, 0x1501, 10, 1008), 15: (653.929, 0x26DE, 0x05F0, 150, 900)}
VANILLA_CAMERAS = 45                    # a/0/5/9 file 0: Black 2's 45 records of 44 bytes


def pearl_camera_bytes(files, ptype):
    """The 44-byte Black 2 camera record (FieldCameraDefaults) for Pearl's camera type: Black 2's standard field camera
    (record 0: bound to the player, target 4 units up, Z-buffer) with Pearl's distance, pitch, half-angle and far plane,
    and the near plane PEOPLE_NEAR gives."""
    rec = bytearray(narcio.load(files, CAMERA_ARC)[0][0:44])
    dist, pitch, fov, _pearl_near, far = PEARL_CAMERAS[ptype]
    near = max(1, round(PEOPLE_NEAR * (dist / 666.922) ** 2))
    struct.pack_into('<iII', rec, 0, round(dist), pitch, 0)
    struct.pack_into('<H', rec, 18, fov)
    struct.pack_into('<ii', rec, 20, near << 12, far << 12)
    return bytes(rec)


def pearl_camera_record(files, ptype):
    """Index of the camera record for Pearl's camera type `ptype` in a/0/5/9 (appended once)."""
    return _record_index(files, pearl_camera_bytes(files, ptype))


def _record_index(files, rec):
    """Index of the 44-byte camera record rec in a/0/5/9 (appended once; a build without --clean finds it again)."""
    entries = narcio.load(files, CAMERA_ARC)
    data = entries[0]
    for k in range(VANILLA_CAMERAS, len(data) // 44):
        if data[44 * k:44 * k + 44] == rec: return k
    entries[0] = data + rec
    narcio.save(files, CAMERA_ARC, entries)
    return len(data) // 44


def tilted_camera_record(files, pitch):
    """Index of Black 2's camera 0 with only its pitch changed ('tilt')."""
    rec = bytearray(narcio.load(files, CAMERA_ARC)[0][0:44])
    struct.pack_into('<I', rec, 4, pitch)
    return _record_index(files, bytes(rec))


def room_camera(files, ptype, chosen):
    """The camera record for a room whose Pearl zone has camera type ptype: Pearl's ('camera'), Black 2's camera 0
    at that camera's pitch ('tilt'), or None (the template's: Black 2's camera 0)."""
    if 'camera' in chosen: return pearl_camera_record(files, ptype)
    if 'tilt' in chosen: return tilted_camera_record(files, PEARL_CAMERAS[ptype][1])
    return None


def tilt_camera(files, world):
    index = tilted_camera_record(files, PEARL_CAMERAS[0][1])
    headers, zentries = zoneheaders.load(files)
    zones = {z['b2_zone'] for z in world['zones'].values()}
    for z in zones:
        w = headers[z]['weather_word']
        headers[z]['weather_word'] = (w & ~(0x7F << 9)) | (index << 9)
    zoneheaders.save(files, headers, zentries)
    return f'EXPERIMENTAL tilted Black 2 camera = record {index}, on {len(zones)} overworld zones'


def pearl_camera(files, world):
    index = pearl_camera_record(files, 0)               # (PEARL_CAMERA)
    headers, zentries = zoneheaders.load(files)
    zones = {z['b2_zone'] for z in world['zones'].values()}
    for z in zones:
        w = headers[z]['weather_word']
        headers[z]['weather_word'] = (w & ~(0x7F << 9)) | (index << 9)      # defaultCameraIndex (7 bits)
    zoneheaders.save(files, headers, zentries)
    return f'EXPERIMENTAL Pearl camera = record {index}, on {len(zones)} overworld zones'


# ------------------------------------------------------------------------------------- rooms: Pearl's light and edges
# (the world pass, 2026-10-20) Pearl lights a map with one of two tables by its area data's u16 at 6 (pokediamond
# ov05_021F4CBC: 0 -> data/area01light.txt, constant: light 0 (23,23,25), light 2 (4,4,16), materials diffuse 16,
# ambient 14, specular 20, emission 16; else data/area00light.txt, the day's cycle, which Black 2's tables 140-143
# carry) and draws outlines with ov05_021FC624 (indoor: ID group 0 black, the rest (4,4,4)) or ov05_021FC634 (outdoor:
# all (4,4,4)). The rooms took Black 2's interior table 132 (light 2 = the sky colour, (17,29,31) by day) and edge
# table 1 (groups 0-6 from black to (24,24,24); Black 2 forces group 7, IDs 56-63, to (16,16,16)).
LIGHT_ARC, EDGE_ARC = 60, 15                   # a/0/6/0 FieldLightEntry tables, a/0/1/5 edge colour tables
B2_ROOM_LIGHTS = 132                            # Black 2's interior table: its time-of-day entries are copied
PEARL_EDGES_INDOOR = [0x0000] + [0x1084] * 7
PEARL_EDGES_OUTDOOR = [0x1084] * 8
ID_REMAP = {56: 52, 57: 53, 58: 54, 59: 49, 60: 50, 61: 51, 62: 49, 63: 55}   # (group 7 -> unused IDs of group 6)


def _append_once(files, arc, data, vanilla_count):
    """Index of `data` in archive arc: an entry appended earlier (a build without --clean), else appended now."""
    entries = narcio.load(files, arc)
    for i in range(vanilla_count, len(entries)):
        if entries[i] == data: return i
    entries.append(data)
    narcio.save(files, arc, entries)
    return len(entries) - 1


def pearl_light_entries(rom, name='data/area01light.txt'):
    """Pearl's light file as [(end time, [(on, (r, g, b), (dx, dy, dz))] * 4, [diffuse, ambient, specular, emission])]."""
    out = []
    import re
    for block in re.split(r'\r?\n\s*\r?\n', rom.read(name).decode('ascii').strip()):
        nums = [int(x) for x in re.split(r'[,\s]+', block) if x.strip() and x.strip() != 'EOF']
        if len(nums) < 41: continue
        t, rest = nums[0], nums[1:]
        lights = [(rest[7 * i], tuple(rest[7 * i + 1:7 * i + 4]), tuple(rest[7 * i + 4:7 * i + 7])) for i in range(4)]
        mats = [tuple(rest[28 + 3 * i:31 + 3 * i]) for i in range(4)]
        out.append((t, lights, mats))
    return out


def _rgb15(c):
    return c[0] | c[1] << 5 | c[2] << 10


def pearl_indoor_light_data(rom):
    """A Black 2 light table made of Pearl's constant indoor light (area01light) (bytes)."""
    vanilla = narcio.load(VANILLA, LIGHT_ARC)
    src = vanilla[B2_ROOM_LIGHTS]
    _, lights, mats = pearl_light_entries(rom)[0]
    out = bytearray()
    for k in range(len(src) // 52):
        e = bytearray(src[52 * k:52 * k + 52])
        for i, (on, col, d) in enumerate(lights):
            e[4 + i] = 1 if on else 0
            struct.pack_into('<H', e, 8 + 2 * i, _rgb15(col))
            struct.pack_into('<3h', e, 16 + 6 * i, *d)
        for i, c in enumerate(mats):
            struct.pack_into('<H', e, 40 + 2 * i, _rgb15(c))       # (fog colour and clear colour: Black 2's, black)
        out += e
    return bytes(out)


def pearl_indoor_lights(files, rom):
    """Index of a Black 2 light table made of Pearl's constant indoor light (area01light) in a/0/6/0."""
    return _append_once(files, LIGHT_ARC, pearl_indoor_light_data(rom), len(narcio.load(VANILLA, LIGHT_ARC)))


# (2026-10-25, notes/MAP_LOOK.md "Rooms: the void past the edge") Black 2 clears the screen with the light table's
# 6th colour, opaque (field_light.c FieldLight_FlushCore: G3X_SetClearColor(materials[5], 31, ...)): tables 140-143
# clear to the sky colour by day ((16,24,30); evening (31,24,15), night (8,3,18)). Pearl clears to black with alpha 0
# over its black backdrop (pokeplatinum easy3d.c Easy3D_SetupEngine). The outdoor rooms (lakes, Eterna Forest, Floaroma
# Meadow, ...) took 140-143, so wherever Black 2's wider camera sees past the map's edge it showed sky where Pearl's
# void is black.
CLEAR_AT = 50                                   # FieldLightEntry: u16 colour 5 of materials[] (the clear colour)


def outdoor_room_light_data(season):
    """Black 2's outdoor table for the season (LIGHTS_OUTDOOR + season, Pearl's day cycle), clearing to black (bytes)."""
    e = bytearray(narcio.load(VANILLA, LIGHT_ARC)[LIGHTS_OUTDOOR + season])
    for k in range(len(e) // 52):
        struct.pack_into('<H', e, 52 * k + CLEAR_AT, 0)
    return bytes(e)


def outdoor_room_lights(files):
    """[index per season] of the outdoor rooms' light tables (outdoor_room_light_data) in a/0/6/0."""
    n = len(narcio.load(VANILLA, LIGHT_ARC))
    return [_append_once(files, LIGHT_ARC, outdoor_room_light_data(s), n) for s in range(4)]


def room_light_tables(rom, day_light):
    """The light tables (bytes) sinnoh_rooms gives a room area: Pearl's indoor light, or for an area on Pearl's day
    cycle the four seasons' outdoor tables clearing to black."""
    if 'light' not in fixes(): return []                 # (the template areas' own tables: not known here)
    return [outdoor_room_light_data(s) for s in range(4)] if day_light else [pearl_indoor_light_data(rom)]


def pearl_edges(files, indoor):
    vanilla = narcio.load(VANILLA, EDGE_ARC)
    data = struct.pack('<8H', *(PEARL_EDGES_INDOOR if indoor else PEARL_EDGES_OUTDOOR))
    return _append_once(files, EDGE_ARC, data, len(vanilla))


def remap_ids(bmd):
    """(new BMD0 bytes, materials changed): opaque materials' polygon IDs 56-63 moved to unused IDs of group 6, whose
    edge colour the area's table sets (Black 2 draws group 7's outlines (16,16,16) whatever the table says)."""
    b = bytearray(bmd); n = 0
    for at in _materials(bmd):
        poly = struct.unpack_from('<I', b, at + 12)[0]
        pid, alpha = (poly >> 24) & 63, (poly >> 16) & 31
        if alpha == 31 and pid in ID_REMAP:
            struct.pack_into('<I', b, at + 12, (poly & ~(63 << 24)) | ID_REMAP[pid] << 24); n += 1
    return bytes(b), n
