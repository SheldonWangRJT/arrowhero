# Arrow Survivor — Product Plan

Version: 1.0  
Owner: Product + Engineering  
Last updated: 2026-02-13

## 1. Vision & Goals
- Build a fast, satisfying survivor-roguelite mobile game inspired by Arrow Legend/Archero: short sessions, deep build variety, and strong upgrade dopamine.
- Monetize ethically via optional gem purchases for cosmetics, time-savers, and rerolls without pay-to-win walls.
- Ship an MVP in 8–10 weeks, then iterate weekly with events, new gear, and balance patches.

### Success Metrics (90-day post-launch)
- D1 retention ≥ 35%, D7 ≥ 12%, D30 ≥ 4%
- Tutorial completion ≥ 85%
- ARPDAU ≥ $0.10; Conversion rate ≥ 2.5%
- Crash-free sessions ≥ 99.5%

## 2. Target Platforms & Tech
- Platform: iOS first (iOS 16+), later Android (if applicable)
- Engine: SpriteKit + SwiftUI shell
- Persistence: SwiftData (or Core Data) + CloudKit for iCloud sync (optional phase 2)
- IAP: StoreKit 2
- Analytics: App Analytics + lightweight in-house events (phase 1), add third-party later if needed

## 3. Core Game Loop
1) Enter run (1–10 minutes target length)  
2) Fight waves spawning over time; auto-attack or tap-to-aim  
3) Gain XP → Level up → Choose 1 of 3 upgrades  
4) Every N waves: mini-boss or elite  
5) Collect gold/gems; finish run (death or boss clear)  
6) Between runs: spend gold on meta-upgrades, unlock gear, quests

## 4. MVP Scope
- 1 biome (Forest) with 10–15 minutes survivability cap
- 10 enemy types + 2 elites + 1 boss
- 18–24 upgrades (common/rare/epic) with stackable effects
- 1 hero with 1 passive, 1 active ultimate (cooldown based)
- Basic gear system (3 slots: weapon, armor, charm) with 3 rarity tiers
- Meta-upgrade tree (5–8 nodes): HP, Damage, Attack Speed, Magnet Radius, Move Speed
- IAP: 3 gem packs + starter bundle + ad-free option (optional)
- Tutorial (90–120 seconds), soft onboarding

## 5. Systems Design

### 5.1 Player Stats
- Health, Damage, AttackSpeed, MoveSpeed, ProjectileCount, Pierce, CritChance, CritDamage, MagnetRadius
- Scaling rules: multiplicative for rates, additive for counts/flat bonuses

### 5.2 Upgrades (During Run)
- Examples:
  - Power Shot: +20% Damage
  - Quick Hands: +20% Attack Speed
  - Forked Arrow: +1 Projectile
  - Piercing Shot: +1 Pierce
  - Sharpshooter: +10% Crit Chance
  - Heavy Quiver: +30% Projectile Speed
  - Ricochet: Arrows bounce to 2 additional targets (-15% damage per bounce)
  - Explosive Tips: 20% chance to create small AoE on hit
  - Guardian Orbs: 2 rotating shields that damage nearby enemies
- Rarity affects strength and appearance rate; duplicates stack.

### 5.3 Gear (Out of Run)
- Slots: Weapon (projectile archetype), Armor (defense/regen), Charm (utility)
- Rarities: Common, Rare, Epic
- Progression: fuse duplicates to upgrade rarity (uses gold + gems for speed-up)

### 5.4 Meta Upgrades (Account-wide)
- Linear tree of 8 nodes, each with 5 levels; costs gold (soft) + occasional gem unlocks
- Example nodes: Max HP, Base Damage, Attack Speed, Magnet Radius, Move Speed, Luck (upgrade quality), Gold Gain

### 5.5 Enemies & Bosses
- Enemy archetypes: Chaser, Dasher, Ranged, Tank, Splitter, Spawner, Mine, Swarm, Shielded, Healer
- Boss patterns: telegraphed AoE, bullet-hell cones, dashes; 2–3 phases
- Difficulty curve: spawn density and type mix increase by time survived

### 5.6 Run Structure
- 10-minute hard cap (MVP) with escalating spawn budget each minute
- Milestones at minutes 3/6/9: elites; minute 10: boss

## 6. Economy & Monetization

### Currencies
- Gold (soft): earned per run, used for meta-upgrades and gear fusing
- Gems (premium): IAP, used for rerolls, extra inventory, cosmetic effects, time-savers

### IAP Catalog (MVP)
- Gem Pack S: $1.99 (200 gems)
- Gem Pack M: $4.99 (600 gems + 10% bonus)
- Gem Pack L: $9.99 (1300 gems + 15% bonus)
- Starter Bundle: $2.99 (300 gems + exclusive charm skin + ad-free banner)
- Optional: Ad-Free: $3.99 (removes interstitials; rewarded ads still available)

