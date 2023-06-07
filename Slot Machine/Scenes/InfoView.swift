
import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage(BusinessConstants.UserDefaults.gameMode)
    private var gameMode: GameMode = BusinessConstants.DefaultValues.gameMode
    
    @AppStorage(BusinessConstants.UserDefaults.highScore)
    private var highscore: Int = BusinessConstants.DefaultValues.highScore
    
    @AppStorage(BusinessConstants.UserDefaults.soundDisabled)
    private var soundDisabled: Bool = BusinessConstants.DefaultValues.soundDisabled {
        didSet {
            onSoundDisabledDidChanged()
        }
    }
    
    @AppStorage(BusinessConstants.UserDefaults.vibrationDisabled)
    private var vibrationDisabled: Bool = BusinessConstants.DefaultValues.vibrationDisabled
    
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    private let symbols: [Symbol]
    
    init(symbols: [Symbol]) {
        self.symbols = symbols
    }
    
    private func onSoundDisabledDidChanged() {
        if soundDisabled {
            SoundManager.shared.stopSound()
        } else {
            SoundManager.shared.playSound(sound: "background-music")
        }
    }
    
    private func resetHighScore() {
        highscore = 0
    }
    
    @ViewBuilder
    var GameModePreference: some View {
        Picker(selection: $gameMode) {
            ForEach(GameMode.allCases, id: \.self) {
                Text($0.name)
            }
        } label: {
            Text("Game mode")
                .foregroundColor(Color.gray)
        }
        .pickerStyle(.menu)
    }
    
    @ViewBuilder
    var SoundPreference: some View {
        HStack {
            Toggle(isOn: Binding(
                get: { !soundDisabled },
                set: { soundDisabled = !$0 }
            )) {
                HStack {
                    Text("Sound")
                        .foregroundColor(Color.gray)
                    
                    Spacer()
                    
                    Image(systemName: "speaker.slash.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.gray)
                }
            }
            
            Image(systemName: "speaker.wave.2.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(Color.gray)
        }
    }
    
    @ViewBuilder
    var VibratePreference: some View {
        HStack {
            Toggle(isOn: Binding(
                get: { !vibrationDisabled },
                set: { vibrationDisabled = !$0 }
            )) {
                HStack {
                    Text("Vibration")
                        .foregroundColor(Color.gray)
                    
                    Spacer()
                    
                    Image(systemName: "water.waves.slash")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.gray)
                }
            }
            
            Image(systemName: "water.waves")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(Color.gray)
        }
    }
    
    @ViewBuilder
    var HighScorePreference: some View {
        HStack {
            Text("High Score \(highscore)")
                .foregroundColor(Color.gray)
            
            Spacer()
            
            Button(action: resetHighScore) {
                Text("Reset")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("Preferences")) {
                    GameModePreference
                    
                    SoundPreference
                    
                    VibratePreference
                    
                    HighScorePreference
                }
                
                Section(header: Text("Coins")) {
                    ForEach(symbols) { symbol in
                        CoinRowView(symbol: symbol)
                    }
                }
                
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Javier Laguna")
                    FormRowView(firstItem: "Designer", secondItem: "Robert Petras")
                    FormRowView(firstItem: "Music", secondItem: "Dan Lebowitz")
                    FormRowView(firstItem: "Copyright", secondItem: "© All rights reserved.")
                    FormRowView(firstItem: "Version", secondItem: appVersion)
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(
            Button(action: {
                SoundManager.shared.stopSound()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
                .padding(.top, 16)
                .padding(.trailing, 16)
                .accentColor(Color.secondary)
            , alignment: .topTrailing
        )
        .onAppear(perform: {
            SoundManager.shared.playSound(sound: "background-music")
        })
    }
}

private struct FormRowView: View {
    
    private let firstItem: String
    private let secondItem: String
    
    init(firstItem: String, secondItem: String) {
        self.firstItem = firstItem
        self.secondItem = secondItem
    }
    
    var body: some View {
        HStack {
            Text(firstItem)
                .foregroundColor(Color.gray)
            
            Spacer()
            
            Text(secondItem)
        }
    }
}

private struct CoinRowView: View {
    
    private let symbol: Symbol
    
    init(symbol: Symbol) {
        self.symbol = symbol
    }
    
    @ViewBuilder
    var SymbolImage: some View {
        Image(symbol.icon)
            .resizable()
            .frame(width: 32, height: 32)
    }
    
    var body: some View {
        HStack {
            SymbolImage
            
            SymbolImage
            
            SymbolImage
            
            Spacer()
            
            Text("x \(symbol.value)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color("ColorPink"))
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        InfoView(symbols: Symbol.all)
    }
}

