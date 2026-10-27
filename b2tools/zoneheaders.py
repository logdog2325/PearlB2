"""Read/write Black 2 zone headers (a/0/1/2: one file, 0x30 bytes per zone; Black 2 has 615). Field layout from the
decomp's include/asm/zone_header.inc (ZoneHeader macro).

More zones (notes/ZONE_TABLE.md, 2026-10-26): the game reads a header at zone * 0x30 with no bound, so zones are
appended after Black 2's 615. Zone 615 is Black 2's "no zone" value (the header cache, the place banner, a new save,
the gate boards): it stays a dummy that no place uses (NO_ZONE). Appended zones are 616-1023 (the game beacon keeps a
zone in 10 bits); 0x7FF and 0xFFFF mean "no zone" in our tables and are never zones. `extend` appends the dummy and
blank room headers; the room patches fill in the ones they install."""
import os, struct
import narcio

FMT = struct.Struct('<BBHHHHH4HHHHHHHHH3I')   # 0x30 bytes
FIELDS = ['map_type', 'npc_cache', 'area', 'matrix', 'scripts', 'init_scripts', 'text', 'bgm0', 'bgm1', 'bgm2', 'bgm3',
          'enc', 'entities', 'parent', 'place_word', 'weather_word', 'flags', 'cam_bound', 'icon_word', 'fly_x', 'fly_y', 'fly_z']
assert FMT.size == 0x30

B2_ZONES = 615                  # Black 2's own zones, 0-614
NO_ZONE = 615                   # Black 2's "no zone" value: the dummy header, never a place
FIRST_APPENDED, LAST_APPENDED = 616, 1023
NOT_ZONES = (0x7FF, 0xFFFF)     # "no zone" in the 11-bit rail/camera tables and in zone lists (zone_effects)
VANILLA = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'external', 'pokebw2', 'build', 'b2_us',
                       'files')
# The blank header: a copy of Black 2's Floccesy house (441, sinnoh_rooms' building template: one-cell map type 16)
# with nothing of its own: the empty script, init script and entity files, no wild Pokémon, no place name, no camera
# boundary, no preloaded sprites, its own zone as parent
BLANK_TEMPLATE = 441
EMPTY_ENTITIES, EMPTY_SCRIPTS, EMPTY_INIT, NO_ENCOUNTERS, NO_PRELOAD = 3, 6, 7, 0x1FFF, 24


def parse(data):
    out = []
    for i in range(len(data) // 0x30):
        h = dict(zip(FIELDS, FMT.unpack_from(data, 0x30 * i)))
        h['encounters'], h['enc_slot'] = h['enc'] & 0x1FFF, h['enc'] >> 13
        h['place'], h['place_display'] = h['place_word'] & 0x3FF, h['place_word'] >> 10
        out.append(h)
    return out

def build(headers):
    out = b''
    for h in headers:
        h = dict(h)
        h['enc'] = (h['encounters'] & 0x1FFF) | (h['enc_slot'] << 13)
        h['place_word'] = (h['place'] & 0x3FF) | (h['place_display'] << 10)
        out += FMT.pack(*[h[f] for f in FIELDS])
    return out

def load(files):
    entries = narcio.load(files, 12)
    return parse(entries[0]), entries

def save(files, headers, entries):
    entries[0] = build(headers) + entries[0][len(headers) * 0x30:]
    narcio.save(files, 12, entries)


def is_appended(zone):
    return FIRST_APPENDED <= zone <= LAST_APPENDED


def check_zone(zone):
    """A zone a place may use: Black 2's 0-614 or an appended one (never 615, 0x7FF, 0xFFFF, nor past 1023)."""
    assert 0 <= zone < B2_ZONES or is_appended(zone), f'zone {zone}: not a usable zone id (notes/ZONE_TABLE.md)'
    return zone


def blank(zone, template=None):
    """A header with nothing of its own for `zone` (template: Black 2's own header BLANK_TEMPLATE)."""
    if template is None:
        template = load(VANILLA)[0][BLANK_TEMPLATE]
    h = dict(template)
    h.update(scripts=EMPTY_SCRIPTS, init_scripts=EMPTY_INIT, entities=EMPTY_ENTITIES, encounters=NO_ENCOUNTERS,
             enc_slot=0, parent=zone, place=0, place_display=0, cam_bound=0xFFFF, npc_cache=NO_PRELOAD, fly_x=0,
             fly_y=0, fly_z=0)
    h['place_word'] = 0
    return h


def extend(headers, count):
    """Grow `headers` (Black 2's 615 or more) to `count` zones: 615 the dummy, the others blank headers that the room
    patches fill in. Returns how many were appended."""
    assert count <= LAST_APPENDED + 1, f'{count} zones: appended zones end at {LAST_APPENDED} (notes/ZONE_TABLE.md)'
    assert len(headers) >= B2_ZONES, f'{len(headers)} headers: not a Black 2 zone file'
    template = load(VANILLA)[0][BLANK_TEMPLATE]
    n = len(headers)
    while len(headers) < count:
        headers.append(blank(len(headers), template))
    return len(headers) - n


def zones_needed(world, reserved_end=B2_ZONES):
    """The header count a build needs: one past the highest zone of data/sinnoh_world.json, and at least
    `reserved_end` (allocate_sinnoh.APPEND_END: every reserved block gets a blank header to fill)."""
    used = [z['b2_zone'] for z in world['zones'].values()] + [r['b2_zone'] for r in world['rooms']['zones'].values()]
    for z in used:
        check_zone(z)
    assert reserved_end <= LAST_APPENDED + 1, reserved_end
    return max([B2_ZONES, reserved_end] + [z + 1 for z in used])
