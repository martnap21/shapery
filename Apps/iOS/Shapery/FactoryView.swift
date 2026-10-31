import Combine
import SpriteKit
import SwiftUI
import ShaperyCore

@MainActor
struct FactoryView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var session = FactorySession()
    @State private var showingReset = false
    private let timer = Timer.publish(every: Factory.tickDuration, on: .main, in: .common).autoconnect()
    private let mint = Color(red: 0.43, green: 0.94, blue: 0.79)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                objective
                SpriteView(scene: session.scene, preferredFramesPerSecond: 30)
                    .aspectRatio(CGFloat(session.factory.width) / CGFloat(session.factory.height), contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.1)))
                    .accessibilityLabel("Factory board. \(session.factory.machines.count) machines placed.")
                    .accessibilityHint("Pause, select a tool, and tap a tile to edit.")
                controls
                buildTools
                Text(session.message)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(minHeight: 40, alignment: .topLeading)
                if let warning = session.saveWarning {
                    Label(warning, systemImage: "exclamationmark.triangle")
                        .font(.callout)
                        .foregroundStyle(.orange)
                }
                guide
            }
            .padding(20)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .background(Color(red: 0.035, green: 0.05, blue: 0.07))
        .tint(mint)
        .onReceive(timer) { _ in
            if scenePhase == .active { session.tick() }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { session.suspend() }
        }
        .alert("Reset this factory?", isPresented: $showingReset) {
            Button("Cancel", role: .cancel) {}
            Button("Reset factory", role: .destructive) { session.reset() }
        } message: {
            Text("This replaces your layout, delivered triangles, and local save with the starter line.")
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("SHAPERY")
                    .font(.system(.largeTitle, design: .rounded, weight: .black))
                    .tracking(3)
                Text("Something from nothing.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("LAB 01")
                .font(.system(.caption, design: .monospaced, weight: .bold))
                .padding(10)
                .background(mint.opacity(0.12), in: Capsule())
                .foregroundStyle(mint)
        }
    }

    private var objective: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(session.factory.trianglesDelivered >= 12 ? "First geometry achieved" : "Your first geometry")
                    .font(.headline)
                Spacer()
                Text("\(session.factory.trianglesDelivered) △")
                    .font(.system(.headline, design: .monospaced))
                    .foregroundStyle(mint)
                    .accessibilityLabel("\(session.factory.trianglesDelivered) triangles delivered")
            }
            Text("Deliver 12 triangles. Three units of matter become one triangle.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ProgressView(value: Double(min(session.factory.trianglesDelivered, 12)), total: 12)
                .accessibilityLabel("Triangle objective")
        }
        .padding(16)
        .background(.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 16))
    }

    private var controls: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) { runButton; directionButton; resetButton }
            VStack(alignment: .leading, spacing: 12) {
                runButton
                HStack { directionButton; resetButton }
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }

    private var runButton: some View {
        Button(action: session.toggleRunning) {
            Label(session.isRunning ? "Pause" : "Run", systemImage: session.isRunning ? "pause.fill" : "play.fill")
                .frame(minWidth: 70)
        }
        .buttonStyle(.borderedProminent)
        .foregroundStyle(.black)
    }

    private var directionButton: some View {
        Button(action: session.changeDirection) {
            Label("Output: \(directionName)", systemImage: "rotate.right")
        }
        .disabled(session.isRunning)
        .accessibilityHint("Changes the output direction for newly placed machines.")
    }

    private var resetButton: some View {
        Button("Reset", role: .destructive) { showingReset = true }
    }

    private var directionName: String {
        switch session.direction {
        case .north: return "Up"
        case .east: return "Right"
        case .south: return "Down"
        case .west: return "Left"
        }
    }

    private var buildTools: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("BUILD YOUR LINE")
                .font(.system(.caption, design: .monospaced, weight: .semibold))
                .foregroundStyle(.secondary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 94))], spacing: 8) {
                ForEach(BuildTool.allCases) { tool in
                    Button { session.tool = tool } label: {
                        VStack(spacing: 7) {
                            Image(systemName: tool.symbol).font(.title3)
                            Text(tool.title).font(.caption)
                        }
                        .frame(maxWidth: .infinity, minHeight: 62)
                        .background(session.tool == tool ? mint.opacity(0.18) : .white.opacity(0.04), in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(session.tool == tool ? mint : .clear))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(session.tool == tool ? mint : .white)
                    .accessibilityAddTraits(session.tool == tool ? .isSelected : [])
                }
            }
            .disabled(session.isRunning)
        }
    }

    private var guide: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("M Matter  →  Belts  →  △ Assembler  →  ◎ Collector")
                .font(.system(.caption, design: .monospaced))
            Text("White dots are matter. Orange triangles are finished shapes. Arrows show outputs; machines accept from any adjacent side. Pause to build, rotate, or erase.")
                .font(.caption)
            Text("DEVELOPMENT SANDBOX · The road to a tesseract starts here.")
                .font(.system(.caption2, design: .monospaced))
                .padding(.top, 8)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview { FactoryView() }
