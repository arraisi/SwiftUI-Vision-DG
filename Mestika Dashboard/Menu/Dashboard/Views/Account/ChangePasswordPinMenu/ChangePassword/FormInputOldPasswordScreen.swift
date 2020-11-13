//
//  FormInputOldPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputOldPasswordScreen: View {
    
    @State private var oldPasswordCtrl = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        VStack {
            Text("PASSWORD LAMA")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(hex: "#2334D0"))
            
            Text("Silahkan masukkan password akun lama Anda")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#002251"))
                .padding(.top, 5)
            
            VStack {
                HStack {
                    if (showPassword) {
                        TextField("Password account Anda", text: self.$oldPasswordCtrl)
                    } else {
                        SecureField("Password account Anda", text: self.$oldPasswordCtrl)
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

        }
        .padding(.top, 60)
        .navigationBarTitle("Ubah Password", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text("Cancel")
        }))
    }
}

struct FormInputOldPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputOldPasswordScreen()
    }
}
