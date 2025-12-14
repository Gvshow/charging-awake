import SwiftUI

@main
struct PosterPlayerApp: App {
    @StateObject private var store = PosterStore()
    @Environment(\.scenePhase) private var phase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .onChange(of: phase) { p in
            if p != .active { UIApplication.shared.isIdleTimerDisabled = false }
        }
    }
}
