# Not built yet: the one list (2026-10-19)

Everything Pearl has, or the user asked for, that the game does not have yet, in one place (HoennB2 lesson 19: its Trick
House sat as "optional" and was forgotten). Details are in the notes named. When something is built, strike it here
with the date. "Players see" = what the game shows meanwhile.

## Story
| Item | Players see now | Notes |
|---|---|---|
| Chapters 2 onward (Route 202 to the end; Chapter 2 = Route 202 to Roark's Gym is ready to install) | Pearl's maps without the story's scenes | STORY.md |
| ~~Pearl's catching tutorial (the counterpart's starter vs Bidoof)~~ done 2026-10-20 (patches/capture_demo.py: Pearl's Pokémon, moves, Dawn/Lucas back, lines, 20 Balls; Black 2's fixed HP-bar changes stay) | | DECISIONS 2026-10-18 |
| Pearl's first-battle rules for the Starly battle (no critical hits, Fight only) | a normal wild battle | DECISIONS 2026-10-19 |
| Losing the Starly battle, a girl player, Turtwig/Piplup, Unova story songs: not yet seen in game | | STORY.md |
| Chapter 5a's left-overs: the Ruin Maniac's cave grows with the Unown forms seen (GetUnownFormsSeenCount: no Black 2 command; stays stage 1, the Route 214 gatehouse man says the under-26 line), Pastoria's move reminder (Pearl's Move Tutor house: SelectMoveTutorPokemon / OpenMoveReminderMenu), Dr. Footstep's Footprint Ribbon (Route 213: ribbons and footprint types), the scarf man's contest-stat scarves (Pastoria), the Pastoria Gym buttons sinking when pressed (static models) | each talks but the service does nothing | STORY.md "Chapter 5a" |
| Chapter 8's left-overs: the credits' copyright screen and THE END (Black 2's art and years); the ending song (Black 2's SEQ_BGM_ENDING); Sunyshore's Seal clerk (PokeMartSeal stubbed), the Route 222 size contest and the Vista Lighthouse binoculars (Pearl's own screens) | Black 2's art and song, the clerks' first lines only | STORY.md Chapter 8 |

## Trainers and battles
| Item | Players see now | Notes |
|---|---|---|
| Trainers (520 first battles), installed with each chapter | no trainer battles | TRAINERS.md |
| All of Pearl's rematches (defeat-flag code change) | none | DECISIONS 2026-10-19 |
| Pearl's boss battle music (Gym Leaders, Galactic, Elite Four, Champion) | Black 2's | DECISIONS 2026-10-19 |

