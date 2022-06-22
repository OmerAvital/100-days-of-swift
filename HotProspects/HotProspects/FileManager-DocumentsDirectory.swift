//
//  FileManager-DocumentsDirectory.swift
//  HotProspects
//
//  Created by Omer Avital on 6/15/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
