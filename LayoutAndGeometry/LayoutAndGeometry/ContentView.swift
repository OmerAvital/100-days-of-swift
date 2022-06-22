//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Omer Avital on 6/16/22.
//

import SwiftUI

extension Double {
    func clamp(_ range: ClosedRange<Double>) -> Double {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }
    
    func transform(from fromRange: ClosedRange<Double> = 0...1, to toRange: ClosedRange<Double>, invert: Bool = false, clamped: Bool = true) -> Double {
        let scale = (toRange.upperBound - toRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        let initialValue = invert ? (fromRange.upperBound - self + fromRange.lowerBound) : self
        
        let value = (initialValue - fromRange.lowerBound) * scale + toRange.lowerBound
        return clamped ? value.clamp(toRange) : value
    }
}

struct ContentView: View {
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: Double(geo.frame(in: .global).minY).transform(from: 0...fullView.size.height, to: 0...1), saturation: 0.7, brightness: 1))
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(geo.frame(in: .global).minY / 200)
                            .scaleEffect(Double(geo.frame(in: .global).minY).transform(from: 0...fullView.size.height, to: 0.5...1.5))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
