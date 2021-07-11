//
//  OtpConfirmationChangeDataView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 15/06/21.
//

import SwiftUI
import JGProgressHUD_SwiftUI
import Indicators
import SystemConfiguration

struct OtpConfirmationChangeDataView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Environtment Object */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userVM = UserRegistrationViewModel()
    
    /* HUD Variable */
    @State private var dim = true
    
    var password: String
    var phoneNumber: String
    var pinAtm: String
    @State var cardNo: String = ""
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var pinShare: String = ""
    @State var referenceCode: String = ""
    @State var showPin = true
    @State var isDisabled = false
    @State var messageResponse: String = ""
    
    /* Variable Validation */
    @State var isLoading = true
    @State var isOtpValid = false
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    @State var isBtnValidationDisabled = false
    @State var tryCount = 0
    @State var tryCountResend = 1
    @State var tryCountResendDisable = 0
    
    /* Timer */
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State private var isShowModal = false
    @State private var isShowAlert: Bool = false
    @State private var modalSelection = ""
    
    @State var isShowSuccess: Bool = false
    
    /* Disabled Form */
    var disableForm: Bool {
        if (pin.count < 6 || self.isBtnValidationDisabled) {
            return true
        }
        return false
    }
    
    // MARK: -MAIN CONTENT
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                VStack(alignment: .center) {
                    Text("We have sent OTP to no.\n".localized(language) + "+62\(phoneNumber.trimmingCharacters(in: .whitespaces))")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 30)
                    
                    Text("Please enter the OTP code with \nREF #".localized(language)+"\(referenceCode)")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    ZStack {
                        pinDots
                        backgroundField
                    }
                    
                    HStack {
                        Text("Didn't Receive Code?".localized(language))
                            .font(.custom("Montserrat-Regular", size: 11))
                        
                        Button(action: {
                            print("-> Resend OTP")
                            self.tryCountResend += 1
                            getOTP()
                            
                            self.resetField()
                        }) {
                            Text("Resend OTP".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 11))
                                .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                        }
                        .disabled(isResendOtpDisabled)
                        
                        Button(
                            action: {
                                self.isOtpValid = true
//                                self.isCancelViewActive = true
                            },
                            label: {
                                Text("(\(self.timeRemainingRsnd.formatted(allowedUnits: [.minute, .second])!))")
                                    .font(.custom("Montserrat-Regular", size: 11))
                            })
                            .disabled(AppConstants().BYPASS_OTP)
                    }
                    .padding(.top, 5)
                    
                    Text("Make sure you are connected to the Internet and have sufficient credit to receive OTP".localized(language))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack {
                        
                        Button(action: {
                            self.tryCount += 1
                            forgotPin()
                        }) {
                            
                            if (self.isBtnValidationDisabled) {
                                Text("(\(self.timeRemainingBtn.formatted(allowedUnits: [.minute, .second])!))")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            } else {
                                Text("OTP Verification")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            }
                        }
                        .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                        .disabled(disableForm)
                        
                    }
                }
                .padding(.horizontal, 30)
                .frame(width: UIScreen.main.bounds.width - 40)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
                .padding(.vertical, 25)
            }
            
            if (self.isShowModal || self.isShowSuccess) {
                ModalOverlay(tapAction: { withAnimation {
                    self.isShowModal = false
                    self.isShowSuccess = false
                } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            getProfile()
            getOTP()
        }
        .onReceive(timer) { time in
            if self.timeRemainingRsnd > 0 {
                self.timeRemainingRsnd -= 1
            }
            
            if self.timeRemainingRsnd < 1 {
                isResendOtpDisabled = false
            } else {
                isResendOtpDisabled = true
            }
            
            if self.timeRemainingBtn > 0 {
                self.timeRemainingBtn -= 1
            }
            
            if self.timeRemainingBtn < 1 {
                isBtnValidationDisabled = false
            }
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse.localized(language)),
                dismissButton: .default(Text("OK".localized(language)))
            )
        }
        .popup(
            isPresented: $isShowModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTap: true, closeOnTapOutside: true) {
            popupMenu()
        }
        .popup(isPresented: $isShowSuccess, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessageSuccess()
        }
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Text("\(self.getImageName(at: index))")
                    .font(.title)
                    .foregroundColor(Color(hex: "#232175"))
                    .bold()
                    .frame(width: 40, height: 40)
                    .multilineTextAlignment(.center)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
            }
            Spacer()
        }.onTapGesture(perform: {
            isDisabled = false
        })
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
            .disabled(isDisabled)
    }
    
    private func submitPin() {
        if pin.count == maxDigits {
            isDisabled = true
            self.tryCount += 1
            forgotPin()
        }
        
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "•"
        }
        
        if self.showPin {
            return self.pin.digits[index].numberString
        }
        
        return ""
    }
    
    private func replace(myString: String, _ index: [Int], _ newChar: Character) -> String {
        var chars = Array(myString)
        if chars.count >= 9 {
            for data in index {
                chars[data] = newChar
            }
        }
        
        let modifiedString = String(chars)
        return modifiedString
    }
    
    // MARK: Function Selection POPUP
    func popupMenu() -> some View {
        switch modalSelection {
        case "OTPINCORRECT":
            return AnyView(popupOTPInvalid())
        case "OTPINCORRECT5TIME":
            return AnyView(popupOTPIncorrect5Time())
        default:
            return AnyView(popupOTPInvalid())
        }
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
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func popupOTPInvalid() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Incorrect OTP Code".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("The OTP code you entered is incorrect, please try again".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                self.isLoading = false
                self.isShowModal = false
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
    
    // MARK: -BOTTOM MESSAGE OTP INCORRECT 5 TIME
    func popupOTPIncorrect5Time() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Incorrect OTP Code".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("The OTP code you entered was incorrect 5 times, please try again next week.".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                
            }) {
                Text("Back to Main Page".localized(language))
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
    
    @ObservedObject private var otpVM = OtpViewModel()
    func getOTP() {
        
        print("Phone Number")
        print(self.phoneNumber)
        
        self.otpVM.otpRequestUser(
            otpRequest: OtpRequest(
                destination: self.phoneNumber,
                type: "hp",
                trytime: self.tryCountResend
            )
        ) { success in
            
            if success {
                print("isLoading \(self.otpVM.isLoading)")
                print("otpRef \(self.otpVM.reference)")
                print("status \(self.otpVM.statusMessage)")
                
                self.isLoading = self.otpVM.isLoading
                self.referenceCode = self.otpVM.reference
                self.messageResponse = self.otpVM.statusMessage
//                    self.timeRemainingRsnd = self.otpVM.timeCounter
                self.timeRemainingRsnd = 30
                self.isShowAlert = false
            }
            
            if !success {
                print("OTP RESP \(self.otpVM.statusMessage)")
                
                if (self.otpVM.statusMessage == "OTP_REQUESTED_FAILED") {
                    print("OTP FAILED")
                    print(self.otpVM.timeCounter)
                    
                    DispatchQueue.main.sync {
                        self.isLoading = self.otpVM.isLoading
                        self.messageResponse = self.otpVM.statusMessage
                        self.pinShare = self.otpVM.code
                        self.referenceCode = self.otpVM.reference
//                        self.timeRemainingRsnd = self.otpVM.timeCounter
                        self.timeRemainingRsnd = 30
                        self.isShowAlert = true
                    }
                } else if (self.otpVM.statusMessage == "Expired Token") {
                    DispatchQueue.main.async {
                        self.isLoading = self.otpVM.isLoading
                        self.isShowAlert = true
                        self.messageResponse = self.otpVM.statusMessage
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = self.otpVM.isLoading
                        self.isShowAlert = true
                        self.messageResponse = self.otpVM.statusMessage
                    }
                }
            }
        }
    }
    
    @StateObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                self.cardNo = self.profileVM.cardNo
            }
        }
    }
    
    @StateObject private var authVM = AuthViewModel()
    func forgotPin() {
        self.isLoading = true
        self.authVM.forgotPinTransaksi(cardNo: cardNo, pin: pinAtm, newPinTrx: password, phoneNmbr: phoneNumber, reference: referenceCode, codeOtp: pin) { success in
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
    
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    private func showIndeterminate() {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            if dim {
                hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            }
            
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.3)
            hud.vibrancyEnabled = false
            
            hud.textLabel.text = "Loading"
            
            if !self.otpVM.isLoading {
                hud.dismiss(afterDelay: 1)
            }
            
            return hud
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
}

struct OtpConfirmationChangeDataView_Previews: PreviewProvider {
    static var previews: some View {
        OtpConfirmationChangeDataView(password: "", phoneNumber: "", pinAtm: "")
    }
}