### Gem Sinks
- Upgrade Reroll (level-up choices): 30 gems
- Extra revive (once per run): 100 gems
- Gear fuse speed-up: 20–50 gems
- Cosmetic unlocks: 200–800 gems

### Ads (Optional MVP)
- Rewarded: double gold at end of run; 1 revive per run if no gems
- No interstitials in MVP to protect retention (evaluate later)

### Safeguards
- No paywalls for core progression; gems accelerate but don’t unlock exclusive power
- Daily caps for revives/rerolls to prevent P2W perception

## 7. Content Roadmap

### Milestone 0 (Week 0–1): Planning & Foundations
- [x] Finalize GDD
- [x] Define technical architecture
- [x] Draft analytics schema
- [x] Define economy model

### Milestone 1 (Week 2–4): Core Gameplay MVP
- [x] Player controller (movement with visible joystick, aim/auto-aim)
- [ ] Combat loop (fire rate, damage, collision)
- [ ] Upgrades (at least 6)
  - [ ] Damage, Attack Speed, Extra Projectile, Pierce, Crit Chance, Projectile Speed
- [ ] Enemy archetypes (4)
  - [ ] Chaser
  - [ ] Ranged
  - [ ] Dasher
  - [ ] Tank
- [x] Spawner (time-based spawn budget)
- [x] Level-up UI (3-card picker + rarity)
- [x] Pause/overlay
- [ ] Basic VFX/SFX
- [x] Auto-fire (stationary) toward nearest enemy

### Milestone 2 (Week 5–6): Systems & Content
- [ ] Expand upgrades to 18+ total
- [ ] Add enemies to 10 types total
- [ ] Implement 1 boss (multi-phase)
- [ ] Gear system (3 slots: weapon, armor, charm)
- [ ] Meta-upgrades (tree UI + persistence)
- [ ] Run summary screen (stats, rewards)
- [ ] Player health & damage (enemy contact damage, run end)
- [ ] XP orbs on enemy death + magnet collection
- [ ] Apply upgrade effects in runtime (damage, crit, pierce)
- [ ] Simple run summary (time survived, enemies defeated)

### Milestone 3 (Week 7–8): Monetization & Polish
- [ ] StoreKit 2 integration (products, purchase, restore)
- [ ] Gem sinks (reroll, revive, fuse speed-up)
- [ ] Store UI (pricing clarity, starter bundle)
- [ ] Tutorial & FTUE polish
- [ ] Difficulty tuning pass
- [ ] Performance pass (60fps target on iPhone 11+)

### Milestone 4 (Week 9–10): Beta & Soft Launch
- [ ] TestFlight build & distribution
- [ ] A/B configs (local JSON)
- [ ] Analytics dashboards & crash monitoring
- [ ] ASO assets (screens, video, icon)
- [ ] App Store page metadata
- [ ] Privacy & age rating review

### Post-Launch (Ongoing)
- [ ] New biome every 4–6 weeks
- [ ] Weekly events
- [ ] Balance patches
- [ ] New gear and upgrades cadence

## 8. Analytics & Telemetry

### Core Events
- session_start/session_end
- tutorial_start/tutorial_complete
- run_start/run_end (duration, cause_of_end, boss_reached)
- level_up (level, offered_upgrades, chosen_upgrade)
- upgrade_reroll (count, currency_spent)
- enemy_kill (type), boss_kill
- iap_view, iap_purchase (product_id, price_tier)
- meta_upgrade_purchase (node_id, level)

### KPIs
- Retention: D1/D7/D30
- Monetization: ARPDAU, conversion, LTV
- Engagement: avg run duration, levels per run, upgrade pick rates

## 9. Technical Architecture (High-Level)

### App Layers
- SwiftUI Shell: navigation, overlays (upgrade picker, store), settings
- Game Layer (SpriteKit): scene, player, enemies, projectiles, spawner, collision
- Data Layer: SwiftData models (PlayerProfile, Gear, MetaUpgrades, Inventory, Economy)
- Services: StoreKitService, AnalyticsService, RemoteConfig (local JSON in MVP)

### Suggested Module Sketch
```swift
// Services
protocol AnalyticsService { func log(_ event: String, _ params: [String: Any]) }
protocol StoreService { func purchase(productID: String) async throws }

// Data Models (simplified)
struct PlayerStats { /* as discussed earlier */ }
struct Upgrade { /* id, rarity, apply() */ }
struct GearItem { /* slot, rarity, stats */ }
struct Economy { /* prices, rewards */ }

// Game Flow
final class RunState: ObservableObject { /* xp, level, choices, apply upgrade */ }
final class Spawner { /* time-based spawn budget */ }



