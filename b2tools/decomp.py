"""The Black 2 decomp (external/pokebw2, branch pearlb2) as PearlB2's code base: our C changes build into the code
binaries that build_rom.py starts from (notes/DECOMP_WORKFLOW.md).

    python3 decomp.py build        ninja the code binaries and the file system (incremental), then the layout check
    python3 decomp.py check        the layout check alone: every module of the game its original size and every
                                   symbol at its original address (our new code: only after Black 2's ITCM code)
    python3 decomp.py changed      which functions' bytes differ from the dump's (what our C changes touch)
    python3 decomp.py vanilla      every PEARLB2 change off (include/pearlb2.h): the code must be the dump's again,
                                   then back on (--rom: also the decomp's own ninja check of the ROM's SHA-1)

build_rom.py calls build() before it copies the code binaries (a no-op ninja: a few seconds) and dsd_compat() on its
copy. symbol(name) is the linked address of anything the decomp links, for patches that fill in our C code's data.

Why the layout check: our binary patches (patches/*.py) edit the code at fixed addresses and assert the bytes they
replace. Black 2's overlays are chained in memory (each placed AFTER others), so a C change that makes a function a
byte longer or shorter moves everything after it, in its module and in every overlay after that one, and those patches
would stop applying. So a change in place keeps its function's size; new code goes to src/pearlb2/*_itcm.c, linked
after Black 2's own ITCM code (the decomp's configure.py and tools/pearlb2/link_itcm.py).
"""
import bisect, fcntl, os, re, shutil, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
VERSION = 'b2_us'
BUILD = os.path.join(DECOMP, 'build', VERSION)
CODE = os.path.join(BUILD, 'build')                      # arm9.bin, arm9_ovNNN.bin, itcm.bin, *.yaml, rom_config.yaml
ORIGINAL = os.path.join(DECOMP, 'extract', VERSION)      # the dump's modules (decompressed), as dsd extracted them
CONFIG = os.path.join(DECOMP, 'config', VERSION, 'arm9')
XMAP = os.path.join(BUILD, 'arm9.o.xMAP')
SWITCH = os.path.join(DECOMP, 'include', 'pearlb2.h')    # #define PEARLB2 1
ARM9, ITCM = 0x02004000, 0x01FF8000
LLVM = '/opt/homebrew/opt/llvm/bin'
NINJA = shutil.which('ninja') or os.path.expanduser('~/Library/Python/3.13/bin/ninja')
TARGET = f'{VERSION}_pearlb2'                            # the decomp's code binaries and files tree, no ROM


# ---- modules -----------------------------------------------------------------------------------------------------------
def modules():
    """[(name, built .bin, original .bin, symbols.txt, base address)] of every code module."""
    out = []
    fixed = [('arm9', 'arm9.bin', 'arm9/arm9.bin', ''), ('itcm', 'itcm.bin', 'arm9/itcm.bin', 'itcm'),
             ('dtcm', 'dtcm.bin', 'arm9/dtcm.bin', 'dtcm'),
             ('autoload_2', 'autoload_2.bin', 'arm9/unk_autoload_2.bin', 'autoload_2'),
             ('autoload_3', 'autoload_3.bin', 'arm9/unk_autoload_3.bin', 'autoload_3'),
             ('ltd_autoload_0', 'ltd_autoload_0.bin', 'dsi/ltd_autoload_0.bin', 'ltd_autoload_0')]
    for name, built, orig, sym in fixed:
        yml = os.path.join(CODE, built.replace('.bin', '.yaml'))
        base = int(re.search(r'^base_address: (\d+)$', open(yml).read(), re.M).group(1))
        out.append((name, os.path.join(CODE, built), os.path.join(ORIGINAL, orig),
                    os.path.join(CONFIG, sym, 'symbols.txt'), base))
    ovl = open(os.path.join(CODE, 'arm9_overlays.yaml')).read()
    for m in re.finditer(r'- id: (\d+)\n\s+base_address: (\d+)', ovl):
        n, base = int(m.group(1)), int(m.group(2))
        out.append((f'ov{n:03d}', os.path.join(CODE, f'arm9_ov{n:03d}.bin'),
                    os.path.join(ORIGINAL, 'arm9_overlays', f'ov{n:03d}.bin'),
                    os.path.join(CONFIG, 'overlays', f'ov{n:03d}', 'symbols.txt'), base))
    return out


