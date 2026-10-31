import Foundation
import ShaperyCore

struct SaveStore {
    private var url: URL {
        get throws {
            let directory = try FileManager.default.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: true
            ).appendingPathComponent("Shapery", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            return directory.appendingPathComponent("factory-v1.json")
        }
    }

    func load() throws -> Factory? {
        let location = try url
        guard FileManager.default.fileExists(atPath: location.path) else { return nil }
        return try SaveGame.decode(Data(contentsOf: location)).factory
    }

    func save(_ factory: Factory) throws {
        try SaveGame(factory: factory).encoded().write(to: url, options: .atomic)
    }
}
