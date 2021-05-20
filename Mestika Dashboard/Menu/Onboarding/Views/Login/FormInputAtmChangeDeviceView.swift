//
//  FormInputAtmChangeDeviceView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 29/04/21.
//

import SwiftUI
import Indicators

struct FormInputAtmChangeDeviceView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    
    // Message
    @State private var responseCode: String = ""
    @State private var responseMsg: String = ""
    
    // Variable Local
    @State private var isLoading: Bool = false
    @State private var isShowPwd: Bool = false
    @State private var isShowModalError: Bool = false
    @State private var isShowModalSuccess: Bool = false
    
    // Controller
    @State private var cardNoCtrl: String = ""
    @State private var pinCtrl: String = ""
    
    // Route
    @State private var nextRoute: Bool = false
    @State private var routeNewPassword: Bool = false
    
    // @Binding Data
    @Binding var pwd: String
    @Binding var phoneNmbr: String
    
    var disableForm: Bool {
        if (cardNoCtrl.isEmpty || pinCtrl.isEmpty || isLoading) {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            NavigationLink(
                destination: BottomNavigationView(),
                isActive: self.$nextRoute,
                label: {}
            )
            .isDetailLink(false)
            
            NavigationLink(
                destination: FormForceChangePasswordView(),
                isActive: self.$routeNewPassword,
                label: {}
            )
            .isDetailLink(false)
            
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                Text("MASUKKAN DATA ANDA")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Masukkan nomor kartu ATM dan PIN ATM anda yang sudah terdaftar")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                
                VStack {
                    HStack {
                        TextField("Masukkan nomor ATM Anda", text: self.$cardNoCtrl)
                            .keyboardType(.numberPad)
                            .onReceive(cardNoCtrl.publisher.collect()) {
                                self.cardNoCtrl = String($0.prefix(16))
                            }
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
                        if (isShowPwd) {
                            TextField("Masukkan PIN ATM Anda", text: self.$pinCtrl)
                                .keyboardType(.numberPad)
                                .onReceive(pinCtrl.publisher.collect()) {
                                    self.pinCtrl = String($0.prefix(6))
                                }
                        } else {
                            SecureField("Masukkan PIN ATM Anda", text: self.$pinCtrl)
                                .keyboardType(.numberPad)
                                .onReceive(pinCtrl.publisher.collect()) {
                                    self.pinCtrl = String($0.prefix(6))
                                }
                        }
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding(.horizontal)
                
                VStack {
                    
                    Button(
                        action: {
                            UIApplication.shared.endEditing()
                            login()
                        },
                        label: {
                            Text("Konfirmasi Data")
                                .foregroundColor(disableForm ? Color.white : Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        }
                    )
                    .background(disableForm ? Color(.lightGray) : Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    .disabled(disableForm)
                }
                .padding(.vertical, 50)
            }
            
            if self.isShowModalError || self.isShowModalSuccess {
                ModalOverlay(tapAction: { withAnimation { } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $isShowModalError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            modalError()
        }
    }
    
    // func login change device
    @ObservedObject private var authVM = AuthViewModel()
    func login() {
        self.isLoading = true
        
        self.authVM.postLoginChangeDevice(password: self.pwd, phoneNumber: self.phoneNmbr, atmPin: self.pinCtrl, cardNo: self.cardNoCtrl) { success in
            
            DispatchQueue.main.async {
                if success {
                    self.isLoading = false
                    self.nextRoute = true
                }
                
                if !success {
                    self.isLoading = false
                    self.responseMsg = self.authVM.errorMessage
                    self.responseCode = self.authVM.errorCode
                    self.isShowModalError = true
                }
            }
            
        }
    }
    
    // MARK: -Bottom modal for error
    func modalError() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text(self.responseMsg)
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                
                if (self.responseCode == "206") {
                    self.routeNewPassword = true
                } else {
                    self.isShowModalError = false
                }
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
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

struct FormInputAtmChangeDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        FormInputAtmChangeDeviceView(pwd: .constant(""), phoneNmbr: .constant(""))
    }
}
