import SwiftUI
import AVFoundation

@main
struct ArrowSurvivorApp: App {
    @StateObject private var runState = GameRunState()

    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(runState)
        }
    }
}
