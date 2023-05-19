
import AVFoundation

final class SoundManager {
    
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        // Empty
    }
    
    func playSound(sound: String, type: String = "mp3") {
        let soundDisabled = UserDefaults.standard.bool(forKey: BusinessConstants.UserDefaults.soundDisabled)
        
        if !soundDisabled,
           let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not find and play the sound file!")
            }
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}
