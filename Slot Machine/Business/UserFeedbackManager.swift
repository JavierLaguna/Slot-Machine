
import UIKit

struct UserFeedbackManager {
    
    static let shared = UserFeedbackManager()
    
    private let haptics = UINotificationFeedbackGenerator()
    
    private init() {
        // Empty
    }
    
    func on(_ event: FeedbackEvent) {
        if let sound = event.sound {
            manage(sound: sound)
        }
        
        if let haptic = event.haptic {
            manage(haptic: haptic)
        }
    }
}

private extension UserFeedbackManager {
    
    func manage(sound: String) {
        let soundDisabled = UserDefaults.standard.bool(forKey: BusinessConstants.UserDefaults.soundDisabled)
        
        if !soundDisabled {
            playSound(sound: sound, type: "mp3")
        }
    }
    
    func manage(haptic type: UINotificationFeedbackGenerator.FeedbackType) {
        haptics.notificationOccurred(type)
    }
}
