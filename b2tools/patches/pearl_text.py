"""Pearl's script text (notes/STORY.md): src/text/script/NNNN_pearl_*.txt (written by b2tools/pearl_story.py) into the
script message archive a/0/0/3 as file NNNN (Black 2's files are 0-675; Pearl's zone banks from 676, in the order of
Pearl's bank numbers: pearl_story.FIRST_TEXT_FILE). Black 2's own files are left byte for byte.

Packed with pokebw2's own packer (external/pokebw2/tools/text/text_data.py pack_file: the format of res/text/script,
`ID = text` lines, the game's encryption), then every file written is read back with pokebw2's unpack_file and
compared with its source line by line; a difference stops the build. Numbers with no Pearl file yet (zones not ported)
get a one-line placeholder, so a zone header can point at any of them. Zone headers get their text file in
patches/sinnoh_story.py.
"""
import glob, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402

SRC = os.path.join(ROOT, 'src', 'text', 'script')
FIRST = 676
PLACEHOLDER = 'PearlPlaceholder_Text_Empty = …\n'


def text_tools():
    sys.path.insert(0, DECOMP)
    from tools.text import text_data      # pokebw2's packer (read-only use of external/)
    return text_data


def messages(text):
    """The message texts of a res/text-format file (IDs dropped), as text_data.pack_file reads them."""
    td = text_tools()
    return [td.split_message(l)[1] for l in text.split('\n')[:-1] if not l.startswith('\\pad{')]


def apply(files):
    td = text_tools()
    srcs = {}
    for p in sorted(glob.glob(os.path.join(SRC, '*.txt'))):
        n = int(os.path.basename(p)[:4])
        assert n >= FIRST, f'{p}: Pearl text files start at {FIRST} (Black 2 keeps 0-{FIRST - 1})'
        srcs[n] = open(p, encoding='utf-8').read()
    if not srcs:
        return 'pearl_text: no Pearl text files'
    entries = narcio.load(files, 3)
    assert len(entries) >= FIRST, f'a/0/0/3 has {len(entries)} files, expected Black 2\'s {FIRST}'
    top = max(srcs)
    while len(entries) <= top:
        entries.append(b'')
    for n in range(FIRST, top + 1):
        entries[n] = td.pack_file(srcs.get(n, PLACEHOLDER))
    narcio.save(files, 3, entries)
    # read back
    back = narcio.load(files, 3)
    for n, text in srcs.items():
        got = [l for l in td.unpack_file(back[n]).split('\n')[:-1] if not l.startswith('\\pad{')]
        want = messages(text)
        if got != want:
            bad = next(i for i in range(max(len(got), len(want))) if i >= len(got) or i >= len(want) or got[i] != want[i])
            raise SystemExit(f'pearl_text: a/0/0/3 file {n} reads back differently at line {bad}: '
                             f'{(got + [None])[bad]!r} != {(want + [None])[bad]!r}')
    return f'pearl_text: {len(srcs)} Pearl text files in a/0/0/3 ({FIRST}-{top}, {top - FIRST + 1 - len(srcs)} ' \
           f'placeholders), read back equal'