## Items, TMs, shops
| Item | Players see now | Notes |
|---|---|---|
| Item balls and hidden items | none, except Pearl's 5 HM / key-item balls (HM02, HM08, Storage Key, Galactic Key, Lunar Wing: data/pearl_item_balls.json, 2026-10-25), which the port can extend | |
| Berry patches (Pearl's 118 soil patches: planting, growth, watering; Black 2 has none) | none (Berries come from people and Amity Square) | the Pokétch's Berry Searcher shows them once built (notes/POKETCH.md) |
| Shops, the Veilstone Dept. Store (Pixie Plate, Fairy Gem) and other specialty marts | Black 2's normal Mart at every clerk, the specialty and decoration clerks included (2026-10-25) | DECISIONS 2026-10-19 |
| The Fly list; Pearl's light fog (weather 8); Defog's sound and battle fog; Rock Climb from the party menu (TM96-TM120, Rock Climb at the walls and Defog from the party menu built 2026-10-26) | Black 2's | TMS.md |
| Exp. Share: Rowan's third question; the item at the Route 206 north gate | none | DECISIONS 2026-10-19 |

## Pokémon and wild encounters
| Item | Players see now | Notes |
|---|---|---|
| Pearl's exact encounter rate (4-byte edit) | Black 2's nearest rule | ENCOUNTERS.md question 3 |
| Fairy moves from X/Y for Sinnoh's Fairy Pokémon | HoennB2's list only | DECISIONS 2026-10-19 |
| Honey trees, Great Marsh daily Pokémon, Trophy Garden daily Pokémon (in the grass), Feebas tiles | nothing there; Mr. Backlot already picks the Trophy Garden's daily Pokémon and names it (Chapter 9b: PVAR_TROPHY_GARDEN_1/2) | ENCOUNTERS.md; the Trophy Garden's grass slots 6-7: the roamers agent (STORY_HANDOFFS 9b) |
| Swarms and roamers (Mesprit, Cresselia) | none (Black 2's zone lists point at the wrong places but stay off) | ENCOUNTERS.md |
| ~~Pokédex area maps~~ done 2026-10-20 (town_map + sinnoh_pokedex: Sinnoh map, AREA page, HABITAT list) | | |
| Roamers on the Pokédex AREA page (Mesprit, Cresselia: Pearl shows where they roam) | "Area Unknown" | waits for the roamers; HoennB2 hoenn_pokedex.py RoamerFix is the model |
| Pearl's diplomas (Grand Lake game director: ShowDiplomaSinnoh / ShowDiplomaNationalDex) | nothing (stubbed) | Black 2's CallPokedexDiploma 0/1 exists, its regional text says Unova (script text 2, read directly by ov314) |
| Town Map: Pearl's hidden places (Fullmoon/Newmoon Island, Spring Path, Flower Paradise), Pal Park's and Victory Road's own Fly spots | not drawn / no record | patches/town_map.py |
| Town Map: the player's marker at Snowpoint (cosmetic, kept: lead 2026-10-26) | the pin is drawn above its point (y 11), so its top is above the screen's edge, as Black 2's own at N's Castle (y 6) | the marker shares the town block's point (TOWNMAP_PARAM_X/Y): a code change |
| Black 2's Medal Box lines about the "Unova Pokédex" | Black 2's | system text title_11 |

## Sinnoh-only places and systems
| Item | Players see now | Notes |
|---|---|---|
| The Pokétch: Pearl's 25 apps, replacing the C-Gear (in progress, 2026-10-26). Apps that wait for other content: the Dowsing Machine (hidden items), the Berry Searcher (berry patches), the Trainer Counter (the Poké Radar: not planned, so it stays empty as in Pearl without the radar), the Marking Map's roamers (Mesprit, Cresselia) and Pearl's hidden places | the C-Gear-off screen; Jubilife's Pokétch scene gives nothing | DECISIONS 2026-10-26, notes/POKETCH.md |
| Underground: Pearl's tunnels, Hideaways, BDSP's Shining Pearl encounter tables, from the Explorer Kit on | part 1 built (c939748): the Kit, tunnels, 18 Hideaways with random battles, item balls, grottos, daily shard/fossil balls; part 2 (visible wandering Pokémon, battle on bump) next; no digging, traps, Spheres or Secret Bases | notes/UNDERGROUND.md |
| Battle Zone (Battle Tower) and the PWT in the Fight Area | the Battle Park and the Battle Tower lobby (Chapter 9a: the people and Barry's scene; the receptionists' Battle Tower commands stubbed, the Exchange Service Corner's BP stubbed); the tower's 7 rooms have no zones (DECISIONS 2026-10-26: zones 616-622). Plan (the battlezone agent): Pearl's tower on Black 2's Battle Subway as HoennB2's battle_tower (script plugin 1's zone table, ov033), BP and the Exchange Service Corner on Black 2's BP; the PWT's zones 192/193 kept, a door in the Battle Park, HoennB2 RESEARCH_PWT 4.2/4.3's traps, the Sinnoh Leaders tournament at the Hall of Fame (ov055 jump table, HoennB2 pwt.py) | DECISIONS 2026-10-18, 2026-10-25 |
| Turnback Cave's rooms and Giratina | the entrance only (its four doors lead back into it); the pillar rooms, the random rooms and Giratina's room have no zones (DECISIONS 2026-10-26: zones 623-632); Pearl's room logic (InitTurnbackCave 0x285) not ported | Chapter 9a |
| The Ribbon Syndicate | everyone is turned away (CountPartyRibbons: Black 2 has no ribbon script commands); its 2F spa has no zone | Chapter 9a |
| Route 224's stone tablet keeps no inscription (Black 2 has no save string for it): read later, it names the player | | Chapter 9a |
| Pal Park: Ramanas Park (BDSP's slate rooms: 9 rooms, slates for Mysterious Shards, the legendaries) and, with a GBA game in slot 2, Pearl's migration + Catching Show | Ramanas Park merged (main 7d4df30); the migration being built (palpark2: cartridge, GBA save and conversion done offline; the screen, the show and the gate next) | notes/RAMANAS_PARK.md, notes/PAL_PARK_MIGRATION.md, DECISIONS 2026-10-26 |
| The Catching Show's battle buttons: Pearl's battle has only PARK BALL (with the balls left) and RUN | Black 2's command screen with its own art: BAG throws a Park Ball at once, FIGHT and POKéMON do nothing, every throw catches, Run always works (the lead, 2026-10-26); no PARK BALL button art yet, and the player's lead Pokémon still comes out (Black 2's battle needs one) | new button art for the command screen's BAG slot (and FIGHT / POKéMON greyed) would make it Pearl's; notes/PAL_PARK_MIGRATION.md |
| Pearl's dual-slot wild Pokémon (routes whose Pokémon change with a GBA game in slot 2: pokediamond CheckGBACartridge 0x26E, gSystem.gbaCartId) | Black 2's slot-2 code is a stub: no dual-slot Pokémon | a later extra (the lead, 2026-10-26); version-specific lists in data when built; notes/PAL_PARK_MIGRATION.md |
| Great Marsh: open since 2026-10-25 as HoennB2's Safari Zone (the $500 fee, 30 Safari Balls as items, normal battles, the balls taken back on the way out; each of the six areas its own zone and wild Pokémon). Not built: Pearl's Safari Game rules (500 steps, the Safari battle screen with mud and bait), the Quick Trams (their six stops show a closed line, "The Quick Tram is being prepared. Please come again!": every area is reachable on foot), the 2F binoculars (a closed line: Pearl's lookout is a series of map views), the daily Pokémon (below) | | STORY.md "Chapter 5a" |

| Super Contests, Poké Radar | **not planned**. The Contest Hall's three receptionists run Black 2's Pokémon Musical instead (Prop Case on the first visit, Black 2's four shows, the show ends back at the counter: patches/musical.py, src/include/pearl_musical.inc); Pearl's Contest stage, ranks, ribbons, Accessories and Poffins are not built | DECISIONS 2026-10-18, 2026-10-25 |
| Veilstone Game Corner (slots, coins) and Prize Exchange | closed: the Game Corner's floor and the prize clerk say "... is being prepared" (Black 2 has no slots or coins; the Coin Case is still given) | DECISIONS 2026-10-25 |
| ~~Snowpoint Gym's ice (Pearl's slide speed by slope, snowballs)~~ done 2026-10-26 (gimmick 61, decomp src/pearlb2/snowpoint_gym_itcm.c, patches/snowpoint_gym.py): no snowball break animation, the break sound a Black 2 stand-in | | STORY.md Chapter 6b |
| Veilstone Gym's sliding wall panels (Pearl's puzzle: gimmick id 60, data in b2tools/pearl_veilstone_gym.py) | the Gym open, the panels not drawn | DECISIONS 2026-10-25 |
| Seals and Ball Capsules (the Solaceon Seal House) | the Seal Case is given; the Seal gift gives nothing | STORY.md Chapter 4b |

## Look and sound
| Item | Players see now | Notes |
|---|---|---|
| Pearl's sprites for Dawn/Lucas (the other one) and Barry walking around (Rowan, Mom, Barry's mom and Pearl's middle-aged women: done 2026-10-19, pearl_npc_sprites) | Black 2 stand-ins (Rosa/Nate, Hugh) | STORY.md question 3 |
| Signs as Black 2's signboard models | person-like sign objects | DECISIONS 2026-10-19 |
| Unova songs re-picked by mood | the first pick by place kind | DECISIONS 2026-10-19 |
| ~~Rowan's shorter question lines~~ done 2026-10-19 | | |
| Sprite question (CLASSIC / NEW) | not asked | FAIRY.md |
| Title menu "UNOVA LINK" label | Black 2's | |
| Pearl's alternate zone music after story events (pokeplatinum SystemFlag_GetAltMusicForHeader: Galactic Eterna Building, Valley Windworks, Floaroma Meadow, the lakes, Galactic HQ, Rowan's lab, Route 224, Pal Park; flags 0x987-0x989 set by Chapter 3) | the zone's header music stays | STORY_HANDOFFS.md Chapter 3 |

## Map details left (notes/MAP_LOOK.md "Other things found")
| Item | Notes |
|---|---|
| Routes 215 (camera 3), 216 (40), 217-219 (25) use other Black 2 cameras than the rest (camera 0) | check in game when the story gets there |
| Overworld area records keep Black 2's texture animation ids (load files for nothing) | harmless; tidy up |
| Room outlines lighter than Pearl's; rooms use a Black 2 interior light table | MAP_LOOK.md |
| Pearl's camera angle (`MAPLOOK_FIXES=default,camera`) | test build first, screenshots to the user |
| Bike slopes, ramps and one-way bike bridges (Pearl 0x76-0x7d bike-only, 0xd7/0xd8 ramps, 0xd9/0xda slopes) are plain floor or wall by Pearl's collision: Route 228's sand bike slopes beside its bridges (0xda BIKE_SLOPE_BOTTOM: (786, 385), (792, 325-326), (794, 370-371)) have no model ground and stand at height 0, so they block | WORLD.md "Bridges: two levels" (bridge_check.py lists them); Pearl's BDHC has their heights (24-72) |

## Release
| Item | Notes |
|---|---|
| The checks from HoennB2's lessons (disk, chunk size, warps, people sprites, text and archive headroom) | HOENN_LESSONS.md |
| melonDS link test with a Hoenn game | LINK.md |
| First .bps release (ask before publishing; hotfix or combined update) | |
