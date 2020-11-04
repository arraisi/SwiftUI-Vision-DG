//
//  DetailKartuTidakAktifView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct DetailKartuTidakAktifView: View {
    
    var kartu: Card
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            HStack {
                Image("ic_credit_card")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .colorInvert()
                
                Spacer()
            }
            
            HStack {
                Text("\(kartu.name) Rekening Tidak Aktif")
                    .font(.custom("Montserrat-SemiBold", size: 15))
                    .foregroundColor(Color(hex: "#232175"))
                
                Spacer()
            }
            
            HStack {
                Text("Aktifkan terlebih dahulu kartu Anda untuk melihat pengaturan.")
                    .font(.custom("Montserrat-Light", size: 10))
                    .foregroundColor(Color(hex: "#232175"))
                
                Spacer()
            }
            .padding(.bottom, 30)
            
            NavigationLink(
                destination: ActivationCardView(),
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
        .padding(.top, 40)
        .padding(30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(25)
    }
}

struct DetailKartuTidakAktifView_Previews: PreviewProvider {
    static var previews: some View {
        DetailKartuTidakAktifView(kartu: Card(id: 0, imageName: "rekening-card-3", name: "KARTU 1", description: "KARTU 1", activeStatus: false, isShow: false))
            .previewLayout(PreviewLayout.fixed(width: UIScreen.main.bounds.width-60, height: 400))
    }
}
