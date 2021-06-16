//
//  TransactionValidationPinAtmView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/06/21.
//

import SwiftUI
import Indicators

struct TransactionValidationPinAtmView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("lock_Password") var key = "123456"
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State var pin = ""
    @State var wrongPin = false
    @State var unlocked = false
    @State var success = false
    
    @State var isShowAlert: Bool = false
    @State var isShowSuccess: Bool = false
    
    var password: String
    @State var cardNo: String = ""
    @State var phoneNumber: String = ""
    
    @State private var isLoading: Bool = false
    
    @State private var otpView: Bool = false
    
    var body: some View {
        if otpView {
            TransactionOtpView(password: password, phoneNumber: self.phoneNumber, pinAtm: self.pin)
        } else {
            ZStack {
                Image("bg_blue")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    if (self.isLoading) {
                        LinearWaitingIndicator()
                            .animated(true)
                            .foregroundColor(.green)
                            .frame(height: 1)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Text("Enter your PIN ATM".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color.white)
                    
                    HStack(spacing: 10){
                        ForEach(0..<6, id: \.self){index in
                            PinView(index: index, password: $pin, emptyColor: .constant(Color(hex: "#2334D0")), fillColor: .constant(Color.white))
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.width < 750 ? 20 : 30)
                    
                    
                    Text(wrongPin ? "Incorrect Pin".localized(language) : "")
                        .foregroundColor(.red)
                        .fontWeight(.heavy)
                        .padding()
                    
                    Spacer(minLength: 0)
                    
                    PinVerification(pin: $pin, onChange: {
                        self.wrongPin = false
                    }, onCommit: {
                        forgotPin()
//                        self.otpView = true
                    })
                }
                
                if self.isShowAlert || self.isShowSuccess {
                    ModalOverlay(tapAction: { withAnimation { } })
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationBarTitle("Pin ATM".localized(language), displayMode: .inline)
            .popup(isPresented: $isShowAlert, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageError()
            }
            .popup(isPresented: $isShowSuccess, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
                popupMessageSuccess()
            }
            .onAppear {
                getProfile()
            }
        }
    }
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Pin Transaksi Salah".localized(language))
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
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageSuccess() -> some View {
        VStack(alignment: .leading) {
            Image("ic_check")
                .resizable()
                .frame(width: 69, height: 69)
                .padding(.top, 20)
            
            Text("Pin Transaksi berhasil disimpan.".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.isShowSuccess = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
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
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
    
    @StateObject private var authVM = AuthViewModel()
    func forgotPin() {
        self.isLoading = true
        self.authVM.forgotPinTransaksi(cardNo: cardNo, pin: pin, newPinTrx: password, phoneNmbr: "", reference: "", codeOtp: "") { success in
            if success {
                self.isLoading = false
                self.isShowSuccess = true
            }
            
            if !success {
                self.isLoading = false
                self.resetField()
                self.isShowAlert = true
                print("Error Pin TRX")
            }
        }
    }
    
    @StateObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                self.cardNo = self.profileVM.cardNo
                self.phoneNumber = self.profileVM.telepon
            }
        }
    }
}

struct TransactionValidationPinAtmView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionValidationPinAtmView(password: "")
    }
}
