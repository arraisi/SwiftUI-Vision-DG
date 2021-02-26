//
//  OTPVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI
import JGProgressHUD_SwiftUI
import Indicators
import SystemConfiguration

struct FormOTPVerificationRegisterNasabahView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userVM = UserRegistrationViewModel()
    @State private var phone_local = UserDefaults.standard.string(forKey: "phone_local")
    @State private var nik_local = UserDefaults.standard.string(forKey: "nik_local_storage")
    
    @Binding var rootIsActive : Bool
    @Binding var root2IsActive : Bool
    
    @State var editModeForCreateSchedule: EditMode = .inactive
    @State var editModeForReschedule: EditMode = .inactive
    @State var editModeForChooseATM: EditMode = .inactive
    @State var editModeForCancel: EditMode = .inactive
    
    @GestureState private var dragOffset = CGSize.zero
    
    /* HUD Variable */
    @State private var dim = true
    
    @State var isShowNextView : Bool = false
    
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
    @State var routingReschedule: Bool = false
    @State var routingChooseATM: Bool = false
    @State var isCancelViewActive: Bool = false
    
    /* Timer */
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State private var isShowModal = false
    @State private var isShowAlert: Bool = false
    @State private var modalSelection = ""
    
    @State var isShowAlertInternetConnection = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    var atmData = AddProductATM()
    
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
                    Text(NSLocalizedString("We have sent OTP to no.\n".localized(language), comment: "") + "+62\(registerData.noTelepon.trimmingCharacters(in: .whitespaces))")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 30)
                    
                    Text(NSLocalizedString("Please enter the OTP code with \nREF #".localized(language), comment: "")+"\(referenceCode)")
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
                        Text(NSLocalizedString("Didn't Receive Code?".localized(language), comment: ""))
                            .font(.custom("Montserrat-Regular", size: 12))
                        
                        Button(action: {
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            if self.isNetworkReachability(with: flags) {
                                print("-> Resend OTP")
                                self.tryCountResend += 1
                                getOTP()
                                
                                self.resetField()
                            } else {
                                self.isShowAlertInternetConnection = true
                            }
                        }) {
                            Text(NSLocalizedString("Resend OTP".localized(language), comment: ""))
                                .font(.custom("Montserrat-SemiBold", size: 12))
                                .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                        }
                        .disabled(isResendOtpDisabled)
                        
                        Button(
                            action: {
                                self.isOtpValid = true
                            },
                            label: {
                                Text("(\(self.timeRemainingRsnd.formatted(allowedUnits: [.minute, .second])!))")
                                    .font(.custom("Montserrat-Regular", size: 12))
                            })
                            .disabled(AppConstants().BYPASS_OTP)
                    }
                    .padding(.top, 5)
                    
                    Text(NSLocalizedString("Make sure you are connected to the Internet and have sufficient credit to receive OTP".localized(language), comment: ""))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack {
                        
                        NavigationLink(destination: FormEmailVerificationRegisterNasabahView(shouldPopToRootView: self.$rootIsActive, shouldPopToRootView2: self.$root2IsActive).environmentObject(registerData), isActive: self.$isOtpValid) {
                            EmptyView()
                        }
                        .isDetailLink(false)
                        
                        NavigationLink(
                            destination: RescheduleRegisterView().environmentObject(registerData).environmentObject(atmData),
                            isActive: self.$routingReschedule,
                            label: {EmptyView()}
                        )
                        
                        NavigationLink(destination: FormPilihJenisATMView().environmentObject(atmData).environmentObject(registerData), isActive: self.$routingChooseATM, label: {EmptyView()})
                            .isDetailLink(false)
                        
                        NavigationLink(
                            destination: SuccessCancelView(),
                            isActive: self.$isCancelViewActive,
                            label: {}
                        )
                        .isDetailLink(false)
                        
                        Button(action: {
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            if self.isNetworkReachability(with: flags) {
                                self.tryCount += 1
                                validateOTP()
                            } else {
                                self.isShowAlertInternetConnection = true
                            }
                        }) {
                            
                            if (self.isBtnValidationDisabled) {
                                Text("(\(self.timeRemainingBtn.formatted(allowedUnits: [.minute, .second])!))")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            } else {
                                Text(NSLocalizedString("OTP Verification", comment: ""))
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
            
            if (self.isShowModal || self.isShowAlertInternetConnection) {
                ModalOverlay(tapAction: { withAnimation {
                    self.isShowModal = false
                    self.isShowAlertInternetConnection = false
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
            if (editModeForCreateSchedule == .active || editModeForReschedule == .active || editModeForChooseATM == .active) {
                self.registerData.noTelepon = phone_local ?? ""
            } else if (editModeForCancel == .active) {
                self.registerData.noTelepon = phone_local ?? ""
            }
        }
        .onAppear(perform: {
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
            if self.isNetworkReachability(with: flags) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    getOTP()
                }
            } else {
                self.isShowAlertInternetConnection = true
            }
        })
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
                message: Text(self.messageResponse),
                dismissButton: .default(Text("Oke"))
            )
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
        .popup(
            isPresented: $isShowModal,
            type: .floater(),
            position: .bottom,
            animation: Animation.spring(),
            closeOnTap: true,
            closeOnTapOutside: true) { popupMenu() }
        
        .popup(isPresented: $isShowAlertInternetConnection, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            PopupNoInternetConnection()
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
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func popupOTPInvalid() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text(NSLocalizedString("Incorrect OTP Code".localized(language), comment: ""))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text(NSLocalizedString("The OTP code you entered is incorrect, please try again".localized(language), comment: ""))
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                self.isLoading = false
                self.isShowModal = false
            }) {
                Text(NSLocalizedString("Back", comment: ""))
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
            
            Text(NSLocalizedString("Incorrect OTP Code".localized(language), comment: ""))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text(NSLocalizedString("The OTP code you entered was incorrect 5 times, please try again next week.".localized(language), comment: ""))
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                self.appState.moveToWelcomeView = true
            }) {
                Text(NSLocalizedString("Back to Main Page".localized(language), comment: ""))
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
    
    func PopupNoInternetConnection() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text(NSLocalizedString("Please check your internet connection".localized(language), comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    appState.moveToWelcomeView = true
                },
                label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    @ObservedObject private var otpVM = OtpViewModel()
    func getOTP() {
        self.otpVM.otpRequest(
            otpRequest: OtpRequest(
                destination: self.registerData.noTelepon,
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
    }
    
    func validateOTP() {
        self.isLoading = true
        print(tryCount)
        self.otpVM.otpValidation(
            code: self.pin,
            destination: self.registerData.noTelepon,
            reference: referenceCode,
            timeCounter: self.timeRemainingBtn,
            tryCount: tryCount,
            type: "hp")
        { success in
            
            if success {
                print("OTP VALID")
                if (editModeForCreateSchedule == .active) {
                    self.isLoading = false
                    self.routingReschedule = true
                } else if (editModeForReschedule == .active) {
                    self.isLoading = false
                    UserDefaults.standard.set("true", forKey: "routingSchedule")
                    self.routingReschedule = true
                } else if (editModeForChooseATM == .active) {
                    self.isLoading = false
                    UserDefaults.standard.set("false", forKey: "routingSchedule")
                    self.routingChooseATM = true
                } else if (editModeForCancel == .active) {
                    var flags = SCNetworkReachabilityFlags()
                    SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                    if self.isNetworkReachability(with: flags) {
                        self.isLoading = false
                        self.cancelRegistration()
                    } else {
                        self.isShowAlertInternetConnection = true
                    }
                } else {
                    UserDefaults.standard.set("false", forKey: "routingSchedule")
                    self.isOtpValid = true
                    self.isLoading = false
                }
            }
            
            if !success {
                print(self.otpVM.errorCode)
                if (self.otpVM.errorCode == 401) {
                    print("OTP INVALID")
                    self.isLoading = false
                    print(self.otpVM.timeRemaining)
                    self.timeRemainingBtn = self.otpVM.timeRemaining
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                    self.isBtnValidationDisabled = true
                    resetField()
                } else if (self.otpVM.errorCode == 403) {
                    self.isLoading = false
                    self.messageResponse = self.otpVM.statusMessage
                    self.isShowAlert = true
                } else {
                    print("OTP INVALID")
                    self.isLoading = false
                    print(self.otpVM.timeRemaining)
                    self.timeRemainingBtn = self.otpVM.timeRemaining
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                    self.isBtnValidationDisabled = true
                    resetField()
                }
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
    
    func cancelRegistration() {
        self.isLoading = true
        
        self.userVM.cancelRegistration(nik: nik_local ?? "", completion: { (success:Bool) in

            if success {
                self.isLoading = false
                self.modalSelection = ""

                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()

                self.isCancelViewActive = true

            } else {
                self.isLoading = false

                self.messageResponse = NSLocalizedString("Failed to cancel the application. Please try again later.".localized(language), comment: "")
                self.isShowAlert.toggle()
            }
        })
    }
    
    func isNetworkReachability(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }
}

#if DEBUG
struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(RegistrasiModel())
        }
    }
}
#endif
