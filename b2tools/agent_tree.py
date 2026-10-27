"""Each agent works in its own copy of the code (2026-10-25). Agents sharing one working tree broke each other: a build
loaded a file another agent was half-way through editing and looped for 2 h 23 min; another failed on a function that
was mid-edit. So every agent gets a git worktree at the lead's HEAD with the data it needs linked or cloned, works and
builds only there, and the lead merges its changes.

    python3 b2tools/agent_tree.py new NAME        work/wt/NAME at HEAD (prints its path)
    python3 b2tools/agent_tree.py status NAME     what NAME changed (tracked and new files)
    python3 b2tools/agent_tree.py merge NAME      apply NAME's changes to the main tree (3-way), nothing committed
    python3 b2tools/agent_tree.py retire NAME     move the tree to the Trash and prune it from git
    python3 b2tools/agent_tree.py decomp NAME     NAME changes C: its own decomp tree (notes/DECOMP_WORKFLOW.md)

In a tree: roms, external, tools, art_sources are links to the main tree's (read-only data); work/{pearl, encounters,
texture_map, title, trainer_pics, world, maplook} are APFS clones (free until changed: builds rewrite work/world, so
each tree has its own); work/pokebw2_mod is a link; work/.full_build.lock is the main tree's, so full builds still
take turns. Build output goes to the main tree's work/agents/NAME/rom (PEARL_BUILD_DIR), shots to work/agents/NAME/.
"""
import os, shutil, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
WT = os.path.join(ROOT, 'work', 'wt')
LINKS = ('roms', 'external', 'tools', 'art_sources')
CLONES = ('pearl', 'encounters', 'texture_map', 'title', 'trainer_pics', 'world', 'maplook')
WORK_LINKS = ('pokebw2_mod', '.full_build.lock')


def git(*a, cwd=ROOT, **kw):
    return subprocess.run(['git', *a], cwd=cwd, check=True, text=True, capture_output=True, **kw).stdout


def new(name):
    path = os.path.join(WT, name)
    assert not os.path.exists(path), f'{path} exists'
    os.makedirs(WT, exist_ok=True)
    git('worktree', 'add', '--detach', path, 'HEAD')
    for d in LINKS:
        os.symlink(os.path.join(ROOT, d), os.path.join(path, d))
    os.makedirs(os.path.join(path, 'work'), exist_ok=True)
    for d in CLONES:
        src = os.path.join(ROOT, 'work', d)
        if os.path.isdir(src):
            subprocess.run(['cp', '-c', '-R', src, os.path.join(path, 'work', d)], check=True)
    open(os.path.join(ROOT, 'work', '.full_build.lock'), 'a').close()
    for d in WORK_LINKS:
        os.symlink(os.path.join(ROOT, 'work', d), os.path.join(path, 'work', d))
    os.makedirs(os.path.join(ROOT, 'work', 'agents', name), exist_ok=True)
    base = git('rev-parse', '--short', 'HEAD', cwd=path).strip()
    print(f'{path}  (base {base}; build with PEARL_BUILD_DIR={ROOT}/work/agents/{name}/rom)')


def _patch(name):
    path = os.path.join(WT, name)
    new_files = [f for f in git('ls-files', '--others', '--exclude-standard', cwd=path).split('\n')
                 if f and f.split('/')[0] not in LINKS]
    if new_files:
        git('add', '-N', '--', *new_files, cwd=path)          # intent-to-add: new files appear in the diff
    return path, git('diff', '--binary', 'HEAD', cwd=path)


def status(name):
    path, patch = _patch(name)
    print(git('diff', '--stat', 'HEAD', cwd=path) or 'no changes')


def merge(name):
    path, patch = _patch(name)
    if not patch.strip():
        print('no changes'); return
    out = os.path.join(ROOT, 'work', 'agents', name, f'{name}.patch')
    open(out, 'w').write(patch)
    r = subprocess.run(['git', 'apply', '--3way', '--whitespace=nowarn', out], cwd=ROOT, text=True,
                       capture_output=True)
    print(r.stdout + r.stderr or f'applied {out} (not committed: review, then commit the named files)')
    sys.exit(r.returncode)


