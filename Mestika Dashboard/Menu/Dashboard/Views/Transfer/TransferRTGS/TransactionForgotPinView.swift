//
//  TransactionForgotPinView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/06/21.
//

import SwiftUI

struct TransactionForgotPinView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /* Environtment Object */
    @EnvironmentObject var appState: AppState
    
    @State private var passwordCtrl = ""
    @State private var confirmPasswordCtrl = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    @State var showingModalError: Bool = false
    @State var showingModalSuccess: Bool = false
    
    @State var isNextRoute: Bool = false
    
    @State private var pinView: Bool = false
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        if pinView {
            TransactionValidationPinAtmView(password: self.passwordCtrl)
        } else {
            ZStack {
                
                Image("bg_blue")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("FORGOT PIN".localized(language))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Text("Please enter your new PIN".localized(language))
                        .font(.subheadline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    VStack {
                        VStack {
                            HStack {
                                SecureField("Enter your new PIN".localized(language), text: self.$passwordCtrl)
                                    .keyboardType(.numberPad)
                                    .onReceive(passwordCtrl.publisher.collect()) {
                                        self.passwordCtrl = String($0.prefix(6))
                                    }
                            }
                            .frame(height: 25)
                            .padding(.vertical, 10)
                            
                            Divider()
                            
                            HStack {
                                SecureField("Confirm password".localized(language), text: self.$confirmPasswordCtrl)
                                    .keyboardType(.numberPad)
                                    .onReceive(confirmPasswordCtrl.publisher.collect()) {
                                        self.confirmPasswordCtrl = String($0.prefix(6))
                                    }
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
                                    self.pinView = true
                                }
                            },
                            label: {
                                Text("Selanjutnya".localized(language))
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
            .navigationBarTitle("Forgot ATM".localized(language), displayMode: .inline)
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
        }
    }
    
    private var disableForm: Bool {
        passwordCtrl.isEmpty || confirmPasswordCtrl.isEmpty || passwordCtrl.count < 6 || confirmPasswordCtrl.count < 6
    }
    
    // MARK: -Bottom modal for error
    func modalPasswordNotMatched() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password is not the same, please retype it.".localized(language))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showingModalError = false
            }) {
                Text("Back".localized(language))
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
            
            Text("Your password has been successfully changed.".localized(language))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isNextRoute = true
            }) {
                Text("Back to login screen".localized(language))
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
}

struct TransactionForgotPinView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionForgotPinView()
    }
}
