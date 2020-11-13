//
//  FormInputRekeningForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormInputRekeningForgotPasswordScreen: View {
    
    @State private var atmNumberCtrl = ""
    @State private var pinAtmCtrl = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("INPUT NO REKENING / KTP")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Text("Masukkan nomor rekening / KTP dan PIN Transaksi Anda.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        TextField("Masukkan nomor rekening / KTP", text: self.$atmNumberCtrl)
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding()
                
                VStack {
                    HStack {
                        TextField("Masukkan PIN Transaksi Anda", text: self.$pinAtmCtrl)
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    NavigationLink(destination: LoginScreen(), label: {
                        Text("KONFIRMASI DATA")
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

struct FormInputRekeningForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputRekeningForgotPasswordScreen()
    }
}
