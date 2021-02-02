//
//  FormInputNewPasswordForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormInputNewPasswordForgotPasswordView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    @State var showingModalError: Bool = false
    @State var showingModalSuccess: Bool = false
    
    @State var isNextRoute: Bool = false
    @State var routeATMNumberPin: Bool = false
    @State var routeAccountNumberPin: Bool = false
    
    var disableForm: Bool {
        passwordCtrl.isEmpty || confirmPasswordCtrl.isEmpty || passwordCtrl.count < 6 || confirmPasswordCtrl.count < 6
    }
    
    var body: some View {
        ZStack {
            
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                Text("PASSWORD BARU")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Pasword aplikasi harus berjumlah minimal 8 karakter huruf. Terdiri dari Uppercase, Number, etc.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                VStack {
                    VStack {
                        HStack {
                            if (showPassword) {
                                TextField("Password baru Anda", text: self.$passwordCtrl)
                            } else {
                                SecureField("Password baru Anda", text: self.$passwordCtrl)
                            }
                            
                            Button(action: {
                                self.showPassword.toggle()
                            }, label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye.fill")
                                    .font(.custom("Montserrat-Light", size: 14))
                                    .frame(width: 80, height: 50)
                                    .cornerRadius(10)
                                    .foregroundColor(Color(hex: "#3756DF"))
                            })
                        }
                        .frame(height: 25)
                        .padding(.vertical, 10)
                        
                        Divider()
                        
                        HStack {
                            if (showConfirmPassword) {
                                TextField("Confirm password", text: self.$confirmPasswordCtrl)
                            } else {
                                SecureField("Confirm password", text: self.$confirmPasswordCtrl)
                            }
                            
                            Button(action: {
                                self.showConfirmPassword.toggle()
                            }, label: {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye.fill")
                                    .font(.custom("Montserrat-Light", size: 14))
                                    .frame(width: 80, height: 50)
                                    .cornerRadius(10)
                                    .foregroundColor(Color(hex: "#3756DF"))
                            })
                        }
                        .frame(height: 25)
                        .padding(.vertical, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding()
                
                Spacer()
                
                VStack {
                    
                    Button(
                        action: {
                            if (passwordCtrl != confirmPasswordCtrl) {
                                self.showingModalError = true
                            } else {
                                self.registerData.password = passwordCtrl
                                self.showingModalSuccess = true
                            }
                        },
                        label: {
                            Text("Simpan Password Baru")
                                .foregroundColor(disableForm ? Color.white : Color(hex: "#2334D0"))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    )
                    .background(disableForm ? Color.gray : Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    .disabled(disableForm)
                }
                .padding(.bottom, 20)
                
            }
            
            if self.showingModalSuccess {
                ModalOverlay(tapAction: { withAnimation { self.showingModalSuccess = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModalError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalPasswordNotMatched()
        }
        .popup(isPresented: $showingModalSuccess, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageForgotPassword()
        }
    }
    
    // MARK: -Bottom modal for error
    func modalPasswordNotMatched() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password tidak sama, silahkan ketik ulang")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showingModalError = false
            }) {
                Text("Kembali")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
    
    // MARK: -Bottom modal for success
    func modalPasswordSuccess() -> some View {
        VStack(alignment: .leading) {
            
            Text("Password anda berhasil di ganti.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isNextRoute = true
            }) {
                Text("Kembali ke halaman login")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
    
    // MARK: - POPUP SELECTOR REGISTER NASABAH
    func popupMessageForgotPassword() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Do you still remember your transaction PIN?")
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            NavigationLink(
                destination: FormInputAtmPinForgotPasswordView().environmentObject(registerData),
                isActive: self.$routeAccountNumberPin) {
                EmptyView()
            }
            
            Button(action: {
                self.routeAccountNumberPin = true
            }) {
                Text("Yes, i'am Still Remember")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(
                destination: FormInputAtmForgotPasswordScreen().environmentObject(registerData),
                isActive: self.$routeATMNumberPin) {
                EmptyView()
            }
            
            Button(action: {
                self.routeATMNumberPin = true
            }) {
                Text("No, I do not remember")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 30)
            .cornerRadius(12)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct FormInputNewPasswordForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputNewPasswordForgotPasswordView()
    }
}
