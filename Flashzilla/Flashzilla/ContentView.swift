//
//  ContentView.swift
//  Flashzilla
//
//  Created by Omer Avital on 6/15/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        var offset = Double(total - position)
        
        if offset > 2 {
            offset = 0
        }
        
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @EnvironmentObject var cards: Cards
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                cards.removeTop(didGetRight: false)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                                .accessibilityLabel("Wrong")
                                .accessibilityHint("Mark your answer as being incorrect.")
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                cards.removeTop(didGetRight: true)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                                .accessibilityLabel("Correct")
                                .accessibilityHint("Mark your answer as being correct.")
                        }
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
            
            VStack {
                Text("Time \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(Array(zip(cards.current.indices, cards.current)), id: \.1.id) { index, card in
                        CardView(card: card) { didGetRight in
                            cards.remove(card, didGetRight: didGetRight)
                            
                            if cards.current.isEmpty {
                                isActive = false
                            }
                        }
                        .stacked(at: index, in: cards.current.count - 1)
                        .allowsHitTesting(index == cards.current.count - 1)
                        .accessibilityHidden(index < cards.current.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.current.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if !cards.current.isEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func resetCards() {
        cards.reset()
        timeRemaining = 100
        isActive = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(Cards())
    }
}
