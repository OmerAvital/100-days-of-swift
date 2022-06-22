//
//  ContentView.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/5/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var activities = Activities()
    
    @State private var showingAddHabitSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if activities.items.isEmpty {
                    Button("Create your first habit!") {
                        showingAddHabitSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    ScrollView {
                        VStack {
                            ForEach(activities.items) { activity in
                                ActivityRow(activities: activities, activity: activity)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Habit tracker")
            .toolbar {
                if !activities.items.isEmpty {
                    Button {
                        showingAddHabitSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabitSheet) {
                NewActivityView(activities: activities)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
