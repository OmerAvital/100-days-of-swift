//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Omer Avital on 4/11/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingRestart = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var roundNumber = 1
    @State private var tappedFlag: Int? = nil
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @Environment(\.colorScheme) var colorScheme
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: colorScheme == .light ? Color(red: 0.1, green: 0.3, blue: 0.6) : Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: colorScheme == .light ? Color(red: 0.83, green: 0.15, blue: 0.26) : Color(red: 0.6, green: 0.15, blue: 0.2), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                        .rotationEffect(tappedFlag == number ? .degrees(360) : .degrees(0))
                        .opacity(tappedFlag == nil || tappedFlag == number ? 1 : 0.25)
                        .overlay(
                            Capsule()
                                .foregroundColor(.blue)
                                .opacity(tappedFlag == nil || tappedFlag == number ? 0 : 0.5)
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .cornerRadius(20)
                .shadow(radius: 5)
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("You're done!", isPresented: $showingRestart) {
            Button("Play again", action: restartGame)
        } message: {
            Text("You scored \(score) points!")
        }
    }
    
    func flagTapped(_ number: Int) {
        withAnimation {
            tappedFlag = number
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if roundNumber >= 8 {
            showingRestart = true
            return
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        roundNumber += 1
        tappedFlag = nil
    }
    
    func restartGame() {
        score = 0
        roundNumber = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .preferredColorScheme(.light)
//        ContentView()
//            .preferredColorScheme(.dark)
    }
}
