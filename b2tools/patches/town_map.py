"""Sinnoh town map (2026-10-20; HoennB2's town_map.py, its Hoenn town map, ported to Pearl; HoennB2 notes/TOWN_MAP.md): Black
2's town map app (FIELD_APP 8, overlay 144) shows Pearl's Sinnoh map instead of Unova for the Town Map key item, Fly
(party menu) and the Pokémon Centers' wall maps (CallPlaceSelect, view mode below). The Pokédex's AREA page draws the
same art and records (patches/sinnoh_pokedex.py reads file 21).

Black 2's town map [code: pokebw2 src/ov144/townmap*.c, include/app/townmap/townmap_data.h; HoennB2 notes/TOWN_MAP.md]:
  - art: a/0/8/4 (ARC 84). Bottom screen BG3 = the painted map (8bpp extended-affine, NCGR 7 + NSCR 16, extended
    palette 0 of NCLR 0), BG2 = the route/town/landmark overlay (NCGR 5 + NSCR 17); sprites (NCGR 8, NCER 12, NANR 19,
    all 16 OBJ palettes of NCLR 2; the touch bar's from palette 12) draw the cursor, the player and the place icons. The
    map is shown at 1:1 (256x168 above the bar) and zoomed 2x by scaling the affine BGs.
  - places: 85 records x 54 bytes (27 u16): zone, snap radius, icon x/y, snap x/y, hit capsule (2 points, radius), type
    (0 town, 1 route, 2 landmark, 3/4/5 icons), can fly, 2 words, arrival flag, show flag, description + 6 landmark
    lines of system text town_map, the Pokédex area page's highlight (anim, x, y). Names = the zone header's place.

Pearl's town map [the user's dump; pokediamond overlay 66, pokeplatinum src/applications/town_map]:
  - art: graphic/tmap_gra.narc: the top screen's region map = NSCR 22 (terrain) + NSCR 24 (routes, over it), NCGR 19,
    NCLR 0 (palettes 0, 1), 256x192 with its frame; the bottom 24 rows are its bar. Hidden places (Fullmoon/Newmoon
    Island, Spring Path, Route 231: NSCR 23 drawn when unlocked) are not in the picture, as in Pearl before unlocking.
  - grid: one map-matrix cell (32 x 32 tiles) of Sinnoh's matrix 0 = 7 x 7 pixels, cell (x, z) centred at
    (7x + 25, 7z - 34) (pokeplatinum TOWN_MAP_GRID_*); the player is shown on their cell.
  - towns: overlay 66's fly table (0x021d990c, 20 x 20 bytes: map header, flag index, block shape, colour, special,
    sprite x/y on that grid) and the town blocks (NCGR 16 / NCER 17: 7 shapes, 16x16 each; NCLR 2 palette 5 = not yet
    visited (grey), 6 = a town's (blue), 7 = a city's (red)). Fly lands at arm9 0x020f2224's spot (20 x 16 bytes:
    black-out map and x/z, fly map and x/z, ...; pokediamond UNK_020F2224 = pokeplatinum sSpawnLocations): in front of
    the Pokémon Center.
  - descriptions: data/tmap_block.dat (182 blocks of 24 bytes: cell x/z, signpost, area description and landmark lines
    of bank 556, hidden-place flag).
  - the Pokédex's area places: application/zukanlist/zkn_data/zukan_enc_pearl.narc files 0-3: 21 "dungeons" (cell,
    Mt. Coronet flag; file 1 their map header) and 50 "fields" (cell rectangle + mask; file 3 their map header).

This patch:
  - art: Pearl's picture rows 0-167 (both layers composed, Pearl's own pixels and colours: extended palette 0 indices
    1-32 = Pearl's palettes 0 and 1) in BG3 at (0, 0), rows 168-255 repeat its terrain's last tile row; BG2 empty. Pearl's town
    blocks as 15 new cells/anims (NCER 12 cells 25+, NANR 19 anims 19+, NCGR 8 7 new 128-byte units, OBJ palettes 5-7 =
    Pearl's 5-7: palettes 5-11 of Black 2's NCLR 2 were unused black). Black 2's own cells are unchanged. The NARC keeps
    its size (padded).
  - places (a/0/8/4 file 21, after the art; the NARC is padded back to its size): 84 records + 1 filler, in hit order:
    the 21 area dungeons (small hit circles on their cell; Mt. Coronet has a second record for its western run), the 18
    Fly towns (icons: Pearl's blocks, grey until visited), the 42 other area fields (routes, lakefronts, the Battle Zone's
    outdoors ...), Verity Lakefront and the Battle Tower. Each takes Pearl's area description (bank 556, appended to
    Black 2's town_map text by data/text_overrides/town_map.json: `python3 town_map.py --text`).
  - zone table: every zone header -> record: Sinnoh's overworld zones by their Pearl map, rooms and caves by their Pearl
    map section (a cave -> its dungeon record, a house -> its town or route; the Lost Tower -> its own record).
  - player's cell: on matrix 0, in a zone whose record is not a town, the record's icon and cursor start are moved to
    the player's own cell (Pearl's marker), from the player's tile.
  - Fly: the 18 towns are flyable once visited: Black 2's arrival flags are the respawn table's discovery flags
    (RESPAWN_ZONE_INFO, ov012 0x0216c33c), set by SetTeleportZoneDiscover on entering a zone that is an entry's town;
    apply_code switches "discover on visit" on for sinnoh_respawn's 18 Sinnoh entries (entry 16's flag 0x9b4 is entry
    15's too in Black 2: it gets entry 18's 0x9b8, which nothing else sets). The towns' zone-header fly points become
    Pearl's landing spots (checked on Sinnoh's walkable tiles). The Pokémon League lands at its south Pokémon Center
    (Pearl's Victory Road entrance spot): one fly point per zone, and entering the League zone (the south part, before
    Victory Road) is what marks it visited.
  - the whole map in view (2026-10-26): Pearl's Sinnoh fills Black 2's whole map area (rows 0-166), and Black 2's name
    plate (NCER 12 cell 3, x 0-152, y 1-25; Unova keeps that corner empty) hid Snowpoint City, Snowpoint Temple, Lake
    Acuity and its lakefront in every mode, Fly included. The decomp (pearlb2, ov144 TownMapPlaceName_SetPlace) never
    opens the plate; the upper screen names the place, as Pearl names it outside its map. All 84 places are on screen
    and reached by touch and D-pad (cursor and touch y 8-168). The Pokédex's AREA page shows rows 0-168 uncovered.
    Known, kept: the player's marker at Snowpoint (y 11) is a pin drawn above its point, so its top is cut by the
    screen's edge (Black 2's own at N's Castle, y 6, too).
  - wall maps: Pearl's tile behaviour 0x85 (Centers, gatehouses, ...) -> pearl_events.TOWN_MAP sign events running
    Pearl's script 2508, whose OpenRegionMap is CallPlaceSelect (view mode below).
  - code (ov144, inside its own size): records from file 21; the player's place through the zone table; the player's
    cell; Pearl's icons for type 5 (anims from file 21's icon table, visited | not visited << 8); view mode for a
    scripted call where Fly is off (the Centers' wall maps); the entry count 85. The compressed size of ov144 is not
    tuned to Black 2's 8,688 B (HoennB2's SIZE_FILLER method needs a rig ROM): the ROM layout after ov144 may move.
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'b2tools'))
import version  # noqa: E402

ARC_GFX, NEW_FILE = 84, 21
REC, NREC = 54, 85
OV144 = 0x0219CE80
GRID, GX, GY = 7, 25, -34                 # Pearl's town map grid: cell (x, z) centre = (7x + 25, 7z - 34)
MAP_H = 168                               # Black 2's map area above its bar (Pearl's picture rows 0-167)
PAL_BASE = 1                              # Pearl colour (palette p, index c) -> extended palette 0 index 1 + 16p + c
PEARL = os.path.join(ROOT, 'work', version.VERSION)
TYPE_ROUTE, TYPE_TOWN_ICON = 1, 5
TOWNMAP_TEXT = 'town_map'                 # system text of the descriptions (Black 2 has 163 lines)
B2_TOWNMAP_LINES = 163


def cell_px(cx, cz):
    return GRID * cx + GX, GRID * cz + GY


# ---------------------------------------------------------------------------------------------------- the Pearl dump

_ROM = []


def _rom():
    if not _ROM:
        from gen4rom import Rom
        _ROM.append(Rom(version.SOURCE_DUMP))
    return _ROM[0]


def _narc(path):
    from gen4rom import narc_members
    import title_art as ta
    return [ta.lz10_decompress(d) if d[:1] == b'\x10' else d for d in narc_members(_rom().read(path))]


def _pals(d):
    """{palette slot: [16 RGB]} of a Gen 4 NCLR (its TTLP holds only the slots its PMCP lists)."""
    import title_art as ta
    assert d[:4] == b'RLCN'
    tsize = struct.unpack_from('<I', d, 0x14)[0]
    depth, _, _, off = struct.unpack_from('<IIII', d, 0x18)
    n = (tsize - 0x18) // 2
    cols = [ta.bgr555_to_rgb(v) for v in struct.unpack_from(f'<{n}H', d, 0x18 + off)]
    slots = list(range(n // 16))
    p = 0x10 + tsize
    if d[p:p + 4] == b'PMCP':
        cnt, io = struct.unpack_from('<H', d, p + 8)[0], struct.unpack_from('<I', d, p + 12)[0]
        slots = list(struct.unpack_from(f'<{cnt}H', d, p + 8 + io))
    return {s: cols[16 * k:16 * k + 16] for k, s in enumerate(slots)}


def _blz(data):
    """Nintendo's bottom-up LZ (compressed overlays)."""
    data = bytearray(data)
    off_size, inc = struct.unpack_from('<II', data, len(data) - 8)
    hdr, comp = off_size >> 24, off_size & 0xFFFFFF
    out = bytearray(len(data) + inc); out[:len(data)] = data
    src, dst, stop = len(data) - hdr, len(out), len(data) - comp
    while src > stop:
        src -= 1; flags = data[src]
        for _ in range(8):
            if src <= stop: break
            if flags & 0x80:
                src -= 2; v = data[src] | data[src + 1] << 8
                for _ in range((v >> 12) + 3):
                    dst -= 1; out[dst] = out[dst + (v & 0xFFF) + 3]
            else:
                src -= 1; dst -= 1; out[dst] = data[src]
            flags = flags << 1 & 0xFF
    return bytes(out)


