//
//  TabItemView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI

struct TabItemView: View {
    var card: ATMDesignViewModel
    let callback: (ATMDesignViewModel)->()
    
    var body: some View {
        Button(action: {
            self.callback(self.card)
        }, label: {
            Image(uiImage: card.cardImage)
                .resizable()
                .padding(.horizontal, 25)
                .aspectRatio(contentMode: .fit)
                .tag(card.id)
        })
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(card: ATMDesignViewModel(id: "0", key: "0", title: "0", cardImage: UIImage(named:"card_bg")!, description: "")) { (id:ATMDesignViewModel) in
            
            }
    }
}
