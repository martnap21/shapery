# Architecture

## Initial decision

Use SwiftUI for the application shell and controls, SpriteKit for a small 2D board, and a local Swift package for the simulation. Apple documents [SpriteView](https://developer.apple.com/documentation/spritekit/spriteview) as a SwiftUI scene renderer and supports [organizing code into local packages](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages).

The iOS target supports iPhone and iPad at iOS 17+. `ShaperyCore` declares iOS 17, macOS 14 and tvOS 17 support but contains no Apple UI dependencies. Future platform shells can reuse it. The current UIKit touch adapter is explicitly iOS-only; a native Mac app and a television focus/controller layer still need their own targets and input.

## Ownership

| Type | Owns |
| --- | --- |
| `GridPoint`, `Direction` | Integer coordinates; north increases y; clockwise rotation |
| `Machine` | Kind, output direction, bounded matter buffer and optional output token |
| `Factory` | Board dimensions, placements, tick count, delivered triangles, all simulation transitions |
| `SaveGame` | Versioned Codable envelope; validation on encoding/decoding |
| `SaveStore` | Application Support path and atomic file writes |
| `FactorySession` | Main-actor gameplay state, edit commands, pause/run, persistence policy |
| `FactoryScene` | Read-only rendering of a snapshot and touch-to-cell conversion |
| `FactoryView` | SwiftUI controls, HUD, lifecycle observation and timer input |

## Simulation rules

The app requests one fixed step every 0.25 seconds while active and running. The core never consults real time. The timer intentionally does not catch up after a stall or suspension: no offline production is implemented. For larger factories, replace the UI timer with a fixed-step accumulator and bounded catch-up after profiling.

Each tick:

1. Visit machines in ascending y, then x order. Sources create matter every fourth tick if their output is empty. Assemblers with three buffered matter and a free output consume those matter and create a triangle.
2. Snapshot all output tokens and their directions.
3. Visit the snapshot in the same stable order. Transfer into an adjacent compatible machine only if it has capacity. An occupied conveyor at the start of transport cannot accept another token this tick, even if it subsequently empties. This conservative rule avoids order-dependent conveyor speed.
4. Clear a sender only after successful acceptance. Collectors accept only triangles and increment the delivery total. Newly received outputs cannot move again in this tick.

Sources hold one matter output. Belts hold one token. Assemblers hold at most three matter plus one triangle output; they may buffer the next recipe while a triangle is blocked. Collectors consume triangles immediately. Inputs accept from any adjacent direction. Competing senders use row-major priority; no fairness/splitter logic exists yet. Removing a machine deletes its contents, intentionally.

Placement rejects occupied or out-of-bounds tiles. UI editing requires pause. Core commands themselves have no running state and can be reused by future platform adapters.

## Persistence

`Application Support/Shapery/factory-v1.json` stores the board, inventory, tick and triangle count in a version-1 envelope. Save writes are atomic. Pausing, editing, app suspension, and every 40 simulation ticks trigger a save. The UI always starts paused. UI selections and run state are not persisted.

Decoding rejects unknown versions, invalid dimensions, invalid positions, negative counters and impossible inventories. Codable enum decoding rejects unknown item/machine/direction values. A failed load presents a warning and blocks writes for that session until the player explicitly confirms Reset. This preserves the original file for recovery. A write failure leaves the factory in memory and displays a warning.

There are no migrations, iCloud sync, background execution, remote persistence or analytics in this starter. Swift's non-string dictionary keys use a Codable array representation; don't hand-edit saves or assume their byte ordering is canonical.

## Rendering and extension points

The board is 8×6 in the starter. The scene rebuilds its nodes at four simulation updates per second and uses a 30 FPS view. This is simple for 48 cells; future larger boards should retain nodes, animate tokens between ticks, introduce a camera, and profile before scaling. Rendering does not use SpriteKit physics for factory rules.

Add geometry descriptors and recipes in the core first; replace the hardcoded triangle recipe when design is settled. Input should issue commands into the session. Avoid placing simulation rules into SwiftUI button closures or SKNode subclasses. Future macOS/tvOS targets should share state and recipes while adapting interaction and layout.
