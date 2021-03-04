//
//  ChangePasswordOrPinSettingScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct ChangePasswordOrPinSettingScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    var body: some View {
        VStack {
            VStack {
                List {
                    NavigationLink(destination: FormInputOldPasswordScreen(), label: {
                        Text("Change Transaction PIN".localized(language))
                    })
                    
                    NavigationLink(destination: FormInputOldPasswordScreen(), label: {
                        Text("Change Password".localized(language))
                    })
                    
                    NavigationLink(destination: FormInputResetPinScreen(unLocked: false), label: {
                        Text("Reset Transaction PIN".localized(language))
                    })
                }
                .padding([.top, .bottom], 20)
                .frame(height: 200)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 20)
            
            Spacer()
        }
        .navigationBarTitle("Change Password / PIN".localized(language), displayMode: .inline)
    }
}

struct ChangePasswordOrPinSettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordOrPinSettingScreen()
    }
}
