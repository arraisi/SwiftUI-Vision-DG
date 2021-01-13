//
//  OTPVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI
import NavigationStack
import JGProgressHUD_SwiftUI
import Indicators

struct FormOTPVerificationRegisterNasabahView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var phone_local = UserDefaults.standard.string(forKey: "phone_local")
    
    @Binding var rootIsActive : Bool
    @Binding var root2IsActive : Bool
    
    @State var editModeForCreateSchedule: EditMode = .inactive
    @State var editModeForReschedule: EditMode = .inactive
    @State var editModeForChooseATM: EditMode = .inactive
    @State var editModeForCancel: EditMode = .inactive
    
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
    @State var tryCountResend = 0
    @State var tryCountResendDisable = 0
    @State var routingReschedule: Bool = false
    @State var routingChooseATM: Bool = false
    
    /* Timer */
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State private var isShowModal = false
    @State private var isShowAlert: Bool = false
    @State private var modalSelection = ""
    
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
                    Text(NSLocalizedString("Kami telah mengirimkan OTP ke no.\n", comment: "") + "+62\(registerData.noTelepon)")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 30)
                    
                    Text(NSLocalizedString("Silahkan masukkan kode OTP dengan \nREF #", comment: "")+"\(referenceCode)")
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
                        Text(NSLocalizedString("Tidak Menerima Kode?", comment: ""))
                            .font(.custom("Montserrat-Regular", size: 10))
                        
                        Button(action: {
                            print("-> Resend OTP")
                            self.tryCountResend += 1
                            getOTP()
                            
                            self.resetField()
                        }) {
                            Text(NSLocalizedString("Resend OTP", comment: ""))
                                .font(.custom("Montserrat-SemiBold", size: 10))
                                .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                        }
                        .disabled(isResendOtpDisabled)
                        
                        Button(
                            action: {
                                self.isOtpValid = true
                            },
                            label: {
                                Text("(\(self.timeRemainingRsnd.formatted(allowedUnits: [.minute, .second])!))")
                                    .font(.custom("Montserrat-Regular", size: 10))
                            })
                            .disabled(true)
                    }
                    .padding(.top, 5)
                    
                    Text(NSLocalizedString("Pastikan Anda terkoneksi ke Internet dan \npulsa mencukupi untuk menerima OTP", comment: ""))
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
                            destination: SuccessRegisterView().environmentObject(registerData),
                            isActive: self.$routingReschedule,
                            label: {}
                        )
                        .isDetailLink(false)
                        
                        NavigationLink(destination: FormPilihJenisATMView().environmentObject(atmData).environmentObject(registerData), isActive: self.$routingChooseATM, label: {EmptyView()})
                            .isDetailLink(false)
                        
                        Button(action: {
                            self.tryCount += 1
                            validateOTP()
                        }) {
                            
                            if (self.isBtnValidationDisabled) {
                                Text("(\(self.timeRemainingBtn.formatted(allowedUnits: [.minute, .second])!))")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            } else {
                                Text(NSLocalizedString("Verifikasi OTP", comment: ""))
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
            
            if self.isShowModal {
                ModalOverlay(tapAction: { withAnimation {} })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                getOTP()
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
        .popup(
            isPresented: $isShowModal,
            type: .floater(),
            position: .bottom,
            animation: Animation.spring(),
            closeOnTap: true,
            closeOnTapOutside: true) { popupMenu() }
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
            
            Text(NSLocalizedString("Kode OTP Salah", comment: ""))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text(NSLocalizedString("Kode OTP yang anda masukkan salah silahkan ulangi lagi", comment: ""))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                self.isLoading = false
                self.isShowModal = false
            }) {
                Text(NSLocalizedString("Kembali", comment: ""))
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
    
    // MARK: -BOTTOM MESSAGE OTP INCORRECT 5 TIME
    func popupOTPIncorrect5Time() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text(NSLocalizedString("Kode OTP Salah", comment: ""))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text(NSLocalizedString("Kode OTP yang anda masukkan telah salah 5 kali, silahkan ulangi lagi minggu depan.", comment: ""))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                self.appState.moveToWelcomeView = true
            }) {
                Text(NSLocalizedString("Kembali ke Halaman Utama", comment: ""))
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
                    self.timeRemainingRsnd = self.otpVM.timeCounter
                    self.isShowAlert = true
                }
            }
            
            if !success {
                print("OTP RESP \(self.otpVM.statusMessage)")
                
                if (self.otpVM.statusMessage == "Internal Server Error") {
                    self.isShowAlert = true
                    self.messageResponse = self.otpVM.statusMessage
                }
                
                if (self.otpVM.statusMessage == "OTP_REQUESTED_FAILED") {
                    print("OTP FAILED")
                    print(self.otpVM.timeCounter)
                    
                    DispatchQueue.main.sync {
                        self.isLoading = self.otpVM.isLoading
                        self.messageResponse = self.otpVM.statusMessage
                        self.pinShare = self.otpVM.code
                        self.referenceCode = self.otpVM.reference
                        self.timeRemainingRsnd = self.otpVM.timeCounter
                        self.isShowAlert = true
                    }
                }
            }
        }
    }
    
    func validateOTP() {
        self.isLoading = true
        self.otpVM.otpValidation(
            code: self.pin,
            destination: "+62" + self.registerData.noTelepon,
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
                    self.isLoading = false
                    self.appState.moveToWelcomeViewThenCancel = true
                } else {
                    UserDefaults.standard.set("false", forKey: "routingSchedule")
                    self.isOtpValid = true
                    self.isLoading = false
                }
            }
            
            if !success {
                print("OTP INVALID")
                
                self.isLoading = false
                print(self.otpVM.timeRemaining)
                self.timeRemainingBtn = self.otpVM.timeRemaining
                self.modalSelection = "OTPINCORRECT"
                self.isShowModal.toggle()
                
//                if (self.tryCount == 1) {
//                    self.timeRemainingBtn = 0
//                    self.modalSelection = "OTPINCORRECT"
//                    self.isShowModal.toggle()
//                }
//
//                if (self.tryCount == 2) {
//                    self.timeRemainingBtn = 0
//                    self.modalSelection = "OTPINCORRECT"
//                    self.isShowModal.toggle()
//                }
//
//                if (self.tryCount == 3) {
//                    self.timeRemainingBtn = 0
//                    self.modalSelection = "OTPINCORRECT"
//                    self.isShowModal.toggle()
//                }
//
//                if (self.tryCount > 3) {
//                    self.tryCountResendDisable += 1
//                    self.timeRemainingBtn = max(30, (tryCountResendDisable) * 30)
//                    self.modalSelection = "OTPINCORRECT"
//                    self.isShowModal.toggle()
//                }
                
                self.isBtnValidationDisabled = true
                resetField()
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

#if DEBUG
struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormOTPVerificationRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(RegistrasiModel())
        }
    }
}
#endif
