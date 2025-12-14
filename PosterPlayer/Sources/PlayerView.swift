import SwiftUI
import Combine

struct PlayerView: View {
    @EnvironmentObject var store: PosterStore
    @State private var index: Int = 0
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if store.posters.indices.contains(index) {
                let url = store.posters[index].url
                if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                }
            } else {
                Text("未选择图片")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            if store.keepAwake { UIApplication.shared.isIdleTimerDisabled = true }
            startTimer()
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            stopTimer()
        }
        .onChange(of: store.playbackDuration) { _ in
            restartTimer()
        }
        .onReceive(timer ?? Timer.publish(every: store.playbackDuration, on: .main, in: .common).autoconnect()) { _ in
            advance()
        }
    }

    private func startTimer() {
        timer = Timer.publish(every: store.playbackDuration, on: .main, in: .common).autoconnect()
    }

    private func stopTimer() {
        timer = nil
    }

    private func restartTimer() {
        stopTimer()
        startTimer()
    }

    private func advance() {
        guard !store.posters.isEmpty else { return }
        index = (index + 1) % store.posters.count
    }
}
