//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Omer Avital on 6/7/22.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16
    
    var body: some View {
        Group {
            switch rating {
            case 1:
                Text("🤮")
            case 2:
                Text("😔")
            case 3:
                Text("😕")
            case 4:
                Text("😊")
            default:
                Text("🤩")
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Rating: \(rating == 1 ? "1 star" : "\(rating) stars")")
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
