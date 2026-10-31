# Validation

## Bootstrap checks

The authoring environment is Linux and has no Swift compiler, Xcode or iOS Simulator. Native validation was therefore performed through GitHub Actions on a macOS runner.

**Verified code commit:** `51ab65a87b879d969bae08dfe89cd38a2a5316fb` on 2026-10-31. [Successful CI run](https://github.com/martnap21/shapery/actions/runs/41228098162), using Xcode 16.4 and Swift 6.1.2 in Swift 5 language mode:

- All eleven core XCTest cases passed with zero failures.
- Debug iOS Simulator build succeeded for arm64 and x86_64.
- Checked-in Xcode project regeneration produced no diff.
- App Info.plist, privacy manifest and project property-list lint passed.

This verifies compilation and core behavior, not app launch, visual layout or device interaction. The manual checks below remain unrun.

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

## Release readiness

Status: **development sandbox; not approved as a player release**.

Existing safeguards include validated saves, atomic writes, preservation of unreadable saves, reset confirmation, bounded inventory and deterministic transport. Their presence is not a claim of comprehensive safety coverage.

Before a player-facing milestone, plan and execute additional verification for:

- App launch and primary build/run interactions, including reset cancellation.
- Save-store integration, lifecycle interruption, failed writes and preservation of unsupported/corrupt saves.
- Relevant malformed-state boundaries beyond the currently tested save dimensions.
- Device layout, accessible interaction and performance on the intended supported hardware.

Select concrete acceptance criteria under [engineering practices](ENGINEERING.md) before implementing these tests or changing safety behavior. Existing manual checklist items remain unrun.
