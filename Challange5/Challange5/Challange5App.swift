//
//  Challange5App.swift
//  Challange5
//
//  Created by Omer Avital on 6/7/22.
//

import SwiftUI

@main
struct Challange5App: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
