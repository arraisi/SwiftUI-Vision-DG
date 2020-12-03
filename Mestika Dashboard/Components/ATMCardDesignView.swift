//
//  ATMCardDesignView.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 02/12/20.
//

import SwiftUI
import SwURL

struct ATMCardDesignView: View {
    var card: ATMDesignViewModel
    
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    let showContent: Bool
    
    var body: some View {
        ZStack {
            RemoteImageView(
                url: card.cardImage!,
                placeholderImage: Image.init("card_bg"),
                transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
            ).progress({ progress in
                return LoadingView(isShowing: Binding.constant(true)) {
                    EmptyView()
                }
            })
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.clear)
            
            if showContent {
                VStack(){
                    
                    HStack {
                        Image("logo_m_mestika")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    
                    HStack{
                        Text(card.title)
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Regular", size: 12))
                        Spacer()
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()

            }
        }
        .frame(width: cardWidth, height: cardHeight, alignment: .center)
        .cornerRadius(10)
        .background(Color.clear)
    }
}

struct ATMCardDesignView_Previews: PreviewProvider {
    static var previews: some View {
        ATMCardDesignView(card: ATMDesignViewModel(id: "0", key: "0", title: "0", cardImage: URL(string: ""), description: "test"), cardWidth: 315, cardHeight: 197, showContent: false)
    }
}
