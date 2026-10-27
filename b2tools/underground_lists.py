"""The Grand Underground Hideaways' wild Pokémon for PearlB2 (notes/UNDERGROUND.md section 6): Shining Pearl's lists,
from the public lists copied as data in data/underground_sources/ (no game data):

    python3 underground_lists.py          -> data/underground_pokemon.json (and a cross-check report)

Sources (user and lead, 2026-10-26):
- serebii_sp.json / serebii_bd.json: Serebii's Grand Underground page, each Hideaway type's Shining Pearl / Brilliant
  Diamond lists by stage (Beginning, Strength, Defog, Icicle Badge, Waterfall, National Pokédex) and its rare spawns
  with their %; the MAIN source (user 2026-10-26). Both versions are kept (a Diamond version of PearlB2 may follow:
  patches/underground.py VERSION picks one);
- bulbapedia_hideaways.json: Bulbapedia's 18 Hideaway pages (both versions, the stage, the rare spawns), the cross-check;
- kaphotics_ugspecial.tsv: Kaphotics' table of BDSP's UgSpecialPokemon (pastebin KL36BBgZ): the rare spawns' raw
  weights per version, used for the weights (Serebii's % are these rounded, with two typos: Stargleam's Duskull 5
  for 25, Icy Cave's Glalie 10 for 15);
- serebii_hideaways.json: the spawns per visit (Caves 5-7, Caverns 7-10) and the most water spawns.
The ordinary spawns' weights are not public (Serebii's % column is blank, Bulbapedia says "Varies"; in the game they
come from the Hideaway's type weights and each species' weight per stage, UgRandMark / UgPokemonData): every entry
gets weight 1, and the format keeps a weight per entry for a dump of the user's own BDSP.

Rules (DECISIONS 2026-10-19):
- One version's lists (patches/underground.py VERSION: Shining Pearl's for Pearl NDS); each entry says its stage in
  each version (null: not in that version).
- Stages kept from BDSP (opendpr UgPokeLottery GetStoryNo): 1 from the Explorer Kit, 2 Strength obtained, 3 Defog
  obtained, 4 Icicle Badge, 5 Waterfall obtained, 6 BDSP's National Pokédex. What unlocks each stage here is data
  (data/underground.json "unlock"): stage 6 opens on becoming Champion (the game-clear flag; user 2026-10-26).
- Land and water: a Hideaway with water spawns in BDSP (Serebii's "Max Water Spawns") gives its Water-type species
  on water too (Surf); the ones that only swim (SWIMMERS) only on water. In the others every species is met on land.
- Rare spawns: a battle is the rare spawn with BDSP's share of them: on half the visits one of the visit's spawns is
  rare (opendpr DoLottery, Kaphotics' notes), so 500 / (the average spawns per visit) per mille of the battles.
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
SRC = os.path.join(ROOT, 'data', 'underground_sources')
OUT = os.path.join(ROOT, 'data', 'underground_pokemon.json')
SPECIES_H = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'include', 'generated', 'constants', 'species.h')
PERSONAL_ARC = 16
WATER = 10                                   # Black 2's Water type

# BDSP's Hideaway area ids (UgSpecialPokemon / UgRandMark id) in Serebii's anchor names, PearlB2's order
HIDEAWAYS = [(2, 'spaciouscave', 'Spacious Cave'), (3, 'grasslandcave', 'Grassland Cave'),
             (4, 'fountainspringcave', 'Fountainspring Cave'), (5, 'rockycave', 'Rocky Cave'),
             (6, 'volcaniccave', 'Volcanic Cave'), (7, 'swampycave', 'Swampy Cave'),
             (8, 'dazzlingcave', 'Dazzling Cave'), (9, 'whiteoutcave', 'Whiteout Cave'), (10, 'icycave', 'Icy Cave'),
             (11, 'riverbankcave', 'Riverbank Cave'), (12, 'sandsearcave', 'Sandsear Cave'),
             (13, 'still-watercavern', 'Still-Water Cavern'), (14, 'sunlitcavern', 'Sunlit Cavern'),
             (15, 'bigbluffcavern', 'Big Bluff Cavern'), (16, 'stargleamcavern', 'Stargleam Cavern'),
             (17, 'glacialcavern', 'Glacial Cavern'), (18, 'bogsunkcavern', 'Bogsunk Cavern'),
             (19, 'typhlocavern', 'Typhlo Cavern')]
# Water Pokémon of these lists that only swim (met on water, never on a cave floor, where the Hideaway has water)
SWIMMERS = {'Tentacool', 'Tentacruel', 'Octillery', 'Mantyke', 'Shellder', 'Horsea', 'Staryu', 'Chinchou', 'Lanturn',
            'Qwilfish', 'Corsola', 'Carvanha', 'Clamperl', 'Barboach', 'Whiscash', 'Seel', 'Dewgong', 'Dratini'}
LAND, ON_WATER = 1, 2


def species_ids():
    out = {}
    for line in open(SPECIES_H):
        m = re.match(r'#define SPECIES_(\w+)\s+(\d+)', line)
        if m: out[m.group(1)] = int(m.group(2))
    return out


def species_of(name, ids):
    key = (name.replace('♀', '_F').replace('♂', '_M').replace("'", '').replace('. ', '_').replace('.', '')
           .replace(' ', '_').replace('-', '_').upper())
    assert key in ids, f'no species constant for {name!r} ({key})'
    return ids[key]


def personal_types(files=None):
    sys.path.insert(0, HERE)
    import narcio
    files = files or os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
    per = narcio.load(files, PERSONAL_ARC)
    return {i: (p[6], p[7]) for i, p in enumerate(per) if len(p) > 7}


def load_sources():
    serebii = json.load(open(os.path.join(SRC, 'serebii_sp.json')))
    bulba = {a['n'].lower().replace('_', ''): a for a in json.load(open(os.path.join(SRC, 'bulbapedia_hideaways.json')))}
    counts = json.load(open(os.path.join(SRC, 'serebii_hideaways.json')))
    kap = {}
    for line in open(os.path.join(SRC, 'kaphotics_ugspecial.tsv')):
        if line.startswith('#') or line.startswith('id'): continue
        i, mons, ver, dw, pw = map(int, line.split())
        kap.setdefault(i, []).append((mons, ver, dw, pw))
    return serebii, bulba, counts, kap


def parse_serebii(rows):
    """{stage: [names]}, {name: rare %} of one Hideaway's Serebii rows."""
    stages, rare = {}, {}
    for row in rows:
        st, rest = row.split(':', 1)
        if st == 'R': rare = {n: p for n, p in (x.split('=') for x in rest.split(';'))}
        else: stages[int(st)] = rest.split(';')
    return stages, rare


