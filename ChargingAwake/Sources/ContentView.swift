import SwiftUI

struct ContentView: View {
    @EnvironmentObject var battery: BatteryController

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: battery.isCharging ? "bolt.fill" : "bolt.slash")
                .font(.system(size: 48))
                .foregroundColor(battery.isCharging ? .yellow : .gray)

            Text(battery.isCharging ? "正在充电，保持常亮" : "未充电，按系统自动锁屏")
                .font(.headline)

            Toggle("强制常亮", isOn: Binding(
                get: { battery.forceAwake },
                set: { battery.setForceAwake($0) }
            ))
            .padding()

            Text(UIApplication.shared.isIdleTimerDisabled ? "已禁用自动锁屏" : "遵循系统自动锁屏")
                .foregroundColor(UIApplication.shared.isIdleTimerDisabled ? .green : .secondary)
                .font(.subheadline)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(BatteryController())
    }
}
