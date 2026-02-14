import SwiftUI

@main
struct ArrowSurvivorApp: App {
    @StateObject private var runState = GameRunState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(runState)
        }
    }
}
