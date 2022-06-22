//
//  User.swift
//  Challange5
//
//  Created by Omer Avital on 6/7/22.
//

import Foundation
import CoreData

struct User: Codable, Identifiable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
        
    init(id: UUID, isActive: Bool, name: String, age: Int, company: String, email: String, address: String, about: String, registered: Date, tags: [String], friends: [Friend]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }
    
    init(from cachedUser: CachedUser) {
        self.id = cachedUser.wrappedId
        self.isActive = cachedUser.isActive
        self.name = cachedUser.wrappedName
        self.age = Int(cachedUser.age)
        self.company = cachedUser.wrappedCompany
        self.email = cachedUser.wrappedEmail
        self.address = cachedUser.wrappedAddress
        self.about = cachedUser.wrappedAbout
        self.registered = cachedUser.registeredDate
        self.tags = cachedUser.tagsArray
        self.friends = cachedUser.friendsArray.map {
            Friend(from: $0)
        }
    }
    
    func toCachedUser(moc: NSManagedObjectContext) -> CachedUser {
        let cachedUser = CachedUser(context: moc)
        
        cachedUser.id = id
        cachedUser.isActive = isActive
        cachedUser.name = name
        cachedUser.age = Int16(age)
        cachedUser.company = company
        cachedUser.email = email
        cachedUser.address = address
        cachedUser.about = about
        cachedUser.registered = registered.ISO8601Format()
        cachedUser.tags = tags.joined(separator: ",")
        
        let cachedFriends = friends.map { friend in
            friend.toCachedFriend(moc: moc)
        }
        cachedUser.friends = NSSet(array: cachedFriends)
        
        return cachedUser
    }
    
    static let example = Self(id: UUID(), isActive: true, name: "Omer Avital", age: 18, company: "Omer Inc.", email: "omer@omeravital.dev", address: "Home, Palo Alto, CA", about: "I am a person who is named Omer and live in Palo Alto.", registered: Date.now, tags: ["Funny", "Smart", "Nice"], friends: [Friend.example])
}
