//
//  Activity.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/5/22.
//

import Foundation

struct Activity: Codable, Identifiable, Equatable {
    var id = UUID()
    
    let name: String
    let description: String
    var lastCompletedOn: Date?
    var totalCompleted = 0
    
    static let example = Self(name: "Example", description: "This activity is an example of an activity. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras gravida.", lastCompletedOn: Date.now, totalCompleted: 1)
}
