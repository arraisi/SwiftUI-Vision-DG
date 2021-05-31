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
            
            if showContent {
                VStack(){
                    
                    HStack{
                        Text("GOLD")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    VStack {
                        HStack{
                            Text((self.card.status != "ACTIVE" ? "****" : card.cardNo) ?? "")
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
                        .hidden()
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 15)
                    .padding(.top, 21)
                    
                    HStack{
                        Text(card.nameOnCard)
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Regular", size: 15))
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    HStack{
                        Spacer()
                        Text((self.card.status == "INACTIVE" ? "INACTIVE" : self.card.status) ?? "INACTIVE")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 10))
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding()

            }
                    }
        .frame(width: cardWidth, height: cardHeight, alignment: .center)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: KartuKuDesignViewModel(cardFlag: "", kodepos: "", provinsi: "", kabupatenKota: "", kecamatan: "", kelurahan: "", rw: "", rt: "", postalAddress: "", accountNumber: "", nameOnCard: "", cardNo: "", classCode: "", nik: "", id: "", imageNameAlias: "", mainCard: "", status: ""), cardWidth: 315, cardHeight: 197, showContent: true)
    }
}
