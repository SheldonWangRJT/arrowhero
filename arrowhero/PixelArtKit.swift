import SpriteKit
import CoreGraphics

// MARK: - PixelArtKit
// Build SKTextures from tiny pixel grids (ASCII legend) with nearest-neighbor filtering.
// This lets us ship a cohesive pixel-art MVP without external PNGs.

enum PixelArt {
    // RGBA8 helper: 0xRRGGBBAA
    static func rgba(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8 = 255) -> UInt32 {
        return (UInt32(r) << 24) | (UInt32(g) << 16) | (UInt32(b) << 8) | UInt32(a)
    }

    // Common palette
    enum Palette {
        static let clear: UInt32 = 0x00000000
        static let white: UInt32 = rgba(240, 240, 240)
        static let black: UInt32 = rgba(20, 20, 20)
        static let gray: UInt32  = rgba(90, 90, 90)
        static let darkGray: UInt32 = rgba(40, 40, 40)
        static let red: UInt32   = rgba(220, 64, 64)
        static let orange: UInt32 = rgba(240, 160, 64)
        static let yellow: UInt32 = rgba(250, 220, 120)
        static let green: UInt32 = rgba(90, 200, 90)
        static let blue: UInt32  = rgba(90, 150, 240)
        static let cyan: UInt32  = rgba(110, 230, 230)
        static let purple: UInt32 = rgba(160, 120, 220)
        static let brown: UInt32 = rgba(120, 80, 40)
    }

    // Build a pixel buffer from ASCII rows and a legend mapping.
    static func pixels(from rows: [String], legend: [Character: UInt32]) -> (data: [UInt32], width: Int, height: Int) {
        let height = rows.count
        let width = rows.first?.count ?? 0
        var buffer = [UInt32](repeating: Palette.clear, count: width * height)
        for (y, row) in rows.enumerated() {
            for (x, ch) in row.enumerated() {
                buffer[y * width + x] = legend[ch] ?? Palette.clear
            }
        }
        return (buffer, width, height)
    }

    // Create SKTexture from RGBA8 buffer (top-left rows[0]).
    static func texture(from rgba: [UInt32], width: Int, height: Int) -> SKTexture {
        var data = rgba // copy mutable
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)
        guard let provider = CGDataProvider(data: NSData(bytes: &data, length: data.count * bytesPerPixel)) else {
            return SKTexture()
        }
        guard let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bytesPerPixel * bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        ) else {
            return SKTexture()
        }
        let tex = SKTexture(cgImage: cgImage)
        tex.filteringMode = .nearest
        return tex
    }

    // Convenience: build texture from ASCII grid and legend
    static func texture(rows: [String], legend: [Character: UInt32]) -> SKTexture {
        let (buf, w, h) = pixels(from: rows, legend: legend)
        return texture(from: buf, width: w, height: h)
    }

    // Convenience: sprite
    static func sprite(rows: [String], legend: [Character: UInt32], scale: CGFloat = 3.0) -> SKSpriteNode {
        let tex = texture(rows: rows, legend: legend)
        let node = SKSpriteNode(texture: tex)
        node.setScale(scale)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return node
    }
}

// MARK: - Prebuilt Assets (ASCII grids)
// Legend keys:
// . = clear
// w = white, k = black, g = gray, d = darkGray
// r = red, o = orange, y = yellow, G = green, b = blue, c = cyan, p = purple, B = brown

struct PixelAssets {
    static let legend: [Character: UInt32] = [
        ".": PixelArt.Palette.clear,
        "w": PixelArt.Palette.white,
        "k": PixelArt.Palette.black,
        "g": PixelArt.Palette.gray,
        "d": PixelArt.Palette.darkGray,
        "r": PixelArt.Palette.red,
        "o": PixelArt.Palette.orange,
        "y": PixelArt.Palette.yellow,
        "G": PixelArt.Palette.green,
        "b": PixelArt.Palette.blue,
        "c": PixelArt.Palette.cyan,
        "p": PixelArt.Palette.purple,
        "B": PixelArt.Palette.brown,
    ]

    // Player (hooded archer) 12x12
    static let playerRows: [String] = [
        "....gggg....",
        "...gwwwwg...",
        "..gwwywwwg..",
        "..gwwwwwgg..",
        "..gwwkwwwg..",
        "...gwwwgg...",
        "....gwwg....",
        "..BBBBBBBB..",
        "..BggggggB..",
        "..BggggggB..",
        "...BBBBBB...",
        "....B..B....",
    ]

    // Slime (chaser) 12x12
    static let slimeRows: [String] = [
        "............",
        "....GGGG....",
        "..GGGGGGGG..",
        ".GGGGGGGGGG.",
        ".GGGgGGgGGG.",
        ".GGGGGGGGGG.",
        ".GGGGGGGGGG.",
        "..GGGGGGGG..",
        "...GGGGGG...",
        "....GGGG....",
        ".....GG.....",
        "............",
    ]

    // Bug Tank (square armored) 12x12
    static let bugRows: [String] = [
        "............",
        "..BBBBBBBB..",
        ".BBBBBBBBBB.",
        ".BddddddddB.",
        ".BddddddddB.",
        ".BddddddddB.",
        ".BddddddddB.",
        ".BBBBBBBBBB.",
        "..BBBBBBBB..",
        "...B....B...",
        "...B....B...",
        "............",
    ]

