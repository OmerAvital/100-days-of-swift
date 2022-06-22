//
//  CardView.swift
//  Flashzilla
//
//  Created by Omer Avital on 6/15/22.
//

import SwiftUI

extension Shape {
    func fillOptions(_ colors: [Color], for conditions: [Bool], defaultColor: Color = .clear) -> some View {
        var color: Color
        
        if let colorIndex = conditions.firstIndex(of: true) {
            color = colors[colorIndex]
        } else {
            color = defaultColor
        }
        
        return self.fill(color)
    }
}

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

struct Offset {
    private var _width = 0.0
    var width: Double {
        get { _width }
        set {
            if newValue > Self.maxMagnitude {
                _width = Self.maxMagnitude
            } else if newValue < -Self.maxMagnitude {
                _width = -Self.maxMagnitude
            } else {
                _width = newValue
            }
        }
    }
    static let maxMagnitude = 160.0
    static let draggingMaxMagnitude = maxMagnitude - 10
}

struct CardView: View {
    let card: Card
    var removal: ((Bool) -> Void)? = nil
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var isShowingAnswer = false
    @State private var offset = Offset()
        
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white.opacity(abs(offset.width).transform(from: 10...100, to: 0...1, invert: true))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fillOptions([.green, .red], for: [offset.width > 0, offset.width < 0], defaultColor: .white)
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 3)
            
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width) / 10))
        .offset(x: offset.width, y: 0)
        .opacity(abs(offset.width).transform(from: 50...Offset.maxMagnitude, to: 0...1, invert: true))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    withAnimation {
                        if gesture.translation.width <= Offset.draggingMaxMagnitude {
                            offset.width = gesture.translation.width
                        }
                    }
                    feedback.prepare()
                })
                .onEnded({ gesture in
                    withAnimation {
                        offset.width = gesture.predictedEndTranslation.width
                    }
                    
                    if abs(offset.width) > 125 {
                        if offset.width > 0 {
                            // right
                            feedback.notificationOccurred(.success)
                        } else {
                            // wrong
                            feedback.notificationOccurred(.error)
                            
                            isShowingAnswer = false
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0).delay(0.3)) {
                                offset.width = 0
                            }
                        }
                        removal?(offset.width > 0)
                    } else {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0)) {
                            offset.width = 0
                        }
                    }
                })
        )
        .onTapGesture {
            isShowingAnswer = true
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .example)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
