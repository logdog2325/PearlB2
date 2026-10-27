"""Pearl's wild Pokémon in Black 2's encounter tables (a/1/2/7) and the Sinnoh zones' headers (notes/ENCOUNTERS.md).
Runs AFTER sinnoh_world (and after sinnoh_rooms, when that is in the list): it only fills in the zones' encounter ids.

    build_rom.py --clean antipiracy sinnoh_world [sinnoh_rooms] scripts sinnoh_encounters
    python3 b2tools/patches/sinnoh_encounters.py --report      (the Pearl-only lists of notes/ENCOUNTERS.md)

Where the tables go
- Every one of Pearl's 183 encounter files (work/pearl/encounters/NNN.json, b2tools/gen4_extract.py) becomes one
  Black 2 table, appended after Black 2's own 135: **table 135 + N is Pearl's file N** (135..317). All 183 are written
  now, the unused ones too (caves, Great Marsh, ...), so a/1/2/7's layout is fixed from this first version on: adding
  caves later only changes zone headers. (HoennB2 found that the game keeps a/1/2/7's file table in RAM, so savestates
  made on a build with another a/1/2/7 layout get no battles, then the error screen.) Black 2's own 135 tables stay
  untouched, so a Black 2 zone that is not replaced yet keeps its own wild Pokémon. 183 x 232 bytes = 42 KB, inside
  a/1/2/7's 64 KB build reserve (build_rom.py RESERVE).
- One table per file (232 bytes, no seasons): EncData_Load (pokebw2 src/ov012/field_encount_st.c) uses it all year,
  which is the user's "same wild Pokémon all year".
- Zone headers: each overworld zone of data/sinnoh_world.json "zones" gets table 135 + its Pearl zone's encounter file,
  or 0x1FFF (none). Room zones (sinnoh_world.json "rooms": caves, interiors) get theirs only once installed (their
  header's matrix is their own Black 2 matrix, as patches/sinnoh_rooms.py sets it); the others are left alone.
  Zone numbers are read from data/sinnoh_world.json at build time, never written here.

Slots (both games pick slots with the same odds, so Pearl's slot order is kept 1:1)
- Grass (12): Pearl's land slots, level -> min = max = level. Black 2 grass 20/20/10/10/10/10/5/5/4/4/1/1
  (enc_pokeset.c ENCOUNTRATE_RND12 row 0) = Pearl's (pokeplatinum wild_encounters.c GetGroundEncounterSlot).
  Time of day: Pearl's base table is the morning one; by day slots 2-3 become "day", at night "night" (pokeplatinum
  WildEncounters_ReplaceTimedEncounters; the same slots in pokediamond's data). Black 2 has no time of day in its
  tables, so slots 2-3 take **the day species** (user, 2026-10-18); the morning-only and night-only species are listed
  in notes/ENCOUNTERS.md (open item). Pearl's grass and very tall grass both become Black 2 single-battle grass
  (pearl_chunk.py classes 0x04 and 0x08), so both use this table.
- Dark grass (12): a copy of the grass table and rate. pearl_chunk.py makes no dark grass today; if a tile ever becomes
  Black 2 dark grass it still gives Pearl's Pokémon (with Black 2's double battles there).
- Shaking grass (12): empty, rate 0. Pearl has none (its shaking patches are the Poké Radar's, closed by the user);
  with rate 0 Black 2 makes no shaking-grass spots in Sinnoh (effect_encount.c UpdatePhenomenon).
- Surf (5): Pearl's surf slots and levels; odds 60/30/5/4/1 in both games (RND5T1 = GetWaterEncounterSlot).
- Rippling surf (5): empty, rate 0 with ROD_LAYOUT 'pearl3' (no rippling spots: Pearl has none). With the older
  one-rod layouts: a copy of surf (rate 1, Black 2's value), as rippling fishing turned spots on.
- Fishing: Pearl's three rods (user 2026-10-18: "three real rods", patches/pearl_rods.py + src/code/rods.c, HoennB2's
  rods code). ROD_LAYOUT 'pearl3': tables 0-2 (the time of day) hold the **Super Rod**'s slots in their fishing group
  (Black 2's own rod item and code path); table 3 (never picked by the time of day) holds the **Old Rod**'s slots in
  its fishing group and the **Good Rod**'s in its rippling-fishing group, read only by rods.c. Odds: Super Rod =
  Black 2's own 40/40/15/4/1 (RND5T2, the same as Pearl's); Old Rod 60/30/5/4/1, Good Rod 40/40/15/4/1 in rods.c
  (pokeplatinum wild_encounters.c). Rippling surf/fishing rates 0 in tables 0-2: no rippling spots in Sinnoh (Pearl
  has none).
- Swarms (slots 0-1), Poké Radar (4-5, 10-11), the GBA-slot species (8-9), Shellos/Gastrodon east-sea flags and
  Unown letters: swarms, radar and GBA are Pearl features not installed (listed per route in notes/ENCOUNTERS.md);
  Shellos/Gastrodon get form 1 (East Sea) where Pearl's file says so (rate_form0/1, pokeplatinum
  wild_encounters.c); Unown gets the room's letter where Pearl allows one or two, else form 31 (any letter; caves only).

Rates
- Grass and surf: Pearl's chance per step is flat% x rate% (flat 40 on foot, 70 on a bike or in very tall grass),
  after a grace period of 8 - rate/10 steps at 5 % of that (pokediamond overlay 6 ov06_0223C470 / ov06_0223C55C, the
  same as pokeplatinum ShouldGetRandomEncounter). Black 2's rate byte instead picks one of 12 fixed rules that ramp the
  chance up after each reset (field_encount.c ENCOUNT_RATE_CONFIGS; HoennB2 notes/RESEARCH_ENCOUNTERS.md). b2_rule()
  picks the rule whose expected number of battles on walks of 10-100 steps (from a reset, on foot) is closest to
  Pearl's (smallest worst relative error; ties -> lowest id). Results: rate 10 -> rule 11 (13 %), 15 -> 11 (38 %),
  20 -> 3 (17 %), 25 -> 4 (20 %), 30 -> 4 (18 %), 35 -> 4 (27 %). Routes (30) get rule 4: 0, 0, 2, 4, 4, 6 ... %,
  20 % from the 20th step; the same mean of 13 steps per battle as Pearl's. Not reproducible without an engine edit:
  Pearl's bike and very-tall-grass bonus (Black 2 has no bike term).
- Fishing: Pearl bites when Random(100) < rate (pokeplatinum TryGenerateFishingEncounter), Black 2 unless
  Random(100) > rate (BtlSetup_CreateFishing): the byte is Pearl's rate - 1. Tables 0-2: the Super Rod's (75 % -> 74);
  table 3: fishing byte = the Old Rod's (25 % -> 24), rippling-fishing byte = the Good Rod's (50 % -> 49). Black 2 rolls
  the Super Rod's chance for every rod; rods.c then rolls again for the Old and Good Rod ((rod byte + 1) / (Super Rod
  byte + 1): 25/75, 50/75), so each rod bites as often as in Pearl.
- Flags byte 0 (Black 2's usual: a rippling spot at most every 20 steps, 10 %; only after the first badge).
"""
import functools, json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders, version  # noqa: E402

