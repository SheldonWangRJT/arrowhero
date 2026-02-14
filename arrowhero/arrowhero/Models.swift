import Foundation
import Combine

struct PlayerStats {
    var maxHealth: Int = 100
    var currentHealth: Int = 100
    var damage: Double = 10
    var attackSpeed: Double = 1.0
    var moveSpeed: Int = 220
    var projectileCount: Int = 1
    var pierce: Int = 0
    var critChance: Double = 0.0
}

enum UpgradeID: String, CaseIterable, Hashable {
    case damageUp
    case attackSpeedUp
    case moveSpeedUp
    case extraProjectile
    case pierce
    case critChance
}

struct Upgrade: Identifiable {
    var id: UpgradeID
    var name: String
    var description: String
    var apply: (inout PlayerStats) -> Void
}

func defaultUpgrades() -> [Upgrade] {
    [
        Upgrade(id: .damageUp, name: "Power Shot", description: "+20% damage") { $0.damage *= 1.20 },
        Upgrade(id: .attackSpeedUp, name: "Quick Hands", description: "+20% attack speed") { $0.attackSpeed *= 1.20 },
        Upgrade(id: .moveSpeedUp, name: "Swift Boots", description: "+15% move speed") { $0.moveSpeed = Int(Double($0.moveSpeed) * 1.15) },
        Upgrade(id: .extraProjectile, name: "Forked Arrow", description: "+1 projectile") { $0.projectileCount += 1 },
        Upgrade(id: .pierce, name: "Piercing Shot", description: "Projectiles pierce +1 enemy") { $0.pierce += 1 },
        Upgrade(id: .critChance, name: "Sharpshooter", description: "+10% crit chance") { $0.critChance = min(1.0, $0.critChance + 0.10) },
    ]
}

final class LevelingSystem: ObservableObject {
    @Published private(set) var level: Int = 1
    @Published private(set) var currentXP: Int = 0
    @Published private(set) var xpToNext: Int = 20
    @Published var pendingChoices: [Upgrade] = []

    private let pool = defaultUpgrades()

    func grantXP(_ amount: Int) {
        currentXP += amount
        while currentXP >= xpToNext {
            currentXP -= xpToNext
            levelUp()
        }
    }

    private func levelUp() {
        level += 1
        xpToNext = xpRequirement(for: level)
        pendingChoices = Array(pool.shuffled().prefix(3))
    }

    private func xpRequirement(for level: Int) -> Int {
        20 + Int(Double(level - 1) * 10.0 + pow(Double(level), 1.2))
    }
}

final class GameRunState: ObservableObject {
    @Published var player = PlayerStats()
    @Published var levelSystem = LevelingSystem()
    @Published var isPaused: Bool = false

    func chooseUpgrade(_ upgrade: Upgrade) {
        upgrade.apply(&player)
        levelSystem.pendingChoices = []
    }
}
