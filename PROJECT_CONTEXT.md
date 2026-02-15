# arrowhero — Quick Context

> Survivor-roguelite iOS game inspired by Arrow Legend / Archero. SpriteKit + SwiftUI.

## Structure
```
arrowhero/
├── arrowhero/arrowhero.xcodeproj    # Xcode project
├── arrowhero/arrowhero/             # App source
│   ├── ArrowSurvivorApp.swift       # @main, GameRunState, AVAudioSession
│   ├── ContentView.swift            # Root UI, GameScene embed, overlays
│   ├── GameScene.swift              # SpriteKit: player, spawner, scene lifecycle
│   ├── GameScene+Player.swift       # Movement, joystick, auto-aim, auto-fire
│   ├── GameScene+Enemies.swift      # Spawn, AI (chase/ranged), move
│   ├── GameScene+Projectiles.swift  # Arrows, enemy bolts, collisions
│   ├── GameScene+Damage.swift       # Player damage, i-frames, XP, game over
│   ├── UpgradeChoiceView.swift      # 3-card level-up picker (overlay)
│   ├── Models.swift                # PlayerStats, Upgrade, LevelingSystem, GameRunState
│   ├── AudioManager.swift           # SFX + BGM (AVAudioPlayer)
│   ├── EnemyType.swift              # Slime, Cultist, Bug Tank, Dasher, Bat
│   ├── GameConstants.swift         # Tunables (damage, spawn, etc.)
│   ├── Sounds/                      # SFX (.caf), BGM (bgm_electronic.mp3)
│   └── SpinComponent.swift          # (check usage)
├── arrowhero/PixelArtKit.swift      # Pixel art textures (hero, enemies, projectiles)
├── .vscode/                         # Cursor debug config (launch, tasks)
├── build.sh                         # xcodebuild -sdk iphonesimulator
└── docs/                            # ROADMAP, PRODUCT_PLAN, ART_STYLE, ARCHITECTURE
```

## Core Flow
1. **GameRunState** (@main) holds `PlayerStats`, `LevelingSystem`, pause, game-over.
2. **ContentView** embeds `GameScene` (SpriteKit), shows pause/upgrade overlays.
3. **GameScene** reads `runState.player` (moveSpeed, attackSpeed, projectileCount, pierce), runs combat loop.
4. On enemy kill → `grantXP(5)` → level up → **UpgradeChoiceView** (3-of-6 random picks).
5. Chosen upgrade → `chooseUpgrade()` → `apply(&player)` → stats update in real time.

## Player Stats (Models.swift)
| Stat | Default | Upgrades |
|------|---------|----------|
| maxHealth | 120 | — |
| damage | 10 | Power Shot +20% |
| attackSpeed | 1.0 | Quick Hands +20% |
| moveSpeed | 220 | Swift Boots +15% |
| projectileCount | 1 | Forked Arrow +1 |
| pierce | 0 | Piercing Shot +1 |
| critChance | 0 | Sharpshooter +10% |

XP: 12 per kill; 10 XP to level 2, +8 per level. Level-up heal: 25% max HP.

## Build & Run
- **Build**: `./build.sh` or `xcodebuild -scheme arrowhero -sdk iphonesimulator -arch arm64 build`
- **Debug in Cursor**: F5 → "arrowhero (iOS Simulator)" (needs CodeLLDB + iOS Debug extensions)
- **Xcode**: `open arrowhero/arrowhero.xcodeproj`

## Key Files to Edit
- **Combat, spawns, player controller**: `GameScene.swift` + `GameScene+*.swift`
- **Upgrades, level-up logic**: `Models.swift`, `UpgradeChoiceView.swift`
- **Main UI, overlays**: `ContentView.swift`
- **Audio**: `AudioManager.swift`; add SFX to `Sounds/` (CAF), BGM (MP3)
- **Art style, palette**: `docs/ART_STYLE.md`, `PixelArtKit.swift`

## MVP Status (from docs/ROADMAP.md)
- [x] Player controller, joystick, auto-aim, auto-fire
- [x] Upgrade system, level-up picker, apply at runtime (damage, attack speed, projectile count, pierce, crit)
- [x] Spawner, pause sync, GameScene lifetime
- [x] Player damage on contact (8), i-frames, run end at 0 HP
- [x] HUD: HP bar, XP bar, time survived
- [x] Crit handling, spawn scaling (2.0s → 0.4s over 3 min)
- [x] Restart button, SpriteKit physics (no enemy overlap)
- [x] SFX (hit, shot, explosion, xp, level-up, player hit)
- [x] BGM (Electronic Synth, looping)
- [x] Hero walk animation (3-frame leg cycle)
