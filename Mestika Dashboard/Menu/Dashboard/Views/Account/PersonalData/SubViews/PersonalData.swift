//
//  PersonalData.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/05/21.
//

import SwiftUI

struct PersonalData: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var name: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var placeOfBirth: String
    @Binding var dateOfBirth: String
    @Binding var gender: String
    
    var body: some View {
        VStack {
            
            Text("Personal Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding()
            
            VStack {
                LabelTextField(value: self.$name, label: "Name".localized(language), placeHolder: "Name".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$phone, label: "Telephone".localized(language), placeHolder: "Telephone".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$email, label: "e-Mail".localized(language), placeHolder: "e-Mail".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$placeOfBirth, label: "Place of Birth".localized(language), placeHolder: "Place of Birth".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$dateOfBirth, label: "Date of Birth".localized(language), placeHolder: "Date of Birth".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
//                LabelTextField(value: self.$gender, label: "Gender".localized(language), placeHolder: "Gender".localized(language), disabled: false, onEditingChanged: { (Bool) in
//                    print("on edit")
//                }, onCommit: {
//                    print("on commit")
//                })
                
                LabelTextFieldMenu(value: self.$gender, label: "Gender", data: ["Laki-laki", "Perempuan"], onEditingChanged: {_ in}, onCommit: {})
            }
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
        .padding(.horizontal, 25)
    }
}

struct PersonalData_Previews: PreviewProvider {
    static var previews: some View {
        PersonalData(name: .constant(""), phone: .constant(""), email: .constant(""), placeOfBirth: .constant(""), dateOfBirth: .constant(""), gender: .constant(""))
    }
}
