import SpriteKit
import SwiftUI
import Combine

final class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var runState: GameRunState?

    // MARK: - State (internal for extensions)
    let player = SKNode()
    var velocity = CGVector(dx: 0, dy: 0)
    var lastUpdate: TimeInterval = 0

    var damageCooldown: TimeInterval = 0

    var spawnTimer: TimeInterval = 0
    var spawnInterval: TimeInterval = 2.0

    var fireCooldown: TimeInterval = 0

    var touchIdentifier: UITouch?
    var joystickOrigin = CGPoint.zero
    let joystickBase = SKShapeNode(circleOfRadius: 40)
    let joystickThumb = SKShapeNode(circleOfRadius: 18)
    var joystickVisible = false

    let hudNode = SKNode()
    let hpBg = SKSpriteNode(color: .white.withAlphaComponent(0.2), size: CGSize(width: 40, height: 3))
    let hpFill = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 3))
    let xpBg = SKSpriteNode(color: .white.withAlphaComponent(0.15), size: CGSize(width: 40, height: 2))
    let xpFill = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 2))

    let enemyCategoryName = "enemy"
    let enemyBoltName = "enemy_bolt"
    let enemyTypeKey = "etype"
    let enemyHPKey = "ehp"
    var enemyFireCooldowns: [SKNode: TimeInterval] = [:]

    let projectileCategoryName = "projectile"

    // MARK: - Scene Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        configureScene()
        AudioManager.playBGM()
    }

    private func configureScene() {
        setupGround()
        configurePlayer()
        configureHUD()
        configureJoystick()
        isPaused = runState?.isPaused ?? false
    }

    private func setupGround() {
        if childNode(withName: "groundLayer") != nil { return }
        let tileTex = PixelAssets.groundTexture()
        let tileSize = CGSize(width: tileTex.size().width * 3.0, height: tileTex.size().height * 3.0)
        let cols = Int(ceil(size.width / tileSize.width)) + 2
        let rows = Int(ceil(size.height / tileSize.height)) + 2
        let originX = -tileSize.width
        let originY = -tileSize.height
        let groundLayer = SKNode()
        groundLayer.name = "groundLayer"
        groundLayer.zPosition = -10
        for r in 0..<rows {
            for c in 0..<cols {
                let spr = SKSpriteNode(texture: tileTex)
                spr.setScale(3.0)
                spr.anchorPoint = CGPoint(x: 0, y: 0)
                spr.position = CGPoint(x: originX + CGFloat(c) * tileSize.width, y: originY + CGFloat(r) * tileSize.height)
                groundLayer.addChild(spr)
            }
        }
        addChild(groundLayer)
    }

    public func restart() {
        lastUpdate = 0
        damageCooldown = 0
        spawnTimer = 0
        fireCooldown = 0
        enemyFireCooldowns.removeAll()

        player.removeAllChildren()
        hudNode.removeAllChildren()
        removeAllActions()
        removeAllChildren()

        touchIdentifier = nil
        joystickVisible = false
        velocity = .zero

        configureScene()
    }

    // MARK: - Update Loop

    override func update(_ currentTime: TimeInterval) {
        guard lastUpdate > 0 else { lastUpdate = currentTime; return }
        let dt = currentTime - lastUpdate
        lastUpdate = currentTime

        if let paused = runState?.isPaused { isPaused = paused }
        if isPaused { return }

        runState?.elapsedTime += dt
        damageCooldown = max(0, damageCooldown - dt)

        // Spawn interval ramp
        let time = runState?.elapsedTime ?? 0
        let t = min(1.0, time / GameConstants.spawnRampDuration)
        spawnInterval = max(
            GameConstants.spawnMinInterval,
            GameConstants.spawnMaxInterval - (GameConstants.spawnMaxInterval - GameConstants.spawnMinInterval) * t
        )

        applyPlayerMovement(dt: dt)
        drawAutoAim()

        spawnTimer += dt
        if spawnTimer >= spawnInterval {
            spawnTimer = 0
            spawnEnemy()
        }

        moveEnemies(dt: dt)
        handleAutoFire(dt)
        updateHUDRatios()

        moveProjectiles(dt: dt)
        moveEnemyBolts(dt: dt)
        handleProjectileCollisions()
        checkEnemyBoltHitPlayer()
    }

    // MARK: - Touches

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchIdentifier == nil, let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard location.x < size.width * 0.5 else { return }

        touchIdentifier = touch
        joystickOrigin = location
        updateVelocity(for: touch)
        joystickBase.position = joystickOrigin
        joystickThumb.position = joystickOrigin
        showJoystick(true)
        updateJoystickThumb(for: touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let id = touchIdentifier, touches.contains(id) else { return }
        updateVelocity(for: id)
        updateJoystickThumb(for: id)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let id = touchIdentifier, touches.contains(id) else { return }
        showJoystick(false)
        touchIdentifier = nil
        velocity = .zero
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    // MARK: - SKPhysicsContactDelegate

    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        guard (maskA & GameConstants.playerCategory != 0 && maskB & GameConstants.enemyCategory != 0) ||
              (maskB & GameConstants.playerCategory != 0 && maskA & GameConstants.enemyCategory != 0)
        else { return }

        applyPlayerDamage(GameConstants.contactDamage)
    }
}
