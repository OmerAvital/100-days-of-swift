//
//  FIleManager-DocumentsFolder.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import Foundation

extension FileManager {
    static var documentsFolder: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
