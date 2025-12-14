import Foundation
import UIKit

struct PosterItem: Identifiable, Equatable {
    let id: UUID
    let url: URL
}

final class PosterStore: ObservableObject {
    @Published var posters: [PosterItem] = []
    @Published var playbackDuration: Double = 5
    @Published var keepAwake: Bool = true

    private let postersKey = "posterplayer_posters_paths"
    private let durationKey = "posterplayer_duration"
    private let awakeKey = "posterplayer_keepawake"

    init() {
        let paths = UserDefaults.standard.array(forKey: postersKey) as? [String] ?? []
        posters = paths.compactMap { URL(string: $0) }.map { PosterItem(id: UUID(), url: $0) }
        let d = UserDefaults.standard.double(forKey: durationKey)
        playbackDuration = d > 0 ? d : 5
        keepAwake = UserDefaults.standard.object(forKey: awakeKey) as? Bool ?? true
    }

    func addPosters(urls: [URL]) {
        let items = urls.map { PosterItem(id: UUID(), url: $0) }
        posters.append(contentsOf: items)
        persist()
    }

    func removeAll() {
        posters.removeAll()
        persist()
    }

    func setDuration(_ d: Double) {
        playbackDuration = d
        UserDefaults.standard.set(d, forKey: durationKey)
    }

    func setKeepAwake(_ on: Bool) {
        keepAwake = on
        UserDefaults.standard.set(on, forKey: awakeKey)
    }

    private func persist() {
        let paths = posters.map { $0.url.absoluteString }
        UserDefaults.standard.set(paths, forKey: postersKey)
    }

    func saveImage(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.95) else { return nil }
        let dir = postersDirectory()
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }

    func postersDirectory() -> URL {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return base.appendingPathComponent("Posters")
    }
}
