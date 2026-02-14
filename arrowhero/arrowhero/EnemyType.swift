import SpriteKit

/// Enemy archetype: texture, HP, speed, and AI behavior.
enum EnemyType: Int, CaseIterable {
    case slime = 0
    case cultist = 1
    case bugTank = 2
    case dasher = 3
    case bat = 4

    var texture: SKTexture {
        switch self {
        case .slime: PixelAssets.slimeTexture()
        case .cultist: PixelAssets.cultistTexture()
        case .bugTank: PixelAssets.bugTankTexture()
        case .dasher: PixelAssets.dasherTexture()
        case .bat: PixelAssets.batTexture()
        }
    }

    var hp: Int {
        switch self {
        case .slime, .cultist: 3
        case .bugTank: 6
        case .dasher: 2
        case .bat: 1
        }
    }

    var speedMultiplier: CGFloat {
        switch self {
        case .slime: 1.0
        case .cultist: 1.0
        case .bugTank: 0.6
        case .dasher: 1.6
        case .bat: 1.25
        }
    }

    var isRanged: Bool {
        self == .cultist
    }

    /// Weighted random spawn (slime/cultist common, bug/dasher/bat rarer).
    static func randomForSpawn() -> EnemyType {
        let roll = Int.random(in: 0..<12)
        switch roll {
        case 0..<4: return .slime
        case 4..<7: return .cultist
        case 7..<9: return .bugTank
        case 9..<11: return .dasher
        default: return .bat
        }
    }

}
