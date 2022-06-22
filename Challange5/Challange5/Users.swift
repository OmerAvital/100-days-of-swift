//
//  Users.swift
//  Challange5
//
//  Created by Omer Avital on 6/7/22.
//

import Foundation

class Users: ObservableObject {
    static let dataUrl = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
    
    @Published var items = [User]()
    
    init() {
        fetchUsers()
    }
    
    init(defaultUsers: [User]) {
        items = defaultUsers
        fetchUsers()
    }
    
    init(items: [User]) {
        self.items = items
    }
    
    private func fetchUsers() {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: Self.dataUrl)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedData = try decoder.decode([User].self, from: data)
                await MainActor.run {
                    self.items = decodedData
                }
            } catch {
                print("Could not fetch data: \(error.localizedDescription)")
            }
        }
    }
    
    func user(from friend: Friend) -> User? {
        items.first(where: { $0.id == friend.id })
    }
}
