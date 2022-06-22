//
//  PreferencesView.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import CoreHaptics
import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var dice: Dice
    
    var body: some View {
        NavigationView {
            Form {
                Section("Rolls") {
                    Stepper("\(dice.preferences.numberOfDice) \(dice.preferences.numberOfDice == 1 ? "Die" : "Dice")", value: $dice.preferences.numberOfDice, in: Preferences.numberOfDiceRange)
                    
                    HStack {
                        Text("Number of Sides:")
                            .accessibilityHidden(true)
                        
                        Spacer()
                        
                        Picker("Number of Sides", selection: $dice.preferences.sides) {
                            ForEach(Preferences.sidesOptions, id: \.self) { num in
                                Text("\(num) sides")
                                    .tag(num)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section("Previous Rolls") {
                    Stepper("Previous rolls saved: \(dice.preferences.maxPreviousRolls)", value: $dice.preferences.maxPreviousRolls, in: Preferences.maxPreviousRollsRange) { tapping in
                        if !tapping {
                            dice.trimExtraSavedRolls()
                        }
                    }
                    
                    if dice.preferences.maxPreviousRolls > 0 {
                        Button("Clear previous rolls") {
                            dice.clearPreviousRolls()
                        }
                        .disabled(dice.previousRolls.isEmpty)
                    }
                }
                    
                Section("General") {
                    VStack(alignment: .leading, spacing: 0) {
                        Toggle("Haptics", isOn: $dice.preferences.haptics)

                        if !CHHapticEngine.capabilitiesForHardware().supportsHaptics {
                            HStack(spacing: 5) {
                                Image(systemName: "exclamationmark.triangle")
                                Text("Device does not support haptics")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }
                    .disabled(!CHHapticEngine.capabilitiesForHardware().supportsHaptics)
                }
            }
            .navigationTitle("Preferences")
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(Dice())
    }
}
