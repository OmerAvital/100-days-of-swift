//
//  FilterValue.swift
//  Instafilter
//
//  Created by Omer Avital on 6/9/22.
//

import Foundation

struct FilterValue: Equatable, Identifiable {
    let id = UUID()
    var name: String
    var range: ClosedRange<Double> = 0...1
    
    private var _value: Double?
    var value: Double {
        set {
            _value = newValue
        }
        
        get {
            _value ?? range.avarageValue
        }
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, range: ClosedRange<Double>) {
        self.name = name
        self.range = range
    }
    
    init(name: String, range: ClosedRange<Double>, value: Double) {
        self.name = name
        self.range = range
        self.value = value
    }
}
