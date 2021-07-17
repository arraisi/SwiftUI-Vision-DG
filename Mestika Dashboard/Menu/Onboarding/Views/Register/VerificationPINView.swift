//
//  VerificationPINView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI
import PopupView
import Indicators
import Combine

struct VerificationPINView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var appState: AppState
    
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @ObservedObject private var pinNoAtmVM = PinNoAtmViewModel()
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    @State var showingModalBlockAtm = false
    @State var nextToFormVideoCall = false
    @State var nextToPilihJenisAtm = false
    
    @State var shouldVerificationWithVC:Bool = false
    
    @State var tryCount: Int = 0
    
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
                    
                    Text("VERIFY YOUR PIN \nCARD OF ATM".localized(language))
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .center) {
                        Text("Please enter your PIN \nATM card".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 18))
                            .foregroundColor(Color(hex: "#232175"))
                            .multilineTextAlignment(.center)
                            .padding(.top, 30)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        TextField("Insert ATM Card Number".localized(language), text: $noKartuCtrl, onEditingChanged: { changed in
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
                        .onReceive(Just(noKartuCtrl)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.noKartuCtrl = filtered
                            }
                        }
                        .onReceive(noKartuCtrl.publisher.collect()) {
                            self.noKartuCtrl = String($0.prefix(16))
                        }
                        .onAppear{
                            if (self.registerData.accType == "ATM" || self.registerData.atmOrRekening == "ATM") {
                                self.noKartuCtrl = self.registerData.accNo
                            }
                        }
                        
                        if (secured) {
                            
                            ZStack {
                                HStack (spacing: 0) {
                                    SecureField("Enter the ATM PIN".localized(language), text: $pin)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .padding()
                                        .foregroundColor(Color(hex: "#232175"))
                                        .disabled(shouldVerificationWithVC)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(pin)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.pin = filtered
                                            }
                                        }
                                        .onReceive(pin.publisher.collect()) {
                                            self.pin = String($0.prefix(6))
                                        }
                                    
                                    Spacer()
                                }
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            
                        } else {
                            
                            ZStack {
                                HStack (spacing: 0) {
                                    TextField("Enter the ATM PIN".localized(language), text: $pin)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .padding()
                                        .foregroundColor(Color(hex: "#232175"))
                                        .disabled(shouldVerificationWithVC)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(pin)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.pin = filtered
                                            }
                                        }
                                        .onReceive(pin.publisher.collect()) {
                                            self.pin = String($0.prefix(6))
                                        }
                                    
                                    Spacer()
                                }
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            
                        }
                        
                        HStack {
                            Button(action: {
                                UIApplication.shared.endEditing()
                                self.shouldVerificationWithVC.toggle()
                                if self.shouldVerificationWithVC {
                                    self.pin = ""
                                    self.isBtnValidationDisabled = false
                                }
                            }) {
                                HStack(alignment: .top) {
                                    Image(systemName: shouldVerificationWithVC ? "checkmark.square": "square")
                                    VStack(alignment: .leading) {
                                        Text("Your account doesn't have an ATM card?".localized(language))
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .foregroundColor(Color(hex: "#707070"))
                                        Text("Verification Via Video Call".localized(language))
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
                                self.nextToFormVideoCall = true
                            } else {
                                UIApplication.shared.endEditing()
                                validatePINBackEnd()
                            }
                        }) {
                            
                            Text("Next".localized(language))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
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
            
            if (self.showingModal || self.showingModalBlockAtm) {
                ModalOverlay(tapAction: { withAnimation {
                    //                                self.showingModal = false
                    //                    self.showingModalBlockAtm = false
                    
                } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            user.forEach { (data) in
                atmData.atmName = data.namaLengkapFromNik ?? ""
                registerData.namaLengkapFromNik = data.namaLengkapFromNik ?? ""
                registerData.provinsiFromNik = data.provinsiFromNik ?? ""
                registerData.alamatKtpFromNik = data.alamatKtpFromNik ?? ""
                registerData.kecamatanFromNik = data.kecamatanFromNik ?? ""
                registerData.kelurahanFromNik = data.kelurahanFromNik ?? ""
                registerData.kodePosFromNik = data.kodePosFromNik ?? ""
                registerData.kabupatenKotaFromNik = data.kabupatenKotaFromNik ?? ""
                registerData.rtFromNik = data.rtFromNik ?? ""
                registerData.rwFromNik = data.rwFromNik ?? ""
                registerData.nik = data.nik ?? ""
                
                registerData.alamatSuratMenyurat = data.addressInput!
                registerData.kecamatanSuratMenyurat = data.addressKecamatanInput ?? ""
                registerData.kelurahanSuratMenyurat = data.addressKelurahanInput ?? ""
                registerData.kodePosSuratMenyurat = data.addressPostalCodeInput ?? ""
                registerData.kotaSuratMenyurat = data.addressKotaInput ?? ""
                registerData.provinsiSuratMenyurat = data.addressProvinsiInput ?? ""
                registerData.rtSuratMenyurat = data.addressRtInput ?? ""
                registerData.rwSuratMenyurat = data.addressRwInput ?? ""
                
                registerData.kecamatan = data.kecamatan ?? ""
                registerData.kelurahan = data.kelurahan ?? ""
                registerData.alamatPerusahaan = data.alamatPerusahaan ?? ""
                registerData.kodePos = ""
//                registerData.rtrw = data.rtrw ?? ""
//                registerData.rtPerusahaan = data.rtPerusahaan!
//                registerData.rwPerusahaan = data.rwPerusahaan!
                registerData.kotaPerusahaan = data.kotaPerusahaan ?? ""
                registerData.provinsiPerusahaan = data.provinsiPerusahaan ?? ""
                
                registerData.isAddressEqualToDukcapil = data.isAddressEqualToDukcapil
            }
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            createBottomFloater()
        }
        .popup(isPresented: $showingModalBlockAtm, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            NoAtmAndBlock
        }
    }
    
    func disableButton() -> Bool {
        if !disableForm {
            return false
        } else if self.shouldVerificationWithVC {
            return false
        } else {
            return true
        }
    }
    
    func validatePINBackEnd() {
        self.isLoading = true
        
        if registerData.isAddressEqualToDukcapil {
            atmData.atmAddressInput = registerData.alamatKtpFromNik
            atmData.atmAddressPostalCodeInput = registerData.kodePosFromNik
            atmData.atmAddressKecamatanInput = registerData.kecamatanFromNik
            atmData.atmAddressKelurahanInput = registerData.kelurahanFromNik
            atmData.atmAddressKotaInput = registerData.kabupatenKotaFromNik
            atmData.atmAddressPropinsiInput = registerData.provinsiFromNik
//            atmData.atmAddressRtInput = registerData.rtFromNik
//            atmData.atmAddressRwInput = registerData.rwFromNik
//            atmData.atmAddressrtRwInput = "\(registerData.rtFromNik)/\(registerData.rwFromNik)"
            atmData.addressEqualToDukcapil = true
        } else {
            atmData.atmAddressInput = registerData.alamatSuratMenyurat
            atmData.atmAddressPostalCodeInput = registerData.kodePosSuratMenyurat
            atmData.atmAddressKecamatanInput = registerData.kecamatanSuratMenyurat
            atmData.atmAddressKelurahanInput = registerData.kelurahanSuratMenyurat
//            atmData.atmAddressrtRwInput = "\(registerData.rtSuratMenyurat)/\(registerData.rwSuratMenyurat)"
//            atmData.atmAddressRtInput = registerData.rtSuratMenyurat
//            atmData.atmAddressRwInput = registerData.rwSuratMenyurat
            atmData.atmAddressKotaInput = registerData.kotaSuratMenyurat
            atmData.atmAddressPropinsiInput = registerData.provinsiSuratMenyurat
            atmData.addressEqualToDukcapil = false
        }
        
        self.pinNoAtmVM.pinValidationNasabahExisting(atmData: atmData, pin: self.pin, cardNo: self.noKartuCtrl)
        { success in
            
            print("success \(success)")
            if success {
                print("PIN VALID")
                self.isLoading = false
                self.noAtmAndPinIsWrong = false
                self.showingModal = true
                self.isBtnValidationDisabled = true
                
            } else {
                print("PIN INVALID")
                
                if (self.tryCount >= 3) {
                    self.showingModalBlockAtm = true
                } else {
                    self.isLoading = false
                    self.noAtmAndPinIsWrong = true
                    self.showingModal = true
                }
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
    
    var NoAtmAndBlock: some View {
        
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("Your ATM Card Is Blocked".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#DF1C1C"))
                .padding(.bottom, 30)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.nextToFormVideoCall = true
            }) {
                Text("Video Call Verification".localized(language))
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
    
    var NoAtmAndPinWrong: some View {
        
        VStack(alignment: .leading) {
            Image("Logo M")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("The ATM PIN you entered is wrong!".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#DF1C1C"))
                .padding(.bottom, 30)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("The ATM PIN you entered does not match the registered account ATM PIN.".localized(language))
                .font(.caption)
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Please try again ..".localized(language))
                .font(.caption)
                .bold()
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {self.showingModal = false}) {
                Text("Back".localized(language))
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
            
            Text("ACCOUNT OPENING APPROVED".localized(language))
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical, 20)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Congratulations, your new account opening has been approved.".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 14))
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.appState.moveToWelcomeView = true
            }) {
                Text("Back to Main Page".localized(language))
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
