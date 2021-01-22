//
//  CardTypeSavingView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardTypeSavingView: View {
    var card: JenisTabunganViewModel
    
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    var body: some View {
        ZStack {
            WebImage(url: card.image)
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .placeholder {
                    Rectangle().foregroundColor(.gray).opacity(0.5)
                }
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
        }
        .frame(width: cardWidth, height: cardHeight, alignment: .center)
        .cornerRadius(10)
        .background(Color.clear)
    }
}
