import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var run: GameRunState
    @State private var scene = GameScene(size: CGSize(width: 750, height: 1334))

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
        .onAppear {
            scene.scaleMode = .resizeFill
            scene.runState = run
            scene.isPaused = run.isPaused
        }
        .onChange(of: run.isPaused) { newValue in
            scene.isPaused = newValue
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameRunState())
}
