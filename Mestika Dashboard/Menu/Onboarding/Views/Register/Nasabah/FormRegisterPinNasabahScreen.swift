//
//  FormRegisterPinNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct FormRegisterPinNasabahScreen: View {
    @EnvironmentObject var registerData: RegistrasiModel
    
    /* Variable PIN OTP */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var showPin = true
    @State var isDisabled = false
    
    @State var activeRoute = false
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    var disableForm: Bool {
        pin.count < 6
//        isPINValidated(with: pin)
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        ZStack(alignment: .top) {
            Color(hex: "#232175")
            
            VStack {

                Spacer()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 45 / 100 * UIScreen.main.bounds.height)
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                ScrollView {
                    // Title
                    Text("DATA PEMBUKAAN REKENING")
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
                        .padding(.vertical, 45)
                        .padding(.horizontal, 40)
                    
                    // Content
                    ZStack {
                        
                        // Forms
                        ZStack {
                            
                            VStack{
                                LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                            }
                            .cornerRadius(25.0)
                            .padding(.horizontal, 70)
                            
                            VStack{
                                LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                            }
                            .cornerRadius(25.0)
                            .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 5, y: -2)
                            .padding(.horizontal, 50)
                            .padding(.top, 10)
                            
                        }
                        
                        VStack {
                            Spacer()
                            
                            // Sub title
                            Text("Masukan PIN \nTransaksi Baru Anda")
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            
                            Text("Pin ini digunakan untuk setiap kegiatan transaksi keuangan")
                                .font(.custom("Montserrat-Regular", size: 8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 3)
                                .padding(.bottom, 20)
                            
                            ZStack {
                                pinDots
                                backgroundField
                            }
                            
                            NavigationLink(
                                destination: FormRegisterVerificationPinScreen().environmentObject(registerData),
                                isActive: self.$activeRoute,
                                label: {}
                            )
                            
                            Button(
                                action: {
                                    print(pin)
                                    
                                    if (isPINValidated(with: pin)) {
                                        activeRoute = true
                                    }
                                    
                                    if (!isPINValidated(with: pin)) {
                                        self.showingModal.toggle()
                                    }
                                },
                                label: {
                                    Text("Konfirmasi PIN Transaksi")
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 40)
                            })
                                .frame(height: 50)
                                .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 25)
                                .disabled(disableForm)
                                .onAppear {
                                    self.registerData.pin = pin
                                }
                        }
                        .background(Color(.white))
                        .cornerRadius(25.0)
                        .shadow(color: Color(hex: "#D6DAF0"), radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.top, 25)
                        
                    }
                    .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
                    .padding(.bottom, 25)
                }
                .KeyboardAwarePadding()
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessage()
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
        
        registerData.pin = pin
    }
    
    private func isPINValidated(with pin: String) -> Bool {
        if pin.count < 6 {
            return false
        }
        
        let pattern = #"^(?!(.)\1{3})(?!19|20)(?!012345|123456|234567|345678|456789|567890|098765|987654|876543|765432|654321|543210)\d{6}$"#
        
        let pinPredicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return pinPredicate.evaluate(with: pin)
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
    

    // MARK:- CREATE POPUP MESSAGE
    func popupMessage() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("PIN terdiri dari 6 karakter, tidak boleh berurutan dari 6 angka yang sama")
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
    
}

struct FormRegisterPinNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormRegisterPinNasabahScreen().environmentObject(RegistrasiModel())
    }
}
