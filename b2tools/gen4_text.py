"""Pokémon Pearl (Gen 4) message files: decode msgdata/msg.narc members and convert their text to Black 2's script text.

    python3 gen4_text.py BANK [ROM]          print a bank in pokediamond's .gmm spelling, one message per line
    python3 gen4_text.py --b2 BANK [ROM]     print a bank as Black 2 res/text/script lines (to_b2)
    python3 gen4_text.py --verify [ROM]      compare every bank with pokediamond's .gmm (prints a summary)

Read-only; no third-party modules.

Format (one NARC member = one bank), from the game's code and pokediamond's msgenc:
  u16 count, u16 key; then count x {u32 offset, u32 length} (length in u16 characters, terminator included), each
  XOR'd with k = (key * 765 * (i + 1)) & 0xffff repeated in both halves (k | k << 16)
      -- arm9/src/msgdata.c Decrypt1; tools/msgenc/MessagesConverter.h MsgAlloc::encrypt (i counted from 1)
  then each message's u16 characters XOR'd with a key stream that starts at ((i + 1) * 596947) & 0xffff and adds
  18749 per character  -- msgdata.c Decrypt2; MessagesConverter.h EncryptU16String / enc_short
  Characters: 0xFFFF ends the message; 0xFFFE starts a control code: u16 command, u16 parameter count, parameters
  (arm9/src/string_control_code.c MsgArray_SkipControlCode / MsgArray_ControlCodeGetField); 0xF100 first means the
  rest is packed 9 bits per character into 15-bit words, ended by 0x1FF (arm9/src/unk_02021934.c
  StringCat_HandleTrainerName; msgenc MessagesDecoder::DecodeTrainerNameMessage). Characters map to text through
  pokediamond's charmap.txt (E000 = \\n line feed, 25BC = \\r, 25BD = \\f).
  .gmm spelling of a control code (MessagesDecoder::DecodeMessage): a command whose high byte is 01, 03, 04 or 34 is
  {STRVAR_<high byte in hex> <low byte>, a, b}, others {NAME a, b} by charmap.txt (FF01 SIZE, FF00 COLOR, 0200 YESNO..)

Checked: every one of the 30,211 messages of Pearl's 624 banks decodes; the 29,361 of the 623 .gmm banks equal
pokediamond's text exactly, and bank 559's 850 compressed trainer names equal trdata.json (diffs.txt).

to_b2(msg, kinds=None, punctuation='b2', colors='pearl', species_case=True) turns one message into a Black 2
res/text/script line (after `ID = `): \\n -> \\n, \\r -> {be01}\\n ({be01} at the end), \\f -> {be00}\\n ({be01}\\n
after a one-line page), {STRVAR_1 s, i} -> {kind:i} (STRVAR1_TO_B2), {COLOR n} -> {ff00:n}, {PAUSE n} -> {be02:n},
{CURSOR_X n} -> {bd05:n}, SIZE / "YESNO" icon dropped, characters B2's font lacks replaced. Mapping and sources:
notes/STORY.md "Text" (the research notes of 2026-10-18).

Written for the story port (2026-10-18; research: every Pearl bank decoded and compared with pokediamond's .gmm: equal).
The story translator (pearl_story.py) uses bank(), buffers() and b2_line(): Pearl's punctuation is kept (Black 2's
font has ’ “ ” ♂ ♀ at the same widths: word for word), species written in capitals in Pearl's text are given Black 2's
case (buffers insert Black 2's own mixed-case names, so the two match), and a code Black 2 has no equivalent for is
dropped and logged (UNCONVERTED), never silently.
"""
import os, re, struct, sys
import xml.etree.ElementTree as ET

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
DIAMOND = os.path.join(ROOT, 'external', 'pokediamond')
DEFAULT_ROM = os.path.join(ROOT, 'roms', 'pearl.nds')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

EOS, CTRL, COMPRESSED = 0xFFFF, 0xFFFE, 0xF100
LF, PAGE_CLEAR, PAGE_SCROLL = 0xE000, 0x25BC, 0x25BD     # \n, \r, \f in the .gmm
STRVAR_HIGH = {0x01, 0x03, 0x04, 0x34}


