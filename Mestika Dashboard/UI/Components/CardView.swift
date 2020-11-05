//
//  CardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/11/20.
//

import SwiftUI

struct CardView: View {
    var background: Image
    var rekeningName: String
    var saldo: String
    var rekeningNumber: String
    var activeStatus: Bool
    
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    var body: some View {
        ZStack {
            background
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
                    Text(rekeningName)
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Regular", size: 12))
                    Spacer()
                }
                
                HStack(alignment:.top){
                    Text("Rp.")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Bold", size: 20))
                    
                    Text(saldo)
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Bold", size: 30))
                    Spacer()
                }
                
                HStack{
                    Text("****")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Regular", size: 12))
                    Text(rekeningNumber)
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-Regular", size: 12))
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    if activeStatus {
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
        CardView(background: Image("card_bg"), rekeningName: "Rekening Utama", saldo: "12.000.000", rekeningNumber: "1234", activeStatus: true, cardWidth: 315, cardHeight: 197)
    }
}
