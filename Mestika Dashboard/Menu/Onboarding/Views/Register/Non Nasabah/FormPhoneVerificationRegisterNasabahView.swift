//
//  PhoneVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI

struct FormPhoneVerificationRegisterNasabahView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Variable Data */
    @State var phoneNumber: String = ""
    
    /* Disabled Form */
    var disableForm: Bool {
        phoneNumber.count < 10
    }
    
    // MARK: -MAIN CONTENT
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: UIScreen.main.bounds.height*0.35)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
//                AppBarLogo(light: false, onCancel: {})
                
                VStack(alignment: .center) {
                    Text("Phone Verification")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.top, 30)
                    
                    Text("Silahkan masukan No. Telepon Anda")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("🇮🇩 +62 ").foregroundColor(.black)
                        
                        Divider()
                            .frame(height: 30)
                        
                        TextField("No. Telepon", text: $phoneNumber, onEditingChanged: { changed in
                            print("\($phoneNumber)")
                            
                            self.registerData.noTelepon = phoneNumber
                        }, onCommit: {
                            print("Commited")
                            self.registerData.noTelepon = phoneNumber
                        })
                        .foregroundColor(.black)
                        .onReceive(phoneNumber.publisher.collect()) {
                            if String($0).hasPrefix("0") {
                                self.phoneNumber = String(String($0).substring(with: 1..<String($0).count).prefix(12))
                            } else {
                                self.phoneNumber = String($0.prefix(12))
                            }
                        }
                        .keyboardType(.numberPad)
                    }
                    .frame(height: 20)
                    .font(.custom("Montserrat-Regular", size: 12))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.25), radius: 15, x: 0.0, y: 4)
                    .padding(.vertical, 15)
                    
                    NavigationLink(destination: FormOTPVerificationRegisterNasabahView().environmentObject(registerData)) {
                        
                        Text("Verifikasi No. Telepon")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        
                    }
                    .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                    .disabled(disableForm)
                }
                .padding(.horizontal, 30)
                .frame(width: UIScreen.main.bounds.width - 40)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.top, UIScreen.main.bounds.height * 0.15)
                
            }
            
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onReceive(self.appState.$skipOTP) { skipOTP in
            if skipOTP {
                print("Skip OTP: \(skipOTP)")
                self.appState.skipOTP = false
            }
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct PhoneVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormPhoneVerificationRegisterNasabahView().environmentObject(RegistrasiModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
