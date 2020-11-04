//
//  DetailKartuAktifView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct DetailKartuAktifView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            
            ForEach(0..<5) {i in
                HStack {
                    Image("ic_credit_card")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .colorInvert()
                    
                    VStack(alignment: .leading){
                        Text("Kartu Rekening Tidak Aktif")
                            .font(.custom("Montserrat-SemiBold", size: 15))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        
                        Text("Aktifkan terlebih dahulu kartu Anda untuk melihat pengaturan.")
                            .font(.custom("Montserrat-Light", size: 10))
                            .foregroundColor(Color(hex: "#232175"))
                    }
                }
            }
        }
        .padding(30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(25)
    }
}

struct DetailKartuAktifView_Previews: PreviewProvider {
    static var previews: some View {
        DetailKartuAktifView()
    }
}
