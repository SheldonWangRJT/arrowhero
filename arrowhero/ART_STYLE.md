// Arrow Survivor — Art Style Guide (MVP)

Version: 1.0  
Owner: Art + Design  
Last updated: 2026-02-14

## Vision
- Pixel-style visuals with simple, punchy VFX. Crisp silhouettes, readable motion, cohesive color palette.
- Thematic direction: ALIGN + SPACE + ROBOT — a retro-future vibe. Think compact mechs, slimes-as-nanogoo, cultist-drones, and industrial space ruins.
- Prioritize gameplay readability over detail. Backgrounds are low-contrast; characters and FX are saturated and bright.

## Core Style
- Pixel art at small base resolutions (8–16px tiles, 12–16px characters) scaled up 2–3x in-engine with nearest-neighbor filtering.
- Simple shading (1–2 tones) plus additive glows for VFX.
- Minimal frame counts (4–8 frames) for idle/move loops; use scale/alpha animations to enhance impact.

## Palette (Starting Point)
- Background: dark gray/olive variants (low saturation)
- Characters: white/blue/cyan for player/mech; green/red/orange for enemies
- FX: yellow/orange for hits/crit; blue/cyan for player projectiles; red/orange for enemy bolts

Example RGB (from PixelArtKit):
- White: (240,240,240)
- Dark Gray: (40,40,40)
- Blue: (90,150,240)
- Cyan: (110,230,230)
- Red: (220,64,64)
- Orange: (240,160,64)
- Yellow: (250,220,120)
- Green: (90,200,90)
- Purple: (160,120,220)
- Brown (industrial accents): (120,80,40)

## MVP Asset List
- Player (mech-archer)
  - Idle (4–6 frames), Move (6–8 frames), Hurt flash overlay
  - Projectile: arrow/bolt with faint trail; crit glow variant
- Enemies (4 base types)
  - Slime (nanogoo chaser): idle/move, hit flash, death pop
  - Bug Tank (armored drone): idle/move, hit flash, death pop
  - Dasher (arrowhead interceptor): idle/move, charge telegraph, hit/death
  - Cultist (ranged automaton): idle/cast, bolt projectile, hit/death
- Boss (1)
  - Large silhouette, 2–3 telegraphs, death burst
- VFX
  - Hit sparks (3 frames), crit variant, level-up ring pulse
  - XP orb
- Environment
  - Ground tiles (16x16) with subtle noise; 2–3 variants
  - Sparse props (rocks, panels, beacons)
- UI
  - Icons (pause, play, debug, HP, XP, speed, projectile)
  - Upgrade card backgrounds with rarity tints

## Production Specs
- Character base height: 12–16px @1x; render at 2–3x in-engine
- Tiles: 16x16 @1x (scale 3x), seamless edges
- Frame counts: idle 4–6, move 6–8, telegraph 2–3, VFX 3–5
- Export: PNG sprite sheets; keep vector/pixel masters (Aseprite .aseprite, Affinity/Figma for UI)
- Naming
  - player_idle_01..06.png, player_move_01..08.png
  - enemy_slime_move_01..06.png, enemy_bug_move_01..06.png
  - vfx_hit_01..03.png, vfx_crit_01..03.png
  - proj_player_arrow.png, proj_enemy_bolt.png
  - tile_ground_01.png
- Atlas: group into player.atlas, enemies.atlas, vfx.atlas, ui.atlas

## Readability & Motion
- Strong silhouette per enemy family; keep props/background muted
- Use scale/alpha pulses for hits/level-up; additive blending for glows
- Avoid busy patterns on the battlefield; ensure enemies pop against ground

## Sourcing & References
- Temporary/generated assets: in-code via PixelArtKit.swift (ASCII → SKTexture) for fast iteration
- Marketplaces: Kenney.nl, Itch.io, GameDev Market (search: “pixel sci-fi”, “mech”, “top-down shooter”)
- Commission: brief artists with silhouettes, palette, and sizes from this doc

## Integration Notes
- Engine scaling: set SKTexture.filteringMode = .nearest and node.setScale(2–3)
- Replace temp generated textures with real PNGs by swapping factory calls with atlas-loaded textures
- Keep gameplay hitboxes separate from sprite bounds (consistent feel across skins)

## Future Extensions
- Parallax background layer (subtle) for depth
- Thematic variants per biome (space station, asteroid mine, derelict ship)
- Cosmetic skins: mech colorways, trail styles, XP orb variants
