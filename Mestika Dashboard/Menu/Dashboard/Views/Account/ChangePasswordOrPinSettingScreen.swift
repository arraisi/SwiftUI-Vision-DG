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
                        Text(NSLocalizedString("Change Transaction PIN".localized(language), comment: ""))
                    })
                    
                    NavigationLink(destination: FormInputOldPasswordScreen(), label: {
                        Text(NSLocalizedString("Change Password".localized(language), comment: ""))
                    })
                    
                    NavigationLink(destination: FormInputResetPinScreen(unLocked: false), label: {
                        Text(NSLocalizedString("Reset Transaction PIN".localized(language), comment: ""))
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
        .navigationBarTitle(NSLocalizedString("Change Password / PIN".localized(language), comment: ""), displayMode: .inline)
    }
}

struct ChangePasswordOrPinSettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordOrPinSettingScreen()
    }
}
