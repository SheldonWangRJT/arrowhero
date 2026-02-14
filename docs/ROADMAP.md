# arrowhero — Roadmap

Version: 1.2 · Last updated: 2026-02-14

## Milestone 0 (Week 0–1): Planning & Foundations
- [x] Finalize GDD
- [x] Define technical architecture
- [x] Draft analytics schema
- [x] Define economy model

## Milestone 1 (Week 2–4): Core Gameplay MVP
- [x] Player controller (movement with visible joystick, aim/auto-aim)
- [x] Combat loop (fire rate, damage, collision)
- [x] Upgrades (at least 6)
  - [x] Damage, Attack Speed, Extra Projectile, Pierce
  - [x] Crit Chance (Sharpshooter)
  - [ ] Projectile Speed
- [x] Enemy archetypes (5): Chaser (slime), Ranged (cultist), Tank (bug), Dasher, Bat
- [x] Spawner (time-based spawn budget)
- [x] Level-up UI (overlay with 3 cards, pixel icons, fixed sizing)
- [x] Pause/overlay
- [x] Basic VFX (hit sparks, crit variant)
- [ ] SFX
- [x] Auto-fire (stationary) toward nearest enemy
- [x] **Wiring & Core Loop**
  - [x] Pass GameRunState into GameScene
  - [x] Pause sync, GameScene lifetime, upgrade overlay
  - [x] Grant XP on kill, apply upgrades (attack speed, projectile count, pierce, crit)
  - [x] Crit handling
  - [x] Collision de-duplication
  - [x] Player damage on contact, i-frames, run end at 0 HP
  - [x] Minimal HUD: HP bar, XP bar, time survived (debug + game-over)
  - [x] Spawn scaling over time (2.0s → 0.4s over 3 min)
  - [x] Restart button (scene.restart, no freeze)
  - [x] SpriteKit physics (enemies push apart, no overlap)

## Milestone 2 (Week 5–6): Systems & Content
- [ ] Expand upgrades to 18+ total
- [ ] 10 enemy types total
- [ ] 1 boss (multi-phase)
- [ ] Gear system (weapon, armor, charm)
- [ ] Meta-upgrades (tree UI + persistence)
- [ ] Run summary screen
- [ ] XP orbs + magnet collection
- [ ] Run summary (time survived, enemies defeated)

## Milestone 3 (Week 7–8): Monetization & Polish
- [ ] StoreKit 2 integration
- [ ] Gem sinks (reroll, revive, fuse speed-up)
- [ ] Store UI
- [ ] Tutorial & FTUE polish
- [ ] Difficulty tuning, 60fps performance pass

## Milestone 4 (Week 9–10): Beta & Soft Launch
- [ ] TestFlight
- [ ] A/B configs, analytics, crash monitoring
- [ ] ASO assets, App Store metadata
- [ ] Privacy & age rating review

## Next Moves & Retention (thinking ahead)

**Concern:** Pure endless scoring (survive until death) may not be user-retaining. It’s easy to give up when:
- There’s no clear “win” or goal beyond time survived
- Progress feels unrewarding after a run ends
- Players ask “Why keep going?” with no milestones

**Ideas to explore (not decided):**
- **Wave-based structure** — e.g. 5 waves, mini-boss at wave 5; clear checkpoint feeling
- **Run cap + boss** — e.g. 10 min cap, boss at end; run feels complete rather than “I died”
- **Milestones & rewards** — “Survive 2 min” → unlock, “First level 5” → reward; short-term goals
- **Daily / session goals** — “Kill 50 enemies today,” “Reach level 3 twice”; gives reason to return
- **Meta-progression hooks** — Gold, meta-upgrades, gear that persists; death becomes “progress toward next build”
- **Hero select** — Use hero2/hero3; variety per run increases engagement

These are product direction notes, not commitments. Validate with playtests before investing.

## Post-Launch
- [ ] New biome every 4–6 weeks
- [ ] Weekly events, balance patches
- [ ] New gear and upgrades cadence
