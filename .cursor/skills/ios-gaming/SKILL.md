---
name: ios-gaming
description: SpriteKit game development, survivor-roguelite patterns, mobile game loops. Use when building iOS games, tuning combat balance, implementing upgrades, spawning, or game feel.
---

# iOS Gaming (SpriteKit + Survivor-Roguelite)

## Survivor-Roguelite Loop
1. Run (1–10 min) → waves spawn over time
2. Combat: auto-attack or tap-to-aim
3. XP on kill → level up → pick 1 of 3 upgrades
4. Milestones: elites at N waves, boss at end
5. Between runs: meta-upgrades, gear, economy

## Stats & Scaling
- **Multiplicative:** damage, attack speed, crit chance (stacking percentages)
- **Additive:** projectile count, pierce, flat bonuses
- Avoid additive for rates (leads to breakpoints); use multiplicative

## Upgrade Design
- 3 random choices per level; duplicates stack
- Rarity affects strength and drop rate
- Examples: +20% damage, +1 projectile, +1 pierce, +10% crit

## Spawner
- Time-based budget; escalate density over time
- Cap max spawns; reduce interval as run progresses
- Enemy mix: Chaser, Ranged, Dasher, Tank (MVP)

## Performance
- 60fps target on iPhone 11+
- Batch sprite creation; reuse nodes
- SKTexture atlases for sprite sheets
- Avoid allocs in update loop

## Game Feel
- Hit pause (brief time scale or freeze)
- Screen shake on crit/boss hit
- Clear telegraphs for enemy attacks (i-frames)
- XP orbs with magnet toward player
