//
//  ContentView.swift
//  Challange5
//
//  Created by Omer Avital on 6/7/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<CachedUser>
    
    var body: some View {
        NavigationView {
            List(users) { cachedUser in
                UserRow(user: User(from: cachedUser))
            }
            .navigationTitle("Users")
            .task {
                await fetchUsers()
            }
        }
    }
    
    func fetchUsers() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: Users.dataUrl)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedData = try decoder.decode([User].self, from: data)
            await MainActor.run {
                for user in decodedData {
                    _ = user.toCachedUser(moc: moc)
                }
                
                try? moc.save()
            }
        } catch {
            print("Could not fetch data: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