ENC_ARC = 127                    # a/1/2/7
B2_TABLES = 135                  # Black 2's own tables; Pearl file N -> table B2_TABLES + N
PEARL_FILES = 183
NO_ENCOUNTERS = 0x1FFF
TABLE_SIZE = 0xE8
PEARL = os.path.join(ROOT, 'work', version.VERSION)   # gen4_extract.py output (work/pearl)
SPECIES_H = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'include', 'generated', 'constants', 'species.h')

# 'pearl3':     the three rods (patches/pearl_rods.py): tables 0-2 fishing = Super Rod, no rippling; table 3 fishing =
#               Old Rod, rippling fishing = Good Rod (read by rods.c only) (default, user 2026-10-18)
# 'good+super': one rod: fishing = Good Rod, rippling fishing = Super Rod, rippling spots on (before the rods patch)
# 'good':       one rod: fishing = Good Rod, no rippling spots at all (Super Rod table unused)
ROD_LAYOUT = 'pearl3'
ROD_TABLE = 3                    # rods.c reads the Old/Good Rod slots from this table (TIME_TABLES never picks it)
RIPPLING_ON = 1                  # Black 2's rate byte for rippling surf/fishing (any non-zero: they never roll)
FLAGS = 0

# Black 2's 12 rules {increase, period, max, safe steps} (pokebw2 src/ov036/field_encount.c ENCOUNT_RATE_CONFIGS)
B2_RULES = [(3, 1, 13, 2), (3, 1, 19, 2), (2, 3, 13, 3), (2, 2, 19, 2), (5, 1, 31, 2), (5, 1, 31, 2),
            (2, 18, 7, 8), (2, 9, 7, 4), (2, 3, 13, 3), (1, 12, 7, 3), (1, 9, 7, 3), (2, 3, 13, 3)]
