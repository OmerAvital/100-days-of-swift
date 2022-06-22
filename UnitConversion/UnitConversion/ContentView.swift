//
//  ContentView.swift
//  UnitConversion
//
//  Created by Omer Avital on 4/9/22.
//

import SwiftUI

struct ContentView: View {
    @State var startingUnit = volumeUnits[0]
    @State var endUnit = volumeUnits[1]
    @State var amount: Double = 1
    
    var finalAmount: Double {
        var value = Measurement(value: amount, unit: startingUnit)
        value.convert(to: endUnit)
        return value.value
    }
    
    static let volumeUnits: [UnitVolume] = [.milliliters, .liters, .cups, .pints, .gallons]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Starting Unit") {
                    Picker("Starting Unit", selection: $startingUnit) {
                        ForEach(ContentView.volumeUnits, id: \.self) {
                            Text($0.symbol)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Ending Unit") {
                    Picker("Ending Unit", selection: $endUnit) {
                        ForEach(ContentView.volumeUnits, id: \.self) {
                            Text($0.symbol)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    HStack {
                        Text("Starting Amount:")
                            .bold()
                        TextField("Starting Amount", value: $amount, format: .number)
                        Text(startingUnit.symbol)
                    }
                    
                    HStack {
                        Text("Ending Amount")
                            .bold()
                        Text(finalAmount, format: .number)
                        Spacer()
                        Text(endUnit.symbol)
                    }
                }
            }
            .navigationTitle("Volume Conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
