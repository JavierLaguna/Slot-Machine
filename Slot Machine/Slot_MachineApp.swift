
import SwiftUI

@main
struct Slot_MachineApp: App {
    
    private func configureWindowSize() {
        if let windowScene {
            let size = CGSize(width: 800, height: 1200)
            
            windowScene.sizeRestrictions?.minimumSize = size
            windowScene.sizeRestrictions?.maximumSize = size
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    configureWindowSize()
                }
        }
    }
}
