//
//  Pekerjaan.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/05/21.
//

import SwiftUI

struct PekerjaanData: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var pekerjaan: String
    @Binding var pengahasilanKotor: String
    @Binding var pendapatanLainnya: String
    
    var body: some View {
        VStack {
            
            Text("Data Pekerjaan".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding()
                .multilineTextAlignment(.center)
            
            VStack {
                LabelTextField(value: self.$pekerjaan, label: "Pekerjaan".localized(language), placeHolder: "Pekerjaan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$pengahasilanKotor, label: "Penghasilan Kotor".localized(language), placeHolder: "Penghasilan Kotor".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$pendapatanLainnya, label: "Pendapatan Lainnya".localized(language), placeHolder: "Pendapatan Lainnya".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
            }
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
        .padding(.horizontal, 25)
    }
}

struct Pekerjaan_Previews: PreviewProvider {
    static var previews: some View {
        PekerjaanData(pekerjaan: .constant(""), pengahasilanKotor: .constant(""), pendapatanLainnya: .constant(""))
    }
}
