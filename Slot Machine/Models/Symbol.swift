
import Foundation

struct Symbol: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let value: Int
}

extension Symbol {
    
    static var all: [Symbol] {
        [
            Symbol(icon: "gfx-bell", value: 20),
            Symbol(icon: "gfx-strawberry", value: 30),
            Symbol(icon: "gfx-cherry", value: 40),
            Symbol(icon: "gfx-grape", value: 50),
            Symbol(icon: "gfx-coin", value: 90),
            Symbol(icon: "gfx-seven", value: 100)
        ]
    }
}
