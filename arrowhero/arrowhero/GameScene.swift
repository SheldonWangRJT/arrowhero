import SpriteKit
import SwiftUI
import Combine

final class GameScene: SKScene {
    weak var runState: GameRunState?

    private let player = SKNode()
    private var velocity = CGVector(dx: 0, dy: 0)
    private var lastUpdate: TimeInterval = 0

    // Player damage / i-frames
    private var damageCooldown: TimeInterval = 0
    private let damageIFrame: TimeInterval = 1.0
    private let contactDamage: Int = 10

    // Enemy spawning properties
    private var spawnTimer: TimeInterval = 0
    private var spawnInterval: TimeInterval = 2.0
    private let enemySpeed: CGFloat = 80
    private let enemyCategoryName = "enemy"

    // Projectile properties
    private var fireCooldown: TimeInterval = 0
    private let projectileSpeed: CGFloat = 360
    private let projectileLifetime: TimeInterval = 2.0
    private let projectileCategoryName = "projectile"

    // Simple joystick tracking
    private var touchIdentifier: UITouch?
    private var joystickOrigin: CGPoint = .zero
    private let joystickBase = SKShapeNode(circleOfRadius: 40)
    private let joystickThumb = SKShapeNode(circleOfRadius: 18)
    private var joystickVisible: Bool = false

