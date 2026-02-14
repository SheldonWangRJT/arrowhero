#!/bin/bash
# Build arrowhero for iOS Simulator without getting stuck.
# Uses -sdk instead of -destination to avoid CoreSimulatorService hang.

set -e
cd "$(dirname "$0")/arrowhero"
xcodebuild -scheme arrowhero -sdk iphonesimulator -arch arm64 build
