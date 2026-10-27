"""The zone header's flags word (u16 at 0x1E) of every Sinnoh zone and room from Pearl's own map header, and the other
header fields nobody set: camera, sprite projection, banner icon (notes/ZONE_FLAGS.md; notes/NEXT_REGION_BRIEF.md
"World and maps"). Runs after sinnoh_world and sinnoh_rooms.

Sinnoh's places reuse Black 2's zone ids (data/sinnoh_world.json zones and rooms -> b2_zone), and sinnoh_world never
set these, so an overworld zone kept the Unova zone's; sinnoh_rooms copied a template zone's (building Floccesy house
441, cave Wellspring Cave 324, outdoor Route 19 437). Found in game 2026-10-25: Eterna Forest (zone 272) fought its
wild battles on Wellspring Cave's grey cave background.

The flags word (decomp src/system/zonedata.c ZoneHeader; bits 0-4 first):
  0-4  mapTransitionEffectType  the warp fade (ov036 field_transition.c tables: 0 outdoors, 1 building, 2 gate,
                                3 cave, 4 bridge, 5 special building). Pearl picks its warp fade by map type the same
                                way (pokediamond asm/unk_0204C1B4.s: outdoor -> cave a wipe, cave -> outdoor another,
                                building a fade), so: Pearl map type 1-2 (town, route) -> 0, 3 (cave) -> 3, 4-5
                                (building, Center) -> 1. Black 2's gate (2), bridge (4) and special (5) are not used.
  5-9  battleBGId               SaveBtlFieldStatus (ov036 field_encount.c) -> BtlFieldEnv.bgType -> a/1/5/1 file 0
                                (light, seasonal, backdrop and stage by terrain; btlv_effect.c). PEARL_BG below.
  10   enableCycling            Pearl's is_bike_allowed (itemuse_event.c; a warp into a zone without it dismounts).
  11   unk1E_11                 read by nothing; 1 in all 615 Black 2 zones: kept 1 (Pearl's unused is_running_allowed
                                sits at the same place in its byte).
  12   enableEscapeRope         Pearl's is_escape_rope_allowed (Escape Rope and Dig; hiden_event.c, itemuse_event.c).
  13   enableFlyFrom            Pearl's is_fly_allowed (Fly and Teleport from here, hiden_event.c; also turns on Black
                                2's sun lens flare outdoors, field_goout_effect.c).
  14   enableCycleSurfBGM       1 everywhere: Pearl plays its surf song while surfing on any map (FieldSystem_
                                GetOverriddenMusicId) and its bike song while riding wherever the bike goes (saved
                                music, ScrCmd_RideBike); Black 2 plays them only where this bit is set (field_sound.c).
  15   enableEntralinkWarp      0 everywhere: the C-Gear and its Entralink go (decision 2026-10-19: the Pokétch
                                replaces the C-Gear; notes/DECISIONS.md).
Battle backgrounds (Black 2's 21, a/1/5/1 file 0, looked at as textures 2026-10-25): 0/1 grass (1 = 0 with spring,
autumn and winter variants), 2/3 city (3 = seasonal), 4/5 cave (the same backdrop; Dusk Ball always), 6 forest,
7 mountain, 8 sea, 9 indoors, 10 desert, 11 Shauntal, 12 Marshal, 13 Grimsley, 14 Caitlin, 15/17 N's Castle and
Dragonspiral Tower top, 16 the Champion, 18-20 PWT, tournament and Kyurem (set by code, not by zones). Pearl's 12
(pokediamond MapHeader battle_bg, 4 bits; Platinum's names): PEARL_BG. The seasonal ones (1, 3; 6-8 by their stages)
change with the season as Black 2's do. The snowy north (Pearl's SNOW) battles in winter all year (apply_code: the
decomp's PearlB2_BattleSeason reads gPearlB2WinterZones; without it, the game's season). The Elite Four and Champion
rooms keep Pearl's own (indoors, like every League room; lead 2026-10-25); PLACE_BG is the switch.

The other fields (lead 2026-10-25):
- weather word bits 6-8, objectProjectionMatrixType (the people sprites' projection, ov036 fieldmap.c): 1 on every
  outdoor Sinnoh place (transition 0), as Black 2's routes; caves and buildings keep their template's. Bits 9-15,
  defaultCameraIndex: 0 on every overworld zone, as Black 2's routes (15 Sinnoh routes kept a Unova camera: Castelia's
  streets on Routes 217-219), or maplook's Pearl camera when MAPLOOK_FIXES has 'camera' (it set every overworld zone
  alike, before this patch runs: kept). The rooms keep theirs: sinnoh_rooms sized their camera boundaries with it.
  Both are read when the field loads (warp, Fly, continue).
- icon word bits 0-12, nameIcon: the place banner's icon (ov036 place_name_letter.c, file icon + 2 of a/0/8/3):
  Black 2's city icon (11) for Pearl's cities, its town icon (107) for towns and areas, no icon (15, as Black 2's
  League, Undella Bay, caves and buildings) for the rest; Black 2's route shields are numbered 1-23 (icons 23-117),
  none fits 201-230. Bits 13-15, the Easy / Challenge Mode level adjust: kept (listed by the offline run).

Zone ids stay as they are; only the Sinnoh zones' fields change (Black 2's other zones, the PWT, Join Avenue ...,
keep theirs). Offline: `python3 b2tools/patches/zone_flags.py` prints every Sinnoh place (Pearl's values -> Black 2's
old word as sinnoh_world/sinnoh_rooms leave it -> ours) and checks the same rules the build checks.
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import zoneheaders  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
PEARL_ZONES = os.path.join(ROOT, 'work', 'pearl', 'zones.json')    # gen4_extract: Pearl's map headers
PEARL_NAMES = os.path.join(ROOT, 'external', 'pokediamond', 'files', 'msgdata', 'msg', 'narc_0382.gmm')
BG_ARC, BG_ENTRY = 151, 0x2C                                        # a/1/5/1 file 0: one 0x2C entry per background

# (name, first bit, width), as the decomp's ZoneHeader bitfield
FIELDS = (('trans', 0, 5), ('bg', 5, 5), ('cycling', 10, 1), ('unk11', 11, 1), ('rope', 12, 1), ('fly', 13, 1),
          ('surf_bgm', 14, 1), ('entralink', 15, 1))

# Pearl battle_bg -> Black 2 battleBGId
PEARL_BG = {
    0: 1,    # PLAIN (routes, lakefronts, Pal Park ...) -> grass, seasonal (Route 19/20's, not Route 1's unseasonal 0)
    1: 8,    # WATER (Routes 213, 220, 223, 230) -> sea (Undella Bay, Routes 17/21)
    2: 3,    # CITY (towns, the League outside, Fight/Resort Area, Battle Park) -> city, seasonal (Aspertia's)
    3: 6,    # FOREST (Eterna Forest, the lakes, Floaroma Meadow, Great Marsh, Trophy Garden) -> forest
    4: 7,    # MOUNTAIN (Routes 205 S-211, 214, 225-228, Spear Pillar, Stark Mountain) -> mountain (Route 10)
    5: 1,    # SNOW (Snowpoint, Routes 216-217, Acuity, Mt. Coronet's sides) -> grass, seasonal, in winter all year:
             # Black 2 has no all-year snow background, its snow is the winter variant (WINTER_BG, apply_code)
    6: 9, 7: 9, 8: 9,  # INDOORS_1-3 (houses, Gyms; big buildings, the League; the Old Chateau, Lost Tower) -> indoors
    9: 4,    # CAVE_1 (Oreburgh Gate and Mine, Ravaged Path) -> cave (Wellspring Cave's)
    10: 5,   # CAVE_2 (Mt. Coronet, Victory Road, Solaceon Ruins, Stark Mountain, Snowpoint Temple) -> cave (Victory
             # Road's: the same backdrop as 4)
    11: 5,   # CAVE_3 (Wayward Cave, Iron Island, the lake caverns, Turnback Cave) -> cave
}
WINTER_BG = 5                          # Pearl's SNOW: these zones battle in winter all year (gPearlB2WinterZones)
# Places whose Black 2 background is not PEARL_BG's, by Pearl map name. Empty: the League's rooms keep Pearl's indoors
# (lead 2026-10-25: Black 2's Elite Four backdrops are themed for Unova's types). The switch, if wanted: Black 2's
# Elite Four backgrounds are 11 Shauntal (purple), 12 Marshal (golden glow), 13 Grimsley (purple-black, orange band),
# 14 Caitlin (grey), 16 the Champion (blue-grey, sparkles), e.g.
# {'MAP_POKEMON_LEAGUE_AARON_ROOM': 11, 'MAP_POKEMON_LEAGUE_BERTHA_ROOM': 13, 'MAP_POKEMON_LEAGUE_FLINT_ROOM': 12,
#  'MAP_POKEMON_LEAGUE_LUCIAN_ROOM': 14, 'MAP_POKEMON_LEAGUE_CYNTHIA_ROOM': 16}
PLACE_BG = {}
BG_SET_BY_CODE = {18, 19, 20}          # PWT / tournament / Kyurem: never a zone's (wbt_battle.c, field_encount.c)
# Pearl map type (1 town, 2 route, 3 cave, 4 building, 5 Center) -> Black 2 mapTransitionEffectType
PEARL_TRANSITION = {0: 0, 1: 0, 2: 0, 3: 3, 4: 1, 5: 1, 6: 1}
# weather word: objectProjectionMatrixType bits 6-8, defaultCameraIndex bits 9-15; Black 2's routes: 1 and 0
PROJ_SHIFT, PROJ_MASK, CAM_SHIFT, CAM_MASK = 6, 7, 9, 0x7F
ROUTE_PROJ, ROUTE_CAMERA = 1, 0
# icon word: nameIcon bits 0-12, Easy/Challenge level adjust bits 13-15
ICON_MASK = 0x1FFF
ICON_CITY, ICON_TOWN, ICON_NONE = 11, 107, 15


def unpack(word):
    return {n: (word >> b) & ((1 << w) - 1) for n, b, w in FIELDS}


def pack(f):
    word = 0
    for n, b, w in FIELDS:
        assert 0 <= f[n] < (1 << w), (n, f[n])
        word |= f[n] << b
    return word


def place_names():
    """Pearl's map section names (English), row = map section."""
    xml = open(PEARL_NAMES, encoding='utf-8').read()
    rows = re.findall(r'<row[^>]*>(.*?)</row>', xml, re.S)
    return [re.search(r'<language name="English">(.*?)</language>', r, re.S).group(1) for r in rows]


