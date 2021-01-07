//
//  PhoneOTPV2.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 02/12/20.
//

import SwiftUI
import Indicators

struct PhoneOTPRegisterNasabahView: View {
    
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* HUD Variable */
    @State private var dim = true
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var showPin = true
    @State var pinShare: String = ""
    @State var referenceCode: String = ""
    @State var isDisabled = false
    @State var messageResponse: String = ""
    @State var destinationNumber: String = ""
    
    /* Variable Validation */
    @State var isLoading = true
    @State var isOtpValid = false
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    @State var isBtnValidationDisabled = false
    @State var tryCount = 0
    @State var tryCountResend = 0
    
    /* Timer */
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State private var isShowModal = false
    @State private var isShowAlert: Bool = false
    @State private var modalSelection = ""
    
    @Binding var rootIsActive : Bool
    @Binding var root2IsActive : Bool
    
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
                    
                    Text(NSLocalizedString("Kami telah mengirimkan OTP ke No.\n", comment: "") + " \(destinationNumber)")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 30)
                    
                    Text(NSLocalizedString("Silahkan masukkan kode OTP dengan", comment: "") + "\nREF #\(referenceCode)")
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
//                            self.timeRemainingRsnd = 30
                        }) {
                            Text(NSLocalizedString("Resend OTP", comment: ""))
                                .font(.custom("Montserrat-SemiBold", size: 10))
                                .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                        }
                        .disabled(isResendOtpDisabled)
                        
                        Button(action: {
                            self.isOtpValid = true
                        }, label: {
                            Text("(\(self.timeRemainingRsnd.formatted(allowedUnits: [.minute, .second])!)")
                                .font(.custom("Montserrat-Regular", size: 10))
                        })
                        .disabled(true) // false by pass to next page
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
                        NavigationLink(
                            destination: EmailRegisterNasabahView(shouldPopToRootView: self.$rootIsActive, shouldPopToRootView2: self.$root2IsActive).environmentObject(registerData),
                            isActive: self.$isOtpValid) {
                            EmptyView()
                        }
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
                ModalOverlay(tapAction: { withAnimation { } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
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
                dismissButton: .default(Text("Oke"), action: {
                    self.isLoading = false
                }))
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
        if chars.count > 5 {
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
        self.otpVM.otpRequestAccOrRek(
            otpRequest: OtpRequest(
                destination: self.registerData.atmOrRekening == "ATM" ? self.registerData.noAtm : self.registerData
                    .noRekening,
                type: self.registerData.atmOrRekening == "ATM" ? "atm" : "rek",
                trytime: 1
            )
        ) { success in
            
            if success {
                print("isLoading \(self.otpVM.isLoading)")
                print("otpRef \(self.otpVM.reference)")
                print("status \(self.otpVM.statusMessage)")
                
                DispatchQueue.main.async {
                    //                    self.timeRemaining = self.otpVM.timeCounter
                    self.isLoading = self.otpVM.isLoading
                    self.referenceCode = self.otpVM.reference
                    self.messageResponse = self.otpVM.statusMessage
                    self.destinationNumber = self.otpVM.destination
                    self.registerData.noTelepon = self.otpVM.destination
                    UserDefaults.standard.set(self.otpVM.destination, forKey: "phone_local")
                }
                
                self.isShowAlert = false
                
                self.timeRemainingRsnd = max(30, self.tryCountResend * 30)
            }
            
            if !success {
                print("OTP RESP \(self.otpVM.statusMessage)")
                
                if (self.otpVM.statusMessage == "Server Error") {
                    self.isShowAlert = true
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
                    }
                    self.isShowAlert = true
                }
            }
        }
    }
    
    func validateOTP() {
        self.isLoading = true
        self.otpVM.otpValidationAccOrRek(
            code: self.pin,
            destination: self.destinationNumber,
            reference: referenceCode,
            timeCounter: self.timeRemainingBtn,
            tryCount: tryCount,
            type: self.registerData.atmOrRekening == "ATM" ? "atm" : "rek",
            accValue: self.registerData.atmOrRekening == "ATM" ? self.registerData.noAtm : self.registerData
                .noRekening)
        { success in
            
            if success {
                print("OTP VALID")
                self.isOtpValid = true
                self.isLoading = false
            }
            
            if !success {
                print("OTP INVALID")
                
                self.isLoading = false
                //                self.timeRemainingBtn = self.otpVM.timeRemaining
                
                if (self.tryCount == 1) {
                    self.timeRemainingBtn = 0
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                }
                
                if (self.tryCount == 2) {
                    self.timeRemainingBtn = 0
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                }
                
                if (self.tryCount == 3) {
                    self.timeRemainingBtn = 0
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                }
                
                if (self.tryCount == 4) {
                    self.timeRemainingBtn = 30
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                }
                
                if (self.tryCount == 5) {
                    self.timeRemainingBtn = 60
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                }
                
                if (self.tryCount == 6) {
                    self.timeRemainingBtn = 120
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                }
                
                if (self.tryCount == 7) {
                    self.timeRemainingBtn = 240
                    self.modalSelection = "OTPINCORRECT"
                    self.isShowModal.toggle()
                }
                
                if (self.tryCount >= 8) {
                    self.timeRemainingBtn = 480
                    self.modalSelection = "OTPINCORRECT5TIME"
                    self.isShowModal.toggle()
                }
                
                self.isBtnValidationDisabled = true
                resetField()
            }
            
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
}

struct PhoneOTPRegisterNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneOTPRegisterNasabahView(rootIsActive: .constant(false), root2IsActive: .constant(false)).environmentObject(RegistrasiModel())
    }
}
