"""The Grand Underground's data in one place (notes/UNDERGROUND.md): data/underground.json (the layout, rooms, items,
grottos, unlocks), data/underground_pokemon.json (the Hideaways' Pokémon, b2tools/underground_lists.py), the ids of
data/pearl_story_ids.json, and what patches/underground.py, the script generator (underground_scripts.py) and the
offline check (underground_check.py) derive from them: the item ids, the local script ids of the shared script file,
and the encounter table the decomp's src/pearlb2/underground_itcm.c reads (gPearlB2Underground)."""
import functools, json, os, re, struct

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
DATA = os.path.join(ROOT, 'data', 'underground.json')
POKEMON = os.path.join(ROOT, 'data', 'underground_pokemon.json')
IDS = os.path.join(ROOT, 'data', 'pearl_story_ids.json')
ITEMS_TXT = os.path.join(ROOT, 'external', 'pokebw2', 'generated', 'items.txt')
SPECIES_H = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'include', 'generated', 'constants', 'species.h')

PEARL_FLAG_ENTERED_UNDERGROUND = 0x96E      # Pearl's FLAG_ENTERED_UNDERGROUND (the Underground Man's first mission)
ANSWER_WORK = 0x4010                        # map-local work (cleared on a zone change) the "go up?" script answers in;
                                            # no Pearl script runs in the Underground's zones
UNLOCK_KINDS = {'item': 1, 'badge': 2, 'flag': 3}
STAGES, LEVEL_ROWS = 6, 9


@functools.lru_cache(maxsize=None)
def data():
    return json.load(open(DATA))


@functools.lru_cache(maxsize=None)
def pokemon():
    return json.load(open(POKEMON))


@functools.lru_cache(maxsize=None)
def ids():
    return json.load(open(IDS))


def new_id(name):
    """A new id of data/pearl_story_ids.json (PVAR_UG_*, PFLAG_UG_*) as a number."""
    reg = ids()
    if name in reg['new']:
        return int(reg['new'][name]['b2'], 16)
    return reg['new_flags'][name]['b2']


def pearl_flag(flag):
    return ids()['flags'][f'0x{flag:04X}']['b2']


@functools.lru_cache(maxsize=None)
def item_ids():
    names = [l.split('=')[0].strip() for l in open(ITEMS_TXT) if l.strip() and not l.startswith('#')]
    return {n[5:]: i for i, n in enumerate(names)}


@functools.lru_cache(maxsize=None)
def tm_items():
    import tm_audit
    return {m[5:]: it for it, (_, m, _) in tm_audit.machines().items()}


def item(name):
    """An item of data/underground.json: a Black 2 item name (ITEM_ without the prefix) or 'move:X' (the TM or HM
    teaching move X here)."""
    if name.startswith('move:'):
        return tm_items()[name[5:]]
    return item_ids()[name]


@functools.lru_cache(maxsize=None)
def species_ids():
    out = {}
    for line in open(SPECIES_H):
        m = re.match(r'#define SPECIES_(\w+)\s+(\d+)', line)
        if m: out[m.group(1)] = int(m.group(2))
    return out


def hideaways():
    """data/underground.json's Hideaways with their Pokémon (underground_pokemon.json, by key)."""
    lists = {h['key']: h for h in pokemon()['hideaways']}
    return [dict(h, pokemon=lists[h['key']]) for h in data()['hideaways']]


# The shared script file (data/underground.json "files": one for every zone of the Underground): its entries
def script_ids():
    """{'go_up': 1, 'name': [ids by Hideaway], 'item': [ids by item ball], 'shard': [ids], 'fossil': [ids],
    'shard_init': id (the zone init that hides the daily balls until Champion)}."""
    hs = hideaways()
    n_items = sum(len(h['items']) for h in hs)
    n_shards = sum(1 for h in hs if h.get('shard'))
    n_fossils = sum(1 for h in hs if h.get('fossil'))
    out = {'go_up': 1, 'name': list(range(2, 2 + len(hs)))}
    first = 2 + len(hs)
    out['item'] = list(range(first, first + n_items))
    out['shard'] = list(range(first + n_items, first + n_items + n_shards))
    out['fossil'] = list(range(first + n_items + n_shards, first + n_items + n_shards + n_fossils))
    out['shard_init'] = first + n_items + n_shards + n_fossils
    return out


def item_balls():
    """[(Hideaway index, item id, x, z, flag)] in flag order (PFLAG_UG_ITEM_nn)."""
    out = []
    for i, h in enumerate(hideaways()):
        for name, x, z in h['items']:
            out.append((i, item(name), x, z, new_id(f'PFLAG_UG_ITEM_{len(out):02d}')))
    return out


