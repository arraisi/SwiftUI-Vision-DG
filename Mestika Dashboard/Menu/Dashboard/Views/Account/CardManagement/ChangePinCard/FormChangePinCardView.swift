//
//  FormChangePinCardView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/03/21.
//

import SwiftUI
import Indicators
import Combine

struct FormChangePinCardView: View {
    
    @Binding var cardNo: String
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var kartuKuVM = KartuKuViewModel()
    
    @State private var oldPinCtrl = ""
    
    @State private var pinCtrl = ""
    @State private var pinConfirmCtrl = ""
    
    @State private var showPin: Bool = false
    @State private var showOldPin: Bool = false
    @State private var showPinConfirm: Bool = false
    @State private var showModal: Bool = false
    @State private var isPinChanged: Bool = false
    @State private var showModalError: Bool = false
    @State private var showModalSamePin: Bool = false
    @State private var showPinWeakModal: Bool = false
    
    @State private var isLoading: Bool = false
    
    private var verificationBtnDisabled: Bool {
        pinCtrl.count == 0 || pinConfirmCtrl.count == 0 || oldPinCtrl.count == 0 ||
            pinCtrl.count != 6 || pinConfirmCtrl.count != 6 || oldPinCtrl.count != 6 || self.isLoading == true
    }
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        
                        Text("Change PIN")
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#232175"))
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                        
                        VStack(alignment: .leading) {
                            
                            Text("Insert your old pin and new pin")
                                .font(.custom("Montserrat-Regular", size: 14))
                                .foregroundColor(Color(hex: "#002251"))
                                .padding(.top, 5)
                            
                            Text("Old PIN".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .padding(.top, 5)
                            
                            HStack {
                                
                                SecureField("Enter your old PIN".localized(language), text: self.$oldPinCtrl)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(oldPinCtrl)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.oldPinCtrl = filtered
                                        }
                                    }
                                    .onReceive(oldPinCtrl.publisher.collect()) {
                                        self.oldPinCtrl = String($0.prefix(6))
                                    }
                            }
                            .frame(height: 25)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10)
                            
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            
                            Text("New PIN".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                            
                            VStack {
                                HStack {
                                    
                                    SecureField("Enter your new PIN".localized(language), text: self.$pinCtrl)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(pinCtrl)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.pinCtrl = filtered
                                            }
                                        }
                                        .onReceive(pinCtrl.publisher.collect()) {
                                            self.pinCtrl = String($0.prefix(6))
                                        }
                                }
                                .frame(height: 25)
                                .padding(.vertical, 10)
                                
                                Divider()
                                
                                HStack {
                                    
                                    SecureField("Re-enter your new PIN".localized(language), text: self.$pinConfirmCtrl)
                                        .keyboardType(.numberPad)
                                        .onReceive(pinConfirmCtrl.publisher.collect()) {
                                            self.pinConfirmCtrl = String($0.prefix(6))
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
                        
                        Button(action: {
                            UIApplication.shared.endEditing()
                            if pinCtrl != pinConfirmCtrl {
                                self.showModalError.toggle()
                            } else if (oldPinCtrl == pinCtrl) {
                                self.showModalSamePin.toggle()
                            } else {
                                if isPinValid(with: pinCtrl) {
                                    self.isLoading = true
                                    self.kartuKuVM.changePinKartuKu(cardNo: cardNo, pin: oldPinCtrl, newPin: pinCtrl) { success in
                                        
                                        if success {
                                            self.isLoading = false
                                            self.isPinChanged = true
                                            self.showModal.toggle()
                                        }
                                        
                                        if !success {
                                            self.isLoading = false
                                            self.isPinChanged = false
                                            self.showModal.toggle()
                                        }
                                    }
                                } else {
                                    self.showPinWeakModal.toggle()
                                }
                            }
                        }, label: {
                            Text("Save New PIN".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            
                        })
                        .disabled(verificationBtnDisabled)
                        .background(verificationBtnDisabled ? Color(.lightGray) : Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                        
                    }
                    .padding(.top, 70)
                    .padding()
                    
                }
                .KeyboardAwarePadding()
                
            }
            
            if self.showModal || self.showModalError || self.showPinWeakModal || self.showModalSamePin {
                ModalOverlay(tapAction: { withAnimation { } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Change PIN ATM", displayMode: .inline)
        .navigationBarHidden(isLoading)
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
        .popup(isPresented: $showModalSamePin, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            modalPinSameWithOld()
        }
        .popup(isPresented: $showPinWeakModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            PinWeakModal()
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
    
    func modalPinSameWithOld() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("New Pin not change, please retype it".localized(language))
                .fontWeight(.bold)
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showModalSamePin = false
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
                .fixedSize(horizontal: false, vertical: true)
            
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
}

struct FormChangePinCardView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangePinCardView(cardNo: .constant(""))
    }
}
