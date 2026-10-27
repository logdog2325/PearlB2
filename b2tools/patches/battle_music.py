"""Pearl's battle music (user 2026-10-25, notes/DECISIONS.md; notes/MUSIC.md "Battle music"): the trainer eye-contact
themes, the battle themes and the victory themes, Pearl's own with Sinnoh's music at Rowan's question; with Black 2's
music, Black 2's counterpart where it has a real one, else still Pearl's (data/battle_music.json "unova"). Runs after
sinnoh_music, pearl_trainers and music_choice:

    build_rom.py ... sinnoh_music ... pearl_trainers ... music_choice battle_music ...

apply (files): the Pearl songs data/battle_music.json names go into Black 2's sound archive as new sequences, each
with its own trimmed bank and wave archive (pearl_music.trim, as sinnoh_music does; songs whose trimmed files are the
same, Pearl's SEQ_WINGINGA and SEQ_WINAKAGI, share one sequence). Their ids go to work/world/battle_music.json.

apply_code (code): the decomp's src/pearlb2/battle_music_itcm.c (in ITCM) makes the choices; this puts its tables in
ITCM (itcm.install) and their address in gPearlB2BattleMusic. Per Black 2 trainer class (the class Pearl's class has in
the build: data/pearl_trainer_classes.json, else b2tools/sinnoh_trainers.py CLASS_MAP), two song indexes, Sinnoh's and
Black 2's, for the eye-contact, battle and victory songs; per species the wild battle song; 0 = Black 2's own choice.
The decomp's call sites (pearlb2 branch): scrcmd_trainer.c's three GetTrainerClassEyeBGMID calls -> PearlB2_EyeBGM,
event_battle.c's EventBattleCall_DecideEnvWild (wild battles, the capture demo) / _DecideEnvTrainer calls ->
PearlB2_DecideEnvWild / _DecideEnvTrainer (the game's choice first, then the table), GetWinBGM -> PearlB2_WinBGM (by
the first opponent's class, Pearl's rule), and the Gym Leader last-Pokemon song change only over Black 2's own
SEQ_BGM_VS_GYMLEADER (PearlB2_GymLeaderLastMon: Pearl's and the PWT's leader themes play on).

check_waits: no song here may stand in for a song that ends (Black 2 waits for jingles: HoennB2's v16 freeze); every
pair is checked both ways (Black 2's song -> Pearl's, Pearl's -> its Black 2 counterpart). Budget: every song fits
pearl_music.BUDGET (Black 2's BGM stack frees a pushed song's waves, so one BGM's waves are in the heap at a time).

    python3 battle_music.py      the table (situation -> Pearl -> Black 2), sizes, the melody evidence, check_waits
Test switch: PEARL_TEST_MUSIC=sinnoh|unova forces the answer (as music_choice).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, HERE)
import itcm, pearl_music  # noqa: E402
from sdat import SDAT, DEFAULT  # noqa: E402

DATA = os.path.join(ROOT, 'data', 'battle_music.json')
REGISTRY = os.path.join(ROOT, 'data', 'pearl_trainer_classes.json')
SONGS_JSON = os.path.join(ROOT, 'work', 'world', 'battle_music.json')
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
PDIAMOND = os.path.join(ROOT, 'external', 'pokediamond')
CLASS_COUNT = 236
HEADER = '<HHHHIIIIIBBBB'        # PearlB2BattleMusic (battle_music_itcm.c): 32 bytes
# The songs Black 2 itself plays in these situations (what a Sinnoh song stands in for): eye contact, trainer and wild
# battles (enceff.c SPECIAL_TRAINER_BGM, EventBattleCall_DecideEnvWild, pearl_trainers' PWT versions), victories
B2_SITUATION = {
    'eye': ['SEQ_BGM_EYE_%02d' % i for i in range(1, 14)] + ['SEQ_BGM_EYE_NEO_PLASMA', 'SEQ_BGM_EYE_DANCER',
                                                            'SEQ_BGM_EYE_CLOWN'],
    'battle': ['SEQ_BGM_VS_TRAINER', 'SEQ_BGM_VS_GYMLEADER', 'SEQ_BGM_VS_SHITENNO', 'SEQ_BGM_VS_SHIRONA',
               'SEQ_BGM_VS_HUE', 'SEQ_BGM_VS_ACHROMA', 'SEQ_BGM_VS_SWAN_N', 'SEQ_BGM_VS_NEO_PLASMA', 'SEQ_BGM_VS_IRIS',
               'SEQ_BGM_VS_NEW_G_CIS', 'SEQ_BGM_VS_ELITE_PLASMA', 'SEQ_BGM_VS_BANJIROU', 'SEQ_BGM_VS_RIVAL',
               'SEQ_BGM_VS_DP_LEADER', 'SEQ_BGM_VS_DP_CHAMP'],
    'wild': ['SEQ_BGM_VS_NORAPOKE', 'SEQ_BGM_VS_TSUYOPOKE', 'SEQ_BGM_VS_SHIN', 'SEQ_BGM_VS_MU', 'SEQ_BGM_VS_RAI',
             'SEQ_BGM_VS_KYURAMU', 'SEQ_BGM_VS_KYUROMU', 'SEQ_BGM_VS_SETPOKE', 'SEQ_BGM_VS_MOVEPOKE', 'SEQ_BGM_VS_REGI',
             'SEQ_BGM_VS_UMA', 'SEQ_BGM_VS_DPLEGEND'],
    'victory': ['SEQ_BGM_WIN%d' % i for i in range(1, 7)],
}


def rules():
    return json.load(open(DATA))


def pearl_names(r):
    """Every Pearl song the rules name, by situation."""
    out = {'eye': set(r['eye'].values()) | {r['eye_default']},
           'battle': set(r['battle'].values()) | {r['battle_default']},
           'wild': set(r['wild'].values()) | {r['wild_default']},
           'victory': set(r['victory'].values()) | {r['victory_default'], r['victory_wild']}}
    for kind, names in out.items():
        for n in names:
            assert n in r['unova'], f'battle_music.json: {n} has no "unova" entry'
    return out


def b2_songs():
    import music_choice
    return music_choice.b2_songs()


# ---------------------------------------------------------------- the songs

def apply(files):
    path = os.path.join(files, 'swan_sound_data.sdat')
    B = SDAT(open(path, 'rb').read())
    P = pearl_music.pearl_sdat()
    names = sorted(set().union(*pearl_names(rules()).values()), key=lambda n: P.index('seq', n))
    free_seq = [i for i in range(4, len(B.info['seq'])) if B.info['seq'][i] is None]
    free_bank = [i for i in range(len(B.info['bank'])) if B.info['bank'][i] is None]
    free_wave = [i for i in range(len(B.info['wavearc'])) if B.info['wavearc'][i] is None]
    new_files, ents, songs, same = [], {}, {}, {}
    next_file = len(B.fat)
    for name in names:
        seq, bank, swar, info = pearl_music.trim(P, P.index('seq', name))
        key = (seq, bank, swar, info['volume'])
        if key in same:                                  # the same song under two names (WINGINGA = WINAKAGI)
            songs[name] = dict(songs[same[key]], same_as=same[key])
            continue
        assert free_seq and free_bank and free_wave, 'battle_music: no free sequence / bank / wave archive id'
        sid, bid, wid = free_seq.pop(0), free_bank.pop(0), free_wave.pop(0)
        new_files += [seq, bank, swar]
        ents[('seq', sid)] = SDAT.seq_entry(next_file, bid, volume=info['volume'])
        ents[('bank', bid)] = SDAT.bank_entry(next_file + 1, [wid])
        ents[('wavearc', wid)] = SDAT.wavearc_entry(next_file + 2)
        next_file += 3
        same[key] = name
        songs[name] = {'b2_seq': sid, 'bytes': info['size']}
    over = [n for n, s in songs.items() if s['bytes'] > pearl_music.BUDGET]
    if over:
        raise SystemExit(f'battle_music: over the sound heap budget ({pearl_music.BUDGET} B): {over}')
    data = B.build(new_files=new_files, entries=ents)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    os.makedirs(os.path.dirname(SONGS_JSON), exist_ok=True)
    json.dump({'songs': songs}, open(SONGS_JSON + '.tmp', 'w'), indent=1); os.replace(SONGS_JSON + '.tmp', SONGS_JSON)
    big = max(songs, key=lambda n: songs[n]['bytes'])
    return (f'battle_music: {len(songs)} Pearl songs ({len(new_files) // 3} sequences, seq '
            f'{min(s["b2_seq"] for s in songs.values())}..{max(s["b2_seq"] for s in songs.values())}); SDAT '
            f'{len(B.data)} -> {len(data)} B; biggest {big} {songs[big]["bytes"]} B (budget {pearl_music.BUDGET})')


# ---------------------------------------------------------------- the tables

def class_map():
    """{Black 2 class: [(Pearl class, how)]} for the classes Pearl's trainers get (pearl_trainers' rule: the registry's
    class, else CLASS_MAP's Black 2 class)."""
    import sinnoh_trainers
    reg = json.load(open(REGISTRY))['classes']
    b2_names = [l.split()[0] for l in open(os.path.join(DECOMP, 'generated', 'trainer_classes.txt'))
                if l.startswith('TRAINER_CLASS')]
    pearl = re.findall(r'#define TRAINER_CLASS_(\w+)\s+\d+',
                       open(os.path.join(PDIAMOND, 'include', 'constants', 'trainer_classes.h')).read())
    out = {}
    for pc in pearl:
        if pc in reg:
            b2, how = reg[pc]['b2'], reg[pc]['how']
        elif pc in sinnoh_trainers.CLASS_MAP:
            b2c, how = sinnoh_trainers.CLASS_MAP[pc]
            b2 = b2_names.index('TRAINER_CLASS_' + b2c)
        else:
            continue
        out.setdefault(b2, []).append((pc, how))
    return out


