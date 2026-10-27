"""Sinnoh's overworld textures and map look (notes/MAP_LOOK.md). Runs after sinnoh_world (it rewrites the overworld
area groups' texture sets in a/0/1/4, then applies the map-look fixes of b2tools/maplook.py to the area records,
chunks, building packs and the zone fog table sinnoh_world wrote).

Default (decision 2026-10-19, MAPLOOK_FIXES unset; 'pearl_art'): spring and summer use Pearl's own texture sets as they
are; autumn and winter use Pearl's own art with each "seasonal" texture (data/texture_map.json: grass, trees, tall
grass, paths, lawns, flowers, ...) recoloured to Black 2's colours for that season: each Pearl colour takes the
Black 2 colour of the same kind at Pearl's relative brightness (recolour.transfer_recolour), so Pearl's shading, edges
and tree shadows stay. Non-seasonal textures (rock, water, towns) stay Pearl's all year. The snowy north (Pearl area
14) is winter all year: its seasonal textures take the "north" section's Black 2 winter colours in all four seasons.
No Black 2 texture is swapped in.

The older style (MAPLOOK_FIXES=none, the re-skin of 2026-10-18, kept for comparisons): each season's set is rebuilt
with Black 2's texture stored under Pearl's texture name, and its palette under the palette name Pearl's materials
ask for (from the models' material pairs); composites/atlases and "derive" edges keep Pearl's pixels with their
palette ramped to the Black 2 texture's colours by brightness rank (recolour.ramp_recolour). Kept as Pearl's art:
keep_pearl entries, flowers, and a Black 2 texture whose palette would clash with another texture's on the same Pearl
palette name (reported). No model is changed by the textures (Pearl's models bind textures and palettes BY NAME).
"""
import json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import narcio, nsbtx, recolour, maplook, b2_look  # noqa: E402
from gen4rom import Rom, narc_members  # noqa: E402

VANILLA = os.path.join(ROOT, 'external', 'pokebw2', 'build', 'b2_us', 'files')
NORTH_AREA = 14


def pearl_pairs(chunks):
    """Pearl texture -> palette name, from the overworld chunks' materials."""
    out = {}
    for c in chunks:
        bmd = open(os.path.join(ROOT, 'work', 'pearl', 'land', f'{c:03d}.nsbmd'), 'rb').read()
        for t, p in nsbtx.material_pairs(bmd):
            out.setdefault(t, p)
    return out


def b2_palette(parsed, tex):
    """The palette a Black 2 texture is drawn with: <tex>_pl, else <tex>, else (direct colour) None."""
    names = {p for p, _ in parsed['pals']}
    for cand in (tex + '_pl', tex):
        if cand in names: return cand
    fmt = (dict(parsed['texs'])[tex][0] >> 26) & 7
    return None if fmt == 7 else (sorted(names)[0] if names else None)


# Texture fixes (b2tools/maplook.py; notes/MAP_LOOK.md). 'pearl_art' (the default) implies the four others.
# 'c0': palette entry 0 is recoloured too where the texture draws it (opaque textures; it stayed Pearl's colour:
# bright Pearl-green lines along path, lawn and tall-grass edges, Pearl-blue specks on shores). 'refs': a composite's
# recolour takes the colours of all its listed Black 2 textures (trees: canopy, highlights and trunk), not just the
# first. 'transfer': recolour.transfer_recolour (Black 2's colour of the same kind, Pearl's shading) instead of the
# brightness ramp (which swapped sand and grass on path edges and flattened trees and tree shadows); flowers get
# the ground's grass colours around Pearl's petals. 'mismatch': a Black 2 texture bigger than Pearl's (either way) or
# see-through where Pearl's is opaque is not swapped in (Pearl's texture coordinates restart every polygon, so a bigger
# texture shows seams or is cropped; a see-through one leaves holes, Jubilife's plaza); Pearl's texture is recoloured
# with that Black 2 texture's colours instead.
MAPLOOK_FIXES = ('pearl_art', 'c0', 'refs', 'transfer', 'mismatch')
# Atlases whose plants follow the season but whose stone and metal must not (2026-10-20: Oreburgh's grey boulders and
# metal fences turned beige in autumn and winter, work/maplook/oreburgh_seasons.png): only their grass colours change,
# as the flowers' do. imped = fence, boulder, bush, pebbles.
GRASS_ONLY = {'imped'}
RECOLOUR_ALL_YEAR = (NORTH_AREA,)       # winter all year


