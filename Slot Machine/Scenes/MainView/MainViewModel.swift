
import Foundation

final class MainViewModel: ObservableObject {
    
    static private let initialCoins = 100
    
    let symbols: [Symbol] = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    @Published var reelsState: [ReelState] = [.stop, .stop, .stop]
    @Published var highscore = UserDefaults.standard.integer(forKey: BusinessConstants.UserDefaults.highScore)
    @Published var coins = MainViewModel.initialCoins
    @Published var bet: BetType = .small {
        didSet {
            onChangeBet()
        }
    }
    @Published var showGameOverModal = false
    
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
                reelsState[index] = .spinning(times: times)
                
                if reelsState[index] != reelsState.last {
                    await TimerUtils.waitTime(time: .seconds(0.3))
                }
            }
        }
    }
    
    func onFinishReelSpin(index: Int, symbol: Symbol) {
        reelsState[index] = .stop
        selectedSymbols[index] = symbol
        
        UserFeedbackManager.shared.on(.endSpin)
        
        checkIfFinish()
    }
    
    func activateSmallBet() {
        if bet != .small {
            bet = .small
        }
    }
    
    func activateBigBet() {
        if bet != .big {
            bet = .big
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: BusinessConstants.UserDefaults.highScore)
        highscore = 0
        
        startNewGame()
        
        UserFeedbackManager.shared.on(.resetGame)
    }
    
    func startNewGame() {
        coins = MainViewModel.initialCoins
        activateSmallBet()
        
        showGameOverModal = false
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
        coins += bet.rawValue * 10
    }
    
    func newHighScore() {
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: BusinessConstants.UserDefaults.highScore)
        
        UserFeedbackManager.shared.on(.newHighScore)
    }
    
    func playerLoses() {
        coins -= bet.rawValue
        
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
}
