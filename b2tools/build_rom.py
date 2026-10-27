"""Build a modified Black 2 ROM from the decomp's matching build plus our patches.

    python3 build_rom.py [--clean] [--no-pad] [patch ...]

1. Builds the decomp's code with our C changes (decomp.py: ninja, branch pearlb2, layout check), then clones (APFS
   copy-on-write) external/pokebw2/build/b2_us/files -> work/rom/files  (only with --clean or first run)
2. Runs each named patch: patches/<name>.py defines apply(files_dir) (NitroFS files) and/or apply_code(code_dir)
   (decompressed arm9.bin / arm9_ovNNN.bin, a clone of the decomp's build dir; dsd recompresses them)
3. Writes work/rom/rom_config.yaml (the decomp's config with absolute paths and our files_dir)
4. Runs `dsd rom build` -> work/rom/pearl.nds

Only decomp.py's ninja writes into the decomp checkout (its build/); its extracted files are never modified. With no
patches, the output matches the original dump's SHA1 (checked) when the decomp's C changes are off (decomp.py vanilla).
"""
import os, sys, subprocess, shutil, hashlib, importlib.util, re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import version  # noqa: E402  (PEARL_VERSION=pearl|diamond: every patch asks b2tools/version.py)
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
SRC_BUILD = os.path.join(DECOMP, 'build', 'b2_us', 'build')
SRC_FILES = os.path.join(DECOMP, 'build', 'b2_us', 'files')
OUT = version.build_dir(os.path.join(ROOT, 'work', 'rom'))   # PEARL_BUILD_DIR (parallel/test builds), else work/rom
                                                             # (Pearl) or work/rom_diamond (never the Pearl ROM)
# dsd that writes the ROM. pokebw2's current dsd (v0.12.1-dsi.4) refuses any arm9 change: the ARM9 secure area (first
# 0x4000 bytes) holds the compressed-size field, and recomputing its DSi digests needs the ARM7 BIOS. v0.12.1-dsi.1
# (HoennB2's, in tools/, git-ignored) keeps the original digests, as every HoennB2 release did (runs on DS flashcarts,
# 3DS, melonDS). PEARL_DSD overrides it.
DSD = os.environ.get('PEARL_DSD') or next((p for p in (os.path.join(ROOT, 'tools', 'dsd-v0.12.1-dsi.1'),
                                                       os.path.join(DECOMP, 'tools', 'dsd')) if os.path.exists(p)))
ORIGINAL_SHA1 = 'e51e6dfb8678a3d19dcd2a10691b96a569ca0abb'
# HoennB2's lessons (notes/HOENN_LESSONS.md): with a full disk dsd writes a 0-byte ROM without an error (16); Black 2's
# map chunk buffer is 110,600 B with no length check, a bigger chunk hangs the game (9); reserves fill up (11).
MIN_FREE = float(os.environ.get('PEARL_MIN_FREE_GB', '2')) * (1 << 30)
# Stuck-build watchdog (2026-10-20: an agent's build sat 2 h 23 min in one step, having loaded a file another agent was
# editing). Each step prints when it starts and how long it took; a step past PEARL_STEP_LIMIT_MIN minutes (default
# 30) or a whole build past PEARL_BUILD_LIMIT_MIN (default 120; the lock wait not counted) prints STUCK and exits 4.
STEP_LIMIT = float(os.environ.get('PEARL_STEP_LIMIT_MIN', '30')) * 60
BUILD_LIMIT = float(os.environ.get('PEARL_BUILD_LIMIT_MIN', '120')) * 60
_STEP = {'name': 'start', 't': None, 't0': None}


