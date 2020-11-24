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
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack(alignment: .center) {
                Text("Phone Verification")
                    .font(.custom("Montserrat-SemiBold", size: 18))
                    .foregroundColor(Color(hex: "#232175"))
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                Text("Silahkan masukan No. Telepon Anda")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                
                HStack {
                    Text("🇮🇩 +62 ").foregroundColor(.black)
                    
                    Divider()
                        .frame(height: 30)
                    
                    TextField("No. Telepon", text: $phoneNumber, onEditingChanged: { changed in
                        print("\($phoneNumber)")
                        
                        self.registerData.noTelepon = "0" + phoneNumber
                    }, onCommit: {
                        print("Commited")
                        self.registerData.noTelepon = "0" + phoneNumber
                    })
                    .onReceive(phoneNumber.publisher.collect()) {
                        self.phoneNumber = String($0.prefix(12))
                    }
                    .keyboardType(.numberPad)
                }
                .frame(height: 20)
                .font(.custom("Montserrat-Regular", size: 12))
                .padding()
                .background(Color(hex: "#f4f4f4"))
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.25), radius: 15, x: 0.0, y: 4)
                .padding(20)
                
                NavigationLink(destination: FormOTPVerificationRegisterNasabahView().environmentObject(registerData)) {
                    
                    Text("Verifikasi No. Telepon")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    
                }
                .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .disabled(disableForm)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 30)
            .padding(.top, 120)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct PhoneVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormPhoneVerificationRegisterNasabahView().environmentObject(RegistrasiModel())
        }
    }
}