    // Dasher (arrowhead) 12x12
    static let dasherRows: [String] = [
        ".....r......",
        "....rrr.....",
        "...rrrrr....",
        "..rrrrrrr...",
        ".rrrrrrrrr..",
        "rrrrrrrrrrr",
        ".rrrrrrrrr..",
        "..rrrrrrr...",
        "...rrrrr....",
        "....rrr.....",
        ".....r......",
        "............",
    ]

    // Cultist (ranged) 12x12
    static let cultistRows: [String] = [
        "....pppp....",
        "...ppwwpp...",
        "..ppwyywpp..",
        "..ppwwwwpp..",
        "..pppppppp..",
        "...pppppp...",
        "....pppp....",
        "....pkkp....",
        "....pkkp....",
        "....pppp....",
        "...p....p...",
        "............",
    ]

    // Player arrow (projectile) 12x3
    static let arrowRows: [String] = [
        "rroooooooo..",
        "..wwwwwwww..",
        "rroooooooo..",
    ]

    // Enemy bolt (projectile) 6x6
    static let boltRows: [String] = [
        ".bbbb.",
        "bbbbbb",
        "bbbbbb",
        "bbbbbb",
        "bbbbbb",
        ".bbbb.",
    ]

    // Hit spark frames (ring-ish) 8x8 x 3
    static let hitSpark1: [String] = [
        "..y....y..",
        ".y......y.",
        ".........",
        ".........",
        ".........",
        ".y......y.",
        "..y....y..",
    ]
    static let hitSpark2: [String] = [
        ".y......y.",
        ".........",
        "..y....y..",
        ".........",
        "..y....y..",
        ".........",
        ".y......y.",
    ]
    static let hitSpark3: [String] = [
        "y........y",
        ".........",
        ".........",
        "....y....",
        ".........",
        ".........",
        "y........y",
    ]

    // XP orb 8x8
    static let xpOrbRows: [String] = [
        "..cbbbc..",
        ".cbbbbbcc",
        ".bbbbbbbb",
        ".bbbbbbbb",
        ".bbbbbbbb",
        ".bbbbbbbb",
        ".ccbbbbc.",
        "..cbbbc..",
    ]

    // Ground tile 16x16 (subtle checker/noise)
    static let groundRows: [String] = [
        "dddddddddddddddd",
        "ddBddddddddddBdd",
        "dddddddddddddddd",
        "ddddddBddddddddd",
        "dddddddddddddddd",
        "dddddBdddddddddd",
        "dddddddddddddddd",
        "dddBdddddddddddd",
        "dddddddddddddddd",
        "ddddddddddBddddd",
        "dddddddddddddddd",
        "ddBddddddddddddd",
        "dddddddddddddddd",
        "dddddddddBdddddd",
        "dddddddddddddddd",
        "dddddddddddddddd",
    ]

    // Factory functions (textures)
    static func playerTexture() -> SKTexture { PixelArt.texture(rows: playerRows, legend: legend) }
    static func slimeTexture() -> SKTexture { PixelArt.texture(rows: slimeRows, legend: legend) }
    static func bugTankTexture() -> SKTexture { PixelArt.texture(rows: bugRows, legend: legend) }
    static func dasherTexture() -> SKTexture { PixelArt.texture(rows: dasherRows, legend: legend) }
    static func cultistTexture() -> SKTexture { PixelArt.texture(rows: cultistRows, legend: legend) }
    static func arrowTexture() -> SKTexture { PixelArt.texture(rows: arrowRows, legend: legend) }
    static func boltTexture() -> SKTexture { PixelArt.texture(rows: boltRows, legend: legend) }
    static func xpOrbTexture() -> SKTexture { PixelArt.texture(rows: xpOrbRows, legend: legend) }
    static func groundTexture() -> SKTexture { PixelArt.texture(rows: groundRows, legend: legend) }

    static func hitSparkTextures() -> [SKTexture] {
        [
            PixelArt.texture(rows: hitSpark1, legend: legend),
            PixelArt.texture(rows: hitSpark2, legend: legend),
            PixelArt.texture(rows: hitSpark3, legend: legend)
        ]
    }

    // Convenience sprites
    static func playerSprite(scale: CGFloat = 3.0) -> SKSpriteNode { SKSpriteNode(texture: playerTexture()) }
    static func slimeSprite(scale: CGFloat = 3.0) -> SKSpriteNode { SKSpriteNode(texture: slimeTexture()) }
    static func bugTankSprite(scale: CGFloat = 3.0) -> SKSpriteNode { SKSpriteNode(texture: bugTankTexture()) }
    static func dasherSprite(scale: CGFloat = 3.0) -> SKSpriteNode { SKSpriteNode(texture: dasherTexture()) }
    static func cultistSprite(scale: CGFloat = 3.0) -> SKSpriteNode { SKSpriteNode(texture: cultistTexture()) }
    static func arrowSprite(scale: CGFloat = 3.0) -> SKSpriteNode { SKSpriteNode(texture: arrowTexture()) }
    static func boltSprite(scale: CGFloat = 3.0) -> SKSpriteNode { SKSpriteNode(texture: boltTexture()) }
}

// Note: integrate by swapping SKShapeNode enemies/projectiles with SKSpriteNodes using these textures.
// Example:
// let enemy = SKSpriteNode(texture: PixelAssets.slimeTexture()); enemy.setScale(3.0)
// let arrow = SKSpriteNode(texture: PixelAssets.arrowTexture()); arrow.setScale(3.0)