def build():
    ids = species_ids()
    types = personal_types()
    serebii, bulba, counts, kap = load_sources()
    serebii_bd = json.load(open(os.path.join(SRC, 'serebii_bd.json')))
    report, out = [], {'_doc': __doc__.strip().splitlines()[0] + ' Written by b2tools/underground_lists.py from '
                       'data/underground_sources/ (do not edit).', 'hideaways': []}
    for bid, key, name in HIDEAWAYS:
        per = {'sp': parse_serebii(serebii[key]), 'bd': parse_serebii(serebii_bd[key])}
        # cross-check with Bulbapedia, both versions
        b = bulba[key]
        bver = {'sp': {}, 'bd': {}}
        for e in b['enc'].split(','):
            st, nm, v = e.split(':')
            if 'S' in v: bver['sp'].setdefault(int(st), []).append(nm)
            if 'B' in v: bver['bd'].setdefault(int(st), []).append(nm)
        for ver in ('sp', 'bd'):
            stages = per[ver][0]
            for st in sorted(set(stages) | set(bver[ver])):
                only_s = set(stages.get(st, [])) - set(bver[ver].get(st, []))
                only_b = set(bver[ver].get(st, [])) - set(stages.get(st, []))
                if only_s or only_b:
                    report.append(f'{name} {ver} stage {st}: Serebii only {sorted(only_s)}, '
                                  f'Bulbapedia only {sorted(only_b)}')
        water_spawns = counts[key]['water']
        entries, index = [], {}
        for ver in ('sp', 'bd'):
            for st in sorted(per[ver][0]):
                for nm in per[ver][0][st]:
                    sp = species_of(nm, ids)
                    if sp not in index:
                        t1, t2 = types[sp]
                        flags = LAND
                        if water_spawns and WATER in (t1, t2):
                            flags = ON_WATER if nm in SWIMMERS else LAND | ON_WATER
                        index[sp] = len(entries)
                        entries.append({'species': sp, 'name': nm, 'sp': None, 'bd': None, 'where': flags,
                                        'weight': 1})
                    e = entries[index[sp]]
                    if e[ver] is None: e[ver] = st
        rare = {}
        for mons, ver, dw, pw in kap[bid]:
            r = rare.setdefault(mons, {'species': mons, 'sp': 0, 'bd': 0})
            r['sp'] += pw if ver in (1, 3) else 0
            r['bd'] += dw if ver in (1, 2) else 0
        rare = list(rare.values())
        for ver in ('sp', 'bd'):
            pct = {species_of(n, ids): p for n, p in per[ver][1].items()}
            tot = sum(r[ver] for r in rare)
            for r in rare:
                if not r[ver]: continue
                mine = 100 * r[ver] / tot
                s = pct.get(r['species'])
                if s is None or abs(float(s.rstrip('%')) - mine) > 1.0:
                    report.append(f'{name} {ver} rare #{r["species"]}: Kaphotics weight {r[ver]} = {mine:.1f}%, '
                                  f'Serebii {s}')
        lo, hi = counts[key]['spawns']
        out['hideaways'].append({'bdsp_id': bid, 'key': key, 'name': name, 'spawns': [lo, hi],
                                 'water_spawns': water_spawns, 'rare_per_mille': round(500 / ((lo + hi) / 2)),
                                 'entries': entries, 'rare': rare})
    out['report'] = report
    return out


def main():
    out = build()
    json.dump(out, open(OUT, 'w'), indent=1, ensure_ascii=False)
    n = sum(len(h['entries']) for h in out['hideaways'])
    print(f'{OUT}: {len(out["hideaways"])} Hideaways, {n} entries (both versions), '
          f'{sum(len(h["rare"]) for h in out["hideaways"])} rare entries')
    for line in out['report']:
        print('  ' + line)


if __name__ == '__main__':
    main()
