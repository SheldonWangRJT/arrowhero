# Running & Debugging arrowhero in Cursor

## Quick start

1. **Open the project** in Cursor: `File > Open Folder` → select `arrowhero`

2. **Install extensions** (required for debugging):
   - Press `Cmd+Shift+X` to open Extensions
   - Install **CodeLLDB** (vadimcn.vscode-lldb)
   - Install **iOS Debug** (nisargjhaveri.ios-debug)
   
   Or run in terminal: `cursor --install-extension vadimcn.vscode-lldb --install-extension nisargjhaveri.ios-debug`

3. **Start the Simulator** (if not running):
   - Open Xcode → Window → Devices and Simulators, or run `open -a Simulator`

4. **Run with debugger**:
   - Press `F5` or `Run > Start Debugging`
   - Choose **"arrowhero (iOS Simulator)"**
   - When prompted for target, pick an iOS Simulator (e.g. iPhone 17)

## Launch configurations

| Config | Use |
|--------|-----|
| **arrowhero (iOS Simulator)** | Build, install, launch with debugger. Sets breakpoints. |
| **arrowhero (Attach)** | Attach to an already-running app on simulator/device. |

## Troubleshooting

- **"Supported platforms is empty"** – The build uses `-sdk iphonesimulator` to avoid simulator service hangs.
- **Simulator not listed** – Start Simulator.app first, or run: `open -a Simulator`
- **Build fails** – Run build manually: `./build.sh` from the arrowhero folder.
