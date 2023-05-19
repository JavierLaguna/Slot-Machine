
enum GameMode: String, CaseIterable {
    case auto = "autoGameMode"
    case manual = "manualGameMode"
}

extension GameMode {
    
    var name: String {
        switch self {
        case .auto:
            return "Auto Stop"
        case .manual:
            return "Manual Stop"
        }
    }
}
