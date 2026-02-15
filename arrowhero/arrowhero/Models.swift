import Foundation
import Combine

struct PlayerStats {
    var maxHealth: Int = 120
    var currentHealth: Int = 120
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
    @Published private(set) var xpToNext: Int = 10  // 10 XP to reach level 2 (1–2 kills)
    @Published var pendingChoices: [Upgrade] = []
    @Published var presentingLevel: Int? = nil
    private(set) var queuedLevelUps: Int = 0

    private let pool = defaultUpgrades()

    func grantXP(_ amount: Int) {
        currentXP += amount
        // Accumulate level-ups
        while currentXP >= xpToNext {
            currentXP -= xpToNext
            level += 1
            xpToNext = xpRequirement(for: level)
            queuedLevelUps += 1
        }
        // If not currently presenting choices, present one now
        if pendingChoices.isEmpty, queuedLevelUps > 0 {
            queuedLevelUps -= 1
            presentChoices()
        }
    }

    private func presentChoices() {
        presentingLevel = level
        pendingChoices = Array(pool.shuffled().prefix(3))
    }

    func presentNextIfNeeded() {
        if pendingChoices.isEmpty, queuedLevelUps > 0 {
            queuedLevelUps -= 1
            presentChoices()
        } else if pendingChoices.isEmpty {
            presentingLevel = nil
        }
    }

    private func xpRequirement(for level: Int) -> Int {
        // Gentler curve: 10, 18, 26, 34... (+8 per level) so early levels feel rewarding
        10 + (level - 1) * 8
    }
}

final class GameRunState: ObservableObject {
    @Published var player = PlayerStats()
    @Published var levelSystem = LevelingSystem()
    @Published var isPaused: Bool = false
    @Published var isGameOver: Bool = false
    @Published var elapsedTime: TimeInterval = 0

    func chooseUpgrade(_ upgrade: Upgrade) {
        upgrade.apply(&player)
        // Level-up reward: heal 25% of max HP (min 15)
        let healAmount = max(15, player.maxHealth / 4)
        player.currentHealth = min(player.maxHealth, player.currentHealth + healAmount)
        levelSystem.pendingChoices = []
        levelSystem.presentNextIfNeeded()
    }

    func resetRun() {
        player = PlayerStats()
        levelSystem = LevelingSystem()
        isPaused = false
        elapsedTime = 0
        isGameOver = false
    }
}
