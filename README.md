# arrowhero

Survivor-roguelite iOS game inspired by Arrow Legend / Archero. Short sessions, deep build variety, strong upgrade dopamine.

## Quick Start

```bash
# Clone
git clone https://github.com/SheldonWangRJT/arrowhero.git && cd arrowhero

# Build (from project root)
./build.sh

# Open in Xcode
open arrowhero/arrowhero.xcodeproj
```

**Tech:** SwiftUI + SpriteKit · iOS 26+ (Xcode 26)

## Project Structure

```
arrowhero/
├── arrowhero/arrowhero.xcodeproj
├── arrowhero/arrowhero/           # Source
│   ├── ArrowSurvivorApp.swift
│   ├── ContentView.swift
│   ├── GameScene.swift
│   ├── Models.swift
│   ├── UpgradeChoiceView.swift
│   └── Assets.xcassets
├── docs/                          # Planning & design
├── .vscode/                       # Cursor debug config
└── build.sh
```

## Documentation

| Doc | Purpose |
|-----|---------|
| [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) | Quick reference for AI / dev context |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Milestones, progress, checklist |
| [docs/PRODUCT_PLAN.md](docs/PRODUCT_PLAN.md) | Vision, systems, economy |
| [docs/ART_STYLE.md](docs/ART_STYLE.md) | Pixel art guide, palette |
| [run-and-debug.md](run-and-debug.md) | Cursor debugging setup |

## Development

- **Build:** `./build.sh` (uses `-sdk iphonesimulator` to avoid simulator hangs)
- **Debug in Cursor:** F5 → "arrowhero (iOS Simulator)" (needs CodeLLDB + iOS Debug)
- **Xcode:** Full support; open `.xcodeproj` directly
