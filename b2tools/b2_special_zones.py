"""Black 2 zone ids that Black 2's code treats specially, from pokebw2's decompiled C (every ZONE_ name in src/).

    python3 b2_special_zones.py        -> ../data/b2_special_zones.json  {"avoid": [...], "harmless": {...}}

A zone named only in HARMLESS files is fine to reuse (data about places, not behaviour). Every other mention is
behaviour (field gimmicks, rails, cameras, weather, warps, evolution places, Union Room/PWT/Subway, ...): those ids
are avoided by allocate_sinnoh.py, on top of HoennB2's list (read from arm9 tables, still needed for the ~13% of the
code not decompiled yet). 427 is used on purpose (the new-game zone; its camera override is a known item).
"""
import glob, json, os, re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
HARMLESS = {
    'zukan_common.c', 'zukan_habitat.c',            # Pokédex habitat pages: which zones a species is shown in
    'local_tvt_calldata.c', 'local_tvt_callmode.c', # Xtransceiver call locations
    'demo3d_data.c',                                 # 3D cutscene data, only when a script starts that cutscene
    'field_encount_st.c',                            # the roaming Pokémon's route circuit (useful for Sinnoh's)
    'townmap_util.c', 'townmap.c',                   # town map positions (rewritten with Sinnoh's map)
}


def scan():
    names = {}
    for line in open(os.path.join(DECOMP, 'build', 'include', 'generated', 'constants', 'zones.h')):
        m = re.match(r'#define (ZONE_\w+) (\d+)', line)
        if m: names[m.group(1)] = int(m.group(2))
    files = {}
    for p in glob.glob(os.path.join(DECOMP, 'src', '**', '*.c'), recursive=True):
        text = open(p, encoding='utf-8', errors='ignore').read()
        for n in set(re.findall(r'\bZONE_[A-Z0-9_]+\b', text)):
            if n in names: files.setdefault(names[n], set()).add(os.path.basename(p))
    avoid = sorted(z for z, fs in files.items() if fs - HARMLESS)
    harmless = {str(z): sorted(fs) for z, fs in files.items() if not fs - HARMLESS}
    return avoid, harmless, {str(z): sorted(fs) for z, fs in files.items() if fs - HARMLESS}


if __name__ == '__main__':
    avoid, harmless, why = scan()
    json.dump({'_doc': __doc__.strip().splitlines()[0], 'avoid': avoid, 'why': why, 'harmless': harmless},
              open(os.path.join(ROOT, 'data', 'b2_special_zones.json'), 'w'), indent=1)
    print(f'{len(avoid)} zones avoided, {len(harmless)} harmless mentions')
