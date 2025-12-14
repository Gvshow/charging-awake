import UIKit
import Combine

final class BatteryController: ObservableObject {
    @Published var isCharging: Bool = false
    @Published var forceAwake: Bool = false
    private var cancellables = Set<AnyCancellable>()

    func start() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        updateState()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
    }

    func stop() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        UIDevice.current.isBatteryMonitoringEnabled = false
        UIApplication.shared.isIdleTimerDisabled = false
    }

    func setForceAwake(_ on: Bool) {
        forceAwake = on
        applyIdlePolicy()
    }

    @objc private func batteryStateDidChange() {
        updateState()
    }

    private func updateState() {
        let state = UIDevice.current.batteryState
        isCharging = (state == .charging || state == .full)
        applyIdlePolicy()
    }

    func applyIdlePolicy() {
        let shouldDisable = forceAwake || isCharging
        UIApplication.shared.isIdleTimerDisabled = shouldDisable
    }
}
