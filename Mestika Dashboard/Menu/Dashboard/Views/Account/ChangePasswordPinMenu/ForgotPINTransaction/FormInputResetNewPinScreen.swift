//
//  FormInputResetNewPinScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputResetNewPinScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var cardNo = ""
    
    @State private var pinCtrl = ""
    @State private var pinConfirmCtrl = ""
    
    //    @State private var showPin: Bool = false
    //    @State private var showPinConfirm: Bool = false
    @State private var showModal: Bool = false
    @State private var isPinChanged: Bool = false
    @State private var showModalError: Bool = false
    @State private var nextViewActive: Bool = false
    @State private var showPinWeakModal: Bool = false
    
    @State private var phoneNumber: String = ""
    
    private var simpanBtnDisabled: Bool {
        pinCtrl.count == 0 || pinConfirmCtrl.count == 0
    }
    
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            
            VStack {
                
                AppBarLogo(light: true, showBackgroundBlueOnStatusBar: true) {}
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        
                        Text("FORGOT TRANSACTION PIN".localized(language))
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        Text("Please enter your new Transaction PIN".localized(language))
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundColor(Color(hex: "#002251"))
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading) {
                            
                            Text("New Transaction PIN".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .padding(.top, 10)
                            
                            VStack {
                                HStack {
                                    //                                    if (showPin) {
                                    //                                        TextField("Input PIN baru Anda", text: self.$pinCtrl)
                                    //                                    } else {
                                    SecureField("Enter your new Transaction PIN".localized(language), text: self.$pinCtrl)
                                        .keyboardType(.numberPad)
                                        .onReceive(pinCtrl.publisher.collect()) {
                                            self.pinCtrl = String($0.prefix(6))
                                        }
                                    //                                    }
                                    
                                    //                                    Button(action: {
                                    //                                        self.showPin.toggle()
                                    //                                    }, label: {
                                    //                                        Image(systemName: showPin ? "eye.fill" : "eye.slash")
                                    //                                            .foregroundColor(Color(hex: "#3756DF"))
                                    //                                    })
                                }
                                .frame(height: 25)
                                .padding(.vertical, 10)
                                
                                Divider()
                                
                                HStack {
                                    //                                    if (showPinConfirm) {
                                    //                                        TextField("Input Ulang PIN baru Anda", text: self.$pinConfirmCtrl)
                                    //                                            .keyboardType(.numberPad)
                                    //                                    } else {
                                    SecureField("Enter your new Transaction PIN".localized(language), text: self.$pinConfirmCtrl)
                                        .keyboardType(.numberPad)
                                        .onReceive(pinConfirmCtrl.publisher.collect()) {
                                            self.pinConfirmCtrl = String($0.prefix(6))
                                        }
                                    //                                    }
                                    
                                    //                                    Button(action: {
                                    //                                        self.showPinConfirm.toggle()
                                    //                                    }, label: {
                                    //                                        Image(systemName: showPinConfirm ? "eye.fill" : "eye.slash")
                                    //                                            .foregroundColor(Color(hex: "#3756DF"))
                                    //                                    })
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
                        
                        NavigationLink(destination: FormInputResetPinScreen(cardNo: self.cardNo, newPin: self.pinCtrl, phoneNumber: phoneNumber), isActive: $nextViewActive) {EmptyView()}
                            .isDetailLink(false)
                        
                        Button(action: {
                            UIApplication.shared.endEditing()
                            if pinCtrl != pinConfirmCtrl {
                                self.showModalError = true
                            } else {
                                if isPinValid(with: pinCtrl) && isPinValid(with: pinConfirmCtrl) {
                                    self.nextViewActive = true
                                } else {
                                    self.showPinWeakModal = true
                                }
                            }
                        }){
                            Text("Save New Transaction PIN".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            
                        }
                        .disabled(simpanBtnDisabled)
                        .background(simpanBtnDisabled ? Color(.lightGray) : Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                    .padding()
                }
            }
            
            if self.showModal || self.showModalError || showPinWeakModal {
                ModalOverlay(tapAction: { withAnimation { self.showModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear() {
            getProfile()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
        .popup(isPresented: $showModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            ZStack {
                if isPinChanged {
                    SuccessChangePinModal()
                } else {
                    FailedChangePinModal()
                }
            }
        }
        .popup(isPresented: $showModalError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            modalPinNotMatched()
        }
        .popup(isPresented: $showPinWeakModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            PinWeakModal()
        }
    }
    
    @StateObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                self.phoneNumber = self.profileVM.telepon
            }
        }
    }
    
    private func isPinValid(with pin: String) -> Bool {
        let pattern = #"^(?!(.)\1{3})(?!19|20)(?!012345|123456|234567|345678|456789|567890|098765|987654|876543|765432|654321|543210)\d{6}$"#
        
        let pinPredicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return pinPredicate.evaluate(with: pin)
    }
    
    // MARK: Bottom modal for error
    func modalPinNotMatched() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("PIN is not the same, please retype it".localized(language))
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
            
            Text("")
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: POPUP PIN WEAK
    func PinWeakModal() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("PIN consists of 6 characters, cannot be sequential from the same 6 digits".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                self.showPinWeakModal = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
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
    
    // MARK: POPUP SUCCSESS CHANGE PIN
    func SuccessChangePinModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_check")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("NEW APPLICATION PIN HAS BEEN SUCCESSFULLY SAVED".localized(language))
                .font(.custom("Montserrat-ExtraBold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
                .multilineTextAlignment(.leading)
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
    
    // MARK: POPUP FAILED CHANGE PIN
    func FailedChangePinModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_attention")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Password Aplikasi Tidak Berubah")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
            
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

struct FormInputResetNewPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputResetNewPinScreen()
    }
}
