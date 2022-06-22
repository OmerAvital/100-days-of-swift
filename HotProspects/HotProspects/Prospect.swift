//
//  Prospect.swift
//  HotProspects
//
//  Created by Omer Avital on 6/14/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor
class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    private let filePath = FileManager.documentsDirectory.appendingPathComponent("prospects", conformingTo: .json)
    
    init() {
        if let data = try? Data(contentsOf: filePath) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        
        // no saved data
        people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: filePath, options: [.atomic, .completeFileProtection])
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
