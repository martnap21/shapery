public struct GridPoint: Hashable, Codable, Sendable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public func neighbor(in direction: Direction) -> GridPoint {
        switch direction {
        case .north: return GridPoint(x: x, y: y + 1)
        case .east: return GridPoint(x: x + 1, y: y)
        case .south: return GridPoint(x: x, y: y - 1)
        case .west: return GridPoint(x: x - 1, y: y)
        }
    }
}

public enum Direction: Int, CaseIterable, Codable, Sendable {
    case north, east, south, west

    public var clockwise: Direction { Direction(rawValue: (rawValue + 1) % 4)! }
}

public enum Item: String, Codable, Sendable {
    case matter, triangle
}

public enum MachineKind: String, CaseIterable, Codable, Sendable {
    case source, conveyor, assembler, collector
}

public struct Machine: Equatable, Codable, Sendable {
    public let kind: MachineKind
    public var direction: Direction
    public internal(set) var storedMatter: Int = 0
    public internal(set) var output: Item?

    public init(kind: MachineKind, direction: Direction = .east) {
        self.kind = kind
        self.direction = direction
    }
}