WALKS = (10, 15, 20, 30, 50, 100)

# Unown letter groups by Pearl's unown_table (1-based; pokeplatinum WildEncounters_UnownTables, forms A=0 .. Z=25,
# ! = 26, ? = 27, the same numbers in Black 2). Group 1 (20 letters) cannot be spread over 12 slots: form 31 = any.
UNOWN_FORMS = {1: None, 2: [5], 3: [17], 4: [8], 5: [13], 6: [4], 7: [3], 8: [26, 27]}
ANY_FORM = 31


# ---------------------------------------------------------------------------------------------------- rates

def pearl_chances(rate, flat=40, steps=101):
    """Pearl's battle chance on the i-th encounter-tile step after a battle or map load."""
    p = flat * rate / 10000
    grace = 8 - min(8, rate // 10)
    return [0.05 * p if i < grace else p for i in range(steps)]


def b2_chances(rule, steps=101):
    """Black 2's chance on the n-th step after a reset (HoennB2 RESEARCH_ENCOUNTERS.md closed form, measured)."""
    inc, period, top, safe = B2_RULES[rule - 1]
    return [0.0 if n <= safe else min(min(1 + inc * ((n - max(safe, 1)) // period), top) + 1, 100) / 100
            for n in range(1, steps + 1)]


def expected_battles(chances, walk):
    """Expected battles on a walk of `walk` encounter-tile steps from a reset; a battle resets."""
    dist, total = {0: 1.0}, 0.0
    for _ in range(walk):
        nxt = {}
        for since, pr in dist.items():
            c = chances[min(since, len(chances) - 1)]
            total += pr * c
            nxt[0] = nxt.get(0, 0) + pr * c
            nxt[since + 1] = nxt.get(since + 1, 0) + pr * (1 - c)
        dist = nxt
    return total


@functools.lru_cache(maxsize=None)
def b2_rule(rate):
    """(rule id, worst relative error) for a Pearl grass/surf rate; (0, 0) for rate 0."""
    if not rate:
        return 0, 0.0
    want = [expected_battles(pearl_chances(rate), k) for k in WALKS]
    best = None
    for rule in range(1, 13):
        got = [expected_battles(b2_chances(rule), k) for k in WALKS]
        err = max(abs(g - w) / w for g, w in zip(got, want))
        if best is None or err < best[1] - 1e-12:
            best = (rule, err)
    return best


def fishing_byte(rate):
    return max(rate - 1, 0) if rate else 0


# ---------------------------------------------------------------------------------------------------- tables

@functools.lru_cache(maxsize=None)
def species_ids():
    return {m.group(1): int(m.group(2)) for m in
            re.finditer(r'#define\s+(SPECIES_\w+)\s+(\d+)', open(SPECIES_H).read())}


def species_id(name):
    if isinstance(name, int):
        return name
    ids = species_ids()
    if name not in ids:
        raise SystemExit(f'sinnoh_encounters: {name} is not a Black 2 species name')
    return ids[name]


def pearl_file(n):
    return json.load(open(os.path.join(PEARL, 'encounters', f'{n:03d}.json')))


def form_of(enc, name):
    if name == 'SPECIES_SHELLOS':
        return 1 if enc['rate_form0'] else 0
    if name == 'SPECIES_GASTRODON':
        return 1 if enc['rate_form1'] else 0
    if name == 'SPECIES_UNOWN' and enc['unown_table']:
        return UNOWN_FORMS.get(enc['unown_table'])   # list, or None = any letter
    return 0


# Time of day (user 2026-10-18: "small code change so the DS clock picks Pearl's morning/day/night Pokémon"): each file
# holds 4 tables, the slots Black 2 uses for seasons; patches/sinnoh_encounters' apply_code makes the game pick them by
# Black 2's day period instead (morning -> 0, day/evening -> 1, night/midnight -> 2; 3 is a copy of the day table).
TIME_TABLES = ('morning', 'day', 'night', 'day')


def grass_slots(enc, period='day'):
    """Pearl's 12 land slots for a time of day: [(name, form, min, max)]. Pearl's base table is the morning one; by day
    slots 2-3 take the 'day' species, at night the 'night' ones (pokeplatinum WildEncounters_ReplaceTimedEncounters)."""
    out = []
    for i, s in enumerate(enc['land_encounters']):
        name = s['species']
        if period != 'morning' and i in (2, 3) and enc[period][i - 2] not in ('SPECIES_NONE', 0):
            name = enc[period][i - 2]
        out.append([name, s['level'], s['level']])
    return finish(enc, out)


def water_slots(enc, key):
    return finish(enc, [[s['species'], s['level_min'], s['level_max']] for s in enc[key]])


def finish(enc, slots):
    """Forms: Shellos/Gastrodon by the file's east flags; Unown letters spread over its slots in order."""
    out, unown_i = [], 0
    for name, lo, hi in slots:
        f = form_of(enc, name)
        if isinstance(f, list):
            f, unown_i = f[unown_i % len(f)], unown_i + 1
        elif f is None:
            f = ANY_FORM
        out.append((name, f, lo, hi))
    return out


def convert(enc, period='day', rod_table=False):
    """One Black 2 table (232 bytes) for a time of day and a summary {group: (rate, slots)} from a Pearl file.
    rod_table: the 'pearl3' table 3 (Old Rod in the fishing group, Good Rod in the rippling-fishing group)."""
    land, surf = enc['land_rate'], enc['surf_rate']
    grass = grass_slots(enc, period) if land else []
    water = water_slots(enc, 'surf_encounters') if surf else []
    good = water_slots(enc, 'good_rod_encounters') if enc['good_rod_rate'] else []
    sup = water_slots(enc, 'super_rod_encounters') if enc['super_rod_rate'] else []
    old = water_slots(enc, 'old_rod_encounters') if enc['old_rod_rate'] else []
    if ROD_LAYOUT == 'pearl3' and rod_table:
        fish, fish_rate, rip, rip_rate = old, fishing_byte(enc['old_rod_rate']), good, fishing_byte(enc['good_rod_rate'])
        fish_rate, rip_rate = (fish_rate if fish else 0), (rip_rate if rip else 0)
    elif ROD_LAYOUT == 'pearl3':
        fish, fish_rate, rip, rip_rate = sup, fishing_byte(enc['super_rod_rate']), [], 0
    elif ROD_LAYOUT == 'good+super':
        fish, fish_rate, rip, rip_rate = good, fishing_byte(enc['good_rod_rate']), sup, RIPPLING_ON
    elif ROD_LAYOUT == 'good':
        fish, fish_rate, rip, rip_rate = good, fishing_byte(enc['good_rod_rate']), [], 0
    elif ROD_LAYOUT == 'rods':
        fish, fish_rate, rip, rip_rate = sup, fishing_byte(enc['super_rod_rate']), good, 0
    else:
        raise SystemExit(f'ROD_LAYOUT {ROD_LAYOUT!r}')
    if not rip:                                    # no rippling spots on this water at all
        rip_rate = 0
    spots = rip_rate and not (ROD_LAYOUT == 'pearl3')   # 'pearl3': never a rippling spot (rippling surf off too)
    groups = [('grass', b2_rule(land)[0], grass, 12), ('dark_grass', b2_rule(land)[0], grass, 12),
              ('shaking_grass', 0, [], 12), ('surf', b2_rule(surf)[0], water, 5),
              ('rippling_surf', RIPPLING_ON if (water and spots) else 0, water if spots else [], 5),
              ('fishing', fish_rate if fish else 0, fish, 5), ('rippling_fishing', rip_rate, rip, 5)]
    data = bytes([g[1] for g in groups] + [FLAGS])
    for name, rate, slots, count in groups:
        assert len(slots) in (0, count), (name, len(slots))
        for sp, form, lo, hi in slots:
            sid = species_id(sp)
            if not sid:
                raise SystemExit(f'sinnoh_encounters: an empty slot in a used {name} group')
            data += struct.pack('<HBB', sid | form << 11, lo, hi)
        data += bytes(4 * (count - len(slots)))
    assert len(data) == TABLE_SIZE
    return data, {name: (rate, slots) for name, rate, slots, _ in groups}


# ---------------------------------------------------------------------------------------------------- zones

def sinnoh_zones(world, headers):
    """[(pearl zone id, info, b2 zone)] for every overworld zone and every installed room; skipped rooms counted."""
    out = [(int(k), v, v['b2_zone']) for k, v in world['zones'].items()]
    rooms = world.get('rooms', {})
    skipped = 0
    for k, v in rooms.get('zones', {}).items():
        mat = rooms.get('matrices', {}).get(str(v.get('pearl_matrix')), {}).get('b2_matrix')
        if mat is not None and headers[v['b2_zone']]['matrix'] == mat:
            out.append((int(k), v, v['b2_zone']))
        else:
            skipped += 1
    return out, skipped


def apply(files):
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    pzones = json.load(open(os.path.join(PEARL, 'zones.json')))
    entries = narcio.load(files, ENC_ARC)
    if len(entries) not in (B2_TABLES, B2_TABLES + PEARL_FILES):
        raise SystemExit(f'a/1/2/7 has {len(entries)} tables: expected Black 2\'s {B2_TABLES} (run on a --clean build)')
    entries = entries[:B2_TABLES] + [b''.join(convert(pearl_file(n), p, k == ROD_TABLE)[0]
                                              for k, p in enumerate(TIME_TABLES)) for n in range(PEARL_FILES)]
    narcio.save(files, ENC_ARC, entries)

    headers, hentries = zoneheaders.load(files)
    for pid, info in world['zones'].items():
        if headers[info['b2_zone']]['matrix'] != 0:
            raise SystemExit(f"{info['name']} (zone {info['b2_zone']}) is not on matrix 0: run sinnoh_world first")
    zones, skipped = sinnoh_zones(world, headers)
    seen, wild = {}, 0
    for pid, info, b2 in zones:
        if b2 in seen and seen[b2] != pid:
            raise SystemExit(f'zone {b2} is both Pearl zone {seen[b2]} and {pid}')
        seen[b2] = pid
        n = pzones[pid]['encounters']
        headers[b2]['encounters'] = NO_ENCOUNTERS if n is None else B2_TABLES + n
        wild += n is not None
    zoneheaders.save(files, headers, hentries)
    return (f'sinnoh_encounters: {PEARL_FILES} Pearl tables -> a/1/2/7 {B2_TABLES}..{B2_TABLES + PEARL_FILES - 1}; '
            f'{len(zones)} zones set ({wild} with wild Pokémon), {skipped} rooms not installed yet; rods {ROD_LAYOUT}')


# ---------------------------------------------------------------------------------------------------- report

def short(name):
    return name.replace('SPECIES_', '').replace('_', ' ').title() if isinstance(name, str) else str(name)


def report():
    """Markdown lists for notes/ENCOUNTERS.md: rates, and what Black 2 does not get, per overworld zone."""
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    pzones = json.load(open(os.path.join(PEARL, 'zones.json')))
    lines = ['| Pearl rate (grass/surf) | Black 2 rule | worst error in expected battles (walks of 10-100 steps) |',
             '|---|---|---|']
    rates = sorted({r for z in pzones if z['encounters'] is not None
                    for r in (pearl_file(z['encounters'])['land_rate'], pearl_file(z['encounters'])['surf_rate']) if r})
    for r in rates:
        rule, err = b2_rule(r)
        lines.append(f'| {r} | {rule} | {err * 100:.0f} % |')
    lines += ['', '| Zone (Pearl) | table | lost: morning-only | lost: night-only | swarm (slots 0-1) |'
              ' Poké Radar (4-5, 10-11) | GBA slots R/S/E/FR/LG (8-9) |', '|---|---|---|---|---|---|---|']
    for pid, info in sorted(world['zones'].items(), key=lambda kv: kv[1]['name']):
        n = pzones[int(pid)]['encounters']
        if n is None:
            continue
        e = pearl_file(n)
        name = info['name'].replace('MAP_', '').replace('_', ' ').title()
        if not e['land_rate']:
            lines.append(f"| {name} | {B2_TABLES + n} | (water only) | | | | |")
            continue
        land = [s['species'] for s in e['land_encounters']]
        day = grass_slots(e)
        dayset = {s[0] for s in day}
        morning = sorted({short(s) for s in land[2:4] if s not in dayset})
        night = sorted({short(s) for s in e['night'] if s not in dayset and s != 'SPECIES_NONE'})
        swarm = ', '.join(sorted({short(s) for s in e['swarms']}))
        radar = ', '.join(dict.fromkeys(short(s) for s in e['radar']))
        gba = ' / '.join(', '.join(dict.fromkeys(short(s) for s in e[g]))
                         for g in ('ruby', 'sapphire', 'emerald', 'firered', 'leafgreen'))
        lines.append(f"| {name} | {B2_TABLES + n} | {', '.join(morning) or '-'} | "
                     f"{', '.join(night) or '-'} | {swarm} | {radar} | {gba} |")
    return '\n'.join(lines)


if __name__ == '__main__':
    if '--report' in sys.argv:
        print(report())
    else:
        print(__doc__)


# ---------------------------------------------------------------------------------------------------- time of day
LOAD_ENC_DATA, LOAD_ENC_DATA_SIZE, OV012 = 0x0215CE60, 0x18, 0x021503C0


def apply_code(code):
    """EventData_LoadEncData (ov012) -> Pearl_LoadEncData in ITCM (src/code/time_encounters.c): table by time of day."""
    import tempfile
    sys.path.insert(0, os.path.dirname(HERE))
    import itcm
    src = os.path.join(ROOT, 'src', 'code', 'time_encounters.c')
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp))
    p = os.path.join(code, 'arm9_ov012.bin')
    d = bytearray(open(p, 'rb').read())
    vanilla = open(os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build', 'arm9_ov012.bin'), 'rb').read()
    o = LOAD_ENC_DATA - OV012
    assert d[o:o + LOAD_ENC_DATA_SIZE] == vanilla[o:o + LOAD_ENC_DATA_SIZE], 'EventData_LoadEncData was changed'
    jump = itcm.long_jump(LOAD_ENC_DATA, sym['Pearl_LoadEncData'] & ~1)
    d[o:o + len(jump)] = jump
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)
    return f'time of day: EventData_LoadEncData -> {sym["Pearl_LoadEncData"]:#x} ({end - base} B of ITCM)'
