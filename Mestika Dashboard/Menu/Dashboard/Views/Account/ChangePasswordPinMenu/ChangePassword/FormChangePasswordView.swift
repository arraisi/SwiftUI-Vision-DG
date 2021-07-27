//
//  FormChangePasswordView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI
import Indicators
import Combine

struct FormChangePasswordView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var authVM = AuthViewModel()
    
    @State private var oldPasswordCtrl = ""
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showOldPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showModal: Bool = false
    @State private var isPasswordChanged: Bool = false
    @State var isLoading = false
    @State private var showModalError = false
    
    private var simpanBtnDisabled: Bool {
        oldPasswordCtrl.count == 0 || passwordCtrl.count == 0 || confirmPasswordCtrl.count == 0
    }
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        
        ZStack {
            
            VStack {
                AppBarLogo(light: true, showBackgroundBlueOnStatusBar: true) {}
                
                if (self.authVM.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        Text("Change Application Password".localized(language))
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        VStack(alignment: .leading) {
                            Text("Please enter your old and new passwords".localized(language))
                                .font(.custom("Montserrat-Regular", size: 14))
                                .foregroundColor(Color(hex: "#002251"))
                                .padding(.top, 5)
                            
                            Text("Old password".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .padding(.top, 5)
                            
                            HStack {
                                if (showOldPassword) {
                                    TextField("Enter your old password".localized(language), text: self.$oldPasswordCtrl)
                                        .font(.custom("Montserrat-Regular", size: 12))
//                                        .onReceive(Just(oldPasswordCtrl)) { newValue in
//                                            let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
//                                            if filtered != newValue {
//                                                self.oldPasswordCtrl = filtered
//                                            }
//                                        }
                                    
                                } else {
                                    SecureField("Enter your old password".localized(language), text: self.$oldPasswordCtrl)
                                        .font(.custom("Montserrat-Regular", size: 12))
//                                        .onReceive(Just(oldPasswordCtrl)) { newValue in
//                                            let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
//                                            if filtered != newValue {
//                                                self.oldPasswordCtrl = filtered
//                                            }
//                                        }
                                }
                                
                                Button(action: {
                                    self.showOldPassword.toggle()
                                }, label: {
                                    Image(systemName: showOldPassword ? "eye.fill" : "eye.slash")
                                        .foregroundColor(Color(hex: "#3756DF"))
                                })
                            }
                            .frame(height: 25)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10)
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            
                            Text("New Password".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                            
                            VStack {
                                HStack {
                                    if (showPassword) {
                                        TextField("Enter your new password".localized(language), text: self.$passwordCtrl)
                                            .font(.custom("Montserrat-Regular", size: 12))
//                                            .onReceive(Just(passwordCtrl)) { newValue in
//                                                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
//                                                if filtered != newValue {
//                                                    self.passwordCtrl = filtered
//                                                }
//                                            }
                                    } else {
                                        SecureField("Enter your new password".localized(language), text: self.$passwordCtrl)
                                            .font(.custom("Montserrat-Regular", size: 12))
//                                            .onReceive(Just(passwordCtrl)) { newValue in
//                                                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
//                                                if filtered != newValue {
//                                                    self.passwordCtrl = filtered
//                                                }
//                                            }
                                    }
                                    
                                    Button(action: {
                                        self.showPassword.toggle()
                                    }, label: {
                                        Image(systemName: showPassword ? "eye.fill" : "eye.slash")
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    })
                                }
                                .frame(height: 25)
                                .padding(.vertical, 10)
                                
                                Divider()
                                
                                HStack {
                                    if (showConfirmPassword) {
                                        TextField("Re-enter your new password".localized(language), text: self.$confirmPasswordCtrl)
                                            .font(.custom("Montserrat-Regular", size: 12))
//                                            .onReceive(Just(confirmPasswordCtrl)) { newValue in
//                                                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
//                                                if filtered != newValue {
//                                                    self.confirmPasswordCtrl = filtered
//                                                }
//                                            }
                                    } else {
                                        SecureField("Re-enter your new password".localized(language), text: self.$confirmPasswordCtrl)
                                            .font(.custom("Montserrat-Regular", size: 12))
//                                            .onReceive(Just(confirmPasswordCtrl)) { newValue in
//                                                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -@.".contains($0) }
//                                                if filtered != newValue {
//                                                    self.confirmPasswordCtrl = filtered
//                                                }
//                                            }
                                    }
                                    
                                    Button(action: {
                                        self.showConfirmPassword.toggle()
                                    }, label: {
                                        Image(systemName: showConfirmPassword ? "eye.fill" : "eye.slash")
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
                        
                        Button(action: {
                            UIApplication.shared.endEditing()
                            if passwordCtrl != confirmPasswordCtrl {
                                self.showModalError.toggle()
                            } else {
                                self.authVM.changePasswordApp(currentPwd: self.oldPasswordCtrl, newPwd: self.passwordCtrl) { result in
                                    
                                    if result {
                                        isPasswordChanged = true
                                    }
                                    
                                    self.showModal.toggle()
                                }
                            }
                        }, label: {
                            Text("Save New Password".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            
                        })
                        .disabled(simpanBtnDisabled)
                        .background(simpanBtnDisabled ? Color(.lightGray) : Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                    .padding()
                    
                }
                .KeyboardAwarePadding()
            }
            
            if self.showModal || self.showModalError {
                ModalOverlay(tapAction: { withAnimation { } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
        .popup(isPresented: $showModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            ZStack {
                if isPasswordChanged {
                    SuccessChangePasswordModal()
                } else {
                    FailedChangePasswordModal()
                }
            }
        }
        .popup(isPresented: $showModalError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            modalPasswordNotMatched()
        }
    }
    
    // MARK: Bottom modal for error
    func modalPasswordNotMatched() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password is not the same, please retype".localized(language))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showModalError = false
            }) {
                Text("Back".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: POPUP SUCCSESS CHANGE PASSWORD
    func SuccessChangePasswordModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_check")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("NEW APPLICATION PASSWORD HAS BEEN SUCCESSFULLY SAVED".localized(language))
                .font(.custom("Montserrat-ExtraBold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.showModal = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: POPUP FAILED CHANGE PASSWORD
    func FailedChangePasswordModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_attention")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text(self.authVM.errorMessage)
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.showModal = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct FormChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangePasswordView()
    }
}
