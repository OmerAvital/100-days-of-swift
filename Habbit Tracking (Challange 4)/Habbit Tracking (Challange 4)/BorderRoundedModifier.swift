//
//  BorderRoundedModifier.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/6/22.
//

import Foundation
import SwiftUI

struct BorderRoundedModifier: ViewModifier {
    let cornerRadius: Double
    let strokeContent: Color
    let style: StrokeStyle?
    let lineWidth: Double?
    
    var rect: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Group {
                    if let style = style {
                        rect.strokeBorder(strokeContent, style: style)
                    } else if let lineWidth = lineWidth {
                        rect.strokeBorder(strokeContent, lineWidth: lineWidth)
                    } else {
                        rect.strokeBorder(strokeContent)
                    }
                }
                    .foregroundColor(.clear)
            }
    }
}

extension View {
    func border(_ content: Color, cornerRadius: Double?) -> some View {
        modifier(BorderRoundedModifier(cornerRadius: cornerRadius ?? 0, strokeContent: content, style: nil, lineWidth: nil))
    }
    
    func border(_ content: Color, cornerRadius: Double?, lineWidth: Double?) -> some View {
        modifier(BorderRoundedModifier(cornerRadius: cornerRadius ?? 0, strokeContent: content, style: nil, lineWidth: lineWidth))
    }
    
    func border(_ content: Color, cornerRadius: Double?, style: StrokeStyle?) -> some View {
        modifier(BorderRoundedModifier(cornerRadius: cornerRadius ?? 0, strokeContent: content, style: style, lineWidth: nil))
    }
}
