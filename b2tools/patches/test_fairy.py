"""TEST ONLY (never in a release build): a party and wild Pokémon for checking the Fairy type in game (notes/FAIRY.md).
Wraps the other test patches instead of changing them: list it INSTEAD of test_story_start (story builds) or
test_wildmon (non-story builds), with their own variables (TEST_START, TEST_LEVEL, TEST_ITEMS), plus:

    TEST_PARTY=SPECIES_GIBLE:10,SPECIES_CLEFAIRY:10   the party instead of the Lv TEST_LEVEL Piplup (default as shown:
                                                      Gible's Dragon Rage (Lv 7) against a Fairy shows the immunity)
    TEST_WILD=ZONE:SPECIES_CLEFAIRY                   every grass slot of that Black 2 zone's 4 wild tables becomes
                                                      that species (levels kept)

    TEST_START=... build_rom.py --clean ... sinnoh_story ... fairy fairy_ui test_fairy
"""
import importlib.util, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import narcio, zoneheaders  # noqa: E402
import scripts  # noqa: E402

TABLE_SIZE, GRASS = 0xE8, 12


def species_ids():
    p = os.path.join(os.path.dirname(os.path.dirname(HERE)), 'external', 'pokebw2', 'generated', 'species.txt')
    out, n = {}, None
    for line in open(p):
        m = re.match(r'\s*(SPECIES_\w+)(?:\s*=\s*(\S+))?\s*(?:#.*)?$', line)
        if not m: continue
        n = int(m.group(2), 0) if m.group(2) else (n + 1 if n is not None else None)
        if n is not None: out[m.group(1)] = n
    return out


def apply(files):
    party = [p.split(':') for p in os.environ.get('TEST_PARTY', 'SPECIES_GIBLE:10,SPECIES_CLEFAIRY:10').split(',')]
    give = ''.join(f'    PokePartyAdd 0x8001, {sp}, 0, {lvl}\n' for sp, lvl in party)
    real = scripts.assemble

    def assemble(path):                      # the other test patch's source: its Piplup line -> the party
        src = open(path).read()
        src, n = re.subn(r'^\s*PokePartyAdd 0x8001, SPECIES_PIPLUP, 0, \d+\n', give, src, flags=re.M)
        assert n == 1, 'the test patch\'s PokePartyAdd line not found once'
        open(path, 'w').write(src)
        return real(path)
    scripts.assemble = assemble
    story = os.environ.get('TEST_STORY', '1') != '0'
    name = 'test_story_start' if story else 'test_wildmon'
    spec = importlib.util.spec_from_file_location(name, os.path.join(HERE, f'{name}.py'))
    mod = importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
    try:
        out = [mod.apply(files)]
    finally:
        scripts.assemble = real
    out.append('party ' + ', '.join(f'{sp} Lv {lvl}' for sp, lvl in party))
    wild = os.environ.get('TEST_WILD')
    if wild:
        zone, sp = wild.split(':')
        sid = species_ids()[sp]
        headers, _ = zoneheaders.load(files)
        tid = headers[int(zone)]['encounters']
        assert tid != 0x1FFF, f'zone {zone} has no wild table'
        enc = narcio.load(files, 127)
        d = bytearray(enc[tid])
        for t in range(len(d) // TABLE_SIZE):
            for s in range(GRASS):
                o = t * TABLE_SIZE + 8 + 4 * s
                struct.pack_into('<H', d, o, sid)
        enc[tid] = bytes(d)
        narcio.save(files, 127, enc)
        out.append(f'zone {zone} (file {tid}): grass = {sp} ({sid})')
    return 'test_fairy: ' + '; '.join(out)
