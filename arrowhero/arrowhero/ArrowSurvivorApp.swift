import SwiftUI

@main
struct ArrowSurvivorApp: App {
    @StateObject private var runState = RunState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(runState)
        }
    }
}
