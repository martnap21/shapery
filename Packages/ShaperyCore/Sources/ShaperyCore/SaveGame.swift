import Foundation

public struct SaveGame: Codable, Equatable, Sendable {
    public let version: Int
    public let factory: Factory

    public init(factory: Factory) {
        version = 1
        self.factory = factory
    }

    public func encoded() throws -> Data {
        try factory.validate()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(self)
    }

    public static func decode(_ data: Data) throws -> SaveGame {
        let save = try JSONDecoder().decode(Self.self, from: data)
        guard save.version == 1 else { throw FactoryError.unsupportedSaveVersion }
        try save.factory.validate()
        return save
    }
}
