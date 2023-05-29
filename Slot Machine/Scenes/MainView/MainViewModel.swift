
import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
        
    let symbols = Symbol.all
    
    @AppStorage(BusinessConstants.UserDefaults.gameMode)
    private var gameMode: GameMode = BusinessConstants.DefaultValues.gameMode
    
    @AppStorage(BusinessConstants.UserDefaults.highScore)
    var highscore: Int = BusinessConstants.DefaultValues.highScore
    
    @AppStorage(BusinessConstants.UserDefaults.coins)
    var coins = BusinessConstants.DefaultValues.initialCoins
    
    @Published var reelsState: [ReelState] = [.stop, .stop, .stop]
    @Published var showGameOverModal = false
    @Published var bet: BetType = .small {
        didSet {
            onChangeBet()
        }
    }
    
    private var isSpinning = false
    private var selectedSymbols: [Symbol?] = [nil, nil, nil]
    
    var canBet: Bool {
        coins >= BetType.small.rawValue
    }
    
    var canUseCurrentBet: Bool {
        coins >= bet.rawValue
    }
    
    var canSpin: Bool {
        !isSpinning && canUseCurrentBet
    }
    
    var showStopButton: Bool {
        gameMode == .manual && isSpinning
    }
    
    var spinButtonDisabled: Bool {
        !canSpin
    }
    
    func onAppearView() {
        checkIsGameOver()
    }
    
    func startSpinReels() {
        guard canSpin else {
            if !canBet {
                checkIsGameOver()
            }
            
            return
        }
        
        Task {
            isSpinning = true
            resetSymbols()
            
            UserFeedbackManager.shared.on(.spin)
            
            var times = 0
            for index in reelsState.indices {
                times += getSpinTimes()
                reelsState[index] = gameMode == .manual ? .spinningInfinite : .spinning(times: times)
                
                if reelsState[index] != reelsState.last {
                    await TimerUtils.waitTime(time: .seconds(0.3))
                }
            }
        }
    }
    
    func onFinishReelSpin(index: Int, symbol: Symbol) {
        guard isSpinning else {
            return
        }
        
        reelsState[index] = .stop
        selectedSymbols[index] = symbol
        
        UserFeedbackManager.shared.on(.endSpin)
        
        checkIfFinish()
    }
    
    func activateSmallBet() {
        if bet != .small, coins >= BetType.small.rawValue {
            bet = .small
        }
    }
    
    func activateBigBet() {
        if bet != .big, coins >= BetType.big.rawValue {
            bet = .big
        }
    }
    
    func resetGame() {
        if isSpinning {
            forceStop()
        }
        
        startNewGame()
        UserFeedbackManager.shared.on(.resetGame)
    }
    
    func startNewGame() {
        coins = BusinessConstants.DefaultValues.initialCoins
        activateSmallBet()
        
        showGameOverModal = false
    }
    
    func stopSpinReel() {
        guard isSpinning, let firstSpinningIndex = reelsState.firstIndex(where: {
            $0 == .spinningInfinite
        }) else {
            return
        }
        
        reelsState[firstSpinningIndex] = .stop
        UserFeedbackManager.shared.on(.pressStopButton)
    }
    
    func onTapInfoButton() {
        if isSpinning {
            forceStop()
        }
    }
}

private extension MainViewModel {
    
    func getSpinTimes() -> Int {
        Int.random(in: BusinessConstants.Game.minRotations...BusinessConstants.Game.maxRotations)
    }
    
    func resetSymbols() {
        selectedSymbols = selectedSymbols.map { _ in
            nil
        }
    }
    
    func onChangeBet() {
        UserFeedbackManager.shared.on(.changeBet)
    }
    
    func checkIfFinish() {
        if !reelsState.allSatisfy({ $0 == .stop }),
           selectedSymbols.contains(where: { $0 == nil }) {
            return
        }
        
        isSpinning = false
        checkWinning()
        checkIsGameOver()
    }
    
    func checkWinning() {
        if selectedSymbols.allSatisfy({ $0 == selectedSymbols.first }) {
            playerWins()
            
            if coins > highscore {
                newHighScore()
            } else {
                UserFeedbackManager.shared.on(.win)
            }
            
        } else {
            playerLoses()
        }
    }
    
    func playerWins() {
        guard let value = selectedSymbols.first??.value else {
            return
        }
        
        coins += bet.rawValue * value
    }
    
    func newHighScore() {
        highscore = coins
        
        UserFeedbackManager.shared.on(.newHighScore)
    }
    
    func playerLoses() {
        coins = max(coins - bet.rawValue, 0)
        
        if coins < bet.rawValue {
            activateSmallBet()
        }
    }
    
    func checkIsGameOver() {
        if !canBet {
            showGameOverModal = true
            UserFeedbackManager.shared.on(.gameOver)
        }
    }
    
    func forceStop() {
        isSpinning = false
        
        reelsState = reelsState.map { _ in
            .stop
        }
        
        resetSymbols()
    }
}
