//
//  FirstOTPLoginView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 12/10/20.
//

import SwiftUI
import Indicators

struct FirstOTPLoginView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Environtment Object */
    @EnvironmentObject var loginData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @GestureState private var dragOffset = CGSize.zero
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var showPin = true
    @State var referenceCode: String = ""
    @State var phoneNumber: String = ""
    @State var fingerprintFlag: Bool = false
    
    @State var isDisabled = false
    
    /* Data Binding */
    @ObservedObject var userVM = UserRegistrationViewModel()
    @ObservedObject private var otpVM = OtpViewModel()
    
    /* Variable Validation */
    @State var isLoading = true
    @State var isOtpValid = false
    @State var tryCount = 0
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    @State var isBtnValidationDisabled = false
    @State var tryCountResend = 1
    
    /* Timer */
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State private var isShowModal = false
    @State private var isShowAlert: Bool = false
    @State private var modalSelection = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /* Route */
    @State private var isRootToPasswordLogin = false
    @State var isKetentuanViewActive: Bool = false
    @State var isNoAtmOrRekViewActive: Bool = false
    
    @State var isShowModalUserNotRegister = false
    @State var isShowModalSelectionRegister = false
    
    /*
     variables otp new device
     */
    @Binding var isNewDeviceLogin: Bool
    @State var messageResponse: String = ""
    @State var pinShare: String = ""
    
    /* Disabled Form */
    var disableForm: Bool {
        if (pin.count < 6 || self.isBtnValidationDisabled) {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                VStack {
                    Text("ENTER OTP CODE".localized(language))
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
            }
            
            if self.isShowModal || self.isShowModalSelectionRegister || self.isShowModalUserNotRegister {
                ModalOverlay(tapAction: { withAnimation { } })
            }
            
            NavigationLink(
                destination: LoginScreen(phoneNumber: loginData.noTelepon, isNewDeviceLogin: self.$isNewDeviceLogin).environmentObject(loginData),
                isActive: self.$isRootToPasswordLogin,
                label: {}
            )
            .isDetailLink(false)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear(perform: getOTP)
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
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isShowAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("OK".localized(language)), action: {
                    self.isLoading = false
                }))
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
        .popup(isPresented: $isShowModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMenu()
        }
        .popup(isPresented: $isShowModalSelectionRegister, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            ScreeningNasabahModal()
        }
        .popup(isPresented: $isShowModalUserNotRegister, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            ScreeningUserNotRegister()
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .center) {
                    Text("We have sent OTP to no.\n".localized(language) + "+62\(loginData.noTelepon.trimmingCharacters(in: .whitespaces))")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 30)
                    
                    Text("Please enter the OTP code with \nREF #".localized(language)+"\(referenceCode)")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            ZStack {
                pinDots
                backgroundField
            }
            
            HStack {
                Text("Didn't Receive Code?".localized(language))
                    .font(.caption2)
                    .foregroundColor(.white)
                
                Button(action: {
                    print("-> Resend OTP")
                    self.tryCountResend += 1
                    getOTP()
                    resetField()
                }) {
                    Text("Resend OTP".localized(language))
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(isResendOtpDisabled ? Color(hex: "#232175") : Color.white)
                }
                .disabled(isResendOtpDisabled)
                
                Button(
                    action: {
                        self.isRootToPasswordLogin = true
                    },
                    label: {
                        Text("(\(self.timeRemainingRsnd.formatted(allowedUnits: [.minute, .second])!))")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                )
                .disabled(AppConstants().BYPASS_OTP)
            }
            .padding(.top, 5)
            
            Text("Make sure you are connected to the Internet and have sufficient credit to receive OTP".localized(language))
                .font(.caption)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 15)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            VStack {
                NavigationLink(destination: FirstATMLoginView(), isActive: self.$isOtpValid) {
                    Text("")
                }
                
                Button(action: {
                    validateOTP()
                }) {
                    
                    if (self.isBtnValidationDisabled) {
                        Text("(\(self.timeRemainingBtn.formatted(allowedUnits: [.minute, .second])!))")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    } else {
                        Text("OTP Verification".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    
                }
                .background(Color(hex: disableForm ? "#CBD1D9" : "#4958e3"))
                .shadow(radius: 3)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                .disabled(disableForm)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
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
            validateOTP()
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
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func bottomMessageOTPinCorrect() -> some View {
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
                self.isShowModal = false
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
    
    // MARK: -BOTTOM MESSAGE OTP VAILURE 5 TIME
    func bottomMessageOTPVailure() -> some View {
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
                self.appState.moveToWelcomeView = true
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
    
    // MARK: - POPUP SELECTOR REGISTER NASABAH
    func ScreeningNasabahModal() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Before Starting..!!".localized(language))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text("Are you a customer of Bank Mestika?".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 30)
            
            NavigationLink(
                destination: KetentuanRegisterNonNasabahView(rootIsActive: .constant(false)).environmentObject(loginData),
                isActive: self.$isKetentuanViewActive) {
                EmptyView()
            }
            
            Button(action: {
                self.isKetentuanViewActive = true
            }) {
                Text("No, I'am not".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(
                destination: NoAtmOrRekeningVerificationView(rootIsActive: .constant(false)).environmentObject(loginData).environmentObject(appState),
                isActive: self.$isNoAtmOrRekViewActive) {
                EmptyView()
            }
            
            Button(action: {
                self.isNoAtmOrRekViewActive = true
            }) {
                Text("Yes, I am a customer of Bank Mestika".localized(language))
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 30)
            .cornerRadius(12)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - POPUP SELECTOR REGISTER NASABAH
    func ScreeningUserNotRegister() -> some View {
        VStack(alignment: .leading) {
            
            HStack {
                Spacer()
                
                Text("You have not registered an online account".localized(language))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 20))
                    .foregroundColor(Color.red)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text("Do you want to register a Digital Banking application".localized(language))
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 20))
                    .foregroundColor(Color(hex: "#232175"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 30)
                
                Spacer()
            }
            
            Button(action: {
                self.isShowModalUserNotRegister = false
                self.isShowModalSelectionRegister = true
            }) {
                Text("YES".localized(language))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
//            NavigationLink(
//                destination: NoAtmOrRekeningVerificationView(rootIsActive: .constant(false)).environmentObject(loginData).environmentObject(appState),
//                isActive: self.$isNoAtmOrRekViewActive) {
//                EmptyView()
//            }
            
            Button(action: {
                self.appState.moveToWelcomeView = true
            }) {
                Text("No".localized(language))
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .padding(.bottom, 30)
            .cornerRadius(12)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func popupMenu() -> some View {
        switch modalSelection {
        case "OTPINCORRECT":
            return AnyView(bottomMessageOTPinCorrect())
        case "OTPINCORRECT5TIME":
            return AnyView(bottomMessageOTPVailure())
        default:
            return AnyView(bottomMessageOTPinCorrect())
        }
    }
    
    // MARK: - FUNCTION GET STATUS USER
    func getUserStatus(deviceId: String) {
        print("GET USER STATUS")
        print("DEVICE ID : \(deviceId)")
        
        self.userVM.userCheck(deviceId: deviceId) { success in
            
            if success {
                print("CODE STATUS : \(self.userVM.code)")
                print("MESSAGE STATUS : \(self.userVM.message)")
            }
            
            if !success {
                self.modalSelection = "DEFAULT"
                self.isShowModal = true
            }
        }
    }
    
    // MARK: - FUNCTION REQUEST OTP
    func getOTP() {
        if isNewDeviceLogin {
            print("NEW DEVICE LOGIN REQ OTP")
            print("Destination \(self.loginData.noTelepon)")
            self.otpVM.otpRequest(
                otpRequest: OtpRequest(
                    destination: self.loginData.noTelepon,
                    type: "hp",
                    trytime: self.tryCountResend
                )
            ) { success in
                
                if success {
                    print("isLoading \(self.otpVM.isLoading)")
                    print("otpRef \(self.otpVM.reference)")
                    print("status \(self.otpVM.statusMessage)")
                    
                    DispatchQueue.main.async {
                        self.isLoading = self.otpVM.isLoading
                        self.referenceCode = self.otpVM.reference
                        self.messageResponse = self.otpVM.statusMessage
                        //                    self.timeRemainingRsnd = self.otpVM.timeCounter
                        self.timeRemainingRsnd = 30
                        self.isShowAlert = false
                    }
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
                    } else {
                        DispatchQueue.main.async {
                            self.isLoading = self.otpVM.isLoading
                            self.isShowAlert = true
                            self.messageResponse = self.otpVM.statusMessage
                        }
                    }
                }
            }
        } else {
            print("CURRECT DEVICE OTP REQUEST")
            self.otpVM.otpRequestLogin() { success in
                   
                   if success {
                       self.isLoading = false
                       self.timeRemainingRsnd = 30
                       
                       print(self.otpVM.isLoading)
                       print(self.otpVM.reference)
                       self.referenceCode = self.otpVM.reference
                   }
                   
                   if !success {
                       self.isLoading = false
                       self.timeRemainingRsnd = 0
                       print("ERROR GET OTP")
                       
                   }
               }

        }
    }
    
    // MARK: - FUNCTION VALIDATE OTP
    func validateOTP() {
        self.isLoading = true
        
        print("self.loginData.noTelepon \(self.loginData.noTelepon)")
        
        var data = self.loginData.noTelepon
        
        if (data.substring(to: 1) == "0") {
            print(data.substring(to: 1))
            self.loginData.noTelepon = String(data.dropFirst())
        } else {
            print(data.substring(to: 1))
            print("Bukan 0")
        }
        
        print(self.loginData.noTelepon)
        
        // VALIDATE OTP LOGIN
        self.otpVM.otpValidationLogin(
            code: self.pin,
            destination: self.loginData.noTelepon,
            reference: referenceCode,
            timeCounter: self.timeRemainingBtn,
            tryCount: tryCount)
        { success in
            
            if success {
                print("OTP VALID | code: \(otpVM.code)")
                self.isLoading = false
                self.isRootToPasswordLogin = true
            }
            
            if !success {
                print("OTP INVALID | code: \(otpVM.code)")
                
                self.isLoading = false
                if self.otpVM.code == "403" {
                    self.isShowModalUserNotRegister = true
                } else {
                    print("unauthorized")
                    
                    print(self.otpVM.timeRemaining)
                    self.timeRemainingBtn = self.otpVM.timeRemaining
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal = true
                    
                    self.isBtnValidationDisabled = true
                    resetField()
                }
            }
            
        }
        
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
}

#if DEBUG
struct FirstOTPLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstOTPLoginView(isNewDeviceLogin: .constant(false)).environmentObject(RegistrasiModel())
    }
}
#endif
