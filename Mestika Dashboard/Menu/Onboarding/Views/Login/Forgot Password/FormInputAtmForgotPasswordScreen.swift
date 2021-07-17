//
//  FormInputAtmForgotPasswordScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI
import Indicators
import Combine

struct FormInputAtmForgotPasswordScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var atmNumberCtrl = ""
    @State private var pinAtmCtrl = ""
    @State private var showPassword: Bool = false
    
    @Binding var isNewDeviceLogin: Bool
    
    @State var errorMessage: String = ""
    
    @GestureState private var dragOffset = CGSize.zero
    
    @State var showingModalError: Bool = false
    @State var showingModalSuccess: Bool = false
    
    /* Route */
    @State var isNextRoute: Bool = false
    
    @State var isLoading: Bool = false
    
    var disableForm: Bool {
        if (atmNumberCtrl.isEmpty || pinAtmCtrl.isEmpty) {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                        .padding(.bottom, 10)
                }
                
                Text("INPUT ATM DATA".localized(language))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Enter your registered ATM card number and ATM PIN".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        TextField("Enter your ATM number".localized(language), text: self.$atmNumberCtrl)
                            .keyboardType(.numberPad)
                            .onReceive(Just(atmNumberCtrl)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.atmNumberCtrl = filtered
                                }
                            }
                            .onReceive(atmNumberCtrl.publisher.collect()) {
                                self.atmNumberCtrl = String($0.prefix(16))
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
                        if (showPassword) {
                            TextField("Enter your ATM PIN".localized(language), text: self.$pinAtmCtrl)
                                .keyboardType(.numberPad)
                                .onReceive(Just(pinAtmCtrl)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.pinAtmCtrl = filtered
                                    }
                                }
                                .onReceive(pinAtmCtrl.publisher.collect()) {
                                    self.pinAtmCtrl = String($0.prefix(6))
                                }
                        } else {
                            SecureField("Enter your ATM PIN".localized(language), text: self.$pinAtmCtrl)
                                .keyboardType(.numberPad)
                                .onReceive(Just(pinAtmCtrl)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.pinAtmCtrl = filtered
                                    }
                                }
                                .onReceive(pinAtmCtrl.publisher.collect()) {
                                    self.pinAtmCtrl = String($0.prefix(6))
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
                
                Spacer()
                
                VStack {
                    
                    Button(
                        action: {
                            setPassword()
                        },
                        label: {
                            Text("DATA CONFIRMATION".localized(language))
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
                    
                    NavigationLink(
                        destination: LoginScreen(isNewDeviceLogin: self.$isNewDeviceLogin).environmentObject(registerData),
                        isActive: self.$isNextRoute) {}
                        .isDetailLink(false)
                }
                .padding(.bottom, 50)
            }
            
            if self.showingModalError || self.showingModalSuccess {
                ModalOverlay(tapAction: { withAnimation { } })
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
            modalError()
        }
        .popup(isPresented: $showingModalSuccess, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            modalSuccess()
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
            
            Text(self.errorMessage)
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showingModalError = false
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
    
    // MARK: -Bottom modal for error
    func modalSuccess() -> some View {
        VStack(alignment: .leading) {
            Image("ic_check")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Password berhasil diganti.")
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isNextRoute = true
            }) {
                Text("Ke Halaman Login")
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
    
    @ObservedObject private var authVM = AuthViewModel()
    func setPassword() {
        self.isLoading = true
        self.authVM.forgotPassword(
            newPwd: registerData.password,
            cardNo: atmNumberCtrl,
            pinAtm: pinAtmCtrl) { success in
            if success {
                self.isLoading = false
                print("SUCCESS CHANGE PASSWORD")
                self.showingModalSuccess = true
            }
            
            if !success {
                self.isLoading = false
                print("NOT SUCCESS CHANGE PASSWORD")
                self.errorMessage = self.authVM.errorMessage
                self.showingModalError = true
            }
        }
    }
}

struct FormInputAtmForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputAtmForgotPasswordScreen(isNewDeviceLogin: .constant(false))
    }
}
