# Plan: engineering partnership practices

Date: 2026-10-31
Scope: repository guidance and documentation only.
Status: planned before editing; completed documentation changes are recorded in the commit.

## Goal and reason

Make Martin's engineering expectations durable: explain purpose, compare meaningful options, plan before implementation, protect player data, test changes, and retain decisions and lessons.

## Options

- Chat-only agreement: insufficient because future contributors need the same expectations.
- Repository guidance with linked plans, decisions, lessons and validation: selected; reviewable alongside code.
- Add new tooling and safety systems immediately: deferred until concrete risks and acceptance criteria justify them.

## Steps

1. Read current AGENTS.md, architecture, validation and changelog at the current main commit.
2. Update contributor guidance and document a proportional planning, implementation and release workflow.
3. Record the bootstrap's established decisions and known mistake. Label newly evaluated alternatives as retrospective.
4. Make unverified behavior and release blockers explicit without changing previous test results.
5. Check document links, scope and consistency; commit against the inspected branch head without overwriting concurrent work.

## Acceptance criteria

- Every implementation requires a prior plan; significant work retains that plan in the repository.
- Decision summaries record options, rationale, tradeoffs and deferred work.
- Mistakes include evidence, correction, verification and prevention.
- Release gates require appropriate passing tests and risk-specific safety checks.
- No claim that the current prototype is ready for distribution.
- This update changes no app code, build settings, dependencies or saves.

## Validation and recovery

Check Markdown links and changed paths. Existing code test results remain tied to their tested commit; this documentation-only update does not require another native build. Any automatically triggered CI remains supplementary. Revert this documentation commit to undo the change.

## Not implemented

No UI tests, save recovery redesign, gameplay features, CI modifications, branch protection changes or distribution work. These require separate plans and verification.
