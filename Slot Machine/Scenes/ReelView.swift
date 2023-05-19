
import SwiftUI

struct ReelView: View {
    
    @AppStorage(BusinessConstants.UserDefaults.gameMode)
    private var gameMode: GameMode = BusinessConstants.DefaultValues.gameMode
    
    private let animationShortDuration = 0.1
    private let animationDuration = 0.2
    private let positionVariation = 50.0
    private let rotationScale = 0.8
    
    private let symbols: [Symbol]
    private let reelState: ReelState
    private let onEndSpin: (_ symbol: Symbol) -> Void
    
    @State private var currentSymbols: [Symbol]
    @State private var rotations = 0
    @State private var opacityAndScale: Double = 0.9
    @State private var position: Double = 0
    @State private var isSpinning = false
    
    var selectedSymbol: Symbol? {
        currentSymbols[1]
    }
    
    init(symbols: [Symbol], reelState: ReelState = .stop, onEndSpin: @escaping (_: Symbol) -> Void) {
        self.symbols = symbols
        self.reelState = reelState
        self.onEndSpin = onEndSpin
        
        currentSymbols = Array(symbols[0..<3])
    }
    
    private func onChange(reelState newReelState: ReelState) {
        switch newReelState {
        case .spinning(let times):
            startSpinning(for: times)
            
        case .spinningInfinite:
            startSpinningInfinite()
            
        case .stop:
            stopSpinning()
        }
    }
    
    private func startSpinning(for rotations: Int) {
        self.rotations = rotations
        isSpinning = true
        
        spin()
    }
    
    private func startSpinningInfinite() {
        rotations = 0
        isSpinning = true
        
        spin()
    }
    
    private func stopSpinning() {
        withAnimation(.spring()) {
            isSpinning = false
        }
        
        rotations = 0
    }
    
    private func spin() {
        guard isSpinning,
              (gameMode == .manual || (gameMode == .auto && rotations != 0)),
              let lastSymbol = currentSymbols.last,
              let lastIndex = symbols.firstIndex(of: lastSymbol) else {
            
            withAnimation(.spring()) {
                isSpinning = false
            }
            
            if let selectedSymbol {
                onEndSpin(selectedSymbol)
            }
            
            return
        }
        
        var time = 0.0
        
        withAnimation(.linear(duration: animationDuration)) {
            position = positionVariation
            opacityAndScale = 0
        }
        time = animationDuration
        
        withAnimation(.linear(duration: animationShortDuration).delay(time)) {
            let nextIndex: Int
            if lastIndex >= symbols.count - 1 {
                nextIndex = 0
            } else {
                nextIndex = lastIndex + 1
            }
            let nextSymbol = symbols[nextIndex]
            currentSymbols.insert(nextSymbol, at: 0)
            _ = currentSymbols.popLast()
            
            position = -positionVariation
        }
        time += animationShortDuration
        
        withAnimation(.linear(duration: animationDuration).delay(time)) {
            opacityAndScale = rotationScale
            position = 0
        }
        time += animationDuration
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            if gameMode == .auto {
                rotations -= 1
            }

            spin()
        }
    }
    
    var body: some View {
        ZStack {
            Image("gfx-reel")
                .resizable()
                .modifier(ImageModifier())
            
            VStack {
                ForEach(currentSymbols.indices, id: \.self) { index in
                    Image(currentSymbols[index].icon)
                        .resizable()
                        .modifier(ImageModifier())
                        .frame(height: index == 1 ? .infinity : 0)
                        .opacity(index == 1 ? opacityAndScale : 0)
                        .scaleEffect(index == 1 && isSpinning ? opacityAndScale : 1)
                        .offset(y: index == 1 ? position : 0)
                }
            }
        }
        .onChange(of: reelState, perform: onChange(reelState:))
    }
}

struct ReelView_Previews: PreviewProvider {
    
    static var previews: some View {
        ReelView(symbols: Symbol.all) { symbol in
            // Empty
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
