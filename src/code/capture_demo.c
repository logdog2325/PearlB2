/* Pearl's catching tutorial (Route 202) in Black 2's capture demo: small helpers in ITCM, linked by b2tools/itcm.py.
 * patches/capture_demo.py has the hook sites; Black 2 functions are called by address.
 *
 * CaptureDemo_Parties   ov012 EventCaptureDemo_Create: the two parties, as Pearl's (pokediamond sub_02047814,
 *                       pokeplatinum FieldBattleDTO_NewCatchingTutorial): the counterpart's starter (the one left in
 *                       the briefcase: PVAR_STARTER Turtwig -> Piplup, Chimchar -> Turtwig, Piplup -> Chimchar) Lv 5,
 *                       a wild Bidoof Lv 2, both with their level-up moves, not shiny, random IVs and PID. Returns
 *                       Bidoof (the caller's wild species for the encounter's music and effect).
 * CaptureDemo_UsedMove  ov167 the demo's first turn: "<starter> used <its first move>!" (Black 2: always Tackle)
 * CaptureDemo_MoveParam ... and its animation: returns PML_MoveGetParam(move, 27) in r0, the move in r1
 * CaptureDemo_WildHit   Bidoof's Tackle hits the starter (Black 2: Purrloin's Growl lowers Attack)
 * CaptureDemo_WildHitDone  ... waits for the hit and the HP bar
 * CaptureDemo_Line      the two lines of system text 23 (btlv_core): lines 0-1 Dawn's (a boy's counterpart), 2-3
 *                       Lucas's (a girl's): the player's trainer type 0/1 in the battle view picks the pair. */
typedef unsigned short u16;
typedef unsigned int u32;
typedef int s32;
typedef unsigned long long u64;

#define FN(type, addr) ((type)((addr) | 1))
/* arm9 */
#define GameData_GetEventWork     FN(void *(*)(void *), 0x02017394)
#define EventWork_GetWkPtr        FN(u16 *(*)(void *, u32), 0x02019294)
#define PokeParty_CreateTempPkm   FN(void (*)(void *, u32, u32, u32, u32), 0x0201c448)  /* u64 id: r3 low, [sp] high */
#define PokeParty_AddPkm          FN(u32 (*)(void *, void *), 0x0201fd6c)
#define PML_MoveGetParam          FN(u32 (*)(u32, u32), 0x02021280)
#define GFL_MsgDataLoadStrbuf     FN(void (*)(void *, u32, void *), 0x02048838)
/* ov167 (battle) */
#define MoveGetID                 FN(u16 (*)(void *, u32), 0x021bacc0)
#define GetBattleMonStat          FN(u32 (*)(void *, u32), 0x021bb1b4)
#define BtlvCore_ViewMon          FN(void *(*)(void *, u32), 0x021ceec0)   /* func_ov167_021ceec0 */
#define BtlvCore_UsedMoveMsg      FN(void (*)(void *, u32, u32), 0x021d02cc) /* func_ov167_021d02cc */
#define BtlvCore_PlaySE           FN(void (*)(void *, u32), 0x021d0ad4)     /* func_ov167_021d0ad4 */
#define BtlvScu_HitDone           FN(u32 (*)(void *), 0x021d31d0)           /* func_ov167_021d31d0 */
/* ov168 (battle view) */
#define BtlvEffect_StartDamage    FN(void (*)(u32, u32), 0x021df560)
#define BtlvEffect_CalcGaugeHP    FN(void (*)(u32, s32), 0x021dfac4)
#define BtlvEffect_GetTrainerType FN(u32 (*)(u32), 0x021e0118)

#define SPECIES_TURTWIG  387
#define SPECIES_CHIMCHAR 390
#define SPECIES_PIPLUP   393
#define SPECIES_BIDOOF   399
#define MOVE_TACKLE      33
#define ID_NOT_SHINY_HI  0xffffffff     /* PKM_ID_NOT_SHINY = 0xffffffff00000000 */
#define CORE_SCU         0x1c0          /* BtlvCore.scu */
#define STAT_MAX_HP      14
#define SE_HIT           0x564          /* the demo's own hit sound (case 7) */

u32 CaptureDemo_Parties(void *pkm, void *party, void *enemy, void *gameData) {
    u32 s = *EventWork_GetWkPtr(GameData_GetEventWork(gameData), PVAR_STARTER);
    u32 mon = s == SPECIES_TURTWIG ? SPECIES_PIPLUP : s == SPECIES_CHIMCHAR ? SPECIES_TURTWIG : SPECIES_CHIMCHAR;
    PokeParty_CreateTempPkm(pkm, mon, 5, 0, ID_NOT_SHINY_HI);
    PokeParty_AddPkm(party, pkm);
    PokeParty_CreateTempPkm(pkm, SPECIES_BIDOOF, 2, 0, ID_NOT_SHINY_HI);
    PokeParty_AddPkm(enemy, pkm);
    return SPECIES_BIDOOF;
}

static u32 starter_move(void *core) {
    return MoveGetID(BtlvCore_ViewMon(core, 0), 0);
}

void CaptureDemo_UsedMove(void *core, u32 monId) {
    BtlvCore_UsedMoveMsg(core, monId, starter_move(core));
}

u64 CaptureDemo_MoveParam(void *core) {
    u32 move = starter_move(core);
    return PML_MoveGetParam(move, 27) | (u64)move << 32;
}

void CaptureDemo_WildHit(void *core) {
    u32 max = GetBattleMonStat(BtlvCore_ViewMon(core, 0), STAT_MAX_HP), d = max >> 3;
    BtlvEffect_CalcGaugeHP(0, max - (d ? d : 1));
    BtlvEffect_StartDamage(0, MOVE_TACKLE);
    BtlvCore_PlaySE(core, SE_HIT);
}

u32 CaptureDemo_WildHitDone(void *core) {
    return BtlvScu_HitDone(*(void **)((char *)core + CORE_SCU));
}

void CaptureDemo_Line(void *msg, u32 line, void *strbuf) {
    GFL_MsgDataLoadStrbuf(msg, line + ((BtlvEffect_GetTrainerType(0) & 1) << 1), strbuf);
}
