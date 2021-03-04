//
//  FormInputPasswordForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormPasswordVerificationForgotPasswordView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var oldPasswordCtrl = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("ENTER PASSWORD".localized(language))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Proses verifikasi berhasil, Silahkan masukkan password aplikasi Anda.".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                VStack {
                    HStack {
                        if (showPassword) {
                            TextField("Enter Password".localized(language), text: self.$oldPasswordCtrl)
                        } else {
                            SecureField("Enter Password".localized(language), text: self.$oldPasswordCtrl)
                        }
                        
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            Text("show")
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
                
                VStack {
                    NavigationLink(destination: FormNoRekeningPinForgotPasswordScreen(), label: {
                        Text("ENTER PASSWORD".localized(language))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        
                    })
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                }
                .padding(.bottom, 20)
                
            }
            .padding(.top, 60)
        }
        .navigationBarTitle("Forgot Password".localized(language), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text("Cancel")
        }))
    }
}

struct FormInputPasswordForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormPasswordVerificationForgotPasswordView()
    }
}