def shard_balls():
    """[(Hideaway index, item id, x, z, daily flag)] (PFLAG_UG_SHARD_n)."""
    out = []
    for i, h in enumerate(hideaways()):
        if h.get('shard'):
            size, x, z = h['shard']
            out.append((i, data()['shard_items'][size], x, z, new_id(f'PFLAG_UG_SHARD_{len(out)}')))
    return out


def fossil_balls():
    """[(Hideaway index, x, z, daily flag)] (PFLAG_UG_FOSSIL_n): the item is one of data "fossil_items" at random."""
    out = []
    for i, h in enumerate(hideaways()):
        if h.get('fossil'):
            x, z = h['fossil']
            out.append((i, x, z, new_id(f'PFLAG_UG_FOSSIL_{len(out)}')))
    return out


def unlock_table():
    """([kind by stage], [value by stage]) of the stages 1-6 (stage 1: always)."""
    kinds, values = [0] * STAGES, [0] * STAGES
    for st, rule in data()['unlock'].items():
        (k, v), = rule.items()
        kinds[int(st) - 1] = UNLOCK_KINDS[k]
        values[int(st) - 1] = item(v) if k == 'item' else v
    return kinds, values


def encounter_lists(version=None):
    """(hideaway records, entries, rares) for the C table: each Hideaway's list in one version (data "version"),
    identical lists shared. An entry: (species, stage | where << 4, weight); a rare: (species, weight). A record's
    spawns: the visible Pokémon a visit (resident/hideaway.c, pearlb2/underground.h UG_SPAWNS_*): BDSP's land minimum and
    maximum, its water maximum, 4 bits each."""
    version = version or data()['version']
    entries, rares, recs, seen = [], [], [], {}
    for h in hideaways():
        p = h['pokemon']
        lst = tuple((e['species'], e[version] | e['where'] << 4, e['weight']) for e in p['entries'] if e[version])
        if lst not in seen:
            seen[lst] = len(entries)
            entries += lst
        rare = [(r['species'], r[version]) for r in p['rare'] if r[version]]
        rfirst = len(rares)
        rares += rare
        (lo, hi), water = p['spawns'], p['water_spawns']
        assert 0 < lo <= hi <= 15 and 0 <= water <= 15 and hi + water <= 16, (h['key'], lo, hi, water)
        recs.append(dict(entry_first=seen[lst], entry_count=len(lst), rare_first=rfirst, rare_count=len(rare),
                         east=1 if h.get('east') else 0, rare_per_mille=p['rare_per_mille'],
                         spawns=lo | hi << 4 | water << 8))
    return recs, entries, rares


def table_blob(base, tunnel_floor_y, version=None):
    """The decomp's PearlB2Underground (src/pearlb2/underground_itcm.c) at base, its arrays after it."""
    d = data()
    recs, entries, rares = encounter_lists(version)
    kinds, values = unlock_table()
    head = struct.pack('<HHHH4HHHhH', d['zones']['tunnels'], d['zones']['first_hideaway'], len(recs),
                       pearl_flag(PEARL_FLAG_ENTERED_UNDERGROUND),
                       *[new_id(f'PVAR_UG_RETURN_{c}') for c in ('ZONE', 'X', 'Y', 'Z')],
                       ANSWER_WORK, script_ids()['go_up'], tunnel_floor_y, new_id('PVAR_UG_HIDEAWAY_BATTLES'))
    head += bytes(kinds) + struct.pack(f'<{STAGES}H', *values)
    assert len(d['levels']) == LEVEL_ROWS
    head += bytes(v for row in d['levels'] for v in row)
    while len(head) % 4: head += b'\0'
    size = len(head) + 12
    hide = b''.join(struct.pack('<HHHBBHH', r['entry_first'], r['entry_count'], r['rare_first'], r['rare_count'],
                                r['east'], r['rare_per_mille'], r['spawns']) for r in recs)
    ent = b''.join(struct.pack('<HBB', s, sw, w) for s, sw, w in entries)
    rar = b''.join(struct.pack('<HH', s, w) for s, w in rares)
    p_hide = base + size
    p_ent = p_hide + len(hide)
    p_rar = p_ent + len(ent)
    return head + struct.pack('<III', p_hide, p_ent, p_rar) + hide + ent + rar


# The C struct's layout (checked against the compiled object by underground_check.py: offsets of the pointers)
BLOB_HEAD_SIZE = None
