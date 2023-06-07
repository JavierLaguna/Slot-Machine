
import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel = MainViewModel()
    
    @State private var showingInfoView: Bool = false
    @State private var loadingText = "."
    
    var isActiveSmallBet: Bool {
        viewModel.bet == .small
    }
    var isActiveBigBet: Bool {
        viewModel.bet == .big
    }
    
    private func onPressSpin() {
        viewModel.startSpinReels()
    }
    
    private func onTapBonusButton() {
        loadingText = "."
        viewModel.onTapBonusButton()
    }
    
    private func animateLoadingText() async {
        while viewModel.isSpinningBonusTry {
            await TimerUtils.waitTime(time: .seconds(0.5))
            loadingText = "\(loadingText)."
            
            await animateLoadingText()
        }
    }
    
    @ViewBuilder
    var CoinsAndScore: some View {
        HStack {
            HStack {
                Text("Your\nCoins".uppercased())
                    .scoreLabelStyle()
                    .multilineTextAlignment(.trailing)
                
                Text("\(viewModel.coins)")
                    .scoreNumberStyle()
                    .modifier(ScoreNumberModifier())
            }
            .modifier(ScoreContainerModifier())
            
            Spacer()
            
            HStack {
                Text("\(viewModel.highscore)")
                    .scoreNumberStyle()
                    .modifier(ScoreNumberModifier())
                
                Text("High\nScore".uppercased())
                    .scoreLabelStyle()
                    .multilineTextAlignment(.leading)
                
            }
            .modifier(ScoreContainerModifier())
        }
    }
    
    @ViewBuilder
    var ReelsAndButton: some View {
        VStack(spacing: 0) {
            ReelView(
                symbols: viewModel.symbols,
                reelState: viewModel.reelsState[1],
                onEndSpin: { viewModel.onFinishReelSpin(index: 1, symbol: $0) }
            )
            
            HStack(spacing: 0) {
                ReelView(
                    symbols: viewModel.symbols,
                    reelState: viewModel.reelsState[0],
                    onEndSpin: { viewModel.onFinishReelSpin(index: 0, symbol: $0) }
                )
                
                Spacer()
                
                ReelView(
                    symbols: viewModel.symbols,
                    reelState: viewModel.reelsState[2],
                    onEndSpin: { viewModel.onFinishReelSpin(index: 2, symbol: $0) }
                )
            }
            .frame(maxWidth: 500)
            
            MainButton
        }
    }
    
    @ViewBuilder
    var BetSelector: some View {
        HStack {
            Button(action: viewModel.activateBigBet) {
                Text("\(BetType.big.rawValue)")
                    .fontWeight(.heavy)
                    .foregroundColor(isActiveBigBet ? Color("ColorYellow") : Color.white)
                    .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
            .disabled(isActiveBigBet)
            
            if isActiveSmallBet {
                Spacer()
            }
            
            Image("gfx-casino-chips")
                .resizable()
                .modifier(CasinoChipsModifier())
                .animation(.default, value: isActiveBigBet)
            
            if isActiveBigBet {
                Spacer()
            }
            
            Button(action: viewModel.activateSmallBet) {
                Text("\(BetType.small.rawValue)")
                    .fontWeight(.heavy)
                    .foregroundColor(isActiveSmallBet ? Color("ColorYellow") : Color.white)
                    .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
            .disabled(isActiveSmallBet)
        }
    }
    
    @ViewBuilder
    var ResetButton: some View {
        Button(action: viewModel.resetGame) {
            Image(systemName: "arrow.2.circlepath.circle")
                .foregroundColor(.white)
        }
        .modifier(ButtonModifier())
    }
    
    @ViewBuilder
    var InfoButton: some View {
        Button(action: {
            showingInfoView = true
            viewModel.onTapInfoButton()
        }) {
            Image(systemName: "info.circle")
                .foregroundColor(.white)
        }
        .modifier(ButtonModifier())
    }
    
    @ViewBuilder
    var LoadingButton: some View {
        ReelButton(loadingText, action: {})
            .disabled(viewModel.isSpinningBonusTry)
            .animation(Animation.default, value: loadingText)
            .task {
                await animateLoadingText()
            }
    }
    
    @ViewBuilder
    var MainButton: some View {
        if viewModel.showBonusButton {
            
            if viewModel.spinButtonDisabled {
                LoadingButton
            } else {
                ReelButton("bonus", action: onTapBonusButton)
            }
            
        } else if viewModel.showStopButton {
            ReelButton("stop", action: viewModel.stopSpinReel)
            
        } else {
            Button(action: onPressSpin) {
                Image("gfx-spin")
                    .renderingMode(.original)
                    .resizable()
                    .modifier(ImageModifier())
            }
            .disabled(viewModel.spinButtonDisabled)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 5) {
                LogoView()
                
                Spacer()
                
                CoinsAndScore
                
                ReelsAndButton
                    .layoutPriority(2)
                
                Spacer()
                
                BetSelector
            }
            .overlay(ResetButton, alignment: .topLeading)
            .overlay(InfoButton, alignment: .topTrailing)
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: viewModel.showGameOverModal ? 5 : 0, opaque: false)
            
            if viewModel.showGameOverModal {
                GameOverModal(onPressNewGameButton: viewModel.startNewGame)
            }
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView(symbols: viewModel.symbols)
        }
        .onAppear {
            viewModel.onAppearView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView()
    }
}