def apply(files):
    chosen = maplook.fixes()
    sets, msg = reskin_sets(maplook.texture_fixes(chosen))
    write_sets(files, sets)
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    return msg + '; ' + maplook.apply_world_fixes(files, world, chosen)


def write_sets(files, new_sets):
    sets = narcio.load(files, 14)
    for i, data in new_sets.items():
        sets[i] = data
    narcio.save(files, 14, sets)


def _size(params):
    return 8 << ((params >> 20) & 7), 8 << ((params >> 23) & 7)


def _see_through(parsed, tex):
    """Texels of a texture the game draws see-through (alpha formats below full alpha, colour 0 where transparent)."""
    params = dict(parsed['texs'])[tex][0]
    fmt = (params >> 26) & 7
    raw, _ = nsbtx._tex_bytes(parsed, params)
    if fmt == 1: return sum(1 for b in raw if b >> 5 != 7)
    if fmt == 6: return sum(1 for b in raw if b >> 3 != 31)
    if fmt == 7: return sum(1 for k in range(0, len(raw), 2) if not raw[k + 1] & 0x80)
    if not (params >> 29) & 1 or fmt not in (2, 3, 4): return 0
    bits = {2: 2, 3: 4, 4: 8}[fmt]
    return sum(1 for b in raw for s in range(0, 8, bits) if not (b >> s) & ((1 << bits) - 1))


