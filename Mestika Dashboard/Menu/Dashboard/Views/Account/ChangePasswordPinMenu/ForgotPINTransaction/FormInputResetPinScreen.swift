//
//  FormInputResetPinScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI
import Indicators

struct FormInputResetPinScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject private var authVM = AuthViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @State private var showSuccess: Bool = false
    @State private var showError: Bool = false
    
    var cardNo = ""
    var newPin = ""
    
    @State var pin = ""
    
    @AppStorage("lock_Password") var key = "123456"
    @State var unLocked : Bool = false
    @State var wrongPin = false
    
    @State var errorMessage: String = ""
    
    var phoneNumber: String
    
    @GestureState private var dragOffset = CGSize.zero
    
    @State var otpView: Bool = false
    
    var body: some View {
        if otpView {
            OtpConfirmationChangeDataView(password: newPin, phoneNumber: phoneNumber, pinAtm: pin)
        } else {
            ZStack {
                Color(hex: "#F6F8FB")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    AppBarLogo(light: true) {}
                    
                    if (self.authVM.isLoading) {
                        LinearWaitingIndicator()
                            .animated(true)
                            .foregroundColor(.green)
                            .frame(height: 1)
                    }
                    
                    VStack {
                        
                        Spacer(minLength: 0)
                        
                        Text("Enter the ATM PIN".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 24))
                            .foregroundColor(Color(hex: "#2334D0"))
                        
                        Text("Please enter your ATM PIN".localized(language))
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#002251"))
                            .padding(.top, 5)
                        
                        HStack(spacing: 10){
                            ForEach(0..<6, id: \.self){index in
                                PinView(index: index, password: $pin, emptyColor: .constant(Color(hex: "#ADAEB0")), fillColor: .constant(Color(hex: "#2334D0")))
                            }
                        }
                        .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                        
                        
                        Text(wrongPin ? "Incorrect Pin".localized(language) : "")
                            .foregroundColor(.red)
                            .fontWeight(.heavy)
                            .padding()
                        
                        Spacer(minLength: 0)
                        
                        //                NavigationLink(
                        //                    destination: OtpResetPinScreen(),
                        //                    isActive: $unLocked,
                        //                    label: {
                        //                        Text("")
                        //                    })
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                            
                            ForEach(1...9,id: \.self) { value in
                                NumPadView(value: "\(value)", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                            }
                            
                            NumPadView(value: "delete.fill", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                                .disabled(true)
                                .hidden()
                            
                            NumPadView(value: "0", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                            
                            NumPadView(value: "delete.fill", password: $pin, key: $key, unlocked: $unLocked, wrongPass: $wrongPin, keyDeleteColor: .constant(Color(hex: "#2334D0")))
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                        
                        //                    NavigationLink(destination: BottomNavigationView(), isActive: $shouldPopToRootView) {EmptyView()}
                    }
                    .padding(.vertical)
                    
                }
                
                if self.showSuccess || self.showError {
                    ModalOverlay(tapAction: { withAnimation { } })
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PinForgotPinTrx"))) { obj in
                print("SUCCESS PIN")
//                self.otpView = true
                self.authVM.forgotPinTransaksi(cardNo: cardNo, pin: pin, newPinTrx: newPin, phoneNmbr: "", reference: "", codeOtp: "") { success in
                    if success {
                        self.showSuccess = true
                    }
                    
                    if !success {
                        self.errorMessage = self.authVM.errorMessage
                        self.showError = true
                        resetField()
                        print("Error Pin TRX")
                    }
                }

            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                if(value.startLocation.x < 20 &&
                    value.translation.width > 100) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }))
            .popup(isPresented: $showSuccess, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
                SuccessChangePasswordModal()
            }
            .popup(isPresented: $showError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
                popupMessageError()
            }
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("\(self.errorMessage)")
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
    
    // MARK: POPUP SUCCSESS CHANGE PASSWORD
    func SuccessChangePasswordModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_check")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("NEW TRANSACTION PIN HAS BEEN SAVED".localized(language))
                .font(.custom("Montserrat-ExtraBold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.showSuccess = false
                
                DispatchQueue.main.async {
                    self.appState.moveToAccountTab = true
                }
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

struct FormInputResetPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputResetPinScreen(pin: "", key: "", unLocked: false, wrongPin: false, phoneNumber: "")
    }
}