def _watchdog():
    import time
    while True:
        time.sleep(10)
        now, name, t, t0 = time.time(), _STEP['name'], _STEP['t'], _STEP['t0']
        if t is None: continue
        if now - t > STEP_LIMIT or now - t0 > BUILD_LIMIT:
            print(f'STUCK: step "{name}" has run {(now - t) / 60:.1f} min (build {(now - t0) / 60:.1f} min; limits '
                  f'{STEP_LIMIT / 60:g} / {BUILD_LIMIT / 60:g} min, PEARL_STEP_LIMIT_MIN / PEARL_BUILD_LIMIT_MIN): '
                  f'stopping. Look for a loop in that step, or a file another agent was editing when the build started.',
                  flush=True)
            os._exit(4)


def step(name):
    """Start a build step: print it (with the previous step's time) and reset the watchdog's step clock."""
    import time
    now = time.time()
    if _STEP['t0'] is None:
        import threading
        _STEP['t0'] = now
        threading.Thread(target=_watchdog, daemon=True).start()
    elif _STEP['t'] is not None:
        print(f'  ({_STEP["name"]}: {now - _STEP["t"]:.0f} s)', flush=True)
    _STEP.update(name=name, t=now)
    print(f'[{(now - _STEP["t0"]) / 60:5.1f} min] {name}', flush=True)
CHUNK_LIMIT = 110600

# Archives we edit get a fixed size (original + reserve), padded inside the NARC, so every build has the same ROM
# file table. The game keeps that table in RAM, so savestates only survive across builds with identical layout.
# Raising a reserve changes the layout: rebuild the base savestates (make_states.py) afterwards.
# The sizes below are HoennB2's (its comments name Hoenn content); Pearl's are set as its content is measured.
RESERVE = {
    2: 1 << 20,       # a/0/0/2 system text (place names; 2026-10-25: 100 % of 512 KB after Chapter 4b)
    3: 4 << 20,       # a/0/0/3 script text (story chapters; 2026-10-25: 1 MB overflowed at Chapter 4b, 204 zones;
                      #  each zone repeats the common scripts' lines; the ROM uses 361 of 512 MiB)
    8: 32 << 20,      # a/0/0/8 map chunks (terrain ~8.1 MB + rooms + caves + standalone maps + event islands; v14: +8 MB for post-game maps)
    9: 512 << 10,     # a/0/0/9 matrices (Pearl: +204 room matrices)
    14: 8 << 20,      # a/0/1/4 map textures (Pearl: 13 x 4 seasonal + 43 room sets)
    56: 1 << 20,      # a/0/5/6 scripts (story chapters; v12)
    126: 512 << 10,   # a/1/2/6 zone entities (Pearl: 441 zones)
    127: 256 << 10,   # a/1/2/7 wild encounters (Pearl: 183 tables)
    174: 4 << 20,     # a/1/7/4 building textures (exterior)
    175: 4 << 20,     # a/1/7/5 building textures (interior; Pearl: 30+ room packs)
    225: 8 << 20,     # a/2/2/5 building packs (exterior)
    226: 8 << 20,     # a/2/2/6 building packs (interior; Pearl's furniture)
    10: 64 << 10,     # a/0/1/0 map replacements
    12: 16 << 10,     # a/0/1/2 zone headers (room for nothing new; keeps edits safe)
    47: 64 << 10,     # a/0/4/7 overworld sprite table
    48: 2 << 20,      # a/0/4/8 overworld sprite sheets (Brendan, May, Birch, ...)
    71: 1 << 20,      # a/0/7/1 trainer sprites, front
    72: 1 << 20,      # a/0/7/2 trainer sprites, back
    92: 32 << 10,     # a/0/9/2 trainer parties (Sapphire's movesets written out; story_infra)
    89: 16 << 10,     # a/0/8/9 (story_infra)
    15: 16 << 10,     # a/0/1/5 edge (outline) tables (Pearl: indoor + outdoor outlines)
    60: 16 << 10,     # a/0/6/0 light tables (Pearl: indoor light)
    109: 64 << 10,    # a/1/0/9 camera boundaries (Pearl: one per room and cave)
}

