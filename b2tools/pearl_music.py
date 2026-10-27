"""Pearl's songs for Black 2's sound engine: each song with its own trimmed bank and wave archive.

    python3 pearl_music.py [SEQ_NAME ...]      sizes of the trimmed songs (default: every song Pearl's zones use)

Pearl's songs share big instrument archives (most field songs: bank 1001 over wave archives 1000 + 1001, ~500 KB),
which Pearl keeps loaded. Black 2 loads a song's sequence, bank and wave archives together, with ~282 KB free for
them (HoennB2 notes/MUSIC.md "Memory per sequence"), and stores each of its own songs with its own bank and wave
archive holding only what it plays. trim() does that for a Pearl song: the programs the sequence switches to
('program' events, and 0 for tracks that never switch), their instrument records, and only the waves those name,
renumbered into one new wave archive (slot 0). The sequence itself is unchanged (same program numbers).

Key-level trimming (2026-10-18, after Twinleaf's song left only 58 KB of Black 2's sound heap free and Route 210's is
74 KB bigger): drum sets (type 16) and key splits (type 17) hold one wave per key or key range, and a song plays only
some of them. note_keys() follows each track's notes with its current program and transpose (sseq.decode, every
track from its start through calls and repeats to its loop). A region no note reaches keeps its place in the
instrument (the layout of drum sets and splits must not change) but points at a wave the song already keeps, so its
own wave is not stored. If a track uses a command the decoder does not follow (random, variables, conditions), the
song's notes are not known for sure and every region is kept, as before.
"""
import os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import sseq  # noqa: E402
from sdat import SDAT, parse_sbnk, build_sbnk, parse_swar, build_swar  # noqa: E402
from gen4rom import Rom  # noqa: E402

BUDGET = 282_000                  # bytes for sequence + bank + wave archives (Black 2's free sound heap per BGM)
PCM_TYPES = {1}                   # note definitions that play a wave (2 PSG square, 3 noise: no wave)


def pearl_sdat():
    return SDAT(Rom(os.path.join(ROOT, 'roms', 'pearl.nds')).read('data/sound/sound_data.sdat'))


def programs(seq_bytes):
    dec = sseq.decode(seq_bytes)
    used = set()
    for tr in dec.values():
        progs = [e[2] for e in tr['events'] if e[1] == 'program']
        notes = any(e[1] == 'note' for e in tr['events'])
        used |= set(progs)
        if notes and not progs: used.add(0)
    return used


def note_keys(seq_bytes):
    """({program: {key}}, complete): the keys each program plays (after transpose); complete = every track decoded."""
    keys, complete = {}, True
    tracks = sseq.decode(seq_bytes)
    for tr in tracks.values():
        prog, transpose = 0, 0
        for e in tr['events']:
            if e[1] == 'program': prog = e[2]
            elif e[1] == 'transpose': transpose = e[2]
            elif e[1] == 'note': keys.setdefault(prog, set()).add(min(127, max(0, e[2] + transpose)))
            elif e[1].startswith(('cmd', 'unknown')): complete = False
            elif e[1] == 'open_track': complete = False     # its notes are not followed by decode()
    return keys, complete


def trim(S, seq_id, by_key=True):
    """(sequence bytes, bank bytes, wave archive bytes, info) for Pearl sequence seq_id."""
    entry = S.info['seq'][seq_id]
    seq_bytes = S.seq(seq_id)
    bank_info = S.info['bank'][entry['bank']]
    bank = parse_sbnk(S.bank(entry['bank']))
    archives = {slot: parse_swar(S.wavearc(w)) for slot, w in enumerate(bank_info['wavearcs']) if w != 0xFFFF}
    used = programs(seq_bytes) & set(bank)
    keys, complete = note_keys(seq_bytes)
    by_key = by_key and complete
    new_waves, index = [], {}
    instruments, skipped = {}, 0
    for p in sorted(used):
        t, regions = bank[p]
        hit = [not by_key or t < 16 or any(r[0] <= k <= r[1] for k in keys.get(p, ())) for r in regions]
        out, later = [], []
        for r, h in zip(regions, hit):
            kind = r[2]
            wave, slot = r[3], r[4]
            r = list(r)
            if kind in PCM_TYPES:
                if not h:
                    later.append(len(out)); out.append(r); continue
                key = (slot, wave)
                if key not in index:
                    index[key] = len(new_waves); new_waves.append(archives[slot][wave])
                r[3], r[4] = index[key], 0
            out.append(r)
        for i in later:                    # a region no note reaches: any kept wave (its own if nothing is kept yet)
            r = out[i]
            if not new_waves:
                index[(r[4], r[3])] = 0; new_waves.append(archives[r[4]][r[3]])
            kept = next((o[3] for o in out if o[2] in PCM_TYPES and o not in [out[j] for j in later]), 0)
            r[3], r[4] = kept, 0
            skipped += 1
        instruments[p] = (t, [tuple(r) for r in out])
    bank_bytes = build_sbnk(instruments)
    swar = build_swar(new_waves)
    size = len(seq_bytes) + len(bank_bytes) + len(swar)
    return seq_bytes, bank_bytes, swar, {'programs': sorted(used), 'waves': len(new_waves), 'size': size,
                                         'volume': entry['volume'], 'by_key': by_key, 'unplayed_regions': skipped}


if __name__ == '__main__':
    import json, collections
    S = pearl_sdat()
    if len(sys.argv) > 1:
        ids = [S.index('seq', n) for n in sys.argv[1:]]
    else:
        zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
        ids = sorted({z[k] for z in zones for k in ('music_day', 'music_night')
                      if z[k] < len(S.info['seq']) and S.info['seq'][z[k]]})
    over = []
    for i in ids:
        _, _, _, info = trim(S, i)
        flag = '' if info['size'] <= BUDGET else '  OVER BUDGET'
        if flag: over.append(S.name('seq', i))
        print(f"{S.name('seq', i):24s} {info['size']:7d} B  {info['waves']:3d} waves  programs {info['programs']}{flag}")
    print(f'{len(ids)} songs, {len(over)} over {BUDGET} B: {over}')
