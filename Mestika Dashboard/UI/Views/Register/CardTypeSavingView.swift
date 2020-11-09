//
//  CardTypeSavingView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI

struct CardTypeSavingView: View {
    var image: Image
    
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .frame(width: cardWidth, height: cardHeight)
        }
        .frame(width: cardWidth, height: cardHeight, alignment: .center)
    }
}

struct CardTypeSavingView_Previews: PreviewProvider {
    static var previews: some View {
        CardTypeSavingView(image: Image("Saving Image"), cardWidth: 315, cardHeight: 197)
    }
}
