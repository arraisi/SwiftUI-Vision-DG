//
//  RegisterNasabahPhoneOTPScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

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
    
    /* Variable Validation */
    @State var isOtpValid = false
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    @State var tryCount = 0
    
    /* Timer */
    @State private var timeRemaining = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State var showingOtpIncorect = false
    @State var showingOtpInvalid = false
    @State private var showingAlert: Bool = false
    @State private var showingAlertError: Bool = false
    
    /* Disabled Form */
    var disableForm: Bool {
        pin.count < 6
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
                
                AppBarLogo(light: false) {
                    
                }
                
                VStack(alignment: .center) {
                    
                    Text("Kami telah mengirimkan OTP ke No. \(replace(myString: registerData.noTelepon, [6, 7, 8, 9], "x"))")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                    
                    Text("Silahkan masukan kode OTP dengan REF #\(referenceCode)")
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
                        Text("Tidak Menerima Kode?")
                            .font(.custom("Montserrat-Regular", size: 10))
                        
                        Button(action: {
                            print("-> Resend OTP")
                            getOTP()
                            
                            self.resetField()
                            self.timeRemaining = 60
                        }) {
                            Text("Resend OTP")
                                .font(.custom("Montserrat-SemiBold", size: 10))
                                .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                        }
                        .disabled(isResendOtpDisabled)
                        
                        Button(action: {
                                self.isOtpValid = true
                            }, label: {
                                Text("(00:\(String(format: "%02d", timeRemaining)))")
                                    .font(.custom("Montserrat-Regular", size: 10))
                            })
                            .disabled(false) // false by pass to next page
                    }
                    .padding(.top, 5)
                    
                    Text("Pastikan Anda terkoneksi ke Internet dan pulsa mencukupi untuk menerima OTP")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack {
                        NavigationLink(
                            destination: InputEmailRegisterNasabahView().environmentObject(registerData),
                            isActive: self.$isOtpValid) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            self.tryCount += 1
                            validateOTP()
                        }) {
                            Text("Verifikasi OTP")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
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
            
            if self.showingOtpIncorect {
                ModalOverlay(tapAction: { withAnimation { self.showingOtpIncorect = false } })
            }
            
            if self.showingOtpInvalid {
                ModalOverlay(tapAction: { withAnimation { self.showingOtpInvalid = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
//        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
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
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            
            if self.timeRemaining < 1 {
                isResendOtpDisabled = false
            } else {
                isResendOtpDisabled = true
            }
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("OTP Code"),
                message: Text(self.pinShare),
                dismissButton: .default(Text("Oke"), action: {
                    self.pin = self.pinShare
                }))
        }
        .popup(isPresented: $showingOtpIncorect, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            bottomMessageOTPinCorrect()
        }
        .popup(isPresented: $showingOtpInvalid, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            bottomMessageOTPVailure()
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
        if chars.count > 5 {
            for data in index {
                chars[data] = newChar
            }
        }
        
        let modifiedString = String(chars)
        return modifiedString
    }
    
    // MARK: -BOTTOM MESSAGE OTP IN CORRECT
    func bottomMessageOTPinCorrect() -> some View {
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
            
            Text("Kode OTP yang anda masukan salah silahkan ulangi lagi")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {}) {
                Text("Kembali")
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
            
            Text("Kode OTP Salah")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("Kode OTP yang anda masukan telah salah 5 kali, silahkan ulangi lagi minggu depan.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
//                self.rootIsActive = true
                self.appState.moveToWelcomeView = true
            }) {
                Text("Kembali ke Halaman Utama")
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
                trytime: 60
            )
        ) { success in
            
            if success {
                print("isLoading \(self.otpVM.isLoading)")
                print("otpRef \(self.otpVM.reference)")
                print("status \(self.otpVM.statusMessage)")
                
                DispatchQueue.main.async {
//                    self.timeRemaining = self.otpVM.timeCounter
                    self.referenceCode = self.otpVM.reference
                }
                
                self.showingAlertError = true
            }
            
            if !success {
                print("OTP RESP \(self.otpVM.statusMessage)")
                
                if (self.otpVM.statusMessage == "Server Error") {
                    self.showingAlertError = true
                }
                
                if (self.otpVM.statusMessage == "OTP_REQUESTED_FAILED") {
                    print("OTP FAILED")
                    print(self.otpVM.timeCounter)
                    
                    DispatchQueue.main.sync {
                        self.pinShare = self.otpVM.code
                        self.referenceCode = self.otpVM.reference
                        self.timeRemaining = self.otpVM.timeCounter
                    }
                    self.showingAlertError = true
                }
            }
        }
    }
    
    func validateOTP() {
        self.otpVM.otpValidation(
            code: self.pin,
            destination: "+62" + self.registerData.noTelepon,
            reference: referenceCode,
            timeCounter: self.otpVM.timeCounter,
            tryCount: tryCount,
            type: "hp")
        { success in
            
            if success {
                print("OTP VALID")
                self.isOtpValid = true
            }
            
            if !success {
                print("OTP INVALID")
                showingOtpIncorect.toggle()
                resetField()
            }
            
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
}

struct RegisterNasabahPhoneOTPScreen_Previews: PreviewProvider {
    static var previews: some View {
        PhoneOTPRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}