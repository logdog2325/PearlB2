# Pearl's story by chapter (lead, 2026-10-19)

What each chapter agent installs and tests (brief: notes/STORY_AGENT_BRIEF.md). Pearl's story has **8 chapters plus
the post-game** (Hoenn's had more, smaller ones: the big chapters below are marked with where they split, which gives
about 12 parts). Owned zones: data/story_chapters.json (b2tools/story_chapters.py; `python3 b2tools/pearl_story.py
chapter <n>` generates them). Every zone's script file is generated whole, so "owning" a zone means installing,
fixing and testing it; a beat of your story in another chapter's zone is a **foreign beat**: test it there, fix it in
the generator, note it in STORY_HANDOFFS.md.

The beats are Pearl's story in order as the lead knows it; items marked (check) must be confirmed in Pearl's own
scripts (pokediamond names, `python3 b2tools/pearl_story.py show <file>`) before coding. Every numbered beat is coded
(or confirmed working) and tested once in game. "Trainers" = trainer NPCs in the owned zones (plus script battles).
Start state = what TEST_SET / TEST_LINES must give a new test game (patches/test_story_start.py): fill in the exact
PVAR/PFLAG values from the previous chapter's last scripts.

Common to all: Pearl's own text word for word, Pearl's music (story songs installed, notes/MUSIC.md), the Lv 100 test
team (TEST_TEAM=1). Not built (notes/OPEN_CONTENT.md): Pokétch apps, Contests (closed), Underground, TMs 96-120, Rock
Climb / Defog field moves, Fly list, HM cut-ins, Pearl's catching demo, item balls and hidden items checks, specialty
shop stock: where a beat needs one, keep the story moving the closest Black 2 way and list it.

## Chapter 1: Twinleaf to the Parcel (done, tested as Lucas and Dawn)
TV, Mom, Barry's "Thud!!", Route 201, Lake Verity (Rowan, the briefcase, the starter, the Starly battle), Running
Shoes, Sandgem (escort, lab, Pokédex, tour), Mom's Journal and the Parcel. Black-out at home fixed.

## Chapter 2: Route 202 to Roark (done through Oreburgh; Mine and Gym being tested 2026-10-19)
Route 202 (catching demo: Black 2's stand-in; Tristan, Natalie, Logan), Jubilife (Lucas, the Trainers' School and the
Parcel -> Town Map, the Pokétch campaign: 3 clowns, the president, the Pokétch), Route 203 (Barry's battle), Oreburgh
Gate (HM06 Rock Smash), Oreburgh (the guide, Barry), Oreburgh Mine (Roark's Rock Smash scene), Oreburgh Gym (Roark:
Coal Badge, TM76).

## Chapter 3: Floaroma and Eterna (badge 2, Forest) - 46 zones, 41 trainers
Places: Route 204 S/N, Ravaged Path, Floaroma Town and Meadow, Valley Windworks, Route 205 S/N, Eterna Forest, Eterna
City (Gym, Galactic Building, Bike Shop, Herb Shop, Underground Man), Fuego Ironworks, Old Chateau.
Beats:
1. Jubilife after the Coal Badge: Galactic grunts harass Rowan and the counterpart; the tag battle with the counterpart
   (Pearl StartTagBattle: stubbed now; Black 2 has partner battles: translate it) (foreign beat in Jubilife).
2. Ravaged Path: Rock Smash with the Coal Badge (HM rules: notes/DECISIONS, hm_free).
3. Floaroma: the flower shop (Sprayduck), the Galactic grunts and the honey man -> Floaroma Meadow: two grunts ->
   Works Key.
4. Route 205 S: the girl whose father is in the Windworks; Valley Windworks: the Works Key opens it, grunts, Commander
   Mars battle, the father freed (Drifloon on Fridays: post-game check).
5. Eterna Forest: Cheryl joins as a partner (follows, double battles against trainer pairs, heals), leaves at the exit.
6. Eterna City: Cynthia at the statue (check what she gives and when: HM01 Cut), Gardenia's Gym -> Forest Badge (+ TM).
7. Galactic Eterna Building: grunts, Commander Jupiter battle, the bike shop owner freed -> Bicycle (Bike Shop).
8. Underground Man -> Explorer Kit (the item only: the Underground is later, DECISIONS).
9. Optional, test once if they start: Old Chateau (Cut), Fuego Ironworks (Surf later).
Start state: Coal Badge; Town Map, Pokétch, HM06; Chapter 2's last flags (Roark's Gym script).
Not built here: Pokétch apps; the Underground.

