//
//  VerificationPINView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI
import PopupView

struct VerificationPINView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var appState: AppState
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    @State var nextToFormVideoCall = false
    @State var nextToPilihJenisAtm = false
    
    @State var shouldVerificationWithVC:Bool = false
    
    
    /* HUD Variable */
    @State private var dim = true
    
    /* Variable PIN  */
    @State var pin: String = ""
    @State private var secured: Bool = true
    let dummyPin = "123456"
    
    /* Variable Validation */
    @State var isOtpValid = false
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    @State var isBtnValidationDisabled = false
    @State var tryCount = 0
    var disableForm: Bool {
        if (pin.count < 6 || self.isBtnValidationDisabled) {
            return true
        }
        return false
    }
    
    /* Timer */
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                VStack {
                    
                    Text(NSLocalizedString("VERIFIKASI PIN \nKARTU ATM ANDA", comment: ""))
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .center) {
                        Text(NSLocalizedString("Silahkan Masukkan PIN \nkartu ATM Anda", comment: ""))
                            .font(.custom("Montserrat-SemiBold", size: 18))
                            .foregroundColor(Color(hex: "#232175"))
                            .multilineTextAlignment(.center)
                            .padding(.top, 30)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if (secured) {
                            
                            ZStack {
                                HStack (spacing: 0) {
                                    SecureField(NSLocalizedString("Masukkan PIN ATM", comment: ""), text: $pin)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .padding()
                                        .frame(width: 200, height: 50)
                                        .foregroundColor(Color(hex: "#232175"))
                                        .disabled(shouldVerificationWithVC)
                                        .keyboardType(.numberPad)
                                        .onReceive(pin.publisher.collect()) {
                                            if String($0).hasPrefix("0") {
                                                self.pin = String(String($0).substring(with: 1..<String($0).count).prefix(6))
                                            } else {
                                                self.pin = String($0.prefix(6))
                                            }
                                        }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        self.secured.toggle()
                                    }) {
                                        Image(systemName: "eye.slash")
                                            .font(.custom("Montserrat-Light", size: 14))
                                            .frame(width: 80, height: 50)
                                            .cornerRadius(10)
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    }
                                }
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            
                        } else {
                            
                            ZStack {
                                HStack (spacing: 0) {
                                    TextField(NSLocalizedString("Masukkan PIN ATM", comment: ""), text: $pin)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .padding()
                                        .frame(width: 200, height: 50)
                                        .foregroundColor(Color(hex: "#232175"))
                                        .disabled(shouldVerificationWithVC)
                                        .keyboardType(.numberPad)
                                        .onReceive(pin.publisher.collect()) {
                                            if String($0).hasPrefix("0") {
                                                self.pin = String(String($0).substring(with: 1..<String($0).count).prefix(6))
                                            } else {
                                                self.pin = String($0.prefix(6))
                                            }
                                        }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        self.secured.toggle()
                                    }) {
                                        Image(systemName: "eye.fill")
                                            .font(.custom("Montserrat-Light", size: 14))
                                            .frame(width: 80, height: 50)
                                            .cornerRadius(10)
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    }
                                }
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            
                        }
                        
                        HStack {
                            Button(action: {
                                self.shouldVerificationWithVC.toggle()
                                if self.shouldVerificationWithVC {
                                    self.pin = ""
                                    self.isBtnValidationDisabled = false
                                }
                            }) {
                                HStack(alignment: .top) {
                                    Image(systemName: shouldVerificationWithVC ? "checkmark.square": "square")
                                    VStack(alignment: .leading) {
                                        Text(NSLocalizedString("Rekening Anda tidak memiliki kartu ATM?", comment: ""))
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .foregroundColor(Color(hex: "#707070"))
                                        Text(NSLocalizedString("Verifikasi Lewat Video Call", comment: ""))
                                            .font(.custom("Montserrat-Bold", size: 12))
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 5)
                        
                        NavigationLink(
                            destination: SuccessRegisterView().environmentObject(registerData).environmentObject(atmData),
                            isActive: self.$nextToFormVideoCall,
                            label: {
                                EmptyView()
                            })
                        
                        NavigationLink(
                            destination: FormPilihJenisATMView().environmentObject(atmData).environmentObject(registerData),
                            isActive: self.$nextToPilihJenisAtm,
                            label: {
                                EmptyView()
                            })
                        
                        Button(action: {
                            self.tryCount += 1
                            if self.shouldVerificationWithVC {
                                UserDefaults.standard.set("true", forKey: "register_nasabah_video_call")
                                self.nextToFormVideoCall = true
                            } else {
                                UserDefaults.standard.set("false", forKey: "register_nasabah_video_call")
                                validatePIN()
                            }
                        }) {
                            
                            if (self.isBtnValidationDisabled) {
                                Text("(\(self.timeRemainingBtn.formatted(allowedUnits: [.minute, .second])!))")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                            } else {
                                Text("Berikutnya")
                                    .foregroundColor(.white)
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .background(Color(hex: disableButton() ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .disabled(disableButton())
                    }
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 30)
                }
                Spacer()
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
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
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
    }
    
    func disableButton() -> Bool {
        if self.shouldVerificationWithVC || !disableForm {
            return false
        } else {
            return true
        }
    }
    
    func validatePIN() {
        
        if pin == dummyPin {
            self.nextToPilihJenisAtm = true
        } else {
            
            if (self.tryCount == 1) {
                self.timeRemainingBtn = 30
                self.showingModal.toggle()
            }
            
            if (self.tryCount == 2) {
                self.timeRemainingBtn = 60
                self.showingModal.toggle()
            }
            
            if (self.tryCount == 3) {
                self.timeRemainingBtn = 120
                self.showingModal.toggle()
            }
            
            if (self.tryCount == 4) {
                self.timeRemainingBtn = 240
                self.showingModal.toggle()
            }
            
            if (self.tryCount >= 5) {
                self.timeRemainingBtn = 480
                self.showingModal.toggle()
            }
            
            self.isBtnValidationDisabled = true
        }
    }
    
    /*
     Fuction for Create Bottom Floater (Modal)
     */
    func createBottomFloater() -> some View {
        VStack(alignment: .leading) {
            Image("Logo M")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text(NSLocalizedString("PIN ATM yang anda Masukkan Salah!", comment: ""))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#DF1C1C"))
                .padding(.bottom, 30)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("PIN ATM yang Anda masukkan tidak sesuai dengan PIN ATM rekening terdaftar.", comment: ""))
                .font(.caption)
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Silahkan coba kembali..", comment: ""))
                .font(.caption)
                .bold()
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {self.showingModal = false}) {
                Text(NSLocalizedString("Kembali", comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct VerificationPINView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationPINView().environmentObject(RegistrasiModel())
    }
}
