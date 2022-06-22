//
//  Friend.swift
//  Challange5
//
//  Created by Omer Avital on 6/8/22.
//

import Foundation
import CoreData

struct Friend: Codable, Identifiable {
    let id: UUID
    let name: String
        
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from cachedFriend: CachedFriend) {
        self.id = cachedFriend.wrappedId
        self.name = cachedFriend.wrappedName
    }
    
    func toCachedFriend(moc: NSManagedObjectContext) -> CachedFriend {
        let cachedFriend = CachedFriend(context: moc)
        
        cachedFriend.id = id
        cachedFriend.name = name
        
        return cachedFriend
    }
    
    static let example = Self(id: UUID(), name: "My Friend")
}