def _symbols_list(path):
    """[(name, address, size or None, kind)] of a decomp symbols.txt (a name can be there twice: two files' statics)."""
    out = []
    for line in open(path):
        m = re.match(r'(\S+) kind:(\w+)(?:\((\w+)(?:,size=(0x[0-9a-f]+))?[^)]*\))? addr:(0x[0-9a-f]+)', line)
        if m:
            out.append((m.group(1), int(m.group(5), 16), int(m.group(4), 16) if m.group(4) else None, m.group(2)))
    return out


def _symbols_txt(path):
    """{name: (address, size or None, kind)} of a decomp symbols.txt."""
    return {n: (a, s, k) for n, a, s, k in _symbols_list(path)}


def _xmap(path=XMAP):
    """{name: {address, ...}} of a link (arm9.o.xMAP's memory map: every module, overlays share addresses)."""
    out = {}
    for line in open(path, errors='replace'):
        m = re.match(r'  ([0-9A-F]{8}) [0-9A-F]{8} \.\w+\s+(.+?)\t\(', line) or \
            re.match(r'#>([0-9A-F]{8})\s+(\S+) \(linker command file\)', line)
        if m:
            out.setdefault(m.group(2), set()).add(int(m.group(1), 16))
            if '::' in m.group(2):                   # a C++ function's static, by its own name as symbols.txt has it
                out.setdefault(m.group(2).rsplit('::', 1)[1], set()).add(int(m.group(1), 16))
    return out


def symbol(name, code=None):
    """The linked address of a function or data symbol (Thumb functions without the bit): of the link whose binaries
    build_rom copied into `code` (it copies the link map with them), else of the decomp's last build."""
    path = os.path.join(code, 'arm9.o.xMAP') if code and os.path.exists(os.path.join(code, 'arm9.o.xMAP')) else XMAP
    if not os.path.exists(path):
        return None
    addrs = _xmap(path).get(name)
    if not addrs:
        return None
    assert len(addrs) == 1, f'{name}: {len(addrs)} addresses in the link'
    return next(iter(addrs))


# ---- dsd compatibility -------------------------------------------------------------------------------------------------
def _dsd_windows():
    sym = _symbols_txt(os.path.join(CONFIG, 'symbols.txt'))
    return [(sym['OverlayTableDigests'][0], sym['SDK_OVERLAY_DIGEST_END'][0]),
            (sym['LtdModuleParams'][0] + 0xC, sym['LtdModuleParams'][0] + 0x10)]


def copy_map(code):
    """Keep the link map with build_rom's copy of the code binaries, for symbol(name, code)."""
    if os.path.exists(XMAP):
        subprocess.run(['cp', '-c', XMAP, os.path.join(code, 'arm9.o.xMAP')], check=True)


