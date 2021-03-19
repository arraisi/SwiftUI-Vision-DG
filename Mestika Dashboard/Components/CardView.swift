//
//  CardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/11/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    var card: KartuKuDesignViewModel
    
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    let showContent: Bool
    
    var body: some View {
        ZStack {
            WebImage(url: card.cardDesign!)
                .onSuccess { image, data, cacheType in
                    // Success
                }
                .placeholder {
                    Rectangle().foregroundColor(.gray).opacity(0.5)
                        .frame(width: cardWidth, height: cardHeight)
                }
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
            
//            Image("card_bg")
//                .resizable()
//                .frame(width: cardWidth, height: cardHeight)
            
            if showContent {
                VStack(){
                    
//                    HStack {
//                        Spacer()
//                        Image("logo_mestika")
//                            .resizable()
//                            .frame(width: 100, height: 15, alignment: .center)
//                    }
//                    .padding(.vertical, 10)
                    
                    HStack{
                        Text("GOLD")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    VStack {
                        HStack{
                            Text(self.card.status != "ACTIVE" ? "**** \(card.cardNo.subStringRange(from: 12, to: 16))" : card.cardNo)
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-Regular", size: 14))
                            Spacer()
                        }
                        
                        HStack{
                            Text(card.accountNumber)
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-Regular", size: 14))
                            Spacer()
                        }
                    }
                    .padding(.top, 10)
                    
                    HStack{
                        Text(card.nameOnCard)
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Regular", size: 15))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    HStack{
                        Spacer()
                        Text(self.card.status == "INACTIVE" ? "INACTIVE" : self.card.status)
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 10))
//                        if card.status {
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
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()

            }
                    }
        .frame(width: cardWidth, height: cardHeight, alignment: .center)
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: KartuKuResponse[0], cardWidth: 315, cardHeight: 197, showContent: true)
//    }
//}
