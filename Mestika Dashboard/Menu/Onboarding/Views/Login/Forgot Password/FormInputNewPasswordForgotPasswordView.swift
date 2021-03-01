//
//  FormInputNewPasswordForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI

struct FormInputNewPasswordForgotPasswordView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
    
    @State var phoneNumber: String = ""
    
    @Binding var isNewDeviceLogin: Bool
    
    @GestureState private var dragOffset = CGSize.zero
    
    var disableForm: Bool {
        passwordCtrl.isEmpty || confirmPasswordCtrl.isEmpty || passwordCtrl.count < 6 || confirmPasswordCtrl.count < 6
    }
    
    var body: some View {
        ZStack {
            
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                Text(NSLocalizedString("NEW PASSWORD".localized(language), comment: ""))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text(NSLocalizedString("The application password must be at least 8 characters long. Consists of Uppercase, Number, etc.".localized(language), comment: ""))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                VStack {
                    VStack {
                        HStack {
                            if (showPassword) {
                                TextField(NSLocalizedString("Your new password".localized(language), comment: ""), text: self.$passwordCtrl)
                            } else {
                                SecureField(NSLocalizedString("Your new password".localized(language), comment: ""), text: self.$passwordCtrl)
                            }
                            
                            Button(action: {
                                self.showPassword.toggle()
                            }, label: {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash")
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
                                TextField(NSLocalizedString("Confirm password".localized(language), comment: ""), text: self.$confirmPasswordCtrl)
                            } else {
                                SecureField(NSLocalizedString("Confirm password".localized(language), comment: ""), text: self.$confirmPasswordCtrl)
                            }
                            
                            Button(action: {
                                self.showConfirmPassword.toggle()
                            }, label: {
                                Image(systemName: showConfirmPassword ? "eye.fill" : "eye.slash")
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
                            Text(NSLocalizedString("Save New Password".localized(language), comment: ""))
                                .foregroundColor(disableForm ? Color.white : Color(hex: "#2334D0"))
                                .fontWeight(.bold)
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
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
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
            
            Text(NSLocalizedString("Password is not the same, please retype it.".localized(language), comment: ""))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showingModalError = false
            }) {
                Text(NSLocalizedString("Back".localized(language), comment: ""))
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
            
            Text(NSLocalizedString("Your password has been successfully changed.".localized(language), comment: ""))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isNextRoute = true
            }) {
                Text(NSLocalizedString("Back to login screen".localized(language), comment: ""))
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
            
            Text(NSLocalizedString("Do you still remember your transaction PIN?".localized(language), comment: ""))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            NavigationLink(
                destination: FormInputAtmPinForgotPasswordView(isNewDeviceLogin: self.$isNewDeviceLogin).environmentObject(registerData),
                isActive: self.$routeAccountNumberPin) {
                EmptyView()
            }
            .isDetailLink(false)
            
            Button(action: {
                self.routeAccountNumberPin = true
            }) {
                Text(NSLocalizedString("Yes, i'am Still Remember".localized(language), comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .cornerRadius(12)
            
            NavigationLink(
                destination: FormInputAtmForgotPasswordScreen().environmentObject(registerData),
                isActive: self.$routeATMNumberPin) {
                EmptyView()
            }
            .isDetailLink(false)
            
            Button(action: {
                self.routeATMNumberPin = true
            }) {
                Text(NSLocalizedString("No, I do not remember".localized(language), comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .cornerRadius(12)
            .background(Color(hex: "#2334D0"))
            .padding(.bottom, 30)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct FormInputNewPasswordForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputNewPasswordForgotPasswordView(isNewDeviceLogin: .constant(false))
    }
}
