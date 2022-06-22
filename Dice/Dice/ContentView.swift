//
//  ContentView.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.displayScale) var displayScale
    @EnvironmentObject var dice: Dice
    
    @State private var showingPreferences = false
    
    var valueTotal: Int? {
        dice.result?.results.reduce(0, +)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    showingPreferences = true
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .accessibilityLabel("Preferences")
            }
            .padding()
            
            
            Spacer()
            
            if dice.preferences.numberOfDice > 1 {
                Group {
                    if let valueTotal = valueTotal, dice.isFinalResult {
                        Text(String(valueTotal))
                    } else {
                        Text(" ")
                    }
                }
                .font(.title.bold())
                .accessibilityHidden(true)
            }
            
            HStack {
                ForEach(0..<dice.preferences.numberOfDice, id: \.self) { index in
                    DieView(number: dice.result?.results[index] ?? 0)
                }
            }
            .frame(minHeight: 100, maxHeight: 125)
            .padding(.horizontal)
            .padding(.vertical, displayScale < 3 ? 0 : nil)
            .onTapGesture {
                dice.roll()
            }
            .accessibilityElement()
            .accessibilityLabel("\(dice.preferences.numberOfDice) dice. Values: \(dice.result?.results.reduce("", { $0 + ", \($1)" }) ?? "Not yet rolled")")
            .accessibilityHint(valueTotal == nil ? "" : "Total: \(valueTotal ?? 0)")
            .accessibilityAddTraits(.isButton)
            
            Text("Roll")
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(.blue)
                .clipShape(Capsule())
                .foregroundColor(.white)
                .onTapGesture {
                    dice.roll()
                }
                .accessibilityHidden(true)
            
            if dice.preferences.maxPreviousRolls > 0 && !dice.previousRolls.isEmpty {
                Divider()
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Previous Roles")
                        .font(.title2.bold())
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.adaptive(minimum: 40), alignment: .leading)], spacing: 20) {
                            ForEach(dice.previousRolls) { roll in
                                PreviousRoll(roll: roll)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingPreferences, content: PreferencesView.init)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                dice.prepareHaptics()
            }
        }
    }
}

struct PreviousRoll: View {
    let roll: DieResult
    
    var formattedDate: String {
        let rollComponents = Calendar.current.dateComponents([.day, .month, .year], from: roll.date)
        let todayComponents = Calendar.current.dateComponents([.day, .month, .year], from: .now)
        
        if rollComponents.day == todayComponents.day
            && rollComponents.month == todayComponents.month
            && rollComponents.year == todayComponents.year {
            return roll.date.formatted(date: .omitted, time: .shortened)
        }
        
        return roll.date.formatted(date: .abbreviated, time: .shortened)
    }
    
    var isLong: Bool {
        roll.results.count >= 4
    }
    
    var body: some View {
        HStack {
            ForEach(roll.results.indices, id: \.self) { index in
                DieView(number: roll.results[index])
            }
            
            Text("= \(roll.results.reduce(0, +))")
                .font(.headline)
            
            Spacer()
        }
        .accessibilityElement()
        .accessibilityLabel("\(roll.results.count) dice. Total: \(roll.results.reduce(0, +)).")
        .accessibilityHint(roll.results.reduce("", { $0 + ", \($1)" }))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Dice())
    }
}
