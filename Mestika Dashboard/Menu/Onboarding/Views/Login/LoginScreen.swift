//
//  LoginScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import LocalAuthentication
import SwiftUI
import NavigationStack

struct LoginScreen: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var isUnlocked = false
    @State private var isActiveRoute = false
    
    @State private var passwordCtrl = ""
    @State private var showPassword: Bool = false
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("LOGIN APPS")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Text("Masukkan Password Akun Anda")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                VStack {
                    HStack {
                        if (showPassword) {
                            TextField("Password account Anda", text: self.$passwordCtrl)
                        } else {
                            SecureField("Password account Anda", text: self.$passwordCtrl)
                        }
                        
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            Text("show")
                                .foregroundColor(Color(hex: "#3756DF"))
                                .fontWeight(.light)
                        })
                    }
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    
                    NavigationLink(destination: PhoneNumberVerificationForgotPasswordView(), label: {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    })
                }
                .padding()
                
                HStack {
                    
                    Button(
                        action: {
                            login()
                        },
                        label: {
                            Text("LOGIN APPS")
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                    
                    NavigationLink(
                        destination: BottomNavigationView(),
                        isActive: self.$isActiveRoute,
                        label: {}
                    )
                  
                    
                    Button(action: {
                        authenticate()
                    }, label: {
                        Image("ic_fingerprint")
                            .padding(.trailing, 20)
                    })
                }
                .padding(.vertical)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account yet?")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                    
                    Button(action: {
                        self.appState.moveToWelcomeView = true
                    }) {
                        Text("Register Here")
                            .font(.subheadline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.bottom)

            }
            .padding(.top, 60)
            .navigationBarHidden(true)
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessage()
        }
    }
    
    func login() {
        if (deviceId == user.last?.deviceId && passwordCtrl == user.last?.password) {
            
            print("DATA READY")
            isActiveRoute = true
            
        } else {
            
            print("NO DATA")
            showingModal.toggle()
            
        }
    }
    
    // MARK: -Function Authentication
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                        self.isActiveRoute = true
                    } else {
                        
                    }
                }
            }
        }
    }
    
    // MARK:- POPUP MESSAGE
    func popupMessage() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password salah")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("Silahkan masukkan password anda dengan benar, atau login dengan cara lain.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {}) {
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

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
