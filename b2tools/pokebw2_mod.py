"""Edit Black 2's data through pokebw2's own JSON sources and packers, without touching external/pokebw2.

    tree = make_tree('name')            # work/pokebw2_mod/<name>_<tree>: an APFS clone (cp -c) of pokebw2's res/, tools/, include/,
                                        # generated/ (costs almost no disk), fresh on every call
    ... edit tree/res/items/<item>/data.json and the like ...
    data = pack_data(tree, 'items')     # {archive path: bytes} from tools/data/item_data.py (configure.py's data_pack)
    data = pack_text(tree, 'system')    # a/0/0/2 (system) or a/0/0/3 (script) from tools/text/text_data.py

    python3 pokebw2_mod.py check        # packs the unchanged sources and compares with Black 2's files (must match)

The packers resolve their paths from their own location, so running the clone's copy reads the clone's res/.
"""
import os, shutil, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
DECOMP = os.path.join(ROOT, 'external', 'pokebw2')
VANILLA_FILES = os.path.join(DECOMP, 'build', 'b2_us', 'files')
GAME = 'black2'

# configure.py DATA_PACKS rows used here: name -> (script, source dir, archives)
PACKERS = {
    'items': ('tools/data/item_data.py', 'res/items', ['a/0/2/4']),
    'species': ('tools/data/species_data.py', 'res/pokemon',
                ['a/0/1/6', 'a/0/1/8', 'a/0/1/9', 'a/0/2/0', 'a/0/1/7', 'a/1/2/4']),
}
TEXT = {'system': ('res/text/system', 'a/0/0/2'), 'script': ('res/text/script', 'a/0/0/3')}


def make_tree(name):
    # One clone per working tree: work/pokebw2_mod is shared by every agent tree (agent_tree.py links it), and two builds
    # cloning 'names' at once removed each other's files (2026-10-25)
    tag = os.path.basename(ROOT) if os.path.basename(os.path.dirname(ROOT)) == 'wt' else 'main'
    tree = os.path.join(ROOT, 'work', 'pokebw2_mod', f'{name}_{tag}')
    if os.path.exists(tree):
        shutil.rmtree(tree)          # our own scratch clone (rebuilt every run), not user data
    os.makedirs(tree)
    for d in ('res', 'tools', 'generated', 'include'):
        subprocess.run(['cp', '-c', '-R', os.path.join(DECOMP, d), os.path.join(tree, d)], check=True)
    return tree


def _run(tree, args):
    r = subprocess.run([sys.executable, *args], cwd=tree, capture_output=True, text=True)
    if r.returncode:
        raise SystemExit(f'pokebw2_mod: {" ".join(args)} failed:\n{r.stdout[-2000:]}{r.stderr[-3000:]}')


def pack_data(tree, name):
    script, src, archives = PACKERS[name]
    with tempfile.TemporaryDirectory(dir=tree) as out:
        outs = [os.path.join(out, a.replace('/', '_')) for a in archives]
        _run(tree, [script, 'pack', src, *outs])   # (no game argument for these two packers)
        return {a: open(o, 'rb').read() for a, o in zip(archives, outs)}


def pack_text(tree, kind):
    src, archive = TEXT[kind]
    with tempfile.TemporaryDirectory(dir=tree) as out:
        o = os.path.join(out, 'text')
        _run(tree, ['tools/text/text_data.py', 'pack', src, o])
        return {archive: open(o, 'rb').read()}


def vanilla(archive):
    return open(os.path.join(VANILLA_FILES, *archive.split('/')), 'rb').read()


if __name__ == '__main__' and sys.argv[1:] == ['check']:
    tree = make_tree('check')
    results = {**pack_data(tree, 'items'), **pack_data(tree, 'species'), **pack_text(tree, 'system')}
    for a, d in results.items():
        print(a, 'matches Black 2' if d == vanilla(a) else 'DIFFERS')
    shutil.rmtree(tree)
