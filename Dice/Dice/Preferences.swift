//
//  Preferences.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import Foundation

struct Preferences: Codable {
    var sides = 4
    var numberOfDice = 2
    
    var maxPreviousRolls = 5
    
    var haptics = true

    static let sidesOptions = [2, 4, 6, 8, 10, 12, 20, 100]
    static let numberOfDiceRange = 1...5
    static let maxPreviousRollsRange = 0...20
}
