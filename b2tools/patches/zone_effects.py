"""Black 2's zone-keyed effects off on every zone Sinnoh uses, and its location evolutions at Pearl's places
(notes/NEXT_REGION_BRIEF.md "World and maps"; HoennB2's patches/zone_effects.py and special_zones.py, ported).

Sinnoh's maps and rooms reuse Black 2's zone ids (data/sinnoh_world.json: zones and rooms' b2_zone; zone ids stay as
they are: saves keep the player's zone), and Black 2 keys tables and code on those ids, so a Sinnoh place kept the
Unova zone's effects. Counted on the dump's own files (442 Sinnoh zones, 2026-10-25):
- a/1/0/2 file 0 (GameData_SetGimmickByZone: u32 zone, u32 gimmick): 45 Sinnoh zones loaded a Unova zone's field
  gimmick overlay (Twinleaf = Aspertia's, Floaroma and Routes 211 E / 212 N, Veilstone, Pal Park, Survival Area ...).
- a/1/4/9 file 0 (the Flash table, u16 zone, u16 flags; GetZoneFlashFlags): 9 dark until Flash (Mt. Coronet's tunnel
  room and north 1F room 2, five Solaceon Ruins rooms, Sunyshore's Center B1F). Pearl's own dark places are not made
  dark here (not built: notes/OPEN_CONTENT.md).
- ISS, the sound by zone: a/1/3/3 (city crowd units, u32 zone): Canalave, Pastoria, Veilstone; a/1/3/6 (zone fades,
  u16 zone, track masks in and out): 29 (Snowpoint and its houses, Sunyshore's, Victory Road, Galactic HQ 1F-4F ...);
  a/1/4/6 (dungeons, u16 zone, pitch and tempo by season): 7, Pearl's music played 3-6 semitones low and 8-16 %
  slow in Hearthome's Center 1F, two Mt. Coronet rooms and three Solaceon Ruins rooms; a/1/4/7 (BGM switch sets: their
  zone lists) 17 (the League's rooms, Iron Island, the Old Chateau, Resort Area, ...). Each entry's zone becomes 0xFFFF.
- arm9 ZONE_CAMERA_ASSIGNMENTS (zone:11 | camera:5): Twinleaf (427) had Aspertia's forced camera 1 (notes/WORLD.md
  "Open"); its zone field becomes 0x7FF (no zone). VERSION_SPECIFIC_ZONES, ZONES_WITH_RAILS, ZONE_RAIL_ASSIGNMENTS and
  zonedata.c's other zone lists name no Sinnoh zone (allocate_sinnoh avoids every zone the decomp's code names):
  checked each build, cleared if one ever does.
- ov012 SCRIPT_PLUGIN_TABLE (the script-command overlay a zone loads, src/ov012/script_plugin.c): 36 Sinnoh zones
  loaded Battle Subway, Pal Park, Plasma Frigate, Pokéwood, Pokémon Center and plugin 14-16 overlays; all off. The
  Pokémon Center plugin (13, overlay 65: link battle records, commands 1005-1009) goes to the shared Center 2F
  instead (pearl_centers: zone 567, where the Union Room's exit lands and the link counters are): global scripts 2106
  (the Union Room exit, ov035 EventMapChangeUnionRoomExit), 2107 (continue) and 10105 (Wi-Fi Club) run its commands,
  and 567 loaded Pokéwood's (plugin 10) before. Black 2's own Center 1F zones are in that list; Sinnoh's 1F rooms
  run no plugin command.
- a/0/8/0 file 29 (the zone fog): maplook's 'fog' fix already drops the Sinnoh zones (sinnoh_reskin); counted here.
- a/0/9/6 (calendar weather): season_weather (Sinnoh zones never take Unova's calendar weather); not touched here.
- Location evolutions (decomp src/pearlb2/evolve_place_itcm.c, table gPearlB2EvolvePlaces): shinka_check.c's lists
  name Chargestone Cave (Magnezone, Probopass), Pinwheel Forest (Leafeon) and Twist Mountain (Glaceon), and hold 1-3
  zones each. Pearl's places (pokediamond arm9/src/map_header.c sMapEvolutionMethods, the whole map counts): Route 217
  (EVO_ROUTE217, the ice rock), Eterna Forest (EVO_ETERNA, the moss rock), and 13 Mt. Coronet maps and Spear Pillar
  (EVO_CORONET). The table maps each to the first zone of the matching Black 2 list; the level-up checks pass it on.
Only Black 2's own entries are cleared (the entry as the decomp's base files have it, at the same place): an entry
another patch writes stays, whichever runs first. Gimmick table rule (lead, 2026-10-25): Pearl's own gimmicks live
there too (Chapter 5a's Pastoria Gym, zone 174 -> gimmick 30; Chapter 6a's Canalave Gym; later gyms): any entry that
is not Black 2's own at its place is kept, and so is any entry whose gimmick id Black 2's table never uses (30, 59+;
Black 2 uses 1-29 and 31-58), so no gym needs a change here; a gym may take a slot this patch cleared (zone 0xFFFF).
Values change in place: every file and table keeps its size. Runs anywhere in the list (it reads data/sinnoh_world.json,
not the files other patches write); after sinnoh_reskin for the fog count. Code tables: a cold boot for old savestates.
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402

NONE16, NONE11 = 0xFFFF, 0x7FF
VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')   # the decomp's base files
VANILLA_CODE = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build')   # and code binaries
ARM9 = 0x02004000
OV012 = 0x021503C0
ARC_GIMMICK, ARC_FLASH, ARC_FOG, ARC_ISS_CITY, ARC_ISS_ZONE, ARC_ISS_DUNGEON, ARC_ISS_SWITCH = 102, 149, 80, 133, 136, 146, 147
FOG_FILE = 29
ISS_SWITCH_ZONES = 24                      # u32 BGM, 9 u16 track masks, u16 fade: the zone count, then the zones
# arm9 zone lists (zonedata.c; symbols.txt addresses): name -> (address, count, kind: 'u16' zone or 'assign' zone:11)
ARM9_LISTS = {
    'ZONE_CAMERA_ASSIGNMENTS': (0x020900AC, 9, 'assign'), 'ZONE_RAIL_ASSIGNMENTS': (0x020900E8, 28, 'assign'),
    'ZONES_WITH_RAILS': (0x020900D0, 12, 'u16'), 'VERSION_SPECIFIC_ZONES': (0x0209A348, 6, 'u16'),
    'WT_BT_ZONES': (0x0209A360, 10, 'u16'), 'BC_WF_LOBBY_ZONES': (0x02090078, 4, 'u16'),
    'ABYSSAL_RUINS_ZONES': (0x0209008A, 8, 'u16'), 'ABYSSAL_RUINS_ZONES_INSIDE': (0x02090070, 4, 'u16'),
    'NIMBASA_STADIUM_ZONES': (0x02090080, 5, 'u16'), 'GEAR_STATION_PLATFORM_ZONES': (0x020900BE, 9, 'u16'),
}
PLUGIN_TABLE, PLUGINS = 0x0216C1AC, 17     # SCRIPT_PLUGIN_TABLE: {commands, u16 *zones, u32 count, s32 ov0, s32 ov1}
OV_POKEMON_CENTER = 65
EVOLVE_LISTS = {'EVO_ROUTE217': 'EVOLVE_ICEROCK_ZONES', 'EVO_ETERNA': 'EVOLVE_MOSSROCK_ZONES',
                'EVO_CORONET': 'EVOLVE_ELEC_ZONES'}
EVOLVE_VANILLA = {'EVOLVE_ICEROCK_ZONES': (0x0209A3E4, 203), 'EVOLVE_MOSSROCK_ZONES': (0x0209A3E6, 155),
                  'EVOLVE_ELEC_ZONES': (0x0209A3E8, 195)}
PEARL_MAP_HEADER = os.path.join(ROOT, 'external', 'pokediamond', 'arm9', 'src', 'map_header.c')


def world():
    return json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))


def our_zones():
    """{Black 2 zone: Pearl map name} of every Sinnoh zone (overworld and rooms)."""
    w = world()
    out = {z['b2_zone']: z['name'] for z in w['zones'].values()}
    out.update({z['b2_zone']: z['name'] for z in w['rooms']['zones'].values()})
    return out


def shared_center_zone():
    """The shared Pokémon Center 2F's zone (pearl_centers; data/sinnoh_world.json rooms 'shared')."""
    rooms = world()['rooms']
    (pid,) = rooms['shared']
    return rooms['zones'][pid]['b2_zone']


