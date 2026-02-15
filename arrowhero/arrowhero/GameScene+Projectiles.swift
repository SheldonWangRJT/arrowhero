import SpriteKit

// MARK: - Projectiles & Bolts

extension GameScene {
    func handleAutoFire(_ dt: TimeInterval) {
        fireCooldown -= dt
        let attackRate = runState?.player.attackSpeed ?? 1.0
        let interval = max(0.05, 1.0 / attackRate)

        guard isStandingStill else { return }

        if fireCooldown <= 0 {
            guard let targetPos = nearestEnemyPosition() else { return }
            let count = max(1, runState?.player.projectileCount ?? 1)
            fireProjectiles(toward: targetPos, count: count)
            fireCooldown = interval
        }
    }

    func fireProjectiles(toward target: CGPoint, count: Int) {
        let from = player.position
        let baseAngle = atan2(target.y - from.y, target.x - from.x)
        let spread: CGFloat = count > 1 ? .pi / 24 : 0
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
                "vx": dir.dx * GameConstants.projectileSpeed,
                "vy": dir.dy * GameConstants.projectileSpeed,
                "ttl": GameConstants.projectileLifetime,
                "pierce": runState?.player.pierce ?? 0,
                "dmg": 1
            ]
            addChild(node)
        }
        AudioManager.play(.shot, on: self)
    }

    func moveProjectiles(dt: TimeInterval) {
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

    func moveEnemyBolts(dt: TimeInterval) {
        enumerateChildNodes(withName: enemyBoltName) { node, _ in
            guard let data = node.userData else { return }
            let vx = data["vx"] as? CGFloat ?? 0
            let vy = data["vy"] as? CGFloat ?? 0
            var ttl = data["ttl"] as? TimeInterval ?? 0
            node.position.x += vx * CGFloat(dt)
            node.position.y += vy * CGFloat(dt)
            ttl -= dt
            if ttl <= 0 { node.removeFromParent() } else { data["ttl"] = ttl }
        }
    }

    func handleProjectileCollisions() {
        var enemiesToRemove: [SKNode] = []
        var projectilesToRemove: [SKNode] = []

        enumerateChildNodes(withName: projectileCategoryName) { [unowned self] pNode, _ in
            guard let data = pNode.userData else { return }
            var pierceRemaining = data["pierce"] as? Int ?? (runState?.player.pierce ?? 0)
            var shouldRemoveProjectile = false

            enumerateChildNodes(withName: enemyCategoryName) { eNode, stop in
                let dx = pNode.position.x - eNode.position.x
                let dy = pNode.position.y - eNode.position.y
                let dist2 = dx * dx + dy * dy
                guard dist2 < GameConstants.hitRadiusSquared else { return }

                let baseDamage = (data["dmg"] as? Int) ?? 1
                let isCrit = Double.random(in: 0...1) < (runState?.player.critChance ?? 0)
                let appliedDamage = isCrit ? Int(Double(baseDamage) * GameConstants.critMultiplier) : baseDamage

                hitVFX(at: eNode.position)
                AudioManager.play(.hit, on: self)
                if isCrit { hitVFX(at: eNode.position) }

                var ehp = (eNode.userData?[enemyHPKey] as? Int) ?? 1
                ehp = max(0, ehp - appliedDamage)
                eNode.userData?[enemyHPKey] = ehp

                if ehp <= 0 { enemiesToRemove.append(eNode) }

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

        let uniqueEnemies = uniqueNodes(enemiesToRemove)
        let uniqueProjectiles = uniqueNodes(projectilesToRemove)

        for enemy in uniqueEnemies { enemyFireCooldowns[enemy] = nil }
        for node in uniqueProjectiles { node.removeFromParent() }
        for node in uniqueEnemies { node.removeFromParent() }

        if !uniqueEnemies.isEmpty {
            AudioManager.play(.explosion, on: self)
            runState?.levelSystem.grantXP(GameConstants.xpPerKill * uniqueEnemies.count)
        }
    }

    func checkEnemyBoltHitPlayer() {
        var toRemove: [SKNode] = []
        enumerateChildNodes(withName: enemyBoltName) { [self] bolt, _ in
            let dx = bolt.position.x - player.position.x
            let dy = bolt.position.y - player.position.y
            if dx * dx + dy * dy < GameConstants.hitRadiusSquared {
                toRemove.append(bolt)
                applyPlayerDamage(GameConstants.boltDamage)
            }
        }
        for n in toRemove { n.removeFromParent() }
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

    func fireEnemyBolt(from: CGPoint, toward: CGPoint) {
        let angle = atan2(toward.y - from.y, toward.x - from.x)
        let dir = CGVector(dx: cos(angle), dy: sin(angle))
        let bolt = SKSpriteNode(texture: PixelAssets.boltTexture())
        bolt.setScale(3.0)
        bolt.name = enemyBoltName
        bolt.position = from
        bolt.zPosition = 6
        bolt.zRotation = angle
        bolt.userData = [
            "vx": dir.dx * GameConstants.enemyBoltSpeed,
            "vy": dir.dy * GameConstants.enemyBoltSpeed,
            "ttl": GameConstants.enemyBoltLifetime
        ]
        addChild(bolt)
    }
}
