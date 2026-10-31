import SpriteKit
import UIKit
import ShaperyCore

/// Presentation only: coordinates and input are translated into core commands.
@MainActor
final class FactoryScene: SKScene {
    var onCellTapped: ((GridPoint) -> Void)?
    private let cell: CGFloat = 64
    private let mint = SKColor(red: 0.43, green: 0.94, blue: 0.79, alpha: 1)

    override init() {
        super.init(size: CGSize(width: 512, height: 384))
        scaleMode = .aspectFit
        backgroundColor = SKColor(red: 0.055, green: 0.075, blue: 0.10, alpha: 1)
    }

    required init?(coder: NSCoder) { fatalError("Use init()") }

    func render(_ factory: Factory) {
        size = CGSize(width: CGFloat(factory.width) * cell, height: CGFloat(factory.height) * cell)
        removeAllChildren()
        for y in 0..<factory.height {
            for x in 0..<factory.width {
                let point = GridPoint(x: x, y: y)
                let center = CGPoint(x: CGFloat(x) * cell + cell / 2, y: CGFloat(y) * cell + cell / 2)
                let tile = SKShapeNode(rectOf: CGSize(width: cell - 5, height: cell - 5), cornerRadius: 9)
                tile.position = center
                tile.fillColor = SKColor(white: 0.09, alpha: 1)
                tile.strokeColor = SKColor(white: 0.17, alpha: 1)
                tile.lineWidth = 1
                addChild(tile)
                guard let machine = factory.machines[point] else { continue }
                tile.fillColor = machine.kind == .conveyor
                    ? SKColor(red: 0.12, green: 0.17, blue: 0.20, alpha: 1)
                    : SKColor(red: 0.10, green: 0.23, blue: 0.22, alpha: 1)
                tile.strokeColor = machine.kind == .conveyor ? SKColor(white: 0.3, alpha: 1) : mint.withAlphaComponent(0.6)

                let symbol: String
                switch machine.kind {
                case .source: symbol = "M"
                case .conveyor: symbol = arrow(machine.direction)
                case .assembler: symbol = "△"
                case .collector: symbol = "◎"
                }
                label(symbol, at: CGPoint(x: center.x, y: center.y + 3), size: 26, color: mint)
                if machine.kind != .conveyor && machine.kind != .collector {
                    label(arrow(machine.direction), at: CGPoint(x: center.x + 19, y: center.y - 18), size: 12, color: mint)
                }
                if machine.kind == .assembler {
                    label("\(machine.storedMatter)/3", at: CGPoint(x: center.x - 9, y: center.y - 19), size: 11, color: .white)
                }
                if let item = machine.output {
                    let token = SKShapeNode(circleOfRadius: 8)
                    token.position = CGPoint(x: center.x - 19, y: center.y + 19)
                    token.fillColor = item == .matter ? .white : .orange
                    token.strokeColor = .clear
                    addChild(token)
                    if item == .triangle {
                        label("△", at: token.position, size: 12, color: .black)
                    }
                }
            }
        }
    }

    private func arrow(_ direction: Direction) -> String {
        switch direction {
        case .north: return "↑"
        case .east: return "→"
        case .south: return "↓"
        case .west: return "←"
        }
    }

    private func label(_ text: String, at point: CGPoint, size: CGFloat, color: SKColor) {
        let node = SKLabelNode(fontNamed: "Menlo-Bold")
        node.text = text
        node.fontSize = size
        node.fontColor = color
        node.verticalAlignmentMode = .center
        node.position = point
        addChild(node)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self),
              location.x >= 0, location.y >= 0,
              location.x < size.width, location.y < size.height else { return }
        onCellTapped?(GridPoint(x: Int(location.x / cell), y: Int(location.y / cell)))
    }
}
