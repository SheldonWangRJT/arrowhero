# arrowhero — Roadmap

Version: 1.1 · Last updated: 2026-02-14

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
- [x] Enemy archetypes (2): Chaser (slime), Ranged (cultist)
- [ ] Enemy archetypes (4 total): Dasher, Tank
- [x] Spawner (time-based spawn budget)
- [x] Level-up UI (3-card picker + rarity)
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

## Post-Launch
- [ ] New biome every 4–6 weeks
- [ ] Weekly events, balance patches
- [ ] New gear and upgrades cadence
