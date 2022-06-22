//
//  DetailView.swift
//  Challange5
//
//  Created by Omer Avital on 6/7/22.
//

import SwiftUI

struct Row: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(content)
                .bold()
        }
    }
}

struct DetailView: View {
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<CachedUser>
    let user: User
    
    var body: some View {
        List {
            Section("General") {
                Row(title: "Name", content: user.name)
                Row(title: "About", content: user.about)
                Row(title: "Activity", content: user.isActive ? "Active" : "Inactive")
                Row(title: "Age", content: String(user.age))
                Row(title: "Company", content: user.company)
            }
            
            Section("Contact") {
                Row(title: "Email", content: user.email)
                Row(title: "Address", content: user.address)
            }
            
            Section("Tags") {
                ForEach(user.tags, id: \.self) { tag in
                    Text(tag)
                }
            }
            
            Section("Friends") {
                ForEach(user.friends) { friend in
                    if let friendUser = user(from: friend) {
                        UserRow(user: friendUser)
                    } else {
                        Text(friend.name)
                    }
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func user(from friend: Friend) -> User? {
        guard let cachedUser = users.first(where: { $0.wrappedId == friend.id }) else {
            return nil
        }
        
        return User(from: cachedUser)
    }
}
