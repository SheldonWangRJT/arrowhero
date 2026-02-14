import SpriteKit
import UIKit

// MARK: - Player & Joystick

extension GameScene {
    func configurePlayer() {
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)

        let body = SKPhysicsBody(circleOfRadius: GameConstants.playerRadius)
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        body.restitution = 0.3
        body.friction = 0.2
        body.categoryBitMask = GameConstants.playerCategory
        body.collisionBitMask = GameConstants.enemyCategory
        body.contactTestBitMask = GameConstants.enemyCategory
        player.physicsBody = body

        let playerSprite = SKSpriteNode(texture: PixelAssets.playerTexture())
        playerSprite.setScale(3.0)
        playerSprite.zPosition = 10
        player.addChild(playerSprite)

        if player.parent == nil { addChild(player) }
    }

    func configureHUD() {
        hudNode.zPosition = 100
        hudNode.position = CGPoint(x: 0, y: 30)
        if hudNode.parent == nil { player.addChild(hudNode) }

        for node in [hpBg, hpFill, xpBg, xpFill] {
            node.anchorPoint = CGPoint(x: 0, y: 0.5)
        }
        let w: CGFloat = 40
        hpBg.position = CGPoint(x: -w / 2, y: 0)
        hpFill.position = CGPoint(x: -w / 2, y: 0)
        xpBg.position = CGPoint(x: -w / 2, y: -5)
        xpFill.position = CGPoint(x: -w / 2, y: -5)
        hudNode.addChild(hpBg)
        hudNode.addChild(hpFill)
        hudNode.addChild(xpBg)
        hudNode.addChild(xpFill)

        updateHUDRatios()
    }

    func configureJoystick() {
        joystickBase.strokeColor = .clear
        joystickBase.fillColor = .white.withAlphaComponent(0.12)
        joystickBase.alpha = 0
        joystickBase.zPosition = 50
        if joystickBase.parent == nil { addChild(joystickBase) }

        joystickThumb.strokeColor = .clear
        joystickThumb.fillColor = .white.withAlphaComponent(0.5)
        joystickThumb.alpha = 0
        joystickThumb.zPosition = 51
        if joystickThumb.parent == nil { addChild(joystickThumb) }
    }

    func updateHUDRatios() {
        guard let run = runState else { return }
        let hpRatio = CGFloat(max(0, min(1, Double(run.player.currentHealth) / Double(max(1, run.player.maxHealth)))))
        hpFill.xScale = hpRatio
        let xpToNext = max(1, run.levelSystem.xpToNext)
        let xpRatio = CGFloat(max(0, min(1, Double(run.levelSystem.currentXP) / Double(xpToNext))))
        xpFill.xScale = xpRatio
    }

    func applyPlayerMovement(dt: TimeInterval) {
        let speed = CGFloat(runState?.player.moveSpeed ?? 220)
        var targetVel = CGVector(dx: velocity.dx * speed, dy: velocity.dy * speed)
        let inset = GameConstants.worldInset
        if player.position.x <= inset && targetVel.dx < 0 { targetVel.dx = 0 }
        if player.position.x >= size.width - inset && targetVel.dx > 0 { targetVel.dx = 0 }
        if player.position.y <= inset && targetVel.dy < 0 { targetVel.dy = 0 }
        if player.position.y >= size.height - inset && targetVel.dy > 0 { targetVel.dy = 0 }
        player.physicsBody?.velocity = targetVel
        player.position.x = max(inset, min(size.width - inset, player.position.x))
        player.position.y = max(inset, min(size.height - inset, player.position.y))
    }

    func updateVelocity(for touch: UITouch) {
        let location = touch.location(in: self)
        var dx = location.x - joystickOrigin.x
        var dy = location.y - joystickOrigin.y
        let len = max(1, hypot(dx, dy))
        dx /= len
        dy /= len
        velocity = CGVector(dx: dx, dy: dy)
    }

    func drawAutoAim() {
        childNode(withName: "autoAim")?.removeFromParent()
        let isStandingStill = abs(velocity.dx) < 0.001 && abs(velocity.dy) < 0.001
        guard isStandingStill, let target = nearestEnemyPosition() else { return }

        let path = CGMutablePath()
        path.move(to: player.position)
        path.addLine(to: target)
        let lineNode = SKShapeNode(path: path)
        lineNode.name = "autoAim"
        lineNode.strokeColor = .red
        lineNode.lineWidth = 2
        lineNode.zPosition = 10
        addChild(lineNode)
    }

    func showJoystick(_ show: Bool) {
        guard joystickVisible != show else { return }
        joystickVisible = show
        let targetAlpha: CGFloat = show ? 1.0 : 0.0
        joystickBase.run(SKAction.fadeAlpha(to: targetAlpha, duration: 0.15))
        joystickThumb.run(SKAction.fadeAlpha(to: targetAlpha, duration: 0.15))
    }

    func updateJoystickThumb(for touch: UITouch) {
        let location = touch.location(in: self)
        let dx = location.x - joystickOrigin.x
        let dy = location.y - joystickOrigin.y
        let length = CGFloat(hypot(dx, dy))
        let maxRadius: CGFloat = 40
        let clampedLength = min(length, maxRadius)
        let nx = (length > 0) ? (dx / length) : 0
        let ny = (length > 0) ? (dy / length) : 0
        joystickThumb.position = CGPoint(x: joystickOrigin.x + nx * clampedLength, y: joystickOrigin.y + ny * clampedLength)
    }

    var isStandingStill: Bool {
        abs(velocity.dx) < 0.001 && abs(velocity.dy) < 0.001
    }
}
