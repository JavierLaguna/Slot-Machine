
import SwiftUI

struct ReelButton: View {
    
    private let text: String
    private let action: () -> Void
    
    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image("gfx-reel")
                .renderingMode(.original)
                .resizable()
                .modifier(ImageModifier())
                .overlay {
                    Text(text.uppercased())
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(Color("ColorYellow"))
                        .shadow(radius: 2, x: 2, y: 4)
                     
                }
        }
    }
}

struct ReelButton_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ReelButton("stop") {
                
            }
            
            HStack {
                ReelButton("stop") {
                    
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
