//
//  FormInputOldPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputOldPasswordScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var oldPasswordCtrl = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        VStack {
            Text(NSLocalizedString("OLD PASSWORD".localized(language), comment: ""))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#2334D0"))
            
            Text(NSLocalizedString("Please enter your old account password".localized(language), comment: ""))
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#002251"))
                .padding(.top, 5)
            
            VStack {
                HStack {
                    if (showPassword) {
                        TextField("Your account password".localized(language), text: self.$oldPasswordCtrl)
                    } else {
                        SecureField("Your account password".localized(language), text: self.$oldPasswordCtrl)
                    }
                    
                    Button(action: {
                        self.showPassword.toggle()
                    }, label: {
                        Text(NSLocalizedString("show".localized(language), comment: ""))
                            .foregroundColor(Color(hex: "#3756DF"))
                            .fontWeight(.light)
                    })
                }
                .frame(height: 25)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
            }
            .padding()
            
            Spacer()

        }
        .padding(.top, 60)
        .navigationBarTitle("Change Password".localized(language), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text(NSLocalizedString("Cancel".localized(language), comment: ""))
        }))
    }
}

struct FormInputOldPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputOldPasswordScreen()
    }
}