# ----------------------------------------------------------------------------------------------------------- charmap
def load_charmap(path=os.path.join(DIAMOND, 'charmap.txt')):
    """(chars, cmds): code -> .gmm text for characters, code -> command name. Same parsing as msgenc's ReadCharmap:
    '//' starts a comment, leading blanks are dropped, trailing ones are kept (01DE is a space)."""
    chars, cmds = {}, {}
    raw = open(path, 'rb').read().decode('utf-8')
    for line in re.split(r'\r\n|\n|\r', raw):
        if '//' in line:
            line = line[:line.index('//')]
        line = line.lstrip(' \t')
        if not line:
            continue
        code, _, text = line.partition('=')
        value = int(code, 16)
        if text.startswith('{') and text.endswith('}'):
            cmds[value] = text[1:-1]
        else:
            chars[value] = text
    return chars, cmds


CHARS, CMDS = load_charmap()
GMM_TO_CODE = {}
for _c, _t in CHARS.items():
    GMM_TO_CODE.setdefault(_t, _c)


# ------------------------------------------------------------------------------------------------------------ binary
def decrypt_bank(data):
    """List of messages, each a list of u16 codes as stored (terminator included), decrypted."""
    count, key = struct.unpack_from('<HH', data, 0)
    out = []
    for i in range(count):
        offset, length = struct.unpack_from('<II', data, 4 + 8 * i)
        k = (key * 765 * (i + 1)) & 0xFFFF
        k |= k << 16
        offset ^= k
        length ^= k
        codes = list(struct.unpack_from(f'<{length}H', data, offset))
        seed = ((i + 1) * 596947) & 0xFFFF
        for j in range(length):
            codes[j] ^= seed
            seed = (seed + 18749) & 0xFFFF
        out.append(codes)
    return out


def unpack_compressed(codes):
    """codes[0] == 0xF100: 9-bit characters in 15-bit words, up to 0x1FF (StringCat_HandleTrainerName)."""
    out, bit, p = [], 0, 1
    while p < len(codes):
        c = (codes[p] >> bit) & 0x1FF
        bit += 9
        if bit >= 15:
            p += 1
            bit -= 15
            if bit and p < len(codes):
                c |= (codes[p] << (9 - bit)) & 0x1FF
        if c == 0x1FF:
            break
        out.append(c)
    return out


def tokens(codes):
    """[('ch', code) | ('cmd', command, [params])], up to the terminator; a compressed message is unpacked first."""
    if codes and codes[0] == COMPRESSED:
        codes = unpack_compressed(codes) + [EOS]
    out, j = [], 0
    while j < len(codes):
        c = codes[j]
        if c == EOS:
            break
        if c == CTRL:
            cmd, n = codes[j + 1], codes[j + 2]
            out.append(('cmd', cmd, list(codes[j + 3:j + 3 + n])))
            j += 3 + n
        else:
            out.append(('ch', c))
            j += 1
    return out


def cmd_gmm(cmd, params):
    if (cmd >> 8) in STRVAR_HIGH:
        s = f'STRVAR_{cmd >> 8:X} {cmd & 0xFF}' + (',' if params else '')
    elif cmd in CMDS:
        s = CMDS[cmd]
    else:
        s = f'UNK_{cmd:04X}'
    return '{' + s + ','.join(f' {p}' for p in params) + '}'


def to_gmm(codes):
    """A message in pokediamond's .gmm spelling (what msgenc -d writes)."""
    pre = '{TRNAME}' if codes and codes[0] == COMPRESSED else ''
    out = []
    for t in tokens(codes):
        if t[0] == 'cmd':
            out.append(cmd_gmm(t[1], t[2]))
        else:
            out.append(CHARS.get(t[1], f'\\x{t[1]:04X}'))
    return pre + ''.join(out)


