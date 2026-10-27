"""TEST ONLY (the camera comparison, 2026-10-25): switch a built ROM between Pearl's field cameras and Black 2's with a
quick non-clean build, so both can be filmed from one full build (notes/MAP_LOOK.md 1d, "Pearl's camera in game").

    MAPLOOK_FIXES=default,camera build_rom.py camera_switch test_story_start    Pearl's cameras
    MAPLOOK_FIXES=default,tilt   build_rom.py camera_switch test_story_start    Black 2's camera 0 at Pearl's pitch
    MAPLOOK_FIXES=default        build_rom.py camera_switch test_story_start    Black 2's camera 0 (the normal build)

It sets every Sinnoh zone's default camera (zone header weather word, bits 9-15) and, for the rooms, the camera
boundary sized for that camera:
- overworld zones: Pearl's camera 0 (maplook.pearl_camera's record) or Black 2's camera 0 (zone_flags' ROUTE_CAMERA);
- rooms: the camera of the room's own Pearl zone (maplook.pearl_camera_record: Pearl's 16 cameras; camera 4, Pearl's
  orthographic room camera, as a perspective camera at Pearl's distance, angle and half-angle) or the camera of the
  Black 2 template zone sinnoh_rooms copies (camera 0 for all three);
- the rooms' boundaries as sinnoh_rooms makes them (the target stops where the screen's bottom row reaches the map's
  south edge), from the south edges of the installed room models and the chosen camera.
Running it twice changes nothing more; it appends camera records and boundaries only once each.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders, maplook, pearl_mesh  # noqa: E402
from b2files import gf_container  # noqa: E402
import sinnoh_rooms  # noqa: E402

CAM_SHIFT, CAM_MASK = 9, 0x7F


def room_south(files, rooms):
    """{Pearl room zone id: the south edge (world units, z) of its installed map models}, as sinnoh_rooms measures
    it (the converted chunk's model: its largest z, per matrix row)."""
    chunks = narcio.load(files, 8)
    extent = {}
    for c, b2 in rooms['chunks'].items():
        magic, secs = gf_container(chunks[b2])
        mm = pearl_mesh.Model(secs[0])
        zs = [mm.units(v)[2] for sh in mm.shapes for poly in sh.polys for v in poly]
        if zs: extent[int(c)] = max(zs)
    out = {}
    for pid, r in rooms['zones'].items():
        m = sinnoh_rooms.load_matrix(r['pearl_matrix'])
        south = [cz * 512 + 256 + extent[c] for cz, row in enumerate(m['maps']) for c in row if c in extent]
        if south: out[int(pid)] = max(south)
    return out


def apply(files):
    fixes = maplook.fixes()
    mode = 'Pearl' if 'camera' in fixes else 'tilted Black 2' if 'tilt' in fixes else 'Black 2'
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    rooms = world['rooms']
    pzones = {z['id']: z for z in json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))}
    vanilla, _ = zoneheaders.load(sinnoh_rooms.VANILLA)
    headers, entries = zoneheaders.load(files)

    def set_cam(hd, index):
        w = hd['weather_word']
        hd['weather_word'] = (w & ~(CAM_MASK << CAM_SHIFT)) | (index << CAM_SHIFT)

    over = (maplook.pearl_camera_record(files, 0) if 'camera' in fixes else
            maplook.tilted_camera_record(files, maplook.PEARL_CAMERAS[0][1]) if 'tilt' in fixes else 0)
    for z in world['zones'].values():
        set_cam(headers[z['b2_zone']], over)

    south = room_south(files, rooms)
    bounds = narcio.load(files, sinnoh_rooms.CAMERA_BOUNDS_ARC)
    nvanilla = len(narcio.load(sinnoh_rooms.VANILLA, sinnoh_rooms.CAMERA_BOUNDS_ARC))
    used, kinds = set(), {}
    for pid, r in rooms['zones'].items():
        pz = pzones[int(pid)]
        hd = headers[r['b2_zone']]
        cam = maplook.room_camera(files, pz['camera'], fixes)
        if cam is None:
            tmpl = vanilla[sinnoh_rooms.TEMPLATE_ZONE.get(pz['map_type'], 441)]
            cam = (tmpl['weather_word'] >> CAM_SHIFT) & CAM_MASK
        set_cam(hd, cam)
        kinds[cam] = kinds.get(cam, 0) + 1
        if int(pid) in south:
            below = sinnoh_rooms.camera_below(files, cam)
            rect = struct.pack('<I', 1) + struct.pack('<6i', 1, 0, -100000, 100000, -100000,
                                                      int(south[int(pid)] - below))
            i = next((k for k in range(nvanilla, len(bounds)) if bounds[k] == rect), None)
            if i is None: bounds.append(rect); i = len(bounds) - 1
            hd['cam_bound'] = i
            used.add(i)
    narcio.save(files, sinnoh_rooms.CAMERA_BOUNDS_ARC, bounds)
    zoneheaders.save(files, headers, entries)
    return (f'camera_switch: {mode} cameras: overworld {len(world["zones"])} zones -> '
            f'record {over}; rooms {len(rooms["zones"])} zones -> records {dict(sorted(kinds.items()))}; '
            f'{len(used)} camera boundaries in use ({len(bounds) - nvanilla} appended in all)')
