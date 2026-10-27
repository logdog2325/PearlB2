"""Sinnoh's weather by season (user 2026-10-20: "snow during the winter"; notes/MAP_LOOK.md "Seasons: grass and
weather"). List it after season_choice (its season hooks) and after sinnoh_world / sinnoh_rooms (the zone headers).

What Black 2 does (pokebw2 src/system/zone_weather.c, src/ov012/calender.c, ov036 WEATHER_OVERLAYS 0x021cfb6c): one
weather per zone change, from GetWeatherAll (arm9 0x02032e94): a stub, the Entralink, Route 7 and birthday weathers,
then the calendar a/0/9/6 (24 zones, a weather for each day of the year, used while the kept season is the clock's),
else the zone header's (bits 0-5). In winter (April, August, December) the calendar snows: weather 1 (flakes) on about
a third of the days in Floccesy Town, Route 20, Pledge Grove, Floccesy Ranch, Virbank City and Complex; 1 or 5 (heavier,
wind-blown; hail in battle) on about two days in three in Driftveil, Route 6, Mistralton, Route 7 and Twist Mountain;
1 or 4 (blizzard; hail) in Icirrus, Dragonspiral Tower and Route 8, with diamond dust (8) one December day. The rest of
Unova never has falling snow; its snow on the ground is in its own winter map chunks (a/0/1/0). Other months give
those zones rain (2) on some days, Routes 14/15 mist (9), Lentimas Town and Reversal Mountain sandstorms (3).
Black 2 has no falling-leaves weather: its 15 weathers are sunny, snow, rain, sandstorm, blizzard, heavy snow,
thunderstorm, gusty rain, diamond dust, mist and five Entralink tints, and the weather graphics (a/0/5/5) hold only
flakes, streaks, rain, sand and sparkles. Its falling leaves are map ribbons in Route 20's autumn chunks (ported by
patches/season_decals.py with its snow patches and leaf clusters).

What this patch does: GetWeatherAll's first call (the stub) goes to SeasonWeather, which answers for every Sinnoh
zone (overworld and rooms, data/sinnoh_world.json). Since 2026-10-25 that is C in the decomp (notes/DECOMP_WORKFLOW.md):
its pearlb2 branch's GetWeatherAll calls PearlB2_SeasonWeather (src/pearlb2/season_weather_itcm.c, in ITCM), and this
patch only puts the zone and day tables in ITCM and their address in gPearlB2SeasonWeather (without them it says
WEATHER_NONE, the game's own answer). With an earlier decomp (no such symbol): our clang copy src/code/season_weather.c
in ITCM and the call pointed at it, as before. The answers:
- outdoors (the overworld outside the north, and the outdoor areas built as rooms: lakes, Eterna Forest, Floaroma
  Meadow, Amity Square, Pal Park, the Great Marsh, Battle Park, ...), seasons on, winter: snow on Black 2's own snow
  days of SNOW_TEMPLATE (default 331, Route 6, as HoennB2's seasons2: weather 1, flakes, on 11-16 days and 5, heavy
  snow with Hail in battle, on 6-9 days of each winter month; HoennB2 uses only the heavy days, its weather 1 being
  greyed for Route 113's ash);
  zones whose Pearl weather is its own (rain on Route 215 and 212, fog on Route 210, ash, sandstorm, Spear Pillar) are
  left out;
- the north (Pearl area 14: Route 216, Route 217, Acuity Lakefront, Snowpoint, Mt. Coronet's sides, Lake Acuity):
  Pearl's own weather all year, seasons on or off: its header weather, and Pearl's day-by-day table (Pearl arm9
  0x020F2364, pokediamond sWeatherTable) for Route 216, Acuity Lakefront and Snowpoint; Pearl -> Black 2: light snow
  -> 1 (flakes), snow -> 5 (heavy snow), blizzard -> 4, diamond dust -> 8;
- everything else of Sinnoh's: its header weather (rooms, caves, buildings: none).
So no Sinnoh zone takes the Unova zone's calendar, Entralink, Route 7 or birthday weather any more (Sandgem had
Lentimas Town's sandstorm on about half the days, seasons on or off; Veilstone's department store elevator and a house
the Unova rain indoors). Seasons off: GameData_GetSeason is spring all year (season_choice), so no seasonal snow.

Switches (test builds or the user's choice): SEASON_SNOW_TEMPLATE=<Black 2 zone> takes that zone's calendar days
(439 Floccesy Town: flakes only, on 10-11 days a month, no battle weather; 113 Icirrus: blizzards); SEASON_SNOW=every
snows (flakes) every winter day.
"""
import json, os, struct, sys, tempfile
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, resident, narcio, zoneheaders  # noqa: E402
from gen4rom import Rom  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
CALENDAR_ARC = 96                       # a/0/9/6: file 0 days (366 per zone), file 1 u16 count + {u16 zone, u16 offset}
SNOW_TEMPLATE = 331                     # Route 6's year (HoennB2 seasons2 snows on Route 6's days too)
NORTH_AREA = 14
WEATHER_MASK = 0x3F
CALL_SITE = 0x02032EAC                  # GetWeatherAll: bl GetDefaultWeatherValue (r0 gameData, r1 zone)
GET_DEFAULT_WEATHER = 0x02159224        # ov012, returns 0xffff
# Pearl's weather (pokediamond constants/weather.h; Platinum overworld_weather.h) -> Black 2's (WEATHER_OVERLAYS)
PEARL_TO_B2 = {0: 0, 1: 0, 5: 1, 6: 5, 7: 4, 11: 8}
B2_SNOW = {1: 1, 5: 2, 4: 3, 8: 1}      # Black 2 calendar snow -> code (1 flakes, 2 heavy snow, 3 blizzard)
SNOW_WEATHER = (0, 1, 5, 4)
SEASONAL_OK = {0, 1, 8, 25}             # Pearl weathers that take winter snow (clear, cloudy, 8, Route 213's sunny year)
PEARL_TABLE, PEARL_TABLE_ZONES = 0x020F2364, 5   # 366 days x (Route 212 S, 213, 216, Acuity Lakefront, Snowpoint)
PEARL_TABLE_FIRST = 24                  # Pearl zone weather 24-28 = the table's columns
WINTER_MONTHS = (4, 8, 12)
MONTH_START = (0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335)


