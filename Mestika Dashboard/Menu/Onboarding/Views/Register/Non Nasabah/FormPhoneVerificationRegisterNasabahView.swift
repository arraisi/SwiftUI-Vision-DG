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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /* Variable Data */
    @State var phoneNumber: String = ""
    
    /* Disabled Form */
    var disableForm: Bool {
        phoneNumber.count < 10
    }
    
    /* Data Binding */
    @Binding var rootIsActive : Bool
    
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
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#232175"))
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                Text("Silahkan masukan No. Telepon Anda")
                    .font(.caption)
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
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                NavigationLink(destination: FormOTPVerificationRegisterNasabahView(rootIsActive: self.$rootIsActive).environmentObject(registerData)) {
                    Text("Verifikasi No. Telepon")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
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
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct PhoneVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        FormPhoneVerificationRegisterNasabahView(rootIsActive: .constant(false)).environmentObject(RegistrasiModel())
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
