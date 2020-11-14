//
//  RegisterNasabahPhoneOTPScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct RegisterNasabahPhoneOTPScreen: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var showPin = true
    @State var isDisabled = false
    
    /* Variable Validation */
    @State var isOtpValid = false
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    
    /* Data Binding */
    @Binding var rootIsActive : Bool
    @ObservedObject private var otpVM = OtpViewModel()
    
    /* Timer */
    @State private var timeRemaining = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let timers = Timer.publish(every: 1000, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State var showingOtpIncorect = false
    @State var showingOtpInvalid = false
    @State private var showingAlert: Bool = false
    
    /* Disabled Form */
    var disableForm: Bool {
        pin.count < 6
    }
    
    func getOTP() {
        self.otpVM.otpRequest(
            otpRequest: OtpRequest(destination: self.registerData.noTelepon, type: "hp")
        ) { success in
            
            if success {
                print(self.otpVM.isLoading)
                print(self.otpVM.code)
                self.showingAlert = true
            }
            
            self.showingAlert = true
        }
    }
    
    // MARK: -MAIN CONTENT
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack(alignment: .center) {
                Text("Kami telah mengirimkan OTP ke No. \(replace(myString: registerData.noTelepon, [6, 7, 8, 9], "x"))")
                    .font(.title3)
                    .foregroundColor(Color(hex: "#232175"))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                Text("Silahkan masukan kode OTP dengan REF #1234")
                    .font(.caption)
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
                    Text("Tidak Menerima Kode?")
                        .font(.caption2)
                    
                    Button(action: {
                        print("-> Resend OTP")
                        getOTP()
                        
                        self.timeRemaining = 60
                    }) {
                        Text("Resend OTP")
                            .font(.caption2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                    }
                    //                    .disabled(isResendOtpDisabled)
                    
                    Text("(00:\(timeRemaining))")
                        .font(.caption2)
                }
                .padding(.top, 5)
                
                Text("Pastikan Anda terkoneksi ke Internet dan pulsa mencukupi untuk menerima OTP")
                    .font(.caption)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack {
                    NavigationLink(destination: ChooseTypeSavingForNasabahScreen().environmentObject(registerData), isActive: self.$isOtpValid) {
                        Text("")
                    }
                    
                    Button(action: {
                        print(pin)
                        
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
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 30)
            .padding(.top, 120)
            
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
            
            if self.timeRemaining < 1 {
                isResendOtpDisabled = false
            }
        }
        .alert(isPresented: $showingAlert) {
            if (self.otpVM.code.isEmpty) {
                return Alert(title: Text("Message Error"), message: Text("No OTP Code"), dismissButton: .default(Text("Oke")))
            } else {
                return Alert(title: Text("OTP Code"), message: Text(self.otpVM.code), dismissButton: .default(Text("Oke")))
            }
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
                    .background(Color.gray.opacity(0.1))
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
                self.rootIsActive = true
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
}

struct RegisterNasabahPhoneOTPScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterNasabahPhoneOTPScreen(rootIsActive: .constant(false)).environmentObject(RegistrasiModel())
    }
}