def read_bank(n, rom_path=DEFAULT_ROM, _cache={}):
    """Bank n of the ROM's msgdata/msg.narc as raw code lists."""
    if rom_path not in _cache:
        from gen4rom import Rom, narc_members
        _cache[rom_path] = narc_members(Rom(rom_path).read('msgdata/msg.narc'))
    return decrypt_bank(_cache[rom_path][n])


def bank_text(n, rom_path=DEFAULT_ROM):
    return [to_gmm(m) for m in read_bank(n, rom_path)]


def read_gmm(n):
    """pokediamond's files/msgdata/msg/narc_NNNN.gmm as msgenc reads it (garbage rows = spaces of the JA length)."""
    path = os.path.join(DIAMOND, 'files', 'msgdata', 'msg', f'narc_{n:04d}.gmm')
    if not os.path.exists(path):
        return None
    out = []
    for row in ET.parse(path).getroot().iter('row'):
        attr = next((a for a in row.findall('attribute') if a.get('name') == 'window_context_name'), None)
        lang = {l.get('name'): (l.text or '') for l in row.findall('language')}
        if attr is not None and (attr.text or '') == 'garbage':
            out.append(' ' * len(lang.get('日本語', '').encode('utf-8')))
        else:
            out.append(lang.get('English', ''))
    return out


# --------------------------------------------------------------------------------------------- conversion to Black 2
# Black 2 word-set kind ({01xx:i}, {02xx:i}) for each Gen 4 STRVAR_1 subtype (the low byte of 0x01xx). Neither game's
# field text reads the kind: Gen 4 StringExpandPlaceholders (arm9/src/message_format.c) tests only (code & 0xFF00) ==
# 0x100 and uses parameter 0, B2 GFL_WordSetFormatStrbuf (src/system/wordset.c) tests category 1 or 2 and uses
# parameter 0. Only B2's battle text reads the kind (src/ov167/btl_string.c). So the table follows each game's own
# convention, found by pairing buffer commands with the codes their next message uses (pearl_strvar_kinds.py on
# work/pearl/scripts, b2_wordset_kinds.py on res/field/scripts): see codes.md. A script converter that knows which
# WordSet command fills buffer i passes kinds={i: kind}.
STRVAR1_TO_B2 = {
    0: 0x0101,   # species (GetPokemonName, GetPlayerStarterName, Unk00DA; also GetPokemonNickname 19x) -> B2 0101
    1: 0x0102,   # nickname (GetPokemonNickname 19x)                       -> B2 0102 (WordSetPartyPokeName)
    3: 0x0100,   # trainer name: GetPlayerName / GetRivalName / GetFriendName -> B2 0100 (WordSetPlayerName, ..RivalName)
    4: 0x0105,   # map name (GetMapName)                                    -> B2 0105 (WordSetPlaceName)
    6: 0x0107,   # move (GetMoveName, GetTMHMMoveName, GetPokemonMoveName) -> B2 0107 (WordSetMoveName, ..TMMoveName)
    7: 0x0108,   # nature (GetNatureName)                                   -> B2 0108 (WordSetLoadNature)
    8: 0x0109,   # item (GetItemName, ..Plural, ..WithIndefArticle, GetBerryName, UG items) -> B2 0109 (WordSetItemName)
    14: 0x010E,  # trainer class (Unk00D9)                                  -> B2 010e (WordSetTrainerClassName)
    18: 0x0112,  # pocket (GetPocketName)                                   -> B2 0112 (WordSetItemPocketName)
    27: 0x0112,  # pocket (item-get script, bank 199 #126)
    60: 0x0112,  # pocket (field item script, bank 325 #9)
}
# Numbers: Gen 4 STRVAR_1 49+d marks a d-digit number (Unk00D5 = BufferNumber buffers it, digits from the value,
# scrcmd_names.c); B2 writes a d-digit number as 02(d-1) (btl_string.c: "the command's index is the number's digits
# less one"; WordSetNumber texts use 0200-0206).
for _d in range(1, 7):
    STRVAR1_TO_B2[49 + _d] = 0x0200 + _d - 1
