import Combine
import Foundation
import ShaperyCore

enum BuildTool: String, CaseIterable, Identifiable {
    case source, conveyor, assembler, collector, rotate, erase
    var id: String { rawValue }
    var title: String {
        switch self {
        case .source: return "Matter"
        case .conveyor: return "Belt"
        case .assembler: return "Assembler"
        case .collector: return "Collector"
        case .rotate: return "Rotate"
        case .erase: return "Erase"
        }
    }
    var symbol: String {
        switch self {
        case .source: return "sparkles"
        case .conveyor: return "arrow.right"
        case .assembler: return "triangle"
        case .collector: return "shippingbox"
        case .rotate: return "rotate.right"
        case .erase: return "eraser"
        }
    }
    var machine: MachineKind? { MachineKind(rawValue: rawValue) }
}

@MainActor
final class FactorySession: ObservableObject {
    @Published private(set) var factory: Factory
    @Published private(set) var isRunning = false
    @Published var tool: BuildTool = .conveyor
    @Published private(set) var direction: Direction = .east
    @Published private(set) var message = "Press Run to bring your first assembly line to life."
    @Published private(set) var saveWarning: String?
    let scene = FactoryScene()
    private let saves = SaveStore()
    private var canSave = true

    init() {
        factory = .demo()
        do {
            if let restored = try saves.load() {
                factory = restored
                message = "Factory restored. Press Run to resume."
            }
        } catch {
            // Preserve unreadable or newer saves until the player explicitly resets.
            canSave = false
            saveWarning = "Your save could not be loaded. It is preserved; this demo will not overwrite it. Reset explicitly to start a new save."
        }
        scene.onCellTapped = { [weak self] point in self?.edit(at: point) }
        scene.render(factory)
    }

    func toggleRunning() {
        isRunning.toggle()
        message = isRunning ? "Matter → assembly → triangle. Follow the arrows." : "Paused. Choose a tool, then tap a tile."
        if !isRunning { save() }
    }

    func tick() {
        guard isRunning else { return }
        factory.advance()
        scene.render(factory)
        if factory.tick.isMultiple(of: 40) { save() }
    }

    func suspend() {
        isRunning = false
        save()
    }

    func changeDirection() { direction = direction.clockwise }

    func reset() {
        isRunning = false
        factory = .demo()
        canSave = true
        saveWarning = nil
        message = "Starter line restored. Press Run or build something new."
        scene.render(factory)
        save()
    }

    private func edit(at point: GridPoint) {
        guard !isRunning else {
            message = "Pause the factory before editing."
            return
        }
        do {
            if let kind = tool.machine {
                try factory.place(kind, at: point, direction: direction)
                message = "\(tool.title) placed. Its arrow points toward the output."
            } else if tool == .rotate {
                factory.rotate(at: point)
                message = "Machine rotated clockwise."
            } else {
                factory.remove(at: point)
                message = "Tile cleared, including any buffered items."
            }
            scene.render(factory)
            save()
        } catch {
            message = "That tile is occupied. Erase it first, or choose an empty tile."
        }
    }

    private func save() {
        guard canSave else { return }
        do {
            try saves.save(factory)
            saveWarning = nil
        } catch {
            saveWarning = "Saving failed. Your factory is still in memory; pause again to retry."
        }
    }
}