def places():
    """[(Black 2 zone, Pearl zone header, kind, place name)] of every Sinnoh place: overworld 'town'/'route'/'other',
    'room'."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    pearl = json.load(open(PEARL_ZONES))
    names = place_names()
    out = []
    for group, kind_of in ((world['zones'], lambda z: z['kind']), (world['rooms']['zones'], lambda z: 'room')):
        for pid, z in group.items():
            p = pearl[int(pid)]
            assert p['id'] == int(pid), (pid, p['id'])
            out.append((z['b2_zone'], p, kind_of(z), names[p['mapsec']]))
    return sorted(out, key=lambda t: t[0]), world


def ours(p):
    """The flags word's fields for a Pearl zone header."""
    return dict(trans=PEARL_TRANSITION[p['map_type']], bg=PLACE_BG.get(p['name'], PEARL_BG[p['battle_bg']]),
                cycling=int(p['bike']), unk11=1, rope=int(p['escape_rope']), fly=int(p['fly']), surf_bgm=1,
                entralink=0)


def icon(kind, name):
    """The banner icon of a Sinnoh place."""
    if kind == 'town':
        return ICON_CITY if name.endswith(' City') else ICON_NONE if 'League' in name else ICON_TOWN
    return ICON_NONE


def new_header(hd, p, kind, name, pearl_camera):
    """(flags, weather word, icon word) for a Sinnoh place; hd = its header as the patches before left it."""
    flags = pack(ours(p))
    w = hd['weather_word']
    if unpack(flags)['trans'] == 0:                                     # outdoors: Black 2's routes' projection
        w = (w & ~(PROJ_MASK << PROJ_SHIFT)) | (ROUTE_PROJ << PROJ_SHIFT)
    if kind != 'room' and not pearl_camera:                             # overworld: Black 2's routes' camera
        w = (w & ~(CAM_MASK << CAM_SHIFT)) | (ROUTE_CAMERA << CAM_SHIFT)
    return flags, w, (hd['icon_word'] & ~ICON_MASK) | icon(kind, name)


