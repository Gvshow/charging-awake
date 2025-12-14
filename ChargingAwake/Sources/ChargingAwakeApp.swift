import SwiftUI

@main
struct ChargingAwakeApp: App {
    @StateObject private var battery = BatteryController()
    @Environment(\.scenePhase) private var phase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(battery)
                .onAppear { battery.start() }
                .onDisappear { battery.stop() }
        }
        .onChange(of: phase) { p in
            if p == .active { battery.applyIdlePolicy() }
            if p != .active { UIApplication.shared.isIdleTimerDisabled = false }
        }
    }
}