def tables(r=None, songs=None):
    """The tables as lists, the song list, and the choices made where Pearl classes share a Black 2 class."""
    r = r or rules()
    songs = songs or json.load(open(SONGS_JSON))['songs']
    ids = b2_songs()
    seqs = [0]

    def idx(name):
        seq = songs[name]['b2_seq'] if name in songs else ids[name]
        if seq not in seqs: seqs.append(seq)
        return seqs.index(seq)

    def pair(song):
        u = r['unova'][song]
        return idx(song), 0 if u == 'black2' else idx(song) if u == 'pearl' else idx(u)

    cmap, shared = class_map(), []
    cols = {k: [0] * (2 * CLASS_COUNT) for k in ('eye', 'battle', 'victory')}
    for c in range(CLASS_COUNT):
        if c not in cmap: continue
        cands = cmap[c]
        for kind, default in (('eye', r['eye_default']), ('battle', r['battle_default']),
                              ('victory', r['victory_default'])):
            got = {pc: r[kind].get(pc, default) for pc, _ in cands}
            if len(set(got.values())) > 1:          # Pearl classes on one Black 2 class with different songs
                pick = next((pc for pc, how in cands if how == 'same'), cands[0][0])
                shared.append(f'{kind} class {c}: {got} -> {pick}')
            else:
                pick = cands[0][0]
            cols[kind][2 * c], cols[kind][2 * c + 1] = pair(got[pick])
    wild = [(int(sp), *pair(song)) for sp, song in sorted(r['wild'].items(), key=lambda kv: int(kv[0]))]
    return dict(cols, wild=wild, wild_default=pair(r['wild_default']), wild_victory=pair(r['victory_wild']),
                songs=seqs, shared=shared)


