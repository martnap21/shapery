# Engineering decisions

Date: 2026-10-31

These records summarize the implemented bootstrap and evaluate alternatives now. Alternatives marked retrospective were not documented as an exhaustive evaluation before the bootstrap; this document does not claim otherwise.

## D001 — Shared simulation with native iOS presentation

**Selected:** SwiftUI controls, SpriteKit board, and a separate Swift package containing deterministic simulation.

**Reason:** Keep gameplay rules testable without a renderer and reusable by future Apple-platform shells. Keep the current iOS interaction layer concrete.

**Alternatives evaluated retrospectively:** A SwiftUI-only board would reduce frameworks but would require another rendering approach as game presentation grows. A general-purpose game engine is another possible direction, but changing engines is not justified by the present bootstrap scope.

**Tradeoffs:** Separate core and presentation require explicit state ownership. UIKit input is currently iOS-only. Future 3D/four-dimensional presentation may require reconsidering the renderer; SpriteKit is not a commitment for every future visual feature.

**Revisit when:** Real shape requirements, performance evidence or platform interaction needs outgrow the starter. See [architecture](ARCHITECTURE.md).

## D002 — Fixed-step deterministic transport

**Selected:** Integer ticks, explicit row-major order, bounded buffers and snapshot-based transport.

**Reason:** Reproducible production and tests; prevent items from moving multiple cells in one tick or disappearing under backpressure.

**Alternative evaluated retrospectively:** Frame-driven updates tie gameplay progress to rendering unless carefully decoupled.

**Tradeoffs:** Conservative conveyor occupancy and row-major contention are intentionally simple. Fairness, interpolation and elapsed-time catch-up remain deferred. No offline production is promised.

**Revisit when:** Larger factories require higher throughput, fair merging or a different timing policy.

## D003 — Local versioned saves

**Selected:** Validated versioned JSON, atomic file writes, warnings for failures, and preservation of unreadable saves until explicit reset.

**Reason:** Persist the starter without accounts or a network dependency while reducing accidental overwrite risk.

**Alternatives evaluated retrospectively:** In-memory-only state would lose progress at termination. Cloud synchronization would add conflict and failure cases before the local behavior is fully verified.

**Tradeoffs:** No backup history, migrations or cross-device synchronization. Atomic writes alone do not establish resilience under every storage failure. Save-store and lifecycle integration still need tests.

**Revisit when:** The first persistent player milestone is planned or save structure changes.

## D004 — Development scope before full game progression

**Selected:** A provisional matter-to-triangle line and editable board.

**Reason:** Establish an environment for development without treating the final vertices/sides/angles design as settled.

**Deferred:** Geometric composition, solids, tesseract finale, native Mac/TV apps, broader safety integration tests and release work.

**Tradeoffs:** This is a sandbox, not a complete game or distribution-ready product. UI and device acceptance are outstanding.

**Revisit when:** Martin supplies the first real production-loop requirements.

## D005 — Repository engineering records

**Selected:** Prior plans, decision summaries, lessons, changelog and validation records, linked from AGENTS.md.

**Alternatives considered for this update:** Chat-only guidance loses repository continuity. Adding new enforcement tools immediately would expand scope without first establishing the requirements.

**Reason:** Future contributors can review both the change and its justification.

**Tradeoffs:** Records need maintenance. Keep them concise and tied to actual decisions rather than duplicating implementation or inventing rationale.
