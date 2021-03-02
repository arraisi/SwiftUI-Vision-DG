//
//  FormInputNewPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputNewPasswordScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    var body: some View {
        VStack {
            Text(NSLocalizedString("NEW PASSWORD".localized(language), comment: ""))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#2334D0"))
            
            Text(NSLocalizedString("Enter your new password".localized(language), comment: ""))
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#002251"))
                .padding(.top, 5)
            
            VStack {
                VStack {
                    HStack {
                        if (showPassword) {
                            TextField(NSLocalizedString("New Password".localized(language), comment: ""), text: self.$passwordCtrl)
                        } else {
                            SecureField(NSLocalizedString("New Password".localized(language), comment: ""), text: self.$passwordCtrl)
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
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    HStack {
                        if (showConfirmPassword) {
                            TextField(NSLocalizedString("Confirm password".localized(language), comment: ""), text: self.$confirmPasswordCtrl)
                        } else {
                            SecureField(NSLocalizedString("Confirm password".localized(language), comment: ""), text: self.$confirmPasswordCtrl)
                        }
                        
                        Button(action: {
                            self.showConfirmPassword.toggle()
                        }, label: {
                            Text(NSLocalizedString("show".localized(language), comment: ""))
                                .foregroundColor(Color(hex: "#3756DF"))
                                .fontWeight(.light)
                        })
                    }
                    .frame(height: 25)
                    .padding(.vertical, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
            }
            .padding()
            
            Spacer()
            
            VStack {
                Button(action: {}, label: {
                    Text(NSLocalizedString("Save New Password".localized(language), comment: ""))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.leading, 20)
                .padding(.trailing, 10)
            }
            .padding(.bottom, 20)
            
        }
        .padding(.top, 60)
        .navigationBarTitle(NSLocalizedString("Change Password".localized(language), comment: ""), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text(NSLocalizedString("Cancel".localized(language), comment: ""))
        }))
    }
}

struct FormInputNewPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputNewPasswordScreen()
    }
}