def pearl_camera_on():
    """Whether maplook's Pearl camera (or its tilted Black 2 camera) is in this build (it sets every overworld zone's
    camera; kept then)."""
    sys.path.insert(0, os.path.dirname(HERE))
    import maplook
    return bool({'camera', 'tilt'} & set(maplook.fixes()))


def check(rows, bg_count):
    """The rules the table must keep (build and offline). Row: zone, Pearl header, kind, name, old and new
    (flags, weather word, icon word)."""
    zones = [r[0] for r in rows]
    dup = sorted({z for z in zones if zones.count(z) > 1})
    assert not dup, f'zone_flags: Black 2 zones used by two Sinnoh places: {dup}'
    names = {r[1]['name'] for r in rows}
    assert set(PLACE_BG) <= names, f'zone_flags: PLACE_BG names no Sinnoh place: {sorted(set(PLACE_BG) - names)}'
    cams = {(r[5][1] >> CAM_SHIFT) & CAM_MASK for r in rows if r[2] != 'room'}
    assert len(cams) == 1, f'zone_flags: the overworld zones have cameras {sorted(cams)}, not one'
    for z, p, kind, name, old, new in rows:
        f = unpack(new[0])
        assert f['bg'] < bg_count and f['bg'] not in BG_SET_BY_CODE, (z, p['name'], f['bg'])
        assert f['unk11'] == 1 and f['entralink'] == 0 and f['surf_bgm'] == 1, (z, p['name'], f)
        assert (f['cycling'], f['rope'], f['fly']) == (p['bike'], p['escape_rope'], p['fly']), (z, p['name'], f)
        assert (f['trans'] == 3) == (p['map_type'] == 3), (z, p['name'], f)
        assert kind != 'room' or f['trans'] != 0 or p['map_type'] in (1, 2), (z, p['name'], f)
        assert f['trans'] != 0 or (new[1] >> PROJ_SHIFT) & PROJ_MASK == ROUTE_PROJ, (z, p['name'])
        assert new[1] & 0x3F == old[1] & 0x3F and new[2] >> 13 == old[2] >> 13, (z, p['name'])   # weather, adjust
        if kind == 'room':
            assert new[1] >> CAM_SHIFT == old[1] >> CAM_SHIFT, (z, p['name'])                     # rooms' cameras
        assert (new[2] & ICON_MASK) in (ICON_CITY, ICON_TOWN, ICON_NONE), (z, p['name'])


