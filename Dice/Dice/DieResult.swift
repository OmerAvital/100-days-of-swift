//
//  DieResult.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import Foundation

struct DieResult: Identifiable, Codable {
    var id = UUID()
    var date = Date.now

    let sides: Int
    let results: [Int]
    
    init(sides: Int, results: [Int]) {
        self.sides = sides
        self.results = results
    }
    
    init(with preferences: Preferences) {
        sides = preferences.sides
        var newResults = [Int]()
        
        for _ in 0..<preferences.numberOfDice {
            newResults.append(Int.random(in: 1...preferences.sides))
        }
        results = newResults
    }
    
    static let example = DieResult(sides: 4, results: [1, 3])
}
