"""Rowan's music question: Sinnoh's songs or Unova's (user's choice 2026-10-18, notes/DECISIONS.md: Sinnoh's songs by
default, a start-of-game choice of Black 2's music). Runs after sinnoh_music (which installs Pearl's songs and points
Black 2's DecideZoneHeaderBGMID at src/code/night_music.c's Pearl_ZoneBGM).

The answer is bit 13 of the options u16 at the start of the trainer-data save block, HoennB2's bit for the same
question ("home-region music": 1 = Hoenn's there, Sinnoh's here; 0 = Unova's), set by Rowan's question in the intro
(patches/pearl_intro.py, intro command 31). Mashing A answers SINNOH.

- apply_code: src/code/music_choice.c goes into ITCM (b2tools/itcm.py) with a table made here: every Pearl zone song
  sinnoh_music installed (work/world/music.json; its night versions follow their day song) -> the Black 2 song of
  data/unova_music.json (one song, or Black 2's four season versions). DecideZoneHeaderBGMID's long-jump word then
  points at Choice_ZoneBGM, which asks Pearl_ZoneBGM first and swaps the song when the answer was UNOVA. Nothing of
  sinnoh_music's changes (its jump is checked byte for byte).
- The songs Pearl's scripts start themselves (sinnoh_music EVENT_SONGS: Barry's, Rowan's, "follow me" ...) become
  Black 2's with UNOVA too (data/unova_music.json "story", else "songs"; a story song in neither stays Pearl's), where
  Black 2 starts a BGM, at HoennB2 hoenn_music's three tested sites:
    arm9 0x02005d9c  GFL_SndBGMPlayCore `adds r4, r0, #0; adds r5, r1, #0` -> bl Music_PlayCoreShim
    arm9 0x02006428  func_02006424 (threaded BGM load) `adds r5, r0, #0; adds r4, r1, #0` -> bl Music_LoadShim
    arm9 0x02005e0a  func_02005e08 (faded BGM change) `bl RequestBGMChange` -> bl Music_RequestChange
  check_waits(): a Pearl song that ends (the game may wait for it) never gets a Black 2 song that loops (HoennB2's v16
  freeze).

Test switch: PEARL_TEST_MUSIC=sinnoh|unova forces the answer (the question then changes nothing).
"""
import json, os, re, struct, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import itcm, zoneheaders  # noqa: E402

DECIDE_ZONE_BGM = 0x02018968                    # arm9 DecideZoneHeaderBGMID (sinnoh_music.DECIDE_ZONE_BGM)
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
VANILLA_FILES = os.path.join(DECOMP, 'build', 'b2_us', 'files')
MAPPING = os.path.join(ROOT, 'data', 'unova_music.json')
MUSIC_JSON = os.path.join(ROOT, 'work', 'world', 'music.json')   # sinnoh_music's mapping (written by its apply)
SILENCES = {'SEQ_BGM_SILENCE_FIELD', 'SEQ_BGM_SILENCE_DUNGEON'}   # no zone of Black 2's plays the second: silence anyway


PLAY_SITES = [   # (arm9 address, Black 2's 4 bytes or the old bl target, new symbol, what): HoennB2 hoenn_music's sites
    (0x02005d9c, '041c0d1c', 'Music_PlayCoreShim', 'GFL_SndBGMPlayCore adds r4, r0, #0; adds r5, r1, #0'),
    (0x02006428, '051c0c1c', 'Music_LoadShim', 'func_02006424 adds r5, r0, #0; adds r4, r1, #0'),
    (0x02005e0a, 0x02005fe0, 'Music_RequestChange', 'func_02005e08 bl RequestBGMChange'),
]


def b2_songs():
    """Black 2's sequence names -> ids (pokebw2 generated/sound.txt: NAME = value, then one more per line)."""
    out, n = {}, None
    for line in open(os.path.join(DECOMP, 'generated', 'sound.txt')):
        m = re.match(r'\s*(SEQ_\w+)(?:\s*=\s*(\S+))?\s*(?:#.*)?$', line)
        if not m: continue
        if m.group(2): n = int(m.group(2), 0)
        elif n is None: continue
        out[m.group(1)] = n
        n += 1
    return out


