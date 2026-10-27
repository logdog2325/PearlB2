"""Sinnoh's music (user's choice: Sinnoh's songs by default; the start-of-game choice of Black 2's music comes with
Rowan's questions). Runs after sinnoh_world and sinnoh_rooms.

- Every song Pearl's installed zones play (day and night themes) goes into Black 2's sound archive (files/swan_sound_data.sdat) as a new sequence with
  its own trimmed bank and wave archive (pearl_music.trim: only the instruments and waves the song plays, as Black 2
  stores its own songs; Pearl's shared archives would not fit Black 2's per-song sound heap).
- Ids: Black 2's empty sequence ids (4-999 are free) and empty bank / wave archive ids, in Pearl sequence order;
  the new files are appended. Sequence entry: Pearl's volume, Black 2's BGM player settings (player 0, channel
  priority 30, player priority 64: notes/MUSIC.md).
- Zone headers: bgm0-3 (spring..winter) = the zone's DAY song. Pearl's SEQ_DUMMY ("keep what plays") -> the parent
  zone's song. The mapping goes to work/world/music.json.
- Night (apply_code): Black 2's zone header holds four season songs, not day/night, so DecideZoneHeaderBGMID (arm9
  0x02018968) jumps to src/code/night_music.c in ITCM, which swaps a Pearl day theme for its night theme in Black 2's
  NIGHT/MIDNIGHT day periods. The {day, night} pairs come from Pearl's zones (music_day/music_night).
- Memory: Black 2's sound heap holds the playing song's sequence, bank and wave archive. Measured in game
  (2026-10-18, hwtest/music_mem.py): Twinleaf's SEQ_TOWN01_D (217 KB with whole instruments) left 58 KB free. With
  pearl_music's key-level trimming (only the samples of the notes a song plays) all 77 songs are 6.5 MB instead of
  12.6 MB and the biggest, SEQ_ROAD_F_D/N (Routes 210, 211 East, 214, 215), is 161 KB instead of 291 KB.
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import zoneheaders, pearl_music, itcm  # noqa: E402
from sdat import SDAT  # noqa: E402

SEQ_DUMMY = 1000
# Songs Pearl's scripts start themselves (PlayMusic / SetBGM in all 446 zone script files, b2tools/pearl_story.py):
# installed like the zone songs; the scripts get their ids as SEQ_PEARL_<name> (scripts.defines(), env
# PEARL_MUSIC_EVENTS set here, so only a build that ran this patch uses them; others keep Black 2's stand-ins).
EVENT_SONGS = ('SEQ_THE_RIV', 'SEQ_THE_BOY', 'SEQ_THE_GIRL', 'SEQ_TSURETEKE', 'SEQ_THE_EVENT01', 'SEQ_THE_EVENT02',
               'SEQ_THE_EVENT03', 'SEQ_SILENCE_DUNGEON', 'SEQ_OPENING2', 'SEQ_FUE', 'SEQ_D_SAFARI', 'SEQ_D_RYAYHY')


def apply(files):
    path = os.path.join(files, 'swan_sound_data.sdat')
    B = SDAT(open(path, 'rb').read())
    P = pearl_music.pearl_sdat()
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    b2_of = {int(k): v['b2_zone'] for k, v in world['zones'].items()}
    b2_of.update({int(k): v['b2_zone'] for k, v in world['rooms']['zones'].items()})
    headers, entries = zoneheaders.load(files)

    def song(pid, key='music_day'):
        s = zones[pid][key]
        if s == SEQ_DUMMY or s >= len(P.info['seq']) or not P.info['seq'][s]:
            return None
        return s
    pairs = {(song(pid), song(pid, 'music_night')) for pid in b2_of}
    pairs = {(d, n) for d, n in pairs if d is not None and n is not None and d != n}
    events = {P.index('seq', n) for n in EVENT_SONGS}
    wanted = sorted({s for pid in b2_of for s in [song(pid)] if s is not None} | {n for _, n in pairs} | events)
    free_seq = [i for i in range(4, len(B.info['seq'])) if B.info['seq'][i] is None]
    free_bank = [i for i in range(len(B.info['bank'])) if B.info['bank'][i] is None]
    free_wave = [i for i in range(len(B.info['wavearc'])) if B.info['wavearc'][i] is None]
    assert len(free_seq) >= len(wanted) and len(free_bank) >= len(wanted) and len(free_wave) >= len(wanted)
    new_files, ents, b2_seq, sizes = [], {}, {}, {}
    next_file = len(B.fat)
    for k, s in enumerate(wanted):
        seq, bank, swar, info = pearl_music.trim(P, s)
        sid, bid, wid = free_seq[k], free_bank[k], free_wave[k]
        f_seq, f_bank, f_wave = next_file, next_file + 1, next_file + 2
        next_file += 3
        new_files += [seq, bank, swar]
        ents[('seq', sid)] = SDAT.seq_entry(f_seq, bid, volume=info['volume'])
        ents[('bank', bid)] = SDAT.bank_entry(f_bank, [wid])
        ents[('wavearc', wid)] = SDAT.wavearc_entry(f_wave)
        b2_seq[s] = sid; sizes[P.name('seq', s)] = info['size']
    data = B.build(new_files=new_files, entries=ents)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)

    by_b2 = {}
    for pid, b2 in b2_of.items():
        s = song(pid)
        if s is not None: by_b2[b2] = b2_seq[s]
    mapping = {}
    for pid, b2 in sorted(b2_of.items()):
        sid = by_b2.get(b2) or by_b2.get(headers[b2]['parent'])
        if sid is None: continue
        hd = headers[b2]
        hd['bgm0'] = hd['bgm1'] = hd['bgm2'] = hd['bgm3'] = sid
        mapping[str(b2)] = {'zone': zones[pid]['name'], 'seq': sid,
                            'pearl_song': P.name('seq', zones[pid]['music_day'])}
    test = os.environ.get('PEARL_TEST_BGM427')          # TEST ONLY: Twinleaf (427) plays this Pearl song (memory test)
    if test:
        sid = b2_seq[P.index('seq', test)]
        for k in ('bgm0', 'bgm1', 'bgm2', 'bgm3'): headers[427][k] = sid
        print(f'sinnoh_music: TEST Twinleaf plays {test} (seq {sid})')
    zoneheaders.save(files, headers, entries)
    os.makedirs(os.path.join(ROOT, 'work', 'world'), exist_ok=True)
    night = sorted({(b2_seq[d], b2_seq[n]) for d, n in pairs})
    assert len({d for d, _ in night}) == len(night), 'a day theme with two night themes'
    event_ids = {n: b2_seq[P.index('seq', n)] for n in EVENT_SONGS}
    os.environ['PEARL_MUSIC_EVENTS'] = json.dumps(event_ids)
    json.dump({'songs': {P.name('seq', s): {'b2_seq': b2_seq[s], 'bytes': sizes[P.name('seq', s)]} for s in wanted},
               'zones': mapping, 'night_pairs': night, 'events': event_ids},
              open(os.path.join(ROOT, 'work', 'world', 'music.json'), 'w'), indent=1)
    over = [n for n, b in sizes.items() if b > pearl_music.BUDGET]
    return (f'sinnoh_music: {len(wanted)} Pearl songs added (seq {free_seq[0]}..), {len(mapping)} zones, '
            f'{len(night)} night themes, {len(event_ids)} story songs; SDAT {len(B.data)} -> {len(data)} B; over budget: {over}')


DECIDE_ZONE_BGM, DECIDE_ZONE_BGM_SIZE = 0x02018968, 0x34


def apply_code(code):
    """DecideZoneHeaderBGMID -> Pearl_ZoneBGM in ITCM (night themes)."""
    import struct, tempfile
    night = json.load(open(os.path.join(ROOT, 'work', 'world', 'music.json')))['night_pairs']
    p9 = os.path.join(code, 'arm9.bin')
    vanilla = open(os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'build', 'arm9.bin'), 'rb').read()
    o = DECIDE_ZONE_BGM - itcm.ARM9
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        with open(os.path.join(tmp, 'night_music.h'), 'w') as f:
            f.write('/* generated by b2tools/patches/sinnoh_music.py */\n'
                    f'#define N_PAIRS {len(night)}\n'
                    'static const u16 kPairs[N_PAIRS][2] = {' + ', '.join(f'{{{d}, {n}}}' for d, n in night) + '};\n')
        src = os.path.join(ROOT, 'src', 'code', 'night_music.c')
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp, includes=[tmp]))
    arm9 = bytearray(open(p9, 'rb').read())
    assert arm9[o:o + DECIDE_ZONE_BGM_SIZE] == vanilla[o:o + DECIDE_ZONE_BGM_SIZE], 'DecideZoneHeaderBGMID changed'
    jump = itcm.long_jump(DECIDE_ZONE_BGM, sym['Pearl_ZoneBGM'] & ~1)
    arm9[o:o + len(jump)] = jump
    open(p9 + '.tmp', 'wb').write(arm9); os.replace(p9 + '.tmp', p9)
    return f'night music: {len(night)} pairs, Pearl_ZoneBGM {sym["Pearl_ZoneBGM"]:#x} ({end - base} B of ITCM)'