def pearl_table():
    """Pearl's day-by-day weather (pokediamond field_system_rtc_weather.c sWeatherTable), from the dump's arm9."""
    d = Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).data
    off, _, load, size = struct.unpack_from('<4I', d, 0x20)
    o = off + PEARL_TABLE - load
    t = d[o:o + 366 * PEARL_TABLE_ZONES]
    assert set(t) <= {0, 1, 2, 3, 4, 5, 6, 7, 11}, 'Pearl weather table: unexpected values (another Pearl revision?)'
    return [t[PEARL_TABLE_ZONES * day + col] for col in range(PEARL_TABLE_ZONES) for day in range(366)]


def zone_kinds(nzones):
    """({Black 2 zone: kind}, {Black 2 zone: header weather}, [(zone, day, weather)]) (season_weather.c)."""
    import sinnoh_rooms
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    pearl = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    field = sinnoh_rooms.pearl_light_field(rom)
    rooms = world['rooms']
    outdoor_rooms = {int(pa) for pa, a in rooms['areas'].items() if field.get(int(pa)) or a['exterior']}
    table = pearl_table()
    kind, header, exc = {}, {}, []
    zones = [(int(k), v, True) for k, v in world['zones'].items()]
    zones += [(int(k), v, v['pearl_area'] in outdoor_rooms) for k, v in rooms['zones'].items()]
    for pid, z, outdoors in zones:
        b2, w = z['b2_zone'], pearl[pid]['weather']
        assert b2 < nzones, (b2, nzones)
        if z['pearl_area'] == NORTH_AREA:
            if w >= PEARL_TABLE_FIRST:                 # Pearl's weather of the day
                col = table[366 * (w - PEARL_TABLE_FIRST):366 * (w - PEARL_TABLE_FIRST + 1)]
                base = Counter(col).most_common(1)[0][0]
                header[b2] = PEARL_TO_B2[base]
                exc += [(b2, day, PEARL_TO_B2[v]) for day, v in enumerate(col) if v != base]
                kind[b2] = 3
            else:
                header[b2] = PEARL_TO_B2.get(w, 0)
                kind[b2] = 1
        elif outdoors and w in SEASONAL_OK:
            kind[b2] = 2
        else:
            kind[b2] = 1
    return kind, header, exc