def force():
    return {'sinnoh': 1, 'unova': 2}.get(os.environ.get('PEARL_TEST_MUSIC', '').lower(), 0)


def blob(base, t):
    """PearlB2BattleMusic at base, then its arrays (each 4-aligned)."""
    hsize = struct.calcsize(HEADER)
    parts, offs, at = [], [], hsize
    arrays = [struct.pack(f'<{len(t["songs"])}H', *t['songs']), bytes(t['eye']), bytes(t['battle']),
              bytes(t['victory']), struct.pack(f'<{3 * len(t["wild"])}H', *[v for w in t['wild'] for v in w])]
    for a in arrays:
        offs.append(base + at); parts.append(a + bytes(-len(a) % 4)); at += len(parts[-1])
    head = struct.pack(HEADER, force(), CLASS_COUNT, len(t['wild']), len(t['songs']), *offs,
                       *t['wild_default'], *t['wild_victory'])
    return head + b''.join(parts)


def apply_code(code):
    import decomp
    slot = decomp.symbol('gPearlB2BattleMusic', code)
    if slot is None:
        raise SystemExit('battle_music: the decomp has no gPearlB2BattleMusic (its src/pearlb2/battle_music_itcm.c, '
                         'branch pearlb2): build on a decomp with it')
    t = tables()
    checked = check_waits()
    base, end, _ = itcm.install(code, lambda b: (blob(b, t), {}))
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    assert data[at:at + 4] == bytes(4), f'gPearlB2BattleMusic at {slot:#x}: {data[at:at + 4].hex()}, not NULL'
    data[at:at + 4] = struct.pack('<I', base)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    n = {k: sum(1 for i in range(0, len(t[k]), 2) if t[k][i]) for k in ('eye', 'battle', 'victory')}
    return (f'battle_music: tables {end - base} B of ITCM at {base:#x} (gPearlB2BattleMusic {slot:#x}); classes with '
            f'Pearl songs: eye {n["eye"]}, battle {n["battle"]}, victory {n["victory"]}; {len(t["wild"])} species; '
            f'{len(t["songs"]) - 1} songs; waits checked: {checked} pairs'
            + (f'; shared classes: {t["shared"]}' if t['shared'] else '')
            + (f'; TEST: answer forced to {os.environ["PEARL_TEST_MUSIC"]}' if force() else ''))


