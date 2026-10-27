# Sinnoh's music in Black 2 (started 2026-10-18)

User's choice: Sinnoh's own songs by default; a start-of-game choice of Black 2's music (with Rowan's questions, later).
Reference: HoennB2 notes/MUSIC.md (Black 2's sound archive, players, sound heap; read-only).

## How
- Pearl's songs are already in the DS sound format (SSEQ/SBNK/SWAR), but they share big instrument archives (field
  songs: bank 1001 over wave archives 1000 + 1001, ~500 KB) that Pearl keeps loaded. Black 2 loads a song's
  sequence + bank + wave archives together (~282 KB free per song, HoennB2's measurement) and stores each song with
  its own bank/archive. `b2tools/pearl_music.py` trims a Pearl song to what it plays (its programs, their
  instruments, only their waves, renumbered into one archive); the sequence is unchanged.
- Sizes (`python3 b2tools/pearl_music.py`): with whole instruments, 78 of the 80 songs fit the estimate (most
  120-220 KB) and SEQ_ROAD_F_D/N (Routes 210, 211 East, 214, 215) was ~291 KB.
- **Measured in game** (2026-10-18, `b2tools/hwtest/music_mem.py`, DeSmuME muted): with Twinleaf's SEQ_TOWN01_D
  (217 KB) playing, Black 2's sound heap had 584,460 of 643,008 bytes used, **58,548 free**. So a song may be about
  275 KB at most; Route 210's 291 KB would not fit.
- **Key-level trimming** (2026-10-18): drum sets and key splits hold one sample per key or key range, and a song
  plays only a few. `pearl_music.trim` now keeps only the samples of the notes the song plays (it follows every
  track's notes with its current instrument and transpose); a region no note reaches stays in place but points at a
  sample already kept. All 77 songs: **12.6 MB -> 6.5 MB**; the biggest is now SEQ_ROAD_F_N at **161 KB** (Route 210
  fits with ~110 KB to spare). Checked: for all 11,213 (instrument, key) pairs the 77 songs play, the trimmed bank
  gives the same sample bytes and the same settings as Pearl's. A song whose tracks use random/variable/condition
  commands or open tracks mid-song would keep every sample (none of the 77 does).
- **Measured again in game** with the trimmed songs (2026-10-18, `fish_shot.py ... HEAP` in Twinleaf): 474,220 of
  643,008 bytes used, **168,788 free** (was 58,548). The biggest song (161 KB) therefore fits with room to spare.
- `b2tools/patches/sinnoh_music.py` (after sinnoh_world/sinnoh_rooms): the 52 day themes the installed zones use go in
  as new sequences 4.. with new banks / wave archives (Black 2's empty ids), files appended (SDAT 89.4 -> 97.7 MB);
  every Sinnoh zone's bgm0-3 = its song (Pearl's SEQ_DUMMY "keep playing" -> the parent zone's song); mapping in
  work/world/music.json. Offline dry run: Twinleaf -> SEQ_TOWN01_D. Each new entry also takes ~76 B of sound heap
  (INFO + FAT), ~4 KB in all.

- **Night themes** (sinnoh_music.apply_code): the night versions go in too (77 songs in all, SDAT 89.4 -> 102.0 MB);
  Black 2's DecideZoneHeaderBGMID (arm9 0x02018968) long-jumps to src/code/night_music.c in ITCM (192 B), which plays
  Pearl's night theme in Black 2's NIGHT and MIDNIGHT day periods (25 day/night pairs). Shared tool:
  `b2tools/itcm.py` (compile, HoennB2's ELF linker, append to ITCM and move the arena literal at arm9 0x0207B400).
  Checked offline: the jump bytes, the ITCM growth, the compiled code.

- **Story songs** (2026-10-18): the 12 songs Pearl's scripts start themselves (PlayMusic/SetBGM across all 446 zone
  script files: Barry's SEQ_THE_RIV, Lucas/Dawn SEQ_THE_BOY/GIRL, "follow me" SEQ_TSURETEKE, Rowan's
  SEQ_THE_EVENT01-03, SEQ_SILENCE_DUNGEON, SEQ_OPENING2, SEQ_FUE, SEQ_D_SAFARI, SEQ_D_RYAYHY; 3-108 KB each) go in with
  the zone songs (sinnoh_music EVENT_SONGS). The translated scripts play `SEQ_PEARL_<name>` when the build ran
  sinnoh_music before `scripts`/`sinnoh_story` (the ids reach the assembler through the PEARL_MUSIC_EVENTS
  environment variable, `patches/scripts.py` defines()); otherwise Black 2's stand-ins. Checked: the Lake Verity
  scene assembles both ways and only the song ids differ.

## Battle music (2026-10-25; user: "it should be Pearl's, and same for any other unique Gen 4 battle track")
Rules: data/battle_music.json; patch: b2tools/patches/battle_music.py (after music_choice); code: the decomp's
src/pearlb2/battle_music_itcm.c (branch pearlb2-music). `python3 b2tools/patches/battle_music.py` prints the table.
- **Pearl's rules** (pokediamond): the class -> encounter-music table (arm9/asm/unk_0204AB0C.s UNK_020F4718, 78
  classes, any other class SEQ_EYE_KID); the class -> battle music (unk_02047500.s sub_020475C0 + UNK_020F457E: Gym
  Leaders SEQ_BA_GYM, Elite Four SEQ_BA_TENNO, Cynthia SEQ_BA_CHANP, Barry SEQ_BA_RIVAL, grunts SEQ_BA_GINGA,
  commanders SEQ_BA_GINGA3, Cyrus SEQ_BA_AKAGI, others SEQ_BA_TRAIN); the wild music by species (sub_02047668: Uxie,
  Mesprit, Azelf SEQ_BA_DPOKE1; Dialga, Palkia SEQ_BA_DPOKE2; Rotom, Heatran, Regigigas, Giratina, Darkrai
  SEQ_BA_SECRET2; Arceus SEQ_BA_SECRET1; others SEQ_BA_POKE); the victory by the first opponent's class (overlay 11:
  leaders SEQ_WINTGYM, Elite Four SEQ_WINTENNO, Cynthia SEQ_WINCHAMP, grunts and commanders SEQ_WINGINGA, Cyrus
  SEQ_WINAKAGI (the same notes as WINGINGA, installed once), others SEQ_WINTRAIN; wild SEQ_WINPOKE). Pearl's Elite Four
  battle (BA_TENNO) is the Gym Leader theme note for note. Not built: Pearl's trainer music for a double battle
  against a non-Galactic class (no story double battle has a leader, the Elite Four, Cynthia or Barry as opponent).
- **Black 2's way** (pokebw2): eye contact = GetTrainerClassEyeBGMID (TRAINER_CLASS_RESOURCES) from the scripts'
  TrainerBGMPlayPush (the eye-contact script global_3000), TrainerClassBGMPlayPush and TrainerBGMPlay; battle =
  EventBattleCall_DecideEnvWild / _DecideEnvTrainer (ov036 enceff.c: SPECIAL_TRAINER_BGM by class group, species
  overrides) from ov012 event_battle.c; victory = btl_setup.c BtlSetup_LoadTrainer by class group (WIN1 wild, WIN2
  trainers, WIN3 leaders and Elite Four, WIN4-6 Plasma and Champion), played through GetWinBGM (ov167). Black 2 also
  changes its leader song at the leader's last Pokemon (btl_client.c, SEQ 0x47b) and plays SEQ_BGM_BATTLEPINCH at low
  HP (btlv_gauge.c); the BGM stack frees a pushed song's waves, so one song's waves are in the sound heap at a time.
- **Installed**: 35 Pearl songs (34 sequences; the biggest SEQ_BA_CHANP 143,712 B trimmed, budget 282,000); the decomp
  calls PearlB2_EyeBGM / PearlB2_DecideEnvWild / PearlB2_DecideEnvTrainer / PearlB2_WinBGM in place of Black 2's
  (same-size call changes) and the leader's last-Pokemon change happens only over Black 2's own SEQ_BGM_VS_GYMLEADER.
  The tables (per Black 2 class: Sinnoh's and Black 2's song for eye contact, battle, victory; per species) are in ITCM
  at gPearlB2BattleMusic. Scripts: Pearl's PlayTrainerEncounterBGM (the Elite Four and Cynthia rooms) ->
  pl_PlayTrainerEncounterBGM (TrainerBGMPlay).
- **Black 2's music** (bit 13 = 0): the eye-contact songs per class, trainer and wild battles and their victories are
  Black 2's own; Gym Leaders and the Elite Four VS_DP_LEADER, Cynthia VS_DP_CHAMP (the PWT remixes), her encounter
  E_SHIRONA (Pearl's EYE_CHAMP melody, 0.97), the lake trio VS_UMA and the legendaries VS_DPLEGEND (Black 2's own
  versions of Pearl's tracks: the same notes, 1.00); victories WIN3 (leaders, Elite Four) and WIN5 (Champion). Pearl's
  in both modes: Team Galactic (eye contact, battle, victory), Cyrus, Barry's battle, the Elite Four's encounter,
  Dialga/Palkia, Arceus.
- check_waits (battle_music.py): every pair both ways (471): all these songs loop on both sides.
- **Tested in game** (2026-10-25, DeSmuME muted; the playing sequence read from the GFL BGM stack, 0x0209da74 /
  0x0209da7c + 28 x level, +4; logs in work/agents/music/shots/bgm_*.log; this build's ids: Pearl's battle songs
  90-123): Sinnoh's music: Valley Windworks grunt (eye contact) 93 SEQ_EYE_GINGA -> 112 SEQ_BA_GINGA -> 120
  SEQ_WINGINGA -> the zone's 60; Roark 106 SEQ_BA_GYM through his last Pokemon (no change of song) -> 118
  SEQ_WINTGYM; Route 202 wild Shinx 105 SEQ_BA_POKE -> 116 SEQ_WINPOKE. Black 2's music: the same grunt 93 -> 112 ->
  120 (Pearl's) over the zone's Black 2 song 1195. Sound heap free in those battles: 160-180 KB.

## Open
- Fanfares (Pearl's jingles): Black 2's own for now.
- Black 2's low-HP song (SEQ_BGM_BATTLEPINCH) still replaces the battle song at red HP with Sinnoh's music too (Pearl
  keeps its battle song and beeps): a question for the user.
- The Black 2 music option (Rowan's question) and checking every place where Black 2 waits for a song to end
  (HoennB2's v16 freeze: a looping song where the game waits for a jingle; HoennB2 b2tools check_waits).
- In-game listening test of the trimmed songs and the night themes: next full build.
