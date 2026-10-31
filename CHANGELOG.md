# Changelog

## Engineering practices — 2026-10-31

- Required plans before implementation and documented rationale, alternatives, tradeoffs and deferrals.
- Added engineering workflow, release gates, decision summaries and lessons from the bootstrap and instruction acknowledgment.
- Clarified that successful core tests and builds do not establish UI, device or release readiness.
- Documentation-only change; no runtime behavior, dependencies, save format or build configuration changed.

## 0.1.0 — iOS development foundation (2026-10-31)

- Added a ready-to-open iPhone/iPad Xcode project, shared scheme, shared configuration and reproducible project generator.
- Added a SwiftUI application shell, SpriteKit board, building tools, pause/run controls, triangle objective and reset confirmation.
- Added a platform-independent Swift package with deterministic grid simulation, bounded buffers, conveyor backpressure and a starter matter-to-triangle line.
- Added versioned local saves, atomic writes, load validation, preservation of unreadable saves and lifecycle pausing.
- Added eleven core tests and a macOS CI workflow for package tests and an unsigned iOS Simulator build.
- Documented setup, ownership, simulation rules, persistence, roadmap, limitations and verification scope.
- Initial gameplay is a development sandbox; final geometry recipes, macOS and tvOS apps, and the tesseract are not implemented.