def dsd_compat(code):
    """Make the decomp's code binaries what build_rom's dsd (v0.12.1-dsi.1, see build_rom.py DSD) expects.

    Since dsd v0.12.1-dsi.5/-dsi.9 the decomp links the overlay digests (OverlayTableDigests .. SDK_OVERLAY_DIGEST_END)
    and LtdModuleParams' LTD compressed end as zeros and lets `dsd rom build` fill them (arm9.yaml overlay_signatures,
    arm9_overlays.yaml table_signed). Our dsd keeps what arm9.bin holds, so this puts back the dump's bytes there and the
    old yaml values: the code binaries are then byte for byte those of the earlier decomp, and our ROM the same as
    before. (Our patched overlays keep Black 2's digests, as they always did: the game checks them only when it isn't
    booted from the cartridge.) Nothing to do with a decomp older than that."""
    yml = os.path.join(code, 'arm9.yaml')
    text = open(yml).read()
    m = re.search(r'^overlay_signatures: (\d+)$', text, re.M)
    if not m or m.group(1) == '0':
        return 'dsd compat: nothing to restore'
    path = os.path.join(code, 'arm9.bin')
    arm9 = bytearray(open(path, 'rb').read())
    orig = open(os.path.join(ORIGINAL, 'arm9', 'arm9.bin'), 'rb').read()
    restored = 0
    for start, end in _dsd_windows():
        a, b = start - ARM9, end - ARM9
        assert not any(arm9[a:b]) or arm9[a:b] == orig[a:b], \
            f'dsd compat: {start:#x}-{end:#x} is neither zeros (to be filled by dsd) nor the original'
        restored += sum(1 for x, y in zip(arm9[a:b], orig[a:b]) if x != y)
        arm9[a:b] = orig[a:b]
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(arm9); os.replace(path + '.tmp', path)
    open(yml, 'w').write(re.sub(r'^overlay_signatures: \d+$', 'overlay_signatures: 0', text, flags=re.M))
    oyml = os.path.join(code, 'arm9_overlays.yaml')
    otext = open(oyml).read()
    if os.path.islink(oyml): os.unlink(oyml)
    open(oyml, 'w').write(re.sub(r'^table_signed: true$', 'table_signed: false', otext, flags=re.M))
    return f'dsd compat: {restored} bytes of overlay digests and LTD params from the dump, signatures off'


# ---- build ---------------------------------------------------------------------------------------------------------------
class _Lock:
    """One ninja at a time in the decomp tree (every build_rom.py of every agent tree that shares it calls build())."""
    def __enter__(self):
        os.makedirs(os.path.join(DECOMP, 'build'), exist_ok=True)
        self.f = open(os.path.join(DECOMP, 'build', '.pearlb2_ninja.lock'), 'w')
        fcntl.flock(self.f, fcntl.LOCK_EX)
        return self

    def __exit__(self, *exc):
        fcntl.flock(self.f, fcntl.LOCK_UN); self.f.close()


def _ninja(*targets):
    """Run the decomp's ninja; its generator rule reruns configure.py, which wants Homebrew's clang first on PATH."""
    env = dict(os.environ, PATH=f'{LLVM}:{os.environ.get("PATH", "")}')
    t = time.time()
    r = subprocess.run([NINJA, '-C', DECOMP, *targets], capture_output=True, text=True, env=env)
    lines = [l for l in r.stdout.splitlines() if l.strip()]
    if r.returncode:
        raise SystemExit(f'decomp: ninja {" ".join(targets)} failed:\n' + '\n'.join(lines[-40:]) + r.stderr[-2000:])
    work = [l for l in lines if l.startswith('[')]
    return f'{len(work)} steps in {time.time() - t:.0f} s' if work else f'up to date ({time.time() - t:.0f} s)'


def build(after=None):
    """Bring the decomp's code binaries and files tree up to date, check the layout, then run after() (build_rom's
    copies) while still holding the lock, so no other tree's ninja changes them in between. Returns a summary line."""
    if not os.path.exists(SWITCH):
        if after: after()
        return 'decomp: no pearlb2 branch (include/pearlb2.h): its build as it is'
    with _Lock():
        done = _ninja(TARGET)
        problems, summary = check()
        if problems:
            raise SystemExit('decomp: the C changes move the game\'s code (our binary patches need it in place):\n  '
                             + '\n  '.join(problems[:30]))
        if after: after()
    return f'decomp {_head()}: ninja {done}; {summary}'


def _head():
    r = subprocess.run(['git', '-C', DECOMP, 'rev-parse', '--abbrev-ref', 'HEAD'], capture_output=True, text=True)
    s = subprocess.run(['git', '-C', DECOMP, 'rev-parse', '--short', 'HEAD'], capture_output=True, text=True)
    return f'{r.stdout.strip()} {s.stdout.strip()}'