# ---------------------------------------------------------------- checks

def _loops(sseq_bytes):
    import sseq
    return any(tr['loop_tick'] is not None for tr in sseq.decode(sseq_bytes).values())


def check_waits(r=None):
    """Refuse a song that loops standing in for one that ends (the game may wait for that one to end), in both
    directions: Black 2's songs of each situation -> Pearl's (Sinnoh's music), Pearl's -> its counterpart (Black 2's)."""
    r = r or rules()
    P, B = pearl_music.pearl_sdat(), SDAT(open(DEFAULT, 'rb').read())

    def loops(name):
        S = P if name in P.names['seq'] and not name.startswith('SEQ_BGM_') else B
        return _loops(S.seq(S.index('seq', name)))
    pairs = []
    for kind, names in pearl_names(r).items():
        for n in sorted(names):
            pairs += [(b, n) for b in B2_SITUATION[kind]]
            u = r['unova'][n]
            if u not in ('black2', 'pearl'):
                pairs.append((n, u))
    bad = [(a, b) for a, b in pairs if not loops(a) and loops(b)]
    assert not bad, f'battle_music: these songs end (the game may wait for them) but their stand-in loops: {bad}'
    return len(pairs)


def melody(pearl, b2, n=5):
    """How much of a Black 2 song's melody is a Pearl song's: transposition-free note-interval n-grams of every
    track, shared / the smaller set (1.0: the same notes)."""
    import sseq
    P, B = pearl_music.pearl_sdat(), SDAT(open(DEFAULT, 'rb').read())

    def grams(S, name):
        out = set()
        for tr in sseq.decode(S.seq(S.index('seq', name))).values():
            tp, keys = 0, []
            for e in tr['events']:
                if e[1] == 'transpose': tp = e[2]
                elif e[1] == 'note': keys.append(e[2] + tp)
            iv = [b - a for a, b in zip(keys, keys[1:])]
            out |= {tuple(iv[i:i + n]) for i in range(len(iv) - n + 1) if any(iv[i:i + n])}
        return out
    a, b = grams(P, pearl), grams(B, b2)
    return len(a & b) / min(len(a), len(b)) if a and b else 0.0


