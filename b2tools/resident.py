"""PearlB2's resident section (the decomp's include/pearlb2/resident.h, overlay 371, read once at boot): the place for
the build's data that the C reads through a pointer, instead of ITCM (32 KB, nearly full).

    install(code, build_fn)   build_fn(base) -> (blob, symbols): the blob goes into the section's pool
                              (PEARLB2_RESIDENT_POOL .. _END, in code/arm9_ov371.bin), at base; returns (base, end,
                              symbols), as itcm.install. A decomp without the section: itcm.install
    write(code, addr, data)   bytes at a linked address, in whichever code binary holds it (ITCM, ARM9, the resident
                              section or the Pokétch's system); read(code, addr, size) the same way
The pool's next free address is kept in code/resident_pool.json (a quick non-clean build appends, like ITCM's).
"""
import json, os, re

RESIDENT = 371
ITCM_BASE, ITCM_END, ARM9 = 0x01FF8000, 0x02000000, 0x02004000


def _pool(code):
    import decomp
    lo, hi = decomp.symbol('PEARLB2_RESIDENT_POOL', code), decomp.symbol('PEARLB2_RESIDENT_POOL_END', code)
    base = decomp.symbol(f'OV{RESIDENT}_TEXT_START', code)
    path = os.path.join(code, f'arm9_ov{RESIDENT:03d}.bin')
    if lo is None or not os.path.exists(path):
        return None
    return lo, hi, base, path


def _binary(code, addr, size):
    """(path, offset) of the code binary that holds addr .. addr+size."""
    if ITCM_BASE <= addr and addr + size <= ITCM_END:
        return os.path.join(code, 'itcm.bin'), addr - ITCM_BASE
    import decomp
    for n in (RESIDENT, 344):
        start = decomp.symbol(f'OV{n}_TEXT_START', code)
        bss = decomp.symbol(f'OV{n}_BSS_START', code)
        if start is not None and start <= addr and addr + size <= bss:
            return os.path.join(code, f'arm9_ov{n:03d}.bin'), addr - start
    path = os.path.join(code, 'arm9.bin')
    assert ARM9 <= addr and addr + size <= ARM9 + os.path.getsize(path), \
        f'{addr:#x}: in no code binary this knows (ITCM, ARM9, overlays {RESIDENT} and 344)'
    return path, addr - ARM9


def read(code, addr, size):
    path, at = _binary(code, addr, size)
    return open(path, 'rb').read()[at:at + size]


def write(code, addr, data):
    path, at = _binary(code, addr, len(data))
    d = bytearray(open(path, 'rb').read())
    assert at + len(data) <= len(d), f'{path}: {at + len(data)} past its {len(d)} B'
    d[at:at + len(data)] = data
    if os.path.islink(path):
        os.unlink(path)
    open(path + '.tmp', 'wb').write(d)
    os.replace(path + '.tmp', path)


def install(code, build_fn):
    pool = _pool(code)
    if pool is None:
        import itcm
        return itcm.install(code, build_fn)
    lo, hi, base, path = pool
    state = os.path.join(code, 'resident_pool.json')
    at = json.load(open(state))['next'] if os.path.exists(state) else lo
    blob, sym = build_fn(at)
    end = (at + len(blob) + 3) & ~3
    assert end <= hi, f'the resident pool is full: {end - lo} B of {hi - lo} (tools/pearlb2/link_overlays.py POOL_SIZE)'
    write(code, at, blob)
    json.dump({'next': end}, open(state, 'w'))
    return at, end, sym
