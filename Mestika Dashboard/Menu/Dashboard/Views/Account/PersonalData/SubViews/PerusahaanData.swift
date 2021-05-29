//
//  PerusahaanData.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/05/21.
//

import SwiftUI

struct PerusahaanData: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var nama: String
    @Binding var alamat: String
    @Binding var kodePos: String
    @Binding var kelurahan: String
    @Binding var kecamatan: String
    @Binding var telepon: String
    
    var body: some View {
        VStack {
            
            Text("Data Perushaan".localized(language))
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding()
                .multilineTextAlignment(.center)
            
            VStack {
                LabelTextField(value: self.$nama, label: "Nama".localized(language), placeHolder: "Nama".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$alamat, label: "Alamat".localized(language), placeHolder: "Alamat".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kodePos, label: "Kode Pos".localized(language), placeHolder: "Kode Pos".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kelurahan, label: "Kelurahan".localized(language), placeHolder: "Kelurahan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kecamatan, label: "Kecamatan".localized(language), placeHolder: "Kecamatan".localized(language), disabled: false, onEditingChanged: { (Bool) in
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

struct PerusahaanData_Previews: PreviewProvider {
    static var previews: some View {
        PerusahaanData(nama: .constant(""), alamat: .constant(""), kodePos: .constant(""), kelurahan: .constant(""), kecamatan: .constant(""), telepon: .constant(""))
    }
}
