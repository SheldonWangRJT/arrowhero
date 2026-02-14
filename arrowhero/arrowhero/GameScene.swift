import SpriteKit
import SwiftUI
import Combine

// Singleton for run state (paused or running)
final class RunState: ObservableObject {
    static let shared = RunState()
    @Published var isPaused: Bool = false
}

final class GameScene: SKScene {
    weak var runState: GameRunState?

    private let player = SKShapeNode(circleOfRadius: 16)
    private var velocity = CGVector(dx: 0, dy: 0)
    private var lastUpdate: TimeInterval = 0

    // Simple joystick tracking
    private var touchIdentifier: UITouch?
    private var joystickOrigin: CGPoint = .zero
    private let joystickBase = SKShapeNode(circleOfRadius: 40)
    private let joystickThumb = SKShapeNode(circleOfRadius: 18)
    private var joystickVisible: Bool = false

    override func didMove(to view: SKView) {
        backgroundColor = .black

        player.fillColor = .white
        player.strokeColor = .clear
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(player)

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

    override func update(_ currentTime: TimeInterval) {
        // Pause support
        guard lastUpdate > 0 else { lastUpdate = currentTime; return }
        let dt = currentTime - lastUpdate
        lastUpdate = currentTime

        if let paused = runState?.isPaused { self.isPaused = paused }
        if self.isPaused { return }

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
}
