"""PearlB2's own overlays (the decomp's tools/pearlb2/link_overlays.py: 371 the resident section, 344 the Pokétch's
system, 345-370 its apps, 372 Pal Park's migration screen), linked after overlay 290 but not in dsd's config: build_rom puts them into the ROM's
overlay table right after it copies the decomp's code binaries, before any patch, so they are in every build of a
decomp that has them (the resident section is read at boot and its code is called from Black 2's).

    install(code) -> message      their entries in code/arm9_overlays.yaml (unsigned, uncompressed, file id = id);
                                  their bytes are the build's arm9_ovNNN.bin, already in the code dir
"""
import os, re, struct

FIRST, RESIDENT, LAST = 344, 371, 372


def _elf_symbols(path):
    d = open(path, 'rb').read()
    assert d[:4] == b'\x7fELF' and d[4] == 1 and d[5] == 1, f'{path}: not a 32-bit little-endian ELF'
    shoff, = struct.unpack_from('<I', d, 0x20)
    shentsize, shnum = struct.unpack_from('<HH', d, 0x2E)
    secs = [struct.unpack_from('<10I', d, shoff + i * shentsize) for i in range(shnum)]
    syms = {}
    for name, typ, flags, addr, off, size, link, info, align, entsize in secs:
        if typ != 2:                                # SHT_SYMTAB
            continue
        stroff = secs[link][4]
        for k in range(size // 16):
            nm, value = struct.unpack_from('<II', d, off + 16 * k)
            if nm:
                e = d.index(b'\0', stroff + nm)
                syms[d[stroff + nm:e].decode()] = value
    return syms


def pearlb2_on():
    import decomp
    text = open(decomp.SWITCH).read()
    return bool(re.search(r'^#define PEARLB2 1$', text, re.M))


def modules():
    """[(id, base, code size, bss size, ctor start, ctor end)] of our overlays in the decomp's link, [] without them."""
    import decomp
    syms = _elf_symbols(os.path.join(decomp.BUILD, 'arm9.o'))
    if f'OV{RESIDENT}_TEXT_START' not in syms:
        return []
    out = []
    for n in range(FIRST, LAST + 1):
        if f'OV{n}_TEXT_START' not in syms:      # (a decomp before Pal Park's overlay 372)
            continue
        start, bss, end = syms[f'OV{n}_TEXT_START'], syms[f'OV{n}_BSS_START'], syms[f'OV{n}_BSS_END']
        out.append((n, start, bss - start, end - bss, syms[f'OV{n}_CTOR_START'], syms[f'OV{n}_CTOR_END']))
    return out


def install(code):
    if not pearlb2_on():
        return 'PearlB2 overlays: the decomp is vanilla (PEARLB2 0), none'
    mods = modules()
    if not mods:
        return 'PearlB2 overlays: this decomp has none'
    yml = os.path.join(code, 'arm9_overlays.yaml')
    text = open(yml).read()
    assert f'id: {FIRST}\n' not in text, f'{yml}: overlay {FIRST} is there already'
    last = max(int(m) for m in re.findall(r'^  - id: (\d+)$', text, re.M))
    assert last == FIRST - 1, f'{yml}: the last overlay is {last}, not {FIRST - 1}'
    entries = []
    for n, base, size, bss, ctor_start, ctor_end in mods:
        path = os.path.join(code, f'arm9_ov{n:03d}.bin')
        assert os.path.getsize(path) == size, f'{path}: {os.path.getsize(path)} B, the link says {size}'
        entries.append(f'  - id: {n}\n    base_address: {base}\n    code_size: {size}\n    bss_size: {bss}\n'
                       f'    ctor_start: {ctor_start}\n    ctor_end: {ctor_end}\n    file_id: {n}\n'
                       f'    compressed: false\n    signed: false\n    file_name: {path}\n')
    if os.path.islink(yml):
        os.unlink(yml)
    open(yml, 'w').write(text.rstrip('\n') + '\n' + ''.join(entries))
    res = next(m for m in mods if m[0] == RESIDENT)
    pp = [m for m in mods if m[0] == LAST]
    return (f'PearlB2 overlays {FIRST}-{mods[-1][0]}: the resident section {res[2] + res[3]} B at {res[1]:#x}, the '
            f'Pokétch {FIRST}-{RESIDENT - 1}' + (f', Pal Park\'s screen {pp[0][2] + pp[0][3]} B at {pp[0][1]:#x}'
                                                  if pp else ''))
