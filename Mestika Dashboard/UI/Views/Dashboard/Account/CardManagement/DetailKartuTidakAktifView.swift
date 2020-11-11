//
//  DetailKartuTidakAktifView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct DetailKartuTidakAktifView: View {
    
    var card: MyCard
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            HStack {
                Image("credit-card-locked")
                
                Spacer()
            }
            
            HStack {
                Text("Kartu Rekening Tidak Aktif")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#232175"))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            
            HStack {
                Text("Aktifkan terlebih dahulu kartu Anda untuk melihat pengaturan.")
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(Color(hex: "#232175"))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            NavigationLink(
                destination: CardActivationView(card: card),
                label: {
                    Text("AKTIFKAN KARTU-KU")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                })
                .frame(height: 50)
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
            
        }
        .padding(.top, 35)
        .padding(20)
        .background(Color.white)
    }
}

struct DetailKartuTidakAktifView_Previews: PreviewProvider {
    static var previews: some View {
        DetailKartuTidakAktifView(card: myCardData[0])
            .previewLayout(PreviewLayout.fixed(width: UIScreen.main.bounds.width, height: 400))
            .environment(\.colorScheme, .dark)
    }
}