def table():
    """(first Pearl seq id, [quad index + 1 or 0 per Pearl seq id], [quads], {pearl song: quad names}, unmapped)."""
    music = json.load(open(MUSIC_JSON))
    mapping = json.load(open(MAPPING))['songs']
    ids = b2_songs()
    # every Black 2 song named must be one that Black 2's own zones play (a zone song: it loops, fits the sound heap)
    vanilla, _ = zoneheaders.load(VANILLA_FILES)
    zone_songs = {h[f'bgm{k}'] for h in vanilla for k in range(4)}
    seq_of = {name: v['b2_seq'] for name, v in music['songs'].items()}
    day_of = {n: d for d, n in music['night_pairs']}
    zone_pearl = {v['pearl_song'] for v in music['zones'].values()}
    quads, index, used, unmapped = [], {}, {}, []
    for name, seq in seq_of.items():
        if name not in zone_pearl and seq not in day_of and name in music.get('events', {}):
            continue                                   # a story song only (scripts play it): not a zone song
        if name not in mapping: continue
        m = mapping[name]
        q = tuple(m) if isinstance(m, list) else (m,) * 4
        assert len(q) == 4, name
        for s in q:
            assert s in ids, f'{name}: {s} is not a Black 2 song'
            assert ids[s] in zone_songs or s in SILENCES, f'{name}: {s} ({ids[s]}) is not played by any Black 2 zone'
        if q not in index:
            index[q] = len(quads); quads.append(q)
        used[seq] = index[q] + 1
    for d, n in music['night_pairs']:                  # night versions: their day song's
        if d in used: used[n] = used[d]
    for z, v in music['zones'].items():
        if v['seq'] not in used and v['pearl_song'] in seq_of and v['pearl_song'] != 'SEQ_DUMMY':
            unmapped.append(v['pearl_song'])
    first, last = min(used), max(used)
    k_song = [used.get(s, 0) for s in range(first, last + 1)]
    return first, k_song, [[ids[s] for s in q] for q in quads], quads, sorted(set(unmapped))


def story():
    """[(Pearl story song's id here, Black 2 song id)] for the songs scripts start themselves (sinnoh_music's events)."""
    music, mp, ids = json.load(open(MUSIC_JSON)), json.load(open(MAPPING)), b2_songs()
    out = []
    for name, seq in sorted(music.get('events', {}).items(), key=lambda x: x[1]):
        m = mp.get('story', {}).get(name) or mp['songs'].get(name)
        if m is None: continue
        b2 = m[1] if isinstance(m, list) else m              # no season here: the summer version of a set
        assert b2 in ids, f'{name}: {b2} is not a Black 2 song'
        out.append((seq, ids[b2], name, b2))
    return out


def _loops(sseq_bytes):
    import sseq
    return any(t['loop_tick'] is not None for t in sseq.decode(sseq_bytes).values())


def check_waits():
    """Refuse a Pearl song that ends -> a Black 2 song that loops (zones and story songs). Returns the pairs checked."""
    import pearl_music
    from sdat import SDAT, DEFAULT
    P, B = pearl_music.pearl_sdat(), SDAT(open(DEFAULT, 'rb').read())
    mp = json.load(open(MAPPING))
    pairs = [(n, s) for sec in ('songs', 'story') for n, m in mp.get(sec, {}).items()
             for s in (m if isinstance(m, list) else [m])]
    bad = [(n, s) for n, s in pairs if n in P.names['seq'] and s not in SILENCES   # (Black 2's silences loop a rest)
           and not _loops(P.seq(P.index('seq', n))) and _loops(B.seq(B.index('seq', s)))]
    assert not bad, f'music_choice: these Pearl songs end but their Black 2 song loops: {bad}'
    return len(pairs)


