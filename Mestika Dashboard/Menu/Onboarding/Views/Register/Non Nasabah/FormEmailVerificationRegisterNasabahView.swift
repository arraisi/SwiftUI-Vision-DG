//
//  EmailVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 29/09/20.
//

import SwiftUI

struct FormEmailVerificationRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @State var email: String = ""
    @State private var isEmailValid : Bool   = false
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
//                AppBarLogo(light: false, onCancel: {})
                
                VStack(alignment: .center) {
                    
                    Text("Email Verification")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.top, 30)
                    
                    Text("Silahkan masukan Alamat Email Anda")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                    
                    TextField("Masukan alamat email anda", text: $email, onEditingChanged: { changed in
                        print("Changed")
                        self.registerData.email = self.email
                    }, onCommit: {
                        print("Commited")
                        self.registerData.email = self.email
                    })
                    .frame(height: 30)
                    .font(.custom("Montserrat-Regular", size: 12))
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                    .padding(.top, 20)
                    .onReceive(email.publisher.collect()) { it in
                        self.isEmailValid = self.textFieldValidatorEmail(String(it)) && it.count > 8
                    }
                    
                    HStack {
                        Text("*Email harus lebih dari 8 karakter")
                            .font(.custom("Montserrat-SemiBold", size: 10))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    
                    NavigationLink(destination: FormEmailOTPVerificationRegisterNasabahView().environmentObject(registerData)) {
                        
                        Text("Verifikasi Email")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        
                    }
                    .background(Color(hex: !self.isEmailValid ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    .disabled(!self.isEmailValid)
                }
                .padding(.horizontal, 30)
                .frame(width: UIScreen.main.bounds.width - 40)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.top, 120)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        
    }
}

#if DEBUG
struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        FormEmailVerificationRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
#endif