# Gen 4 subtypes of features Black 2 lacks (no B2 kind): 10 gift, 24 Pokétch app, 25 decoration, 26 cup, 28 easy-chat
# / inscription, 31 accessory (also a pocket in bank 199 #30), 34/35 contest rank/category, 36/37 city/country,
# 39 ribbon, 61 Union group. to_b2 raises on them unless kinds= names one.

PK, MN = '₧', '₦'   # Gen 4 01E0 / 01E1, the "PK" "MN" glyphs (charmap ₧ ₦); B2 has no such glyphs
# Characters Black 2's font 0 lacks (b2font.py, a/0/2/3 member 0), with what B2 writes instead
CHAR_TO_B2 = {
    '♡': '♥',   # ♡ (Gen 4 00FC) -> ♥ (B2 text uses ♥ 13x)
    '♫': '♪',   # ♫ (Gen 4 0105) -> ♪
    '㊚': '⑭',   # ㊚ (Gen 4 00EE) -> ⑭, B2's inline male sign (Nidoran⑭)
    '㊛': '⑮',   # ㊛ (Gen 4 00EF) -> ⑮
    ' ': ' ',        # Gen 4 01E2 (not in script text)
}
# punctuation='b2': Black 2's own script text writes ' (8578x vs ’ 7x), “ then a straight " (776 “ / 778 " / 1 ”),
# and ⑭ ⑮ for gender signs (♂ ♀ never). Font 0 has ’ “ ” ♂ ♀ too, with the same advances (’ and ' both 5 px,
# “ ” and " 6 px), so punctuation='pearl' (keep Pearl's, as HoennB2's gen3text.py writes ’ “ ”) is also safe.
B2_PUNCT = {'’': "'", '‘': "'", '”': '"', '♂': '⑭', '♀': '⑮'}

_SPECIES_UPPER = None


def species_upper():
    """Pearl's capitalised species names -> Black 2's (res/pokemon/*/data.json), apostrophes normalised."""
    global _SPECIES_UPPER
    if _SPECIES_UPPER is None:
        import glob, json
        _SPECIES_UPPER = {}
        for f in glob.glob(os.path.join(ROOT, 'external', 'pokebw2', 'res', 'pokemon', '*', 'data.json')):
            name = json.load(open(f, encoding='utf-8')).get('name') or ''
            if any(c.isalpha() for c in name):
                _SPECIES_UPPER[name.upper().replace("'", '’').replace('⑭', '♂').replace('⑮', '♀')] = name
    return _SPECIES_UPPER


def b2_kind(cmd, params, kinds=None):
    low = cmd & 0xFF
    idx = params[0] if params else None
    if idx is None:
        raise ValueError(f'{cmd_gmm(cmd, params)} has no buffer index')
    if kinds and idx in kinds:
        return f'{{{kinds[idx]:04x}:{idx}}}'
    if cmd >> 8 != 0x01 or low not in STRVAR1_TO_B2:
        raise ValueError(f'{cmd_gmm(cmd, params)} has no Black 2 kind')
    return f'{{{STRVAR1_TO_B2[low]:04x}:{idx}}}'


def _next_text(toks, j, n=8):
    """The next n characters of text after token j, skipping control codes."""
    s = ''
    while j < len(toks) and len(s) < n:
        if toks[j][0] == 'ch':
            s += CHARS.get(toks[j][1], '?')
        j += 1
    return s