def header(prev):
    first, k_song, quads, _, _ = table()
    st = story()
    force = {'sinnoh': 1, 'unova': 0}.get(os.environ.get('PEARL_TEST_MUSIC', '').lower())
    return ('/* generated by b2tools/patches/music_choice.py */\n'
            f'#define PREV_ZONE_BGM {prev:#x}\n#define FIRST_SEQ {first}\n#define N_SEQ {len(k_song)}\n'
            f'#define N_UNOVA {len(quads)}\n'
            + (f'#define MUSIC_FORCE {force}\n' if force is not None else '')
            + 'static const u8 kSong[N_SEQ] = {' + ', '.join(map(str, k_song)) + '};\n'
            + 'static const u16 kUnova[N_UNOVA][4] = {' + ', '.join('{%d, %d, %d, %d}' % tuple(q) for q in quads)
            + '};\n'
            + f'#define N_STORY {len(st)}\n'
            + 'static const u16 kStory[N_STORY][2] = {' + ', '.join(f'{{{a}, {b}}}' for a, b, _, _ in st) + '};\n')


def apply_code(code):
    p9 = os.path.join(code, 'arm9.bin')
    o = DECIDE_ZONE_BGM - itcm.ARM9
    arm9 = bytearray(open(p9, 'rb').read())
    h1, h2, prev = struct.unpack_from('<HHI', arm9, o)
    assert (h1, h2) == (0x4B00, 0x4718) and itcm.ITCM_BASE <= prev < itcm.ITCM_END, \
        'DecideZoneHeaderBGMID is not sinnoh_music\'s long jump into ITCM: run music_choice after sinnoh_music'
    src = os.path.join(ROOT, 'src', 'code', 'music_choice.c')
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        with open(os.path.join(tmp, 'music_choice.h'), 'w') as f:
            f.write(header(prev & ~1))
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp, includes=[tmp]))
    arm9 = bytearray(open(p9, 'rb').read())             # itcm.install moved the arena literal
    struct.pack_into('<I', arm9, o + 4, sym['Choice_ZoneBGM'] | 1)
    for at, old, new, what in PLAY_SITES:
        q = at - itcm.ARM9
        old_b = bytes.fromhex(old) if isinstance(old, str) else itcm.bl(at, old)
        assert bytes(arm9[q:q + 4]) == old_b, f'{what} at {at:#x}: {bytes(arm9[q:q + 4]).hex()} (expected {old_b.hex()})'
        arm9[q:q + 4] = itcm.bl(at, sym[new] & ~1)
    if os.path.islink(p9): os.unlink(p9)
    open(p9 + '.tmp', 'wb').write(arm9); os.replace(p9 + '.tmp', p9)
    first, k_song, quads, _, unmapped = table()
    st, checked = story(), check_waits()
    force = os.environ.get('PEARL_TEST_MUSIC')
    return (f'music_choice: Choice_ZoneBGM {sym["Choice_ZoneBGM"] | 1:#x} before Pearl_ZoneBGM {prev:#x} '
            f'({end - base} B of ITCM); {sum(1 for k in k_song if k)} Pearl songs -> {len(quads)} Black 2 songs/sets; '
            f'story songs with UNOVA: {", ".join(f"{a}->{b}" for _, _, a, b in st)} (BGM play sites hooked: '
            f'{len(PLAY_SITES)}); waits checked: {checked} pairs'
            + (f'; Pearl songs kept with UNOVA (no entry in data/unova_music.json): {unmapped}' if unmapped else '')
            + (f'; TEST: answer forced to {force}' if force else ''))


if __name__ == '__main__':      # python3 music_choice.py: the table (needs work/world/music.json) and a compile check
    first, k_song, ids, quads, unmapped = table()
    names = {v['b2_seq']: n for n, v in json.load(open(MUSIC_JSON))['songs'].items()}
    for s, k in enumerate(k_song, first):
        if k: print(f'{names.get(s, s):20s} -> {" / ".join(sorted(set(quads[k - 1]), key=quads[k - 1].index))}')
    print('unmapped:', unmapped)
    print('story:', [(a, b) for _, _, a, b in story()])
    print('check_waits:', check_waits(), 'pairs OK')
    with tempfile.TemporaryDirectory() as tmp:
        open(os.path.join(tmp, 'music_choice.h'), 'w').write(header(0x01FF9000))
        blob, sym = itcm.build(os.path.join(ROOT, 'src', 'code', 'music_choice.c'), 0x01FFC000, tmp, includes=[tmp])
        print(len(blob), 'B', {k: hex(v) for k, v in sym.items() if not k.startswith(('$', '.'))})