def winter_zones(rows):
    """The Black 2 zones of Pearl's SNOW places (they battle in winter all year)."""
    return sorted(z for z, p, *_ in rows if p['battle_bg'] == WINTER_BG)


def count_changes(rows):
    """{field: Sinnoh places whose value changed}."""
    out = {n: 0 for n, _, _ in FIELDS}
    out.update(projection=0, camera=0, icon=0)
    for *_, old, new in rows:
        a, b = unpack(old[0]), unpack(new[0])
        for n, _, _ in FIELDS:
            out[n] += a[n] != b[n]
        out['projection'] += (old[1] >> PROJ_SHIFT) & PROJ_MASK != (new[1] >> PROJ_SHIFT) & PROJ_MASK
        out['camera'] += old[1] >> CAM_SHIFT != new[1] >> CAM_SHIFT
        out['icon'] += old[2] & ICON_MASK != new[2] & ICON_MASK
    return out


def bg_count(files):
    import narcio
    return len(narcio.load(files, BG_ARC)[0]) // BG_ENTRY


def _rows(headers, plist, pearl_camera):
    rows = []
    for z, p, kind, name in plist:
        hd = headers[z]
        old = (hd['flags'], hd['weather_word'], hd['icon_word'])
        rows.append((z, p, kind, name, old, new_header(hd, p, kind, name, pearl_camera)))
    return rows


def apply(files):
    plist, world = places()
    headers, entries = zoneheaders.load(files)
    room_matrix = {z['b2_zone']: world['rooms']['matrices'][str(z['pearl_matrix'])]['b2_matrix']
                   for z in world['rooms']['zones'].values()}
    for z, p, kind, name in plist:
        want = room_matrix.get(z, 0)
        assert headers[z]['matrix'] == want, (
            f"zone_flags: zone {z} ({p['name']}) has matrix {headers[z]['matrix']}, not {want}: run it after "
            f"sinnoh_world and sinnoh_rooms (sinnoh_rooms copies a template's flags over the rooms')")
    rows = _rows(headers, plist, pearl_camera_on())
    check(rows, bg_count(files))
    for z, p, kind, name, old, new in rows:
        headers[z]['flags'], headers[z]['weather_word'], headers[z]['icon_word'] = new
    zoneheaders.save(files, headers, entries)
    ch = count_changes(rows)
    return (f'zone_flags: {len(rows)} Sinnoh zones ({sum(r[4] != r[5] for r in rows)} headers changed); changed per '
            f'field: ' + ', '.join(f'{n} {c}' for n, c in ch.items()))


def winter_table(zones):
    """The decomp's PearlB2WinterZones (src/pearlb2/battle_season_itcm.c): u32 count, u16 zones."""
    data = struct.pack('<I', len(zones)) + struct.pack(f'<{len(zones)}H', *zones)
    return data + bytes(-len(data) % 4)


