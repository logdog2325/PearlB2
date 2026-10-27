"""Gen 4 (Diamond/Pearl) field script disassembler: Pearl's scr_seq_release.narc, from the dump to readable text.

    python3 gen4_script.py [ROM] [OUT_DIR]       defaults: roms/pearl.nds, work/pearl/scripts
    python3 gen4_script.py --table               rebuild data/gen4_script_cmds.json from the decomps and print a summary

Opcode table (data/gen4_script_cmds.json, cached; rebuilt when missing or with --table):
  pokediamond's gScriptCmdTable (arm9/asm/unk_02038C78.s, 721 entries) names each opcode's handler. The argument
  layout is read from the handler, in reading order:
    'pokediamond-c'    arm9/src/*.c: ScriptReadByte / ScriptReadHalfword / ScriptReadWord / ScriptGetVar(Pointer),
                       helper functions that take the context are followed; ScriptJump / ScriptCall / ScriptReturn /
                       StopScript and `scriptPtr + offset` give the flow type and relative-offset arguments.
    'pokediamond-asm'  arm9/asm/*.s: the same readers as `bl`, ScriptReadByte inlined as a +1 store to ctx->scriptPtr
                       ([rN, #0x8]); a halfword read that feeds FieldSystem_VarGet / GetVarPointer is a var.
    'manual'           handlers whose reads depend on an argument's value (a switch or an if in the handler):
                       the cases are written out below (MANUAL) from the same handler source, checked on the data.
    'pokeplatinum'     asm/macros/scrcmd.inc, by matching handler, only where pokediamond gives no layout.
  Argument types: u8, u16, u32, var (u16 var-or-value), rel (s32 offset to code), mov (s32 offset to movement data).
  Flow: end, jump, call, cjump (conditional jump), ccall (conditional call), return, or none.

Script file layout (checked on all 1,051 files): u32 offsets (relative to the end of each u32) to the entry points,
ended by u16 0xFD13; then code; movement lists (u16 command, u16 count pairs ended by u16 0xFE) referenced by
ApplyMovement (opcode 0x5E). Level-script files (zones' level_scripts) are: entries {u8 type, u32 value} ended by
u8 0; type 1's value is a relative offset to a table of {u16 var, u16 value, u16 script id} ended by u16 0, the other
types' value is a script id. A few script files have no 0xFD13 (the header then ends where the first script starts);
files no zone names are told apart by format (a clean level-script parse). Disassembly follows control flow from the
entry points; bytes no flow reaches are then decoded linearly and shown as 'unreferenced' (mostly the End the compiler
put after a GoTo, and unused scripts / movement lists), zero runs that align a movement list or end the file are padding,
and anything else is printed as UNEXPLAINED and counted in the summary (none on Pearl).
Read-only: nothing is written to the ROM.
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from gen4rom import Rom, narc_members  # noqa: E402

DIAMOND = os.path.join(ROOT, 'external', 'pokediamond')
PLATINUM = os.path.join(ROOT, 'external', 'pokeplatinum')
TABLE_JSON = os.path.join(HERE, 'data', 'gen4_script_cmds.json')
SIZES = {'u8': 1, 'u16': 2, 'var': 2, 'u32': 4, 'rel': 4, 'mov': 4}

# Handlers whose argument count depends on an argument (reads inside a switch / if of the handler), written out case by
# case from the pokediamond source named. Format: (fixed leading args, index of the selector arg, {value: more args},
# default more args).
MANUAL = {
    # arm9/src/scrcmd_flags.c: u8 option; only option 2 (get) reads a var pointer
    'ScrCmd_GetSetStrength': (['u8'], 0, {2: ['var']}, []),
    'ScrCmd_GetSetFlash': (['u8'], 0, {2: ['var']}, []),
    'ScrCmd_GetSetDefog': (['u8'], 0, {2: ['var']}, []),
    # arm9/src/scrcmd_union.c: u16 option; 0-3 two vars, 4 and 5 one var, 6 none
    'ScrCmd_UnionGroup': (['u16'], 0, {0: ['var', 'var'], 1: ['var', 'var'], 2: ['var', 'var'], 3: ['var', 'var'],
                                       4: ['var'], 5: ['var']}, []),
    # arm9/src/scrcmd.c: var pointer, then a 5-iteration loop of bytes, then one byte (not a switch)
    'ScrCmd_Unk0289': (['var', 'u8', 'u8', 'u8', 'u8', 'u8', 'u8'], None, {}, []),
    # arm9/asm/scrcmd_9.s: u16 selector, jump table of 7 cases
    'ScrCmd_Unk0235': (['u16'], 0, {0: ['var'], 1: ['u16', 'var', 'var'], 2: [], 3: ['var', 'var', 'var'],
                                    4: ['var', 'var'], 5: ['var', 'var', 'var'], 6: ['var']}, []),
    # arm9/asm/scrcmd_9.s: u16 selector, 0 and 1 three vars
    'ScrCmd_Unk0237': (['u16'], 0, {0: ['var', 'var', 'var'], 1: ['var', 'var', 'var']}, []),
    # arm9/asm/scrcmd_12.s: u16 selector, jump table of 9 cases
    'ScrCmd_Unk023E': (['u16'], 0, {0: [], 1: ['var'], 2: ['var'], 3: ['var'], 4: [], 5: ['var', 'var'],
                                    6: ['var', 'var'], 7: [], 8: []}, []),
    # arm9/asm/scrcmd_9.s: u16 selector, 0-2 one var
    'ScrCmd_Unk027C': (['u16'], 0, {0: ['var'], 1: ['var'], 2: ['var']}, []),
}


# ---------------------------------------------------------------- opcode table from pokediamond

def cmd_table_names():
    src = open(os.path.join(DIAMOND, 'arm9/asm/unk_02038C78.s'), encoding='utf-8').read()
    body = src[src.index('gScriptCmdTable:'):]
    names = []
    for line in body.splitlines()[1:]:
        m = re.match(r'\s*\.word\s+(\w+)', line)
        if not m:
            if names:
                break
            continue
        names.append(m.group(1))
    return names


def strip_c_comments(s):
    s = re.sub(r'/\*.*?\*/', ' ', s, flags=re.S)
    return re.sub(r'//[^\n]*', ' ', s)


def c_functions():
    """{name: (file, param_name_of_ScriptContext_or_None, body)} for every function defined in arm9/src/*.c."""
    funcs = {}
    d = os.path.join(DIAMOND, 'arm9/src')
    for fn in sorted(os.listdir(d)):
        if not fn.endswith('.c'):
            continue
        s = strip_c_comments(open(os.path.join(d, fn), encoding='utf-8', errors='replace').read())
        for m in re.finditer(r'^[A-Za-z_][\w \t\*]*?\b(\w+)\s*\(([^;{)]*)\)\s*\{', s, re.M):
            name, params = m.group(1), m.group(2)
            if name in ('if', 'while', 'for', 'switch'):
                continue
            i, depth = m.end() - 1, 0
            for j in range(i, len(s)):
                if s[j] == '{':
                    depth += 1
                elif s[j] == '}':
                    depth -= 1
                    if depth == 0:
                        break
            pm = re.search(r'ScriptContext\s*\*\s*(\w+)', params)
            funcs.setdefault(name, (fn, pm.group(1) if pm else None, s[i + 1:j]))
    return funcs


READ_RE = (r'(?P<r>ScriptGetVarPointer|ScriptGetVar|ScriptReadHalfword|ScriptReadWord|ScriptReadByte)\s*\(\s*{c}\s*\)'
           r'|(?P<flow>\b(ScriptJump|ScriptCall|ScriptReturn|StopScript))\b'
           r'|(?P<call>\b\w+)\s*\(\s*{c}\s*[,)]'
           r'|(?P<ptr>scriptPtr\s*\+=?\s*(?P<pv>\w+))')
KIND = {'ScriptGetVarPointer': 'var', 'ScriptGetVar': 'var', 'ScriptReadHalfword': 'u16', 'ScriptReadWord': 'u32',
        'ScriptReadByte': 'u8'}


def c_layout(funcs, name, depth=0):
    """(args, flow names, conditional?) of a C function; args are [type, ...] in reading order."""
    fn, ctx, body = funcs[name]
    if ctx is None:
        return [], [], False
    args, flows, cond = [], [], False
    word_vars = {}   # variable name assigned from a word read -> arg index
    for m in re.finditer(READ_RE.format(c=re.escape(ctx)), body):
        before = body[:m.start()]
        stmt = re.split(r'[;{}]', before)[-1]
        nested = (before.count('{') - before.count('}') > 0 or re.search(r'\b(if|while|for)\b|\?', stmt)
                  or re.search(r'\breturn\b', before))
        if m.group('r'):
            if nested:
                cond = True
            args.append(KIND[m.group('r')])
            if m.group('r') == 'ScriptReadWord':
                vm = re.search(r'(\w+)\s*=\s*(\([^()]*\)\s*)?$', before)
                if vm:
                    word_vars[vm.group(1)] = len(args) - 1
        elif m.group('call'):
            callee = m.group('call')
            if callee in funcs and callee != name and depth < 4 and callee not in KIND:
                sub, subflow, subcond = c_layout(funcs, callee, depth + 1)
                if sub and nested:
                    cond = True
                args += sub
                flows += subflow
                cond = cond or subcond
        elif m.group('flow'):
            flows.append(m.group('flow') + ('?' if nested else ''))
        elif m.group('ptr'):
            v = m.group('pv')
            if v in word_vars:
                args[word_vars[v]] = 'rel'
    return args, flows, cond


def asm_functions():
    """{name: [instruction lines]} for thumb functions in arm9/asm/*.s."""
    funcs = {}
    d = os.path.join(DIAMOND, 'arm9/asm')
    for fn in sorted(os.listdir(d)):
        if not fn.endswith('.s'):
            continue
        cur = None
        for line in open(os.path.join(d, fn), encoding='utf-8', errors='replace'):
            m = re.match(r'(\w+):', line)
            if m and not line.startswith('_0'):
                cur = m.group(1)
                funcs[cur] = []
            elif re.match(r'\s+(thumb|arm)_func_start', line):
                cur = None
            elif cur:
                funcs[cur].append(line.split(';')[0].rstrip())
    return funcs


def asm_layout(lines):
    args, flows, cond, branched = [], [], False, False
    pending_hw = []
    for i, l in enumerate(lines):
        if re.match(r'_\w+:', l) or re.match(r'\s+(b|b\w\w)\s+_', l):
            branched = True
        m = re.match(r'\s+bl\s+(\w+)', l)
        if m:
            f = m.group(1)
            if f in ('ScriptReadHalfword', 'ScriptReadWord'):
                cond = cond or branched
                args.append('u16' if f == 'ScriptReadHalfword' else 'u32')
                if f == 'ScriptReadHalfword':
                    pending_hw.append(len(args) - 1)
            elif f in ('FieldSystem_VarGet', 'GetVarPointer') and pending_hw:
                args[pending_hw.pop()] = 'var'
            elif f in ('ScriptJump', 'ScriptCall', 'ScriptReturn', 'StopScript'):
                flows.append(f + ('?' if branched else ''))
        elif re.match(r'\s+str\s+r\d+, \[r\d+, #0x8\]', l) and re.match(r'\s+add\s+r\d+, r\d+, #0x1', lines[i - 1]):
            cond = cond or branched
            args.append('u8')
    return args, flows, cond


def flow_type(flows):
    f = set(flows)
    if 'StopScript' in f:
        return 'end'
    if 'ScriptReturn' in f:
        return 'return'
    if 'ScriptJump' in f:
        return 'jump'
    if 'ScriptCall' in f:
        return 'call'
    if 'ScriptJump?' in f:
        return 'cjump'
    if 'ScriptCall?' in f:
        return 'ccall'
    return None


def platinum_layouts():
    """{handler name: [types]} from Platinum's scrcmd.inc macros, via include/data/scripts/scrcmd.h."""
    inc = open(os.path.join(PLATINUM, 'asm/macros/scrcmd.inc'), encoding='utf-8').read()
    by_const = {}
    for m in re.finditer(r'\.macro\s+\w+[^\n]*\n(.*?)\.endm', inc, re.S):
        lines = [l.strip() for l in m.group(1).splitlines() if l.strip()]
        if not lines or not re.match(r'\.short\s+SCRCMD_\w+$', lines[0]):
            continue
        const = lines[0].split()[1]
        types = []
        for l in lines[1:]:
            t = re.match(r'\.(byte|short|long|hword|word)\b', l)
            if not t or '.if' in l:
                types = None
                break
            types.append({'byte': 'u8', 'short': 'u16', 'hword': 'u16', 'long': 'u32', 'word': 'u32'}[t.group(1)])
        if types is not None:
            by_const.setdefault(const, types)
    out = {}
    for m in re.finditer(r'ScriptCommand\((SCRCMD_\w+),\s*(\w+)\)',
                         open(os.path.join(PLATINUM, 'include/data/scripts/scrcmd.h'), encoding='utf-8').read()):
        if m.group(1) in by_const:
            out[m.group(2)] = by_const[m.group(1)]
    return out


def build_table():
    names = cmd_table_names()
    cfuncs, afuncs = c_functions(), asm_functions()
    plat = platinum_layouts()
    table = []
    for op, h in enumerate(names):
        e = {'op': op, 'name': h[7:] if h.startswith('ScrCmd_') else h, 'handler': h}
        if h in MANUAL:
            fixed, sel, cases, default = MANUAL[h]
            e.update(args=fixed, flow=None, source='manual')
            if sel is not None:
                e['switch'] = {'arg': sel, 'cases': {str(k): v for k, v in cases.items()}, 'default': default}
        elif h in cfuncs:
            args, flows, cond = c_layout(cfuncs, h)
            e.update(args=args, flow=flow_type(flows), source='pokediamond-c', file='arm9/src/' + cfuncs[h][0])
            if cond:
                e['conditional_reads'] = True
        elif h in afuncs:
            args, flows, cond = asm_layout(afuncs[h])
            e.update(args=args, flow=flow_type(flows), source='pokediamond-asm')
            if cond:
                e['conditional_reads'] = True
        elif h in plat:
            e.update(args=plat[h], flow=None, source='pokeplatinum')
        else:
            e.update(args=None, flow=None, source='unknown')
        if e['op'] == 0x5E and e.get('args') == ['var', 'rel']:
            e['args'] = ['var', 'mov']      # sub_0205AEA4(event, ctx->scriptPtr + offset): a movement list
        table.append(e)
    return table


def load_table(rebuild=False):
    if rebuild or not os.path.exists(TABLE_JSON):
        table = build_table()
        os.makedirs(os.path.dirname(TABLE_JSON), exist_ok=True)
        with open(TABLE_JSON, 'w') as f:
            f.write('[\n' + ',\n'.join(json.dumps(e) for e in table) + '\n]\n')
    return json.load(open(TABLE_JSON))


# ---------------------------------------------------------------- disassembly

class Disasm:
    """One script file followed from its entry points: insns {addr: (end, op, [(type, value)], text)},
    movement {addr: [(cmd, count)]}, problems [str]."""

    def __init__(self, data, table):
        self.d, self.t = data, table
        self.entries, self.insns, self.movement, self.problems = [], {}, {}, []
        self.labels = {}            # addr -> label kind ('code' / 'mov')
        self.unknown_ops = set()
        self.no_terminator = False
        self.owner = bytearray(len(data))   # 0 free, 1 header, 2 code, 3 movement, 4 padding
        self.header()
        work = list(self.entries)
        seen = set()
        while work:
            a = work.pop()
            while a not in seen:
                seen.add(a)
                nxt = self.insn(a, work)
                if nxt is None:
                    break
                a = nxt
        self.coverage()

    def mark(self, a, n, kind):
        for i in range(a, a + n):
            if i >= len(self.d):
                self.problems.append(f'{a:04X}: runs past the file end')
                return False
            if self.owner[i] and self.owner[i] != kind:
                self.problems.append(f'{a:04X}: overlaps other data at {i:04X}')
                return False
            self.owner[i] = kind
        return True

    def header(self):
        p, first = 0, len(self.d)
        self.code_start = 0
        while True:
            if p >= first:      # a few files have no terminator: the code starts where the first script does
                self.code_start = p
                self.no_terminator = True
                return
            if p + 2 > len(self.d):
                self.problems.append('header: no 0xFD13 terminator')
                return
            if struct.unpack_from('<H', self.d, p)[0] == 0xFD13:
                self.mark(p, 2, 1)
                self.code_start = p + 2
                return
            off, = struct.unpack_from('<i', self.d, p)
            self.mark(p, 4, 1)
            tgt = p + 4 + off
            if not 0 <= tgt < len(self.d):
                self.problems.append(f'header: entry {len(self.entries) + 1} points outside the file ({tgt:X})')
            else:
                self.entries.append(tgt)
                first = min(first, tgt)
            p += 4

    def decode(self, a, limit=None):
        """(end, op, [(type, value)]) of the instruction at a, or raise ValueError; no side effects."""
        limit = len(self.d) if limit is None else limit
        if a + 2 > limit:
            raise ValueError(f'{a:04X}: code runs past the end')
        op, = struct.unpack_from('<H', self.d, a)
        if op >= len(self.t) or self.t[op]['args'] is None:
            raise ValueError(f'{a:04X}: unknown opcode {op:#06x}')
        e = self.t[op]
        p, args, types, i = a + 2, [], list(e['args']), 0
        while i < len(types):
            ty = types[i]
            n = SIZES[ty]
            if p + n > limit:
                raise ValueError(f'{a:04X}: {e["name"]} runs past the end')
            v = self.d[p] if n == 1 else struct.unpack_from('<H' if n == 2 else '<i', self.d, p)[0]
            p += n
            args.append((ty, p + v) if ty in ('rel', 'mov') else (ty, v))
            sw = e.get('switch')
            if sw and i == sw['arg']:
                types[i + 1:i + 1] = sw['cases'].get(str(v), sw['default'])
            i += 1
        return p, op, args

    def insn(self, a, work):
        try:
            p, op, args = self.decode(a)
        except ValueError as x:
            if 'unknown opcode' in str(x):
                self.unknown_ops.add(struct.unpack_from('<H', self.d, a)[0])
            self.problems.append(str(x))
            return None
        e = self.t[op]
        if not self.mark(a, p - a, 2):
            return None
        self.insns[a] = (p, op, args)
        for ty, tgt in args:
            if ty not in ('rel', 'mov'):
                continue
            if not 0 <= tgt < len(self.d):
                self.problems.append(f'{a:04X}: {e["name"]} target outside the file ({tgt:X})')
            elif ty == 'rel':
                self.labels.setdefault(tgt, 'code')
                work.append(tgt)
            else:
                self.labels[tgt] = 'mov'
                self.read_movement(tgt)
        if e['flow'] in ('end', 'jump', 'return'):
            return None
        return p

    def read_movement(self, a):
        if a in self.movement:
            return
        steps, p = [], a
        while True:
            if p + 4 > len(self.d):
                self.problems.append(f'{a:04X}: movement runs past the file end')
                break
            cmd, n = struct.unpack_from('<HH', self.d, p)
            steps.append((cmd, n))
            p += 4
            if cmd == 0xFE:
                break
        if a % 4:
            self.problems.append(f'{a:04X}: movement list not 4-aligned')
        self.mark(a, p - a, 3)
        self.movement[a] = steps

    def movement_run(self, a, limit):
        """End of a movement list starting at a and ending (0xFE) before limit, else None."""
        p = a
        while p + 4 <= limit:
            cmd, n = struct.unpack_from('<HH', self.d, p)
            p += 4
            if cmd == 0xFE:
                return p
            if cmd > 0xFF:
                return None
        return None

    def code_run(self, a, limit):
        """[(addr, end, op, args)] of instructions from a up to one that ends the flow, all before limit, else None."""
        run = []
        try:
            while a < limit:
                p, op, args = self.decode(a, limit)
                run.append((a, p, op, args))
                if self.t[op]['flow'] in ('end', 'jump', 'return'):
                    return run
                a = p
        except ValueError:
            return None
        return None

    def coverage(self):
        """Bytes no control flow reaches. Zero runs shorter than 4 that end at a 4-aligned movement list or the file end
        are padding. Other gaps are decoded linearly, apart from the reached code, and shown as unreferenced: runs of
        instructions ending in End / GoTo / Return (most often the End the script compiler put after a GoTo), and
        4-aligned movement lists. What still does not decode is reported as unexplained."""
        self.unreached, self.dead, self.dead_bytes = [], set(), 0
        i, n = 0, len(self.d)
        while i < n:
            if self.owner[i]:
                i += 1
                continue
            j = i
            while j < n and not self.owner[j]:
                j += 1
            q, rest = i, self.d[i:j]
            if not any(rest) and j - q < 4 and (j == n or self.owner[j] == 3 or j % 4 == 0):
                self.owner[q:j] = b'\4' * (j - q)
                i = j
                continue
            if q % 4 and q + (-q % 4) <= j and not any(self.d[q:q + (-q % 4)]) and \
                    self.movement_run(q + (-q % 4), j):
                self.owner[q:q + (-q % 4)] = b'\4' * (-q % 4)    # alignment before an unreferenced movement list
                i = q + (-q % 4)
                end = self.movement_run(i, j)
                self.dead_movement(i, end)
                i = end
                continue
            k = q - 1
            while k >= 0 and self.owner[k] == 4:
                k -= 1
            after_movement = k >= 0 and self.owner[k] in (3, 6)   # movement lists sit after the code
            run = None if after_movement and q % 4 == 0 and self.movement_run(q, j) else self.code_run(q, j)
            if run:
                for a, p, op, args in run:
                    self.insns[a] = (p, op, args)
                    self.dead.add(a)
                self.owner[q:run[-1][1]] = b'\5' * (run[-1][1] - q)
                self.dead_bytes += run[-1][1] - q
                for a, p, op, args in run:
                    for ty, tgt in args:
                        if ty in ('rel', 'mov') and 0 <= tgt < n:
                            self.labels.setdefault(tgt, 'code' if ty == 'rel' else 'mov')
                        if ty == 'mov' and 0 <= tgt < n and not self.owner[tgt]:
                            end = self.movement_run(tgt, n)
                            if end and not any(self.owner[tgt:end]):
                                self.dead_movement(tgt, end)
                i = run[-1][1]
                continue
            end = self.movement_run(q, j) if q % 4 == 0 else None
            if end:
                self.dead_movement(q, end)
                i = end
                continue
            self.unreached.append((q, j))
            i = j

    def dead_movement(self, q, end):
        self.movement[q] = [struct.unpack_from('<HH', self.d, k) for k in range(q, end, 4)]
        self.dead.add(q)
        self.owner[q:end] = b'\6' * (end - q)
        self.dead_bytes += end - q

    def text(self, title=''):
        out = [f'@ {title}  ({len(self.d)} bytes, {len(self.entries)} scripts)'] if title else []
        names = {}
        for k, a in enumerate(self.entries):
            names.setdefault(a, f'script_{k + 1}')
        for a, kind in self.labels.items():
            names.setdefault(a, f'{"Mov" if kind == "mov" else "L"}_{a:04X}')
        for k, a in enumerate(self.entries):
            out.append(f'    ScriptEntry {names[a]}')
        out.append('    ScriptEntryEnd')
        addrs = sorted(set(self.insns) | set(self.movement) | {a for a, b in self.unreached})
        prev_end, prev_dead = None, False
        for a in addrs:
            dead = a in self.dead
            if dead and not (prev_dead and prev_end == a):
                out += ['', '@ unreferenced (no flow reaches it; decoded linearly):']
            if a in self.movement:
                out += ['', '    .balign 4' if a % 4 == 0 else '    @ (not 4-aligned)', f'{names.get(a, f"Mov_{a:04X}")}:']
                for cmd, n in self.movement[a]:
                    out.append('    EndMovement' if cmd == 0xFE else f'    Move 0x{cmd:02X}, {n}')
                prev_end, prev_dead = None, dead
                continue
            if a in self.insns:
                if a in names:
                    out += ['', f'{names[a]}:'] if prev_end is not None or not dead else [f'{names[a]}:']
                elif prev_end != a:
                    out += ['', f'L_{a:04X}:']
                end, op, args = self.insns[a]
                e = self.t[op]
                parts = []
                for ty, v in args:
                    if ty in ('rel', 'mov'):
                        parts.append(names.get(v, f'0x{v:X}'))
                    elif ty == 'var' and v >= 0x4000:
                        parts.append(f'VAR_0x{v:04X}')
                    else:
                        parts.append(str(v) if v < 10 else f'0x{v:X}')
                out.append(f'    {e["name"]} {", ".join(parts)}'.rstrip().ljust(48) + f' @ {a:04X}')
                prev_end, prev_dead = (None if e['flow'] in ('end', 'jump', 'return') else end), dead
                continue
            b = next(e for s, e in self.unreached if s == a)
            out += ['', f'@ UNEXPLAINED {a:04X}-{b:04X}: {self.d[a:b].hex()}']
            prev_end, prev_dead = None, False
        for pr in self.problems:
            out.append(f'@ PROBLEM {pr}')
        return '\n'.join(out) + '\n'


def level_script(data):
    """(text, problems, unexplained byte count) for a level-script file."""
    out, probs, owner = [], [], bytearray(len(data))
    p = 0
    tables = []
    while True:
        if p >= len(data):
            probs.append('no terminator'); break
        t = data[p]
        if t == 0:
            owner[p] = 1; p += 1
            out.append('    InitScriptEntryEnd')
            break
        if p + 5 > len(data):
            probs.append(f'{p:04X}: entry runs past the end'); break
        v, = struct.unpack_from('<i', data, p + 1)
        owner[p:p + 5] = b'\1' * 5
        if t == 1:
            tables.append(p + 5 + v)
            out.append(f'    InitScriptEntry_OnFrameTable Table_{p + 5 + v:04X}')
        else:
            kind = {2: 'OnTransition', 3: 'OnResume', 4: 'OnLoad'}.get(t, f'Type{t}')
            out.append(f'    InitScriptEntry_{kind} {v & 0xFFFF}' + (f'  @ high half {v >> 16:#x}' if v >> 16 else ''))
        p += 5
    for a in tables:
        out.append(f'Table_{a:04X}:')
        q = a
        if not 0 <= a < len(data):
            probs.append(f'frame table outside the file ({a:X})')
            continue
        while q + 2 <= len(data):
            var, = struct.unpack_from('<H', data, q)
            if var == 0:
                owner[q:q + 2] = b'\1\1'; q += 2
                out.append('    InitScriptFrameTableEnd'); break
            if q + 6 > len(data):
                probs.append(f'{q:04X}: table runs past the end'); break
            var, val, sid = struct.unpack_from('<HHH', data, q)
            owner[q:q + 6] = b'\1' * 6
            out.append(f'    InitScriptGoToIfEqual VAR_0x{var:04X}, {val}, {sid}')
            q += 6
    bad, last = 0, max([i for i in range(len(data)) if owner[i]], default=-1)
    if last + 1 < len(data) and not any(data[last + 1:]):
        out.append(f'    @ {len(data) - last - 1} zero bytes of padding to the file end')
        owner[last + 1:] = b'\1' * (len(data) - last - 1)
    for i in range(len(data)):
        if not owner[i]:
            bad += 1
    if bad:
        probs.append(f'{bad} bytes not explained: ' + ' '.join(f'{i:04X}' for i in range(len(data)) if not owner[i]))
    return '\n'.join(out + [f'@ PROBLEM {x}' for x in probs]) + '\n', probs, bad


def main(argv):
    if argv[:1] == ['--table']:
        t = load_table(True)
        from collections import Counter
        print(Counter(e['source'] for e in t), Counter(e['flow'] for e in t))
        return 0
    rom_path = argv[0] if argv else os.path.join(ROOT, 'roms', 'pearl.nds')
    out_dir = argv[1] if len(argv) > 1 else os.path.join(ROOT, 'work', 'pearl', 'scripts')
    table = load_table()
    files = narc_members(Rom(rom_path).read('fielddata/script/scr_seq_release.narc'))
    zones_path = os.path.join(os.path.dirname(out_dir), 'zones.json')
    if not os.path.exists(zones_path):
        zones_path = os.path.join(ROOT, 'work', 'pearl', 'zones.json')
    zones = json.load(open(zones_path))
    level = {z['level_scripts'] for z in zones}
    scripts = {z['scripts'] for z in zones}
    users = {}
    for z in zones:
        users.setdefault(z['scripts'], []).append(z['name'])
        users.setdefault(z['level_scripts'], []).append(z['name'] + ' (level)')
    os.makedirs(out_dir, exist_ok=True)
    ok = unreached_bytes = n_level = n_empty = dead_bytes = dead_files = 0
    unknown = set()
    bad_files = []
    for i, data in enumerate(files):
        title = f'file {i}: ' + (', '.join(users.get(i, [])[:4]) or 'no zone') + (' ...' if len(users.get(i, [])) > 4 else '')
        if not data:
            text, probs, bad = f'@ {title}  (empty file)\n', [], 0
            n_empty += 1
        elif i in level or (i not in scripts and not level_script(data)[1]):
            text, probs, bad = level_script(data)
            kind = 'level scripts' if i in level else 'level scripts, no zone: detected by format'
            text = f'@ {title}  ({len(data)} bytes, {kind})\n' + text
            unreached_bytes += bad
            n_level += 1
        else:
            d = Disasm(data, table)
            text, probs = d.text(title), d.problems
            bad = sum(b - a for a, b in d.unreached)
            unreached_bytes += bad
            dead_bytes += d.dead_bytes
            dead_files += bool(d.dead_bytes)
            unknown |= d.unknown_ops
        with open(os.path.join(out_dir, f'{i:04d}.txt'), 'w') as f:
            f.write(text)
        if probs or bad:
            bad_files.append(i)
        else:
            ok += 1
    print(f'{len(files)} files ({len(files) - n_level - n_empty} script, {n_level} level-script, {n_empty} empty): '
          f'{ok} fully decoded, '
          f'{unreached_bytes} bytes unexplained, unknown opcodes hit: '
          f'{" ".join(f"{o:#x}" for o in sorted(unknown)) or "none"}')
    print(f'unreferenced but decoding cleanly (dead code / movement, shown in the text): {dead_bytes} bytes '
          f'in {dead_files} files')
    if bad_files:
        print('files with problems:', ' '.join(map(str, bad_files[:60])), '...' if len(bad_files) > 60 else '')
    print('wrote', out_dir)
    return 0 if not bad_files else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
