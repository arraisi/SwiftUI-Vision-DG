//
//  FormRegisterPasswordNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct PasswordRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var password: String = ""
    @State var confirmationPassword: String = ""
    
    @State private var securedPassword: Bool = true
    @State private var securedConfirmation: Bool = true
    
    @State private var showingModal: Bool = false
    @State private var activeRoute: Bool = false
    
    var disableForm: Bool {
        password.isEmpty || confirmationPassword.isEmpty || password.count < 6 || confirmationPassword.count < 6
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 350)
                Color(hex: "#F6F8FB")
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                ScrollView {
                    
                    ZStack {
                        
                        VStack {
                            Color(hex: "#232175")
                                .frame(height: 380)
                            Color(hex: "#F6F8FB")
                                .cornerRadius(radius: 25.0, corners: .topLeft)
                                .cornerRadius(radius: 25.0, corners: .topRight)
                                .padding(.top, -30)
                        }
                        
                        VStack {
                            // Title
                            Text("DATA PEMBUKAAN REKENING")
                                .font(.custom("Montserrat-ExtraBold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 25)
                                .padding(.horizontal, 40)
                            
                            // Content
                            ZStack {
                                
                                // Forms
                                ZStack {
                                    
                                    VStack{
                                        LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                                    }
                                    .cornerRadius(25.0)
                                    .padding(.horizontal, 70)
                                    
                                    VStack{
                                        LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                                    }
                                    .cornerRadius(25.0)
                                    .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 5, y: -2)
                                    .padding(.horizontal, 50)
                                    .padding(.top, 10)
                                    
                                }
                                
                                VStack {
                                    // Sub title
                                    Text("Masukan Password Aplikasi Digital Banking")
                                        .font(.custom("Montserrat-SemiBold", size: 18))
                                        .foregroundColor(Color(hex: "#232175"))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("Password ini digunakan saat anda masuk kedalam Aplikasi Mobile Banking Mestika Bank")
                                        .font(.custom("Montserrat-Regular", size: 8))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 3)
                                        .padding(.bottom, 20)
                                    
                                    // Forms input
                                    ZStack {
                                        VStack(alignment: .leading) {
                                            if (securedPassword) {
                                                ZStack {
                                                    HStack (spacing: 0) {
                                                        SecureField("Masukan Password", text: $password)
                                                            .font(.custom("Montserrat-SemiBold", size: 14))
                                                            .padding()
                                                            .frame(width: 200, height: 50)
                                                            .foregroundColor(Color(hex: "#232175"))
                                                        
                                                        Button(action: {
                                                            self.securedPassword.toggle()
                                                        }) {
                                                            Image(systemName: "eye.slash")
                                                                .font(.custom("Montserrat-Light", size: 14))
                                                                .frame(width: 80, height: 50)
                                                                .cornerRadius(10)
                                                                .foregroundColor(Color(hex: "#3756DF"))
                                                        }
                                                    }.padding(.leading, 15)
                                                }
                                            } else {
                                                ZStack {
                                                    HStack (spacing: 0) {
                                                        TextField("Masukan Password", text: $password, onEditingChanged: { changed in
                                                            print("\($password)")
                                                            
                                                            self.registerData.password = password
                                                        })
                                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                                        .padding()
                                                        .frame(width: 200, height: 50)
                                                        .foregroundColor(Color(hex: "#232175"))
                                                        
                                                        Button(action: {
                                                            self.securedPassword.toggle()
                                                        }) {
                                                            Image(systemName: "eye.fill")
                                                                .font(.custom("Montserrat-Light", size: 14))
                                                                .frame(width: 80, height: 50)
                                                                .cornerRadius(10)
                                                                .foregroundColor(Color(hex: "#3756DF"))
                                                        }
                                                    }
                                                }.padding(.leading, 15)
                                            }
                                            
                                            Divider()
                                                .padding(.horizontal, 15)
                                            
                                            if (securedConfirmation) {
                                                ZStack {
                                                    HStack (spacing: 0) {
                                                        SecureField("Konfirmasi Password", text: $confirmationPassword)
                                                            .font(.custom("Montserrat-SemiBold", size: 14))
                                                            .padding()
                                                            .frame(width: 200, height: 50)
                                                            .foregroundColor(Color(hex: "#232175"))
                                                        
                                                        Button(action: {
                                                            self.securedConfirmation.toggle()
                                                        }) {
                                                            Image(systemName: "eye.slash")
                                                                .font(.custom("Montserrat-Light", size: 14))
                                                                .frame(width: 80, height: 50)
                                                                .cornerRadius(10)
                                                                .foregroundColor(Color(hex: "#3756DF"))
                                                        }
                                                    }
                                                }.padding(.leading, 15)
                                            } else {
                                                ZStack {
                                                    HStack (spacing: 0) {
                                                        TextField("Konfirmasi Password", text: $confirmationPassword)
                                                            .font(.custom("Montserrat-SemiBold", size: 14))
                                                            .padding()
                                                            .frame(width: 200, height: 50)
                                                            .foregroundColor(Color(hex: "#232175"))
                                                        
                                                        Button(action: {
                                                            self.securedConfirmation.toggle()
                                                        }) {
                                                            Image(systemName: "eye.fill")
                                                                .font(.custom("Montserrat-Light", size: 14))
                                                                .frame(width: 80, height: 50)
                                                                .cornerRadius(10)
                                                                .foregroundColor(Color(hex: "#3756DF"))
                                                        }
                                                    }
                                                }.padding(.leading, 15)
                                            }
                                        }
                                        .padding(.vertical, 10)
                                        
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 100)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                    
                                    NavigationLink(
                                        destination: PinRegisterNasabahView().environmentObject(registerData),
                                        isActive: $activeRoute,
                                        label: {EmptyView()}
                                    )
                                    
                                    Button(
                                        action: {
                                            if (password != confirmationPassword) {
                                                self.showingModal.toggle()
                                            } else {
                                                self.activeRoute = true
                                            }
                                        },
                                        label:{
                                            Text("Berikutnya")
                                                .foregroundColor(.white)
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .frame(maxWidth: .infinity, maxHeight: 40)
                                            
                                        })
                                        .frame(height: 50)
                                        .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 25)
                                        .disabled(disableForm)
                                    
                                }
                                .background(LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(25.0)
                                .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 5, y: -2)
                                .padding(.horizontal, 30)
                                .padding(.top, 25)
                                
                            }
                            .padding(.bottom, 25)
                        }
                        
                    }
                }
                .KeyboardAwarePadding()
                
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            bottomMessagePasswordIncorrect()
        }
    }
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func bottomMessagePasswordIncorrect() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password tidak sama, silahkan ketik ulang")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
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
    
    @ObservedObject private var passwordVM = PasswordViewModel()
    func getValidationPassword() {
        self.passwordVM.validationPassword(password: password) { success in
            
            if success {
                print(self.passwordVM.code)
                print(self.passwordVM.message)
            }
            
        }
    }
}

struct FormRegisterPasswordNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
