# arrowhero — Technical Architecture

## App Layers
- **SwiftUI Shell:** navigation, overlays (upgrade picker, store), settings
- **Game Layer (SpriteKit):** scene, player, enemies, projectiles, spawner, collision
- **Data Layer:** SwiftData (PlayerProfile, Gear, MetaUpgrades, Inventory, Economy)
- **Services:** StoreKitService, AnalyticsService, RemoteConfig (local JSON in MVP)

## Module Sketch

```swift
protocol AnalyticsService { func log(_ event: String, _ params: [String: Any]) }
protocol StoreService { func purchase(productID: String) async throws }

struct PlayerStats { /* maxHealth, damage, attackSpeed, ... */ }
struct Upgrade { id, rarity, apply() }
struct GearItem { slot, rarity, stats }
struct Economy { prices, rewards }

final class GameRunState: ObservableObject { xp, level, choices, apply upgrade }
final class Spawner { time-based spawn budget }
```
