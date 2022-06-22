//
//  DataSaver.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import Foundation
import UniformTypeIdentifiers

struct DataSaver<T: Codable> {
    let filePath: URL
    
    init(filePath: URL) {
        self.filePath = filePath
    }
    
    init(fileName: String, conformingTo contentType: UTType? = nil) {
        let baseFolder = FileManager.documentsFolder
        
        if let contentType = contentType {
            self.filePath = baseFolder.appendingPathComponent(fileName, conformingTo: contentType)
        } else {
            self.filePath = baseFolder.appendingPathComponent(fileName)
        }
    }
    
    func load() -> T? {
        if let data = try? Data(contentsOf: filePath),
           let decoded = try? JSONDecoder().decode(T.self, from: data) {
            return decoded
        }
        
        return nil
    }
    
    /// - Returns Whether the saving succeeded,
    func save(_ data: T) -> Bool {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: filePath, options: [.atomic, .completeFileProtection])
            return true
        } catch {
            return false
        }
    }
}
