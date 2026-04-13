#!/usr/bin/env bash
# build.sh — Build MeshLink for iOS Simulator
# Requirements: Xcode installed, valid developer account (or free provisioning)
#
# Usage:
#   ./build.sh                  # builds for iPhone 15 simulator
#   ./build.sh "iPhone 14 Pro"  # builds for a specific simulator
#
# To run on a real device, open the project in Xcode and select your device.

set -euo pipefail

SIMULATOR="${1:-iPhone 15}"
SCHEME="MeshLink"
DERIVED_DATA="$(pwd)/.build/DerivedData"

echo "==> Building MeshLink for simulator: $SIMULATOR"

xcodebuild \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,name=$SIMULATOR" \
  -derivedDataPath "$DERIVED_DATA" \
  -configuration Debug \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  build

echo ""
echo "==> Build complete. To run in the simulator, open the .xcodeproj in Xcode"
echo "    or use 'xcrun simctl install' with the built .app bundle."
