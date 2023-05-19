
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
        SoundManager.shared.playSound(sound: sound)
    }
    
    func manage(haptic type: UINotificationFeedbackGenerator.FeedbackType) {
        haptics.notificationOccurred(type)
    }
}
