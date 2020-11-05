//
//  FormInputNewPasswordForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormInputNewPasswordForgotPasswordScreen: View {
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    var body: some View {
        ZStack {
            
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("PASSWORD BARU")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Text("Pasword aplikasi harus berjumlah minimal 8 karakter huruf. Terdiri dari Uppercase, Number, etc.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                VStack {
                    VStack {
                        HStack {
                            if (showPassword) {
                                TextField("Password baru Anda", text: self.$passwordCtrl)
                            } else {
                                SecureField("Password baru Anda", text: self.$passwordCtrl)
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
                        .padding(.vertical, 10)
                        
                        Divider()
                        
                        HStack {
                            if (showConfirmPassword) {
                                TextField("Confirm password", text: self.$confirmPasswordCtrl)
                            } else {
                                SecureField("Confirm password", text: self.$confirmPasswordCtrl)
                            }
                            
                            Button(action: {
                                self.showConfirmPassword.toggle()
                            }, label: {
                                Text("show")
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
                    NavigationLink(destination: FormInputPasswordForgotPasswordScreen(), label: {
                        Text("Simpan Password Baru")
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

struct FormInputNewPasswordForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputNewPasswordForgotPasswordScreen()
    }
}
