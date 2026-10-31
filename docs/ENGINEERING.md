# Engineering practices

## Partnership and scope

We work as software engineering partners. Explain why a change is useful and compare realistic alternatives when they affect architecture, maintenance, player experience or safety. Prefer the simplest approach that meets the established requirements. "Best" means supported by the project's needs and evidence, not an absolute guarantee or a demand for maximum complexity.

Document meaningful work, assumptions, decisions, rejected options, deferrals and lessons alongside the code. Use concise decision summaries; do not fabricate historical reasoning or turn private deliberation into a project artifact. The current product direction remains Martin's.

## Before implementation

Every implementation starts with a plan communicated in chat. Substantive work also gets a dated file under `docs/plans/` before code changes. Plans should contain:

1. Problem, intended outcome and observable acceptance criteria.
2. Current evidence, constraints, assumptions and questions that could change scope.
3. Meaningful options, chosen approach, reasons and tradeoffs.
4. Implementation steps and affected components.
5. Risks, safeguards, validation and recovery or rollback.
6. Explicit exclusions and deferred work.

Scale the plan to the task. A typo does not need an architecture proposal. Revise the plan when evidence changes the approach; distinguish completed steps from proposed ones. Proceed within authorized scope without requesting approval for routine reversible implementation choices.

## During implementation

Keep changes focused and reviewable. Preserve the core/UI boundary and deterministic simulation. Handle failures explicitly. Avoid silent data loss and destructive defaults. Keep credentials out of source. Choose dependencies only after reviewing their purpose, maintenance and implications.

For save changes, consider compatibility, malformed input, partial writes, recovery and migration tests. Atomic writes are one safeguard, not proof that every failure mode is covered. For destructive operations, define confirmation, undo or recovery appropriate to the action. For app lifecycle changes, test interruption and restoration.

Update plans and relevant architecture, setup, decision and changelog records as part of the same work. Record material defects promptly with cause, evidence and prevention. Newly considered alternatives must not be presented as choices evaluated during earlier work.

## Verification and delivery

Select tests from behavior and risk, including boundary and failure cases. Core changes require relevant core tests; app changes require a native build and applicable interaction/lifecycle checks. Fix required-check failures and verify the fix. Do not skip required checks to obtain a passing status.

Documentation-only changes require content, link and scope checks. Repeating native tests for unchanged code is unnecessary unless the documentation exposes a concern that requires investigation. Record exact tested commits and distinguish automated tests, build checks, manual inspection and unrun checks.

A delivery report states outcome, reasons, changes, executed checks and results, unresolved limitations, and where the work is committed. Passing compilation is not evidence of a working user interaction. Code committed for development must not be described as distribution-ready.

## Release gate

Before a player-facing release, define the release scope and require:

- Passing relevant automated tests and target-platform builds.
- Verified launch and primary gameplay paths on supported devices/platforms.
- Verified save/load, interruption, destructive actions and recovery scenarios relevant to that release.
- Review of accessibility, performance and applicable privacy/security behavior.
- No known material defect that threatens player data, security or essential functionality.
- Documented remaining limitations, compatibility and recovery/rollback instructions.

If a material check cannot be run, report the blocker and keep release status unverified. A release checklist is not proof of safety; attach the results. Signing and distribution require their own authorized work.

## Current baseline

The current app is a development sandbox. See [validation](VALIDATION.md) for passing core/build evidence and outstanding UI/device checks, [decisions](DECISIONS.md) for tradeoffs, and [lessons](LESSONS.md) for corrections. These instructions are process requirements; they do not configure branch protections or enforce checks through GitHub settings.