def snow_days():
    """366 codes (0 none, 1 flakes, 2 heavy snow, 3 blizzard): Black 2's calendar year of SNOW_TEMPLATE, its snow in
    the winter months only (or SEASON_SNOW=every: flakes every winter day)."""
    if os.environ.get('SEASON_SNOW') == 'every':
        return [1 if any(MONTH_START[m] <= d < MONTH_START[m] + (31 if m != 4 else 30) for m in WINTER_MONTHS) else 0
                for d in range(366)], 'every winter day'
    zone = int(os.environ.get('SEASON_SNOW_TEMPLATE', SNOW_TEMPLATE))
    cal = narcio.load(VANILLA, CALENDAR_ARC)
    n = struct.unpack_from('<H', cal[1], 0)[0]
    offs = dict(struct.unpack_from('<HH', cal[1], 2 + 4 * i) for i in range(n))
    assert zone in offs, f'SEASON_SNOW_TEMPLATE {zone}: not one of Black 2\'s calendar zones {sorted(offs)}'
    year = cal[0][offs[zone]:offs[zone] + 366]
    winter = {d for m in WINTER_MONTHS for d in range(MONTH_START[m], MONTH_START[m] + 31)}
    return [B2_SNOW.get(v, 0) if d in winter else 0 for d, v in enumerate(year)], f"Black 2 zone {zone}'s days"


def _array(ctype, name, values):
    return f'static const {ctype} {name}[{max(1, len(values))}] = {{{", ".join(str(v) for v in values) or "0"}}};\n'


