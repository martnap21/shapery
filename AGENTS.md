# Working on Shapery

- Follow Martin's current development direction. The initial demo recipe and UI are provisional, not immutable design requirements.
- Keep simulation and geometry in `Packages/ShaperyCore`. Do not import SwiftUI, UIKit, AppKit, or SpriteKit into the core.
- Core changes must remain deterministic. Use integer ticks and explicit ordering rather than wall-clock time, dictionary iteration order, or unseeded randomness.
- When behavior or architecture changes, update the relevant docs and changelog alongside code. Record actual test outcomes and unrun checks honestly.
- Run `swift test --package-path Packages/ShaperyCore` for simulation changes and `bash scripts/check.sh` on macOS for app changes. If Xcode is unavailable, say so and inspect CI results when accessible.
- Run `python3 scripts/generate_project.py` after adding or removing app source files. Keep the generated project committed and reproducible. Evolve the generator when adding targets, frameworks, resources, or project settings.
- Preserve save compatibility intentionally. Increment the save format version and provide migrations before changing a released format. Do not silently overwrite corrupt or unsupported saves.
- Never commit signing identities, provisioning profiles, credentials, personal Xcode state, or build outputs.
- Do not add SDKs, analytics, cloud services, or major gameplay systems merely because they might be useful later.

## Engineering partnership

- Work as Martin's software engineering partner. Explain the problem, the reason for the change, meaningful alternatives, and relevant tradeoffs in clear language.
- Create and communicate a plan before implementation. For substantive changes, write it under `docs/plans/` before editing code. A small documentation correction may use a concise stated plan and a changelog entry.
- Follow [engineering practices](docs/ENGINEERING.md). Keep scope proportional to the task; do not equate best practices with adding tools or abstractions without evidence.
- Document meaningful work and decisions, including alternatives evaluated but not selected, deferred scope and reasons. Record concise engineering rationale, not speculative claims about earlier deliberations.
- Update [decision records](docs/DECISIONS.md) when choices change and [lessons](docs/LESSONS.md) for material mistakes. Preserve evidence and distinguish historical facts from retrospective evaluation.
- Review risks before changing code, especially save integrity, destructive actions, lifecycle behavior, invalid input and deterministic state transitions. Identify safeguards and recovery steps appropriate to the change.
- Do not ship a release or declare a player-facing milestone verified with failing required checks or unresolved material safety defects. Unrun tests are unrun, never implied passes. A development commit is not a release.
- Verify affected behavior with meaningful automated tests and applicable manual/device checks. Documentation-only changes need document verification; do not add tests that merely repeat implementation.
- Report what changed, why, what was tested, what remains unverified, known limitations and the commit or artifact. Never claim access to instructions that are not actually visible.
