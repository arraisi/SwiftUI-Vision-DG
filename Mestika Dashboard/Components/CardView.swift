//
//  CardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/11/20.
//

import SwiftUI

struct CardView: View {
    var card: MyCard
    
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .frame(width: cardWidth, height: cardHeight)
            
            VStack(){
                
                HStack {
                    Image("logo_m_mestika")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                    Spacer()
                }
                .padding(.vertical, 10)
                
                HStack{
                    Text(card.rekeningName)
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Regular", size: 12))
                    Spacer()
                }
                
                HStack(alignment:.top){
                    Text("Rp.")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Bold", size: 20))
                    
                    Text(card.saldo)
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Bold", size: 30))
                    Spacer()
                }
                
                HStack{
                    Text("****")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Regular", size: 12))
                    Text(card.rekeningNumber)
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Regular", size: 12))
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    if card.blocked {
                        Text("Blokir Sementara")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 10))
                    }
                    else if card.activeStatus {
                        Text("Aktif")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 10))
                    }
                    else {
                        Text("Tidak Aktif")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 10))
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .frame(width: cardWidth, height: cardHeight, alignment: .center)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: myCardData[1], cardWidth: 315, cardHeight: 197)
    }
}
