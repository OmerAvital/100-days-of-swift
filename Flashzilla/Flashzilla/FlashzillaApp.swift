//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Omer Avital on 6/15/22.
//

import SwiftUI

@main
struct FlashzillaApp: App {
    @StateObject var cards = Cards()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cards)
        }
    }
}
