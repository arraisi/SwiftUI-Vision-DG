//
//  PembukaanRekening.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/05/21.
//

import SwiftUI

struct PembukaanRekeningData: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var tujuanBukaRek: String
    @Binding var sumberDana: String
    @Binding var penarikanPerbulan: String
    @Binding var danaPenarikanPerbulan: String
    @Binding var setoranPerbulan: String
    @Binding var danaSetoranPerbulan: String
    
    var body: some View {
        VStack {
            
            Text("Data Pembukaan Rekening".localized(language))
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding()
                .multilineTextAlignment(.center)
            
            VStack {
                LabelTextField(value: self.$tujuanBukaRek, label: "Tujuan Pembukaan".localized(language), placeHolder: "Tujuan Pembukaan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$sumberDana, label: "Sumber Dana".localized(language), placeHolder: "Sumber Dana".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$penarikanPerbulan, label: "Jumlah Penarikan Perbulan".localized(language), placeHolder: "Jumlah Penarikan Perbulan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$danaPenarikanPerbulan, label: "Jumlah Penarikan Dana Perbulan".localized(language), placeHolder: "Jumlah Penarikan Dana Perbulan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$setoranPerbulan, label: "Jumlah Setoran Perbulan".localized(language), placeHolder: "Jumlah Setoran Perbulan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$danaSetoranPerbulan, label: "Jumlah Setoran Dana Perbulan".localized(language), placeHolder: "Jumlah Setoran Dana Perbulan".localized(language), disabled: false, onEditingChanged: { (Bool) in
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

struct PembukaanRekening_Previews: PreviewProvider {
    static var previews: some View {
        PembukaanRekeningData(tujuanBukaRek: .constant(""), sumberDana: .constant(""), penarikanPerbulan: .constant(""), danaPenarikanPerbulan: .constant(""), setoranPerbulan: .constant(""), danaSetoranPerbulan: .constant(""))
    }
}
