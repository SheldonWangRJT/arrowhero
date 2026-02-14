import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var run: GameRunState

    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 750, height: 1334))
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene, options: [.ignoresSiblingOrder])
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: { run.isPaused.toggle() }) {
                        Image(systemName: run.isPaused ? "play.fill" : "pause.fill")
                            .font(.title2)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }

            UpgradeChoiceView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameRunState())
}
