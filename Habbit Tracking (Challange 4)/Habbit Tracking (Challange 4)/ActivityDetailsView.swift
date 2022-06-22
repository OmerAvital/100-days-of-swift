//
//  ActivityDetailsView.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/5/22.
//

import SwiftUI

struct ActivityDetailsView: View {
    @ObservedObject var activities: Activities
    let activity: Activity
    
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.title2.bold())
                    Text(activity.name)
                    
                    Text("Description")
                        .font(.title2.bold())
                        .padding(.top)
                    Text(activity.description)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Last completed on")
                        .font(.title2.bold())
                        .padding(.top)
                    Text(activity.lastCompletedOn?.formatted(date: .complete, time: .shortened) ?? "Never completed")
                    
                    if activity.totalCompleted > 0 {
                        Text("Number of times completed")
                            .font(.title2.bold())
                            .padding(.top)
                        Text("\(activity.totalCompleted)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Button("Complete") {
                    activities.complete(activity)
                }
                .padding(.top)
                Button("Delete Habit", role: .destructive) {
                    showingDeleteConfirmation = true
                }
                .padding(.top, 5)
            }
        }
        .navigationTitle("\(activity.name) Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Are you sure you want to delete \(activity.name)", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            
            Button("Delete", role: .destructive) {
                activities.delete(activity)
            }
        }
    }
}

struct ActivityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActivityDetailsView(activities: Activities(), activity: Activity.example)
        }
    }
}
