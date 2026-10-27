# Story handoffs between chapters

Each chapter agent adds, at the end of its own section, what a later (or earlier) chapter must know: a flag or var
it sets that another chapter's zone reads, a scene it left for the owner of another zone (a "foreign beat"), a state
the next chapter's test start needs (TEST_SET / TEST_LINES), a generator change others should use. Read the sections
of the chapters before yours first. One section per chapter; never edit another chapter's section.

## Chapter 1 (done)
## Chapter 2 (done)
- End state for Chapter 3's test start: Coal Badge (pl_GiveBadge 0), Town Map, Pokétch, HM06; the flags Roark's Gym
  script sets (src/field_scripts/*_pearl_oreburgh_gym.s).
## Chapter 3
- Chapter 3's own test start (for reference): Jubilife (zone 6) at (174, 747) with TEST_SET
  "PVAR_4077=3,PVAR_4079=2,PVAR_40F0=1,PFLAG_025D,PFLAG_01B6,PFLAG_0075" and TEST_LINES "pl_GiveBadge 0;FlagReset
  PFLAG_0198;FlagReset PFLAG_01BB;FlagReset PFLAG_01BA" (Roark's end state; the Jubilife scene needs Dawn/Lucas,
  Rowan and the grunts shown). A party move for a field move: "PokePartyLearnMove 1, 3, 249" (Rock Smash), "...15" (Cut).
- End state for Chapter 4's test start (Eterna's south gate / Route 206): TEST_LINES "pl_GiveBadge 0;pl_GiveBadge 1"
  (Coal, Forest), TEST_ITEMS "420,450,428" (HM01, Bicycle, Explorer Kit; without the Kit Eterna's south exit sends
  you back: Eterna script 20), TEST_SET
  "PVAR_4077=4,PVAR_4079=3,PVAR_407A=1,PVAR_40AE=4,PVAR_40B1=2,PVAR_4089=2,PVAR_40CF=2,PVAR_40E9=1,PVAR_411B=1,
  PFLAG_0074,PFLAG_0079,PFLAG_0081,PFLAG_0082,PFLAG_008B,PFLAG_009F,PFLAG_00A0,PFLAG_00E3,PFLAG_00F2,PFLAG_010F,
  PFLAG_0113,PFLAG_0198,PFLAG_01B9,PFLAG_01BA,PFLAG_01BB,PFLAG_01BF,PFLAG_01C0,PFLAG_01C3,PFLAG_01C4,PFLAG_021B,
  PFLAG_021D,PFLAG_0216,PFLAG_0987,PFLAG_0988,PFLAG_0989" plus TEST_LINES "FlagReset PFLAG_01A0" (Gardenia's
  script clears it: Mt. Coronet 2F's cave-painting shards appear, Chapter 4/7) and "FlagReset PFLAG_01B0;FlagReset
  PFLAG_021C;FlagReset PFLAG_021E" (Jupiter's: the cycle shop owner, the Center's Buneary, the shop's Clefairy).
- Generator pieces others can use (2026-10-25): pl_StartTagBattle (Pearl StartTagBattle = Black 2's
  CallTrainerMultiBattle; a partner from a var becomes a chain over the trainer numbers the script sets it to:
  Spear Pillar's tag battle); pl_follow_start_ally (SetMovementType 0x30 after Pearl's partner var 0x403F: Black 2's
  ally follower, so two trainers who see you are a multi battle and wild battles are doubles with the partner;
  persistent across warps unless the same file ends the follow: Mira (Wayward Cave), Riley (Iron Island) use it and
  must test the warps); pl_SetBgEventPos (Pearl SetBgEventPosition); PearlData.text_file (zones on Pearl's
  placeholder bank 18: Iron Island, Snowpoint Temple, League rooms, Center B1Fs); a script that a step trigger also
  runs shows its lines in the plain window (kind_of: Black 2's talk balloon shows nothing without a talked-to person).
- World-wide fix (pearl_chunk.floor_mats, 62 tiles in 46 room chunks): walkable warp mats in rooms sat on their door
  frames (Eterna Gym entrance 30 units up); they now take the floor of the tile they are walked onto from. Rooms in
  later chapters with such mats (test their door once): Grand Lake reception, Route 214 gate, League lobby 2F, Pokémon Mansion, Old Chateau, Galactic HQ, Mt.
  Coronet, Stark Mountain, Lake caverns.
- Eterna after the Bicycle: Pearl's bike girl (Eterna trigger 23, var 0x411B = 1) turns the player back at the
  west exit until Route 207 (Chapter 4) sets 0x411B to 2: the forest and the Old Chateau are reached before the
  Bicycle or after Route 207.
- Exit mats: Pearl's 0x6F (WARP_SOUTH) is left by pressing DOWN even where it sits in a north wall (Ravaged Path's
  north exit (28, 44)); story_play: STEPD on the mat.
- Not done in Chapter 3 (not Chapter 3's code): Pearl's alternate zone music (pokeplatinum
  SystemFlag_GetAltMusicForHeader: the Galactic Eterna Building, Valley Windworks and Floaroma Meadow switch to the
  town/route music once flags 0x987-0x989 are set; also the lakes, Galactic HQ, Rowan's lab, Route 224, Pal Park):
  Black 2's zone music is fixed per zone, so these keep their header music after the scenes.
## Chapter 4
### 4a (Route 206 to Hearthome)
- Chapter 4a's own test start (for reference): Route 206 below the Eterna gate, TEST_START=368,304,577 with Chapter
  3's end state above (work/agents/ch4a/build.sh).
- End state for Chapter 4b's test start (Hearthome, east exit to Route 209: TEST_START=107,503,726): Chapter 3's
  TEST_SET/TEST_LINES/TEST_ITEMS plus TEST_ITEMS 443 (Vs. Seeker) and TEST_SET "PVAR_408C=1,PVAR_411B=2,PVAR_4096=1,
  PVAR_40F6=1,PVAR_40F7=1,PVAR_40EB=1,PVAR_407B=2,PFLAG_01EA,PFLAG_01C9,PFLAG_025A,PFLAG_025B,PFLAG_025C,PFLAG_0224,
  PFLAG_0225,PFLAG_0226,PFLAG_0227,PFLAG_0978,PFLAG_097F" (all read back in game at 4a's end, 2026-10-25; Fantina
  gone from the Contest Hall door (0x25C), Route 207's counterpart gone, the bike girl at Eterna's west exit gone (0x411B = 2), Cyrus
  gone, Keira's Buneary scene done, the Contest Hall lobby scene done (Mom, Keira: the Route 209 blockade 0x224 hidden),
  Barry's Hearthome battle done (0x407B = 2)). Hearthome's east exit is blocked by two people (flag 0x224) until the
  Contest Hall lobby scene: the lobby stays open for it (only its counters are closed).
- Closed places (data/pearl_closed_facilities.json, pl_closed_facility; schema in pearl_story.py CLOSED): the three
  Contest counters now run Black 2's Pokémon Musical ("musical": true rows; the musical agent, 2026-10-25) and Amity
  Square is open with Pearl's followers (the amity agent, 2026-10-25). Rows for later chapters go in
  the same file (5a: the Great Marsh).
- Mira (Wayward Cave 1F, pl_follow_start_ally): her goodbye at the hidden exit (trigger (41,53)) uses pl_follow_leave
  now; Chapter 6a's pl_follow_end change reaches it at the merge: test her goodbye once after that merge (not tested
  in 4a). The hidden part (Mira, 10 trainers) needs Rock Smash only; the main entrance needs Strength (later).
- Fantina's look: after the sprite pass (Pearl gfx 130 on Black 2's PWT Fantina sheet draws a white X for her
  movement type at the Contest Hall door, Hearthome (479,692); the sprite agent fixes it world-wide).
- Fantina's Gym: Pearl does not lock the door; the guide inside says she is away until flag 0x98D (Chapter 5b's Gym
  zones, not installed in 4a: the Gym rooms are empty until then).
- Left for later chapters in 4a's zones: Bebe's Eevee needs the National Pokédex (Chapter 9); the Hearthome Egg
  man (Happiny, GiveEgg stub: PokePartyAddEgg) appears after the Hall of Fame (Chapter 9); Hearthome's continuation
  34 (after Spear Pillar's Warp: HideObject 255, SpearPillarSequence) is Chapter 7's; Cynthia's Hearthome scene
  (frame table var 0x40D1 == 1) and Barry's battle lines 4/5 after Fantina are Chapter 5's.
- Generator pieces others can use (2026-10-25): PearlData.script_file/text_file give each zone on Pearl's empty
  script file 368 its own files (Lost Tower 2F-4F, Solaceon Ruins, Victory Road, Route 223, ... install normally now);
  Pokétch app names in lines (BufferPoketchAppName: Jubilife's Pokétch Company, the Berry Master, Pal Park, the
  Day-Care checker man, ...); elevators (ELEVATOR_FLOORS_ABOVE: every floor and elevator room gets a zone-init entry;
  SetSpecialLocation = FieldSetNextZone): Veilstone Dept Store (4b), the Vista Lighthouse (8), the Ribbon Syndicate
  (9) test their elevators once; rooms only a script Warp reaches now get zones (allocate_sinnoh script_warp: the
  Hearthome houses' 2F, the Vista Lighthouse deck; skipped with reasons: the Contest stage, Pearl's Battle Tower
  rooms, the Hall of Origin; 1 free Black 2 zone left).
### 4b (Route 209 to Veilstone)
- Chapter 4b's own test start: Hearthome's east exit, 4a's end state above (work/agents/ch4b/build.sh; plus Cut,
  Rock Smash, Fly taught to test Pokémon).
- End state for Chapter 5a's test start (Veilstone after the Pokédex tag battle): the above plus TEST_LINES
  "pl_GiveBadge 2" (Cobble), TEST_ITEMS 387 (TM60), 421 (HM02), 423 (HM04), 224 (Cleanse Tag), 446 (Good Rod),
  TEST_SET "PVAR_411A=2,PVAR_407D=1,PVAR_40F5=1,PFLAG_0101,PFLAG_01DD,PFLAG_01C6,PFLAG_009D,PFLAG_0096,PFLAG_0116,PFLAG_00A2"
  (read back in game 2026-10-25 after the tag battle: 0x411A = 2, 0x407D = 1, 0x40F5 = 1, flags 0x101, 0x1DD, 0x1C6,
  0x9D set, the Cobble Badge flag 2416; 0x96 / 0x116 / 0xA2 are the Lost Tower ladies' and the Good Rod's gift flags
  from Pearl's scripts, the ladies' gifts seen in game). A start in Veilstone: TEST_START=120,680,598 (a Veilstone
  cell; work/agents/ch4b/build_veil.sh).
- Beats of later chapters in 4b's zones: Route 210 South's Psyduck block and Cynthia's SecretPotion scene (5b; her
  lines and the narration have their speakers, data/pearl_speakers.json); the Storage Key ball under the grunt that
  Lake Acuity's script brings back to Veilstone (flag 0x241: 6b/7; data/pearl_item_balls.json installs the ball),
  the warehouse's inner door (Storage Key) and its stairs to the HQ (7).
- HM05 Defog is Pearl's Great Marsh Area 6 (5a's Safari zone, not built), not the Solaceon Ruins.
- Route 215 cannot be crossed yet (2026-10-25 test): its road runs under Pearl's two-level wooden bridges, and the
  conversion gives bridge tiles the bridge's floor height (pearl_chunk BEHAVIOURS 0x70/0x71), so the way east to
  Veilstone is blocked from both sides. Walk Solaceon -> Route 210 S -> Route 215 -> Veilstone once after the bridges
  fix (a world agent); 4b's Veilstone beats were tested from a start in Veilstone. Getting to the Solaceon Ruins
  entrance takes Pearl's south ledges east of town (the planner in story_play does not jump ledges).
- Generator pieces others can use (2026-10-25): data/pearl_item_balls.json (Pearl's HM / key-item balls as people
  running Pearl's own item script: Route 217's HM08 (6b), HQ B2F's Galactic Key (7), Fullmoon's Lunar Wing (9)
  install with their zones; test each once); zone-init copies of subroutines (call_label: automatic); Black 2's party
  select for ChoosePokemonMenu; the Day Care; specialty clerks on Black 2's normal Mart; MessageUnown.
- After the merge, one in-game check each (changed outside 4b): the Jubilife TV gallery's and the Eterna
  condominiums' party select, a Mart's second clerk (any town).
- Shared fixes from 4b's test (2026-10-25), affecting every chapter: Pearl's 6 elevator rooms' exits (Pearl's dynamic
  warp, dest header 0xFFF) are Black 2's next-zone warps now (patches/sinnoh_events.py PEARL_DYNAMIC_WARP; before, the
  player walking into an elevator landed at (0, 0) off the room): Chapter 8's Vista Lighthouse and 9's Ribbon
  Syndicate ride theirs once; every Mart's regular clerk opens Black 2's badge Mart (pl_PokeMartCommon: shop id 255;
  before, shop id 0 sold one Unova town's Repeat/Nest/Quick Balls and mail).
- Fly works (Veilstone visited -> the Sinnoh map -> lands at the Center); its cut-in and landing still show Black 2's
  Nate (a sprite pass).
## Chapter 5
### 5a (Route 214 to Pastoria)
- Chapter 5a's own test start (for reference; work/agents/ch5a/test_env2.sh): inside the Pastoria Gym,
  TEST_START=174,13,41 (build 1: Pastoria in front of the Gym, 113,589,828), TEST_TEAM=1, TEST_ITEMS
  "420,421,425,450,428,443", TEST_LINES "pl_GiveBadge 0;pl_GiveBadge 1;pl_GiveBadge 2;FlagReset PFLAG_01A0;FlagReset
  PFLAG_01B0;FlagReset PFLAG_021C;FlagReset PFLAG_021E;PokePartyLearnMove 1, 3, 249;PokePartyLearnMove 0, 1, 399"
  (Palkia's second move Dark Pulse: Black 2 remembers the move cursor, and Aura Sphere cannot hit Ghosts), TEST_SET =
  Chapter 3's end state (above, with PVAR_411B=2) + Chapter 4a's (above) + Chapter 4b's, read from Pearl's Veilstone
  scripts (Chapter 4b not merged when 5a was tested): "PVAR_407D=1,PVAR_40F5=1,PVAR_411A=2,PFLAG_0101,PFLAG_009D,
  PFLAG_010E,PFLAG_0242,PFLAG_09DD,PFLAG_01C6,PFLAG_01DD" (0x101 = after the Veilstone tag battle: Pastoria's grunt
  then waits for "the package"; 0x411A = 2, 0x407D = 1, Maylene's TM 0x9D, the Storage Key 0x10E, the HQ 1F door 0x242,
  the counterpart 0x1C6 and the warehouse grunts 0x1DD hidden) + PVAR_STARTER=387.
- End state for Chapter 5b's test start (after Valor Lakefront): pl_GiveBadge 3 (Fen, flag 2417), the SecretPotion
  (item 464, key items) and TEST_SET "PVAR_407C=1,PVAR_4083=2,PFLAG_009C,PFLAG_0102,PFLAG_0103,PFLAG_0104,PFLAG_0106,
  PFLAG_00B7,PFLAG_01C7,PFLAG_022A,PFLAG_0238,PFLAG_0239,PFLAG_01CB" (all read back in game 2026-10-25: Wake's TM55,
  the Pastoria grunt's two scenes and Barry's battle (Barry and the grunt hidden), the Route 213 grunt gone, the Valor
  Lakefront grunt beaten and gone, Cynthia gone with the SecretPotion given: var 0x4083 = 2, flag 0xB7).
- The hand-over to 5b: Cynthia gives the SecretPotion at Valor Lakefront (5a's zone: P381 script 4), not on Route
  210 N; 5b's Psyduck scene on Route 210 N reads var 0x4083 = 2 / the SecretPotion. Tested in 5a's run.
- Pastoria Gym water (decomp src/pearlb2/pastoria_gym_itcm.c, patches/pastoria_gym.py, generator handlers
  PressPastoriaGymButton / InitPersistedMapFeaturesForPastoriaGym): the gimmick slot 30, the GetTerrainAll hook (one row
  of the shared dispatcher at the merge with 6a's Canalave Gym), work 0x401D (PVAR_PASTORIA_GYM_PRESS). A later gym of
  the same kind (Pearl's dynamic terrain height) can reuse the layer idea: a water/lift height as one more terrain layer.
- Test tip: Route 214's Psychic Abigail (721,660, sight 5 west) guards the only way to the Veilstone gate; her Gastly
  is immune to Aura Sphere, Black 2 remembers the move cursor, and story_play can't leave the faint party screen: give
  the lead Dark Pulse in two slots (TEST_LINES "PokePartyLearnMove 0, 1, 399").
- The Ruin Maniac cave and Route 214's gatehouse man count Unown forms seen (GetUnownFormsSeenCount: no Black 2
  command; stub): the cave stays stage 1 and the man says the under-26 line until a script command exists.
- The Great Marsh opens as HoennB2's Safari Zone (user 2026-10-25): the attendant's $500, 30 Safari Balls into the Bag
  (pl_SafariStart), the leftover ones taken on the way out (pl_SafariEnd); normal battles, no step count. Each of its
  six areas is a zone (areas 1-5: Black 2 zones 585, 550, 608, 84, 85; allocate_sinnoh GREAT_MARSH_ZONES; the marsh
  matrix per cell, sinnoh_rooms rooms['cell_zones']). Tested in game: the fee and balls, a catch with a Safari Ball
  in area 6, area 5's own Pokémon and person, the way out. The Quick Tram and the binoculars (closed-facility lines on
  their stops/signs) and Pearl's daily marsh Pokémon are not built (OPEN_CONTENT).
- Rooms with the floor-mat fix tested in 5a: the Grand Lake reception (both doors, in and out), the Route 214
  Veilstone gatehouse (its south door, in and out).
- Black void past room edges in Black 2's camera (MAP_LOOK 1d, pending with the user), seen in 5a: the Pastoria Gym's
  narrow entrance and outer corridor ((13,42), (1,37)), the Route 213 gatehouse's west end ((1,7)).
### 5b (Route 212 to Celestic, Fantina)
- Chapter 5b's own test start (work/agents/ch5b/build.sh): inside Fantina's Gym, first room, TEST_START=128,9,21,
  5a's TEST_SET above + 4b's gift flags "PFLAG_0096,PFLAG_0116,PFLAG_00A2" + 5a's end state above + "2481,2475"
  (Hearthome and Solaceon visited: Fly), TEST_ITEMS "420,421,423,425,450,428,443,446,224,387,464", TEST_LINES
  "pl_GiveBadge 0;...;pl_GiveBadge 3;FlagReset PFLAG_01A0;FlagReset PFLAG_01B0;FlagReset PFLAG_021C;FlagReset
  PFLAG_021E;PokePartyLearnMove 0, 1, 399;PokePartyLearnMove 1, 3, 249;PokePartyLearnMove 2, 3, 19;
  PokePartyLearnMove 3, 3, 15;PokePartyAdjustHappiness 1, 255, 1" (Fly on Giratina, Cut on Heatran).
- Pearl's order (its scripts): Route 210 S Psyduck (SecretPotion from 5a's Valor Lakefront; Cynthia gives the Old
  Charm) -> Route 210 N -> Celestic (the elder, the shrine grunt, the Old Charm; the ruins' mural: the elder gives
  HM03 and sets 0x98D, Fantina back; Cyrus at the ruins' door) -> Fantina's Gym -> Cynthia in Hearthome (frame table
  var 0x40D1 == 1) sends you to the Canalave library.
- End state for Chapter 6a's test start (read back in game 2026-10-26 after Cynthia's Hearthome scene):
  pl_GiveBadge 4 (Relic, flag 2418), TM65 (item 392), HM03 (item 422); TEST_SET "PVAR_4074=2,PVAR_40F1=1,
  PVAR_40D1=2,PFLAG_00A3,PFLAG_00A5,PFLAG_00A6,PFLAG_00A7,PFLAG_098D,PFLAG_007D,PFLAG_0107,PFLAG_0980,PFLAG_01C8,
  PFLAG_01CA,PFLAG_01CD,PFLAG_01CE,PFLAG_01CF,PFLAG_01DB,PFLAG_0247" with PFLAG_01E1 clear (the elder at home); the
  Old Charm handed over (item 439 gone), the SecretPotion kept (Pearl keeps it). 6a's own start (above) used Pearl's
  values: the same, except PVAR_40D1 = 2 here (Cynthia's Hearthome scene done) and 0x1C8/0x1DB set, not reset.
- Fantina's Gym (DECISIONS 2026-10-26): Pearl's quiz-room lifts on gimmick 59 (pearl_gimmicks HEARTHOME_LIFTS; the
  struct's flag: the first room's lift up and still until PFLAG_098D; decomp branch pearlb2-ch5b). Exits go back
  through every room's lift (each room's entrance leads to the previous room's top door), as in Pearl.
- Grandma Wilma (Route 210 N, behind Pearl's Rock Climb wall: not reached in 5b's test): her Draco Meteor tutor is
  translated (pl_GetPartyMonTypes, PokePartyHasMove, pl_OpenMoveTutorMenu with Pearl's tutor-app lines, bank 586,
  and Black 2's forget-a-move screen). Test it once when Rock Climb works (6b): a Dragon at friendship 255 with four
  moves (the forget screen) and one with three. Route 228's ultimate-move tutor (9) uses the same commands.
- Mt. Coronet north 1F room 1's boulders: after the boulders fix (1x1 Pearl boulders, DECISIONS 2026-10-26), check
  (18,39) (the way to Route 211 West), (29,30) (to B1F: Chapter 7's climb), (18,43) (to the tunnel room), (15,34)
  (an item) can be pushed as in Pearl.
- Later chapters' beats in 5b's zones: the grandparents' house book (flag 0x15E: the elder shows Palkia's picture,
  DrawPokemonPreview, stub), the Trophy Garden (Mr. Backlot with the National Pokédex: GetTrophyGardenSlot1Species,
  AddTrophyGardenMon stubs; 9), Route 211 E / Coronet boulders (Strength), the café and the TM house (side; not
  played).
## Chapter 6
- 6a's own test start (2026-10-25; Chapters 4-5 were not done, so their end state comes from Pearl's own scripts:
  the Veilstone, Pastoria and Hearthome Gym leaders' scripts and Celestic's town, ruins and grandparents' house):
  Route 218 east, TEST_START=38,119,757, TEST_TEAM=1, TEST_ITEMS "420,421,422,425,450,428" (HM01, HM02, HM03, HM06,
  Bicycle, Explorer Kit), TEST_SET = Chapter 3's end state (above; with PVAR_411B=2, Route 207's) plus
  "PVAR_407D=1,PVAR_411A=1,PFLAG_009D,PVAR_407C=1,PFLAG_009C,PVAR_40D1=1,PFLAG_007D,PFLAG_0980,PFLAG_00A6,
  PFLAG_00A5,PFLAG_00A7,PFLAG_01CA,PFLAG_098D,PFLAG_0145,PVAR_40F1=1,PVAR_4074=2", TEST_LINES "pl_GiveBadge 0;...;
  pl_GiveBadge 4;FlagReset PFLAG_01A0;FlagReset PFLAG_01B0;FlagReset PFLAG_021C;FlagReset PFLAG_021E;FlagReset
  PFLAG_01C6;FlagReset PFLAG_01C8;FlagReset PFLAG_01DB;FlagReset PFLAG_0247;FlagReset PFLAG_01E1;PokePartyLearnMove
  0, 3, 57" (Palkia gets Surf). The whole command: work/agents/ch6a/tools/build.sh.
- End state for 6b's test start (Canalave after the library; played 2026-10-25): Mine Badge (pl_GiveBadge 5), TM91
  (Pearl item 418) and PVAR_4078=5, PVAR_40B2=2, PFLAG_00A8 (Lake Valor exploded), PFLAG_01CC, PFLAG_01B6,
  PFLAG_0092 set; PFLAG_01B2, PFLAG_0193, PFLAG_02B1 cleared (Lake Valor's Galactic scene: 6b); PFLAG_01D0,
  PFLAG_01D2, PFLAG_01D4, PFLAG_01D5, PFLAG_01D6 set (Barry, the sailor, the library's three gone). The next entry
  into Canalave sets PVAR_4078=6 and PFLAG_01D1, PFLAG_01D3 (Rowan and the counterpart gone: Canalave script 1), so a
  test start outside Canalave uses those. Iron Island is optional: Riley's Egg sets PFLAG_00E5, PFLAG_0203,
  PVAR_4092=2 (Riolu Egg in the party).
- Gimmick 59 (Pearl's moving platforms, decomp src/pearlb2/pearl_platforms_itcm.c, patches/pearl_platforms.py, data
  b2tools/pearl_gimmicks.py): the Canalave Gym (floors 2-4, 24 platforms, Pearl's collision maps) and Iron Island's
  three platform lifts. **The League's six lifts are not on it yet** (Chapter 8): MAP_POKEMON_LEAGUE_ENTRANCE,
  _AARON_BERTHA_LINK, _BERTHA_FLINT_LINK, _FLINT_LUCIAN_LINK, _LUCIAN_CYNTHIA_LINK and _CYNTHIA_ROOM keep
  TriggerPlatformLift as a stub, and the League can't be crossed until they are added to pearl_gimmicks.LIFTS (their
  plates already take their bottom floor's height: pearl_chunk._lift_plates). A new PearlB2 gimmick: one row in
  gimmick_itcm.c's sGimmicks (ids 60, 61, ...), one in sTerrainLayers if it adds terrain; the zone gets its id in
  a/1/0/2 from its patch.
- Partners that stay in their zone (pearl_story.partner_stays): a partner whose file gives it another movement type
  right after ClearHasPartner, and never makes it persistent, follows "in this zone only" and becomes its own NPC
  again (pl_follow_end): Riley here; Mira (Wayward Cave, 4a), Marley (Victory Road, 8) and Buck (Stark Mountain, 9)
  get the same at regeneration. Pearl's StartTrainerBattle right after SetHasPartner is a battle at the partner's
  side (pl_StartTagBattle with the file's 0x403F partner).
- Boats (the user: "look at how hoenn ported the boat scenes"): Pearl's ShipAnimation = pl_BoatCutscene <travel way>
  (pearl_story.inc), Black 2's 3D boat demos on a closed field as HoennB2's boats: Eldritch's boat (ways 3/0:
  Canalave <-> Iron Island, Fullmoon, Newmoon) = demo 4, the white motorboat with Castelia's pier hidden
  (patches/boat_demos.py, in the build list after pearl_platforms); the Snowpoint ship (ways 2/1: Snowpoint <-> Fight
  Area) = demo 26, the Virbank ferry at sea. 6b and 9 only regenerate. Canalave's drawbridge (Barry's bridge, props
  c2_s03a/b) does not rise: off screen from the dock, and Black 2 can't sail Pearl's docked boat through it. Test a
  boat from a cold boot (a savestate of another build plays a black demo).
- File-368 zones of 6a (trainers only, waiting for 4a's file-368 fix): MAP_IRON_ISLAND_B1F_ROOM_1,
  MAP_IRON_ISLAND_B2F_ROOM_1. Not generated in this tree.
- Cameras: Pearl's ShakeCamera (0x29F) is Black 2's EvCameraShake (pl_ShakeCamera); Black 2 shakes the camera's
  bound target, so with a free camera on (EvCameraUnbind) the view jumped to the map's corner: the generator now
  returns the view to the player for the shake and sets the free camera up again (also Stark Mountain, 9). A free
  camera on the player's tile from vars (AddFreeCamera after GetPlayerMapPos) takes its tile from
  pearl_story.CAMERA_AT_PLAYER (Library 3F's); Spear Pillar's four and Lake Acuity (Galactic)'s start on wide
  triggers or several arrivals, so they stay on the player (7, 6b: add a row if a scene needs the pan), and a
  RestoreCamera after such a stub now emits nothing.
### 6b (the lakes and Snowpoint)
- 6b's own test start (work/agents/ch6b/tools/build.sh): Verity Lakefront by the lake, TEST_START=456,81,846, Chapter
  3's TEST_SET + 6a's Chapters 4-5 part + Chapter 1's end works (story_sim chapter1: PVAR_4070=2, 4071=2, 4072=1,
  4082=4, 4086=3, 4093=1, 4095=1, 40A3=1, 40A4=6, 40A6=1, 40E6=1, 40F9=1, PFLAG_01B4: no Chapter 1 scene re-runs at
  Twinleaf, Route 201 or the lakes) + 6a's end (PVAR_4078=6, PVAR_40B2=2, PFLAG_00A8, 01CC, 01B6, 0092, 01D0-01D6;
  FlagReset PFLAG_01B2, 0193, 02B1) + Fly flags 2472, 2473, 2482, 2486 (Black 2's respawn discovery flags: Twinleaf,
  Sandgem, Pastoria, Snowpoint).
- End state for Chapter 7's test start (read back in game 2026-10-26): pl_GiveBadge 6 (Icicle, flag 2420), TM72
  (PFLAG_009E), HM08 (PFLAG_047B); TEST_SET "PVAR_40D3=2,PVAR_4097=1,PFLAG_013E,PFLAG_0984,PFLAG_00BA,PFLAG_098E,
  PFLAG_098F,PFLAG_0252,PFLAG_01B2,PFLAG_0193,PFLAG_02AA,PFLAG_02AB,PFLAG_01D7,PFLAG_01D8,PFLAG_01DA,PFLAG_01DE" and
  FlagReset PFLAG_0241 (the Storage Key grunt shown in Veilstone), PFLAG_00A8 (Lake Valor's explosion done).
- Foreign beat for Chapter 7: Lake Acuity's script clears 0x241: Veilstone's grunt with the Storage Key (4b's zone,
  data/pearl_item_balls.json) appears; test it with the warehouse door. Valor Lakefront's lake goes back to normal
  (0x15E, Spear Pillar) and Valor Cavern's exit with it: one look after Chapter 7.
- The caverns' legendaries (Azelf at Valor, Uxie at Acuity; Mesprit at Verity roams: not built) are Chapter 7's (after
  Spear Pillar). Their 0xED check is pl_CheckLostBattle (knocked out = gone for good, ran = back); untested in game.
- Gimmick 61 (decomp pearlb2-ch6b: src/pearlb2/snowpoint_gym_itcm.c, three calls in field_player_grid.c,
  gimmick_itcm.c rows 60 (NULL, kept for Veilstone's panels) and 61): any other Pearl ice with slopes or snowballs
  gets the rules by adding its zone to patches/snowpoint_gym.py GYMS; Snowpoint Temple's flat ice (Chapter 9) plays
  the same on Black 2's ice.
## Chapter 7
- Chapter 7's own test starts (2026-10-26; work/agents/ch7/build.sh): A = Mt. Coronet south 2F before the Galactic HQ,
  TEST_START=275,7,25 (the cave-painting wall in front); B = Mt. Coronet 4F room 3 after the HQ (the same build,
  `build.sh B` re-runs test_story_start only); later quick starts (`build.sh Q`: scripts, texts, story entities,
  sprites and test_story_start again on the same files, each sets its entries by index; build.sh.*.env): D = the
  Galactic HQ lab before Saturn (507, 8, 8), B2 = Spear Pillar below Cyrus's trigger with 0x4098 = 1 (330, 31, 40),
  C = Mt. Coronet south 2F after the HQ (275, 7, 25 with B's flags). Lv 100 test team (Dialga Strength, Giratina Fly, Heatran Rock Smash,
  Palkia Surf, Darkrai Cut), TEST_ITEMS 420-425, 427 (HM01-HM06, HM08), 450, 428, 443, badges 0-6 (pl_GiveBadge), Fly
  to Veilstone and Hearthome (Black 2 flags 2483 = 0x9B3, 2481 = 0x9B1).
- **Assumed for 6b's end state (6b not written yet; from Pearl's own scripts; check at the merge):** Lake Verity
  (Galactic) file 343: PVAR_4097=1, PFLAG_098E, PFLAG_00BA set, PVAR_40D3=1 (then 2 below); Valor Cavern file 348:
  PFLAG_013E, PFLAG_0984 set, PFLAG_01DA set (Saturn gone); Lake Acuity (Galactic) file 351: PFLAG_098F, PFLAG_0252,
  PFLAG_01B2, PFLAG_0193, PFLAG_02AB, PFLAG_02AA, PFLAG_01D7, PFLAG_01D8 set, PVAR_40D3=2, PFLAG_0241 (the Veilstone
  grunt with the Storage Key appears), PFLAG_01B6 and PFLAG_00A8 cleared; Snowpoint's Icicle Badge (pl_GiveBadge 6);
  HM08 (item 427) in the Bag. Chapters 5b and 6a's Library/Canalave flags as their handoffs or Pearl's scripts
  (build.sh S5 / S6A). Checked after the rebase on main (6b merged): every flag and var Chapter 7's zones read matches
  6b's read-back end state (STORY.md "Chapter 6b"); 6b's 0x1DE, 0x9E, 0x47B (set there) are not read here.
- End state for Chapter 8's test start (after Spear Pillar, Pearl file 230 continuation 17): PVAR_4098=4,
  PFLAG_0981, PFLAG_01EB, PFLAG_015E, PFLAG_02B3, PFLAG_02AD, PFLAG_0986, PFLAG_0253, PFLAG_0255, PFLAG_097D,
  PFLAG_00AD, PFLAG_0242, PFLAG_0244, PVAR_40D6=1, PVAR_410D=0 set; PFLAG_01FD, PFLAG_01FE, PFLAG_01FF (the lake trio
  in their caverns) and PFLAG_02B0 (Saturn on HQ 1F) cleared; the Master Ball (item 1); PFLAG_015F only if Palkia
  was caught. (Read back in game: see STORY.md "Chapter 7".)
- Foreign beats of Chapter 7 in other chapters' zones (generated in this tree, intended changes): the Spear Pillar
  vistas are Pearl file 230's code after its Warps: continuation 8 in Valley Windworks (ch3) and continuation 34 in
  Hearthome (ch4a): the player hidden (HideObject 255), Pearl's 90 frames, THE_EVENT03 kept over the warps
  (fixed_music); the Veilstone grunt's Storage Key (4b's zone, Veilstone script 14) and the warehouse's inner door.
- Left for 6b (its zones; not installed in this tree): the lake caverns after Spear Pillar (flags 0x1FD-0x1FF cleared
  here): Azelf (Valor Cavern) and Uxie (Acuity Cavern) battles use 0xED (6b's pl_CheckLostBattle: a knocked-out one
  sets 0x126/0x127 and never returns, Pearl's rule; one you ran from returns after the Hall of Fame, file 192);
  Mesprit (Verity Cavern) flees and roams: ActivateRoamingPokemon (0x21C) and ShowPokemonPic/RemovePokemonPreview
  (0x208/0x209) are stubs (roamers are open content). 6b is merged now; the caverns' trio float 24 units up there too
  (pearl_npc_sprites FLOAT_Y, Pearl's sprite offset for graphics 151-153; offline: work/agents/ch7/cavern_*_cmp.png);
  in game not yet (this tree's builds predate the merge).
- Mt. Coronet's climb needs Rock Climb (test after the Rock Climb merge; Pearl's walls are kept as they are): the
  north mountainside's east-west wall (40-44, 22) is on the only way to 4F room 3 / Spear Pillar (from Route 207/208
  through 2F-3F-south mountainside-4F room 1, and from Route 211 through the Tunnel Room, whose (4-7, 52) wall also
  needs it); off the way: Tunnel Room (11, 27-28) and (11, 48-50), south mountainside (31, 14-22), 4F room 1 (7,
  13-16). 4F room 1's waterfall (14-20, 9) needs Waterfall (Chapter 8's HM07). Mt. Coronet B1F (fog: Defog) is on
  Chapter 6b's way to Route 216 (Strength, Rock Smash, Surf). The Strength boulders' DoStrengthFunc (Pearl's 10002) is
  the boulders agent's.
- Generator pieces others can use (2026-10-26): camera_plan / CAMERA_PLAN_FILES (a free camera started on the
  player's tile in a scene that starts on several tiles: Pearl's branches on the player's x resolved by playing the
  scene from every trigger tile, across Warps; Lake Acuity (Galactic), file 351, can be added: one entry);
  end_free_camera (the free camera ends before a battle or Warp it is still out at); fixed_music (SetBGMFixed: the
  song played again after the warps Pearl keeps it over); pl_HideObject / pl_ShowObject (Pearl 0x1B2 / 0x1B1, also
  the player), SetEventDirection 0x18C (a turn at once), pl_CheckHasTwoAliveMons (0xEE), CheckDidNotCapture 0x2BC
  (6b's pl_CheckDidNotCapture), pl_SpearPillarSequence; sinnoh_events: Pearl's warp panels (0x67) are type-5
  step-on warps (the HQ's 25); pearl_ids PARTNER_VARIANTS (Barry's Spear Pillar teams 607/619/620 = Black 2 667-669);
  pearl_lab_units (a Pearl prop with an animation scripts play: a dynamic record of a kind no Black 2 code looks for,
  handles per placement, BMAnmPlayInv to hold the last frame on the shared instance); pearl_npc_sprites FLOAT_Y (a
  Pearl sprite offset as the ow record's wPosOffsetY; the shadow off, as Black 2's would float with it).
## Chapter 8
- Chapter 8's own test start (work/agents/ch8/tools/build.sh): the Route 222 / Sunyshore gatehouse, zone 513 (8, 7)
  (walking east into Sunyshore runs Flint's scene), with Chapters 1 and 3-6's end states above, badges 0-6, HM01-04,
  HM06, TM119 Defog (528), TM120 Rock Climb (529), Bicycle, Explorer Kit, Vs. Seeker, and Chapter 7's end taken from
  Pearl's own Spear Pillar script (file 230, its last continuation; Chapter 7 was not merged when 8 was tested):
  "PFLAG_015E,PFLAG_015F,PFLAG_0981,PFLAG_01EB,PFLAG_02B3,PFLAG_02AD,PFLAG_0986,PVAR_4098=4" and FlagReset
  PFLAG_01FD, 01FE, 01FF, 02B0. 0x15E opens Valor Lakefront's road to Route 222 (its blackout man hidden, var 0x4112 =
  1: Valor Lakefront's zone init).
- End state for Chapter 9's test start (after the Hall of Fame and Continue): the game-clear flag (Pearl's 0x964 =
  Black 2's 2400), Black 2's Hall of Fame record (RECORD 71 = 1: pl_GetLeagueVictories reads it, Fight Area Barry's
  team at 20), the Hall of Fame room's post-game flags (P192_0178: PFLAG_0982, var 0x40F4 = 1 (Twinleaf sets 2),
  0x410F = 1, the legendaries' and the lake trio's flags cleared as Pearl's), badge 7 (Beacon, flag 2421), TM57
  (PFLAG_00B6), HM07 Waterfall (PFLAG_009A; Black 2's HM05, item 424), var 0x407E = 2, PFLAG_0162 (Volkner back),
  PFLAG_00B5, var 0x40EF = 1 (Barry's lobby battle done), 0xAF (the lobby guard's badge check done).
- Generator pieces others can use (2026-10-26): PVAR_GIMMICK_REQUEST (0x401F, map-local) + pl_gimmick_request value,
  frames: one script-to-gimmick handshake for any PearlB2 gimmick (the Sunyshore Gym's buttons, Cynthia's lift);
  gimmick 59's LIFT_ONE_WAY / LIFT_SCRIPTED (pearl_gimmicks.LEAGUE_LIFTS) and pl_TriggerPlatformLiftRide for a lift a
  script starts; pl_ClearGame (Black 2's own Hall of Fame ending; Chapter 9's re-runs of the League use the same
  room and CallGameClear 1); h_add never adds an object that is not installed (Black 2's ActorAdd of a missing uid
  writes through an unset pointer).
- Black 2 3D-model actor codes: OBJ_CODE_MODEL_2 (0x2002) now carries Pearl's Elite Four door (patches/pearl_e4_doors.py);
  0x2001 and 0x2004 (copies of the boulder's model no Black 2 zone, script or code places) are still free for
  another Pearl 3D object; GetIndexOfObjID knows no code past 0x200A. Their own records have scene node 0, which
  draws nothing: copy a drawn model record (scene node 12, e.g. MODEL_7's, as pearl_e4_doors does).
- Beats of Chapter 9 in Chapter 8's zones: Victory Road's back rooms (Marley joins as a partner on 1F back 2,
  pl_follow_start_ally / partner_stays; the way to Route 224 needs the National Pokédex), the League's rematches
  (CallGameClear 1, the credits skippable), Julia's ribbons and the Sunyshore Market's Effort Ribbon (Black 2 has no
  ribbon script commands: stubs), the size-contest house (stubs), the Pokétch developer's apps (the Pokétch work), the
  Vista Lighthouse binoculars (UseVistaLighthouseBinoculars: nothing after "took a look"), the League lobby 2F/B1F
  link rooms (Union Room / Wi-Fi stubs).
## Chapter 9

## The Grand Underground (feature, not a chapter: notes/UNDERGROUND.md, 2026-10-26)
- Chapter 3 (Eterna, the Underground Man): his file is regenerated with data/pearl_script_patches.json (file 89) and
  data/pearl_text_edits.json (bank 97 line 6): mission 1 (go down; PFLAG_096E, set by the Explorer Kit's way down)
  ends with his trimmed line 6 and then line 29 for good; no traps are given; missions 2-8 never start.
- Chapter 9b (Route 209, the Hallowed Tower's Spiritomb): Pearl's GetSpiritombTalkCounter (people talked to in the
  multiplayer Underground, 32 needed) reads **PVAR_UG_HIDEAWAY_BATTLES** (src/include/pearl.h: the Hideaways' wild battles, counted
  by src/pearlb2/underground_itcm.c; the lead 2026-10-26: 32 Hideaway battles instead) and ResetSpiritombTalkCounter
  sets it to 0: two pearl_story handlers (today both are stubs in 1619_pearl_route_209.s, P406_0102 / P406_017F).
- Test starts in the Underground: TEST_ITEMS 428 (the Explorer Kit); zones 633 (tunnels) and 634-651 (Hideaways);
  Champion's stage = TEST_SET PFLAG_0964 (Black 2's 2400).
### 9a (the National Pokédex, the Fight Area, Stark Mountain, the event Pokémon)
- 9a's own test start: work/agents/ch9a/tools/build.sh (START=lab|snowpoint|r224|temple|origin|spring): Chapters 1-6b's
  end states (this file), all 8 badges, game clear 2400 + Pearl's 0x982, PVAR_STARTER=387, FlagReset PFLAG_01B6
  (Rowan back in his lab: 6b's Lake Acuity). No species need to be seen: the National Pokédex comes at Champion.
- The National Pokédex at Champion (user 2026-10-26): pearl_story NATIONAL_DEX_AT_CHAMPION makes the two checks that
  gate Oak's upgrade (Rowan's talk in his lab, Pearl 990:0x61; Dawn / Lucas, global 10300, 977:0x23, outside the lab
  after the Hall of Fame: "Have you shown your Pokédex to Prof. Rowan yet?") pass once 2400 is set
  (pl_CheckLocalDexCompletedOrChampion); the Pokédex rating (Rowan's PC, 376) and the Grand Lake diploma (384) keep the
  true count. Everything gated on the National Pokédex follows Pearl's own rules from Oak's scene on.
- The deliveryman (Pearl's globals 10200/10201) is in every Pokémart file: Sunyshore's Mart (Chapter 8) gets him on
  regeneration. After the Hall of Fame he gives, one a talk: the Member Card (Darkrai: Canalave's Harbor Inn, 9b), Oak's
  Letter (Shaymin: Route 224), the Azure Flute (Arceus: Spear Pillar, 7's zone), the Manaphy Egg. PVAR_DELIVERY = 4
  when all four are given; a test start for 9b: TEST_SET "PVAR_DELIVERY=4" + TEST_ITEMS 454 (the Member Card).
- CheckDistributionEvent n (0 Darkrai, 1 Shaymin, 2 Arceus) = pl_CheckDistributionEvent: PVAR_DELIVERY > n.
- Hidden paths (b2tools/pearl_hidden_paths.py, patches/pearl_paths.py, right after sinnoh_rooms in the build list):
  the Spring Path is mountain until Rowan's National Pokédex (or the Hall of Fame after it: Chapter 8's file) sets
  Black 2's map-replace event 7; Route 224 opens to the Seabreak Path with event 9 (the Shaymin scene). A test start
  past them: TEST_LINES "MapReplaceSetEvent 7, 1, 0" / "MapReplaceSetEvent 9, 1, 0".
- Spear Pillar (Chapter 7's zone): its trigger (31, 52) on var 0x4118 runs Pearl's 2039 (game clear, National Pokédex,
  the Azure Flute's event) and warps to the Hall of Origin (zone 489, allocate_sinnoh EVENT_ROOM_ZONES); test once
  after both merges.
- Chapter 8: the Hall of Fame's GetLeagueVictories also picks Barry's Fight Area team (under 20 / 20 or more wins):
  RecordGet 71 (RECORD_HALL_OF_FAME_ENTRIES, the lead's note to Chapter 8); its SetHiddenLocation 2 is now Black 2's
  map replacement (the Spring Path).
- 9b: Eterna's Oak house shows Oak only once Pal Park's entrance clears 0x260 (Route 221, 9b); Canalave's Harbor Inn
  sailor reads the Member Card's event (pl_CheckDistributionEvent 0); SetHiddenLocation 0/1 (Fullmoon / Newmoon) are
  Town Map marks only (not drawn).
- The battlezone agent: the Battle Park, its gatehouse (the Point Card), the Exchange Service Corner (BP commands
  stubbed) and the Battle Tower lobby (128 stubs) are generated in 9a's zones; Barry's Battle Park scene is 9a's.
- The Turnback Cave agent: the entrance is generated (InitTurnbackCave stubbed); its four doors lead back into the
  entrance (dest 268, Pearl's own warps without its room logic); Sendoff Spring and the Spring Path are installed.
- Pal Park and its gate (Chapter 9b's MAP_PAL_PARK, MAP_ROUTE_221_PAL_PARK_ENTRANCE; the palpark agent, 2026-10-26,
  notes/RAMANAS_PARK.md): Ramanas Park lives in them through pearl_story / pearl_events hooks (b2tools/ramanas.py,
  data/ramanas_park.json), so 9b's regeneration keeps it: the gate's extra entries RamanasExtra_clerk (a new person,
  uid 100, the slate clerk) and RamanasExtra_return (frame table: VAR_PAL_PARK_STATE == 3, the walk-out after a
  visit); the park's RamanasExtra_attendant (object 0's talk: a Ramanas line in a visit, else Pearl's script). Pearl's
  VAR_PAL_PARK_STATE (PVAR_40F3) value 3 = a Ramanas visit. The park opens at Champion (PFLAG_0964). Pearl's own
  scenes (Oak, the Catching Show receptionist, the Pokétch apps, the accessory lady) stay 9b's. The Catching Show's
  stubs (0x253-0x256, 0x26E GetGBACartridgeVersion) are Part 2's (notes/PAL_PARK_MIGRATION.md): leave them stubbed.
  The rooms' doorways are 9 warps appended to Pal Park's events by patches/ramanas_park.py (after Pearl's 2).
- Turnback Cave (the turnback agent, 2026-10-26; b2tools/turnback.py): Pearl's maze on zones 623 (pillar room), 624
  (Giratina's room), 625-632 and 663-664 (the 18 random rooms: one zone per layout and wild tier, two of Pearl's rooms
  each, Rooms 17 and 14 alone), from the entrance (382, chapter 9a's file: its InitTurnbackCave is now translated).
  The rooms are in chapter 9's zone list (data/story_chapters.json), so 9's regeneration keeps them; the doors come
  from hooks (pearl_story InitTurnbackCave + PearlData.turnback_doors, pearl_events map_script_table, sinnoh_events
  Planner.warps -> turnback.extra_warps). Pearl's VAR_TURNBACK_CAVE_PILLARS_SEEN / ROOMS_VISITED = PVAR_410B / PVAR_410C (works 0x40CA / 0x40CB).
  Giratina (Pearl's script, Lv 70, Altered Forme): caught OR knocked out sets PFLAG_0121 (Pearl's 0xED answers 0 for
  both; Ramanas Park's Distortion Room reads it), hides Giratina (PFLAG_026E) and shows the item ball (PFLAG_0296);
  fled: Giratina stays. Test start inside: TEST_START=382,11,15 (the entrance, north of the way in from Sendoff
  Spring); a start in a maze room sets every door to Pearl's draw (no way in).
### 9b (the moon islands, Routes 219-221, Pal Park's gate, the Trophy Garden, Rotom, Spiritomb)
- 9b's own test start: work/agents/ch9b/tools/build.sh (START=canalave|mansion|chateau|r209|r221|oak|r219): Chapters
  1-8's end states (9a's lists + Chapter 7's and 8's from this file), all 8 badges, the National Pokédex
  (pl_SetNationalDex), PVAR_DELIVERY=4, the Member Card (454), the Odd Keystone (111), three Master Balls.
- **Cresselia's roaming (the roamers agent):** Fullmoon Island's forest (1524_pearl_fullmoon_island_interior.s,
  P274_000C, Cresselia's talk) keeps Pearl's `CreateRoamer 1` as a stub (`pl_stub ActivateRoamingPokemon`), right
  before Pearl's own PFLAG_011F (FLAG_MET_CRESSELIA, Black 2 flag 361) is set: the roamer starts when 361 is set (or
  give ActivateRoamingPokemon a handler: Mesprit's is the same stub in 1577_pearl_verity_cavern.s, CreateRoamer 0).
  Pearl's other Cresselia state: PFLAG_026D (681) hides her in the forest; the Lunar Wing (453) ball is PFLAG_0436.
- **The Trophy Garden's wild slots (the roamers agent, the lead 2026-10-26):** Mr. Backlot (Route 212 Pokémon
  Mansion east room, Chapter 5b's file) now runs AddTrophyGardenMon / GetTrophyGardenSlot1Species
  (pearl_story.inc pl_AddTrophyGardenMon): saved works **PVAR_TROPHY_GARDEN_1 (0x40F5) and _2 (0x40F6)** hold
  species (0 = none; a new one goes to slot 1, the old slot 1 to slot 2; once a day: Pearl's daily flag PFLAG_0AA2 =
  2746). The rule for the encounter code (pokeplatinum wild_encounters.c WildEncounters_ReplaceTrophyGardenEncounters):
  in the Trophy Garden (Black 2 zone 395), grass encounters only, when the player has the National Pokédex
  (Black 2's ZukanWork national flag, PokeDexHaveNational: given by Rowan once 2400 is set), grass slot 6 = work
  0x40F5 and slot 7 = work 0x40F6, each only when non-zero (5 % each: Black 2's grass rates are Pearl's). Pearl reads
  the species from encdata_ex 8 by index; here the works hold the species.
- Spiritomb (Route 209, Chapter 4b's file): pl_GetSpiritombCounter reads PVAR_UG_HIDEAWAY_BATTLES, the battle's end
  sets it to 0 (pl_ClearSpiritombCounter), as Pearl's Reset.
- Route 221's house: pl_GetDailyRandomLevel is a level 2-99 from the date (Pearl's is a random one kept in its save
  and rerolled at midnight); pl_GetPartyMonLevel = Black 2's PokePartyGetParam 158 (0 for an Egg).
- Eterna's Oak house: Oak shows once the Pal Park gate's first scene (frame table PVAR_40C6 == 0, its script 10)
  clears PFLAG_0260 (666).
