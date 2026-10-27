"""Assemble src/field_scripts/NNNN_*.s with pokebw2's field-script macros (clang, as pokebw2's own build does) and put
each one into the script archive a/0/5/6 as entry NNNN (Black 2 has 1289 entries; ours start at 1289).

Defines passed to every script:
  BLACK2, and the zones' fly points written by patches/sinnoh_world.py (work/world/fly.json) as
  FLY_<b2 zone>_X / _Y / _Z (tiles; Y in 16-unit steps), so a script can warp to a zone's start tile.
(From HoennB2's patches/scripts.py, without Hoenn's test switches and version overlays.)
"""
import glob, json, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio  # noqa: E402

SRC = os.path.join(ROOT, 'src', 'field_scripts')
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
LLVM = '/opt/homebrew/opt/llvm/bin'
FLY = os.path.join(ROOT, 'work', 'world', 'fly.json')


def defines():
    out = ['-D', 'BLACK2']
    if os.path.exists(FLY):
        for z, (x, y, zz) in json.load(open(FLY)).items():
            out += ['-D', f'FLY_{z}_X={x}', '-D', f'FLY_{z}_Y={y}', '-D', f'FLY_{z}_Z={zz}']
    for name, sid in json.loads(os.environ.get('PEARL_MUSIC_EVENTS', '{}')).items():   # set by sinnoh_music
        out += ['-D', f'SEQ_PEARL_{name[4:]}={sid}']
    return out


def assemble(src):
    """Assemble one field-script source with pokebw2's macros; returns the binary."""
    with tempfile.TemporaryDirectory() as t:
        o, b = os.path.join(t, 'x.o'), os.path.join(t, 'x.bin')
        subprocess.run([f'{LLVM}/clang', '--target=armv5te-none-eabi', '-x', 'assembler-with-cpp', '-c', *defines(),
                        '-I', f'{DECOMP}/include', '-I', f'{DECOMP}/build/include/generated',
                        '-I', f'{DECOMP}/lib/nitro/include', '-I', os.path.join(ROOT, 'src', 'include'),
                        '-I', SRC, '-o', o, os.path.abspath(src)], check=True, cwd=DECOMP)
        # an unknown name would silently assemble as 0: refuse it
        undef = subprocess.run([f'{LLVM}/llvm-nm', '--undefined-only', o], capture_output=True, text=True,
                               check=True).stdout.split()
        undef = [w for w in undef if w != 'U']
        if undef:
            raise SystemExit(f'{src}: undefined names {undef}')
        subprocess.run([f'{LLVM}/llvm-objcopy', '-O', 'binary', o, b], check=True)
        return open(b, 'rb').read()


def check_local_works():
    """Black 2 gives a script the local works 0x8000-0x8061 only; a work at 0x8062+ overwrites the script engine's own
    memory, which crashed HoennB2 at the Hall of Fame on melonDS/hardware (DeSmuME hid it; HoennB2 d519dac). So no
    script source or include may name one."""
    import re
    bad = []
    for path in glob.glob(os.path.join(SRC, '*.s')) + glob.glob(os.path.join(ROOT, 'src', 'include', '*')):
        for n, line in enumerate(open(path, errors='replace'), 1):
            code = line.split('//')[0]
            for m in re.finditer(r'0x80([0-9A-Fa-f]{2})\b|PVAR_80([0-9A-F]{2})\b', code):
                if int(m.group(1) or m.group(2), 16) >= 0x62:
                    bad.append(f'{os.path.relpath(path, ROOT)}:{n}: {m.group(0)}')
    assert not bad, 'script works past 0x8061 (crash at the Hall of Fame):\n  ' + '\n  '.join(bad[:20])


def apply(files):
    check_local_works()
    entries = narcio.load(files, 56)
    done = []
    for src in sorted(glob.glob(os.path.join(SRC, '*.s'))):
        num = int(os.path.basename(src)[:4])
        while len(entries) <= num:
            entries.append(b'')
        entries[num] = assemble(src)
        done.append(f'{num} ({len(entries[num])} B)')
    narcio.save(files, 56, entries)
    return 'scripts ' + ', '.join(done)
