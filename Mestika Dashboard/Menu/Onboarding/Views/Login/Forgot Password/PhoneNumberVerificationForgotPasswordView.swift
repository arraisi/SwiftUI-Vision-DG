//
//  ForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct PhoneNumberVerificationForgotPasswordView: View {
    
    @State private var phoneNumberCtrl = ""
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("VERIFIKASI NO. HP ANDA")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Text("Silahkan Masukkan Nomor Handphone Anda")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                HStack {
                    HStack {
                        Image("indo_flag")
                        Text("+62 ")
                            .font(.system(size: 12))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    
                    Divider()
                        .frame(height: 20)
                    
                    TextField("Phone Number", text: $phoneNumberCtrl, onEditingChanged: { changed in
                        print("\($phoneNumberCtrl)")
                    })
                    .keyboardType(.numberPad)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.top, 20)
                .padding()
                
                Text("Pastikan nomor handphone Anda telah sesuai sebelum melanjutkan ketahap berikutnya.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                VStack {
                    NavigationLink(destination: PhoneNumberVerificationForgotPasswordView(), label: {
                        Text("MASUKKAN NO. HP ANDA")
                            .foregroundColor(Color(hex: "#232175"))
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

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberVerificationForgotPasswordView()
    }
}
