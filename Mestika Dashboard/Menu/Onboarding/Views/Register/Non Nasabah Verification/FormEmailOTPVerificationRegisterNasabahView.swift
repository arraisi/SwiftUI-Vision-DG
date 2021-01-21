//
//  EmailOTPVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI
import Indicators
import SystemConfiguration

struct FormEmailOTPVerificationRegisterNasabahView: View {
    
    var productATMData = AddProductATM()
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
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
    @State var isResendOtpDisabled = true
    @State var isBtnValidationDisabled = false
    @State var tryCount = 0
    @State var tryCountResend = 1
    @State var tryCountResendDisable = 0
    
    @Binding var shouldPopToRootView : Bool
    
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State private var isShowModal = false
    @State private var isShowAlert: Bool = false
    @State private var modalSelection = ""
    
    @State var isShowAlertInternetConnection = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    var disableForm: Bool {
        if (pin.count < 6 || self.isBtnValidationDisabled) {
            return true
        }
        return false
    }
    
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
                    Text(NSLocalizedString("Kami telah mengirimkan Kode Verifikasi ke\n", comment: "") + " \(registerData.email)")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(NSLocalizedString("Silahkan masukkan kode OTP dengan \nREF #", comment: "") + "\(referenceCode)")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    ZStack {
                        pinDots
                        backgroundField
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Tidak Menerima Kode?", comment: ""))
                            .font(.custom("Montserrat-Regular", size: 12))
                        
                        Button(action: {
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            if self.isNetworkReachability(with: flags) {
                                print("-> Resend OTP")
                                
                                self.tryCountResend += 1
                                self.resetField()
                                getOTP()
                            } else {
                                self.isShowAlertInternetConnection = true
                            }
                        }) {
                            Text("Resend OTP")
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
                            .disabled(true)
                    }
                    .padding(.top, 5)
                    
                    Text(NSLocalizedString("Silahkan cek email Anda untuk melihat kode OTP", comment: ""))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack {
                        NavigationLink(
                            destination: FormPilihJenisTabunganView(shouldPopToRootView: self.$shouldPopToRootView).environmentObject(registerData).environmentObject(productATMData),
                            isActive: self.$isOtpValid,
                            label: {
                                EmptyView()
                            }).isDetailLink(false)
                        
                        
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
                                Text(NSLocalizedString("Verifikasi OTP", comment: ""))
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            }
                        }
                        .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                        .disabled(disableForm)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 30)
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
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                if self.isNetworkReachability(with: flags) {
                    getOTP()
                } else {
                    self.isShowAlertInternetConnection = true
                }
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
            } else {
                //                isBtnValidationDisabled = true
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
        .popup(isPresented: $isShowAlertInternetConnection, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            PopupNoInternetConnection()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
    }
    
    func PopupNoInternetConnection() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Please check your internet connection")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            Button(
                action: {
                    self.isShowAlertInternetConnection = false
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
        if chars.count > 2 {
            chars[index[0]] = newChar
            chars[index[1]] = chars[index[0]]
            chars[index[2]] = chars[index[1]]
            chars[index[3]] = chars[index[2]]
        }
        let modifiedString = String(chars)
        return modifiedString
    }
    
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
            
            Text("Kode OTP Salah")
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
        print("EMAIL \(self.registerData.email)")
        self.otpVM.otpRequest(
            otpRequest: OtpRequest(
                destination: self.registerData.email,
                type: "email",
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
                    self.isShowAlert = false
                    self.timeRemainingRsnd = self.otpVM.timeCounter
                }
            }
            
            if !success {
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
        self.otpVM.otpValidation(
            code: self.pin,
            destination: self.registerData.email,
            reference: referenceCode,
            timeCounter: self.timeRemainingBtn,
            tryCount: tryCount,
            type: "email")
        { success in
            
            if success {
                print("OTP VALID")
                self.isOtpValid = true
            }
            
            if !success {
                print("OTP INVALID")
                
                self.isLoading = false
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
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
    
    func isNetworkReachability(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }
}

struct EmailOTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormEmailOTPVerificationRegisterNasabahView(shouldPopToRootView: .constant(false)).environmentObject(RegistrasiModel())
        }
    }
}
