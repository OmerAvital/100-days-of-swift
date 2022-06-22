//
//  String-TitleCased.swift
//  HotProspects
//
//  Created by Omer Avital on 6/15/22.
//

import Foundation


// https://stackoverflow.com/a/50202999/15549903
extension String {
    func titleCased() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
}