def pad_archives(files, fresh=True):
    import struct
    from b2files import arc_path
    used = []
    for arc, reserve in RESERVE.items():
        orig = os.path.getsize(arc_path(os.path.join(SRC_FILES), arc))
        target = (orig + reserve + 0x1FF) & ~0x1FF
        path = arc_path(files, arc)
        data = bytearray(open(path, 'rb').read())
        used.append(((len(data) - orig) / reserve, arc))
        if len(data) > target:
            raise SystemExit(f'a/{arc:03d} is {len(data)} bytes, over its fixed size {target}: raise RESERVE[{arc}] '
                             f'and rebuild the base savestates')
        # grow the NARC's GMIF (last section) and header size, so the padding is part of a valid archive
        hdr_size = struct.unpack_from('<H', data, 0xC)[0]
        off = hdr_size
        for _ in range(2):  # BTAF, BTNF
            off += struct.unpack_from('<I', data, off + 4)[0]
        assert data[off:off+4] == b'GMIF'
        extra = target - len(data)
        struct.pack_into('<I', data, off + 4, struct.unpack_from('<I', data, off + 4)[0] + extra)
        struct.pack_into('<I', data, 8, target)
        data += bytes(extra)
        if os.path.islink(path): os.unlink(path)
        open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    if fresh:                                       # (archives padded by an earlier run already read as full)
        print('reserves, fullest first:', ', '.join(f'a/{a:03d} {u:.0%}' for u, a in sorted(used, reverse=True)[:4]))

def check_chunks(files):
    import narcio
    big = [(len(c), i) for i, c in enumerate(narcio.load(files, 8)) if len(c) > CHUNK_LIMIT]
    if big:
        raise SystemExit(f'map chunks over Black 2\'s {CHUNK_LIMIT} B buffer (the game would hang): {sorted(big, reverse=True)[:5]}')

def sha1(path):
    h = hashlib.sha1()
    with open(path, 'rb') as f:
        for chunk in iter(lambda: f.read(1 << 20), b''): h.update(chunk)
    return h.hexdigest()

def write_config():
    """The decomp's ROM config with absolute paths: NitroFS from our files/ tree, code binaries (arm9, overlays,
    autoloads) from our code/ copy of the decomp's build dir, everything else (header, DSi parts) from the decomp."""
    src = open(os.path.join(SRC_BUILD, 'rom_config.yaml')).read()
    code = os.path.join(OUT, 'code')
    def absolutise(m):
        key, val = m.group(1), m.group(2).strip()
        if key == 'files_dir':
            return f'{key}: {os.path.join(OUT, "files")}'
        if val in ('null', 'false', 'true') or val == '' or re.fullmatch(r'-?(0x[0-9a-fA-F]+|\d+)', val):
            return m.group(0)
        path = os.path.normpath(os.path.join(SRC_BUILD, val))
        if os.path.dirname(path) == os.path.normpath(SRC_BUILD):   # a code file of the build dir -> our copy
            path = os.path.join(code, os.path.basename(path))
        return f'{key}: {path}'
    cfg = re.sub(r'^(\s*(?:- )?\w+): (\S.*)$', absolutise, src, flags=re.M)
    path = os.path.join(OUT, 'rom_config.yaml')
    open(path, 'w').write(cfg)
    return path

