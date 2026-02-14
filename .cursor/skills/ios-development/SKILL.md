---
name: ios-development
description: Build, run, and debug iOS apps with Xcode, xcodebuild, Swift, SwiftUI, and UIKit. Use when building iOS projects, configuring Xcode schemes, fixing simulator issues, or working with Swift code for iPhone/iPad.
---

# iOS Development

## Building from Terminal
- Use `-sdk iphonesimulator -arch arm64` to avoid CoreSimulatorService hangs; omit `-destination` when simulator service is unavailable
- `xcodebuild -scheme <name> -sdk iphonesimulator -arch arm64 build`
- For device: `-destination 'generic/platform=iOS'` (requires signing)
- List schemes: `xcodebuild -list`

## Key Paths
- DerivedData: `~/Library/Developer/Xcode/DerivedData/<project>-<hash>/Build/Products/`
- Simulator apps: `.../Debug-iphonesimulator/<App>.app`
- Device apps: `.../Debug-iphoneos/<App>.app`

## Simulator
- Boot: `xcrun simctl boot "iPhone 17"` (or device name)
- Install: `xcrun simctl install booted /path/to/App.app`
- Launch: `xcrun simctl launch booted <bundleId>`
- List devices: `xcrun simctl list devices available`

## Debugging in Cursor
- Extensions: CodeLLDB + iOS Debug
- launch.json: `program` → path to .app; `iosBundleId`; `iosTarget: "select"`
- lldb.library: `/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB`

## Swift / Xcode
- iOS 26+ uses deployment target 26.2
- Simulators: iPhone 17, iPhone 17 Pro, iPhone Air (not iPhone 16 on Xcode 26)
- UITouch, UIEvent: UIKit-only; not available when building for macOS
