"""Black 2's game clear for Sinnoh: the Hall of Fame's ending places, Pearl's staff credits and Sinnoh photos
(chapter 8, 2026-10-26; HoennB2's patches/game_clear.py did the same for Hoenn with byte edits, read only).

The Hall of Fame room (src/field_scripts/1478_pearl_pokemon_league_hall_of_fame.s) ends with Black 2's CallGameClear
(pl_ClearGame), which runs ov012 EventGameClear (decomp src/ov012/event_game_clear.c): field close, the Hall of Fame
record (ov265), global 9601 (src/field_scripts/1242_global_9600.s: heal, respawn, Continue in the player's room), the
save (ov295), a map change to Black 2's epilogue zone 0x8b + its script 1, the credits (ov266), a map change to zone
0x1ab + its script 0x20, THE END (ov267). PearlB2's decomp (src/pearlb2/game_clear_itcm.c) sends both map changes to
the Hall of Fame room at the machine and runs the room file's ending entries (pearl_story.GAME_CLEAR_ZONE,
PearlData.game_clear_ids: the ending song before the credits, nothing after), and leaves out the first clear's Unova
Link key screen.

- apply_code(code): that table in ITCM, its address in gPearlB2GameClear (NULL: Black 2's places); checks that global
  9601's Continue zone (521) is still Pearl's player's room;
- apply(files): the credits' command list (a/2/1/5 file 1) for Pearl's staff lines (b2tools/pearl_credits.py; their
  text: data/text_overrides/pearl_credits.json, packed by sinnoh_names), and the photos: data/credits/credits.json and
  its PNGs (Sinnoh map shots, made by b2tools/credits_photos.py) in place of Black 2's Unova ones, as HoennB2 did
  (a/2/1/5: photo p's files 0x15 + 12 p + 3 gender: NCLR, NCGR 8bpp 768 tiles, NSCR; the last picture files 10-12 with
  a sprite over it, files 6-9, cleared). Without credits.json Black 2's photos stay.
List it after sinnoh_names (the text) and the other ITCM users.
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, resident, narcio  # noqa: E402

HOF_TILE = (8, 5)                      # the Hall of Fame room, in front of the machine (Pearl's scene ends there)
HOF_DIR = 1                            # facing it (Black 2 passes 1)
CONTINUE_ZONE, CONTINUE_ROOM = 521, 'MAP_TWINLEAF_RIVAL_HOUSE_2F'   # 1242_global_9600.s's FieldSetNextZone
END_ARC = 215
PIC_FIRST, PICS = 0x15, 12
FINAL = 10                             # files 10/11/12: the last picture
SPRITE_NCGR = 7                        # the sprite over it (ClAct files 6-9)
DATA = os.path.join(ROOT, 'data', 'credits')


def _zones():
    w = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    return {v['name']: v['b2_zone'] for v in list(w['zones'].values()) + list(w['rooms']['zones'].values())}


def table_blob(base):
    import pearl_story
    pd = pearl_story.PearlData()
    zone = pd.by_name[pearl_story.GAME_CLEAR_ZONE]
    before, after = pd.game_clear_ids(zone['id'])
    b2 = pd.b2_zone[zone['id']]
    x, z = HOF_TILE
    blob = struct.pack('<4H3i', b2, HOF_DIR, before, after, x * 16 << 12, 0, z * 16 << 12)
    return blob, dict(zone=b2, before=before, after=after)


def apply_code(code):
    import decomp
    assert _zones()[CONTINUE_ROOM] == CONTINUE_ZONE, \
        f'{CONTINUE_ROOM} is zone {_zones()[CONTINUE_ROOM]}: fix FieldSetNextZone in src/field_scripts/1242_global_9600.s'
    slot = decomp.symbol('gPearlB2GameClear', code)
    if slot is None:
        return 'game_clear: no gPearlB2GameClear in this decomp: Black 2\'s ending places'
    info = {}

    def build(base):
        blob, i = table_blob(base)
        info.update(i)
        return blob, {}
    base, end, _ = resident.install(code, build)  # its table in the resident section (b2tools/resident.py)
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2GameClear at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return (f'game_clear: the ending in zone {info["zone"]} at {HOF_TILE}, scripts {info["before"]}/{info["after"]} '
            f'(gPearlB2GameClear {slot:#x}, {end - base} B)')


# ---- the credits' photos (HoennB2's encoder) ---------------------------------------------------------------------------
def _png_indexed(path):
    from PIL import Image
    im = Image.open(path)
    assert im.mode == 'P' and im.size == (256, 192), f'{path}: indexed 256x192 PNG expected ({im.mode} {im.size})'
    pal = im.getpalette()[:768]
    pal += [0] * (768 - len(pal))
    return bytes(im.getdata()), [tuple(pal[i * 3:i * 3 + 3]) for i in range(256)]


def _bgr555(rgb):
    return sum(((c * 31 + 127) // 255) << (5 * i) for i, c in enumerate(rgb))


def _encode(template_nclr, template_ncgr, template_nscr, pix, pal, photo):
    """The three files of a 256x192 palette-index picture on Black 2's own (the same headers and sizes). photo: the
    tiles of screen rows 2-21, columns 2-29 only (1..560, tile 0 blank); else the whole screen (tiles 0..767)."""
    nclr = bytearray(template_nclr)
    size, off = struct.unpack_from('<II', nclr, 0x20)
    assert size == 0x200
    struct.pack_into('<256H', nclr, 0x18 + off, *[_bgr555(c) for c in pal])
    ncgr = bytearray(template_ncgr)
    th, tw, depth, mapping, tiled, dsize, doff = struct.unpack_from('<HHIIIII', ncgr, 0x18)
    assert depth == 4 and dsize == 768 * 64, (depth, dsize)
    base = 0x18 + doff
    nscr = bytearray(template_nscr)
    w, h, mode, _, ssize = struct.unpack_from('<HHHHI', nscr, 0x18)
    assert (w, h, mode, ssize) == (256, 256, 1, 2048)
    ents = [0] * 1024
    tiles = []
    for ty in range(24):
        for tx in range(32):
            if photo and not (2 <= ty <= 21 and 2 <= tx <= 29):
                continue
            tiles.append((ty, tx, bytes(pix[(ty * 8 + y) * 256 + tx * 8 + x] for y in range(8) for x in range(8))))
    data = bytearray(768 * 64)
    for k, (ty, tx, t) in enumerate(tiles):
        n = k + 1 if photo else k
        data[n * 64:n * 64 + 64] = t
        ents[ty * 32 + tx] = n
    ncgr[base:base + len(data)] = data
    struct.pack_into('<1024H', nscr, 0x24, *ents)
    return bytes(nclr), bytes(ncgr), bytes(nscr)


def apply(files):
    import pearl_credits
    e = narcio.load(files, END_ARC)
    sizes = [len(x) for x in e]
    e[1] = pearl_credits.list_bytes(files)
    msg = f'game_clear: credits list for Pearl\'s staff ({len(e[1]) // 16} commands)'
    spec = os.path.join(DATA, 'credits.json')
    if os.path.exists(spec):
        cfg = json.load(open(spec))
        for p in range(PICS):
            for g, gname in enumerate(('m', 'f')):
                pix, pal = _png_indexed(os.path.join(DATA, cfg['photos'][p][gname]))
                b = PIC_FIRST + 12 * p + 3 * g
                e[b], e[b + 1], e[b + 2] = _encode(e[b], e[b + 1], e[b + 2], pix, pal, True)
        pix, pal = _png_indexed(os.path.join(DATA, cfg['final']['file']))
        e[FINAL], e[FINAL + 1], e[FINAL + 2] = _encode(e[FINAL], e[FINAL + 1], e[FINAL + 2], pix, pal, False)
        spr = bytearray(e[SPRITE_NCGR])
        assert spr[:4] == b'RGCN' and spr[0x10:0x14] == b'RAHC'
        dsize, doff = struct.unpack_from('<II', spr, 0x28)
        spr[0x18 + doff:0x18 + doff + dsize] = bytes(dsize)
        e[SPRITE_NCGR] = bytes(spr)
        msg += f'; {PICS} Sinnoh photos x 2 and the final picture (its sprite cleared)'
    else:
        msg += '; Black 2\'s photos kept (no data/credits/credits.json)'
    assert [len(x) for i, x in enumerate(e) if i != 1] == [s for i, s in enumerate(sizes) if i != 1], \
        'a credits file changed size'
    narcio.save(files, END_ARC, e)
    return msg


if __name__ == '__main__':
    print(table_blob(itcm.ITCM_BASE)[1])
