# arrowhero — Quick Context

> Survivor-roguelite iOS game inspired by Arrow Legend / Archero. SpriteKit + SwiftUI.

## Structure
```
arrowhero/
├── arrowhero/arrowhero.xcodeproj    # Xcode project
├── arrowhero/arrowhero/             # App source
│   ├── ArrowSurvivorApp.swift       # @main, GameRunState
│   ├── ContentView.swift           # Root UI, GameScene embed, overlays
│   ├── GameScene.swift             # SpriteKit: player, enemies, projectiles, spawner
│   ├── UpgradeChoiceView.swift     # 3-card level-up picker
│   ├── Models.swift                # PlayerStats, Upgrade, LevelingSystem, GameRunState
│   └── SpinComponent.swift         # (check usage)
├── arrowhero/PixelArtKit.swift      # Shared pixel-art helpers
├── .vscode/                        # Cursor debug config (launch, tasks)
├── build.sh                        # xcodebuild -sdk iphonesimulator
└── docs/                           # ROADMAP, PRODUCT_PLAN, ART_STYLE, ARCHITECTURE
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
| damage | 10 | Power Shot +20% |
| attackSpeed | 1.0 | Quick Hands +20% |
| moveSpeed | 220 | Swift Boots +15% |
| projectileCount | 1 | Forked Arrow +1 |
| pierce | 0 | Piercing Shot +1 |
| critChance | 0 | Sharpshower +10% |

## Build & Run
- **Build**: `./build.sh` or `xcodebuild -scheme arrowhero -sdk iphonesimulator -arch arm64 build`
- **Debug in Cursor**: F5 → "arrowhero (iOS Simulator)" (needs CodeLLDB + iOS Debug extensions)
- **Xcode**: `open arrowhero/arrowhero.xcodeproj`

## Key Files to Edit
- **Combat, spawns, player controller**: `GameScene.swift`
- **Upgrades, level-up logic**: `Models.swift`, `UpgradeChoiceView.swift`
- **Main UI, overlays**: `ContentView.swift`
- **Art style, palette**: `ART_STYLE.md`, `PixelArtKit.swift`

## MVP Status (from docs/ROADMAP.md)
- [x] Player controller, joystick, auto-aim, auto-fire
- [x] Upgrade system, level-up picker, apply at runtime (damage, attack speed, projectile count, pierce)
- [x] Spawner, pause sync, GameScene lifetime
- [ ] Player damage on contact, run end at 0 HP
- [ ] HUD: HP bar, XP bar, time survived
- [ ] Crit handling, spawn scaling