def to_b2(msg, kinds=None, punctuation='b2', colors='pearl', species_case=True):
    """A Pearl message -- raw codes from read_bank, or text in .gmm spelling -- as a Black 2 res/text/script message
    (the part after `ID = `). Raises ValueError on what has no Black 2 equivalent.

    kinds: {buffer index: B2 kind} from the script's WordSet commands, overriding STRVAR1_TO_B2.
    punctuation: 'b2' (Black 2's own: ' and “..." and ⑭⑮) or 'pearl' (keep ’ “ ” ♂ ♀).
    colors: 'pearl' keeps {COLOR n} as {ff00:n} (same color numbers: both games' field message palettes have red at
      1, blue at 2); 'b2' writes Pearl's red key-item names (COLOR 1) in Black 2's blue (ff00:2), as B2 writes
      "received a pair of {ff00:2}Running Shoes{ff00:0}!".
    species_case: Pearl's capitalised species names in the text itself (GYARADOS, PALKIA) in Black 2's case.
    """
    toks = tokens(msg) if isinstance(msg, list) else tokens(gmm_to_codes(msg))
    out = []
    lines_on_page = 1
    n = len(toks)
    for i, t in enumerate(toks):
        last = i + 1 == n
        if t[0] == 'cmd':
            cmd, params = t[1], t[2]
            if (cmd >> 8) in STRVAR_HIGH:
                if cmd == 0x011F and _next_text(toks, i + 1).startswith(' Pocket'):
                    cmd = 0x0112             # subtype 31 is also a pocket name (bank 199 #30): by its context
                out.append(b2_kind(cmd, params, kinds))
            elif cmd == 0xFF00:          # COLOR n: both games color n = palette entries 2n+1 / 2n+2
                c = params[0]            # (render_text.c case 0xFF00; printsys.c GFL_TextRndExecColorCmd)
                if 100 <= c < 255:
                    continue             # Gen 4 "remember color c-100 for COLOR 255": no B2 equivalent, no display
                if colors == 'b2' and c == 1:
                    c = 2
                out.append(f'{{ff00:{c}}}')
            elif cmd == 0xFF01:          # SIZE 200/100: Gen 4 big letters (render_text.c case 0xFF01). B2 has no
                continue                 # size command (categories bd layout, be stream, ff color only): dropped
            elif cmd == 0x0201:          # PAUSE n: wait n frames (render_text.c state 6) = B2 stream command 2
                out.append(f'{{be02:{params[0]}}}')
            elif cmd == 0x0203:          # CURSOR_X n: x = n (render_text.c case 0x203) = B2 layout command 5
                out.append(f'{{bd05:{params[0]}}}')
            elif cmd == 0x0205:          # ALN_CENTER = B2 layout command 2 (center the line)
                out.append('{bd02}')
            elif cmd == 0x0206:          # ALN_RIGHT n = B2 layout command 3 (right-align, margin n)
                out.append(f'{{bd03:{params[0] if params else 0}}}')
            elif cmd == 0x0200:          # "YESNO" n: draws icon n (font.narc 5, 24x32) at the window's right edge
                continue                 # (text.c sub_0201C1EC): no B2 equivalent, dropped (only bank 18 #25)
            else:                        # WAIT n (0x202: printer callback value, TM boot-up sounds), CURSOR_Y, ...
                raise ValueError(f'control code {cmd_gmm(cmd, params)} has no Black 2 equivalent')
            continue
        c = t[1]
        if c == LF:
            out.append('\\n')
            lines_on_page += 1
        elif c == PAGE_CLEAR:            # \r (25BC): wait, clear, continue at the top = B2 {be01} (PAGE_CLEAR);
            out.append('{be01}' + ('' if last else '\\n'))   # B2 skips the \n after a page break (func_02022694)
            lines_on_page = 1
        elif c == PAGE_SCROLL:           # \f (25BD): wait, scroll one line, continue on line 2 = B2 {be00}
            # (PAGE_SCROLL: B2 then prints at y 16). After a one-line page Gen 4 keeps printing on line 1, B2 on
            # line 2 (pushing the next \n to a 3rd line): a clear is the faithful page break there.
            out.append(('{be00}' if lines_on_page >= 2 else '{be01}') + ('' if last else '\\n'))
            lines_on_page = 2
        else:
            ch = CHARS.get(c)
            if ch is None or len(ch) != 1:
                raise ValueError(f'character {c:04X} ({ch!r}) has no Black 2 equivalent')
            if ch == PK:
                if i + 1 < n and toks[i + 1] == ('ch', GMM_TO_CODE[MN]):
                    out.append('Pokémon')
                    continue
                raise ValueError('lone PK glyph')
            if ch == MN and out and out[-1] == 'Pokémon':
                continue
            ch = CHAR_TO_B2.get(ch, ch)
            if punctuation == 'b2':
                ch = B2_PUNCT.get(ch, ch)
            out.append({'\\': '\\\\', '{': '\\{', '}': '\\}'}.get(ch, ch))
    s = ''.join(out)
    if species_case:
        names = species_upper()
        def fix(m):
            w = m.group(0)
            core = w.rstrip(".'\u2019")
            key = core.replace("'", '\u2019').replace('\u246d', '\u2642').replace('\u246e', '\u2640')
            return names[key] + w[len(core):] if key in names else w
        s = re.sub(r"[A-Z][A-Z.\-\u2019'\u00e92]*[A-Z2\u2019'.\u2642\u2640\u246d\u246e]", fix, s)
        s = re.sub(r'MR\. MIME|MIME JR\.', lambda m: names.get(m.group(0), m.group(0)), s)
    return s


