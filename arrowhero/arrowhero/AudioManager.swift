import SpriteKit
import AVFoundation

/// Simple SFX and BGM playback using CAF/MP3 (iOS-compatible).
enum AudioManager {
    enum Sound: String {
        case hit = "hit_01"
        case shot = "shot_01"
        case explosion = "explosion"
        case xpPickup = "plop_01"
        case levelUp = "key_open_01"
        case playerHit = "hit_02"
    }

    private static let hitVolume: Float = 0.35  // Softer — hit is sharp at full volume
    private static var players: [AVAudioPlayer] = []  // Retain until playback finishes
    private static var bgmPlayer: AVAudioPlayer?

    static func play(_ sound: Sound, on node: SKNode) {
        play(sound)
    }

    static func play(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "caf") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            switch sound {
            case .hit, .playerHit: player.volume = hitVolume
            default: player.volume = 1.0
            }
            players.append(player)
            player.play()
            // Don't prune here — removing players while AVAudioPlayer may have pending
            // callbacks causes EXC_BAD_ACCESS (finishedPlaying: on deallocated object).
        } catch { /* ignore */ }
    }

    // MARK: - BGM

    static func playBGM() {
        try? AVAudioSession.sharedInstance().setActive(true)
        guard let url = Bundle.main.url(forResource: "bgm_electronic", withExtension: "mp3") else { return }
        do {
            stopBGM()
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.6
            player.numberOfLoops = -1
            bgmPlayer = player
            player.prepareToPlay()
            player.play()
        } catch { /* ignore */ }
    }

    static func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }
}
