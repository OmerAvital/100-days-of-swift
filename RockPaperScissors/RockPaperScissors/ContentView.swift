//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Omer Avital on 4/18/22.
//

import SwiftUI

enum Option: CaseIterable {
    case rock, paper, scissors
    
    func emoji() -> String {
        switch self {
        case .rock:
            return "🪨"
        case .paper:
            return "📄"
        case .scissors:
            return "✂️"
        }
    }
    
    func doesBeat(_ other: Self) -> Bool {
        switch self {
        case .rock:
            return other == .scissors
        case .paper:
            return other == .rock
        case .scissors:
            return other == .paper
        }
    }
}

struct OptionBtn: View {
    var option: Option
    var action: (_: Option) -> Void
    
    var body: some View {
        Button {
            action(option)
        } label: {
            Text(option.emoji())
                .font(.system(size: 75))
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(10)
    }
}

struct ContentView: View {
    @State var opponent: Option = .allCases.randomElement() ?? .rock
    @State var shouldWin = Bool.random()
    @State var points = 0
    @State var roundNumber = 1
    
    @State var roundEndAlertTitle = ""
    @State var showRoundEndAlert = false
    
    @State var showGameEndAlert = false
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
                .opacity(0.9)
            
            VStack {
                Spacer()
                
                Text("Rock Paper Scisssors")
                    .font(.system(.largeTitle).bold())
                Text("Round \(roundNumber)     |     Score: \(points)")
                    .padding(.bottom)
                    .foregroundStyle(.secondary)
                
                VStack {
                    Text("Opponent Chose:")
                        .font(.title)
                    Text(opponent.emoji())
                        .font(.system(size: 75))
                    
                    Text("You need to \(shouldWin ? "win!" : "lose!")")
                        .font(.system(.title).bold())
                        .padding()
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                
                Group {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                VStack {
                    Text("Choose the \(shouldWin ? "winning" : "losing") option:")
                        .padding()
                    HStack {
                        OptionBtn(option: .rock, action: handleOptionTouch)
                        OptionBtn(option: .paper, action: handleOptionTouch)
                        OptionBtn(option: .scissors, action: handleOptionTouch)
                    }
                }
                
                Spacer()
            }
        }
        .alert(roundEndAlertTitle, isPresented: $showRoundEndAlert) {
            Button("Ok", action: resetRound)
        }
        .alert("You finished the game with \(points) points!", isPresented: $showGameEndAlert) {
            Button("Play Again!", action: resetGame)
        }
    }
    
    func handleOptionTouch(_ opt: Option) {
        if opt.doesBeat(opponent) && shouldWin || !opt.doesBeat(opponent) && !shouldWin {
            // win round
            points += 1
            roundEndAlertTitle = "Correct!"
        } else {
            // lose
            if points > 0 {
                points -= 1
            }
            roundEndAlertTitle = "Inccorrect!"
        }
        
        if roundNumber >= 10 {
            showGameEndAlert = true
            return
        }
        
        showRoundEndAlert = true
    }
    
    func resetRound() {
        opponent = .allCases.randomElement() ?? .rock
        shouldWin.toggle()
        roundNumber += 1
    }
    
    func resetGame() {
        roundNumber = 1
        points = 0
        resetRound()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
