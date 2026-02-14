# arrowhero — Roadmap

Version: 1.0 · Last updated: 2026-02-14

## Milestone 0 (Week 0–1): Planning & Foundations
- [x] Finalize GDD
- [x] Define technical architecture
- [x] Draft analytics schema
- [x] Define economy model

## Milestone 1 (Week 2–4): Core Gameplay MVP
- [x] Player controller (movement with visible joystick, aim/auto-aim)
- [ ] Combat loop (fire rate, damage, collision)
- [ ] Upgrades (at least 6)
  - [x] Damage, Attack Speed, Extra Projectile, Pierce
  - [ ] Crit Chance, Projectile Speed
- [ ] Enemy archetypes (4): Chaser, Ranged, Dasher, Tank
- [x] Spawner (time-based spawn budget)
- [x] Level-up UI (3-card picker + rarity)
- [x] Pause/overlay
- [ ] Basic VFX/SFX
- [x] Auto-fire (stationary) toward nearest enemy
- [ ] **Wiring & Core Loop**
  - [x] Pass GameRunState into GameScene
  - [x] Pause sync, GameScene lifetime, upgrade overlay
  - [x] Grant XP on kill, apply upgrades (attack speed, projectile count, pierce)
  - [ ] Crit (pending)
  - [x] Collision de-duplication
  - [ ] Player damage on contact, i-frames, run end at 0 HP
  - [ ] Minimal HUD: HP bar, XP bar, time survived
  - [ ] Spawn scaling over time

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
