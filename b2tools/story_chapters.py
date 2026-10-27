"""Which chapter owns each Pearl zone not yet installed (notes/STORY_CHAPTERS.md; next week's chapter agents).

    python3 b2tools/story_chapters.py        writes data/story_chapters.json and prints the counts

Chapters 1, 2 and 90 (every Pokémon Center 1F) stay in pearl_story.CHAPTERS; 3-9 come from the rules below (zone name
prefixes, in Pearl's story order: the first chapter whose story reaches a zone owns it), and pearl_story.py reads
data/story_chapters.json for them. "skip" = zones nothing installs (Pearl's Pokémon Center basements and Union Room:
Black 2's shared 2F does that; an unused route).
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)

# (chapter, prefixes), first match wins: the more specific prefixes first
RULES = [
    # also: zones on Pearl's empty script file 368 (MAP_EVERYWHERE's: one End, 114 zones) with nothing at all to
    # install (no people, signs, triggers, item balls or hidden items): Jubilife's south-east house 4F and two Old
    # Chateau 2F rooms (2026-10-25, chapter 3). Zones on 368 with any of those stay in their chapters: each gets its
    # own script and text file (pearl_story.PearlData.shared_file_zones, 2026-10-25, chapter 4a).
    ('skip', ['UNION_ROOM', 'ROUTE_231_UNUSED', 'JUBLIFE_POKECENTER_2F', '_POKECENTER_B1F',
              'JUBLIFE_SOUTHEAST_HOUSE_4F', 'OLD_CHATEAU_2F_CORRIDOR', 'OLD_CHATEAU_2F_ROOM_3']),
    (7, ['VEILSTONE_GALACTIC_HEADQUARTERS', 'MOUNT_CORONET_SPEAR_PILLAR', 'MOUNT_CORONET_2F', 'MOUNT_CORONET_3F',
         'MOUNT_CORONET_4F', 'MOUNT_CORONET_5F', 'MOUNT_CORONET_6F', 'MOUNT_CORONET_B1F', 'MOUNT_CORONET_SOUTH_2F',
         'MOUNT_CORONET_SOUTH_3F', 'MOUNT_CORONET_SOUTH_MOUNTAINSIDE', 'MOUNT_CORONET_TUNNEL_ROOM']),
    (5, ['HEARTHOME_GYM']),
    (9, ['FIGHT_AREA', 'BATTLE_PARK', 'BATTLE_TOWER', 'ROUTE_224', 'ROUTE_225', 'ROUTE_226', 'ROUTE_227', 'ROUTE_228',
         'ROUTE_229', 'ROUTE_230', 'SURVIVAL_AREA', 'RESORT_AREA', 'STARK_MOUNTAIN', 'SNOWPOINT_TEMPLE',
         'TURNBACK_CAVE', 'SENDOFF_SPRING', 'SPRING_PATH', 'FULLMOON_ISLAND', 'NEWMOON_ISLAND', 'FLOWER_PARADISE',
         'ROUTE_219', 'ROUTE_220', 'ROUTE_221', 'PAL_PARK', 'TROPHY_GARDEN', 'ETERNA_OAK_HOUSE', 'HALL_OF_ORIGIN']),
    (3, ['JUBLIFE_SOUTHEAST_HOUSE_4F', 'ROUTE_204', 'RAVAGED_PATH', 'FLOAROMA', 'VALLEY_WINDWORKS', 'ROUTE_205',
         'ETERNA', 'FUEGO_IRONWORKS', 'OLD_CHATEAU']),
    (4, ['ROUTE_206', 'WAYWARD_CAVE', 'ROUTE_207', 'MOUNT_CORONET_SOUTH_1F', 'ROUTE_208', 'HEARTHOME', 'AMITY_SQUARE',
         'ROUTE_209', 'SOLACEON', 'ROUTE_210_SOUTH', 'ROUTE_215', 'VEILSTONE']),
    (5, ['ROUTE_214', 'RUIN_MANIAC_CAVE', 'VALOR_LAKEFRONT', 'ROUTE_213', 'PASTORIA', 'GREAT_MARSH', 'ROUTE_212',
         'ROUTE_210_NORTH', 'ROUTE_210_GRANDMA_WILMA_HOUSE', 'ROUTE_210_CAFE', 'CELESTIC', 'ROUTE_211',
         'MOUNT_CORONET_NORTH_1F']),
    (6, ['ROUTE_218', 'CANALAVE', 'IRON_ISLAND', 'LAKE_VALOR', 'VALOR_CAVERN', 'LAKE_VERITY_GALACTIC', 'VERITY_CAVERN',
         'ROUTE_216', 'ROUTE_217', 'ACUITY_LAKEFRONT', 'SNOWPOINT', 'LAKE_ACUITY', 'ACUITY_CAVERN',
         'MOUNT_CORONET_NORTH_MOUNTAINSIDE']),
    (8, ['ROUTE_222', 'SUNYSHORE', 'ROUTE_223', 'VICTORY_ROAD', 'POKEMON_LEAGUE']),
]


def chapter_of(name):
    short = name[4:]
    for ch, prefixes in RULES:
        if any(short.startswith(p) or (p.startswith('_') and short.endswith(p[1:])) for p in prefixes):
            return ch
    return None


def main():
    import pearl_story
    zones = json.load(open(os.path.join(ROOT, 'work', 'pearl', 'zones.json')))
    world = json.load(open(os.path.join(ROOT, 'data', 'sinnoh_world.json')))
    inst = {int(k) for k in world['zones']} | {int(k) for k in world['rooms']['zones']}
    done = {n for c in (1, 2, 90) for n in pearl_story.CHAPTERS[c]}
    out, unassigned = {}, []
    for i, z in enumerate(zones):
        if i not in inst or z['name'] in done:
            continue
        ch = chapter_of(z['name'])
        if ch is None:
            unassigned.append(z['name'])
        else:
            out.setdefault(str(ch), []).append(z['name'])
    assert not unassigned, unassigned
    data = {'_doc': 'Zones each story chapter owns (b2tools/story_chapters.py writes this; notes/STORY_CHAPTERS.md '
                    'describes the chapters). pearl_story.py reads chapters 3-9 from here.'}
    data.update({k: out[k] for k in sorted(out, key=lambda k: (k == 'skip', k))})
    json.dump(data, open(os.path.join(ROOT, 'data', 'story_chapters.json'), 'w'), indent=1)
    for k in data:
        if k != '_doc':
            print(k, len(data[k]))


if __name__ == '__main__':
    main()