def reskin_sets(fixes=(), areas=None, chunks=None):
    """({a/0/1/4 index: BTX0 bytes} for every overworld area group and season, report). fixes: MAPLOOK_FIXES names.
    areas ({Pearl area: {'pearl_texset', 'b2_area_group'}}) and chunks (Pearl chunks whose materials name the
    palettes) default to the overworld's; patches/sinnoh_rooms.py passes its outdoor room areas (lakes, forest, ...)."""
    fixes = set(fixes)
    pearl_art = 'pearl_art' in fixes
    if pearl_art: fixes |= {'c0', 'refs', 'transfer', 'mismatch'}
    tmap = json.load(open(os.path.join(ROOT, 'data', 'texture_map.json')))
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    rom = Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))
    pearl_sets = narc_members(rom.read('fielddata/areadata/area_map_tex/map_tex_set.narc'))
    b2_sets = narcio.load(VANILLA, 14)
    parsed = {}
    def b2(i):
        if i not in parsed: parsed[i] = nsbtx._parse(b2_sets[i])
        return parsed[i]
    pairs = pearl_pairs(int(c) for c in (world['chunks'] if chunks is None else chunks))
    if areas is None: areas = world['areas']
    sets = {}
    used = kept = recoloured = edged = 0
    clashes = set()
    for pa, a in areas.items():
        section = tmap['north'] if int(pa) == NORTH_AREA else tmap
        src = pearl_sets[a['pearl_texset']]
        P = nsbtx._parse(src)
        pearl_pals = {p for p, _ in P['pals']}
        ptex = dict(P['texs'])
        def seasonal(name):     # 'pearl_art': textures that change with the seasons (by the main mapping)
            return isinstance(tmap.get(name), dict) and tmap[name].get('seasonal')
        for season in range(4):
            def b2_set(m):
                return m['season_sets'][season] if m.get('seasonal') and m.get('season_sets') else m['b2_set']
            count = season == (2 if pearl_art else 0)              # the report counts one season per area set
            if pearl_art and season < 2 and int(pa) not in RECOLOUR_ALL_YEAR:
                sets[a['b2_area_group'] + season] = b2_look.add_textures(   # spring, summer: Pearl's own set (its
                    b2_grass_rims(src, P, pairs, ptex, season), 'outdoor', season)   # grass rims on Black 2's grass)
                continue
            # pass 1: the Black 2 choice of each texture (None = keep Pearl's)
            choice, mismatched = {}, {}
            for name, _ in P['texs']:
                m = section.get(name) if isinstance(section.get(name), dict) else None
                if pearl_art and not seasonal(name):
                    continue                                        # Pearl's own all year
                if m and m.get('b2') and not m.get('composite') and 'derive' not in m.get('note', ''):
                    i = b2_set(m)
                    if m['b2'] in dict(b2(i)['texs']):
                        bw, bh = _size(dict(b2(i)['texs'])[m['b2']][0]); pw, ph = _size(ptex[name][0])
                        if pearl_art or 'mismatch' in fixes and (           # seams (tiles) or a cropped cut-out
                                bw > pw or bh > ph or _see_through(b2(i), m['b2']) and not _see_through(P, name)):
                            mismatched[name] = (i, m['b2']); continue          # (or holes: Jubilife's plaza c1_g1)
                        choice[name] = (i, m['b2'], b2_palette(b2(i), m['b2']))
            # pass 2: a Pearl palette name holds ONE palette: if two textures that share it disagree (Black 2 vs
            # Pearl, or two Black 2 palettes), they all keep Pearl's art
            by_pal = {}
            for name, _ in P['texs']:
                if pairs.get(name): by_pal.setdefault(pairs[name], set()).add(choice.get(name) and choice[name][::2])
            for name in list(choice):
                if len(by_pal.get(pairs.get(name), {None})) > 1:
                    clashes.add((pa, name)); del choice[name]
            # recolour plan: Pearl palette -> the Black 2 colours of its composite entries' reference texture
            ramps, refs, users, mains, derive, flowers = {}, {}, {}, {}, set(), set()
            ground_tex = (section.get('ngrass') or {}).get('b2')
            for name, _ in P['texs']:
                m = section.get(name) if isinstance(section.get(name), dict) else None
                pal = pairs.get(name)
                if name in choice or not pal: continue
                users.setdefault(pal, []).append(name)
                if pearl_art and not seasonal(name):
                    refs.setdefault(pal, set()).add(None)           # Pearl's own (and so is its palette)
                elif name in mismatched:
                    refs.setdefault(pal, set()).add(mismatched[name])
                    mains.setdefault(pal, set()).add(mismatched[name][1])
                elif m and m.get('b2') and ((m.get('composite') and not any('hana' in c for c in m['composite'])
                                             and name not in GRASS_ONLY) or 'derive' in m.get('note', '')):
                    # (+ road/lawn edges and corners)
                    i = b2_set(m)
                    refs.setdefault(pal, set()).add((i, m['b2'])); mains.setdefault(pal, set()).add(m['b2'])
                    if 'derive' in m.get('note', ''): derive.add(pal)
                    if 'refs' in fixes:
                        for c in m.get('composite') or ():
                            if c in dict(b2(i)['texs']) and (dict(b2(i)['texs'])[c][0] >> 26) & 7 not in (1, 6) \
                                    and (c != ground_tex or m['b2'] == ground_tex):
                                refs[pal].add((i, c))  # (translucent shadow decals such as ki02c, and the ground
                                                       # under tall grass, left out: not this art's colours)
                elif 'transfer' in fixes and m and m.get('b2') and m.get('composite'):     # flowers on grass:
                    refs.setdefault(pal, set()).add((b2_set(m), m['b2']))                 # the grass only
                    mains.setdefault(pal, set()).add(m['b2']); flowers.add(pal)
                else:
                    refs.setdefault(pal, set()).add(None)
            ground = _ground_anchors(section, P, pairs, b2, b2_set,
                                     seasonal if pearl_art else None) if 'transfer' in fixes else None
            group_counts = {}   # 'transfer': palettes with the same main Black 2 texture (all trees) share anchors
            if 'transfer' in fixes:
                from collections import Counter
                for pal, r in refs.items():
                    if None in r or pal not in pearl_pals: continue
                    key = tuple(sorted(mains.get(pal, ())))
                    pc, bc, bc_more, seen = group_counts.setdefault(key, (Counter(), Counter(), Counter(), set()))
                    for n in users.get(pal, ()): pc.update(recolour.colour_counts(P, n, pal))
                    for i, tex in r:
                        bp = b2_palette(b2(i), tex) if tex in dict(b2(i)['texs']) else None
                        if bp and (i, tex) not in seen:      # the main texture's colours first; the composite's
                            seen.add((i, tex))                # other textures only for kinds the main one lacks
                            (bc if tex in key else bc_more).update(recolour.colour_counts(b2(i), tex, bp))
            for pal, r in refs.items():
                one = len(r) == 1 and None not in r
                if not (one or ('refs' in fixes or 'mismatch' in fixes) and r and None not in r):
                    continue
                r = sorted(t for t in r if t[1] in dict(b2(t[0])['texs']))
                if not r: continue
                keep_first = True
                if 'c0' in fixes:   # entry 0 is transparent only if every texture drawn with this palette says so
                    keep_first = all((ptex[n][0] >> 29) & 1 for n in users.get(pal, ()) if n in ptex)
                if 'transfer' in fixes:
                    if pal not in pearl_pals: continue
                    pc, bc, bc_more, _ = group_counts[tuple(sorted(mains.get(pal, ())))]
                    if pal in flowers:          # grass colours to the ground's, petals left as Pearl drew them
                        ramps[pal] = (lambda q, kf: (lambda data: recolour.transfer_recolour(data, q, kf, True)))(
                            list(ground['pairs']), keep_first)
                        if not any(recolour.colour_class(p) == 'green' for p, _ in ground['pairs']):
                            # (the north: its ground is snow, no green anchor to match, so the bushes and grass of
                            # imped stayed Pearl-green; 2026-10-20) their grass colours take the snow
                            ramps[pal] = (lambda q, kf: (lambda data: recolour.grass_recolour(data, q, kf)))(
                                list(ground['pairs']), keep_first)
                        continue
                    ap = []
                    if pal in derive or ground_tex in mains.get(pal, ()):
                        ap += ground['pairs']                      # the ground's own grass: no seam at the edge
                    for n in users.get(pal, ()):                   # an edge (nsandp, lgreenp, beachp, ...) and the
                        inner = n[:-1] if n.endswith('p') else None   # middle it surrounds (nsand, lgreen, beach)
                        if pal in derive and inner in ground['inner']: ap.append(ground['inner'][inner])
                    ap += recolour.anchor_pairs(pc, bc, bc_more)
                    ramps[pal] = (lambda q, kf: (lambda data: recolour.transfer_recolour(data, q, kf)))(ap, keep_first)
                else:
                    i, tex = r[0]
                    if one:
                        cols = recolour.used_colours(b2(i), tex, b2_palette(b2(i), tex))
                    else:
                        cols = sorted({c for i2, t2 in r
                                       for c in recolour.used_colours(b2(i2), t2, b2_palette(b2(i2), t2))},
                                      key=recolour.luma)
                    ramps[pal] = (lambda c, kf: (lambda data: recolour.ramp_recolour(data, c, kf)))(cols, keep_first)
            if pearl_art and 'transfer' in fixes and ground and ground['pairs']:
                # Pearl art kept all year that has grass in it (gravel fringes, path, plaza and brick edges, marsh
                # mud, berry soil: blueglayp, ckado, c07_base_*, c5_base_*, numa_*, plant2): its grass colours take
                # the season's ground, its stone and soil stay Pearl's (2026-10-20: Pearl-green rims next to
                # recoloured grass; b2tools/season_grass_check.py)
                for pal, r in refs.items():
                    names = [n for n in users.get(pal, ()) if n in ptex]
                    if pal in ramps or pal not in pearl_pals or r != {None} or not names \
                            or any(seasonal(n) for n in names) \
                            or not any(recolour.is_grass(c) for n in names for c in recolour.colour_counts(P, n, pal)):
                        continue
                    kf = all((ptex[n][0] >> 29) & 1 for n in names)
                    ramps[pal] = (lambda q, k: (lambda data: recolour.grass_recolour(data, q, k)))(
                        list(ground['pairs']), kf)
                    edged += count * len(names)
            adds = []
            for name, _ in P['texs']:
                pal = pairs.get(name)
                if name in choice:
                    i, tex, bp = choice[name]
                    adds.append((b2_sets[i], tex, bp, name, pal if bp else None)); used += count
                elif pal in ramps and pal in pearl_pals:
                    adds.append((src, name, pal, name, pal, ramps[pal])); recoloured += count
                else:
                    adds.append((src, name, pal if pal in pearl_pals else None)); kept += count
            sets[a['b2_area_group'] + season] = b2_look.add_textures(       # (+ Black 2's water and grass: b2_look)
                nsbtx.merge(src, adds, keep_base=False), 'outdoor', season, int(pa) == NORTH_AREA)
    return sets, (f'sinnoh_reskin: {used} textures from Black 2, {recoloured} recoloured to Black 2, {kept} kept from '
                  f'Pearl (per area set, {"autumn" if pearl_art else "spring"}); '
                  f'palette clashes kept as Pearl: {len(clashes)}; grass rims of Pearl art recoloured: {edged}'
                  + (f'; map-look fixes {sorted(fixes)}' if fixes else ''))


