//
//  LoginScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import LocalAuthentication
import SwiftUI
import Indicators

struct LoginScreen: View {
    
    // Device ID
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    
    /* Data Binding */
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject private var authVM = AuthViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @State private var isUnlocked = false
    @State private var isActiveRoute = false
    
    @State private var passwordCtrl = ""
    @State private var showPassword: Bool = false
    @State var phoneNumber: String = ""
    
    @State var fingerprintFlag: Bool = false
    
    @State var routeNewPassword: Bool = false
    
    @State var isLoading: Bool = false
    
    @State var routeAtmInputLogin: Bool = false
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @FetchRequest(entity: NewDevice.entity(), sortDescriptors: [])
    var device: FetchedResults<NewDevice>
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showingModalError = false
    @State var showingModalBiometricLogin = false
    @State var showingModalForgotPassword = false
    
    @Binding var isNewDeviceLogin: Bool
    
    @State var iconSecure: String = ""
    
    var disableForm: Bool {
        passwordCtrl.isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                Text("LOGIN APPS".localized(language))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Enter Your Account Password".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                VStack {
                    HStack {
                        if (showPassword) {
                            TextField("Your account password".localized(language), text: self.$passwordCtrl)
                        } else {
                            SecureField("Your account password".localized(language), text: self.$passwordCtrl)
                        }
                        
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            Image(systemName: showPassword ? "eye.fill" : "eye.slash")
                                .foregroundColor(Color(hex: "#3756DF"))
                        })
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    
                    Button(
                        action: {
                            //                            self.showingModalForgotPassword = true
                            self.routeNewPassword = true
                        },
                        label: {
                            Text("Forgot Password?".localized(language))
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    )
                }
                .padding()
                
