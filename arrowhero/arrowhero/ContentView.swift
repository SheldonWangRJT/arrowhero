import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var run: GameRunState
    @State private var scene = GameScene(size: CGSize(width: 750, height: 1334))
    @State private var showDebug = false
    
    private func timeString(from t: TimeInterval) -> String {
        let seconds = Int(t.rounded())
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
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
                    Button(action: { showDebug.toggle() }) {
                        Image(systemName: showDebug ? "ladybug.fill" : "ladybug")
                            .font(.title2)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding()
                Spacer()
            }
            
            if showDebug {
                VStack(alignment: .leading, spacing: 8) {
                    // HP bar
                    ProgressView(value: Double(run.player.currentHealth), total: Double(run.player.maxHealth))
                        .progressViewStyle(.linear)
                        .tint(.red)
                        .frame(maxWidth: 300)
                        .padding(6)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))

                    // XP bar + Level
                    HStack(spacing: 8) {
                        ProgressView(value: Double(run.levelSystem.currentXP), total: Double(run.levelSystem.xpToNext))
                            .progressViewStyle(.linear)
                            .tint(.blue)
                        Text("Lv \(run.levelSystem.level)")
                            .font(.caption)
                            .monospacedDigit()
                    }
                    .frame(maxWidth: 300)
                    .padding(6)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))

                    // Time survived
                    Text(timeString(from: run.elapsedTime))
                        .font(.caption)
                        .monospacedDigit()
                        .padding(6)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            UpgradeChoiceView()
            
            if run.isGameOver {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Run Over")
                        .font(.largeTitle)
                        .bold()
                    Text("Time: \(timeString(from: run.elapsedTime))")
                        .font(.headline)
                        .monospacedDigit()
                    HStack(spacing: 12) {
                        Button("Restart") {
                            run.resetRun()
                            run.isPaused = false
                            scene.restart()
                            scene.runState = run
                            scene.isPaused = false
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Exit") {
                            // For now, just reset and pause; could navigate to a menu later
                            run.resetRun()
                            scene.isPaused = true
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .frame(maxWidth: 400)
            }
        }
        .onAppear {
            scene.scaleMode = .resizeFill
            scene.runState = run
            scene.isPaused = run.isPaused
        }
        .onChange(of: run.isPaused) { oldValue, newValue in
            scene.isPaused = newValue
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameRunState())
}
