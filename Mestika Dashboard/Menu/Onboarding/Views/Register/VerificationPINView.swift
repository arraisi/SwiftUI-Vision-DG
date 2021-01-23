//
//  VerificationPINView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI
import PopupView
import Indicators

struct VerificationPINView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var appState: AppState
    
    @ObservedObject private var pinNoAtmVM = PinNoAtmViewModel()
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
    @State var isLoading = false
    @State var isPINValid = false
    @State var otpInvalidCount = 0
    @State var isResendPinDisabled = true
    @State var isBtnValidationDisabled = false
    @State var tryCount = 0
    
    var disableForm: Bool {
        if (pin.count < 6 || self.isBtnValidationDisabled) {
            return true
        }
        return false
    }
    
    @State var noAtmAndPinIsWrong = true
    
    /* Timer */
    @State private var timeRemainingRsnd = 30
    @State private var timeRemainingBtn = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var noKartuCtrl: String = ""
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                if (self.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
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
                        
                        TextField(NSLocalizedString("Masukkan No Kartu ATM", comment: ""), text: $noKartuCtrl, onEditingChanged: { changed in
                            self.registerData.noAtm = self.noKartuCtrl
                            self.registerData.accNo = self.noKartuCtrl
                        })
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .keyboardType(.numberPad)
                        .disabled((self.registerData.accType == "ATM" || self.registerData.atmOrRekening == "ATM"))
                        .padding(15)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                        .padding(.top, 15)
                        .onReceive(noKartuCtrl.publisher.collect()) {
                            self.noKartuCtrl = String($0.prefix(16))
                        }
                        .onAppear{
                            if (self.registerData.accType == "ATM" || self.registerData.atmOrRekening == "ATM") {
                                self.noKartuCtrl = self.registerData.accNo
                                self.noKartuCtrl = self.registerData.noAtm
                            }
                        }
                        
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
                            .isDetailLink(false)
                        
                        Button(action: {
                            self.tryCount += 1
                            if self.shouldVerificationWithVC {
                                UserDefaults.standard.set("true", forKey: "register_nasabah_video_call")
                                self.nextToFormVideoCall = true
                            } else {
                                UserDefaults.standard.set("false", forKey: "register_nasabah_video_call")
                                validatePINBackEnd()
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
                isResendPinDisabled = false
            } else {
                isResendPinDisabled = true
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
//            self.nextToPilihJenisAtm = true
            self.noAtmAndPinIsWrong = false
            self.showingModal.toggle()
        } else {
            self.noAtmAndPinIsWrong = true
            
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
    
    func validatePINBackEnd() {
        self.isLoading = true
        
        self.pinNoAtmVM.pinValidationNasabahExisting(atmData: atmData, pin: self.pin, cardNo: self.noKartuCtrl)
        { success in
            
            print("success \(success)")
            if success {
                print("PIN VALID")
                self.isLoading = false
                self.noAtmAndPinIsWrong = false
                self.showingModal.toggle()
                
            } else {
                print("PIN INVALID")
                
                self.isLoading = false
                self.noAtmAndPinIsWrong = true
                self.showingModal.toggle()
//                self.isBtnValidationDisabled = true
//                resetField()
            }
            
        }
    }
    
    /*
     Fuction for Create Bottom Floater (Modal)
     */
    func createBottomFloater() -> some View {
        VStack {
            if (noAtmAndPinIsWrong) {
                NoAtmAndPinWrong
            } else {
                NoAtmAndPinApproved
            }
        }
        
    }
    
    var NoAtmAndPinWrong: some View {
        
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
    
    var NoAtmAndPinApproved: some View {
        
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text(NSLocalizedString("ACCOUNT OPENING APPROVED", comment: ""))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical, 20)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(NSLocalizedString("Congratulations, your new account opening has been approved.", comment: ""))
                .font(.custom("Montserrat-SemiBold", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.appState.moveToWelcomeView = true
            }) {
                Text(NSLocalizedString("Continue to Create an ATM", comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.vertical)
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
        VerificationPINView().environmentObject(RegistrasiModel()).environmentObject(AddProductATM()).environmentObject(AppState())
    }
}
