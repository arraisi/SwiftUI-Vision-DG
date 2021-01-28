//
//  FirstLoginView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 12/10/20.
//

import SwiftUI

struct FirstLoginView: View {
    
    /* Environtment Object */
    @EnvironmentObject var loginData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @State private var nextRoute: Bool = false
    @State var phoneNumber: String = ""
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    /* Disabled Form */
    var disableForm: Bool {
        phoneNumber.count < 10
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                VStack {
                    Text("LOGIN APPS")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessage()
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            Text("Silahkan Masukkan Nomor Handphone Anda")
                .font(.caption)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            HStack {
                Text("🇮🇩 +62 ").foregroundColor(.gray)
                
                Divider()
                    .frame(height: 20)
                
                TextField("No. Telepon", text: $phoneNumber, onEditingChanged: { changed in
                    print("\($phoneNumber)")
                    
                    self.loginData.noTelepon = phoneNumber
                })
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
            .font(.subheadline)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
            Text("Pastikan nomor handphone Anda telah sesuai sebelum melanjutkan ketahap berikutnya")
                .font(.caption)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            Button(
                action: {
                    checkPhoneNumber()
                },
                label: {
                    Text("Masukkan No. HP Anda")
                        .foregroundColor(disableForm ? .white : Color(hex: "#232175"))
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                })
                .background(disableForm ? Color.gray.opacity(0.3) : Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .disabled(disableForm)
            
            NavigationLink(
                destination: FirstOTPLoginView().environmentObject(loginData),
                isActive: self.$nextRoute,
                label: {}
            )
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    func checkPhoneNumber() {
        self.nextRoute = true
    }
    
    // MARK:- POPUP MESSAGE
    func popupMessage() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("No. Telepon belum terdaftar")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("Nomor yang anda masukkan tidak terdaftar silahkan lakukan registrasi.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
//                self.rootIsActive = true
                self.appState.moveToWelcomeView = true
            }) {
                Text("Kembali")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Text("")
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#if DEBUG
struct FirstLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLoginView().environmentObject(LoginBindingModel())
    }
}
#endif
