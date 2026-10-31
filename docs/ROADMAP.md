# Direction and next milestones

## Product intent

A short, satisfying Apple-exclusive factory game: start with matter, automate geometric components, combine shapes into new ones, and end with a tesseract. Target ecosystem: iOS/iPadOS, macOS and tvOS. The immediate development target is iOS.

The initial interface and three-matter triangle recipe are provisional scaffolding. They deliberately avoid deciding how vertices, sides, angles, shape validation, 3D assembly, or fourth-dimensional projection should ultimately work. Martin's development direction takes precedence over these placeholders.

## Environment milestone — implemented

- Native iPhone/iPad project and shared scheme.
- SwiftUI controls and SpriteKit board.
- Independent deterministic simulation package.
- Source, belt, triangle assembler and collector starter line.
- Pause, place, rotate, erase, local saves and reset confirmation.
- Core tests, macOS build workflow, project generator and developer documentation.

Validation status lives in `VALIDATION.md`; implementation does not imply device acceptance.

## Next: settle the first real production loop

- Define what matter, vertices, sides and angles mean as inventory and shape properties.
- Choose the first small recipe chain and completion objective.
- Decide whether orientation and geometric validity affect assembly.
- Replace the demo recipe and add tests for actual design rules.

## Then: make building feel good

- Drag-to-build conveyors, undo, clear input/output ports and placement previews.
- Camera pan/zoom and readable item movement.
- Clear blocked-machine feedback and useful production information.
- Accessible board navigation and device/controller interaction tests.

## Later: shape progression and platform expansion

- Compose polygons, then solids; establish consistent recipes and visual assembly.
- Add native macOS and tvOS targets using the shared core, with platform-specific input.
- Build a tesseract finale with a projected four-dimensional object.
- Add polished art/audio, balancing, onboarding, save migrations and distribution readiness.

No schedule or final recipe balance is implied by this list.