def _overlay(n):
    d = _rom().data
    off, length = struct.unpack_from('<II', d, 0x50)
    for i in range(length // 32):
        oid, ram, size, bss, s0, s1, fid, fl = struct.unpack_from('<8I', d, off + 32 * i)
        if oid == n:
            b = _rom().read(fid)
            return ram, _blz(b) if fl >> 24 & 1 else b
    raise KeyError(n)


def fly_table():
    """Pearl's 20 town-map fly places (overlay 66 0x021d990c): dicts header, index, shape, colour, special, x, y."""
    ram, b = _overlay(66)
    o = 0x021D990C - ram
    out = []
    for i in range(20):
        h, idx, shape, col, special, x, y = struct.unpack_from('<IIBBHII', b, o + 20 * i)
        out.append(dict(header=h, index=idx, shape=shape, colour=col, special=special, x=x, y=y))
    assert out[0]['header'] == 411 and out[7]['header'] == 3, 'not overlay 66\'s fly table'
    return out


def spawn_table():
    """{fly-table index: (fly map header, x, z)} (arm9 0x020f2224, 20 x 16 bytes)."""
    d = _rom().data
    off, _, ram, size = struct.unpack_from('<IIII', d, 0x20)
    o = off + 0x020F2224 - ram
    out = {}
    for i in range(20):
        bh, bx, bz, fh, fx, fz, warp, unlock, idx, _ = struct.unpack_from('<6H4B', d, o + 16 * i)
        out[idx] = (fh, fx, fz)
    assert out[0] == (411, 0x74, 0x376), out[0]
    return out


def blocks():
    """Pearl's tmap_block.dat: {(x, z): (area line, landmark line, hidden flags)}."""
    d = _rom().read('data/tmap_block.dat')
    n = struct.unpack_from('<I', d, 0)[0]
    out = {}
    for i in range(n):
        x, z, _, _, area, land, _, _, _, _, hid, _ = struct.unpack_from('<12H', d, 4 + 24 * i)
        out[(x, z)] = (area, land, hid)
    return out


def area_places():
    """Pearl's Pokédex area places (zukan_enc_pearl.narc files 0-3): (dungeons [(x, z, coronet, header)],
    fields [(x, z, w, h, cells, header)]), index 0 (a blank) dropped."""
    m = _narc('application/zukanlist/zkn_data/zukan_enc_pearl.narc' if not version.DIAMOND
              else 'application/zukanlist/zkn_data/zukan_enc_diamond.narc')
    d0, d1, d2, d3 = m[:4]
    dh = struct.unpack(f'<{len(d1) // 4}I', d1)
    fh = struct.unpack(f'<{len(d3) // 4}I', d3)
    dungeons = [(d0[4 * i], d0[4 * i + 1], d0[4 * i + 2], dh[i]) for i in range(1, len(d0) // 4)]
    fields = []
    for i in range(1, len(d2) // 36):
        x, z, w, h = d2[36 * i:36 * i + 4]
        mask = d2[36 * i + 4:36 * i + 4 + w * h]
        cells = [(x + k // h, z + k % h) for k in range(w * h) if mask[k]]   # (column-major, pokedex_enc_data.c)
        fields.append((x, z, w, h, cells, fh[i]))
    return dungeons, fields


# ---------------------------------------------------------------------------------------------------- the art

def pearl_picture():
    """(pixels 256 x 256: Pearl's map rows 0-167 then its terrain's last tile row repeated, extended-palette indices;
    {index: RGB})"""
    import title_art as ta
    m = _narc('graphic/tmap_gra.narc')
    _, tiles = ta.ncgr_tiles(m[19])
    pal = _pals(m[0])
    def layer(n):
        w, h, _, ents = ta.nscr_entries(m[n])
        assert (w, h) == (256, 192)
        out = bytearray(256 * 192)
        for i, e in enumerate(ents):
            t = ta.flip_tile(tiles[e & 0x3FF], e >> 10 & 1, e >> 11 & 1); p = e >> 12
            assert p in pal, (n, p)
            for y in range(8):
                for x in range(8):
                    v = t[y * 8 + x]
                    out[(i // 32 * 8 + y) * 256 + i % 32 * 8 + x] = 0x80 | p << 4 | v if v else p << 4
        return out
    terrain, routes = layer(22), layer(24)
    pix = bytearray(256 * 256)
    for i in range(256 * MAP_H):
        v = routes[i] if routes[i] & 0x80 else terrain[i]
        pix[i] = PAL_BASE + (v & 0x7F)              # terrain's index 0 kept opaque (Pearl's backdrop colour)
    last = bytes(PAL_BASE + (v & 0x7F) for v in terrain[256 * (MAP_H - 8):256 * MAP_H])   # (no route pieces)
    for r in range(MAP_H, 256, 8):
        pix[256 * r:256 * (r + 8)] = last
    colours = {PAL_BASE + 16 * p + c: rgb for p, cs in pal.items() if p < 2 for c, rgb in enumerate(cs)}
    return bytes(pix), colours


def art_entries(entries):
    """New a/0/8/4 entries 0 (palettes), 5/17 (BG2: empty), 7/16 (BG3: Pearl's map), 2/8/12/19 (Pearl's town blocks)."""
    import title_art as ta
    out = list(entries)
    pix, colours = pearl_picture()
    ts = ta.TileSet()
    scr = ta.screen_from_image(ts, pix, 256, 256)
    bpp, old = ta.ncgr_tiles(entries[7])
    assert bpp == 8 and len(ts.tiles) <= 512 and len(ts.tiles) <= len(old), (bpp, len(ts.tiles), len(old))
    out[7] = ta.ncgr_build(ts.tiles, 8)
    assert ta.nscr_entries(entries[16])[:2] == (256, 256)
    out[16] = entries[16][:0x24] + struct.pack('<1024H', *scr)
    out[5] = ta.ncgr_build([bytes(64)], 8)
    out[17] = entries[17][:0x24] + bytes(2048)
    cols = ta.nclr_colours(entries[0])                 # 16 extended palettes x 256; the map uses palette 0
    for i, rgb in colours.items(): cols[i] = rgb
    out[0] = ta.nclr_build(entries[0], cols)
    for k, v in sprite_entries(entries).items(): out[k] = v
    return out, len(ts.tiles)


# Pearl's town blocks: 7 shapes (Pearl NCGR 16, 4 tiles each, NCER 17 cells: one 16x16 OBJ at (-8, -8)); colours: OBJ
# palette 5 = not visited, 6 = a town's, 7 = a city's (Pearl's palette numbers kept). One Black 2 cell + anim per
# (shape, palette) a town uses, after Black 2's cells / anims.
SHAPE_CELLS = {0: [(0, 0)], 1: [(0, 0), (0, 1)], 2: [(0, 0), (1, 0), (0, 1), (1, 1)], 3: [(0, 0), (1, 0), (0, 1)],
               4: [(0, 0), (1, 0), (1, 1)], 5: [(0, 0), (1, 0)], 6: [(0, 0)]}   # cells of each shape from its top-left
PAL_UNVISITED, PAL_TOWN = 5, 6                     # PAL_TOWN + Pearl's colour (0 blue, 1 red)
ICON_ANIM0 = 19                                    # Black 2's NANR 19 has anims 0-18
_ICONS = []                                        # [(shape, palette)] in anim order (sprite_entries)


def town_icons():
    """[(shape, palette)] of the icons the towns use, in anim order (ICON_ANIM0 + k)."""
    if not _ICONS:
        need = []
        for t in towns():
            for k in ((t['shape'], PAL_UNVISITED), (t['shape'], PAL_TOWN + t['colour'])):
                if k not in need: need.append(k)
        _ICONS.extend(sorted(need, key=lambda k: (k[1], k[0])))
    return _ICONS


def sprite_entries(entries):
    """New a/0/8/4 entries 2 (OBJ palettes), 8 (OBJ tiles), 12 (cells), 19 (anims) with Pearl's town blocks."""
    import title_art as ta
    m = _narc('graphic/tmap_gra.narc')
    ptile_bpp, ptiles = ta.ncgr_tiles(m[16])
    assert ptile_bpp == 4 and len(ptiles) == 28
    ppal = _pals(m[2])
    icons = town_icons()
    # tiles: one 128-byte unit (4 tiles, a 16x16 OBJ in 1D order) per Pearl shape after Black 2's
    ncgr = bytearray(entries[8])
    th, tw, depth, mapping, tiled, size, off = struct.unpack_from('<HHIIIII', ncgr, 0x18)
    assert depth == 3 and size % 128 == 0 and (th, tw) == (0xFFFF, 0xFFFF)
    unit0 = size // 128
    raw = b''.join(bytes(t[i] | t[i + 1] << 4 for i in range(0, 64, 2)) for t in ptiles)
    secs = _sections_of(bytes(ncgr))
    mg, ro, rsz = secs[0]
    assert mg == b'RAHC' and ro == 0x10 and off == 0x18 and rsz == 0x20 + size
    rahc = bytearray(ncgr[ro:ro + rsz]) + raw
    struct.pack_into('<I', rahc, 4, rsz + len(raw)); struct.pack_into('<I', rahc, 0x18, size + len(raw))
    ncgr_new = _nitro(bytes(ncgr), [bytes(rahc)] + [bytes(ncgr[o:o + sz]) for _, o, sz in secs[1:]])
    # cells
    ncer = entries[12]
    secs = _sections_of(ncer)
    mg, ko, ksz = secs[0]; assert mg == b'KBEC'
    kb = ncer[ko:ko + ksz]
    n, attr, co = struct.unpack_from('<HHI', kb, 8)
    assert attr & 1 and co == 0x18
    table = bytearray(kb[8 + co:8 + co + 16 * n]); oams = bytearray(kb[8 + co + 16 * n:])
    oam_len = max(struct.unpack_from('<I', table, 16 * i + 4)[0] + 6 * struct.unpack_from('<H', table, 16 * i)[0]
                  for i in range(n))
    oams = oams[:oam_len]
    bound = struct.unpack_from('<H', table, 16 * 4 + 2)[0]
    for shape, pal in icons:
        table += struct.pack('<HHIhhhh', 1, bound, len(oams), 7, 7, -8, -8)
        oams += struct.pack('<HHH', 0 << 14 | (-8 & 0xFF), 1 << 14 | (-8 & 0x1FF), pal << 12 | (unit0 + shape))
    while len(oams) % 4: oams += b'\0'
    head = bytearray(kb[8:8 + co]); struct.pack_into('<H', head, 0, n + len(icons))
    kb_new = struct.pack('<4sI', b'KBEC', 8 + len(head) + len(table) + len(oams)) + bytes(head + table + oams)
    ncer_new = _nitro(ncer, [kb_new] + [ncer[o:o + sz] for _, o, sz in secs[1:]])
    # anims (one frame each, Black 2's anim 1 as the template)
    nanr = entries[19]
    secs = _sections_of(nanr)
    mg, ao, asz = secs[0]; assert mg == b'KNBA'
    ab = nanr[ao:ao + asz]
    nA, nF, aoff, foff, poff = struct.unpack_from('<HHIII', ab, 8)
    assert nA == ICON_ANIM0, nA
    anims = bytearray(ab[8 + aoff:8 + foff]); frames = bytearray(ab[8 + foff:8 + poff]); pos = bytearray(ab[8 + poff:])
    proto = ab[8 + aoff + 16:8 + aoff + 32]
    for k in range(len(icons)):
        a = bytearray(proto); struct.pack_into('<I', a, 12, len(frames)); anims += a
        frames += struct.pack('<IHH', len(pos), 4, 0xBEEF)
        pos += struct.pack('<HH', n + k, 0xCCCC)
    head = bytearray(ab[8:8 + aoff])
    struct.pack_into('<HHIII', head, 0, nA + len(icons), nF + len(icons), aoff, aoff + len(anims),
                     aoff + len(anims) + len(frames))
    ab_new = struct.pack('<4sI', b'KNBA', 8 + len(head) + len(anims) + len(frames) + len(pos)) + bytes(head + anims + frames + pos)
    nanr_new = _nitro(nanr, [ab_new] + [nanr[o:o + sz] for _, o, sz in secs[1:]])
    cols = ta.nclr_colours(entries[2])
    assert all(c == (0, 0, 0) for c in cols[16 * 5:16 * 8]), 'OBJ palettes 5-7 are in use'
    for p in (5, 6, 7):
        cols[16 * p:16 * p + 16] = ppal[p]
    return {2: ta.nclr_build(entries[2], cols), 8: ncgr_new, 12: ncer_new, 19: nanr_new}


def _sections_of(d):
    """[(magic, start, size)] of a Nitro file's sections."""
    hsize, nsec = struct.unpack_from('<HH', d, 0xC)
    out, off = [], hsize
    for _ in range(nsec):
        mg, sz = struct.unpack_from('<4sI', d, off); out.append((mg, off, sz)); off += sz
    return out


def _nitro(d, sections):
    body = b''.join(sections)
    return d[:8] + struct.pack('<IHH', 0x10 + len(body), 0x10, len(sections)) + body


# ---------------------------------------------------------------------------------------------------- the places

def _world():
    w = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    pz = json.load(open(os.path.join(PEARL, 'zones.json')))
    b2 = {int(k): v['b2_zone'] for k, v in w['zones'].items()}
    b2.update({int(k): v['b2_zone'] for k, v in w['rooms']['zones'].items()})
    return w, pz, b2


def _matrix_cells():
    m = json.load(open(os.path.join(PEARL, 'matrices', '000.json')))
    cells = {}
    for z, row in enumerate(m['headers']):
        for x, h in enumerate(row):
            if h: cells.setdefault(h, []).append((x, z))
    return cells


def towns():
    """Pearl's 18 Fly towns (fly_table entries 0-16 and the Pokémon League's own block): header, shape, colour, cells,
    icon (sprite position on Black 2's screen), landing (x, z)."""
    spawn = spawn_table()
    mcells = _matrix_cells()
    out = []
    for e in fly_table():
        if e['special'] in (1, 2):                    # Pal Park's and Victory Road's own spots: not separate places
            continue
        cx, cz = e['x'] // GRID, e['y'] // GRID
        fh, fx, fz = spawn[e['index']]
        if e['special'] == 3:                         # the League: its south spot (see the module docstring)
            fh, fx, fz = next(v for k, v in spawn.items() if v[0] == e['header'] and k != e['index'])
        assert fh == e['header'], e
        shape_cells = [(cx + dx, cz + dz) for dx, dz in SHAPE_CELLS[e['shape']]]
        assert set(shape_cells) <= set(mcells[e['header']]), e
        out.append(dict(header=e['header'], shape=e['shape'], colour=e['colour'], cells=mcells[e['header']],
                        icon=(e['x'] + GX, e['y'] + GY), landing=(fx, fz)))
    assert len(out) == 18, len(out)
    return out


def _capsule(cells, radius=None):
    """A hit capsule over grid cells: the segment between the two farthest cell centres, its radius covering a cell."""
    pts = [cell_px(*c) for c in cells]
    a, b = max(((p, q) for p in pts for q in pts), key=lambda pq: (pq[0][0] - pq[1][0]) ** 2 + (pq[0][1] - pq[1][1]) ** 2)
    xs, zs = {c[0] for c in cells}, {c[1] for c in cells}
    r = radius or (4 if len(xs) == 1 or len(zs) == 1 else 7)
    return (a[0], a[1], b[0], b[1], r)


def _centre(cells):
    pts = [cell_px(*c) for c in cells]
    return (round(sum(p[0] for p in pts) / len(pts)), round(sum(p[1] for p in pts) / len(pts)))


EXTRA = [('MAP_VERITY_LAKEFRONT', None), ('MAP_BATTLE_PARK', [(20, 12)])]   # outdoor places with no area data
CORONET_WEST = [(11, 19), (11, 20), (11, 21), (11, 22)]                    # Mt. Coronet's second run (Pearl's blocks)
CORONET_MAIN = [(12, z) for z in range(12, 20)]


def locations():
    """The map's places in record order (module docstring): dicts key, type, zone, pearl (map header), icon, snap,
    cap, snap_r, fly_flag, can_fly, show, cells, desc (bank 556 line), anims, landing."""
    w, pz, b2 = _world()
    by_mapsec = {}
    for z in pz:
        if z['id'] in b2: by_mapsec.setdefault(z['mapsec'], []).append(z['id'])
    dungeons, fields = area_places()
    blk = blocks()
    mcells = _matrix_cells()
    def zone_of(header):
        if header in b2: return b2[header]
        cand = sorted(by_mapsec.get(pz[header]['mapsec'], []))
        return b2[cand[0]] if cand else None
    def desc(cells, landmark=False):
        for c in cells:
            if c in blk:
                area, land, _ = blk[c]
                return land if landmark and land != 0xFFFF else area
        return None
    out = []
    # a cave's hit circle stays clear of the towns' cursor points (Snowpoint Temple is on Snowpoint's upper cell)
    snaps = [t['icon'] for t in towns()]
    for k, (x, z, coronet, header) in enumerate(dungeons):
        zone = zone_of(header)
        assert zone is not None, pz[header]['name']
        cells = CORONET_MAIN if coronet else [(x, z)]
        c = cell_px(x, z)
        r = min([3] + [max(1, abs(c[0] - sx) + abs(c[1] - sy) - 1) for sx, sy in snaps if (sx, sy) != c])
        lake = pz[header]['name'].startswith('MAP_LAKE_')
        out.append(dict(key=pz[header]['name'][4:], kind='dungeon', area_index=k + 1, type=TYPE_ROUTE, zone=zone,
                        pearl=header, icon=c, snap=c, cap=_capsule(cells, 3) if coronet else (*c, *c, r), snap_r=r,
                        cells=cells, marker=(x, z), desc=desc(cells, landmark=not coronet and not lake)))
        if coronet:
            out.append(dict(out[-1], key=out[-1]['key'] + '#1', cells=CORONET_WEST, cap=_capsule(CORONET_WEST, 3),
                            icon=_centre(CORONET_WEST), snap=_centre(CORONET_WEST), main=False))
    flags = fly_flags()
    for t in towns():
        zone = b2[t['header']]
        vis, unvis = town_icons().index((t['shape'], PAL_TOWN + t['colour'])), town_icons().index((t['shape'], PAL_UNVISITED))
        out.append(dict(key=pz[t['header']]['name'][4:], kind='town', type=TYPE_TOWN_ICON, zone=zone, pearl=t['header'],
                        icon=t['icon'], snap=t['icon'], cap=_capsule(t['cells'], 4 if len(t['cells']) < 3 else 6),
                        snap_r=6, cells=t['cells'], fly_flag=flags[zone], can_fly=1, desc=desc(t['cells']),
                        anims=(ICON_ANIM0 + vis) | (ICON_ANIM0 + unvis) << 8, landing=t['landing']))
    town_headers = {t['header'] for t in towns()}
    for k, (x, z, fw, fh, cells, header) in enumerate(fields):
        if header in town_headers: continue
        zone = b2[header]
        c = _centre(cells)
        out.append(dict(key=pz[header]['name'][4:], kind='field', area_index=k + 1, type=TYPE_ROUTE, zone=zone,
                        pearl=header, icon=c, snap=c, cap=_capsule(cells), snap_r=0, cells=cells, desc=desc(cells)))
    for name, cells in EXTRA:
        header = next(z['id'] for z in pz if z['name'] == name)
        cells = cells or mcells[header]
        c = _centre(cells)
        out.append(dict(key=name[4:], kind='extra', type=TYPE_ROUTE, zone=zone_of(header), pearl=header, icon=c, snap=c,
                        cap=_capsule(cells), snap_r=0, cells=cells, desc=desc(cells)))
    for l in out:
        l.setdefault('fly_flag', 0xFFFF); l.setdefault('can_fly', 0); l.setdefault('show', 0xFFFF)
        l.setdefault('anims', 0); l.setdefault('main', True)
    assert not any(l['zone'] in (0, 424, 490) for l in out), 'zones 0/424/490 have Black 2 special cases in ov144'
    assert len(out) < NREC, len(out)
    return out


def dummy_record(locs):
    """The filler up to 85 records (Black 2's loops and the Pokédex's habitat format are made for 85): Twinleaf's zone
    (zone lookups find the real record first), a route without icon whose hit circle (radius 0 at (0, 0)) the cursor
    (y >= 8) never reaches."""
    return dict(key='(filler)', kind='filler', type=TYPE_ROUTE, zone=next(l['zone'] for l in locs if l['key'] == 'TWINLEAF'),
                pearl=None, icon=(8, 8), snap=(8, 8), cap=(0, 0, 0, 0, 0), snap_r=0, fly_flag=0xFFFF, can_fly=0,
                show=0xFFFF, cells=[], desc=None, anims=0, main=True)


def desc_lines():
    """Pearl's bank 556 lines the places use, in data/text_overrides/town_map.json's order."""
    return sorted({l['desc'] for l in locations() if l['desc'] is not None})


def text_line(n):
    """The town_map system text line of Pearl's bank 556 line n (appended after Black 2's lines, --text)."""
    lines = desc_lines()
    return B2_TOWNMAP_LINES + lines.index(n)


def write_text():
    import gen4_text
    bank = gen4_text.bank(556)
    lines = desc_lines()
    doc = ('Pearl\'s town map descriptions (the user\'s dump, bank 556, through b2tools/gen4_text.py), appended after Black '
           '2\'s 163 town_map lines in this order (b2tools/patches/town_map.py text_line; regenerate with python3 '
           'b2tools/patches/town_map.py --text). Each Sinnoh place shows its area\'s line, a cave or lake its landmark '
           'line, as Pearl\'s top screen does.')
    out = {'_doc': doc, TOWNMAP_TEXT: {f'+TownMap_Text_Pearl{n:03d}': gen4_text.b2_line(bank[n]) for n in lines}}
    path = os.path.join(ROOT, 'data', 'text_overrides', 'town_map.json')
    json.dump(out, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    return f'{len(lines)} lines -> {path}'


def dex_highlights(locs):
    """The Pokédex area page's highlight of each record (fields 24-26: anim, x, y; patches/sinnoh_pokedex.py draws the
    cells): the record's grid cells filled (7 x 7 pixels each). -> ([(anim, x, y)], [shape]) where a shape is the
    tuple of (dx, dz) cells from its top-left cell, anim = its index; (x, y) = the top-left cell's top-left pixel."""
    shapes, out = [], []
    for l in locs:
        if not l['cells']:
            out.append((0, 0, 200)); continue
        x0, z0 = min(c[0] for c in l['cells']), min(c[1] for c in l['cells'])
        shape = tuple(sorted((x - x0, z - z0) for x, z in l['cells']))
        if shape not in shapes: shapes.append(shape)
        px, py = cell_px(x0, z0)
        out.append((shapes.index(shape), px - 3, py - 3))
    return out, shapes


def record(l, hl, desc_line):
    r = [0] * 27
    r[0] = l['zone']; r[1] = l['snap_r']
    r[2], r[3] = l['icon']; r[4], r[5] = l['snap']
    r[6:11] = l['cap']
    r[11] = l['type']; r[12] = l['can_fly']; r[13] = r[14] = 0
    r[15] = l['fly_flag']; r[16] = l['show']
    r[17:24] = [0xFFFF] * 7
    if desc_line is not None: r[17] = desc_line
    r[24], r[25], r[26] = hl
    return struct.pack('<27H', *[v & 0xFFFF for v in r])


# ---------------------------------------------------------------------------------------------------- tables

LOST_TOWER = 'MAP_ROUTE_209_LOST_TOWER'
PLACE_OF_SECTION = {80: 'BATTLE_PARK'}            # Battle Tower rooms (no warp out to the Battle Park in the data)


def zone_table(headers, locs):
    """One byte per zone header: the record of the zone's place (0xff: none), for every Sinnoh zone by its Pearl map:
    its own record; a cave's (a dungeon's map section; the Lost Tower's floors their own); else the place its warps
    lead to (a house -> its town or route half, a cavern -> its lake, Spring Path -> Sendoff Spring); else any record
    of its map section. -> (table, the Sinnoh maps left without a place)"""
    import collections
    w, pz, b2 = _world()
    rec = {}
    for i, l in enumerate(locs):
        if l['pearl'] is not None and l['main']: rec.setdefault(l['pearl'], i)
    lost = next(i for i, l in enumerate(locs) if l['key'].startswith('ROUTE_209_LOST_TOWER'))
    cave_sec = {pz[l['pearl']]['mapsec']: i for i, l in enumerate(locs)
                if l['kind'] == 'dungeon' and l['main'] and i != lost}
    any_sec = {}
    for i, l in enumerate(locs):
        if l['pearl'] is not None and l['main']: any_sec.setdefault(pz[l['pearl']]['mapsec'], i)
    by_key = {l['key']: i for i, l in enumerate(locs)}
    for pid, key in (('MAP_SPRING_PATH', 'SENDOFF_SPRING'),):
        rec[next(z['id'] for z in pz if z['name'] == pid)] = by_key[key]
    def direct(pid):
        name = pz[pid]['name']
        if pid in rec: return rec[pid]
        if name.startswith(LOST_TOWER): return lost
        if pz[pid]['mapsec'] in cave_sec: return cave_sec[pz[pid]['mapsec']]
        if pz[pid]['mapsec'] in PLACE_OF_SECTION: return by_key[PLACE_OF_SECTION[pz[pid]['mapsec']]]
        return None
    def warps(pid):
        p = os.path.join(PEARL, 'events', f"{pz[pid]['events']:03d}.json")
        return [e['dest_header_id'] for e in json.load(open(p))['warp_events']] if os.path.exists(p) else []
    t = bytearray([0xFF] * len(headers))
    unplaced = []
    for pid, zone in b2.items():
        r = direct(pid)
        if r is None:                                 # breadth first through the warps
            seen, todo = {pid}, collections.deque(warps(pid))
            while todo and r is None:
                q = todo.popleft()
                if q in seen or q >= len(pz): continue
                seen.add(q)
                r = direct(q)
                if r is None: todo.extend(warps(q))
        if r is None: r = any_sec.get(pz[pid]['mapsec'])
        if r is None:
            unplaced.append(pid); continue
        if zone < len(t): t[zone] = r
    # lifts (no warps: their scripts move the player) -> the place of the map whose name shares the most with theirs
    placed = {pz[pid]['name']: t[zone] for pid, zone in b2.items() if zone < len(t) and t[zone] != 0xFF}
    left = []
    for pid in unplaced:
        name = pz[pid]['name']
        best = max(placed, key=lambda n: len(os.path.commonprefix([n, name])))
        if name.endswith('_ELEVATOR') and os.path.commonprefix([best, name]).count('_') >= 2:
            t[b2[pid]] = placed[best]
        else:
            left.append(name)
    return bytes(t), left


def refine_zones(ztab, locs):
    """Sinnoh's matrix-0 zones whose place is not a town: the player's marker goes on their own cell."""
    w, pz, b2 = _world()
    return sorted({v['b2_zone'] for v in w['zones'].values()
                   if ztab[v['b2_zone']] != 0xFF and locs[ztab[v['b2_zone']]]['type'] != TYPE_TOWN_ICON})


def data_file(headers):
    """a/0/8/4 #21 (little-endian; sinnoh_pokedex reads it too): records at 0, NREC x 54 B (27 u16) | zone table at ZT
    (u8 record per zone header, 0xff none) | refine list at REF (u16 count, u16 0, u16 zones) | icon anims at ANIM (u16
    per record: visited | not visited << 8, 0 = Black 2's) | 16-B trailer 'TMAP', u16 NREC, ZT, zone count, REF, ANIM,
    0.  -> (bytes, layout, locations, zone table, unplaced zones)"""
    locs = locations()
    locs = locs + [dummy_record(locs)] * (NREC - len(locs))
    hls, _ = dex_highlights(locs)
    recs = b''.join(record(l, hl, text_line(l['desc']) if l['desc'] is not None else None) for l, hl in zip(locs, hls))
    ztab, unplaced = zone_table(headers, locs)
    zt_off = (len(recs) + 3) & ~3
    ref_off = (zt_off + len(ztab) + 3) & ~3
    refs = refine_zones(ztab, locs)
    d = recs + bytes(zt_off - len(recs)) + ztab + bytes(ref_off - zt_off - len(ztab))
    d += struct.pack(f'<HH{len(refs)}H', len(refs), 0, *refs)
    anim_off = (len(d) + 3) & ~3
    d += bytes(anim_off - len(d)) + struct.pack(f'<{len(locs)}H', *[l['anims'] for l in locs])
    d += bytes((-len(d)) % 4) + struct.pack('<4s6H', b'TMAP', len(locs), zt_off, len(ztab), ref_off, anim_off, 0)
    lay = dict(n=len(locs), zt_off=zt_off, nzones=len(ztab), ref_off=ref_off, nref=len(refs), anim_off=anim_off)
    return d, lay, locs, ztab, unplaced


def read_file21(files):
    """The built a/0/8/4 #21: dict(n, records=[27-tuples], zone_table=bytes, refine=[zones], anims=[...])."""
    import narcio
    d = narcio.load(files, ARC_GFX)[NEW_FILE]
    i = d.rfind(b'TMAP'); n, zt, nz, ref, anim, _ = struct.unpack_from('<6H', d, i + 4)
    nref = struct.unpack_from('<H', d, ref)[0]
    return dict(n=n, records=[struct.unpack_from('<27H', d, REC * k) for k in range(n)], zone_table=d[zt:zt + nz],
                refine=list(struct.unpack_from(f'<{nref}H', d, ref + 4)), anims=list(struct.unpack_from(f'<{n}H', d, anim)))


def _pad_narc(data, target):
    """Grow a NARC (its GMIF and header sizes) to `target` bytes with zeros, as build_rom.py pad_archives does."""
    data = bytearray(data)
    assert len(data) <= target, (len(data), target)
    off = struct.unpack_from('<H', data, 0xC)[0]
    for _ in range(2): off += struct.unpack_from('<I', data, off + 4)[0]
    assert data[off:off + 4] == b'GMIF'
    extra = target - len(data)
    struct.pack_into('<I', data, off + 4, struct.unpack_from('<I', data, off + 4)[0] + extra)
    struct.pack_into('<I', data, 8, target)
    return bytes(data) + bytes(extra)


# ---------------------------------------------------------------------------------------------------- Fly

RESPAWN_TABLE, RESPAWN_COUNT, RESPAWN_SIZE, OV012 = 0x0216C33C, 82, 20, 0x021503C0
DISCOVER_ON_VISIT = 2
SHARED_FLAG_FIX = {16: 18}                 # entry 16's flag (= entry 15's in Black 2) -> entry 18's (never set)


def _respawn():
    """sinnoh_respawn's entries {town zone: entry (1-based)} (its first entry for the town) and Black 2's flags."""
    import importlib.util
    spec = importlib.util.spec_from_file_location('sinnoh_respawn_tm', os.path.join(HERE, 'sinnoh_respawn.py'))
    m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    vanilla = open(os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build', 'arm9_ov012.bin'), 'rb').read()
    vflag = [struct.unpack_from('<H', vanilla, RESPAWN_TABLE - OV012 + RESPAWN_SIZE * i)[0] for i in range(RESPAWN_COUNT)]
    entry = {}
    for i, zone, x, z, town in m.entries():
        entry.setdefault(town, i)
    flag = {i: vflag[SHARED_FLAG_FIX.get(i, i) - 1] for i in entry.values()}
    assert len(set(flag.values())) == len(flag), flag
    return entry, flag


def fly_flags():
    """{town zone: its arrival flag}: the discovery flag of the town's respawn entry."""
    entry, flag = _respawn()
    return {zone: flag[i] for zone, i in entry.items()}


def respawn_code(code):
    """RESPAWN_ZONE_INFO: "discover on visit" on for each Sinnoh town's first entry (and its flag fix)."""
    entry, flag = _respawn()
    p = os.path.join(code, 'arm9_ov012.bin')
    d = bytearray(open(p, 'rb').read())
    for i in entry.values():
        o = RESPAWN_TABLE - OV012 + RESPAWN_SIZE * (i - 1)
        f, bits = struct.unpack_from('<HH', d, o)
        assert bits & 1, f'respawn entry {i} is not a Sinnoh one (run sinnoh_respawn first)'
        struct.pack_into('<HH', d, o, flag[i], bits | DISCOVER_ON_VISIT)
    _save(p, d)
    return f'Fly: {len(entry)} towns discovered on visit (respawn entries {sorted(entry.values())})'


def landing_problems(locs):
    """Pearl's landing tiles that are not walkable in Sinnoh's converted map (work/world/heights_overworld.json) or
    not in the town's matrix cells."""
    m = json.load(open(os.path.join(PEARL, 'matrices', '000.json')))
    p = os.path.join(ROOT, 'work', 'world', 'heights_overworld.json')
    heights = json.load(open(p)) if os.path.exists(p) else None
    bad = []
    for l in locs:
        if l['kind'] != 'town': continue
        x, z = l['landing']
        cx, cz = x // 32, z // 32
        if m['headers'][cz][cx] != l['pearl']:
            bad.append(f"{l['key']} ({x},{z}): another map's cell"); continue
        chunk = m['maps'][cz][cx]
        if heights is not None and f'{x % 32},{z % 32}' not in heights.get(str(chunk), {}):
            bad.append(f"{l['key']} ({x},{z}): not walkable")
    return bad


def _save(path, data):
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)


LAYOUT = {}


def apply(files):
    import narcio, zoneheaders
    from b2files import arc_path
    path = arc_path(files, ARC_GFX)
    size = os.path.getsize(path)
    entries = narcio.load(files, ARC_GFX)
    assert len(entries) == 21, f'a/0/8/4 has {len(entries)} files (town_map applied twice?)'
    headers, hentries = zoneheaders.load(files)
    blob, lay, locs, ztab, unplaced = data_file(headers)
    new, ntiles = art_entries(entries)
    LAYOUT.update(lay)
    new.append(blob)
    narcio.save(files, ARC_GFX, new)
    d = open(path, 'rb').read()
    open(path + '.tmp', 'wb').write(_pad_narc(d, size)); os.replace(path + '.tmp', path)
    bad = landing_problems(locs)
    assert not bad, bad
    for l in locs:
        if l['kind'] == 'town':
            headers[l['zone']]['fly_x'], headers[l['zone']]['fly_z'] = l['landing']
    zoneheaders.save(files, headers, hentries)
    json.dump(dict(layout=lay, locations=locs, unplaced=unplaced,
                   zone_table={z: locs[r]['key'] for z, r in enumerate(ztab) if r != 0xFF}),
              open(os.path.join(os.path.dirname(files), 'town_map.json'), 'w'), indent=1, default=list)
    return (f"town_map: Pearl's Sinnoh map in BG3 ({ntiles} tiles); {lay['n']} records "
            f"({sum(1 for l in locs if l['kind'] != 'filler')} places), {sum(1 for r in ztab if r != 0xFF)} zones placed "
            f"({len(unplaced)} Sinnoh zones without a place), {lay['nref']} zones on their cell; file {NEW_FILE} "
            f"{len(blob)} B; Fly lands at Pearl's spots in 18 towns")


# ---------------------------------------------------------------------------------------------------- the code (ov144)

GSYS_GetGameData, GameData_GetPlayerState = 0x02016AD8, 0x020171F4
GetZoneFlagsEnableFlyFrom, GFL_ArcSysReadHeapNewLZ = 0x020189CC, 0x0204B4E4
INIT_LOAD_CALL = 0x0219CF18          # init: movs r0, #0x44; bl func_ov144_0219f718 (r5 = gameData, r6 = the param)
FIND_ENTRY = (0x0219E118, 0x0219E154)   # func_ov144_0219e118(module, zone): the player's location entry
COUNT_AT, BOUND_AT = 0x0219DDA4, 0x0219DE3C   # func_ov144_0219dd78: movs r0, #0x54 (entries); cmp r4, #0x55 (records)
JA_BRANCH = 0x0219ECF8               # func_ov144_0219eb6c: bne .L_0219ecfc (Join Avenue lines, zone 490 only)
FREE = (0x0219ECFC, 0x0219EE7C)      # ... the Join Avenue block it jumps to: unreachable once the branch is gone
JA_DEAD = [(0x0219EBD4, bytes.fromhex('11d0'), 0x0219EBFA),   # func_ov144_0219eb6c: the name from JoinAvenue_GetParam
           (0x0219F13E, bytes.fromhex('1fd0'), 0x0219F180)]   # func_ov144_0219f0ec: the same for the banner
TYPE5_CASE = (0x0219E2B8, 0x0219E2CC)   # func_ov144_0219e18c, switch on the record type, case 5 (up to .L_0219e2cc)


class T:
    def __init__(self, base):
        import importlib.util
        spec = importlib.util.spec_from_file_location('exp_share_tm', os.path.join(HERE, 'exp_share.py'))
        es = importlib.util.module_from_spec(spec); spec.loader.exec_module(es)
        self.t = es.Thumb(base)
    def __getattr__(self, k): return getattr(self.t, k)
    def asrs(self, rd, rm, imm): self.t.h(0x1000 | imm << 6 | rm << 3 | rd)
    def subsr(self, rd, rn, rm): self.t.h(0x1A00 | rm << 6 | rn << 3 | rd)
    def strh_off(self, rd, rn, off): assert off % 2 == 0 and off < 64; self.t.h(0x8000 | off >> 1 << 6 | rn << 3 | rd)
    def str_off(self, rd, rn, off): assert off % 4 == 0 and off < 128; self.t.h(0x6000 | off >> 2 << 6 | rn << 3 | rd)


def find_entry_code(lay):
    """func_ov144_0219e118 replacement: the entry whose record index (+8) is the zone table's record for `zone`."""
    t = T(FIND_ENTRY[0])
    t.push([4])
    t.ldr_off(2, 0, 8); t.ldr_off(3, 0, 12)                   # entries, count
    t.cmp(3, 0); t.beq('none')
    t.ldr_off(4, 2, 4)                                        # the records (entry 0's)
    t.ldr_lit(0, 'nz'); t.cmpr(1, 0); t.bcc('hs', 'none')
    t.ldr_lit(0, 'zt'); t.addsr(4, 4, 0)
    t.ldrb_rr(1, 4, 1)                                        # record of the zone (0xff: none)
    t.label('loop')
    t.ldr_off(0, 2, 8); t.cmpr(0, 1); t.beq('found')
    t.addi(2, 0x44); t.subi(3, 1); t.bne('loop')
    t.label('none'); t.movs(0, 0); t.pop([4])
    t.label('found'); t.mov(0, 2); t.pop([4])
    t.word('nz', lay['nzones']); t.word('zt', lay['zt_off'])
    code = t.assemble()
    assert len(code) <= FIND_ENTRY[1] - FIND_ENTRY[0], len(code)
    return code


def load_code(lay):
    """SinnohLoad(heap) at FREE[0], called by init instead of func_ov144_0219f718 (r5 = gameData, r6 = TownMapParam):
    view mode for a scripted call (mode 0 from CallPlaceSelect) in a zone without Fly, the records from a/0/8/4 #21,
    then the player's own cell for a zone of the refine list."""
    t = T(FREE[0])
    t.push([3, 4, 7])
    t.mov(7, 0)                                               # heap
    t.ldr_off(0, 6, 0); t.cmp(0, 0); t.bne('load')            # param->mode
    t.ldrh_off(0, 6, 8); t.bl(GetZoneFlagsEnableFlyFrom)      # param->zoneId
    t.cmp(0, 0); t.bne('load')
    t.movs(0, 1); t.str_off(0, 6, 0)                          # param->mode = 1 (view)
    t.label('load')
    t.movs(0, ARC_GFX); t.movs(1, NEW_FILE); t.movs(2, 0); t.mov(3, 7)
    t.bl(GFL_ArcSysReadHeapNewLZ)
    t.mov(4, 0)
    t.mov(0, 5); t.bl(GameData_GetPlayerState)
    t.mov(1, 0); t.mov(0, 4); t.bl_label('refine')
    t.mov(0, 4); t.pop([3, 4, 7])
    # refine(data r0, PlayerState* r1): a zone of the list -> its record's icon and cursor point = the player's cell
    t.label('refine')
    t.push([3, 4, 5, 6, 7])
    t.mov(4, 0); t.mov(5, 1)
    t.ldrh_off(6, 5, 0)                                       # zone
    t.ldr_lit(0, 'ref'); t.addsr(7, 4, 0)
    t.ldrh_off(3, 7, 0); t.addi(7, 4)                         # count, first zone
    t.label('find')
    t.cmp(3, 0); t.beq('done')
    t.ldrh_off(0, 7, 0); t.cmpr(0, 6); t.beq('found')
    t.addi(7, 2); t.subi(3, 1); t.b('find')
    t.label('found')
    t.ldr_off(0, 5, 4); t.asrs(0, 0, 16); t.asrs(2, 0, 5)    # cell x = tile x / 32 (position fx32, 16 units a tile)
    t.lsls(0, 2, 3); t.subsr(2, 0, 2); t.addi(2, GX)          # 7 * cell + 25
    t.ldr_off(0, 5, 12); t.asrs(0, 0, 16); t.asrs(3, 0, 5)   # cell z
    t.lsls(0, 3, 3); t.subsr(3, 0, 3); t.subi(3, -GY)         # 7 * cell - 34
    t.ldr_lit(0, 'zt'); t.addsr(0, 4, 0); t.ldrb_rr(0, 0, 6)  # the zone's record
    t.movs(1, REC); t.muls(0, 1); t.addsr(0, 4, 0)            # its address
    t.strh_off(2, 0, 4); t.strh_off(3, 0, 6)                  # icon (= the player marker)
    t.strh_off(2, 0, 8); t.strh_off(3, 0, 10)                 # cursor point
    t.label('done')
    t.pop([3, 4, 5, 6, 7])
    type5_code(t)
    t.word('ref', lay['ref_off']); t.word('zt', lay['zt_off']); t.word('anim', lay['anim_off'])
    code = t.assemble()
    assert len(code) <= FREE[1] - FREE[0], len(code)
    return code, FREE[0], t.labels['type5']


def type5_code(t):
    """Type5Anims(entry r0) -> r1 = the entry's anim, also stored as its selected anim (+0x31): the file's icon table
    (u16 per record: visited | not visited << 8; Pearl's icon does not change when selected, the cursor ring shows it)
    when not 0, else Black 2's (0x11 visited / 0x10, 0x12 selected)."""
    t.label('type5')
    t.push([3, 4])
    t.mov(4, 0)
    t.ldr_off(0, 4, 4); t.ldr_off(1, 4, 8); t.lsls(1, 1, 1); t.addsr(0, 0, 1)   # records + index * 2
    t.ldr_lit(1, 'anim'); t.addsr(0, 0, 1); t.ldrh_off(0, 0, 0)               # the record's icon anims
    t.cmp(0, 0); t.bne('t5c')
    t.movs(1, 0x12); t.adds(2, 4, 0); t.addi(2, 0x31); t.strb_off(1, 2, 0)
    t.ldr_off(0, 4, 0x38); t.movs(1, 0x10); t.cmp(0, 0); t.beq('t5r'); t.movs(1, 0x11)
    t.label('t5r'); t.pop([3, 4])
    t.label('t5c')
    t.ldr_off(2, 4, 0x38); t.cmp(2, 0); t.beq('t5u')
    t.lsls(1, 0, 24); t.lsrs(1, 1, 24); t.b('t5s')                            # visited: the low byte
    t.label('t5u')
    t.lsrs(1, 0, 8)                                                           # not visited: the high byte
    t.label('t5s')
    t.adds(2, 4, 0); t.addi(2, 0x31); t.strb_off(1, 2, 0)                    # selected: the same icon
    t.pop([3, 4])


def type5_case(at):
    """Case 5 of the type switch: r1 = Type5Anims(entry), then Black 2's store of r1 at +0x30 (.L_0219e2cc)."""
    t = T(TYPE5_CASE[0])
    t.mov(0, 4); t.bl(at); t.at('back', TYPE5_CASE[1]); t.b('back')
    code = t.assemble()
    return code + bytes.fromhex('c046') * ((TYPE5_CASE[1] - TYPE5_CASE[0] - len(code)) // 2)


def _put(ov, addr, old, new, what):
    at = addr - OV144
    if old is not None:
        assert bytes(ov[at:at + len(old)]) == old, f'{what}: unexpected bytes {bytes(ov[at:at + len(old)]).hex()} at {addr:#x}'
    ov[at:at + len(new)] = new


def apply_code(code):
    if not LAYOUT:                       # (apply ran in another process: recompute from the files tree next to code)
        import zoneheaders
        files = os.path.join(os.path.dirname(code), 'files')
        LAYOUT.update(data_file(zoneheaders.load(files)[0])[1])
    lay = LAYOUT
    path = os.path.join(code, 'arm9_ov144.bin')
    ov = bytearray(open(path, 'rb').read())
    _put(ov, COUNT_AT, bytes.fromhex('5420'), struct.pack('<H', 0x2000 | lay['n']), 'entry count')   # 85: none skipped
    _put(ov, BOUND_AT, bytes.fromhex('552c'), struct.pack('<H', 0x2C00 | lay['n']), 'record loop bound')
    _put(ov, JA_BRANCH, bytes.fromhex('00d1'), bytes.fromhex('c046'), 'Join Avenue branch')
    for at, old_, end in JA_DEAD:
        _put(ov, at, old_, struct.pack('<H', 0xE000 | ((end - (at + 4)) >> 1) & 0x7FF), 'Join Avenue jump')
        _put(ov, at + 2, None, bytes(end - at - 2), 'Join Avenue code')
    load, at, t5 = load_code(lay)
    _put(ov, FREE[0], None, load + bytes(FREE[1] - FREE[0] - len(load)), 'SinnohLoad')
    off = at - (INIT_LOAD_CALL + 4)
    _put(ov, INIT_LOAD_CALL, None, struct.pack('<HH', 0xF000 | (off >> 12) & 0x7FF, 0xF800 | (off >> 1) & 0x7FF),
         'init: load call')
    _put(ov, TYPE5_CASE[0], bytes.fromhex('201c122131300170'), type5_case(t5), 'type 5 anims')
    fe = find_entry_code(lay)
    _put(ov, FIND_ENTRY[0], None, fe + bytes(FIND_ENTRY[1] - FIND_ENTRY[0] - len(fe)), 'find entry')
    _save(path, ov)
    return (f"ov144: {lay['n']} entries, places from a/0/8/4 #{NEW_FILE}, zone table lookup, the player's cell, Pearl's "
            f"icons; " + respawn_code(code))


if __name__ == '__main__':
    if sys.argv[1:] == ['--text']:
        print(write_text())
    elif sys.argv[1:] == ['--check']:
        locs = locations()
        for i, l in enumerate(locs):
            print(i, l['kind'], l['key'], l['zone'], l['icon'], l['cap'], l.get('desc'), hex(l['fly_flag']))