def b2_grass_rims(src, P, pairs, ptex, season):
    """Spring and summer with Black 2's grass ground (b2_look 'b2_grass'): Pearl's own art keeps its colours but its
    grass colours (path, lawn, beach and puddle edges, tree shadows on the ground, the flowers' grass, imped's grass,
    bare patches) take Black 2's grass01ax colours of the season at Pearl's relative brightness (recolour.
    grass_recolour), so no Pearl-mint rim meets the new ground; the trees and the tall grass stay Pearl's own (the
    user, 2026-10-26), and so does a palette one of them shares."""
    if not b2_look.grass_on(): return src
    pairs_g = b2_look.grass_pairs(P, season)
    if not pairs_g: return src
    users = {}
    for name, _ in P['texs']:
        if pairs.get(name): users.setdefault(pairs[name], []).append(name)
    pearl_pals = {p for p, _ in P['pals']}
    changes = {}
    for pal, names in users.items():
        if pal not in pearl_pals or any(b2_look.keeps_own_grass(n) for n in names): continue
        if not any(recolour.is_grass(c) for n in names for c in recolour.colour_counts(P, n, pal)): continue
        kf = all((ptex[n][0] >> 29) & 1 for n in names)
        changes[pal] = (lambda q, k: (lambda data: recolour.grass_recolour(data, q, k)))(pairs_g, kf)
    return b2_look.recolour_palettes(src, changes)


