//
//  DataSaver.swift
//  Flashzilla
//
//  Created by Omer Avital on 6/16/22.
//

import Foundation

protocol DataSaver {
    associatedtype SavedData: Codable
    static var filePath: URL { get }
}

extension DataSaver {
    static func load() -> SavedData? {
        if let data = try? Data(contentsOf: filePath),
           let decoded = try? JSONDecoder().decode(SavedData.self, from: data) {
            return decoded
        }
        
        // no saved data
        return nil
    }
    
    /// Saves the data to specified file
    /// - Parameter data: The data to save, same one as is loaded in load() function.
    /// - Returns: A Bool stating whether the save was successful.
    static func save(_ data: SavedData) -> Bool {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: filePath, options: [.atomic, .completeFileProtection])
            return true
        } catch {
            return false
        }
    }
}