    // HUD elements (follow player)
    private let hudNode = SKNode()
    private let hpBg = SKSpriteNode(color: .white.withAlphaComponent(0.2), size: CGSize(width: 40, height: 3))
    private let hpFill = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 3))
    private let xpBg = SKSpriteNode(color: .white.withAlphaComponent(0.15), size: CGSize(width: 40, height: 2))
    private let xpFill = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 2))

    override func didMove(to view: SKView) {
        backgroundColor = .black

        player.position = CGPoint(x: size.width/2, y: size.height/2)

        // Background ground tiling
        setupGround()

        // Player sprite
        let playerSprite = SKSpriteNode(texture: PixelAssets.playerTexture())
        playerSprite.setScale(3.0)
        playerSprite.zPosition = 10
        player.addChild(playerSprite)

        addChild(player)

        // Setup HUD bars that follow the player
        hudNode.zPosition = 100
        hudNode.position = CGPoint(x: 0, y: 30)
        player.addChild(hudNode)

        // Configure anchors so scaling the fill adjusts width from left to right
        for node in [hpBg, hpFill, xpBg, xpFill] {
            node.anchorPoint = CGPoint(x: 0, y: 0.5)
        }

        // Position backgrounds and fills centered above player
        let hpWidth: CGFloat = 40
        let xpWidth: CGFloat = 40
        hpBg.position = CGPoint(x: -hpWidth/2, y: 0)
        hpFill.position = CGPoint(x: -hpWidth/2, y: 0)
        xpBg.position = CGPoint(x: -xpWidth/2, y: -5)
        xpFill.position = CGPoint(x: -xpWidth/2, y: -5)

        hudNode.addChild(hpBg)
        hudNode.addChild(hpFill)
        hudNode.addChild(xpBg)
        hudNode.addChild(xpFill)

        // Initialize to current ratios
        let hpRatio = CGFloat(max(0, min(1, Double(runState?.player.currentHealth ?? 0) / Double(runState?.player.maxHealth ?? 1))))
        hpFill.xScale = hpRatio
        let xpRatio = CGFloat(max(0, min(1, Double(runState?.levelSystem.currentXP ?? 0) / Double(runState?.levelSystem.xpToNext == 0 ? 1 : runState?.levelSystem.xpToNext ?? 1))))
        xpFill.xScale = xpRatio

        joystickBase.strokeColor = .clear
        joystickBase.fillColor = .white.withAlphaComponent(0.12)
        joystickBase.alpha = 0
        joystickBase.zPosition = 50
        addChild(joystickBase)

        joystickThumb.strokeColor = .clear
        joystickThumb.fillColor = .white.withAlphaComponent(0.5)
        joystickThumb.alpha = 0
        joystickThumb.zPosition = 51
        addChild(joystickThumb)

        self.isPaused = runState?.isPaused ?? false
    }

    private func setupGround() {
        let tileTex = PixelAssets.groundTexture()
        let tileSize = CGSize(width: tileTex.size().width * 3.0, height: tileTex.size().height * 3.0)
        let cols = Int(ceil(size.width / tileSize.width)) + 2
        let rows = Int(ceil(size.height / tileSize.height)) + 2
        let originX = -tileSize.width
        let originY = -tileSize.height
        let groundLayer = SKNode()
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

    override func update(_ currentTime: TimeInterval) {
        // Pause support
        guard lastUpdate > 0 else { lastUpdate = currentTime; return }
        let dt = currentTime - lastUpdate
        lastUpdate = currentTime

        if let paused = runState?.isPaused { self.isPaused = paused }
        if self.isPaused { return }

        // Update run elapsed time
        runState?.elapsedTime += dt

        // Decrement i-frame cooldown
        damageCooldown = max(0, damageCooldown - dt)

        // Spawn scaling over time (reduce interval from 2.0 to 0.4 over ~3 minutes)
        let time = runState?.elapsedTime ?? 0
        let minInterval: TimeInterval = 0.4
        let maxInterval: TimeInterval = 2.0
        let rampDuration: TimeInterval = 180 // seconds
        let t = min(1.0, time / rampDuration)
        spawnInterval = max(minInterval, maxInterval - (maxInterval - minInterval) * t)

        // Movement
        let speed = CGFloat(runState?.player.moveSpeed ?? 220)
        player.position.x += velocity.dx * speed * dt
        player.position.y += velocity.dy * speed * dt

        // Clamp to scene
        let inset: CGFloat = 20
        player.position.x = max(inset, min(size.width - inset, player.position.x))
        player.position.y = max(inset, min(size.height - inset, player.position.y))

        // Auto-aim placeholder (draw a line or similar)
        drawAutoAim()

        // Spawner
        spawnTimer += dt
        if spawnTimer >= spawnInterval {
            spawnTimer = 0
            spawnEnemy()
        }

        // Move enemies toward player
        moveEnemies(dt: dt)

        // Auto-fire
        handleAutoFire(dt)
        
        // Update HUD bars to reflect current health and XP
        if let run = runState {
            let hpRatio = CGFloat(max(0, min(1, Double(run.player.currentHealth) / Double(max(1, run.player.maxHealth)))))
            hpFill.xScale = hpRatio
            let xpToNext = max(1, run.levelSystem.xpToNext)
            let xpRatio = CGFloat(max(0, min(1, Double(run.levelSystem.currentXP) / Double(xpToNext))))
            xpFill.xScale = xpRatio
        }

        // Move projectiles and handle collisions
        moveProjectiles(dt: dt)
        handleProjectileCollisions()
        checkPlayerEnemyContact()
    }

    // MARK: - Touches (simple joystick on left half)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchIdentifier == nil, let touch = touches.first else { return }
        let location = touch.location(in: self)
        if location.x < size.width * 0.5 {
            touchIdentifier = touch
            joystickOrigin = location
            updateVelocity(for: touch)
            joystickBase.position = joystickOrigin
            joystickThumb.position = joystickOrigin
            showJoystick(true)
            updateJoystickThumb(for: touch)
        }
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

    private func updateVelocity(for touch: UITouch) {
        let location = touch.location(in: self)
        var dx = location.x - joystickOrigin.x
        var dy = location.y - joystickOrigin.y
        let len = max(1, hypot(dx, dy))
        dx /= len
        dy /= len
        velocity = CGVector(dx: dx, dy: dy)
    }

    private func drawAutoAim() {
        // Remove previous aim line
        childNode(withName: "autoAim")?.removeFromParent()

        // Placeholder auto-aim: draw a thin red line from player forward in velocity direction
        if velocity.dx != 0 || velocity.dy != 0 {
            let lineLength: CGFloat = 100
            let endPoint = CGPoint(
                x: player.position.x + velocity.dx * lineLength,
                y: player.position.y + velocity.dy * lineLength
            )
            let path = CGMutablePath()
            path.move(to: player.position)
            path.addLine(to: endPoint)

            let lineNode = SKShapeNode(path: path)
            lineNode.name = "autoAim"
            lineNode.strokeColor = .red
            lineNode.lineWidth = 2
            lineNode.zPosition = 10
            addChild(lineNode)
        }
    }

    private func showJoystick(_ show: Bool) {
        guard joystickVisible != show else { return }
        joystickVisible = show
        let targetAlpha: CGFloat = show ? 1.0 : 0.0
        joystickBase.run(SKAction.fadeAlpha(to: targetAlpha * 1.0, duration: 0.15))
        joystickThumb.run(SKAction.fadeAlpha(to: targetAlpha * 1.0, duration: 0.15))
    }

    private func updateJoystickThumb(for touch: UITouch) {
        let location = touch.location(in: self)
        let dx = location.x - joystickOrigin.x
        let dy = location.y - joystickOrigin.y
        let vector = CGVector(dx: dx, dy: dy)
        let maxRadius: CGFloat = 40
        let length = CGFloat(hypot(vector.dx, vector.dy))
        let clampedLength = min(length, maxRadius)
        let nx = vector.dx / max(1, length)
        let ny = vector.dy / max(1, length)
        let thumbPos = CGPoint(x: joystickOrigin.x + nx * clampedLength, y: joystickOrigin.y + ny * clampedLength)
        joystickThumb.position = thumbPos
    }

    private func spawnEnemy() {
        // Spawn at a random edge
        let margin: CGFloat = 30
        let side = Int.random(in: 0..<4) // 0: left, 1: right, 2: bottom, 3: top
        var pos = CGPoint.zero
        switch side {
        case 0: pos = CGPoint(x: -margin, y: CGFloat.random(in: 0...size.height))
        case 1: pos = CGPoint(x: size.width + margin, y: CGFloat.random(in: 0...size.height))
        case 2: pos = CGPoint(x: CGFloat.random(in: 0...size.width), y: -margin)
        default: pos = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height + margin)
        }

        let node = SKSpriteNode(texture: PixelAssets.slimeTexture())
        node.setScale(3.0)
        node.name = enemyCategoryName
        node.position = pos
        node.zPosition = 5
        addChild(node)
    }

    private func moveEnemies(dt: TimeInterval) {
        enumerateChildNodes(withName: enemyCategoryName) { node, _ in
            guard let enemy = node as? SKShapeNode else {
                let toPlayer = CGVector(dx: self.player.position.x - node.position.x, dy: self.player.position.y - node.position.y)
                let len = max(1, hypot(toPlayer.dx, toPlayer.dy))
                let nx = toPlayer.dx / len
                let ny = toPlayer.dy / len
                node.position.x += nx * self.enemySpeed * CGFloat(dt)
                node.position.y += ny * self.enemySpeed * CGFloat(dt)
                return
            }
            let toPlayer = CGVector(dx: self.player.position.x - enemy.position.x, dy: self.player.position.y - enemy.position.y)
            let len = max(1, hypot(toPlayer.dx, toPlayer.dy))
            let nx = toPlayer.dx / len
            let ny = toPlayer.dy / len
            enemy.position.x += nx * self.enemySpeed * CGFloat(dt)
            enemy.position.y += ny * self.enemySpeed * CGFloat(dt)
        }
    }

    private func nearestEnemyPosition() -> CGPoint? {
        var nearest: CGPoint? = nil
        var bestDist: CGFloat = .greatestFiniteMagnitude
        enumerateChildNodes(withName: enemyCategoryName) { node, _ in
            let dx = node.position.x - self.player.position.x
            let dy = node.position.y - self.player.position.y
            let d2 = dx*dx + dy*dy
            if d2 < bestDist {
                bestDist = d2
                nearest = node.position
            }
        }
        return nearest
    }

    private func handleAutoFire(_ dt: TimeInterval) {
        fireCooldown -= dt
        let attackRate = runState?.player.attackSpeed ?? 1.0 // attacks per second
        let interval = max(0.05, 1.0 / attackRate)

        // Only fire when the player is standing still (no joystick input)
        let isStandingStill = (abs(velocity.dx) < 0.001 && abs(velocity.dy) < 0.001)
        if !isStandingStill { return }

        if fireCooldown <= 0 {
            guard let targetPos = nearestEnemyPosition() else { return }
            let count = max(1, runState?.player.projectileCount ?? 1)
            fireProjectiles(toward: targetPos, count: count)
            fireCooldown = interval
        }
    }

    private func fireProjectiles(toward target: CGPoint, count: Int) {
        let from = player.position
        let baseAngle = atan2(target.y - from.y, target.x - from.x)
        let spread: CGFloat = count > 1 ? .pi / 24 : 0 // ~7.5 degrees total spread
        let startAngle = baseAngle - spread * CGFloat(count - 1) / 2
        for i in 0..<count {
            let angle = startAngle + spread * CGFloat(i)
            let dir = CGVector(dx: cos(angle), dy: sin(angle))
            let node = SKSpriteNode(texture: PixelAssets.arrowTexture())
            node.setScale(3.0)
            node.name = projectileCategoryName
            node.position = from
            node.zPosition = 6
            node.zRotation = angle
            node.userData = [
                "vx": dir.dx * projectileSpeed,
                "vy": dir.dy * projectileSpeed,
                "ttl": projectileLifetime,
                "pierce": runState?.player.pierce ?? 0
            ]
            addChild(node)
        }
    }

    private func moveProjectiles(dt: TimeInterval) {
        enumerateChildNodes(withName: projectileCategoryName) { node, _ in
            guard let data = node.userData else { return }
            let vx = data["vx"] as? CGFloat ?? 0
            let vy = data["vy"] as? CGFloat ?? 0
            var ttl = data["ttl"] as? TimeInterval ?? 0
            node.position.x += vx * CGFloat(dt)
            node.position.y += vy * CGFloat(dt)
            ttl -= dt
            if ttl <= 0 {
                node.removeFromParent()
            } else {
                data["ttl"] = ttl
            }
        }
    }

    private func uniqueNodes(_ nodes: [SKNode]) -> [SKNode] {
        var seen = Set<ObjectIdentifier>()
        var result: [SKNode] = []
        for node in nodes {
            let id = ObjectIdentifier(node)
            if !seen.contains(id) {
                seen.insert(id)
                result.append(node)
            }
        }
        return result
    }

    private func handleProjectileCollisions() {
        var enemiesToRemove: [SKNode] = []
        var projectilesToRemove: [SKNode] = []

        enumerateChildNodes(withName: projectileCategoryName) { [unowned self] pNode, _ in
            guard let data = pNode.userData else { return }
            var pierceRemaining = data["pierce"] as? Int ?? (self.runState?.player.pierce ?? 0)
            var shouldRemoveProjectile = false

            self.enumerateChildNodes(withName: self.enemyCategoryName) { eNode, stop in
                let dx = pNode.position.x - eNode.position.x
                let dy = pNode.position.y - eNode.position.y
                let dist2 = dx*dx + dy*dy
                if dist2 < 16*16 { // hit radius ~16
                    self.hitVFX(at: eNode.position)
                    enemiesToRemove.append(eNode)
                    if pierceRemaining > 0 {
                        pierceRemaining -= 1
                        data["pierce"] = pierceRemaining
                    } else {
                        projectilesToRemove.append(pNode)
                        shouldRemoveProjectile = true
                        stop.pointee = true
                    }
                }
            }

            if shouldRemoveProjectile {
                // Projectile will be removed after we finish enumerating
            }
        }

        let uniqueEnemies = uniqueNodes(enemiesToRemove)
        let uniqueProjectiles = uniqueNodes(projectilesToRemove)

        // Remove nodes
        for node in uniqueProjectiles { node.removeFromParent() }
        for node in uniqueEnemies { node.removeFromParent() }

        // Grant XP for each enemy killed
        if !uniqueEnemies.isEmpty {
            let xpPerKill = 5
            runState?.levelSystem.grantXP(xpPerKill * uniqueEnemies.count)
        }
    }

    private func checkPlayerEnemyContact() {
        guard damageCooldown == 0 else { return }
        var tookDamage = false
        enumerateChildNodes(withName: enemyCategoryName) { node, stop in
            let dx = node.position.x - self.player.position.x
            let dy = node.position.y - self.player.position.y
            let dist2 = dx*dx + dy*dy
            if dist2 < 20*20 { // contact radius ~20
                tookDamage = true
                stop.pointee = true
            }
        }

        if tookDamage, let run = runState {
            run.player.currentHealth = max(0, run.player.currentHealth - contactDamage)
            damageCooldown = damageIFrame

            // Brief flash feedback
            let flash = SKAction.sequence([
                .fadeAlpha(to: 0.2, duration: 0.05),
                .fadeAlpha(to: 1.0, duration: 0.15)
            ])
            player.run(flash)

            if run.player.currentHealth == 0 {
                self.isPaused = true
                run.isPaused = true
            }
        }
    }

    private func hitVFX(at point: CGPoint) {
        let frames = PixelAssets.hitSparkTextures()
        guard let first = frames.first else { return }
        let spr = SKSpriteNode(texture: first)
        spr.zPosition = 20
        spr.position = point
        spr.setScale(3.0)
        addChild(spr)
        let anim = SKAction.animate(with: frames, timePerFrame: 0.05)
        spr.run(.sequence([anim, .removeFromParent()]))
    }
}

