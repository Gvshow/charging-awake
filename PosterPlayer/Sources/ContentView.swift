import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: PosterStore
    @State private var showingPicker = false
    @State private var showingPlayer = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("图片")) {
                    HStack {
                        Text("已选择")
                        Spacer()
                        Text("\(store.posters.count) 张")
                            .foregroundColor(.secondary)
                    }
                    Button("选择图片") { showingPicker = true }
                    Button("清空") { store.removeAll() }
                }

                Section(header: Text("播放")) {
                    HStack {
                        Text("每张时长")
                        Spacer()
                        Text(String(format: "%.0f 秒", store.playbackDuration))
                            .foregroundColor(.secondary)
                    }
                    Slider(value: Binding(get: { store.playbackDuration }, set: { store.setDuration($0) }), in: 1...60, step: 1)
                    Toggle("播放时保持常亮", isOn: Binding(get: { store.keepAwake }, set: { store.setKeepAwake($0) }))
                    Button("开始播放") { showingPlayer = true }
                        .disabled(store.posters.isEmpty)
                }
            }
            .navigationTitle("海报播放")
        }
        .sheet(isPresented: $showingPicker) {
            ImagePicker { images in
                showingPicker = false
                let urls = images.compactMap { store.saveImage($0) }
                if !urls.isEmpty { store.addPosters(urls: urls) }
            }
        }
        .fullScreenCover(isPresented: $showingPlayer) {
            PlayerView().environmentObject(store)
        }
    }
}
