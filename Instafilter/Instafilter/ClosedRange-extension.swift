//
//  ClosedRange-extension.swift
//  Instafilter
//
//  Created by Omer Avital on 6/9/22.
//

import Foundation

extension ClosedRange where Bound == Double {
    var avarageValue: Double {
        (self.upperBound + self.lowerBound) / 2
    }
}