def retire(name):
    path = os.path.join(WT, name)
    shutil.move(path, os.path.expanduser(f'~/.Trash/wt_{name}_{time.strftime("%H%M%S")}'))
    git('worktree', 'prune')
    own = os.path.join(ROOT, 'external', f'pokebw2_{name}')
    if os.path.isdir(own):                                   # its decomp tree (decomp NAME); the branch stays
        shutil.move(own, os.path.expanduser(f'~/.Trash/pokebw2_{name}_{time.strftime("%H%M%S")}'))
        git('worktree', 'prune', cwd=os.path.join(ROOT, 'external', 'pokebw2'))
    # its scratch clones (pokebw2_mod.make_tree: <kind>_NAME) and its build output: they keep old decomp files alive
    # on the disk (2026-10-26: 17 GB of retired trees' clones)
    mod = os.path.join(ROOT, 'work', 'pokebw2_mod')
    for d in sorted(os.listdir(mod)) if os.path.isdir(mod) else []:
        if d.endswith('_' + name):
            shutil.move(os.path.join(mod, d), os.path.expanduser(f'~/.Trash/pokebw2_mod_{d}_{time.strftime("%H%M%S")}'))
    rom = os.path.join(ROOT, 'work', 'agents', name, 'rom')
    if os.path.isdir(rom):
        shutil.move(rom, os.path.expanduser(f'~/.Trash/{name}_rom_{time.strftime("%H%M%S")}'))
    print(f'{name}: moved to the Trash, pruned')


def decomp(name):
    """Agent NAME changes the game's C: its own worktree of the decomp, external/pokebw2_NAME on branch pearlb2-NAME
    (from pearlb2), with the toolchain and the base ROM cloned (free), configured; work/wt/NAME/external becomes a
    folder whose pokebw2 is that tree (the rest: links to the main tree's). Other builds never see its half-made
    changes; the lead merges the branch into pearlb2. Its first ninja (printed) takes about 6 min and 0.7 GB."""
    main = os.path.join(ROOT, 'external', 'pokebw2')
    own = os.path.join(ROOT, 'external', f'pokebw2_{name}')
    tree = os.path.join(WT, name)
    assert os.path.isdir(tree), f'{tree}: make the tree first (agent_tree.py new {name})'
    assert not os.path.exists(own), f'{own} exists'
    git('worktree', 'add', '-b', f'pearlb2-{name}', own, 'pearlb2', cwd=main)
    tools = [os.path.join(main, 'tools', t) for t in ('mwccarm', 'wibo', 'sjiswrap.exe', 'dsd', 'dsd.rev')]
    subprocess.run(['cp', '-c', '-R', *tools, os.path.join(own, 'tools')], check=True)
    os.makedirs(os.path.join(own, 'orig'))
    subprocess.run(['cp', '-c', os.path.join(main, 'orig', 'baserom_b2_us.nds'), os.path.join(own, 'orig')], check=True)
    env = dict(os.environ, PATH=f'/opt/homebrew/opt/llvm/bin:{os.environ.get("PATH", "")}')
    subprocess.run([sys.executable, 'configure.py', '--no-download', 'b2_us'], cwd=own, env=env, check=True,
                   capture_output=True)
    ext = os.path.join(tree, 'external')
    assert os.path.islink(ext), f'{ext} is not the link agent_tree.py new made'
    shutil.move(ext, os.path.expanduser(f'~/.Trash/wt_{name}_external_link_{time.strftime("%H%M%S")}'))
    os.makedirs(ext)
    for d in sorted(os.listdir(os.path.join(ROOT, 'external'))):
        if d == 'pokebw2_latest' or not (d == 'pokebw2' or d.startswith('pokebw2_')):
            os.symlink(os.path.join(ROOT, 'external', d), os.path.join(ext, d))
    os.symlink(own, os.path.join(ext, 'pokebw2'))
    print(f'{own} (branch pearlb2-{name}); work/wt/{name}/external/pokebw2 -> it.\n'
          f'Now build it once, in the background (about 6 min, 0.7 GB): '
          f'PATH=/opt/homebrew/opt/llvm/bin:$PATH ninja -C {own} b2_us_pearlb2')


if __name__ == '__main__':
    cmd, name = sys.argv[1], sys.argv[2]
    {'new': new, 'status': status, 'merge': merge, 'retire': retire, 'decomp': decomp}[cmd](name)
