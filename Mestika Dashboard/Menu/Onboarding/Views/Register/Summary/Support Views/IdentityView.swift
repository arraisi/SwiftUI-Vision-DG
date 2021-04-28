//
//  IdentityView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 27/04/21.
//

import SwiftUI

struct IdentityView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    var productATMData = AddProductATM()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            LabelTextFieldWithIcon(value: $registerData.nik, label: "Identity Card/(KTP)".localized(language), placeHolder: "Identity Card/(KTP)".localized(language)) {
                (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .disabled(true)
            
            LabelTextFieldWithIcon(value: $registerData.noTelepon, label: "Phone Number".localized(language), placeHolder: "Phone Number".localized(language)) {
                (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .disabled(true)
            
            LabelTextFieldWithIcon(value: $registerData.email, label: "Email", placeHolder: "Email") {
                (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .disabled(true)
            
            LabelTextFieldWithIcon(value: $registerData.npwp, label: "Tax Identification Number".localized(language), placeHolder: "Tax Identification Number".localized(language)) {
                (Bool) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .disabled(true)
        }
        .padding(20)
        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ffffff"), Color(hex: "#ececf6")]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        .padding(.bottom, 10)
        .shadow(radius: 2)
    }
}

struct IdentityView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityView().environmentObject(RegistrasiModel()).environmentObject(AppState())
    }
}
