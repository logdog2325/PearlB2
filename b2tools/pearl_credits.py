"""Pearl's staff credits in Black 2's staff roll (chapter 8, 2026-10-26: the lead, "Credits: Pearl's staff list").

    python3 b2tools/pearl_credits.py          writes data/text_overrides/pearl_credits.json and prints the roll

Black 2's staff roll (ov266 src/ov266/staff_roll_main.c) reads its lines from system text 369 (res/text/system/
title_15.txt, 324 lines: Black 2's staff) and its commands from file 1 of the end archive a/2/1/5 (16-byte records:
u32 message (0xffff none), u16 frames to the next command (or a title's y), u8 command, u8 argument, u8 colour, u8 font,
u16 align (or a picture's screen), s16 x (or a picture's fade frames), s16 offset). Black 2's list: three fading title
pages, then the scroll (names 20 frames apart, a gap between groups) with twelve photos on the top or bottom screen,
the last photo with the player's sprite, the producers, and DEVELOPED BY / GAME FREAK stopping mid-screen; 21,172
frames in all, as long as Black 2's ending song.

Pearl's (bank 493 of the Pearl dump, gen4_text: 216 lines): "Pokémon Diamond"/"Pokémon Pearl" (one per version),
"Credits", then its staff by role (a role in colour 2, its names indented), "Fin". Here:
- the text: title_15's first 216 lines become Pearl's, in Pearl's order (colours, indents and cursor codes dropped:
  the roll's own colours and centring do that), via data/text_overrides/pearl_credits.json (sinnoh_names). Black 2's
  lines after them stay, unused;
- the list (list_bytes, written by patches/game_clear.py): Black 2's shape with Pearl's lines: the fading pages show
  Pearl's first roles (Director; Art and Battle Directors; Program Leader), the scroll the rest, each role in Black
  2's title colour and font, its names 20 frames apart, the groups spread so the scroll lasts as long as Black 2's,
  and each photo shown at its time in Black 2's roll (at the next group's end); the producers after the last photo,
  "Pokémon Pearl" where the roll stops (Black 2's version title, LINE_AT) and "Fin" for DEVELOPED BY. The total
  stays Black 2's.
Not translated: the logo before the roll (a/0/2/6, already Pearl's: patches/pearl_title.py), the copyright screen
after it (a/2/0/5 art, Black 2's years) and THE END (Black 2's art).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)

PEARL_BANK = 493
B2_TEXT = os.path.join(ROOT, 'external', 'pokebw2', 'res', 'text', 'system', 'title_15.txt')
OVERRIDES = os.path.join(ROOT, 'data', 'text_overrides', 'pearl_credits.json')
END_ARC = 215
NONE = 0xFFFF
CMD_LINE, CMD_FADE_IN, CMD_FADE_OUT, CMD_SCROLL_START, CMD_SCROLL_STOP, CMD_END, CMD_YIELD, CMD_LINE_AT, \
    CMD_PICTURE, CMD_LAST_PICTURE = range(10)
GAME = 1                       # Pearl's "Pokémon Pearl" line (0 is Diamond's)
FIN = 215
FADE_PAGES = [(3, 4), (5, 6, 7, 8), (9, 10)]      # Director; Art Director, Battle Director; Program Leader
SCROLL_FIRST, SCROLL_LAST = 11, 210               # the scroll: Graphic Leader .. Producers
EXECUTIVES = (211, 212, 213, 214)                 # after the last photo, on Black 2's executive producers' four lines
LINE_WAIT = 20


def pearl_lines():
    """[(kind, text, sub)]: Pearl's 216 credit lines, kind 'game' (colour 1), 'title' (colour 2: a role), 'name'; sub:
    a role indented under another (Nintendo Wi-Fi Connection's)."""
    import gen4_text
    out = []
    for m in gen4_text.bank(PEARL_BANK):
        kind = 'game' if '{COLOR 1}' in m else 'title' if '{COLOR 2}' in m else 'name'
        text = re.sub(r'\{[^}]*\}', '', m).strip()
        out.append((kind, text, kind == 'title' and m.startswith(' ')))
    assert len(out) == 216 and out[GAME][:2] == ('game', 'Pokémon Pearl') and out[FIN][:2] == ('name', 'Fin'), out[:3]
    return out


def b2_labels():
    return [l.split('=', 1)[0].strip() for l in open(B2_TEXT, encoding='utf-8') if '=' in l and l.startswith('Title15')]


def overrides():
    labels = b2_labels()
    lines = pearl_lines()
    assert len(labels) >= len(lines)
    return {'_doc': 'Pearl\'s staff credits (Pearl bank 493) on the first 216 lines of Black 2\'s staff roll text '
                    '(res/text/system/title_15.txt), written by b2tools/pearl_credits.py (do not edit): the roll\'s '
                    'command list (a/2/1/5 file 1, patches/game_clear.py) shows them by these numbers.',
            'title_15': {labels[i]: text for i, (_, text, _) in enumerate(lines)}}


def _rec(msg, wait, cmd, arg=0, color=0, font=0, align=0, x=0, off=0):
    return struct.pack('<IHBBBBHhh', msg, wait, cmd, arg, color, font, align, x, off)


def _line(msg, kind, wait=LINE_WAIT):
    title = kind in ('title', 'game')
    return _rec(msg, wait, CMD_LINE, 0, 1 if title else 0, 1 if title else 0, 2, 128)


def b2_records(files):
    import narcio
    d = narcio.load(files, END_ARC)[1]
    return [struct.unpack_from('<IHBBBBHhh', d, 16 * i) for i in range(len(d) // 16)]


def _times(recs):
    """Black 2's roll: (scroll start frame, [(frame, record)] of its photos in the scroll, the last photo's frame,
    [the records from the last photo on])."""
    t, start, pics, last = 0, None, [], None
    for i, r in enumerate(recs):
        cmd = r[2]
        if cmd == CMD_SCROLL_START:
            start = t
        elif cmd == CMD_PICTURE and last is None:
            pics.append((t, r))
        elif cmd == CMD_LAST_PICTURE:
            last = (t, i)
            break
        t += r[1]
    return start, pics, last


def list_bytes(files):
    """Black 2's command list (a/2/1/5 file 1) remade for Pearl's lines (the module's docstring)."""
    recs = b2_records(files)
    lines = pearl_lines()
    start, pics, (last_t, last_i) = _times(recs)
    out = []
    # the fading pages: Black 2's own frames (records up to the scroll), Pearl's lines on them
    t, page, k = 0, 0, 0
    for r in recs:
        msg, wait, cmd = r[0], r[1], r[2]
        if cmd == CMD_SCROLL_START:
            break
        if cmd == CMD_FADE_IN:
            ids = FADE_PAGES[page]
            if k < len(ids):
                kind = lines[ids[k]][0]
                out.append(_rec(ids[k], wait, CMD_FADE_IN, 0, 1 if kind == 'title' else 0,
                                1 if kind == 'title' else 0, 2, 128))
            else:
                out.append(_rec(NONE, wait, CMD_LINE))
            k += 1
        elif cmd == CMD_FADE_OUT:
            assert k == len(FADE_PAGES[page]), (page, k)
            out.append(struct.pack('<IHBBBBHhh', *r))
            page, k = page + 1, 0
        else:
            out.append(struct.pack('<IHBBBBHhh', *r))
        t += wait
    assert page == len(FADE_PAGES) and t == start, (page, t, start)
    out.append(_rec(NONE, 0, CMD_SCROLL_START))
    # the scroll: Pearl's groups (a role and its names; the Wi-Fi Connection's sub-roles stay in its group)
    groups, cur = [], []
    for i in range(SCROLL_FIRST, SCROLL_LAST + 1):
        kind, text, sub = lines[i]
        if kind == 'title' and not sub and cur and lines[i - 1][0] != 'title':
            groups.append(cur)
            cur = []
        cur.append(i)
    groups.append(cur)
    pic_wait = sum(r[1] for _, r in pics)
    text_frames = LINE_WAIT * sum(len(g) for g in groups)
    gap = (last_t - start - pic_wait - text_frames) // len(groups)
    assert gap >= 2 * LINE_WAIT, f'credits: gaps of {gap} frames'
    t = start
    pending = list(pics)
    for g in groups:
        for i in g:
            out.append(_line(i, lines[i][0]))
            t += LINE_WAIT
        while pending and pending[0][0] <= t:            # a photo at its time in Black 2's roll, between groups
            _, r = pending.pop(0)
            out.append(struct.pack('<IHBBBBHhh', *r))
            t += r[1]
        out.append(_rec(NONE, gap, CMD_LINE))
        t += gap
    for _, r in pending:
        out.append(struct.pack('<IHBBBBHhh', *r))
        t += r[1]
    assert t <= last_t, (t, last_t)
    if t < last_t:
        out.append(_rec(NONE, last_t - t, CMD_LINE))
    # from the last photo on: Black 2's records to the end of the file, Pearl's executive producers on its four
    # producer lines; its LINE_AT (the version's title, drawn where the scroll stops) points past END to the two
    # version lines (Black 2 / White 2): both "Pokémon Pearl"; DEVELOPED BY after it becomes "Fin", GAME FREAK a wait
    # (2026-10-26: the list cut at END left LINE_AT reading past the file: about 15,000 frames of black in game)
    tail = recs[last_i:]
    end_at = next(i for i, r in enumerate(tail) if r[2] == CMD_END)
    at = next(i for i, r in enumerate(tail) if r[2] == CMD_LINE_AT)
    named = [i for i, r in enumerate(tail[:end_at]) if r[2] == CMD_LINE and r[0] != NONE]
    before, after = [i for i in named if i < at], [i for i in named if i > at]
    versions = [at + tail[at][3], at + tail[at][3] + 1]          # Black 2's (arg) and White 2's (arg + 1) line
    assert len(before) == len(EXECUTIVES) and len(after) == 2, (before, after)
    assert versions[1] < len(tail) and all(tail[v][2] == CMD_LINE and tail[v][0] != NONE for v in versions), versions
    ours = dict(zip(before, EXECUTIVES))
    ours.update({after[0]: FIN, after[1]: NONE, versions[0]: GAME, versions[1]: GAME})
    for j, r in enumerate(tail):
        r = list(r)
        if j in ours:
            r[0] = ours[j]
            if r[0] != NONE:
                r[4] = r[5] = 1 if lines[r[0]][0] in ('title', 'game') else 0
        out.append(struct.pack('<IHBBBBHhh', *r))
    return b''.join(out)


def describe(blob):
    names = pearl_lines()
    t = 0
    rows = []
    for i in range(len(blob) // 16):
        msg, wait, cmd, arg, color, font, align, x, off = struct.unpack_from('<IHBBBBHhh', blob, 16 * i)
        what = names[msg][1] if msg != NONE and msg < len(names) else ''
        rows.append(f'{t:6d} {cmd} {arg:2d} {wait:4d} {what}')
        t += wait
    return rows, t


if __name__ == '__main__':
    json.dump(overrides(), open(OVERRIDES, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    open(OVERRIDES, 'a').write('\n')
    print('wrote', os.path.relpath(OVERRIDES, ROOT))
    vanilla = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
    sys.path.insert(0, os.path.join(HERE, 'patches'))
    rows, total = describe(list_bytes(vanilla))
    print('\n'.join(rows))
    print('total frames', total)
