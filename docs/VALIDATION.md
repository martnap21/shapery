# Validation

## Bootstrap checks

The authoring environment is Linux and has no Swift compiler, Xcode or iOS Simulator. Native compilation and execution cannot be claimed from local checks. GitHub Actions is configured to run core tests and an unsigned iOS Simulator build on macOS; inspect its result for the relevant commit.

Local structural validation covers Python generator syntax/execution and repeatability, XML property lists and scheme parsing, asset JSON, configuration paths, shell syntax, Xcode object references and expected source membership. These checks do not substitute for an Xcode build.

## Automated coverage

Eleven XCTest cases in `FactoryTests.swift` cover:

- Demo production; occupied/out-of-bounds placement.
- Backpressure, one-cell-per-tick transport and recipe consumption.
- Collector rejection of matter and competing sender conservation.
- Rotation/removal and deterministic results across insertion orders.
- Save round-trip with identical continued simulation.
- Corrupt, unsupported-version and invalid-dimension saves.

CI regenerates the project, checks for a diff, runs `swift test`, builds Debug for a generic iOS Simulator, and lints property lists. The app scheme itself has no tests. UI automation, launch verification and physical-device testing are not included in the initial workflow.

## Manual acceptance checklist (not yet run)

- [ ] Run on iPhone and iPad; verify a visible board and readable controls in portrait and landscape.
- [ ] Start the line; see matter arrive, assembler buffer reach three, and triangles reach the collector.
- [ ] Pause; ensure ticks stop. Place, rotate and erase; occupied tiles should not be overwritten.
- [ ] Block the line; confirm tokens stay buffered. Reconnect and verify production resumes.
- [ ] Complete twelve triangles; confirm the objective changes and production continues.
- [ ] Background and relaunch; confirm the same factory resumes paused without offline production.
- [ ] Exercise Reset cancellation and confirmation.
- [ ] Test an unreadable or future-version save; confirm a warning and no silent overwrite.
- [ ] Exercise save-write failure recovery where feasible.
- [ ] Check large Dynamic Type, VoiceOver and small-screen/landscape layouts.
- [ ] Profile frame time, memory, CPU and battery on a physical device.

## Known limitations

The board is tap-only and not individually navigable through VoiceOver; labels on controls do not imply full game accessibility. Cells can be small on compact devices. Items advance discretely, the renderer rebuilds nodes, and there is no camera or interpolation. Wall-clock catch-up, undo, controller input, progression beyond the triangle objective, native Mac/TV apps, cloud sync, app icons and release validation remain unimplemented.
