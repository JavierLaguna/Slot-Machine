
import SwiftUI

struct StopButton: View {
    
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image("gfx-reel")
                .renderingMode(.original)
                .resizable()
                .modifier(ImageModifier())
                .overlay {
                    Text("STOP")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(Color("ColorYellow"))
                        .shadow(radius: 2, x: 2, y: 4)
                     
                }
        }
    }
}

struct StopButton_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            StopButton() {
                
            }
            
            HStack {
                StopButton() {
                    
                }
                    
                Button(action: {}) {
                    Image("gfx-spin")
                        .renderingMode(.original)
                        .resizable()
                        .modifier(ImageModifier())
                }
            }
            .previewDisplayName("With SPIN Button")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
