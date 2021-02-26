//
//  FormInputRekeningForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormNoRekeningPinForgotPasswordScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var atmNumberCtrl = ""
    @State private var pinAtmCtrl = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(NSLocalizedString("INPUT NO ACCOUNT / ID CARD".localized(language), comment: ""))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(NSLocalizedString("Enter your account number / KTP and Transaction PIN.".localized(language), comment: ""))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        TextField(NSLocalizedString("Enter your account number / ID CARD".localized(language), comment: ""), text: self.$atmNumberCtrl)
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
                        TextField(NSLocalizedString("Enter your Transaction PIN".localized(language), comment: ""), text: self.$pinAtmCtrl)
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
                    NavigationLink(destination: LoginScreen(isNewDeviceLogin: .constant(false)), label: {
                        Text(NSLocalizedString("DATA CONFIRMATION".localized(language), comment: ""))
                            .foregroundColor(Color(hex: "#232175"))
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

struct FormInputRekeningForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormNoRekeningPinForgotPasswordScreen()
    }
}