def apply_code(code):
    """The snowy north's zones for the decomp's PearlB2_BattleSeason (SaveBtlFieldStatus: winter there all year)."""
    import itcm, decomp
    slot = decomp.symbol('gPearlB2WinterZones', code)
    plist, _ = places()
    zones = winter_zones([(z, p) for z, p, *_ in plist])
    if slot is None:
        return 'zone_flags (code): no gPearlB2WinterZones in this decomp: the north battles in the game\'s season'
    base, end, _ = itcm.install(code, lambda b: (winter_table(zones), {}))
    p = os.path.join(code, 'itcm.bin')
    data = bytearray(open(p, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2WinterZones at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(data); os.replace(p + '.tmp', p)
    return f'zone_flags (code): {len(zones)} zones battle in winter all year ({end - base} B of ITCM at {base:#x}): {zones}'


# ---- offline -------------------------------------------------------------------------------------------------------------
def offline_rows():
    """The rows as a build makes them, from Black 2's own headers: an overworld zone keeps its Unova words, a room gets
    its sinnoh_rooms template's (TEMPLATE_ZONE by Pearl map type)."""
    sys.path.insert(0, HERE)
    from sinnoh_rooms import TEMPLATE_ZONE
    vanilla, _ = zoneheaders.load(VANILLA)
    plist, _ = places()
    headers = {}
    for z, p, kind, name in plist:
        # a zone past Black 2's 615 starts as sinnoh_world's blank header (zoneheaders.extend)
        hd = dict(vanilla[z]) if z < len(vanilla) else zoneheaders.blank(z, vanilla[zoneheaders.BLANK_TEMPLATE])
        if kind == 'room':
            t = vanilla[TEMPLATE_ZONE.get(p['map_type'], 441)]
            hd.update(flags=t['flags'], weather_word=t['weather_word'], icon_word=t['icon_word'])
        headers[z] = hd
    return _rows(headers, plist, pearl_camera_on())


def fmt(word):
    f = unpack(word)
    return (f"tr{f['trans']} bg{f['bg']:<2} {'C' if f['cycling'] else '-'}{'R' if f['rope'] else '-'}"
            f"{'F' if f['fly'] else '-'}{'M' if f['surf_bgm'] else '-'}{'E' if f['entralink'] else '-'}")


def fmt_other(old, new):
    out = []
    for what, o, n in (('proj', (old[1] >> PROJ_SHIFT) & PROJ_MASK, (new[1] >> PROJ_SHIFT) & PROJ_MASK),
                       ('cam', old[1] >> CAM_SHIFT, new[1] >> CAM_SHIFT), ('icon', old[2] & ICON_MASK, new[2] & ICON_MASK)):
        if o != n: out.append(f'{what} {o}->{n}')
    return ('  ' + ', '.join(out)) if out else ''


def main():
    rows = offline_rows()
    check(rows, bg_count(VANILLA))
    print('zone  Pearl map                                     kind   Pearl: type bg bike rope fly  ->  Black 2 old  ->  '
          'ours        (tr = transition, bg = battle background, C cycling R Escape Rope F Fly M bike/surf music '
          'E Entralink; then projection, camera and banner icon changes)')
    for z, p, kind, name, old, new in rows:
        print(f"{z:4d}  {p['name'][4:]:<45} {kind:<6}{p['map_type']:5d} {p['battle_bg']:2d} {int(p['bike']):4d} "
              f"{int(p['escape_rope']):4d} {int(p['fly']):3d}  ->  {fmt(old[0])}  ->  {fmt(new[0])}"
              f"{'  (same)' if old == new else fmt_other(old, new)}")
    ch = count_changes(rows)
    print(f'{len(rows)} Sinnoh places, {sum(r[4] != r[5] for r in rows)} headers change; per field: '
          + ', '.join(f'{n} {c}' for n, c in ch.items()))
    by = {}
    for z, p, kind, name, old, new in rows:
        by.setdefault((p['battle_bg'], unpack(new[0])['bg']), []).append(p['name'][4:])
    for (pb, bb), ns in sorted(by.items()):
        print(f'Pearl bg {pb:2d} -> Black 2 bg {bb:2d}: {len(ns):3d} places ({", ".join(ns[:6])}{" ..." if len(ns) > 6 else ""})')
    print('winter all year (gPearlB2WinterZones):', winter_zones([(z, p) for z, p, *_ in rows]))
    adj = {}
    for z, p, kind, name, old, new in rows:
        if kind != 'room': adj.setdefault(new[2] >> 13, []).append(name)
    print('Easy/Challenge level adjust kept (overworld places):',
          '; '.join(f'{a}: {len(ns)} ({", ".join(ns)})' for a, ns in sorted(adj.items())))
    radj = {}
    for z, p, kind, name, old, new in rows:
        if kind == 'room': radj[new[2] >> 13] = radj.get(new[2] >> 13, 0) + 1
    print('Easy/Challenge level adjust kept (rooms, from their template):', radj)


if __name__ == '__main__':
    main()
