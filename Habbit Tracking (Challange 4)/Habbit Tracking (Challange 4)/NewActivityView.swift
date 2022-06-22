//
//  NewActivityView.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/5/22.
//

import SwiftUI

struct NewActivityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var activities: Activities
    
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("New habit", text: $name)
                }
                
                Section("Description") {
                    TextField("Description", text: $description)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                Button("Create") {
                    activities.items.insert(Activity(name: name, description: description), at: 0)
                    dismiss()
                }
            }
        }
    }
}

struct NewActivitySheet_Previews: PreviewProvider {
     static var previews: some View {
         NewActivityView(activities: Activities())
    }
}
