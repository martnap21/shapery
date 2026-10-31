# Shapery

**Something from nothing.** A short factory / automation game for the Apple ecosystem. Route matter through assembly lines, manufacture geometry, and eventually build a tesseract.

This repository starts with an **iPhone and iPad development sandbox**, not the finished game. It includes an editable working production line, native UI, an independent simulation package, versioned local saves, and CI. The long-term direction includes macOS and tvOS; those apps are not implemented yet.

## Open and run

1. On a Mac, install **Xcode 16 or newer** and an iOS Simulator runtime through Xcode Settings → Components. Launch Xcode once to finish setup.
2. Clone the repository and open the checked-in project:

   ```bash
   git clone https://github.com/martnap21/shapery.git
   cd shapery
   open Shapery.xcodeproj
   ```

3. Select the **Shapery** scheme and an **iPhone or iPad simulator running iOS 17 or later**. Press **⌘R**.
4. For a physical device, select your own development team under **Shapery target → Signing & Capabilities**. Change `PRODUCT_BUNDLE_IDENTIFIER` in `Configuration/Base.xcconfig` if your account requires a different identifier. No development team or signing credentials are committed.

There are no third-party runtime dependencies, package downloads, or project-generation prerequisites. Open **Shapery.xcodeproj**, not the core package, to run the game.

## Try the starter

- Press **Run**. The supplied line already connects a matter source, belts, an assembler, and a collector.
- Every source produces one matter per second when its output is free. Three matter make one triangle. Deliver twelve triangles to complete the sandbox objective; the factory keeps running afterward.
- Press **Pause**, select a tool, and tap an empty tile to place it. **Output** changes the direction for new machines; **Rotate** changes a placed machine. **Erase** removes a machine and its contents.
- Inputs may arrive from any adjacent side; arrows specify the output side. Full buffers stop upstream movement without deleting items.
- Layout changes, pausing, backgrounding, and every ten seconds of simulation trigger local saves. Relaunching restores the factory paused. **Reset** asks for confirmation before replacing the layout and save with the starter line.

## Development

```bash
# Simulation tests; no simulator or Apple frameworks needed.
swift test --package-path Packages/ShaperyCore

# Core tests plus unsigned iOS Simulator build on a Mac.
bash scripts/check.sh

# Only needed after adding/removing app Swift source files outside Xcode.
python3 scripts/generate_project.py
```

The generator uses Python's standard library. If you add files through Xcode, regenerate before committing so the project stays reproducible. The app scheme has no XCTest target: core tests live in the package and run through the command above or by opening its `Package.swift` in Xcode. CI builds the app and tests the package on a macOS runner.

| Location | Responsibility |
| --- | --- |
| `Apps/iOS/Shapery/` | SwiftUI interface, SpriteKit board, input, app lifecycle and disk storage |
| `Packages/ShaperyCore/` | Geometry, machine state, deterministic simulation, save format and tests |
| `Configuration/Base.xcconfig` | Deployment target, bundle ID, version, signing style and Swift settings |
| `Shapery.xcodeproj/` | Ready-to-open project and shared scheme |
| `docs/` | Architecture, direction, verification, milestones and known limitations |

Start with [development setup](docs/DEVELOPMENT.md), [architecture](docs/ARCHITECTURE.md), and [the roadmap](docs/ROADMAP.md). [Validation](docs/VALIDATION.md) distinguishes executed checks from checks that still require Xcode or a device.

## Scope

The matter-to-triangle recipe is an intentionally small placeholder, not a commitment to the final geometry system. Vertices, sides, angles, shape composition, 3D objects, and the tesseract remain future design work. Native macOS/tvOS input, controller support, cloud saves, audio, app icons, and distribution setup are also future work. No license has been selected; repository visibility does not grant an open-source license.
