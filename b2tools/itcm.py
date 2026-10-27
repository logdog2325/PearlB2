"""New code for Black 2: compile C, link it at a fixed address, put it in ITCM (HoennB2's method: hoenn_world.py /
roamers.py / fairy.py, generalised; the ELF linker is roamers.py's).

    blob_and_symbols = build(c_path, base, workdir, defines=(), includes=())   # clang -> ELF -> bytes linked at base
    install(code_dir, build_fn)   # build_fn(base) -> (blob, symbols); appends to ITCM, moves the ITCM arena start
    long_jump(addr, target)       # bytes to put at a function start: jump to target (r3 used; keeps lr)

ITCM: the autoload `itcm.bin` (code/itcm.yaml: base 0x01FF8000, no bss) fills only the start of the 32 KB ITCM; the
rest is the SDK's ITCM arena, whose start is the literal at arm9 0x0207B400. Each install appends after what is
there and moves that literal past it (patches run in order; each asserts the literal equals the current end). Being
an autoload, ITCM is copied at boot: savestates made before need a cold boot. The C may not reference symbols:
Black 2 functions are called by address (function pointers to literals).
"""
import os, re, struct, subprocess, tempfile

LLVM = '/opt/homebrew/opt/llvm/bin'
ITCM_BASE, ITCM_END, ARENA_ITCM_LIT, ARM9 = 0x01FF8000, 0x02000000, 0x0207B400, 0x02004000
CFLAGS = ['--target=thumbv5te-none-eabi', '-mthumb', '-march=armv5te', '-Os', '-ffreestanding', '-fno-builtin',
          '-fno-jump-tables', '-fno-pic', '-fno-unwind-tables', '-fno-asynchronous-unwind-tables', '-fno-exceptions',
          '-fno-common', '-mno-unaligned-access', '-Wall', '-Werror']


def long_jump(addr, target):
    """At a function start: ldr r3, [pc, #0]; bx r3; .word target|1 (r3 is free at a function's entry when it has
    at most 3 arguments). A start that is not 4-aligned gets a nop first (10 bytes then)."""
    if addr % 4 == 0:
        return struct.pack('<HHI', 0x4B00, 0x4718, target | 1)
    return struct.pack('<HHHI', 0x46C0, 0x4B00, 0x4718, target | 1)


def bl(src, dst):
    off = dst - (src + 4)
    assert -(1 << 22) <= off < (1 << 22) and not off & 1, hex(off)
    return struct.pack('<HH', 0xF000 | (off >> 12) & 0x7FF, 0xF800 | (off >> 1) & 0x7FF)


    d = open(path, 'rb').read()
    assert d[:4] == b'\x7fELF' and d[4] == 1 and d[5] == 1
    shoff, = struct.unpack_from('<I', d, 0x20)
    shentsize, shnum, shstrndx = struct.unpack_from('<HHH', d, 0x2E)
    secs = []
    for i in range(shnum):
        name, typ, flags, addr, off, size, link, info, align, entsize = struct.unpack_from('<10I', d, shoff + i * shentsize)
        secs.append(dict(name=name, type=typ, flags=flags, off=off, size=size, link=link, info=info, align=align, entsize=entsize))
    strtab = secs[shstrndx]
    for s in secs:
        e = d.index(b'\0', strtab['off'] + s['name']); s['name'] = d[strtab['off'] + s['name']:e].decode()
    return d, secs

# ---- a minimal ELF32 (ARM, REL) linker (HoennB2 roamers.py): .text/.rodata at base; ABS32 / THM_CALL / THM_JUMP11
def _elf(path):
    d = open(path, 'rb').read()
    assert d[:4] == b'\x7fELF' and d[4] == 1 and d[5] == 1
    shoff, = struct.unpack_from('<I', d, 0x20)
    shentsize, shnum, shstrndx = struct.unpack_from('<HHH', d, 0x2E)
    secs = []
    for i in range(shnum):
        name, typ, flags, addr, off, size, link, info, align, entsize = struct.unpack_from('<10I', d, shoff + i * shentsize)
        secs.append(dict(name=name, type=typ, flags=flags, off=off, size=size, link=link, info=info, align=align, entsize=entsize))
    strtab = secs[shstrndx]
    for s in secs:
        e = d.index(b'\0', strtab['off'] + s['name']); s['name'] = d[strtab['off'] + s['name']:e].decode()
    return d, secs


