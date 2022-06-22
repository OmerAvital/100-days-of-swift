//
//  DiceApp.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import SwiftUI

@main
struct DiceApp: App {
    @StateObject var dice = Dice()
    
    @State private var rotation = 0.0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dice)
        }
    }
}
