
struct BusinessConstants {
    
    struct UserDefaults {
        static let highScore = "UD_HighScore"
        static let soundDisabled = "UD_SoundDisabled"
        static let vibrationDisabled = "UD_VibrationDisabled"
        static let gameMode = "UD_GameMode"
        static let coins = "UD_Coins"
    }
    
    struct DefaultValues {
        static let initialCoins = 100
        static let highScore = 0
        static let soundDisabled = false
        static let vibrationDisabled = false
        static let gameMode: GameMode = .auto
    }
    
    struct Game {
        static let minRotations = 3
        static let maxRotations = 7
    }
}