## Chapter 4: Route 206 to Veilstone (badge 3, Cobble) - 76 zones, 74 trainers (split 4a / 4b)
4a, Route 206 to Hearthome: Route 206 (Cycling Road, bike), Wayward Cave (optional: Mira as a partner, check),
Route 207, Mt. Coronet south 1F, Route 208 (Berry Master), Hearthome City.
1. Cycling Road on the bike; Route 207's scene with the counterpart (check what is given).
2. Mt. Coronet south 1F: Cyrus's monologue (check).
3. Hearthome: the counterpart/Keira scene (check), Bebe -> Eevee (gift), Pokémon Fan Club, Amity Square (not built:
   its gate must say so or stay closed), the Contest Hall (closed: a person or sign says so; DECISIONS), Fantina's Gym
   closed until Chapter 5 (check how Pearl blocks it).
4b, Route 209 to Veilstone: Route 209 (Good Rod), Lost Tower (5F, the old ladies: HM04 Strength and the Cleanse Tag;
checked 2026-10-25), Solaceon Town (Day Care, News Press, Seal House), Solaceon Ruins (Unown; HM05 Defog is not here:
it is in Pearl's Great Marsh Area 6, Chapter 5a), Route 210 S, Route 215, Veilstone City.
4. Veilstone (checked 2026-10-25): Maylene's Gym -> Cobble Badge + TM60; leaving the Gym, the counterpart's Pokédex
   was taken by Team Galactic; the tag battle with the counterpart against two grunts at the warehouse; then HM02 Fly
   (an item ball in the warehouse's front room); the Department Store (its elevator); the Game Corner and the Prize
   Exchange closed (no slots or coins in Black 2).
Start state: Forest Badge, Bicycle, HM01, Explorer Kit; Chapter 3's last flags.

## Chapter 5: Pastoria, Hearthome, Celestic (badges 4 Fen, 5 Relic; HM03 Surf) - 59 zones, 91 trainers (split 5a / 5b)
5a, Route 214 to Pastoria: Route 214, Ruin Maniac's cave (grows with Unown seen), Valor Lakefront (Hotel Grand Lake,
Seven Stars Restaurant), Route 213 (Dr. Footstep), Pastoria City, Great Marsh (Safari: planned, not built).
1. Pastoria: Barry (check), Crasher Wake's Gym (the water-level switches puzzle) -> Fen Badge (+ TM).
2. The Galactic grunt at the Great Marsh lookout ("the bomb"), the chase toward Route 213 / Valor Lakefront (check).
5b, Route 212 to Celestic: Route 212 S/N (Pokémon Mansion, Trophy Garden: daily Pokémon later), Hearthome's Gym,
Route 210 N (Psyduck, the café, Grandma Wilma), Route 211 E/W, Mt. Coronet north 1F, Celestic Town (ruins, Cynthia's
grandparents).
3. Fantina's Gym (the question rooms) -> Relic Badge (+ TM).
4. Route 210 N: the Psyduck block; Cynthia gives the SecretPotion (check where), the Psyduck go.
5. Celestic Town: the Galactic grunt at the shrine, battle; Cynthia's grandmother -> HM03 Surf; the ruins' mural.
Start state: Cobble Badge, HM02; Chapter 4's last flags.

## Chapter 6: Canalave, the lakes, Snowpoint (badges 6 Mine, 7 Icicle) - 42 zones, 54 trainers (split 6a / 6b)
6a, Canalave: Route 218 (Surf), Canalave City, Iron Island (boat), Canalave Library.
1. Canalave: Barry's battle at the drawbridge (check), Byron's Gym -> Mine Badge (+ TM).
2. Iron Island: Riley as a partner against Galactic grunts, the Riolu Egg (gift).
3. Canalave Library 3F: Rowan, Cynthia, the counterpart and Barry on the lakes' legend; the explosion at Lake Valor;
   who goes to which lake.
6b, the lakes and Snowpoint: Valor Lakefront / Lake Valor (drained), Lake Verity (Galactic), Routes 216-217 (snow,
Snowbound Lodge; check HM08 Rock Climb on Route 217), Acuity Lakefront, Snowpoint City, Lake Acuity.
4. Lake Valor: Commander Saturn battle, Azelf taken; Lake Verity: Commander Mars battle (the counterpart), Mesprit
   taken; the order of the lakes as Pearl's scripts set it (check).
5. Snowpoint: Candice's Gym (ice puzzle) -> Icicle Badge (+ TM); Lake Acuity: Jupiter, Barry beaten, Uxie taken; the
   Galactic Key or the way into the HQ (check).
6. The lake scenes switch warps with SetWarpEventPos (stacked warps at the three lakefronts and Valor Cavern:
   HOENN_LESSONS 2): test that the Galactic and normal lakes each open at the right time.
Start state: Fen and Relic Badges, HM03; Chapter 5's last flags.

## Chapter 7: Galactic HQ and Spear Pillar (Palkia) - 18 zones, 22 trainers
Places: Veilstone Galactic HQ (all floors), Mt. Coronet (the climb, its upper floors and mountainsides), Spear Pillar.
1. Galactic HQ: grunts, Commander Saturn, Cyrus's battle, the lake trio freed, Master Ball (check).
2. The climb up Mt. Coronet: HM gates on the way (Strength, Surf, Rock Smash, Rock Climb, Defog: check which; Rock
   Climb and Defog are not built as field moves: make the path passable the HM plan's way and list it).
3. Spear Pillar: Mars and Jupiter (tag battle with Barry), Cyrus, Palkia awakens; the battle with Palkia (catch or
   defeat: what happens next as Pearl does it, and DECISIONS on knocked-out legendaries (HOENN_LESSONS 26)).
4. After: the lake trio's caverns open (Azelf, Uxie stay; Mesprit roams: roamers are open content, list it).
Start state: Mine and Icicle Badges, HM08 (check); Chapter 6's last flags.

## Chapter 8: Sunyshore and the League (badge 8 Beacon; Champion) - 40 zones, 63 trainers
Places: Route 222 (Pikachu Fan Club, size contest), Sunyshore City (Vista Lighthouse, Market, Julia), Route 223,
Victory Road, Pokémon League (lobby, Elite Four rooms, Champion, Hall of Fame).
1. Sunyshore: Volkner at the Vista Lighthouse (check), his Gym (the gear puzzle) -> Beacon Badge (+ TM); HM07
   Waterfall (check who gives it).
2. Route 223 (Waterfall), Victory Road (Strength, Rock Climb, Rock Smash).
3. The League: the lobby (Barry? check), Aaron, Bertha, Flint, Lucian, Champion Cynthia; the Hall of Fame; the ending
   and credits; back home and what changes after (Rowan, the National Pokédex upgrade: check).
Start state: 7 badges, HM02-08 as Pearl has them; Chapter 7's last flags. (Done 2026-10-26: STORY_HANDOFFS Chapter 8 has the exact start; Pearl's own order and what was played: STORY.md "Chapter 8".)

## Chapter 9: post-game - 58 zones, 75 trainers (split 9a / 9b)
9a: the National Pokédex (Rowan / Oak, check), Route 224 (Oak's Letter: event-only, DECISIONS), Fight Area (Barry),
Battle Park / Battle Tower (DECISIONS: Battle Zone with Black 2's tower), Routes 225-230, Survival Area, Resort Area
(Villa: check), Stark Mountain (Heatran: check its trigger in Pearl), Snowpoint Temple (Regigigas), Turnback Cave
(Giratina), Sendoff Spring / Spring Path.
Checked in Pearl's scripts (2026-10-26, the ch9a agent; notes/STORY.md "Chapter 9a"): the National Pokédex is Rowan's
lab (Oak walks in once the Sinnoh Pokédex is seen; the Poké Radar; the Spring Path opens); the ship to the Fight Area
needs only the Hall of Fame; Pearl has no Villa (Platinum's) and no Mars/Jupiter at Stark Mountain (Platinum's):
Buck joins as partner in room 2, takes the Magma Stone in room 3, and Heatran appears after Buck's talk at his
grandfather's (Survival Area); Regigigas needs Regirock, Regice and Registeel in the party (Pearl's own check: they
come by trade or Ramanas Park); Turnback Cave's rooms and the Battle Tower's rooms need zones (DECISIONS 2026-10-26:
their own agents).
9b: Fullmoon Island (Cresselia: the Lunar Wing, then roaming), Newmoon / Flower Paradise (Darkrai / Shaymin: event
items: decide with the user), Routes 219-221, Pal Park (Gen 3 migration: not possible on Black 2: close it), Trophy
Garden (daily Pokémon), Old Chateau's Rotom, Hallowed Tower's Spiritomb (Underground).
Start state: the Champion beaten; Chapter 8's last flags.


Event Pokémon built in (user 2026-10-25: "make it so all the events like darkrai shaymin etc are built into the base
game already", "arceus too"): Darkrai (the Member Card: the Canalave Harbor Inn sailor's dream -> Newmoon Island),
Shaymin (Oak's Letter: Route 224 -> Flower Paradise, Pearl map D18, in our world), Arceus (the Azure Flute: Spear
Pillar's stairs -> the Hall of Origin, Pearl map 510 D05R0116: NOT allocated yet (skipped as event-only): it needs a
Black 2 zone, the spare 489 (notes/ZONES_KEPT or allocate_sinnoh's spares)), and the Manaphy Egg (Pokémon Ranger's
gift). All four come after the Hall of Fame from Pearl's Pokémon Center deliveryman (DECISIONS 2026-10-25). Pearl's own scripts for each event (check what Pearl's data holds for Route 224 and the
Hall of Origin; pokeplatinum only for gaps). How the items are given: DECISIONS.

Also for Chapter 9 (user 2026-10-25): the PWT in the Battle Frontier (Fight Area), as HoennB2's Hoenn Leaders
tournament (HoennB2 a9f14aa, notes/RESEARCH_PWT.md). How it works (decomp): opponents' teams are drawn at random
from a pool of sets per trainer (Battle Subway system, Lv 50; the rival uses his story team); AI = Black 2's basic /
attack-evaluation / expert flags (+ tag strategy in doubles) from 4 bits of the entrant record; NPC-vs-NPC matches
are not battled: the higher rank wins, same rank -> type matchup wins 70 %, else a coin flip.

## Skipped (data/story_chapters.json "skip")
Pearl's Pokémon Center basements (Black 2's shared 2F does Pearl's link rooms: pearl_centers), Pearl's Union Room,
the shared 2F, an unused route.

## Before the story agents: the world pass (user 2026-10-19)
The whole map is built (66 outdoor zones, 376 rooms and caves, Pearl's own models), but the rooms and caves have not
been checked against Pearl yet (Oreburgh Gym's colours looked wrong to the user). Next week starts with a world pass:
every town, building and cave compared with Pearl (lights and outlines in rooms: MAP_LOOK.md "Other things found";
textures; doors; warps, heights and reachability: HOENN_LESSONS 1-5; cave encounter tiles; people limits), fixed in
the converters, then the chapters above.