def link(obj, base):
    d, secs = _elf(obj)
    place, blob = {}, bytearray()
    for i, s in enumerate(secs):
        if s['flags'] & 2 and s['size'] and not s['name'].startswith('.ARM.'):   # SHF_ALLOC (not the unwind index)
            assert s['type'] == 1, f"section {s['name']}: only PROGBITS (no .bss/.data)"
            assert not s['flags'] & 1, f"section {s['name']} is writable: the code keeps no RAM of its own"
            while len(blob) % max(s['align'], 1): blob += b'\0'
            place[i] = base + len(blob)
            blob += d[s['off']:s['off'] + s['size']]
    symtab = next(s for s in secs if s['type'] == 2)
    strs = secs[symtab['link']]
    syms, names = [], {}
    for i in range(symtab['size'] // 16):
        nm, val, size, info, other, shndx = struct.unpack_from('<IIIBBH', d, symtab['off'] + 16 * i)
        name = d[strs['off'] + nm:d.index(b'\0', strs['off'] + nm)].decode()
        syms.append((name, val, shndx))
        if name and shndx in place: names[name] = place[shndx] + val
    for s in secs:
        if s['type'] != 9 or s['info'] not in place: continue     # SHT_REL for an allocated section
        tbase = place[s['info']]
        for i in range(s['size'] // 8):
            off, info = struct.unpack_from('<II', d, s['off'] + 8 * i)
            sym, typ = info >> 8, info & 0xFF
            name, val, shndx = syms[sym]
            assert shndx in place, f'undefined symbol {name!r}: everything outside the blob is called by address'
            S = place[shndx] + val
            at = tbase - base + off
            P = tbase + off
            if typ == 2:                                          # R_ARM_ABS32
                A, = struct.unpack_from('<I', blob, at)
                struct.pack_into('<I', blob, at, (S + A) & 0xFFFFFFFF)
            elif typ == 10:                                       # R_ARM_THM_CALL (bl): X = S + A - P, A in place (-4)
                h1, h2 = struct.unpack_from('<HH', blob, at)
                assert h2 & 0xF800 == 0xF800, 'blx to a Thumb symbol'
                A = (h1 & 0x7FF) << 12 | (h2 & 0x7FF) << 1
                if A & (1 << 22): A -= 1 << 23
                X = (S & ~1) + A - P
                assert -(1 << 22) <= X < (1 << 22)
                struct.pack_into('<HH', blob, at, 0xF000 | (X >> 12) & 0x7FF, 0xF800 | (X >> 1) & 0x7FF)
            elif typ == 102:                                      # R_ARM_THM_JUMP11 (b)
                h, = struct.unpack_from('<H', blob, at)
                A = (h & 0x7FF) << 1
                if A & 0x800: A -= 0x1000
                o = (S & ~1) + A - P
                assert -2048 <= o < 2048 and not o & 1
                struct.pack_into('<H', blob, at, 0xE000 | (o >> 1) & 0x7FF)
            else:
                raise SystemExit(f"itcm: relocation type {typ} not handled")
    return bytes(blob), names


def build(c_path, base, workdir, defines=(), includes=()):
    """Compile c_path (thumb, -Os) and link it at base: (blob, {symbol: address})."""
    obj = os.path.join(workdir, os.path.basename(c_path) + '.o')
    subprocess.run([f'{LLVM}/clang', *CFLAGS, *defines, *[a for i in includes for a in ('-I', i)], '-c', c_path,
                    '-o', obj], check=True)
    und = subprocess.run([f'{LLVM}/llvm-nm', '--undefined-only', obj], capture_output=True, text=True,
                         check=True).stdout.split()
    assert not und, f'{c_path} needs {und}: call Black 2 functions by address only'
    return link(obj, base)


def _load(code, name):
    p = os.path.join(code, name)
    return p, bytearray(open(p, 'rb').read())


def _save(p, d):
    if os.path.islink(p): os.unlink(p)
    open(p + '.tmp', 'wb').write(d); os.replace(p + '.tmp', p)


def install(code, build_fn):
    """Append build_fn(base)'s blob to ITCM in the code dir (arm9.bin, itcm.bin, itcm.yaml): returns
    (base, end, symbols)."""
    yml = os.path.join(code, 'itcm.yaml')
    text = open(yml).read()
    size = int(re.search(r'^code_size: (\d+)$', text, re.M).group(1))
    assert re.search(r'^base_address: (\d+)$', text, re.M).group(1) == str(ITCM_BASE)
    assert re.search(r'^bss_size: 0$', text, re.M), 'ITCM autoload has a bss'
    base = ITCM_BASE + size
    p9, arm9 = _load(code, 'arm9.bin')
    lit = ARENA_ITCM_LIT - ARM9
    assert struct.unpack_from('<I', arm9, lit)[0] == base, \
        f'ITCM arena literal {struct.unpack_from("<I", arm9, lit)[0]:#x} != code end {base:#x}'
    blob, sym = build_fn(base)
    end = (base + len(blob) + 31) & ~31
    assert end <= ITCM_END, f'ITCM full: {end:#x}'
    struct.pack_into('<I', arm9, lit, end); _save(p9, arm9)
    pi, itcm = _load(code, 'itcm.bin')
    assert len(itcm) == size
    _save(pi, bytes(itcm) + blob + bytes(end - base - len(blob)))
    open(yml, 'w').write(re.sub(r'^code_size: \d+$', f'code_size: {end - ITCM_BASE}', text, flags=re.M))
    return base, end, sym