def main(args):
    clean = '--clean' in args
    pad = '--no-pad' not in args
    patches = [a for a in args if not a.startswith('--')]
    if clean or not os.path.isdir(os.path.join(OUT, 'files')):
        # at most TWO full builds at a time (2026-10-20: three at once with the Mac's swap full took 1.5 h each; after the
        # restart of 2026-10-25 memory is healthy and one-at-a-time queued agents for 45 min). Two slots: the main tree's
        # work/.full_build.lock and .full_build.lock2 (found through the lock's real path, so agent trees share them;
        # an older tree's build_rom takes slot 1 only). Quick non-clean builds take no slot.
        import fcntl, time
        global _BUILD_LOCK
        first = os.path.realpath(os.path.join(ROOT, 'work', '.full_build.lock'))
        # (2026-10-25 evening: a third slot while HoennB2 is paused; 8 cores, swap 0: older trees use slots 1-2)
        slots = [first] + [os.path.join(os.path.dirname(first), f'.full_build.lock{n}') for n in (2, 3)]
        waited = False
        while True:
            for path in slots:
                f = open(path, 'a')
                try:
                    fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
                    _BUILD_LOCK = f
                    break
                except BlockingIOError:
                    f.close()
            else:
                if not waited:
                    print('waiting for a full-build slot (work/.full_build.lock, .full_build.lock2, .full_build.lock3) ...',
                          flush=True)
                    waited = True
                time.sleep(5)
                continue
            break
    sys.stdout.reconfigure(line_buffering=True)        # progress shows in a redirected log as it happens
    step('copy Black 2 files' if clean else 'start')
    free = shutil.disk_usage(os.path.dirname(OUT)).free
    if free < MIN_FREE:
        sys.exit(f'only {free / (1 << 30):.1f} GB free (need {MIN_FREE / (1 << 30):.0f}; PEARL_MIN_FREE_GB): empty the Trash first')
    files = os.path.join(OUT, 'files')
    if clean or not os.path.isdir(files):
        shutil.rmtree(files, ignore_errors=True)
        shutil.rmtree(os.path.join(OUT, 'code'), ignore_errors=True)
        os.makedirs(OUT, exist_ok=True)
        import decomp                                  # our C changes: the decomp's ninja first (decomp.py)

        def copy():
            subprocess.run(['cp', '-c', '-R', '-L', SRC_FILES, files], check=True)
            # code binaries (arm9.bin, arm9_ovNNN.bin, ...): patches with apply_code(code_dir) edit this copy
            subprocess.run(['cp', '-c', '-R', '-L', SRC_BUILD, os.path.join(OUT, 'code')], check=True)
            decomp.copy_map(os.path.join(OUT, 'code'))             # its link map, for decomp.symbol(name, code)
        print(decomp.build(after=copy))
        print(decomp.dsd_compat(os.path.join(OUT, 'code')))       # the decomp's dsd fills fields ours keeps
        import pearlb2_overlays                                  # PearlB2's own overlays (the resident section,
        print(pearlb2_overlays.install(os.path.join(OUT, 'code')))  # the Pokétch) into the overlay table
    for name in patches:
        step(f'patch {name}')
        spec = importlib.util.spec_from_file_location(name, os.path.join(HERE, 'patches', f'{name}.py'))
        mod = importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
        if hasattr(mod, 'apply'):
            print(f'patch {name}:', mod.apply(files) or 'ok')
        if hasattr(mod, 'apply_code'):
            print(f'patch {name} (code):', mod.apply_code(os.path.join(OUT, 'code')) or 'ok')
    step('check chunks, pad archives')
    check_chunks(files)
    if pad:
        sys.path.insert(0, HERE)
        pad_archives(files, fresh=clean)
    step('write the ROM')
    cfg = write_config()
    rom = os.path.join(OUT, 'pearl.nds')
    r = subprocess.run([DSD, 'rom', 'build', '--config', cfg, '--rom', rom],
                       capture_output=True, text=True)
    if r.returncode:
        sys.exit(r.stdout[-2000:] + r.stderr[-4000:])
    size = os.path.getsize(rom) if os.path.exists(rom) else 0
    if size < (64 << 20):
        sys.exit(f'{rom} is {size} bytes: the ROM was not written (disk full?)')
    step('done')
    digest = sha1(rom)
    print(rom, digest)
    if not patches and clean and not pad:
        print('matches original' if digest == ORIGINAL_SHA1 else 'DOES NOT MATCH ORIGINAL')
    return rom

if __name__ == '__main__':
    main(sys.argv[1:])
