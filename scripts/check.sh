#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
swift test --package-path Packages/ShaperyCore
if [[ "$(uname -s)" == "Darwin" ]]; then
  xcodebuild -project Shapery.xcodeproj -scheme Shapery \
    -configuration Debug -destination 'generic/platform=iOS Simulator' \
    -derivedDataPath DerivedData CODE_SIGNING_ALLOWED=NO build
else
  echo "Core tests complete; the iOS build requires macOS and Xcode."
fi
