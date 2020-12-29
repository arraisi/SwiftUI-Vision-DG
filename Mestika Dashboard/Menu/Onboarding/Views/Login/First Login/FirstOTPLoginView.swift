//
//  FirstOTPLoginView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 12/10/20.
//

import SwiftUI

struct FirstOTPLoginView: View {
    /* Environtment Object */
    @EnvironmentObject var loginData: LoginBindingModel
    @EnvironmentObject var appState: AppState
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var showPin = true
    
    @State var isDisabled = false
    
    /* Data Binding */
    @ObservedObject private var otpVM = OtpViewModel()
    
    /* Variable Validation */
    @State var isOtpValid = false
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    
    /* Timer */
    @State private var timeRemaining = 40
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State var showingOtpIncorect = false
    @State var showingOtpInvalid = false
    @State private var showingAlert: Bool = false
    
    /* Disabled Form */
    var disableForm: Bool {
        pin.count < 6
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                VStack {
                    Text("MASUKKAN KODE OTP")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 100)
            }
            
            if self.showingOtpIncorect {
                ModalOverlay(tapAction: { withAnimation { self.showingOtpIncorect = false } })
            }
            
            if self.showingOtpInvalid {
                ModalOverlay(tapAction: { withAnimation { self.showingOtpInvalid = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear(perform: getOTP)
        .onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
        .alert(isPresented: $showingAlert) {
            if (self.otpVM.code.isEmpty) {
                return Alert(
                    title: Text("Message Error"),
                    message: Text("No OTP Code"),
                    dismissButton: .default(Text("Oke"))
                )
            } else {
                return Alert(
                    title: Text("OTP Code"),
                    message: Text(self.otpVM.code),
                    dismissButton: .default(Text("Oke"), action: {
                        pin = self.otpVM.code
                    })
                )
            }
        }
        .popup(isPresented: $showingOtpIncorect, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            bottomMessageOTPinCorrect()
        }
        .popup(isPresented: $showingOtpInvalid, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            bottomMessageOTPVailure()
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .center) {
                    Text("Kode OTP telah dikirim ke nomor")
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("".replace(myString: loginData.noTelepon, [6, 7, 8, 9], "x"))
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            
            ZStack {
                pinDots
                backgroundField
            }
            
            HStack {
                Text("Tidak Menerima Kode?")
                    .font(.caption2)
                    .foregroundColor(.white)
                Button(action: {
                    print("-> Resend OTP")
                    getOTP()
                }) {
                    Text("Resend OTP")
                        .font(.caption2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                }
                Text("(00:\(timeRemaining))")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
            .padding(.top, 5)
            
            Text("Pastikan Anda terkoneksi ke Internet dan pulsa mencukupi untuk menerima OTP")
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
                    print(pin)
                    print(self.otpVM.code)
                    
                    if (pin == self.otpVM.code && otpInvalidCount < 5) {
                        print("OTP CORRECT")
                        self.isOtpValid = true
                    }
                    
                    if (pin != self.otpVM.code && otpInvalidCount <= 4) {
                        print("OTP INCORRECT")
                        self.otpInvalidCount += 1
                        print("\(self.otpInvalidCount)")
                        showingOtpIncorect.toggle()
                    }
                    
                    if (otpInvalidCount >= 5) {
                        print("OTP INVALID IN 5 TIME")
                        showingOtpInvalid.toggle()
                    }
                }) {
                    Text("Verifikasi OTP")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
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
            
            Text("Kode OTP Salah")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("Kode OTP yang anda masukkan salah silahkan ulangi lagi")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
                    self.appState.moveToWelcomeView = true
            }) {
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
            
            Text("Kode OTP yang anda masukkan telah salah 5 kali, silahkan ulangi lagi minggu depan.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
//                self.rootIsActive = false
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
    
    func getOTP() {
        self.otpVM.otpRequest(
            otpRequest: OtpRequest(
                    destination: self.loginData.noTelepon,
                    type: "hp",
                    trytime: 30
            )
        ) { success in
            
            if success {
                print(self.otpVM.isLoading)
                print(self.otpVM.code)
                self.showingAlert = true
            }
            
            self.showingAlert = true
        }
    }
}

#if DEBUG
struct FirstOTPLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstOTPLoginView().environmentObject(LoginBindingModel())
    }
}
#endif
