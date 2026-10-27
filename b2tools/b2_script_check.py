"""Check an assembled Black 2 field-script file offline (no ROM, no emulator).

    python3 b2_script_check.py FILE.bin [--level SCRIPT:LEVEL ...]

- Decodes every script entry with Black 2's command table (pokebw2 tools/script/field_commands.json: the arguments of
  each command, from its handler) following jumps and calls: every opcode must exist and every jump/call target must
  be inside the file (an error otherwise).
- --level S:L: script S runs at feature level L (a zone's map scripts: zone init = 2, field load/return = 1; ov012
  script_sys.c FieldScript_CallZoneInitCore; every other script at level 0). Every command reachable from a script
  must be allowed at its level by
  EVCMD_PERM_TABLE (ov012 script_sys.c; a forbidden command hangs the game: FieldScript_ThrowOpcodeAccessError,
  HoennB2 notes/STORY_COMMON.md "Map-script permissions").
Used by b2tools/patches/sinnoh_story.py for every zone it installs, and importable: check(data, levels).
"""
import json, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
DECOMP = os.path.join(HERE, '..', 'external', 'pokebw2')
SIZES = {'u8': 1, 'u16': 2, 'any': 2, 'var': 2, 'u32': 4}
JUMPS = {30: 'jump', 31: 'cjump', 4: 'call', 32: 'ccall'}     # VMJump, VMJumpIf, VMCall, VMCallIf: u32 relative
# PearlB2's extension command (notes/EXT_COMMAND.md): command 0x15F, a sub-command byte, then the sub-command's own
# arguments (bytes after the sub-command byte; each module adds its rows)
EXT_CMD = 0x15F
EXT_ARGS = {
    0x00: 0, 0x01: 2, 0x02: 2, 0x03: 4, 0x04: 0, 0x05: 0,   # the Pokétch (src/pearlb2/poketch_itcm.c)
    0x40: 3, 0x41: 2, 0x42: 2, 0x43: 2, 0x44: 0, 0x45: 4,   # Pal Park (src/pearlb2/resident/palpark.c)
}
_CMDS = _PERM = None


def commands():
    global _CMDS
    if _CMDS is None:
        _CMDS = {int(k): v for k, v in json.load(open(os.path.join(DECOMP, 'tools', 'script',
                                                                   'field_commands.json')))['commands'].items()}
    return _CMDS


def permissions():
    """[(level0, level1, level2)] per command, from EVCMD_PERM_TABLE."""
    global _PERM
    if _PERM is None:
        src = open(os.path.join(DECOMP, 'src', 'ov012', 'script_sys.c')).read()
        body = src[src.index('EVCMD_PERM_TABLE[] = {'):]
        body = body[:body.index('};')]
        # PearlB2's entries (#if PEARLB2 ... #else <Black 2's> #endif): the PearlB2 side, as the build compiles it
        body = re.sub(r'#else\b.*?#endif', '', body, flags=re.S)
        body = re.sub(r'#(?:if|endif)\b[^\n]*', '', body)
        _PERM = [tuple(map(int, m)) for m in re.findall(r'\{ (\d), (\d), (\d) \}', body)]
    return _PERM


def entries(data):
    out, p = [], 0
    while struct.unpack_from('<H', data, p)[0] != 0xFD13:
        off, = struct.unpack_from('<i', data, p)
        out.append(p + 4 + off)
        p += 4
    return out


def walk(data, start):
    """{address: opcode} reachable from start; raises ValueError on a bad opcode or target."""
    cmds, seen, todo = commands(), {}, [start]
    while todo:
        a = todo.pop()
        while a not in seen:
            if not 0 <= a < len(data) - 1:
                raise ValueError(f'code at {a:#x} outside the file')
            op, = struct.unpack_from('<H', data, a)
            c = cmds.get(op)
            if c is None:
                raise ValueError(f'unknown opcode {op} at {a:#x}')
            seen[a] = op
            p = a + 2
            for ty in c['args']:
                p += SIZES[ty]
            if op == EXT_CMD:
                sub = data[p]
                if sub not in EXT_ARGS:
                    raise ValueError(f'unknown PearlB2 extension sub-command {sub:#x} at {a:#x}')
                p += 1 + EXT_ARGS[sub]
            if op in JUMPS:
                off, = struct.unpack_from('<i', data, p - 4)
                t = p + off
                if not 0 <= t < len(data):
                    raise ValueError(f'{c["handler"]} at {a:#x} jumps outside the file ({t:#x})')
                todo.append(t)
                if JUMPS[op] == 'jump':
                    break
            if set(c.get('flow', [])) & {'end', 'return'}:
                break
            a = p
    return seen


MSG_ARGS = {52: [0], 53: [0], 60: [1], 61: [1], 67: [0], 72: [1, 2], 175: [0]}   # SystemMsg(Async), ActorMsg,
# ParentActorMsg, MsgPlaceSign, ActorMsgGendered, ListMenuAdd: which arguments are a line of the script's text file


def message_lines(data):
    """{line number} of the script's own text file that the reachable code shows (constant ids only; ActorMsg with a
    file other than the script's own, MSGFILE_SCRIPT 0x400, is skipped)."""
    cmds, out = commands(), set()
    for start in entries(data):
        for a, op in walk(data, start).items():
            if op not in MSG_ARGS:
                continue
            p, vals = a + 2, []
            for ty in cmds[op]['args']:
                n = SIZES[ty]
                vals.append(int.from_bytes(data[p:p + n], 'little'))
                p += n
            if op in (60, 61, 72) and vals[0] != 0x400:
                continue
            out |= {vals[i] for i in MSG_ARGS[op] if vals[i] < 0x4000}
    return out


def check(data, levels=None):
    """List of problems (empty = fine). levels: {1-based script number: feature level}."""
    problems, perm, cmds = [], permissions(), commands()
    ents = entries(data)
    for k, start in enumerate(ents, 1):
        try:
            seen = walk(data, start)
        except ValueError as e:
            problems.append(f'script {k}: {e}')
            continue
        lv = (levels or {}).get(k, 0)              # a script started by a person, sign, trigger or warp: level 0
        if True:
            bad = sorted({cmds[op]['handler'] for op in seen.values() if op < len(perm) and not perm[op][lv]})
            if bad:
                problems.append(f'script {k} runs at level {lv} but uses {", ".join(bad)} (not allowed there: hangs)')
    return problems


def main(argv):
    data = open(argv[0], 'rb').read()
    levels = {}
    for a in argv[1:]:
        if a != '--level':
            s, l = a.split(':')
            levels[int(s)] = int(l)
    probs = check(data, levels)
    print('\n'.join(probs) or f'{argv[0]}: {len(entries(data))} scripts decode cleanly')
    return 1 if probs else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
