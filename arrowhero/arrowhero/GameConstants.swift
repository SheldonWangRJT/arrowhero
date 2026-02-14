import CoreGraphics
import Foundation

/// Centralized game tuning constants.
enum GameConstants {
    // MARK: - Physics
    static let playerCategory: UInt32 = 0b1
    static let enemyCategory: UInt32 = 0b10
    static let playerRadius: CGFloat = 14
    static let enemyRadius: CGFloat = 12

    // MARK: - Player Damage
    static let contactDamage: Int = 8
    static let boltDamage: Int = 10
    static let damageIFrame: TimeInterval = 1.0

    // MARK: - Projectiles
    static let projectileSpeed: CGFloat = 360
    static let projectileLifetime: TimeInterval = 2.0
    static let hitRadiusSquared: CGFloat = 16 * 16  // hit radius ~16
    static let critMultiplier: Double = 2.0

    // MARK: - Enemies
    static let enemyBaseSpeed: CGFloat = 80
    static let enemyRange: CGFloat = 220
    static let enemyBoltSpeed: CGFloat = 200
    static let enemyBoltLifetime: TimeInterval = 3.0
    static let enemyFireCooldown: TimeInterval = 1.2

    // MARK: - Spawning
    static let spawnMargin: CGFloat = 30
    static let spawnMinInterval: TimeInterval = 0.4
    static let spawnMaxInterval: TimeInterval = 2.0
    static let spawnRampDuration: TimeInterval = 180

    // MARK: - Progression
    static let xpPerKill: Int = 12

    // MARK: - Bounds
    static let worldInset: CGFloat = 20
}