def convert_bank(n, rom_path=DEFAULT_ROM, **kw):
    """[(index, B2 text or None, error or None)] for bank n."""
    out = []
    for i, m in enumerate(read_bank(n, rom_path)):
        try:
            out.append((i, to_b2(m, **kw), None))
        except ValueError as e:
            out.append((i, None, str(e)))
    return out


def gmm_to_codes(text):
    """.gmm spelling -> u16 codes with terminator (msgenc's EncodeMessage, without the compressed form)."""
    out, j = [], 0
    while j < len(text):
        if text[j] == '{':
            k = text.index('}', j)
            inner = text[j + 1:k]
            j = k + 1
            name, _, rest = inner.partition(' ')
            args = [int(a) for a in rest.split(',')] if rest.strip() else []
            m = re.fullmatch(r'STRVAR_([0-9A-F]+)', name)
            if m:
                cmd = (int(m[1], 16) << 8) | args.pop(0)
            else:
                cmd = next(c for c, nm in CMDS.items() if nm == name)
            out += [CTRL, cmd, len(args)] + args
            continue
        for L in (6, 2, 1):            # \x0000, \n \r \f, single characters
            s = text[j:j + L]
            if s in GMM_TO_CODE:
                out.append(GMM_TO_CODE[s])
                j += L
                break
        else:
            raise ValueError(f'unknown character {text[j]!r}')
    return out + [EOS]


def to_unicode(codes):
    """Plain readable text: line breaks as newlines, page breaks as blank-line separators, codes kept in .gmm form."""
    s = to_gmm(codes)
    return s.replace('\\n', '\n').replace('\\r', '\n\n').replace('\\f', '\n')



# ------------------------------------------------------------------------------------------- the story translator's API
COUNTERPART = {'boy': 'Dawn', 'girl': 'Lucas'}     # Pearl's counterpart: Dawn for a boy player, Lucas for a girl
UNCONVERTED = []                                   # (bank text, what was dropped) of every b2_line fallback
_BANKS = {}
_STRVAR = re.compile(r'\{STRVAR_1 (\d+), (\d+)(?:, \d+)*\}')


TEXT_EDITS = os.path.join(ROOT, 'data', 'pearl_text_edits.json')


def text_edits():
    """{bank: {line: [(old, new), ...]}}: the project's few deliberate changes of Pearl's words (data/
    pearl_text_edits.json, each with its reason there)."""
    if not os.path.exists(TEXT_EDITS):
        return {}
    import json
    d = json.load(open(TEXT_EDITS, encoding='utf-8'))
    return {int(b): {int(l): [tuple(p) for p in pairs] for l, pairs in lines.items()}
            for b, lines in d.items() if not b.startswith('_')}


def bank(n):
    """Pearl's bank n (the dump's msgdata/msg.narc member n) as messages in pokediamond's .gmm spelling, with
    data/pearl_text_edits.json applied (each edit's old words must be in its line: a changed dump stops here)."""
    if n not in _BANKS:
        msgs = bank_text(n)
        for line, pairs in text_edits().get(n, {}).items():
            for old, new in pairs:
                assert old in msgs[line], f'pearl_text_edits.json: bank {n} line {line} has no {old!r}'
                msgs[line] = msgs[line].replace(old, new, 1)
        _BANKS[n] = msgs
    return _BANKS[n]


