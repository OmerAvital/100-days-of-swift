//
//  UserRow.swift
//  Challange5
//
//  Created by Omer Avital on 6/8/22.
//

import SwiftUI

struct UserRow: View {
    let user: User
    
    var body: some View {
        NavigationLink {
            DetailView(user: user)
        } label: {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                
                Text(user.isActive ? "Active" : "Inactive")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: User.example)
    }
}
