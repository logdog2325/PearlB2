"""Pearl's story in its zones (notes/STORY.md): for every Pearl zone whose script file has been translated
(src/field_scripts/NNNN_pearl_*.s, b2tools/pearl_story.py), its zone header gets that script file and its text file
(a/0/0/3, patches/pearl_text.py), and its entity file (a/1/2/6) Pearl's people, signs, step triggers and map-script
table (b2tools/pearl_events.py). Runs after sinnoh_events (whose warps it keeps, with their indices) and with
`scripts` and `pearl_text` in the same build:

    build_rom.py ... sinnoh_events ... scripts pearl_text sinnoh_story pearl_starters

Zones not translated yet keep what sinnoh_events gave them (warps only). Zone 427 (Twinleaf, where Black 2 starts a
new game) gets Twinleaf's file, which also holds the new-game scripts 29-31 (src/field_scripts/pearl/newgame.inc).

Checks, which stop the build (they would hang or break the game):
- every script file installed decodes with Black 2's command table, and every script uses only commands allowed at
  its feature level (2 zone init, 1 field load, 0 the rest: b2tools/b2_script_check.py);
- every line a script shows is in its zone's text file, every script a person, sign, trigger or map script runs is
  in its zone's file;
- an NPC's uid is unique in its zone (Pearl's copies of a neighbouring zone's objects, script 0xFFFF, get 200+);
- a zone shows at most 30 different sprites, its zone header's preload list counted (Black 2's 32 billboard
  materials, the player's two included: HoennB2 notes/NPC_LIMIT.md; sinnoh_world NO_PRELOAD).
"""
import glob, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import narcio, zoneheaders  # noqa: E402
from zones import parse_entities, build_entities  # noqa: E402

SPRITE_LIMIT = 30
CLONE_UID = 200


def generated():
    """{a/0/5/6 number: path} and {a/0/0/3 number: path} of the translated Pearl files."""
    s = {int(os.path.basename(p)[:4]): p for p in glob.glob(os.path.join(ROOT, 'src', 'field_scripts', '*_pearl_*.s'))}
    t = {int(os.path.basename(p)[:4]): p for p in glob.glob(os.path.join(ROOT, 'src', 'text', 'script', '*_pearl_*.txt'))}
    return s, t


def script_id(pd, ids, sid):
    """Black 2 script id of a Pearl event's script."""
    import pearl_events
    kind = pearl_events.script_kind(sid)
    if kind in ('none', 'local'):
        return 0 if sid == 0xFFFF else sid
    if kind == 'trainer':
        tid, base = (sid - 2999, 3000) if sid < 5000 else (sid - 4999, 5000)
        return base + ids.trainer_value(tid)
    if kind == 'global':
        return pd.proxy_ids()[sid]
    raise ValueError(f'script {sid} ({kind}) has no Black 2 script here')


def apply(files):
    import pearl_story, pearl_ids, pearl_events, b2_script_check
    sys.path.insert(0, HERE)
    import scripts as scripts_patch
    pd = pearl_story.PearlData()
    ids = pearl_ids.Ids()
    heights = pearl_events.Heights()
    gen_s, gen_t = generated()
    by_num = pd.zones_of_script_file()          # a/0/5/6 number -> the Pearl zones on it (one each on Pearl's shared
                                                # empty file 368: pearl_story.shared_file_zones)
    headers, hentries = zoneheaders.load(files)
    ents = narcio.load(files, 126)
    lists = narcio.load(files, 57)

    def preloaded(idx):
        """Sprite codes of a zone's a/0/5/7 preload list (npc_cache < 24; sinnoh_world NO_PRELOAD)."""
        if idx >= 24: return set()
        n = int.from_bytes(lists[idx][:2], 'little')
        return {int.from_bytes(lists[idx][2 + 2 * k:4 + 2 * k], 'little') for k in range(n)}

    done, notes, problems = [], [], []
    for num, path in sorted(gen_s.items()):
        if num not in by_num:
            continue
        binary = scripts_patch.assemble(path)
        for zone in by_num[num]:
            b2 = pd.b2_zone.get(zone['id'])
            if b2 is None:
                notes.append(f'{zone["name"]}: no Black 2 zone (not installed)')
                continue
            hd = headers[b2]
            hd['scripts'] = num
            tnum = pd.text_file(zone)
            if tnum in gen_t:
                hd['text'] = tnum
            else:
                problems.append(f'{zone["name"]}: no text file {tnum} (run pearl_story.py zones)')
            e, _ = parse_entities(ents[hd['entities']])
            npcs, signs, trigs, skipped = pearl_events.entities(pd, zone, ids, heights,
                                                                lambda s: script_id(pd, ids, s))
            for k, n in enumerate(m for m in npcs if m['clone']):   # Pearl's copies of a neighbour's objects (no
                n['uid'] = CLONE_UID + k                               # script refers to them): their own uids
            uids = [n['uid'] for n in npcs]
            if len(uids) != len(set(uids)):
                problems.append(f'{zone["name"]}: NPC uids repeat: {sorted(uids)}')
            sprites = {n['model'] for n in npcs} | preloaded(hd['npc_cache'])   # a kept Unova list counts too
            if len(sprites) > SPRITE_LIMIT:
                problems.append(f'{zone["name"]}: {len(sprites)} different sprites (Black 2 shows {SPRITE_LIMIT}; '
                                f'preload list {hd["npc_cache"]})')
            nscripts = len(b2_script_check.entries(binary))
            for kind, objs in (('person', npcs), ('sign', signs), ('trigger', trigs)):
                for o in objs:                     # a local script id must be an entry of the zone's file
                    if 0 < o['script'] < 2000 and o['script'] > nscripts:
                        problems.append(f'{zone["name"]}: {kind} script {o["script"]} past the file\'s {nscripts}')
            init, levels = pearl_events.map_script_table(pd, zone, ids)
            bad = [k for k in levels if k > nscripts]
            if bad:
                problems.append(f'{zone["name"]}: map scripts {bad} past the file\'s {nscripts}')
            e.update(npcs=npcs, signs=signs, triggers=trigs)
            ents[hd['entities']] = build_entities(e, ents[hd['entities']], init=init)
            nlines = sum(1 for l in open(gen_t[tnum], encoding='utf-8') if ' = ' in l) if tnum in gen_t else 0
            missing = sorted(n for n in b2_script_check.message_lines(binary) if n >= nlines)
            if missing:
                problems.append(f'{zone["name"]}: lines {missing[:8]} are past its text file\'s {nlines}')
            for p in b2_script_check.check(binary, levels):
                problems.append(f'{zone["name"]} ({os.path.basename(path)}): {p}')
            notes += [f'{zone["name"]}: {s}' for s in skipped]
            done.append(f'{zone["name"]} -> zone {b2} (scripts {num}, text {tnum}, {len(npcs)} people, '
                        f'{len(signs)} signs, {len(trigs)} triggers)')
    narcio.save(files, 126, ents)
    zoneheaders.save(files, headers, hentries)
    log = os.path.join(ROOT, 'work', 'pearl', 'sinnoh_story.log')
    open(log, 'w').write('\n'.join(['installed:'] + done + ['', 'left out:'] + notes + ['', 'problems:'] + problems)
                         + '\n')
    if problems and not os.environ.get('PEARL_STORY_ALLOW'):
        raise SystemExit('sinnoh_story: ' + '; '.join(problems[:10]) + f' (all: {log})')
    return f'sinnoh_story: {len(done)} zones ({len(notes)} objects left out, {len(problems)} problems; {log})'
