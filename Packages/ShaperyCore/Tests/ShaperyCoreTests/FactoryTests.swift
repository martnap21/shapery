import Foundation
import XCTest
@testable import ShaperyCore

final class FactoryTests: XCTestCase {
    func testDemoProducesTriangles() {
        var factory = Factory.demo()
        for _ in 0..<120 { factory.advance() }
        XCTAssertGreaterThan(factory.trianglesDelivered, 0)
    }

    func testPlacementRejectsOccupiedAndOutOfBoundsCells() throws {
        var factory = Factory()
        let point = GridPoint(x: 0, y: 0)
        try factory.place(.source, at: point)
        XCTAssertThrowsError(try factory.place(.conveyor, at: point)) {
            XCTAssertEqual($0 as? FactoryError, .occupied)
        }
        XCTAssertThrowsError(try factory.place(.conveyor, at: GridPoint(x: 8, y: 0)))
        XCTAssertThrowsError(try factory.place(.conveyor, at: GridPoint(x: -1, y: 0)))
        XCTAssertEqual(factory.machines.count, 1)
    }

    func testBlockedSourceRetainsMatter() throws {
        var factory = Factory()
        let source = GridPoint(x: 0, y: 0)
        try factory.place(.source, at: source)
        for _ in 0..<20 { factory.advance() }
        XCTAssertEqual(factory.machines[source]?.output, .matter)
        try factory.place(.conveyor, at: GridPoint(x: 1, y: 0))
        factory.advance()
        XCTAssertNil(factory.machines[source]?.output)
        XCTAssertEqual(factory.machines[GridPoint(x: 1, y: 0)]?.output, .matter)
    }

    func testItemsMoveAtMostOneCellPerTick() throws {
        var factory = Factory()
        try factory.place(.source, at: GridPoint(x: 0, y: 0))
        try factory.place(.conveyor, at: GridPoint(x: 1, y: 0))
        try factory.place(.conveyor, at: GridPoint(x: 2, y: 0))
        for _ in 0..<4 { factory.advance() }
        XCTAssertEqual(factory.machines[GridPoint(x: 1, y: 0)]?.output, .matter)
        XCTAssertNil(factory.machines[GridPoint(x: 2, y: 0)]?.output)
        factory.advance()
        XCTAssertEqual(factory.machines[GridPoint(x: 2, y: 0)]?.output, .matter)
    }

    func testThreeMatterProduceOneTriangle() throws {
        var factory = Factory()
        let assembler = GridPoint(x: 1, y: 0)
        try factory.place(.source, at: GridPoint(x: 0, y: 0))
        try factory.place(.assembler, at: assembler)
        for _ in 0..<12 { factory.advance() }
        XCTAssertEqual(factory.machines[assembler]?.storedMatter, 3)
        XCTAssertNil(factory.machines[assembler]?.output)
        factory.advance()
        XCTAssertEqual(factory.machines[assembler]?.storedMatter, 0)
        XCTAssertEqual(factory.machines[assembler]?.output, .triangle)
    }

    func testCollectorRejectsRawMatter() throws {
        var factory = Factory()
        try factory.place(.source, at: GridPoint(x: 0, y: 0))
        try factory.place(.collector, at: GridPoint(x: 1, y: 0))
        for _ in 0..<12 { factory.advance() }
        XCTAssertEqual(factory.trianglesDelivered, 0)
        XCTAssertEqual(factory.machines[GridPoint(x: 0, y: 0)]?.output, .matter)
    }

    func testCompetingInputsDoNotDuplicateOrOverwriteMatter() throws {
        var factory = Factory()
        try factory.place(.source, at: GridPoint(x: 0, y: 1), direction: .east)
        try factory.place(.source, at: GridPoint(x: 2, y: 1), direction: .west)
        try factory.place(.conveyor, at: GridPoint(x: 1, y: 1), direction: .north)
        for _ in 0..<4 { factory.advance() }
        XCTAssertEqual(factory.machines.values.filter { $0.output == .matter }.count, 2)
        XCTAssertNil(factory.machines[GridPoint(x: 0, y: 1)]?.output)
        XCTAssertEqual(factory.machines[GridPoint(x: 2, y: 1)]?.output, .matter)
    }

    func testRotationAndRemoval() throws {
        var factory = Factory()
        let point = GridPoint(x: 0, y: 0)
        try factory.place(.conveyor, at: point)
        factory.rotate(at: point)
        XCTAssertEqual(factory.machines[point]?.direction, .south)
        for _ in 0..<3 { factory.rotate(at: point) }
        XCTAssertEqual(factory.machines[point]?.direction, .east)
        factory.remove(at: point)
        XCTAssertTrue(factory.machines.isEmpty)
    }

    func testSimulationIsIndependentOfPlacementOrder() throws {
        let placements: [(GridPoint, MachineKind, Direction)] = [
            (.init(x: 0, y: 1), .source, .east),
            (.init(x: 2, y: 1), .source, .west),
            (.init(x: 1, y: 1), .assembler, .north),
            (.init(x: 1, y: 2), .collector, .north)
        ]
        var first = Factory()
        var second = Factory()
        for (point, kind, direction) in placements { try first.place(kind, at: point, direction: direction) }
        for (point, kind, direction) in placements.reversed() { try second.place(kind, at: point, direction: direction) }
        for _ in 0..<100 { first.advance(); second.advance() }
        XCTAssertEqual(first, second)
    }

    func testSaveRoundTripContinuesExactly() throws {
        var original = Factory.demo()
        for _ in 0..<37 { original.advance() }
        var restored = try SaveGame.decode(SaveGame(factory: original).encoded()).factory
        XCTAssertEqual(original, restored)
        for _ in 0..<100 { original.advance(); restored.advance() }
        XCTAssertEqual(original, restored)
    }

    func testCorruptAndFutureSavesAreRejected() throws {
        XCTAssertThrowsError(try SaveGame.decode(Data("broken".utf8)))
        let data = try SaveGame(factory: .demo()).encoded()
        var json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        json["version"] = 99
        XCTAssertThrowsError(try SaveGame.decode(JSONSerialization.data(withJSONObject: json))) {
            XCTAssertEqual($0 as? FactoryError, .unsupportedSaveVersion)
        }
        json["version"] = 1
        var factory = try XCTUnwrap(json["factory"] as? [String: Any])
        factory["width"] = 0
        json["factory"] = factory
        XCTAssertThrowsError(try SaveGame.decode(JSONSerialization.data(withJSONObject: json))) {
            XCTAssertEqual($0 as? FactoryError, .invalidState)
        }
    }
}