                HStack {
                    
                    Button(
                        action: {
//                            self.isActiveRoute = true
                            login()
                            UIApplication.shared.endEditing()
                        },
                        label: {
                            Text("LOGIN APPS".localized(language))
                                .foregroundColor(disableForm ? Color.white : Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        })
                        .disabled(disableForm)
                        .background(disableForm ? Color(.lightGray) : Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 25)
                    
                    NavigationLink(
                        destination: BottomNavigationView(),
                        isActive: self.$isActiveRoute,
                        label: {}
                    )
                    .isDetailLink(false)
                    
                    NavigationLink(
                        destination: FormInputAtmChangeDeviceView(pwd: self.$passwordCtrl, phoneNmbr: self.$phoneNumber).environmentObject(registerData),
                        isActive: self.$routeAtmInputLogin,
                        label: {}
                    )
                    .isDetailLink(false)
                    
                    NavigationLink(
                        destination: FormForceChangePasswordView(),
                        isActive: self.$routeNewPassword,
                        label: {}
                    )
                    .isDetailLink(false)
                    
                    if !isNewDeviceLogin {
                        if let value = device.last?.fingerprintFlag {
                            if biometricCheck() && value {
                                
                                Button(action: {
                                    authenticate()
                                }, label: {
                                    Image(UIDevice.current.hasNotch ? "ic_faceid" : "ic_fingerprint")
                                        .padding(.trailing, 20)
                                })
                            }
                        }
                    }
                    
                }
                .padding(.vertical)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account yet?".localized(language))
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                    
                    Button(action: {
                        self.appState.moveToWelcomeView = true
                    }) {
                        Text("Register Here".localized(language))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                    }
                }
                .padding(.bottom, 30)
                .padding(.horizontal, 20)
                
            }
            
            if self.showingModal || self.showingModalForgotPassword || self.showingModalError {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            self.getUserStatus(deviceId: deviceId!)
            self.phoneNumber = self.registerData.noTelepon
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessage()
        }
        .popup(isPresented: $showingModalError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageError()
        }
        .popup(isPresented: $showingModalBiometricLogin, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupBiometricLogin()
        }
    }
    
    func saveDataNewDeviceToCoreData()  {
        print("------SAVE TO CORE DATA-------")
        
        let data = NewDevice(context: managedObjectContext)
        data.noTelepon = self.phoneNumber
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
    }
    
    // MARK: - LOGIN AUTH
    func login() {
        self.isLoading = true
        
        if self.isNewDeviceLogin {
            print("LOGIN NEW DEVICE")
            authVM.postLoginNewDevice(password: self.passwordCtrl, phoneNumber: self.phoneNumber) { success in
                saveDataNewDeviceToCoreData()
                if success {
                    self.isLoading = false
                    
                    print("LOGIN SUCCESS")
//                    self.isActiveRoute = true
                    self.routeAtmInputLogin = true
                }
                
                if !success {
                    self.isLoading = false
                    
                    if (self.authVM.errorCode == "206") {
                        self.routeNewPassword = true
                    } else if (self.authVM.errorCode == "401") {
                        self.showingModal = true
                    } else if (self.authVM.errorCode == "302") {
                        print("ERROR")
                        self.showingModalError = true
                    } else {
                        print("LOGIN FAILED")
                        self.showingModal = true
                    }
                }
            }
            
        } else {
            print("LOGIN CURRENT DEVICE")
            authVM.postLogin(password: self.passwordCtrl, phoneNumber: "", fingerCode: "") { success in
                
                if success {
                    self.isLoading = false
                    
                    print("LOGIN SUCCESS")
                    self.isActiveRoute = true
                }
                
                if !success {
                    self.isLoading = false
                    
                    if (self.authVM.errorCode == "206") {
                        self.routeNewPassword = true
                    } else if (self.authVM.errorCode == "401") {
//                        self.appState.moveToWelcomeView = true
                        self.showingModal = true
                    } else {
                        print("LOGIN FAILED")
                        self.showingModal = true
                    }
                }
            }
        }
    }
    
    // MARK: -Function Authentication
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "We need to unlock your data.".localized(language)
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                        self.isActiveRoute = true
                        print("YES U CAN UNLOCK")
                    } else {
                        print("NO U CAN'T UNLOCK")
                        
                    }
                }
            }
        }
    }
    
    // MARK: -Function Authentication
    func biometricCheck() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    // MARK: POPUP MESSAGE
    func popupMessage() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Wrong password".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("Please enter your password correctly or login in another way.".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {}) {
                Text("Back".localized(language))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
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
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Autentikasi gagal, silakan coba kembali".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {}) {
                Text("Back".localized(language))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
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
    
    // MARK: POPUP MESSAGE BIOMETRIC LOGIN
    func popupBiometricLogin() -> some View {
        VStack(alignment: .center) {
            Image(UIDevice.current.hasNotch ? "ic_faceid" : "ic_fingerprint")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Login dengan Biometric".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("It's easy to log in only with Biometrics.".localized(language))
                .font(.custom("Montserrat-Regular", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
                .multilineTextAlignment(.center)
            
            HStack {
                
                Button(action: {}) {
                    Text("Back".localized(language))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .cornerRadius(12)
                
                Button(action: {
                    
                    self.authVM.enableBiometricLogin { result in
                        print("result : \(result)")
                        if result {
                            device.last?.fingerprintFlag = true
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print("Error saving managed object context: \(error)")
                            }
                            
                            print("ENABLE FINGER PRINT SUCCESS")
                        }
                        
                        if !result {
                            print("ENABLE FINGER PRINT FAILED")
                        }
                    }
                    
                    
                }) {
                    Text("Activate".localized(language))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    /* Function GET USER Status */
    @ObservedObject var userVM = UserRegistrationViewModel()
    func getUserStatus(deviceId: String) {
        print("GET USER STATUS")
        print("DEVICE ID : \(deviceId)")
        
        self.userVM.userCheck(deviceId: deviceId) { success in
            
            if success {
                print("CODE STATUS : \(self.userVM.code)")
                print("MESSAGE STATUS : \(self.userVM.message)")
                
                self.fingerprintFlag = self.userVM.fingerprintFlag
            }
            
            if !success {
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(isNewDeviceLogin: .constant(true))
    }
}

enum BiometricType{
    case touch
    case face
    case none
}
