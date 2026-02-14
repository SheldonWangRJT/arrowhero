# Arrow Survivor — Product Plan

Version: 1.0 · Owner: Product + Engineering · Last updated: 2026-02-13

## 1. Vision & Goals
- Fast, satisfying survivor-roguelite mobile game inspired by Arrow Legend/Archero.
- Short sessions, deep build variety, strong upgrade dopamine.
- Ethical monetization: optional gems for cosmetics, time-savers, rerolls—no pay-to-win walls.
- Ship MVP in 8–10 weeks; iterate weekly.

### Success Metrics (90-day post-launch)
- D1 ≥ 35%, D7 ≥ 12%, D30 ≥ 4%
- Tutorial completion ≥ 85%
- ARPDAU ≥ $0.10; Conversion ≥ 2.5%
- Crash-free sessions ≥ 99.5%

## 2. Target Platforms & Tech
- **Platform:** iOS first (iOS 16+), later Android
- **Engine:** SpriteKit + SwiftUI shell
- **Persistence:** SwiftData / Core Data + CloudKit (phase 2)
- **IAP:** StoreKit 2
- **Analytics:** App Analytics + in-house events

## 3. Core Game Loop
1. Enter run (1–10 min)
2. Fight waves; auto-attack or tap-to-aim
3. XP → Level up → Choose 1 of 3 upgrades
4. Every N waves: mini-boss or elite
5. Collect gold/gems; finish run (death or boss clear)
6. Between runs: meta-upgrades, gear, quests

## 4. MVP Scope
- 1 biome (Forest), 10–15 min cap
- 10 enemy types, 2 elites, 1 boss
- 18–24 upgrades (stackable)
- 1 hero, 1 passive + 1 active ultimate
- Gear: 3 slots (weapon, armor, charm), 3 rarities
- Meta-upgrade tree (5–8 nodes)
- IAP: 3 gem packs + starter bundle + ad-free (optional)
- Tutorial 90–120 sec

## 5. Systems Design

### 5.1 Player Stats
Health, Damage, AttackSpeed, MoveSpeed, ProjectileCount, Pierce, CritChance, CritDamage, MagnetRadius. Multiplicative for rates; additive for counts.

### 5.2 Upgrades (During Run)
Power Shot, Quick Hands, Forked Arrow, Piercing Shot, Sharpshooter, Heavy Quiver, Ricochet, Explosive Tips, Guardian Orbs. Rarity affects strength; duplicates stack.

### 5.3 Gear (Out of Run)
Weapon / Armor / Charm. Fuse duplicates to upgrade rarity.

### 5.4 Meta Upgrades
Linear tree, 8 nodes × 5 levels. Gold + occasional gem unlocks.

### 5.5 Enemies & Bosses
Chaser, Dasher, Ranged, Tank, Splitter, Spawner, Mine, Swarm, Shielded, Healer. Boss: telegraphed patterns, 2–3 phases. Difficulty scales with time.

### 5.6 Run Structure
10-min cap; milestones at 3/6/9 min (elites), 10 min (boss).

## 6. Economy & Monetization

**Currencies:** Gold (soft), Gems (premium IAP)

**IAP:** Gem Packs S/M/L; Starter Bundle; Ad-Free optional.

**Gem Sinks:** Reroll (30), Revive (100), Fuse speed-up (20–50), Cosmetics (200–800).

**Ads:** Rewarded only (optional MVP); no interstitials.

**Safeguards:** No paywalls; daily caps for revives/rerolls.

## 8. Analytics & Telemetry

**Events:** session_start/end, tutorial_*, run_start/end, level_up, upgrade_reroll, enemy_kill, boss_kill, iap_*, meta_upgrade_purchase.

**KPIs:** D1/D7/D30 retention; ARPDAU, conversion, LTV; avg run duration, levels per run, upgrade pick rates.