def data_header(nzones, kind, exc, days):
    packed = [0] * ((nzones + 3) // 4)
    for z, k in kind.items(): packed[z >> 2] |= k << ((z & 3) * 2)
    sd = [0] * 92
    for d, c in enumerate(days): sd[d >> 2] |= c << ((d & 3) * 2)
    return (f'#define ZONE_COUNT {nzones}\n#define NORTH_EXC_COUNT {len(exc)}\n'
            + _array('u8', 'ZONE_KIND', packed) + _array('u8', 'SNOW_DAYS', sd)
            + _array('u16', 'SNOW_WEATHER', SNOW_WEATHER)
            + _array('u16', 'NORTH_EXC_ZONE', [z for z, _, _ in exc])
            + _array('u16', 'NORTH_EXC_DAY', [d for _, d, _ in exc])
            + _array('u16', 'NORTH_EXC_WEATHER', [w for _, _, w in exc]))


def apply(files):
    """The north's zone headers: Pearl's weather (the day-by-day zones: their most common one)."""
    headers, entries = zoneheaders.load(files)
    kind, header, exc = zone_kinds(len(headers))
    for z, w in header.items():
        headers[z]['weather_word'] = (headers[z]['weather_word'] & ~WEATHER_MASK) | w
    zoneheaders.save(files, headers, entries)
    return (f'season_weather: north headers {sorted(header.items())}; '
            f'{sum(1 for k in kind.values() if k == 2)} outdoor zones snow in winter, '
            f'{sum(1 for k in kind.values() if k == 1)} keep their header weather, '
            f'{sum(1 for k in kind.values() if k == 3)} north zones by Pearl\'s day ({len(exc)} days differ)')


def table_blob(base, nzones, kind, exc, days):
    """The decomp's PearlB2SeasonWeather (its src/pearlb2/season_weather_itcm.c) at base, with the arrays after it:
    the same values as data_header's, which the clang version compiles in."""
    packed = [0] * ((nzones + 3) // 4)
    for z, k in kind.items(): packed[z >> 2] |= k << ((z & 3) * 2)
    sd = [0] * 92
    for d, c in enumerate(days): sd[d >> 2] |= c << ((d & 3) * 2)
    arrays = [bytes(packed), bytes(sd), struct.pack(f'<{len(SNOW_WEATHER)}H', *SNOW_WEATHER)]
    arrays += [struct.pack(f'<{len(exc)}H', *[e[i] for e in exc]) for i in range(3)]
    header = 4 + 4 * len(arrays)
    out, ptrs = bytearray(), []
    for a in arrays:
        while (header + len(out)) % 4: out += b'\0'
        ptrs.append(base + header + len(out))
        out += a
    return struct.pack('<HH6I', nzones, len(exc), *ptrs) + bytes(out)


def apply_code(code):
    files = os.path.join(os.path.dirname(code), 'files')
    nzones = len(zoneheaders.load(files)[0])
    kind, _, exc = zone_kinds(nzones)
    days, what = snow_days()
    import decomp
    slot = decomp.symbol('gPearlB2SeasonWeather', code)
    if slot is not None:
        # The decomp's GetWeatherAll asks PearlB2_SeasonWeather (C, in ITCM) first: give it the table
        # the table in PearlB2's resident section (b2tools/resident.py), not ITCM
        base, end, _ = resident.install(code, lambda b: (table_blob(b, nzones, kind, exc, days), {}))
        path = os.path.join(code, 'itcm.bin')
        data = bytearray(open(path, 'rb').read())
        at = slot - itcm.ITCM_BASE
        assert data[at:at + 4] == bytes(4), f'gPearlB2SeasonWeather at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
        data[at:at + 4] = struct.pack('<I', base)
        if os.path.islink(path): os.unlink(path)
        open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
        return (f'season_weather: the decomp\'s PearlB2_SeasonWeather {decomp.symbol("PearlB2_SeasonWeather", code):#x}, '
                f'its table {end - base} B at {base:#x}; winter snow on {sum(1 for c in days if c)} days a '
                f'year ({what}), {sum(1 for c in days if c == 2)} heavy, {sum(1 for c in days if c == 3)} blizzard')
    # an earlier decomp: our own clang code in ITCM, and GetWeatherAll's first call pointed at it
    src = os.path.join(ROOT, 'src', 'code', 'season_weather.c')
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        open(os.path.join(tmp, 'season_weather_data.h'), 'w').write(data_header(nzones, kind, exc, days))
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp, includes=[tmp]))
    path = os.path.join(code, 'arm9.bin')
    arm9 = bytearray(open(path, 'rb').read())
    o = CALL_SITE - itcm.ARM9
    assert bytes(arm9[o:o + 4]) == itcm.bl(CALL_SITE, GET_DEFAULT_WEATHER), \
        f'GetWeatherAll: unexpected {arm9[o:o + 4].hex()} at {CALL_SITE:#x}'
    arm9[o:o + 4] = itcm.bl(CALL_SITE, sym['SeasonWeather'] & ~1)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(arm9); os.replace(path + '.tmp', path)
    return (f'season_weather: {end - base} B of ITCM at {base:#x} (SeasonWeather {sym["SeasonWeather"] | 1:#x}); '
            f'winter snow on {sum(1 for c in days if c)} days a year ({what}), '
            f'{sum(1 for c in days if c == 2)} heavy, {sum(1 for c in days if c == 3)} blizzard')
