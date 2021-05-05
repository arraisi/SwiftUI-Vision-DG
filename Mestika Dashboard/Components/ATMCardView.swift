//
//  ATMCardView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 01/12/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ATMCardView: View {
    var card: ATMViewModel
    
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    let showContent: Bool
    
    var body: some View {
        ZStack {
            WebImage(url: card.cardImage)
                .onSuccess { image, data, cacheType in
                    // Success
                }
                .placeholder {
                    Rectangle().foregroundColor(.gray).opacity(0.5)
                }
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
            
//            Image(uiImage: card.cardImageBase64!)
//                .resizable()
//                    .frame(width: cardWidth, height: cardHeight)
//                    .background(Color.clear)
            
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
                    
//                    HStack(alignment:.top){
//                        Text("Rp.")
//                            .foregroundColor(.white)
//                            .font(.custom("Montserrat-Bold", size: 20))
//
//                        Text(card.saldo)
//                            .foregroundColor(.white)
//                            .font(.custom("Montserrat-Bold", size: 30))
//                        Spacer()
//                    }
                    
//                    HStack{
//                        Text("****")
//                            .foregroundColor(.white)
//                            .font(.custom("Montserrat-Regular", size: 12))
//                        Text(card.rekeningNumber)
//                            .foregroundColor(.white)
//                            .font(.custom("Montserrat-Regular", size: 12))
//                        Spacer()
//                    }
                    
//                    HStack{
//                        Spacer()
//                        if card.blocked {
//                            Text("Blokir Sementara")
//                                .foregroundColor(.white)
//                                .font(.custom("Montserrat-SemiBold", size: 10))
//                        }
//                        else if card.activeStatus {
//                            Text("Aktif")
//                                .foregroundColor(.white)
//                                .font(.custom("Montserrat-SemiBold", size: 10))
//                        }
//                        else {
//                            Text("Tidak Aktif")
//                                .foregroundColor(.white)
//                                .font(.custom("Montserrat-SemiBold", size: 10))
//                        }
//                    }
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

struct ATMCardView_Previews: PreviewProvider {
    static var previews: some View {
        ATMCardView(card: ATMViewModel(id: "1", key: "1", title: "Test", cardImage: URL(string: "")!, description: ATMDescriptionModel(limitPurchase: "0", limitPayment: "0", limitPenarikanHarian: "0", limitTransferKeBankLain: "0", limitTransferAntarSesama: "0", codeClass: "0")), cardWidth: 315, cardHeight: 197, showContent: true)
    }
}
