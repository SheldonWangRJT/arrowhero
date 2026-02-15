# arrowhero — Technical Architecture

## App Layers
- **SwiftUI Shell:** navigation, overlays (upgrade picker, store), settings
- **Game Layer (SpriteKit):** scene, player, enemies, projectiles, spawner, collision
- **Audio Layer:** AudioManager (SFX via AVAudioPlayer, BGM looping)
- **Data Layer:** SwiftData (future); Models.swift (PlayerStats, Upgrade, LevelingSystem, GameRunState)
- **Services:** StoreKitService, AnalyticsService (future); RemoteConfig (local JSON in MVP)

## Module Sketch

```swift
// Core
struct PlayerStats { maxHealth, damage, attackSpeed, moveSpeed, projectileCount, pierce, critChance }
struct Upgrade { id: UpgradeID, name, description, apply(inout PlayerStats) }
enum EnemyType { slime, cultist, bugTank, dasher, bat }  // texture, hp, speedMultiplier, isRanged

final class GameRunState: ObservableObject { player, levelSystem, isPaused, isGameOver, elapsedTime }
final class LevelingSystem: ObservableObject { level, currentXP, xpToNext, pendingChoices, grantXP }

// GameScene extensions
GameScene+Player      // configurePlayer, applyMovement, drawAutoAim, handleAutoFire
GameScene+Enemies    // spawnEnemy, moveEnemies (chase/ranged AI), nearestEnemyPosition
GameScene+Projectiles // fireArrow, moveProjectiles, moveEnemyBolts, handleCollisions
GameScene+Damage     // applyPlayerDamage, grantXPOnKill, gameOver

// Audio
enum AudioManager { play(Sound), playBGM(), stopBGM() }
// Sounds: hit_01, shot_01, explosion, plop_01, key_open_01, hit_02 (CAF); bgm_electronic (MP3)

// Future
protocol AnalyticsService { func log(_ event: String, _ params: [String: Any]) }
protocol StoreService { func purchase(productID: String) async throws }
struct GearItem { slot, rarity, stats }
```

## Build Output
- **App:** `arrowhero.app` (Debug-iphonesimulator)
- **Run:** `xcrun simctl install booted <path>.app && xcrun simctl launch booted sdw.arrowhero`
