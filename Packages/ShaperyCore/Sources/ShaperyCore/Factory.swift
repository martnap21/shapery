public enum FactoryError: Error, Equatable {
    case outOfBounds, occupied, invalidState, unsupportedSaveVersion
}

/// Deterministic simulation. No clock, renderer, or platform dependencies.
public struct Factory: Codable, Equatable, Sendable {
    public static let tickDuration: Double = 0.25
    public static let triangleMatterCost = 3
    public let width: Int
    public let height: Int
    public private(set) var machines: [GridPoint: Machine] = [:]
    public private(set) var tick: Int = 0
    public private(set) var trianglesDelivered: Int = 0

    public init(width: Int = 8, height: Int = 6) {
        precondition((1...64).contains(width) && (1...64).contains(height))
        self.width = width
        self.height = height
    }

    public func contains(_ point: GridPoint) -> Bool {
        (0..<width).contains(point.x) && (0..<height).contains(point.y)
    }

    public mutating func place(_ kind: MachineKind, at point: GridPoint, direction: Direction = .east) throws {
        guard contains(point) else { throw FactoryError.outOfBounds }
        guard machines[point] == nil else { throw FactoryError.occupied }
        machines[point] = Machine(kind: kind, direction: direction)
    }

    /// Removing a machine deliberately discards its buffered items.
    public mutating func remove(at point: GridPoint) {
        machines.removeValue(forKey: point)
    }

    public mutating func rotate(at point: GridPoint) {
        guard var machine = machines[point] else { return }
        machine.direction = machine.direction.clockwise
        machines[point] = machine
    }

    public mutating func advance() {
        tick += 1
        let orderedPoints = machines.keys.sorted { lhs, rhs in
            lhs.y == rhs.y ? lhs.x < rhs.x : lhs.y < rhs.y
        }

        // Production comes first. A blocked output holds its item indefinitely.
        for point in orderedPoints {
            guard var machine = machines[point], machine.output == nil else { continue }
            switch machine.kind {
            case .source where tick.isMultiple(of: 4):
                machine.output = .matter
            case .assembler where machine.storedMatter == Self.triangleMatterCost:
                machine.storedMatter = 0
                machine.output = .triangle
            default: break
            }
            machines[point] = machine
        }

        // Snapshot outputs: a newly received item cannot travel twice this tick.
        let ready = orderedPoints.compactMap { point -> (GridPoint, Item, Direction)? in
            guard let machine = machines[point], let item = machine.output else { return nil }
            return (point, item, machine.direction)
        }
        let occupiedOutputs = Set(ready.map { $0.0 })
        for (point, item, direction) in ready {
            let destination = point.neighbor(in: direction)
            guard var target = machines[destination] else { continue }
            switch target.kind {
            case .conveyor:
                guard target.output == nil, !occupiedOutputs.contains(destination) else { continue }
                target.output = item
            case .assembler:
                guard item == .matter, target.storedMatter < Self.triangleMatterCost else { continue }
                target.storedMatter += 1
            case .collector:
                guard item == .triangle else { continue }
                trianglesDelivered += 1
            case .source:
                continue
            }
            machines[destination] = target
            machines[point]?.output = nil
        }
    }

    /// Called after decoding, before exposing a save to simulation or rendering.
    public func validate() throws {
        guard (1...64).contains(width), (1...64).contains(height),
              tick >= 0, tick < Int.max - 1_000_000,
              trianglesDelivered >= 0, trianglesDelivered < Int.max - 1_000_000 else {
            throw FactoryError.invalidState
        }
        for (point, machine) in machines {
            guard contains(point), (0...Self.triangleMatterCost).contains(machine.storedMatter) else {
                throw FactoryError.invalidState
            }
            switch machine.kind {
            case .source:
                guard machine.storedMatter == 0, machine.output == nil || machine.output == .matter else {
                    throw FactoryError.invalidState
                }
            case .conveyor:
                guard machine.storedMatter == 0 else { throw FactoryError.invalidState }
            case .assembler:
                guard machine.output == nil || machine.output == .triangle else { throw FactoryError.invalidState }
            case .collector:
                guard machine.storedMatter == 0, machine.output == nil else { throw FactoryError.invalidState }
            }
        }
    }

    public static func demo() -> Factory {
        var factory = Factory()
        // All positions are distinct and within the fixed starter board.
        let line: [(Int, MachineKind)] = [
            (0, .source), (1, .conveyor), (2, .conveyor),
            (3, .assembler), (4, .conveyor), (5, .conveyor), (6, .collector)
        ]
        for (x, kind) in line {
            factory.machines[GridPoint(x: x, y: 2)] = Machine(kind: kind)
        }
        return factory
    }
}
