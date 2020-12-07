//
//  EmailOTPVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI

struct FormEmailOTPVerificationRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var pinShare: String = ""
    @State var referenceCode: String = ""
    @State var showPin = true
    @State var isDisabled = false
    @State var messageResponse: String = ""
    
    /* Variable Validation */
    @State var isOtpValid = false
    @State var isResendOtpDisabled = true
    @State var isBtnValidationDisabled = false
    @State var tryCount = 0
    
    @Binding var shouldPopToRootView : Bool
    
    @State private var timeRemaining = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State private var showingAlert: Bool = false
    
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
            
            VStack(alignment: .center) {
                Text("Kami telah mengirimkan Kode Verifikasi ke \(replace(myString: registerData.email, [4, 5, 6, 7], "x"))")
                    .font(.custom("Montserrat-SemiBold", size: 18))
                    .foregroundColor(Color(hex: "#232175"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Silahkan masukan kode OTP dengan REF #\(referenceCode)")
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
                    Text("Tidak Menerima Kode?")
                        .font(.custom("Montserrat-Regular", size: 10))
                    
                    Button(action: {
                        print("-> Resend OTP")
                        
                        self.resetField()
                        self.timeRemaining = 60
                        
                        getOTP()
                    }) {
                        Text("Resend OTP")
                            .font(.custom("Montserrat-SemiBold", size: 10))
                            .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                    }
                    .disabled(isResendOtpDisabled)
                    
                    Button(
                        action: {
                            self.isOtpValid = true
                        },
                        label: {
                            Text("(00:\(String(format: "%02d", timeRemaining)))")
                                .font(.custom("Montserrat-Regular", size: 10))
                        })
                        .disabled(true)
                }
                .padding(.top, 5)
                
                Text("Silahkan cek email Anda untuk melihat kode OTP")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack {
                    NavigationLink(
                        destination: FormPilihJenisTabunganView(shouldPopToRootView: self.$shouldPopToRootView).environmentObject(registerData),
                        isActive: self.$isOtpValid,
                        label: {
                            EmptyView()
                        }).isDetailLink(false)
                    
                    
                    Button(action: {
//                        self.isOtpValid = true
                        self.tryCount += 1
                        validateOTP()
                    }) {
                        if (self.isBtnValidationDisabled) {
                            Text("(00:\(String(format: "%02d", timeRemainingBtn)))")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        } else {
                            Text("Verifikasi OTP")
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
            .padding(.top, 120)
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            trailing: LoadingIndicator(style: .medium, animate: .constant(self.otpVM.isLoading))
                .configure {
                    $0.color = .white
            })
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
            
            if self.timeRemainingBtn > 0 {
                self.timeRemainingBtn -= 1
            }
            
            if self.timeRemainingBtn < 1 {
                isBtnValidationDisabled = false
            } else {
//                isBtnValidationDisabled = true
            }
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text(self.messageResponse),
                dismissButton: .default(Text("Oke"))
            )
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
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
        if chars.count > 2 {
            chars[index[0]] = newChar
            chars[index[1]] = chars[index[0]]
            chars[index[2]] = chars[index[1]]
            chars[index[3]] = chars[index[2]]
        }
        let modifiedString = String(chars)
        return modifiedString
    }
    
    /*
     Fuction for Create Bottom Floater (Modal)
     */
    func createBottomFloater() -> some View {
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
    
    @ObservedObject private var otpVM = OtpViewModel()
    func getOTP() {
        print("EMAIL \(self.registerData.email)")
        self.otpVM.otpRequest(
            otpRequest: OtpRequest(
                    destination: self.registerData.email,
                    type: "email",
                    trytime: 1
            )
        ) { success in
            
            if success {
                print("isLoading \(self.otpVM.isLoading)")
                print("otpRef \(self.otpVM.reference)")
                print("status \(self.otpVM.statusMessage)")
                
                DispatchQueue.main.async {
                    self.timeRemaining = 30
                    self.referenceCode = self.otpVM.reference
                    self.messageResponse = self.otpVM.statusMessage
                }
                
                self.showingAlert = true
            }
            
            if !success {
                if (self.otpVM.statusMessage == "OTP_REQUESTED_FAILED") {
                    print("OTP FAILED")
                    print(self.otpVM.timeCounter)
                    
                    DispatchQueue.main.sync {
                        self.messageResponse = self.otpVM.statusMessage
                        self.pinShare = self.otpVM.code
                        self.referenceCode = self.otpVM.reference
                        self.timeRemaining = 30
                    }
                    self.showingAlert = true
                }
            }
        }
    }
    
    func validateOTP() {
        self.otpVM.otpValidation(
            code: self.pin,
            destination: self.registerData.email,
            reference: referenceCode,
            timeCounter: self.otpVM.timeCounter,
            tryCount: tryCount,
            type: "email")
        { success in
            
            if success {
                print("OTP VALID")
                self.isOtpValid = true
            }
            
            if !success {
                print("OTP INVALID")
                
                if (self.tryCount == 1) {
                    self.timeRemainingBtn = 30
                }
                
                if (self.tryCount == 2) {
                    self.timeRemainingBtn = 60
                }
                
                if (self.tryCount == 3) {
                    self.timeRemainingBtn = 120
                }
                
                if (self.tryCount == 4) {
                    self.timeRemainingBtn = 240
                }
                
                if (self.tryCount == 5) {
                    self.timeRemainingBtn = 480
                }
                
                self.isBtnValidationDisabled = true
                self.showingModal.toggle()
                self.resetField()
            }
            
        }
    }
    
    private func resetField() {
        self.pin = "" /// return to empty pin
    }
}

struct EmailOTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormEmailOTPVerificationRegisterNasabahView(shouldPopToRootView: .constant(false)).environmentObject(RegistrasiModel())
        }
    }
}