def _ground_anchors(section, P, pairs, b2, b2_set, recoloured=None):
    """{'pairs': [(Pearl ground colour, Black 2 ground colour)], 'inner': {texture: (Pearl colour, Black 2 colour)}}:
    the most used colour of Pearl's ngrass and of every Pearl texture swapped for a Black 2 one, with that Black 2
    texture's most used colour, so recoloured edges and shadows meet the ground and the middle they surround in the
    very colours drawn there. recoloured ('pearl_art'): which textures change; one that does not stays Pearl's, so
    its pair is its own Pearl colour."""
    out = {'pairs': [], 'inner': {}}
    for pname, _ in P['texs']:
        m = section.get(pname)
        if not isinstance(m, dict) or not m.get('b2') or not pairs.get(pname): continue
        if m.get('composite') or 'derive' in m.get('note', ''): continue
        i = b2_set(m)
        if m['b2'] not in dict(b2(i)['texs']) or pairs[pname] not in {p for p, _ in P['pals']}: continue
        bp = b2_palette(b2(i), m['b2'])
        if not bp: continue
        pc = recolour.colour_counts(P, pname, pairs[pname]).most_common(1)
        bc = recolour.colour_counts(b2(i), m['b2'], bp).most_common(1)
        if pc and bc:
            if recoloured and not recoloured(pname): bc = pc
            out['inner'][pname] = (pc[0][0], bc[0][0])
            if pname == 'ngrass': out['pairs'].append((pc[0][0], bc[0][0]))
    return out