def buffers(text):
    """The word-buffer numbers a message's placeholders read."""
    return {int(m.group(2)) for m in _STRVAR.finditer(text)}


def b2_line(text, variant=None):
    """A Pearl message (.gmm spelling) as a Black 2 script text line. variant ('boy' | 'girl', buffers): those
    buffers hold the counterpart's name, written out (Black 2's gendered-message copies). Never raises: a code Black 2
    lacks is dropped (a placeholder of a Pearl-only kind keeps its buffer as {0100:i}) and listed in UNCONVERTED."""
    if variant:
        g, bufs = variant
        text = _STRVAR.sub(lambda m: COUNTERPART[g] if int(m.group(2)) in bufs else m.group(0), text)
    kinds, dropped = {}, []
    for _ in range(20):
        try:
            out = to_b2(text, kinds=kinds or None, punctuation='pearl', colors='pearl', species_case=True)
            if dropped:
                UNCONVERTED.append((text, dropped))
            return out
        except ValueError as e:
            msg = str(e)
            m = re.search(r'\{STRVAR_1 (\d+), (\d+)', msg)
            if 'has no Black 2 kind' in msg and m:
                kinds[int(m.group(2))] = 0x0100          # Black 2's field text ignores the kind (wordset.c)
                dropped.append(f'kind of {m.group(0)}}} -> 0100')
                continue
            m = re.search(r'(\{STRVAR_1 \d+\}) has no buffer index', msg)
            if m and m.group(1) in text:
                text = text.replace(m.group(1), '', 1)
                dropped.append(m.group(1))
                continue
            m = re.search(r'control code (\{[^}]*\})', msg)
            if m and m.group(1) in text:
                text = text.replace(m.group(1), '', 1)
                dropped.append(m.group(1))
                continue
            m = re.search(r'character ([0-9A-F]{4})', msg)
            if m:
                ch = CHARS.get(int(m.group(1), 16), '')
                if ch and ch in text:
                    text = text.replace(ch, '', 1)
                    dropped.append(f'character {m.group(1)} {ch!r}')
                    continue
            raise
    raise ValueError(f'b2_line: cannot convert {text!r}')

# -------------------------------------------------------------------------------------------------------------- main
def verify(rom_path=DEFAULT_ROM, out=sys.stdout):
    from gen4rom import Rom, narc_members
    members = narc_members(Rom(rom_path).read('msgdata/msg.narc'))
    same = diff = 0
    diffs = []
    for n in range(len(members)):
        gmm = read_gmm(n)
        if gmm is None:
            continue
        rom = [to_gmm(m) for m in decrypt_bank(members[n])]
        if len(rom) != len(gmm):
            diffs.append((n, None, f'{len(rom)} messages in the ROM, {len(gmm)} in the .gmm', ''))
        for i, (a, b) in enumerate(zip(rom, gmm)):
            if a == b:
                same += 1
            else:
                diff += 1
                diffs.append((n, i, a, b))
    return same, diff, diffs


if __name__ == '__main__':
    args = sys.argv[1:]
    rom = DEFAULT_ROM
    if args and args[-1].endswith('.nds'):
        rom = args.pop()
    if args[:1] == ['--verify']:
        same, diff, diffs = verify(rom)
        print(f'{same} messages equal, {diff} differ')
        for n, i, a, b in diffs:
            print(f'bank {n} msg {i}\n  ROM: {a}\n  gmm: {b}')
    elif args[:1] == ['--b2']:
        for i, m in enumerate(read_bank(int(args[1]), rom)):
            try:
                print(f'{i}\t{to_b2(m)}')
            except ValueError as e:
                print(f'{i}\t!! {e}: {to_gmm(m)}')
    else:
        for i, t in enumerate(bank_text(int(args[0]), rom)):
            print(f'{i}\t{t}')
