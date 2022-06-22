//
//  Color-theme.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/5/22.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var themePrimary: Color {
        Color(hue: 0.65, saturation: 0.6, brightness: 0.6)
    }
    
    static var themeSecondary: Color {
        Color(hue: 0.6, saturation: 0.6, brightness: 0.8)
    }
}
