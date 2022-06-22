//
//  DieView.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import SwiftUI

enum PresentationStyle {
    case simple, detailed
}

struct Dot: View {
    typealias PaddingFunc = ((Double) -> Double)
    
    let size: CGSize
    var body: some View {
        Circle()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: size.width * 0.125)
    }
}

struct DieView: View {
    @Environment(\.colorScheme) var colorScheme
    let number: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let roundedRect = RoundedRectangle(cornerRadius: geo.size.width * 0.15, style: .continuous)
                let rectLight = roundedRect.fill(.background)
                let rectDark = roundedRect.fill(.quaternary)
                let mainRect = Group {
                    if colorScheme == .light {
                        rectLight
                    } else {
                        rectDark
                    }
                }
                
                if geo.size.width > 50 {
                    mainRect
                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)
                } else {
                    mainRect
                    roundedRect
                        .strokeBorder(.primary)
                }
                
                switch number {
                case 0:
                    Text("?")
                        .font(.system(size: geo.size.height / 2))
                case 1:
                    Dot(size: geo.size)
                case 2:
                    HStack {
                        Dot(size: geo.size)
                        Dot(size: geo.size)
                    }
                case 3:
                    VStack {
                        HStack {
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                        }
                        Dot(size: geo.size)
                    }
                case 4:
                    VStack {
                        HStack {
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                        }
                        HStack {
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                        }
                    }
                case 5:
                    VStack(spacing: geo.size.width * 0.03) {
                        HStack(spacing: geo.size.width * 0.15) {
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                        }
                        Dot(size: geo.size)
                        HStack(spacing: geo.size.width * 0.15) {
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                        }
                    }
                case 6:
                    VStack(spacing: geo.size.width * 0.05) {
                        HStack(spacing: geo.size.width * 0.05) {
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                        }
                        HStack(spacing: geo.size.width * 0.05) {
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                            Dot(size: geo.size)
                        }
                    }
                default:
                    Text(String(number))
                        .font(.system(size: geo.size.width * 0.4))
                }
            }
            .padding(geo.size.width * 0.075)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement()
        .accessibilityLabel("Die \(number == 0 ? "not yet rolled" : "with value \(number)")")
    }
}

struct DieView_Previews: PreviewProvider {
    static var previews: some View {
        DieView(number: 29)
            .preferredColorScheme(.light)
        
        DieView(number: 29)
            .preferredColorScheme(.dark)
    }
}
