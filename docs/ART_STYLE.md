# Arrow Survivor — Art Style Guide (MVP)

Version: 1.1 · Owner: Art + Design · Last updated: 2026-02-14

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
| Black | (20,20,20) |
| Dark Gray | (40,40,40) |
| Gray | (90,90,90) |
| Blue | (90,150,240) |
| Cyan | (110,230,230) |
| Red | (220,64,64) |
| Orange | (240,160,64) |
| Yellow | (250,220,120) |
| Green | (90,200,90) |
| Purple | (160,120,220) |
| Brown | (120,80,40) |

## MVP Asset List (Implemented)

### Hero (PixelArtKit)
- **Hero 1** — Mech-archer (default), 12×12, blue/cyan. Primary player sprite.
- **Hero 2** — Armored scout, 12×12, gray/orange. (Variant, not yet selectable.)
- **Hero 3** — Swift striker, 12×12, yellow/cyan. (Variant, not yet selectable.)

### Enemies (5 types, PixelArtKit)
| Type | Role | HP | Speed | AI |
|------|------|-----|-------|-----|
| Slime | Chaser | 3 | 1.0× | Moves toward player |
| Cultist | Ranged | 3 | 1.0× | Stops at range, shoots bolts |
| Bug Tank | Tank | 6 | 0.6× | Slow chaser |
| Dasher | Dasher | 2 | 1.6× | Fast chaser |
| Bat | Swarm | 1 | 1.25× | Quick chaser |

### Other
- **Projectiles:** arrow, crit variant (orange/yellow glow)
- **VFX:** hit sparks, crit, level-up pulse
- **Environment:** 16×16 ground tile (PixelAssets.groundTexture)
- **UI:** pause, HP bar, XP bar, upgrade cards (3-of-6, pixel icons)

## Pending / Future
- **Boss:** large silhouette, 2–3 telegraphs, death burst
- **XP orbs:** collectible sprites + magnet
- **Character animations:** idle (4–6), move (6–8), hurt flash

## Production Specs
- Character: 12–16px @1x, render 2–3x
- Tiles: 16×16 @1x, scale 3x
- Frames: idle 4–6, move 6–8, telegraph 2–3, VFX 3–5
- Export: PNG sprite sheets; Aseprite masters
- Atlas: player.atlas, enemies.atlas, vfx.atlas, ui.atlas

## Integration
- `SKTexture.filteringMode = .nearest`; `node.setScale(3.0)` for hero and enemies.
- **PixelArtKit.swift**: ASCII grid → SKTexture (legend mapping). Used for hero, all 5 enemies, projectiles, ground tile.
- **Sounds/**: SFX as CAF (hit_01, shot_01, explosion, plop_01, key_open_01, hit_02); BGM as MP3 (bgm_electronic).