def simulate(t):
    """battle_music_itcm.c's answers from the packed table, both columns, for each Pearl class with a battle of its own
    and the special species: what the game plays (sequence ids of this build, with names)."""
    base = itcm.ITCM_BASE
    b = blob(base, t)
    frc, ncls, nwild, nsong, p_songs, p_eye, p_battle, p_victory, p_wild, *rest = struct.unpack_from(HEADER, b)
    songs = struct.unpack_from(f'<{nsong}H', b, p_songs - base)
    names = {v: k for k, v in b2_songs().items()}
    for name, v in json.load(open(SONGS_JSON))['songs'].items():
        names.setdefault(v['b2_seq'], name)
    def song(i, keep): return f'{names.get(songs[i], songs[i])} ({songs[i]})' if i else keep
    cmap = class_map()
    print('\nsimulated (decomp code on this table): class -> eye / battle / victory, Sinnoh | Black 2')
    for c in sorted(cmap):
        pcs = ','.join(pc for pc, _ in cmap[c])
        if not any(k in pcs for k in ('LEADER', 'ELITE', 'CHAMPION', 'BARRY', 'GALACTIC', 'COMMANDER', 'YOUNGSTER')):
            continue
        row = []
        for p in (p_eye, p_battle, p_victory):
            s, u = b[p - base + 2 * c], b[p - base + 2 * c + 1]
            row.append(f'{song(s, "B2")} | {song(u, "B2 own")}')
        print(f'  {c:3d} {pcs:34s} ' + ' ; '.join(row))
    wild = struct.unpack_from(f'<{3 * nwild}H', b, p_wild - base)
    for i in range(nwild):
        print(f'  wild {wild[3 * i]}: {song(wild[3 * i + 1], "B2")} | {song(wild[3 * i + 2], "B2 own")}')
    print(f'  wild (others): {song(rest[0], "B2")} | {song(rest[1], "B2 own")}; wild victory {song(rest[2], "B2")} | '
          f'{song(rest[3], "B2 own")}')


if __name__ == '__main__':
    r = rules()
    P = pearl_music.pearl_sdat()
    print('situation                         Pearl                Black 2 music')
    rows = [('wild battle', r['wild_default']), ('wild victory', r['victory_wild']),
            ('trainer battle', r['battle_default']), ('trainer victory', r['victory_default'])]
    rows += [(f'battle {pc}', s) for pc, s in r['battle'].items()]
    rows += [(f'victory {pc}', s) for pc, s in r['victory'].items()]
    rows += [(f'wild species {sp}', s) for sp, s in r['wild'].items()]
    rows += [(f'eye {pc}', s) for pc, s in r['eye'].items()] + [('eye (other classes)', r['eye_default'])]
    for what, s in rows:
        u = r['unova'][s]
        print(f'{what:33s} {s:20s} {"the class/Pokemon gets Black 2" + chr(39) + "s own" if u == "black2" else u}')
    print()
    for s, u in r['unova'].items():
        if u not in ('black2', 'pearl'):
            print(f'melody {s} ~ {u}: {melody(s, u):.2f}')
    for s in sorted(set().union(*pearl_names(r).values()), key=lambda n: P.index('seq', n)):
        print(f'{s:16s} {pearl_music.trim(P, P.index("seq", s))[3]["size"]:7d} B')
    print('check_waits:', check_waits(r), 'pairs OK')
    if os.path.exists(SONGS_JSON):
        t = tables(r)
        print('shared classes:', t['shared'] or 'none', '; table bytes:', len(blob(itcm.ITCM_BASE, t)))
        simulate(t)
