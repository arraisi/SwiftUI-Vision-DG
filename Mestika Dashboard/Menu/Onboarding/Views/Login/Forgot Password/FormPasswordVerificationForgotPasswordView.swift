//
//  FormInputPasswordForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormPasswordVerificationForgotPasswordView: View {
    
    @State private var oldPasswordCtrl = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("MASUKKAN PASSWORD")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Text("Proses verifikasi berhasil, Silahkan masukkan password aplikasi Anda.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                VStack {
                    HStack {
                        if (showPassword) {
                            TextField("Masukkan Password", text: self.$oldPasswordCtrl)
                        } else {
                            SecureField("Masukkan Password", text: self.$oldPasswordCtrl)
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
                        Text("MASUKKAN PASSWORD")
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
        .navigationBarTitle("Lupa Password", displayMode: .inline)
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
