import SpriteKit
import SwiftUI
import Combine

// Singleton for run state (paused or running)
final class RunState: ObservableObject {
    static let shared = RunState()
    @Published var isPaused: Bool = false
}

final class GameScene: SKScene {
    private let player = SKShapeNode(circleOfRadius: 16)
    private var velocity = CGVector(dx: 0, dy: 0)
    private var lastUpdate: TimeInterval = 0

    // Simple joystick tracking
    private var touchIdentifier: UITouch?
    private var joystickOrigin: CGPoint = .zero

    override func didMove(to view: SKView) {
        backgroundColor = .black

        player.fillColor = .white
        player.strokeColor = .clear
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(player)
    }

    override func update(_ currentTime: TimeInterval) {
        // Pause support
        if RunState.shared.isPaused {
            lastUpdate = currentTime
            return
        }

        guard lastUpdate > 0 else { lastUpdate = currentTime; return }
        let dt = currentTime - lastUpdate
        lastUpdate = currentTime

        // Movement
        let speed: CGFloat = 220
        player.position.x += velocity.dx * speed * dt
        player.position.y += velocity.dy * speed * dt

        // Clamp to scene
        let inset: CGFloat = 20
        player.position.x = max(inset, min(size.width - inset, player.position.x))
        player.position.y = max(inset, min(size.height - inset, player.position.y))

        // Auto-aim placeholder (draw a line or similar)
        drawAutoAim()
    }

    // MARK: - Touches (simple joystick on left half)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchIdentifier == nil, let touch = touches.first else { return }
        let location = touch.location(in: self)
        if location.x < size.width * 0.5 {
            touchIdentifier = touch
            joystickOrigin = location
            updateVelocity(for: touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let id = touchIdentifier, touches.contains(id) else { return }
        updateVelocity(for: id)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let id = touchIdentifier, touches.contains(id) else { return }
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
}
