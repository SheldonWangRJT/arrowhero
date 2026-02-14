# Arrow Survivor — Art Style Guide (MVP)

Version: 1.0 · Owner: Art + Design · Last updated: 2026-02-14

## Vision
- Pixel-style visuals, punchy VFX. Crisp silhouettes, readable motion, cohesive palette.
- Thematic: ALIGN + SPACE + ROBOT — retro-future. Mechs, slimes-as-nanogoo, cultist-drones.
- Readability over detail. Low-contrast backgrounds; saturated characters and FX.

## Core Style
- 8–16px tiles, 12–16px characters; scale 2–3x, nearest-neighbor.
- Simple shading (1–2 tones) + additive glows.
- Minimal frames (4–8) for idle/move; scale/alpha for impact.

## Palette (PixelArtKit reference)
| Color | RGB |
|-------|-----|
| White | (240,240,240) |
| Dark Gray | (40,40,40) |
| Blue | (90,150,240) |
| Cyan | (110,230,230) |
| Red | (220,64,64) |
| Orange | (240,160,64) |
| Yellow | (250,220,120) |
| Green | (90,200,90) |
| Purple | (160,120,220) |
| Brown | (120,80,40) |

## MVP Asset List
- **Player:** idle (4–6), move (6–8), hurt flash; projectile + crit variant
- **Enemies (4):** Slime (chaser), Bug Tank, Dasher, Cultist (ranged)
- **Boss:** large silhouette, 2–3 telegraphs, death burst
- **VFX:** hit sparks, crit, level-up pulse, XP orb
- **Environment:** 16×16 tiles, sparse props
- **UI:** pause, HP, XP, upgrade card backgrounds

## Production Specs
- Character: 12–16px @1x, render 2–3x
- Tiles: 16×16 @1x, scale 3x
- Frames: idle 4–6, move 6–8, telegraph 2–3, VFX 3–5
- Export: PNG sprite sheets; Aseprite masters
- Atlas: player.atlas, enemies.atlas, vfx.atlas, ui.atlas

## Integration
- `SKTexture.filteringMode = .nearest`; `node.setScale(2–3)`
- Temp: PixelArtKit.swift (ASCII → SKTexture); replace with PNG atlas.
