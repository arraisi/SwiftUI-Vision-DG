//
//  EmailOTPVerificationView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI

struct FormEmailOTPVerificationRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @ObservedObject private var otpVM = OtpViewModel()
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var pinShare: String = ""
    @State var referenceCode: String = ""
    @State var showPin = true
    @State var isDisabled = false
    
    /* Variable Validation */
    @State var isOtpValid = false
    @State var isResendOtpDisabled = true
    
    @State private var timeRemaining = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State private var showingAlert: Bool = false
    
    var disableForm: Bool {
        pin.count < 6
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
                        self.timeRemaining = 60
                        
                        getOTP()
                    }) {
                        Text("Resend OTP")
                            .font(.custom("Montserrat-SemiBold", size: 10))
                            .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                    }
                    .disabled(isResendOtpDisabled)
                    
                    Text("(00:\(timeRemaining))")
                        .font(.custom("Montserrat-Regular", size: 12))
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
                        destination: FormPilihJenisTabunganView().environmentObject(registerData),
                        isActive: self.$isOtpValid,
                        label: {
                            EmptyView()
                        })
                    
                    Button(action: {
                        // dummy
                        self.isOtpValid = true
                        // ---
                        
                        print(pin)
                        if (pin == self.pinShare) {
                            self.isOtpValid = true
                        } else {
                            print("Not Valid")
                            showingModal.toggle()
                        }
                    }) {
                        Text("Verifikasi OTP")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
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
            }
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("OTP Code"),
                message: Text(self.pinShare),
                dismissButton: .default(Text("Oke"), action: {
                    pin = self.pinShare
                }))
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
    
    func getOTP() {
        self.otpVM.otpRequest(
            otpRequest: OtpRequest(destination: self.registerData.noTelepon, type: "hp")
        ) { success in
            
            if success {
                print(self.otpVM.isLoading)
                print("PIN : \(self.otpVM.code)")
                
                DispatchQueue.main.sync {
                    self.pinShare = self.otpVM.code
                    self.referenceCode = self.otpVM.reference
                }
                self.showingAlert = true
            }
            
            self.showingAlert = true
        }
    }
}

struct EmailOTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormEmailOTPVerificationRegisterNasabahView().environmentObject(RegistrasiModel())
        }
    }
}
