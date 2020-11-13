//
//  FormInputNewPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputNewPasswordScreen: View {
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    var body: some View {
        VStack {
            Text("PASSWORD BARU")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(hex: "#2334D0"))
            
            Text("Silahkan masukkan password baru Anda")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#002251"))
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
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Simpan Password Baru")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
        .navigationBarTitle("Ubah Password", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text("Cancel")
        }))
    }
}

struct FormInputNewPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputNewPasswordScreen()
    }
}
