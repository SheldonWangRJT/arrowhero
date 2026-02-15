import SpriteKit

// MARK: - Player Damage & VFX

extension GameScene {
    /// Apply damage to the player (contact, bolt, etc.). Respects i-frames.
    func applyPlayerDamage(_ amount: Int) {
        guard damageCooldown == 0 else { return }
        guard let run = runState else { return }

        run.player.currentHealth = max(0, run.player.currentHealth - amount)
        damageCooldown = GameConstants.damageIFrame
        AudioManager.play(.playerHit, on: self)

        let flash = SKAction.sequence([
            .fadeAlpha(to: 0.2, duration: 0.05),
            .fadeAlpha(to: 1.0, duration: 0.15)
        ])
        player.run(flash)

        if run.player.currentHealth == 0 {
            isPaused = true
            run.isPaused = true
            run.isGameOver = true
        }
    }

    func hitVFX(at point: CGPoint) {
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
