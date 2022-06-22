//
//  AdjustableStack.swift
//  Dice
//
//  Created by Omer Avital on 6/17/22.
//

import SwiftUI

enum Stacks {
    case VStack, HStack
}

struct AdjustableStack<Content>: View where Content: View {
    var content: (() -> Content)
    var stack: Stacks
    var spacing: CGFloat?
    var verticalAlignment: VerticalAlignment?
    var horizontalAlignment: HorizontalAlignment?
    
    var body: some View {
        switch stack {
        case .VStack:
            VStack(alignment: horizontalAlignment ?? .center, spacing: spacing, content: content)
        case .HStack:
            HStack(alignment: verticalAlignment ?? .center, spacing: spacing, content: content)
        }
    }
    
    init(stack: Stacks, verticalAlignment: VerticalAlignment? = nil, horizontalAlignment: HorizontalAlignment? = nil, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (() -> Content)) {
        self.stack = stack
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.content = content
    }
}

struct AdjustableStack_Previews: PreviewProvider {
    static var previews: some View {
        AdjustableStack(stack: .VStack) {
            Text("Hello, world!")
        }
    }
}
