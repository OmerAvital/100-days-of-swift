//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Omer Avital on 6/13/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
