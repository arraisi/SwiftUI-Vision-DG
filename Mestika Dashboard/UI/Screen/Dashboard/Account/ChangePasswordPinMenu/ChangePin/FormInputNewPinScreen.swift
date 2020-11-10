//
//  FormInputNewPinScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputNewPinScreen: View {
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    var body: some View {
        VStack {
            Text("MASUKKAN PIN BARU")
                .font(.custom("Montserrat-SemiBold", size: 24))
                .foregroundColor(Color(hex: "#2334D0"))
            
            Text("Silahkan masukkan PIN transaksi baru Anda")
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(Color(hex: "#002251"))
                .padding(.top, 5)
            
            VStack {
                VStack {
                    HStack {
                        if (showPassword) {
                            TextField("PIN baru Anda", text: self.$passwordCtrl)
                                .font(.custom("Montserrat-Light", size: 14))
                        } else {
                            SecureField("PIN baru Anda", text: self.$passwordCtrl)
                                .font(.custom("Montserrat-Light", size: 14))
                        }
                        
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            Text("show")
                                .foregroundColor(Color(hex: "#3756DF"))
                                .font(.custom("Montserrat-Light", size: 10))
                        })
                    }
                    .frame(height: 25)
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    HStack {
                        if (showConfirmPassword) {
                            TextField("Confirm PIN", text: self.$confirmPasswordCtrl)
                                .font(.custom("Montserrat-Light", size: 14))
                        } else {
                            SecureField("Confirm PIN", text: self.$confirmPasswordCtrl)
                                .font(.custom("Montserrat-Light", size: 14))
                        }
                        
                        Button(action: {
                            self.showConfirmPassword.toggle()
                        }, label: {
                            Text("show")
                                .foregroundColor(Color(hex: "#3756DF"))
                                .font(.custom("Montserrat-Light", size: 10))
                        })
                    }
                    .frame(height: 25)
                    .padding(.vertical, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
            }
            .padding()
            
            Spacer()
            
            VStack {
                Button(action: {}, label: {
                    Text("Simpan PIN Transaksi Baru")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 16))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.leading, 20)
                .padding(.trailing, 10)
            }
            .padding(.bottom, 20)
            
        }
        .padding(.top, 60)
        .navigationBarTitle("Ubah PIN Transaksi", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}, label: {
            Text("Cancel")
        }))
    }
}

struct FormInputNewPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputNewPinScreen()
    }
}
