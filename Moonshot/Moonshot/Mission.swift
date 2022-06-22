//
//  Mission.swift
//  Moonshot
//
//  Created by Omer Avital on 6/3/22.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var diplayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String? {
        launchDate?.formatted(date: .abbreviated, time: .omitted)
    }
}

