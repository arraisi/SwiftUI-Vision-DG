//
//  FormInputAtmActivationScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/11/20.
//

import SwiftUI
import Indicators
import Combine

struct FormInputAtmPinForgotPasswordView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var atmNumberCtrl = ""
    @State private var pinAtmCtrl = ""
    @State private var showPassword: Bool = false
    
    @State var errorMessage: String = ""
    @State var showingModalError: Bool = false
    @State var showingModalSuccess: Bool = false
    
    @Binding var isNewDeviceLogin: Bool
    
    @State var isLoading: Bool = false
    
    @GestureState private var dragOffset = CGSize.zero
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    /* Route */
    @State var isNextRoute: Bool = false
    
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
                
                Text("ENTER ID CARD DATA".localized(language))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Enter your registered account number / ID CARD and Transaction PIN".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        TextField("Enter your account number / ID CARD".localized(language), text: self.$atmNumberCtrl)
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
                        
                        SecureField("Enter your Transaction PIN".localized(language), text: self.$pinAtmCtrl)
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
                    .frame(height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    Button(action: {
                        setPassword()
                    }, label: {
                        Text("DATA CONFIRMATION".localized(language))
                            .foregroundColor(disableForm ? Color.black : Color(hex: "#232175"))
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        
                    })
                    .background(disableForm ? Color.gray : Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    .disabled(disableForm)
                    
                    NavigationLink(
                        destination: LoginScreen(isNewDeviceLogin: self.$isNewDeviceLogin).environmentObject(registerData),
                        isActive: self.$isNextRoute) {}
                        .isDetailLink(false)
                }
                .padding(.bottom, 20)
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
            
            Text("\(self.errorMessage)")
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
            
            Text("Password changed successfully.".localized(language))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isNextRoute = true
            }) {
                Text("Back to the login page".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold".localized(language), size: 14))
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
    
    @ObservedObject private var authVM = AuthViewModel()
    func setPassword() {
        self.isLoading = true
        if (atmNumberCtrl.count < 16) {
            print("WITH ACCOUNT NUMBER")
            self.authVM.setPwd(
                pwd: registerData.password,
                accountNumber: atmNumberCtrl,
                nik: "",
                pinTrx: pinAtmCtrl) { success in
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
        } else {
            print("WITH NIK")
            self.authVM.setPwd(
                pwd: registerData.password,
                accountNumber: "",
                nik: atmNumberCtrl,
                pinTrx: pinAtmCtrl) { success in
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
}

struct FormInputAtmActivationScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputAtmPinForgotPasswordView(isNewDeviceLogin: .constant(false))
    }
}
