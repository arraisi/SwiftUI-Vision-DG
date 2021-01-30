//
//  FormInputAtmForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormInputAtmForgotPasswordScreen: View {
    
    @State private var atmNumberCtrl = ""
    @State private var pinAtmCtrl = ""
    @State private var showPassword: Bool = false
    
    /* Route */
    @State var isNextRoute: Bool = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                Text("INPUT DATA ATM")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Masukkan nomor kartu ATM dan PIN ATM Anda yang sudah terdaftar")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        TextField("Masukkan nomor ATM Anda", text: self.$atmNumberCtrl)
                            .keyboardType(.numberPad)
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
                        TextField("Masukkan PIN ATM Anda", text: self.$pinAtmCtrl)
                            .keyboardType(.numberPad)
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding(.horizontal)
                
                Spacer()
                
//                VStack {
//                    NavigationLink(destination: FormInputAtmPinForgotPasswordView(), label: {
//                        Text("AKTIVASI KARTU ATM BARU")
//                            .foregroundColor(Color(hex: "#232175"))
//                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                            .font(.system(size: 13))
//                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
//
//                    })
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .padding(.leading, 20)
//                    .padding(.trailing, 10)
//                }
//                .padding(.bottom, 10)
                
                VStack {
                    
                    Button(
                        action: {
//                            self.isNextRoute = true
                            validatePinTrx()
                        },
                        label: {
                            Text("KONFIRMASI DATA")
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    )
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    
                    NavigationLink(
                        destination: FormInputNewPasswordForgotPasswordView(),
                        isActive: self.$isNextRoute) {}
                }
                .padding(.bottom, 20)
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
    
    @ObservedObject private var authVM = AuthViewModel()
    func validatePinTrx() {
        self.authVM.validatePinTrx(accountNumber: atmNumberCtrl, pinTrx: pinAtmCtrl) { success in
            
            if success {
                print("SUCCESS")
                self.isNextRoute = true
            }
            
            if !success {
                print("NOT SUCCESS")
            }
        }
    }
}

struct FormInputAtmForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputAtmForgotPasswordScreen()
    }
}