def evolve_places():
    """[(Black 2 zone, Pearl evolution method, map name)] from pokediamond's sMapEvolutionMethods."""
    text = open(PEARL_MAP_HEADER).read()
    body = re.search(r'sMapEvolutionMethods\[\] = \{(.*?)\};', text, re.S).group(1)
    names = re.findall(r'\b(MAP_\w+|EVO_\w+)\b', body)
    pairs = list(zip(names[0::2], names[1::2]))
    assert pairs and all(m.startswith('MAP_') and e.startswith('EVO_') for m, e in pairs), pairs
    zone = {n: z for z, n in our_zones().items()}
    out = [(zone[m], e, m) for m, e in pairs if m in zone]
    missing = [m for m, _ in pairs if m not in zone]
    kinds = {e for _, e, _ in out}
    assert kinds == set(EVOLVE_LISTS), f'zone_effects: Pearl evolution places found for {kinds} only'
    return out, missing


# ---- files ---------------------------------------------------------------------------------------------------------------
def _pairs(data, base, fmt, ours, what, done, keep=()):
    """(zone, value) pairs: Black 2's own (as in base, at the same place) on a Sinnoh zone get zone 0xFFFF."""
    data = bytearray(data)
    size = struct.calcsize(fmt)
    for o in range(0, len(data) - size + 1, size):
        z, v = struct.unpack_from(fmt, data, o)
        own = o + size <= len(base) and struct.unpack_from(fmt, base, o) == (z, v)
        if z in ours and own and v not in keep:
            struct.pack_into(fmt, data, o, NONE16, v); done.append((what, z))
    return bytes(data)