def check():
    """(problems, summary): each module of the build against the dump's. Every module keeps its size (ITCM may grow:
    our code after the game's) and every symbol of the decomp's symbols.txt that the link has stays at its address."""
    problems, moved, checked = [], 0, 0
    linked = _xmap()
    itcm_extra = 0
    for name, built, orig, symtxt, base in modules():
        b, o = os.path.getsize(built), os.path.getsize(orig)
        if name == 'itcm':
            itcm_extra = b - o
            if b < o:
                problems.append(f'itcm: {b} bytes, smaller than the original {o}')
        elif b != o:
            problems.append(f'{name}: {b} bytes (the original {o})')
        if not os.path.exists(symtxt):
            continue
        for sym, addr, _, kind in _symbols_list(symtxt):
            addrs = linked.get(sym)
            if not addrs:
                continue
            checked += 1
            if addr not in addrs:
                moved += 1
                if moved <= 20:
                    problems.append(f'{name}: {sym} at {", ".join(hex(a) for a in sorted(addrs))} (was {addr:#x})')
    if moved > 20:
        problems.append(f'... {moved} symbols moved in all')
    return problems, f'layout kept ({checked} symbols checked; ITCM +{itcm_extra} B of our code)'


def changed():
    """[(module, function, differing bytes)]: the functions whose bytes differ from the dump's."""
    out = []
    skip = _dsd_windows()
    for name, built, orig, symtxt, base in modules():
        b, o = open(built, 'rb').read(), open(orig, 'rb').read()
        diff = [i for i in range(min(len(b), len(o))) if b[i] != o[i]
                and not (name == 'arm9' and any(s <= base + i < e for s, e in skip))]
        if not diff:
            continue
        funcs = sorted((a, n, s) for n, a, s, k in _symbols_list(symtxt)) if os.path.exists(symtxt) else []
        starts = [a for a, _, _ in funcs]
        hits = {}
        for i in diff:
            j = bisect.bisect_right(starts, base + i) - 1
            if j < 0:
                owner = f'{base + i:#x}'
            elif i >= len(o) or (funcs[j][2] and base + i >= funcs[j][0] + funcs[j][2]):
                owner = f'(after {funcs[j][1]}: padding or our code)'
            else:
                owner = funcs[j][1]
            hits[owner] = hits.get(owner, 0) + 1
        out += [(name, f, n) for f, n in hits.items()]
    return out


def vanilla(rom=False):
    """Build the decomp with PEARLB2 0: every code module must then be the dump's (changed() empty, ITCM its size),
    which proves each change of ours is inside #if PEARLB2 and the rest is the game's; rom=True also runs the decomp's
    own `ninja check` (the whole ROM's SHA-1; writes its 512 MB ROM). Then PEARLB2 1 again and the code rebuilt."""
    text = open(SWITCH).read()
    assert re.search(r'^#define PEARLB2 1$', text, re.M), f'{SWITCH}: no "#define PEARLB2 1"'
    with _Lock():
        try:
            open(SWITCH, 'w').write(text.replace('#define PEARLB2 1', '#define PEARLB2 0'))
            done = _ninja('check' if rom else TARGET)
            diff = changed()
            itcm = next(m for m in modules() if m[0] == 'itcm')
            extra = os.path.getsize(itcm[1]) - os.path.getsize(itcm[2])
        finally:
            open(SWITCH, 'w').write(text)
        _ninja(TARGET)
    if diff or extra:
        raise SystemExit(f'decomp vanilla: with PEARLB2 0 the code still differs from the dump: ITCM +{extra} B, '
                         + ', '.join(f'{m} {f} ({n} B)' for m, f, n in diff[:20]))
    return (f'PEARLB2 0: every code module is the dump\'s' + (' and the ROM\'s SHA-1 the original\'s' if rom else '')
            + f' (ninja {done}); PEARLB2 1 again, rebuilt')


if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else ''
    if cmd == 'build':
        print(build())
    elif cmd == 'check':
        problems, summary = check()
        print('\n'.join(problems) if problems else summary)
        sys.exit(1 if problems else 0)
    elif cmd == 'changed':
        for module, func, n in changed():
            print(f'{module:15} {func:50} {n} bytes')
    elif cmd == 'vanilla':
        print(vanilla(rom='--rom' in sys.argv))
    else:
        sys.exit(__doc__)
