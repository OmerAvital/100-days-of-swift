//
//  Card.swift
//  Flashzilla
//
//  Created by Omer Avital on 6/15/22.
//

import Foundation

struct Card: Codable, Identifiable, Equatable {
    var id = UUID()
    let prompt: String
    let answer: String
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example = Card(prompt: "Who played the 18th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
