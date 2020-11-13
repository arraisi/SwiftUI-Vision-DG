//
//  TabItemView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI

struct TabItemView: View {
    let card: CardModel
    let callback: (CardModel)->()
    
    init(
        card: CardModel,
        callback: @escaping (CardModel)->()
    ) {
        self.card = card
        self.callback = callback
    }
    
    var body: some View {
        Button(action: {
            self.callback(self.card)
        }, label: {
            card.image
                .resizable()
                .padding(.horizontal, 25)
                .aspectRatio(contentMode: .fit)
                .tag(card.id)
        })
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(card: cardData[0]) {id in
            //            cardData[0].id = id
        }
    }
}
