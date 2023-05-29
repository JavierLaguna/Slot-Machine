
import UIKit

enum FeedbackEvent {
    case spin
    case endSpin
    case changeBet
    case win
    case newHighScore
    case gameOver
    case resetGame
    case pressStopButton
}

// MARK: Sound
extension FeedbackEvent {
    
    var sound: String? {
        switch self {
        case .spin: return "riseup"
        case .endSpin: return "spin"
        case .changeBet: return "casino-chips"
        case .win: return "win"
        case .newHighScore: return "high-score"
        case .gameOver: return "game-over"
        case .resetGame: return "chimeup"
        default: return nil
        }
    }
}

// MARK: Haptics
extension FeedbackEvent {
    
    var haptic: UINotificationFeedbackGenerator.FeedbackType? {
        switch self {
        case .spin, .changeBet: return .success
        case .pressStopButton: return .warning
        default: return nil
        }
    }
}