def _heads(entries, base, fmt, ours, what, done):
    """Files that start with their zone: Black 2's own (as in base) on a Sinnoh zone get zone 0xFFFF."""
    n = struct.calcsize(fmt)
    for i, u in enumerate(entries):
        z = struct.unpack_from(fmt, u, 0)[0]
        if z in ours and i < len(base) and base[i][:n] == u[:n]:
            entries[i] = struct.pack(fmt, NONE16) + u[n:]; done.append((what, z))


def apply(files):
    ours = our_zones()
    done = []
    g = narcio.load(files, ARC_GIMMICK)
    base = narcio.load(VANILLA, ARC_GIMMICK)[0]
    unused = set(range(1 << 16)) - {v for _, v in struct.iter_unpack('<II', base[:len(base) // 8 * 8])}
    g[0] = _pairs(g[0], base, '<II', ours, 'gimmick', done, keep=unused)
    narcio.save(files, ARC_GIMMICK, g)
    f = narcio.load(files, ARC_FLASH)
    f[0] = _pairs(f[0], narcio.load(VANILLA, ARC_FLASH)[0], '<HH', ours, 'dark', done)
    narcio.save(files, ARC_FLASH, f)
    for arc, fmt, what in ((ARC_ISS_CITY, '<I', 'city sound'), (ARC_ISS_ZONE, '<H', 'zone fade'),
                           (ARC_ISS_DUNGEON, '<H', 'dungeon pitch')):
        e = narcio.load(files, arc); _heads(e, narcio.load(VANILLA, arc), fmt, ours, what, done); narcio.save(files, arc, e)
    e, base = narcio.load(files, ARC_ISS_SWITCH), narcio.load(VANILLA, ARC_ISS_SWITCH)
    for i, u in enumerate(e):
        u = bytearray(u)
        for k in range(u[ISS_SWITCH_ZONES]):
            at = ISS_SWITCH_ZONES + 1 + 2 * k
            z = struct.unpack_from('<H', u, at)[0]
            if z in ours and i < len(base) and base[i][at:at + 2] == u[at:at + 2]:
                struct.pack_into('<H', u, at, NONE16); done.append(('BGM switch zone', z))
        e[i] = bytes(u)
    narcio.save(files, ARC_ISS_SWITCH, e)
    fog = narcio.load(files, ARC_FOG)[FOG_FILE]
    fogged = sorted({z for z, _ in struct.iter_unpack('<HH', fog[:len(fog) // 4 * 4]) if z in ours})
    kinds = {}
    for what, z in done: kinds.setdefault(what, []).append(z)
    return ('zone_effects: off on Sinnoh zones: ' + '; '.join(f'{w} {len(z)} ({", ".join(map(str, sorted(z)))})'
                                                         for w, z in kinds.items())
            + f'; zone fog left on {len(fogged)} Sinnoh zones' + (f' {fogged} (MAPLOOK_FIXES without fog?)' if fogged else ''))


# ---- code ----------------------------------------------------------------------------------------------------------------
def _load(code, name):
    p = os.path.join(code, name)
    return p, bytearray(open(p, 'rb').read())


def _save(p, d):
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)


def _addr(name, fixed, code):
    import decomp
    a = decomp.symbol(name, code)
    assert a in (None, fixed), f'zone_effects: {name} at {a:#x}, not {fixed:#x}'
    return fixed


def evolve_table(base, places):
    """The decomp's PearlB2EvolvePlaces (src/pearlb2/evolve_place_itcm.c) at base."""
    return struct.pack('<I', len(places)) + b''.join(struct.pack('<HH', z, a) for z, a in places)


def apply_code(code):
    import itcm, decomp
    ours = our_zones()
    done = []
    # arm9 zone lists
    p, a = _load(code, 'arm9.bin')
    a0 = open(os.path.join(VANILLA_CODE, 'arm9.bin'), 'rb').read()
    for name, (addr, n, kind) in ARM9_LISTS.items():
        o = _addr(name, addr, code) - ARM9
        for i in range(n):
            v = struct.unpack_from('<H', a, o + 2 * i)[0]
            if v != struct.unpack_from('<H', a0, o + 2 * i)[0]:
                continue                                    # another patch's entry: kept
            if kind == 'assign' and (v & NONE11) in ours:
                struct.pack_into('<H', a, o + 2 * i, (v & ~NONE11) | NONE11); done.append(f'{name} {v & NONE11}')
            elif kind == 'u16' and v in ours:
                struct.pack_into('<H', a, o + 2 * i, NONE16); done.append(f'{name} {v}')
    as_zone = {}
    for method, name in EVOLVE_LISTS.items():
        addr, vanilla = EVOLVE_VANILLA[name]
        z = struct.unpack_from('<H', a, _addr(name, addr, code) - ARM9)[0]
        assert z == vanilla and z not in ours, f'zone_effects: {name} starts with {z}, not Black 2\'s {vanilla}'
        as_zone[method] = z
    _save(p, a)
    # ov012 script plugins: no Sinnoh zone loads a Unova plugin; the shared Center 2F loads the Pokémon Center's
    p, ov = _load(code, 'arm9_ov012.bin')
    ov0012 = open(os.path.join(VANILLA_CODE, 'arm9_ov012.bin'), 'rb').read()
    table = _addr('SCRIPT_PLUGIN_TABLE', PLUGIN_TABLE, code) - OV012
    shared = shared_center_zone()
    center_slots = []
    for e in range(1, PLUGINS):
        _, zp, n, ov0, _ = struct.unpack_from('<IIIii', ov, table + 20 * e)
        assert OV012 <= zp < OV012 + len(ov) and 0 < n < 64, f'zone_effects: plugin table entry {e} unexpected'
        for i in range(n):
            at = zp - OV012 + 2 * i
            z = struct.unpack_from('<H', ov, at)[0]
            if z != struct.unpack_from('<H', ov0012, at)[0] and not (z == shared and ov0 == OV_POKEMON_CENTER):
                continue                                    # another patch's entry: kept
            if z in ours or (z == NONE16 and ov0 == OV_POKEMON_CENTER):
                if z != NONE16:
                    struct.pack_into('<H', ov, at, NONE16); done.append(f'plugin {e} (ov{ov0}) {z}')
                if ov0 == OV_POKEMON_CENTER:
                    center_slots.append(at)
    assert center_slots, 'zone_effects: no free slot in the Pokémon Center plugin\'s zone list'
    struct.pack_into('<H', ov, center_slots[0], shared)
    _save(p, ov)
    # location evolutions: the table for the decomp's PearlB2_CheckEvolveSpecies
    places, missing = evolve_places()
    slot = decomp.symbol('gPearlB2EvolvePlaces', code)
    if slot is None:
        evo = 'no gPearlB2EvolvePlaces in this decomp: Black 2\'s evolution places'
    else:
        rows = [(z, as_zone[m]) for z, m, _ in places]
        base, end, _ = itcm.install(code, lambda b: (evolve_table(b, rows), {}))
        p, data = _load(code, 'itcm.bin')
        at = slot - itcm.ITCM_BASE
        assert data[at:at + 4] == bytes(4), f'gPearlB2EvolvePlaces at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
        data[at:at + 4] = struct.pack('<I', base)
        _save(p, data)
        by = {}
        for z, m, _ in places: by.setdefault(m, []).append(z)
        evo = (f'evolution places ({end - base} B of ITCM at {base:#x}): '
               + '; '.join(f'{m} as {as_zone[m]}: {sorted(zs)}' for m, zs in by.items())
               + (f' (Pearl maps without a zone: {missing})' if missing else ''))
    return f'zone_effects: {len(done)} code entries off: {", ".join(done)}; shared Center 2F {shared} -> Pokémon Center plugin; {evo}'
