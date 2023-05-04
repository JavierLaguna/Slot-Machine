
import SwiftUI

struct GameOverModal: View {
    
    private let onPressNewGameButton: () -> Void
    
    init(onPressNewGameButton: @escaping () -> Void) {
        self.onPressNewGameButton = onPressNewGameButton
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("GAME OVER")
                .font(.system(.title, design: .rounded))
                .fontWeight(.heavy)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color("ColorPink"))
                .foregroundColor(Color.white)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 16) {
                Image("gfx-seven-reel")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 72)
                
                Text("Bad luck! You lost all of the coins. \nLet's play again!")
                    .font(.system(.body, design: .rounded))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
                    .layoutPriority(1)
                
                Button(action: onPressNewGameButton) {
                    Text("New Game".uppercased())
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .accentColor(Color("ColorPink"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(minWidth: 128)
                        .background(
                            Capsule()
                                .strokeBorder(lineWidth: 1.75)
                                .foregroundColor(Color("ColorPink"))
                        )
                }
            }
            
            Spacer()
        }
        .modifier(BlurModalModifier())
    }
}

struct GameOverModal_Previews: PreviewProvider {
    
    static var previews: some View {
        GameOverModal() {
            
        }
    }
}
