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
