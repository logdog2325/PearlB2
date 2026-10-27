"""Pearl's roaming Pokémon, Mesprit and Cresselia, and the Trophy Garden's daily Pokémon (2026-10-26; notes/ENCOUNTERS.md
"Roamers"). List it after sinnoh_pokedex (it reads town_map's places and the built wild tables, as the AREA page).

The code is the decomp's src/pearlb2/resident/roamers.c (Black 2's own roamer save, encounter and flee AI, with Pearl's
release, moves, after-battle update, AREA page and Pokétch API added; its comment has Pearl's rules). This patch gives
it gPearlB2Roamers (NULL: Black 2's behaviour, nothing roams):
- the zone of each of Pearl's 29 roaming places (pokediamond's UNK_020F7460 order: Routes 201-222, Valley Windworks
  and Fuego Ironworks outside), from data/sinnoh_world.json;
- each place's spot on the Pokédex's AREA page (the habitat index sinnoh_pokedex gives the zone: its town_map record's
  first record) and its kinds (walking 0x01 / surfing 0x08, from the zone's built wild tables);
- what releases each roamer, the flags Pearl's scenes set (src/include/pearl.h): Mesprit, Verity Cavern's
  FLAG_HIDE_VERITY_CAVERN_MESPRIT (0x1FD) once Spear Pillar is over (VAR_SPEAR_PILLAR_STATE 0x4098 >= 4: the scene sets
  0x1FD right before its CreateRoamer 0; the new game sets it too and Spear Pillar clears it); Cresselia, Fullmoon
  Island's FLAG_MET_CRESSELIA (0x11F, right after its CreateRoamer 1);
- the Trophy Garden's zone and the two works Mr. Backlot's script sets (PVAR_TROPHY_GARDEN_1/2: species, 0 = none).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)

# Pearl's roaming places, by Pearl map id (pokediamond arm9/asm/unk_020603B0.s UNK_020F7460)
PEARL_PLACES = (342, 343, 344, 345, 346, 347, 349, 350, 353, 354, 356, 362, 363, 365, 366,
                367, 371, 373, 380, 382, 383, 385, 388, 391, 467, 392, 395, 200, 204)
# (flag, work, minimum) per Black 2 slot: 0 Mesprit, 1 Cresselia (pearl.h names)
RELEASE = (('PFLAG_01FD', 'PVAR_4098', 4), ('PFLAG_011F', None, 0))
TROPHY_GARDEN = 'MAP_TROPHY_GARDEN'
TROPHY_WORKS = ('PVAR_TROPHY_GARDEN_1', 'PVAR_TROPHY_GARDEN_2')
# Chapter 9b's ids for the Trophy Garden's works (pearl.h after its merge has them; until then these)
TROPHY_WORKS_9B = {'PVAR_TROPHY_GARDEN_1': 0x40F5, 'PVAR_TROPHY_GARDEN_2': 0x40F6}
LAND, WATER = 0x01, 0x08
STATE = {}                                       # apply() -> apply_code()


def pearl_ids():
    """{name: value} of src/include/pearl.h's PFLAG_/PVAR_ defines."""
    out = {}
    for m in re.finditer(r'^#define (P(?:FLAG|VAR)_\w+)\s+(0x[0-9A-Fa-f]+|\d+)', open(
            os.path.join(ROOT, 'src', 'include', 'pearl.h')).read(), re.M):
        out[m.group(1)] = int(m.group(2), 0)
    return out


def table(files):
    """The gPearlB2Roamers blob (resident/roamers.c PearlB2Roamers) and a summary."""
    import importlib.util
    spec = importlib.util.spec_from_file_location('sinnoh_pokedex_roam', os.path.join(HERE, 'sinnoh_pokedex.py'))
    dex = importlib.util.module_from_spec(spec); spec.loader.exec_module(dex)
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = [world['zones'][str(p)]['b2_zone'] for p in PEARL_PLACES]
    tm = dex._tm()
    f21 = tm.read_file21(files)
    recs, ztab = f21['records'], f21['zone_table']
    rzones = [r[0] for r in recs]
    bits = dex.zone_bits(files, ztab)
    places, kinds = [], []
    for z in zones:
        rec = ztab[z] if z < len(ztab) else 0xFF
        places.append(0xFF if rec == 0xFF else rzones.index(rzones[rec]))
        k = 0
        for b in bits.get(z, {}).values():
            k |= b & (LAND | WATER)
        kinds.append(k or LAND)
    ids = pearl_ids()
    rel = [(ids[f], ids[w] if w else 0, n) for f, w, n in RELEASE]
    rooms = world['rooms']['zones']
    tg = next(v['b2_zone'] for v in rooms.values() if v['name'] == TROPHY_GARDEN)
    works = [ids.get(w, TROPHY_WORKS_9B[w]) for w in TROPHY_WORKS]
    blob = struct.pack('<H29H29B29B', len(PEARL_PLACES), *zones, *places, *kinds)
    blob += struct.pack('<2H2H2H', rel[0][0], rel[1][0], rel[0][1], rel[1][1], rel[0][2], rel[1][2])
    blob += struct.pack('<3H', tg, *works)
    assert len(blob) == 136, len(blob)
    missing = [i for i, p in enumerate(places) if p == 0xFF]
    return blob, (f'{len(zones)} places (zones {zones[0]}..{zones[-1]}; AREA page spots for '
                  f'{len(zones) - len(missing)}{", none for " + str(missing) if missing else ""}; '
                  f'{sum(1 for k in kinds if k & WATER)} with surfing), release flags '
                  f'{[hex(r[0]) for r in rel]}, Trophy Garden zone {tg} works {[hex(w) for w in works]}')


def apply(files):
    STATE['blob'], STATE['summary'] = table(files)
    return 'roamers: ' + STATE['summary']


def apply_code(code):
    import decomp, resident
    slot = decomp.symbol('gPearlB2Roamers', code)
    if slot is None:
        return 'roamers: no gPearlB2Roamers in this decomp: nothing roams'
    blob = STATE['blob']
    old = struct.unpack('<I', resident.read(code, slot, 4))[0]
    if old:                                      # a quick non-clean build: the table is there, rewrite it in place
        assert struct.unpack('<H', resident.read(code, old, 2))[0] == len(PEARL_PLACES), 'gPearlB2Roamers: not the table'
        resident.write(code, old, blob)
        base = old
    else:                                        # the table in PearlB2's resident section (b2tools/resident.py)
        base, end, _ = resident.install(code, lambda b: (blob, {}))
        resident.write(code, slot, struct.pack('<I', base))
    return f'roamers: table {len(blob)} B at {base:#x} (gPearlB2Roamers {slot:#x}); {STATE["summary"]}'
