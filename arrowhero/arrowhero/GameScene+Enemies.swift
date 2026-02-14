import SpriteKit

// MARK: - Enemy Spawning & AI

extension GameScene {
    func spawnEnemy() {
        let margin = GameConstants.spawnMargin
        let side = Int.random(in: 0..<4)
        let pos: CGPoint
        switch side {
        case 0: pos = CGPoint(x: -margin, y: CGFloat.random(in: 0...size.height))
        case 1: pos = CGPoint(x: size.width + margin, y: CGFloat.random(in: 0...size.height))
        case 2: pos = CGPoint(x: CGFloat.random(in: 0...size.width), y: -margin)
        default: pos = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height + margin)
        }

        let enemyType = EnemyType.randomForSpawn()
        let node = SKSpriteNode(texture: enemyType.texture)
        node.setScale(3.0)
        node.name = enemyCategoryName
        node.position = pos
        node.zPosition = 5
        node.userData = [enemyTypeKey: enemyType.rawValue, enemyHPKey: enemyType.hp]

        let body = SKPhysicsBody(circleOfRadius: GameConstants.enemyRadius)
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        body.restitution = 0.2
        body.friction = 0.3
        body.categoryBitMask = GameConstants.enemyCategory
        body.collisionBitMask = GameConstants.playerCategory | GameConstants.enemyCategory
        body.contactTestBitMask = GameConstants.playerCategory
        node.physicsBody = body

        addChild(node)
    }

    func moveEnemies(dt: TimeInterval) {
        let range = GameConstants.enemyRange
        let baseSpeed = GameConstants.enemyBaseSpeed

        enumerateChildNodes(withName: enemyCategoryName) { node, _ in
            guard let enemy = node as? SKSpriteNode else { return }
            let toPlayer = CGVector(dx: self.player.position.x - enemy.position.x, dy: self.player.position.y - enemy.position.y)
            let dist = max(1, hypot(toPlayer.dx, toPlayer.dy))
            let nx = toPlayer.dx / dist
            let ny = toPlayer.dy / dist

            guard let etypeInt = enemy.userData?[self.enemyTypeKey] as? Int,
                  let enemyType = EnemyType(rawValue: etypeInt) else {
                enemy.physicsBody?.velocity = CGVector(dx: nx * baseSpeed, dy: ny * baseSpeed)
                return
            }

            if enemyType.isRanged {
                if dist > range * 0.9 {
                    enemy.physicsBody?.velocity = CGVector(dx: nx * baseSpeed, dy: ny * baseSpeed)
                } else {
                    enemy.physicsBody?.velocity = .zero
                }
                let cd = self.enemyFireCooldowns[enemy] ?? 0
                if cd <= 0, dist <= range {
                    self.fireEnemyBolt(from: enemy.position, toward: self.player.position)
                    self.enemyFireCooldowns[enemy] = GameConstants.enemyFireCooldown
                } else {
                    self.enemyFireCooldowns[enemy] = max(0, cd - dt)
                }
            } else {
                let speed = baseSpeed * enemyType.speedMultiplier
                enemy.physicsBody?.velocity = CGVector(dx: nx * speed, dy: ny * speed)
            }
        }
    }

    func nearestEnemyPosition() -> CGPoint? {
        var nearest: CGPoint?
        var bestDist: CGFloat = .greatestFiniteMagnitude
        enumerateChildNodes(withName: enemyCategoryName) { [self] node, _ in
            let dx = node.position.x - self.player.position.x
            let dy = node.position.y - self.player.position.y
            let d2 = dx * dx + dy * dy
            if d2 < bestDist {
                bestDist = d2
                nearest = node.position
            }
        }
        return nearest
    }
}
