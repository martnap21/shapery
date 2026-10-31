# Development setup

## Requirements

- Mac capable of running Xcode 16 or newer; Swift tools 5.9+ for the standalone core. The app uses Swift 5 language mode and targeted concurrency checks.
- An iOS 17+ simulator runtime, installed through Xcode. The repository does not pin a particular simulator model.
- Git. Python 3 is needed only to regenerate the project, and in CI to verify reproducibility.
- Your Apple signing team only when deploying to hardware. Simulator builds do not require signing.

Open `Shapery.xcodeproj`, select Shapery and a supported simulator, then run. The project has a local package reference at `Packages/ShaperyCore`. Keep that folder next to the project. No Homebrew, CocoaPods, XcodeGen, or remote Swift packages are required.

## Common commands

```bash
swift test --package-path Packages/ShaperyCore
bash scripts/check.sh
xcodebuild -project Shapery.xcodeproj -scheme Shapery \
  -configuration Release -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath DerivedData CODE_SIGNING_ALLOWED=NO build
```

If command-line tools point to CommandLineTools instead of Xcode, select the installed Xcode in **Xcode Settings → Locations → Command Line Tools**. If an iOS destination is missing, install a simulator runtime in Xcode. Keep any local paths or signing overrides out of shared configuration unless they are genuinely project-wide.

## Adding files and targets

The committed project can be opened immediately. `scripts/generate_project.py` deterministically regenerates it using Python's standard library. It discovers top-level `.swift` files in `Apps/iOS/Shapery`, includes the declared resource files, links the local package, and writes a shared scheme. It does not recursively discover future subfolders or arbitrary resources: update the generator when introducing those. New core files are automatically discovered by SwiftPM.

Changes made only in Xcode's project editor can be lost on regeneration. Keep reusable project settings in `Configuration/Base.xcconfig`; update the generator for target, source, resource and scheme changes. CI checks that regeneration yields no diff.

## Debugging

- Break on `Factory.advance()` for production and transport.
- Break on `FactorySession.edit(at:)` for placement, rotation and removal.
- Inspect the `factory` snapshot in the debugger to compare buffers and output tokens.
- Use Xcode's device container tools to inspect `Library/Application Support/Shapery/factory-v1.json` in a simulator/device container. Confirm Reset in-app to replace it intentionally.

## Before shipping

This is a development environment. A release still needs app icons and other artwork, device and accessibility testing, performance/power profiling, audio policy, final privacy review, app signing/distribution configuration and a chosen license. The included privacy manifest reflects no tracking, collected data or required-reason API use in this starter; revise it when adding capabilities or SDKs.
